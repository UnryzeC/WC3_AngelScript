#include "TriggerAPI.as";

namespace Test::Projectiles
{
    hashtable ht = Jass::InitHashtable( );
    bool isDebug = true;

    void OnDebugProjectileData( string funcName )
    {
        projectile proj = Jass::GetTriggerProjectile( );
        unit uSource = Jass::GetTriggerProjectileSource( );
        ability aSource = Jass::GetProjectileSourceAbility( proj );
        player p = Jass::GetTriggerPlayer( );
        widget wTarget = Jass::GetTriggerProjectileTarget( );

        if ( isDebug )
        {
            print( "=====\n" );
            print( funcName + "\n" );
            print( "Source Player: " + Jass::GetPlayerName( p ) + " ( " + Jass::GetHandleId( p ) + " )\n" );
            print( "Source Unit: " + Jass::Id2String( Jass::GetUnitTypeId( uSource ) ) + "->" + Jass::GetUnitName( uSource ) + " ( " + Jass::GetHandleId( uSource ) + " )\n" );
            print( "Source Ability: " + Jass::Id2String( Jass::GetAbilityTypeId( aSource ) ) + "->" + Jass::GetAbilityStringField( aSource, Jass::ABILITY_SF_NAME ) + " ( " + Jass::GetHandleId( aSource ) + " )\n" );
            print( "Target Widget = " + Jass::Id2String( Jass::GetWidgetTypeId( wTarget ) ) + "->" + Jass::GetWidgetName( wTarget ) + " ( " + Jass::GetHandleId( wTarget ) + " )\n" );

            if ( Jass::IsProjectileType( proj, Jass::PROJECTILE_TYPE_ARTILLERY ) )
            {
                print( "Artillery: " );
            }
            else if ( Jass::IsProjectileType( proj, Jass::PROJECTILE_TYPE_MISSILE ) )
            {
                print( "Missile: " );
            }
            else if ( Jass::IsProjectileType( proj, Jass::PROJECTILE_TYPE_BULLET ) )
            {
                print( "Bullet: " );
            }

            print( Jass::GetHandleBaseTypeName( proj ) + " ( " + Jass::GetHandleId( proj ) + " ) -> " + Jass::IntToHex( Jass::HandleToAddress( proj ) ) + "\n" );

            if ( false )
            {
                print( "AttackType = " + Jass::GetHandleId( Jass::GetProjectileAttackType( proj ) ) + "\n" );
                print( "WeaponType = " + Jass::GetHandleId( Jass::GetProjectileWeaponType( proj ) ) + "\n" );
                print( "DamageType = " + Jass::GetHandleId( Jass::GetProjectileDamageType( proj, 0 ) ) + "\n" );
                print( "Speed = " + Jass::GetProjectileSpeed( proj ) + "\n" );
                print( "Damage = " + Jass::GetProjectileDamage( proj, 0 ) + "\n" );
            }

            print( "=====\n" );
        }
    }

    void AutoTestProjectileManualLaunch( )
    {
        unit u = Jass::CreateUnit( Jass::Player( 0 ), 'Hamg', .0f, .0f, .0f );
        projectile proj = Jass::CreateProjectile( '+wbu', .0f, .0f, 100.f, 270.f );
        timer tmr = Jass::CreateTimer( );
        integer hid = Jass::GetHandleId( tmr );

        Jass::SetProjectileUnitData( proj, u, 0 );
        Jass::SetProjectileModelEx( proj, "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", 0 );
        Jass::SetProjectileSource( proj, u );

        Jass::SaveProjectileHandle( ht, hid, 'proj', proj );
        Jass::SaveReal( ht, hid, 'dist', 1500.f );
        Jass::SaveReal( ht, hid, 'sped', 10.f );
        Jass::SaveReal( ht, hid, 'angl', 45.f );

        Jass::TimerStart
        (
            tmr,
            .01f,
            true,
            function()
            {
                timer tmr = Jass::GetExpiredTimer( );
                integer hid = Jass::GetHandleId( tmr );
                projectile proj = Jass::LoadProjectileHandle( ht, hid, 'proj' );
                float speed = Jass::LoadReal( ht, hid, 'sped' );
                float angle = Jass::LoadReal( ht, hid, 'angl' );
                float maxDist = Jass::LoadReal( ht, hid, 'dist' );
                float travel = Jass::LoadReal( ht, hid, 'move' );
                
                if ( travel > maxDist )
                {
                    Jass::KillProjectile( proj );
                    Jass::PauseTimer( tmr );
                    Jass::FlushChildHashtable( ht, hid );
                    Jass::DestroyTimer( tmr );
                }
                else
                {
                    Jass::SaveReal( ht, hid, 'move', travel + speed );
                    Jass::SetProjectilePositionWithZ
                    (
                        proj,
                        Jass::MathPointProjectionX( Jass::GetProjectileX( proj ), angle, speed ),
                        Jass::MathPointProjectionY( Jass::GetProjectileY( proj ), angle, speed ),
                        100.f
                    );
                }
            }
        );
    }

    void AutoTestProjectileLaunch( )
    {
        unit u = Jass::CreateUnit( Jass::Player( 0 ), 'Hamg', - 1000.f, - 500.f, .0f );
        unit target = Jass::CreateUnit( Jass::Player( 1 ), 'Hamg', .0f, .0f, .0f );

        Jass::PanCameraToTimed( Jass::GetUnitX( u ), Jass::GetUnitY( u ), .0f );
        Jass::SetWar3ImageAnimationFrozen( target, true );

        timer t = Jass::CreateTimer( );
        uint hid = Jass::GetHandleId( t );

        Jass::SaveUnitHandle( ht, hid, '+src', u );
        Jass::SaveUnitHandle( ht, hid, '+trg', target );

        Jass::TimerStart
        ( 
            Jass::CreateTimer( ),
            .5f,
            true,
            function( )
            {
                timer t = Jass::GetExpiredTimer( );
                uint hid = Jass::GetHandleId( t );
                uint i = Jass::LoadInteger( ht, hid, 'iter' );
                unit u = Jass::LoadUnitHandle( ht, hid, '+src' );
                unit target = Jass::LoadUnitHandle( ht, hid, '+trg' );
                projectile proj = Jass::CreateProjectile( 'B-Mi', -1000.f, -500.f, .0f, 270.f );

                Jass::SetProjectileSource( proj, u );
                Jass::SetProjectileUnitData( proj, u, 0 );
                Jass::SetProjectileArc( proj, .5f );
                Jass::SetProjectileSpeed( proj, 400.f );
                Jass::SetProjectileModelEx( proj, "Abilities\\Weapons\\IllidanMissile\\IllidanMissile.mdl", 0 ); // "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl"

                if ( i % 2 == 0 )
                {
                    Jass::LaunchProjectileAt( proj, Jass::GetUnitX( target ), Jass::GetUnitY( target ), Jass::GetUnitZ( target ) + 100.f );
                }
                else
                {
                    Jass::LaunchProjectileTarget( proj, target );
                }

                Jass::SaveInteger( ht, hid, 'iter', ++i );

                if ( i == 2 )
                {
                    Jass::FlushChildHashtable( ht, hid );
                    Jass::PauseTimer( t );
                    Jass::DestroyTimer( t );
                }
            }
        );
    }

    void TestLaunchArtillery( )
    {
        unit u = Jass::CreateUnit( Jass::Player( 0 ), 'Hpal', .0f, .0f, .0f );
        projectile proj = Jass::CreateProjectile( 'B-Ar', Jass::GetUnitX( u ), Jass::GetUnitY( u ), .0f, .0f );

        Jass::SetProjectileSource( proj, u );
        Jass::SetProjectileModelEx( proj, "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", 0 );
        Jass::SetProjectileScale( proj, 1.5f );
        Jass::SetProjectileDamage( proj, 0, 250.f + 50.f * Jass::GetHeroLevel( u ) + Jass::GetHeroStr( u, true ) );
        Jass::SetProjectileAttackType( proj, Jass::ATTACK_TYPE_NORMAL );
        Jass::SetProjectileDamageType( proj, 0, Jass::DAMAGE_TYPE_MAGIC );
        Jass::SetProjectileWeaponType( proj, Jass::WEAPON_TYPE_WHOKNOWS );
        Jass::SetProjectileArc( proj, 700.f );
        Jass::SetProjectileSpeed( proj, 500.f );
        Jass::LaunchProjectileAt( proj, 500.f, .0f, .0f );

        Jass::CreateUnit( Jass::Player( 1 ), 'hpea', 500.f, .0f, .0f );
    }

    void TestProjectileAPI( )
    {
        trigger t;
        projectile proj;
        unit u;

        t = Jass::CreateTrigger( );
        Jass::TriggerRegisterPlayerUnitEvent( t, Jass::Player( 0 ), Jass::EVENT_PLAYER_UNIT_PROJECTILE_LAUNCH, nil );
        Jass::TriggerAddAction
        ( 
            t,
            function()
            {
                projectile proj = Jass::GetTriggerProjectile( );
                unit uSource = Jass::GetTriggerProjectileSource( );
                ability aSource = Jass::GetProjectileSourceAbility( proj );
                player p = Jass::GetTriggerPlayer( );
                widget wTarget = Jass::GetTriggerProjectileTarget( );

                OnDebugProjectileData( "OnProjectileLaunch" );

                //Jass::TriggerSleepAction( .01f );
                //Jass::SetProjectileSpeed( proj, 1.f );
                //Jass::SetProjectileModel( proj, "units\\human\\Peasant\\Peasant.mdl" );
                //Jass::SetProjectileColour( proj, 0xFF203040 );
                //Jass::SetProjectileAnimation( proj, "walk" );
                //Jass::TriggerSleepAction( .1f );
                //Jass::KillProjectile( proj );
            }
        );

        t = Jass::CreateTrigger( );
        Jass::TriggerRegisterPlayerUnitEvent( t, Jass::Player( 0 ), Jass::EVENT_PLAYER_UNIT_PROJECTILE_HIT, nil );
        Jass::TriggerAddAction
        (
            t,
            function()
            {
                OnDebugProjectileData( "OnProjectileHit" );
            }
        );
        
        u = Jass::CreateUnit( Jass::Player( 0 ), 'Hamg', .0f, .0f, .0f );
        
        u = Jass::CreateUnit( Jass::Player( 12 ), 'Hamg', .0f, .0f, .0f );
        Jass::PauseUnit( u, true );
        Jass::SetUnitMaxLife( u, 9999999.f );
        Jass::SetUnitCurrentLife( u, 9999999.f );
    }

    void main( )
    {

    }
}