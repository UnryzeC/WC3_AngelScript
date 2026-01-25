#include "Base.as"

namespace Akainu
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00I';
    const uint32 ITEM_TYPE_ID = 'I018';
    const uint32 BUFF_TYPE_ID = 'B04H';
    const string MODEL_PATH = "Characters\\Akainu\\Akainu";
    const string ICON_PATH = "Characters\\Akainu\\ReplaceableTextures\\CommandButtons\\BTNAkainuIcon.blp";
    const float SCALE = 1.8f;
    const uint32 D_TYPE_ID = 'A049';
    const uint32 Q_TYPE_ID = 'A04A';
    const uint32 W_TYPE_ID = 'A04C';
    const uint32 E_TYPE_ID = 'A04B';
    const uint32 R_TYPE_ID = 'A04D';
    const uint32 T_TYPE_ID = 'A04E';

    void D( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'D1', 100.f, .0f );
            Jass::SaveEffectHandle( DataHT, hid, '+eff', Jass::AddSpecialEffectTarget( "GeneralEffects\\lavaspray.mdx", source, "head" ) );
        }

        if ( SpellAPI::Counter( DataHT, hid, 0, 50 ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            if ( Jass::GetUnitAbilityLevel( source, BUFF_TYPE_ID ) <= 0 )
            {
                Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }

            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float dmg = 12.5f * Jass::GetHeroLevel( source ) + .1f * Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 300.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    if ( DamageTarget( source, u, dmg ) )
                    {
                        Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", u, "chest" ) );
                    }
                }
            }
        }
    }

    void Q( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

        if ( SpellAPI::Stop( DataHT, hid, 1, true ) )
        {
            Sound::StopHero( SoundHT, source, 'psnd' + 'R1' );
            Sound::StopHero( SoundHT, source, 'psnd' + 'R2' );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );
        unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );

        if ( ticks == 0 )
        {
            Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 90.f, .0f );
            StunUnit( source, .25f );
            Jass::SetUnitPathing( source, false );
            Jass::SetUnitAnimation( source, "spell three" );
        }

        if ( SpellAPI::Counter( DataHT, hid, 0, 10 ) )
        {
            StunUnit( source, .10f );
            //DisableTeleport( target, .10f ); // this adds up
        }

        float x = Jass::GetUnitX( source );
        float y = Jass::GetUnitY( source );
        float targX = Jass::GetUnitX( target );
        float targY = Jass::GetUnitY( target );
        float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
        float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
        float moveX = Jass::MathPointProjectionX( x, angle, 20.f );
        float moveY = Jass::MathPointProjectionY( y, angle, 20.f );

        if ( dist > 150.f )
        {
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
            SetUnitXY( source, moveX, moveY );
            Jass::SetUnitFacingInstant( source, angle );
        }
        else
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'R1', 90.f, .0f );
            Jass::SetUnitAnimation( source, "spell two" );

            effect ef;
            // "Units\\Creeps\\LavaSpawn\\LavaSpawn.mdl"

            ef = EffectAPI::CreateEx( "Abilities\\Weapons\\DemolisherFireMissile\\DemolisherFireMissile.mdl", moveX, moveY, 50.f, angle, 1.f, 1.f );
            Jass::SetSpecialEffectPitch( ef, -90.f );
            Jass::DestroyEffect( ef );

            ef = EffectAPI::CreateEx( "GeneralEffects\\t_huobao.mdl", moveX, moveY, 100.f, angle, 1.f, 1.f );
            Jass::SetSpecialEffectPitch( ef, -90.f );
            EffectAPI::SetTimedLife( ef, 2.f );

            for ( int i = 0; i < 3; i++ )
            {
                float face = 120.f * i;
                moveX = Jass::MathPointProjectionX( targX, face, 150.f );
                moveY = Jass::MathPointProjectionY( targY, face, 150.f );

                Jass::DestroyEffect( EffectAPI::CreateEx( "Units\\Creeps\\LavaSpawn\\LavaSpawn.mdl", moveX, moveY, .0f, .0f, 1.5f, 1.f ) );
                Jass::DestroyEffect( EffectAPI::CreateEx( "Characters\\Akainu\\magmablast2.mdl", moveX, moveY, 120.f, face, .5f, 1.5f ) );
            }

            float dmg = 200.f + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, Jass::GetUnitX( target ), Jass::GetUnitY( target ), 300.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    if ( u == target )
                    {
                        StunUnit( u, 2.f );
                        War3Image::DisplaceLinear( target, angle, -300.f, .4f, .01f, false, false );
                    }
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void W( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
        {
            Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'E1' );
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'E1', 90.f, .0f );
            StunUnit( source, .5f );
            Jass::SetUnitAnimation( source, "spell one" );

            effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, .0f, 1.5f, 1.f );
            EffectAPI::SetTimedLife( ef, 4.f );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
            Displacer::Unit::Move( source, angle, Jass::LoadReal( DataHT, hid, 'dist' ), .5f, .01f, 600.f );
        }
        else if ( ticks == 50 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            effect ef;

            ef = EffectAPI::CreateEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, .0f, .0f, 1.5f, 1.f );

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );

            for ( int i = 0; i < 4; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f, 1.25f ); 
                EffectAPI::SetTimedLife( ef, 4.f );

                ef = EffectAPI::CreateEx( "Characters\\Akainu\\magmablast2.mdl", x, y, .0f, 90.f * i, .5f, 1.5f );
                EffectAPI::SetTimedLife( ef, 2.f );
            }

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 350.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 1.f );
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void E( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1, true ) )
        {
            Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'R1' );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            StunUnit( source, .25f );
            Jass::SetUnitTimeScale( source, 2.f );
            Jass::SetUnitAnimation( source, "attack" );
        }
        else if ( ticks == 20 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );

            Jass::SetUnitTimeScale( source, 1 );

            projectile proj = Jass::CreateProjectile( 'B-Mi', Jass::MathPointProjectionX( x, angle, 40.f ), Jass::MathPointProjectionY( y, angle, 40.f ), Jass::GetUnitZ( source ) + 100.f, angle );

            Jass::SetProjectileUnitData( proj, source, 0 );
            Jass::SetProjectileModel( proj, "Characters\\Akainu\\magmablast2.mdl" ); // Characters\\Akainu\\moon_shin_mg1.mdl
            Jass::SetProjectileScale( proj, 1.5f );
            Jass::SetProjectileDamage( proj, 0, 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true ) );
            Jass::SetProjectileAttackType( proj, Jass::ATTACK_TYPE_NORMAL );
            Jass::SetProjectileDamageType( proj, 0, Jass::DAMAGE_TYPE_MAGIC );
            Jass::SetProjectileWeaponType( proj, Jass::WEAPON_TYPE_WHOKNOWS );
            Jass::SetProjectileArc( proj, .0f );
            Jass::SetProjectileSpeed( proj, 1500.f );
            Jass::LaunchProjectileTarget( proj, Jass::LoadUnitHandle( DataHT, hid, 'utrg' ) );
            Jass::SaveInteger( DataHT, Jass::GetHandleId( proj ), 'atid', Jass::LoadInteger( DataHT, hid, 'atid' ) );

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void R( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::StopHero( SoundHT, source, 'psnd' + 'Q1' );
            Sound::StopHero( SoundHT, source, 'psnd' + 'R2' );

            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 90.f, .0f );
            Jass::SetUnitTimeScale( source, 2 );
            StunUnit( source, .2f );
            Jass::SetUnitAnimation( source, "attack" );

            //Jass::SaveGroupHandle( DataHT, hid, 'grpr', Jass::CreateGroup( ) );
        }
        else if ( ticks == 20 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );

            effect ef = EffectAPI::CreateEx( "Characters\\Akainu\\moon_shin_dph23.mdl", Jass::MathPointProjectionX( x, angle, 300.f ), Jass::MathPointProjectionY( y, angle, 300.f ), 100.f, angle, 2.f, 1.f );
            EffectAPI::SetTimedLife( ef, 1.f );

            Jass::SetUnitTimeScale( source, 1.f );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 60.f, .0f );
        }
        else if ( ticks > 20 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            group g = Jass::LoadGroupHandle( DataHT, hid, 'grpr' );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );
            float dist = Jass::LoadReal( DataHT, hid, 'edst' ) + 100.f;
            float x = Jass::MathPointProjectionX( Jass::LoadReal( DataHT, hid, 'srcX' ), angle, dist );
            float y = Jass::MathPointProjectionY( Jass::LoadReal( DataHT, hid, 'srcY' ), angle, dist );

            Jass::SaveReal( DataHT, hid, 'edst', dist );

            for ( int i = 0; i < 2; i++ )
            {
                float efAngle = Jass::GetRandomReal( 0.f, 360.f );
                float efDist = Jass::GetRandomReal( 0.f, 500.f );
                float efX = Jass::MathPointProjectionX( x, efAngle, efDist );
                float efY = Jass::MathPointProjectionY( y, efAngle, efDist );

                Jass::DestroyEffect( EffectAPI::CreateEx( "Characters\\Akainu\\magmablast2.mdl", efX, efY, 120.f, Jass::GetRandomReal( 0.f, 360.f ), .5f, 1.f ) );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "abilities\\weapons\\catapult\\catapultmissile.mdl", efX, efY ) );
            }

            float dmg = 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 500.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) && !Jass::IsUnitInGroup( u, g ) )
                {
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 1.f );
                    Jass::GroupAddUnit( g, u );
                }
            }

            if ( dist >= 1500.f )
            {
                Jass::GroupClear( g );
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }
        }
    }

    void T( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
        {
            Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'T1' );
            HandleListCleanEffects( Jass::LoadHandleList( DataHT, hid, 'elst' ), true, true );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            StunUnit( source, 50 * .025f );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 100.f, .0f );
            Jass::SetUnitAnimation( source, "Spell" );
            Jass::SaveHandleList( DataHT, hid, 'elst', Jass::HandleListCreate( ) );
            // "Characters\\Akainu\\moon_shin_dph12.mdl"
        }
        else if ( ticks >= 10 )
        {
            handlelist eflist = Jass::LoadHandleList( DataHT, hid, 'elst' );
            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );

            if ( SpellAPI::Counter( DataHT, hid, 0, 5 ) )
            {
                int count = Jass::LoadInteger( DataHT, hid, 'cout' );

                if ( count < 50 )
                {
                    float dist = Jass::GetRandomReal( 0.f, 550.f );
                    float face = Jass::GetRandomReal( 0.f, 360.f );

                    effect ef = EffectAPI::CreateEx( "Characters\\Akainu\\moon_shin_dph12.mdl", Jass::MathPointProjectionX( targX, face, dist ), Jass::MathPointProjectionY( targY, face, dist ), 1000.f, Jass::GetRandomReal( 0.f, 360.f ), .4f, .0f );
                    Jass::SetSpecialEffectAnimationOffsetPercent( ef, .75f );
                    //Jass::SetSpecialEffectPitch( ef, Jass::GetRandomReal( -10.f, -45.f ) );
                    Jass::HandleListAddHandle( eflist, ef );

                    Jass::SaveInteger( DataHT, hid, 'cout', count + 1 );
                }
            }

            int maxCount = Jass::HandleListGetEffectCount( eflist );

            for ( int i = 0; i < maxCount; i++ )
            {
                effect ef = Jass::HandleListGetEffectByIndex( eflist, i );
                float x = Jass::GetSpecialEffectX( ef );
                float y = Jass::GetSpecialEffectY( ef );
                float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
                float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
                float newHeight = Jass::GetSpecialEffectHeight( ef ) - Jass::GetRandomReal( 15.f, 25.f );

                if ( dist >= 20.f )
                {
                    Jass::SetSpecialEffectX( ef, Jass::MathPointProjectionX( x, angle, 20.f ) );
                    Jass::SetSpecialEffectY( ef, Jass::MathPointProjectionY( y, angle, 20.f ) );
                }
                Jass::SetSpecialEffectHeight( ef, newHeight );

                if ( newHeight <= .0f )
                {
                    player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                    unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                    float dmg = 25.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true ) * .05f;
                    group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                    Jass::GroupEnumUnitsInRange( gEnum, Jass::GetSpecialEffectX( ef ), Jass::GetSpecialEffectY( ef ), 500.f, nil );

                    for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                    {
                        if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                        {
                            DamageTarget( source, u, dmg );
                        }
                    }

                    Jass::HandleListRemoveHandle( eflist, ef );
                    Jass::SetSpecialEffectTimeScale( ef, 1.f );
                    Jass::DestroyEffect( ef );
                    maxCount--;
                    i--;
                }
            }

            if ( maxCount == 0 )
            {
                HandleListCleanEffects( Jass::LoadHandleList( DataHT, hid, 'elst' ), true, true );
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }
        }
    }

    void Release( unit u )
    {
        if ( u == nil ) { return; }

        int hid = Jass::GetHandleId( u );

        if ( Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
        {
        }

        if ( Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'D1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'Q1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'W1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T1' ) );
        }

		Jass::DestroyGroup( Jass::LoadGroupHandle( DataHT, hid, 'egrp' ) );
        Jass::DestroyGroup( Jass::LoadGroupHandle( DataHT, hid, 'grpr' ) );
        Jass::DestroyTrigger( Jass::LoadTriggerHandle( DataHT, hid, '+trg' ) );
        Jass::FlushChildHashtable( DataHT, hid );
		Jass::FlushChildHashtable( SoundHT, hid );
    }

    void Init( unit u, hashtable whichHashTable, hashtable whichSoundTable, uint32 loadFlags = ( 1 | 2 ) )
    {
        if ( u == nil ) { return; }

        if ( DataHT == nil || ( loadFlags & 1 ) == 1 )
        {
            DataHT = whichHashTable;
        }

        if ( SoundHT == nil || ( loadFlags & 2 ) == 2 )
        {
            SoundHT = whichSoundTable;
        }

        int hid = Jass::GetHandleId( u );

        if ( !Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
        {

            Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
        }

        if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            string path = "Characters\\Akainu\\Sounds\\AkainuSpell";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', Sound::Create( path + "DSound.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', Sound::Create( path + "QSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', Sound::Create( path + "WSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', Sound::Create( path + "ESound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', Sound::Create( path + "RSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', Sound::Create( path + "RSound2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', Sound::Create( path + "TSound1.mp3" ) );

            Jass::SaveBoolean( SoundHT, hid, 'psnd', true );
        }

        if ( Jass::LoadTriggerHandle( DataHT, hid, '+trg' ) == nil )
        {
            trigger trg = Jass::CreateTrigger();

            TriggerAPI::RegisterUnitEvent
            (
                trg,
                Jass::EVENT_UNIT_SPELL_EFFECT,
                u,
                null,
                function()
                {
                    ability abil = Jass::GetSpellAbility( );
                    unit source = Jass::GetTriggerUnit( );
                    unit target = Jass::GetSpellTargetUnit( );
                    float targX = Jass::GetSpellTargetX( );
                    float targY = Jass::GetSpellTargetY( );
                    int aid = Jass::GetAbilityTypeId( abil );

                    switch( aid )
                    {
                        case D_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @D ); break;
                        case Q_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @Q ); break;
                        case W_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @W ); break;
                        case E_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @E ); break;
                        case R_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @R ); break;
                        case T_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @T ); break;
                    }
                }
            );

            Jass::SaveTriggerHandle( DataHT, hid, '+trg', trg );
            Jass::SaveGroupHandle( DataHT, hid, 'egrp', Jass::CreateGroup() );
            Jass::SaveGroupHandle( DataHT, hid, 'grpr', Jass::CreateGroup() );
        }

        int uid = Jass::GetUnitTypeId( u );

        if ( !Jass::LoadBoolean( DataHT, uid, 'INIT' ) )
        {

            Jass::SaveBoolean( DataHT, uid, 'INIT', true );
        }
    }

    Character GetInfo( )
    {
        return Character( UNIT_TYPE_ID, ITEM_TYPE_ID, BUFF_TYPE_ID, ICON_PATH, MODEL_PATH, SCALE );
    }

    void AddData( hashtable ht )
    {
        GetInfo( ).AddData( ht );
    }
}
