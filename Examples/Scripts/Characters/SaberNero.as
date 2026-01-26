#include "Base.as"

namespace SaberNero
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00E';
    const uint32 ITEM_TYPE_ID = 'I008';
    const uint32 BUFF_TYPE_ID = '0000';
    const string MODEL_PATH = "Characters\\SaberNero\\SaberNero";
    const string ICON_PATH = "Characters\\SaberNero\\ReplaceableTextures\\CommandButtons\\BTNSaberNeroIcon.blp";
    const float SCALE = 2.4f;
    const uint32 D1_TYPE_ID = 'A04Q';
    const uint32 D2_TYPE_ID = 'A04P';
    const uint32 Q_TYPE_ID = 'A038';
    const uint32 W_TYPE_ID = 'A039';
    const uint32 E_TYPE_ID = 'A03A';
    const uint32 R_TYPE_ID = 'A03B';
    const uint32 T_TYPE_ID = 'A03C';

    void Q( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 100.f, .0f );
            EffectAPI::Dash( source );
            StunUnit( source, .5f );
            Jass::SetUnitTimeScale( source, 1.5f );
            Jass::SetUnitAnimation( source, "spell two" );
            War3Image::DisplaceLinear( source, angle, dist, .5f, .01f, false, true );
        }
        else if ( ticks == 50 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float angle = Jass::GetUnitFacing( source );
            float x = Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, 200.f );
            float y = Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, 200.f );

            for ( int i = 0; i < 2; i++ )
            {
                effect ef = EffectAPI::CreateEx( "Characters\\SaberNero\\SaberNeroFireCutEffect.mdl", x, y, .0f, angle, 2.5f, 1.f );
                EffectAPI::SetTimedLife( ef, 1.f );
            }

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 400.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
                    War3Image::DisplaceLinear( u, GetUnitAngle( source, u ), 200.f, .3f, .01f, false, false );
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void W( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'W1', 100.f, .0f );
            StunUnit( source, .4f );
            Jass::SetUnitAnimation( source, "attack slam" );
        }
        else if ( ticks == 40 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            effect ef;

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );

            ef = EffectAPI::CreateEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, .0f, 270.f, 4.f, 1.f );

            for ( int i = 0; i < 8; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
                Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            float dmg = 250 + Jass::GetHeroLevel( source ) * 50 + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 450.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 1.f );
                    War3Image::DisplaceLinear( u, GetUnitAngle( source, u ), 200.f, .25f, .01f, false, false );
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
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'E1', 100.f, .0f );
            
            StunUnit( source, 1.7f );
            Jass::SetUnitTimeScale( source, 1.5f );
            Jass::SetUnitAnimation( source, "Spell Three" );
            War3Image::DisplaceLinear( source, angle, dist - 150.f, .1f, .015f, false, true );
        }
        else if ( ticks == 10 )
        {
            StunUnit( Jass::LoadUnitHandle( DataHT, hid, 'utrg' ), .35f );
        }
        else if ( ticks >= 35 && ticks <= 140 )
        {
            if ( SpellAPI::Counter( DataHT, hid, 0, 35 ) )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float targX = Jass::GetUnitX( target );
                float targY = Jass::GetUnitY( target );
                float dmg = 10.f * Jass::GetHeroLevel( source );

                Jass::SetUnitFacing( source, GetUnitAngle( source, target ) );
                DamageTarget( source, target, dmg );
                StunUnit( target, .35f );

                effect ef = EffectAPI::CreateEx( "GeneralEffects\\qqqqq.mdl", targX, targY, 100.f, Jass::GetRandomReal( 0.f, 360.f ), 1.2f, 1.f );
                EffectAPI::SetTimedLife( ef, 1.f );

                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\RedAftershock.mdx", targX, targY ) );
                Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", target, "chest" ) );
            }
        }
        else if ( ticks == 170 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            effect ef;

            ef = EffectAPI::CreateEx( "GeneralEffects\\lssdqiu.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );
            EffectAPI::SetTimedLife( ef, 1.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\moonwrath.mdl", targX, targY, .0f, .0f, 4.f, 1.f );
            EffectAPI::SetTimedLife( ef, 4.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\apocalypsecowstomp.mdl", targX, targY, .0f, .0f, 1.5f, 1.f );
            Jass::SetSpecialEffectColour( ef, 0xFFFF00FF );

            for ( int i = 0; i < 8; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
                Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            float dmg = 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 400.f, nil );

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

    void R( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'R1', 100.f, .0f );
            StunUnit( source, 1.85f );
            Jass::SetUnitFacing( source, Jass::LoadReal( DataHT, hid, 'angl' ) );
            Jass::SetUnitAnimation( source, "spell One" );
            Jass::SaveReal( DataHT, hid, 'circ', 800 );
        }

        if ( ticks < 80 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            float circle = Jass::LoadReal( DataHT, hid, 'circ' );

            DisplaceCircular( p, Jass::LoadReal( DataHT, hid, 'trgX' ), Jass::LoadReal( DataHT, hid, 'trgY' ), 300.f, circle, 1.f, "Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl" );

            Jass::SaveReal( DataHT, hid, 'circ', circle - 10.f );
        }
        else if ( ticks == 80 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float angle = Jass::GetUnitFacing( source );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );

            Jass::SetUnitAnimation( source, "spell channel one" );
            War3Image::DisplaceLinear( source, angle, dist * .4f, .5f, .01f, false, false );
        }
        else if ( ticks == 130 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::GetUnitFacing( source );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );
            effect ef;

            Jass::SetUnitAnimation( source, "attack slam" );

            Displacer::Unit::Move( source, angle, ( dist * .6f ), .6f, .01f, 600.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\wave.mdl", x, y, 200.f, angle, 2.f, 1.f );
            EffectAPI::SetTimedLife( ef, 3.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.f, 2.f );
            EffectAPI::SetTimedLife( ef, 3.f );

            for ( int i = 0; i < 4; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
                Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                EffectAPI::SetTimedLife( ef, 4.f );
            }
        }
        else if ( ticks == 185 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );
            effect ef = EffectAPI::CreateEx( "GeneralEffects\\FuzzyStomp.mdl", targX, targY, .0f, 270.f, 6.f, 1.f );

            for ( int i = 0; i < 12; i++ )
            {
                if ( i < 8 )
                {
                    ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 4.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
                    Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                    EffectAPI::SetTimedLife( ef, 4.f );
                }

                for ( int j = 0; j < 3; j++ )
                {
                    float efX = Jass::MathPointProjectionX( targX, 30.f * i, 200.f + 200.f * j );
                    float efY = Jass::MathPointProjectionY( targY, 30.f * i, 200.f + 200.f * j );

                    ef = EffectAPI::CreateEx( "GeneralEffects\\ioncannonbeam.mdl", efX, efY, 50.f, .0f, 10.f, 1.f );
                    Jass::SetSpecialEffectColour( ef, 0xFFFF6400 );
                    Jass::SetSpecialEffectAnimation( ef, "birth" );
                    EffectAPI::SetTimedLife( ef, 1.5f );
                }
            }

            float dmg = 2000.f + 125.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 800.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 2.f );
                    Displacer::Unit::Move( u, GetUnitAngle( source, u ), 1000.f, 1, .01f, 600.f );
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void T( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            StunUnit( source, 4.1f );
            Jass::SetUnitTimeScale( source, 1.5f );
            Jass::SetUnitAnimation( source, "Spell Fly Slam" );

            Jass::SaveBoolean( DataHT, hid, 'skip', true );
            Jass::SaveInteger( DataHT, hid, 'tick', 5 );
        }
        else if ( ticks == 5 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );

            if ( War3Image::DisplaceToTarget( source, target, 50.f, 150.f ) )
            {
                Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 100.f, .0f );
                Jass::SetUnitAnimation( source, "Spell Three" );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\RedAftershock.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );

                Jass::SaveBoolean( DataHT, hid, 'skip', false );
                Jass::SaveInteger( DataHT, hid, 'tick', 30 );

                return;
            }
        }
        else if ( ticks >= 30 && ticks <= 120 )
        {
            if ( SpellAPI::Counter( DataHT, hid, 0, 30 ) )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float targX = Jass::GetUnitX( target );
                float targY = Jass::GetUnitY( target );
                float angle = GetUnitAngle( source, target );
                float dmg = 20.f * Jass::GetHeroLevel( source );

                DamageTarget( source, target, dmg );
                Jass::SetUnitFacing( source, angle );

                effect ef = EffectAPI::CreateEx( "GeneralEffects\\qqqqq.mdl", targX, targY, 100.f, Jass::GetRandomReal( 0.f, 360.f ), 1.2f, 1.f );
                EffectAPI::SetTimedLife( ef, 1.f );

                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\RedAftershock.mdx", targX, targY ) );
                Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", target, "chest" ) );
            }
        }
        else if ( ticks == 170 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float dmg = 20.f * Jass::GetHeroLevel( source );
            effect ef;

            Jass::SetUnitTimeScale( source, 1.f );

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", targX, targY ) );
            for ( int i = 0; i < 8; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 4.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
                Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            DamageTarget( source, target, dmg );
            Displacer::Unit::Move( target, 0, 0, .9f, .01f, 600.f );
            Jass::SetUnitAnimation( source, "Spell Five" );
        }
        else if ( ticks == 250 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            float dmg = 20.f * Jass::GetHeroLevel( source );
            effect ef;

            Sound::PlayHero( SoundHT, source, 'gsnd' + 1, 60.f, .0f );

            Jass::SetUnitAnimation( source, "Spell One" );

            ef = EffectAPI::CreateEx( "GeneralEffects\\wave.mdl", targX, targY, 200.f, angle, 2.f, 1.f );
            Jass::SetSpecialEffectPitch( ef, -90.f );
            EffectAPI::SetTimedLife( ef, 3.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, 50.f, angle, 1.f, 2.f );
            Jass::SetSpecialEffectPitch( ef, -90.f );
            EffectAPI::SetTimedLife( ef, 3.f );

            for ( int i = 0; i < 3; i++ )
            {
                ef = EffectAPI::CreateEx( "Characters\\SaberNero\\SaberNeroFireCutEffect.mdl", x, y, .0f, angle, 2.5f, 1.f );
                EffectAPI::SetTimedLife( ef, 1.f );
            }

            DamageTarget( source, target, dmg );

            EffectAPI::PushWind( source, target );

            War3Image::DisplaceLinear( target, angle, 500.f, 1, .01f, false, false );
        }
        else if ( ticks == 330 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            Jass::SetUnitAnimation( source, "Attack Slam" );
            EffectAPI::Dash( source );
            
            Displacer::Unit::Move( source, angle, 950.f, .8f, .01f, 600.f );
        }
        else if ( ticks == 410 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float dmg = 180.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            effect ef = EffectAPI::CreateEx( "GeneralEffects\\FuzzyStomp.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 2, 80.f, .0f );

            for ( int i = 0; i < 10; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\BlinkNew.mdl", targX, targY, 200.f, 36.f * i, .5f * i, 1.5f - .1f * i );
                Jass::SetSpecialEffectColour( ef, 0xFF6000FF );
                EffectAPI::SetTimedLife( ef, 4.f );

                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 4.5f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
                Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
            DamageTarget( source, target, dmg );
            StunUnit( target, 1.f );
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void Release( unit u )
    {
        if ( u == nil ) { return; }

        int hid = Jass::GetHandleId( u );

        if ( Jass::LoadBoolean( SoundHT, hid, 'gsnd' ) )
        {
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'gsnd' + 1 ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'gsnd' + 2 ) );
        }

        if ( Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'D1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'W1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T1' ) );
        }

        Jass::DestroyGroup( Jass::LoadGroupHandle( DataHT, hid, 'egrp' ) );
        Jass::DestroyTrigger( Jass::LoadTriggerHandle( DataHT, hid, '+trg' ) );
        Jass::DestroyTimer( Jass::LoadTimerHandle( DataHT, hid, '+tmr' ) );
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
            Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, Sound::Create( "GeneralSounds\\KickSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, Sound::Create( "GeneralSounds\\GlassShatterSound.mp3" ) );

            Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
        }

        if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            string path = "Characters\\SaberNero\\Sounds\\SaberNeroSound";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', Sound::Create( path + "Q1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', Sound::Create( path + "W1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', Sound::Create( path + "E1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', Sound::Create( path + "R2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', Sound::Create( path + "T1.mp3" ) );

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
                        case Q_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @Q ); break;
                        case W_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @W ); break;
                        case E_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @E ); break;
                        case R_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @R ); break;
                        case T_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @T ); break;
                    }
                }
            );

            Jass::SaveTriggerHandle( DataHT, hid, '+trg', trg );
            Jass::SaveGroupHandle( DataHT, hid, 'egrp', Jass::CreateGroup() );
        }

        if ( Jass::LoadTimerHandle( DataHT, hid, '+tmr' ) == nil )
        {
            timer tmr = Jass::CreateTimer( );
            int t_hid = Jass::GetHandleId( tmr );
            Jass::SaveUnitHandle( DataHT, t_hid, 'usrc', u );
            Jass::TimerStart
            (
                tmr,
                1.f,
                true,
                function( )
                {
                    int hid = Jass::GetHandleId( Jass::GetExpiredTimer( ) );
                    unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' ); if ( Jass::IsUnitDead( source ) ) { return; }
                    float hpMax = Jass::GetUnitMaxLife( source );
                    float hpCur = Jass::GetUnitCurrentLife( source );
                    Jass::SetUnitCurrentLife( source, ( hpMax - hpCur ) * .04f + hpCur );
                }
            );

            Jass::SaveTimerHandle( DataHT, hid, '+tmr', tmr );
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