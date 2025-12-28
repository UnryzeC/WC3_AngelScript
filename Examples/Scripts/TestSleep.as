#include "TriggerAPI.as"

namespace Test::Sleep
{
    void main( )
    {
        print( "1: " + Jass::GetTimeStamp( false, 0 ) + "\n" );
        std::sleep( 2.f );
        print( "2: " + Jass::GetTimeStamp( false, 0 ) + "\n" );
        std::sleep( 3.f );
        print( "3: " + Jass::GetTimeStamp( false, 0 ) + "\n" );
    }
}