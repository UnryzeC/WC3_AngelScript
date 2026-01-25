namespace Test::Unit::AbilityRegen
{
    void Apply( unit u, float hpRegen, float mpRegen )
    {
        ability abil = nil;
        uint32 aid = 'Arel';

        for( int i = 0; ( abil = Jass::GetUnitAbilityEx( u, aid, i ) ) != nil; i++ )
        {
            if ( Jass::GetAbilityRealLevelField( abil, ABILITY_RLF_DATA_FIELD_I, 0 ) == -9876.f )
            {
                break;
            }
        }

        if ( abil == nil )
        {
            Jass::UnitAddAbilityEx( u, aid, false );
            abil = Jass::GetUnitAbilityEx( u, aid, 0 );
            Jass::SetAbilityRealLevelField( abil, ABILITY_RLF_DATA_FIELD_I, 0, -9876.f );
        }

        if ( abil == nil ) { return; }

        uint32 level = Jass::GetAbilityLevel( abil );

        print( "=====================================\n" );
        print( "Test::Unit::AbilityRegen::Apply:\n" );
        print( "abil: " + Jass::GetHandleId( abil ) + "\n" );

        Jass::SetAbilityIntegerLevelField( abil, Jass::ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND, level, 0 );
        Jass::SetAbilityIntegerLevelField( abil, Jass::ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND, level, 0 );

        print( "UNIT_STATE_REGEN_LIFE: " + Jass::GetUnitState( u, Jass::UNIT_STATE_REGEN_LIFE ) + "\n" );
        print( "ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND: " + Jass::GetAbilityIntegerLevelField( abil, Jass::ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND, level ) + "\n" );
        Jass::SetAbilityIntegerLevelField( abil, Jass::ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND, level, 100 );
        print( "ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND: " + Jass::GetAbilityIntegerLevelField( abil, Jass::ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND, level ) + "\n" );
        print( "UNIT_STATE_REGEN_LIFE: " + Jass::GetUnitState( u, Jass::UNIT_STATE_REGEN_LIFE ) + "\n" );

        print( "UNIT_STATE_REGEN_MANA: " + Jass::GetUnitState( u, Jass::UNIT_STATE_REGEN_MANA ) + "\n" );
        print( "ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND: " + Jass::GetAbilityIntegerLevelField( abil, Jass::ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND, level ) + "\n" );
        Jass::SetAbilityIntegerLevelField( abil, Jass::ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND, level, 100 );
        print( "ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND: " + Jass::GetAbilityIntegerLevelField( abil, Jass::ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND, level ) + "\n" );
        print( "UNIT_STATE_REGEN_MANA: " + Jass::GetUnitState( u, Jass::UNIT_STATE_REGEN_MANA ) + "\n" );
        print( "=====================================\n" );
    }
}