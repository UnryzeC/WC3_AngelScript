namespace Test::DynamicTooltips
{
    hashtable ht = nil;
    table tbl_timers = { };

    void TestAbility( unit u, int abilId = 'A00B' )
    {
        Init( );

        auto a = GetUnitAbility( u, 'A00B' );

        if ( a == nil )
        {
            UnitAddAbility( u, 'A00B' );
            a = GetUnitAbility( u, 'A00B' );
        }

        auto tmr = CreateTimer( );
        auto hid = GetHandleId( tmr );

        SaveUnitHandle( ht, hid, '+src', u );
        SaveAbilityHandle( ht, hid, 'abil', a );

        TimerStart
        (
            tmr,
            1.f,
            true,
            function( )
            {
                auto a = LoadAbilityHandle( ht, GetHandleId( GetExpiredTimer( ) ), 'abil' );

                for ( auto i = GetHandleId( ABILITY_RLF_DATA_FIELD_A ); i <= GetHandleId( ABILITY_RLF_DATA_FIELD_I ); i++ )
                {
                    SetAbilityRealLevelField( a, ConvertAbilityRealLevelField( i ), 0, GetRandomReal( 5.f, 99.f ) );
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
            it = UnitAddItemById( u, itemId );
        }

        auto tmr = CreateTimer( );
        auto hid = GetHandleId( tmr );

        SaveUnitHandle( ht, hid, '+src', u );
        SaveItemHandle( ht, hid, 'item', it );

        TimerStart
        (
            tmr,
            1.f,
            true,
            function( )
            {
                SetAbilityRealLevelField( GetItemAbilityById( LoadItemHandle( ht, GetHandleId( GetExpiredTimer( ) ), 'item' ), 'AIcf' ), ABILITY_RLF_DATA_FIELD_A, 0, GetRandomReal( 5.f, 99.f ) );
            }
        );

        tbl_timers[ hid ] = tmr;
    }

    void PauseAll( )
    {
        auto keys = tbl_timers.getKeys();

        for ( uint i = 0; i < keys.length( ); i++ )
        {
            PauseTimer( timer( tbl_timers[ keys[i] ] ) );
        }
    }

    void Init( )
    {
        if ( ht == nil )
        {
            ht = InitHashtable( );
        }
    }
}