#include "TriggerAPI.as"

namespace Test::Sync::Variable
{
    trigger tString = nil;

    void String( string prefix, string data )
    {
        if ( tString == nil )
        {
            TriggerAPI::RegisterPlayerSyncEvent
            (
                tString = CreateTrigger( ),
                prefix,
                false,
                null,
                function( )
                {
                    print( "[EVENT_PLAYER_SYNC_PREFIX]: " + GetTimeStamp( false, 0 ) + "\n" );
                    print( "Prefix: " + GetTriggerSyncPrefix( ) + "\n" );
                    print( "==========================================================\n" );
                    print( "Data: " + GetTriggerSyncData( ) + "\n" );
                }
            );
        }

        if ( GetLocalPlayer( ) == Player( 0 ) )
        {
            SendSyncData
            ( 
                prefix,
                data
            );
        }
    }
}