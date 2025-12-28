namespace Test::DynamicTooltips
{
    hashtable ht = nil;
    table tbl_timers = { };

    void TestAbility( unit u, int abilId = 'A00B' )
    {
        Init( );

        auto a = Jass::GetUnitAbility( u, 'A00B' );

        if ( a == nil )
        {
            Jass::UnitAddAbility( u, 'A00B' );
            a = Jass::GetUnitAbility( u, 'A00B' );
        }

        auto tmr = Jass::CreateTimer( );
        auto hid = Jass::GetHandleId( tmr );

        Jass::SaveUnitHandle( ht, hid, '+src', u );
        Jass::SaveAbilityHandle( ht, hid, 'abil', a );

        Jass::TimerStart
        (
            tmr,
            1.f,
            true,
            function( )
            {
                auto a = Jass::LoadAbilityHandle( ht, Jass::GetHandleId( Jass::GetExpiredTimer( ) ), 'abil' );

                for ( auto i = Jass::GetHandleId( Jass::ABILITY_RLF_DATA_FIELD_A ); i <= Jass::GetHandleId( Jass::ABILITY_RLF_DATA_FIELD_I ); i++ )
                {
                    Jass::SetAbilityRealLevelField( a, Jass::ConvertAbilityRealLevelField( i ), 0, Jass::GetRandomReal( 5.f, 99.f ) );
                }
            }
        );

        tbl_timers[ hid ] = tmr;
    }

    void TestItem( unit u, int itemId = 'I004' )
    {
        Init( );

        auto it = GetUnitItem( u, itemId );

        if ( it == nil )
        {
            it = Jass::UnitAddItemById( u, itemId );
        }

        auto tmr = Jass::CreateTimer( );
        auto hid = Jass::GetHandleId( tmr );

        Jass::SaveUnitHandle( ht, hid, '+src', u );
        Jass::SaveItemHandle( ht, hid, 'item', it );

        Jass::TimerStart
        (
            tmr,
            1.f,
            true,
            function( )
            {
                Jass::SetAbilityRealLevelField( Jass::GetItemAbilityById( Jass::LoadItemHandle( ht, Jass::GetHandleId( Jass::GetExpiredTimer( ) ), 'item' ), 'AIcf' ), Jass::ABILITY_RLF_DATA_FIELD_A, 0, Jass::GetRandomReal( 5.f, 99.f ) );
            }
        );

        tbl_timers[ hid ] = tmr;
    }

    void PauseAll( )
    {
        auto keys = tbl_timers.getKeys();

        for ( uint i = 0; i < keys.length( ); i++ )
        {
            Jass::PauseTimer( timer( tbl_timers[ keys[i] ] ) );
        }
    }

    void Init( )
    {
        if ( ht == nil )
        {
            ht = Jass::InitHashtable( );
        }
    }
}