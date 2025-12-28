namespace ACF
{
	//#include "Scripts\\Blizzard.as"
	#include "Scripts\\TriggerAPI.as"

	bool SameHeroBoolean = false;
	bool TestCommandEnabled = false;
	dialog ModeSelectionDialog = Jass::DialogCreate( );
	dialog KillSelectionDialog = Jass::DialogCreate( );
	group GroupEnum = Jass::CreateGroup( );
	group GroupFilter = Jass::CreateGroup( );
	hashtable GameHT = Jass::InitHashtable( );
	hashtable DataHT = Jass::InitHashtable( );
	hashtable SoundHT = Jass::InitHashtable( );
	int KillLimit = 0;
	int TotalPlayers = 0;
	int TotalHeroes = 0;
	int HeroesSelected = 0;
	float MapMinX = -6100.f + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_LEFT );
	float MapMaxX = 6100.f - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_RIGHT );
	float MapMinY = -4400.f + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_BOTTOM );
	float MapMaxY = 3350.f - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_TOP );
	timer CreepUpgradeTimer1 = Jass::CreateTimer( );
	timer CreepSpawnerTimer1 = Jass::CreateTimer( );
	timer KillSelectionTimer = Jass::CreateTimer( );
	rect worldBounds;
	multiboard MainMultiboard;
	timer TMR_ResetCD = nil;
	timerdialog ModeSelectionTD;
	unit SelectionUnit;
	effect Ef_Selection;
	effect Ef_SelectionBack;
	array<button> SameHeroModeButtonArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<bool> TeamOneSelected( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<bool> TeamTwoSelected( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<bool> HealthDisplayBooleanArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<bool> ESCLocationSaveBooleanArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<effect> EF_SelectionHeroModelArray;
	array<effect> EF_SelectionIconArray;
	bool B_IsCreepSpawn = true;
	int I_WinningTeam = -1;
	array<int> TeamPlayers( 2 );
	array<int> TeamKills( 2 );
	array<int> TeamDeaths( 2 );
	array<int> DyingUnitIntegerArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<int> KillingUnitIntegerArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<int> BossesKilledIntegerArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<int> MBArr1( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<rect> CircleRectArr( 5 );
	array<string> PlayerColorStringArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<string> PlayerColoredNameArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<string> PlayerNameArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	trigger TR_SelectionMode;
	trigger TR_HeroSelection;
	array<unit> U_SelectionSelArr( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<unit> U_SelectionDumArr( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<unit> HeroUnitArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<unit> U_SelectionHeroDummyArr( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<unit> KawarimiTriggerUnitArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
	array<unit> MUnitArray( Jass::PLAYER_NEUTRAL_AGGRESSIVE );

	bool IsAxisReal( float targX, float targY )
	{
		return targX >= MapMinX && targX <= MapMaxX && targY >= MapMinY && targY <= MapMaxY;
	}

	bool RectContainsAxis( rect r, float x, float y )
	{
		return x >= Jass::GetRectMinX( r ) && x <= Jass::GetRectMaxX( r ) && y >= Jass::GetRectMinY( r ) && y <= Jass::GetRectMaxY( r );
	}

	float GetUnitAngle( unit source, unit target )
	{
		return Jass::MathAngleBetweenPoints( Jass::GetUnitX( source ), Jass::GetUnitY( source ), Jass::GetUnitX( target ), Jass::GetUnitY( target ) );
	}

	float GetUnitDistance( unit source, unit target )
	{
		return Jass::MathDistanceBetweenPoints( Jass::GetUnitX( source ), Jass::GetUnitY( source ), Jass::GetUnitX( target ), Jass::GetUnitY( target ) );
	}

	float ACF_GetUnitStatePercent( unit whichUnit, unitstate whichState, unitstate whichMaxState )
	{
		float maxValue = Jass::GetUnitState( whichUnit, whichMaxState );

		if ( whichUnit == nil || maxValue == 0 )
		{
			return .0f;
		}

		float value = Jass::GetUnitState( whichUnit, whichState );

		return value / maxValue * 100.0f;
	}

	int CountUnitInGroupOfPlayer( player p, int id )
	{
		int count = 0;
		group g = GroupFilter;

		Jass::GroupClear( GroupFilter );
		Jass::GroupEnumUnitsOfPlayer( GroupFilter, p, nil );

		for ( int i = 0; i < Jass::GroupGetCount( GroupFilter ); i++ )
		{
			unit u = Jass::GroupGetUnitByIndex( GroupFilter, i );

			if ( Jass::IsUnitAlive( u ) && Jass::GetUnitTypeId( u ) == id )
			{
				count++;
			}
		}

		Jass::GroupClear( GroupFilter );

		return count;
	}

	void GroupEnumUnitsInLine( group g, float x, float y, float angle, float dist, float aoe )
	{
		Jass::GroupClear( g );
		Jass::GroupClear( GroupFilter );
		for ( float moved = .0f; moved < dist; moved += aoe )
		{
			Jass::GroupEnumUnitsInRange( GroupFilter, x, y, aoe, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupFilter ); u != nil; u = Jass::GroupForEachUnit( GroupFilter ) )
			{
				if ( !Jass::IsUnitInGroup( u, g ) )
				{
					Jass::GroupAddUnit( g, u );
				}
			}

			x = Jass::MathPointProjectionX( x, angle, aoe );
			y = Jass::MathPointProjectionY( y, angle, aoe );
		}
	}

	bool IsUnitCCed( unit u )
	{
		return Jass::GetUnitAbilityLevel( u, 'BPSE' ) > 0 || Jass::GetUnitAbilityLevel( u, 'B005' ) > 0;
	}

	void ACF_AddBuffTimed( unit u, uint bid, float time, bool isAdd = true )
	{
		if ( Jass::IsUnitDead( u ) ) { return; }

		buff buf = Jass::GetUnitBuff( u, bid );
		float prevTime = .0f;

		if ( buf == nil )
		{
			buf = Jass::UnitAddBuffById( u, bid );
		}
		else
		{
			prevTime = Jass::GetBuffRemainingDuration( buf );
		}

		Jass::SetBuffRemainingDuration( buf, isAdd ? prevTime + time : time );
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
		int pid = Jass::GetPlayerId( p );

		switch( pid )
		{
			case 0: Jass::PingMinimapEx( x, y, 5, 100, 0, 0, extraEffects ); break;
			case 1: Jass::PingMinimapEx( x, y, 5, 0, 0, 100, extraEffects ); break;
			case 2: Jass::PingMinimapEx( x, y, 5, 0, 100, 100, extraEffects ); break;
			case 3: Jass::PingMinimapEx( x, y, 5, 43, 14, 51, extraEffects ); break;
			case 4: Jass::PingMinimapEx( x, y, 5, 100, 100, 0, extraEffects ); break;
			case 5: Jass::PingMinimapEx( x, y, 5, 83, 37, 10, extraEffects ); break;
			case 6: Jass::PingMinimapEx( x, y, 5, 0, 100, 0, extraEffects ); break;
			case 7: Jass::PingMinimapEx( x, y, 5, 100, 50, 50, extraEffects ); break;
		}
	}

	void SetUnitScaleAndTime( unit u, float length, float time )
	{
		Jass::SetUnitScale( u, length, length, length );
		Jass::SetUnitTimeScale( u, time );
	}

	int ACF_GetItemSlotById( unit whichUnit, int itemId )
	{
		for ( int i = 0; i < 6; i++ )
		{
			item itm = Jass::UnitItemInSlot( whichUnit, i );
			if ( Jass::GetItemTypeId( itm ) == itemId ) { return i; }
		}

		return -1;
	}

	item ACF_GetItemById( unit whichUnit, int itemId )
	{
		int id = ACF_GetItemSlotById( whichUnit, itemId );

		return id != -1 ? Jass::UnitItemInSlot( whichUnit, id ) : nil;
	}

	int ACF_CountItems( unit u, int itemId )
	{
		if ( u == nil || itemId == 0 ) { return 0; }

		int count = 0;

		for ( int i = 0; i < 6; i++ )
		{
			item itm = Jass::UnitItemInSlot( u, i );
			if ( Jass::GetItemTypeId( itm ) == itemId ) { count++; }
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
			if ( Jass::UnitItemInSlot( u, i ) == nil )
			{
				return true;
			}
		}

		return false;
	}

	void ACF_SelectUnit( unit u, player p = nil )
	{
		if ( p == nil ) { p = Jass::GetOwningPlayer( u ); }

		if ( Jass::GetLocalPlayer( ) == p )
		{
			Jass::ClearSelection( );
			Jass::SelectUnit( u, true );
		}
	}

	void ACF_PanCameraToTimed( player p, float x, float y, float time )
	{
		if ( Jass::GetLocalPlayer( ) == p )
		{
			Jass::PanCameraToTimed( x, y, time );
		}
	}

	bool ACF_HasPersonalItem( unit u )
	{
		return ACF_UnitHasItemById( u, Jass::LoadInteger( DataHT, Jass::GetUnitTypeId( u ), 'pitm' ) );
	}

	void GameCreateVariables( )
	{
		for ( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
		{
			player p = Jass::Player( i ); if ( Jass::GetPlayerSlotState( p ) != Jass::PLAYER_SLOT_STATE_PLAYING || Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_COMPUTER ) { continue; }
			int hid = Jass::GetHandleId( p );

			Jass::SaveReal( DataHT, hid, '+tpX', .0f );
			Jass::SaveReal( DataHT, hid, '+tpY', -500.f );
			Jass::SaveReal( DataHT, hid, 'camH', 2000.f );
			Jass::SaveBoolean( DataHT, hid, 'ntfc', true );
		}
	}

	void GameCameraSystemInit( )
	{
		Jass::TimerStart
		(
			Jass::CreateTimer( ),
			.01f,
			true,
			function()
			{
				int hid = Jass::GetHandleId( Jass::GetLocalPlayer( ) );

				Jass::SetCameraField( Jass::CAMERA_FIELD_TARGET_DISTANCE, Jass::LoadReal( DataHT, hid, 'camH' ), 0.f );

				if ( !Jass::LoadBoolean( DataHT, hid, 'HERO' ) )
				{
					Jass::PanCameraToTimed( -1800.f, 5800.f, .0f );
					Jass::SetCameraField( Jass::CAMERA_FIELD_ANGLE_OF_ATTACK, 270., 0.f );
				}
			}
		);
	}

	bool ACF_DamageTarget
	(
		unit u,
		unit target,
		float dmg,
		bool attack = true,
		bool ranged = false,
		attacktype attackType = Jass::ATTACK_TYPE_NORMAL,
		damagetype damageType = Jass::DAMAGE_TYPE_MAGIC,
		weapontype weaponType = Jass::WEAPON_TYPE_WHOKNOWS
	)
	{
		if ( ACF_HasPersonalItem( u ) )
		{
			dmg *= 1.15f;
		}

		return Jass::UnitDamageTarget( u, target, dmg, attack, ranged, attackType, damageType, weaponType );
	}

	void DialogShow( dialog dg, bool isShow )
	{
		for ( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
		{
			Jass::DialogDisplay( Jass::Player( i ), dg, isShow );
		}
	}

	texttag TextTagCreate( string word, float x, float y, float z, float size, int red, int green, int blue, int alpha )
	{
		texttag txtTag = Jass::CreateTextTag( );
		Jass::SetTextTagText( txtTag, word, size * 0.023f / 10.f );
		Jass::SetTextTagPos( txtTag, x, y, z );
		Jass::SetTextTagColor( txtTag, red, green, blue, alpha );
		return txtTag;
	}

	sound ACF_CreateSound( string filePath )
	{
		return Jass::CreateSound( filePath, false, false, false, 12700, 12700, "DefaultEAXON" );
	}

	void ACF_PlaySoundWithVolume( sound soundHandle, float volumePercent, float startingOffset )
	{
		if ( soundHandle == nil )
		{
			return;
		}

		int result = Jass::MathIntegerClamp( Jass::R2I( volumePercent * Jass::I2R( 127 ) * .01f ), 0, 127 );

		Jass::SetSoundVolume( soundHandle, result );
		Jass::StartSound( soundHandle );
		Jass::SetSoundPlayPosition( soundHandle, Jass::R2I( startingOffset * 1000 ) );
	}

	void PlayHeroSound( unit u, uint childKey, float volume, float startingOffset )
	{
		ACF_PlaySoundWithVolume( Jass::LoadSoundHandle( SoundHT, Jass::GetHandleId( u ), childKey ), volume, startingOffset );
	}

	void StopSoundEx( sound snd, bool killWhenDone, bool fadeOut )
	{
		if ( !Jass::GetSoundIsPlaying( snd ) ) { return; }
		Jass::StopSound( snd, killWhenDone, fadeOut );
	}

	void StopHeroSound( unit u, uint childKey )
	{
		StopSoundEx( Jass::LoadSoundHandle( SoundHT, Jass::GetHandleId( u ), childKey ), false, false );
	}

	void SetUnitXY( unit u, float toX, float toY, bool pathing = false )
	{
		if ( pathing && Jass::IsTerrainPathable( toX, toY, Jass::PATHING_TYPE_WALKABILITY ) )
		{
			return;
		}

		if ( Jass::GetUnitMoveSpeed( u ) > 0 ) // && IsAxisReal( toX, toY ) -> max/min x/y of map
		{
			Jass::SetUnitX( u, toX );
			Jass::SetUnitY( u, toY );
		}
		else
		{
			Jass::SetUnitPosition( u, toX, toY );
		}
	}

	void HandleListCleanEffects( handlelist hl, bool destroyEffects, bool isDestroy )
	{
		if ( hl == nil ) { return; }

		if ( destroyEffects )
		{
			for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
			{
				effect ef = Jass::HandleListGetEffectByIndex( hl, i );
				Jass::DestroyEffect( ef );
			}
		}

		Jass::HandleListClear( hl );
		if ( !isDestroy ) { return; }
		Jass::HandleListDestroy( hl );
	}

	void MapStartData( )
	{
		Jass::PanCameraToTimed( -1800.f, 5900.f, .0f );
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

	void StartAI( unit u )
	{
		int u_hid = Jass::GetHandleId( u );

		if ( Jass::LoadBoolean( DataHT, Jass::GetHandleId( u ), 'ISAI' ) ) { return; }
		Jass::SaveBoolean( DataHT, Jass::GetHandleId( u ), 'ISAI', true );

		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );

		Jass::SaveUnitHandle( GameHT, hid, 'usrc', u );
		Jass::SaveHandleList( GameHT, hid, 'list', Jass::HandleListCreate( ) );
		
		/* AI Loop, disabled as it's not all that good.
		Jass::TimerStart
		(
			tmr,
			1.f,
			true,
			function()
			{
				if ( true )
				{
					timer tmr = Jass::GetExpiredTimer( );
					int hid = Jass::GetHandleId( tmr );
					unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
					int tick = Jass::LoadInteger( GameHT, hid, 'tick' ) + 1;
					handlelist list = Jass::LoadHandleList( GameHT, hid, 'list' );
					player p = Jass::GetOwningPlayer( source );
					int team = Jass::GetPlayerTeam( p );
					unit boss = Jass::LoadUnitHandle( DataHT, 'BOSS', 'unit' );
					unit utarg = nil;

					Jass::SaveInteger( GameHT, hid, 'tick', tick );

					float x = Jass::GetUnitX( source );
					float y = Jass::GetUnitY( source );

					Jass::HandleListClear( list );
					Jass::HandleListEnumUnitsInRange( list, x, y, 600.f, nil );

					for( int i = 0; i < Jass::HandleListGetUnitCount( list ); i++ )
					{
						unit u = Jass::HandleListGetUnitByIndex( list, i );

						if ( Jass::IsUnitAlive( u ) && Jass::IsPlayerEnemy( Jass::GetOwningPlayer( u ), p ) )
						{
							utarg = u;

							if ( Jass::IsUnitType( u, Jass::UNIT_TYPE_HERO ) )
							{
								break;
							}
						}
					}

					if ( utarg == nil )
					{
						if ( source != boss )
						{
							Jass::HandleListClear( list );
							Jass::HandleListEnumItemsInRange( list, x, y, 1600.f, nil );

							for( int i = 0; i < Jass::HandleListGetItemCount( list ); i++ )
							{
								if ( !ACF_UnitHasEmptySlot( source ) ) { break; }
								item itm = Jass::HandleListGetItemByIndex( list, i );

								if ( Jass::IsItemVisible( itm ) && Jass::GetItemLife( itm ) >= .0f && Jass::GetItemType( itm ) == Jass::ITEM_TYPE_POWERUP )
								{
									Jass::IssueTargetOrder( source, "smart", itm );
									break;
								}
							}

							Jass::HandleListClear( list );
						}
					}
					else
					{
						float targX = Jass::GetUnitX( utarg );
						float targY = Jass::GetUnitY( utarg );

						Jass::IssueTargetOrder( source, "attack", utarg );
						Jass::IssueTargetOrder( source, "purge", utarg );
						Jass::IssueTargetOrder( source, "drain", utarg );
						Jass::IssueTargetOrder( source, "curse", utarg );
						Jass::IssuePointOrder( source, "shockwave", targX, targY );
						Jass::IssuePointOrder( source, "blizzard", targX, targY );
						Jass::IssuePointOrder( source, "inferno", targX, targY );
						Jass::IssuePointOrder( source, "carrionswarm", targX, targY );
						Jass::IssueImmediateOrder( source, "stomp" );
						Jass::IssueImmediateOrder( source, "roar" );

						if ( ( !Jass::IsUnitType( utarg, Jass::UNIT_TYPE_HERO ) && Jass::GetUnitCurrentLife( utarg ) >= 500.f ) || Jass::IsUnitType( utarg, Jass::UNIT_TYPE_HERO ) )
						{
							Jass::IssueImmediateOrder( source, "thunderclap" );
							Jass::IssueTargetOrder( source, "cripple", utarg );
							Jass::IssueTargetOrder( source, "hex", utarg );
							Jass::IssueTargetOrder( source, "banish", utarg );
							Jass::IssuePointOrder( source, "breathoffire", targX, targY );
							Jass::IssuePointOrder( source, "earthquake", targX, targY );
						}

						if ( source != boss )
						{
							if ( ACF_GetUnitStatePercent( source, Jass::UNIT_STATE_LIFE, Jass::UNIT_STATE_MAX_LIFE ) <= 20.f )
							{
								Jass::IssuePointOrder( source, "move", team == 0 ? -4288.f : 4288.f, -576.f );
							}
							else
							{
								if ( tick >= 10 )
								{
									Jass::IssuePointOrder( source, "attack", Jass::GetRandomReal( -1900.f, 1900.f ), Jass::GetRandomReal( -110.f, 180.f ) );
									tick = 0;
								}
							}
						}
					}
				}			
			}
		);
		*/

		if ( u != Jass::LoadUnitHandle( DataHT, 'BOSS', 'unit' ) )
		{
			player p = Jass::GetOwningPlayer( u );
			aidifficulty ai = Jass::GetAIDifficulty( p );

			if ( ai == Jass::AI_DIFFICULTY_NEWBIE )
			{
				Jass::SetPlayerHandicapXP( p, 1.5f );
			}
			else if ( ai == Jass::AI_DIFFICULTY_NORMAL )
			{
				Jass::SetPlayerHandicapXP( p, 2.f );
			}
			else if ( ai == Jass::AI_DIFFICULTY_INSANE )
			{
				Jass::SetPlayerHandicapXP( p, 3.f );
			}

			Jass::IssuePointOrder( u, "attack", Jass::GetRandomReal( -1900.f, 1900.f ), Jass::GetRandomReal( -1200.f, 200.f ) );
		}
	}

	namespace PickSystem
	{
		void InitHeroData( uint id, uint uid, float scale, uint itemId, string modelPath, string iconPath )
		{
			Jass::SaveInteger( DataHT, id, 'type', uid );
			Jass::SaveReal( DataHT, uid, 'size', scale );
			Jass::SaveStr( DataHT, uid, 'mmdl', modelPath + ".mdl" );
			Jass::SaveStr( DataHT, uid, 'imdl', modelPath + "Icon.mdl" );
			Jass::SaveStr( DataHT, uid, 'icon', iconPath );

			Jass::SaveInteger( DataHT, uid, 'pitm', itemId );

			TotalHeroes++;
		}
	}

	namespace BossSystem
	{
		void InitBossData( uint id, uint uid )
		{
			Jass::SaveInteger( DataHT, 'btid', id, uid );
		}

		unit CreateSide( uint id, uint side )
		{
			unit u = Jass::CreateUnit( Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE ), Jass::LoadInteger( DataHT, 'btid', id ), side == 'lbos' ? -2200.f : 2200.f, 2800.f, 270.f );
			Jass::SaveInteger( DataHT, Jass::GetHandleId( u ), 'side', side );
			Jass::SaveInteger( DataHT, Jass::GetHandleId( u ), 'indx', id );

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

		player p = Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE );

		SelectionUnit = Jass::CreateUnit( p, 'u012', -1800.f, 5525.f, 270.f );
		Jass::SetUnitScale( SelectionUnit, 2.5f, 2.5f, 2.5f );
		Ef_Selection = Jass::AddSpecialEffectTarget( "HeroSelectionSystem\\HeroSelectionEffect.mdl", SelectionUnit, "origin" );
		Ef_SelectionBack = Jass::AddSpecialEffectTarget( "HeroSelectionSystem\\HeroSelectionBackground.mdl", SelectionUnit, "origin" );

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
			int uid = Jass::LoadInteger( DataHT, id, 'type' ); if ( uid == 0 ) { continue; }

			unit u = Jass::CreateUnit( p, 'u013', x, y, 270.f );
			Jass::SetUnitVertexColor( u, 255, 255, 255, 0 );
			Jass::SetUnitUserData( u, id );
			U_SelectionHeroDummyArr[id] = u;
			EF_SelectionIconArray[id] = Jass::AddSpecialEffect( Jass::LoadStr( DataHT, uid, 'imdl' ), x, y );
			
			HeroUnitArray[id] = Jass::CreateUnit( p, uid, x_d, y_d, 270.f );
			Jass::SetUnitInvulnerable( HeroUnitArray[id], true );

			x += 100.f;
			x_d += 150.f;
		}
	}

	void MoveHeroToTeamLocation( int pid, int heroId )
	{
		player p = Jass::Player( pid );
		int team = Jass::GetPlayerTeam( p );

		if ( HeroesSelected < TotalPlayers )
		{
			HeroesSelected++;
			Jass::SaveBoolean( DataHT, Jass::GetHandleId( p ), 'HERO', true );
		}

		if ( team == 0 )
		{
			TeamOneSelected[heroId] = true;
		}
		else
		{
			TeamTwoSelected[heroId] = true;
		}

		int uid = Jass::LoadInteger( DataHT, heroId, 'type' );
		unit u = Jass::CreateUnit( p, uid, team == 0 ? -4480.f : 4480.f, -480.f, 270.f );
		InitHero( u );
		if ( Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_USER )
		{
			Jass::SetPlayerName( p, PlayerColoredNameArray[pid] + " [ " + Jass::GetUnitName( u ) + " ]" );
			if ( Jass::GetLocalPlayer( ) == p )
			{
				Jass::SetCameraField( Jass::CAMERA_FIELD_ANGLE_OF_ATTACK, 305.f, 0.f );
				Jass::PanCameraToTimed( Jass::GetUnitX( u ), Jass::GetUnitY( u ), 0.f );
				Jass::ClearSelection( );
				Jass::SelectUnit( u, true );
			}
		}
		else
		{
			StartAI( u );
			Jass::SetPlayerName( p, PlayerColorStringArray[pid] + Jass::GetHeroProperName( u ) );
		}

		MUnitArray[pid] = u;

		if ( !SameHeroBoolean )
		{
			Jass::RemoveUnit( HeroUnitArray[heroId] );
			Jass::RemoveUnit( U_SelectionHeroDummyArr[heroId] );
		}

		int mbId = pid + 1 + Jass::GetPlayerTeam( p );

		multiboarditem mbitem = Jass::MultiboardGetItem( MainMultiboard, mbId, 0 );
		Jass::MultiboardSetItemIcon( mbitem, Jass::LoadStr( DataHT, uid, 'icon' ) );
		Jass::MultiboardReleaseItem( mbitem );
		mbitem = Jass::MultiboardGetItem( MainMultiboard, mbId, 0 );
		Jass::MultiboardSetItemValue( mbitem, PlayerColoredNameArray[pid] );
		Jass::MultiboardReleaseItem( mbitem );

		Jass::DisplayTextToPlayer
		(
			Jass::GetLocalPlayer( ),
			0.f,
			0.f,
			PlayerColoredNameArray[pid] + "|r:|c0000ffff has chosen " + PlayerColorStringArray[pid] + Jass::GetUnitName( MUnitArray[pid] ) + "|r"
		);
	}

	void ComputerHeroSelection( )
	{
		if ( HeroesSelected >= TotalPlayers )
		{
			Jass::DestroyEffect( Ef_Selection );
			Jass::DestroyEffect( Ef_SelectionBack );
			Jass::RemoveUnit( SelectionUnit );

			for ( int i = 0; i < 8; i++ )
			{
				player p = Jass::Player( i );
				
				if ( Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING && Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_COMPUTER )
				{
					for ( int rand = Jass::GetRandomInt( 1, TotalHeroes ); !TeamOneSelected[rand] && !TeamTwoSelected[rand]; rand = Jass::GetRandomInt( 1, TotalHeroes ) )
					{
						MoveHeroToTeamLocation( i, rand );
					}
				}
			}

			for ( int i = 1; i <= TotalHeroes; i++ )
			{
				Jass::DestroyEffect( EF_SelectionIconArray[i] );
				Jass::RemoveUnit( U_SelectionHeroDummyArr[i] );
				Jass::RemoveUnit( HeroUnitArray[i] );
			}

			Jass::DisableTrigger( TR_HeroSelection );
		}
	}

	void HeroSelectionAction( )
	{
		player p = Jass::GetTriggerPlayer( );
		unit u = Jass::GetTriggerUnit( );
		int teamId = Jass::GetPlayerTeam( p );
		int pid = Jass::GetPlayerId( p );
		int heroId = Jass::GetUnitUserData( u );
		int uid = Jass::LoadInteger( DataHT, heroId, 'type' );
		string smdl = "";

		if ( !Jass::LoadBoolean( DataHT, Jass::GetHandleId( p ), 'HERO' ) && Jass::GetUnitTypeId( u ) == 'u013' )
		{
			if ( U_SelectionSelArr[pid] != HeroUnitArray[heroId] )
			{
				float scale = Jass::LoadReal( DataHT, uid, 'size' );

				if ( Jass::GetLocalPlayer( ) == p )
				{
					smdl = Jass::LoadStr( DataHT, uid, 'mmdl' );
					Jass::ClearSelection( );
					Jass::SelectUnit( HeroUnitArray[heroId], true );
				}
				Jass::DestroyEffect( EF_SelectionHeroModelArray[pid] );
				Jass::RemoveUnit( U_SelectionDumArr[pid] );
				U_SelectionDumArr[pid] = Jass::CreateUnit( Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE ), 'u012', -1800.f, 5525.f, 270.f );
				Jass::SetUnitTimeScale( U_SelectionDumArr[pid], 1.5f );
				Jass::SetUnitScale( U_SelectionDumArr[pid], scale, scale, scale );
				EF_SelectionHeroModelArray[pid] = Jass::AddSpecialEffectTarget( smdl, U_SelectionDumArr[pid], "origin" );

				U_SelectionSelArr[pid] = HeroUnitArray[heroId];
			}
			else
			{
				if ( ( TeamOneSelected[heroId] == false && teamId == 0 ) || ( TeamTwoSelected[heroId] == false && teamId == 1 ) )
				{
					Jass::DestroyEffect( EF_SelectionHeroModelArray[pid] );
					Jass::RemoveUnit( U_SelectionDumArr[pid] );
					MoveHeroToTeamLocation( pid, heroId );
					ComputerHeroSelection( );
				}
				else
				{
					Jass::DisplayTextToPlayer( p, .0f, .0f, "|c0000ffffHero already selected by your ally!" );
				}
			}
		}
	}

	void PlayerNameSettingAction( )
	{
		int tid = 1;

		for ( int i = 0; i < 12; i++ )
		{
			player p = Jass::Player( i );
			string name = "";

			if ( i <= 7 )
			{
				if ( Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING )
				{
					if ( Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_COMPUTER )
					{
						name = "Bot " + Jass::I2S( i + 1 );
					}
					else
					{
						name = Jass::GetPlayerName( p );
					}
				}
				else
				{
					name = "- Empty Slot -";
				}
			}
			else if ( i >= 10 )
			{
				name = "Base Tower " + Jass::I2S( tid );
				tid++;
			}

			if ( name.isEmpty( ) )
			{
				continue;
			}

			PlayerNameArray[i] = name;
			PlayerColoredNameArray[i] = PlayerColorStringArray[i] + PlayerNameArray[i] + "|r";

			Jass::SetPlayerName( p, PlayerColoredNameArray[i] ); // crashes -> PlayerColoredNameArray[i]
		}
	}

	void AllHeroPickAction( )
	{
		player p = Jass::GetTriggerPlayer( );
		float CenterX = Jass::GetPlayerTeam( p ) == 0 ? -4288.f : 4288.f;
		Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 10.f, "|c0000ff00The host got all heroes.|r" );

		for ( int i = 1; i <= TotalHeroes; i++ )
		{
			InitHero( Jass::CreateUnit( p, Jass::LoadInteger( DataHT, i, 'type' ), CenterX, -576.f, 270.f ) );
		}
	}

	void SetUnitFlyHeightEx( unit u, float height, float time )
	{
		ability a = Jass::GetUnitAbility( u, 'A04U' );

		if ( a == nil )
		{
			Jass::UnitAddAbility( u, 'A04U' );
			a = Jass::GetUnitAbility( u, 'A04U' );
		}

		Jass::ShowAbility( a, false );
		Jass::SetUnitFlyHeight( u, height, time );
	}

	// Effect API
	effect CreateEffect( string model, float x, float y, float facing )
	{
		effect ef = Jass::AddSpecialEffect( model, x, y );
		Jass::SetSpecialEffectFacing( ef, facing );

		return ef;
	}

	effect CreateEffectEx( string model, float x, float y, float height = .0f, float facing = 270.f, float scale = 1.f, float timeScale = 1.f )
	{
		effect ef = CreateEffect( model, x, y, facing );
		Jass::SetSpecialEffectHeight( ef, height );
		Jass::SetSpecialEffectScale( ef, scale );
		Jass::SetSpecialEffectTimeScale( ef, timeScale );

		return ef;
	}

	void RemoveEffect( effect ef )
	{
		if ( ef == nil ) { return; }

		Jass::SetSpecialEffectVisible( ef, false );
		Jass::DestroyEffect( ef );
	}

	timer LifeTimer;
	hashtable LifeHT = Jass::InitHashtable( );

	void SetEffectTimedLife( effect ef, float time, string anim = "" )
	{
		if ( Jass::IsHandleDestroyed( ef ) ) { return; } // returns true if ef is nil, or underlaying object was destroyed.

		int ef_hid = Jass::GetHandleId( ef );
		Jass::SaveReal( LifeHT, ef_hid, 'LIFE', time );
		Jass::SaveStr( LifeHT, ef_hid, 'ANIM', anim );

		int hid = Jass::GetHandleId( LifeTimer );
		handlelist hl = Jass::LoadHandleList( LifeHT, hid, 'ELST' );

		if ( hl == nil )
		{
			LifeTimer = Jass::CreateTimer( );
			hid = Jass::GetHandleId( LifeTimer );
			hl = Jass::HandleListCreate( );

			Jass::SaveHandleList( LifeHT, hid, 'ELST', hl );

			Jass::TimerStart
			(
				LifeTimer,
				.05f,
				true,
				function()
				{
					int hid = Jass::GetHandleId( Jass::GetExpiredTimer( ) );
					handlelist hl = Jass::LoadHandleList( LifeHT, hid, 'ELST' ); if ( hl == nil ) { return; }
					int max = Jass::HandleListGetCount( hl );

					//print( "OnProcessEffectList: " + "hl = " + Jass::I2S( Jass::GetHandleId( hl ) ) + " | max: " + Jass::I2S( max ) + "\n" );

					for ( int i = 0; i < max; i++ )
					{
						effect ef = Jass::HandleListGetEffectByIndex( hl, i ); if ( ef == nil ) { break; }
						int ef_hid = Jass::GetHandleId( ef );
						float life = Jass::LoadReal( LifeHT, ef_hid, 'LIFE' ) - .05f;

						if ( life <= .0f )
						{
							Jass::HandleListRemoveHandle( hl, ef );

							string anim = Jass::LoadStr( LifeHT, ef_hid, 'ANIM' );

							if ( anim.isEmpty( ) )
							{
								RemoveEffect( ef );
							}
							else
							{
								Jass::SetSpecialEffectAnimation( ef, anim );
								Jass::DestroyEffect( ef );
							}
							
							i--;
							max = Jass::HandleListGetCount( hl );
						}
						else
						{
							Jass::SaveReal( LifeHT, ef_hid, 'LIFE', life );
						}
					}				
				}
			);
		}

		Jass::HandleListAddHandle( hl, ef );
	}

	namespace EffectAPI
	{
		void Dash( unit source, int effCount = 6, float moveStep = 40.f, float initSize = .4f, float sizeStep = .25f, float timeScale = 1.25f, float height = 50.f )
		{
			float angle = Jass::GetUnitFacing( source );
			float x = Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, 100.f );
			float y = Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, 100.f );
			effect ef;

			for ( int i = 0; i < effCount; i++ )
			{
				float move = -( moveStep + moveStep * i );

				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", Jass::MathPointProjectionX( x, angle, move ), Jass::MathPointProjectionY( y, angle, move ), height, angle, initSize + sizeStep * i, timeScale );
				Jass::SetSpecialEffectAlpha( ef, 0xA0 );
				Jass::SetSpecialEffectPitch( ef, -90.f );
				SetEffectTimedLife( ef, 4.f );
			}
		}

		void Jump( unit source, int effCount = 6 )
		{
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::GetUnitFacing( source );
			effect ef;

			//ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 3.f, 1.f );
			//SetEffectTimedLife( ef, 1.f );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );

			for ( int i = 0; i < effCount; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, Jass::GetRandomReal( .0f, 360.f ), 1.f + .25f * i, Jass::GetRandomReal( .5f, 1.5f ) );
				Jass::SetSpecialEffectAlpha( ef, 0xA0 );
				SetEffectTimedLife( ef, 4.f );
			}
		}

		void InverseDash( unit source, int effCount = 6, float moveStep = 25.f, float initSize = .4f, float sizeStep = .15f, float timeScale = 1.25f, float height = 50.f )
		{
			Dash( source, effCount, -moveStep, initSize, sizeStep, timeScale, height );
		}

		void PushWind( unit source, unit target, float baseHeight = 50.f, float pitch = -90.f )
		{
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
			float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
			effect ef;

			for ( int i = 0; i < 3; i++ )
			{
				float move = 25.f + 25.f * i;

				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", Jass::MathPointProjectionX( x, angle, move ), Jass::MathPointProjectionY( y, angle, move ), 50.f, angle, 1.f + .25f * i, 1.f );
				Jass::SetSpecialEffectPitch( ef, pitch );
				SetEffectTimedLife( ef, 4.f );
			}

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, baseHeight, angle, 1.5f, 2.f );
			Jass::SetSpecialEffectPitch( ef, pitch );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, baseHeight, angle, 1.f, 2.f );
			Jass::SetSpecialEffectPitch( ef, pitch );
			SetEffectTimedLife( ef, 3.f );
		}
	}
	//

	bool DisplaceWar3ImageToTarget( war3image source, war3image target, float speed, float minDist )
	{
		float x = Jass::GetWar3ImageX( source );
		float y = Jass::GetWar3ImageY( source );
		float targX = Jass::GetWar3ImageX( target );
		float targY = Jass::GetWar3ImageY( target );
		float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
		float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );

		Jass::SetWar3ImageFacing( source, angle, true );

		if ( dist > minDist )
		{
			x = Jass::MathPointProjectionX( x, angle, speed );
			y = Jass::MathPointProjectionY( y, angle, speed );
			dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
			Jass::SetWar3ImagePosition( source, x, y );
		}

		return dist <= minDist;
	}

	void DisplaceCircular( player enemyTo, float startX, float startY, float aoe, float angle, float scale = 1.f, string eff = "" )
	{
		for ( int i = 0; i < 1; i++ )
		{
			float x = Jass::MathPointProjectionX( startX, angle, angle );
			float y = Jass::MathPointProjectionY( startY, angle, angle );

			if ( !eff.isEmpty( ) )
			{
				effect ef = CreateEffectEx( eff, x, y, .0f, .0f, scale, 1.f );
				
				Jass::DestroyEffect( ef );
			}

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, aoe, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, enemyTo ) )
				{
					SetUnitXY( u, x, y );
				}
			}

			angle += 180.f;
		}
	}

	void DisplaceUnitWithArgs( unit u, float angle, float dist, float time, float rate, float heightMax )
	{
		if ( u == nil || Jass::LoadInteger( GameHT, Jass::GetHandleId( u ), 'disp' ) > 0 ) { return; }

		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );
		float x = Jass::GetUnitX( u );
		float y = Jass::GetUnitY( u );
		int magnitudeMax = Jass::R2I( time / rate );
		int magnitude = 0;
		float step = dist / magnitudeMax;
		float heightStep = 1.f / magnitudeMax;
		float heightOrig = Jass::GetUnitFlyHeight( u );

		Jass::SetUnitPathing( u, false );
		Jass::SaveInteger( GameHT, Jass::GetHandleId( u ), 'disp', 1 );
		Jass::SaveUnitHandle( GameHT, hid, 'usrc', u );
		Jass::SaveReal( GameHT, hid, 'horg', heightOrig );
		Jass::SaveReal( GameHT, hid, 'angl', angle );
		Jass::SaveReal( GameHT, hid, 'step', step );
		Jass::SaveReal( GameHT, hid, 'hmax', heightMax );
		Jass::SaveReal( GameHT, hid, 'hstp', heightStep );
		Jass::SaveReal( GameHT, hid, 'srcX', x );
		Jass::SaveReal( GameHT, hid, 'srcY', y );
		Jass::SaveInteger( GameHT, hid, 'magc', magnitude );
		Jass::SaveInteger( GameHT, hid, 'magm', magnitudeMax );

		Jass::TimerStart
		(
			tmr,
			rate,
			true,
			function()
			{
				timer tmr = Jass::GetExpiredTimer( );
				int hid = Jass::GetHandleId( tmr );
				int magnitude = Jass::LoadInteger( GameHT, hid, 'magc' );
				int magnitudeMax = Jass::LoadInteger( GameHT, hid, 'magm' );
				float heightOrig = Jass::LoadReal( GameHT, hid, 'horg' );
				unit u = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				int isMoved = Jass::LoadInteger( GameHT, Jass::GetHandleId( u ), 'disp' );

				if ( ( magnitude < magnitudeMax && isMoved > 0 ) && Jass::IsUnitAlive( u ) )
				{
					float angle = Jass::LoadReal( GameHT, hid, 'angl' );
					float step = Jass::LoadReal( GameHT, hid, 'step' );
					float x = Jass::LoadReal( GameHT, hid, 'srcX' );
					float y = Jass::LoadReal( GameHT, hid, 'srcY' );

					float moveX = Jass::MathPointProjectionX( x, angle, magnitude * step );
					float moveY = Jass::MathPointProjectionY( y, angle, magnitude * step );
					bool isMove = IsAxisReal( moveX, moveY );

					if ( isMove )
					{
						SetUnitXY( u, moveX, moveY );
					}
					
					float heightMax = Jass::LoadReal( GameHT, hid, 'hmax' );
					float heightStep = Jass::LoadReal( GameHT, hid, 'hstp' );
					float hmag = ( 2.f * Jass::I2R( magnitude ) * heightStep - 1 );
					Jass::SaveInteger( GameHT, hid, 'magc', magnitude + 1 );
					SetUnitFlyHeightEx( u, ( 1.f + -hmag * hmag ) * heightMax + heightOrig, 99999.f );
				}
				else
				{
					SetUnitFlyHeightEx( u, heightOrig, 99999.f );
					Jass::SetUnitPathing( u, true );
					Jass::SaveInteger( GameHT, Jass::GetHandleId( u ), 'disp', isMoved - 1 );
					Jass::PauseTimer( tmr );
					Jass::FlushChildHashtable( GameHT, hid );
					Jass::DestroyTimer( tmr );
				}
			}
		);
	}

	void DisplaceWar3ImageWithArgs( war3image source, float angle, float dist, float time, float rate, float heightMax )
	{
		if ( source == nil || Jass::LoadInteger( GameHT, Jass::GetHandleId( source ), 'disp' ) > 0 ) { return; }

		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );
		float x = Jass::GetWar3ImageX( source );
		float y = Jass::GetWar3ImageY( source );
		int magnitudeMax = Jass::R2I( time / rate );
		int magnitude = 0;
		float step = dist / magnitudeMax;
		float heightStep = 1.f / magnitudeMax;
		float heightOrig = Jass::GetWar3ImageHeight( source );

		Jass::SaveInteger( GameHT, Jass::GetHandleId( source ), 'disp', 1 );
		Jass::SaveWar3ImageHandle( GameHT, hid, '+src', source );
		Jass::SaveReal( GameHT, hid, 'horg', heightOrig );
		Jass::SaveReal( GameHT, hid, 'angl', angle );
		Jass::SaveReal( GameHT, hid, 'step', step );
		Jass::SaveReal( GameHT, hid, 'hmax', heightMax );
		Jass::SaveReal( GameHT, hid, 'hstp', heightStep );
		Jass::SaveReal( GameHT, hid, 'srcX', x );
		Jass::SaveReal( GameHT, hid, 'srcY', y );
		Jass::SaveInteger( GameHT, hid, 'magc', magnitude );
		Jass::SaveInteger( GameHT, hid, 'magm', magnitudeMax );

		Jass::TimerStart
		(
			tmr,
			rate,
			true,
			function()
			{
				timer tmr = Jass::GetExpiredTimer( );
				int hid = Jass::GetHandleId( tmr );
				int magnitude = Jass::LoadInteger( GameHT, hid, 'magc' );
				int magnitudeMax = Jass::LoadInteger( GameHT, hid, 'magm' );
				float heightOrig = Jass::LoadReal( GameHT, hid, 'horg' );
				war3image source = Jass::LoadEffectHandle( GameHT, hid, '+src' );
				int isMoved = Jass::LoadInteger( GameHT, Jass::GetHandleId( source ), 'disp' );

				if ( ( magnitude < magnitudeMax && isMoved > 0 ) )
				{
					float angle = Jass::LoadReal( GameHT, hid, 'angl' );
					float step = Jass::LoadReal( GameHT, hid, 'step' );
					float x = Jass::LoadReal( GameHT, hid, 'srcX' );
					float y = Jass::LoadReal( GameHT, hid, 'srcY' );
					float moveX = Jass::MathPointProjectionX( x, angle, magnitude * step );
					float moveY = Jass::MathPointProjectionY( y, angle, magnitude * step );
					bool isMove = IsAxisReal( moveX, moveY );

					if ( isMove )
					{
						Jass::SetWar3ImagePosition( source, moveX, moveY );
					}
					
					float heightMax = Jass::LoadReal( GameHT, hid, 'hmax' );
					float heightStep = Jass::LoadReal( GameHT, hid, 'hstp' );
					float hmag = ( 2.f * Jass::I2R( magnitude ) * heightStep - 1 );
					Jass::SaveInteger( GameHT, hid, 'magc', magnitude + 1 );
					Jass::SetWar3ImageHeight( source, ( 1.f + -hmag * hmag ) * heightMax + heightOrig );
				}
				else
				{
					Jass::SetWar3ImageHeight( source, heightOrig );
					Jass::ResetWar3ImageZ( source );
					Jass::SaveInteger( GameHT, Jass::GetHandleId( source ), 'disp', isMoved - 1 );
					Jass::PauseTimer( tmr );
					Jass::FlushChildHashtable( GameHT, hid );
					Jass::DestroyTimer( tmr );
				}			
			}
		);
	}

	void DisplaceWar3ImageLinear( war3image source, float angle, float dist, float ticks, float rate, bool destDestr, bool ignorePathing, string effmdl = "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl" )
	{
		if ( source == nil )
		{
			return;
		}

		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );
		float step = 2.f * dist * rate / ticks;

		Jass::SaveReal( GameHT, hid, 'angl', angle );
		Jass::SaveReal( GameHT, hid, 'step', step );
		Jass::SaveReal( GameHT, hid, 'rate', step * rate / ticks );
		Jass::SaveWar3ImageHandle( GameHT, hid, '+src', source );
		Jass::SaveBoolean( GameHT, hid, 'PATH', !ignorePathing );
		Jass::SaveStr( GameHT, hid, 'emdl', effmdl );
		Jass::SaveReal( GameHT, hid, 'time', ticks / rate );
		Jass::TimerStart
		(
			tmr,
			rate,
			true,
			function()
			{
				timer tmr = Jass::GetExpiredTimer( );
				int hid = Jass::GetHandleId( tmr );

				float angle = Jass::LoadReal( GameHT, hid, 'angl' );
				float step = Jass::LoadReal( GameHT, hid, 'step' );
				war3image source = Jass::LoadWar3ImageHandle( GameHT, hid, '+src' );
				float x = Jass::GetWar3ImageX( source );
				float y = Jass::GetWar3ImageY( source );
				float moveX = Jass::MathPointProjectionX( x, angle, step );
				float moveY = Jass::MathPointProjectionY( y, angle, step );
				bool isMove = Jass::LoadBoolean( GameHT, hid, 'PATH' ) ? !Jass::IsTerrainPathable( moveX, moveY, Jass::PATHING_TYPE_WALKABILITY ) : true;

				if ( step <= 0 || !IsAxisReal( moveX, moveY ) || !isMove )
				{
					Jass::PauseTimer( tmr );
					Jass::FlushChildHashtable( GameHT, hid );
					Jass::DestroyTimer( tmr );
					return;
				}

				string effMdl = Jass::LoadStr( GameHT, hid, 'emdl' );

				if ( !effMdl.isEmpty( ) )
				{
					Jass::DestroyEffect( Jass::AddSpecialEffect( effMdl, x, y ) );
				}

				Jass::SetWar3ImagePosition( source, moveX, moveY );
				Jass::SaveReal( GameHT, hid, 'step', step - Jass::LoadReal( GameHT, hid, 'rate' ) );
			}
		);
	}

	void DamageVisualDrawNumber( string i, float x, float y, string suffix )
	{
		Jass::DestroyEffect( Jass::AddSpecialEffect( "DamageSystemVisual\\Number_" + i + suffix + ".mdx", x, y ) );
	}

	float DamageVisualGetPosition( float startX, float x, int index, int length, float scale )
	{
		return x - ( startX * scale * ( length / 2 ) ) + ( startX * scale * index );
	}

	void DamageVisualDrawNumberAction( unit u, unit target, float dmg )
	{
		if ( dmg == .0f ) { return; }

		float startX = 70.f;
		float x = Jass::GetUnitX( target );
		float y = Jass::GetUnitY( target ) + Jass::GetUnitFlyHeight( target ) + 150;
		string numb = Jass::I2S( Jass::R2I( dmg ) );
		int length = Jass::StringLength( numb );
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
			if ( Jass::IsUnitInvisible( target, Jass::GetOwningPlayer( u ) ) == false )
			{
				DamageVisualDrawNumber( Jass::SubString( numb, index, index + 1 ), newX, y, suffix );
			}
		}
	}

	void AkamePoisonCheck( unit source, unit targ )
	{
		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );

		Jass::SaveUnitHandle( GameHT, hid, 'usrc', source );
		Jass::SaveUnitHandle( GameHT, hid, 'utrg', targ );
		Jass::TimerStart
		(
			tmr,
			1.f,
			true,
			function()
			{
				timer tmr = Jass::GetExpiredTimer( );
				int hid = Jass::GetHandleId( tmr );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

				if ( Jass::GetUnitAbilityLevel( target, 'B006' ) > 0 )
				{
					float dmg = 10 + Jass::GetHeroLevel( source ) + .1f * Jass::GetHeroInt( source, true );
					ACF_DamageTarget( source, target, dmg );
				}
				else
				{
					Jass::FlushChildHashtable( GameHT, hid );
					Jass::DestroyTimer( tmr );
				}
			}
		);
	}

	void OnPlayerUnitDamaged( )
	{
		float dmg = Jass::GetEventDamage( );

		trigger t = Jass::GetTriggeringTrigger( );
		unit source = Jass::GetEventDamageSource( );
		unit target = Jass::GetTriggerUnit( );
		int tid = Jass::GetUnitTypeId( target );

		float multiplier = 1.f;
		float dmgMulti = 0;

		Jass::DisableTrigger( t );

		if ( Jass::GetEventIsAttack( ) )
		{
			if ( tid == 'n000' && ( Jass::GetUnitTypeId( source ) == 'base' || Jass::IsUnitType( source, Jass::UNIT_TYPE_HERO ) ) )
			{
				SetUnitXY( KawarimiTriggerUnitArray[Jass::GetPlayerId( Jass::GetOwningPlayer( target ) )], Jass::GetUnitX( source ), Jass::GetUnitY( source ) );
				Jass::UnitApplyTimedLife( target, 'BOmi', .01f );
			}

			if ( Jass::GetUnitTypeId( source ) == 'H00G' )
			{
				int bid = 'B006';
				buff buf = Jass::GetUnitBuff( target, bid );
				float dur = Jass::GetBuffBaseRealFieldById( bid, Jass::IsUnitHero( target ) ? Jass::ABILITY_RLF_DURATION_HERO : Jass::ABILITY_RLF_DURATION_NORMAL );

				if ( buf == nil )
				{
					Jass::UnitAddBuffById( target, bid );
					buf = Jass::GetUnitBuff( target, bid );
					AkamePoisonCheck( source, target );
				}

				Jass::SetBuffRemainingDuration( buf, dur );
			}
			else if ( Jass::GetUnitTypeId( source ) == 'H00K' )
			{
				Jass::SetUnitCurrentLife( source, dmg * .15f + Jass::GetUnitCurrentLife( source ) );
			}

			if ( Jass::GetUnitAbilityLevel( source, 'B002' ) > 0 || Jass::GetUnitAbilityLevel( source, 'B000' ) > 0 )
			{
				if ( Jass::GetUnitAbilityLevel( source, 'B002' ) > 0 )
				{
					dmgMulti = 10;
				}
				if ( Jass::GetUnitAbilityLevel( source, 'B000' ) > 0 )
				{
					dmgMulti = 20;
				}

				float reqHP = 5.f;

				if ( ACF_HasPersonalItem( source ) )
				{
					dmgMulti = dmgMulti + dmgMulti / 2;
					reqHP = 10.f;
				}

				dmg = Jass::GetHeroLevel( source ) * dmgMulti + Jass::GetHeroInt( source, true ) * dmgMulti / 100;
				if ( ACF_GetUnitStatePercent( target, Jass::UNIT_STATE_LIFE, Jass::UNIT_STATE_MAX_LIFE ) <= reqHP && target != Jass::LoadUnitHandle( DataHT, 'BOSS', 'unit' ) )
				{
					int aid = 0;

					if ( Jass::GetUnitAbilityLevel( source, 'B002' ) > 0 )
					{
						aid = 'A02X';
						Jass::UnitRemoveAbility( source, 'B002' );
					}

					if ( Jass::GetUnitAbilityLevel( source, 'B000' ) > 0 )
					{
						aid = 'A035';
						Jass::UnitRemoveAbility( source, 'B000' );
					}

					Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, aid ), .01f );

					dmg = 100000000.f;
					float targX = Jass::GetUnitX( target );
					float targY = Jass::GetUnitY( target );

					SetEffectTimedLife( CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 1.f, 4.f ), 4.f );
					
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
				}

				Jass::SetEventDamage( Jass::GetEventDamage( ) + dmg );
			}

			if ( Jass::GetUnitTypeId( source ) == 'H00J'  && Jass::GetRandomInt( 0, 100 ) <= 15 )
			{
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );
				float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
				effect ef;

				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 50.f, angle, 1.5f, 3.f );
				Jass::SetSpecialEffectPitch( ef, -90.f );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.5f, 3.f );
				Jass::SetSpecialEffectPitch( ef, -90.f );
				SetEffectTimedLife( ef, 3.f );

				dmg = Jass::GetHeroLevel( source ) * 50 + Jass::GetHeroInt( source, true );
				DisplaceUnitWithArgs( target, angle, 200.f, .25f, .01f, 0 );
				Jass::SetEventDamage( Jass::GetEventDamage( ) + dmg );
			}

			if ( Jass::GetUnitTypeId( source ) == 'H00H' )
			{
				if ( !Jass::IsUnitType( target, Jass::UNIT_TYPE_HERO ) )
				{
					dmgMulti = 2;
				}
				dmgMulti = .01f * multiplier;
				dmg = .005f * multiplier * Jass::GetUnitMaxLife( target );

				Jass::SetEventDamage( Jass::GetEventDamage( ) + dmg );
				Jass::SetUnitCurrentLife( source, Jass::GetUnitMaxLife( source ) * dmgMulti + Jass::GetUnitCurrentLife( source ) );
			}
		}

		if ( Jass::GetUnitTypeId( source ) == 'base' )
		{
			Jass::SetEventDamage( Jass::GetEventDamage( ) + Jass::GetUnitMaxLife( target ) * .02f );
		}

		dmg = Jass::GetEventDamage( );
		if ( Jass::GetUnitTypeId( source ) != 'base' )
		{
			DamageVisualDrawNumberAction( source, target, dmg );
		}

		if ( tid == 'tstu'  )
		{
			Jass::SetEventDamage( .0f );
		}

		Jass::EnableTrigger( t );
	}

	void PrepareFinishGameAction( int teamId )
	{
		float x = teamId == 0 ? -800.f : 800.f;

		I_WinningTeam = teamId;
		TextTagCreate( "|c0000FF00Winners!|r", x, 1700.f, 0, 20, 255, 255, 255, 0 );
		TextTagCreate( "|c00ff0000Losers!|r", -x, 1700.f, 0, 20, 255, 255, 255, 0 );

		Jass::TimerStart
		(
			Jass::CreateTimer( ),
			1.f,
			true,
			function()
			{
				for( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
				{
					player p = Jass::Player( i ); if ( Jass::GetPlayerSlotState( p ) != Jass::PLAYER_SLOT_STATE_PLAYING ) { continue; }
					unit u = MUnitArray[ i ];
					ACF_PanCameraToTimed( p, Jass::GetUnitX( u ), Jass::GetUnitY( u ), .0f );
					SetUnitXY( u, Jass::GetPlayerTeam( p ) == 0 ? -800.f : 800.f, 1536.f );
					Jass::SetUnitFacing( u, 270.f );
					Jass::SetUnitInvulnerable( u, true );
					Jass::PauseUnit( u, true );
				}
			}
		);

		Jass::TimerStart
		(
			Jass::CreateTimer( ),
			10.f,
			false,
			function()
			{
				for( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
				{
					player p = Jass::Player( i ); if ( Jass::GetPlayerSlotState( p ) != Jass::PLAYER_SLOT_STATE_PLAYING ) { continue; }

					Jass::RemovePlayer( p, Jass::GetPlayerTeam( p ) == I_WinningTeam ? Jass::PLAYER_GAME_RESULT_VICTORY : Jass::PLAYER_GAME_RESULT_DEFEAT );
				}

				Jass::EndGame( true );			
			}
		);
	}

	void OnAnyWidgetDeath( )
	{
		widget w_d = Jass::GetTriggerWidget( );

		switch( Jass::GetHandleBaseTypeId( w_d ) )
		{
			case '+w3w': // any widget, unused
			{
				return;
			}
			case 'item':
			{
				item itm = Jass::GetTriggerItem( );
				OnProcessItemState( itm );

				return;
			}
			case '+w3d':
			{
				destructable dest = Jass::GetTriggerDestructable( );

				return;
			}
			case '+w3u':
			{
				unit killer = Jass::GetKillingUnit( );
				player k_p = Jass::GetOwningPlayer( killer );
				int k_pid = Jass::GetPlayerId( k_p );
				int kp_hid = Jass::GetHandleId( k_p );
				int k_team = Jass::GetPlayerTeam( k_p );
				unit dying = Jass::GetDyingUnit( );
				int d_hid = Jass::GetHandleId( dying );
				int d_uid = Jass::GetUnitTypeId( dying );
				player d_p = Jass::GetOwningPlayer( dying );
				int d_pid = Jass::GetPlayerId( d_p );
				int d_team = Jass::GetPlayerTeam( d_p );

				if ( d_uid == 'n000' )
				{
					unit source = KawarimiTriggerUnitArray[ d_pid ];

					Jass::SetUnitInvulnerable( source, false );
					Jass::ShowUnit( source, true );
					Jass::PauseUnit( source, false );

					Jass::GroupEnumUnitsInRange( GroupEnum, Jass::GetUnitX( dying ), Jass::GetUnitY( dying ), 300.f, nil );

					for( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
					{
						if ( Jass::IsUnitDead( u ) || Jass::IsUnitAlly( u, d_p ) ) { continue; }
						ACF_AddBuffTimed( u, 'BPSE', 2.f );
					}

					Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", Jass::GetUnitX( dying ), Jass::GetUnitY( dying ) ) );
					ACF_SelectUnit( source, d_p );

					return;
				}

				if ( Jass::IsUnitType( dying, Jass::UNIT_TYPE_HERO ) )
				{
					int d_lvl = Jass::GetHeroLevel( dying );
					unit mainBoss = Jass::LoadUnitHandle( DataHT, 'BOSS', 'unit' );

					if ( killer == mainBoss )
					{
						Jass::SetHeroStr( killer, Jass::GetHeroStr( killer, false ) + d_lvl * 2, true );
						Jass::SetHeroAgi( killer, Jass::GetHeroAgi( killer, false ) + d_lvl * 2, true );
						Jass::SetHeroInt( killer, Jass::GetHeroInt( killer, false ) + d_lvl * 2, true );
						Jass::SetUnitCurrentLife( killer, Jass::GetUnitCurrentLife( killer ) + Jass::GetUnitMaxLife( killer ) * d_lvl * .01f );
						Jass::DestroyEffect( Jass::AddSpecialEffect( "Characters\\Arcueid\\ArcueidREffect1.mdl", Jass::GetUnitX( killer ), Jass::GetUnitY( killer ) ) );
						Jass::DestroyEffect( Jass::AddSpecialEffect( "Characters\\Arcueid\\ArcueidREffect2.mdl", Jass::GetUnitX( killer ), Jass::GetUnitY( killer ) ) );
					}

					if ( dying == mainBoss )
					{
						Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 10.f, PlayerColoredNameArray[ k_pid ] + " |c008080c0Killed|r " + "|c0000FF00" + Jass::GetHeroProperName( dying ) );
						PrepareFinishGameAction( k_team );
						return;
					}

					if ( Jass::GetPlayerSlotState( d_p ) == Jass::PLAYER_SLOT_STATE_PLAYING )
					{
						timer tmr = Jass::CreateTimer( );
						int hid = Jass::GetHandleId( tmr );
						effect ef = Jass::AddSpecialEffect( "GeneralEffects\\UnitEffects\\DeathIndicator.mdl", Jass::GetUnitX( dying ), Jass::GetUnitY( dying ) );
						Jass::SetSpecialEffectHeight( ef, 150.f );

						Jass::SavePlayerHandle( GameHT, hid, '+ply', d_p );
						Jass::SaveUnitHandle( GameHT, hid, 'usrc', dying );
						Jass::SaveEffectHandle( GameHT, hid, 'efct', ef );
						Jass::TimerStart
						(
							tmr,
							4.f,
							false,
							function( )
							{
								timer tmr = Jass::GetExpiredTimer( );
								int hid = Jass::GetHandleId( tmr );
								player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
								unit u = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
								float x = Jass::GetPlayerTeam( p ) == 0 ? -4288.f : 4288.f;

								Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, 'efct' ) );
								Jass::ReviveHero( u, x, -576.f, true );
								SetUnitFlyHeightEx( u, 0.f, 2000.f );
								ACF_SelectUnit( u, p );
								ACF_PanCameraToTimed( p, Jass::GetUnitX( u ), Jass::GetUnitY( u ), .2f );

								if ( Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_COMPUTER )
								{
									Jass::IssuePointOrder( u, "attack", Jass::GetRandomReal( -1900.f, 1900.f ), Jass::GetRandomReal( -1200.f, 200.f ) );
								}

								Jass::PauseTimer( tmr );
								Jass::FlushChildHashtable( GameHT, hid );
								Jass::DestroyTimer( tmr );
							}
						);
					}

					int side = Jass::LoadInteger( DataHT, d_hid, 'side' );

					if ( side == 'lbos' || side == 'rbos' )
					{
						BossesKilledIntegerArray[ k_pid ]++;
						Jass::DisplayTextToPlayer( k_p, .0f, .0f, "|cFFFFCC00Bosses Killed:|r |c00ff8040" + Jass::I2S( BossesKilledIntegerArray[ k_pid ] ) + "|r" );
						Jass::SetPlayerState( k_p, Jass::PLAYER_STATE_RESOURCE_LUMBER, Jass::GetPlayerState( k_p, Jass::PLAYER_STATE_RESOURCE_LUMBER ) + 1 );
						if ( BossesKilledIntegerArray[ k_pid ] == 8 )
						{
							Jass::DisplayTextToPlayer( Jass::GetLocalPlayer( ), 0, 0, PlayerColoredNameArray[k_pid] + "|r has earnt enough kills for -T command" );
							Jass::SaveBoolean( GameHT, kp_hid, 'ISTP', true );
						}

						Jass::FlushChildHashtable( DataHT, d_hid );
						
						int id = Jass::LoadInteger( DataHT, d_hid, 'indx' );

						if ( id >= 0 && id <= 7 )
						{
							timer tmr = Jass::CreateTimer( );
							int hid = Jass::GetHandleId( tmr );

							Jass::SaveInteger( GameHT, hid, 'side', side );
							Jass::SaveInteger( GameHT, hid, 'indx', id );
							
							Jass::TimerStart
							(
								tmr,
								10.f,
								false,
								function( )
								{
									timer tmr = Jass::GetExpiredTimer( );
									int hid = Jass::GetHandleId( tmr );
									int side = Jass::LoadInteger( GameHT, hid, 'side' );
									int i = Jass::LoadInteger( GameHT, hid, 'indx' );
									
									BossSystem::CreateSide( i + 1, side );

									Jass::FlushChildHashtable( GameHT, hid );
									Jass::DestroyTimer( tmr );
								}
							);
						}

						return;
					}

					if ( !Jass::IsPlayerAlly( k_p, d_p ) )
					{
						multiboarditem mbItem;
						int mbIndex = 0;

						if ( k_p != Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE ) && Jass::GetUnitTypeId( killer ) != 'base' )
						{
							mbIndex = k_pid + ( d_team == 0 ? 2 : 1 );
						
							Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, PlayerColoredNameArray[ k_pid ] + " |c008080c0Killed|r " + PlayerColoredNameArray[ d_pid ] );
							KillingUnitIntegerArray[mbIndex]++;
							TeamKills[k_team]++;
							
							mbItem = Jass::MultiboardGetItem( MainMultiboard, mbIndex, 1 );
							Jass::MultiboardSetItemValue( mbItem, PlayerColorStringArray[ k_pid ] + Jass::I2S( KillingUnitIntegerArray[mbIndex] ) );
							Jass::MultiboardReleaseItem( mbItem );

							mbItem = Jass::MultiboardGetItem( MainMultiboard, d_team == 0 ? 5 : 0, 1 );
							Jass::MultiboardSetItemValue( mbItem, Jass::I2S( TeamKills[k_team] ) );
							Jass::MultiboardReleaseItem( mbItem );
						}

						mbIndex = d_pid + ( d_team == 1 ? 2 : 1 );

						DyingUnitIntegerArray[mbIndex]++;
						TeamDeaths[d_team]++;

						mbItem = Jass::MultiboardGetItem( MainMultiboard, mbIndex, 2 );
						Jass::MultiboardSetItemValue( mbItem, PlayerColorStringArray[ d_pid ] + Jass::I2S( DyingUnitIntegerArray[mbIndex] ) );
						Jass::MultiboardReleaseItem( mbItem );
						
						mbItem = Jass::MultiboardGetItem( MainMultiboard, d_team == 1 ? 5 : 0, 2 );
						Jass::MultiboardSetItemValue( mbItem, Jass::I2S( TeamDeaths[d_team] ) );
						Jass::MultiboardReleaseItem( mbItem );
						Jass::MultiboardSetTitleText( MainMultiboard, "|Cff00ff00Scoreboard|r |c00ff0000" + Jass::I2S( TeamKills[0] ) + "|r/|c000000ff" + Jass::I2S( TeamKills[1] ) + "|r" );
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
		Jass::TimerStart
		(
			Jass::CreateTimer( ),
			1.f,
			true, 
			function( )
			{
				unit u = Jass::LoadUnitHandle( DataHT, 'BOSS', 'unit' ); if ( Jass::IsUnitDead( u ) ) { Jass::DestroyTimer( Jass::GetExpiredTimer( ) ); return; }
				float x = Jass::GetUnitX( u );
				float y = Jass::GetUnitY( u );

				if ( !( x >= -544.f && x <= 544.f && y >= -4100.f && y <= -2800.f ) )
				{
					Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", x, y ) );
					x = .0f;
					y = -3850.f;
					SetUnitXY( u, x, y );
					Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", x, y ) );
				}
			}
		);
	}

	void MultiBoardCreationFunction1( )
	{
		Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), 0.f, 0.f, 5.f, "|c00ff0000Welcome to Anime Character Fight|r
		|c00ff0000Wish you an amazing victory: |r|c0000ffffor a sweet defeat : )|r
		|c00ff0000SO!: |r|c0000ffffFor spells sounds download patch from vk.com/acfwc3 or chaosrealm.info!|r" );
		MainMultiboard = Jass::CreateMultiboard( );
		Jass::MultiboardSetRowCount( MainMultiboard, 11 );
		Jass::MultiboardSetColumnCount( MainMultiboard, 3 );
		Jass::MultiboardSetTitleText( MainMultiboard, "|Cff00ff00Scoreboard|r |c00ff0000" + Jass::I2S( TeamKills[0] ) + "|r/|c000000ff" + Jass::I2S( TeamKills[1] ) + "|r" );
		Jass::MultiboardDisplay( MainMultiboard, true );

		multiboarditem mbItem = Jass::MultiboardGetItem( MainMultiboard, 10, 0 );
		Jass::MultiboardSetItemWidth( mbItem, 12.f / 100.f );
		Jass::MultiboardReleaseItem( mbItem );
		mbItem = Jass::MultiboardGetItem( MainMultiboard, 10, 1 );
		Jass::MultiboardSetItemWidth( mbItem, 12.f / 100.f );
		Jass::MultiboardReleaseItem( mbItem );
		int i = 0;
		int j = 0;
		while ( true )
		{
			if ( i > 9 ) break;
			mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 0 );
			Jass::MultiboardSetItemWidth( mbItem, 12 / 100.0f );
			Jass::MultiboardReleaseItem( mbItem );
			mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 1 );
			Jass::MultiboardSetItemWidth( mbItem, 4 / 100.0f );
			Jass::MultiboardReleaseItem( mbItem );
			mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 2 );
			Jass::MultiboardSetItemWidth( mbItem, 4 / 100.0f );
			Jass::MultiboardReleaseItem( mbItem );
			if ( i == 0 || i == 5 )
			{
				mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 1 );
				Jass::MultiboardSetItemValue( mbItem, "0" );
				Jass::MultiboardReleaseItem( mbItem );
				mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 2 );
				Jass::MultiboardSetItemValue( mbItem, "0" );
				Jass::MultiboardReleaseItem( mbItem );
				mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 1 );
				Jass::MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNTransmute.blp" );
				Jass::MultiboardReleaseItem( mbItem );
				mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 2 );
				Jass::MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNDeathCoil.blp" );
				Jass::MultiboardReleaseItem( mbItem );
			}
			if ( i != 0 && i != 5 )
			{
				mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 0 );
				if ( Jass::GetPlayerSlotState( Jass::Player( j ) ) == Jass::PLAYER_SLOT_STATE_PLAYING )
				{
					Jass::MultiboardSetItemValue( mbItem, PlayerColoredNameArray[j] + "|r" );
				}
				else
				{
					Jass::MultiboardSetItemValue( mbItem, PlayerColorStringArray[j] + "- Empty Slot -|r" );
				}
				Jass::MultiboardSetItemIcon( mbItem, "UI\\Widgets\\Console\\Human\\CommandButton\\human-button-lvls-overlay.blp" );
				Jass::MultiboardReleaseItem( mbItem );
				mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 1 );
				Jass::MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp" );
				Jass::MultiboardReleaseItem( mbItem );
				mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 2 );
				Jass::MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNFrostArmor.blp" );
				Jass::MultiboardReleaseItem( mbItem );
				mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 1 );
				Jass::MultiboardSetItemValue( mbItem, PlayerColorStringArray[j] + "0" + "|r" );
				Jass::MultiboardReleaseItem( mbItem );
				mbItem = Jass::MultiboardGetItem( MainMultiboard, i, 2 );
				Jass::MultiboardSetItemValue( mbItem, PlayerColorStringArray[j] + "0" + "|r" );
				Jass::MultiboardReleaseItem( mbItem );
				j++;
			}
			i++;
		}
		mbItem = Jass::MultiboardGetItem( MainMultiboard, 0, 0 );
		Jass::MultiboardSetItemValue( mbItem, "|c00ff0000RED|r TEAM" );
		Jass::MultiboardReleaseItem( mbItem );
		mbItem = Jass::MultiboardGetItem( MainMultiboard, 5, 0 );
		Jass::MultiboardSetItemValue( mbItem, "|c000000ffBLUE|r TEAM" );
		Jass::MultiboardReleaseItem( mbItem );
		mbItem = Jass::MultiboardGetItem( MainMultiboard, 10, 0 );
		Jass::MultiboardSetItemValue( mbItem, "Kills: Undecided" );
		Jass::MultiboardReleaseItem( mbItem );
		mbItem = Jass::MultiboardGetItem( MainMultiboard, 10, 1 );
		Jass::MultiboardSetItemValue( mbItem, "0:0:0" );
		Jass::MultiboardReleaseItem( mbItem );
		mbItem = Jass::MultiboardGetItem( MainMultiboard, 0, 0 );
		Jass::MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNOrbofSlowness.blp" );
		Jass::MultiboardReleaseItem( mbItem );
		mbItem = Jass::MultiboardGetItem( MainMultiboard, 5, 0 );
		Jass::MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNMoonStone.blp" );
		Jass::MultiboardReleaseItem( mbItem );
		mbItem = Jass::MultiboardGetItem( MainMultiboard, 10, 0 );
		Jass::MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\CommandButtons\\BTNLament.blp" );
		Jass::MultiboardReleaseItem( mbItem );
		mbItem = Jass::MultiboardGetItem( MainMultiboard, 10, 1 );
		Jass::MultiboardSetItemIcon( mbItem, "ReplaceableTextures\\WorldeditUI\\Events-time.blp" );
		Jass::MultiboardReleaseItem( mbItem );
		Jass::MultiboardDisplay( MainMultiboard, true );
	}

	void InGameTimerAction( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int secs = Jass::LoadInteger( GameHT, hid, 'secs' );
		int mins = Jass::LoadInteger( GameHT, hid, 'mins' );
		int hours = Jass::LoadInteger( GameHT, hid, 'hors' );

		if ( secs == 59 )
		{
			Jass::SaveInteger( GameHT, hid, 'secs', 0 );
			Jass::SaveInteger( GameHT, hid, 'mins', mins + 1 );
		}
		else
		{
			Jass::SaveInteger( GameHT, hid, 'secs', secs + 1 );
		}

		if ( mins == 59 )
		{
			Jass::SaveInteger( GameHT, hid, 'mins', 0 );
			Jass::SaveInteger( GameHT, hid, 'hors', hours + 1 );
		}

		multiboarditem mbitem = Jass::MultiboardGetItem( MainMultiboard, 10, 1 );
		Jass::MultiboardSetItemValue( mbitem, Jass::I2S( hours ) + ":" + Jass::I2S( mins ) + ":" + Jass::I2S( secs ) );
		Jass::MultiboardReleaseItem( mbitem );
	}

	void KillSelectionDialogAction( )
	{
		int i = 0;
		while ( true )
		{
			if ( i > 8 ) break;
			if ( Jass::GetClickedButton( ) == SameHeroModeButtonArray[i] )
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
		Jass::DialogClear( KillSelectionDialog );
		Jass::DialogDestroy( KillSelectionDialog );
		Jass::TimerDialogDisplay( ModeSelectionTD, false );
		Jass::DestroyTimerDialog( ModeSelectionTD );
		Jass::MultiboardDisplay( MainMultiboard, true );

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
			KillLimit = 20 * Jass::GetRandomInt( 1, 7 );
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
			Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, "
			|cFFFFCC00Votes for |c0000ffff[Random]|r|cFFFFCC00:|r |c0000ffff" + Jass::I2S( MBArr1[0] ) + "|r
			|cFFFFCC00Votes for |c0000ffff[20 Kills]|r|cFFFFCC00:|r |c0000ffff" + Jass::I2S( MBArr1[1] ) + "|r
			|cFFFFCC00Votes for |c0000ffff[40 Kills]|r|cFFFFCC00:|r |c0000ffff" + Jass::I2S( MBArr1[2] ) + "|r
			|cFFFFCC00Votes for |c0000ffff[60 Kills]|r|cFFFFCC00:|r |c0000ffff" + Jass::I2S( MBArr1[3] ) + "|r
			|cFFFFCC00Votes for |c0000ffff[80 Kills]|r|cFFFFCC00:|r |c0000ffff" + Jass::I2S( MBArr1[4] ) + "|r
			|cFFFFCC00Votes for |c0000ffff[100 Kills]|r|cFFFFCC00:|r |c0000ffff" + Jass::I2S( MBArr1[5] ) + "|r
			|cFFFFCC00Votes for |c0000ffff[120 Kills]|r|cFFFFCC00:|r |c0000ffff" + Jass::I2S( MBArr1[6] ) + "|r
			|cFFFFCC00Votes for |c0000ffff[140 Kills]|r|cFFFFCC00:|r |c0000ffff" + Jass::I2S( MBArr1[7] ) + "|r
			|cFFFFCC00Votes for |c0000ffff[Unlimited Kills]|cFFFFCC00:|r |c0000ffff" + Jass::I2S( MBArr1[8] ) + "|r" );
		}

		multiboarditem mbItem = Jass::MultiboardGetItem( MainMultiboard, 10, 0 );

		if ( KillLimit != 999999999 )
		{
			Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, "|cFFFFCC00Kill Limit is:|r |c0000ffff[" + Jass::I2S( KillLimit ) + "]|r |cFFFFCC00Kills|r" );
			Jass::MultiboardSetItemValue( mbItem, "Kills: " + Jass::I2S( KillLimit ) );
		}
		else
		{
			Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, "|cFFFFCC00Kill Limit is:|r |c0000ffff[Unlimited]|r |cFFFFCC00Kills.|r" );
			Jass::MultiboardSetItemValue( mbItem, "Kills: Unlimited" );
		}

		Jass::MultiboardReleaseItem( mbItem );
		Jass::EnableTrigger( TR_HeroSelection );
		Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, "|c0000ffffHero Selection has been activated!|r" );
		Jass::MultiboardDisplay( MainMultiboard, false );
		Jass::MultiboardDisplay( MainMultiboard, true );
		Jass::TimerStart( Jass::CreateTimer( ), 1, true, @InGameTimerAction );
	}

	void KillSelectionAction( )
	{
		Jass::DisplayTimedTextToPlayer
		(
			Jass::GetLocalPlayer( ), .0f, .0f, 5.f, "|c0000ffffAttention to All Players!

		You have 5 seconds to choose desirable Kill Limit"
		);
		ModeSelectionTD = Jass::CreateTimerDialog( KillSelectionTimer );
		Jass::TimerDialogSetTitle( ModeSelectionTD, "|c00ffff00Kill Limit Selection" );
		Jass::TimerDialogDisplay( ModeSelectionTD, true );

		Jass::TimerStart
		(
			KillSelectionTimer,
			5,
			false,
			@KillSelectionTimerExpireAction
		);

		Jass::DialogSetMessage( KillSelectionDialog, "Select Kill Limit" );
		SameHeroModeButtonArray[0] = Jass::DialogAddButton( KillSelectionDialog, "Random", 0 );
		SameHeroModeButtonArray[1] = Jass::DialogAddButton( KillSelectionDialog, "20 Kills [1 vs 1]", 0 );
		SameHeroModeButtonArray[2] = Jass::DialogAddButton( KillSelectionDialog, "40 Kills", 0 );
		SameHeroModeButtonArray[3] = Jass::DialogAddButton( KillSelectionDialog, "60 Kills [2 vs 2]", 0 );
		SameHeroModeButtonArray[4] = Jass::DialogAddButton( KillSelectionDialog, "80 Kills", 0 );
		SameHeroModeButtonArray[5] = Jass::DialogAddButton( KillSelectionDialog, "100 Kills [3 vs 3]", 0 );
		SameHeroModeButtonArray[6] = Jass::DialogAddButton( KillSelectionDialog, "120 Kills", 0 );
		SameHeroModeButtonArray[7] = Jass::DialogAddButton( KillSelectionDialog, "140 Kills [4 vs 4]", 0 );
		SameHeroModeButtonArray[8] = Jass::DialogAddButton( KillSelectionDialog, "Unlimited Kills", 0 );
		DialogShow( KillSelectionDialog, true );
	}

	void ModeSelectionFunction2( )
	{
		button but = Jass::GetClickedButton( );

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
		Jass::DialogClear( ModeSelectionDialog );
		Jass::DialogDestroy( ModeSelectionDialog );
		Jass::TimerDialogDisplay( ModeSelectionTD, false );
		Jass::MultiboardDisplay( MainMultiboard, true );
		Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, "|cFFFFCC00Same u Mode Results:
		For:|r |c0000ffff" + Jass::I2S( MBArr1[10] ) + "|r |cFFFFCC00Against:|r |c0000ffff" + Jass::I2S( MBArr1[11] ) + "|r" );

		if ( MBArr1[10] > MBArr1[11] )
		{
			SameHeroBoolean = true;
			Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, "|c0000FF00Same u Mode Enabled!" );
		}
		else
		{
			Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, "|c00ff0000Same u Mode Disabled!" );
		}

		Jass::TimerStart( KillSelectionTimer, 1.f, false, @KillSelectionAction );
	}

	void ModeSelectionFunction1( )
	{
		timer tmr = Jass::CreateTimer( );
		Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, "|c00FFFF00Hero Selection is disabled
		To enable it:
		Choose desirable kills and mode|r" );
		ModeSelectionTD = Jass::CreateTimerDialog( tmr );
		Jass::TimerDialogSetTitle( ModeSelectionTD, "|c00ffff00Mode Selection" );
		Jass::TimerDialogDisplay( ModeSelectionTD, true );
		Jass::DialogSetMessage( ModeSelectionDialog, "Same u Mode" );
		SameHeroModeButtonArray[10] = Jass::DialogAddButton( ModeSelectionDialog, "|c0000FF00Enable|r", 0 );
		SameHeroModeButtonArray[11] = Jass::DialogAddButton( ModeSelectionDialog, "|c00ff0000Disable|r", 0 );
		DialogShow( ModeSelectionDialog, true );
		Jass::TimerStart( tmr, 5, false, @ModeSelectionFunction3 );
	}

	void RegisterPlayerLeaveAction( )
	{
		player p = Jass::GetTriggerPlayer( );
		int pid = Jass::GetPlayerId( p );
		int teamId = Jass::GetPlayerTeam( p );
		int count = TeamPlayers[teamId] - 1;
		int gold = count > 0 ? ( Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD ) / ( TeamPlayers[teamId] - 1 ) ) : 0;
		int mbId = teamId == 0 ? pid + 1 : pid + 2;

		multiboarditem mbItem = Jass::MultiboardGetItem( MainMultiboard, mbId, 0 );
		Jass::MultiboardSetItemValue( mbItem, PlayerColorStringArray[pid] + "- Left -|r" );
		Jass::MultiboardReleaseItem( mbItem );

		TotalPlayers = TotalPlayers - 1;
		TeamPlayers[teamId] = TeamPlayers[teamId] - 1;
		Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 5.f, PlayerColoredNameArray[pid] + "|r Has left the game!" );
		Jass::RemoveUnit( MUnitArray[pid] );
		Jass::RemovePlayer( p, Jass::PLAYER_GAME_RESULT_DEFEAT );

		if ( gold > 0 )
		{
			for( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
			{
				player p2 = Jass::Player( i ); if ( Jass::GetPlayerSlotState( p2 ) != Jass::PLAYER_SLOT_STATE_PLAYING || !Jass::IsPlayerAlly( p, p2 ) ) { continue; }
				Jass::SetPlayerState( p2, Jass::PLAYER_STATE_RESOURCE_GOLD, Jass::GetPlayerState( p2, Jass::PLAYER_STATE_RESOURCE_GOLD ) + gold );
			}
			Jass::DisplayTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, "Each player in Team " + Jass::I2S( teamId + 1 ) + " has received |cFFFFCC00" + Jass::I2S( gold ) + "|r gold from a leaver." );
		}

		if ( TeamPlayers[teamId] == 0 )
		{
			PrepareFinishGameAction( teamId == 0 ? 1 : 0 );
		}
	}

	void DisableSharedUnitsAct( )
	{
		for ( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
		{
			for ( int j = 0; j < Jass::PLAYER_NEUTRAL_AGGRESSIVE; j++ )
			{
				player p1 = Jass::Player( i );
				player p2 = Jass::Player( j );

				if ( p1 == p2 ) { continue; }

				Jass::SetPlayerAlliance( p1, p2, Jass::ALLIANCE_SHARED_CONTROL, false );
			}
		}
	}

	void UnitCreationAction( )
	{
		Jass::TimerStart
		(
			CreepUpgradeTimer1,
			300.f,
			false,
			function()
			{
				Jass::PauseTimer( CreepSpawnerTimer1 );

				Jass::TimerStart
				(
					CreepUpgradeTimer1,
					600.f,
					false,
					function()
					{
						Jass::PauseTimer( CreepSpawnerTimer1 );

						Jass::TimerStart
						(
							CreepSpawnerTimer1,
							90.f,
							true,
							function()
							{
								if ( !B_IsCreepSpawn ) { return; }

								player p = Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE );

								for ( int i = 0; i < 4; i++ )
								{
									if ( i < 2 )
									{
										Jass::CreateUnit( p, 'h003', -1888.f, -160.f, 270 );
										Jass::CreateUnit( p, 'h004', -1888.f, -864.f, 270 );
										Jass::CreateUnit( p, 'h007', -1184.f, -864.f, 270 );
										Jass::CreateUnit( p, 'h015', 384.f, -896.f, 270 );
										Jass::CreateUnit( p, 'h003', 1888.f, -160.f, 270 );
										Jass::CreateUnit( p, 'h007', 1184.f, -864.f, 270 );
										Jass::CreateUnit( p, 'h004', 1888.f, -896.f, 270 );
									}
									else if ( i < 3 )
									{
										Jass::CreateUnit( p, 'h009', -1888.f, -160.f, 270 );
										Jass::CreateUnit( p, 'h016', -1888.f, -896.f, 270 );
										Jass::CreateUnit( p, 'h001', -1184.f, -896.f, 270 );
										Jass::CreateUnit( p, 'h016', -384.f, -160.f, 270 );
										Jass::CreateUnit( p, 'h001', 384.f, -160.f, 270 );
										Jass::CreateUnit( p, 'h009', -384.f, -896.f, 270 );
										Jass::CreateUnit( p, 'h009', 1888.f, -160.f, 270 );
										Jass::CreateUnit( p, 'h001', 1184.f, -896.f, 270 );
										Jass::CreateUnit( p, 'h016', 1888.f, -896.f, 270 );
									}

									Jass::CreateUnit( p, 'h015', -1184.f, -160.f, 270 );
									Jass::CreateUnit( p, 'h015', 1184.f, -160.f, 270 );
								}			
							}
						);
					}
				);

				Jass::TimerStart
				(
					CreepSpawnerTimer1,
					60.f,
					true,
					function()
					{
						if ( !B_IsCreepSpawn ) { return; }

						player p = Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE );

						for ( int i = 0; i < 6; i++ )
						{
							if ( i < 5 )
							{
								Jass::CreateUnit( p, 'h008', -1888.f, -160.f, 270 );
								Jass::CreateUnit( p, 'h002', -1888.f, -896.f, 270 );
								Jass::CreateUnit( p, 'h000', -1184.f, -896.f, 270 );
								Jass::CreateUnit( p, 'h002', -384.f, -160.f, 270 );
								Jass::CreateUnit( p, 'h000', 384.f, -160.f, 270 );
								Jass::CreateUnit( p, 'h014', 384.f, -896.f, 270 );
								Jass::CreateUnit( p, 'h008', -384.f, -896.f, 270 );
								Jass::CreateUnit( p, 'h008', 1888.f, -160.f, 270 );
								Jass::CreateUnit( p, 'h000', 1184.f, -896.f, 270 );
								Jass::CreateUnit( p, 'h002', 1888.f, -896.f, 270 );
							}
							Jass::CreateUnit( p, 'h014', -1184.f, -160.f, 270 );
							Jass::CreateUnit( p, 'h014', 1184.f, -160.f, 270 );
						}			
					}
				);
			}
		);

		Jass::TimerStart
		(
			CreepSpawnerTimer1,
			30.f,
			true,
			function()
			{
				if ( !B_IsCreepSpawn ) { return; }

				player p = Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE );

				for ( int i = 0; i < 4; i++ )
				{
					if ( i < 2 )
					{
						Jass::CreateUnit( p, 'h011', -1888.f, -896.f, 270 );
						Jass::CreateUnit( p, 'h011', -384.f, -896.f, 270 );
						Jass::CreateUnit( p, 'h011', 1888.f, -896.f, 270 );
					}

					Jass::CreateUnit( p, 'h010', 384.f, -896.f, 270 );
					Jass::CreateUnit( p, 'h010', 1184.f, -896.f, 270 );
					Jass::CreateUnit( p, 'h010', -1184.f, -896.f, 270 );
					Jass::CreateUnit( p, 'h012', -1184.f, -160.f, 270 );
					Jass::CreateUnit( p, 'h012', 1888.f, -160.f, 270 );
					Jass::CreateUnit( p, 'h012', 384.f, -160.f, 270 );
					Jass::CreateUnit( p, 'h013', -1888.f, -160.f, 270 );
					Jass::CreateUnit( p, 'h013', -384.f, -160.f, 270 );
					Jass::CreateUnit( p, 'h013', 1184.f, -160.f, 270 );
				}
			}
		);
	}

	bool UnitCreationWithCircleCond( )
	{
		return Jass::IsUnitType( Jass::GetEnteringUnit( ), Jass::UNIT_TYPE_HERO );
	}

	int SpawnNPCAtLimited( int uid, int toCreate, float minX, float maxX, float minY, float maxY, int lim )
	{
		int count = 0;
		player p = Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE );

		for ( int i = 0; i < Jass::MathIntegerClamp( toCreate, 0, lim - CountUnitInGroupOfPlayer( p, uid ) ); i++ )
		{
			Jass::CreateUnit( p, uid, Jass::GetRandomReal( minX, maxX ), Jass::GetRandomReal( minY, maxY ), Jass::GetRandomReal( 0.f, 360.f ) );
			count++;
		}

		return count;
	}

	void PrintNPCSpawn( player p, int count = 0 )
	{
		Jass::DisplayTextToPlayer( p, .0f, .0f, count > 0 ? "|c00CBFF75NPC Spawned" : "|c00ff0000Maximum amount of units was reached!" );
	}

	void OnAnyUnitEnterRegion( unit u, region reg, rect rec )
	{
		player p = Jass::GetOwningPlayer( u );
		float x = Jass::GetUnitX( u );
		float y = Jass::GetUnitY( u );

		if ( reg == Jass::LoadRegionHandle( DataHT, 'regs', 'BASE' ) )
		{
			if ( Jass::IsUnitIllusion( u ) || ( !Jass::IsUnitType( u, Jass::UNIT_TYPE_HERO ) && p == Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE ) ) )
			{
				Jass::KillUnit( u );
			}

			return;
		}

		if ( rec == CircleRectArr[0] || rec == CircleRectArr[1] || rec == CircleRectArr[3] || rec == CircleRectArr[4] ) // spawner enter
		{
			if ( !Jass::IsUnitType( u, Jass::UNIT_TYPE_HERO ) ) { return; }

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
		int pid = Jass::GetPlayerId( p );
		int hid = Jass::GetHandleId( p );

		if ( !checkEsc || ESCLocationSaveBooleanArray[pid] )
		{
			Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffCurrent location was saved!" );
			Jass::SaveReal( DataHT, hid, '+tpX', Jass::GetUnitX( MUnitArray[pid] ) );
			Jass::SaveReal( DataHT, hid, '+tpY', Jass::GetUnitY( MUnitArray[pid] ) );
		}
	}

	void ESCToSaveAction( )
	{
		SaveUnitAxis( Jass::GetTriggerPlayer( ), true );
	}

	void HealthDisplayReaderAction( )
	{
		player p = Jass::GetTriggerPlayer( );
		int pid = Jass::GetPlayerId( p );
		unit u = Jass::GetTriggerUnit( );
		int hpMax = Jass::R2I( Jass::GetUnitMaxLife( u ) );

		if ( HealthDisplayBooleanArray[ pid ] && hpMax >= 10000 && Jass::GetOwningPlayer( u ) != Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE ) && Jass::GetUnitTypeId( u ) != 'n000' )
		{
			Jass::DisplayTextToPlayer( p, .0f, .0f, "|c0000ffff" + ( Jass::IsUnitType( u, Jass::UNIT_TYPE_HERO ) ? Jass::GetHeroProperName( u ) : Jass::GetUnitName( u ) ) + "|r has: |cFFFFCC00[" + Jass::I2S( hpMax ) + "]|r |c0000ffffHP|r" );
		}
	}

	void HeroProcessAbilityDisplay( unit u, bool forceHide )
	{
		int ulvl = Jass::GetUnitLevel( u );
		int hid = Jass::GetHandleId( u );

		string abils = Jass::GetUnitStringField( u, Jass::UNIT_SF_ABILITY_LIST );
		array<string>@ abilList = abils.split( "," );

		//print( "abils = " + abils + " " + "abilList.length( ) = " + Jass::I2S( abilList.length( ) ) + "\n" );

		for ( uint i = 0; i < abilList.length( ); i++ )
		{
			int aid = Jass::String2Id( abilList[i] );

			switch( aid )
			{
				case 'AInv': break;
				default:
				{
					bool isShow = true;
					//print( "aid: " + Id2String( aid ) + " -> reqLvL = " + Jass::I2S( Jass::GetAbilityBaseIntegerFieldById( aid, Jass::ABILITY_IF_REQUIRED_LEVEL ) ) + "\n" );

					if ( forceHide )
					{
						if ( Jass::GetAbilityBaseIntegerFieldById( aid, Jass::ABILITY_IF_REQUIRED_LEVEL ) > 1 )
						{
							Jass::ShowUnitAbility( u, aid, false );
						}
					}
					else
					{
						int reqLvL = Jass::GetAbilityBaseIntegerFieldById( aid, Jass::ABILITY_IF_REQUIRED_LEVEL ); if ( reqLvL == 0 ) { continue; }
						Jass::ShowUnitAbility( u, aid, ulvl >= reqLvL );
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
		unit u = Jass::GetLevelingUnit( );
		player p = Jass::GetOwningPlayer( u );
		int ulvl = Jass::GetUnitLevel( u );
		int uid = Jass::GetUnitTypeId( u );
		int hid = Jass::GetHandleId( u );
		int statCount = 0;

		Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\LevelUp.mdl", u, "origin" ) );

		HeroUnlockAbilities( u );

		if ( Jass::GetPlayerController( p ) != Jass::MAP_CONTROL_COMPUTER )
		{
			if ( Jass::GetUnitLevel( u ) >= 50 )
			{
				Jass::SetHeroStr( u, Jass::GetHeroStr( u, false ) + 3, true );
				Jass::SetHeroAgi( u, Jass::GetHeroAgi( u, false ) + 3, true );
				Jass::SetHeroInt( u, Jass::GetHeroInt( u, false ) + 3, true );
				Jass::SuspendHeroXP( u, true );
			}
		}
		else
		{
			if ( Jass::GetAIDifficulty( p ) == Jass::AI_DIFFICULTY_NEWBIE )
			{
				statCount = 2;
			}
			else if ( Jass::GetAIDifficulty( p ) == Jass::AI_DIFFICULTY_NORMAL )
			{
				statCount = 3;
			}
			else if ( Jass::GetAIDifficulty( p ) == Jass::AI_DIFFICULTY_INSANE )
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

			Jass::SetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD, Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD ) + 50 * statCount );
			Jass::SetHeroStr( u, Jass::GetHeroStr( u, false ) + statCount, true );
			Jass::SetHeroAgi( u, Jass::GetHeroAgi( u, false ) + statCount, true );
			Jass::SetHeroInt( u, Jass::GetHeroInt( u, false ) + statCount, true );
		
			switch( ulvl )
			{
				case 5: Jass::UnitAddItemById( u, 'I03U' ); break;
				case 8: Jass::UnitAddItemById( u, 'I03X' ); break;
				case 10: Jass::UnitAddItemById( u, 'I03Z' ); break;
				case 13: Jass::UnitAddItemById( u, 'I00H' ); break;
				case 15:
				{
					Jass::UnitAddItemById( u, Jass::LoadInteger( DataHT, Jass::GetUnitTypeId( u ), 'pitm' ) );

					break;
				}
				case 20: Jass::UnitAddItemById( u, 'I03V' ); break;
				case 21: Jass::UnitAddItemById( u, 'I03Z' ); break;
				case 25: Jass::UnitAddItemById( u, 'I00X' ); break;
				case 27: Jass::UnitAddItemById( u, 'I00T' ); break;
			}
		}
	}

	// MUI related functions
	int SpellTickEx( hashtable ht, int hid )
	{
		int tick = Jass::LoadInteger( ht, hid, 'tick' ); if ( Jass::LoadBoolean( ht, hid, 'skip' ) ) { return tick; }
		Jass::SaveInteger( ht, hid, 'tick', tick + 1 );
		return tick;
	}

	int SpellTickEx( int hid )
	{
		return SpellTickEx( GameHT, hid );
	}

	bool CounterEx( int hid, int id, int max )
	{
		int count = Jass::LoadInteger( GameHT, hid, 'icnt' + id );

		if ( !Jass::LoadBoolean( GameHT, hid, 'bcnt' + id ) )
		{
			Jass::SaveBoolean( GameHT, hid, 'bcnt' + id, true );
			return true;
		}

		if ( count + 1 >= max )
		{
			Jass::SaveInteger( GameHT, hid, 'icnt' + id, 0 );
			return true;
		}
		else
		{
			Jass::SaveInteger( GameHT, hid, 'icnt' + id, count + 1 );
		}

		return false;
	}

	void ReleaseTimer( timer tmr, bool extraClean = true )
	{
		int hid = Jass::GetHandleId( tmr );
		unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

		Jass::PauseTimer( tmr );

		if ( extraClean )
		{
			if ( Jass::IsUnitPaused( source ) )
			{
				Jass::PauseUnit( source, false );
				Jass::IssueImmediateOrder( source, "stop" );
			}
			Jass::SetUnitTimeScale( source, 1 );
			Jass::ShowUnit( source, true );
			Jass::SetUnitPathing( source, true );
			Jass::KillUnit( Jass::LoadUnitHandle( GameHT, hid, 106 ) );
			Jass::SetUnitInvulnerable( source, false );
			Jass::RemoveLocation( Jass::LoadLocationHandle( GameHT, hid, 102 ) );
			Jass::RemoveLocation( Jass::LoadLocationHandle( GameHT, hid, 103 ) );
			Jass::RemoveLocation( Jass::LoadLocationHandle( GameHT, hid, 107 ) );
			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
			Jass::SetUnitVertexColor( source, 255, 255, 255, 255 );
		}

		Jass::FlushChildHashtable( GameHT, hid );
		Jass::DestroyTimer( tmr );
	}

	void ClearAllData( int hid )
	{
		ReleaseTimer( Jass::GetExpiredTimer( ), true );
	}

	bool StopSpell( int hid, int mod, bool onlyCheck = false )
	{
		unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
		unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
		bool isClear = false;

		if ( mod == 0 )
		{
			isClear = Jass::GetUnitCurrentLife( source ) <= .0f;
		}
		else
		{
			isClear = Jass::GetUnitCurrentLife( source ) <= .0f || Jass::GetUnitCurrentLife( target ) <= .0f;
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			PlayHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'D1', 90.f, .0f );
			ReleaseTimer( tmr );
		}
	}

	void NanayaShiki_Q( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'Q1' );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, .3f );
			Jass::SetUnitAnimation( source, "spell slam one" );
			PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
		}
		else if ( ticks == 30 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );

			Jass::SetUnitAnimation( source, "spell throw six" );

			DisplaceWar3ImageLinear( source, angle, dist, .1f, .01f, false, true );

			effect ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", Jass::MathPointProjectionX( x, angle, dist * .5f ), Jass::MathPointProjectionY( y, angle, dist * .5f ), .0f, angle, 3.f, 1.f );
			SetEffectTimedLife( ef, 3.f );

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
			bool isEnhanced = Jass::GetUnitBuffLevel( source, 'B001' ) > 0;
			if ( isEnhanced )
			{
				dmg *= 1.5f;
			}

			GroupEnumUnitsInLine( GroupEnum, x, y, angle, dist, 400.f );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					float u_x = Jass::GetUnitX( u );
					float u_y = Jass::GetUnitY( u );

					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
					DisplaceWar3ImageLinear( u, Jass::MathAngleBetweenPoints( u_x, u_y, targX, targY ), 200.f, .5f, .01f, false, false );

					ACF_DamageTarget( source, u, dmg );
					if ( isEnhanced )
					{
						ACF_StunUnit( u, 1.f );
					}
				}
			}

			Jass::UnitRemoveAbility( source, 'B001' );

			ReleaseTimer( tmr );
		}
	}

	void NanayaShiki_W( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'W1' );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float dmg = 5.f * Jass::GetHeroLevel( source ) + .033f * Jass::GetHeroInt( source, true );

			PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
			ACF_StunUnit( source, .3f );
			Jass::SetUnitTimeScale( source, 2.f );
			Jass::SetUnitAnimation( source, "spell two" );
			Jass::SaveReal( GameHT, hid, '+dmg', Jass::GetUnitBuffLevel( source, 'B001' ) == 0 ? dmg : 1.5f * dmg );
		}
		else
		{
			int slashes = Jass::LoadInteger( GameHT, hid, 'slsh' );

			if ( slashes < 30 )
			{
				if ( CounterEx( hid, 0, 2 ) )
				{
					player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
					unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
					float x = Jass::GetUnitX( source );
					float y = Jass::GetUnitY( source );
					float angle = Jass::GetUnitFacing( source );
					float dmg = Jass::LoadReal( GameHT, hid, '+dmg' );
					bool isEffect = CounterEx( hid, 1, 10 );

					effect ef = CreateEffectEx( "Characters\\NanayaShiki\\WEffect.mdl", Jass::MathPointProjectionX( x, angle, 150.f ), Jass::MathPointProjectionY( y, angle, 150.f ), .0f, angle, 1.5f, 1.f );
					Jass::SetSpecialEffectAnimation( ef, "stand" );
					Jass::SetSpecialEffectColour( ef, 0xFFFF00FF );
					SetEffectTimedLife( ef, 1.f );

					Jass::GroupEnumUnitsInRange( GroupEnum, Jass::GetSpecialEffectX( ef ), Jass::GetSpecialEffectY( ef ), 350.f, nil );

					for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
					{
						if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
						{
							if ( isEffect )
							{
								Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
								Jass::IssueImmediateOrder( u, "stop" );
							}

							if ( slashes == 29 )
							{
								Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", u, "chest" ) );
							}

							ACF_DamageTarget( source, u, dmg );
						}
					}

					Jass::SaveInteger( GameHT, hid, 'slsh', slashes + 1 );
				}
			}
			else
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

				Jass::UnitRemoveAbility( source, 'B001' );
				Jass::SetUnitAnimation( source, "stand" );
				ReleaseTimer( tmr );
			}
		}
	}

	void NanayaShiki_E( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			Jass::SaveBoolean( GameHT, hid, 'isex', Jass::GetUnitBuffLevel( source, 'B001' ) > 0 );
			//ACF_DisableUnitTP( target, Jass::GetUnitAbilityLevel( source, 'B001' ) > 0 ? 1.5f : .5f );
		}

		if ( !Jass::LoadBoolean( GameHT, hid, 'isex' ) )
		{
			if ( StopSpell( hid, 1, true ) )
			{
				if ( StopSpell( hid, 0, true ) )
				{
					StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'R2' );
				}
				
				ReleaseTimer( tmr );
				return;
			}

			if ( ticks == 0 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float angle = GetUnitAngle( source, target );
				float dist = GetUnitDistance( source, target ) + 200.f;

				PlayHeroSound( source, 'psnd' + 'R2', 90.f, .0f );

				ACF_StunUnit( source, .55f );
				Jass::SetUnitAnimation( source, "spell slam one" );
			}
			else if ( ticks == 50 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );
				float angle = GetUnitAngle( source, target );
				float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

				SetUnitXY( source, Jass::MathPointProjectionX( targX, angle, 100.f ), Jass::MathPointProjectionY( targY, angle, 100.f ) );
				Jass::SetUnitAnimation( source, "spell throw six" );
				ACF_DamageTarget( source, target, dmg );
				ACF_StunUnit( target, 2.f );

				effect ef;

				ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, angle + 45.f, 2.f, 1.f );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, angle - 45.f, 2.f, 1.f );
				SetEffectTimedLife( ef, 4.f );

				Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
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
						StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'R2' );
					}
					
					ReleaseTimer( tmr );
					return;
				}
			}

			if ( ticks == 0 )
			{
				ACF_StunUnit( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 1.5f );
			}
			else if ( ticks == 25 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float angle = GetUnitAngle( source, target );
				float dist = GetUnitDistance( source, target ) - 150.f;

				PlayHeroSound( source, 'psnd' + 'R2', 90.f, .0f );
				Jass::SetUnitAnimation( source, "spell two alternate" );
				DisplaceWar3ImageLinear( source, angle, dist, .25f, .01f, false, true );
			}
			else if ( ticks == 50 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float angle = GetUnitAngle( source, target );
				float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

				PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );
				Jass::SetUnitAnimation( source, "spell slam one" );

				ACF_DamageTarget( source, target, dmg );
				SetUnitFlyHeightEx( target, 800.f, 4000.f );
				DisplaceWar3ImageLinear( target, angle, 300.f, .4f, .01f, false, false, "" );
			}
			else if ( ticks == 75 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float angle = GetUnitAngle( source, target );
				float dist = GetUnitDistance( source, target ) - 150.f;

				PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
				Jass::SetUnitFacing( source, angle );
				Jass::SetUnitAnimation( source, "spell throw three" );
				SetUnitFlyHeightEx( source, 600.f, 4000.f );
				SetUnitXY( source, Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, dist ), Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, dist ) );
			}
			else if ( ticks == 125 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float angle = GetUnitAngle( source, target );
				float dmg = 250.f + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );
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
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );

				Jass::SetUnitAnimation( source, "spell throw two" );
				Jass::UnitRemoveAbility( source, 'B001' );

				effect ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 3.f, 1.f );
				SetEffectTimedLife( ef, 1.f );

				for ( int i = 0; i < 5; i++ )
				{
					float move = 25.f + 25.f * i;

					ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 2.f, Jass::GetRandomReal( .5f, 2.f ) );
					SetEffectTimedLife( ef, 4.f );
				}

				float dmg = 250.f + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

				Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 500.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( StopSpell( hid, 0, true ) || ticks == 305 )
		{

			ReleaseTimer( tmr );
			return;
		}

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target ) - 200.f;

			PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
			Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, 'A02P' ), .01f );
			ACF_StunUnit( source, 3.f );
			Jass::SetUnitTimeScale( source, 2.f );
			Jass::SetUnitFacing( source, angle );
			Jass::SetUnitAnimation( source, "spell channel one" );
			DisplaceWar3ImageLinear( source, angle, dist, .25f, .01f, false, true );
		}
		else if ( ticks == 25 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = 600.f;

			Jass::SetUnitAnimation( source, "spell throw four" );
			EffectAPI::InverseDash( target );

			DisplaceWar3ImageLinear( source, angle, -dist * .5f, 1.f, .01f, false, false );
			DisplaceWar3ImageLinear( target, angle, dist, 1.f, .01f, false, false );
		}
		else if ( ticks == 125 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			effect ef;

			PlayHeroSound( source, 'psnd' + 'T2', 100.f, .0f );
			Jass::SetUnitAnimation( source, "spell throw five" );

			for ( int i = 0; i < 5; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( .0f, 360.f ), 1.f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
				Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0x80, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 50.f, angle, 1.5f, 2.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.f, 2.f );
			SetEffectTimedLife( ef, 3.f );

			Jass::SetUnitFacing( source, angle );
			DisplaceUnitWithArgs( source, angle, dist, 1.f, .015f, 400.f );
			string mdl = Jass::GetUnitModel( source );

			for ( int i = 0; i < 15; i++ )
			{
				ef = CreateEffectEx( mdl, x, y, .0f, angle, 1.f, 1.f );
				SetEffectTimedLife( ef, 1.f );
				Jass::SetSpecialEffectAnimation( ef, "spell throw five" );
				Jass::SetSpecialEffectAlpha( ef, 0xFF - 25 * i );
				DisplaceWar3ImageWithArgs( ef, angle, dist, 1.f + .1f * i, .02f, 400.f );
			}
		}
		else if ( ticks == 225 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::GetUnitFacing( source );
			float dmg = 4000.f + 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
			effect ef;

			PlayHeroSound( source, 'gsnd' + 2, 80.f, .0f );
			PlayHeroSound( source, 'psnd' + 'D1', 100.f, .0f );

			ACF_StunUnit( target, 1.f );
			ACF_DamageTarget( source, target, dmg );

			Jass::SetUnitFacing( source, angle );
			Jass::SetUnitAnimation( source, "spell throw six" );
			DisplaceWar3ImageLinear( source, angle, 250.f, .8f, .01f, false, false );
			EffectAPI::Dash( source );

			for ( int i = 0; i < 4; i++ )
			{
				ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, ( angle + Jass::Pow( -1.f, i ) ) * 30.f, 3.f, .5f );
				SetEffectTimedLife( ef, 4.f );
			}

			for ( int i = 0; i < 5; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
				SetEffectTimedLife( ef, 4.f );
			}
		}
	}

	void NanayaShiki_T( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, 2.f );
			Jass::SetUnitAnimation( source, "stand" );
			Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, 'A02P' ), .01f );
		}
		else if ( ticks == 50 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'T3', 100.f, .0f );
			Jass::SetUnitTimeScale( source, .25f );
			Jass::SetUnitAnimation( source, "spell one alternate" );
		}
		else if ( ticks == 90 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );

			Jass::SetUnitTimeScale( source, 1.f );
			Jass::SetUnitAnimation( source, "attack" );

			effect ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect.mdl", Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, 50.f ), Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, 50.f ), 100.f, angle, 1.f, 1.f );
			Jass::SaveEffectHandle( GameHT, hid, '+eff', ef );

			Jass::SaveBoolean( GameHT, hid, 'skip', true );
			Jass::SaveInteger( GameHT, hid, 'tick', ticks + 5 );
		}
		else if ( ticks == 95 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

			if ( DisplaceWar3ImageToTarget( Jass::LoadEffectHandle( GameHT, hid, '+eff' ), target, 20.f, 75.f ) )
			{
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );
				float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
				float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
				string mdl = Jass::GetUnitModel( source );

				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralSounds\\BlackBlink.mdx", x, y ) );
				Jass::SetUnitTimeScale( source, 1.f );
				SetUnitFlyHeightEx( source, 200.f, 99999.f );
				Jass::SetUnitAnimation( source, "spell channel three" );
				SetUnitXY( source, targX, targY );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralSounds\\BlackBlink.mdx", targX, targY ) );

				effect ef = CreateEffectEx( mdl, Jass::MathPointProjectionX( targX, angle, 150.f ), Jass::MathPointProjectionY( targY, angle, 150.f ), .0f, -angle, 1.f, 1.f );
				Jass::SetSpecialEffectAlpha( ef, 0xB0 );
				SetEffectTimedLife( ef, .8f );
				Jass::SetSpecialEffectAnimation( ef, "spell slam three" );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralSounds\\BlackBlink.mdx", Jass::GetSpecialEffectX( ef ), Jass::GetSpecialEffectY( ef ) ) );

				Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
				Jass::SaveBoolean( GameHT, hid, 'skip', false );
				Jass::SaveInteger( GameHT, hid, 'tick', ticks + 5 );
				return;
			}
		}
		else if ( ticks == 130 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			effect ef;

			Jass::SetUnitAnimation( source, "spell throw six" );
			SetUnitFlyHeightEx( source, 0, 99999.f );
			DisplaceWar3ImageLinear( source, angle, -300.f, .4f, .01f, false, false );

			for ( int i = 0; i < 3; i++ )
			{
				ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 4.f, 1.f );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, angle + 45.f - 45.f * i, 1.f, 1.f );
				SetEffectTimedLife( ef, 4.f );
			}

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralSounds\\26.mdx", targX, targY ) );
		}
		else if ( ticks == 170 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float dmg = 6000.f + 400.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			ACF_StunUnit( target, 2.f );
			ACF_DamageTarget( source, target, dmg );
			Jass::SetUnitTimeScale( source, 1.f );
			ReleaseTimer( tmr );
		}
	}
	//

	// Toono Shiki Spells
	void ToonoShiki_D( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			PlayHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'D1', 100.f, .0f );
			ReleaseTimer( tmr );
		}
	}

	void ToonoShiki_Q( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'Q1' );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, .3f );
			Jass::SetUnitAnimation( source, "spell three" );
			PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
		}
		else if ( ticks == 30 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );

			Jass::SetUnitAnimation( source, "spell four" );

			DisplaceWar3ImageLinear( source, angle, dist, .1f, .01f, false, true );

			effect ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", Jass::MathPointProjectionX( x, angle, dist * .5f ), Jass::MathPointProjectionY( y, angle, dist * .5f ), .0f, angle, 3.f, 1.f );
			SetEffectTimedLife( ef, 3.f );

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
			GroupEnumUnitsInLine( GroupEnum, x, y, angle, dist, 400.f );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					float u_x = Jass::GetUnitX( u );
					float u_y = Jass::GetUnitY( u );

					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
					DisplaceWar3ImageLinear( u, Jass::MathAngleBetweenPoints( u_x, u_y, targX, targY ), 200.f, .5f, .01f, false, false );

					ACF_DamageTarget( source, u, dmg );
				}
			}

			ReleaseTimer( tmr );
		}
	}

	void ToonoShiki_W( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'W1' );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float dmg = 5.f * Jass::GetHeroLevel( source ) + .033f * Jass::GetHeroInt( source, true );

			PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
			ACF_StunUnit( source, .3f );
			Jass::SetUnitTimeScale( source, 2.f );
			Jass::SetUnitAnimation( source, "spell two" );
		}
		else
		{
			int slashes = Jass::LoadInteger( GameHT, hid, 'slsh' );

			if ( slashes < 30 )
			{
				if ( CounterEx( hid, 0, 2 ) )
				{
					player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
					unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
					float x = Jass::GetUnitX( source );
					float y = Jass::GetUnitY( source );
					float angle = Jass::GetUnitFacing( source );
					float dmg = Jass::LoadReal( GameHT, hid, '+dmg' );
					bool isEffect = CounterEx( hid, 1, 10 );

					effect ef = CreateEffectEx( "Characters\\NanayaShiki\\WEffect.mdl", Jass::MathPointProjectionX( x, angle, 150.f ), Jass::MathPointProjectionY( y, angle, 150.f ), .0f, angle, 1.5f, 1.f );
					Jass::SetSpecialEffectAnimation( ef, "stand" );
					Jass::SetSpecialEffectColour( ef, 0xFF4040FF ); // 0xFFC0C0FF
					SetEffectTimedLife( ef, 1.f );

					Jass::GroupEnumUnitsInRange( GroupEnum, Jass::GetSpecialEffectX( ef ), Jass::GetSpecialEffectY( ef ), 350.f, nil );

					for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
					{
						if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
						{
							if ( isEffect )
							{
								Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
								Jass::IssueImmediateOrder( u, "stop" );
							}

							if ( slashes == 29 )
							{
								Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", u, "chest" ) );
							}

							ACF_DamageTarget( source, u, dmg );
						}
					}

					Jass::SaveInteger( GameHT, hid, 'slsh', slashes + 1 );
				}
			}
			else
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

				Jass::SetUnitAnimation( source, "stand" );
				ReleaseTimer( tmr );
			}
		}
	}

	void ToonoShiki_E( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			StopHeroSound( source, 'psnd' + 'E2' );
			StopHeroSound( source, 'psnd' + 'E3' );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );
		
		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			
			PlayHeroSound( source, 'psnd' + 'E3', 100.f, .0f );
			ACF_StunUnit( source, .9f );
			Jass::SetUnitTimeScale( source, 2.5f );
			Jass::SetUnitAnimation( source, "spell channel three" );
			EffectAPI::Dash( source );
			DisplaceWar3ImageLinear( source, angle, dist + 100.f, .2f, .01f, false, false );
		}
		else if ( ticks == 20 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'E2', 100.f, .0f );
			Jass::SetUnitAnimation( source, "spell five" );
		}
		else if ( ticks == 70 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 500.f + 75.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			PlayHeroSound( source, 'gsnd' + 2, 60.f, .0f );
			Jass::SetUnitTimeScale( source, 1 );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		int ticks = SpellTickEx( hid );

		if ( StopSpell( hid, 1, true ) && ticks < 160 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
			ACF_StunUnit( source, 2.f );
			Jass::SetUnitTimeScale( source, 2.f );
			Jass::SetUnitAnimation( source, "spell channel five" );
			EffectAPI::Dash( source );
			DisplaceWar3ImageLinear( source, angle, dist - 150.f, .1f, .01f, false, false );
		}
		else if ( ticks == 20 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 325.f + 32.5f * Jass::GetHeroLevel( source ) + .2f * Jass::GetHeroInt( source, true );

			PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );

			EffectAPI::PushWind( source, target );
			DisplaceWar3ImageLinear( target, angle, 150.f, .2f, .01f, false, false );
			ACF_DamageTarget( source, target, dmg );
			ACF_StunUnit( target, 1.f );
		}
		else if ( ticks == 40 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			Jass::SetUnitAnimation( source, "spell channel three" );
			DisplaceWar3ImageLinear( source, angle, dist - 150.f, .1f, .01f, false, false );
		}
		else if ( ticks == 60 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'R2', 100.f, .0f );
			Jass::SetUnitAnimation( source, "spell channel one" );
		}
		else if ( ticks == 110 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 750.f + 60.f * Jass::GetHeroLevel( source ) + .25f * Jass::GetHeroInt( source, true );

			Jass::SetUnitTimeScale( source, 3 );
			EffectAPI::PushWind( source, target, 50.f, -45.f );
			ACF_DamageTarget( source, target, dmg );
			SetUnitFlyHeightEx( source, 800.f, 2000.f );
			SetUnitFlyHeightEx( target, 800.f, 2000.f );
			DisplaceWar3ImageLinear( source, angle, 200.f, .4f, .01f, false, false );
			DisplaceWar3ImageLinear( target, angle, 200.f, .4f, .01f, false, false );
		}
		else if ( ticks == 160 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 750.f + 60.f * Jass::GetHeroLevel( source ) + .25f * Jass::GetHeroInt( source, true );

			PlayHeroSound( source, 'psnd' + 'R3', 100.f, .0f );
			Jass::SetUnitAnimation( source, "spell channel four" );
			EffectAPI::PushWind( source, target, 700.f, 45.f );

			SetUnitFlyHeightEx( source, 0.f, 3000.f );
			SetUnitFlyHeightEx( target, 0.f, 3000.f );
			DisplaceWar3ImageLinear( source, angle, 200.f, .25f, .01f, false, false );
			DisplaceWar3ImageLinear( target, angle, 200.f, .25f, .01f, false, false );
			ACF_DamageTarget( source, target, dmg );
		}
		else if ( ticks == 200 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
			effect ef;

			for ( int i = 0; i < 4; i++ )
			{
				ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, ( angle + Jass::Pow( -1.f, i ) ) * 30.f, 3.f, .5f );
				SetEffectTimedLife( ef, 4.f );
			}

			for ( int i = 0; i < 5; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
				SetEffectTimedLife( ef, 4.f );
			}

			float dmg = 500.f + 40.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 600.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			ACF_StunUnit( source, 1.3f );
			Jass::SetUnitAnimation( source, "spell one" );
			Jass::SetUnitFacing( source, angle );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
				Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}
		}
		else if ( ticks == 90 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 3000.f + 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
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
					ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
					Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
					SetEffectTimedLife( ef, 4.f );
				}

				float face = Jass::GetRandomReal( 0.f, 360.f );

				ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, face, 2.f, .5f );
				DisplaceWar3ImageWithArgs( ef, face, Jass::GetRandomReal( 200.f, 800.f ), .1f, .01f, .0f );
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			PlayHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'D1', 100.f, .0f );
			ReleaseTimer( tmr );
		}
	}

	void RyougiShiki_Q( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );

			ACF_StunUnit( source, .2f );
			Jass::SetUnitTimeScale( source, 1.5f );
			Jass::SetUnitAnimation( source, "spell channel four" );
		}
		else if ( ticks == 20 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::GetUnitFacing( source );
			float targX = Jass::MathPointProjectionX( x, angle, 200.f );
			float targY = Jass::MathPointProjectionY( y, angle, 200.f );

			PlayHeroSound( source, 'gsnd' + 0, 50.f, .0f );
			Jass::SetUnitTimeScale( source, 1.f );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiWEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
				SetEffectTimedLife( ef, 4.f );
			}

			float dmg = 240.f + 80.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 300.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					ACF_StunUnit( u, 1.f );

					DisplaceUnitWithArgs( u, angle, 300.f, .5f, .01f, 150.f );
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
				}
			}

			ReleaseTimer( tmr );
		}
	}

	void RyougiShiki_W( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );

			PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
			ACF_StunUnit( source, .4f );
			Jass::SetUnitAnimation( source, "Spell Channel Slam" );
			Jass::SetUnitTimeScale( source, 2.f );
			EffectAPI::Dash( source );

			DisplaceWar3ImageLinear( source, Jass::GetUnitFacing( source ), dist, .4f, .01f, false, true );
		}
		else if ( ticks == 40 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::GetUnitFacing( source );
			float targX = Jass::MathPointProjectionX( x, angle, 200.f );
			float targY = Jass::MathPointProjectionY( y, angle, 200.f );

			PlayHeroSound( source, 'gsnd' + 0, 50.f, .0f );
			Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, 'A033' ), .01f );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiWEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
				//Jass::SetSpecialEffectColour( ef, 0xFFFF7000 );
				SetEffectTimedLife( ef, 3.f );
			}

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					ACF_StunUnit( u, 1.f );
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
					DisplaceWar3ImageLinear( u, angle, 150.f, .2f, .01f, false, false );
				}
			}

			ReleaseTimer( tmr );
		}
	}

	void RyougiShiki_E( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );

			PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
			ACF_StunUnit( source, .5f );
			Jass::SetUnitTimeScale( source, 1.75f );
			Jass::SetUnitAnimation( source, "spell channel two" );
			DisplaceWar3ImageLinear( source, angle, dist, .4f, .01f, false, true );

			Jass::SaveReal( GameHT, hid, 'srcX', x );
			Jass::SaveReal( GameHT, hid, 'srcY', y );
			Jass::SaveReal( GameHT, hid, 'trgX', Jass::MathPointProjectionX( x, angle, dist * .5f ) );
			Jass::SaveReal( GameHT, hid, 'trgY', Jass::MathPointProjectionY( y, angle, dist * .5f ) );
		}
		else if ( ticks == 50 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float origX = Jass::LoadReal( GameHT, hid, 'srcX' );
			float origY = Jass::LoadReal( GameHT, hid, 'srcX' );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );

			PlayHeroSound( source, 'gsnd' + 0, 50.f, .0f );

			effect ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle, 3.f, .5f );
			SetEffectTimedLife( ef, 3.f );

			float dmg = 75.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			GroupEnumUnitsInLine( GroupEnum, origX, origY, angle, dist, 600.f );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
				}
			}

			ReleaseTimer( tmr );
		}
	}

	void RyougiShiki_R( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, 1.35f );
			Jass::SetUnitAnimation( source, "spell one" );
			PlayHeroSound( source, 'psnd' + 'T1', 80.f, .0f );
		}
		else if ( ticks == 25 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

			Jass::SetUnitAnimation( source, "spell channel five" );
			ACF_DamageTarget( source, target, dmg );
			SetUnitXY( source, Jass::MathPointProjectionX( targX, angle, 100.f ), Jass::MathPointProjectionY( targY, angle, 100.f ) );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiQEffect.mdl", targX, targY, .0f, angle, 2.f, 1.f );
				//Jass::SetSpecialEffectColour( ef, 0xFFFF7000 );
				SetEffectTimedLife( ef, 3.f );
			}
		}
		else if ( ticks == 75 )
		{
			Jass::SetUnitAnimation( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), "spell slam one" );
		}
		else if ( ticks == 135 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

			PlayHeroSound( source, 'gsnd' + 0, 50.f, .0f );
			ACF_DamageTarget( source, target, dmg );
			ACF_StunUnit( target, 1.f );

			for ( int i = 0; i < 3; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 4.f, 1.f );
				SetEffectTimedLife( ef, 4.f );
			}

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
			ReleaseTimer( tmr );
		}
	}

	void RyougiShiki_T( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, 1.25f );
			Jass::SetUnitAnimation( source, "spell channel three" );
			PlayHeroSound( source, 'psnd' + 'D1', 100.f, .0f );
			Jass::SaveBoolean( GameHT, hid, 'skip', true );
			Jass::SaveInteger( GameHT, hid, 'tick', ticks + 1 );
		}
		else if ( ticks == 1 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

			if ( DisplaceWar3ImageToTarget( source, target, 40.f, 600.f ) )
			{
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );
				float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
				float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
				float dmg = 1500.f + 150.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

				PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
				Jass::SetUnitAnimation( source, "spell channel four" );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );

				for ( int i = 0; i < 3; i++ )
				{
					effect ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle, 1.f, 1.f );
					SetEffectTimedLife( ef, 4.f );

					ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
					Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
					SetEffectTimedLife( ef, 4.f );
				}

				DisplaceWar3ImageLinear( source, angle, dist + 250.f, .2f, .01f, false, false );
				
				ACF_DamageTarget( source, target, dmg );
				ACF_StunUnit( target, .5f );
				Jass::SaveInteger( GameHT, hid, 'tick', 5 );
				return;
			}
		}
		else if ( ticks == 5 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			int slashes = Jass::LoadInteger( GameHT, hid, 'slsh' );

			if ( slashes < 30 )
			{
				PlayHeroSound( source, 'psnd' + 'R2', 100.f, .0f );

				for ( int i = 0; i < 3; i++ )
				{
					effect ef = CreateEffectEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, slashes * 12.f, 1.f, 1.f );
					SetEffectTimedLife( ef, 4.f );
				}

				Jass::SaveInteger( GameHT, hid, 'slsh', slashes + 1 );
			}
			else
			{
				float angle = GetUnitAngle( source, target );
				float dist = GetUnitDistance( source, target );

				Jass::SetUnitAnimation( source, "spell" );
				DisplaceUnitWithArgs( source, angle, dist + 600.f, 1.1f, .01f, 250.f );
				Jass::SaveInteger( GameHT, hid, 'tick', 10 );
				Jass::SaveBoolean( GameHT, hid, 'skip', false );
				return;
			}
		}
		else if ( ticks == 70 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			effect ef;
			float dmg = 1500.f + 150.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

			PlayHeroSound( source, 'gsnd' + 0, 70.f, .0f );

			ACF_StunUnit( target, 1.f );
			ACF_DamageTarget( source, target, dmg );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );

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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			StopHeroSound( source, 'psnd' + 'D1' );
			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'D1', 100.f, .0f );
			ACF_StunUnit( source, .2f );
			Jass::SetUnitAnimation( source, "Morph" );
		}
		else if ( ticks == 20 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\SaberAlter\\DarkLightningNova.mdl", x, y, 50.f, .0f, .2f * i, .6f + .1f * i );
				SetEffectTimedLife( ef, 4.f );
			}

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
			
			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 300.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
			ACF_StunUnit( source, .3f );
			Jass::SetUnitTimeScale( source, 1.5f );
			Jass::SetUnitAnimation( source, "spell Slam" );
		}
		else if ( ticks == 10 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );
			float targX = Jass::MathPointProjectionX( x, angle, dist * .5f );
			float targY = Jass::MathPointProjectionY( y, angle, dist * .5f );
		
			DisplaceWar3ImageLinear( source, angle, dist, .1f, .01f, false, true );

			PlayHeroSound( source, 'psnd' + 'Q2', 100.f, .0f );

			effect ef = CreateEffectEx( "Characters\\SaberAlter\\SaberAlterClaw.mdl", targX, targY, .0f, angle, 3.f, .5f );
			Jass::SetSpecialEffectColour( ef, 0xFF800080 );
			SetEffectTimedLife( ef, 3.f );

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			GroupEnumUnitsInLine( GroupEnum, x, y, angle, dist, 400.f );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
					DisplaceWar3ImageLinear( u, angle, 200.f, .5f, .01f, false, false );
				}
			}

			ReleaseTimer( tmr );
		}
	}

	void SaberAlter_W( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );

			Jass::SetUnitAnimation( source, "spell Two" );
			EffectAPI::Jump( source );

			DisplaceUnitWithArgs( source, Jass::LoadReal( GameHT, hid, 'angl' ), dist, .4f, .01f, 200.f + dist / 5.f );
		}
		else if ( ticks == 40 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			effect ef;

			PlayHeroSound( source, 'psnd' + 'W2', 100.f, .0f );
			PlayHeroSound( source, 'psnd' + 'W3', 100.f, .0f );

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );

			ef = CreateEffectEx( "Characters\\SaberAlter\\DarkExplosion.mdl", x, y, .0f, 270.f, .5f, 1.f );

			for ( int i = 0; i < 4; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
				Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}

			float dmg = 150.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 300.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			Jass::DestroyGroup( Jass::LoadGroupHandle( GameHT, hid, '+grp' ) );
			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
			ACF_StunUnit( source, .6f );
			Jass::SaveGroupHandle( GameHT, hid, '+grp', Jass::CreateGroup( ) );
			Jass::SetUnitAnimation( source, "spell Five" );
		}
		else if ( ticks == 60 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'E2', 100.f, .5f );
			Jass::SaveReal( GameHT, hid, 'srcX', Jass::GetUnitX( source ) );
			Jass::SaveReal( GameHT, hid, 'srcY', Jass::GetUnitY( source ) );
		}
		else if ( ticks > 60 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float move = Jass::LoadReal( GameHT, hid, 'move' ) + 150.f;
			int id = Jass::R2I( move / 150.f );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float x = Jass::MathPointProjectionX( Jass::LoadReal( GameHT, hid, 'srcX' ), angle, move );
			float y = Jass::MathPointProjectionY( Jass::LoadReal( GameHT, hid, 'srcY' ), angle, move );
			group g = Jass::LoadGroupHandle( GameHT, hid, '+grp' );

			effect ef = CreateEffectEx( "Characters\\SaberAlter\\ShadowBurstBigger.mdx", x, y, .0f, .0f, .2f + .05f * id, 1.f );
			SetEffectTimedLife( ef, 1.f + .025f * id );

			float dmg = 75.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 300.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) && !Jass::IsUnitInGroup( u, g ) )
				{
					ACF_DamageTarget( source, u, dmg );
					ACF_StunUnit( u, 1.f );
					DisplaceUnitWithArgs( u, .0f, .0f, .5f, .01f, 400.f );

					Jass::GroupAddUnit( g, u );
				}
			}

			if ( move >= 1500.f )
			{
				Jass::DestroyGroup( g );
				ReleaseTimer( tmr );
				return;
			}

			Jass::SaveReal( GameHT, hid, 'move', move );
		}
	}

	void SaberAlter_R( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, 1.5f );
			PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
			PlayHeroSound( source, 'psnd' + 'R2', 100.f, .5f );
		}
		else if ( ticks >= 10 )
		{
			int slashes = Jass::LoadInteger( GameHT, hid, 'slsh' );

			if ( CounterEx( hid, 0, 40 ) )
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				float angle = Jass::GetUnitFacing( source );
				float efX = Jass::MathPointProjectionX( x, angle, 50.f );
				float efY = Jass::MathPointProjectionY( y, angle, 50.f );

				PlayHeroSound( source, 'psnd' + 'R2', 100.f, .5f );
				Jass::SetUnitAnimation( source, slashes == 0 || slashes == 2 ? "spell Three" : "spell Six" );

				for ( int i = 0; i < 5; i++ )
				{
					effect ef = CreateEffectEx( "Characters\\SaberAlter\\SaberAlterSlash.mdl", efX, efY, .0f, angle, 1.f, 1.f );
					SetEffectTimedLife( ef, 3.f );
				}

				DisplaceWar3ImageLinear( source, angle, 100.f, .4f, .01f, false, false );

				float dmg = 30.f * Jass::GetHeroLevel( source ) + .25f * Jass::GetHeroInt( source, true );

				Jass::GroupEnumUnitsInRange( GroupEnum, efX, efY, 300.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
					{
						ACF_DamageTarget( source, u, dmg );
						DisplaceUnitWithArgs( u, angle, slashes < 3 ? 100.f : 300.f, .35f, .01f, 300.f );
						Jass::DestroyEffect( Jass::AddSpecialEffectTarget( slashes < 3 ? "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl" : "GeneralEffects\\BloodEffect1.mdx", u, "chest" ) );
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
					Jass::SaveInteger( GameHT, hid, 'slsh', slashes );
				}
			}
		}
	}

	void SaberAlter_T( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			Jass::DestroyGroup( Jass::LoadGroupHandle( GameHT, hid, '+grp' ) );
			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );

			PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
			ACF_StunUnit( source, 1.f );
			Jass::SetUnitAnimation( source, "spell Channel One" );
			Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Characters\\SaberAlter\\ShadowBurst.mdx", source, "weapon" ) );

			EffectAPI::Jump( source );

			for ( int i = 0; i < 2; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\SaberAlter\\DarkExplosion.mdl", x, y, .0f, .0f, Jass::GetRandomReal( .95f, 1.25f ), Jass::GetRandomReal( .45f, .7f ) );
				SetEffectTimedLife( ef, 2.f );
			}

			Jass::SaveGroupHandle( GameHT, hid, '+grp', Jass::CreateGroup( ) );
		}
		else if ( ticks == 100 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );

			Jass::SetUnitAnimation( source, "spell Channel Two" );
			PlayHeroSound( source, 'psnd' + 'T2', 100.f, .0f );

			effect ef = CreateEffectEx( "Characters\\SaberAlter\\DarkWave.mdl", x, y, 50.f, angle, 1.f, 1.f );
			Jass::SetSpecialEffectColour( ef, 0xFFA0FF70 );
			SetEffectTimedLife( ef, 3.f );

			Jass::SaveReal( GameHT, hid, 'srcX', x );
			Jass::SaveReal( GameHT, hid, 'srcY', y );
		}
		else if ( ticks >= 100 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			group g = Jass::LoadGroupHandle( GameHT, hid, '+grp' );
			float x = Jass::LoadReal( GameHT, hid, 'srcX' );
			float y = Jass::LoadReal( GameHT, hid, 'srcY' );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float moved = Jass::LoadReal( GameHT, hid, 'move' );
			bool isEff = ( moved % 400.f ) == 0.f; moved += 100.f;

			float efX = Jass::MathPointProjectionX( x, angle, moved );
			float efY = Jass::MathPointProjectionY( y, angle, moved );

			if ( isEff )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", efX, efY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 3.f, 1.f );
				SetEffectTimedLife( ef, 1.f );
			}

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", efX, efY ) );

			float dmg = 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, efX, efY, 500.f, nil );
		
			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) && !Jass::IsUnitInGroup( u, g ) )
				{
					ACF_DamageTarget( source, u, dmg );

					Jass::GroupAddUnit( g, u );
				}
			}

			if ( moved >= 3000 )
			{
				Jass::DestroyGroup( g );
				ReleaseTimer( tmr );
				return;
			}

			Jass::SaveReal( GameHT, hid, 'move', moved );
		}
	}
	//

	// Saber Nero Spells
	void SaberNero_Q( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );

			PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
			EffectAPI::Dash( source );
			ACF_StunUnit( source, .5f );
			Jass::SetUnitTimeScale( source, 1.5f );
			Jass::SetUnitAnimation( source, "spell two" );
			DisplaceWar3ImageLinear( source, angle, dist, .5f, .01f, false, true );
		}
		else if ( ticks == 50 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float angle = Jass::GetUnitFacing( source );
			float x = Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, 200.f );
			float y = Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, 200.f );

			for ( int i = 0; i < 2; i++ )
			{
				effect ef = CreateEffectEx( "Characters\\SaberNero\\SaberNeroFireCutEffect.mdl", x, y, .0f, angle, 2.5f, 1.f );
				SetEffectTimedLife( ef, 1.f );
			}

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 400.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
					DisplaceWar3ImageLinear( u, GetUnitAngle( source, u ), 200.f, .3f, .01f, false, false );
				}
			}

			ReleaseTimer( tmr );
		}
	}

	void SaberNero_W( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
			ACF_StunUnit( source, .4f );
			Jass::SetUnitAnimation( source, "attack slam" );
		}
		else if ( ticks == 40 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			effect ef;

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );

			ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, .0f, 270.f, 4.f, 1.f );

			for ( int i = 0; i < 8; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
				Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}

			float dmg = 250 + Jass::GetHeroLevel( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ) ) * 50 + Jass::GetHeroInt( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 450.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
			
			ACF_StunUnit( source, 1.7f );
			Jass::SetUnitTimeScale( source, 1.5f );
			Jass::SetUnitAnimation( source, "Spell Three" );
			DisplaceWar3ImageLinear( source, angle, dist - 150.f, .1f, .015f, false, true );
		}
		else if ( ticks == 10 )
		{
			ACF_StunUnit( Jass::LoadUnitHandle( GameHT, hid, 'utrg' ), .35f );
		}
		else if ( ticks >= 35 && ticks <= 140 )
		{
			if ( CounterEx( hid, 0, 35 ) )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );
				float dmg = 10.f * Jass::GetHeroLevel( source );

				Jass::SetUnitFacing( source, GetUnitAngle( source, target ) );
				ACF_DamageTarget( source, target, dmg );
				ACF_StunUnit( target, .35f );

				effect ef = CreateEffectEx( "GeneralEffects\\qqqqq.mdl", targX, targY, 100.f, Jass::GetRandomReal( 0.f, 360.f ), 1.2f, 1.f );
				SetEffectTimedLife( ef, 1.f );

				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\RedAftershock.mdx", targX, targY ) );
				Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", target, "chest" ) );
			}
		}
		else if ( ticks == 170 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			effect ef;

			ef = CreateEffectEx( "GeneralEffects\\lssdqiu.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );
			SetEffectTimedLife( ef, 1.f );

			ef = CreateEffectEx( "GeneralEffects\\moonwrath.mdl", targX, targY, .0f, .0f, 4.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\apocalypsecowstomp.mdl", targX, targY, .0f, .0f, 1.5f, 1.f );
			Jass::SetSpecialEffectColour( ef, 0xFFFF00FF );

			for ( int i = 0; i < 8; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
				Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}

			float dmg = 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
			ACF_StunUnit( source, 1.85f );
			Jass::SetUnitFacing( source, Jass::LoadReal( GameHT, hid, 'angl' ) );
			Jass::SetUnitAnimation( source, "spell One" );
			Jass::SaveReal( GameHT, hid, 'circ', 800 );
		}

		if ( ticks < 80 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			float circle = Jass::LoadReal( GameHT, hid, 'circ' );

			DisplaceCircular( p, Jass::LoadReal( GameHT, hid, 'trgX' ), Jass::LoadReal( GameHT, hid, 'trgY' ), 300.f, circle, 1.f, "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl" );

			Jass::SaveReal( GameHT, hid, 'circ', circle - 10.f );
		}
		else if ( ticks == 80 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float angle = Jass::GetUnitFacing( source );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );

			Jass::SetUnitAnimation( source, "spell channel one" );
			DisplaceWar3ImageLinear( source, angle, dist * .4f, .5f, .01f, false, false );
		}
		else if ( ticks == 130 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::GetUnitFacing( source );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );
			effect ef;

			Jass::SetUnitAnimation( source, "attack slam" );

			DisplaceUnitWithArgs( source, angle, ( dist * .6f ), .6f, .01f, 600.f );

			ef = CreateEffectEx( "GeneralEffects\\wave.mdl", x, y, 200.f, angle, 2.f, 1.f );
			SetEffectTimedLife( ef, 3.f );

			ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.f, 2.f );
			SetEffectTimedLife( ef, 3.f );

			for ( int i = 0; i < 4; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
				Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}
		}
		else if ( ticks == 185 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );
			effect ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", targX, targY, .0f, 270.f, 6.f, 1.f );

			for ( int i = 0; i < 12; i++ )
			{
				if ( i < 8 )
				{
					ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 4.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
					Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
					SetEffectTimedLife( ef, 4.f );
				}

				for ( int j = 0; j < 3; j++ )
				{
					float efX = Jass::MathPointProjectionX( targX, 30.f * i, 200.f + 200.f * j );
					float efY = Jass::MathPointProjectionY( targY, 30.f * i, 200.f + 200.f * j );

					ef = CreateEffectEx( "GeneralEffects\\ioncannonbeam.mdl", efX, efY, 50.f, .0f, 10.f, 1.f );
					Jass::SetSpecialEffectColour( ef, 0xFFFF6400 );
					Jass::SetSpecialEffectAnimation( ef, "birth" );
					SetEffectTimedLife( ef, 1.5f );
				}
			}

			float dmg = 2000.f + 125.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 800.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, 4.1f );
			Jass::SetUnitTimeScale( source, 1.5f );
			Jass::SetUnitAnimation( source, "Spell Fly Slam" );

			Jass::SaveBoolean( GameHT, hid, 'skip', true );
			Jass::SaveInteger( GameHT, hid, 'tick', 5 );
		}
		else if ( ticks == 5 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

			if ( DisplaceWar3ImageToTarget( source, target, 50.f, 150.f ) )
			{
				PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
				Jass::SetUnitAnimation( source, "Spell Three" );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\RedAftershock.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );

				Jass::SaveBoolean( GameHT, hid, 'skip', false );
				Jass::SaveInteger( GameHT, hid, 'tick', 30 );

				return;
			}
		}
		else if ( ticks >= 30 && ticks <= 120 )
		{
			if ( CounterEx( hid, 0, 30 ) )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );
				float angle = GetUnitAngle( source, target );
				float dmg = 20.f * Jass::GetHeroLevel( source );

				ACF_DamageTarget( source, target, dmg );
				Jass::SetUnitFacing( source, angle );

				effect ef = CreateEffectEx( "GeneralEffects\\qqqqq.mdl", targX, targY, 100.f, Jass::GetRandomReal( 0.f, 360.f ), 1.2f, 1.f );
				SetEffectTimedLife( ef, 1.f );

				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\RedAftershock.mdx", targX, targY ) );
				Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", target, "chest" ) );
			}
		}
		else if ( ticks == 170 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float dmg = 20.f * Jass::GetHeroLevel( source );
			effect ef;

			Jass::SetUnitTimeScale( source, 1.f );

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", targX, targY ) );
			for ( int i = 0; i < 8; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 4.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
				Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}

			ACF_DamageTarget( source, target, dmg );
			DisplaceUnitWithArgs( target, 0, 0, .9f, .01f, 600.f );
			Jass::SetUnitAnimation( source, "Spell Five" );
		}
		else if ( ticks == 250 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 20.f * Jass::GetHeroLevel( source );
			effect ef;

			PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );

			Jass::SetUnitAnimation( source, "Spell One" );

			ef = CreateEffectEx( "GeneralEffects\\wave.mdl", targX, targY, 200.f, angle, 2.f, 1.f );
			Jass::SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 3.f );

			ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, 50.f, angle, 1.f, 2.f );
			Jass::SetSpecialEffectPitch( ef, -90.f );
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
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			Jass::SetUnitAnimation( source, "Attack Slam" );
			EffectAPI::Dash( source );
			
			DisplaceUnitWithArgs( source, angle, 950.f, .8f, .01f, 600.f );
		}
		else if ( ticks == 410 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float dmg = 180.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
			effect ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );

			PlayHeroSound( source, 'gsnd' + 2, 80.f, .0f );

			for ( int i = 0; i < 10; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\BlinkNew.mdl", targX, targY, 200.f, 36.f * i, .5f * i, 1.5f - .1f * i );
				Jass::SetSpecialEffectColour( ef, 0xFF6000FF );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 4.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
				Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
				SetEffectTimedLife( ef, 4.f );
			}

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
			ACF_DamageTarget( source, target, dmg );
			ACF_StunUnit( target, 1.f );
			ReleaseTimer( tmr );
		}
	}
	//

	// Kuchiki Byakuya Spells
	void KuchikiByakuya_Q( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
			Jass::DestroyGroup( Jass::LoadGroupHandle( GameHT, hid, '+grp' ) );
			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'Q2', 90.f, .0f );

			ACF_StunUnit( source, .25f );
			Jass::SetUnitAnimation( source, "spell" );
		}
		else if ( ticks == 25 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::GetUnitFacing( source );
			effect ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSpellQEffect.mdl", Jass::MathPointProjectionX( x, angle, 150.f ), Jass::MathPointProjectionY( y, angle, 150.f ), .0f, angle, 1.5f, 1.f );

			PlayHeroSound( source, 'psnd' + 'Q1', 90.f, .0f );

			Jass::SaveEffectHandle( GameHT, hid, '+eff', ef );
			Jass::SaveGroupHandle( GameHT, hid, '+grp', Jass::CreateGroup( ) );

			DisplaceWar3ImageLinear( ef, angle, 1250.f, .5f, .01f, false, false, "" );
		}

		if ( ticks >= 25 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			effect ef = Jass::LoadEffectHandle( GameHT, hid, '+eff' );
			group g = Jass::LoadGroupHandle( GameHT, hid, '+grp' );
			float x = Jass::GetSpecialEffectX( ef );
			float y = Jass::GetSpecialEffectY( ef );
			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 250.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) && !Jass::IsUnitInGroup( u, g ) )
				{
					ACF_DamageTarget( source, u, dmg );
					Jass::GroupAddUnit( g, u );
				}
			}

			if ( ticks == 60 )
			{
				Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
				Jass::DestroyGroup( Jass::LoadGroupHandle( GameHT, hid, '+grp' ) );
				ReleaseTimer( tmr );
			}
		}
	}

	void KuchikiByakuya_W( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			HandleListCleanEffects( Jass::LoadHandleList( GameHT, hid, 'elst' ), true, true );
			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
			ACF_StunUnit( source, .25f );
			Jass::SetUnitAnimation( source, "spell channel one" );

			Jass::SaveHandleList( GameHT, hid, 'elst', Jass::HandleListCreate( ) );
		}
		else if ( ticks >= 10 && ticks <= 20 )
		{
			if ( CounterEx( hid, 0, 2 ) )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );
				float angle = GetUnitAngle( source, target );
				handlelist hl = Jass::LoadHandleList( GameHT, hid, 'elst' );
				int count = Jass::HandleListGetEffectCount( hl );
				float efAngle = 60.f * count;
				float efX = Jass::MathPointProjectionX( targX, efAngle, 100.f );
				float efY = Jass::MathPointProjectionY( targX, efAngle, 100.f );
				effect ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSenkeiSword.mdl", efX, efY, 350.f, .0f, 3.f, 1.f );
				Jass::SetSpecialEffectAnimation( ef, "stand" );
				Jass::SetSpecialEffectPitch( ef, -85.f );
				SetEffectTimedLife( ef, .25f - count * .01f );

				Jass::HandleListAddHandle( hl, ef );
			}
		}
		else if ( ticks == 50 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			handlelist hl = Jass::LoadHandleList( GameHT, hid, 'elst' );
			float angleStep = 360.f / Jass::HandleListGetEffectCount( hl );

			for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
			{
				effect ef = Jass::HandleListGetEffectByIndex( hl, i );

				Jass::SetSpecialEffectPosition( ef, Jass::MathPointProjectionX( targX, i * angleStep, 100.f ), Jass::MathPointProjectionY( targY, i * angleStep, 100.f ) );
				Jass::SetSpecialEffectHeight( ef, 100.f );
			}

			float dmg = 245.f + 65.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			ACF_DamageTarget( source, target, dmg );
			ACF_StunUnit( source, 1.f );

			effect ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSpellQEffect.mdl", targX, targY, .0f, .0f, 1.5f, 1.f );
			SetEffectTimedLife( ef, .5f );

			Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\Spark_Pink.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\Deadspirit Asuna.mdx", targX, targY ) );

			Jass::HandleListDestroy( hl );
			ReleaseTimer( tmr );
		}
	}

	void KuchikiByakuya_E( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'E1', 90.f, .0f );

			ACF_StunUnit( source, 2.f );
			Jass::SetUnitAnimation( source, "spell Slam" );
		}
		else if ( ticks == 10 )
		{
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\plasma.mdl", targX, targY, .0f, .0f, 1.3f + i * .1f, 1.f );
				Jass::SetSpecialEffectAnimation( ef, "stand" );
				Jass::SetSpecialEffectColour( ef, 0xFFFF3060 );
				SetEffectTimedLife( ef, 2.f );
			}
		}
		else if ( ticks >= 20 && ticks <= 200 )
		{
			if ( CounterEx( hid, 0, 20 ) )
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
				float targY = Jass::LoadReal( GameHT, hid, 'trgY' );

				float dmg = 3.f * Jass::GetHeroLevel( source ) + .05f * Jass::GetHeroInt( source, true );
				float dmgFin = 40.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

				Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 450.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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

							DisplaceWar3ImageLinear( u, Jass::MathAngleBetweenPoints( targX, targY, Jass::GetUnitX( u ), Jass::GetUnitY( u ) ), 300.f, .5f, .01f, false, false );
						}

						Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( StopSpell( hid, 0, true ) || ticks > 1000 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			HandleListCleanEffects( Jass::LoadHandleList( GameHT, hid, 'elst' ), true, true );
			ReleaseTimer( tmr );
			return;
		}

		if ( ticks == 0 )
		{
			Jass::SetUnitAnimation( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), "morph" );
			Jass::SaveHandleList( GameHT, hid, 'elst', Jass::HandleListCreate( ) );
		}
		else if ( ticks == 25 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			handlelist hl = Jass::LoadHandleList( GameHT, hid, 'elst' );
			effect ef;
			
			for ( int i = 0; i < 3; i++ )
			{
				ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaBankaiEffect.mdl", x, y, 200.f * i, .0f, 1.f, 3.f );
				Jass::SetSpecialEffectTimeScale( ef, 3.f );
				Jass::HandleListAddHandle( hl, ef );
			}
		}
		else if ( ticks >= 100 )
		{
			float x = .0f;
			float y = .0f;
			handlelist hl = Jass::LoadHandleList( GameHT, hid, 'elst' );

			for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
			{
				effect ef = Jass::HandleListGetEffectByIndex( hl, i );
				float newFacing = 0;

				if ( i == 0 )
				{
					newFacing = 5.f;
					x = Jass::GetSpecialEffectX( ef );
					y = Jass::GetSpecialEffectY( ef );
				}
				else if ( i == 1 )
				{
					newFacing = -5.f;
				}
				else if ( i == 2 )
				{
					newFacing = 7.5f;
				}

				Jass::SetSpecialEffectFacing( ef, Jass::GetSpecialEffectFacing( ef ) + newFacing );
			}

			if ( CounterEx( hid, 0, 25 ) )
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float dmg = 5.f * Jass::GetHeroLevel( source ) + .05f * Jass::GetHeroInt( source, true );
				bool isEffect = CounterEx( hid, 1, 5 );
				Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 800.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
					{
						ACF_DamageTarget( source, u, dmg );

						if ( isEffect )
						{
							Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
							Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "head" ) );
						}
					}
				}
			}
		}
	}

	void KuchikiByakuya_T( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ReleaseTimer( tmr );
			return;
		}
		
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'T3', 100.f, .0f );
			ACF_StunUnit( source, 2.5f );
			Jass::SetUnitTimeScale( source, 2.f );
			Jass::SetUnitAnimation( source, "Attack Alternate One" );
		}
		else if ( ticks == 40 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );

			PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );

			EffectAPI::PushWind( source, target );

			Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\QQQQQ.mdx", target, "chest" ) );
			ACF_StunUnit( target, 2.f );

			DisplaceWar3ImageLinear( target, angle, 400.f, .4f, .01f, false, false );
		}
		else if ( ticks == 80 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'T2', 100.f, .0f );
			Jass::SetUnitTimeScale( source, 1.f );
			Jass::SetUnitAnimation( source, "spell three" );
		}
		else if ( ticks == 120 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			Jass::SetUnitAnimation( source, "spell four" );
			EffectAPI::Dash( source );

			DisplaceWar3ImageLinear( source, angle, dist - 250.f, .5f, .01f, false, false );
		}
		else if ( ticks == 170 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );

			Jass::SetUnitAnimation( source, "spell one" );
			EffectAPI::Dash( source );
		}
		else if ( ticks == 180 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			effect ef;

			for ( int i = 0; i < 2; i++ )
			{
				ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiQEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
				//Jass::SetSpecialEffectColour( ef, 0xFFFF7000 );
				SetEffectTimedLife( ef, 3.f );
			}

			Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\QQQQQ.mdx", target, "chest" ) );

			ef = CreateEffectEx( "GeneralEffects\\qianbenying8.mdl", targX, targY, .0f, .0f, 1.f, 1.f );
			SetEffectTimedLife( ef, .5f );

			DisplaceWar3ImageLinear( source, angle, dist + 400.f, .6f, .01f, false, false );
		}
		else if ( ticks == 250 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			effect ef;
			float dmg = 3000.f + 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			PlayHeroSound( source, 'gsnd' + 0, 60.f, .0f );

			for ( int i = 0; i < 5; i++ )
			{
				ef = CreateEffectEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSakuraExplosionEffect.mdl", targX, targY, 50.f, .0f, .5f * i, .3f + i );
				SetEffectTimedLife( ef, 5.f );
			}

			ef = CreateEffectEx( "GeneralEffects\\qianbenying8.mdl", targX, targY, .0f, .0f, 1.f, 1.f );
			SetEffectTimedLife( ef, .5f );

			Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "chest" ) );
			Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\Spark_Pink.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\Deadspirit Asuna.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );

			ACF_StunUnit( target, 1.f );
			ACF_DamageTarget( source, target, dmg );
			ReleaseTimer( tmr );
		}
	}
	//

	// Akame Spells
	void Akame_D( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'D1' );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float dist = -400.f;

			if ( Jass::LoadInteger( GameHT, hid, 'atid' ) == 'A052' )
			{
				dist = -350.f;
				Jass::ShowUnitAbility( source, 'A03L', true );
				Jass::ShowUnitAbility( source, 'A052', false );
			}
			PlayHeroSound( source, 'psnd' + 'D1', 80.f, .0f );
			ACF_StunUnit( source, .3f );
			Jass::SetUnitTimeScale( source, 2.f );
			Jass::SetUnitAnimation( source, "spell two" );
			Jass::SetUnitInvulnerable( source, true );
			Jass::SaveReal( GameHT, hid, 'dist', dist );
		}
		else if ( ticks == 20 )
		{
			DisplaceUnitWithArgs( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), Jass::LoadReal( GameHT, hid, 'angl' ), Jass::LoadReal( GameHT, hid, 'dist' ), .2f, .01f, 0 );
		}
		else if ( ticks == 30 )
		{
			ReleaseTimer( tmr );
		}
	}

	void Akame_Q( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( StopSpell( hid, 0, true ) || ticks == 200 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			if ( ticks != 200 )
			{
				StopHeroSound( source, 'psnd' + 'Q1' );
			}

			Jass::ShowUnitAbility( source, 'A03L', true );
			Jass::ShowUnitAbility( source, 'A052', false );
			ReleaseTimer( tmr );
			return;
		}
		else if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, .2f );
			Jass::SetUnitAnimation( source, "Spell Four" );
		}
		else if ( ticks == 20 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float angle = Jass::GetUnitFacing( source );
			float dist = 200.f;
			float x = Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, dist );
			float y = Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, dist );

			PlayHeroSound( source, 'psnd' + 'Q1', 60.f, .0f );

			Jass::ShowUnitAbility( source, 'A03L', false );
			Jass::ShowUnitAbility( source, 'A052', true );

			for ( int i = 0; i < 5; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\AkihaClaw.mdl", x, y, .0f, angle + 30.f, 1.5f, .8f );
				SetEffectTimedLife( ef, 4.f );
			}

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 400.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
					ACF_DamageTarget( source, u, dmg );
					ACF_StunUnit( u, 1.f );
				}
			}
		}
	}

	void Akame_W( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			if ( StopSpell( hid, 0, true ) )
			{
				StopHeroSound( source, 'psnd' + 'W1' );
			}

			Jass::SetUnitVertexColor( source, 0xFF, 0xFF, 0xFF, 0xFF );
			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
			ReleaseTimer( tmr );

			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, .2f );
			Jass::SetUnitPathing( source, false );
			Jass::SetUnitAnimation( source, "Spell Channel" );
			Jass::SaveInteger( GameHT, hid, 'acol', 0xFF );
			Jass::SaveEffectHandle( GameHT, hid, '+eff', Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );
		}
		else
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
			int alpha = Jass::MathIntegerClamp( Jass::LoadInteger( GameHT, hid, 'acol' ) - 5, 0, 0xFF );

			Jass::SetUnitVertexColor( source, 0xFF, 0xFF, 0xFF, alpha );
			Jass::SaveInteger( GameHT, hid, 'acol', alpha );

			if ( DisplaceWar3ImageToTarget( source, target, 20.f, 100.f ) )
			{
				float dmg = 200.f + 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

				PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );

				for ( int i = 0; i < 5; i++ )
				{
					effect ef = CreateEffectEx( "Characters\\RyougiShiki\\RyougiShikiWEffect.mdl", x, y, .0f, angle, 4.f, 1.f );
					//Jass::SetSpecialEffectColour( ef, 0xFFFF7000 );
					SetEffectTimedLife( ef, 3.f );
				}

				ACF_StunUnit( target, 1.f );
				ACF_DamageTarget( source, target, dmg );
				Jass::SetUnitAnimation( source, "attack" );

				Jass::SetUnitVertexColor( source, 0xFF, 0xFF, 0xFF, 0xFF );
				Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
				ReleaseTimer( tmr );
				return;
			}
		}
	}

	void Akame_E( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'E1' );
			ReleaseTimer( tmr );

			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_StunUnit( source, .3f );
			Jass::SetUnitAnimation( source, "Spell Four" );
			PlayHeroSound( source, 'psnd' + 'E1', 100.f, .0f );
		}
		else if ( ticks == 30 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );

			effect ef = CreateEffectEx( "GeneralEffects\\AkihaClaw.mdl", Jass::MathPointProjectionX( x, angle, dist * .5f ), Jass::MathPointProjectionY( y, angle, dist * .5f ), .0f, angle, 3.f, 1.f );
			SetEffectTimedLife( ef, 3.f );

			DisplaceWar3ImageLinear( source, angle, dist, .1f, .01f, false, true );

			float dmg = 300.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			GroupEnumUnitsInLine( GroupEnum, x, y, angle, dist, 450.f );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					DisplaceWar3ImageLinear( u, angle, 200.f, .5f, .01f, false, false );
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
				}
			}

			ReleaseTimer( tmr );
		}
	}

	void Akame_R( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			if ( StopSpell( hid, 0, true ) )
			{
				StopHeroSound( source, 'gsnd' + 0 );
				StopHeroSound( source, 'gsnd' + 1 );
				StopHeroSound( source, 'psnd' + 'D1' );
				StopHeroSound( source, 'psnd' + 'W1' );
				StopHeroSound( source, 'psnd' + 'R1' );
				StopHeroSound( source, 'psnd' + 'R2' );
			}

			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			DisplaceWar3ImageLinear( source, angle, dist - 150.f, .6f, .01f, false, false );
			Jass::SetUnitTimeScale( source, 2.f );
			ACF_StunUnit( source, 2.8f );
			Jass::SetUnitAnimation( source, "spell three" );
		}
		else if ( ticks == 40 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 250.f + 30.f * Jass::GetHeroLevel( source );

			PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );
			PlayHeroSound( source, 'psnd' + 'D1', 80.f, .0f );

			EffectAPI::PushWind( source, target );

			DisplaceWar3ImageLinear( target, angle, 400.f, .5f, .01f, false, false );
			ACF_DamageTarget( source, target, dmg );
			Jass::SetUnitAnimation( source, "spell two" );
			DisplaceUnitWithArgs( source, angle, -400.f, 1, .01f, 0 );
		}
		else if ( ticks == 140 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'R2', 80.f, .0f );

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );
			Jass::ShowUnit( source, false );
			Jass::SaveBoolean( GameHT, hid, 'skip', true );
			Jass::SaveInteger( GameHT, hid, 'tick', ticks + 5 );
		}
		else if ( ticks == 145 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float dmg = 25.f + Jass::GetHeroLevel( source );
			int slashCount = Jass::LoadInteger( GameHT, hid, 'slct' );

			if ( slashCount < 20 )
			{
				float angle = slashCount * 18.f;
				float efX = Jass::MathPointProjectionX( Jass::GetUnitX( target ), angle, 150.f );
				float efY = Jass::MathPointProjectionY( Jass::GetUnitY( target ), angle, 150.f );
				effect ef;

				ACF_DamageTarget( source, target, dmg );

				if ( CounterEx( hid, 0, 4 ) )
				{
					ef = Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "chest" );
					Jass::SetSpecialEffectScale( ef, .5f );
					Jass::DestroyEffect( ef );
				}
				
				ef = CreateEffectEx( "GeneralEffects\\BlackBlink.mdx", efX, efY, .0f, .0f, .75f, 1.f );
				Jass::DestroyEffect( ef );

				Jass::SaveInteger( GameHT, hid, 'slct', slashCount + 1 );
			}
			else
			{
				Jass::SaveBoolean( GameHT, hid, 'skip', false );
				Jass::SaveInteger( GameHT, hid, 'tick', ticks + 1 );
				Jass::ShowUnit( source, true );
				ACF_SelectUnit( source, Jass::LoadPlayerHandle( GameHT, hid, '+ply' ) );
				Jass::SetUnitFacing( source, GetUnitAngle( source, target ) );
				Jass::SetUnitTimeScale( source, .1f );
				Jass::SetUnitAnimation( source, "attack" );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );
				Jass::SaveEffectHandle( GameHT, hid, '+eff', Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );
				return;
			}
		}
		else if ( ticks == 190 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			ACF_SelectUnit( source, Jass::LoadPlayerHandle( GameHT, hid, '+ply' ) );
			PlayHeroSound( source, 'psnd' + 'W1', 90.f, .0f );
			Jass::SetUnitTimeScale( source, 2.f );
		}
		else if ( ticks == 210 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
			float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );

			PlayHeroSound( source, 'psnd' + 'R1', 90.f, .0f );

			for ( int i = 0; i < 3; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\AkihaClaw.mdl", targX, targY, .0f, angle, 4.f, 1.f ); // perhaps better to change logic of the effect...?
				SetEffectTimedLife( ef, 1.f );
			}

			DisplaceWar3ImageLinear( source, angle, dist + 400.f, .2f, .01f, false, false );

			Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
		}
		else if ( ticks == 250 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float dmg = 500.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			ACF_StunUnit( target, 1 );
			PlayHeroSound( source, 'gsnd' + 0, 60.f, .0f );
			ACF_DamageTarget( source, target, dmg );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
			ReleaseTimer( tmr );
		}
	}

	void Akame_T( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			StopHeroSound( source, 'gsnd' + 1 );
			StopHeroSound( source, 'psnd' + 'Q1' );
			StopHeroSound( source, 'psnd' + 'T1' );

			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			DisplaceWar3ImageLinear( source, angle, dist - 150.f, .5f, .01f, false, false );
			ACF_StunUnit( source, 2.f );
			Jass::SetUnitAnimation( source, "spell three" );
			ACF_StunUnit( target, 2.f );
			Jass::SaveEffectHandle( GameHT, hid, '+eff', Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );
		}
		else if ( ticks == 50 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );
			float dmg = 500.f + 50.f * Jass::GetHeroLevel( source );

			PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );

			EffectAPI::PushWind( source, target );

			effect ef;

			ef = CreateEffectEx( "GeneralEffects\\wave.mdl", targX, targY, 200.f, angle, 1.f, 1.f );
			Jass::SetSpecialEffectPitch( ef, -90.f );

			Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "chest" ) );
			Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\QQQQQ.mdx", target, "chest" ) );
			DisplaceWar3ImageLinear( target, angle, 600.f, 1.f, .01f, false, false );
			ACF_DamageTarget( source, target, dmg );
		}
		else if ( ticks == 75 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float dist = GetUnitDistance( source, target ) + 600.f;
			float height = dist / 2.f;

			DisplaceUnitWithArgs( source, GetUnitAngle( source, target ), dist, .8f, .01f, Jass::MathRealClamp( height, 100.f, 250.f ) );
		}
		else if ( ticks == 155 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

			Jass::SetUnitTimeScale( source, 1.75f );
			PlayHeroSound( source, 'psnd' + 'Q1', 80.f, .0f );

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( target ), Jass::GetUnitY( target ) ) );
		}
		else if ( ticks == 205 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			PlayHeroSound( source, 'gsnd' + 0, 60.f, .0f );
			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", Jass::GetUnitX( target ), Jass::GetUnitY( target ) ) );

			ACF_StunUnit( target, 1.f );
			ACF_DamageTarget( source, target, dmg );

			ReleaseTimer( tmr );
		}
	}
	//

	// Scathach Spells
	void SetScathachQState( unit u, int state = 0 )
	{
		Jass::ShowUnitAbility( u, 'A040', state == 0 );
		Jass::ShowUnitAbility( u, 'A03Y', state == 1 );
		Jass::ShowUnitAbility( u, 'A03Z', state == 2 );
	}

	void ResetScathachQ( unit u )
	{
		SetScathachQState( u, 0 );
	}

	void Scathach_Q1( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( StopSpell( hid, 1, true ) || ticks == 300 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

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
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

			PlayHeroSound( source, 'psnd' + 'Q3', 100.f, .0f );
			ACF_StunUnit( source, .55f );
			Jass::SetUnitFacing( source, GetUnitAngle( source, target ) );
			Jass::SetUnitAnimation( source, "Attack" );
			
		}
		else if ( ticks == 20 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			SetScathachQState( source, Jass::GetUnitLevel( source ) >= 5 ? 1 : 0 );
			Jass::SetUnitFacing( source, angle );
			EffectAPI::Dash( source );
			DisplaceWar3ImageLinear( source, angle, dist - 50.f, .35f, .02f, false, true );
		}
		else if ( ticks == 55 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float dmg = 100.f + 50.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

			ACF_StunUnit( target, 1.f );
			ACF_DamageTarget( source, target, dmg );
		}
	}

	void Scathach_Q2( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( StopSpell( hid, 1, true ) || ticks == 300 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			StopHeroSound( source, 'psnd' + 'Q1' );
			ResetScathachQ( source );
			ReleaseTimer( tmr );
			return;
		}
		else if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			PlayHeroSound( source, 'psnd' + 'Q2', 100.f, .0f );
			ACF_StunUnit( source, .15f );
			Jass::SetUnitAnimation( source, "spell Three" ); 
			DisplaceWar3ImageLinear( source, angle, dist - 150.f, .1f, .02f, false, true );
		}
		else if ( ticks == 10 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dmg = 50.f + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

			SetScathachQState( source, Jass::GetUnitLevel( source ) >= 8 ? 2 : 0 );
			EffectAPI::PushWind( source, target );
			DisplaceWar3ImageLinear( target, angle, 200.f, .25f, .01f, false, false );
			ACF_DamageTarget( source, target, dmg );
			ReleaseTimer( tmr );
		}
	}

	void Scathach_Q3( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			StopHeroSound( source, 'psnd' + 'Q1' );
			ResetScathachQ( source );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = GetUnitAngle( source, target );
			float dist = GetUnitDistance( source, target );

			PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
			ACF_StunUnit( source, .45f );

			Jass::SetUnitFacing( source, angle );
			Jass::SetUnitAnimation( source, "Spell Three" );

			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, .0f, 2.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			DisplaceWar3ImageLinear( source, angle, dist - 150.f, .2f, .02f, false, true );
		}
		else if ( ticks == 20 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

			ResetScathachQ( source );
			Jass::SetUnitFacing( source, GetUnitAngle( source, target ) );
			Jass::SetUnitAnimation( source, "Spell Three" );
		}
		else if ( ticks == 45 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = GetUnitAngle( source, target );
			float dmg = 100.f + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );
			effect ef;

			Jass::SetUnitFacing( source, angle );

			EffectAPI::PushWind( source, target );
			DisplaceWar3ImageLinear( target, angle, 200.f, .5f, .01f, false, false );
			ACF_DamageTarget( source, target, dmg );


			ReleaseTimer( tmr );
		}
	}

	void Scathach_W( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			StopHeroSound( source, 'psnd' + 'W1' );
			StopHeroSound( source, 'psnd' + 'Q3' );
			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, 'eff' ) );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );

			PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );
			ACF_StunUnit( source, .5f );
			Jass::SetUnitAnimation( source, "spell Throw" );

			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, .0f, 2.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
			Jass::SaveEffectHandle( GameHT, hid, '+eff', Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );

			DisplaceUnitWithArgs( source, angle, Jass::LoadReal( GameHT, hid, 'dist' ), .5f, .01f, 600.f );
		}
		else if ( ticks == 50 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );

			PlayHeroSound( source, 'psnd' + 'Q3', 100.f, .0f );
			
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\SlamEffect.mdx", x, y ) );
			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );

			for ( int i = 0; i < 3; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
				SetEffectTimedLife( ef, 4.f );
			}

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 400.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			HandleListCleanEffects( Jass::LoadHandleList( GameHT, hid, 'elst' ), true, true );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
			handlelist hl = Jass::HandleListCreate( );

			ACF_DisableUnitTP( target, 1.f );
			ACF_StunUnit( source, 1.f );
			Jass::SetUnitPathing( source, false );
			Jass::SetUnitAnimation( source, "Spell Three" ); // was channel

			for ( int i = 0; i < 8; i++ )
			{
				float dist = 80.f * i;
				effect ef;

				ef = CreateEffectEx( "GeneralEffects\\OrbOfFire.mdl", Jass::MathPointProjectionX( x, angle - 160.f, dist ), Jass::MathPointProjectionY( y, angle - 160.f, dist ), 150.f, angle, 1.5f, 1.f );

				Jass::HandleListAddHandle( hl, ef );

				ef = CreateEffectEx( "GeneralEffects\\OrbOfFire.mdl", Jass::MathPointProjectionX( x, angle + 160.f, dist ), Jass::MathPointProjectionY( y, angle + 160.f, dist ), 150.f, angle, 1.5f, 1.f );

				Jass::HandleListAddHandle( hl, ef );
			}

			Jass::SaveHandleList( GameHT, hid, 'elst', hl );
		}
		else if ( ticks == 50 )
		{
			Jass::SaveInteger( GameHT, hid, 'tick', ticks + 5 );
			Jass::SaveBoolean( GameHT, hid, 'skip', true );
		}
		else if ( ticks == 55 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
			float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
			handlelist hl = Jass::LoadHandleList( GameHT, hid, 'elst' );

			if ( CounterEx( hid, 0, 10 ) )
			{
				ACF_StunUnit( source, .1f );
			}

			if ( dist >= 150.f )
			{
				Jass::SetUnitFacing( source, angle );
				SetUnitXY( source, Jass::MathPointProjectionX( x, angle, 50.f ), Jass::MathPointProjectionY( y, angle, 50.f ) );
			}
			else
			{
				Jass::SetUnitAnimation( source, "spell Seven" );
				PlayHeroSound( source, 'psnd' + 'R1', 100.f, .0f );
				Jass::SaveBoolean( GameHT, hid, 'skip', false );
				//HandleListCleanEffects( Jass::LoadHandleList( GameHT, hid, 'elst' ), true, true );
			}

			for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
			{
				effect ef = Jass::HandleListGetEffectByIndex( hl, i );
				angle = Jass::GetSpecialEffectFacing( ef );

				Jass::SetSpecialEffectPosition( ef, Jass::MathPointProjectionX( Jass::GetSpecialEffectX( ef ), angle, 50.f ), Jass::MathPointProjectionY( Jass::GetSpecialEffectY( ef ), angle, 50.f ) );
			}
		}
		else if ( ticks == 60 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
			effect ef;

			PlayHeroSound( source, 'psnd' + 'R2', 100.f, .0f );
			Jass::SetUnitFacing( source, angle );
			Jass::SetUnitAnimation( source, "spell four" );

			EffectAPI::PushWind( source, target );

			ef = CreateEffectEx( "GeneralEffects\\t_huobao.mdl", targX, targY, 100.f, angle, .5f, 1.f );
			Jass::SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 2.f );

			Jass::SaveInteger( GameHT, hid, 'tick', ticks + 5 );
			Jass::SaveBoolean( GameHT, hid, 'skip', true );

			float dist = 500.f;
			Jass::SaveReal( GameHT, hid, 'angl', GetUnitAngle( source, target ) );
			Jass::SaveReal( GameHT, hid, 'dist', dist );
			Jass::SaveReal( GameHT, hid, '+spd', dist * .01f / .4f ); // dist * tickRate / time
		}
		else if ( ticks == 65 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );
			float speed = Jass::LoadReal( GameHT, hid, '+spd' );
			handlelist hl = Jass::LoadHandleList( GameHT, hid, 'elst' );

			if ( CounterEx( hid, 0, 10 ) )
			{
				ACF_StunUnit( source, .1f );
			}

			if ( dist >= 0.f )
			{
				SetUnitXY( target, Jass::MathPointProjectionX( targX, angle, speed ), Jass::MathPointProjectionY( targY, angle, speed ) );

				if ( CounterEx( hid, 1, 5 ) )
				{
					Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", targX, targY ) );
				}

				for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
				{
					effect ef = Jass::HandleListGetEffectByIndex( hl, i );
					angle = Jass::GetSpecialEffectFacing( ef );

					Jass::SetSpecialEffectPosition( ef, Jass::MathPointProjectionX( Jass::GetSpecialEffectX( ef ), angle, speed ), Jass::MathPointProjectionY( Jass::GetSpecialEffectY( ef ), angle, speed ) );
				}
			}
			else
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );

				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", targX, targY ) );

				for ( int i = 0; i < 10; i++ )
				{
					effect ef = CreateEffectEx( "GeneralEffects\\t_huobao.mdl", targX, targY, 100.f, 36.f * i, 2.f, 1.f );
					Jass::SetSpecialEffectPitch( ef, -90.f );
					SetEffectTimedLife( ef, 2.f ); 
				}

				float dmg = 75.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

				Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 600.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
					{
						ACF_DamageTarget( source, u, dmg );
					}
				}

				HandleListCleanEffects( hl, true, true );
				//Jass::SaveBoolean( GameHT, hid, 'skip', false );
				ReleaseTimer( tmr );
			}

			Jass::SaveReal( GameHT, hid, 'dist', dist - speed );
		}
	}

	void Scathach_R( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'E1' );

			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );

			PlayHeroSound( source, 'psnd' + 'E1', 80.f, .0f );
			ACF_StunUnit( source, 1.25f );
			Jass::SetUnitTimeScale( source, 2.f );
			Jass::SetUnitAnimation( source, "spell Three" ); // attack?
			ACF_DisableUnitTP( target, 1.25f );
			DisplaceWar3ImageLinear( source, angle, GetUnitDistance( source, target ) - 100.f, .2f, .01f, false, false );

			for ( int i = 0; i < 3; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, Jass::GetRandomReal( 0.f, 360.f ), .5f * ( i + 1 ), 2.f + .25 * i );
				SetEffectTimedLife( ef, 4.f );
			}
		}
		else if ( ticks >= 20 && ticks <= 120 )
		{
			if ( CounterEx( hid, 0, 20 ) )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );
				float angle = GetUnitAngle( source, target );
				float dist = GetUnitDistance( source, target );
				float dmg = 25.f * Jass::GetHeroLevel( source ) + .2f * Jass::GetHeroInt( source, true );
				effect ef;

				Jass::SetUnitAnimationWithRarity( source, "attack", Jass::RARITY_RARE );
				Jass::SetUnitFacing( source, angle );

				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 50.f, angle, 1.5f, 2.f );
				Jass::SetSpecialEffectPitch( ef, -90.f );
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, 50.f, angle, 1.f, 2.f );
				Jass::SetSpecialEffectPitch( ef, -90.f );
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
						Jass::SetSpecialEffectPitch( ef, -90.f );
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
		
			StopHeroSound( source, 'psnd' + 'Q1' );
			StopHeroSound( source, 'psnd' + 'T1' );
			Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::MathAngleBetweenPoints( x, y, Jass::LoadReal( GameHT, hid, 'trgX' ), Jass::LoadReal( GameHT, hid, 'trgY' ) );

			PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
			ACF_StunUnit( source, 1.f );
			Jass::SetUnitAnimation( source, "spell Three" );

			effect ef = CreateEffectEx( "GeneralEffects\\laxus_lightning_spear.mdl", x, y, 50.f, angle, 2.f, 1.f );
			Jass::SetSpecialEffectColour( ef, 0x64840000 );

			Jass::SaveEffectHandle( GameHT, hid, '+eff', ef );
		}
		else if ( ticks < 100 )
		{
			if ( CounterEx( hid, 0, 5 ) )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				float angle = Jass::MathAngleBetweenPoints( x, y, Jass::LoadReal( GameHT, hid, 'trgX' ), Jass::LoadReal( GameHT, hid, 'trgY' ) );
				effect ef = Jass::LoadEffectHandle( GameHT, hid, '+eff' );

				Jass::SetUnitFacing( source, angle );
				Jass::SetSpecialEffectFacing( ef, angle );
				Jass::SetSpecialEffectScale( ef, 2.f + ticks / 50.f );
			}
		}
		else if ( ticks == 100 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float dist = Jass::MathDistanceBetweenPoints( x, y, Jass::LoadReal( GameHT, hid, 'trgX' ), Jass::LoadReal( GameHT, hid, 'trgY' ) );

			PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );

			for ( int i = 0; i < 8; i++ )
			{
				effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + i / 5.f, 1.25f );
				Jass::SetSpecialEffectAlpha( ef, 0x50 );
				SetEffectTimedLife( ef, 4.f );
			}

			Jass::SetUnitAnimation( source, "spell Four" );
			Jass::SaveReal( GameHT, hid, 'dist', dist );
		}
		else if ( ticks > 100 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			effect ef = Jass::LoadEffectHandle( GameHT, hid, '+eff' );
			float efX = Jass::GetSpecialEffectX( ef );
			float efY = Jass::GetSpecialEffectY( ef );
			float angle = Jass::GetSpecialEffectFacing( ef );
			float moveX = Jass::MathPointProjectionX( efX, angle, 50.f );
			float moveY = Jass::MathPointProjectionY( efY, angle, 50.f );
			float dist = Jass::LoadReal( GameHT, hid, 'dist' );
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );

			if ( dist >= 100.f )
			{
				Jass::SetSpecialEffectPosition( ef, moveX, moveY );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", efX, efY ) );
				Jass::GroupEnumUnitsInRange( GroupEnum, moveX, moveY, 450.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
					{
						float x = Jass::GetUnitX( u );
						float y = Jass::GetUnitY( u );
						float toAngle = Jass::MathAngleBetweenPoints( x, y, moveX, moveY );

						SetUnitXY( u, Jass::MathPointProjectionX( x, toAngle, 50.f ), Jass::MathPointProjectionY( y, toAngle, 50.f ) );
					}
				}

				Jass::SaveReal( GameHT, hid, 'dist', dist - 50.f );
			}
			else
			{
				PlayHeroSound( source, 'gsnd' + 2, 80.f, .0f );

				Jass::DestroyEffect( ef );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", efX, efY ) );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", efX, efY ) );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", efX, efY ) );

				for ( int i = 0; i < 8; i++ )
				{
					ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", efX, efY, .0f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + i / 5.f, 1.25f );
					Jass::SetSpecialEffectAlpha( ef, 0x50 );
					SetEffectTimedLife( ef, 4.f );
				}

				Jass::GroupEnumUnitsInRange( GroupEnum, efX, efY, 450.f, nil );

				float dmg = 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			PlayHeroSound( source, 'psnd' + 'D1', 100.f, .0f );
			Jass::SaveEffectHandle( GameHT, hid, '+eff', Jass::AddSpecialEffectTarget( "GeneralEffects\\lavaspray.mdx", source, "head" ) );
		}

		if ( CounterEx( hid, 0, 50 ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			if ( Jass::GetUnitAbilityLevel( source, 'B04H' ) <= 0 )
			{
				Jass::DestroyEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' ) );
				ReleaseTimer( tmr );
			}

			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float dmg = 12.5f * Jass::GetHeroLevel( source ) + .1f * Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 300.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					if ( ACF_DamageTarget( source, u, dmg ) )
					{
						Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", u, "chest" ) );
					}
				}
			}
		}
	}

	void Akainu_Q( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

		if ( StopSpell( hid, 1, true ) )
		{
			StopHeroSound( source, 'psnd' + 'R1' );
			StopHeroSound( source, 'psnd' + 'R2' );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );
		unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

		if ( ticks == 0 )
		{
			PlayHeroSound( source, 'psnd' + 'R2', 90.f, .0f );
			ACF_StunUnit( source, .25f );
			Jass::SetUnitPathing( source, false );
			Jass::SetUnitAnimation( source, "spell three" );
		}

		if ( CounterEx( hid, 0, 10 ) )
		{
			ACF_StunUnit( source, .10f );
			//ACF_DisableUnitTP( target, .10f ); // this adds up
		}

		float x = Jass::GetUnitX( source );
		float y = Jass::GetUnitY( source );
		float targX = Jass::GetUnitX( target );
		float targY = Jass::GetUnitY( target );
		float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
		float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
		float moveX = Jass::MathPointProjectionX( x, angle, 20.f );
		float moveY = Jass::MathPointProjectionY( y, angle, 20.f );

		if ( dist > 150.f )
		{
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
			SetUnitXY( source, moveX, moveY );
			Jass::SetUnitFacingInstant( source, angle );
		}
		else
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );

			PlayHeroSound( source, 'psnd' + 'R1', 90.f, .0f );
			Jass::SetUnitAnimation( source, "spell two" );

			effect ef;
			// "Units\\Creeps\\LavaSpawn\\LavaSpawn.mdl"

			ef = CreateEffectEx( "Abilities\\Weapons\\DemolisherFireMissile\\DemolisherFireMissile.mdl", moveX, moveY, 50.f, angle, 1.f, 1.f );
			Jass::SetSpecialEffectPitch( ef, -90.f );
			Jass::DestroyEffect( ef );

			ef = CreateEffectEx( "GeneralEffects\\t_huobao.mdl", moveX, moveY, 100.f, angle, 1.f, 1.f );
			Jass::SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 2.f );

			for ( int i = 0; i < 3; i++ )
			{
				float face = 120.f * i;
				moveX = Jass::MathPointProjectionX( targX, face, 150.f );
				moveY = Jass::MathPointProjectionY( targY, face, 150.f );

				Jass::DestroyEffect( CreateEffectEx( "Units\\Creeps\\LavaSpawn\\LavaSpawn.mdl", moveX, moveY, .0f, .0f, 1.5f, 1.f ) );
				Jass::DestroyEffect( CreateEffectEx( "Characters\\Akainu\\magmablast2.mdl", moveX, moveY, 120.f, face, .5f, 1.5f ) );
			}

			Jass::GroupEnumUnitsInRange( GroupEnum, Jass::GetUnitX( target ), Jass::GetUnitY( target ), 300.f, nil );
			float dmg = 200 + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'E1' );
			ReleaseTimer( tmr );
		}

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );

			PlayHeroSound( source, 'psnd' + 'E1', 90.f, .0f );
			ACF_StunUnit( source, .5f );
			Jass::SetUnitAnimation( source, "spell one" );

			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, .0f, 1.5f, 1.f );
			SetEffectTimedLife( ef, 4.f );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
			DisplaceUnitWithArgs( source, angle, Jass::LoadReal( GameHT, hid, 'dist' ), .5f, .01f, 600.f );
		}
		else if ( ticks == 50 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			effect ef;

			ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, .0f, .0f, 1.5f, 1.f );

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );

			for ( int i = 0; i < 4; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f, 1.25f ); 
				SetEffectTimedLife( ef, 4.f );

				ef = CreateEffectEx( "Characters\\Akainu\\magmablast2.mdl", x, y, .0f, 90.f * i, .5f, 1.5f );
				SetEffectTimedLife( ef, 2.f );
			}

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 350.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 1, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'R1' );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			ACF_StunUnit( source, .25f );
			Jass::SetUnitTimeScale( source, 2.f );
			Jass::SetUnitAnimation( source, "attack" );
		}
		else if ( ticks == 20 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );

			Jass::SetUnitTimeScale( source, 1 );

			projectile proj = Jass::CreateProjectile( 'B-Mi', Jass::MathPointProjectionX( x, angle, 40.f ), Jass::MathPointProjectionY( y, angle, 40.f ), Jass::GetUnitZ( source ) + 100.f, angle );

			Jass::SetProjectileUnitData( proj, source, 0 );
			Jass::SetProjectileModel( proj, "Characters\\Akainu\\magmablast2.mdl" ); // Characters\\Akainu\\moon_shin_mg1.mdl
			Jass::SetProjectileScale( proj, 1.5f );
			Jass::SetProjectileDamage( proj, 0, 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true ) );
			Jass::SetProjectileAttackType( proj, Jass::ATTACK_TYPE_NORMAL );
			Jass::SetProjectileDamageType( proj, 0, Jass::DAMAGE_TYPE_MAGIC );
			Jass::SetProjectileWeaponType( proj, Jass::WEAPON_TYPE_WHOKNOWS );
			Jass::SetProjectileArc( proj, .0f );
			Jass::SetProjectileSpeed( proj, 1500.f );
			Jass::LaunchProjectileTarget( proj, Jass::LoadUnitHandle( GameHT, hid, 'utrg' ) );
			Jass::SaveInteger( GameHT, Jass::GetHandleId( proj ), 'atid', Jass::LoadInteger( GameHT, hid, 'atid' ) );

			ReleaseTimer( tmr );
		}
	}

	void Akainu_R( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			StopHeroSound( source, 'psnd' + 'Q1' );
			StopHeroSound( source, 'psnd' + 'R2' );

			Jass::DestroyGroup( Jass::LoadGroupHandle( GameHT, hid, '+grp' ) );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			PlayHeroSound( source, 'psnd' + 'Q1', 90.f, .0f );
			Jass::SetUnitTimeScale( source, 2 );
			ACF_StunUnit( source, .2f );
			Jass::SetUnitAnimation( source, "attack" );

			Jass::SaveGroupHandle( GameHT, hid, '+grp', Jass::CreateGroup( ) );
		}
		else if ( ticks == 20 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );

			effect ef = CreateEffectEx( "Characters\\Akainu\\moon_shin_dph23.mdl", Jass::MathPointProjectionX( x, angle, 300.f ), Jass::MathPointProjectionY( y, angle, 300.f ), 100.f, angle, 2.f, 1.f );
			SetEffectTimedLife( ef, 1.f );

			Jass::SetUnitTimeScale( source, 1.f );
			PlayHeroSound( source, 'psnd' + 'R2', 60.f, .0f );
		}
		else if ( ticks > 20 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			group g = Jass::LoadGroupHandle( GameHT, hid, '+grp' );
			float angle = Jass::LoadReal( GameHT, hid, 'angl' );
			float dist = Jass::LoadReal( GameHT, hid, 'edst' ) + 100.f;
			float x = Jass::MathPointProjectionX( Jass::LoadReal( GameHT, hid, 'srcX' ), angle, dist );
			float y = Jass::MathPointProjectionY( Jass::LoadReal( GameHT, hid, 'srcY' ), angle, dist );

			Jass::SaveReal( GameHT, hid, 'edst', dist );

			for ( int i = 0; i < 2; i++ )
			{
				float efAngle = Jass::GetRandomReal( 0.f, 360.f );
				float efDist = Jass::GetRandomReal( 0.f, 500.f );
				float efX = Jass::MathPointProjectionX( x, efAngle, efDist );
				float efY = Jass::MathPointProjectionY( y, efAngle, efDist );

				Jass::DestroyEffect( CreateEffectEx( "Characters\\Akainu\\magmablast2.mdl", efX, efY, 120.f, Jass::GetRandomReal( 0.f, 360.f ), .5f, 1.f ) );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "abilities\\weapons\\catapult\\catapultmissile.mdl", efX, efY ) );
			}

			float dmg = 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 500.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) && !Jass::IsUnitInGroup( u, g ) )
				{
					ACF_DamageTarget( source, u, dmg );
					ACF_StunUnit( u, 1.f );
					Jass::GroupAddUnit( g, u );
				}
			}

			if ( dist >= 1500.f )
			{
				Jass::DestroyGroup( g );
				ReleaseTimer( tmr );
			}
		}
	}

	void Akainu_T( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'T1' );
			HandleListCleanEffects( Jass::LoadHandleList( GameHT, hid, 'elst' ), true, true );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			ACF_StunUnit( source, 50 * .025f );
			PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
			Jass::SetUnitAnimation( source, "Spell" );
			Jass::SaveHandleList( GameHT, hid, 'elst', Jass::HandleListCreate( ) );
			// "Characters\\Akainu\\moon_shin_dph12.mdl"
		}
		else if ( ticks >= 10 )
		{
			handlelist eflist = Jass::LoadHandleList( GameHT, hid, 'elst' );
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );

			if ( CounterEx( hid, 0, 5 ) )
			{
				int count = Jass::LoadInteger( GameHT, hid, 'cout' );

				if ( count < 50 )
				{
					float dist = Jass::GetRandomReal( 0.f, 550.f );
					float face = Jass::GetRandomReal( 0.f, 360.f );

					effect ef = CreateEffectEx( "Characters\\Akainu\\moon_shin_dph12.mdl", Jass::MathPointProjectionX( targX, face, dist ), Jass::MathPointProjectionY( targY, face, dist ), 1000.f, Jass::GetRandomReal( 0.f, 360.f ), .4f, .0f );
					Jass::SetSpecialEffectAnimationOffsetPercent( ef, .75f );
					//Jass::SetSpecialEffectPitch( ef, Jass::GetRandomReal( -10.f, -45.f ) );
					Jass::HandleListAddHandle( eflist, ef );

					Jass::SaveInteger( GameHT, hid, 'cout', count + 1 );
				}
			}

			int maxCount = Jass::HandleListGetEffectCount( eflist );

			for ( int i = 0; i < maxCount; i++ )
			{
				effect ef = Jass::HandleListGetEffectByIndex( eflist, i );
				float x = Jass::GetSpecialEffectX( ef );
				float y = Jass::GetSpecialEffectY( ef );
				float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
				float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
				float newHeight = Jass::GetSpecialEffectHeight( ef ) - Jass::GetRandomReal( 15.f, 25.f );

				if ( dist >= 20.f )
				{
					Jass::SetSpecialEffectX( ef, Jass::MathPointProjectionX( x, angle, 20.f ) );
					Jass::SetSpecialEffectY( ef, Jass::MathPointProjectionY( y, angle, 20.f ) );
				}
				Jass::SetSpecialEffectHeight( ef, newHeight );

				if ( newHeight <= .0f )
				{
					player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
					unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
					float dmg = 25.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true ) * .05f;
					Jass::GroupEnumUnitsInRange( GroupEnum, Jass::GetSpecialEffectX( ef ), Jass::GetSpecialEffectY( ef ), 500.f, nil );

					for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
					{
						if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
						{
							ACF_DamageTarget( source, u, dmg );
						}
					}

					Jass::HandleListRemoveHandle( eflist, ef );
					Jass::SetSpecialEffectTimeScale( ef, 1.f );
					Jass::DestroyEffect( ef );
					maxCount--;
					i--;
				}
			}

			if ( maxCount == 0 )
			{
				HandleListCleanEffects( Jass::LoadHandleList( GameHT, hid, 'elst' ), true, true );
				ReleaseTimer( tmr );
			}
		}
	}
	//

	// Reinforce Spells
	void Reinforce_Q( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( StopSpell( hid, 0, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'Q1' );

			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );
			effect ef;

			PlayHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'Q1', 60.f, .0f );

			ef = CreateEffectEx( "Characters\\Reinforce\\BlackHole.mdl", targX, targY, .0f, 270.f, 1.2f, 1.f );
			SetEffectTimedLife( ef, 1.f );

			ef = CreateEffectEx( "Characters\\SaberAlter\\DarkExplosion.mdl", targX, targY, .0f, 270.f, 1.2f, 1.f );
			SetEffectTimedLife( ef, 3.f );
		}
		else
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );

			Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					float x = Jass::GetUnitX( u );
					float y = Jass::GetUnitY( u );
					float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY ) + 60.f;

					SetUnitXY( u, Jass::MathPointProjectionX( x, angle, 10.f ), Jass::MathPointProjectionY( y, angle, 10.f ) );
				}
			}

			if ( ticks >= 100 )
			{
				effect ef;

				ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, 50.f, 270.f, 5.f, 2.f );
				SetEffectTimedLife( ef, 3.f );

				ef = CreateEffectEx( "Characters\\Reinforce\\firaga6.mdl", targX, targY, 75.f, 270.f, 4.f, .8f );
				SetEffectTimedLife( ef, 3.f );

				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

				Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
					{
						float x = Jass::GetUnitX( u );
						float y = Jass::GetUnitY( u );
						float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );

						if ( ACF_DamageTarget( source, u, dmg ) )
						{
							Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		
		if ( StopSpell( hid, 1, true ) )
		{
			StopHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'W1' );
			HandleListCleanEffects( Jass::LoadHandleList( GameHT, hid, 'elst' ), true, true );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			handlelist hl = Jass::HandleListCreate( );

			PlayHeroSound( source, 'psnd' + 'W1', 60.f, .0f );
			Jass::SaveHandleList( GameHT, hid, 'elst', hl );

			for ( int i = 0; i < 20; i++ )
			{
				float face = 36.f * i;
				float dist = Jass::GetRandomReal( 100.f, 1000.f );
				float x = Jass::MathPointProjectionX( targX, face, dist );
				float y = Jass::MathPointProjectionY( targY, face, dist );
				float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
				float height = Jass::GetRandomReal( 500.f, 1000.f );

				effect ef;

				ef = CreateEffectEx( "Characters\\NanayaShiki\\REffect.mdl", x, y, height, angle, 1.5f, 1.f );
				Jass::SetSpecialEffectColour( ef, 0xFFFF0000 );
				Jass::SetSpecialEffectPitch( ef, -45.f );

				Jass::HandleListAddHandle( hl, ef );

				ef = CreateEffectEx( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", x, y, height, angle, 1.f, 1.f );
				Jass::SetSpecialEffectColour( ef, 0xFFFF0000 );
				Jass::DestroyEffect( ef );
			}
		}
		else if ( ticks >= 100 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			handlelist eflist = Jass::LoadHandleList( GameHT, hid, 'elst' );

			for ( int i = 0; i < Jass::HandleListGetEffectCount( eflist ); i++ )
			{
				effect ef = Jass::HandleListGetEffectByIndex( eflist, i );
				Jass::SetSpecialEffectFacing( ef, Jass::MathAngleBetweenPoints( Jass::GetSpecialEffectX( ef ), Jass::GetSpecialEffectY( ef ), targX, targY ) );
				Jass::SetSpecialEffectX( ef, targX );
				Jass::SetSpecialEffectY( ef, targY );
				Jass::SetSpecialEffectHeight( ef, .0f );
			}

			float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
			ACF_StunUnit( target, 1 );
			ACF_DamageTarget( source, target, dmg );
			HandleListCleanEffects( Jass::LoadHandleList( GameHT, hid, 'elst' ), true, true );
			ReleaseTimer( tmr );
		}
	}

	void Reinforce_E( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( StopSpell( hid, 0 ) ) { return; }

		if ( ticks == 0 )
		{
			PlayHeroSound( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), 'psnd' + 'E1', 60.f, .0f );
		}
		else if ( ticks == 100 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );
			effect ef;

			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", targX, targY ) );
			Jass::DestroyEffect( Jass::AddSpecialEffect( "Characters\\Reinforce\\ApocalypseStomp.mdx", targX, targY ) );

			ef = CreateEffectEx( "GeneralEffects\\moonwrath.mdl", targX, targY, 0.f, .0f, 4.f, 1.f );
			Jass::SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, .0f, .0f, 2.5f, .75f );
			SetEffectTimedLife( ef, 4.f );

			float dmg = 60.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
			Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 450.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					if ( ACF_DamageTarget( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), u, dmg ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

		if ( StopSpell( hid, 1, true ) )
		{
			StopHeroSound( source, 'psnd' + 'R1' );
			ReleaseTimer( tmr );
			return;
		}

		int ticks = SpellTickEx( hid );
		unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );

		if ( ticks == 0 )
		{
			PlayHeroSound( source, 'psnd' + 'R1', 60.f, .0f );
			ACF_StunUnit( source, .25f );
			Jass::SetUnitPathing( source, false );
			Jass::SetUnitAnimation( source, "walk" );
		}

		if ( CounterEx( hid, 0, 10 ) )
		{
			ACF_StunUnit( source, .10f );
			//ACF_DisableUnitTP( target, .10f ); // this adds up
		}

		float x = Jass::GetUnitX( source );
		float y = Jass::GetUnitY( source );
		float targX = Jass::GetUnitX( target );
		float targY = Jass::GetUnitY( target );
		float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
		float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
		float moveX = Jass::MathPointProjectionX( x, angle, 20.f );
		float moveY = Jass::MathPointProjectionY( y, angle, 20.f );

		if ( dist > 150.f )
		{
			Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
			SetUnitXY( source, moveX, moveY );
			Jass::SetUnitFacingInstant( source, angle );
		}
		else
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			effect ef;

			ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 50.f, angle, 1.5f, 2.f );
			Jass::SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.5f, 2.f );
			Jass::SetSpecialEffectPitch( ef, -90.f );
			SetEffectTimedLife( ef, 3.f );

			Jass::GroupEnumUnitsInRange( GroupEnum, Jass::GetUnitX( target ), Jass::GetUnitY( target ), 400.f, nil );
			float dmg = 150.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( ticks == 0 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
			Jass::SaveReal( GameHT, hid, 'disp', 800 );
			ACF_DisableUnitTP( source, 3.f );
			ACF_StunUnit( source, 3.f );
			Jass::SetUnitAnimation( source, "spell channel" );
		}

		if ( ticks < 70 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

			if ( Jass::IsUnitDead( source ) )
			{
				Jass::StopSound( Jass::LoadSoundHandle( SoundHT, Jass::GetHandleId( source ), 'psnd' + 'T1' ), false, false );
				Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, 'A04K' ), .01f );
				RemoveEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' + 0 ) );

				ReleaseTimer( tmr );
				return;
			}

			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );
			float mangl = Jass::LoadReal( GameHT, hid, 'disp' );

			DisplaceCircular( p, targX, targY, 450.f, mangl, 2.5f, "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl" );

			Jass::SaveReal( GameHT, hid, 'disp', mangl - 16.f );
		}
		else if ( ticks == 70 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			effect ef = CreateEffectEx( "Characters\\Reinforce\\CosmicField.mdl", Jass::LoadReal( GameHT, hid, 'trgX' ), Jass::LoadReal( GameHT, hid, 'trgY' ), .0f, .0f, 5.f, 1.f );
			//Jass::SetSpecialEffectAnimation( ef, "birth" );
			Jass::SaveEffectHandle( GameHT, hid, '+eff' + 0, ef );

			Jass::SetUnitAnimation( source, "attack slam" );
		}
		else if ( ticks == 120 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float facing = Jass::GetUnitFacing( source );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			effect ef;

			Jass::SetUnitAnimation( source, "spell channel" );

			for ( int i = 1; i < 6; i++ )
			{
				ef = CreateEffectEx( "Characters\\Reinforce\\mfqwd.mdl", x, y, .0f, .0f, 1.f * i, .05f * i );
				Jass::SetSpecialEffectColour( ef, 0xFFFF32FF ); // green = 50
				SetEffectTimedLife( ef, 1.8f );
			}

			float targX = Jass::MathPointProjectionX( x, Jass::GetUnitFacing( source ), 130.f );
			float targY = Jass::MathPointProjectionY( y, Jass::GetUnitFacing( source ), 130.f );

			ef = CreateEffectEx( "Characters\\Reinforce\\t_xuliyy.mdl", targX, targY, 30.f, .0f, 1.f, 1.f );
			Jass::SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
			SetEffectTimedLife( ef, 2.f ); // 3.6f
		}
		else if ( ticks == 280 )
		{
			Jass::SetUnitAnimation( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), "spell slam" );
		}
		else if ( ticks == 300 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
			float targY = Jass::LoadReal( GameHT, hid, 'trgY' );
			float dmg = 400.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
			effect ef;

			ef = CreateEffectEx( "Characters\\Reinforce\\ShadowExplosion.mdl", targX, targY, 50.f, .0f, 10.f, 1.f );
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\moonwrath.mdl", targX, targY, 0.f, .0f, 10.f, 1.f );
			Jass::SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
			SetEffectTimedLife( ef, 4.f );

			ef = CreateEffectEx( "GeneralEffects\\apocalypsecowstomp.mdl", targX, targY, 0.f, .0f, 3.5f, 1.f );
			Jass::SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
			SetEffectTimedLife( ef, 3.f );

			Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 900.f, nil );

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
				{
					ACF_DamageTarget( source, u, dmg );
					ACF_StunUnit( u, 1.f );
					DisplaceWar3ImageLinear( u, Jass::MathAngleBetweenPoints( targX, targY, Jass::GetUnitX( u ), Jass::GetUnitY( u ) ), 300.f, 1.f, .01f, false, false );
				}
			}

			RemoveEffect( Jass::LoadEffectHandle( GameHT, hid, '+eff' + 0 ) );
			ReleaseTimer( tmr );
		}
	}
	//

	// Arcueid Spells
	void Arcueid_Q( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( !StopSpell( hid, 0 ) )
		{
			int ticks = SpellTickEx( hid );

			if ( ticks == 0 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

				PlayHeroSound( source, 'psnd' + 'Q1', 100.f, .0f );
				ACF_StunUnit( source, .25f );
				Jass::SetUnitTimeScale( source, 2 );
				Jass::SetUnitAnimation( source, "Spell One" );
			}
			else if ( ticks == 20 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float dmg = 250.f + Jass::GetHeroLevel( source ) * 70.f + Jass::GetHeroInt( source, true );
				float x = Jass::LoadReal( GameHT, hid, 'srcX' );
				float y = Jass::LoadReal( GameHT, hid, 'srcY' );

				PlayHeroSound( source, 'gsnd' + 0, 100.f, .0f );
				Jass::GroupEnumUnitsInRange( GroupEnum, Jass::LoadReal( GameHT, hid, 'trgX' ), Jass::LoadReal( GameHT, hid, 'trgY' ), 300.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitEnemy( u, Jass::GetOwningPlayer( source ) ) )
					{
						float u_x = Jass::GetUnitX( u );
						float u_y = Jass::GetUnitY( u );
						float angle = Jass::MathAngleBetweenPoints( x, y, u_x, u_y );

						DisplaceUnitWithArgs( u, angle, -300.f, .5f, .01f, 250.f );
						ACF_DamageTarget( source, u, dmg );
						Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", u_x, u_y ) );
					}
				}

				Jass::SetUnitTimeScale( source, 1.f );
				ReleaseTimer( tmr );
			}
		}
	}

	void Arcueid_W( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( !StopSpell( hid, 0 ) )
		{
			if ( ticks == 0 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

				PlayHeroSound( source, 'psnd' + 'W1', 100.f, .0f );

				ACF_StunUnit( source, .4f );
				Jass::SetUnitTimeScale( source, 1.75f );
				Jass::SetUnitAnimation( source, "Spell Five" );
			}
			if ( ticks == 10 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );

				for ( int i = 0; i < 5; i++ )
				{
					effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, .0f, Jass::GetRandomReal( 1.5f, 2.f ), 1.5f );
					Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
					SetEffectTimedLife( ef, 4.f );
				}
			}
			else if ( ticks == 25 )
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				float dmg = 350.f + 60.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

				Jass::GroupEnumUnitsInRange( GroupEnum, x, y, 450.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
					{
						float targX = Jass::GetUnitX( u );
						float targY = Jass::GetUnitY( u );
						float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );

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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( !StopSpell( hid, 0 ) )
		{
			if ( ticks == 0 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, .0f, 1.5f, 1.5f );
				
				SetEffectTimedLife( ef, 4.f );
				ACF_StunUnit( source, .25f );
				Jass::SetUnitAnimation( source, "Attack Two" );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", x, y ) );
			}
			else if ( ticks == 15 )
			{
				Jass::ShowUnit( Jass::LoadUnitHandle( GameHT, hid, 'usrc' ), false );
			}
			else if ( ticks >= 25 )
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
				float targY = Jass::LoadReal( GameHT, hid, 'trgY' );
				float dmg = 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

				PlayHeroSound( source, 'gsnd' + 3, 60.f, .0f );
				SetUnitXY( source, targX, targY );
				Jass::ShowUnit( source, true );
				ACF_SelectUnit( source, p );
				Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 400.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
					{
						ACF_DamageTarget( source, u, dmg );
						ACF_StunUnit( u, 1.f );
					}
				}

				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\SlamEffect.mdx", targX, targY ) );

				for ( int i = 0; i < 3; i++ )
				{
					effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", targX, targY, .0f, .0f, Jass::GetRandomReal( 1.5f, 2.f ), 1.5f );
					Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
					SetEffectTimedLife( ef, 4.f );
				}

				ReleaseTimer( tmr );
			}
		}
	}

	void Arcueid_R( )
	{
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );
		int ticks = SpellTickEx( hid );

		if ( !StopSpell( hid, 0 ) )
		{
			if ( ticks == 0 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				
				ACF_StunUnit( source, .8f );
				Jass::SetUnitTimeScale( source, 1.75f );
				Jass::SetUnitAnimation( source, "Attack Slam" );

				ACF_DisableUnitTP( target, .8f );
			}
			else if ( ticks == 15 )
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
				float x = Jass::GetUnitX( source );
				float y = Jass::GetUnitY( source );
				float targX = Jass::GetUnitX( target );
				float targY = Jass::GetUnitY( target );
				float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
				float dmg = Jass::GetHeroLevel( source ) * 150 + Jass::GetHeroInt( source, true ) * .5f;

				effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, angle, 1.5f, 1.5f );
				Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
				SetEffectTimedLife( ef, 4.f );

				PlayHeroSound( source, 'gsnd' + 1, 60.f, .0f );
				ACF_DamageTarget( source, target, dmg );
				SetUnitFlyHeightEx( target, 600.f, 4000.f );
			}
			else if ( ticks == 25 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );
			}
			else if ( ticks == 30 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

				SetUnitFlyHeightEx( source, 700.f, 4000.f );
				Jass::SetUnitAnimation( source, "Attack Two" );
			}
		}

		if ( ticks == 60 )
		{
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float targX = Jass::GetUnitX( target );
			float targY = Jass::GetUnitY( target );
			float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
			float dmg = Jass::GetHeroLevel( source ) * 50 + Jass::GetHeroInt( source, true ) * .5f;

			effect ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 800.f, angle, 1.5f, 1.5f );
			Jass::SetSpecialEffectPitch( ef, -90.f );
			Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
			SetEffectTimedLife( ef, 4.f );

			ACF_DamageTarget( source, target, dmg );
			SetUnitFlyHeightEx( target, 0, 2000.f );
			SetUnitFlyHeightEx( source, 0, 99999.f );
			DisplaceWar3ImageLinear( target, angle, 250.f, .2f, .01f, false, false );
		}
		else if ( ticks >= 80 )
		{
			player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
			unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
			unit target = Jass::LoadUnitHandle( GameHT, hid, 'utrg' );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float dmg = 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
			effect ef;
			
			ef = CreateEffectEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f, 1.f );
			SetEffectTimedLife( ef, 1.f );

			for ( int i = 0; i < 3; i++ )
			{
				ef = CreateEffectEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, .0f, Jass::GetRandomReal( 1.5f, 2.f ), 1.5f );
				Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
				SetEffectTimedLife( ef, 4.f );
			}

			for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
			{
				if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
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
		timer tmr = Jass::GetExpiredTimer( );
		int hid = Jass::GetHandleId( tmr );

		if ( !StopSpell( hid, 0 ) )
		{
			int ticks = SpellTickEx( hid );

			if ( ticks == 0 )
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float x = Jass::LoadReal( GameHT, hid, 'srcX' );
				float y = Jass::LoadReal( GameHT, hid, 'srcY' );

				PlayHeroSound( source, 'psnd' + 'T1', 100.f, .0f );
				ACF_StunUnit( source, .5f );
				SetEffectTimedLife( Jass::AddSpecialEffect( "GeneralEffects\\ValkDust.mdl", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ), 4.f );
				Jass::SetUnitAnimation( source, "Spell Six" );

				Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", x, y ) );
			}
			else if ( ticks == 25 )
			{
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

				Jass::ShowUnit( source, false );
				SetUnitXY( source, Jass::LoadReal( GameHT, hid, 'trgX' ), Jass::LoadReal( GameHT, hid, 'trgY' ) );
			}
			else if ( ticks == 45 )
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
				float targY = Jass::LoadReal( GameHT, hid, 'trgY' );
				float dmg = 200.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
	
				Jass::GroupEnumUnitsInRange( GroupEnum, targX, targY, 600.f, nil );

				for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
				{
					if ( Jass::IsUnitEnemy( u, p ) )
					{
						for ( int i = 0; i < 3; i++ )
						{
							effect ef = CreateEffectEx( "GeneralEffects\\ShortSlash\\ShortSlash.mdl", Jass::GetUnitX( u ), Jass::GetUnitY( u ), Jass::GetUnitFlyHeight( u ) + 50.f, i * Jass::GetRandomInt( 60, 90 ), Jass::GetRandomReal( .75f, 1.f ), Jass::GetRandomReal( .75f, 1.f ) );
							Jass::DestroyEffect( ef );
						}

						ACF_DamageTarget( source, u, dmg );
						Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
						Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "head" ) );
					}
				}
			}
			else if ( ticks == 50 )
			{
				player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
				unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
				float targX = Jass::LoadReal( GameHT, hid, 'trgX' );
				float targY = Jass::LoadReal( GameHT, hid, 'trgY' );

				Jass::ShowUnit( source, true );
				Jass::SetUnitAnimation( source, "Stand" );
				ACF_SelectUnit( source, p );

				for ( int i = 0; i < 3; i++ )
				{
					effect ef = Jass::AddSpecialEffect( "GeneralEffects\\ValkDust.mdl", targX, targY );
					Jass::SetSpecialEffectScale( ef, 2.f );
					Jass::SetSpecialEffectTimeScale( ef, Jass::GetRandomReal( .5f, 2.f ) );
					SetEffectTimedLife( ef, 4.f );
				}

				ReleaseTimer( tmr );
			}
		}
	}
	//

	void TeleportToSavedLocation( player p )
	{
		int pid = Jass::GetPlayerId( p );
		int p_hid = Jass::GetHandleId( p );
		float targX = Jass::LoadReal( DataHT, p_hid, '+tpX' );
		float targY = Jass::LoadReal( DataHT, p_hid, '+tpY' );
		unit u = MUnitArray[pid];

		Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffYou have been teleported to saved position" );
		Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
		SetUnitXY( u, targX, targY );
		Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", targX, targY ) );
		ACF_PanCameraToTimed( p, targX, targY, .0f );
	}

	timer Spells_Handler( ability abil, unit source, unit target, float targX, float targY, CallbackFunc@ act )
	{
		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );
		int aid = Jass::GetAbilityTypeId( abil );
		int alvl = Jass::GetAbilityLevel( abil );
		int lvl = Jass::GetHeroLevel( source );
		int uid = Jass::GetUnitTypeId( source );
		player p = Jass::GetOwningPlayer( source );
		float x = Jass::GetUnitX( source );
		float y = Jass::GetUnitY( source );
		float facing = Jass::GetUnitFacing( source );
		float angle = facing;

		Jass::SaveInteger( GameHT, hid, 'utid', uid );
		Jass::SaveInteger( GameHT, hid, 'ulvl', lvl );
		Jass::SaveInteger( GameHT, hid, 'atid', aid );
		Jass::SaveInteger( GameHT, hid, 'alvl', alvl );

		Jass::SaveReal( GameHT, hid, 'srcX', Jass::GetUnitX( source ) );
		Jass::SaveReal( GameHT, hid, 'srcY', Jass::GetUnitY( source ) );
		Jass::SaveReal( GameHT, hid, 'face', facing );

		Jass::SavePlayerHandle( GameHT, hid, '+ply', p );
		Jass::SaveAbilityHandle( GameHT, hid, 'abil', abil );
		Jass::SaveUnitHandle( GameHT, hid, 'usrc', source );

		if ( target != nil )
		{
			Jass::SaveUnitHandle( GameHT, hid, 'utrg', target );
			targX = Jass::GetUnitX( target );
			targY = Jass::GetUnitY( target );
		}

		Jass::SaveReal( GameHT, hid, 'angl', x == targX && y == targY ? facing : Jass::MathAngleBetweenPoints( x, y, targX, targY ) );
		Jass::SaveReal( GameHT, hid, 'dist', Jass::MathDistanceBetweenPoints( x, y, targX, targY ) );
		Jass::SaveReal( GameHT, hid, 'trgX', targX );
		Jass::SaveReal( GameHT, hid, 'trgY', targY );

		if ( !( act is null ) )
		{
			Jass::TimerStart( tmr, .01f, true, act );
		}
		
		return tmr;
	}

	timer Spells_Handler( CallbackFunc@ act )
	{
		return Spells_Handler( nil, nil, nil, .0f, .0f, act );
	}

	bool IsStopCast( unit target, float targX, float targY )
	{
		return target == nil && Jass::IsTerrainPathable( targX, targY, Jass::PATHING_TYPE_WALKABILITY );
	}

	void OnAnyItemPick( )
	{
		int charges = 0;
		int max = 2;
		unit u = Jass::GetTriggerUnit( );
		player p = Jass::GetOwningPlayer( u );
		item itm = Jass::GetManipulatedItem( );
		int iid = Jass::GetItemTypeId( itm );

		if ( Jass::GetItemPlayer( itm ) == Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE ) )
		{
			Jass::SetItemPlayer( itm, p, false );
		}

		if ( Jass::GetItemPlayer( itm ) != p )
		{
			Jass::UnitRemoveItem( u, itm );
			Jass::DisplayTextToPlayer( p, .0f, .0f, "|c00ffff00That is not your Item!|r" );
			return;
		}

		if ( Jass::GetItemCharges( itm ) > 0 ) // if stacked item
		{
			for ( int i = 0; i < 6; i++ )
			{
				item itm_tmp = Jass::UnitItemInSlot( u, i ); if ( itm_tmp == itm || Jass::GetItemTypeId( itm ) != Jass::GetItemTypeId( itm_tmp ) ) { continue; }

				if ( Jass::GetItemCharges( itm_tmp ) + Jass::GetItemCharges( itm ) <= max )
				{
					charges = Jass::GetItemCharges( itm_tmp ) + Jass::GetItemCharges( itm );
					Jass::SetItemCharges( itm_tmp, charges );
					Jass::RemoveItem( itm );
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
					timer tmr = Jass::CreateTimer( );
					int hid = Jass::GetHandleId( tmr );

					Jass::SavePlayerHandle( GameHT, hid, '+ply', p );
					Jass::SaveUnitHandle( GameHT, hid, 'usrc', u );
				
					Jass::TimerStart
					(
						tmr,
						1.f,
						true,
						function( )
						{
							timer tmr = Jass::GetExpiredTimer( );
							int hid = Jass::GetHandleId( Jass::GetExpiredTimer( ) );
							unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );

							if ( Jass::IsUnitAlive( source ) && ACF_UnitHasItemById( source, 'I00P' ) )
							{
								player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
								float x = Jass::GetUnitX( source );
								float y = Jass::GetUnitY( source );
								float aoe = 300.f;
								float dmg = 30.f + 10.f * Jass::GetHeroLevel( source );
								
								Jass::GroupEnumUnitsInRange( GroupEnum, x, y, aoe, nil );

								for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
								{
									if ( Jass::IsUnitEnemy( u, p ) && !Jass::IsUnitInvisible( u, p ) )
									{
										ACF_DamageTarget( source, u, dmg );
										Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedDamage.mdl", u, "chest" ) );
									}
								}
							}
							else
							{
								Jass::PauseTimer( tmr );
								Jass::FlushChildHashtable( GameHT, hid );
								Jass::DestroyTimer( tmr );
							}
						}
					);
				}

				break;
			}
			case 'I02R': // Item Certificate
			{
				int piid = Jass::LoadInteger( DataHT, Jass::GetUnitTypeId( u ), 'pitm' );
				Jass::RemoveItem( itm );

				if ( Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD ) >= 10000 )
				{
					if ( ACF_CountItems( u, piid ) == 0 )
					{
						Jass::UnitAddItemById( u, piid );
						Jass::SetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD, Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD ) - 10000 );
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

				timer tmr = Jass::CreateTimer( );
				int hid = Jass::GetHandleId( tmr );

				Jass::SavePlayerHandle( GameHT, hid, '+ply', p );
				Jass::SaveUnitHandle( GameHT, hid, 'usrc', u );
				Jass::SaveInteger( GameHT, hid, 'cost', goldCost );
				Jass::SaveInteger( GameHT, hid, '+sts', statBonus );
				Jass::SaveInteger( GameHT, hid, 'styp', statType );

				Jass::TimerStart
				(
					tmr,
					.01f,
					true, 
					function( )
					{
						timer tmr = Jass::GetExpiredTimer( );
						int hid = Jass::GetHandleId( tmr );
						player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
						unit u = Jass::LoadUnitHandle( GameHT, hid, 'usrc' );
						int gold = Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD );
						int cost = Jass::LoadInteger( GameHT, hid, 'cost' );

						if ( cost <= gold )
						{
							Jass::SetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD, gold - cost );

							int statBonus = Jass::LoadInteger( GameHT, hid, '+sts' );

							switch( Jass::LoadInteger( GameHT, hid, 'styp' ) )
							{
								case '+str': Jass::SetHeroStr( u, Jass::GetHeroStr( u, false ) + statBonus, true ); break;
								case '+agi': Jass::SetHeroAgi( u, Jass::GetHeroAgi( u, false ) + statBonus, true ); break;
								case '+int': Jass::SetHeroInt( u, Jass::GetHeroInt( u, false ) + statBonus, true ); break;
							}
						}
						else
						{
							Jass::PauseTimer( tmr );
							Jass::FlushChildHashtable( GameHT, hid );
							Jass::DestroyTimer( tmr );
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
				Jass::RemoveItem( ACF_GetItemById( u, 'I03U' ) );
				Jass::RemoveItem( ACF_GetItemById( u, 'I03U' ) );
				Jass::UnitAddItemById( u, 'I00Y' );
			}
		}
		else if ( ACF_CountItems( u, 'I03X' ) > 0 && ACF_CountItems( u, 'I03Z' ) > 0 && ACF_CountItems( u, 'I03U' ) > 0 )
		{
			Jass::RemoveItem( ACF_GetItemById( u, 'I03U' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I03Z' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I03X' ) );
			Jass::UnitAddItemById( u, 'I00X' );
		}
		else if ( ACF_CountItems( u, 'I03V' ) > 0 && ACF_CountItems( u, 'I03Z' ) > 0 )
		{
			Jass::RemoveItem( ACF_GetItemById( u, 'I03V' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I03Z' ) );
			Jass::UnitAddItemById( u, 'I00R' );
		}
		else if ( ACF_CountItems( u, 'I03X' ) > 0 && ACF_CountItems( u, 'I03Y' ) > 0 )
		{
			Jass::RemoveItem( ACF_GetItemById( u, 'I03Y' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I03X' ) );
			Jass::UnitAddItemById( u, 'I00S' );
		}
		else if ( ACF_CountItems( u, 'I03Y' ) > 0 && ACF_CountItems( u, 'I03V' ) > 0 )
		{
			Jass::RemoveItem( ACF_GetItemById( u, 'I03Y' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I03V' ) );
			Jass::UnitAddItemById( u, 'I00Z' );
		}
		else if ( ACF_CountItems( u, 'I03X' ) > 0 && ACF_CountItems( u, 'I03W' ) > 0 )
		{
			Jass::RemoveItem( ACF_GetItemById( u, 'I03X' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I03W' ) );
			Jass::UnitAddItemById( u, 'I00U' );
		}
		else if ( ACF_CountItems( u, 'I00Q' ) > 0 && ACF_CountItems( u, 'I00K' ) > 0 )
		{
			Jass::RemoveItem( ACF_GetItemById( u, 'I00Q' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I00K' ) );
			Jass::UnitAddItemById( u, 'I00R' );
		}
		else if ( ACF_CountItems( u, 'I00Q' ) > 0 && ACF_CountItems( u, 'I00N' ) > 0 )
		{
			Jass::RemoveItem( ACF_GetItemById( u, 'I00Q' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I00N' ) );
			Jass::UnitAddItemById( u, 'I00S' );
		}
		else if ( ACF_CountItems( u, 'I00O' ) > 0 && ACF_CountItems( u, 'I00I' ) > 0 )
		{
			Jass::RemoveItem( ACF_GetItemById( u, 'I00O' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I00I' ) );
			Jass::UnitAddItemById( u, 'I00U' );
		}
		else if ( ACF_CountItems( u, 'I00N' ) > 0 && ACF_CountItems( u, 'I00K' ) > 0 )
		{
			Jass::RemoveItem( ACF_GetItemById( u, 'I00N' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I00K' ) );
			Jass::UnitAddItemById( u, 'I00Z' );
		}
		else if ( ACF_CountItems( u, 'I02Q' ) > 0 && ACF_CountItems( u, 'I00J' ) > 0 && Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD ) >= 3800 )
		{
			Jass::SetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD, Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD ) - 3800 );
			Jass::RemoveItem( ACF_GetItemById( u, 'I02Q' ) );
			Jass::RemoveItem( ACF_GetItemById( u, 'I00J' ) );
			Jass::UnitAddItemById( u, 'I00T' );
		}
		else if ( ACF_CountItems( u, 'I01K' ) > 0 && ACF_CountItems( u, 'I01S' ) > 0 )
		{
			if ( Jass::GetItemCharges( ACF_GetItemById( u, 'I01S' ) ) == 1 && Jass::GetItemCharges( ACF_GetItemById( u, 'I01K' ) ) == 1 )
			{
				Jass::RemoveItem( ACF_GetItemById( u, 'I01S' ) );
				Jass::RemoveItem( ACF_GetItemById( u, 'I01K' ) );
				Jass::UnitAddItemById( u, 'I01T' );
			}
			else if ( Jass::GetItemCharges( ACF_GetItemById( u, 'I01S' ) ) == 2 && Jass::GetItemCharges( ACF_GetItemById( u, 'I01K' ) ) == 1 )
			{
				Jass::RemoveItem( ACF_GetItemById( u, 'I01S' ) );
				Jass::RemoveItem( ACF_GetItemById( u, 'I01K' ) );
				Jass::UnitAddItemById( u, 'I01T' );
				Jass::UnitAddItemById( u, 'I01S' );
			}
			else if ( Jass::GetItemCharges( ACF_GetItemById( u, 'I01S' ) ) == 1 && Jass::GetItemCharges( ACF_GetItemById( u, 'I01K' ) ) == 2 )
			{
				Jass::RemoveItem( ACF_GetItemById( u, 'I01S' ) );
				Jass::RemoveItem( ACF_GetItemById( u, 'I01K' ) );
				Jass::UnitAddItemById( u, 'I01T' );
				Jass::UnitAddItemById( u, 'I01K' );
			}
			else if ( Jass::GetItemCharges( ACF_GetItemById( u, 'I01S' ) ) == 2 && Jass::GetItemCharges( ACF_GetItemById( u, 'I01K' ) ) == 2 )
			{
				Jass::RemoveItem( ACF_GetItemById( u, 'I01S' ) );
				Jass::RemoveItem( ACF_GetItemById( u, 'I01K' ) );
				Jass::UnitAddItemById( u, 'I01T' );
				Jass::UnitAddItemById( u, 'I01T' );
			}
		}
	}

	bool OnProcessItemState( item itm )
	{
		if ( Jass::GetItemLife( itm ) <= .0f )
		{
			Jass::RemoveItem( itm );
			return true;
		}

		return false;
	}

	void OnAnyItemDrop( )
	{
		item itm = Jass::GetManipulatedItem( );

		if ( OnProcessItemState( itm ) ) { return; }


	}

	void OnAnyItemUsed( )
	{
		unit source = Jass::GetTriggerUnit( );
		player p = Jass::GetOwningPlayer( source );
		int pid = Jass::GetPlayerId( p );
		float x = Jass::GetUnitX( source );
		float y = Jass::GetUnitY( source );
		item itm = Jass::GetManipulatedItem( );
		int iid = Jass::GetItemTypeId( itm );

		switch( iid )
		{
			case 'I01T': // Shadow Scroll
			{
				unit clone = Jass::CreateIllusionFromUnitEx( source, true ); // 'I01U'
				Jass::SetIllusionDamageDealt( clone, .0f );
				Jass::SetIllusionDamageReceived( clone, 1.f );
				Jass::UnitApplyTimedLife( clone, 'BTLF', 25.f );

				break;
			}
			case 'I01S': // Red Tablet
			{
				unit clone = Jass::CreateIllusionFromUnitEx( source, true ); // 'I00M'
				Jass::SetIllusionDamageDealt( clone, .0f );
				Jass::SetIllusionDamageReceived( clone, 1.f );
				Jass::UnitApplyTimedLife( clone, 'BTLF', 20.f );

				break;
			}
			case 'I003': // Scroll of Teleportation
			{
				if ( IsUnitCCed( source ) || Jass::IsUnitPaused( source ) )
				{
					Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffUnable to teleport!" );
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
				Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", x, y ) );

				unit dummy = Jass::CreateUnit( p, 'n000', x, y, 270.f );
				Jass::SetUnitInvulnerable( source, true );
				Jass::PauseUnit( source, true );
				Jass::ShowUnit( source, false );
				Jass::UnitApplyTimedLife( dummy, 'BOmi', 3.f );

				break;
			}
		}
	}

	void OnAnySpellAction( )
	{
		ability abil = Jass::GetSpellAbility( );
		unit source = Jass::GetTriggerUnit( );
		player p = Jass::GetOwningPlayer( source );
		unit target = Jass::GetSpellTargetUnit( );
		float targX = Jass::GetSpellTargetX( );
		float targY = Jass::GetSpellTargetY( );
		float delay = .0f;
		int aid = Jass::GetAbilityTypeId( abil );
		int hid = 0;
		eventid evId = Jass::GetTriggerEventId( );
		timer tmr;

		if ( evId == Jass::EVENT_PLAYER_UNIT_SPELL_CAST )
		{
			if ( aid == 'A01W' ) // Anti-TP stone
			{
				if ( Jass::GetUnitTypeId( target ) == 'H02M' )
				{
					Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffInvalid target!" );
					return;
				}
			}

			if ( aid == 'A021' || aid == 'A00X' )
			{

			}
			else
			{
				Jass::UnitRemoveAbility( source, 'B018' );
				Jass::UnitRemoveAbility( source, 'Binv' );
			}

			if ( Jass::IsUnitType( source, Jass::UNIT_TYPE_HERO ) && aid != 'A055' && aid != 'A01S' )
			{
				texttag txtTag = Jass::CreateTextTag( );
				float speed = 100.f;
				float angle = 90.f;
				float size = 13.f;
				float vel = speed * 0.071f / 128.f;
				float xvel = vel * Jass::Cos( Jass::Deg2Rad( angle ) );
				float yvel = vel * Jass::Sin( Jass::Deg2Rad( angle ) );
				float textHeight = size * 0.023f / 10.f;

				Jass::SetTextTagText( txtTag, Jass::GetObjectName( aid ), textHeight );
				Jass::SetTextTagColor( txtTag, 255, 0, 0, 100 );
				Jass::SetTextTagPosUnit( txtTag, source, 50 );
				Jass::SetTextTagVelocity( txtTag, xvel, yvel );
				Jass::SetTextTagPermanent( txtTag, false );
				Jass::SetTextTagLifespan( txtTag, 2.f );
				Jass::SetTextTagFadepoint( txtTag, .25f );
			}

			if ( Jass::LoadBoolean( GameHT, aid, 'PATH' ) && Jass::IsTerrainPathable( targX, targY, Jass::PATHING_TYPE_WALKABILITY ) ) // flag is inversed in the engine...
			{
				Jass::IssueImmediateOrder( source, "stop" );
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
						Jass::PauseUnit( Jass::CreateUnit( p, 'n002', targX + Jass::GetRandomReal( -125.f, 125.f ), targY + Jass::GetRandomReal( -125.f, 125.f ), Jass::GetRandomReal( 0.f, 360.f ) ), true );
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

		// if ( tmr == nil || !Jass::TimerIsPaused( tmr ) ) { return; }
	}
	//

	void InitHero( unit u )
	{
		int hid = Jass::GetHandleId( u );

		if ( u == nil || Jass::LoadBoolean( GameHT, hid, 'INIT' ) ) { return; }

		int uid = Jass::GetUnitTypeId( u );

		switch( uid )
		{
			case 'H00A': // Nanaya
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, ACF_CreateSound( "GeneralSounds\\GlassShatterSound.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellV.mp3"  ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellQ.mp3"  ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellW.wav"  ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellE1.wav" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E2', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellE2.wav" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellR1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellR2.wav" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellT1.wav" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellT2.wav" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T3', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellT3.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			case 'H00B': // Toono
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, ACF_CreateSound( "GeneralSounds\\GlassShatterSound.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundV1.mp3"  ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellQ.mp3"  ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundW1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E2', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundE2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E3', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundE3.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundR1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundR2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R3', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundR3.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundT1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', ACF_CreateSound( "Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundT2.mp3" ) );
					
					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			case 'H00C': // Ryougi
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 0, ACF_CreateSound( "GeneralSounds\\BloodFlow.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellDSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellQSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellWSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellESound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellRSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellRSound2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellTSound1.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			case 'H00D': // Saber Alter
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterC1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterQ1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterQ2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterW1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterW2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W3', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterW3.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterE1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterE2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterR1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterR2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterT1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterT2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T3', ACF_CreateSound( "Characters\\SaberAlter\\Sounds\\SaberAlterT3.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			case 'H00E': // Saber Nero
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, ACF_CreateSound( "GeneralSounds\\GlassShatterSound.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundQ1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundW1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundE1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundR2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\SaberNero\\Sounds\\SaberNeroSoundT1.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				timer tmr = Jass::CreateTimer( );
				int t_hid = Jass::GetHandleId( tmr );
				Jass::SaveUnitHandle( GameHT, t_hid, 'usrc', u );
				Jass::TimerStart
				(
					tmr,
					1.f,
					true,
					function( )
					{
						int hid = Jass::GetHandleId( Jass::GetExpiredTimer( ) );
						unit source = Jass::LoadUnitHandle( GameHT, hid, 'usrc' ); if ( Jass::IsUnitDead( source ) ) { return; }
						float hpMax = Jass::GetUnitMaxLife( source );
						float hpCur = Jass::GetUnitCurrentLife( source );
						Jass::SetUnitCurrentLife( source, ( hpMax - hpCur ) * .04f + hpCur );
					}
				);

				break;
			}
			case 'H00F': // Kuchiki Byakuya
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellDSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellQSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellQSound2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellWSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellESound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellRSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellRSound2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellTSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellTSound2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellTSound3.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			case 'H00G': // Akame
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 0, ACF_CreateSound( "GeneralSounds\\BloodFlow.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellDSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellQSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellWSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellESound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellRSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellRSound2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Akame\\Sounds\\AkameSpellTSound1.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			case 'H00H': // Scathach
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, ACF_CreateSound( "GeneralSounds\\GlassShatterSound.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellQFirstSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q2', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellQSecondSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q3', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellQThirdSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellWSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellESound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellRSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellRSound2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Scathach\\Sounds\\ScathachSpellTSound1.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			case 'H00I': // Akainu
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellDSound.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellQSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellWSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellESound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellRSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellRSound2.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Akainu\\Sounds\\AkainuSpellTSound1.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			case 'H00J': // Reinforce
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellQSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellWSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellESound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellCSound1.mp3" ) ); // R1
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellRSound1.mp3" ) ); // R2
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Reinforce\\Sounds\\ReinforceSpellTSound1.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			case 'H00K': // Arcueid
			{
				if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 0, ACF_CreateSound( "GeneralSounds\\BloodFlow.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, ACF_CreateSound( "GeneralSounds\\KickSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 3, ACF_CreateSound( "GeneralSounds\\SlamSound.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
				}

				if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
				{
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellQSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellWSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellESound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellRSound1.mp3" ) );
					Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', ACF_CreateSound( "Characters\\Arcueid\\Sounds\\ArcueidSpellTSound1.mp3" ) );

					Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
				}

				if ( !Jass::LoadBoolean( GameHT, uid, 'INIT' ) )
				{
					Jass::SaveBoolean( GameHT, 'A02A', 'PATH', true );
					Jass::SaveBoolean( GameHT, 'A026', 'PATH', true );

					Jass::SaveBoolean( GameHT, uid, 'INIT', true );
				}

				break;
			}
			default: return;
		}

		if ( !Jass::LoadBoolean( GameHT, hid, 'INIT' ) )
		{
			HeroProcessAbilityDisplay( u, true );

			Jass::SaveBoolean( GameHT, hid, 'INIT', true );
		}
	}

	void OnAnyChatEvent( )
	{
		player p = Jass::GetTriggerPlayer( );
		int pid = Jass::GetPlayerId( p );
		int p_team = Jass::GetPlayerTeam( p );
		string msg = Jass::GetEventPlayerChatString( );
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
					int p_hid = Jass::GetHandleId( p );

					if ( !Jass::LoadBoolean( DataHT, p_hid, 'ISTP' ) ) { return; }

					int tpCD = Jass::LoadInteger( GameHT, p_hid, 'tptm' );
					unit hero = MUnitArray[pid];

					if ( IsUnitCCed( hero ) || Jass::IsUnitPaused( hero ) )
					{
						Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffUnable to teleport!" );
					}
					else
					{
						if ( tpCD == 0 )
						{
							timer tmr = Jass::CreateTimer( );
							int hid = Jass::GetHandleId( tmr );

							Jass::SavePlayerHandle( GameHT, hid, '+ply', p );
							Jass::SaveInteger( GameHT, p_hid, 'tptm', 30 );

							TeleportToSavedLocation( p );

							Jass::TimerStart
							(
								tmr,
								1.f,
								true, 
								function( )
								{
									timer tmr = Jass::GetExpiredTimer( );
									int hid = Jass::GetHandleId( tmr );
									player p = Jass::LoadPlayerHandle( GameHT, hid, '+ply' );
									int p_hid = Jass::GetHandleId( p );
									int cd = Jass::LoadInteger( GameHT, p_hid, 'tptm' ) - 1;

									if ( cd > 0 )
									{
										Jass::SaveInteger( GameHT, p_hid, 'tptm', cd );
									}
									else
									{
										Jass::SaveInteger( GameHT, p_hid, 'tptm', 0 );
										Jass::PauseTimer( tmr );
										Jass::FlushChildHashtable( GameHT, hid );
										Jass::DestroyTimer( tmr );
									}
								}
							);
						}
						else
						{
							Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c00ffff00Teleportation Cooldown: " + Jass::I2S( tpCD ) + " seconds|r|c00ff0000!|r" );
						}
					}

					break;
				}
				else if ( cmd == "combinations" )
				{
					Jass::DisplayTimedTextToPlayer( p, 0.f, 0.f, 10.f, "*Mithril Shield+Champion Belt = |c0000ff00Gold Shield|r
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
						Jass::DisplayTextToPlayer( p, 0, 0, "Health display by text is: |c0000ffffOn|r" );
					}
					else
					{
						Jass::DisplayTextToPlayer( p, 0, 0, "Health display by text is: |c00ff0000Off|r" );
					}

					HealthDisplayBooleanArray[pid] = !HealthDisplayBooleanArray[pid];
				}
				else if ( cmd == "2" )
				{
					if ( !ESCLocationSaveBooleanArray[pid] )
					{
						Jass::DisplayTextToPlayer( p, 0, 0, "Push ESC to save current position function is: |c0000ffffActivated|r" );
					}
					else
					{
						Jass::DisplayTextToPlayer( p, 0, 0, "Push ESC to save current position function is: |c00ff0000Deactivated|r" );
					}

					ESCLocationSaveBooleanArray[pid] = !ESCLocationSaveBooleanArray[pid];
				}
				else if ( cmd == "3" )
				{
					int p_hid = Jass::GetHandleId( p );

					Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffDisplaying the saved position" );
					if ( Jass::GetLocalPlayer( ) == p )
					{
						ACF_PingMinimap( p, Jass::LoadReal( DataHT, p_hid, '+tpX' ), Jass::LoadReal( DataHT, p_hid, '+tpY' ), false );
					}
				}
				else if ( cmd == "4" )
				{
					Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffDisplaying the saved position" );

					if ( Jass::GetLocalPlayer( ) == p )
					{
						for ( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
						{
							player p_other = Jass::Player( i ); if ( p == p_other || !Jass::IsPlayerAlly( p, p_other ) || Jass::GetPlayerSlotState( p ) != Jass::PLAYER_SLOT_STATE_PLAYING ) { continue; }
							int p_hid = Jass::GetHandleId( p_other );
							ACF_PingMinimap( p, Jass::LoadReal( DataHT, p_hid, '+tpX' ), Jass::LoadReal( DataHT, p_hid, '+tpY' ), false );
						}
					}
				}
				else if ( cmd == "commands" )
				{
					Jass::DisplayTextToPlayer( p, 0.f, 0.f, "|c0080ff00-testcommands|r: |c0000ffffDisplays available test commands|r.
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
					Jass::DisplayTextToPlayer( p, 0.f, 0.f, "|c0080ff00-nc|r: |c0000ffffRemoves cooldowns on abilities|r.
					|c0080ff00-heroes|r: |c0000ffffGrants you all heroes available in the game|r.
					|c0080ff00-gold|r: |c0000ffffGrants you 100000000 gold when used|r.
					|cFFFFCC00-level XX|r: |c0000ffffSets the level of selected u to XX|r.
					|c0080ff00-nocreep|r: |c0000ffffStops mobs spawning on mid|r.
					|c0080ff00-testunit|r: |c0000ffffSpawns a unit, that has a lot of hp|r." );
				}
				else if ( cmd == "contacts" )
				{
					Jass::DisplayTextToPlayer( p, 0.f, 0.f, "|cFFFFCC00Map Maker and Contact Info:|r Unryze ( https://vk.com/acfwc3 / https://vendev.info/ )

					|cFFFFCC00Helpers:|r Andutrache, Nelu_o, Maou, Sanyabane and Saasura" );
				}
				else if ( cmd == "non" || cmd == "noff" )
				{
					bool isEnable = cmd == "non";

					if ( isEnable )
					{
						Jass::DisplayTextToPlayer( p, .0f, .0f, "|c0000FF00Notifications have been enabled!" );
					}
					else
					{
						Jass::DisplayTextToPlayer( p, .0f, .0f, "|c00ff0000Notifications have been disabled!" );
					}
					
					Jass::SaveBoolean( DataHT, Jass::GetHandleId( p ), 'ntfc', isEnable );
				}
				else if ( cmd == "clear" )
				{
					if ( Jass::GetLocalPlayer( ) == p ) { Jass::ClearTextMessages( ); }
				}

				if ( TestCommandEnabled )
				{
					if ( cmd == "nc" )
					{
						bool toggleMode = true;
						bool isEnabled = TMR_ResetCD != nil ? Jass::TimerIsPaused( TMR_ResetCD ) : true;

						if ( TMR_ResetCD == nil )
						{
							TMR_ResetCD = Jass::CreateTimer( );
							toggleMode = false;
							Jass::TimerStart
							(
								TMR_ResetCD,
								.01f,
								true,
								function( )
								{
									Jass::GroupEnumUnitsInRect
									(
										GroupEnum,
										worldBounds, 
										Jass::Condition
										( 
											function( )
											{
												return Jass::IsUnitHero( Jass::GetFilterUnit( ) );
											}
										)
									);

									for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
									{
										if ( Jass::GetPlayerId( Jass::GetOwningPlayer( u ) ) >= Jass::PLAYER_NEUTRAL_AGGRESSIVE ) { continue; }
										Jass::UnitResetCooldown( u );
									}
								}
							);
						}

						Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 10.f, isEnabled ? "|c0000FF00No-CoolDown Mode Operation Enabled!" : "|c00ff0000No-CoolDown Mode Operation Disabled!" );

						if ( !toggleMode ) { return; }

						Jass::TimerIsPaused( TMR_ResetCD ) ? Jass::ResumeTimer( TMR_ResetCD ) : Jass::PauseTimer( TMR_ResetCD );
					}
					else if ( cmd == "nocreep" )
					{
						if ( B_IsCreepSpawn )
						{
							Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c00ff0000Creeps on mid will no longer spawn.|r" );
						}
						else
						{
							Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ff00Creeps on mid will start to spawn.|r" );
						}

						B_IsCreepSpawn = !B_IsCreepSpawn;
					}
					else if ( cmd == "testunit" )
					{
						Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ff00Test unit created.|r" );
						Jass::CreateUnit( Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE ), 'tstu', 0.f, -500.f, 270.f );
					}
				}

				break;
			}
		}
	}

	void DefaultCommandsTriggers( )
	{
		TriggerAPI::RegisterPlayerEvent( Jass::CreateTrigger(), Jass::EVENT_PLAYER_END_CINEMATIC, null, @ESCToSaveAction );
		TriggerAPI::RegisterChatEvent( Jass::CreateTrigger(), "", false, null, @OnAnyChatEvent );
		TriggerAPI::RegisterPlayerUnitEvent( Jass::CreateTrigger(), Jass::EVENT_PLAYER_UNIT_SELECTED, null, @HealthDisplayReaderAction );
	}

	void CreateLocalTimers( )
	{
		Jass::TimerStart
		(
			Jass::CreateTimer( ),
			30.f,
			true, 
			function( )
			{
				Jass::UnitResetCooldown( Jass::LoadUnitHandle( DataHT, 'BOSS', 'unit' ) );

				player p = Jass::GetLocalPlayer( );
				int hid = Jass::GetHandleId( p );

				if ( Jass::LoadBoolean( DataHT, hid, 'ntfc' ) )
				{
					Jass::DisplayTextToPlayer( p, 0.f, 0.f, "|c0080ff00-commands|r: |c0000ffffdisplays available in-game commands|r.
					|c0080ff00-testcommands|r: |c0000ffffdisplays available in-game test commands|r.
					|c0080ff00-noff/-non|r: |c0000ffffdisables/enables -commands notification|r." );
				}
			}
		);
	}

	void GameTriggers( )
	{

		TriggerAPI::RegisterDialogEvent( TR_SelectionMode = Jass::CreateTrigger(), ModeSelectionDialog, null, @ModeSelectionFunction2 );
		TriggerAPI::RegisterDialogEvent( Jass::CreateTrigger(), KillSelectionDialog, null, @KillSelectionDialogAction );

		{
			trigger t = Jass::CreateTrigger( );

			for ( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
			{
				player p = Jass::Player( i );

				if ( Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING && Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_USER )
				{
					TotalPlayers++;
					TeamPlayers[ Jass::GetPlayerTeam( p ) ]++;
				}

				Jass::TriggerRegisterPlayerAllianceChange( t, p, Jass::ALLIANCE_SHARED_CONTROL );
			}
			Jass::TriggerAddAction( t, @DisableSharedUnitsAct );
		}

		TriggerAPI::RegisterTimerEvent( Jass::CreateTrigger(), .0f, false, null, @MultiBoardCreationFunction1 );
		TriggerAPI::RegisterPlayerEvent( Jass::CreateTrigger(), Jass::EVENT_PLAYER_LEAVE, null, @RegisterPlayerLeaveAction );

		TriggerAPI::RegisterPlayerUnitEvent( Jass::CreateTrigger(), Jass::EVENT_PLAYER_HERO_LEVEL, null, @OnHeroLevel );
		TriggerAPI::RegisterPlayerUnitEvent( Jass::CreateTrigger(), Jass::EVENT_PLAYER_UNIT_PICKUP_ITEM, null, @OnAnyItemPick );
		TriggerAPI::RegisterPlayerUnitEvent( Jass::CreateTrigger(), Jass::EVENT_PLAYER_UNIT_DROP_ITEM, null, @OnAnyItemDrop );
		TriggerAPI::RegisterPlayerUnitEvent( Jass::CreateTrigger(), Jass::EVENT_PLAYER_UNIT_USE_ITEM, null, @OnAnyItemUsed );

		{
			trigger t = Jass::CreateTrigger();
			TriggerAPI::RegisterPlayerUnitEvent( t, Jass::EVENT_PLAYER_UNIT_SPELL_CAST, null, @OnHeroLevel );
			TriggerAPI::RegisterPlayerUnitEvent( t, Jass::EVENT_PLAYER_UNIT_SPELL_EFFECT, null, @OnHeroLevel );
		}
		
		TriggerAPI::RegisterPlayerUnitEvent
		(
			Jass::CreateTrigger(),
			Jass::EVENT_PLAYER_UNIT_PROJECTILE_HIT,
			null,
			function()
			{
				projectile proj = Jass::GetTriggerProjectile( );
				int pr_hid = Jass::GetHandleId( proj );
				unit source = Jass::GetTriggerProjectileSource( );
				unit target = Jass::GetTriggerProjectileTargetUnit( );
				int aid = Jass::LoadInteger( GameHT, pr_hid, 'atid' );

				switch( aid )
				{
					case 'A04B': // Akainu E
					{
						break;
					}
				}

				Jass::FlushChildHashtable( GameHT, pr_hid );
			}
		);

		TriggerAPI::RegisterPlayerUnitEvent( Jass::CreateTrigger(), Jass::EVENT_PLAYER_UNIT_DAMAGED, null, @OnPlayerUnitDamaged );

		{
			trigger t = Jass::CreateTrigger();
			TriggerAPI::RegisterPlayerUnitEvent( t, Jass::EVENT_PLAYER_UNIT_SELECTED, null, @HeroSelectionAction );
			Jass::DisableTrigger( t );
			TR_HeroSelection = t;
		}

		TriggerAPI::RegisterGameEvent( Jass::CreateTrigger(), Jass::EVENT_GAME_WIDGET_DEATH, null, @OnAnyWidgetDeath );
	}

	void AllRegions( )
	{
		CircleRectArr[0] = Jass::Rect( -2688.f, 704.f, -2432.f, 960.f ); // TL
		CircleRectArr[1] = Jass::Rect( -2688.f, -1920.f, -2432.f, -1600.f ); // BL
		CircleRectArr[2] = Jass::Rect( -672.f, -1184.f, 672.f, 160.f ); // Center
		CircleRectArr[3] = Jass::Rect( 2464.f, -1920.f, 2720.f, -1600.f ); // TR
		CircleRectArr[4] = Jass::Rect( 2464.f, 704.f, 2720.f, 960.f ); // BR
		
		array<int> shopList = { 'mtk3', 'mtk4', 'mtk5', 'mtk1', 'mtk2' };

		for ( int team = 0; team < 2; team++ )
		{
			unit u = Jass::CreateUnit( Jass::Player( 10 + team ), 'base', team == 0 ? -4350.f : 4350.f, -500.f, 270.f );
			Jass::SetUnitVertexColor( u, 255, 255, 255, 75 );

			for ( uint i = 0; i < CircleRectArr.length( ); i++ )
			{
				float x = team == 0 ? -5184.f : 5120.f;
				float y = -256.f * i;
				float targX = Jass::GetRectCenterX( CircleRectArr[i] );
				float targY = Jass::GetRectCenterY( CircleRectArr[i] );

				u = Jass::CreateUnit( Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE ), 'wgt1', x, y, 270.f );

				Jass::WaygateSetDestination( u, targX, targY );
				Jass::CreateUnit( Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE ), 'cofp', targX, targY, 270.f );
				Jass::WaygateActivate( u, true );
			}

			for ( uint i = 0; i < shopList.length( ); i++ )
			{
				int typeId = shopList[i];

				float x = 4032.f + ( i <= 1 ? i * 356.f : ( i - 2 ) * 256.f );
				float y = i <= 1 ? -128.f : -1088.f;

				u = Jass::CreateUnit( Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE ), typeId, team == 0 ? -x : x, y, 270.f );
			}
		}

		trigger t;
		region reg;
		rect rec;

		worldBounds = Jass::GetWorldBounds( );

		t = Jass::CreateTrigger( );

		reg = Jass::CreateRegion( );
		rec = Jass::Rect( -5440.f, -1440.f, -3520.f, 480.f );
		Jass::RegionAddRect( reg, rec );
		Jass::SetRect( rec, 3520.f, -1440.f, 5440.f, 480.f );
		Jass::RegionAddRect( reg, rec );
		Jass::TriggerRegisterEnterRegion( t, reg, nil );
		Jass::TriggerAddAction
		(
			t, 
			function( )
			{
				OnAnyUnitEnterRegion( Jass::GetEnteringUnit( ), Jass::GetTriggeringRegion( ), nil );
			}
		);
		Jass::SaveRegionHandle( DataHT, 'regs', 'BASE', reg );
		Jass::RemoveRect( rec );

		t = Jass::CreateTrigger( );
		reg = Jass::CreateRegion( );
		Jass::RegionAddRect( reg, CircleRectArr[0] ); // TL
		Jass::TriggerRegisterEnterRegion( t, reg, nil );
		Jass::TriggerAddAction
		(
			t, 
			function( )
			{
				OnAnyUnitEnterRegion( Jass::GetEnteringUnit( ), Jass::GetTriggeringRegion( ), CircleRectArr[0] );
			}
		);

		t = Jass::CreateTrigger( );
		reg = Jass::CreateRegion( );
		Jass::RegionAddRect( reg, CircleRectArr[1] ); // BL
		Jass::TriggerRegisterEnterRegion( t, reg, nil );
		Jass::TriggerAddAction
		(
			t, 
			function( )
			{
				OnAnyUnitEnterRegion( Jass::GetEnteringUnit( ), Jass::GetTriggeringRegion( ), CircleRectArr[1] );
			}
		);

		t = Jass::CreateTrigger( );
		reg = Jass::CreateRegion( );
		Jass::RegionAddRect( reg, CircleRectArr[3] ); // TR
		Jass::TriggerRegisterEnterRegion( t, reg, nil );
		Jass::TriggerAddAction
		(
			t, 
			function( )
			{
				OnAnyUnitEnterRegion( Jass::GetEnteringUnit( ), Jass::GetTriggeringRegion( ), CircleRectArr[3] );
			}
		);

		t = Jass::CreateTrigger( );
		reg = Jass::CreateRegion( );
		Jass::RegionAddRect( reg, CircleRectArr[4] ); // BR
		Jass::TriggerRegisterEnterRegion( t, reg, nil );
		Jass::TriggerAddAction
		(
			t, 
			function( )
			{
				OnAnyUnitEnterRegion( Jass::GetEnteringUnit( ), Jass::GetTriggeringRegion( ), CircleRectArr[4] );
			}
		);
	}

	void CreateAllUnits( )
	{
		player p = Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
		unit u = Jass::CreateUnit( p, Jass::LoadInteger( DataHT, Jass::GetRandomInt( 1, TotalHeroes ), 'type' ), 0.f, -3900.f, 90.f ); // boss
		Jass::SaveUnitHandle( DataHT, 'BOSS', 'unit', u );

		InitHero( u );
		Jass::SetHeroLevel( u, 50, false );
		HeroUnlockAbilities( u );
		Jass::SetHeroStr( u, 5000, false );
		Jass::SetHeroAgi( u, 5000, false );
		Jass::SetHeroInt( u, 5000, false );
		Jass::UnitAddAbility( u, 'A017' );
		Jass::UnitAddAbility( u, 'A02F' );
		Jass::UnitAddItemById( u, 'I03S' );
		Jass::UnitAddItemById( u, 'I00S' );
		Jass::UnitAddItemById( u, 'I00U' );
		Jass::UnitAddItemById( u, 'I00H' );
		Jass::UnitAddItemById( u, 'I00T' );
		Jass::UnitAddItemById( u, 'I00R' );
		Jass::SetPlayerHandicapXP( p, 3 );
		StartAI( u );
	}

	void QuestCreationFunction( )
	{
		quest QuestCreation = Jass::CreateQuest( );
		Jass::QuestSetTitle( QuestCreation, "|cFFFFCC00Gameplay Information|r" );
		Jass::QuestSetDescription( QuestCreation, "|c0000ffffWhen you kill 8 bosses on the lanes you will get -T command|r.
		|cFFFFCC00-T|r: |c0000ffffTeleports you to your|r |cFFFFCC00-save|r |c0000ffff( saved ) location|r.
		|cFFFFCC00-commands|r – |c0000ffffShows in-game commands|r.

		|cFFFFCC00Single Player Test Commands:|r
		|cFFFFCC00-nc|r – |c0000ffffRemoves cooldowns on abilities|r.
		|cFFFFCC00-heroes|r – |c0000ffffSpawns all the heroes on the base|r.
		|cFFFFCC00-gold X|r – |c0000ffffInstantly gives 10000000 gold to player X|r.
		|cFFFFCC00-level X|r – |c0000ffffSets the level of selected u to X|r.
		|cFFFFCC00-nocreep|r – |c0000ffffDisables creep spawn system in the middle|r.
		|cFFFFCC00-testunit|r – |c0000ffffSpawns a test unit for spell testing|r." );
		Jass::QuestSetIconPath( QuestCreation, "Characters\\SaberAlter\\ReplaceableTextures\\CommandButtons\\BTNSaberAlterIcon.blp" );
		Jass::QuestSetRequired( QuestCreation, true );
		Jass::QuestSetDiscovered( QuestCreation, true );
		Jass::QuestSetCompleted( QuestCreation, false );

		QuestCreation = Jass::CreateQuest( );
		Jass::QuestSetTitle( QuestCreation, "|cFFFFCC00Map Credits|r" );
		Jass::QuestSetDescription( QuestCreation, "|c0000ffffThese are the people who have contributed to the map|r:
		|c00FFFF00Andutrache / Nelu_o|r |c00FF0000[FOCS English Team]|r
		|c00FF7F00Space_GlobalTM|r / |c0096FF96gnusik533|r |c0000ffff[ACF Team]|r
		|c00FFFF00Illussionisst / Tekirinmaru / mansuraybov12 / AK-Kisame / brostopchat|r |c006969FF[Bug Reports]|r
		|c00FFFF00brostopchat / Tekirinmaru / Steelvager|r |c006969FF[Map Testers]|r
		|c00FFFF00Kira_Izuru_3th / NN_Dragonforce / steel1606 / Maou / BahaSTI|r |c006969FF[Supporters]|r
		|c00FFFF00Sanyabane|r |c006969FF[Sounds / Textures]|r
		|c00FFFF00Saasura / x10azgmfx / moon_shin / Nagne|r |c006969FF[Animations]|r
		|c00FFFF00Cytyscwyt / Mr.Yagyu|r |c006969FF[Models]|r" );
		Jass::QuestSetIconPath( QuestCreation, "Characters\\SaberNero\\ReplaceableTextures\\CommandButtons\\BTNSaberNeroIcon.blp" );
		Jass::QuestSetRequired( QuestCreation, false );
		Jass::QuestSetDiscovered( QuestCreation, true );
		Jass::QuestSetCompleted( QuestCreation, false );

		QuestCreation = Jass::CreateQuest( );
		Jass::QuestSetTitle( QuestCreation, "|cFFFFCC00Sponsor Sites|r" );
		Jass::QuestSetDescription( QuestCreation, "|cFFFFCC00VK Group|r: |c0000ffffhttps://vk.com/unryzeworkshop|r
		|cFFFFCC00Platform|r: |c0000ffffhttps://warcis.com|r
		|cFFFFCC00Host Bot Forum|r: |c0000ffffhttps://vendev.info|r
		|cFFFFCC00WC3 Models and Maps|r: |c0000ffffhttp://chaosrealm.info|r" );
		Jass::QuestSetIconPath( QuestCreation, "Characters\\Scathach\\ReplaceableTextures\\CommandButtons\\BTNScathachIcon.blp" );
		Jass::QuestSetRequired( QuestCreation, false );
		Jass::QuestSetDiscovered( QuestCreation, true );
		Jass::QuestSetCompleted( QuestCreation, false );
	}

	void MapCameraBounds( )
	{
		float minX = -6144.f + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_LEFT );
		float minY = -5120.f + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_BOTTOM );
		float maxX = 6144.f - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_RIGHT );
		float maxY = 7168.f - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_TOP );

		Jass::SetCameraBounds( minX, minY, maxX, maxY, minX, maxY, maxX, minY );
	}

	void SoloGameDetection( )
	{
		if ( TeamPlayers[0] == 0 || TeamPlayers[1] == 0 )
		{
			SameHeroBoolean = true;
			KillLimit = 999999999;
			B_IsCreepSpawn = false;
			Jass::DestroyTrigger( TR_SelectionMode );
			TestCommandEnabled = true;
			Jass::EnableTrigger( TR_HeroSelection );
			Jass::TimerStart( Jass::CreateTimer( ), 1.f, true, @InGameTimerAction );
		}
		else
		{
			Jass::TimerStart( Jass::CreateTimer( ), 2.f, false, @ModeSelectionFunction1 );
			UnitCreationAction( );
		}
	}

	void MapDataSetting( )
	{
		Jass::SetWaterBaseColor( 255, 255, 255, 255 );
		Jass::SetSkyModel( "Environment\\Sky\\Sky\\SkyLight.mdl" );
		Jass::SetDayNightModels( "Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl" );
		Jass::SetFloatGameState( Jass::GAME_STATE_TIME_OF_DAY, 12.f );
		Jass::SetTimeOfDayScale( 0.f );
		Jass::SuspendTimeOfDay( true );
		Jass::SetTerrainFogEx( 0, 3000.f, 5000.f, .5f, .0f, .0f, .0f );
		Jass::NewSoundEnvironment( "Default" );
		Jass::SetMapMusic( "Music", true, 0 );
		Jass::SetMapFlag( Jass::MAP_LOCK_RESOURCE_TRADING, true );
		Jass::SetMapFlag( Jass::MAP_FOG_HIDE_TERRAIN, true );
		Jass::SetMapFlag( Jass::MAP_SHARED_ADVANCED_CONTROL, false );
		Jass::FogEnable( false );
		Jass::FogMaskEnable( false );
	}

	void InitBuffData( )
	{
		int bid = 'B006';

		Jass::SetBuffBaseRealFieldById( bid, Jass::ABILITY_RLF_DAMAGE_PER_SECOND_POI1, .0f );
		Jass::SetBuffBaseRealFieldById( bid, Jass::ABILITY_RLF_DURATION_HERO, 5.f );
		Jass::SetBuffBaseRealFieldById( bid, Jass::ABILITY_RLF_DURATION_NORMAL, 5.f );
	}

	void Start( )
	{
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

	void Setup()
	{
		Jass::SetPlayers( 10 );
		Jass::SetTeams( 2 );

		for ( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
		{
			if ( i == 8 || i == 9 ) { continue; }
			player p = Jass::Player( i );
			Jass::SetPlayerTeam( p, i > 3 && i != 10 ? 1 : 0 );
			Jass::SetPlayerRaceSelectable( p, false );
			Jass::SetPlayerController( p, i < 10 ? Jass::MAP_CONTROL_USER : Jass::MAP_CONTROL_COMPUTER );
			Jass::SetPlayerRacePreference( p, Jass::RACE_PREF_HUMAN );
		}
	}
}

void main( )
{
	//InitBlizzard( );
	ACF::Start();
}

void config( )
{
	ACF::Setup();
}
