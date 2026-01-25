#include "TriggerAPI.as"
#include "TestDamageEvents.as"
#include "TestSyncHashtable.as"
#include "TestSyncData.as"
#include "TestProjectiles.as"

namespace Mediator
{
    unit uGlobal;
    bool isEnableFog = false;
    hashtable ht = Jass::InitHashtable( );

    void ProcessFog( bool enable )
    {
        Jass::FogEnable( enable );
        Jass::FogMaskEnable( enable );
    }

    void ProcessResources( )
    {
        for ( int i = 0; i < Jass::PLAYER_NEUTRAL_AGGRESSIVE; i++ )
        {
            Jass::SetPlayerState( Jass::Player( i ), Jass::PLAYER_STATE_RESOURCE_GOLD, 500000 );
            Jass::SetPlayerState( Jass::Player( i ), Jass::PLAYER_STATE_RESOURCE_LUMBER, 500000 );
        }
    }

    void main( )
    {
        //Test::Coroutines::Init( );

        ProcessFog( isEnableFog );
        Jass::PanCameraToTimed( 0.f, 0.f, 0.f );
        ProcessResources( );

        Jass::TimerStart
        (
            Jass::CreateTimer( ),
            .01f,
            false,
            function( )
            {
                print( "[INFO]: " + Jass::GetTimeStamp( true, 0 ) + " | Locale: " + Jass::GetLocale( ) + "\n" );
                print( "[GAME_TIME]: " + Jass::GetGameTimeStamp( false, 0 ) + "\n" );
                print( "[GAME_START_TIME]: " + Jass::GetGameTimeStamp( true, 0 ) + "\n" );

                Jass::StartFogHeartbeat( true, .0f );
                Jass::StartPathingHeartbeat( true, .01f );

                uGlobal = Jass::CreateUnit( Jass::Player( 0 ), 'Hpal', -250.f, .0f, .0f );
                Jass::SetUnitBaseDamageByIndex( uGlobal, 0, 5000 );


                Jass::UnitAddAbility( uGlobal, 'A00B' );
                ability abil = Jass::GetUnitAbility( uGlobal, 'A00B' );

                Jass::SetAbilityLevel( abil, 3 );

                for( uint i = 0; i < 3; i++ )
                {
                    Jass::SetAbilityRealLevelField( abil, Jass::ABILITY_RLF_CHANCE_TO_CRITICAL_STRIKE, i, 11. * ( i + 1 ) );
                    Jass::SetAbilityRealLevelField( abil, Jass::ABILITY_RLF_DAMAGE_MULTIPLIER_OCR2, i, 1.11 * ( i + 1 ) );
                }

                Jass::UnitAddAbility( uGlobal, 'A00A' );

                uGlobal = Jass::CreateUnit( Jass::Player( 0 ), 'hpea', .0f, .0f, .0f );

                Jass::UnitAddAbility( uGlobal, 'A00H' );

                Jass::UnitAddAbility( uGlobal, 'AInv' );
                abil = Jass::GetUnitAbility( uGlobal, 'AInv' );

                //print( "abil = " + Jass::GetHandleId( abil ) + "\n" );

                Jass::SetUnitItemSlots( uGlobal, 3 );

                for ( uint i = 0; i < 12; i++ )
                {
                    Jass::CreateItem( i % 2 == 0 ? 'desc' : 'I000', .0f, .0f );
                }

                Jass::SetAbilityBooleanLevelField(abil, Jass::ABILITY_BLF_CAN_DROP_ITEMS, 0, true);
                Jass::SetAbilityBooleanLevelField(abil, Jass::ABILITY_BLF_CAN_GET_ITEMS, 0, true);
                Jass::SetAbilityBooleanLevelField(abil, Jass::ABILITY_BLF_CAN_USE_ITEMS, 0, true);

                //Test::Projectiles::AutoTestProjectileLaunch();

                
                //Test::Sync::Hashtable::Register( Jass::CreateTrigger( ), ht );
                //Test::Sync::Data::Register( Jass::CreateTrigger( ), "SomeData" );
                //Test::Sync::Data::Register( Jass::CreateTrigger( ), "OtherData" );
            }
        );

        Jass::TimerStart
        (
            Jass::CreateTimer( ),
            2.f,
            true,
            function( )
            {
                if ( Jass::IsUnitAlive( uGlobal ) )
                {
                    //Jass::KillUnit( uGlobal );
                }
                else
                {
                    Jass::ReviveUnit( uGlobal, .0f, .0f );
                    //Jass::DestroyTimer( Jass::GetExpiredTimer( ) );
                }

                //Test::Sync::Data::Test( "SomeData", "banana" );
                //Test::Sync::Data::Test( "OtherData", "ananas" );
                //Test::Sync::Hashtable::TestReal( ht );
                //Test::Sync::Hashtable::TestInteger( ht );
            }
        );

    }
}
