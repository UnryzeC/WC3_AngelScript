#include "TriggerAPI.as"

namespace Test::Sync::Hashtable
{
    trigger trig = nil;

    void Integer( hashtable ht )
    {
        if ( trig == nil )
        {
            TriggerAPI::RegisterPlayerHashtableSyncEvent
            (
                trig = CreateTrigger( ),
                ht,
                null,
                function( )
                {
                    hashtable ht = GetSyncSavedHashtable( );
                    uint32 keyParent = GetSyncSavedParentKey( );
                    uint32 keyChild = GetSyncSavedChildKey( );

                    print( "[EVENT_PLAYER_SYNC_HASHTABLE]: " + GetTimeStamp( false, 0 ) + "\n" );
                    print( "GetSyncSavedHashtable: " + ht + "\n" );
                    print( "GetSyncSavedParentKey: " + keyParent + "\n" );
                    print( "GetSyncSavedChildKey: " + keyChild + "\n" );
                    print( "GetSyncSavedVariableType: " + GetSyncSavedVariableType( ) + "\n" );

                    if ( GetSyncSavedVariableType( ) == VARIABLE_TYPE_INTEGER )
                    {
                        print( "Value: " + LoadInteger( ht, keyParent, keyChild ) + "\n" );
                    }

                    print( "==========================================================\n" );
                }
            );
        }

        if ( GetLocalPlayer( ) == Player( 0 ) )
        {
            SaveInteger( ht, 123, 321, 100500 );

            SyncSavedInteger( ht, 123, 321 );
        }
    }
}