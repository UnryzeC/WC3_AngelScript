//#include "Scripts\\Blizzard.as"

bool SameHeroBoolean = false;
bool TestCommandEnabled = false;
dialog ModeSelectionDialog = DialogCreate( );
dialog KillSelectionDialog = DialogCreate( );
group GroupEnum = CreateGroup( );
group GroupFilter = CreateGroup( );
hashtable GameHT = InitHashtable( );
hashtable DataHT = InitHashtable( );
hashtable SoundHT = InitHashtable( );
int KillLimit = 0;
int TotalPlayers = 0;
int TotalHeroes = 0;
int HeroesSelected = 0;
float MapMinX = -6100.f + GetCameraMargin( CAMERA_MARGIN_LEFT );
float MapMaxX = 6100.f - GetCameraMargin( CAMERA_MARGIN_RIGHT );
float MapMinY = -4400.f + GetCameraMargin( CAMERA_MARGIN_BOTTOM );
float MapMaxY = 3350.f - GetCameraMargin( CAMERA_MARGIN_TOP );
timer CreepUpgradeTimer1 = CreateTimer( );
timer CreepSpawnerTimer1 = CreateTimer( );
timer KillSelectionTimer = CreateTimer( );
rect worldBounds;
multiboard MainMultiboard;
timer TMR_ResetCD = nil;
timerdialog ModeSelectionTD;
unit SelectionUnit;
effect Ef_Selection;
effect Ef_SelectionBack;
array<button> SameHeroModeButtonArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<bool> TeamOneSelected( PLAYER_NEUTRAL_AGGRESSIVE );
array<bool> TeamTwoSelected( PLAYER_NEUTRAL_AGGRESSIVE );
array<bool> HealthDisplayBooleanArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<bool> ESCLocationSaveBooleanArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<effect> EF_SelectionHeroModelArray;
array<effect> EF_SelectionIconArray;
bool B_IsCreepSpawn = true;
int I_WinningTeam = -1;
array<int> TeamPlayers( 2 );
array<int> TeamKills( 2 );
array<int> TeamDeaths( 2 );
array<int> DyingUnitIntegerArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<int> KillingUnitIntegerArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<int> BossesKilledIntegerArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<int> MBArr1( PLAYER_NEUTRAL_AGGRESSIVE );
array<rect> CircleRectArr( 5 );
array<string> PlayerColorStringArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<string> PlayerColoredNameArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<string> PlayerNameArray( PLAYER_NEUTRAL_AGGRESSIVE );
trigger TR_SelectionMode;
trigger TR_HeroSelection;
array<unit> U_SelectionSelArr( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> U_SelectionDumArr( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> HeroUnitArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> U_SelectionHeroDummyArr( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> KawarimiTriggerUnitArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> MUnitArray( PLAYER_NEUTRAL_AGGRESSIVE );

void TriggerRegisterAnyUnitEventRW( trigger t, playerunitevent whichEvent )
{
	for ( int i = 0; i <= PLAYER_NEUTRAL_PASSIVE; i++ )
	{
		TriggerRegisterPlayerUnitEvent( t, Player( i ), whichEvent, nil );
	}
}

void TriggerRegisterAnyPlayerEventRW( trigger t, playerevent whichEvent )
{
	for ( int i = 0; i <= PLAYER_NEUTRAL_PASSIVE; i++ )
	{
		TriggerRegisterPlayerEvent( t, Player( i ), whichEvent );
	}
}

void TriggerRegisterPlayerChatEventRW( trigger t, string text, bool caseSensitive )
{
	for ( int i = 0; i <= PLAYER_NEUTRAL_PASSIVE; i++ )
	{
		TriggerRegisterPlayerChatEvent( t, Player( i ), text, caseSensitive );
	}
}

bool IsAxisReal( float targX, float targY )
{
	return targX >= MapMinX && targX <= MapMaxX && targY >= MapMinY && targY <= MapMaxY;
}

bool RectContainsAxis( rect r, float x, float y )
{
	return x >= GetRectMinX( r ) && x <= GetRectMaxX( r ) && y >= GetRectMinY( r ) && y <= GetRectMaxY( r );
}

float GetUnitAngle( unit source, unit target )
{
	return MathAngleBetweenPoints( GetUnitX( source ), GetUnitY( source ), GetUnitX( target ), GetUnitY( target ) );
}

float GetUnitDistance( unit source, unit target )
{
	return MathDistanceBetweenPoints( GetUnitX( source ), GetUnitY( source ), GetUnitX( target ), GetUnitY( target ) );
}

float ACF_GetUnitStatePercent( unit whichUnit, unitstate whichState, unitstate whichMaxState )
{
	float value = GetUnitState( whichUnit, whichState );
	float maxValue = GetUnitState( whichUnit, whichMaxState );
	if ( whichUnit == nil || maxValue == 0 )
	{
		return .0f;
	}
	return value / maxValue * 100.0f;
}

int CountUnitInGroupOfPlayer( player p, int id )
{
	int count = 0;
	group g = GroupFilter;

	GroupClear( GroupFilter );
	GroupEnumUnitsOfPlayer( GroupFilter, p, nil );

	for ( int i = 0; i < GroupGetCount( GroupFilter ); i++ )
	{
		unit u = GroupGetUnitByIndex( GroupFilter, i );

		if ( IsUnitAlive( u ) && GetUnitTypeId( u ) == id )
		{
			count++;
		}
	}

	GroupClear( GroupFilter );

	return count;
}

void GroupEnumUnitsInLine( group g, float x, float y, float angle, float dist, float aoe )
{
	GroupClear( g );
	GroupClear( GroupFilter );
	for ( float moved = .0f; moved < dist; moved += aoe )
	{
		GroupEnumUnitsInRange( GroupFilter, x, y, aoe, nil );

		for ( unit u = GroupForEachUnit( GroupFilter ); u != nil; u = GroupForEachUnit( GroupFilter ) )
		{
			if ( !IsUnitInGroup( u, g ) )
			{
				GroupAddUnit( g, u );
			}
		}

		x = MathPointProjectionX( x, angle, aoe );
		y = MathPointProjectionY( y, angle, aoe );
	}
}

bool IsUnitCCed( unit u )
{
	return GetUnitAbilityLevel( u, 'BPSE' ) > 0 || GetUnitAbilityLevel( u, 'B005' ) > 0;
}

void ACF_AddBuffTimed( unit u, uint bid, float time, bool isAdd = true )
{
	if ( IsUnitDead( u ) ) { return; }

	buff buf = GetUnitBuff( u, bid );
	float prevTime = .0f;

	if ( buf == nil )
	{
		buf = CreateBuff( bid );
		UnitAddBuff( u, buf );
	}
	else
	{
		prevTime = GetBuffRemainingDuration( buf );
	}

	SetBuffRemainingDuration( buf, isAdd ? prevTime + time : time );
}

void ACF_StunUnit( unit u, float time )
{
	ACF_AddBuffTimed( u, 'BPSE', time );
}

void ACF_DisableUnitTP( unit u, float time )
{
	ACF_AddBuffTimed( u, 'B005', time );
}

void ACF_PingMinimap( player p, float x, float y, bool extraEffects = false )
{
	int pid = GetPlayerId( p );

	switch( pid )
	{
		case 0: PingMinimapEx( x, y, 5, 100, 0, 0, extraEffects ); break;
		case 1: PingMinimapEx( x, y, 5, 0, 0, 100, extraEffects ); break;
		case 2: PingMinimapEx( x, y, 5, 0, 100, 100, extraEffects ); break;
		case 3: PingMinimapEx( x, y, 5, 43, 14, 51, extraEffects ); break;
		case 4: PingMinimapEx( x, y, 5, 100, 100, 0, extraEffects ); break;
		case 5: PingMinimapEx( x, y, 5, 83, 37, 10, extraEffects ); break;
		case 6: PingMinimapEx( x, y, 5, 0, 100, 0, extraEffects ); break;
		case 7: PingMinimapEx( x, y, 5, 100, 50, 50, extraEffects ); break;
	}
}

void SetUnitScaleAndTime( unit u, float length, float time )
{
	SetUnitScale( u, length, length, length );
	SetUnitTimeScale( u, time );
}

int ACF_GetItemSlotById( unit whichUnit, int itemId )
{
	for ( int i = 0; i < 6; i++ )
	{
		item itm = UnitItemInSlot( whichUnit, i );
		if ( GetItemTypeId( itm ) == itemId ) { return i; }
	}

	return -1;
}

item ACF_GetItemById( unit whichUnit, int itemId )
{
	int id = ACF_GetItemSlotById( whichUnit, itemId );

	return id != -1 ? UnitItemInSlot( whichUnit, id ) : nil;
}

int ACF_CountItems( unit u, int itemId )
{
	if ( u == nil || itemId == 0 ) { return 0; }

	int count = 0;

	for ( int i = 0; i < 6; i++ )
	{
		item itm = UnitItemInSlot( u, i );
		if ( GetItemTypeId( itm ) == itemId ) { count++; }
	}

	return count;
}

bool ACF_UnitHasItemById( unit u, int iid )
{
	return ACF_CountItems( u, iid ) > 0;
}

bool ACF_UnitHasEmptySlot( unit u )
{
	for ( int i = 0; i < 6; i++ )
	{
		if ( UnitItemInSlot( u, i ) == nil )
		{
			return true;
		}
	}

	return false;
}

void ACF_SelectUnit( unit u, player p = nil )
{
	if ( p == nil ) { p = GetOwningPlayer( u ); }

	if ( GetLocalPlayer( ) == p )
	{
		ClearSelection( );
		SelectUnit( u, true );
	}
}

void ACF_PanCameraToTimed( player p, float x, float y, float time )
{
	if ( GetLocalPlayer( ) == p )
	{
		PanCameraToTimed( x, y, time );
	}
}

bool ACF_HasPersonalItem( unit u )
{
	return ACF_UnitHasItemById( u, LoadInteger( DataHT, GetUnitTypeId( u ), 'pitm' ) );
}

void GameCreateVariables( )
{
	for ( int i = 0; i < PLAYER_NEUTRAL_AGGRESSIVE; i++ )
	{
		player p = Player( i ); if ( GetPlayerSlotState( p ) != PLAYER_SLOT_STATE_PLAYING || GetPlayerController( p ) == MAP_CONTROL_COMPUTER ) { continue; }
		int hid = GetHandleId( p );

		SaveReal( DataHT, hid, '+tpX', .0f );
		SaveReal( DataHT, hid, '+tpY', -500.f );
		SaveReal( DataHT, hid, 'camH', 2000.f );
		SaveBoolean( DataHT, hid, 'ntfc', true );
	}
}

void CameraSetHeight( )
{
	int hid = GetHandleId( GetLocalPlayer( ) );

	SetCameraField( CAMERA_FIELD_TARGET_DISTANCE, LoadReal( DataHT, hid, 'camH' ), 0.f );

	if ( !LoadBoolean( DataHT, hid, 'HERO' ) )
	{
		PanCameraToTimed( -1800.f, 5800.f, .0f );
		SetCameraField( CAMERA_FIELD_ANGLE_OF_ATTACK, 270., 0.f );
	}
}

void GameCameraSystemInit( )
{
	TimerStart( CreateTimer( ), .01f, true, @CameraSetHeight );
}

bool ACF_DamageTarget( unit u, unit target, float dmg )
{
	if ( ACF_HasPersonalItem( u ) )
	{
		dmg *= 1.15f;
	}

	return UnitDamageTarget( u, target, dmg, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS );
}

void DialogShow( dialog dg, bool isShow )
{
	for ( int i = 0; i < PLAYER_NEUTRAL_AGGRESSIVE; i++ )
	{
		DialogDisplay( Player( i ), dg, isShow );
	}
}

texttag TextTagCreate( string word, float x, float y, float z, float size, int red, int green, int blue, int alpha )
{
	texttag txtTag = CreateTextTag( );
	SetTextTagText( txtTag, word, size * 0.023f / 10.f );
	SetTextTagPos( txtTag, x, y, z );
	SetTextTagColor( txtTag, red, green, blue, alpha );
	return txtTag;
}

sound ACF_CreateSound( string filePath )
{
	return CreateSound( filePath, false, false, false, 12700, 12700, "DefaultEAXON" );
}

void ACF_PlaySoundWithVolume( sound soundHandle, float volumePercent, float startingOffset )
{
	if ( soundHandle == nil )
	{
		return;
	}

	int result = MathIntegerClamp( R2I( volumePercent * I2R( 127 ) * .01f ), 0, 127 );

	SetSoundVolume( soundHandle, result );
	StartSound( soundHandle );
	SetSoundPlayPosition( soundHandle, R2I( startingOffset * 1000 ) );
}

void PlayHeroSound( unit u, uint childKey, float volume, float startingOffset )
{
	ACF_PlaySoundWithVolume( LoadSoundHandle( SoundHT, GetHandleId( u ), childKey ), volume, startingOffset );
}

void StopSoundEx( sound snd, bool killWhenDone, bool fadeOut )
{
	if ( !GetSoundIsPlaying( snd ) ) { return; }
	StopSound( snd, killWhenDone, fadeOut );
}

void StopHeroSound( unit u, uint childKey )
{
	StopSoundEx( LoadSoundHandle( SoundHT, GetHandleId( u ), childKey ), false, false );
}

void SetUnitXY( unit u, float toX, float toY, bool pathing = false )
{
	if ( pathing && IsTerrainPathable( toX, toY, PATHING_TYPE_WALKABILITY ) )
	{
		return;
	}

	if ( GetUnitMoveSpeed( u ) > 0 ) // && IsAxisReal( toX, toY ) -> max/min x/y of map
	{
		SetUnitX( u, toX );
		SetUnitY( u, toY );
	}
	else
	{
		SetUnitPosition( u, toX, toY );
	}
}

void HandleListCleanEffects( handlelist hl, bool destroyEffects, bool isDestroy )
{
	if ( hl == nil ) { return; }

	if ( destroyEffects )
	{
		for ( int i = 0; i < HandleListGetEffectCount( hl ); i++ )
		{
			effect ef = HandleListGetEffectByIndex( hl, i );
			DestroyEffect( ef );
		}
	}

	HandleListClear( hl );
	if ( !isDestroy ) { return; }
	HandleListDestroy( hl );
}

void MapStartData( )
{
	PanCameraToTimed( -1800.f, 5900.f, .0f );
	PlayerColorStringArray[0] = "|c00FF0000";
	PlayerColorStringArray[1] = "|c000000FF";
	PlayerColorStringArray[2] = "|c0021E7B6";
	PlayerColorStringArray[3] = "|c005E0093";
	PlayerColorStringArray[4] = "|c00FFFF00";
	PlayerColorStringArray[5] = "|c00FF8000";
	PlayerColorStringArray[6] = "|c0000B400";
	PlayerColorStringArray[7] = "|c00FF64FF";
	PlayerColorStringArray[10] = "|c00FF0000";
	PlayerColorStringArray[11] = "|c000000FF";
}

void AILoop( )
{
	if ( true )
	{
		timer tmr = GetExpiredTimer( );
		int hid = GetHandleId( tmr );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		int tick = LoadInteger( GameHT, hid, 'tick' ) + 1;
		handlelist list = LoadHandleList( GameHT, hid, 'list' );
		player p = GetOwningPlayer( source );
		int team = GetPlayerTeam( p );
		unit boss = LoadUnitHandle( DataHT, 'BOSS', 'unit' );
		unit utarg = nil;

		SaveInteger( GameHT, hid, 'tick', tick );

		float x = GetUnitX( source );
		float y = GetUnitY( source );

		HandleListClear( list );
		HandleListEnumUnitsInRange( list, x, y, 600.f, nil );

		for( int i = 0; i < HandleListGetUnitCount( list ); i++ )
		{
			unit u = HandleListGetUnitByIndex( list, i );

			if ( IsUnitAlive( u ) && IsPlayerEnemy( GetOwningPlayer( u ), p ) )
			{
				utarg = u;

				if ( IsUnitType( u, UNIT_TYPE_HERO ) )
				{
					break;
				}
			}
		}

		if ( utarg == nil )
		{
			if ( source != boss )
			{
				HandleListClear( list );
				HandleListEnumItemsInRange( list, x, y, 1600.f, nil );

				for( int i = 0; i < HandleListGetItemCount( list ); i++ )
				{
					if ( !ACF_UnitHasEmptySlot( source ) ) { break; }
					item itm = HandleListGetItemByIndex( list, i );

					if ( IsItemVisible( itm ) && GetItemLife( itm ) >= .0f && GetItemType( itm ) == ITEM_TYPE_POWERUP )
					{
						IssueTargetOrder( source, "smart", itm );
						break;
					}
				}

				HandleListClear( list );
			}
		}
		else
		{
			float targX = GetUnitX( utarg );
			float targY = GetUnitY( utarg );

			IssueTargetOrder( source, "attack", utarg );
			IssueTargetOrder( source, "purge", utarg );
			IssueTargetOrder( source, "drain", utarg );
			IssueTargetOrder( source, "curse", utarg );
			IssuePointOrder( source, "shockwave", targX, targY );
			IssuePointOrder( source, "blizzard", targX, targY );
			IssuePointOrder( source, "inferno", targX, targY );
			IssuePointOrder( source, "carrionswarm", targX, targY );
			IssueImmediateOrder( source, "stomp" );
			IssueImmediateOrder( source, "roar" );

			if ( ( !IsUnitType( utarg, UNIT_TYPE_HERO ) && GetUnitCurrentLife( utarg ) >= 500.f ) || IsUnitType( utarg, UNIT_TYPE_HERO ) )
			{
				IssueImmediateOrder( source, "thunderclap" );
				IssueTargetOrder( source, "cripple", utarg );
				IssueTargetOrder( source, "hex", utarg );
				IssueTargetOrder( source, "banish", utarg );
				IssuePointOrder( source, "breathoffire", targX, targY );
				IssuePointOrder( source, "earthquake", targX, targY );
			}

			if ( source != boss )
			{
				if ( ACF_GetUnitStatePercent( source, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE ) <= 20.f )
				{
					IssuePointOrder( source, "move", team == 0 ? -4288.f : 4288.f, -576.f );
				}
				else
				{
					if ( tick >= 10 )
					{
						IssuePointOrder( source, "attack", GetRandomReal( -1900.f, 1900.f ), GetRandomReal( -110.f, 180.f ) );
						tick = 0;
					}
				}
			}
		}
	}
}

void StartAI( unit u )
{
	int u_hid = GetHandleId( u );

	if ( LoadBoolean( DataHT, GetHandleId( u ), 'ISAI' ) ) { return; }
	SaveBoolean( DataHT, GetHandleId( u ), 'ISAI', true );

	timer tmr = CreateTimer( );
	int hid = GetHandleId( tmr );

	SaveUnitHandle( GameHT, hid, 'usrc', u );
	SaveHandleList( GameHT, hid, 'list', HandleListCreate( ) );
	//TimerStart( tmr, 1.f, true, @AILoop );

	if ( u != LoadUnitHandle( DataHT, 'BOSS', 'unit' ) )
	{
		player p = GetOwningPlayer( u );
		aidifficulty ai = GetAIDifficulty( p );

		if ( ai == AI_DIFFICULTY_NEWBIE )
		{
			SetPlayerHandicapXP( p, 1.5f );
		}
		else if ( ai == AI_DIFFICULTY_NORMAL )
		{
			SetPlayerHandicapXP( p, 2.f );
		}
		else if ( ai == AI_DIFFICULTY_INSANE )
		{
			SetPlayerHandicapXP( p, 3.f );
		}

		IssuePointOrder( u, "attack", GetRandomReal( -1900.f, 1900.f ), GetRandomReal( -1200.f, 200.f ) );
	}
}

namespace PickSystem
{
	void InitHeroData( uint id, uint uid, float scale, uint itemId, string modelPath, string iconPath )
	{
		SaveInteger( DataHT, id, 'type', uid );
		SaveReal( DataHT, uid, 'size', scale );
		SaveStr( DataHT, uid, 'mmdl', modelPath + ".mdl" );
		SaveStr( DataHT, uid, 'imdl', modelPath + "Icon.mdl" );
		SaveStr( DataHT, uid, 'icon', iconPath );

		SaveInteger( DataHT, uid, 'pitm', itemId );

		TotalHeroes++;
	}
}

namespace BossSystem
{
	void InitBossData( uint id, uint uid )
	{
		SaveInteger( DataHT, 'btid', id, uid );
	}

	unit CreateSide( uint id, uint side )
	{
		unit u = CreateUnit( Player( PLAYER_NEUTRAL_AGGRESSIVE ), LoadInteger( DataHT, 'btid', id ), side == 'lbos' ? -2200.f : 2200.f, 2800.f, 270.f );
		SaveInteger( DataHT, GetHandleId( u ), 'side', side );
		SaveInteger( DataHT, GetHandleId( u ), 'indx', id );

		return u;
	}

	void Init( )
	{
		InitBossData( 0, 'U001' );
		InitBossData( 1, 'U002' );
		InitBossData( 2, 'U003' );
		InitBossData( 3, 'U004' );
		InitBossData( 4, 'U005' );
		InitBossData( 5, 'U006' );
		InitBossData( 6, 'U007' );
		InitBossData( 7, 'U008' );

		CreateSide( 0, 'lbos' );
		CreateSide( 0, 'rbos' );
	}
}

void HeroPickArrayCreation( )
{
	PickSystem::InitHeroData(  1, 'H00A', 1.4f, 'I006', "Characters\\NanayaShiki\\NanayaShiki",			"Characters\\NanayaShiki\\ReplaceableTextures\\CommandButtons\\BTNNanayaShikiIcon.blp" 			 );
	PickSystem::InitHeroData(  2, 'H00B', 1.4f, 'I01J', "Characters\\ToonoShiki\\ToonoShiki",			"Characters\\ToonoShiki\\ReplaceableTextures\\CommandButtons\\BTNToonoShikiIcon.blp" 			 );
	PickSystem::InitHeroData(  3, 'H00C', 1.5f, 'I01F', "Characters\\RyougiShiki\\RyougiShiki",			"Characters\\RyougiShiki\\ReplaceableTextures\\CommandButtons\\BTNRyougiShikiIcon.blp" 			 );
	PickSystem::InitHeroData(  4, 'H00D', 2.2f, 'I01W', "Characters\\SaberAlter\\SaberAlter",			"Characters\\SaberAlter\\ReplaceableTextures\\CommandButtons\\BTNSaberAlterIcon.blp" 			 );
	PickSystem::InitHeroData(  5, 'H00E', 2.4f, 'I008', "Characters\\SaberNero\\SaberNero",				"Characters\\SaberNero\\ReplaceableTextures\\CommandButtons\\BTNSaberNeroIcon.blp" 				 );
	PickSystem::InitHeroData(  6, 'H00F', 2.2f, 'I016', "Characters\\KuchikiByakuya\\KuchikiByakuya",	"Characters\\KuchikiByakuya\\ReplaceableTextures\\CommandButtons\\BTNKuchikiByakuyaIcon.blp" 	 );
	PickSystem::InitHeroData(  7, 'H00G', 1.5f, 'I01V', "Characters\\Akame\\Akame",						"Characters\\Akame\\ReplaceableTextures\\CommandButtons\\BTNAkameIcon.blp" 						 );
	PickSystem::InitHeroData(  8, 'H00H', 2.4f, 'I01P', "Characters\\Scathach\\Scathach",				"Characters\\Scathach\\ReplaceableTextures\\CommandButtons\\BTNScathachIcon.blp" 				 );
	PickSystem::InitHeroData(  9, 'H00I', 1.8f, 'I018', "Characters\\Akainu\\Akainu",					"Characters\\Akainu\\ReplaceableTextures\\CommandButtons\\BTNAkainuIcon.blp" 					 );
	PickSystem::InitHeroData( 10, 'H00J', 2.4f, 'I010', "Characters\\Reinforce\\Reinforce",				"Characters\\Reinforce\\ReplaceableTextures\\CommandButtons\\BTNReinforceIcon.blp" 				 );
	PickSystem::InitHeroData( 11, 'H00K', 2.4f, 'I00E', "Characters\\Arcueid\\Arcueid",					"Characters\\Arcueid\\ReplaceableTextures\\CommandButtons\\BTNArcueidIcon.blp" 					 );

	int size = TotalHeroes + 1;

	HeroUnitArray.resize( size );
	U_SelectionHeroDummyArr.resize( size );
	EF_SelectionIconArray.resize( size );
	EF_SelectionHeroModelArray.resize( size );

	float x = -2600.f;
	float y = 6200.f;
	float x_d = 700.f;
	float y_d = 6200.f;

	player p = Player( PLAYER_NEUTRAL_PASSIVE );

	SelectionUnit = CreateUnit( p, 'u012', -1800.f, 5525.f, 270.f );
	SetUnitScale( SelectionUnit, 2.5f, 2.5f, 2.5f );
	Ef_Selection = AddSpecialEffectTarget( "HeroSelectionSystem\\HeroSelectionEffect.mdl", SelectionUnit, "origin" );
	Ef_SelectionBack = AddSpecialEffectTarget( "HeroSelectionSystem\\HeroSelectionBackground.mdl", SelectionUnit, "origin" );

	for ( int i = 0; i < TotalHeroes; i++ )
	{
		if ( ( i % 5 ) == 0 )
		{
			x = -2600.f;
			y -= 100.f;
			x_d = 700.f;
			y_d -= 150.f;
		}

		int id = i + 1;
		int uid = LoadInteger( DataHT, id, 'type' ); if ( uid == 0 ) { continue; }

		unit u = CreateUnit( p, 'u013', x, y, 270.f );
		SetUnitVertexColor( u, 255, 255, 255, 0 );
		SetUnitUserData( u, id );
		U_SelectionHeroDummyArr[id] = u;
		EF_SelectionIconArray[id] = AddSpecialEffect( LoadStr( DataHT, uid, 'imdl' ), x, y );
		
		HeroUnitArray[id] = CreateUnit( p, uid, x_d, y_d, 270.f );
		SetUnitInvulnerable( HeroUnitArray[id], true );

		x += 100.f;
		x_d += 150.f;
	}
}

void MoveHeroToTeamLocation( int pid, int heroId )
{
	player p = Player( pid );
	int team = GetPlayerTeam( p );

	if ( HeroesSelected < TotalPlayers )
	{
		HeroesSelected++;
		SaveBoolean( DataHT, GetHandleId( p ), 'HERO', true );
	}

	if ( team == 0 )
	{
		TeamOneSelected[heroId] = true;
	}
	else
	{
		TeamTwoSelected[heroId] = true;
	}

	int uid = LoadInteger( DataHT, heroId, 'type' );
	unit u = CreateUnit( p, uid, team == 0 ? -4480.f : 4480.f, -480.f, 270.f );
	InitHero( u );
	if ( GetPlayerController( p ) == MAP_CONTROL_USER )
	{
		SetPlayerName( p, PlayerColoredNameArray[pid] + " [ " + GetUnitName( u ) + " ]" );
		if ( GetLocalPlayer( ) == p )
		{
			SetCameraField( CAMERA_FIELD_ANGLE_OF_ATTACK, 305.f, 0.f );
			PanCameraToTimed( GetUnitX( u ), GetUnitY( u ), 0.f );
			ClearSelection( );
			SelectUnit( u, true );
		}
	}
	else
	{
		StartAI( u );
		SetPlayerName( p, PlayerColorStringArray[pid] + GetHeroProperName( u ) );
	}

	MUnitArray[pid] = u;

	if ( !SameHeroBoolean )
	{
		RemoveUnit( HeroUnitArray[heroId] );
		RemoveUnit( U_SelectionHeroDummyArr[heroId] );
	}

	int mbId = pid + 1 + GetPlayerTeam( p );

	multiboarditem mbitem = MultiboardGetItem( MainMultiboard, mbId, 0 );
	MultiboardSetItemIcon( mbitem, LoadStr( DataHT, uid, 'icon' ) );
	MultiboardReleaseItem( mbitem );
	mbitem = MultiboardGetItem( MainMultiboard, mbId, 0 );
	MultiboardSetItemValue( mbitem, PlayerColoredNameArray[pid] );
	MultiboardReleaseItem( mbitem );

	DisplayTextToPlayer( GetLocalPlayer( ), 0.f, 0.f, PlayerColoredNameArray[pid] + "|r:|c0000ffff has chosen " + PlayerColorStringArray[pid] + GetUnitName( MUnitArray[pid] ) + "|r" );
}

void ComputerHeroSelection( )
{
	if ( HeroesSelected >= TotalPlayers )
	{
		DestroyEffect( Ef_Selection );
		DestroyEffect( Ef_SelectionBack );
		RemoveUnit( SelectionUnit );

		for ( int i = 0; i < 8; i++ )
		{
			player p = Player( i );
			
			if ( GetPlayerSlotState( p ) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController( p ) == MAP_CONTROL_COMPUTER )
			{
				for ( int rand = GetRandomInt( 1, TotalHeroes ); !TeamOneSelected[rand] && !TeamTwoSelected[rand]; rand = GetRandomInt( 1, TotalHeroes ) )
				{
					MoveHeroToTeamLocation( i, rand );
				}
			}
		}

		for ( int i = 1; i <= TotalHeroes; i++ )
		{
			DestroyEffect( EF_SelectionIconArray[i] );
			RemoveUnit( U_SelectionHeroDummyArr[i] );
			RemoveUnit( HeroUnitArray[i] );
		}

		DisableTrigger( TR_HeroSelection );
	}
}

void HeroSelectionAction( )
{
	player p = GetTriggerPlayer( );
	unit u = GetTriggerUnit( );
	int teamId = GetPlayerTeam( p );
	int pid = GetPlayerId( p );
	int heroId = GetUnitUserData( u );
	int uid = LoadInteger( DataHT, heroId, 'type' );
	string smdl = "";

	if ( !LoadBoolean( DataHT, GetHandleId( p ), 'HERO' ) && GetUnitTypeId( u ) == 'u013' )
	{
		if ( U_SelectionSelArr[pid] != HeroUnitArray[heroId] )
		{
			float scale = LoadReal( DataHT, uid, 'size' );

			if ( GetLocalPlayer( ) == p )
			{
				smdl = LoadStr( DataHT, uid, 'mmdl' );
				ClearSelection( );
				SelectUnit( HeroUnitArray[heroId], true );
			}
			DestroyEffect( EF_SelectionHeroModelArray[pid] );
			RemoveUnit( U_SelectionDumArr[pid] );
			U_SelectionDumArr[pid] = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'u012', -1800.f, 5525.f, 270.f );
			SetUnitTimeScale( U_SelectionDumArr[pid], 1.5f );
			SetUnitScale( U_SelectionDumArr[pid], scale, scale, scale );
			EF_SelectionHeroModelArray[pid] = AddSpecialEffectTarget( smdl, U_SelectionDumArr[pid], "origin" );

			U_SelectionSelArr[pid] = HeroUnitArray[heroId];
		}
		else
		{
			if ( ( TeamOneSelected[heroId] == false && teamId == 0 ) || ( TeamTwoSelected[heroId] == false && teamId == 1 ) )
			{
				DestroyEffect( EF_SelectionHeroModelArray[pid] );
				RemoveUnit( U_SelectionDumArr[pid] );
				MoveHeroToTeamLocation( pid, heroId );
				ComputerHeroSelection( );
			}
			else
			{
				DisplayTextToPlayer( p, .0f, .0f, "|c0000ffffHero already selected by your ally!" );
			}
		}
	}
}

void PlayerNameSettingAction( )
{
	int tid = 1;

	for ( int i = 0; i < 12; i++ )
	{
		player p = Player( i );
		string name = "";

		if ( i <= 7 )
		{
			if ( GetPlayerSlotState( p ) == PLAYER_SLOT_STATE_PLAYING )
			{
				if ( GetPlayerController( p ) == MAP_CONTROL_COMPUTER )
				{
					name = "Bot " + I2S( i + 1 );
				}
				else
				{
					name = GetPlayerName( p );
				}
			}
			else
			{
				name = "- Empty Slot -";
			}
		}
		else if ( i >= 10 )
		{
			name = "Base Tower " + I2S( tid );
			tid++;
		}

		if ( name.isEmpty( ) )
		{
			continue;
		}

		PlayerNameArray[i] = name;
		PlayerColoredNameArray[i] = PlayerColorStringArray[i] + PlayerNameArray[i] + "|r";

		SetPlayerName( p, PlayerColoredNameArray[i] ); // crashes -> PlayerColoredNameArray[i]
	}
}

void AllHeroPickAction( )
{
	player p = GetTriggerPlayer( );
	float CenterX = GetPlayerTeam( p ) == 0 ? -4288.f : 4288.f;
	DisplayTimedTextToPlayer( p, .0f, .0f, 10.f, "|c0000ff00The host got all heroes.|r" );

	for ( int i = 1; i <= TotalHeroes; i++ )
	{
		InitHero( CreateUnit( p, LoadInteger( DataHT, i, 'type' ), CenterX, -576.f, 270.f ) );
	}
}

void SetUnitFlyHeightEx( unit u, float height, float time )
{
	ability a = GetUnitAbility( u, 'A04U' );

	if ( a == nil )
	{
		UnitAddAbility( u, 'A04U' );
		a = GetUnitAbility( u, 'A04U' );
	}

	ShowAbility( a, false );
	SetUnitFlyHeight( u, height, time );
}

// Effect API
effect CreateEffect( string model, float x, float y, float facing )
{
	effect ef = AddSpecialEffect( model, x, y );
	SetSpecialEffectFacing( ef, facing );

	return ef;
}

effect CreateEffectEx( string model, float x, float y, float height = .0f, float facing = 270.f, float scale = 1.f, float timeScale = 1.f )
{
	effect ef = CreateEffect( model, x, y, facing );
	SetSpecialEffectHeight( ef, height );
	SetSpecialEffectScale( ef, scale );
	SetSpecialEffectTimeScale( ef, timeScale );

	return ef;
}

void RemoveEffect( effect ef )
{
	if ( ef == nil ) { return; }

	SetSpecialEffectVisible( ef, false );
	DestroyEffect( ef );
}

timer LifeTimer;
hashtable LifeHT = InitHashtable( );

void OnProcessEffectList( )
{
	int hid = GetHandleId( GetExpiredTimer( ) );
	handlelist hl = LoadHandleList( LifeHT, hid, 'ELST' ); if ( hl == nil ) { return; }
	int max = HandleListGetCount( hl );

	//print( "OnProcessEffectList: " + "hl = " + I2S( GetHandleId( hl ) ) + " | max: " + I2S( max ) + "\n" );

	for ( int i = 0; i < max; i++ )
	{
		effect ef = HandleListGetEffectByIndex( hl, i ); if ( ef == nil ) { break; }
		int ef_hid = GetHandleId( ef );
		float life = LoadReal( LifeHT, ef_hid, 'LIFE' ) - .05f;

		if ( life <= .0f )
		{
			HandleListRemoveHandle( hl, ef );

			string anim = LoadStr( LifeHT, ef_hid, 'ANIM' );

			if ( anim.isEmpty( ) )
			{
				RemoveEffect( ef );
			}
			else
			{
				SetSpecialEffectAnimation( ef, anim );
				DestroyEffect( ef );
			}
			
			i--;
			max = HandleListGetCount( hl );
		}
		else
		{
			SaveReal( LifeHT, ef_hid, 'LIFE', life );
		}
	}
}

void SetEffectTimedLife( effect ef, float time, string anim = "" )
{
	if ( IsHandleDestroyed( ef ) ) { return; } // returns true if ef is nil, or underlaying object was destroyed.

	int ef_hid = GetHandleId( ef );
	SaveReal( LifeHT, ef_hid, 'LIFE', time );
	SaveStr( LifeHT, ef_hid, 'ANIM', anim );

	int hid = GetHandleId( LifeTimer );
	handlelist hl = LoadHandleList( LifeHT, hid, 'ELST' );

	if ( hl == nil )
	{
		LifeTimer = CreateTimer( );
		hid = GetHandleId( LifeTimer );
		hl = HandleListCreate( );

		SaveHandleList( LifeHT, hid, 'ELST', hl );

		TimerStart( LifeTimer, .05f, true, @OnProcessEffectList );
	}

	HandleListAddHandle( hl, ef );
}

namespace EffectAPI
{
	void Dash( unit source, int effCount = 6, float moveStep = 40.f, float initSize = .4f, float sizeStep = .25f, float timeScale = 1.25f, float height = 50.f )
	{
		float angle = GetUnitFacing( source );
		float x = MathPointProjectionX( GetUnitX( source ), angle, 100.f );
		float y = MathPointProjectionY( GetUnitY( source ), angle, 100.f );
		effect ef;

		for ( int i = 0; i < effCount; i++ )
		{
			float move = -( moveStep + moveStep * i );

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", MathPointProjectionX( x, angle, move ), MathPointProjectionY( y, angle, move ), height, angle, initSize + sizeStep * i, timeScale );
			SetSpecialEffectAlpha( ef, 0xA0 );
			SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 4.f );
		}
	}

	void Jump( unit source, int effCount = 6 )
	{
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = GetUnitFacing( source );
		effect ef;

		//ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, 0.f, GetRandomReal( 0.f, 360.f ), 3.f, 1.f );
		//SetEffectTimedLife( ef, 1.f );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );

		for ( int i = 0; i < effCount; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, GetRandomReal( .0f, 360.f ), 1.f + .25f * i, GetRandomReal( .5f, 1.5f ) );
			SetSpecialEffectAlpha( ef, 0xA0 );
			SetEffectTimedLife( ef, 4.f );
		}
	}

	void InverseDash( unit source, int effCount = 6, float moveStep = 25.f, float initSize = .4f, float sizeStep = .15f, float timeScale = 1.25f, float height = 50.f )
	{
		Dash( source, effCount, -moveStep, initSize, sizeStep, timeScale, height );
	}

	void PushWind( unit source, unit target, float baseHeight = 50.f, float pitch = -90.f )
	{
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = MathAngleBetweenPoints( x, y, targX, targY );
		float dist = MathDistanceBetweenPoints( x, y, targX, targY );
		effect ef;

		for ( int i = 0; i < 3; i++ )
		{
			float move = 25.f + 25.f * i;

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", MathPointProjectionX( x, angle, move ), MathPointProjectionY( y, angle, move ), 50.f, angle, 1.f + .25f * i, 1.f );
			SetSpecialEffectPitch( ef, pitch );
			SetEffectTimedLife( ef, 4.f );
		}

		ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, baseHeight, angle, 1.5f, 2.f );
		SetSpecialEffectPitch( ef, pitch );
		SetEffectTimedLife( ef, 4.f );

		ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, baseHeight, angle, 1.f, 2.f );
		SetSpecialEffectPitch( ef, pitch );
		SetEffectTimedLife( ef, 3.f );
	}
}
//

bool DisplaceWar3ImageToTarget( war3image source, war3image target, float speed, float minDist )
{
	float x = GetWar3ImageX( source );
	float y = GetWar3ImageY( source );
	float targX = GetWar3ImageX( target );
	float targY = GetWar3ImageY( target );
	float angle = MathAngleBetweenPoints( x, y, targX, targY );
	float dist = MathDistanceBetweenPoints( x, y, targX, targY );

	SetWar3ImageFacing( source, angle, true );

	if ( dist > minDist )
	{
		x = MathPointProjectionX( x, angle, speed );
		y = MathPointProjectionY( y, angle, speed );
		dist = MathDistanceBetweenPoints( x, y, targX, targY );
		SetWar3ImagePosition( source, x, y );
	}

	return dist <= minDist;
}

void DisplaceCircular( player enemyTo, float startX, float startY, float aoe, float angle, float scale = 1.f, string eff = "" )
{
	for ( int i = 0; i < 1; i++ )
	{
		float x = MathPointProjectionX( startX, angle, angle );
		float y = MathPointProjectionY( startY, angle, angle );

		if ( !eff.isEmpty( ) )
		{
			effect ef = CreateEffectEx( eff, x, y, .0f, .0f, scale, 1.f );
			
			DestroyEffect( ef );
		}

		GroupEnumUnitsInRange( GroupEnum, x, y, aoe, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, enemyTo ) )
			{
				SetUnitXY( u, x, y );
			}
		}

		angle += 180.f;
	}
}

void DisplaceUnitAction( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int magnitude = LoadInteger( GameHT, hid, 'magc' );
	int magnitudeMax = LoadInteger( GameHT, hid, 'magm' );
	float heightOrig = LoadReal( GameHT, hid, 'horg' );
	unit u = LoadUnitHandle( GameHT, hid, 'usrc' );
	int isMoved = LoadInteger( GameHT, GetHandleId( u ), 'disp' );

	if ( ( magnitude < magnitudeMax && isMoved > 0 ) && IsUnitAlive( u ) )
	{
		float angle = LoadReal( GameHT, hid, 'angl' );
		float step = LoadReal( GameHT, hid, 'step' );
		float x = LoadReal( GameHT, hid, 'srcX' );
		float y = LoadReal( GameHT, hid, 'srcY' );

		float moveX = MathPointProjectionX( x, angle, magnitude * step );
		float moveY = MathPointProjectionY( y, angle, magnitude * step );
		bool isMove = IsAxisReal( moveX, moveY );

		if ( isMove )
		{
			SetUnitXY( u, moveX, moveY );
		}
		
		float heightMax = LoadReal( GameHT, hid, 'hmax' );
		float heightStep = LoadReal( GameHT, hid, 'hstp' );
		float hmag = ( 2.f * I2R( magnitude ) * heightStep - 1 );
		SaveInteger( GameHT, hid, 'magc', magnitude + 1 );
		SetUnitFlyHeightEx( u, ( 1.f + -hmag * hmag ) * heightMax + heightOrig, 99999.f );
	}
	else
	{
		SetUnitFlyHeightEx( u, heightOrig, 99999.f );
		SetUnitPathing( u, true );
		SaveInteger( GameHT, GetHandleId( u ), 'disp', isMoved - 1 );
		PauseTimer( tmr );
		FlushChildHashtable( GameHT, hid );
		DestroyTimer( tmr );
	}
}

void DisplaceUnitWithArgs( unit u, float angle, float dist, float time, float rate, float heightMax )
{
	if ( u == nil || LoadInteger( GameHT, GetHandleId( u ), 'disp' ) > 0 ) { return; }

	timer tmr = CreateTimer( );
	int hid = GetHandleId( tmr );
	float x = GetUnitX( u );
	float y = GetUnitY( u );
	int magnitudeMax = R2I( time / rate );
	int magnitude = 0;
	float step = dist / magnitudeMax;
	float heightStep = 1.f / magnitudeMax;
	float heightOrig = GetUnitFlyHeight( u );

	SetUnitPathing( u, false );
	SaveInteger( GameHT, GetHandleId( u ), 'disp', 1 );
	SaveUnitHandle( GameHT, hid, 'usrc', u );
	SaveReal( GameHT, hid, 'horg', heightOrig );
	SaveReal( GameHT, hid, 'angl', angle );
	SaveReal( GameHT, hid, 'step', step );
	SaveReal( GameHT, hid, 'hmax', heightMax );
	SaveReal( GameHT, hid, 'hstp', heightStep );
	SaveReal( GameHT, hid, 'srcX', x );
	SaveReal( GameHT, hid, 'srcY', y );
	SaveInteger( GameHT, hid, 'magc', magnitude );
	SaveInteger( GameHT, hid, 'magm', magnitudeMax );
	TimerStart( tmr, rate, true, @DisplaceUnitAction );
}

void DisplaceWar3ImageAction( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int magnitude = LoadInteger( GameHT, hid, 'magc' );
	int magnitudeMax = LoadInteger( GameHT, hid, 'magm' );
	float heightOrig = LoadReal( GameHT, hid, 'horg' );
	war3image source = LoadEffectHandle( GameHT, hid, '+src' );
	int isMoved = LoadInteger( GameHT, GetHandleId( source ), 'disp' );

	if ( ( magnitude < magnitudeMax && isMoved > 0 ) )
	{
		float angle = LoadReal( GameHT, hid, 'angl' );
		float step = LoadReal( GameHT, hid, 'step' );
		float x = LoadReal( GameHT, hid, 'srcX' );
		float y = LoadReal( GameHT, hid, 'srcY' );
		float moveX = MathPointProjectionX( x, angle, magnitude * step );
		float moveY = MathPointProjectionY( y, angle, magnitude * step );
		bool isMove = IsAxisReal( moveX, moveY );

		if ( isMove )
		{
			SetWar3ImagePosition( source, moveX, moveY );
		}
		
		float heightMax = LoadReal( GameHT, hid, 'hmax' );
		float heightStep = LoadReal( GameHT, hid, 'hstp' );
		float hmag = ( 2.f * I2R( magnitude ) * heightStep - 1 );
		SaveInteger( GameHT, hid, 'magc', magnitude + 1 );
		SetWar3ImageHeight( source, ( 1.f + -hmag * hmag ) * heightMax + heightOrig );
	}
	else
	{
		SetWar3ImageHeight( source, heightOrig );
		ResetWar3ImageZ( source );
		SaveInteger( GameHT, GetHandleId( source ), 'disp', isMoved - 1 );
		PauseTimer( tmr );
		FlushChildHashtable( GameHT, hid );
		DestroyTimer( tmr );
	}
}

void DisplaceWar3ImageWithArgs( war3image source, float angle, float dist, float time, float rate, float heightMax )
{
	if ( source == nil || LoadInteger( GameHT, GetHandleId( source ), 'disp' ) > 0 ) { return; }

	timer tmr = CreateTimer( );
	int hid = GetHandleId( tmr );
	float x = GetWar3ImageX( source );
	float y = GetWar3ImageY( source );
	int magnitudeMax = R2I( time / rate );
	int magnitude = 0;
	float step = dist / magnitudeMax;
	float heightStep = 1.f / magnitudeMax;
	float heightOrig = GetWar3ImageHeight( source );

	SaveInteger( GameHT, GetHandleId( source ), 'disp', 1 );
	SaveWar3ImageHandle( GameHT, hid, '+src', source );
	SaveReal( GameHT, hid, 'horg', heightOrig );
	SaveReal( GameHT, hid, 'angl', angle );
	SaveReal( GameHT, hid, 'step', step );
	SaveReal( GameHT, hid, 'hmax', heightMax );
	SaveReal( GameHT, hid, 'hstp', heightStep );
	SaveReal( GameHT, hid, 'srcX', x );
	SaveReal( GameHT, hid, 'srcY', y );
	SaveInteger( GameHT, hid, 'magc', magnitude );
	SaveInteger( GameHT, hid, 'magm', magnitudeMax );
	TimerStart( tmr, rate, true, @DisplaceWar3ImageAction );
}

void DisplaceWar3ImageLinearAction( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	float angle = LoadReal( GameHT, hid, 'angl' );
	float step = LoadReal( GameHT, hid, 'step' );
	war3image source = LoadWar3ImageHandle( GameHT, hid, '+src' );
	float x = GetWar3ImageX( source );
	float y = GetWar3ImageY( source );
	float moveX = MathPointProjectionX( x, angle, step );
	float moveY = MathPointProjectionY( y, angle, step );
	bool isMove = LoadBoolean( GameHT, hid, 'PATH' ) ? !IsTerrainPathable( moveX, moveY, PATHING_TYPE_WALKABILITY ) : true;

	if ( step <= 0 || !IsAxisReal( moveX, moveY ) || !isMove )
	{
		PauseTimer( tmr );
		FlushChildHashtable( GameHT, hid );
		DestroyTimer( tmr );
		return;
	}

	string effMdl = LoadStr( GameHT, hid, 'emdl' );

	if ( !effMdl.isEmpty( ) )
	{
		DestroyEffect( AddSpecialEffect( effMdl, x, y ) );
	}

	SetWar3ImagePosition( source, moveX, moveY );
	SaveReal( GameHT, hid, 'step', step - LoadReal( GameHT, hid, 'rate' ) );
}

void DisplaceWar3ImageLinear( war3image source, float angle, float dist, float ticks, float rate, bool destDestr, bool ignorePathing, string effmdl = "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl" )
{
	if ( source == nil )
	{
		return;
	}

	timer tmr = CreateTimer( );
	int hid = GetHandleId( tmr );
	float step = 2.f * dist * rate / ticks;

	SaveReal( GameHT, hid, 'angl', angle );
	SaveReal( GameHT, hid, 'step', step );
	SaveReal( GameHT, hid, 'rate', step * rate / ticks );
	SaveWar3ImageHandle( GameHT, hid, '+src', source );
	SaveBoolean( GameHT, hid, 'PATH', !ignorePathing );
	SaveStr( GameHT, hid, 'emdl', effmdl );
	SaveReal( GameHT, hid, 'time', ticks / rate );
	TimerStart( tmr, rate, true, @DisplaceWar3ImageLinearAction );
}

void DamageVisualDrawNumber( string i, float x, float y, string suffix )
{
	DestroyEffect( AddSpecialEffect( "DamageSystemVisual\\Number_" + i + suffix + ".mdx", x, y ) );
}

float DamageVisualGetPosition( float startX, float x, int index, int length, float scale )
{
	return x - ( startX * scale * ( length / 2 ) ) + ( startX * scale * index );
}

void DamageVisualDrawNumberAction( unit u, unit target, float dmg )
{
	if ( dmg == .0f ) { return; }

	float startX = 70.f;
	float x = GetUnitX( target );
	float y = GetUnitY( target ) + GetUnitFlyHeight( target ) + 150;
	string numb = I2S( R2I( dmg ) );
	int length = StringLength( numb );
	float newX = 0;
	string suffix = "";
	float scale = 0;
	int index = 0;

	if ( dmg >= 5000 )
	{
		suffix = "_Large";
		scale = 1.3f;
	}
	else if ( dmg >= 500 )
	{
		suffix = "";
		scale = 1.0f;
	}
	else
	{
		suffix = "_Small";
		scale = 0.7f;
	}

	index = - 1;
	while ( true )
	{
		index++;
		if ( index > length - 1 ) break;
		newX = DamageVisualGetPosition( startX, x, index, length, scale );
		if ( IsUnitInvisible( target, GetOwningPlayer( u ) ) == false )
		{
			DamageVisualDrawNumber( SubString( numb, index, index + 1 ), newX, y, suffix );
		}
	}
}

void AkamePoisonDamage( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
	unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

	if ( GetUnitAbilityLevel( target, 'B006' ) > 0 )
	{
		float dmg = 10 + GetHeroLevel( source ) + .1f * GetHeroInt( source, true );
		ACF_DamageTarget( source, target, dmg );
	}
	else
	{
		FlushChildHashtable( GameHT, hid );
		DestroyTimer( tmr );
	}
}

void AkamePoisonCheck( unit source, unit targ )
{
	timer tmr = CreateTimer( );
	int hid = GetHandleId( tmr );

	SaveUnitHandle( GameHT, hid, 'usrc', source );
	SaveUnitHandle( GameHT, hid, 'utrg', targ );
	TimerStart( tmr, 1.f, true, @AkamePoisonDamage );
}

void OnPlayerUnitProjectileHit( )
{
	projectile proj = GetTriggerProjectile( );
	int pr_hid = GetHandleId( proj );
	unit source = GetTriggerProjectileSource( );
	unit target = GetTriggerProjectileTargetUnit( );
	int aid = LoadInteger( GameHT, pr_hid, 'atid' );

	switch( aid )
	{
		case 'A04B': // Akainu E
		{

			break;
		}
	}

	FlushChildHashtable( GameHT, pr_hid );
}

void OnPlayerUnitDamaged( )
{
	float dmg = GetEventDamage( );

	trigger t = GetTriggeringTrigger( );
	unit source = GetEventDamageSource( );
	unit target = GetTriggerUnit( );
	int tid = GetUnitTypeId( target );

	float multiplier = 1.f;
	float dmgMulti = 0;

	DisableTrigger( t );

	if ( GetEventIsAttack( ) )
	{
		if ( tid == 'n000' && ( GetUnitTypeId( source ) == 'base' || IsUnitType( source, UNIT_TYPE_HERO ) ) )
		{
			SetUnitXY( KawarimiTriggerUnitArray[GetPlayerId( GetOwningPlayer( target ) )], GetUnitX( source ), GetUnitY( source ) );
			UnitApplyTimedLife( target, 'BOmi', .01f );
		}

		if ( GetUnitTypeId( source ) == 'H00G' )
		{
			int bid = 'B006';
			buff buf = GetUnitBuff( target, bid );
			float dur = GetBuffBaseRealFieldById( bid, IsUnitHero( target ) ? ABILITY_RLF_DURATION_HERO : ABILITY_RLF_DURATION_NORMAL );

			if ( buf == nil )
			{
				UnitAddBuffById( target, bid );
				buf = GetUnitBuff( target, bid );
				AkamePoisonCheck( source, target );
			}

			SetBuffRemainingDuration( buf, dur );
		}
		else if ( GetUnitTypeId( source ) == 'H00K' )
		{
			SetUnitCurrentLife( source, dmg * .15f + GetUnitCurrentLife( source ) );
		}

		if ( GetUnitAbilityLevel( source, 'B002' ) > 0 || GetUnitAbilityLevel( source, 'B000' ) > 0 )
		{
			if ( GetUnitAbilityLevel( source, 'B002' ) > 0 )
			{
				dmgMulti = 10;
			}
			if ( GetUnitAbilityLevel( source, 'B000' ) > 0 )
			{
				dmgMulti = 20;
			}

			float reqHP = 5.f;

			if ( ACF_HasPersonalItem( source ) )
			{
				dmgMulti = dmgMulti + dmgMulti / 2;
				reqHP = 10.f;
			}

			dmg = GetHeroLevel( source ) * dmgMulti + GetHeroInt( source, true ) * dmgMulti / 100;
			if ( ACF_GetUnitStatePercent( target, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE ) <= reqHP && target != LoadUnitHandle( DataHT, 'BOSS', 'unit' ) )
			{
				int aid = 0;

				if ( GetUnitAbilityLevel( source, 'B002' ) > 0 )
				{
					aid = 'A02X';
					UnitRemoveAbility( source, 'B002' );
				}

				if ( GetUnitAbilityLevel( source, 'B000' ) > 0 )
				{
					aid = 'A035';
					UnitRemoveAbility( source, 'B000' );
				}

				SetAbilityRemainingCooldown( GetUnitAbility( source, aid ), .01f );

				dmg = 100000000.f;
				float targX = GetUnitX( target );
				float targY = GetUnitY( target );

				SetEffectTimedLife( CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 1.f, 4.f ), 4.f );
				
				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
				DestroyEffect( AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
			}

			SetEventDamage( GetEventDamage( ) + dmg );
		}

		if ( GetUnitTypeId( source ) == 'H00J'  && GetRandomInt( 0, 100 ) <= 15 )
		{
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );
			float angle = MathAngleBetweenPoints( x, y, targX, targY );
			effect ef;

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 50.f, angle, 1.5f, 3.f );
			SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.5f, 3.f );
			SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 3.f );

			dmg = GetHeroLevel( source ) * 50 + GetHeroInt( source, true );
			DisplaceUnitWithArgs( target, angle, 200.f, .25f, .01f, 0 );
			SetEventDamage( GetEventDamage( ) + dmg );
		}

		if ( GetUnitTypeId( source ) == 'H00H' )
		{
			if ( !IsUnitType( target, UNIT_TYPE_HERO ) )
			{
				dmgMulti = 2;
			}
			dmgMulti = .01f * multiplier;
			dmg = .005f * multiplier * GetUnitMaxLife( target );

			SetEventDamage( GetEventDamage( ) + dmg );
			SetUnitCurrentLife( source, GetUnitMaxLife( source ) * dmgMulti + GetUnitCurrentLife( source ) );
		}
	}

	if ( GetUnitTypeId( source ) == 'base' )
	{
		SetEventDamage( GetEventDamage( ) + GetUnitMaxLife( target ) * .02f );
	}

	dmg = GetEventDamage( );
	if ( GetUnitTypeId( source ) != 'base' )
	{
		DamageVisualDrawNumberAction( source, target, dmg );
	}

	if ( tid == 'tstu'  )
	{
		SetEventDamage( .0f );
	}

	EnableTrigger( t );
}

void DecideWinnersAction( )
{
	for( int i = 0; i < PLAYER_NEUTRAL_AGGRESSIVE; i++ )
	{
		player p = Player( i ); if ( GetPlayerSlotState( p ) != PLAYER_SLOT_STATE_PLAYING ) { continue; }

		RemovePlayer( p, GetPlayerTeam( p ) == I_WinningTeam ? PLAYER_GAME_RESULT_VICTORY : PLAYER_GAME_RESULT_DEFEAT );
	}

	EndGame( true );
}

void GameEndUnitPauseFunction( )
{
	for( int i = 0; i < PLAYER_NEUTRAL_AGGRESSIVE; i++ )
	{
		player p = Player( i ); if ( GetPlayerSlotState( p ) != PLAYER_SLOT_STATE_PLAYING ) { continue; }
		unit u = MUnitArray[ i ];
		ACF_PanCameraToTimed( p, GetUnitX( u ), GetUnitY( u ), .0f );
		SetUnitXY( u, GetPlayerTeam( p ) == 0 ? -800.f : 800.f, 1536.f );
		SetUnitFacing( u, 270.f );
		SetUnitInvulnerable( u, true );
		PauseUnit( u, true );
	}
}

void PrepareFinishGameAction( int teamId )
{
	float x = teamId == 0 ? -800.f : 800.f;

	I_WinningTeam = teamId;
	TextTagCreate( "|c0000FF00Winners!|r", x, 1700.f, 0, 20, 255, 255, 255, 0 );
	TextTagCreate( "|c00ff0000Losers!|r", -x, 1700.f, 0, 20, 255, 255, 255, 0 );
	TimerStart( CreateTimer( ), 1.f, true, @GameEndUnitPauseFunction );
	TimerStart( CreateTimer( ), 10.f, false, @DecideWinnersAction );
}

void OnAnyWidgetDeath( )
{
	widget w_d = GetTriggerWidget( );

	switch( GetHandleBaseTypeId( w_d ) )
	{
		case '+w3w': // any widget, unused
		{
			return;
		}
		case 'item':
		{
			item itm = GetTriggerItem( );
			OnProcessItemState( itm );

			return;
		}
		case '+w3d':
		{
			destructable dest = GetTriggerDestructable( );

			return;
		}
		case '+w3u':
		{
			unit killer = GetKillingUnit( );
			player k_p = GetOwningPlayer( killer );
			int k_pid = GetPlayerId( k_p );
			int kp_hid = GetHandleId( k_p );
			int k_team = GetPlayerTeam( k_p );
			unit dying = GetDyingUnit( );
			int d_hid = GetHandleId( dying );
			int d_uid = GetUnitTypeId( dying );
			player d_p = GetOwningPlayer( dying );
			int d_pid = GetPlayerId( d_p );
			int d_team = GetPlayerTeam( d_p );

			if ( d_uid == 'n000' )
			{
				unit source = KawarimiTriggerUnitArray[ d_pid ];

				SetUnitInvulnerable( source, false );
				ShowUnit( source, true );
				PauseUnit( source, false );

				GroupEnumUnitsInRange( GroupEnum, GetUnitX( dying ), GetUnitY( dying ), 300.f, nil );

				for( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
				{
					if ( IsUnitDead( u ) || IsUnitAlly( u, d_p ) ) { continue; }
					ACF_AddBuffTimed( u, 'BPSE', 2.f );
				}

				DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", GetUnitX( dying ), GetUnitY( dying ) ) );
				ACF_SelectUnit( source, d_p );

				return;
			}

			if ( IsUnitType( dying, UNIT_TYPE_HERO ) )
			{
				int d_lvl = GetHeroLevel( dying );
				unit mainBoss = LoadUnitHandle( DataHT, 'BOSS', 'unit' );

				if ( killer == mainBoss )
				{
					SetHeroStr( killer, GetHeroStr( killer, false ) + d_lvl * 2, true );
					SetHeroAgi( killer, GetHeroAgi( killer, false ) + d_lvl * 2, true );
					SetHeroInt( killer, GetHeroInt( killer, false ) + d_lvl * 2, true );
					SetUnitCurrentLife( killer, GetUnitCurrentLife( killer ) + GetUnitMaxLife( killer ) * d_lvl * .01f );
					DestroyEffect( AddSpecialEffect( "Characters\\Arcueid\\ArcueidREffect1.mdl", GetUnitX( killer ), GetUnitY( killer ) ) );
					DestroyEffect( AddSpecialEffect( "Characters\\Arcueid\\ArcueidREffect2.mdl", GetUnitX( killer ), GetUnitY( killer ) ) );
				}

				if ( dying == mainBoss )
				{
					DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 10.f, PlayerColoredNameArray[ k_pid ] + " |c008080c0Killed|r " + "|c0000FF00" + GetHeroProperName( dying ) );
					PrepareFinishGameAction( k_team );
					return;
				}

				if ( GetPlayerSlotState( d_p ) == PLAYER_SLOT_STATE_PLAYING )
				{
					timer tmr = CreateTimer( );
					int hid = GetHandleId( tmr );
					effect ef = AddSpecialEffect( "GeneralEffects\\UnitEffects\\DeathIndicator.mdl", GetUnitX( dying ), GetUnitY( dying ) );
					SetSpecialEffectHeight( ef, 150.f );

					SavePlayerHandle( GameHT, hid, '+ply', d_p );
					SaveUnitHandle( GameHT, hid, 'usrc', dying );
					SaveEffectHandle( GameHT, hid, 'efct', ef );
					TimerStart( tmr, 4.f, false, 
						function( )
						{
							timer tmr = GetExpiredTimer( );
							int hid = GetHandleId( tmr );
							player p = LoadPlayerHandle( GameHT, hid, '+ply' );
							unit u = LoadUnitHandle( GameHT, hid, 'usrc' );
							float x = GetPlayerTeam( p ) == 0 ? -4288.f : 4288.f;

							DestroyEffect( LoadEffectHandle( GameHT, hid, 'efct' ) );
							ReviveHero( u, x, -576.f, true );
							SetUnitFlyHeightEx( u, 0.f, 2000.f );
							ACF_SelectUnit( u, p );
							ACF_PanCameraToTimed( p, GetUnitX( u ), GetUnitY( u ), .2f );

							if ( GetPlayerController( p ) == MAP_CONTROL_COMPUTER )
							{
								IssuePointOrder( u, "attack", GetRandomReal( -1900.f, 1900.f ), GetRandomReal( -1200.f, 200.f ) );
							}

							PauseTimer( tmr );
							FlushChildHashtable( GameHT, hid );
							DestroyTimer( tmr );
						}
					 );
				}

				int side = LoadInteger( DataHT, d_hid, 'side' );

				if ( side == 'lbos' || side == 'rbos' )
				{
					BossesKilledIntegerArray[ k_pid ]++;
					DisplayTextToPlayer( k_p, .0f, .0f, "|cFFFFCC00Bosses Killed:|r |c00ff8040" + I2S( BossesKilledIntegerArray[ k_pid ] ) + "|r" );
					SetPlayerState( k_p, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState( k_p, PLAYER_STATE_RESOURCE_LUMBER ) + 1 );
					if ( BossesKilledIntegerArray[ k_pid ] == 8 )
					{
						DisplayTextToPlayer( GetLocalPlayer( ), 0, 0, PlayerColoredNameArray[k_pid] + "|r has earnt enough kills for -T command" );
						SaveBoolean( GameHT, kp_hid, 'ISTP', true );
					}

					FlushChildHashtable( DataHT, d_hid );
					
					int id = LoadInteger( DataHT, d_hid, 'indx' );

					if ( id >= 0 && id <= 7 )
					{
						timer tmr = CreateTimer( );
						int hid = GetHandleId( tmr );

						SaveInteger( GameHT, hid, 'side', side );
						SaveInteger( GameHT, hid, 'indx', id );
						
						TimerStart( tmr, 10.f, false,
							function( )
							{
								timer tmr = GetExpiredTimer( );
								int hid = GetHandleId( tmr );
								int side = LoadInteger( GameHT, hid, 'side' );
								int i = LoadInteger( GameHT, hid, 'indx' );
								
								BossSystem::CreateSide( i + 1, side );

								FlushChildHashtable( GameHT, hid );
								DestroyTimer( tmr );
							}
						 );
					}

					return;
				}

				if ( !IsPlayerAlly( k_p, d_p ) )
				{
					multiboarditem mbItem;
					int mbIndex = 0;

					if ( k_p != Player( PLAYER_NEUTRAL_AGGRESSIVE ) && GetUnitTypeId( killer ) != 'base' )
					{
						mbIndex = k_pid + ( d_team == 0 ? 2 : 1 );
					
						DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, PlayerColoredNameArray[ k_pid ] + " |c008080c0Killed|r " + PlayerColoredNameArray[ d_pid ] );
						KillingUnitIntegerArray[mbIndex]++;
						TeamKills[k_team]++;
						
						mbItem = MultiboardGetItem( MainMultiboard, mbIndex, 1 );
						MultiboardSetItemValue( mbItem, PlayerColorStringArray[ k_pid ] + I2S( KillingUnitIntegerArray[mbIndex] ) );
						MultiboardReleaseItem( mbItem );

						mbItem = MultiboardGetItem( MainMultiboard, d_team == 0 ? 5 : 0, 1 );
						MultiboardSetItemValue( mbItem, I2S( TeamKills[k_team] ) );
						MultiboardReleaseItem( mbItem );
					}

					mbIndex = d_pid + ( d_team == 1 ? 2 : 1 );

					DyingUnitIntegerArray[mbIndex]++;
					TeamDeaths[d_team]++;

					mbItem = MultiboardGetItem( MainMultiboard, mbIndex, 2 );
					MultiboardSetItemValue( mbItem, PlayerColorStringArray[ d_pid ] + I2S( DyingUnitIntegerArray[mbIndex] ) );
					MultiboardReleaseItem( mbItem );
					
					mbItem = MultiboardGetItem( MainMultiboard, d_team == 1 ? 5 : 0, 2 );
					MultiboardSetItemValue( mbItem, I2S( TeamDeaths[d_team] ) );
					MultiboardReleaseItem( mbItem );
					MultiboardSetTitleText( MainMultiboard, "|Cff00ff00Scoreboard|r |c00ff0000" + I2S( TeamKills[0] ) + "|r/|c000000ff" + I2S( TeamKills[1] ) + "|r" );
				}

				if ( TeamKills[0] >= KillLimit || TeamKills[1] >= KillLimit )
				{
					if ( TeamKills[0] >= KillLimit )
					{
						PrepareFinishGameAction( 0 );
					}
					else if ( TeamKills[1] >= KillLimit )
					{
						PrepareFinishGameAction( 1 );
					}
				}
			}


			return;
		}
	}
}

void BossCheckInit( )
{
	TimerStart( CreateTimer( ), 1.f, true, 
		function( )
		{
			unit u = LoadUnitHandle( DataHT, 'BOSS', 'unit' ); if ( IsUnitDead( u ) ) { DestroyTimer( GetExpiredTimer( ) ); return; }
			float x = GetUnitX( u );
			float y = GetUnitY( u );

			if ( !( x >= -544.f && x <= 544.f && y >= -4100.f && y <= -2800.f ) )
			{
				DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", x, y ) );
				x = .0f;
				y = -3850.f;
				SetUnitXY( u, x, y );
				DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", x, y ) );
			}
		}
	 );
}

void MultiBoardCreationFunction1( )
{
	DisplayTimedTextToPlayer( GetLocalPlayer( ), 0.f, 0.f, 5.f, "|c00ff0000Welcome to Anime Character Fight|r
	|c00ff0000Wish you an amazing victory: |r|c0000ffffor a sweet defeat : )|r
	|c00ff0000SO!: |r|c0000ffffFor spells sounds download patch from vk.com/acfwc3 or chaosrealm.info!|r" );
	MainMultiboard = CreateMultiboard( );
	MultiboardSetRowCount( MainMultiboard, 11 );
	MultiboardSetColumnCount( MainMultiboard, 3 );
	MultiboardSetTitleText( MainMultiboard, "|Cff00ff00Scoreboard|r |c00ff0000" + I2S( TeamKills[0] ) + "|r/|c000000ff" + I2S( TeamKills[1] ) + "|r" );
	MultiboardDisplay( MainMultiboard, true );

	multiboarditem mbItem = MultiboardGetItem( MainMultiboard, 10, 0 );
	MultiboardSetItemWidth( mbItem, 12.f / 100.f );
	MultiboardReleaseItem( mbItem );
	mbItem = MultiboardGetItem( MainMultiboard, 10, 1 );
	MultiboardSetItemWidth( mbItem, 12.f / 100.f );
	MultiboardReleaseItem( mbItem );
	int i = 0;
	int j = 0;
	while ( true )
	{
		if ( i > 9 ) break;
		mbItem = MultiboardGetItem( MainMultiboard, i, 0 );
		MultiboardSetItemWidth( mbItem, 12 / 100.0f );
		MultiboardReleaseItem( mbItem );
		mbItem = MultiboardGetItem( MainMultiboard, i, 1 );
		MultiboardSetItemWidth( mbItem, 4 / 100.0f );
		MultiboardReleaseItem( mbItem );
		mbItem = MultiboardGetItem( MainMultiboard, i, 2 );
		MultiboardSetItemWidth( mbItem, 4 / 100.0f );
		MultiboardReleaseItem( mbItem );
		if ( i == 0 || i == 5 )
		{
			mbItem = MultiboardGetItem( MainMultiboard, i, 1 );
			MultiboardSetItemValue( mbItem, "0" );
			MultiboardReleaseItem( mbItem );
			mbItem = MultiboardGetItem( MainMultiboard, i, 2 );
			MultiboardSetItemValue( mbItem, "0" );
			MultiboardReleaseItem( mbItem );
			mbItem = MultiboardGetItem( MainMultiboard, i, 1 );
			MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNTransmute.blp" );
			MultiboardReleaseItem( mbItem );
			mbItem = MultiboardGetItem( MainMultiboard, i, 2 );
			MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNDeathCoil.blp" );
			MultiboardReleaseItem( mbItem );
		}
		if ( i != 0 && i != 5 )
		{
			mbItem = MultiboardGetItem( MainMultiboard, i, 0 );
			if ( GetPlayerSlotState( Player( j ) ) == PLAYER_SLOT_STATE_PLAYING )
			{
				MultiboardSetItemValue( mbItem, PlayerColoredNameArray[j] + "|r" );
			}
			else
			{
				MultiboardSetItemValue( mbItem, PlayerColorStringArray[j] + "- Empty Slot -|r" );
			}
			MultiboardSetItemIcon( mbItem, "UI\\Widgets\\Console\\Human\\CommandButton\\human-button-lvls-overlay.blp" );
			MultiboardReleaseItem( mbItem );
			mbItem = MultiboardGetItem( MainMultiboard, i, 1 );
			MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp" );
			MultiboardReleaseItem( mbItem );
			mbItem = MultiboardGetItem( MainMultiboard, i, 2 );
			MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNFrostArmor.blp" );
			MultiboardReleaseItem( mbItem );
			mbItem = MultiboardGetItem( MainMultiboard, i, 1 );
			MultiboardSetItemValue( mbItem, PlayerColorStringArray[j] + "0" + "|r" );
			MultiboardReleaseItem( mbItem );
			mbItem = MultiboardGetItem( MainMultiboard, i, 2 );
			MultiboardSetItemValue( mbItem, PlayerColorStringArray[j] + "0" + "|r" );
			MultiboardReleaseItem( mbItem );
			j++;
		}
		i++;
	}
	mbItem = MultiboardGetItem( MainMultiboard, 0, 0 );
	MultiboardSetItemValue( mbItem, "|c00ff0000RED|r TEAM" );
	MultiboardReleaseItem( mbItem );
	mbItem = MultiboardGetItem( MainMultiboard, 5, 0 );
	MultiboardSetItemValue( mbItem, "|c000000ffBLUE|r TEAM" );
	MultiboardReleaseItem( mbItem );
	mbItem = MultiboardGetItem( MainMultiboard, 10, 0 );
	MultiboardSetItemValue( mbItem, "Kills: Undecided" );
	MultiboardReleaseItem( mbItem );
	mbItem = MultiboardGetItem( MainMultiboard, 10, 1 );
	MultiboardSetItemValue( mbItem, "0:0:0" );
	MultiboardReleaseItem( mbItem );
	mbItem = MultiboardGetItem( MainMultiboard, 0, 0 );
	MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNOrbofSlowness.blp" );
	MultiboardReleaseItem( mbItem );
	mbItem = MultiboardGetItem( MainMultiboard, 5, 0 );
	MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNMoonStone.blp" );
	MultiboardReleaseItem( mbItem );
	mbItem = MultiboardGetItem( MainMultiboard, 10, 0 );
	MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNLament.blp" );
	MultiboardReleaseItem( mbItem );
	mbItem = MultiboardGetItem( MainMultiboard, 10, 1 );
	MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\WorldeditUI\\Events-time.blp" );
	MultiboardReleaseItem( mbItem );
	MultiboardDisplay( MainMultiboard, true );
}

void InGameTimerAction( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int secs = LoadInteger( GameHT, hid, 'secs' );
	int mins = LoadInteger( GameHT, hid, 'mins' );
	int hours = LoadInteger( GameHT, hid, 'hors' );

	if ( secs == 59 )
	{
		SaveInteger( GameHT, hid, 'secs', 0 );
		SaveInteger( GameHT, hid, 'mins', mins + 1 );
	}
	else
	{
		SaveInteger( GameHT, hid, 'secs', secs + 1 );
	}

	if ( mins == 59 )
	{
		SaveInteger( GameHT, hid, 'mins', 0 );
		SaveInteger( GameHT, hid, 'hors', hours + 1 );
	}

	multiboarditem mbitem = MultiboardGetItem( MainMultiboard, 10, 1 );
	MultiboardSetItemValue( mbitem, I2S( hours ) + ":" + I2S( mins ) + ":" + I2S( secs ) );
	MultiboardReleaseItem( mbitem );
}

void KillSelectionDialogAction( )
{
	int i = 0;
	while ( true )
	{
		if ( i > 8 ) break;
		if ( GetClickedButton( ) == SameHeroModeButtonArray[i] )
		{
			MBArr1[i] = MBArr1[i] + 1;
		}
		i++;
	}
}

void KillSelectionTimerExpireAction( )
{
	int voteMax = 0;
	int votes = 0;
	int voteId = 0;
	int index = 0;
	bool isTied = false;

	DialogShow( KillSelectionDialog, false );
	DialogClear( KillSelectionDialog );
	DialogDestroy( KillSelectionDialog );
	TimerDialogDisplay( ModeSelectionTD, false );
	DestroyTimerDialog( ModeSelectionTD );
	MultiboardDisplay( MainMultiboard, true );

	while ( true )
	{
		if ( index > 8 ) break;
		if ( MBArr1[index] > 0 )
		{
			votes = votes + 1;
		}
		if ( MBArr1[index] == voteMax )
		{
			isTied = true;
		}
		if ( MBArr1[index] > voteMax )
		{
			voteMax = MBArr1[index];
			voteId = index;
			isTied = false;
		}
		index++;
	}

	if ( voteId == 0 )
	{
		KillLimit = 20 * GetRandomInt( 1, 7 );
	}
	else if ( voteId == 8 )
	{
		KillLimit = 999999999;
	}
	else if ( voteId != 0 && voteId != 8 )
	{
		KillLimit = 20 * voteId;
	}

	if ( isTied || votes <= 0 )
	{
		if ( TotalPlayers <= 1 )
		{
			KillLimit = 999999999;
		}
		else
		{
			KillLimit = TotalPlayers * 20 - 20;
		}
	}

	if ( votes > 0 )
	{
		DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, "
		|cFFFFCC00Votes for |c0000ffff[Random]|r|cFFFFCC00:|r |c0000ffff" + I2S( MBArr1[0] ) + "|r
		|cFFFFCC00Votes for |c0000ffff[20 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S( MBArr1[1] ) + "|r
		|cFFFFCC00Votes for |c0000ffff[40 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S( MBArr1[2] ) + "|r
		|cFFFFCC00Votes for |c0000ffff[60 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S( MBArr1[3] ) + "|r
		|cFFFFCC00Votes for |c0000ffff[80 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S( MBArr1[4] ) + "|r
		|cFFFFCC00Votes for |c0000ffff[100 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S( MBArr1[5] ) + "|r
		|cFFFFCC00Votes for |c0000ffff[120 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S( MBArr1[6] ) + "|r
		|cFFFFCC00Votes for |c0000ffff[140 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S( MBArr1[7] ) + "|r
		|cFFFFCC00Votes for |c0000ffff[Unlimited Kills]|cFFFFCC00:|r |c0000ffff" + I2S( MBArr1[8] ) + "|r" );
	}

	multiboarditem mbItem = MultiboardGetItem( MainMultiboard, 10, 0 );

	if ( KillLimit != 999999999 )
	{
		DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, "|cFFFFCC00Kill Limit is:|r |c0000ffff[" + I2S( KillLimit ) + "]|r |cFFFFCC00Kills|r" );
		MultiboardSetItemValue( mbItem, "Kills: " + I2S( KillLimit ) );
	}
	else
	{
		DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, "|cFFFFCC00Kill Limit is:|r |c0000ffff[Unlimited]|r |cFFFFCC00Kills.|r" );
		MultiboardSetItemValue( mbItem, "Kills: Unlimited" );
	}

	MultiboardReleaseItem( mbItem );
	EnableTrigger( TR_HeroSelection );
	DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, "|c0000ffffHero Selection has been activated!|r" );
	MultiboardDisplay( MainMultiboard, false );
	MultiboardDisplay( MainMultiboard, true );
	TimerStart( CreateTimer( ), 1, true, @InGameTimerAction );
}

void KillSelectionAction( )
{
	DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, "|c0000ffffAttention to All Players!

	You have 5 seconds to choose desirable Kill Limit" );
	ModeSelectionTD = CreateTimerDialog( KillSelectionTimer );
	TimerDialogSetTitle( ModeSelectionTD, "|c00ffff00Kill Limit Selection" );
	TimerDialogDisplay( ModeSelectionTD, true );
	TimerStart( KillSelectionTimer, 5, false, @KillSelectionTimerExpireAction );
	DialogSetMessage( KillSelectionDialog, "Select Kill Limit" );
	SameHeroModeButtonArray[0] = DialogAddButton( KillSelectionDialog, "Random", 0 );
	SameHeroModeButtonArray[1] = DialogAddButton( KillSelectionDialog, "20 Kills [1 vs 1]", 0 );
	SameHeroModeButtonArray[2] = DialogAddButton( KillSelectionDialog, "40 Kills", 0 );
	SameHeroModeButtonArray[3] = DialogAddButton( KillSelectionDialog, "60 Kills [2 vs 2]", 0 );
	SameHeroModeButtonArray[4] = DialogAddButton( KillSelectionDialog, "80 Kills", 0 );
	SameHeroModeButtonArray[5] = DialogAddButton( KillSelectionDialog, "100 Kills [3 vs 3]", 0 );
	SameHeroModeButtonArray[6] = DialogAddButton( KillSelectionDialog, "120 Kills", 0 );
	SameHeroModeButtonArray[7] = DialogAddButton( KillSelectionDialog, "140 Kills [4 vs 4]", 0 );
	SameHeroModeButtonArray[8] = DialogAddButton( KillSelectionDialog, "Unlimited Kills", 0 );
	DialogShow( KillSelectionDialog, true );
}

void ModeSelectionFunction2( )
{
	button but = GetClickedButton( );

	if ( but == SameHeroModeButtonArray[10] )
	{
		MBArr1[10]++;
	}
	else if ( but == SameHeroModeButtonArray[11] )
	{
		MBArr1[11]++;
	}
}

void ModeSelectionFunction3( )
{
	DialogShow( ModeSelectionDialog, false );
	DialogClear( ModeSelectionDialog );
	DialogDestroy( ModeSelectionDialog );
	TimerDialogDisplay( ModeSelectionTD, false );
	MultiboardDisplay( MainMultiboard, true );
	DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, "|cFFFFCC00Same u Mode Results:
	For:|r |c0000ffff" + I2S( MBArr1[10] ) + "|r |cFFFFCC00Against:|r |c0000ffff" + I2S( MBArr1[11] ) + "|r" );

	if ( MBArr1[10] > MBArr1[11] )
	{
		SameHeroBoolean = true;
		DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, "|c0000FF00Same u Mode Enabled!" );
	}
	else
	{
		DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, "|c00ff0000Same u Mode Disabled!" );
	}

	TimerStart( KillSelectionTimer, 1.f, false, @KillSelectionAction );
}

void ModeSelectionFunction1( )
{
	timer tmr = CreateTimer( );
	DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, "|c00FFFF00Hero Selection is disabled
	To enable it:
	Choose desirable kills and mode|r" );
	ModeSelectionTD = CreateTimerDialog( tmr );
	TimerDialogSetTitle( ModeSelectionTD, "|c00ffff00Mode Selection" );
	TimerDialogDisplay( ModeSelectionTD, true );
	DialogSetMessage( ModeSelectionDialog, "Same u Mode" );
	SameHeroModeButtonArray[10] = DialogAddButton( ModeSelectionDialog, "|c0000FF00Enable|r", 0 );
	SameHeroModeButtonArray[11] = DialogAddButton( ModeSelectionDialog, "|c00ff0000Disable|r", 0 );
	DialogShow( ModeSelectionDialog, true );
	TimerStart( tmr, 5, false, @ModeSelectionFunction3 );
}

void RegisterPlayerLeaveAction( )
{
	player p = GetTriggerPlayer( );
	int pid = GetPlayerId( p );
	int teamId = GetPlayerTeam( p );
	int count = TeamPlayers[teamId] - 1;
	int gold = count > 0 ? ( GetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD ) / ( TeamPlayers[teamId] - 1 ) ) : 0;
	int mbId = teamId == 0 ? pid + 1 : pid + 2;

	multiboarditem mbItem = MultiboardGetItem( MainMultiboard, mbId, 0 );
	MultiboardSetItemValue( mbItem, PlayerColorStringArray[pid] + "- Left -|r" );
	MultiboardReleaseItem( mbItem );

	TotalPlayers = TotalPlayers - 1;
	TeamPlayers[teamId] = TeamPlayers[teamId] - 1;
	DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 5.f, PlayerColoredNameArray[pid] + "|r Has left the game!" );
	RemoveUnit( MUnitArray[pid] );
	RemovePlayer( p, PLAYER_GAME_RESULT_DEFEAT );

	if ( gold > 0 )
	{
		for( int i = 0; i < PLAYER_NEUTRAL_AGGRESSIVE; i++ )
		{
			player p2 = Player( i ); if ( GetPlayerSlotState( p2 ) != PLAYER_SLOT_STATE_PLAYING || !IsPlayerAlly( p, p2 ) ) { continue; }
			SetPlayerState( p2, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( p2, PLAYER_STATE_RESOURCE_GOLD ) + gold );
		}
		DisplayTextToPlayer( GetLocalPlayer( ), .0f, .0f, "Each player in Team " + I2S( teamId + 1 ) + " has received |cFFFFCC00" + I2S( gold ) + "|r gold from a leaver." );
	}

	if ( TeamPlayers[teamId] == 0 )
	{
		PrepareFinishGameAction( teamId == 0 ? 1 : 0 );
	}
}

void DisableSharedUnitsAct( )
{
	for ( int i = 0; i < PLAYER_NEUTRAL_AGGRESSIVE; i++ )
	{
		for ( int j = 0; j < PLAYER_NEUTRAL_AGGRESSIVE; j++ )
		{
			player p1 = Player( i );
			player p2 = Player( j );

			if ( p1 == p2 ) { continue; }

			SetPlayerAlliance( p1, p2, ALLIANCE_SHARED_CONTROL, false );
		}
	}
}



void CreepSpawn3Action( )
{
	if ( !B_IsCreepSpawn ) { return; }

	player p = Player( PLAYER_NEUTRAL_AGGRESSIVE );

	for ( int i = 0; i < 4; i++ )
	{
		if ( i < 2 )
		{
			CreateUnit( p, 'h003', -1888.f, -160.f, 270 );
			CreateUnit( p, 'h004', -1888.f, -864.f, 270 );
			CreateUnit( p, 'h007', -1184.f, -864.f, 270 );
			CreateUnit( p, 'h015', 384.f, -896.f, 270 );
			CreateUnit( p, 'h003', 1888.f, -160.f, 270 );
			CreateUnit( p, 'h007', 1184.f, -864.f, 270 );
			CreateUnit( p, 'h004', 1888.f, -896.f, 270 );
		}
		else if ( i < 3 )
		{
			CreateUnit( p, 'h009', -1888.f, -160.f, 270 );
			CreateUnit( p, 'h016', -1888.f, -896.f, 270 );
			CreateUnit( p, 'h001', -1184.f, -896.f, 270 );
			CreateUnit( p, 'h016', -384.f, -160.f, 270 );
			CreateUnit( p, 'h001', 384.f, -160.f, 270 );
			CreateUnit( p, 'h009', -384.f, -896.f, 270 );
			CreateUnit( p, 'h009', 1888.f, -160.f, 270 );
			CreateUnit( p, 'h001', 1184.f, -896.f, 270 );
			CreateUnit( p, 'h016', 1888.f, -896.f, 270 );
		}

		CreateUnit( p, 'h015', -1184.f, -160.f, 270 );
		CreateUnit( p, 'h015', 1184.f, -160.f, 270 );
	}
}

void CreepUpgrade2Action( )
{
	PauseTimer( CreepSpawnerTimer1 );
	TimerStart( CreepSpawnerTimer1, 90.f, true, @CreepSpawn3Action );
}

void CreepSpawn2Action( )
{
	if ( !B_IsCreepSpawn ) { return; }

	player p = Player( PLAYER_NEUTRAL_AGGRESSIVE );

	for ( int i = 0; i < 6; i++ )
	{
		if ( i < 5 )
		{
			CreateUnit( p, 'h008', -1888.f, -160.f, 270 );
			CreateUnit( p, 'h002', -1888.f, -896.f, 270 );
			CreateUnit( p, 'h000', -1184.f, -896.f, 270 );
			CreateUnit( p, 'h002', -384.f, -160.f, 270 );
			CreateUnit( p, 'h000', 384.f, -160.f, 270 );
			CreateUnit( p, 'h014', 384.f, -896.f, 270 );
			CreateUnit( p, 'h008', -384.f, -896.f, 270 );
			CreateUnit( p, 'h008', 1888.f, -160.f, 270 );
			CreateUnit( p, 'h000', 1184.f, -896.f, 270 );
			CreateUnit( p, 'h002', 1888.f, -896.f, 270 );
		}
		CreateUnit( p, 'h014', -1184.f, -160.f, 270 );
		CreateUnit( p, 'h014', 1184.f, -160.f, 270 );
	}
}

void CreepUpgrade1Action( )
{
	PauseTimer( CreepSpawnerTimer1 );
	TimerStart( CreepUpgradeTimer1, 600.f, false, @CreepUpgrade2Action );
	TimerStart( CreepSpawnerTimer1, 60.f, true, @CreepSpawn2Action );
}

void CreepSpawn1Action( )
{
	if ( !B_IsCreepSpawn ) { return; }

	player p = Player( PLAYER_NEUTRAL_AGGRESSIVE );

	for ( int i = 0; i < 4; i++ )
	{
		if ( i < 2 )
		{
			CreateUnit( p, 'h011', -1888.f, -896.f, 270 );
			CreateUnit( p, 'h011', -384.f, -896.f, 270 );
			CreateUnit( p, 'h011', 1888.f, -896.f, 270 );
		}
		CreateUnit( p, 'h010', 384.f, -896.f, 270 );
		CreateUnit( p, 'h010', 1184.f, -896.f, 270 );
		CreateUnit( p, 'h010', -1184.f, -896.f, 270 );
		CreateUnit( p, 'h012', -1184.f, -160.f, 270 );
		CreateUnit( p, 'h012', 1888.f, -160.f, 270 );
		CreateUnit( p, 'h012', 384.f, -160.f, 270 );
		CreateUnit( p, 'h013', -1888.f, -160.f, 270 );
		CreateUnit( p, 'h013', -384.f, -160.f, 270 );
		CreateUnit( p, 'h013', 1184.f, -160.f, 270 );
	}
}

void UnitCreationAction( )
{
	TimerStart( CreepUpgradeTimer1, 300.f, false, @CreepUpgrade1Action );
	TimerStart( CreepSpawnerTimer1, 30.f, true, @CreepSpawn1Action );
}

bool UnitCreationWithCircleCond( )
{
	return IsUnitType( GetEnteringUnit( ), UNIT_TYPE_HERO );
}

int SpawnNPCAtLimited( int uid, int toCreate, float minX, float maxX, float minY, float maxY, int lim )
{
	int count = 0;
	player p = Player( PLAYER_NEUTRAL_AGGRESSIVE );

	for ( int i = 0; i < MathIntegerClamp( toCreate, 0, lim - CountUnitInGroupOfPlayer( p, uid ) ); i++ )
	{
		CreateUnit( p, uid, GetRandomReal( minX, maxX ), GetRandomReal( minY, maxY ), GetRandomReal( 0.f, 360.f ) );
		count++;
	}

	return count;
}

void PrintNPCSpawn( player p, int count = 0 )
{
	DisplayTextToPlayer( p, .0f, .0f, count > 0 ? "|c00CBFF75NPC Spawned" : "|c00ff0000Maximum amount of units was reached!" );
}

void OnAnyUnitEnterRegion( unit u, region reg, rect rec )
{
	player p = GetOwningPlayer( u );
	float x = GetUnitX( u );
	float y = GetUnitY( u );

	if ( reg == LoadRegionHandle( DataHT, 'regs', 'BASE' ) )
	{
		if ( IsUnitIllusion( u ) || ( !IsUnitType( u, UNIT_TYPE_HERO ) && p == Player( PLAYER_NEUTRAL_AGGRESSIVE ) ) )
		{
			KillUnit( u );
		}

		return;
	}

	if ( rec == CircleRectArr[0] || rec == CircleRectArr[1] || rec == CircleRectArr[3] || rec == CircleRectArr[4] ) // spawner enter
	{
		if ( !IsUnitType( u, UNIT_TYPE_HERO ) ) { return; }

		int npcCount = -1;

		if ( rec == CircleRectArr[0] )
		{
			npcCount = SpawnNPCAtLimited( 'h022', 9, -5632.f, -3136.f, 1088.f, 3136.f, 160 );
		}
		else if ( rec == CircleRectArr[1] )
		{
			npcCount = SpawnNPCAtLimited( 'h018', 1, -5632.f, -3008.f, -4160.f, -2176.f, 30 ) + SpawnNPCAtLimited( 'h021', 1, -5632.f, -3008.f, -4160.f, -2176.f, 30 );
		}
		else if ( rec == CircleRectArr[3] )
		{
			npcCount = SpawnNPCAtLimited( 'h017', 9, 3072.f, 5632.f, -4160.f, -2208.f, 160 );
		}
		else if ( rec == CircleRectArr[4] )
		{
			npcCount = SpawnNPCAtLimited( 'h020', 1, 3200.f, 5664.f, 1120.f, 3168.f, 30 ) + SpawnNPCAtLimited( 'h023', 1, 3200.f, 5664.f, 1120.f, 3168.f, 30 );
		}

		if ( npcCount >= 0 )
		{
			PrintNPCSpawn( p, npcCount );
		}

		return;
	}
}

void SaveUnitAxis( player p, bool checkEsc = false )
{
	int pid = GetPlayerId( p );
	int hid = GetHandleId( p );

	if ( !checkEsc || ESCLocationSaveBooleanArray[pid] )
	{
		DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffCurrent location was saved!" );
		SaveReal( DataHT, hid, '+tpX', GetUnitX( MUnitArray[pid] ) );
		SaveReal( DataHT, hid, '+tpY', GetUnitY( MUnitArray[pid] ) );
	}
}

void ESCToSaveAction( )
{
	SaveUnitAxis( GetTriggerPlayer( ), true );
}

void HealthDisplayReaderAction( )
{
	player p = GetTriggerPlayer( );
	int pid = GetPlayerId( p );
	unit u = GetTriggerUnit( );
	int hpMax = R2I( GetUnitMaxLife( u ) );

	if ( HealthDisplayBooleanArray[ pid ] && hpMax >= 10000 && GetOwningPlayer( u ) != Player( PLAYER_NEUTRAL_PASSIVE ) && GetUnitTypeId( u ) != 'n000' )
	{
		DisplayTextToPlayer( p, .0f, .0f, "|c0000ffff" + ( IsUnitType( u, UNIT_TYPE_HERO ) ? GetHeroProperName( u ) : GetUnitName( u ) ) + "|r has: |cFFFFCC00[" + I2S( hpMax ) + "]|r |c0000ffffHP|r" );
	}
}

void HeroProcessAbilityDisplay( unit u, bool forceHide )
{
	int ulvl = GetUnitLevel( u );
	int hid = GetHandleId( u );

	string abils = GetUnitStringField( u, UNIT_SF_ABILITY_LIST );
	array<string>@ abilList = abils.split( "," );

	//print( "abils = " + abils + " " + "abilList.length( ) = " + I2S( abilList.length( ) ) + "\n" );

	for ( uint i = 0; i < abilList.length( ); i++ )
	{
		int aid = String2Id( abilList[i] );

		switch( aid )
		{
			case 'AInv': break;
			default:
			{
				bool isShow = true;
				//print( "aid: " + Id2String( aid ) + " -> reqLvL = " + I2S( GetAbilityBaseIntegerFieldById( aid, ABILITY_IF_REQUIRED_LEVEL ) ) + "\n" );

				if ( forceHide )
				{
					if ( GetAbilityBaseIntegerFieldById( aid, ABILITY_IF_REQUIRED_LEVEL ) > 1 )
					{
						ShowUnitAbility( u, aid, false );
					}
				}
				else
				{
					int reqLvL = GetAbilityBaseIntegerFieldById( aid, ABILITY_IF_REQUIRED_LEVEL ); if ( reqLvL == 0 ) { continue; }
					ShowUnitAbility( u, aid, ulvl >= reqLvL );
				}

				break;
			}
		}
	}
}

void HeroUnlockAbilities( unit u )
{
	HeroProcessAbilityDisplay( u, false );
}

void OnHeroLevel( )
{
	unit u = GetLevelingUnit( );
	player p = GetOwningPlayer( u );
	int ulvl = GetUnitLevel( u );
	int uid = GetUnitTypeId( u );
	int hid = GetHandleId( u );
	int statCount = 0;

	DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\LevelUp.mdl", u, "origin" ) );

	HeroUnlockAbilities( u );

	if ( GetPlayerController( p ) != MAP_CONTROL_COMPUTER )
	{
		if ( GetUnitLevel( u ) >= 50 )
		{
			SetHeroStr( u, GetHeroStr( u, false ) + 3, true );
			SetHeroAgi( u, GetHeroAgi( u, false ) + 3, true );
			SetHeroInt( u, GetHeroInt( u, false ) + 3, true );
			SuspendHeroXP( u, true );
		}
	}
	else
	{
		if ( GetAIDifficulty( p ) == AI_DIFFICULTY_NEWBIE )
		{
			statCount = 2;
		}
		else if ( GetAIDifficulty( p ) == AI_DIFFICULTY_NORMAL )
		{
			statCount = 3;
		}
		else if ( GetAIDifficulty( p ) == AI_DIFFICULTY_INSANE )
		{
			statCount = 5;
		}

		if ( ulvl >= 5 && ulvl < 10 )
		{
			statCount = statCount * 2;
		}
		else if ( ulvl >= 10 && ulvl < 15 )
		{
			statCount = statCount * 3;
		}
		else if ( ulvl >= 15 )
		{
			statCount = statCount * 5;
		}

		SetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD ) + 50 * statCount );
		SetHeroStr( u, GetHeroStr( u, false ) + statCount, true );
		SetHeroAgi( u, GetHeroAgi( u, false ) + statCount, true );
		SetHeroInt( u, GetHeroInt( u, false ) + statCount, true );
	
		switch( ulvl )
		{
			case 5: UnitAddItemById( u, 'I03U' ); break;
			case 8: UnitAddItemById( u, 'I03X' ); break;
			case 10: UnitAddItemById( u, 'I03Z' ); break;
			case 13: UnitAddItemById( u, 'I00H' ); break;
			case 15:
			{
				UnitAddItemById( u, LoadInteger( DataHT, GetUnitTypeId( u ), 'pitm' ) );

				break;
			}
			case 20: UnitAddItemById( u, 'I03V' ); break;
			case 21: UnitAddItemById( u, 'I03Z' ); break;
			case 25: UnitAddItemById( u, 'I00X' ); break;
			case 27: UnitAddItemById( u, 'I00T' ); break;
		}
	}
}

// MUI related functions
int SpellTickEx( hashtable ht, int hid )
{
	int tick = LoadInteger( ht, hid, 'tick' ); if ( LoadBoolean( ht, hid, 'skip' ) ) { return tick; }
	SaveInteger( ht, hid, 'tick', tick + 1 );
	return tick;
}

int SpellTickEx( int hid )
{
	return SpellTickEx( GameHT, hid );
}

bool CounterEx( int hid, int id, int max )
{
	int count = LoadInteger( GameHT, hid, 'icnt' + id );

	if ( !LoadBoolean( GameHT, hid, 'bcnt' + id ) )
	{
		SaveBoolean( GameHT, hid, 'bcnt' + id, true );
		return true;
	}

	if ( count + 1 >= max )
	{
		SaveInteger( GameHT, hid, 'icnt' + id, 0 );
		return true;
	}
	else
	{
		SaveInteger( GameHT, hid, 'icnt' + id, count + 1 );
	}

	return false;
}

void ReleaseTimer( timer tmr, bool extraClean = true )
{
	int hid = GetHandleId( tmr );
	unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
	unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

	PauseTimer( tmr );

	if ( extraClean )
	{
		if ( IsUnitPaused( source ) )
		{
			PauseUnit( source, false );
			IssueImmediateOrder( source, "stop" );
		}
		SetUnitTimeScale( source, 1 );
		ShowUnit( source, true );
		SetUnitPathing( source, true );
		KillUnit( LoadUnitHandle( GameHT, hid, 106 ) );
		SetUnitInvulnerable( source, false );
		RemoveLocation( LoadLocationHandle( GameHT, hid, 102 ) );
		RemoveLocation( LoadLocationHandle( GameHT, hid, 103 ) );
		RemoveLocation( LoadLocationHandle( GameHT, hid, 107 ) );
		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
		SetUnitVertexColor( source, 255, 255, 255, 255 );
	}

	FlushChildHashtable( GameHT, hid );
	DestroyTimer( tmr );
}

void ClearAllData( int hid )
{
	ReleaseTimer( GetExpiredTimer( ), true );
}

bool StopSpell( int hid, int mod, bool onlyCheck = false )
{
	unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
	unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
	bool isClear = false;

	if ( mod == 0 )
	{
		isClear = GetUnitCurrentLife( source ) <= .0f;
	}
	else
	{
		isClear = GetUnitCurrentLife( source ) <= .0f || GetUnitCurrentLife( target ) <= .0f;
	}

	if ( isClear && !onlyCheck )
	{
		ClearAllData( hid );
	}

	return isClear;
}
//

// Nanaya Shiki Spells
void NanayaShiki_D( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		PlayHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'D1', 90.f, .0f );
		ReleaseTimer( tmr );
	}
}

void NanayaShiki_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'Q1' );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, .3f );
		SetUnitAnimation( source, "spell slam one" );
		PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
	}
	else if ( ticks == 30 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float dist = LoadReal( GameHT, hid, 'dist' );

		SetUnitAnimation( source, "spell throw six" );

		DisplaceWar3ImageLinear( source, angle, dist, .1f, .01f, false, true );

		effect ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", MathPointProjectionX( x, angle, dist * .5f ), MathPointProjectionY( y, angle, dist * .5f ), .0f, angle, 3.f, 1.f );
		SetEffectTimedLife( ef, 3.f );

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		bool isEnhanced = GetUnitBuffLevel( source, 'B001' ) > 0;
		if ( isEnhanced )
		{
			dmg *= 1.5f;
		}

		GroupEnumUnitsInLine( GroupEnum, x, y, angle, dist, 400.f );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				float u_x = GetUnitX( u );
				float u_y = GetUnitY( u );

				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( u ), GetUnitY( u ) ) );
				DisplaceWar3ImageLinear( u, MathAngleBetweenPoints( u_x, u_y, targX, targY ), 200.f, .5f, .01f, false, false );

				ACF_DamageTarget( source, u, dmg );
				if ( isEnhanced )
				{
					ACF_StunUnit( u, 1.f );
				}
			}
		}

		UnitRemoveAbility( source, 'B001' );

		ReleaseTimer( tmr );
	}
}

void NanayaShiki_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'W1' );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float dmg = 5.f * GetHeroLevel( source ) + .033f * GetHeroInt( source, true );

		PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
		ACF_StunUnit( source, .3f );
		SetUnitTimeScale( source, 2.f );
		SetUnitAnimation( source, "spell two" );
		SaveReal( GameHT, hid, '+dmg', GetUnitBuffLevel( source, 'B001' ) == 0 ? dmg : 1.5f * dmg );
	}
	else
	{
		int slashes = LoadInteger( GameHT, hid, 'slsh' );

		if ( slashes < 30 )
		{
			if ( CounterEx( hid, 0, 2 ) )
			{
				player p = LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = GetUnitX( source );
				float y = GetUnitY( source );
				float angle = GetUnitFacing( source );
				float dmg = LoadReal( GameHT, hid, '+dmg' );
				bool isEffect = CounterEx( hid, 1, 10 );

				effect ef = CreateEffectEx( "Characters\\NanayaShiki\\WEffect.mdl", MathPointProjectionX( x, angle, 150.f ), MathPointProjectionY( y, angle, 150.f ), .0f, angle, 1.5f, 1.f );
				SetSpecialEffectAnimation( ef, "stand" );
				SetSpecialEffectColour( ef, 0xFFFF00FF );
				SetEffectTimedLife( ef, 1.f );

				GroupEnumUnitsInRange( GroupEnum, GetSpecialEffectX( ef ), GetSpecialEffectY( ef ), 350.f, nil );

				for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
				{
					if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
					{
						if ( isEffect )
						{
							DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
							IssueImmediateOrder( u, "stop" );
						}

						if ( slashes == 29 )
						{
							DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", u, "chest" ) );
						}

						ACF_DamageTarget( source, u, dmg );
					}
				}

				SaveInteger( GameHT, hid, 'slsh', slashes + 1 );
			}
		}
		else
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

			UnitRemoveAbility( source, 'B001' );
			SetUnitAnimation( source, "stand" );
			ReleaseTimer( tmr );
		}
	}
}

void NanayaShiki_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		SaveBoolean( GameHT, hid, 'isex', GetUnitBuffLevel( source, 'B001' ) > 0 );
		//ACF_DisableUnitTP( target, GetUnitAbilityLevel( source, 'B001' ) > 0 ? 1.5f : .5f );
	}

	if ( !LoadBoolean( GameHT, hid, 'isex' ) )
	{
		if ( StopSpell( hid, 1, true ) )
		{
			if ( StopSpell( hid, 0, true ) )
			{
				StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'R2' );
			}
			
			ReleaseTimer( tmr );
			return;
		}

		if ( ticks == 0 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target ) + 200.f;

			PlayHeroSound( source, 'psnd' + 'R2', 90.f, .0f );

			ACF_StunUnit( source, .55f );
			SetUnitAnimation( source, "spell slam one" );
		}
		else if ( ticks == 50 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dmg = 1000.f + 100.f * GetHeroLevel( source ) + GetHeroInt( source, true );

			SetUnitXY( source, MathPointProjectionX( targX, angle, 100.f ), MathPointProjectionY( targY, angle, 100.f ) );
			SetUnitAnimation( source, "spell throw six" );
			ACF_DamageTarget( source, target, dmg );
			ACF_StunUnit( target, 2.f );

			effect ef;

			ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, angle + 45.f, 2.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, angle - 45.f, 2.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
			ReleaseTimer( tmr );
		}
	}
	else
	{
		if ( ticks < 125 )
		{
			if ( StopSpell( hid, 1, true ) )
			{
				if ( StopSpell( hid, 0, true ) )
				{
					StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'R2' );
				}
				
				ReleaseTimer( tmr );
				return;
			}
		}

		if ( ticks == 0 )
		{
			ACF_StunUnit( LoadUnitHandle( GameHT, hid, 'usrc' ), 1.5f );
		}
		else if ( ticks == 25 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target ) - 150.f;

			PlayHeroSound( source, 'psnd' + 'R2', 90.f, .0f );
			SetUnitAnimation( source, "spell two alternate" );
			DisplaceWar3ImageLinear( source, angle, dist, .25f, .01f, false, true );
		}
		else if ( ticks == 50 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dmg = 1000.f + 100.f * GetHeroLevel( source ) + GetHeroInt( source, true );

			PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );
			SetUnitAnimation( source, "spell slam one" );

			ACF_DamageTarget( source, target, dmg );
			SetUnitFlyHeightEx( target, 800.f, 4000.f );
			DisplaceWar3ImageLinear( target, angle, 300.f, .4f, .01f, false, false, "" );
		}
		else if ( ticks == 75 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target ) - 150.f;

			PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
			SetUnitFacing( source, angle );
			SetUnitAnimation( source, "spell throw three" );
			SetUnitFlyHeightEx( source, 600.f, 4000.f );
			SetUnitXY( source, MathPointProjectionX( GetUnitX( source ), angle, dist ), MathPointProjectionY( GetUnitY( source ), angle, dist ) );
		}
		else if ( ticks == 125 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dmg = 250.f + 25.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );
			effect ef;

			PlayHeroSound( source, 'psnd' + 'E2', 100.f, .0f );
			ACF_DamageTarget( source, target, dmg );

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 800.f, angle, 1.5f, 3.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", x, y, 800.f, angle, 1.5f, 3.f );
			SetEffectTimedLife( ef, 3.f );

			SetUnitFlyHeightEx( target, 0.f, 2000.f );
			SetUnitFlyHeightEx( source, 0.f, 99999.f );
			DisplaceWar3ImageLinear( target, angle, 400.f, .4f, .01f, false, false, "" );
		}
		else if ( ticks == 150 )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );

			SetUnitAnimation( source, "spell throw two" );
			UnitRemoveAbility( source, 'B001' );

			effect ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 3.f, 1.f );
			SetEffectTimedLife( ef, 1.f );

			for ( int i = 0; i < 5; i++ )
			{
				float move = 25.f + 25.f * i;

				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 2.f, GetRandomReal( .5f, 2.f ) );
				SetEffectTimedLife( ef, 4.f );
			}

			float dmg = 250.f + 25.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

			GroupEnumUnitsInRange( GroupEnum, targX, targY, 500.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					ACF_StunUnit( u, 1.f );
				}
			}

			ReleaseTimer( tmr );
		}
	}
}

void NanayaShiki_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( StopSpell( hid, 0, true ) || ticks == 305 )
	{

		ReleaseTimer( tmr );
		return;
	}

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target ) - 200.f;

		PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
		SetAbilityRemainingCooldown( GetUnitAbility( source, 'A02P' ), .01f );
		ACF_StunUnit( source, 3.f );
		SetUnitTimeScale( source, 2.f );
		SetUnitFacing( source, angle );
		SetUnitAnimation( source, "spell channel one" );
		DisplaceWar3ImageLinear( source, angle, dist, .25f, .01f, false, true );
	}
	else if ( ticks == 25 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = 600.f;

		SetUnitAnimation( source, "spell throw four" );
		EffectAPI::InverseDash( target );

		DisplaceWar3ImageLinear( source, angle, -dist * .5f, 1.f, .01f, false, false );
		DisplaceWar3ImageLinear( target, angle, dist, 1.f, .01f, false, false );
	}
	else if ( ticks == 125 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		effect ef;

		PlayHeroSound( source, 'psnd' + 'T2', 100.f, .0f );
		SetUnitAnimation( source, "spell throw five" );

		for ( int i = 0; i < 5; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, GetRandomReal( .0f, 360.f ), 1.f + .25f * i, GetRandomReal( .5f, 2.f ) );
			SetSpecialEffectAlpha( ef, GetRandomInt( 0x80, 0xC0 ) );
			SetEffectTimedLife( ef, 4.f );
		}

		ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 50.f, angle, 1.5f, 2.f );
		SetEffectTimedLife( ef, 4.f );

		ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.f, 2.f );
		SetEffectTimedLife( ef, 3.f );

		SetUnitFacing( source, angle );
		DisplaceUnitWithArgs( source, angle, dist, 1.f, .015f, 400.f );
		string mdl = GetUnitModel( source );

		for ( int i = 0; i < 15; i++ )
		{
			ef = CreateEffectEx( mdl, x, y, .0f, angle, 1.f, 1.f );
			SetEffectTimedLife( ef, 1.f );
			SetSpecialEffectAnimation( ef, "spell throw five" );
			SetSpecialEffectAlpha( ef, 0xFF - 25 * i );
			DisplaceWar3ImageWithArgs( ef, angle, dist, 1.f + .1f * i, .02f, 400.f );
		}
	}
	else if ( ticks == 225 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitFacing( source );
		float dmg = 4000.f + 300.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		effect ef;

		PlayHeroSound( source, 'gsnd' + 2, 80.f, .0f );
		PlayHeroSound( source, 'psnd' + 'D1', 100.f, .0f );

		ACF_StunUnit( target, 1.f );
		ACF_DamageTarget( source, target, dmg );

		SetUnitFacing( source, angle );
		SetUnitAnimation( source, "spell throw six" );
		DisplaceWar3ImageLinear( source, angle, 250.f, .8f, .01f, false, false );
		EffectAPI::Dash( source );

		for ( int i = 0; i < 4; i++ )
		{
			ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, ( angle + Pow( -1.f, i ) ) * 30.f, 3.f, .5f );
			SetEffectTimedLife( ef, 4.f );
		}

		for ( int i = 0; i < 5; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
			SetEffectTimedLife( ef, 4.f );
		}
	}
}

void NanayaShiki_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, 2.f );
		SetUnitAnimation( source, "stand" );
		SetAbilityRemainingCooldown( GetUnitAbility( source, 'A02P' ), .01f );
	}
	else if ( ticks == 50 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'T3', 100.f, .0f );
		SetUnitTimeScale( source, .25f );
		SetUnitAnimation( source, "spell one alternate" );
	}
	else if ( ticks == 90 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );

		SetUnitTimeScale( source, 1.f );
		SetUnitAnimation( source, "attack" );

		effect ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect.mdl", MathPointProjectionX( GetUnitX( source ), angle, 50.f ), MathPointProjectionY( GetUnitY( source ), angle, 50.f ), 100.f, angle, 1.f, 1.f );
		SaveEffectHandle( GameHT, hid, '+eff', ef );

		SaveBoolean( GameHT, hid, 'skip', true );
		SaveInteger( GameHT, hid, 'tick', ticks + 5 );
	}
	else if ( ticks == 95 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

		if ( DisplaceWar3ImageToTarget( LoadEffectHandle( GameHT, hid, '+eff' ), target, 20.f, 75.f ) )
		{
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );
			float angle = MathAngleBetweenPoints( x, y, targX, targY );
			float dist = MathDistanceBetweenPoints( x, y, targX, targY );
			string mdl = GetUnitModel( source );

			DestroyEffect( AddSpecialEffect( "GeneralSounds\\BlackBlink.mdx", x, y ) );
			SetUnitTimeScale( source, 1.f );
			SetUnitFlyHeightEx( source, 200.f, 99999.f );
			SetUnitAnimation( source, "spell channel three" );
			SetUnitXY( source, targX, targY );
			DestroyEffect( AddSpecialEffect( "GeneralSounds\\BlackBlink.mdx", targX, targY ) );

			effect ef = CreateEffectEx( mdl, MathPointProjectionX( targX, angle, 150.f ), MathPointProjectionY( targY, angle, 150.f ), .0f, -angle, 1.f, 1.f );
			SetSpecialEffectAlpha( ef, 0xB0 );
			SetEffectTimedLife( ef, .8f );
			SetSpecialEffectAnimation( ef, "spell slam three" );
			DestroyEffect( AddSpecialEffect( "GeneralSounds\\BlackBlink.mdx", GetSpecialEffectX( ef ), GetSpecialEffectY( ef ) ) );

			DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
			SaveBoolean( GameHT, hid, 'skip', false );
			SaveInteger( GameHT, hid, 'tick', ticks + 5 );
			return;
		}
	}
	else if ( ticks == 130 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitAngle( source, target );
		effect ef;

		SetUnitAnimation( source, "spell throw six" );
		SetUnitFlyHeightEx( source, 0, 99999.f );
		DisplaceWar3ImageLinear( source, angle, -300.f, .4f, .01f, false, false );

		for ( int i = 0; i < 3; i++ )
		{
			ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 4.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, angle + 45.f - 45.f * i, 1.f, 1.f );
			SetEffectTimedLife( ef, 4.f );
		}

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "GeneralSounds\\26.mdx", targX, targY ) );
	}
	else if ( ticks == 170 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float dmg = 6000.f + 400.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		ACF_StunUnit( target, 2.f );
		ACF_DamageTarget( source, target, dmg );
		SetUnitTimeScale( source, 1.f );
		ReleaseTimer( tmr );
	}
}
//

// Toono Shiki Spells
void ToonoShiki_D( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		PlayHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'D1', 100.f, .0f );
		ReleaseTimer( tmr );
	}
}

void ToonoShiki_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'Q1' );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, .3f );
		SetUnitAnimation( source, "spell three" );
		PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
	}
	else if ( ticks == 30 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float dist = LoadReal( GameHT, hid, 'dist' );

		SetUnitAnimation( source, "spell four" );

		DisplaceWar3ImageLinear( source, angle, dist, .1f, .01f, false, true );

		effect ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", MathPointProjectionX( x, angle, dist * .5f ), MathPointProjectionY( y, angle, dist * .5f ), .0f, angle, 3.f, 1.f );
		SetEffectTimedLife( ef, 3.f );

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		GroupEnumUnitsInLine( GroupEnum, x, y, angle, dist, 400.f );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				float u_x = GetUnitX( u );
				float u_y = GetUnitY( u );

				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( u ), GetUnitY( u ) ) );
				DisplaceWar3ImageLinear( u, MathAngleBetweenPoints( u_x, u_y, targX, targY ), 200.f, .5f, .01f, false, false );

				ACF_DamageTarget( source, u, dmg );
			}
		}

		ReleaseTimer( tmr );
	}
}

void ToonoShiki_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'W1' );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float dmg = 5.f * GetHeroLevel( source ) + .033f * GetHeroInt( source, true );

		PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
		ACF_StunUnit( source, .3f );
		SetUnitTimeScale( source, 2.f );
		SetUnitAnimation( source, "spell two" );
	}
	else
	{
		int slashes = LoadInteger( GameHT, hid, 'slsh' );

		if ( slashes < 30 )
		{
			if ( CounterEx( hid, 0, 2 ) )
			{
				player p = LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = GetUnitX( source );
				float y = GetUnitY( source );
				float angle = GetUnitFacing( source );
				float dmg = LoadReal( GameHT, hid, '+dmg' );
				bool isEffect = CounterEx( hid, 1, 10 );

				effect ef = CreateEffectEx( "Characters\\NanayaShiki\\WEffect.mdl", MathPointProjectionX( x, angle, 150.f ), MathPointProjectionY( y, angle, 150.f ), .0f, angle, 1.5f, 1.f );
				SetSpecialEffectAnimation( ef, "stand" );
				SetSpecialEffectColour( ef, 0xFF4040FF ); // 0xFFC0C0FF
				SetEffectTimedLife( ef, 1.f );

				GroupEnumUnitsInRange( GroupEnum, GetSpecialEffectX( ef ), GetSpecialEffectY( ef ), 350.f, nil );

				for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
				{
					if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
					{
						if ( isEffect )
						{
							DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
							IssueImmediateOrder( u, "stop" );
						}

						if ( slashes == 29 )
						{
							DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", u, "chest" ) );
						}

						ACF_DamageTarget( source, u, dmg );
					}
				}

				SaveInteger( GameHT, hid, 'slsh', slashes + 1 );
			}
		}
		else
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

			SetUnitAnimation( source, "stand" );
			ReleaseTimer( tmr );
		}
	}
}

void ToonoShiki_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		StopHeroSound( source, 'psnd' + 'E2' );
		StopHeroSound( source, 'psnd' + 'E3' );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );
	
	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		
		PlayHeroSound( source, 'psnd' + 'E3', 100.f, .0f );
		ACF_StunUnit( source, .9f );
		SetUnitTimeScale( source, 2.5f );
		SetUnitAnimation( source, "spell channel three" );
		EffectAPI::Dash( source );
		DisplaceWar3ImageLinear( source, angle, dist + 100.f, .2f, .01f, false, false );
	}
	else if ( ticks == 20 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'E2', 100.f, .0f );
		SetUnitAnimation( source, "spell five" );
	}
	else if ( ticks == 70 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		float dmg = 500.f + 75.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		PlayHeroSound( source, 'gsnd' + 2, 60.f, .0f );
		SetUnitTimeScale( source, 1 );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
		DisplaceWar3ImageLinear( source, angle, -300.f, .25f, .01f, false, false );
		ACF_StunUnit( target, 1 );
		ACF_DamageTarget( source, target, dmg );

		effect ef;

		ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle + 45.f, 2.f, 1.f );
		SetEffectTimedLife( ef, 4.f );

		ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle - 45.f, 2.f, 1.f );
		SetEffectTimedLife( ef, 4.f );
	}
	else if ( ticks == 95 )
	{
		ReleaseTimer( tmr );
	}
}

void ToonoShiki_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	int ticks = SpellTickEx( hid );

	if ( StopSpell( hid, 1, true ) && ticks < 160 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
		ACF_StunUnit( source, 2.f );
		SetUnitTimeScale( source, 2.f );
		SetUnitAnimation( source, "spell channel five" );
		EffectAPI::Dash( source );
		DisplaceWar3ImageLinear( source, angle, dist - 150.f, .1f, .01f, false, false );
	}
	else if ( ticks == 20 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		float dmg = 325.f + 32.5f * GetHeroLevel( source ) + .2f * GetHeroInt( source, true );

		PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );

		EffectAPI::PushWind( source, target );
		DisplaceWar3ImageLinear( target, angle, 150.f, .2f, .01f, false, false );
		ACF_DamageTarget( source, target, dmg );
		ACF_StunUnit( target, 1.f );
	}
	else if ( ticks == 40 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		SetUnitAnimation( source, "spell channel three" );
		DisplaceWar3ImageLinear( source, angle, dist - 150.f, .1f, .01f, false, false );
	}
	else if ( ticks == 60 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'R2', 100.f, .0f );
		SetUnitAnimation( source, "spell channel one" );
	}
	else if ( ticks == 110 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		float dmg = 750.f + 60.f * GetHeroLevel( source ) + .25f * GetHeroInt( source, true );

		SetUnitTimeScale( source, 3 );
		EffectAPI::PushWind( source, target, 50.f, -45.f );
		ACF_DamageTarget( source, target, dmg );
		SetUnitFlyHeightEx( source, 800.f, 2000.f );
		SetUnitFlyHeightEx( target, 800.f, 2000.f );
		DisplaceWar3ImageLinear( source, angle, 200.f, .4f, .01f, false, false );
		DisplaceWar3ImageLinear( target, angle, 200.f, .4f, .01f, false, false );
	}
	else if ( ticks == 160 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		float dmg = 750.f + 60.f * GetHeroLevel( source ) + .25f * GetHeroInt( source, true );

		PlayHeroSound( source, 'psnd' + 'R3', 100.f, .0f );
		SetUnitAnimation( source, "spell channel four" );
		EffectAPI::PushWind( source, target, 700.f, 45.f );

		SetUnitFlyHeightEx( source, 0.f, 3000.f );
		SetUnitFlyHeightEx( target, 0.f, 3000.f );
		DisplaceWar3ImageLinear( source, angle, 200.f, .25f, .01f, false, false );
		DisplaceWar3ImageLinear( target, angle, 200.f, .25f, .01f, false, false );
		ACF_DamageTarget( source, target, dmg );
	}
	else if ( ticks == 200 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = MathAngleBetweenPoints( x, y, targX, targY );
		effect ef;

		for ( int i = 0; i < 4; i++ )
		{
			ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, ( angle + Pow( -1.f, i ) ) * 30.f, 3.f, .5f );
			SetEffectTimedLife( ef, 4.f );
		}

		for ( int i = 0; i < 5; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
			SetEffectTimedLife( ef, 4.f );
		}

		float dmg = 500.f + 40.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, targX, targY, 600.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
			}
		}

		ReleaseTimer( tmr );
	}
}

void ToonoShiki_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		ACF_StunUnit( source, 1.3f );
		SetUnitAnimation( source, "spell one" );
		SetUnitFacing( source, angle );

		for ( int i = 0; i < 5; i++ )
		{
			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
			SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
			SetEffectTimedLife( ef, 4.f );
		}
	}
	else if ( ticks == 90 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		float dmg = 3000.f + 300.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		effect ef;

		PlayHeroSound( source, 'gsnd' + 2, 80.f, .0f );
		PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );

		DisplaceWar3ImageLinear( source, angle, dist + 250.f, .4f, .01f, false, false );
		
		for ( int i = 0; i < 17; i++ )
		{
			if ( i < 3 )
			{
				ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 4.f, 1.f );
				SetEffectTimedLife( ef, 4.f );
			}

			if ( i < 8 )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
				SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}

			float face = GetRandomReal( 0.f, 360.f );

			ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, face, 2.f, .5f );
			DisplaceWar3ImageWithArgs( ef, face, GetRandomReal( 200.f, 800.f ), .1f, .01f, .0f );
			SetEffectTimedLife( ef, 4.f );
		}

		ACF_StunUnit( target, 2.f );
		ACF_DamageTarget( source, target, dmg );
	}
	else if ( ticks == 130 )
	{
		ReleaseTimer( tmr );
	}
}
//

// Ryougi Shiki Spells
void RyougiShiki_D( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		PlayHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'D1', 100.f, .0f );
		ReleaseTimer( tmr );
	}
}

void RyougiShiki_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );

		ACF_StunUnit( source, .2f );
		SetUnitTimeScale( source, 1.5f );
		SetUnitAnimation( source, "spell channel four" );
	}
	else if ( ticks == 20 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = GetUnitFacing( source );
		float targX = MathPointProjectionX( x, angle, 200.f );
		float targY = MathPointProjectionY( y, angle, 200.f );

		PlayHeroSound( source, 'gsnd' + 0, 50.f, .0f );
		SetUnitTimeScale( source, 1.f );

		for ( int i = 0; i < 5; i++ )
		{
			effect ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiWEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
			SetEffectTimedLife( ef, 4.f );
		}

		float dmg = 240.f + 80.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, targX, targY, 300.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );

				DisplaceUnitWithArgs( u, angle, 300.f, .5f, .01f, 150.f );
				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( u ), GetUnitY( u ) ) );
			}
		}

		ReleaseTimer( tmr );
	}
}

void RyougiShiki_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float dist = LoadReal( GameHT, hid, 'dist' );

		PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
		ACF_StunUnit( source, .4f );
		SetUnitAnimation( source, "Spell Channel Slam" );
		SetUnitTimeScale( source, 2.f );
		EffectAPI::Dash( source );

		DisplaceWar3ImageLinear( source, GetUnitFacing( source ), dist, .4f, .01f, false, true );
	}
	else if ( ticks == 40 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = GetUnitFacing( source );
		float targX = MathPointProjectionX( x, angle, 200.f );
		float targY = MathPointProjectionY( y, angle, 200.f );

		PlayHeroSound( source, 'gsnd' + 0, 50.f, .0f );
		SetAbilityRemainingCooldown( GetUnitAbility( source, 'A033' ), .01f );

		for ( int i = 0; i < 5; i++ )
		{
			effect ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiWEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
			//SetSpecialEffectColour( ef, 0xFFFF7000 );
			SetEffectTimedLife( ef, 3.f );
		}

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( u ), GetUnitY( u ) ) );
				DisplaceWar3ImageLinear( u, angle, 150.f, .2f, .01f, false, false );
			}
		}

		ReleaseTimer( tmr );
	}
}

void RyougiShiki_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float dist = LoadReal( GameHT, hid, 'dist' );

		PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
		ACF_StunUnit( source, .5f );
		SetUnitTimeScale( source, 1.75f );
		SetUnitAnimation( source, "spell channel two" );
		DisplaceWar3ImageLinear( source, angle, dist, .4f, .01f, false, true );

		SaveReal( GameHT, hid, 'srcX', x );
		SaveReal( GameHT, hid, 'srcY', y );
		SaveReal( GameHT, hid, 'trgX', MathPointProjectionX( x, angle, dist * .5f ) );
		SaveReal( GameHT, hid, 'trgY', MathPointProjectionY( y, angle, dist * .5f ) );
	}
	else if ( ticks == 50 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float origX = LoadReal( GameHT, hid, 'srcX' );
		float origY = LoadReal( GameHT, hid, 'srcX' );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float dist = LoadReal( GameHT, hid, 'dist' );
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );

		PlayHeroSound( source, 'gsnd' + 0, 50.f, .0f );

		effect ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle, 3.f, .5f );
		SetEffectTimedLife( ef, 3.f );

		float dmg = 75.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInLine( GroupEnum, origX, origY, angle, dist, 600.f );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( u ), GetUnitY( u ) ) );
			}
		}

		ReleaseTimer( tmr );
	}
}

void RyougiShiki_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, 1.35f );
		SetUnitAnimation( source, "spell one" );
		PlayHeroSound( source, 'psnd' + 'T1', 80.f, .0f );
	}
	else if ( ticks == 25 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		float dmg = 1000.f + 100.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

		SetUnitAnimation( source, "spell channel five" );
		ACF_DamageTarget( source, target, dmg );
		SetUnitXY( source, MathPointProjectionX( targX, angle, 100.f ), MathPointProjectionY( targY, angle, 100.f ) );

		for ( int i = 0; i < 5; i++ )
		{
			effect ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiQEffect.mdl", targX, targY, .0f, angle, 2.f, 1.f );
			//SetSpecialEffectColour( ef, 0xFFFF7000 );
			SetEffectTimedLife( ef, 3.f );
		}
	}
	else if ( ticks == 75 )
	{
		SetUnitAnimation( LoadUnitHandle( GameHT, hid, 'usrc' ), "spell slam one" );
	}
	else if ( ticks == 135 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float dmg = 1000.f + 100.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

		PlayHeroSound( source, 'gsnd' + 0, 50.f, .0f );
		ACF_DamageTarget( source, target, dmg );
		ACF_StunUnit( target, 1.f );

		for ( int i = 0; i < 3; i++ )
		{
			effect ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 4.f, 1.f );
			SetEffectTimedLife( ef, 4.f );
		}

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
		ReleaseTimer( tmr );
	}
}

void RyougiShiki_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, 1.25f );
		SetUnitAnimation( source, "spell channel three" );
		PlayHeroSound( source, 'psnd' + 'D1', 100.f, .0f );
		SaveBoolean( GameHT, hid, 'skip', true );
		SaveInteger( GameHT, hid, 'tick', ticks + 1 );
	}
	else if ( ticks == 1 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

		if ( DisplaceWar3ImageToTarget( source, target, 40.f, 600.f ) )
		{
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );
			float angle = MathAngleBetweenPoints( x, y, targX, targY );
			float dist = MathDistanceBetweenPoints( x, y, targX, targY );
			float dmg = 1500.f + 150.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

			PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
			SetUnitAnimation( source, "spell channel four" );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );

			for ( int i = 0; i < 3; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle, 1.f, 1.f );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
				SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}

			DisplaceWar3ImageLinear( source, angle, dist + 250.f, .2f, .01f, false, false );
			
			ACF_DamageTarget( source, target, dmg );
			ACF_StunUnit( target, .5f );
			SaveInteger( GameHT, hid, 'tick', 5 );
			return;
		}
	}
	else if ( ticks == 5 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		int slashes = LoadInteger( GameHT, hid, 'slsh' );

		if ( slashes < 30 )
		{
			PlayHeroSound( source, 'psnd' + 'R2', 100.f, .0f );

			for ( int i = 0; i < 3; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, slashes * 12.f, 1.f, 1.f );
				SetEffectTimedLife( ef, 4.f );
			}

			SaveInteger( GameHT, hid, 'slsh', slashes + 1 );
		}
		else
		{
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			SetUnitAnimation( source, "spell" );
			DisplaceUnitWithArgs( source, angle, dist + 600.f, 1.1f, .01f, 250.f );
			SaveInteger( GameHT, hid, 'tick', 10 );
			SaveBoolean( GameHT, hid, 'skip', false );
			return;
		}
	}
	else if ( ticks == 70 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitAngle( source, target );
		effect ef;
		float dmg = 1500.f + 150.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

		PlayHeroSound( source, 'gsnd' + 0, 70.f, .0f );

		ACF_StunUnit( target, 1.f );
		ACF_DamageTarget( source, target, dmg );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );

		for ( int i = 0; i < 3; i++ )
		{
			ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 0.f, angle, 4.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
			SetEffectTimedLife( ef, 4.f );
		}
	}
	else if ( ticks == 120 )
	{
		ReleaseTimer( tmr );
	}
}
//

// Saber Alter Spells
void SaberAlter_D( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		StopHeroSound( source, 'psnd' + 'D1' );
		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'D1', 100.f, .0f );
		ACF_StunUnit( source, .2f );
		SetUnitAnimation( source, "Morph" );
	}
	else if ( ticks == 20 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );

		for ( int i = 0; i < 5; i++ )
		{
			effect ef = CreateEffectEx( "Characters\\SaberAlter\\DarkLightningNova.mdl", x, y, 50.f, .0f, .2f * i, .6f + .1f * i );
			SetEffectTimedLife( ef, 4.f );
		}

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		
		GroupEnumUnitsInRange( GroupEnum, x, y, 300.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				float dist = GetUnitDistance( source, u );

				ACF_DamageTarget( source, u, dmg );
				DisplaceUnitWithArgs( u, GetUnitAngle( source, u ), 200.f, .5f, .01f, 200.f );
			}
		}

		ReleaseTimer( tmr );
	}
}

void SaberAlter_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
		ACF_StunUnit( source, .3f );
		SetUnitTimeScale( source, 1.5f );
		SetUnitAnimation( source, "spell Slam" );
	}
	else if ( ticks == 10 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float dist = LoadReal( GameHT, hid, 'dist' );
		float targX = MathPointProjectionX( x, angle, dist * .5f );
		float targY = MathPointProjectionY( y, angle, dist * .5f );
	
		DisplaceWar3ImageLinear( source, angle, dist, .1f, .01f, false, true );

		PlayHeroSound( source, 'psnd' + 'Q2', 100.f, .0f );

		effect ef = CreateEffectEx( "Characters\\SaberAlter\\SaberAlterClaw.mdl", targX, targY, .0f, angle, 3.f, .5f );
		SetSpecialEffectColour( ef, 0xFF800080 );
		SetEffectTimedLife( ef, 3.f );

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInLine( GroupEnum, x, y, angle, dist, 400.f );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( u ), GetUnitY( u ) ) );
				DisplaceWar3ImageLinear( u, angle, 200.f, .5f, .01f, false, false );
			}
		}

		ReleaseTimer( tmr );
	}
}

void SaberAlter_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float dist = LoadReal( GameHT, hid, 'dist' );

		SetUnitAnimation( source, "spell Two" );
		EffectAPI::Jump( source );

		DisplaceUnitWithArgs( source, LoadReal( GameHT, hid, 'angl' ), dist, .4f, .01f, 200.f + dist / 5.f );
	}
	else if ( ticks == 40 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		effect ef;

		PlayHeroSound( source, 'psnd' + 'W2', 100.f, .0f );
		PlayHeroSound( source, 'psnd' + 'W3', 100.f, .0f );

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );

		ef = CreateEffectEx( "Characters\\SaberAlter\\DarkExplosion.mdl", x, y, .0f, 270.f, .5f, 1.f );

		for ( int i = 0; i < 4; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
			SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
			SetEffectTimedLife( ef, 4.f );
		}

		float dmg = 150.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 300.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
			}
		}

		ReleaseTimer( tmr );
	}
}

void SaberAlter_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		DestroyGroup( LoadGroupHandle( GameHT, hid, '+grp' ) );
		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
		ACF_StunUnit( source, .6f );
		SaveGroupHandle( GameHT, hid, '+grp', CreateGroup( ) );
		SetUnitAnimation( source, "spell Five" );
	}
	else if ( ticks == 60 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'E2', 100.f, .5f );
		SaveReal( GameHT, hid, 'srcX', GetUnitX( source ) );
		SaveReal( GameHT, hid, 'srcY', GetUnitY( source ) );
	}
	else if ( ticks > 60 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float move = LoadReal( GameHT, hid, 'move' ) + 150.f;
		int id = R2I( move / 150.f );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float x = MathPointProjectionX( LoadReal( GameHT, hid, 'srcX' ), angle, move );
		float y = MathPointProjectionY( LoadReal( GameHT, hid, 'srcY' ), angle, move );
		group g = LoadGroupHandle( GameHT, hid, '+grp' );

		effect ef = CreateEffectEx( "Characters\\SaberAlter\\ShadowBurstBigger.mdx", x, y, .0f, .0f, .2f + .05f * id, 1.f );
		SetEffectTimedLife( ef, 1.f + .025f * id );

		float dmg = 75.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 300.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) && !IsUnitInGroup( u, g ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
				DisplaceUnitWithArgs( u, .0f, .0f, .5f, .01f, 400.f );

				GroupAddUnit( g, u );
			}
		}

		if ( move >= 1500.f )
		{
			DestroyGroup( g );
			ReleaseTimer( tmr );
			return;
		}

		SaveReal( GameHT, hid, 'move', move );
	}
}

void SaberAlter_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, 1.5f );
		PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
		PlayHeroSound( source, 'psnd' + 'R2', 100.f, .5f );
	}
	else if ( ticks >= 10 )
	{
		int slashes = LoadInteger( GameHT, hid, 'slsh' );

		if ( CounterEx( hid, 0, 40 ) )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			float angle = GetUnitFacing( source );
			float efX = MathPointProjectionX( x, angle, 50.f );
			float efY = MathPointProjectionY( y, angle, 50.f );

			PlayHeroSound( source, 'psnd' + 'R2', 100.f, .5f );
			SetUnitAnimation( source, slashes == 0 || slashes == 2 ? "spell Three" : "spell Six" );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\SaberAlter\\SaberAlterSlash.mdl", efX, efY, .0f, angle, 1.f, 1.f );
				SetEffectTimedLife( ef, 3.f );
			}

			DisplaceWar3ImageLinear( source, angle, 100.f, .4f, .01f, false, false );

			float dmg = 30.f * GetHeroLevel( source ) + .25f * GetHeroInt( source, true );

			GroupEnumUnitsInRange( GroupEnum, efX, efY, 300.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					DisplaceUnitWithArgs( u, angle, slashes < 3 ? 100.f : 300.f, .35f, .01f, 300.f );
					DestroyEffect( AddSpecialEffectTarget( slashes < 3 ? "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl" : "GeneralEffects\\BloodEffect1.mdx", u, "chest" ) );
				}
			}

			slashes++;
  
			if ( slashes > 3 )
			{
				ReleaseTimer( tmr );
				return;
			}
			else
			{
				SaveInteger( GameHT, hid, 'slsh', slashes );
			}
		}
	}
}

void SaberAlter_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		DestroyGroup( LoadGroupHandle( GameHT, hid, '+grp' ) );
		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );

		PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
		ACF_StunUnit( source, 1.f );
		SetUnitAnimation( source, "spell Channel One" );
		DestroyEffect( AddSpecialEffectTarget( "Characters\\SaberAlter\\ShadowBurst.mdx", source, "weapon" ) );

		EffectAPI::Jump( source );

		for ( int i = 0; i < 2; i++ )
		{
			effect ef = CreateEffectEx( "Characters\\SaberAlter\\DarkExplosion.mdl", x, y, .0f, .0f, GetRandomReal( .95f, 1.25f ), GetRandomReal( .45f, .7f ) );
			SetEffectTimedLife( ef, 2.f );
		}

		SaveGroupHandle( GameHT, hid, '+grp', CreateGroup( ) );
	}
	else if ( ticks == 100 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = LoadReal( GameHT, hid, 'angl' );

		SetUnitAnimation( source, "spell Channel Two" );
		PlayHeroSound( source, 'psnd' + 'T2', 100.f, .0f );

		effect ef = CreateEffectEx( "Characters\\SaberAlter\\DarkWave.mdl", x, y, 50.f, angle, 1.f, 1.f );
		SetSpecialEffectColour( ef, 0xFFA0FF70 );
		SetEffectTimedLife( ef, 3.f );

		SaveReal( GameHT, hid, 'srcX', x );
		SaveReal( GameHT, hid, 'srcY', y );
	}
	else if ( ticks >= 100 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		group g = LoadGroupHandle( GameHT, hid, '+grp' );
		float x = LoadReal( GameHT, hid, 'srcX' );
		float y = LoadReal( GameHT, hid, 'srcY' );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float moved = LoadReal( GameHT, hid, 'move' );
		bool isEff = ( moved % 400.f ) == 0.f; moved += 100.f;

		float efX = MathPointProjectionX( x, angle, moved );
		float efY = MathPointProjectionY( y, angle, moved );

		if ( isEff )
		{
			effect ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", efX, efY, 0.f, GetRandomReal( 0.f, 360.f ), 3.f, 1.f );
			SetEffectTimedLife( ef, 1.f );
		}

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", efX, efY ) );

		float dmg = 300.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, efX, efY, 500.f, nil );
	
		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) && !IsUnitInGroup( u, g ) )
			{
				ACF_DamageTarget( source, u, dmg );

				GroupAddUnit( g, u );
			}
		}

		if ( moved >= 3000 )
		{
			DestroyGroup( g );
			ReleaseTimer( tmr );
			return;
		}

		SaveReal( GameHT, hid, 'move', moved );
	}
}
//

// Saber Nero Spells
void SaberNero_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float dist = LoadReal( GameHT, hid, 'dist' );

		PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
		EffectAPI::Dash( source );
		ACF_StunUnit( source, .5f );
		SetUnitTimeScale( source, 1.5f );
		SetUnitAnimation( source, "spell two" );
		DisplaceWar3ImageLinear( source, angle, dist, .5f, .01f, false, true );
	}
	else if ( ticks == 50 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float angle = GetUnitFacing( source );
		float x = MathPointProjectionX( GetUnitX( source ), angle, 200.f );
		float y = MathPointProjectionY( GetUnitY( source ), angle, 200.f );

		for ( int i = 0; i < 2; i++ )
		{
			effect ef = CreateEffectEx( "Characters\\SaberNero\\SaberNeroFireCutEffect.mdl", x, y, .0f, angle, 2.5f, 1.f );
			SetEffectTimedLife( ef, 1.f );
		}

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 400.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( u ), GetUnitY( u ) ) );
				DisplaceWar3ImageLinear( u, GetUnitAngle( source, u ), 200.f, .3f, .01f, false, false );
			}
		}

		ReleaseTimer( tmr );
	}
}

void SaberNero_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
		ACF_StunUnit( source, .4f );
		SetUnitAnimation( source, "attack slam" );
	}
	else if ( ticks == 40 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		effect ef;

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );

		ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, .0f, 270.f, 4.f, 1.f );

		for ( int i = 0; i < 8; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, GetRandomReal( .5f, 2.f ) );
			SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
			SetEffectTimedLife( ef, 4.f );
		}

		float dmg = 250 + GetHeroLevel( LoadUnitHandle( GameHT, hid, 'usrc' ) ) * 50 + GetHeroInt( LoadUnitHandle( GameHT, hid, 'usrc' ), true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 450.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
				DisplaceWar3ImageLinear( u, GetUnitAngle( source, u ), 200.f, .25f, .01f, false, false );
			}
		}

		ReleaseTimer( tmr );
	}
}

void SaberNero_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
		
		ACF_StunUnit( source, 1.7f );
		SetUnitTimeScale( source, 1.5f );
		SetUnitAnimation( source, "Spell Three" );
		DisplaceWar3ImageLinear( source, angle, dist - 150.f, .1f, .015f, false, true );
	}
	else if ( ticks == 10 )
	{
		ACF_StunUnit( LoadUnitHandle( GameHT, hid, 'utrg' ), .35f );
	}
	else if ( ticks >= 35 && ticks <= 140 )
	{
		if ( CounterEx( hid, 0, 35 ) )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );
			float dmg = 10.f * GetHeroLevel( source );

			SetUnitFacing( source, GetUnitAngle( source, target ) );
			ACF_DamageTarget( source, target, dmg );
			ACF_StunUnit( target, .35f );

			effect ef = CreateEffectEx( "GeneralEffects\\qqqqq.mdl", targX, targY, 100.f, GetRandomReal( 0.f, 360.f ), 1.2f, 1.f );
			SetEffectTimedLife( ef, 1.f );

			DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\RedAftershock.mdx", targX, targY ) );
			DestroyEffect( AddSpecialEffectTarget( "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", target, "chest" ) );
		}
	}
	else if ( ticks == 170 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		effect ef;

		ef = CreateEffectEx( "GeneralEffects\\lssdqiu.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );
		SetEffectTimedLife( ef, 1.f );

		ef = CreateEffectEx( "GeneralEffects\\moonwrath.mdl", targX, targY, .0f, .0f, 4.f, 1.f );
		SetEffectTimedLife( ef, 4.f );

		ef = CreateEffectEx( "GeneralEffects\\apocalypsecowstomp.mdl", targX, targY, .0f, .0f, 1.5f, 1.f );
		SetSpecialEffectColour( ef, 0xFFFF00FF );

		for ( int i = 0; i < 8; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, GetRandomReal( .5f, 2.f ) );
			SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
			SetEffectTimedLife( ef, 4.f );
		}

		float dmg = 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
			}
		}

		ReleaseTimer( tmr );
	}
}

void SaberNero_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
		ACF_StunUnit( source, 1.85f );
		SetUnitFacing( source, LoadReal( GameHT, hid, 'angl' ) );
		SetUnitAnimation( source, "spell One" );
		SaveReal( GameHT, hid, 'circ', 800 );
	}

	if ( ticks < 80 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		float circle = LoadReal( GameHT, hid, 'circ' );

		DisplaceCircular( p, LoadReal( GameHT, hid, 'trgX' ), LoadReal( GameHT, hid, 'trgY' ), 300.f, circle, 1.f, "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl" );

		SaveReal( GameHT, hid, 'circ', circle - 10.f );
	}
	else if ( ticks == 80 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float angle = GetUnitFacing( source );
		float dist = LoadReal( GameHT, hid, 'dist' );

		SetUnitAnimation( source, "spell channel one" );
		DisplaceWar3ImageLinear( source, angle, dist * .4f, .5f, .01f, false, false );
	}
	else if ( ticks == 130 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = GetUnitFacing( source );
		float dist = LoadReal( GameHT, hid, 'dist' );
		effect ef;

		SetUnitAnimation( source, "attack slam" );

		DisplaceUnitWithArgs( source, angle, ( dist * .6f ), .6f, .01f, 600.f );

		ef = CreateEffectEx( "GeneralEffects\\wave.mdl", x, y, 200.f, angle, 2.f, 1.f );
		SetEffectTimedLife( ef, 3.f );

		ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.f, 2.f );
		SetEffectTimedLife( ef, 3.f );

		for ( int i = 0; i < 4; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, GetRandomReal( .5f, 2.f ) );
			SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
			SetEffectTimedLife( ef, 4.f );
		}
	}
	else if ( ticks == 185 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );
		effect ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", targX, targY, .0f, 270.f, 6.f, 1.f );

		for ( int i = 0; i < 12; i++ )
		{
			if ( i < 8 )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 4.5f + .25f * i, GetRandomReal( .5f, 2.f ) );
				SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}

			for ( int j = 0; j < 3; j++ )
			{
				float efX = MathPointProjectionX( targX, 30.f * i, 200.f + 200.f * j );
				float efY = MathPointProjectionY( targY, 30.f * i, 200.f + 200.f * j );

				ef = CreateEffectEx( "GeneralEffects\\ioncannonbeam.mdl", efX, efY, 50.f, .0f, 10.f, 1.f );
				SetSpecialEffectColour( ef, 0xFFFF6400 );
				SetSpecialEffectAnimation( ef, "birth" );
				SetEffectTimedLife( ef, 1.5f );
			}
		}

		float dmg = 2000.f + 125.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, targX, targY, 800.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 2.f );
				DisplaceUnitWithArgs( u, GetUnitAngle( source, u ), 1000.f, 1, .01f, 600.f );
			}
		}

		ReleaseTimer( tmr );
	}
}

void SaberNero_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, 4.1f );
		SetUnitTimeScale( source, 1.5f );
		SetUnitAnimation( source, "Spell Fly Slam" );

		SaveBoolean( GameHT, hid, 'skip', true );
		SaveInteger( GameHT, hid, 'tick', 5 );
	}
	else if ( ticks == 5 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

		if ( DisplaceWar3ImageToTarget( source, target, 50.f, 150.f ) )
		{
			PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
			SetUnitAnimation( source, "Spell Three" );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\RedAftershock.mdx", GetUnitX( source ), GetUnitY( source ) ) );

			SaveBoolean( GameHT, hid, 'skip', false );
			SaveInteger( GameHT, hid, 'tick', 30 );

			return;
		}
	}
	else if ( ticks >= 30 && ticks <= 120 )
	{
		if ( CounterEx( hid, 0, 30 ) )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dmg = 20.f * GetHeroLevel( source );

			ACF_DamageTarget( source, target, dmg );
			SetUnitFacing( source, angle );

			effect ef = CreateEffectEx( "GeneralEffects\\qqqqq.mdl", targX, targY, 100.f, GetRandomReal( 0.f, 360.f ), 1.2f, 1.f );
			SetEffectTimedLife( ef, 1.f );

			DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\RedAftershock.mdx", targX, targY ) );
			DestroyEffect( AddSpecialEffectTarget( "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", target, "chest" ) );
		}
	}
	else if ( ticks == 170 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float dmg = 20.f * GetHeroLevel( source );
		effect ef;

		SetUnitTimeScale( source, 1.f );

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", targX, targY ) );
		for ( int i = 0; i < 8; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 4.5f + .25f * i, GetRandomReal( .5f, 2.f ) );
			SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
			SetEffectTimedLife( ef, 4.f );
		}

		ACF_DamageTarget( source, target, dmg );
		DisplaceUnitWithArgs( target, 0, 0, .9f, .01f, 600.f );
		SetUnitAnimation( source, "Spell Five" );
	}
	else if ( ticks == 250 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		float dmg = 20.f * GetHeroLevel( source );
		effect ef;

		PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );

		SetUnitAnimation( source, "Spell One" );

		ef = CreateEffectEx( "GeneralEffects\\wave.mdl", targX, targY, 200.f, angle, 2.f, 1.f );
		SetSpecialEffectPitch( ef, -90.f );
		SetEffectTimedLife( ef, 3.f );

		ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, 50.f, angle, 1.f, 2.f );
		SetSpecialEffectPitch( ef, -90.f );
		SetEffectTimedLife( ef, 3.f );

		for ( int i = 0; i < 3; i++ )
		{
			ef = CreateEffectEx( "Characters\\SaberNero\\SaberNeroFireCutEffect.mdl", x, y, .0f, angle, 2.5f, 1.f );
			SetEffectTimedLife( ef, 1.f );
		}

		ACF_DamageTarget( source, target, dmg );

		EffectAPI::PushWind( source, target );

		DisplaceWar3ImageLinear( target, angle, 500.f, 1, .01f, false, false );
	}
	else if ( ticks == 330 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		SetUnitAnimation( source, "Attack Slam" );
		EffectAPI::Dash( source );
		
		DisplaceUnitWithArgs( source, angle, 950.f, .8f, .01f, 600.f );
	}
	else if ( ticks == 410 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float dmg = 180.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		effect ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );

		PlayHeroSound( source, 'gsnd' + 2, 80.f, .0f );

		for ( int i = 0; i < 10; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\BlinkNew.mdl", targX, targY, 200.f, 36.f * i, .5f * i, 1.5f - .1f * i );
			SetSpecialEffectColour( ef, 0xFF6000FF );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, GetRandomReal( 0.f, 360.f ), 4.5f + .25f * i, GetRandomReal( .5f, 2.f ) );
			SetSpecialEffectAlpha( ef, GetRandomInt( 0xA0, 0xC0 ) );
			SetEffectTimedLife( ef, 4.f );
		}

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
		ACF_DamageTarget( source, target, dmg );
		ACF_StunUnit( target, 1.f );
		ReleaseTimer( tmr );
	}
}
//

// Kuchiki Byakuya Spells
void KuchikiByakuya_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
		DestroyGroup( LoadGroupHandle( GameHT, hid, '+grp' ) );
		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'Q2', 90.f, .0f );

		ACF_StunUnit( source, .25f );
		SetUnitAnimation( source, "spell" );
	}
	else if ( ticks == 25 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = GetUnitFacing( source );
		effect ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSpellQEffect.mdl", MathPointProjectionX( x, angle, 150.f ), MathPointProjectionY( y, angle, 150.f ), .0f, angle, 1.5f, 1.f );

		PlayHeroSound( source, 'psnd' + 'Q1', 90.f, .0f );

		SaveEffectHandle( GameHT, hid, '+eff', ef );
		SaveGroupHandle( GameHT, hid, '+grp', CreateGroup( ) );

		DisplaceWar3ImageLinear( ef, angle, 1250.f, .5f, .01f, false, false, "" );
	}

	if ( ticks >= 25 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		effect ef = LoadEffectHandle( GameHT, hid, '+eff' );
		group g = LoadGroupHandle( GameHT, hid, '+grp' );
		float x = GetSpecialEffectX( ef );
		float y = GetSpecialEffectY( ef );
		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 250.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) && !IsUnitInGroup( u, g ) )
			{
				ACF_DamageTarget( source, u, dmg );
				GroupAddUnit( g, u );
			}
		}

		if ( ticks == 60 )
		{
			DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
			DestroyGroup( LoadGroupHandle( GameHT, hid, '+grp' ) );
			ReleaseTimer( tmr );
		}
	}
}

void KuchikiByakuya_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		HandleListCleanEffects( LoadHandleList( GameHT, hid, 'elst' ), true, true );
		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
		ACF_StunUnit( source, .25f );
		SetUnitAnimation( source, "spell channel one" );

		SaveHandleList( GameHT, hid, 'elst', HandleListCreate( ) );
	}
	else if ( ticks >= 10 && ticks <= 20 )
	{
		if ( CounterEx( hid, 0, 2 ) )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			handlelist hl = LoadHandleList( GameHT, hid, 'elst' );
			int count = HandleListGetEffectCount( hl );
			float efAngle = 60.f * count;
			float efX = MathPointProjectionX( targX, efAngle, 100.f );
			float efY = MathPointProjectionY( targX, efAngle, 100.f );
			effect ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSenkeiSword.mdl", efX, efY, 350.f, .0f, 3.f, 1.f );
			SetSpecialEffectAnimation( ef, "stand" );
			SetSpecialEffectPitch( ef, -85.f );
			SetEffectTimedLife( ef, .25f - count * .01f );

			HandleListAddHandle( hl, ef );
		}
	}
	else if ( ticks == 50 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		handlelist hl = LoadHandleList( GameHT, hid, 'elst' );
		float angleStep = 360.f / HandleListGetEffectCount( hl );

		for ( int i = 0; i < HandleListGetEffectCount( hl ); i++ )
		{
			effect ef = HandleListGetEffectByIndex( hl, i );

			SetSpecialEffectPosition( ef, MathPointProjectionX( targX, i * angleStep, 100.f ), MathPointProjectionY( targY, i * angleStep, 100.f ) );
			SetSpecialEffectHeight( ef, 100.f );
		}

		float dmg = 245.f + 65.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		ACF_DamageTarget( source, target, dmg );
		ACF_StunUnit( source, 1.f );

		effect ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSpellQEffect.mdl", targX, targY, .0f, .0f, 1.5f, 1.f );
		SetEffectTimedLife( ef, .5f );

		DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\Spark_Pink.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\Deadspirit Asuna.mdx", targX, targY ) );

		HandleListDestroy( hl );
		ReleaseTimer( tmr );
	}
}

void KuchikiByakuya_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'E1', 90.f, .0f );

		ACF_StunUnit( source, 2.f );
		SetUnitAnimation( source, "spell Slam" );
	}
	else if ( ticks == 10 )
	{
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );

		for ( int i = 0; i < 5; i++ )
		{
			effect ef = CreateEffectEx( "GeneralEffects\\plasma.mdl", targX, targY, .0f, .0f, 1.3f + i * .1f, 1.f );
			SetSpecialEffectAnimation( ef, "stand" );
			SetSpecialEffectColour( ef, 0xFFFF3060 );
			SetEffectTimedLife( ef, 2.f );
		}
	}
	else if ( ticks >= 20 && ticks <= 200 )
	{
		if ( CounterEx( hid, 0, 20 ) )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float targX = LoadReal( GameHT, hid, 'trgX' );
			float targY = LoadReal( GameHT, hid, 'trgY' );

			float dmg = 3.f * GetHeroLevel( source ) + .05f * GetHeroInt( source, true );
			float dmgFin = 40.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

			GroupEnumUnitsInRange( GroupEnum, targX, targY, 450.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					if ( ticks != 200 )
					{
						ACF_DamageTarget( source, u, dmg );
						ACF_AddBuffTimed( u, 'Bslo', 1.f, false );
					}
					else
					{
						ACF_DamageTarget( source, u, dmgFin );
						ACF_StunUnit( u, 1.f );

						DisplaceWar3ImageLinear( u, MathAngleBetweenPoints( targX, targY, GetUnitX( u ), GetUnitY( u ) ), 300.f, .5f, .01f, false, false );
					}

					DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
				}
			}

			if ( ticks == 200 )
			{
				effect ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSakuraExplosionEffect.mdl", targX, targY, 50.f, .0f, 1.f, .3f );
				SetEffectTimedLife( ef, 5.f );

				ReleaseTimer( tmr );
			}
		}
	}
}

void KuchikiByakuya_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( StopSpell( hid, 0, true ) || ticks > 1000 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		HandleListCleanEffects( LoadHandleList( GameHT, hid, 'elst' ), true, true );
		ReleaseTimer( tmr );
		return;
	}

	if ( ticks == 0 )
	{
		SetUnitAnimation( LoadUnitHandle( GameHT, hid, 'usrc' ), "morph" );
		SaveHandleList( GameHT, hid, 'elst', HandleListCreate( ) );
	}
	else if ( ticks == 25 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		handlelist hl = LoadHandleList( GameHT, hid, 'elst' );
		effect ef;
		
		for ( int i = 0; i < 3; i++ )
		{
			ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaBankaiEffect.mdl", x, y, 200.f * i, .0f, 1.f, 3.f );
			SetSpecialEffectTimeScale( ef, 3.f );
			HandleListAddHandle( hl, ef );
		}
	}
	else if ( ticks >= 100 )
	{
		float x = .0f;
		float y = .0f;
		handlelist hl = LoadHandleList( GameHT, hid, 'elst' );

		for ( int i = 0; i < HandleListGetEffectCount( hl ); i++ )
		{
			effect ef = HandleListGetEffectByIndex( hl, i );
			float newFacing = 0;

			if ( i == 0 )
			{
				newFacing = 5.f;
				x = GetSpecialEffectX( ef );
				y = GetSpecialEffectY( ef );
			}
			else if ( i == 1 )
			{
				newFacing = -5.f;
			}
			else if ( i == 2 )
			{
				newFacing = 7.5f;
			}

			SetSpecialEffectFacing( ef, GetSpecialEffectFacing( ef ) + newFacing );
		}

		if ( CounterEx( hid, 0, 25 ) )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float dmg = 5.f * GetHeroLevel( source ) + .05f * GetHeroInt( source, true );
			bool isEffect = CounterEx( hid, 1, 5 );
			GroupEnumUnitsInRange( GroupEnum, x, y, 800.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );

					if ( isEffect )
					{
						DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
						DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "head" ) );
					}
				}
			}
		}
	}
}

void KuchikiByakuya_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ReleaseTimer( tmr );
		return;
	}
	
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'T3', 100.f, .0f );
		ACF_StunUnit( source, 2.5f );
		SetUnitTimeScale( source, 2.f );
		SetUnitAnimation( source, "Attack Alternate One" );
	}
	else if ( ticks == 40 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );

		PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );

		EffectAPI::PushWind( source, target );

		DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\QQQQQ.mdx", target, "chest" ) );
		ACF_StunUnit( target, 2.f );

		DisplaceWar3ImageLinear( target, angle, 400.f, .4f, .01f, false, false );
	}
	else if ( ticks == 80 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'T2', 100.f, .0f );
		SetUnitTimeScale( source, 1.f );
		SetUnitAnimation( source, "spell three" );
	}
	else if ( ticks == 120 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		SetUnitAnimation( source, "spell four" );
		EffectAPI::Dash( source );

		DisplaceWar3ImageLinear( source, angle, dist - 250.f, .5f, .01f, false, false );
	}
	else if ( ticks == 170 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );

		SetUnitAnimation( source, "spell one" );
		EffectAPI::Dash( source );
	}
	else if ( ticks == 180 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		effect ef;

		for ( int i = 0; i < 2; i++ )
		{
			ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiQEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
			//SetSpecialEffectColour( ef, 0xFFFF7000 );
			SetEffectTimedLife( ef, 3.f );
		}

		DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\QQQQQ.mdx", target, "chest" ) );

		ef = CreateEffectEx( "GeneralEffects\\qianbenying8.mdl", targX, targY, .0f, .0f, 1.f, 1.f );
		SetEffectTimedLife( ef, .5f );

		DisplaceWar3ImageLinear( source, angle, dist + 400.f, .6f, .01f, false, false );
	}
	else if ( ticks == 250 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		effect ef;
		float dmg = 3000.f + 300.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		PlayHeroSound( source, 'gsnd' + 0, 60.f, .0f );

		for ( int i = 0; i < 5; i++ )
		{
			ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSakuraExplosionEffect.mdl", targX, targY, 50.f, .0f, .5f * i, .3f + i );
			SetEffectTimedLife( ef, 5.f );
		}

		ef = CreateEffectEx( "GeneralEffects\\qianbenying8.mdl", targX, targY, .0f, .0f, 1.f, 1.f );
		SetEffectTimedLife( ef, .5f );

		DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "chest" ) );
		DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\Spark_Pink.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\Deadspirit Asuna.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );

		ACF_StunUnit( target, 1.f );
		ACF_DamageTarget( source, target, dmg );
		ReleaseTimer( tmr );
	}
}
//

// Akame Spells
void Akame_D( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'D1' );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float dist = -400.f;

		if ( LoadInteger( GameHT, hid, 'atid' ) == 'A052' )
		{
			dist = -350.f;
			ShowUnitAbility( source, 'A03L', true );
			ShowUnitAbility( source, 'A052', false );
		}
		PlayHeroSound( source, 'psnd' + 'D1', 80.f, .0f );
		ACF_StunUnit( source, .3f );
		SetUnitTimeScale( source, 2.f );
		SetUnitAnimation( source, "spell two" );
		SetUnitInvulnerable( source, true );
		SaveReal( GameHT, hid, 'dist', dist );
	}
	else if ( ticks == 20 )
	{
		DisplaceUnitWithArgs( LoadUnitHandle( GameHT, hid, 'usrc' ), LoadReal( GameHT, hid, 'angl' ), LoadReal( GameHT, hid, 'dist' ), .2f, .01f, 0 );
	}
	else if ( ticks == 30 )
	{
		ReleaseTimer( tmr );
	}
}

void Akame_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( StopSpell( hid, 0, true ) || ticks == 200 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		if ( ticks != 200 )
		{
			StopHeroSound( source, 'psnd' + 'Q1' );
		}

		ShowUnitAbility( source, 'A03L', true );
		ShowUnitAbility( source, 'A052', false );
		ReleaseTimer( tmr );
		return;
	}
	else if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, .2f );
		SetUnitAnimation( source, "Spell Four" );
	}
	else if ( ticks == 20 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float angle = GetUnitFacing( source );
		float dist = 200.f;
		float x = MathPointProjectionX( GetUnitX( source ), angle, dist );
		float y = MathPointProjectionY( GetUnitY( source ), angle, dist );

		PlayHeroSound( source, 'psnd' + 'Q1', 60.f, .0f );

		ShowUnitAbility( source, 'A03L', false );
		ShowUnitAbility( source, 'A052', true );

		for ( int i = 0; i < 5; i++ )
		{
			effect ef = CreateEffectEx( "GeneralEffects\\AkihaClaw.mdl", x, y, .0f, angle + 30.f, 1.5f, .8f );
			SetEffectTimedLife( ef, 4.f );
		}

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 400.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( u ), GetUnitY( u ) ) );
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
			}
		}
	}
}

void Akame_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( source, 'psnd' + 'W1' );
		}

		SetUnitVertexColor( source, 0xFF, 0xFF, 0xFF, 0xFF );
		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
		ReleaseTimer( tmr );

		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, .2f );
		SetUnitPathing( source, false );
		SetUnitAnimation( source, "Spell Channel" );
		SaveInteger( GameHT, hid, 'acol', 0xFF );
		SaveEffectHandle( GameHT, hid, '+eff', AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", GetUnitX( source ), GetUnitY( source ) ) );
	}
	else
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = MathAngleBetweenPoints( x, y, targX, targY );
		int alpha = MathIntegerClamp( LoadInteger( GameHT, hid, 'acol' ) - 5, 0, 0xFF );

		SetUnitVertexColor( source, 0xFF, 0xFF, 0xFF, alpha );
		SaveInteger( GameHT, hid, 'acol', alpha );

		if ( DisplaceWar3ImageToTarget( source, target, 20.f, 100.f ) )
		{
			float dmg = 200.f + 100.f * GetHeroLevel( source ) + GetHeroInt( source, true );

			PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiWEffect.mdl", x, y, .0f, angle, 4.f, 1.f );
				//SetSpecialEffectColour( ef, 0xFFFF7000 );
				SetEffectTimedLife( ef, 3.f );
			}

			ACF_StunUnit( target, 1.f );
			ACF_DamageTarget( source, target, dmg );
			SetUnitAnimation( source, "attack" );

			SetUnitVertexColor( source, 0xFF, 0xFF, 0xFF, 0xFF );
			DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
			ReleaseTimer( tmr );
			return;
		}
	}
}

void Akame_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'E1' );
		ReleaseTimer( tmr );

		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_StunUnit( source, .3f );
		SetUnitAnimation( source, "Spell Four" );
		PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
	}
	else if ( ticks == 30 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float dist = LoadReal( GameHT, hid, 'dist' );

		effect ef = CreateEffectEx( "GeneralEffects\\AkihaClaw.mdl", MathPointProjectionX( x, angle, dist * .5f ), MathPointProjectionY( y, angle, dist * .5f ), .0f, angle, 3.f, 1.f );
		SetEffectTimedLife( ef, 3.f );

		DisplaceWar3ImageLinear( source, angle, dist, .1f, .01f, false, true );

		float dmg = 300.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInLine( GroupEnum, x, y, angle, dist, 450.f );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				DisplaceWar3ImageLinear( u, angle, 200.f, .5f, .01f, false, false );
				DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( u ), GetUnitY( u ) ) );
			}
		}

		ReleaseTimer( tmr );
	}
}

void Akame_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( source, 'gsnd' + 0 );
			StopHeroSound( source, 'gsnd' + 1 );
			StopHeroSound( source, 'psnd' + 'D1' );
			StopHeroSound( source, 'psnd' + 'W1' );
			StopHeroSound( source, 'psnd' + 'R1' );
			StopHeroSound( source, 'psnd' + 'R2' );
		}

		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		DisplaceWar3ImageLinear( source, angle, dist - 150.f, .6f, .01f, false, false );
		SetUnitTimeScale( source, 2.f );
		ACF_StunUnit( source, 2.8f );
		SetUnitAnimation( source, "spell three" );
	}
	else if ( ticks == 40 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		float dmg = 250.f + 30.f * GetHeroLevel( source );

		PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );
		PlayHeroSound( source, 'psnd' + 'D1', 80.f, .0f );

		EffectAPI::PushWind( source, target );

		DisplaceWar3ImageLinear( target, angle, 400.f, .5f, .01f, false, false );
		ACF_DamageTarget( source, target, dmg );
		SetUnitAnimation( source, "spell two" );
		DisplaceUnitWithArgs( source, angle, -400.f, 1, .01f, 0 );
	}
	else if ( ticks == 140 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'R2', 80.f, .0f );

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", GetUnitX( source ), GetUnitY( source ) ) );
		ShowUnit( source, false );
		SaveBoolean( GameHT, hid, 'skip', true );
		SaveInteger( GameHT, hid, 'tick', ticks + 5 );
	}
	else if ( ticks == 145 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float dmg = 25.f + GetHeroLevel( source );
		int slashCount = LoadInteger( GameHT, hid, 'slct' );

		if ( slashCount < 20 )
		{
			float angle = slashCount * 18.f;
			float efX = MathPointProjectionX( GetUnitX( target ), angle, 150.f );
			float efY = MathPointProjectionY( GetUnitY( target ), angle, 150.f );
			effect ef;

			ACF_DamageTarget( source, target, dmg );

			if ( CounterEx( hid, 0, 4 ) )
			{
				ef = AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "chest" );
				SetSpecialEffectScale( ef, .5f );
				DestroyEffect( ef );
			}
			
			ef = CreateEffectEx( "GeneralEffects\\BlackBlink.mdx", efX, efY, .0f, .0f, .75f, 1.f );
			DestroyEffect( ef );

			SaveInteger( GameHT, hid, 'slct', slashCount + 1 );
		}
		else
		{
			SaveBoolean( GameHT, hid, 'skip', false );
			SaveInteger( GameHT, hid, 'tick', ticks + 1 );
			ShowUnit( source, true );
			ACF_SelectUnit( source, LoadPlayerHandle( GameHT, hid, '+ply' ) );
			SetUnitFacing( source, GetUnitAngle( source, target ) );
			SetUnitTimeScale( source, .1f );
			SetUnitAnimation( source, "attack" );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", GetUnitX( source ), GetUnitY( source ) ) );
			SaveEffectHandle( GameHT, hid, '+eff', AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );
			return;
		}
	}
	else if ( ticks == 190 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		ACF_SelectUnit( source, LoadPlayerHandle( GameHT, hid, '+ply' ) );
		PlayHeroSound( source, 'psnd' + 'W1', 90.f, .0f );
		SetUnitTimeScale( source, 2.f );
	}
	else if ( ticks == 210 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = MathAngleBetweenPoints( x, y, targX, targY );
		float dist = MathDistanceBetweenPoints( x, y, targX, targY );

		PlayHeroSound( source, 'psnd' + 'R1', 90.f, .0f );

		for ( int i = 0; i < 3; i++ )
		{
			effect ef = CreateEffectEx( "GeneralEffects\\AkihaClaw.mdl", targX, targY, .0f, angle, 4.f, 1.f ); // perhaps better to change logic of the effect...?
			SetEffectTimedLife( ef, 1.f );
		}

		DisplaceWar3ImageLinear( source, angle, dist + 400.f, .2f, .01f, false, false );

		DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
	}
	else if ( ticks == 250 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float dmg = 500.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		ACF_StunUnit( target, 1 );
		PlayHeroSound( source, 'gsnd' + 0, 60.f, .0f );
		ACF_DamageTarget( source, target, dmg );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
		ReleaseTimer( tmr );
	}
}

void Akame_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		StopHeroSound( source, 'gsnd' + 1 );
		StopHeroSound( source, 'psnd' + 'Q1' );
		StopHeroSound( source, 'psnd' + 'T1' );

		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		DisplaceWar3ImageLinear( source, angle, dist - 150.f, .5f, .01f, false, false );
		ACF_StunUnit( source, 2.f );
		SetUnitAnimation( source, "spell three" );
		ACF_StunUnit( target, 2.f );
		SaveEffectHandle( GameHT, hid, '+eff', AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );
	}
	else if ( ticks == 50 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );
		float dmg = 500.f + 50.f * GetHeroLevel( source );

		PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );

		EffectAPI::PushWind( source, target );

		effect ef;

		ef = CreateEffectEx( "GeneralEffects\\wave.mdl", targX, targY, 200.f, angle, 1.f, 1.f );
		SetSpecialEffectPitch( ef, -90.f );

		DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "chest" ) );
		DestroyEffect( AddSpecialEffectTarget( "GeneralEffects\\QQQQQ.mdx", target, "chest" ) );
		DisplaceWar3ImageLinear( target, angle, 600.f, 1.f, .01f, false, false );
		ACF_DamageTarget( source, target, dmg );
	}
	else if ( ticks == 75 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float dist = GetUnitDistance( source, target ) + 600.f;
		float height = dist / 2.f;

		DisplaceUnitWithArgs( source, GetUnitAngle( source, target ), dist, .8f, .01f, MathRealClamp( height, 100.f, 250.f ) );
	}
	else if ( ticks == 155 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

		SetUnitTimeScale( source, 1.75f );
		PlayHeroSound( source, 'psnd' + 'Q1', 80.f, .0f );

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", GetUnitX( target ), GetUnitY( target ) ) );
	}
	else if ( ticks == 205 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float dmg = 1000.f + 100.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		PlayHeroSound( source, 'gsnd' + 0, 60.f, .0f );
		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\26.mdx", GetUnitX( target ), GetUnitY( target ) ) );

		ACF_StunUnit( target, 1.f );
		ACF_DamageTarget( source, target, dmg );

		ReleaseTimer( tmr );
	}
}
//

// Scathach Spells
void SetScathachQState( unit u, int state = 0 )
{
	ShowUnitAbility( u, 'A040', state == 0 );
	ShowUnitAbility( u, 'A03Y', state == 1 );
	ShowUnitAbility( u, 'A03Z', state == 2 );
}

void ResetScathachQ( unit u )
{
	SetScathachQState( u, 0 );
}

void Scathach_Q1( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( StopSpell( hid, 1, true ) || ticks == 300 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		if ( ticks != 300 )
		{
			StopHeroSound( source, 'psnd' + 'Q3' );
		}

		ResetScathachQ( source );
		ReleaseTimer( tmr );
		return;
	}
	else if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

		PlayHeroSound( source, 'psnd' + 'Q3', 100.f, .0f );
		ACF_StunUnit( source, .55f );
		SetUnitFacing( source, GetUnitAngle( source, target ) );
		SetUnitAnimation( source, "Attack" );
		
	}
	else if ( ticks == 20 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		SetScathachQState( source, GetUnitLevel( source ) >= 5 ? 1 : 0 );
		SetUnitFacing( source, angle );
		EffectAPI::Dash( source );
		DisplaceWar3ImageLinear( source, angle, dist - 50.f, .35f, .02f, false, true );
	}
	else if ( ticks == 55 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float dmg = 100.f + 50.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

		ACF_StunUnit( target, 1.f );
		ACF_DamageTarget( source, target, dmg );
	}
}

void Scathach_Q2( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( StopSpell( hid, 1, true ) || ticks == 300 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		StopHeroSound( source, 'psnd' + 'Q1' );
		ResetScathachQ( source );
		ReleaseTimer( tmr );
		return;
	}
	else if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		PlayHeroSound( source, 'psnd' + 'Q2', 100.f, .0f );
		ACF_StunUnit( source, .15f );
		SetUnitAnimation( source, "spell Three" ); 
		DisplaceWar3ImageLinear( source, angle, dist - 150.f, .1f, .02f, false, true );
	}
	else if ( ticks == 10 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dmg = 50.f + 25.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

		SetScathachQState( source, GetUnitLevel( source ) >= 8 ? 2 : 0 );
		EffectAPI::PushWind( source, target );
		DisplaceWar3ImageLinear( target, angle, 200.f, .25f, .01f, false, false );
		ACF_DamageTarget( source, target, dmg );
		ReleaseTimer( tmr );
	}
}

void Scathach_Q3( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		StopHeroSound( source, 'psnd' + 'Q1' );
		ResetScathachQ( source );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = GetUnitAngle( source, target );
		float dist = GetUnitDistance( source, target );

		PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
		ACF_StunUnit( source, .45f );

		SetUnitFacing( source, angle );
		SetUnitAnimation( source, "Spell Three" );

		effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, .0f, 2.f, 1.f );
		SetEffectTimedLife( ef, 4.f );

		DisplaceWar3ImageLinear( source, angle, dist - 150.f, .2f, .02f, false, true );
	}
	else if ( ticks == 20 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

		ResetScathachQ( source );
		SetUnitFacing( source, GetUnitAngle( source, target ) );
		SetUnitAnimation( source, "Spell Three" );
	}
	else if ( ticks == 45 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = GetUnitAngle( source, target );
		float dmg = 100.f + 25.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );
		effect ef;

		SetUnitFacing( source, angle );

		EffectAPI::PushWind( source, target );
		DisplaceWar3ImageLinear( target, angle, 200.f, .5f, .01f, false, false );
		ACF_DamageTarget( source, target, dmg );


		ReleaseTimer( tmr );
	}
}

void Scathach_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		StopHeroSound( source, 'psnd' + 'W1' );
		StopHeroSound( source, 'psnd' + 'Q3' );
		DestroyEffect( LoadEffectHandle( GameHT, hid, 'eff' ) );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = LoadReal( GameHT, hid, 'angl' );

		PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
		ACF_StunUnit( source, .5f );
		SetUnitAnimation( source, "spell Throw" );

		effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, .0f, 2.f, 1.f );
		SetEffectTimedLife( ef, 4.f );

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
		SaveEffectHandle( GameHT, hid, '+eff', AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );

		DisplaceUnitWithArgs( source, angle, LoadReal( GameHT, hid, 'dist' ), .5f, .01f, 600.f );
	}
	else if ( ticks == 50 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );

		PlayHeroSound( source, 'psnd' + 'Q3', 100.f, .0f );
		
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\SlamEffect.mdx", x, y ) );
		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );

		for ( int i = 0; i < 3; i++ )
		{
			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, GetRandomReal( .5f, 2.f ) );
			SetEffectTimedLife( ef, 4.f );
		}

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 400.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 2.f );
			}
		}

		ReleaseTimer( tmr );
	}
}

void Scathach_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		HandleListCleanEffects( LoadHandleList( GameHT, hid, 'elst' ), true, true );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = MathAngleBetweenPoints( x, y, targX, targY );
		handlelist hl = HandleListCreate( );

		ACF_DisableUnitTP( target, 1.f );
		ACF_StunUnit( source, 1.f );
		SetUnitPathing( source, false );
		SetUnitAnimation( source, "Spell Three" ); // was channel

		for ( int i = 0; i < 8; i++ )
		{
			float dist = 80.f * i;
			effect ef;

			ef = CreateEffectEx( "GeneralEffects\\OrbOfFire.mdl", MathPointProjectionX( x, angle - 160.f, dist ), MathPointProjectionY( y, angle - 160.f, dist ), 150.f, angle, 1.5f, 1.f );

			HandleListAddHandle( hl, ef );

			ef = CreateEffectEx( "GeneralEffects\\OrbOfFire.mdl", MathPointProjectionX( x, angle + 160.f, dist ), MathPointProjectionY( y, angle + 160.f, dist ), 150.f, angle, 1.5f, 1.f );

			HandleListAddHandle( hl, ef );
		}

		SaveHandleList( GameHT, hid, 'elst', hl );
	}
	else if ( ticks == 50 )
	{
		SaveInteger( GameHT, hid, 'tick', ticks + 5 );
		SaveBoolean( GameHT, hid, 'skip', true );
	}
	else if ( ticks == 55 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = MathAngleBetweenPoints( x, y, targX, targY );
		float dist = MathDistanceBetweenPoints( x, y, targX, targY );
		handlelist hl = LoadHandleList( GameHT, hid, 'elst' );

		if ( CounterEx( hid, 0, 10 ) )
		{
			ACF_StunUnit( source, .1f );
		}

		if ( dist >= 150.f )
		{
			SetUnitFacing( source, angle );
			SetUnitXY( source, MathPointProjectionX( x, angle, 50.f ), MathPointProjectionY( y, angle, 50.f ) );
		}
		else
		{
			SetUnitAnimation( source, "spell Seven" );
			PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
			SaveBoolean( GameHT, hid, 'skip', false );
			//HandleListCleanEffects( LoadHandleList( GameHT, hid, 'elst' ), true, true );
		}

		for ( int i = 0; i < HandleListGetEffectCount( hl ); i++ )
		{
			effect ef = HandleListGetEffectByIndex( hl, i );
			angle = GetSpecialEffectFacing( ef );

			SetSpecialEffectPosition( ef, MathPointProjectionX( GetSpecialEffectX( ef ), angle, 50.f ), MathPointProjectionY( GetSpecialEffectY( ef ), angle, 50.f ) );
		}
	}
	else if ( ticks == 60 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = MathAngleBetweenPoints( x, y, targX, targY );
		effect ef;

		PlayHeroSound( source, 'psnd' + 'R2', 100.f, .0f );
		SetUnitFacing( source, angle );
		SetUnitAnimation( source, "spell four" );

		EffectAPI::PushWind( source, target );

		ef = CreateEffectEx( "GeneralEffects\\t_huobao.mdl", targX, targY, 100.f, angle, .5f, 1.f );
		SetSpecialEffectPitch( ef, -90.f );
		SetEffectTimedLife( ef, 2.f );

		SaveInteger( GameHT, hid, 'tick', ticks + 5 );
		SaveBoolean( GameHT, hid, 'skip', true );

		float dist = 500.f;
		SaveReal( GameHT, hid, 'angl', GetUnitAngle( source, target ) );
		SaveReal( GameHT, hid, 'dist', dist );
		SaveReal( GameHT, hid, '+spd', dist * .01f / .4f ); // dist * tickRate / time
	}
	else if ( ticks == 65 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float dist = LoadReal( GameHT, hid, 'dist' );
		float speed = LoadReal( GameHT, hid, '+spd' );
		handlelist hl = LoadHandleList( GameHT, hid, 'elst' );

		if ( CounterEx( hid, 0, 10 ) )
		{
			ACF_StunUnit( source, .1f );
		}

		if ( dist >= 0.f )
		{
			SetUnitXY( target, MathPointProjectionX( targX, angle, speed ), MathPointProjectionY( targY, angle, speed ) );

			if ( CounterEx( hid, 1, 5 ) )
			{
				DestroyEffect( AddSpecialEffect( "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", targX, targY ) );
			}

			for ( int i = 0; i < HandleListGetEffectCount( hl ); i++ )
			{
				effect ef = HandleListGetEffectByIndex( hl, i );
				angle = GetSpecialEffectFacing( ef );

				SetSpecialEffectPosition( ef, MathPointProjectionX( GetSpecialEffectX( ef ), angle, speed ), MathPointProjectionY( GetSpecialEffectY( ef ), angle, speed ) );
			}
		}
		else
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );

			DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", targX, targY ) );

			for ( int i = 0; i < 10; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\t_huobao.mdl", targX, targY, 100.f, 36.f * i, 2.f, 1.f );
				SetSpecialEffectPitch( ef, -90.f );
				SetEffectTimedLife( ef, 2.f ); 
			}

			float dmg = 75.f * GetHeroLevel( source ) + GetHeroInt( source, true );

			GroupEnumUnitsInRange( GroupEnum, targX, targY, 600.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
				}
			}

			HandleListCleanEffects( hl, true, true );
			//SaveBoolean( GameHT, hid, 'skip', false );
			ReleaseTimer( tmr );
		}

		SaveReal( GameHT, hid, 'dist', dist - speed );
	}
}

void Scathach_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'E1' );

		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float angle = LoadReal( GameHT, hid, 'angl' );

		PlayHeroSound( source, 'psnd' + 'E1', 80.f, .0f );
		ACF_StunUnit( source, 1.25f );
		SetUnitTimeScale( source, 2.f );
		SetUnitAnimation( source, "spell Three" ); // attack?
		ACF_DisableUnitTP( target, 1.25f );
		DisplaceWar3ImageLinear( source, angle, GetUnitDistance( source, target ) - 100.f, .2f, .01f, false, false );

		for ( int i = 0; i < 3; i++ )
		{
			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, GetRandomReal( 0.f, 360.f ), .5f * ( i + 1 ), 2.f + .25 * i );
			SetEffectTimedLife( ef, 4.f );
		}
	}
	else if ( ticks >= 20 && ticks <= 120 )
	{
		if ( CounterEx( hid, 0, 20 ) )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 25.f * GetHeroLevel( source ) + .2f * GetHeroInt( source, true );
			effect ef;

			SetUnitAnimationWithRarity( source, "attack", RARITY_RARE );
			SetUnitFacing( source, angle );

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 50.f, angle, 1.5f, 2.f );
			SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, 50.f, angle, 1.f, 2.f );
			SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 3.f );

			DisplaceWar3ImageLinear( target, angle, 50.f, .2f, .01f, false, false );
			if ( ACF_DamageTarget( source, target, dmg ) )
			{
				if ( ticks <= 100 )
				{
					DisplaceWar3ImageLinear( source, angle, dist - 50.f, .2f, .01f, false, false );
				}
				else
				{
					ef = CreateEffectEx( "GeneralEffects\\t_huobao.mdl", targX, targY, 100.f, angle, .5f, 1.f );
					SetSpecialEffectPitch( ef, -90.f );
					SetEffectTimedLife( ef, 2.f );
					ACF_StunUnit( target, 2.f );
					ReleaseTimer( tmr );
				}
			}
		}
	}
}

void Scathach_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
	
		StopHeroSound( source, 'psnd' + 'Q1' );
		StopHeroSound( source, 'psnd' + 'T1' );
		DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = MathAngleBetweenPoints( x, y, LoadReal( GameHT, hid, 'trgX' ), LoadReal( GameHT, hid, 'trgY' ) );

		PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
		ACF_StunUnit( source, 1.f );
		SetUnitAnimation( source, "spell Three" );

		effect ef = CreateEffectEx( "GeneralEffects\\laxus_lightning_spear.mdl", x, y, 50.f, angle, 2.f, 1.f );
		SetSpecialEffectColour( ef, 0x64840000 );

		SaveEffectHandle( GameHT, hid, '+eff', ef );
	}
	else if ( ticks < 100 )
	{
		if ( CounterEx( hid, 0, 5 ) )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			float angle = MathAngleBetweenPoints( x, y, LoadReal( GameHT, hid, 'trgX' ), LoadReal( GameHT, hid, 'trgY' ) );
			effect ef = LoadEffectHandle( GameHT, hid, '+eff' );

			SetUnitFacing( source, angle );
			SetSpecialEffectFacing( ef, angle );
			SetSpecialEffectScale( ef, 2.f + ticks / 50.f );
		}
	}
	else if ( ticks == 100 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float dist = MathDistanceBetweenPoints( x, y, LoadReal( GameHT, hid, 'trgX' ), LoadReal( GameHT, hid, 'trgY' ) );

		PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );

		for ( int i = 0; i < 8; i++ )
		{
			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, GetRandomReal( 0.f, 360.f ), 1.f + i / 5.f, 1.25f );
			SetSpecialEffectAlpha( ef, 0x50 );
			SetEffectTimedLife( ef, 4.f );
		}

		SetUnitAnimation( source, "spell Four" );
		SaveReal( GameHT, hid, 'dist', dist );
	}
	else if ( ticks > 100 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		effect ef = LoadEffectHandle( GameHT, hid, '+eff' );
		float efX = GetSpecialEffectX( ef );
		float efY = GetSpecialEffectY( ef );
		float angle = GetSpecialEffectFacing( ef );
		float moveX = MathPointProjectionX( efX, angle, 50.f );
		float moveY = MathPointProjectionY( efY, angle, 50.f );
		float dist = LoadReal( GameHT, hid, 'dist' );
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );

		if ( dist >= 100.f )
		{
			SetSpecialEffectPosition( ef, moveX, moveY );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", efX, efY ) );
			GroupEnumUnitsInRange( GroupEnum, moveX, moveY, 450.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					float x = GetUnitX( u );
					float y = GetUnitY( u );
					float toAngle = MathAngleBetweenPoints( x, y, moveX, moveY );

					SetUnitXY( u, MathPointProjectionX( x, toAngle, 50.f ), MathPointProjectionY( y, toAngle, 50.f ) );
				}
			}

			SaveReal( GameHT, hid, 'dist', dist - 50.f );
		}
		else
		{
			PlayHeroSound( source, 'gsnd' + 2, 80.f, .0f );

			DestroyEffect( ef );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\26.mdx", efX, efY ) );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", efX, efY ) );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", efX, efY ) );

			for ( int i = 0; i < 8; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", efX, efY, .0f, GetRandomReal( 0.f, 360.f ), 1.f + i / 5.f, 1.25f );
				SetSpecialEffectAlpha( ef, 0x50 );
				SetEffectTimedLife( ef, 4.f );
			}

			GroupEnumUnitsInRange( GroupEnum, efX, efY, 450.f, nil );

			float dmg = 300.f * GetHeroLevel( source ) + GetHeroInt( source, true );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					ACF_StunUnit( u, 1.f );
				}
			}

			ReleaseTimer( tmr );
		}
	}
}
//

// Akainu Spells

void Akainu_D( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		PlayHeroSound( source, 'psnd' + 'D1', 100.f, .0f );
		SaveEffectHandle( GameHT, hid, '+eff', AddSpecialEffectTarget( "GeneralEffects\\lavaspray.mdx", source, "head" ) );
	}

	if ( CounterEx( hid, 0, 50 ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		if ( GetUnitAbilityLevel( source, 'B04H' ) <= 0 )
		{
			DestroyEffect( LoadEffectHandle( GameHT, hid, '+eff' ) );
			ReleaseTimer( tmr );
		}

		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float dmg = 12.5f * GetHeroLevel( source ) + .1f * GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 300.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				if ( ACF_DamageTarget( source, u, dmg ) )
				{
					DestroyEffect( AddSpecialEffectTarget( "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", u, "chest" ) );
				}
			}
		}
	}
}

void Akainu_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

	if ( StopSpell( hid, 1, true ) )
	{
		StopHeroSound( source, 'psnd' + 'R1' );
		StopHeroSound( source, 'psnd' + 'R2' );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );
	unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

	if ( ticks == 0 )
	{
		PlayHeroSound( source, 'psnd' + 'R2', 90.f, .0f );
		ACF_StunUnit( source, .25f );
		SetUnitPathing( source, false );
		SetUnitAnimation( source, "spell three" );
	}

	if ( CounterEx( hid, 0, 10 ) )
	{
		ACF_StunUnit( source, .10f );
		//ACF_DisableUnitTP( target, .10f ); // this adds up
	}

	float x = GetUnitX( source );
	float y = GetUnitY( source );
	float targX = GetUnitX( target );
	float targY = GetUnitY( target );
	float dist = MathDistanceBetweenPoints( x, y, targX, targY );
	float angle = MathAngleBetweenPoints( x, y, targX, targY );
	float moveX = MathPointProjectionX( x, angle, 20.f );
	float moveY = MathPointProjectionY( y, angle, 20.f );

	if ( dist > 150.f )
	{
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
		SetUnitXY( source, moveX, moveY );
		SetUnitFacingInstant( source, angle );
	}
	else
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );

		PlayHeroSound( source, 'psnd' + 'R1', 90.f, .0f );
		SetUnitAnimation( source, "spell two" );

		effect ef;
		// "Units\\Creeps\\LavaSpawn\\LavaSpawn.mdl"

		ef = CreateEffectEx( "Abilities\\Weapons\\DemolisherFireMissile\\DemolisherFireMissile.mdl", moveX, moveY, 50.f, angle, 1.f, 1.f );
		SetSpecialEffectPitch( ef, -90.f );
		DestroyEffect( ef );

		ef = CreateEffectEx( "GeneralEffects\\t_huobao.mdl", moveX, moveY, 100.f, angle, 1.f, 1.f );
		SetSpecialEffectPitch( ef, -90.f );
		SetEffectTimedLife( ef, 2.f );

		for ( int i = 0; i < 3; i++ )
		{
			float face = 120.f * i;
			moveX = MathPointProjectionX( targX, face, 150.f );
			moveY = MathPointProjectionY( targY, face, 150.f );

			DestroyEffect( CreateEffectEx( "Units\\Creeps\\LavaSpawn\\LavaSpawn.mdl", moveX, moveY, .0f, .0f, 1.5f, 1.f ) );
			DestroyEffect( CreateEffectEx( "Characters\\Akainu\\magmablast2.mdl", moveX, moveY, 120.f, face, .5f, 1.5f ) );
		}

		GroupEnumUnitsInRange( GroupEnum, GetUnitX( target ), GetUnitY( target ), 300.f, nil );
		float dmg = 200 + 25.f * GetHeroLevel( source ) + .5f * GetHeroInt( source, true );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				if ( u == target )
				{
					ACF_StunUnit( u, 2.f );
					DisplaceWar3ImageLinear( target, angle, -300.f, .4f, .01f, false, false );
				}
			}
		}

		ReleaseTimer( tmr );
	}
}

void Akainu_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( StopSpell( hid, 0, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'E1' );
		ReleaseTimer( tmr );
	}

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = LoadReal( GameHT, hid, 'angl' );

		PlayHeroSound( source, 'psnd' + 'E1', 90.f, .0f );
		ACF_StunUnit( source, .5f );
		SetUnitAnimation( source, "spell one" );

		effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, .0f, 1.5f, 1.f );
		SetEffectTimedLife( ef, 4.f );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
		DisplaceUnitWithArgs( source, angle, LoadReal( GameHT, hid, 'dist' ), .5f, .01f, 600.f );
	}
	else if ( ticks == 50 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		effect ef;

		ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, .0f, .0f, 1.5f, 1.f );

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );

		for ( int i = 0; i < 4; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, GetRandomReal( 0.f, 360.f ), 1.5f, 1.25f ); 
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "Characters\\Akainu\\magmablast2.mdl", x, y, .0f, 90.f * i, .5f, 1.5f );
			SetEffectTimedLife( ef, 2.f );
		}

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 350.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
			}
		}

		ReleaseTimer( tmr );
	}
}

void Akainu_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 1, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'R1' );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		ACF_StunUnit( source, .25f );
		SetUnitTimeScale( source, 2.f );
		SetUnitAnimation( source, "attack" );
	}
	else if ( ticks == 20 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = LoadReal( GameHT, hid, 'angl' );

		SetUnitTimeScale( source, 1 );

		projectile proj = CreateProjectileEx( source, 'B-Mi', 0 );
		SetProjectileModel( proj, "Characters\\Akainu\\magmablast2.mdl" ); // Characters\\Akainu\\moon_shin_mg1.mdl
		SetProjectileScale( proj, 1.5f );
		SetProjectilePositionWithZ( proj, MathPointProjectionX( x, angle, 40.f ), MathPointProjectionY( y, angle, 40.f ), GetUnitZ( source ) + 100.f );
		SetProjectileDamage( proj, 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true ) );
		SetProjectileAttackType( proj, ATTACK_TYPE_NORMAL );
		SetProjectileDamageType( proj, DAMAGE_TYPE_MAGIC );
		SetProjectileWeaponType( proj, WEAPON_TYPE_WHOKNOWS );
		SetProjectileArc( proj, .0f );
		SetProjectileSpeed( proj, 1500.f );
		LaunchProjectileTarget( proj, LoadUnitHandle( GameHT, hid, 'utrg' ) );
		SaveInteger( GameHT, GetHandleId( proj ), 'atid', LoadInteger( GameHT, hid, 'atid' ) );

		ReleaseTimer( tmr );
	}
}

void Akainu_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		StopHeroSound( source, 'psnd' + 'Q1' );
		StopHeroSound( source, 'psnd' + 'R2' );

		DestroyGroup( LoadGroupHandle( GameHT, hid, '+grp' ) );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		PlayHeroSound( source, 'psnd' + 'Q1', 90.f, .0f );
		SetUnitTimeScale( source, 2 );
		ACF_StunUnit( source, .2f );
		SetUnitAnimation( source, "attack" );

		SaveGroupHandle( GameHT, hid, '+grp', CreateGroup( ) );
	}
	else if ( ticks == 20 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float angle = LoadReal( GameHT, hid, 'angl' );

		effect ef = CreateEffectEx( "Characters\\Akainu\\moon_shin_dph23.mdl", MathPointProjectionX( x, angle, 300.f ), MathPointProjectionY( y, angle, 300.f ), 100.f, angle, 2.f, 1.f );
		SetEffectTimedLife( ef, 1.f );

		SetUnitTimeScale( source, 1.f );
		PlayHeroSound( source, 'psnd' + 'R2', 60.f, .0f );
	}
	else if ( ticks > 20 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		group g = LoadGroupHandle( GameHT, hid, '+grp' );
		float angle = LoadReal( GameHT, hid, 'angl' );
		float dist = LoadReal( GameHT, hid, 'edst' ) + 100.f;
		float x = MathPointProjectionX( LoadReal( GameHT, hid, 'srcX' ), angle, dist );
		float y = MathPointProjectionY( LoadReal( GameHT, hid, 'srcY' ), angle, dist );

		SaveReal( GameHT, hid, 'edst', dist );

		for ( int i = 0; i < 2; i++ )
		{
			float efAngle = GetRandomReal( 0.f, 360.f );
			float efDist = GetRandomReal( 0.f, 500.f );
			float efX = MathPointProjectionX( x, efAngle, efDist );
			float efY = MathPointProjectionY( y, efAngle, efDist );

			DestroyEffect( CreateEffectEx( "Characters\\Akainu\\magmablast2.mdl", efX, efY, 120.f, GetRandomReal( 0.f, 360.f ), .5f, 1.f ) );
			DestroyEffect( AddSpecialEffect( "abilities\\weapons\\catapult\\catapultmissile.mdl", efX, efY ) );
		}

		float dmg = 100.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		GroupEnumUnitsInRange( GroupEnum, x, y, 500.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) && !IsUnitInGroup( u, g ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
				GroupAddUnit( g, u );
			}
		}

		if ( dist >= 1500.f )
		{
			DestroyGroup( g );
			ReleaseTimer( tmr );
		}
	}
}

void Akainu_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'T1' );
		HandleListCleanEffects( LoadHandleList( GameHT, hid, 'elst' ), true, true );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		ACF_StunUnit( source, 50 * .025f );
		PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
		SetUnitAnimation( source, "Spell" );
		SaveHandleList( GameHT, hid, 'elst', HandleListCreate( ) );
		// "Characters\\Akainu\\moon_shin_dph12.mdl"
	}
	else if ( ticks >= 10 )
	{
		handlelist eflist = LoadHandleList( GameHT, hid, 'elst' );
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );

		if ( CounterEx( hid, 0, 5 ) )
		{
			int count = LoadInteger( GameHT, hid, 'cout' );

			if ( count < 50 )
			{
				float dist = GetRandomReal( 0.f, 550.f );
				float face = GetRandomReal( 0.f, 360.f );

				effect ef = CreateEffectEx( "Characters\\Akainu\\moon_shin_dph12.mdl", MathPointProjectionX( targX, face, dist ), MathPointProjectionY( targY, face, dist ), 1000.f, GetRandomReal( 0.f, 360.f ), .4f, .0f );
				SetSpecialEffectAnimationOffsetPercent( ef, .75f );
				//SetSpecialEffectPitch( ef, GetRandomReal( -10.f, -45.f ) );
				HandleListAddHandle( eflist, ef );

				SaveInteger( GameHT, hid, 'cout', count + 1 );
			}
		}

		int maxCount = HandleListGetEffectCount( eflist );

		for ( int i = 0; i < maxCount; i++ )
		{
			effect ef = HandleListGetEffectByIndex( eflist, i );
			float x = GetSpecialEffectX( ef );
			float y = GetSpecialEffectY( ef );
			float angle = MathAngleBetweenPoints( x, y, targX, targY );
			float dist = MathDistanceBetweenPoints( x, y, targX, targY );
			float newHeight = GetSpecialEffectHeight( ef ) - GetRandomReal( 15.f, 25.f );

			if ( dist >= 20.f )
			{
				SetSpecialEffectX( ef, MathPointProjectionX( x, angle, 20.f ) );
				SetSpecialEffectY( ef, MathPointProjectionY( y, angle, 20.f ) );
			}
			SetSpecialEffectHeight( ef, newHeight );

			if ( newHeight <= .0f )
			{
				player p = LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
				float dmg = 25.f * GetHeroLevel( source ) + GetHeroInt( source, true ) * .05f;
				GroupEnumUnitsInRange( GroupEnum, GetSpecialEffectX( ef ), GetSpecialEffectY( ef ), 500.f, nil );

				for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
				{
					if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
					{
						ACF_DamageTarget( source, u, dmg );
					}
				}

				HandleListRemoveHandle( eflist, ef );
				SetSpecialEffectTimeScale( ef, 1.f );
				DestroyEffect( ef );
				maxCount--;
				i--;
			}
		}

		if ( maxCount == 0 )
		{
			HandleListCleanEffects( LoadHandleList( GameHT, hid, 'elst' ), true, true );
			ReleaseTimer( tmr );
		}
	}
}
//

// Reinforce Spells
void Reinforce_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( StopSpell( hid, 0, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'Q1' );

		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );
		effect ef;

		PlayHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'Q1', 60.f, .0f );

		ef = CreateEffectEx( "Characters\\Reinforce\\BlackHole.mdl", targX, targY, .0f, 270.f, 1.2f, 1.f );
		SetEffectTimedLife( ef, 1.f );

		ef = CreateEffectEx( "Characters\\SaberAlter\\DarkExplosion.mdl", targX, targY, .0f, 270.f, 1.2f, 1.f );
		SetEffectTimedLife( ef, 3.f );
	}
	else
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );

		GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				float x = GetUnitX( u );
				float y = GetUnitY( u );
				float angle = MathAngleBetweenPoints( x, y, targX, targY ) + 60.f;

				SetUnitXY( u, MathPointProjectionX( x, angle, 10.f ), MathPointProjectionY( y, angle, 10.f ) );
			}
		}

		if ( ticks >= 100 )
		{
			effect ef;

			ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, 50.f, 270.f, 5.f, 2.f );
			SetEffectTimedLife( ef, 3.f );

			ef = CreateEffectEx( "Characters\\Reinforce\\firaga6.mdl", targX, targY, 75.f, 270.f, 4.f, .8f );
			SetEffectTimedLife( ef, 3.f );

			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );

			GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					float x = GetUnitX( u );
					float y = GetUnitY( u );
					float angle = MathAngleBetweenPoints( x, y, targX, targY );

					if ( ACF_DamageTarget( source, u, dmg ) )
					{
						DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
						ACF_StunUnit( u, 2.f );
					}
					
					DisplaceUnitWithArgs( u, angle, -200.f, 1, .01f, 0 );
				}
			}

			ReleaseTimer( tmr );
		}
	}
}

void Reinforce_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	
	if ( StopSpell( hid, 1, true ) )
	{
		StopHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'W1' );
		HandleListCleanEffects( LoadHandleList( GameHT, hid, 'elst' ), true, true );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		handlelist hl = HandleListCreate( );

		PlayHeroSound( source, 'psnd' + 'W1', 60.f, .0f );
		SaveHandleList( GameHT, hid, 'elst', hl );

		for ( int i = 0; i < 20; i++ )
		{
			float face = 36.f * i;
			float dist = GetRandomReal( 100.f, 1000.f );
			float x = MathPointProjectionX( targX, face, dist );
			float y = MathPointProjectionY( targY, face, dist );
			float angle = MathAngleBetweenPoints( x, y, targX, targY );
			float height = GetRandomReal( 500.f, 1000.f );

			effect ef;

			ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect.mdl", x, y, height, angle, 1.5f, 1.f );
			SetSpecialEffectColour( ef, 0xFFFF0000 );
			SetSpecialEffectPitch( ef, -45.f );

			HandleListAddHandle( hl, ef );

			ef = CreateEffectEx( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", x, y, height, angle, 1.f, 1.f );
			SetSpecialEffectColour( ef, 0xFFFF0000 );
			DestroyEffect( ef );
		}
	}
	else if ( ticks >= 100 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		handlelist eflist = LoadHandleList( GameHT, hid, 'elst' );

		for ( int i = 0; i < HandleListGetEffectCount( eflist ); i++ )
		{
			effect ef = HandleListGetEffectByIndex( eflist, i );
			SetSpecialEffectFacing( ef, MathAngleBetweenPoints( GetSpecialEffectX( ef ), GetSpecialEffectY( ef ), targX, targY ) );
			SetSpecialEffectX( ef, targX );
			SetSpecialEffectY( ef, targY );
			SetSpecialEffectHeight( ef, .0f );
		}

		float dmg = 250.f + 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
		ACF_StunUnit( target, 1 );
		ACF_DamageTarget( source, target, dmg );
		HandleListCleanEffects( LoadHandleList( GameHT, hid, 'elst' ), true, true );
		ReleaseTimer( tmr );
	}
}

void Reinforce_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( StopSpell( hid, 0 ) ) { return; }

	if ( ticks == 0 )
	{
		PlayHeroSound( LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'E1', 60.f, .0f );
	}
	else if ( ticks == 100 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );
		effect ef;

		DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", targX, targY ) );
		DestroyEffect( AddSpecialEffect( "Characters\\Reinforce\\ApocalypseStomp.mdx", targX, targY ) );

		ef = CreateEffectEx( "GeneralEffects\\moonwrath.mdl", targX, targY, 0.f, .0f, 4.f, 1.f );
		SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
		SetEffectTimedLife( ef, 4.f );

		ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, .0f, .0f, 2.5f, .75f );
		SetEffectTimedLife( ef, 4.f );

		float dmg = 60.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		GroupEnumUnitsInRange( GroupEnum, targX, targY, 450.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				if ( ACF_DamageTarget( LoadUnitHandle( GameHT, hid, 'usrc' ), u, dmg ) )
				{
					ACF_AddBuffTimed( u, 'Bslo', 1.f );
				}
			}
		}

		ReleaseTimer( tmr );
	}
}

void Reinforce_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

	if ( StopSpell( hid, 1, true ) )
	{
		StopHeroSound( source, 'psnd' + 'R1' );
		ReleaseTimer( tmr );
		return;
	}

	int ticks = SpellTickEx( hid );
	unit target = LoadUnitHandle( GameHT, hid, 'utrg' );

	if ( ticks == 0 )
	{
		PlayHeroSound( source, 'psnd' + 'R1', 60.f, .0f );
		ACF_StunUnit( source, .25f );
		SetUnitPathing( source, false );
		SetUnitAnimation( source, "walk" );
	}

	if ( CounterEx( hid, 0, 10 ) )
	{
		ACF_StunUnit( source, .10f );
		//ACF_DisableUnitTP( target, .10f ); // this adds up
	}

	float x = GetUnitX( source );
	float y = GetUnitY( source );
	float targX = GetUnitX( target );
	float targY = GetUnitY( target );
	float dist = MathDistanceBetweenPoints( x, y, targX, targY );
	float angle = MathAngleBetweenPoints( x, y, targX, targY );
	float moveX = MathPointProjectionX( x, angle, 20.f );
	float moveY = MathPointProjectionY( y, angle, 20.f );

	if ( dist > 150.f )
	{
		DestroyEffect( AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
		SetUnitXY( source, moveX, moveY );
		SetUnitFacingInstant( source, angle );
	}
	else
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		effect ef;

		ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 50.f, angle, 1.5f, 2.f );
		SetSpecialEffectPitch( ef, -90.f );
		SetEffectTimedLife( ef, 4.f );

		ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.5f, 2.f );
		SetSpecialEffectPitch( ef, -90.f );
		SetEffectTimedLife( ef, 3.f );

		GroupEnumUnitsInRange( GroupEnum, GetUnitX( target ), GetUnitY( target ), 400.f, nil );
		float dmg = 150.f * GetHeroLevel( source ) + GetHeroInt( source, true );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
			}
		}

		StopHeroSound( source, 'psnd' + 'R1' );
		ReleaseTimer( tmr );
	}
}

void Reinforce_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( ticks == 0 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
		SaveReal( GameHT, hid, 'disp', 800 );
		ACF_DisableUnitTP( source, 3.f );
		ACF_StunUnit( source, 3.f );
		SetUnitAnimation( source, "spell channel" );
	}

	if ( ticks < 70 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

		if ( IsUnitDead( source ) )
		{
			StopSound( LoadSoundHandle( SoundHT, GetHandleId( source ), 'psnd' + 'T1' ), false, false );
			SetAbilityRemainingCooldown( GetUnitAbility( source, 'A04K' ), .01f );
			RemoveEffect( LoadEffectHandle( GameHT, hid, '+eff' + 0 ) );

			ReleaseTimer( tmr );
			return;
		}

		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );
		float mangl = LoadReal( GameHT, hid, 'disp' );

		DisplaceCircular( p, targX, targY, 450.f, mangl, 2.5f, "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl" );

		SaveReal( GameHT, hid, 'disp', mangl - 16.f );
	}
	else if ( ticks == 70 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		effect ef = CreateEffectEx( "Characters\\Reinforce\\CosmicField.mdl", LoadReal( GameHT, hid, 'trgX' ), LoadReal( GameHT, hid, 'trgY' ), .0f, .0f, 5.f, 1.f );
		//SetSpecialEffectAnimation( ef, "birth" );
		SaveEffectHandle( GameHT, hid, '+eff' + 0, ef );

		SetUnitAnimation( source, "attack slam" );
	}
	else if ( ticks == 120 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float facing = GetUnitFacing( source );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		effect ef;

		SetUnitAnimation( source, "spell channel" );

		for ( int i = 1; i < 6; i++ )
		{
			ef = CreateEffectEx( "Characters\\Reinforce\\mfqwd.mdl", x, y, .0f, .0f, 1.f * i, .05f * i );
			SetSpecialEffectColour( ef, 0xFFFF32FF ); // green = 50
			SetEffectTimedLife( ef, 1.8f );
		}

		float targX = MathPointProjectionX( x, GetUnitFacing( source ), 130.f );
		float targY = MathPointProjectionY( y, GetUnitFacing( source ), 130.f );

		ef = CreateEffectEx( "Characters\\Reinforce\\t_xuliyy.mdl", targX, targY, 30.f, .0f, 1.f, 1.f );
		SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
		SetEffectTimedLife( ef, 2.f ); // 3.6f
	}
	else if ( ticks == 280 )
	{
		SetUnitAnimation( LoadUnitHandle( GameHT, hid, 'usrc' ), "spell slam" );
	}
	else if ( ticks == 300 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		float targX = LoadReal( GameHT, hid, 'trgX' );
		float targY = LoadReal( GameHT, hid, 'trgY' );
		float dmg = 400.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		effect ef;

		ef = CreateEffectEx( "Characters\\Reinforce\\ShadowExplosion.mdl", targX, targY, 50.f, .0f, 10.f, 1.f );
		SetEffectTimedLife( ef, 4.f );

		ef = CreateEffectEx( "GeneralEffects\\moonwrath.mdl", targX, targY, 0.f, .0f, 10.f, 1.f );
		SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
		SetEffectTimedLife( ef, 4.f );

		ef = CreateEffectEx( "GeneralEffects\\apocalypsecowstomp.mdl", targX, targY, 0.f, .0f, 3.5f, 1.f );
		SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
		SetEffectTimedLife( ef, 3.f );

		GroupEnumUnitsInRange( GroupEnum, targX, targY, 900.f, nil );

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
				DisplaceWar3ImageLinear( u, MathAngleBetweenPoints( targX, targY, GetUnitX( u ), GetUnitY( u ) ), 300.f, 1.f, .01f, false, false );
			}
		}

		RemoveEffect( LoadEffectHandle( GameHT, hid, '+eff' + 0 ) );
		ReleaseTimer( tmr );
	}
}
//

// Arcueid Spells
void Arcueid_Q( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( !StopSpell( hid, 0 ) )
	{
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
			ACF_StunUnit( source, .25f );
			SetUnitTimeScale( source, 2 );
			SetUnitAnimation( source, "Spell One" );
		}
		else if ( ticks == 20 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float dmg = 250.f + GetHeroLevel( source ) * 70.f + GetHeroInt( source, true );
			float x = LoadReal( GameHT, hid, 'srcX' );
			float y = LoadReal( GameHT, hid, 'srcY' );

			PlayHeroSound( source, 'gsnd' + 0, 100.f, .0f );
			GroupEnumUnitsInRange( GroupEnum, LoadReal( GameHT, hid, 'trgX' ), LoadReal( GameHT, hid, 'trgY' ), 300.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitEnemy( u, GetOwningPlayer( source ) ) )
				{
					float u_x = GetUnitX( u );
					float u_y = GetUnitY( u );
					float angle = MathAngleBetweenPoints( x, y, u_x, u_y );

					DisplaceUnitWithArgs( u, angle, -300.f, .5f, .01f, 250.f );
					ACF_DamageTarget( source, u, dmg );
					DestroyEffect( AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", u_x, u_y ) );
				}
			}

			SetUnitTimeScale( source, 1.f );
			ReleaseTimer( tmr );
		}
	}
}

void Arcueid_W( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( !StopSpell( hid, 0 ) )
	{
		if ( ticks == 0 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );

			ACF_StunUnit( source, .4f );
			SetUnitTimeScale( source, 1.75f );
			SetUnitAnimation( source, "Spell Five" );
		}
		if ( ticks == 10 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = GetUnitX( source );
			float y = GetUnitY( source );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, .0f, GetRandomReal( 1.5f, 2.f ), 1.5f );
				SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
				SetEffectTimedLife( ef, 4.f );
			}
		}
		else if ( ticks == 25 )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			float dmg = 350.f + 60.f * GetHeroLevel( source ) + GetHeroInt( source, true );

			GroupEnumUnitsInRange( GroupEnum, x, y, 450.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					float targX = GetUnitX( u );
					float targY = GetUnitY( u );
					float angle = MathAngleBetweenPoints( x, y, targX, targY );

					DisplaceWar3ImageLinear( u, angle, 200.f, .15f, .01f, false, false );
					ACF_DamageTarget( source, u, dmg );
				}
			}
		}
		else if ( ticks == 40 )
		{
			ReleaseTimer( tmr );
		}
	}
}

void Arcueid_E( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( !StopSpell( hid, 0 ) )
	{
		if ( ticks == 0 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, .0f, 1.5f, 1.5f );
			
			SetEffectTimedLife( ef, 4.f );
			ACF_StunUnit( source, .25f );
			SetUnitAnimation( source, "Attack Two" );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", x, y ) );
		}
		else if ( ticks == 15 )
		{
			ShowUnit( LoadUnitHandle( GameHT, hid, 'usrc' ), false );
		}
		else if ( ticks >= 25 )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float targX = LoadReal( GameHT, hid, 'trgX' );
			float targY = LoadReal( GameHT, hid, 'trgY' );
			float dmg = 100.f * GetHeroLevel( source ) + GetHeroInt( source, true );

			PlayHeroSound( source, 'gsnd' + 3, 60.f, .0f );
			SetUnitXY( source, targX, targY );
			ShowUnit( source, true );
			ACF_SelectUnit( source, p );
			GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					ACF_StunUnit( u, 1.f );
				}
			}

			DestroyEffect( AddSpecialEffect( "GeneralEffects\\SlamEffect.mdx", targX, targY ) );

			for ( int i = 0; i < 3; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, .0f, .0f, GetRandomReal( 1.5f, 2.f ), 1.5f );
				SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
				SetEffectTimedLife( ef, 4.f );
			}

			ReleaseTimer( tmr );
		}
	}
}

void Arcueid_R( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );
	int ticks = SpellTickEx( hid );

	if ( !StopSpell( hid, 0 ) )
	{
		if ( ticks == 0 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			
			ACF_StunUnit( source, .8f );
			SetUnitTimeScale( source, 1.75f );
			SetUnitAnimation( source, "Attack Slam" );

			ACF_DisableUnitTP( target, .8f );
		}
		else if ( ticks == 15 )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
			float x = GetUnitX( source );
			float y = GetUnitY( source );
			float targX = GetUnitX( target );
			float targY = GetUnitY( target );
			float angle = MathAngleBetweenPoints( x, y, targX, targY );
			float dmg = GetHeroLevel( source ) * 150 + GetHeroInt( source, true ) * .5f;

			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, angle, 1.5f, 1.5f );
			SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
			SetEffectTimedLife( ef, 4.f );

			PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );
			ACF_DamageTarget( source, target, dmg );
			SetUnitFlyHeightEx( target, 600.f, 4000.f );
		}
		else if ( ticks == 25 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			DestroyEffect( AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", GetUnitX( source ), GetUnitY( source ) ) );
		}
		else if ( ticks == 30 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

			SetUnitFlyHeightEx( source, 700.f, 4000.f );
			SetUnitAnimation( source, "Attack Two" );
		}
	}

	if ( ticks == 60 )
	{
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float targX = GetUnitX( target );
		float targY = GetUnitY( target );
		float angle = MathAngleBetweenPoints( x, y, targX, targY );
		float dmg = GetHeroLevel( source ) * 50 + GetHeroInt( source, true ) * .5f;

		effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 800.f, angle, 1.5f, 1.5f );
		SetSpecialEffectPitch( ef, -90.f );
		SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
		SetEffectTimedLife( ef, 4.f );

		ACF_DamageTarget( source, target, dmg );
		SetUnitFlyHeightEx( target, 0, 2000.f );
		SetUnitFlyHeightEx( source, 0, 99999.f );
		DisplaceWar3ImageLinear( target, angle, 250.f, .2f, .01f, false, false );
	}
	else if ( ticks >= 80 )
	{
		player p = LoadPlayerHandle( GameHT, hid, '+ply' );
		unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = LoadUnitHandle( GameHT, hid, 'utrg' );
		float x = GetUnitX( source );
		float y = GetUnitY( source );
		float dmg = 50.f * GetHeroLevel( source ) + GetHeroInt( source, true );
		effect ef;
		
		ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, 0.f, GetRandomReal( 0.f, 360.f ), 1.5f, 1.f );
		SetEffectTimedLife( ef, 1.f );

		for ( int i = 0; i < 3; i++ )
		{
			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, .0f, GetRandomReal( 1.5f, 2.f ), 1.5f );
			SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
			SetEffectTimedLife( ef, 4.f );
		}

		for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
		{
			if ( IsUnitAlive( u ) && IsUnitEnemy( u, p ) )
			{
				ACF_DamageTarget( source, u, dmg );
				ACF_StunUnit( u, 1.f );
			}
		}

		ReleaseTimer( tmr );
	}
}

void Arcueid_T( )
{
	timer tmr = GetExpiredTimer( );
	int hid = GetHandleId( tmr );

	if ( !StopSpell( hid, 0 ) )
	{
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = LoadReal( GameHT, hid, 'srcX' );
			float y = LoadReal( GameHT, hid, 'srcY' );

			PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
			ACF_StunUnit( source, .5f );
			SetEffectTimedLife( AddSpecialEffect( "GeneralEffects\\ValkDust.mdl", GetUnitX( source ), GetUnitY( source ) ), 4.f );
			SetUnitAnimation( source, "Spell Six" );

			DestroyEffect( AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", x, y ) );
		}
		else if ( ticks == 25 )
		{
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

			ShowUnit( source, false );
			SetUnitXY( source, LoadReal( GameHT, hid, 'trgX' ), LoadReal( GameHT, hid, 'trgY' ) );
		}
		else if ( ticks == 45 )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float targX = LoadReal( GameHT, hid, 'trgX' );
			float targY = LoadReal( GameHT, hid, 'trgY' );
			float dmg = 200.f * GetHeroLevel( source ) + GetHeroInt( source, true );
 
			GroupEnumUnitsInRange( GroupEnum, targX, targY, 600.f, nil );

			for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
			{
				if ( IsUnitEnemy( u, p ) )
				{
					for ( int i = 0; i < 3; i++ )
					{
						effect ef = CreateEffectEx( "GeneralEffects\\ShortSlash\\ShortSlash.mdl", GetUnitX( u ), GetUnitY( u ), GetUnitFlyHeight( u ) + 50.f, i * GetRandomInt( 60, 90 ), GetRandomReal( .75f, 1.f ), GetRandomReal( .75f, 1.f ) );
						DestroyEffect( ef );
					}

					ACF_DamageTarget( source, u, dmg );
					DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
					DestroyEffect( AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "head" ) );
				}
			}
		}
		else if ( ticks == 50 )
		{
			player p = LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = LoadUnitHandle( GameHT, hid, 'usrc' );
			float targX = LoadReal( GameHT, hid, 'trgX' );
			float targY = LoadReal( GameHT, hid, 'trgY' );

			ShowUnit( source, true );
			SetUnitAnimation( source, "Stand" );
			ACF_SelectUnit( source, p );

			for ( int i = 0; i < 3; i++ )
			{
				effect ef = AddSpecialEffect( "GeneralEffects\\ValkDust.mdl", targX, targY );
				SetSpecialEffectScale( ef, 2.f );
				SetSpecialEffectTimeScale( ef, GetRandomReal( .5f, 2.f ) );
				SetEffectTimedLife( ef, 4.f );
			}

			ReleaseTimer( tmr );
		}
	}
}
//

void TeleportToSavedLocation( player p )
{
	int pid = GetPlayerId( p );
	int p_hid = GetHandleId( p );
	float targX = LoadReal( DataHT, p_hid, '+tpX' );
	float targY = LoadReal( DataHT, p_hid, '+tpY' );
	unit u = MUnitArray[pid];

	DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffYou have been teleported to saved position" );
	DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX( u ), GetUnitY( u ) ) );
	SetUnitXY( u, targX, targY );
	DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", targX, targY ) );
	ACF_PanCameraToTimed( p, targX, targY, .0f );
}

timer Spells_Handler( ability abil, unit source, unit target, float targX, float targY, CallbackFunc@ act )
{
	timer tmr = CreateTimer( );
	int hid = GetHandleId( tmr );
	int aid = GetAbilityTypeId( abil );
	int alvl = GetAbilityLevel( abil );
	int lvl = GetHeroLevel( source );
	int uid = GetUnitTypeId( source );
	player p = GetOwningPlayer( source );
	float x = GetUnitX( source );
	float y = GetUnitY( source );
	float facing = GetUnitFacing( source );
	float angle = facing;

	SaveInteger( GameHT, hid, 'utid', uid );
	SaveInteger( GameHT, hid, 'ulvl', lvl );
	SaveInteger( GameHT, hid, 'atid', aid );
	SaveInteger( GameHT, hid, 'alvl', alvl );

	SaveReal( GameHT, hid, 'srcX', GetUnitX( source ) );
	SaveReal( GameHT, hid, 'srcY', GetUnitY( source ) );
	SaveReal( GameHT, hid, 'face', facing );

	SavePlayerHandle( GameHT, hid, '+ply', p );
	SaveAbilityHandle( GameHT, hid, 'abil', abil );
	SaveUnitHandle( GameHT, hid, 'usrc', source );

	if ( target != nil )
	{
		SaveUnitHandle( GameHT, hid, 'utrg', target );
		targX = GetUnitX( target );
		targY = GetUnitY( target );
	}

	SaveReal( GameHT, hid, 'angl', x == targX && y == targY ? facing : MathAngleBetweenPoints( x, y, targX, targY ) );
	SaveReal( GameHT, hid, 'dist', MathDistanceBetweenPoints( x, y, targX, targY ) );
	SaveReal( GameHT, hid, 'trgX', targX );
	SaveReal( GameHT, hid, 'trgY', targY );

	if ( !( act is null ) )
	{
		TimerStart( tmr, .01f, true, act );
	}
	
	return tmr;
}

timer Spells_Handler( CallbackFunc@ act )
{
	return Spells_Handler( nil, nil, nil, .0f, .0f, act );
}

bool IsStopCast( unit target, float targX, float targY )
{
	return target == nil && IsTerrainPathable( targX, targY, PATHING_TYPE_WALKABILITY );
}

void OnAnyItemPick( )
{
	int charges = 0;
	int max = 2;
	unit u = GetTriggerUnit( );
	player p = GetOwningPlayer( u );
	item itm = GetManipulatedItem( );
	int iid = GetItemTypeId( itm );

	if ( GetItemPlayer( itm ) == Player( PLAYER_NEUTRAL_PASSIVE ) )
	{
		SetItemPlayer( itm, p, false );
	}

	if ( GetItemPlayer( itm ) != p )
	{
		UnitRemoveItem( u, itm );
		DisplayTextToPlayer( p, .0f, .0f, "|c00ffff00That is not your Item!|r" );
		return;
	}

	if ( GetItemCharges( itm ) > 0 ) // if stacked item
	{
		for ( int i = 0; i < 6; i++ )
		{
			item itm_tmp = UnitItemInSlot( u, i ); if ( itm_tmp == itm || GetItemTypeId( itm ) != GetItemTypeId( itm_tmp ) ) { continue; }

			if ( GetItemCharges( itm_tmp ) + GetItemCharges( itm ) <= max )
			{
				charges = GetItemCharges( itm_tmp ) + GetItemCharges( itm );
				SetItemCharges( itm_tmp, charges );
				RemoveItem( itm );
				break;
			}
		}
	}

	switch( iid )
	{
		case 'I00P': // Cloak of Flames
		{
			if ( ACF_CountItems( u, iid ) == 1 )
			{
				timer tmr = CreateTimer( );
				int hid = GetHandleId( tmr );

				SavePlayerHandle( GameHT, hid, '+ply', p );
				SaveUnitHandle( GameHT, hid, 'usrc', u );
			
				TimerStart( tmr, 1.f, true,
					function( )
					{
						timer tmr = GetExpiredTimer( );
						int hid = GetHandleId( GetExpiredTimer( ) );
						unit source = LoadUnitHandle( GameHT, hid, 'usrc' );

						if ( IsUnitAlive( source ) && ACF_UnitHasItemById( source, 'I00P' ) )
						{
							player p = LoadPlayerHandle( GameHT, hid, '+ply' );
							float x = GetUnitX( source );
							float y = GetUnitY( source );
							float aoe = 300.f;
							float dmg = 30.f + 10.f * GetHeroLevel( source );
							
							GroupEnumUnitsInRange( GroupEnum, x, y, aoe, nil );

							for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
							{
								if ( IsUnitEnemy( u, p ) && !IsUnitInvisible( u, p ) )
								{
									ACF_DamageTarget( source, u, dmg );
									DestroyEffect( AddSpecialEffectTarget( "Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedDamage.mdl", u, "chest" ) );
								}
							}
						}
						else
						{
							PauseTimer( tmr );
							FlushChildHashtable( GameHT, hid );
							DestroyTimer( tmr );
						}
					}
				 );
			}

			break;
		}
		case 'I02R': // Item Certificate
		{
			int piid = LoadInteger( DataHT, GetUnitTypeId( u ), 'pitm' );
			RemoveItem( itm );

			if ( GetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD ) >= 10000 )
			{
				if ( ACF_CountItems( u, piid ) == 0 )
				{
					UnitAddItemById( u, piid );
					SetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD ) - 10000 );
				}
			}

			break;
		}
		case 'I04E': // str tome
		case 'I04D': // agi tome
		case 'I00C': // int tome
		{
			int goldCost = 0;
			int statBonus = 0;
			int statType = 0;

			switch( iid )
			{
				case 'I04E': // str tome
				{
					goldCost = 1000;
					statBonus = 10;
					statType = '+str';

					break;
				}
				case 'I04D': // str tome
				{
					goldCost = 1000;
					statBonus = 10;
					statType = '+agi';

					break;
				}
				case 'I00C': // str tome
				{
					goldCost = 1000;
					statBonus = 10;
					statType = '+int';

					break;
				}
			}

			if ( statType == 0 ) { break; }

			timer tmr = CreateTimer( );
			int hid = GetHandleId( tmr );

			SavePlayerHandle( GameHT, hid, '+ply', p );
			SaveUnitHandle( GameHT, hid, 'usrc', u );
			SaveInteger( GameHT, hid, 'cost', goldCost );
			SaveInteger( GameHT, hid, '+sts', statBonus );
			SaveInteger( GameHT, hid, 'styp', statType );

			TimerStart( tmr, .01f, true, 
				function( )
				{
					timer tmr = GetExpiredTimer( );
					int hid = GetHandleId( tmr );
					player p = LoadPlayerHandle( GameHT, hid, '+ply' );
					unit u = LoadUnitHandle( GameHT, hid, 'usrc' );
					int gold = GetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD );
					int cost = LoadInteger( GameHT, hid, 'cost' );

					if ( cost <= gold )
					{
						SetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD, gold - cost );

						int statBonus = LoadInteger( GameHT, hid, '+sts' );

						switch( LoadInteger( GameHT, hid, 'styp' ) )
						{
							case '+str': SetHeroStr( u, GetHeroStr( u, false ) + statBonus, true ); break;
							case '+agi': SetHeroAgi( u, GetHeroAgi( u, false ) + statBonus, true ); break;
							case '+int': SetHeroInt( u, GetHeroInt( u, false ) + statBonus, true ); break;
						}
					}
					else
					{
						PauseTimer( tmr );
						FlushChildHashtable( GameHT, hid );
						DestroyTimer( tmr );
					}
				}
			 );

			return;
		}
	}

	// Item Combinations

	if ( iid == 'I03U' )
	{
		if ( ACF_CountItems( u, 'I03U' ) > 1 )
		{
			RemoveItem( ACF_GetItemById( u, 'I03U' ) );
			RemoveItem( ACF_GetItemById( u, 'I03U' ) );
			UnitAddItemById( u, 'I00Y' );
		}
	}
	else if ( ACF_CountItems( u, 'I03X' ) > 0 && ACF_CountItems( u, 'I03Z' ) > 0 && ACF_CountItems( u, 'I03U' ) > 0 )
	{
		RemoveItem( ACF_GetItemById( u, 'I03U' ) );
		RemoveItem( ACF_GetItemById( u, 'I03Z' ) );
		RemoveItem( ACF_GetItemById( u, 'I03X' ) );
		UnitAddItemById( u, 'I00X' );
	}
	else if ( ACF_CountItems( u, 'I03V' ) > 0 && ACF_CountItems( u, 'I03Z' ) > 0 )
	{
		RemoveItem( ACF_GetItemById( u, 'I03V' ) );
		RemoveItem( ACF_GetItemById( u, 'I03Z' ) );
		UnitAddItemById( u, 'I00R' );
	}
	else if ( ACF_CountItems( u, 'I03X' ) > 0 && ACF_CountItems( u, 'I03Y' ) > 0 )
	{
		RemoveItem( ACF_GetItemById( u, 'I03Y' ) );
		RemoveItem( ACF_GetItemById( u, 'I03X' ) );
		UnitAddItemById( u, 'I00S' );
	}
	else if ( ACF_CountItems( u, 'I03Y' ) > 0 && ACF_CountItems( u, 'I03V' ) > 0 )
	{
		RemoveItem( ACF_GetItemById( u, 'I03Y' ) );
		RemoveItem( ACF_GetItemById( u, 'I03V' ) );
		UnitAddItemById( u, 'I00Z' );
	}
	else if ( ACF_CountItems( u, 'I03X' ) > 0 && ACF_CountItems( u, 'I03W' ) > 0 )
	{
		RemoveItem( ACF_GetItemById( u, 'I03X' ) );
		RemoveItem( ACF_GetItemById( u, 'I03W' ) );
		UnitAddItemById( u, 'I00U' );
	}
	else if ( ACF_CountItems( u, 'I00Q' ) > 0 && ACF_CountItems( u, 'I00K' ) > 0 )
	{
		RemoveItem( ACF_GetItemById( u, 'I00Q' ) );
		RemoveItem( ACF_GetItemById( u, 'I00K' ) );
		UnitAddItemById( u, 'I00R' );
	}
	else if ( ACF_CountItems( u, 'I00Q' ) > 0 && ACF_CountItems( u, 'I00N' ) > 0 )
	{
		RemoveItem( ACF_GetItemById( u, 'I00Q' ) );
		RemoveItem( ACF_GetItemById( u, 'I00N' ) );
		UnitAddItemById( u, 'I00S' );
	}
	else if ( ACF_CountItems( u, 'I00O' ) > 0 && ACF_CountItems( u, 'I00I' ) > 0 )
	{
		RemoveItem( ACF_GetItemById( u, 'I00O' ) );
		RemoveItem( ACF_GetItemById( u, 'I00I' ) );
		UnitAddItemById( u, 'I00U' );
	}
	else if ( ACF_CountItems( u, 'I00N' ) > 0 && ACF_CountItems( u, 'I00K' ) > 0 )
	{
		RemoveItem( ACF_GetItemById( u, 'I00N' ) );
		RemoveItem( ACF_GetItemById( u, 'I00K' ) );
		UnitAddItemById( u, 'I00Z' );
	}
	else if ( ACF_CountItems( u, 'I02Q' ) > 0 && ACF_CountItems( u, 'I00J' ) > 0 && GetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD ) >= 3800 )
	{
		SetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( p, PLAYER_STATE_RESOURCE_GOLD ) - 3800 );
		RemoveItem( ACF_GetItemById( u, 'I02Q' ) );
		RemoveItem( ACF_GetItemById( u, 'I00J' ) );
		UnitAddItemById( u, 'I00T' );
	}
	else if ( ACF_CountItems( u, 'I01K' ) > 0 && ACF_CountItems( u, 'I01S' ) > 0 )
	{
		if ( GetItemCharges( ACF_GetItemById( u, 'I01S' ) ) == 1 && GetItemCharges( ACF_GetItemById( u, 'I01K' ) ) == 1 )
		{
			RemoveItem( ACF_GetItemById( u, 'I01S' ) );
			RemoveItem( ACF_GetItemById( u, 'I01K' ) );
			UnitAddItemById( u, 'I01T' );
		}
		else if ( GetItemCharges( ACF_GetItemById( u, 'I01S' ) ) == 2 && GetItemCharges( ACF_GetItemById( u, 'I01K' ) ) == 1 )
		{
			RemoveItem( ACF_GetItemById( u, 'I01S' ) );
			RemoveItem( ACF_GetItemById( u, 'I01K' ) );
			UnitAddItemById( u, 'I01T' );
			UnitAddItemById( u, 'I01S' );
		}
		else if ( GetItemCharges( ACF_GetItemById( u, 'I01S' ) ) == 1 && GetItemCharges( ACF_GetItemById( u, 'I01K' ) ) == 2 )
		{
			RemoveItem( ACF_GetItemById( u, 'I01S' ) );
			RemoveItem( ACF_GetItemById( u, 'I01K' ) );
			UnitAddItemById( u, 'I01T' );
			UnitAddItemById( u, 'I01K' );
		}
		else if ( GetItemCharges( ACF_GetItemById( u, 'I01S' ) ) == 2 && GetItemCharges( ACF_GetItemById( u, 'I01K' ) ) == 2 )
		{
			RemoveItem( ACF_GetItemById( u, 'I01S' ) );
			RemoveItem( ACF_GetItemById( u, 'I01K' ) );
			UnitAddItemById( u, 'I01T' );
			UnitAddItemById( u, 'I01T' );
		}
	}
}

bool OnProcessItemState( item itm )
{
	if ( GetItemLife( itm ) <= .0f )
	{
		RemoveItem( itm );
		return true;
	}

	return false;
}

void OnAnyItemDrop( )
{
	item itm = GetManipulatedItem( );

	if ( OnProcessItemState( itm ) ) { return; }


}

void OnAnyItemUsed( )
{
	unit source = GetTriggerUnit( );
	player p = GetOwningPlayer( source );
	int pid = GetPlayerId( p );
	float x = GetUnitX( source );
	float y = GetUnitY( source );
	item itm = GetManipulatedItem( );
	int iid = GetItemTypeId( itm );

	switch( iid )
	{
		case 'I01T': // Shadow Scroll
		{
			unit clone = CreateIllusionFromUnitEx( source, true ); // 'I01U'
			SetIllusionDamageDealt( clone, .0f );
			SetIllusionDamageReceived( clone, 1.f );
			UnitApplyTimedLife( clone, 'BTLF', 25.f );

			break;
		}
		case 'I01S': // Red Tablet
		{
			unit clone = CreateIllusionFromUnitEx( source, true ); // 'I00M'
			SetIllusionDamageDealt( clone, .0f );
			SetIllusionDamageReceived( clone, 1.f );
			UnitApplyTimedLife( clone, 'BTLF', 20.f );

			break;
		}
		case 'I003': // Scroll of Teleportation
		{
			if ( IsUnitCCed( source ) || IsUnitPaused( source ) )
			{
				DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffUnable to teleport!" );
			}
			else
			{
				TeleportToSavedLocation( p );
			}

			break;
		}
		case 'I00V': // Kawarimi
		{
			KawarimiTriggerUnitArray[pid] = source;
			DestroyEffect( AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", x, y ) );

			unit dummy = CreateUnit( p, 'n000', x, y, 270.f );
			SetUnitInvulnerable( source, true );
			PauseUnit( source, true );
			ShowUnit( source, false );
			UnitApplyTimedLife( dummy, 'BOmi', 3.f );

			break;
		}
	}
}

void OnAnySpellAction( )
{
	ability abil = GetSpellAbility( );
	unit source = GetTriggerUnit( );
	player p = GetOwningPlayer( source );
	unit target = GetSpellTargetUnit( );
	float targX = GetSpellTargetX( );
	float targY = GetSpellTargetY( );
	float delay = .0f;
	int aid = GetAbilityTypeId( abil );
	int hid = 0;
	eventid evId = GetTriggerEventId( );
	timer tmr;

	if ( evId == EVENT_PLAYER_UNIT_SPELL_CAST )
	{
		if ( aid == 'A01W' ) // Anti-TP stone
		{
			if ( GetUnitTypeId( target ) == 'H02M' )
			{
				DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffInvalid target!" );
				return;
			}
		}

		if ( aid == 'A021' || aid == 'A00X' )
		{

		}
		else
		{
			UnitRemoveAbility( source, 'B018' );
			UnitRemoveAbility( source, 'Binv' );
		}

		if ( IsUnitType( source, UNIT_TYPE_HERO ) && aid != 'A055' && aid != 'A01S' )
		{
			texttag txtTag = CreateTextTag( );
			float speed = 100.f;
			float angle = 90.f;
			float size = 13.f;
			float vel = speed * 0.071f / 128.f;
			float xvel = vel * Cos( Deg2Rad( angle ) );
			float yvel = vel * Sin( Deg2Rad( angle ) );
			float textHeight = size * 0.023f / 10.f;

			SetTextTagText( txtTag, GetObjectName( aid ), textHeight );
			SetTextTagColor( txtTag, 255, 0, 0, 100 );
			SetTextTagPosUnit( txtTag, source, 50 );
			SetTextTagVelocity( txtTag, xvel, yvel );
			SetTextTagPermanent( txtTag, false );
			SetTextTagLifespan( txtTag, 2.f );
			SetTextTagFadepoint( txtTag, .25f );
		}

		if ( LoadBoolean( GameHT, aid, 'PATH' ) && IsTerrainPathable( targX, targY, PATHING_TYPE_WALKABILITY ) ) // flag is inversed in the engine...
		{
			IssueImmediateOrder( source, "stop" );
			return;
		}
	}
	else
	{
		switch( aid )
		{
			case 'A00V': // Kunai of Boulders
			{
				for ( int i = 0; i < 10; i++ )
				{
					PauseUnit( CreateUnit( p, 'n002', targX + GetRandomReal( -125.f, 125.f ), targY + GetRandomReal( -125.f, 125.f ), GetRandomReal( 0.f, 360.f ) ), true );
				}

				break;
			}
			// Nanaya Shiki Spells
			case 'A02P': tmr = Spells_Handler( abil, source, nil, targX, targY, @NanayaShiki_D ); break;
			case 'A02M': tmr = Spells_Handler( abil, source, nil, targX, targY, @NanayaShiki_Q ); break;
			case 'A02N': tmr = Spells_Handler( abil, source, nil, targX, targY, @NanayaShiki_W ); break;
			case 'A02O': tmr = Spells_Handler( abil, source, target, targX, targY, @NanayaShiki_E ); break;
			case 'A02Q': tmr = Spells_Handler( abil, source, target, targX, targY, @NanayaShiki_R ); break;
			case 'A02R': tmr = Spells_Handler( abil, source, target, targX, targY, @NanayaShiki_T ); break;
			// Toono Shiki Spells
			case 'A02X': tmr = Spells_Handler( abil, source, nil, targX, targY, @ToonoShiki_D ); break;
			case 'A02U': tmr = Spells_Handler( abil, source, nil, targX, targY, @ToonoShiki_Q ); break;
			case 'A02V': tmr = Spells_Handler( abil, source, nil, targX, targY, @ToonoShiki_W ); break;
			case 'A02W': tmr = Spells_Handler( abil, source, target, targX, targY, @ToonoShiki_E ); break;
			case 'A02Y': tmr = Spells_Handler( abil, source, target, targX, targY, @ToonoShiki_R ); break;
			case 'A02Z': tmr = Spells_Handler( abil, source, target, targX, targY, @ToonoShiki_T ); break;
			// Ryougi Shiki Spells
			case 'A035': tmr = Spells_Handler( abil, source, nil, targX, targY, @RyougiShiki_D ); break;
			case 'A033': tmr = Spells_Handler( abil, source, nil, targX, targY, @RyougiShiki_Q ); break;
			case 'A032': tmr = Spells_Handler( abil, source, nil, targX, targY, @RyougiShiki_W ); break;
			case 'A034': tmr = Spells_Handler( abil, source, nil, targX, targY, @RyougiShiki_E ); break;
			case 'A036': tmr = Spells_Handler( abil, source, target, targX, targY, @RyougiShiki_R ); break;
			case 'A037': tmr = Spells_Handler( abil, source, target, targX, targY, @RyougiShiki_T ); break;
			// Saber Alter Spells
			case 'A03S': tmr = Spells_Handler( abil, source, nil, targX, targY, @SaberAlter_D ); break;
			case 'A03T': tmr = Spells_Handler( abil, source, nil, targX, targY, @SaberAlter_Q ); break;
			case 'A03U': tmr = Spells_Handler( abil, source, nil, targX, targY, @SaberAlter_W ); break;
			case 'A03V': tmr = Spells_Handler( abil, source, nil, targX, targY, @SaberAlter_E ); break;
			case 'A03W': tmr = Spells_Handler( abil, source, nil, targX, targY, @SaberAlter_R ); break;
			case 'A03X': tmr = Spells_Handler( abil, source, nil, targX, targY, @SaberAlter_T ); break;
			// Saber Nero Spells
			case 'A038': tmr = Spells_Handler( abil, source, nil, targX, targY, @SaberNero_Q ); break;
			case 'A039': tmr = Spells_Handler( abil, source, nil, targX, targY, @SaberNero_W ); break;
			case 'A03A': tmr = Spells_Handler( abil, source, target, targX, targY, @SaberNero_E ); break;
			case 'A03B': tmr = Spells_Handler( abil, source, nil, targX, targY, @SaberNero_R ); break;
			case 'A03C': tmr = Spells_Handler( abil, source, target, targX, targY, @SaberNero_T ); break;
			// Kuchiki Byakuya Spells
			case 'A03E': tmr = Spells_Handler( abil, source, nil, targX, targY, @KuchikiByakuya_Q ); break;
			case 'A03D': tmr = Spells_Handler( abil, source, target, targX, targY, @KuchikiByakuya_W ); break;
			case 'A03G': tmr = Spells_Handler( abil, source, nil, targX, targY, @KuchikiByakuya_E ); break;
			case 'A03H': tmr = Spells_Handler( abil, source, target, targX, targY, @KuchikiByakuya_R ); break;
			case 'A03I': tmr = Spells_Handler( abil, source, target, targX, targY, @KuchikiByakuya_T ); break;
			// Akame Spells
			case 'A052': tmr = Spells_Handler( abil, source, nil, targX, targY, @Akame_D ); break;
			case 'A03K': tmr = Spells_Handler( abil, source, nil, targX, targY, @Akame_D ); break;
			case 'A03L': tmr = Spells_Handler( abil, source, nil, targX, targY, @Akame_Q ); break;
			case 'A03M': tmr = Spells_Handler( abil, source, target, targX, targY, @Akame_W ); break;
			case 'A03N': tmr = Spells_Handler( abil, source, nil, targX, targY, @Akame_E ); break;
			case 'A03O': tmr = Spells_Handler( abil, source, target, targX, targY, @Akame_R ); break;
			case 'A03P': tmr = Spells_Handler( abil, source, target, targX, targY, @Akame_T ); break;
			// Scathach Spells
			case 'A040': tmr = Spells_Handler( abil, source, target, targX, targY, @Scathach_Q1 ); break;
			case 'A03Y': tmr = Spells_Handler( abil, source, target, targX, targY, @Scathach_Q2 ); break;
			case 'A03Z': tmr = Spells_Handler( abil, source, target, targX, targY, @Scathach_Q3 ); break;
			case 'A041': tmr = Spells_Handler( abil, source, nil, targX, targY, @Scathach_W ); break;
			case 'A042': tmr = Spells_Handler( abil, source, target, targX, targY, @Scathach_E ); break;
			case 'A043': tmr = Spells_Handler( abil, source, target, targX, targY, @Scathach_R ); break;
			case 'A044': tmr = Spells_Handler( abil, source, nil, targX, targY, @Scathach_T ); break;
			// Akainu Spells
			case 'A049': tmr = Spells_Handler( abil, source, target, targX, targY, @Akainu_D ); break;
			case 'A04A': tmr = Spells_Handler( abil, source, target, targX, targY, @Akainu_Q ); break;
			case 'A04C': tmr = Spells_Handler( abil, source, target, targX, targY, @Akainu_W ); break;
			case 'A04B': tmr = Spells_Handler( abil, source, target, targX, targY, @Akainu_E ); break;
			case 'A04D': tmr = Spells_Handler( abil, source, target, targX, targY, @Akainu_R ); break;
			case 'A04E': tmr = Spells_Handler( abil, source, target, targX, targY, @Akainu_T ); break;
			// Reinforce Spells
			case 'A04G': tmr = Spells_Handler( abil, source, nil, targX, targY, @Reinforce_Q ); break;
			case 'A04H': tmr = Spells_Handler( abil, source, target, targX, targY, @Reinforce_W ); break;
			case 'A04I': tmr = Spells_Handler( abil, source, nil, targX, targY, @Reinforce_E ); break;
			case 'A04J': tmr = Spells_Handler( abil, source, target, targX, targY, @Reinforce_R ); break;
			case 'A04K': tmr = Spells_Handler( abil, source, nil, targX, targY, @Reinforce_T ); break;
			// Arcueid Spells
			case 'A01N': tmr = Spells_Handler( abil, source, nil, targX, targY, @Arcueid_Q ); break;
			case 'A01Y': tmr = Spells_Handler( abil, source, nil, targX, targY, @Arcueid_W ); break;
			case 'A026': tmr = Spells_Handler( abil, source, nil, targX, targY, @Arcueid_E ); break;
			case 'A027': tmr = Spells_Handler( abil, source, target, targX, targY, @Arcueid_R ); break;
			case 'A02A': tmr = Spells_Handler( abil, source, nil, targX, targY, @Arcueid_T ); break;
		}
	}

	// if ( tmr == nil || !TimerIsPaused( tmr ) ) { return; }
}
//

void InitHero( unit u )
{
	int hid = GetHandleId( u );

	if ( u == nil || LoadBoolean( GameHT, hid, 'INIT' ) ) { return; }

	int uid = GetUnitTypeId( u );

	switch( uid )
	{
		case 'H00A': // Nanaya
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, ACF_CreateSound( "GeneralSounds\\GlassShatterSound.mp3" ) );

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellV.mp3"  ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellQ.mp3"  ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellW.wav"  ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellE1.wav" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E2', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellE2.wav" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellR1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellR2.wav" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellT1.wav" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellT2.wav" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T3', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellT3.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		case 'H00B': // Toono
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, ACF_CreateSound( "GeneralSounds\\GlassShatterSound.mp3" ) );

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundV1.mp3"  ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellQ.mp3"  ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundW1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E2', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundE2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E3', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundE3.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundR1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundR2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R3', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundR3.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundT1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundT2.mp3" ) );
				
				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		case 'H00C': // Ryougi
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 0, ACF_CreateSound( "GeneralSounds\\BloodFlow.mp3" ) );

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellDSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellQSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellWSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellESound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellRSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellRSound2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellTSound1.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		case 'H00D': // Saber Alter
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterC1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterQ1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterQ2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterW1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterW2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W3', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterW3.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterE1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterE2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterR1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterR2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterT1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterT2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T3', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterT3.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		case 'H00E': // Saber Nero
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, ACF_CreateSound( "GeneralSounds\\GlassShatterSound.mp3" ) );

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundQ1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundW1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundE1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundR2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundT1.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			timer tmr = CreateTimer( );
			int t_hid = GetHandleId( tmr );
			SaveUnitHandle( GameHT, t_hid, 'usrc', u );
			TimerStart( tmr, 1.f, true, 
				function( )
				{
					int hid = GetHandleId( GetExpiredTimer( ) );
					unit source = LoadUnitHandle( GameHT, hid, 'usrc' ); if ( IsUnitDead( source ) ) { return; }
					float hpMax = GetUnitMaxLife( source );
					float hpCur = GetUnitCurrentLife( source );
					SetUnitCurrentLife( source, ( hpMax - hpCur ) * .04f + hpCur );
				}
			 );

			break;
		}
		case 'H00F': // Kuchiki Byakuya
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellDSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellQSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellQSound2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellWSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellESound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellRSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellRSound2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellTSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellTSound2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellTSound3.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		case 'H00G': // Akame
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 0, ACF_CreateSound( "GeneralSounds\\BloodFlow.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellDSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellQSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellWSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellESound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellRSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellRSound2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellTSound1.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		case 'H00H': // Scathach
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, ACF_CreateSound( "GeneralSounds\\GlassShatterSound.mp3" ) );

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellQFirstSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q2', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellQSecondSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q3', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellQThirdSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellWSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellESound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellRSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellRSound2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellTSound1.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		case 'H00I': // Akainu
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellDSound.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellQSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellWSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellESound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellRSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellRSound2.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellTSound1.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		case 'H00J': // Reinforce
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellQSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellWSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellESound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellCSound1.mp3" ) ); // R1
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellRSound1.mp3" ) ); // R2
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellTSound1.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		case 'H00K': // Arcueid
		{
			if ( !LoadBoolean( SoundHT, hid, 'gsnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 0, ACF_CreateSound( "GeneralSounds\\BloodFlow.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'gsnd' + 3, ACF_CreateSound( "GeneralSounds\\SlamSound.mp3" ) );

				SaveBoolean( SoundHT, hid, 'gsnd', true );
			}

			if ( !LoadBoolean( SoundHT, hid, 'psnd' ) )
			{
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellQSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellWSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellESound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellRSound1.mp3" ) );
				SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellTSound1.mp3" ) );

				SaveBoolean( SoundHT, hid, 'psnd', true );
			}

			if ( !LoadBoolean( GameHT, uid, 'INIT' ) )
			{
				SaveBoolean( GameHT, 'A02A', 'PATH', true );
				SaveBoolean( GameHT, 'A026', 'PATH', true );

				SaveBoolean( GameHT, uid, 'INIT', true );
			}

			break;
		}
		default: return;
	}

	if ( !LoadBoolean( GameHT, hid, 'INIT' ) )
	{
		HeroProcessAbilityDisplay( u, true );

		SaveBoolean( GameHT, hid, 'INIT', true );
	}
}

void OnAnyChatEvent( )
{
	player p = GetTriggerPlayer( );
	int pid = GetPlayerId( p );
	int p_team = GetPlayerTeam( p );
	string msg = GetEventPlayerChatString( );
	int trig = msg[0];

	switch( trig )
	{
		case '-':
		{
			string cmd = msg.substr( 1 );
			string payload = "";
			int space = cmd.findFirstOf( " " );

			if ( space != -1 )
			{
				payload = cmd.substr( space + 1 );
				cmd = cmd.substr( 0, space - 1 );
			}

			if ( cmd == "save" )
			{
				SaveUnitAxis( p, true );
			}
			else if ( cmd == "t" )
			{
				int p_hid = GetHandleId( p );

				if ( !LoadBoolean( DataHT, p_hid, 'ISTP' ) ) { return; }

				int tpCD = LoadInteger( GameHT, p_hid, 'tptm' );
				unit hero = MUnitArray[pid];

				if ( IsUnitCCed( hero ) || IsUnitPaused( hero ) )
				{
					DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffUnable to teleport!" );
				}
				else
				{
					if ( tpCD == 0 )
					{
						timer tmr = CreateTimer( );
						int hid = GetHandleId( tmr );

						SavePlayerHandle( GameHT, hid, '+ply', p );
						SaveInteger( GameHT, p_hid, 'tptm', 30 );

						TeleportToSavedLocation( p );

						TimerStart( tmr, 1.f, true, 
							function( )
							{
								timer tmr = GetExpiredTimer( );
								int hid = GetHandleId( tmr );
								player p = LoadPlayerHandle( GameHT, hid, '+ply' );
								int p_hid = GetHandleId( p );
								int cd = LoadInteger( GameHT, p_hid, 'tptm' ) - 1;

								if ( cd > 0 )
								{
									SaveInteger( GameHT, p_hid, 'tptm', cd );
								}
								else
								{
									SaveInteger( GameHT, p_hid, 'tptm', 0 );
									PauseTimer( tmr );
									FlushChildHashtable( GameHT, hid );
									DestroyTimer( tmr );
								}
							}
						 );
					}
					else
					{
						DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c00ffff00Teleportation Cooldown: " + I2S( tpCD ) + " seconds|r|c00ff0000!|r" );
					}
				}

				break;
			}
			else if ( cmd == "combinations" )
			{
				DisplayTimedTextToPlayer( p, 0.f, 0.f, 10.f, "*Mithril Shield+Champion Belt = |c0000ff00Gold Shield|r
				*u's Axe + Ninja's Slipper = |c0000ff00Minotaur's Axe|r
				*Speed Boots + Ninja's Slipper = |c0000ff00Blink Boots|r
				*Red Stone + Ninja's Slipper + Champion Belt = |c0000ff00Gold Medal|r
				*Red Stone + Red Stone = |c0000ff00Crystal|r
				*Mithril Shield + u's Axe = |c0000ff00Sword of King|r
				*Red Tablet + Stealth Cap = |c0000ff00Stealth Scroll|r" );
			}
			else if ( cmd == "1" )
			{
				if ( !HealthDisplayBooleanArray[pid] )
				{
					DisplayTextToPlayer( p, 0, 0, "Health display by text is: |c0000ffffOn|r" );
				}
				else
				{
					DisplayTextToPlayer( p, 0, 0, "Health display by text is: |c00ff0000Off|r" );
				}

				HealthDisplayBooleanArray[pid] = !HealthDisplayBooleanArray[pid];
			}
			else if ( cmd == "2" )
			{
				if ( !ESCLocationSaveBooleanArray[pid] )
				{
					DisplayTextToPlayer( p, 0, 0, "Push ESC to save current position function is: |c0000ffffActivated|r" );
				}
				else
				{
					DisplayTextToPlayer( p, 0, 0, "Push ESC to save current position function is: |c00ff0000Deactivated|r" );
				}

				ESCLocationSaveBooleanArray[pid] = !ESCLocationSaveBooleanArray[pid];
			}
			else if ( cmd == "3" )
			{
				int p_hid = GetHandleId( p );

				DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffDisplaying the saved position" );
				if ( GetLocalPlayer( ) == p )
				{
					ACF_PingMinimap( p, LoadReal( DataHT, p_hid, '+tpX' ), LoadReal( DataHT, p_hid, '+tpY' ), false );
				}
			}
			else if ( cmd == "4" )
			{
				DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffDisplaying the saved position" );

				if ( GetLocalPlayer( ) == p )
				{
					for ( int i = 0; i < PLAYER_NEUTRAL_AGGRESSIVE; i++ )
					{
						player p_other = Player( i ); if ( p == p_other || !IsPlayerAlly( p, p_other ) || GetPlayerSlotState( p ) != PLAYER_SLOT_STATE_PLAYING ) { continue; }
						int p_hid = GetHandleId( p_other );
						ACF_PingMinimap( p, LoadReal( DataHT, p_hid, '+tpX' ), LoadReal( DataHT, p_hid, '+tpY' ), false );
					}
				}
			}
			else if ( cmd == "commands" )
			{
				DisplayTextToPlayer( p, 0.f, 0.f, "|c0080ff00-testcommands|r: |c0000ffffDisplays available test commands|r.
				|c0080ff00-camera 50~250|r: |c0000ffffMap camera distance change|r.
				|c0080ff00-combinations|r: |c0000ffffA list of item combinations|r.
				|c0080ff00-T|r: |c0000ffffTeleports you to the saved location ( Requires 8 bosses killed )|r.
				|c0080ff00-1|r: |c0000ffffWrites exact amount of hp of target if his hp exceeds 10000|r.
				|c0080ff00-2|r: |c0000ffffPush ESC button 2 times to save your current position|r.
				|c0080ff00-3|r: |c0000ffffShows the location where you saved|r.
				|c0080ff00-4|r: |c0000ffffShows the location where you and your teammates saved|r.
				|c0080ff00-clear|r: |c0000ffffClears text messages from chat|r.
				|c0080ff00-Contacts|r: |c0000ffffDisplays Map Maker and Contact information|r." );
			}
			else if ( cmd == "testcommands" )
			{
				DisplayTextToPlayer( p, 0.f, 0.f, "|c0080ff00-nc|r: |c0000ffffRemoves cooldowns on abilities|r.
				|c0080ff00-heroes|r: |c0000ffffGrants you all heroes available in the game|r.
				|c0080ff00-gold|r: |c0000ffffGrants you 100000000 gold when used|r.
				|cFFFFCC00-level XX|r: |c0000ffffSets the level of selected u to XX|r.
				|c0080ff00-nocreep|r: |c0000ffffStops mobs spawning on mid|r.
				|c0080ff00-testunit|r: |c0000ffffSpawns a unit, that has a lot of hp|r." );
			}
			else if ( cmd == "contacts" )
			{
				DisplayTextToPlayer( p, 0.f, 0.f, "|cFFFFCC00Map Maker and Contact Info:|r Unryze ( https://vk.com/acfwc3 / https://vendev.info/ )

				|cFFFFCC00Helpers:|r Andutrache, Nelu_o, Maou, Sanyabane and Saasura" );
			}
			else if ( cmd == "non" || cmd == "noff" )
			{
				bool isEnable = cmd == "non";

				if ( isEnable )
				{
					DisplayTextToPlayer( p, .0f, .0f, "|c0000FF00Notifications have been enabled!" );
				}
				else
				{
					DisplayTextToPlayer( p, .0f, .0f, "|c00ff0000Notifications have been disabled!" );
				}
				
				SaveBoolean( DataHT, GetHandleId( p ), 'ntfc', isEnable );
			}
			else if ( cmd == "clear" )
			{
				if ( GetLocalPlayer( ) == p ) { ClearTextMessages( ); }
			}

			if ( TestCommandEnabled )
			{
				if ( cmd == "nc" )
				{
					bool toggleMode = true;
					bool isEnabled = TMR_ResetCD != nil ? TimerIsPaused( TMR_ResetCD ) : true;

					if ( TMR_ResetCD == nil )
					{
						TMR_ResetCD = CreateTimer( );
						toggleMode = false;
						TimerStart( TMR_ResetCD, .01f, true,
							function( )
							{
								GroupEnumUnitsInRect( GroupEnum, worldBounds, Condition( function( ) { return IsUnitHero( GetFilterUnit( ) ); } ) );

								for ( unit u = GroupForEachUnit( GroupEnum ); u != nil; u = GroupForEachUnit( GroupEnum ) )
								{
									if ( GetPlayerId( GetOwningPlayer( u ) ) >= PLAYER_NEUTRAL_AGGRESSIVE ) { continue; }
									UnitResetCooldown( u );
								}
							}
						 );
					}

					DisplayTimedTextToPlayer( p, .0f, .0f, 10.f, isEnabled ? "|c0000FF00No-CoolDown Mode Operation Enabled!" : "|c00ff0000No-CoolDown Mode Operation Disabled!" );

					if ( !toggleMode ) { return; }

					TimerIsPaused( TMR_ResetCD ) ? ResumeTimer( TMR_ResetCD ) : PauseTimer( TMR_ResetCD );
				}
				else if ( cmd == "nocreep" )
				{
					if ( B_IsCreepSpawn )
					{
						DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c00ff0000Creeps on mid will no longer spawn.|r" );
					}
					else
					{
						DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ff00Creeps on mid will start to spawn.|r" );
					}

					B_IsCreepSpawn = !B_IsCreepSpawn;
				}
				else if ( cmd == "testunit" )
				{
					DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ff00Test unit created.|r" );
					CreateUnit( Player( PLAYER_NEUTRAL_AGGRESSIVE ), 'tstu', 0.f, -500.f, 270.f );
				}
			}

			break;
		}
	}
}

void DefaultCommandsTriggers( )
{
	trigger t;

	t = CreateTrigger( );
	TriggerRegisterAnyPlayerEventRW( t, EVENT_PLAYER_END_CINEMATIC );
	TriggerAddAction( t, @ESCToSaveAction );

	t = CreateTrigger( );
	TriggerRegisterPlayerChatEventRW( t, "", false );
	TriggerAddAction( t, @OnAnyChatEvent );

	t = CreateTrigger( );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_UNIT_SELECTED );
	TriggerAddAction( t, @HealthDisplayReaderAction );
}

void CreateLocalTimers( )
{
	TimerStart( CreateTimer( ), 30.f, true, 
		function( )
		{
			UnitResetCooldown( LoadUnitHandle( DataHT, 'BOSS', 'unit' ) );

			player p = GetLocalPlayer( );
			int hid = GetHandleId( p );

			if ( LoadBoolean( DataHT, hid, 'ntfc' ) )
			{
				DisplayTextToPlayer( p, 0.f, 0.f, "|c0080ff00-commands|r: |c0000ffffdisplays available in-game commands|r.
				|c0080ff00-testcommands|r: |c0000ffffdisplays available in-game test commands|r.
				|c0080ff00-noff/-non|r: |c0000ffffdisables/enables -commands notification|r." );
			}
		}
	 );
}

void GameTriggers( )
{
	trigger t;

	TR_SelectionMode = CreateTrigger( );
	TriggerRegisterDialogEvent( TR_SelectionMode, ModeSelectionDialog );
	TriggerAddAction( TR_SelectionMode, @ModeSelectionFunction2 );

	t = CreateTrigger( );

	for ( int i = 0; i < PLAYER_NEUTRAL_AGGRESSIVE; i++ )
	{
		player p = Player( i );

		if ( GetPlayerSlotState( p ) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController( p ) == MAP_CONTROL_USER )
		{
			TotalPlayers++;
			TeamPlayers[ GetPlayerTeam( p ) ]++;
		}

		TriggerRegisterPlayerAllianceChange( t, p, ALLIANCE_SHARED_CONTROL );
	}
	TriggerAddAction( t, @DisableSharedUnitsAct );

	t = CreateTrigger( );
	TriggerRegisterTimerEvent( t, 0, false );
	TriggerAddAction( t, @MultiBoardCreationFunction1 );

	t = CreateTrigger( );
	TriggerRegisterAnyPlayerEventRW( t, EVENT_PLAYER_LEAVE );
	TriggerAddAction( t, @RegisterPlayerLeaveAction );

	t = CreateTrigger( );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_HERO_LEVEL );
	TriggerAddAction( t, @OnHeroLevel );

	t = CreateTrigger( );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_UNIT_PICKUP_ITEM );
	TriggerAddAction( t, @OnAnyItemPick );

	t = CreateTrigger( );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_UNIT_DROP_ITEM );
	TriggerAddAction( t, @OnAnyItemDrop );

	t = CreateTrigger( );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_UNIT_USE_ITEM );
	TriggerAddAction( t, @OnAnyItemUsed );

	t = CreateTrigger( );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_UNIT_SPELL_CAST );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_UNIT_SPELL_EFFECT );
	TriggerAddAction( t, @OnAnySpellAction );

	t = CreateTrigger( );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_UNIT_PROJECTILE_HIT );
	TriggerAddAction( t, @OnPlayerUnitProjectileHit );

	t = CreateTrigger( );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_UNIT_DAMAGED );
	TriggerAddAction( t, @OnPlayerUnitDamaged );

	t = CreateTrigger( );
	TriggerRegisterGameEvent( t, EVENT_GAME_WIDGET_DEATH );
	TriggerAddAction( t, @OnAnyWidgetDeath );

	TR_HeroSelection = CreateTrigger( );
	DisableTrigger( TR_HeroSelection );
	TriggerRegisterAnyUnitEventRW( TR_HeroSelection, EVENT_PLAYER_UNIT_SELECTED );
	TriggerAddAction( TR_HeroSelection, @HeroSelectionAction );

	t = CreateTrigger( );
	TriggerRegisterDialogEvent( t, KillSelectionDialog );
	TriggerAddAction( t, @KillSelectionDialogAction );
}

void AllRegions( )
{
	CircleRectArr[0] = Rect( -2688.f, 704.f, -2432.f, 960.f ); // TL
	CircleRectArr[1] = Rect( -2688.f, -1920.f, -2432.f, -1600.f ); // BL
	CircleRectArr[2] = Rect( -672.f, -1184.f, 672.f, 160.f ); // Center
	CircleRectArr[3] = Rect( 2464.f, -1920.f, 2720.f, -1600.f ); // TR
	CircleRectArr[4] = Rect( 2464.f, 704.f, 2720.f, 960.f ); // BR
	
	array<int> shopList = { 'mtk3', 'mtk4', 'mtk5', 'mtk1', 'mtk2' };

	for ( int team = 0; team < 2; team++ )
	{
		unit u = CreateUnit( Player( 10 + team ), 'base', team == 0 ? -4350.f : 4350.f, -500.f, 270.f );
		SetUnitVertexColor( u, 255, 255, 255, 75 );

		for ( uint i = 0; i < CircleRectArr.length( ); i++ )
		{
			float x = team == 0 ? -5184.f : 5120.f;
			float y = -256.f * i;
			float targX = GetRectCenterX( CircleRectArr[i] );
			float targY = GetRectCenterY( CircleRectArr[i] );

			u = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'wgt1', x, y, 270.f );

			WaygateSetDestination( u, targX, targY );
			CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), 'cofp', targX, targY, 270.f );
			WaygateActivate( u, true );
		}

		for ( uint i = 0; i < shopList.length( ); i++ )
		{
			int typeId = shopList[i];

			float x = 4032.f + ( i <= 1 ? i * 356.f : ( i - 2 ) * 256.f );
			float y = i <= 1 ? -128.f : -1088.f;

			u = CreateUnit( Player( PLAYER_NEUTRAL_PASSIVE ), typeId, team == 0 ? -x : x, y, 270.f );
		}
	}

	trigger t;
	region reg;
	rect rec;

	worldBounds = GetWorldBounds( );

	t = CreateTrigger( );

	reg = CreateRegion( );
	rec = Rect( -5440.f, -1440.f, -3520.f, 480.f );
	RegionAddRect( reg, rec );
	SetRect( rec, 3520.f, -1440.f, 5440.f, 480.f );
	RegionAddRect( reg, rec );
	TriggerRegisterEnterRegion( t, reg, nil );
	TriggerAddAction( t, 
		function( )
		{
			OnAnyUnitEnterRegion( GetEnteringUnit( ), GetTriggeringRegion( ), nil );
		}
	 );
	SaveRegionHandle( DataHT, 'regs', 'BASE', reg );
	RemoveRect( rec );

	t = CreateTrigger( );
	reg = CreateRegion( );
	RegionAddRect( reg, CircleRectArr[0] ); // TL
	TriggerRegisterEnterRegion( t, reg, nil );
	TriggerAddAction( t, 
		function( )
		{
			OnAnyUnitEnterRegion( GetEnteringUnit( ), GetTriggeringRegion( ), CircleRectArr[0] );
		}
	 );

	t = CreateTrigger( );
	reg = CreateRegion( );
	RegionAddRect( reg, CircleRectArr[1] ); // BL
	TriggerRegisterEnterRegion( t, reg, nil );
	TriggerAddAction( t, 
		function( )
		{
			OnAnyUnitEnterRegion( GetEnteringUnit( ), GetTriggeringRegion( ), CircleRectArr[1] );
		}
	 );

	t = CreateTrigger( );
	reg = CreateRegion( );
	RegionAddRect( reg, CircleRectArr[3] ); // TR
	TriggerRegisterEnterRegion( t, reg, nil );
	TriggerAddAction( t, 
		function( )
		{
			OnAnyUnitEnterRegion( GetEnteringUnit( ), GetTriggeringRegion( ), CircleRectArr[3] );
		}
	 );

	t = CreateTrigger( );
	reg = CreateRegion( );
	RegionAddRect( reg, CircleRectArr[4] ); // BR
	TriggerRegisterEnterRegion( t, reg, nil );
	TriggerAddAction( t, 
		function( )
		{
			OnAnyUnitEnterRegion( GetEnteringUnit( ), GetTriggeringRegion( ), CircleRectArr[4] );
		}
	 );
}

void CreateAllUnits( )
{
	player p = Player( PLAYER_NEUTRAL_AGGRESSIVE );
	unit u = CreateUnit( p, LoadInteger( DataHT, GetRandomInt( 1, TotalHeroes ), 'type' ), 0.f, -3900.f, 90.f ); // boss
	SaveUnitHandle( DataHT, 'BOSS', 'unit', u );

	InitHero( u );
	SetHeroLevel( u, 50, false );
	HeroUnlockAbilities( u );
	SetHeroStr( u, 5000, false );
	SetHeroAgi( u, 5000, false );
	SetHeroInt( u, 5000, false );
	UnitAddAbility( u, 'A017' );
	UnitAddAbility( u, 'A02F' );
	UnitAddItemById( u, 'I03S' );
	UnitAddItemById( u, 'I00S' );
	UnitAddItemById( u, 'I00U' );
	UnitAddItemById( u, 'I00H' );
	UnitAddItemById( u, 'I00T' );
	UnitAddItemById( u, 'I00R' );
	SetPlayerHandicapXP( p, 3 );
	StartAI( u );
}

void QuestCreationFunction( )
{
	quest QuestCreation = CreateQuest( );
	QuestSetTitle( QuestCreation, "|cFFFFCC00Gameplay Information|r" );
	QuestSetDescription( QuestCreation, "|c0000ffffWhen you kill 8 bosses on the lanes you will get -T command|r.
	|cFFFFCC00-T|r: |c0000ffffTeleports you to your|r |cFFFFCC00-save|r |c0000ffff( saved ) location|r.
	|cFFFFCC00-commands|r – |c0000ffffShows in-game commands|r.

	|cFFFFCC00Single Player Test Commands:|r
	|cFFFFCC00-nc|r – |c0000ffffRemoves cooldowns on abilities|r.
	|cFFFFCC00-heroes|r – |c0000ffffSpawns all the heroes on the base|r.
	|cFFFFCC00-gold X|r – |c0000ffffInstantly gives 10000000 gold to player X|r.
	|cFFFFCC00-level X|r – |c0000ffffSets the level of selected u to X|r.
	|cFFFFCC00-nocreep|r – |c0000ffffDisables creep spawn system in the middle|r.
	|cFFFFCC00-testunit|r – |c0000ffffSpawns a test unit for spell testing|r." );
	QuestSetIconPath( QuestCreation, "Characters\\SaberAlter\\ReplaceableTextures\\CommandButtons\\BTNSaberAlterIcon.blp" );
	QuestSetRequired( QuestCreation, true );
	QuestSetDiscovered( QuestCreation, true );
	QuestSetCompleted( QuestCreation, false );
	QuestCreation = CreateQuest( );
	QuestSetTitle( QuestCreation, "|cFFFFCC00Map Credits|r" );
	QuestSetDescription( QuestCreation, "|c0000ffffThese are the people who have contributed to the map|r:
	|c00FFFF00Andutrache / Nelu_o|r |c00FF0000[FOCS English Team]|r
	|c00FF7F00Space_GlobalTM|r / |c0096FF96gnusik533|r |c0000ffff[ACF Team]|r
	|c00FFFF00Illussionisst / Tekirinmaru / mansuraybov12 / AK-Kisame / brostopchat|r |c006969FF[Bug Reports]|r
	|c00FFFF00brostopchat / Tekirinmaru / Steelvager|r |c006969FF[Map Testers]|r
	|c00FFFF00Kira_Izuru_3th / NN_Dragonforce / steel1606 / Maou / BahaSTI|r |c006969FF[Supporters]|r
	|c00FFFF00Sanyabane|r |c006969FF[Sounds / Textures]|r
	|c00FFFF00Saasura / x10azgmfx / moon_shin / Nagne|r |c006969FF[Animations]|r
	|c00FFFF00Cytyscwyt / Mr.Yagyu|r |c006969FF[Models]|r" );
	QuestSetIconPath( QuestCreation, "Characters\\SaberNero\\ReplaceableTextures\\CommandButtons\\BTNSaberNeroIcon.blp" );
	QuestSetRequired( QuestCreation, false );
	QuestSetDiscovered( QuestCreation, true );
	QuestSetCompleted( QuestCreation, false );
	QuestCreation = CreateQuest( );
	QuestSetTitle( QuestCreation, "|cFFFFCC00Sponsor Sites|r" );
	QuestSetDescription( QuestCreation, "|cFFFFCC00VK Group|r: |c0000ffffhttps://vk.com/unryzeworkshop|r
	|cFFFFCC00Platform|r: |c0000ffffhttps://warcis.com|r
	|cFFFFCC00Host Bot Forum|r: |c0000ffffhttps://vendev.info|r
	|cFFFFCC00WC3 Models and Maps|r: |c0000ffffhttp://chaosrealm.info|r" );
	QuestSetIconPath( QuestCreation, "Characters\\Scathach\\ReplaceableTextures\\CommandButtons\\BTNScathachIcon.blp" );
	QuestSetRequired( QuestCreation, false );
	QuestSetDiscovered( QuestCreation, true );
	QuestSetCompleted( QuestCreation, false );
}

void MapCameraBounds( )
{
	float minX = -6144.f + GetCameraMargin( CAMERA_MARGIN_LEFT );
	float minY = -5120.f + GetCameraMargin( CAMERA_MARGIN_BOTTOM );
	float maxX = 6144.f - GetCameraMargin( CAMERA_MARGIN_RIGHT );
	float maxY = 7168.f - GetCameraMargin( CAMERA_MARGIN_TOP );

	SetCameraBounds( minX, minY, maxX, maxY, minX, maxY, maxX, minY );
}

void SoloGameDetection( )
{
	if ( TeamPlayers[0] == 0 || TeamPlayers[1] == 0 )
	{
		SameHeroBoolean = true;
		KillLimit = 999999999;
		B_IsCreepSpawn = false;
		DestroyTrigger( TR_SelectionMode );
		TestCommandEnabled = true;
		EnableTrigger( TR_HeroSelection );
		TimerStart( CreateTimer( ), 1.f, true, @InGameTimerAction );
	}
	else
	{
		TimerStart( CreateTimer( ), 2.f, false, @ModeSelectionFunction1 );
		CreepSpawn1Action( );
	}
}

void MapDataSetting( )
{
	SetWaterBaseColor( 255, 255, 255, 255 );
	SetSkyModel( "Environment\\Sky\\Sky\\SkyLight.mdl" );
	SetDayNightModels( "Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl" );
	SetFloatGameState( GAME_STATE_TIME_OF_DAY, 12.f );
	SetTimeOfDayScale( 0.f );
	SuspendTimeOfDay( true );
	SetTerrainFogEx( 0, 3000.f, 5000.f, .5f, .0f, .0f, .0f );
	NewSoundEnvironment( "Default" );
	SetMapMusic( "Music", true, 0 );
	SetMapFlag( MAP_LOCK_RESOURCE_TRADING, true );
	SetMapFlag( MAP_FOG_HIDE_TERRAIN, true );
	SetMapFlag( MAP_SHARED_ADVANCED_CONTROL, false );
	FogEnable( false );
	FogMaskEnable( false );
}

void InitBuffData( )
{
	int bid = 'B006';

	SetBuffBaseRealFieldById( bid, ABILITY_RLF_DAMAGE_PER_SECOND_POI1, .0f );
	SetBuffBaseRealFieldById( bid, ABILITY_RLF_DURATION_HERO, 5.f );
	SetBuffBaseRealFieldById( bid, ABILITY_RLF_DURATION_NORMAL, 5.f );
}

void main( )
{
	//InitBlizzard( );
	InitBuffData( );
	BossCheckInit( );
	BossSystem::Init( );
	HeroPickArrayCreation( );
	AllRegions( );
	CreateAllUnits( );
	GameCreateVariables( );
	GameCameraSystemInit( );
	DefaultCommandsTriggers( );
	GameTriggers( );
	CreateLocalTimers( );
	MapDataSetting( );
	MapCameraBounds( );
	QuestCreationFunction( );
	MapStartData( );
	PlayerNameSettingAction( );
	SoloGameDetection( );
	UnitCreationAction( );
}

void config( )
{
	SetPlayers( 10 );
	SetTeams( 2 );

	for ( int i = 0; i < PLAYER_NEUTRAL_AGGRESSIVE; i++ )
	{
		if ( i == 8 || i == 9 ) { continue; }
		player p = Player( i );
		SetPlayerTeam( p, i > 3 && i != 10 ? 1 : 0 );
		SetPlayerRaceSelectable( p, false );
		SetPlayerController( p, i < 10 ? MAP_CONTROL_USER : MAP_CONTROL_COMPUTER );
		SetPlayerRacePreference( p, RACE_PREF_HUMAN );
	}
}
