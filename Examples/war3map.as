bool SameHeroBoolean = false;
bool TestCommandEnabled = false;
dialog ModeSelectionDialog = Jass::DialogCreate( );
dialog KillSelectionDialog = Jass::DialogCreate( );
group GroupEnum = Jass::CreateGroup( );
hashtable GameHT = Jass::InitHashtable( );
hashtable DispHT = Jass::InitHashtable( );
hashtable VarHT = Jass::InitHashtable( );
hashtable SoundHT = Jass::InitHashtable( );
hashtable AIHT = Jass::InitHashtable( );
int KillLimit = 0;
int TotalPlayers = 0;
int HeroesSelected = 0;
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

namespace ACF
{
	//#include "Scripts\\Blizzard.as"
	#include "Scripts\\API\\Trigger.as"
	#include "Scripts\\API\\General.as"
	#include "Scripts\\API\\Sound.as"
	#include "Scripts\\API\\Spell.as"
	#include "Scripts\\API\\Effect.as"
	#include "Scripts\\API\\War3Image.as"
	#include "Scripts\\API\\DisplacerUnit.as"
	#include "Scripts\\AI\\General.as"

	void GameCreateVariables( )
	{
		for ( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
		{
			player p = Jass::Player( i ); if ( Jass::GetPlayerSlotState( p ) != Jass::PLAYER_SLOT_STATE_PLAYING || Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_COMPUTER ) { continue; }
			int hid = Jass::GetHandleId( p );

			Jass::SaveReal( VarHT, hid, '+tpX', .0f );
			Jass::SaveReal( VarHT, hid, '+tpY', -500.f );
			Jass::SaveReal( VarHT, hid, 'camH', 2000.f );
			Jass::SaveBoolean( VarHT, hid, 'ntfc', true );
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

				Jass::SetCameraField( Jass::CAMERA_FIELD_TARGET_DISTANCE, Jass::LoadReal( VarHT, hid, 'camH' ), 0.f );

				if ( !Jass::LoadBoolean( VarHT, hid, 'HERO' ) )
				{
					Jass::PanCameraToTimed( -1800.f, 5800.f, .0f );
					Jass::SetCameraField( Jass::CAMERA_FIELD_ANGLE_OF_ATTACK, 270., 0.f );
				}
			}
		);
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

	namespace BossSystem
	{
		void InitBossData( uint id, uint uid )
		{
			Jass::SaveInteger( VarHT, 'btid', id, uid );
		}

		unit CreateSide( uint id, uint side )
		{
			unit u = Jass::CreateUnit( Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE ), Jass::LoadInteger( VarHT, 'btid', id ), side == 'lbos' ? -2200.f : 2200.f, 2800.f, 270.f );
			Jass::SaveInteger( VarHT, Jass::GetHandleId( u ), 'side', side );
			Jass::SaveInteger( VarHT, Jass::GetHandleId( u ), 'indx', id );

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

	#include "Scripts\\Characters\\NanayaShiki.as"
	#include "Scripts\\Characters\\ToonoShiki.as"
	#include "Scripts\\Characters\\RyougiShiki.as"
	#include "Scripts\\Characters\\SaberAlter.as"
	#include "Scripts\\Characters\\SaberNero.as"
	#include "Scripts\\Characters\\KuchikiByakuya.as"
	#include "Scripts\\Characters\\Akame.as"
	#include "Scripts\\Characters\\Scathach.as"
	#include "Scripts\\Characters\\Akainu.as"
	#include "Scripts\\Characters\\Reinforce.as"
	#include "Scripts\\Characters\\Arcueid.as"

	void InitHeroData( )
	{
		NanayaShiki::AddData( VarHT );
		ToonoShiki::AddData( VarHT );
		RyougiShiki::AddData( VarHT );
		SaberAlter::AddData( VarHT );
		SaberNero::AddData( VarHT );
		KuchikiByakuya::AddData( VarHT );
		Akame::AddData( VarHT );
		Scathach::AddData( VarHT );
		Akainu::AddData( VarHT );
		Reinforce::AddData( VarHT );
		Arcueid::AddData( VarHT );
	}

	void InitHero( unit u )
	{
		if ( u == nil ) { return; }

		int hid = Jass::GetHandleId( u );
		int uid = Jass::GetUnitTypeId( u );

		switch( uid )
		{
			case NanayaShiki::UNIT_TYPE_ID: 	NanayaShiki::Init( u, GameHT, SoundHT ); break;
			case ToonoShiki::UNIT_TYPE_ID: 		ToonoShiki::Init( u, GameHT, SoundHT ); break;
			case RyougiShiki::UNIT_TYPE_ID: 	RyougiShiki::Init( u, GameHT, SoundHT ); break;
			case SaberAlter::UNIT_TYPE_ID: 		SaberAlter::Init( u, GameHT, SoundHT ); break;
			case SaberNero::UNIT_TYPE_ID: 		SaberNero::Init( u, GameHT, SoundHT ); break;
			case KuchikiByakuya::UNIT_TYPE_ID: 	KuchikiByakuya::Init( u, GameHT, SoundHT ); break;
			case Akame::UNIT_TYPE_ID: 			Akame::Init( u, GameHT, SoundHT ); break;
			case Scathach::UNIT_TYPE_ID: 		Scathach::Init( u, GameHT, SoundHT ); break;
			case Akainu::UNIT_TYPE_ID: 			Akainu::Init( u, GameHT, SoundHT ); break;
			case Reinforce::UNIT_TYPE_ID: 		Reinforce::Init( u, GameHT, SoundHT ); break;
			case Arcueid::UNIT_TYPE_ID: 		Arcueid::Init( u, GameHT, SoundHT ); break;
			default: return;
		}

		Jass::SetUnitFlyHeightEnabled( u, true );

		if ( !Jass::LoadBoolean( GameHT, hid, 'DISP' ) )
		{
			HeroProcessAbilityDisplay( u, true );

			Jass::SaveBoolean( GameHT, hid, 'DISP', true );
		}
	}

	void ReleaseHero( unit u )
	{
		if ( u == nil ) { return; }

		switch( Jass::GetUnitTypeId( u ) )
		{
			case NanayaShiki::UNIT_TYPE_ID: 	NanayaShiki::Release( u ); break;
			case ToonoShiki::UNIT_TYPE_ID: 		ToonoShiki::Release( u ); break;
			case RyougiShiki::UNIT_TYPE_ID: 	RyougiShiki::Release( u ); break;
			case SaberAlter::UNIT_TYPE_ID: 		SaberAlter::Release( u ); break;
			case SaberNero::UNIT_TYPE_ID: 		SaberNero::Release( u ); break;
			case KuchikiByakuya::UNIT_TYPE_ID: 	KuchikiByakuya::Release( u ); break;
			case Akame::UNIT_TYPE_ID: 			Akame::Release( u ); break;
			case Scathach::UNIT_TYPE_ID: 		Scathach::Release( u ); break;
			case Akainu::UNIT_TYPE_ID: 			Akainu::Release( u ); break;
			case Reinforce::UNIT_TYPE_ID: 		Reinforce::Release( u ); break;
			case Arcueid::UNIT_TYPE_ID: 		Arcueid::Release( u ); break;
		}
	}

	void HeroPickArrayCreation( )
	{
		InitHeroData( );

		int size = PickSystem::TotalHeroes + 1;

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

		for ( int i = 0; i < PickSystem::TotalHeroes; i++ )
		{
			if ( ( i % 5 ) == 0 )
			{
				x = -2600.f;
				y -= 100.f;
				x_d = 700.f;
				y_d -= 150.f;
			}

			int id = i + 1;
			int uid = Jass::LoadInteger( VarHT, id, 'type' ); if ( uid == 0 ) { continue; }

			unit u = Jass::CreateUnit( p, 'u013', x, y, 270.f );
			Jass::SetUnitVertexColor( u, 255, 255, 255, 0 );
			Jass::SetUnitUserData( u, id );
			U_SelectionHeroDummyArr[id] = u;
			EF_SelectionIconArray[id] = Jass::AddSpecialEffect( Jass::LoadStr( VarHT, uid, 'imdl' ), x, y );
			
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
			Jass::SaveBoolean( VarHT, Jass::GetHandleId( p ), 'HERO', true );
		}

		if ( team == 0 )
		{
			TeamOneSelected[heroId] = true;
		}
		else
		{
			TeamTwoSelected[heroId] = true;
		}

		int uid = Jass::LoadInteger( VarHT, heroId, 'type' );
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
			AI::Start( u );
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
		Jass::MultiboardSetItemIcon( mbitem, Jass::LoadStr( VarHT, uid, 'icon' ) );
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
			int totalHeroes = PickSystem::TotalHeroes;

			for ( int i = 0; i < 8; i++ )
			{
				player p = Jass::Player( i );
				
				if ( Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING && Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_COMPUTER )
				{
					for ( int rand = Jass::GetRandomInt( 1, totalHeroes ); !TeamOneSelected[rand] && !TeamTwoSelected[rand]; rand = Jass::GetRandomInt( 1, totalHeroes ) )
					{
						MoveHeroToTeamLocation( i, rand );
					}
				}
			}

			for ( int i = 1; i <= totalHeroes; i++ )
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
		int uid = Jass::LoadInteger( VarHT, heroId, 'type' );
		string smdl = "";

		if ( !Jass::LoadBoolean( VarHT, Jass::GetHandleId( p ), 'HERO' ) && Jass::GetUnitTypeId( u ) == 'u013' )
		{
			if ( U_SelectionSelArr[pid] != HeroUnitArray[heroId] )
			{
				float scale = Jass::LoadReal( VarHT, uid, 'size' );

				if ( Jass::GetLocalPlayer( ) == p )
				{
					smdl = Jass::LoadStr( VarHT, uid, 'mmdl' );
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

		for ( int i = 1; i <= PickSystem::TotalHeroes; i++ )
		{
			InitHero( Jass::CreateUnit( p, Jass::LoadInteger( VarHT, i, 'type' ), CenterX, -576.f, 270.f ) );
		}
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

	void OnPlayerUnitDamaged( )
	{
		float dmg = Jass::GetEventDamage( );

		trigger t = Jass::GetTriggeringTrigger( );
		unit source = Jass::GetEventDamageSource( );
		unit target = Jass::GetTriggerUnit( );
		int tid = Jass::GetUnitTypeId( target );

		float multiplier = 1.f;
		float dmgMulti = 0;
		bool isDraw = true;

		Jass::DisableTrigger( t );

		if ( Jass::GetEventIsAttack( ) )
		{
			if ( tid == 'n000' && ( Jass::GetUnitTypeId( source ) == 'base' || Jass::IsUnitType( source, Jass::UNIT_TYPE_HERO ) ) )
			{
				SetUnitXY( KawarimiTriggerUnitArray[Jass::GetPlayerId( Jass::GetOwningPlayer( target ) )], Jass::GetUnitX( source ), Jass::GetUnitY( source ) );
				Jass::UnitApplyTimedLife( target, 'BOmi', .01f );
			}

			switch( Jass::GetUnitTypeId( source ) )
			{
				case Akame::UNIT_TYPE_ID:
				{
					int bid = Akame::BUFF_TYPE_ID;
					buff buf = Jass::GetUnitBuff( target, bid );
					float dur = Jass::GetBuffBaseRealFieldById( bid, Jass::IsUnitHero( target ) ? Jass::ABILITY_RLF_DURATION_HERO : Jass::ABILITY_RLF_DURATION_NORMAL );

					if ( buf == nil )
					{
						Jass::UnitAddBuffById( target, bid );
						buf = Jass::GetUnitBuff( target, bid );
						Akame::PoisonCheck( source, target );
					}

					Jass::SetBuffRemainingDuration( buf, dur );

					break;
				}
				case Arcueid::UNIT_TYPE_ID:
				{
					Jass::SetUnitCurrentLife( source, dmg * .15f + Jass::GetUnitCurrentLife( source ) );

					break;
				}
				case Reinforce::UNIT_TYPE_ID:
				{
					if ( Jass::GetRandomInt( 0, 100 ) <= 15 )
					{
						float x = Jass::GetUnitX( source );
						float y = Jass::GetUnitY( source );
						float targX = Jass::GetUnitX( target );
						float targY = Jass::GetUnitY( target );
						float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
						effect ef;

						ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 50.f, angle, 1.5f, 3.f );
						Jass::SetSpecialEffectPitch( ef, -90.f );
						EffectAPI::SetTimedLife( ef, 4.f );

						ef = EffectAPI::CreateEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.5f, 3.f );
						Jass::SetSpecialEffectPitch( ef, -90.f );
						EffectAPI::SetTimedLife( ef, 3.f );

						dmg = Jass::GetHeroLevel( source ) * 50 + Jass::GetHeroInt( source, true );
						Displacer::Unit::Move( target, angle, 200.f, .25f, .01f, 0 );
						Jass::SetEventDamage( Jass::GetEventDamage( ) + dmg );
					}

					break;
				}
				case Scathach::UNIT_TYPE_ID:
				{
					if ( !Jass::IsUnitType( target, Jass::UNIT_TYPE_HERO ) )
					{
						dmgMulti = 2;
					}
					dmgMulti = .01f * multiplier;
					dmg = .005f * multiplier * Jass::GetUnitMaxLife( target );

					Jass::SetEventDamage( Jass::GetEventDamage( ) + dmg );
					Jass::SetUnitCurrentLife( source, Jass::GetUnitMaxLife( source ) * dmgMulti + Jass::GetUnitCurrentLife( source ) );

					break;
				}
			}

			if ( Jass::GetUnitAbilityLevel( source, ToonoShiki::BUFF_TYPE_ID ) > 0 || Jass::GetUnitAbilityLevel( source, RyougiShiki::BUFF_TYPE_ID ) > 0 )
			{
				if ( Jass::GetUnitAbilityLevel( source, ToonoShiki::BUFF_TYPE_ID ) > 0 )
				{
					dmgMulti = 10;
				}
				else if ( Jass::GetUnitAbilityLevel( source, RyougiShiki::BUFF_TYPE_ID ) > 0 )
				{
					dmgMulti = 20;
				}

				float reqHP = 5.f;

				if ( UnitHasPersonalItem( source, GameHT ) )
				{
					dmgMulti = dmgMulti + dmgMulti / 2;
					reqHP = 10.f;
				}

				dmg = Jass::GetHeroLevel( source ) * dmgMulti + Jass::GetHeroInt( source, true ) * dmgMulti / 100;
				if ( GetUnitStatePercent( target, Jass::UNIT_STATE_LIFE, Jass::UNIT_STATE_MAX_LIFE ) <= reqHP && target != Jass::LoadUnitHandle( VarHT, 'BOSS', 'unit' ) )
				{
					int aid = 0;

					if ( Jass::GetUnitAbilityLevel( source, ToonoShiki::BUFF_TYPE_ID ) > 0 )
					{
						aid = ToonoShiki::D_TYPE_ID;
						Jass::UnitRemoveAbility( source, ToonoShiki::BUFF_TYPE_ID );
					}

					if ( Jass::GetUnitAbilityLevel( source, RyougiShiki::BUFF_TYPE_ID ) > 0 )
					{
						aid = RyougiShiki::D_TYPE_ID;
						Jass::UnitRemoveAbility( source, RyougiShiki::BUFF_TYPE_ID );
					}

					Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, aid ), .01f );

					dmg = 100000000.f;
					float targX = Jass::GetUnitX( target );
					float targY = Jass::GetUnitY( target );

					EffectAPI::SetTimedLife( EffectAPI::CreateEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 1.f, 4.f ), 4.f );
					
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
					Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
				}

				Jass::SetEventDamage( Jass::GetEventDamage( ) + dmg );
			}
		}

		if ( Jass::GetUnitTypeId( source ) == 'base' )
		{
			Jass::SetEventDamage( Jass::GetEventDamage( ) + Jass::GetUnitMaxLife( target ) * .02f );
			isDraw = false;
		}

		if ( tid == 'tstu'  )
		{
			Jass::SetEventDamage( .0f );
			isDraw = false;
		}

		if ( isDraw )
		{
			DamageVisualDrawNumberAction( source, target, Jass::GetEventDamage( ) );
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
					PanCameraToTimed( p, Jass::GetUnitX( u ), Jass::GetUnitY( u ), .0f );
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
						AddBuffTimed( u, 'BPSE', 2.f );
					}

					Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", Jass::GetUnitX( dying ), Jass::GetUnitY( dying ) ) );
					SelectUnit( source, d_p );

					return;
				}

				if ( Jass::IsUnitType( dying, Jass::UNIT_TYPE_HERO ) )
				{
					int d_lvl = Jass::GetHeroLevel( dying );
					unit mainBoss = Jass::LoadUnitHandle( VarHT, 'BOSS', 'unit' );

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
								Jass::SetUnitFlyHeight( u, 0.f, 2000.f );
								SelectUnit( u, p );
								PanCameraToTimed( p, Jass::GetUnitX( u ), Jass::GetUnitY( u ), .2f );

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

					int side = Jass::LoadInteger( VarHT, d_hid, 'side' );

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

						Jass::FlushChildHashtable( VarHT, d_hid );
						
						int id = Jass::LoadInteger( VarHT, d_hid, 'indx' );

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
				unit u = Jass::LoadUnitHandle( VarHT, 'BOSS', 'unit' ); if ( Jass::IsUnitDead( u ) ) { Jass::DestroyTimer( Jass::GetExpiredTimer( ) ); return; }
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

		{
			unit hero = MUnitArray[pid];
			uint32 hid = Jass::GetHandleId( hero );

			ReleaseHero( hero );

			Jass::RemoveUnit( hero );
		}

		
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

		if ( reg == Jass::LoadRegionHandle( VarHT, 'regs', 'BASE' ) )
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
			Jass::SaveReal( VarHT, hid, '+tpX', Jass::GetUnitX( MUnitArray[pid] ) );
			Jass::SaveReal( VarHT, hid, '+tpY', Jass::GetUnitY( MUnitArray[pid] ) );
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
					Jass::UnitAddItemById( u, Jass::LoadInteger( VarHT, Jass::GetUnitTypeId( u ), 'pitm' ) );

					break;
				}
				case 20: Jass::UnitAddItemById( u, 'I03V' ); break;
				case 21: Jass::UnitAddItemById( u, 'I03Z' ); break;
				case 25: Jass::UnitAddItemById( u, 'I00X' ); break;
				case 27: Jass::UnitAddItemById( u, 'I00T' ); break;
			}
		}
	}


	void TeleportToSavedLocation( player p )
	{
		int pid = Jass::GetPlayerId( p );
		int p_hid = Jass::GetHandleId( p );
		float targX = Jass::LoadReal( VarHT, p_hid, '+tpX' );
		float targY = Jass::LoadReal( VarHT, p_hid, '+tpY' );
		unit u = MUnitArray[pid];

		Jass::DisplayTimedTextToPlayer( p, .0f, .0f, 5.f, "|c0000ffffYou have been teleported to saved position" );
		Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
		SetUnitXY( u, targX, targY );
		Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", targX, targY ) );
		PanCameraToTimed( p, targX, targY, .0f );
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
				if ( CountItems( u, iid ) == 1 )
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

							if ( Jass::IsUnitAlive( source ) && UnitHasItemById( source, 'I00P' ) )
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
										DamageTarget( source, u, dmg );
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
				int piid = Jass::LoadInteger( VarHT, Jass::GetUnitTypeId( u ), 'pitm' );
				Jass::RemoveItem( itm );

				if ( Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD ) >= 10000 )
				{
					if ( CountItems( u, piid ) == 0 )
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
			if ( CountItems( u, 'I03U' ) > 1 )
			{
				Jass::RemoveItem( GetItemById( u, 'I03U' ) );
				Jass::RemoveItem( GetItemById( u, 'I03U' ) );
				Jass::UnitAddItemById( u, 'I00Y' );
			}
		}
		else if ( CountItems( u, 'I03X' ) > 0 && CountItems( u, 'I03Z' ) > 0 && CountItems( u, 'I03U' ) > 0 )
		{
			Jass::RemoveItem( GetItemById( u, 'I03U' ) );
			Jass::RemoveItem( GetItemById( u, 'I03Z' ) );
			Jass::RemoveItem( GetItemById( u, 'I03X' ) );
			Jass::UnitAddItemById( u, 'I00X' );
		}
		else if ( CountItems( u, 'I03V' ) > 0 && CountItems( u, 'I03Z' ) > 0 )
		{
			Jass::RemoveItem( GetItemById( u, 'I03V' ) );
			Jass::RemoveItem( GetItemById( u, 'I03Z' ) );
			Jass::UnitAddItemById( u, 'I00R' );
		}
		else if ( CountItems( u, 'I03X' ) > 0 && CountItems( u, 'I03Y' ) > 0 )
		{
			Jass::RemoveItem( GetItemById( u, 'I03Y' ) );
			Jass::RemoveItem( GetItemById( u, 'I03X' ) );
			Jass::UnitAddItemById( u, 'I00S' );
		}
		else if ( CountItems( u, 'I03Y' ) > 0 && CountItems( u, 'I03V' ) > 0 )
		{
			Jass::RemoveItem( GetItemById( u, 'I03Y' ) );
			Jass::RemoveItem( GetItemById( u, 'I03V' ) );
			Jass::UnitAddItemById( u, 'I00Z' );
		}
		else if ( CountItems( u, 'I03X' ) > 0 && CountItems( u, 'I03W' ) > 0 )
		{
			Jass::RemoveItem( GetItemById( u, 'I03X' ) );
			Jass::RemoveItem( GetItemById( u, 'I03W' ) );
			Jass::UnitAddItemById( u, 'I00U' );
		}
		else if ( CountItems( u, 'I00Q' ) > 0 && CountItems( u, 'I00K' ) > 0 )
		{
			Jass::RemoveItem( GetItemById( u, 'I00Q' ) );
			Jass::RemoveItem( GetItemById( u, 'I00K' ) );
			Jass::UnitAddItemById( u, 'I00R' );
		}
		else if ( CountItems( u, 'I00Q' ) > 0 && CountItems( u, 'I00N' ) > 0 )
		{
			Jass::RemoveItem( GetItemById( u, 'I00Q' ) );
			Jass::RemoveItem( GetItemById( u, 'I00N' ) );
			Jass::UnitAddItemById( u, 'I00S' );
		}
		else if ( CountItems( u, 'I00O' ) > 0 && CountItems( u, 'I00I' ) > 0 )
		{
			Jass::RemoveItem( GetItemById( u, 'I00O' ) );
			Jass::RemoveItem( GetItemById( u, 'I00I' ) );
			Jass::UnitAddItemById( u, 'I00U' );
		}
		else if ( CountItems( u, 'I00N' ) > 0 && CountItems( u, 'I00K' ) > 0 )
		{
			Jass::RemoveItem( GetItemById( u, 'I00N' ) );
			Jass::RemoveItem( GetItemById( u, 'I00K' ) );
			Jass::UnitAddItemById( u, 'I00Z' );
		}
		else if ( CountItems( u, 'I02Q' ) > 0 && CountItems( u, 'I00J' ) > 0 && Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD ) >= 3800 )
		{
			Jass::SetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD, Jass::GetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD ) - 3800 );
			Jass::RemoveItem( GetItemById( u, 'I02Q' ) );
			Jass::RemoveItem( GetItemById( u, 'I00J' ) );
			Jass::UnitAddItemById( u, 'I00T' );
		}
		else if ( CountItems( u, 'I01K' ) > 0 && CountItems( u, 'I01S' ) > 0 )
		{
			if ( Jass::GetItemCharges( GetItemById( u, 'I01S' ) ) == 1 && Jass::GetItemCharges( GetItemById( u, 'I01K' ) ) == 1 )
			{
				Jass::RemoveItem( GetItemById( u, 'I01S' ) );
				Jass::RemoveItem( GetItemById( u, 'I01K' ) );
				Jass::UnitAddItemById( u, 'I01T' );
			}
			else if ( Jass::GetItemCharges( GetItemById( u, 'I01S' ) ) == 2 && Jass::GetItemCharges( GetItemById( u, 'I01K' ) ) == 1 )
			{
				Jass::RemoveItem( GetItemById( u, 'I01S' ) );
				Jass::RemoveItem( GetItemById( u, 'I01K' ) );
				Jass::UnitAddItemById( u, 'I01T' );
				Jass::UnitAddItemById( u, 'I01S' );
			}
			else if ( Jass::GetItemCharges( GetItemById( u, 'I01S' ) ) == 1 && Jass::GetItemCharges( GetItemById( u, 'I01K' ) ) == 2 )
			{
				Jass::RemoveItem( GetItemById( u, 'I01S' ) );
				Jass::RemoveItem( GetItemById( u, 'I01K' ) );
				Jass::UnitAddItemById( u, 'I01T' );
				Jass::UnitAddItemById( u, 'I01K' );
			}
			else if ( Jass::GetItemCharges( GetItemById( u, 'I01S' ) ) == 2 && Jass::GetItemCharges( GetItemById( u, 'I01K' ) ) == 2 )
			{
				Jass::RemoveItem( GetItemById( u, 'I01S' ) );
				Jass::RemoveItem( GetItemById( u, 'I01K' ) );
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
			}
		}

		// if ( tmr == nil || !Jass::TimerIsPaused( tmr ) ) { return; }
	}
	//

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

					if ( !Jass::LoadBoolean( VarHT, p_hid, 'ISTP' ) ) { return; }

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
						PingMinimap( p, Jass::LoadReal( VarHT, p_hid, '+tpX' ), Jass::LoadReal( VarHT, p_hid, '+tpY' ), false );
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
							PingMinimap( p, Jass::LoadReal( VarHT, p_hid, '+tpX' ), Jass::LoadReal( VarHT, p_hid, '+tpY' ), false );
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
					
					Jass::SaveBoolean( VarHT, Jass::GetHandleId( p ), 'ntfc', isEnable );
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
				Jass::UnitResetCooldown( Jass::LoadUnitHandle( VarHT, 'BOSS', 'unit' ) );

				player p = Jass::GetLocalPlayer( );
				int hid = Jass::GetHandleId( p );

				if ( Jass::LoadBoolean( VarHT, hid, 'ntfc' ) )
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
			TriggerAPI::RegisterPlayerUnitEvent( t, Jass::EVENT_PLAYER_UNIT_SPELL_CAST, null, @OnAnySpellAction );
			TriggerAPI::RegisterPlayerUnitEvent( t, Jass::EVENT_PLAYER_UNIT_SPELL_EFFECT, null, @OnAnySpellAction );
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
					case Akainu::E_TYPE_ID: // Akainu E
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
		Jass::SaveRegionHandle( VarHT, 'regs', 'BASE', reg );
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
		unit u = Jass::CreateUnit( p, Jass::LoadInteger( VarHT, Jass::GetRandomInt( 1, PickSystem::TotalHeroes ), 'type' ), 0.f, -3900.f, 90.f ); // boss
		Jass::SaveUnitHandle( VarHT, 'BOSS', 'unit', u );

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
		AI::Start( u );
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
		int bid = Akame::BUFF_TYPE_ID;

		Jass::SetBuffBaseRealFieldById( bid, Jass::ABILITY_RLF_DAMAGE_PER_SECOND_POI1, .0f );
		Jass::SetBuffBaseRealFieldById( bid, Jass::ABILITY_RLF_DURATION_HERO, 5.f );
		Jass::SetBuffBaseRealFieldById( bid, Jass::ABILITY_RLF_DURATION_NORMAL, 5.f );
	}

	void Start( )
	{
		Sound::Init( SoundHT );
		War3Image::Init( DispHT );
		Displacer::Unit::Init( DispHT );
		AI::Init( AIHT );

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