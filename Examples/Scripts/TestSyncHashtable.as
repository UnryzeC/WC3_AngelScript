#include "TriggerAPI.as"

namespace Test::Sync::Hashtable
{
    trigger trig = nil;

    void Register( trigger t, hashtable ht )
    {
        TriggerAPI::RegisterPlayerHashtableSyncEvent
        (
            t,
            ht,
            null,
            function( )
            {
                hashtable ht = Jass::GetSyncSavedHashtable( );
                uint32 keyParent = Jass::GetSyncSavedParentKey( );
                uint32 keyChild = Jass::GetSyncSavedChildKey( );

                print( "[EVENT_PLAYER_SYNC_HASHTABLE]: " + Jass::GetTimeStamp( false, 0 ) + "\n" );
                print( "GetSyncSavedHashtable: " + ht + "\n" );
                print( "GetSyncSavedParentKey: " + keyParent + "\n" );
                print( "GetSyncSavedChildKey: " + keyChild + "\n" );
                print( "GetSyncSavedVariableType: " + Jass::GetSyncSavedVariableType( ) + "\n" );

                if ( Jass::GetSyncSavedVariableType( ) == Jass::VARIABLE_TYPE_INTEGER )
                {
                    print( "Value: " + Jass::LoadInteger( ht, keyParent, keyChild ) + "\n" );
                }
                else if ( Jass::GetSyncSavedVariableType( ) == Jass::VARIABLE_TYPE_REAL )
                {
                    print( "Value: " + Jass::LoadReal( ht, keyParent, keyChild ) + "\n" );
                }

                print( "==========================================================\n" );
            }
        );
    }

    void TestInteger( hashtable ht, player fromPlayer = Jass::Player( 0 ) )
    {
        if ( Jass::GetLocalPlayer( ) == fromPlayer )
        {
            Jass::SaveInteger( ht, 123, 321, 100500 );

            Jass::SyncSavedInteger( ht, 123, 321 );
        }
    }

    void TestReal( hashtable ht, player fromPlayer = Jass::Player( 0 ) )
    {
        if ( Jass::GetLocalPlayer( ) == fromPlayer )
        {
            Jass::SaveReal( ht, 1234, 4321, 123.456f );

            Jass::SyncSavedReal( ht, 1234, 4321 );
        }
    }
}