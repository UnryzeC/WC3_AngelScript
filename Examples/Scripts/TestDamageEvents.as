#include "TriggerAPI.as"

namespace Test::Damage
{
    unit UnitSource;
    unit UnitTarget;
    bool isDebug = true;
    player printOnlyForPlayer = Player( 0 );

    void OnUnitAnyDamageDebug( string funcName )
    {
        unit unitTarget = GetTriggerUnit( ); // GetEventDamageTarget( ) // 
        unit unitSource = GetEventDamageSource( );
        player playerSource = GetOwningPlayer( unitSource );
        player playerTarget = GetTriggerPlayer( );
        int damageFlags = GetEventDamageFlags( );
        int actualAttackFlag = BitwiseShiftLeft( 1, 30 );
        
        if ( playerTarget == nil )
        {
            playerTarget = GetOwningPlayer( unitTarget );
        }

        if ( isDebug && ( printOnlyForPlayer != nil ? playerSource == printOnlyForPlayer : true ) )
        {
            print( "======" + funcName + "=====\n" );

            print( "IsAttack = " + B2S( GetEventIsAttack( ) ) + "\n" );
            print( "IsAttackFlag & 0x100: " + B2S( BitwiseAND( damageFlags, 0x100 ) > 0 ) + "\n" );
            print( "IsRanged = " + B2S( GetEventIsRanged( ) ) + "\n" );

            print( "damageFlags = " + IntToHex( GetEventIsAttack( ) ? damageFlags - actualAttackFlag : damageFlags ) + "\n" );

            print( "AttackType = " + I2S( GetHandleId( GetEventAttackType( ) ) ) + "\n" );
            print( "DamageType = " + I2S( GetHandleId( GetEventDamageType( ) ) ) + "\n" );
            print( "WeaponType = " + I2S( GetHandleId( GetEventWeaponType( ) ) ) + "\n" );

            print( "DamagedPlayer: " + GetPlayerName( playerTarget ) + "\n" );
            print( "Source: " + GetUnitName( unitSource ) + " -> (" + I2S( GetHandleId( unitSource ) ) + ")\n" );
            print( "Target: " + GetUnitName( unitTarget ) + " -> (" + I2S( GetHandleId( unitTarget ) ) + ")\n" );
            print( "Pre-damage: " + R2S( GetEventPreDamage( ) ) + " | " + "Damage: " + R2S( GetEventDamage( ) ) + "\n" );
            print( "================\n" );
        }
    }

    void main( )
    {
        UnitSource = CreateUnit( Player( 0 ), 'Hamg', .0, .0, .0 );
        UnitTarget = CreateUnit( Player( 1 ), 'Hblm', .0, .0, .0 );

        SetUnitLifeRegen( UnitSource, 100.f );
        SetUnitLifeRegen( UnitTarget, 100.f );

        TriggerAPI::RegisterAnyPlayerUnitEvent
        (
            CreateTrigger( ),
            EVENT_PLAYER_UNIT_DAMAGING,
            null,
            function( )
            {
                OnUnitAnyDamageDebug( "OnUnitDamaging" );
            }
        );

        TriggerAPI::RegisterAnyPlayerUnitEvent
        (
            CreateTrigger( ),
            EVENT_PLAYER_UNIT_DAMAGED,
            null,
            function( )
            {
                OnUnitAnyDamageDebug( "OnUnitDamaged" );
            }
        );
    }
}