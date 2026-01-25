//
float CameraMinX = -6144.f + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_LEFT );
float CameraMinY = -5120.f + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_BOTTOM );
float CameraMaxX = 6144.f - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_RIGHT );
float CameraMaxY = 7168.f - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_TOP );

void MapCameraBounds( )
{
    Jass::SetCameraBounds( CameraMinX, CameraMinY, CameraMaxX, CameraMaxY, CameraMinX, CameraMaxY, CameraMaxX, CameraMinY );
}
//

float MapMinX = -6100.f + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_LEFT );
float MapMaxX = 6100.f - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_RIGHT );
float MapMinY = -4400.f + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_BOTTOM );
float MapMaxY = 3350.f - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_TOP );

group GroupFilter = Jass::CreateGroup( );

bool IsAxisReal( float targX, float targY )
{
    return targX >= MapMinX && targX <= MapMaxX && targY >= MapMinY && targY <= MapMaxY;
}

bool RectContainsAxis( rect r, float x, float y )
{
    return x >= Jass::GetRectMinX( r ) && x <= Jass::GetRectMaxX( r ) && y >= Jass::GetRectMinY( r ) && y <= Jass::GetRectMaxY( r );
}

float GetUnitAngle( unit source, unit target )
{
    return Jass::MathAngleBetweenPoints( Jass::GetUnitX( source ), Jass::GetUnitY( source ), Jass::GetUnitX( target ), Jass::GetUnitY( target ) );
}

float GetUnitDistance( unit source, unit target )
{
    return Jass::MathDistanceBetweenPoints( Jass::GetUnitX( source ), Jass::GetUnitY( source ), Jass::GetUnitX( target ), Jass::GetUnitY( target ) );
}

float GetUnitStatePercent( unit whichUnit, unitstate whichState, unitstate whichMaxState )
{
    float maxValue = Jass::GetUnitState( whichUnit, whichMaxState );

    if ( whichUnit == nil || maxValue == 0 )
    {
        return .0f;
    }

    float value = Jass::GetUnitState( whichUnit, whichState );

    return value / maxValue * 100.0f;
}

int CountUnitInGroupOfPlayer( player p, int id, group g = GroupFilter )
{
    int count = 0;

    Jass::GroupClear( g );
    Jass::GroupEnumUnitsOfPlayer( g, p, nil );

    for ( int i = 0; i < Jass::GroupGetCount( g ); i++ )
    {
        unit u = Jass::GroupGetUnitByIndex( g, i );

        if ( Jass::IsUnitAlive( u ) && Jass::GetUnitTypeId( u ) == id )
        {
            count++;
        }
    }

    Jass::GroupClear( g );

    return count;
}

void GroupEnumUnitsInLine( group g, float x, float y, float angle, float dist, float aoe, group gFilter = GroupFilter )
{
    Jass::GroupClear( g );
    Jass::GroupClear( gFilter );
    for ( float moved = .0f; moved < dist; moved += aoe )
    {
        Jass::GroupEnumUnitsInRange( gFilter, x, y, aoe, nil );

        for ( unit u = Jass::GroupForEachUnit( gFilter ); u != nil; u = Jass::GroupForEachUnit( gFilter ) )
        {
            if ( !Jass::IsUnitInGroup( u, g ) )
            {
                Jass::GroupAddUnit( g, u );
            }
        }

        x = Jass::MathPointProjectionX( x, angle, aoe );
        y = Jass::MathPointProjectionY( y, angle, aoe );
    }
}

bool IsUnitCCed( unit u )
{
    return Jass::GetUnitAbilityLevel( u, 'BPSE' ) > 0 || Jass::GetUnitAbilityLevel( u, 'B005' ) > 0;
}

void AddBuffTimed( unit u, uint bid, float time, bool isAdd = true )
{
    if ( Jass::IsUnitDead( u ) ) { return; }

    buff buf = Jass::GetUnitBuff( u, bid );
    float prevTime = .0f;

    if ( buf == nil )
    {
        buf = Jass::UnitAddBuffById( u, bid );
    }
    else
    {
        prevTime = Jass::GetBuffRemainingDuration( buf );
    }

    Jass::SetBuffRemainingDuration( buf, isAdd ? prevTime + time : time );
}

void StunUnit( unit u, float time )
{
    AddBuffTimed( u, 'BPSE', time );
}

void DisableTeleport( unit u, float time )
{
    AddBuffTimed( u, 'B005', time );
}

void PingMinimap( player p, float x, float y, bool extraEffects = false )
{
    int pid = Jass::GetPlayerId( p );

    switch( pid )
    {
        case 0: Jass::PingMinimapEx( x, y, 5, 100, 0, 0, extraEffects ); break;
        case 1: Jass::PingMinimapEx( x, y, 5, 0, 0, 100, extraEffects ); break;
        case 2: Jass::PingMinimapEx( x, y, 5, 0, 100, 100, extraEffects ); break;
        case 3: Jass::PingMinimapEx( x, y, 5, 43, 14, 51, extraEffects ); break;
        case 4: Jass::PingMinimapEx( x, y, 5, 100, 100, 0, extraEffects ); break;
        case 5: Jass::PingMinimapEx( x, y, 5, 83, 37, 10, extraEffects ); break;
        case 6: Jass::PingMinimapEx( x, y, 5, 0, 100, 0, extraEffects ); break;
        case 7: Jass::PingMinimapEx( x, y, 5, 100, 50, 50, extraEffects ); break;
    }
}

void SetUnitScaleAndTime( unit u, float length, float time )
{
    Jass::SetUnitScale( u, length, length, length );
    Jass::SetUnitTimeScale( u, time );
}

int GetItemSlotById( unit whichUnit, int itemId )
{
    for ( int i = 0; i < 6; i++ )
    {
        item itm = Jass::UnitItemInSlot( whichUnit, i );
        if ( Jass::GetItemTypeId( itm ) == itemId ) { return i; }
    }

    return -1;
}

item GetItemById( unit whichUnit, int itemId )
{
    int id = GetItemSlotById( whichUnit, itemId );

    return id != -1 ? Jass::UnitItemInSlot( whichUnit, id ) : nil;
}

int CountItems( unit u, int itemId )
{
    if ( u == nil || itemId == 0 ) { return 0; }

    int count = 0;

    for ( int i = 0; i < 6; i++ )
    {
        item itm = Jass::UnitItemInSlot( u, i );
        if ( Jass::GetItemTypeId( itm ) == itemId ) { count++; }
    }

    return count;
}

bool UnitHasItemById( unit u, int iid )
{
    return CountItems( u, iid ) > 0;
}

bool UnitHasEmptySlot( unit u )
{
    for ( int i = 0; i < 6; i++ )
    {
        if ( Jass::UnitItemInSlot( u, i ) == nil )
        {
            return true;
        }
    }

    return false;
}

void SelectUnit( unit u, player p = nil )
{
    if ( p == nil ) { p = Jass::GetOwningPlayer( u ); }

    if ( Jass::GetLocalPlayer( ) == p )
    {
        Jass::ClearSelection( );
        Jass::SelectUnit( u, true );
    }
}

void PanCameraToTimed( player p, float x, float y, float time )
{
    if ( Jass::GetLocalPlayer( ) == p )
    {
        Jass::PanCameraToTimed( x, y, time );
    }
}

bool UnitHasPersonalItem( unit u, hashtable ht )
{
    return UnitHasItemById( u, Jass::LoadInteger( ht, Jass::GetUnitTypeId( u ), 'pitm' ) );
}

void SetUnitXY( unit u, float toX, float toY, bool pathing = false )
{
    if ( pathing && Jass::IsTerrainPathable( toX, toY, Jass::PATHING_TYPE_WALKABILITY ) )
    {
        return;
    }

    if ( Jass::GetUnitMoveSpeed( u ) > 0 ) // && IsAxisReal( toX, toY ) -> max/min x/y of map
    {
        Jass::SetUnitX( u, toX );
        Jass::SetUnitY( u, toY );
    }
    else
    {
        Jass::SetUnitPosition( u, toX, toY );
    }
}

float CalculateDamage( hashtable ht, unit source, float inDmg, float ampPercent = 1.15f )
{
    if ( UnitHasPersonalItem( source, ht ) )
    {
        return inDmg * ampPercent;
    }

    return inDmg;
}

bool DamageTarget
(
    unit u,
    unit target,
    float dmg,
    bool attack = true,
    bool ranged = false,
    attacktype attackType = Jass::ATTACK_TYPE_NORMAL,
    damagetype damageType = Jass::DAMAGE_TYPE_MAGIC,
    weapontype weaponType = Jass::WEAPON_TYPE_WHOKNOWS
)
{
    return Jass::UnitDamageTarget( u, target, dmg, attack, ranged, attackType, damageType, weaponType );
}

void DisplaceCircular( player enemyTo, float startX, float startY, float aoe, float angle, float scale = 1.f, string eff = "" )
{
    for ( int i = 0; i < 1; i++ )
    {
        float x = Jass::MathPointProjectionX( startX, angle, angle );
        float y = Jass::MathPointProjectionY( startY, angle, angle );

        if ( !eff.isEmpty( ) )
        {
            effect ef = EffectAPI::CreateEx( eff, x, y, .0f, .0f, scale, 1.f );
            
            Jass::DestroyEffect( ef );
        }

        Jass::GroupEnumUnitsInRange( GroupEnum, x, y, aoe, nil );

        for ( unit u = Jass::GroupForEachUnit( GroupEnum ); u != nil; u = Jass::GroupForEachUnit( GroupEnum ) )
        {
            if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, enemyTo ) )
            {
                SetUnitXY( u, x, y );
            }
        }

        angle += 180.f;
    }
}

void HandleListCleanEffects( handlelist hl, bool destroyEffects, bool isDestroy )
{
    if ( hl == nil ) { return; }

    if ( destroyEffects )
    {
        for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
        {
            effect ef = Jass::HandleListGetEffectByIndex( hl, i );
            Jass::DestroyEffect( ef );
        }
    }

    Jass::HandleListClear( hl );
    if ( !isDestroy ) { return; }
    Jass::HandleListDestroy( hl );
}

namespace PickSystem
{
    int TotalHeroes = 0;

    void InitHeroData( hashtable ht, uint32 id, uint uid, uint itemId, uint32 buffId, string iconPath, string modelPath, float scale )
    {
        bool increment = !Jass::HaveSavedInteger( ht, id, 'type' );

        Jass::SaveInteger( ht, id, 'type', uid );
        Jass::SaveReal( ht, uid, 'size', scale );
        Jass::SaveStr( ht, uid, 'mmdl', modelPath + ".mdl" );
        Jass::SaveStr( ht, uid, 'imdl', modelPath + "Icon.mdl" );
        Jass::SaveStr( ht, uid, 'icon', iconPath );

        Jass::SaveInteger( ht, uid, 'pitm', itemId );
        Jass::SaveInteger( ht, uid, 'bfid', buffId );

        if ( increment )
        {
            TotalHeroes++;
        }
    }

    void InitHeroData( uint id, uint uid, uint itemId, uint32 buffId, string iconPath, string modelPath, float scale )
    {
        InitHeroData( VarHT, id, uid, itemId, buffId, iconPath, modelPath, scale );
    }

    void AddHeroData( hashtable ht, uint uid, uint itemId, uint32 buffId, string iconPath, string modelPath, float scale )
    {
        InitHeroData( ht, TotalHeroes + 1, uid, itemId, buffId, iconPath, modelPath, scale );
    }

    void AddHeroData( uint uid, uint itemId, uint32 buffId, string iconPath, string modelPath, float scale )
    {
        AddHeroData( VarHT, uid, itemId, buffId, iconPath, modelPath, scale );
    }
}
