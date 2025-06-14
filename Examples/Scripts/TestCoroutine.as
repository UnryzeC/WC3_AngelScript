namespace Test::Coroutines
{
    void TestCoroutine( dictionary@ args )
    {
        print( "TestCoroutine: " + int( args["first"] ) + "\n" );
        CreateUnit( Player( 0 ), 'Hpal', .0f, .0f, .0f );
    }

    void TestThread( dictionary@ args )
    {
        print( "TestThread: " + int( args["first"] ) + "\n" );
        CreateUnit( Player( 0 ), 'Hamg', .0f, .0f, .0f );

        createCoRoutine( TestCoroutine, 
            dictionary =
            {
                {"first", 2}
            }
        );
    }

    void Init( )
    {
        createThread( TestThread, 
            dictionary =
            {
                {"first", 1}
            }
        );
    }
}
