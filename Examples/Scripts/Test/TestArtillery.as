void Test( )
{
    projectile pr = CreateProjectile( 'B-Ar', 500.f, .0f, .0f, GetUnitFacing( u ) );
    SetProjectileUnitData( pr, u, 0 );
    SetProjectileModel( pr, GetUnitWeaponStringField( u, UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART, 0 ) );

    print( "pr = " + GetHandleId( pr ) + "\n" );
    print( "GetProjectileAreaOfEffectFullDamage( pr ) = " + GetProjectileAreaOfEffectFullDamage( pr ) + "\n" );
    print( "GetProjectileAreaOfEffectMediumDamage( pr ) = " + GetProjectileAreaOfEffectMediumDamage( pr ) + "\n" );
    print( "GetProjectileAreaOfEffectSmallDamage( pr ) = " + GetProjectileAreaOfEffectSmallDamage( pr ) + "\n" );
    print( "GetProjectileAreaOfEffectMediumDamageFactor( pr ) = " + GetProjectileAreaOfEffectMediumDamageFactor( pr ) + "\n" );
    print( "GetProjectileAreaOfEffectSmallDamageFactor( pr ) = " + GetProjectileAreaOfEffectSmallDamageFactor( pr ) + "\n" );

    SetProjectileAreaOfEffectFullDamage( pr, 999.f );
    SetProjectileAreaOfEffectMediumDamage( pr, 998.f );
    SetProjectileAreaOfEffectSmallDamage( pr, 997.f );
    SetProjectileAreaOfEffectMediumDamageFactor( pr, 996.f );
    SetProjectileAreaOfEffectSmallDamageFactor( pr, 995.f );

    print( "GetProjectileAreaOfEffectFullDamage( pr ) = " + GetProjectileAreaOfEffectFullDamage( pr ) + "\n" );
    print( "GetProjectileAreaOfEffectMediumDamage( pr ) = " + GetProjectileAreaOfEffectMediumDamage( pr ) + "\n" );
    print( "GetProjectileAreaOfEffectSmallDamage( pr ) = " + GetProjectileAreaOfEffectSmallDamage( pr ) + "\n" );
    print( "GetProjectileAreaOfEffectMediumDamageFactor( pr ) = " + GetProjectileAreaOfEffectMediumDamageFactor( pr ) + "\n" );
    print( "GetProjectileAreaOfEffectSmallDamageFactor( pr ) = " + GetProjectileAreaOfEffectSmallDamageFactor( pr ) + "\n" );

    LaunchProjectileAt( pr, .0f, .0f, .0f );
}