table unitTable = { };

void TestFunc( )
{
	unit uOut;
	bool isDelete = false;

	unitTable[ 0 ] = Jass::CreateUnit( Jass::Player( 0 ), 'Hpal', .0, .0, .0 );

	if ( unitTable.exists( 0 ) )
	{
		bool isValid = unitTable.get( 0, uOut );

		if ( isValid && isDelete )
		{
			unitTable.delete( 0 ); // remove it from table.
		}
	}

	unit u = unit( unitTable[ 0 ] ); // get value with key 0 and cast it to unit. | could also be used via cast<unit>( unitTable[ 0 ] ).

	unit u2 = Jass::CreateUnit( Jass::Player( 0 ), 'Hamg', .0, .0, .0 );

	unitTable.set( 0, u2 ); // change current unit with value from u2, only works if key exists, if .delete was used, we need to set it via unitTable[ 0 ].
}

void TestAsHashtable( )
{
	unit u = Jass::CreateUnit( Jass::Player( 0 ), 'Hamg', .0f, .0f, .0f );
	timer t = Jass::CreateTimer( );
	uint32 hid = Jass::GetHandleId( t );

	unitTable[ uint64( hid ) << 32 | 'unit' ] = u;

	TimerStart
	(
		t,
		.1f,
		true,
		function( )
		{
			timer t = Jass::GetExpiredTimer( );
			uint32 hid = Jass::GetHandleId( t );
			unit u = unit( tableMain[ uint64( hid ) << 32 | 'unit' ] );

			print( "u = " + Jass::GetHandleId( u ) + "\n" );
		}
	);
}

void IterateAll( )
{
	timer t = Jass::CreateTimer( ); // any other refCounted handle (agent) will do.
	uint32 hid = Jass::GetHandleId( t ); // this just used as an example, easier to let game provide handleId.
	table tableTest = { };

	tableTest[ uint64( hid ) << 32 | 'unit' ] = 1;
	tableTest[ uint64( hid ) << 32 | 'pimp' ] = 2;
	tableTest[ uint64( hid ) << 32 | 'appl' ] = 3;
	tableTest[ uint64( hid ) << 32 | '+loc' ] = 4;

	array<uint64> keys = tableTest.getKeys( );

	for ( uint64 i = 0; i < keys.length( ); i++ )
	{
		print( "key = " + uint32( keys[i] >> 32 ) + " | " + Id2String( uint32( keys[i] ) ) + "\n" );
	}
}
