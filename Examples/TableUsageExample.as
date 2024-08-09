table unitTable = { };

void TestFunc( )
{
  bool isDelete = false;

  unitTable[ 0 ] = CreateUnit( Player( 0 ), 'Hpal', .0, .0, .0 );

  if ( unitTable.exists( 0 ) )
  {
    bool isValid = dict.get( 0, unit );

    if ( isValid && isDelete )
    {
      unitTable.delete( 0 ); // remove it from table.
    }
  }

  unit u = unit( unitTable[ 0 ] ); // get value with key 0 and cast it to unit. | could also be used via cast<unit>( unitTable[ 0 ] ).

  unit u2 = CreateUnit( Player( 0 ), 'Hamg', .0, .0, .0 );

  unitTable.set( 0, u2 ); // change current unit with value from u2, only works if key exists, if .delete was used, we need to set it via unitTable[ 0 ].
}
