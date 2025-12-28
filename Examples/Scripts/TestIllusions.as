namespace Test::Illusion
{
    int CountSlots( unit u )
    {
        int count = 0;

        for ( int i = 0; i < Jass::UnitInventorySize( u ); i++ )
        {
            if ( Jass::UnitItemInSlot( u, i ) != nil ) { count++; }
        }

        return count;
    }

    void FillInventory( unit u, int itemId = 'rat6' )
    {
        if ( CountSlots( u ) == 0 ) { return; }

        UnitInventorySetSize( u, 12 );

        for ( int i = 0; i < Jass::UnitInventorySize( u ); i++ )
        {
            Jass::UnitAddItemById( u, itemId );
        }
    }

    void TestMirrorImage( unit u )
    {
        FillInventory( u );

        if ( Jass::GetUnitManaRegen( u ) < 100.f )
        {
            Jass::SetUnitManaRegen( u, 100. );
        }

        if ( Jass::GetUnitAbility( u, 'AOmi' ) != nil ) { return; }

        Jass::UnitAddAbility( u, 'AOmi' );
        Jass::SetUnitAbilityLevel( u, 'AOmi', 3 );
    }

    void TestWandOfIllusions( unit u )
    {
        FillInventory( u );

        if ( Jass::GetUnitManaRegen( u ) < 100.f )
        {
            Jass::SetUnitManaRegen( u, 100. );
        }

        if ( Jass::GetUnitAbility( u, 'AIil' ) != nil ) { return; }

        Jass::UnitAddAbility( u, 'AIil' );
    }

    void main( )
    {
        
    }
}