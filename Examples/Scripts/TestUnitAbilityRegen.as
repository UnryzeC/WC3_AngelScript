namespace Test::Unit::AbilityRegen
{
    void Apply( unit u, float hpRegen, float mpRegen )
    {
        ability abil = nil;
        uint32 aid = 'Arel';

        for( int i = 0; ( abil = GetUnitAbilityEx( u, aid, i ) ) != nil; i++ )
        {
            if ( GetAbilityRealLevelField( abil, ABILITY_RLF_DATA_FIELD_I, 0 ) == -9876.f )
            {
                break;
            }
        }

        if ( abil == nil )
        {
            UnitAddAbilityEx( u, aid, false );
            abil = GetUnitAbilityEx( u, aid, 0 );
            SetAbilityRealLevelField( abil, ABILITY_RLF_DATA_FIELD_I, 0, -9876.f );
        }

        if ( abil == nil ) { return; }

        uint32 level = GetAbilityLevel( abil );

        print( "=====================================\n" );
        print( "Test::Unit::AbilityRegen::Apply:\n" );
        print( "abil: " + GetHandleId( abil ) + "\n" );

        SetAbilityIntegerLevelField( abil, ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND, level, 0 );
        SetAbilityIntegerLevelField( abil, ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND, level, 0 );

        print( "UNIT_STATE_REGEN_LIFE: " + GetUnitState( u, UNIT_STATE_REGEN_LIFE ) + "\n" );
        print( "ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND: " + GetAbilityIntegerLevelField( abil, ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND, level ) + "\n" );
        SetAbilityIntegerLevelField( abil, ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND, level, 100 );
        print( "ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND: " + GetAbilityIntegerLevelField( abil, ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND, level ) + "\n" );
        print( "UNIT_STATE_REGEN_LIFE: " + GetUnitState( u, UNIT_STATE_REGEN_LIFE ) + "\n" );

        print( "UNIT_STATE_REGEN_MANA: " + GetUnitState( u, UNIT_STATE_REGEN_MANA ) + "\n" );
        print( "ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND: " + GetAbilityIntegerLevelField( abil, ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND, level ) + "\n" );
        SetAbilityIntegerLevelField( abil, ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND, level, 100 );
        print( "ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND: " + GetAbilityIntegerLevelField( abil, ABILITY_ILF_MANA_POINTS_REGENERATED_PER_SECOND, level ) + "\n" );
        print( "UNIT_STATE_REGEN_MANA: " + GetUnitState( u, UNIT_STATE_REGEN_MANA ) + "\n" );
        print( "=====================================\n" );
    }
}