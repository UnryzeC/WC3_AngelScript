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
                tString = Jass::CreateTrigger( ),
                prefix,
                false,
                null,
                function( )
                {
                    print( "[EVENT_PLAYER_SYNC_PREFIX]: " + Jass::GetTimeStamp( false, 0 ) + "\n" );
                    print( "Prefix: " + Jass::GetTriggerSyncPrefix( ) + "\n" );
                    print( "==========================================================\n" );
                    print( "Data: " + Jass::GetTriggerSyncData( ) + "\n" );
                }
            );
        }

        if ( Jass::GetLocalPlayer( ) == Jass::Player( 0 ) )
        {
            Jass::SendSyncData
            ( 
                prefix,
                data
            );
        }
    }
}