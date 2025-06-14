#include "TriggerAPI.as"

namespace Test::Sleep
{
    void main( )
    {
        print( "1: " + GetTimeStamp( false, 0 ) + "\n" );
        std::sleep( 2.f );
        print( "2: " + GetTimeStamp( false, 0 ) + "\n" );
        std::sleep( 3.f );
        print( "3: " + GetTimeStamp( false, 0 ) + "\n" );
    }
}