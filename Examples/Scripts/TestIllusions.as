namespace Test::Illusion
{
    int CountSlots( unit u )
    {
        int count = 0;

        for ( int i = 0; i < UnitInventorySize( u ); i++ )
        {
            if ( UnitItemInSlot( u, i ) != nil ) { count++; }
        }

        return count;
    }

    void FillInventory( unit u, int itemId = 'rat6' )
    {
        if ( CountSlots( u ) == 0 ) { return; }

        UnitInventorySetSize( u, 12 );

        for ( int i = 0; i < UnitInventorySize( u ); i++ )
        {
            UnitAddItemById( u, itemId );
        }
    }

    void TestMirrorImage( unit u )
    {
        FillInventory( u );

        if ( GetUnitManaRegen( u ) < 100.f )
        {
            SetUnitManaRegen( u, 100. );
        }

        if ( GetUnitAbility( u, 'AOmi' ) != nil ) { return; }

        UnitAddAbility( u, 'AOmi' );
        SetUnitAbilityLevel( u, 'AOmi', 3 );
    }

    void TestWandOfIllusions( unit u )
    {
        FillInventory( u );

        if ( GetUnitManaRegen( u ) < 100.f )
        {
            SetUnitManaRegen( u, 100. );
        }

        if ( GetUnitAbility( u, 'AIil' ) != nil ) { return; }

        UnitAddAbility( u, 'AIil' );
    }

    void main( )
    {
        
    }
}