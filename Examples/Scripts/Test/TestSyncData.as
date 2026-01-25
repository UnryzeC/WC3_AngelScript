#include "TriggerAPI.as"

namespace Test::Sync::Data
{
    trigger trig = nil;

    void Register( trigger t, string prefix, bool fromServer = false )
    {
        TriggerAPI::RegisterPlayerSyncEvent
        (
            t,
            prefix,
            fromServer,
            null,
            function( )
            {
                print( "[EVENT_PLAYER_SYNC_DATA]: " + Jass::GetTimeStamp( false, 0 ) + "\n" );
                print( "GetTriggerSyncPrefix: " + Jass::GetTriggerSyncPrefix( ) + "\n" );
                print( "GetTriggerSyncData: " + Jass::GetTriggerSyncData() + "\n" );
                print( "==========================================================\n" );
            }
        );
    }

    void Test( string prefix, string data )
    {
        if ( Jass::GetLocalPlayer( ) == Jass::Player( 0 ) )
        {
            Jass::SendSyncData( prefix, data );
        }
    }
}