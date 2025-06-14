table unitTable = { };

void TestFunc( )
{
	unit uOut;
	bool isDelete = false;

	unitTable[ 0 ] = CreateUnit( Player( 0 ), 'Hpal', .0, .0, .0 );

	if ( unitTable.exists( 0 ) )
	{
		bool isValid = unitTable.get( 0, uOut );

		if ( isValid && isDelete )
		{
			unitTable.delete( 0 ); // remove it from table.
		}
	}

	unit u = unit( unitTable[ 0 ] ); // get value with key 0 and cast it to unit. | could also be used via cast<unit>( unitTable[ 0 ] ).

	unit u2 = CreateUnit( Player( 0 ), 'Hamg', .0, .0, .0 );

	unitTable.set( 0, u2 ); // change current unit with value from u2, only works if key exists, if .delete was used, we need to set it via unitTable[ 0 ].
}

void TestAsHashtable( )
{
	unit u = CreateUnit( Player( 0 ), 'Hamg', .0f, .0f, .0f );
	timer t = CreateTimer( );
	uint32 hid = GetHandleId( t );

	unitTable[ uint64( hid ) << 32 | 'unit' ] = u;

	TimerStart
	(
		t,
		.1f,
		true,
		function( )
		{
			timer t = GetExpiredTimer( );
			uint32 hid = GetHandleId( t );
			unit u = unit( tableMain[ uint64( hid ) << 32 | 'unit' ] );

			print( "u = " + GetHandleId( u ) + "\n" );
		}
	);
}
