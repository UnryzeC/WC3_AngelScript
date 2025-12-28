namespace Test::Unit::BonusState
{
    void Apply( unit u, float hpBonus, float mpBonus )
    {
        buff buf = nil;
        uint32 bid = 'Bdbb';

        for( int i = 0; ( buf = Jass::GetUnitBuffEx( u, bid, i ) ) != nil; i++ )
        {
            if ( Jass::GetBuffRealField( buf, ABILITY_RLF_DATA_FIELD_A ) == -9876.f )
            {
                break;
            }
        }

        if ( buf == nil )
        {
            Jass::UnitAddBuffByIdEx( u, bid, false );
            buf = Jass::GetUnitBuffEx( u, bid, 0 );
            SetBuffDrawEnabled( buf, false );
            Jass::SetBuffRealField( buf, ABILITY_RLF_DATA_FIELD_A, -9876.f );
        }

        if ( buf == nil ) { return; }

        print( "=====================================\n" );
        print( "Test::Unit::BonusState::Apply:\n" );
        print( "buf: " + Jass::GetHandleId( buf ) + "\n" );
        Jass::SetBuffRealField( buf, ABILITY_RLF_DATA_FIELD_F, hpBonus );
        Jass::SetBuffRealField( buf, ABILITY_RLF_DATA_FIELD_H, mpBonus );
        print( "=====================================\n" );
    }
}