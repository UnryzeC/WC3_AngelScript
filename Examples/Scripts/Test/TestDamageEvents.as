#include "TriggerAPI.as"

namespace Test::Damage
{
    unit UnitSource;
    unit UnitTarget;
    bool isDebug = true;
    player printOnlyForPlayer = Jass::Player( 0 );

    void OnUnitAnyDamageDebug( string funcName )
    {
        unit unitTarget = Jass::GetTriggerUnit( ); // GetEventDamageTarget( ) // 
        unit unitSource = Jass::GetEventDamageSource( );
        player playerSource = Jass::GetOwningPlayer( unitSource );
        player playerTarget = Jass::GetTriggerPlayer( );
        int damageFlags = Jass::GetEventDamageFlags( );
        int actualAttackFlag = Jass::BitwiseShiftLeft( 1, 30 );
        
        if ( playerTarget == nil )
        {
            playerTarget = Jass::GetOwningPlayer( unitTarget );
        }

        if ( isDebug && ( printOnlyForPlayer != nil ? playerSource == printOnlyForPlayer : true ) )
        {
            print( "======" + funcName + "=====\n" );

            print( "IsAttack = " + Jass::GetEventIsAttack( ) + "\n" );
            print( "IsAttackFlag & 0x100: " + ( Jass::BitwiseAND( damageFlags, 0x100 ) > 0 ) + "\n" );
            print( "IsRanged = " + Jass::GetEventIsRanged( ) + "\n" );

            print( "damageFlags = " + Jass::IntToHex( Jass::GetEventIsAttack( ) ? damageFlags - actualAttackFlag : damageFlags ) + "\n" );

            print( "AttackType = " + Jass::GetHandleId( Jass::GetEventAttackType( ) ) + "\n" );
            print( "DamageType = " + Jass::GetHandleId( Jass::GetEventDamageType( ) ) + "\n" );
            print( "WeaponType = " + Jass::GetHandleId( Jass::GetEventWeaponType( ) ) + "\n" );

            print( "DamagedPlayer: " + Jass::GetPlayerName( playerTarget ) + "\n" );
            print( "Source: " + Jass::GetUnitName( unitSource ) + " -> (" + Jass::GetHandleId( unitSource ) + ")\n" );
            print( "Target: " + Jass::GetUnitName( unitTarget ) + " -> (" + Jass::GetHandleId( unitTarget ) + ")\n" );
            print( "Pre-damage: " + Jass::GetEventPreDamage( ) + " | " + "Damage: " + Jass::GetEventDamage( ) + "\n" );
            print( "================\n" );
        }
    }

	void Register( )
	{
        TriggerAPI::RegisterPlayerUnitEvent
        (
            Jass::CreateTrigger( ),
            Jass::EVENT_PLAYER_UNIT_DAMAGING,
            null,
            function( )
            {
                OnUnitAnyDamageDebug( "OnUnitDamaging" );
            }
        );

        TriggerAPI::RegisterPlayerUnitEvent
        (
            Jass::CreateTrigger( ),
            Jass::EVENT_PLAYER_UNIT_DAMAGED,
            null,
            function( )
            {
                OnUnitAnyDamageDebug( "OnUnitDamaged" );
            }
        );
	}
	
	void CreateUnits( )
	{
	    UnitSource = Jass::CreateUnit( Jass::Player( 0 ), 'Hamg', .0, .0, .0 );
        UnitTarget = Jass::CreateUnit( Jass::Player( 1 ), 'Hblm', .0, .0, .0 );

        Jass::SetUnitLifeRegen( UnitSource, 100.f );
        Jass::SetUnitLifeRegen( UnitTarget, 100.f );
	}

    void main( )
    {

    }
}