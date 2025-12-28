table tableTable =
{
	{
		'intTbl', table = // this tells AngelScript that value is of type 'table'.
		{ 
			{ 'player', 5 },
			{ 'noob', 999 }
		}
	}
};

void TestTable()
{
	table@ myTable;
	tableTable.get( 'intTbl', @myTable );

	uint64 uOut;
	bool isDelete = false;

	print( "uint64( myTable[ 'player' ] ) = " + uint64( myTable[ 'player' ] ) + "\n" );
	print( "uint64( myTable[ 'noob' ] ) = " + uint64( myTable[ 'noob' ] ) + "\n" );

	myTable[ 'score' ] = 123;

	if ( myTable.exists( 'score' ) )
	{
		bool isValid = myTable.get( 'score', uOut );

		print( "myTable.exists( 'score' ) && isValid = " + isValid + "\n" );

		if ( isValid && isDelete )
		{
			myTable.delete( 'score' ); // remove it from myTable.
		}
	}

	uint64 uTest = uint64( myTable[ 'score' ] ); // get value with key 'score' and cast it to uint64. | could also be used via cast<uint64>( myTable[ 'score' ] ).
	uint64 uNew = 321;

	myTable.set( 'score', uNew ); // change current value with value from uNew, only works if key exists, if .delete was used, we need to set it via myTable[ 'score' ].

	print( "uint64( myTable[ 'score' ] ) = " + uint64( myTable[ 'score' ] ) + "\n" );
	print( "uint64( myTable[ 'player' ] ) = " + uint64( myTable[ 'player' ] ) + "\n" );
}

dictionary dictDict =
{
	{
		"myTable", dictionary = // this tells AngelScript that value is of type 'dictionary'.
		{
			{ "name", "Player1" },
			{ "health", 100 },
			{ "speed", 5.5f }
		}
	}
};

void TestDictionary()
{
	dictionary@ myDict;
	dictDict.get( "myTable", @myDict );

	int health = 0;
	myDict.get("health", health );

	print( "health = " + health + "\n" );

	// Check if a key exists
	if ( myDict.exists( "score" ) )
	{
		print( "score key doesn't exist!\n" );
	}

	print( "uint64( myDict[ \"health\" ] ) = " + uint64( myDict[ "health" ] ) + "\n" );
}
