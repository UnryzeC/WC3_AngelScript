#include "Base.as"

namespace Scathach
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00H';
    const uint32 ITEM_TYPE_ID = 'I01P';
    const uint32 BUFF_TYPE_ID = '0000';
    const string MODEL_PATH = "Characters\\Scathach\\Scathach";
    const string ICON_PATH = "Characters\\Scathach\\ReplaceableTextures\\CommandButtons\\BTNScathachIcon.blp";
    const float SCALE = 2.4f;
    const uint32 D_TYPE_ID = 'A050';
    const uint32 Q1_TYPE_ID = 'A040';
    const uint32 Q2_TYPE_ID = 'A03Y';
    const uint32 Q3_TYPE_ID = 'A03Z';
    const uint32 W_TYPE_ID = 'A041';
    const uint32 E_TYPE_ID = 'A042';
    const uint32 R_TYPE_ID = 'A043';
    const uint32 T_TYPE_ID = 'A044';

    void SetQState( unit u, int state = 0 )
    {
        Jass::ShowUnitAbility( u, Q1_TYPE_ID, state == 0 );
        Jass::ShowUnitAbility( u, Q2_TYPE_ID, state == 1 );
        Jass::ShowUnitAbility( u, Q3_TYPE_ID, state == 2 );
    }

    void ResetQ( unit u )
    {
        SetQState( u, 0 );
    }

    void Q1( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) || ticks == 300 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            if ( ticks != 300 )
            {
                Sound::StopHero( SoundHT, source, 'psnd' + 'Q3' );
            }

            ResetQ( source );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        else if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q3', 100.f, .0f );
            StunUnit( source, .55f );
            Jass::SetUnitFacing( source, GetUnitAngle( source, target ) );
            Jass::SetUnitAnimation( source, "Attack" );
            
        }
        else if ( ticks == 20 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            SetQState( source, Jass::GetUnitLevel( source ) >= 5 ? 1 : 0 );
            Jass::SetUnitFacing( source, angle );
            EffectAPI::Dash( source );
            War3Image::DisplaceLinear( source, angle, dist - 50.f, .35f, .02f, false, true );
        }
        else if ( ticks == 55 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float dmg = 100.f + 50.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

            StunUnit( target, 1.f );
            DamageTarget( source, target, dmg );
        }
    }

    void Q2( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) || ticks == 300 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::StopHero( SoundHT, source, 'psnd' + 'Q1' );
            ResetQ( source );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        else if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q2', 100.f, .0f );
            StunUnit( source, .15f );
            Jass::SetUnitAnimation( source, "spell Three" ); 
            War3Image::DisplaceLinear( source, angle, dist - 150.f, .1f, .02f, false, true );
        }
        else if ( ticks == 10 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dmg = 50.f + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

            SetQState( source, Jass::GetUnitLevel( source ) >= 8 ? 2 : 0 );
            EffectAPI::PushWind( source, target );
            War3Image::DisplaceLinear( target, angle, 200.f, .25f, .01f, false, false );
            DamageTarget( source, target, dmg );
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void Q3( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::StopHero( SoundHT, source, 'psnd' + 'Q1' );
            ResetQ( source );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 100.f, .0f );
            StunUnit( source, .45f );

            Jass::SetUnitFacing( source, angle );
            Jass::SetUnitAnimation( source, "Spell Three" );

            effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, .0f, 2.f, 1.f );
            EffectAPI::SetTimedLife( ef, 4.f );

            War3Image::DisplaceLinear( source, angle, dist - 150.f, .2f, .02f, false, true );
        }
        else if ( ticks == 20 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );

            ResetQ( source );
            Jass::SetUnitFacing( source, GetUnitAngle( source, target ) );
            Jass::SetUnitAnimation( source, "Spell Three" );
        }
        else if ( ticks == 45 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dmg = 100.f + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );
            effect ef;

            Jass::SetUnitFacing( source, angle );

            EffectAPI::PushWind( source, target );
            War3Image::DisplaceLinear( target, angle, 200.f, .5f, .01f, false, false );
            DamageTarget( source, target, dmg );


            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void W( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::StopHero( SoundHT, source, 'psnd' + 'W1' );
            Sound::StopHero( SoundHT, source, 'psnd' + 'Q3' );
            Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, 'eff' ) );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'W1', 100.f, .0f );
            StunUnit( source, .5f );
            Jass::SetUnitAnimation( source, "spell Throw" );

            effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, .0f, 2.f, 1.f );
            EffectAPI::SetTimedLife( ef, 4.f );

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
            Jass::SaveEffectHandle( DataHT, hid, '+eff', Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );

            Displacer::Unit::Move( source, angle, Jass::LoadReal( DataHT, hid, 'dist' ), .5f, .01f, 600.f );
        }
        else if ( ticks == 50 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q3', 100.f, .0f );
            
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\SlamEffect.mdx", x, y ) );
            Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );

            for ( int i = 0; i < 3; i++ )
            {
                effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 400.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 2.f );
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void E( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            HandleListCleanEffects( Jass::LoadHandleList( DataHT, hid, 'elst' ), true, true );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
            handlelist hl = Jass::HandleListCreate( );

            DisableTeleport( target, 1.f );
            StunUnit( source, 1.f );
            Jass::SetUnitPathing( source, false );
            Jass::SetUnitAnimation( source, "Spell Three" ); // was channel

            for ( int i = 0; i < 8; i++ )
            {
                float dist = 80.f * i;
                effect ef;

                ef = EffectAPI::CreateEx( "GeneralEffects\\OrbOfFire.mdl", Jass::MathPointProjectionX( x, angle - 160.f, dist ), Jass::MathPointProjectionY( y, angle - 160.f, dist ), 150.f, angle, 1.5f, 1.f );

                Jass::HandleListAddHandle( hl, ef );

                ef = EffectAPI::CreateEx( "GeneralEffects\\OrbOfFire.mdl", Jass::MathPointProjectionX( x, angle + 160.f, dist ), Jass::MathPointProjectionY( y, angle + 160.f, dist ), 150.f, angle, 1.5f, 1.f );

                Jass::HandleListAddHandle( hl, ef );
            }

            Jass::SaveHandleList( DataHT, hid, 'elst', hl );
        }
        else if ( ticks == 50 )
        {
            Jass::SaveInteger( DataHT, hid, 'tick', ticks + 5 );
            Jass::SaveBoolean( DataHT, hid, 'skip', true );
        }
        else if ( ticks == 55 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
            float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
            handlelist hl = Jass::LoadHandleList( DataHT, hid, 'elst' );

            if ( SpellAPI::Counter( DataHT, hid, 0, 10 ) )
            {
                StunUnit( source, .1f );
            }

            if ( dist >= 150.f )
            {
                Jass::SetUnitFacing( source, angle );
                SetUnitXY( source, Jass::MathPointProjectionX( x, angle, 50.f ), Jass::MathPointProjectionY( y, angle, 50.f ) );
            }
            else
            {
                Jass::SetUnitAnimation( source, "spell Seven" );
                Sound::PlayHero( SoundHT, source, 'psnd' + 'R1', 100.f, .0f );
                Jass::SaveBoolean( DataHT, hid, 'skip', false );
                //HandleListCleanEffects( Jass::LoadHandleList( DataHT, hid, 'elst' ), true, true );
            }

            for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
            {
                effect ef = Jass::HandleListGetEffectByIndex( hl, i );
                angle = Jass::GetSpecialEffectFacing( ef );

                Jass::SetSpecialEffectPosition( ef, Jass::MathPointProjectionX( Jass::GetSpecialEffectX( ef ), angle, 50.f ), Jass::MathPointProjectionY( Jass::GetSpecialEffectY( ef ), angle, 50.f ) );
            }
        }
        else if ( ticks == 60 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
            effect ef;

            Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 100.f, .0f );
            Jass::SetUnitFacing( source, angle );
            Jass::SetUnitAnimation( source, "spell four" );

            EffectAPI::PushWind( source, target );

            ef = EffectAPI::CreateEx( "GeneralEffects\\t_huobao.mdl", targX, targY, 100.f, angle, .5f, 1.f );
            Jass::SetSpecialEffectPitch( ef, -90.f );
            EffectAPI::SetTimedLife( ef, 2.f );

            Jass::SaveInteger( DataHT, hid, 'tick', ticks + 5 );
            Jass::SaveBoolean( DataHT, hid, 'skip', true );

            float dist = 500.f;
            Jass::SaveReal( DataHT, hid, 'angl', GetUnitAngle( source, target ) );
            Jass::SaveReal( DataHT, hid, 'dist', dist );
            Jass::SaveReal( DataHT, hid, '+spd', dist * .01f / .4f ); // dist * tickRate / time
        }
        else if ( ticks == 65 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );
            float speed = Jass::LoadReal( DataHT, hid, '+spd' );
            handlelist hl = Jass::LoadHandleList( DataHT, hid, 'elst' );

            if ( SpellAPI::Counter( DataHT, hid, 0, 10 ) )
            {
                StunUnit( source, .1f );
            }

            if ( dist >= 0.f )
            {
                SetUnitXY( target, Jass::MathPointProjectionX( targX, angle, speed ), Jass::MathPointProjectionY( targY, angle, speed ) );

                if ( SpellAPI::Counter( DataHT, hid, 1, 5 ) )
                {
                    Jass::DestroyEffect( Jass::AddSpecialEffect( "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", targX, targY ) );
                }

                for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
                {
                    effect ef = Jass::HandleListGetEffectByIndex( hl, i );
                    angle = Jass::GetSpecialEffectFacing( ef );

                    Jass::SetSpecialEffectPosition( ef, Jass::MathPointProjectionX( Jass::GetSpecialEffectX( ef ), angle, speed ), Jass::MathPointProjectionY( Jass::GetSpecialEffectY( ef ), angle, speed ) );
                }
            }
            else
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );

                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", targX, targY ) );

                for ( int i = 0; i < 10; i++ )
                {
                    effect ef = EffectAPI::CreateEx( "GeneralEffects\\t_huobao.mdl", targX, targY, 100.f, 36.f * i, 2.f, 1.f );
                    Jass::SetSpecialEffectPitch( ef, -90.f );
                    EffectAPI::SetTimedLife( ef, 2.f ); 
                }

                float dmg = 75.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 600.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                    {
                        DamageTarget( source, u, dmg );
                    }
                }

                HandleListCleanEffects( hl, true, true );
                //Jass::SaveBoolean( DataHT, hid, 'skip', false );
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }

            Jass::SaveReal( DataHT, hid, 'dist', dist - speed );
        }
    }

    void R( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) )
        {
            Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'E1' );

            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'E1', 80.f, .0f );
            StunUnit( source, 1.25f );
            Jass::SetUnitTimeScale( source, 2.f );
            Jass::SetUnitAnimation( source, "spell Three" ); // attack?
            DisableTeleport( target, 1.25f );
            War3Image::DisplaceLinear( source, angle, GetUnitDistance( source, target ) - 100.f, .2f, .01f, false, false );

            for ( int i = 0; i < 3; i++ )
            {
                effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, Jass::GetRandomReal( 0.f, 360.f ), .5f * ( i + 1 ), 2.f + .25 * i );
                EffectAPI::SetTimedLife( ef, 4.f );
            }
        }
        else if ( ticks >= 20 && ticks <= 120 )
        {
            if ( SpellAPI::Counter( DataHT, hid, 0, 20 ) )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float targX = Jass::GetUnitX( target );
                float targY = Jass::GetUnitY( target );
                float angle = GetUnitAngle( source, target );
                float dist = GetUnitDistance( source, target );
                float dmg = 25.f * Jass::GetHeroLevel( source ) + .2f * Jass::GetHeroInt( source, true );
                effect ef;

                Jass::SetUnitAnimationWithRarity( source, "attack", Jass::RARITY_RARE );
                Jass::SetUnitFacing( source, angle );

                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 50.f, angle, 1.5f, 2.f );
                Jass::SetSpecialEffectPitch( ef, -90.f );
                EffectAPI::SetTimedLife( ef, 4.f );

                ef = EffectAPI::CreateEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, 50.f, angle, 1.f, 2.f );
                Jass::SetSpecialEffectPitch( ef, -90.f );
                EffectAPI::SetTimedLife( ef, 3.f );

                War3Image::DisplaceLinear( target, angle, 50.f, .2f, .01f, false, false );
                if ( DamageTarget( source, target, dmg ) )
                {
                    if ( ticks <= 100 )
                    {
                        War3Image::DisplaceLinear( source, angle, dist - 50.f, .2f, .01f, false, false );
                    }
                    else
                    {
                        ef = EffectAPI::CreateEx( "GeneralEffects\\t_huobao.mdl", targX, targY, 100.f, angle, .5f, 1.f );
                        Jass::SetSpecialEffectPitch( ef, -90.f );
                        EffectAPI::SetTimedLife( ef, 2.f );
                        StunUnit( target, 2.f );
                        SpellAPI::ReleaseTimer( DataHT, tmr );
                    }
                }
            }
        }
    }

    void T( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
        
            Sound::StopHero( SoundHT, source, 'psnd' + 'Q1' );
            Sound::StopHero( SoundHT, source, 'psnd' + 'T1' );
            Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::MathAngleBetweenPoints( x, y, Jass::LoadReal( DataHT, hid, 'trgX' ), Jass::LoadReal( DataHT, hid, 'trgY' ) );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 100.f, .0f );
            StunUnit( source, 1.f );
            Jass::SetUnitAnimation( source, "spell Three" );

            effect ef = EffectAPI::CreateEx( "GeneralEffects\\laxus_lightning_spear.mdl", x, y, 50.f, angle, 2.f, 1.f );
            Jass::SetSpecialEffectColour( ef, 0x64840000 );

            Jass::SaveEffectHandle( DataHT, hid, '+eff', ef );
        }
        else if ( ticks < 100 )
        {
            if ( SpellAPI::Counter( DataHT, hid, 0, 5 ) )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );
                float angle = Jass::MathAngleBetweenPoints( x, y, Jass::LoadReal( DataHT, hid, 'trgX' ), Jass::LoadReal( DataHT, hid, 'trgY' ) );
                effect ef = Jass::LoadEffectHandle( DataHT, hid, '+eff' );

                Jass::SetUnitFacing( source, angle );
                Jass::SetSpecialEffectFacing( ef, angle );
                Jass::SetSpecialEffectScale( ef, 2.f + ticks / 50.f );
            }
        }
        else if ( ticks == 100 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float dist = Jass::MathDistanceBetweenPoints( x, y, Jass::LoadReal( DataHT, hid, 'trgX' ), Jass::LoadReal( DataHT, hid, 'trgY' ) );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 100.f, .0f );

            for ( int i = 0; i < 8; i++ )
            {
                effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + i / 5.f, 1.25f );
                Jass::SetSpecialEffectAlpha( ef, 0x50 );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            Jass::SetUnitAnimation( source, "spell Four" );
            Jass::SaveReal( DataHT, hid, 'dist', dist );
        }
        else if ( ticks > 100 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            effect ef = Jass::LoadEffectHandle( DataHT, hid, '+eff' );
            float efX = Jass::GetSpecialEffectX( ef );
            float efY = Jass::GetSpecialEffectY( ef );
            float angle = Jass::GetSpecialEffectFacing( ef );
            float moveX = Jass::MathPointProjectionX( efX, angle, 50.f );
            float moveY = Jass::MathPointProjectionY( efY, angle, 50.f );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );

            if ( dist >= 100.f )
            {
                Jass::SetSpecialEffectPosition( ef, moveX, moveY );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", efX, efY ) );

                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, moveX, moveY, 450.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                    {
                        float x = Jass::GetUnitX( u );
                        float y = Jass::GetUnitY( u );
                        float toAngle = Jass::MathAngleBetweenPoints( x, y, moveX, moveY );

                        SetUnitXY( u, Jass::MathPointProjectionX( x, toAngle, 50.f ), Jass::MathPointProjectionY( y, toAngle, 50.f ) );
                    }
                }

                Jass::SaveReal( DataHT, hid, 'dist', dist - 50.f );
            }
            else
            {
                Sound::PlayHero( SoundHT, source, 'gsnd' + 2, 80.f, .0f );

                Jass::DestroyEffect( ef );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", efX, efY ) );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", efX, efY ) );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", efX, efY ) );

                for ( int i = 0; i < 8; i++ )
                {
                    ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", efX, efY, .0f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + i / 5.f, 1.25f );
                    Jass::SetSpecialEffectAlpha( ef, 0x50 );
                    EffectAPI::SetTimedLife( ef, 4.f );
                }

                float dmg = 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, efX, efY, 450.f, nil );

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
    }

    void Release( unit u )
    {
        if ( u == nil ) { return; }

        int hid = Jass::GetHandleId( u );

        if ( Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
        {
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'gsnd' + 2 ) );
        }

        if ( Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'Q1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'Q2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'Q3' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'W1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T1' ) );
        }

		Jass::DestroyGroup( Jass::LoadGroupHandle( DataHT, hid, 'egrp' ) );
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
            Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, Sound::Create( "GeneralSounds\\GlassShatterSound.mp3" ) );

            Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
        }

        if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            string path = "Characters\\Scathach\\Sounds\\ScathachSpell";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', Sound::Create( path + "QFirstSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q2', Sound::Create( path + "QSecondSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q3', Sound::Create( path + "QThirdSound1.mp3" ) );
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
                        case Q1_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @Q1 ); break;
                        case Q2_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @Q2 ); break;
                        case Q3_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @Q3 ); break;
                        case W_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @W ); break;
                        case E_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @E ); break;
                        case R_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @R ); break;
                        case T_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @T ); break;
                    }
                }
            );

            Jass::SaveTriggerHandle( DataHT, hid, '+trg', trg );
            Jass::SaveGroupHandle( DataHT, hid, 'egrp', Jass::CreateGroup() );
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
