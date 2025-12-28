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



                //Test::Projectiles::AutoTestProjectileLaunch();

                
                //Test::Sync::Hashtable::Register( Jass::CreateTrigger( ), ht );
                //Test::Sync::Data::Register( Jass::CreateTrigger( ), "SomeData" );
                //Test::Sync::Data::Register( Jass::CreateTrigger( ), "OtherData" );
            }
        );

        Jass::TimerStart
        (
            Jass::CreateTimer( ),
            .5f,
            false,
            function( )
            {
                //Test::Sync::Data::Test( "SomeData", "banana" );
                //Test::Sync::Data::Test( "OtherData", "ananas" );
                //Test::Sync::Hashtable::TestReal( ht );
                //Test::Sync::Hashtable::TestInteger( ht );
            }
        );

    }
}