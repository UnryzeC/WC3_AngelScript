namespace Test::Unit::BonusState
{
    void Apply( unit u, float hpBonus, float mpBonus )
    {
        buff buf = nil;
        uint32 bid = 'Bdbb';

        for( int i = 0; ( buf = GetUnitBuffEx( u, bid, i ) ) != nil; i++ )
        {
            if ( GetBuffRealField( buf, ABILITY_RLF_DATA_FIELD_A ) == -9876.f )
            {
                break;
            }
        }

        if ( buf == nil )
        {
            UnitAddBuffByIdEx( u, bid, false );
            buf = GetUnitBuffEx( u, bid, 0 );
            SetBuffDrawEnabled( buf, false );
            SetBuffRealField( buf, ABILITY_RLF_DATA_FIELD_A, -9876.f );
        }

        if ( buf == nil ) { return; }

        print( "=====================================\n" );
        print( "Test::Unit::BonusState::Apply:\n" );
        print( "buf: " + GetHandleId( buf ) + "\n" );
        SetBuffRealField( buf, ABILITY_RLF_DATA_FIELD_F, hpBonus );
        SetBuffRealField( buf, ABILITY_RLF_DATA_FIELD_H, mpBonus );
        print( "=====================================\n" );
    }
}