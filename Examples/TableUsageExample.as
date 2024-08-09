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

  unit u = unit( unitTable[ 0 ] ); // get value with key 0 and cast it to unit.
}
