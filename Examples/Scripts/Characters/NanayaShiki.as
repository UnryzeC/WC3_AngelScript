#include "Base.as"

namespace NanayaShiki
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00A';
    const uint32 ITEM_TYPE_ID = 'I006';
    const uint32 BUFF_TYPE_ID = 'B001';
    const string MODEL_PATH = "Characters\\NanayaShiki\\NanayaShiki";
    const string ICON_PATH = "Characters\\NanayaShiki\\ReplaceableTextures\\CommandButtons\\BTNNanayaShikiIcon.blp";
    const float SCALE = 1.4f;
    const uint32 D_TYPE_ID = 'A02P';
    const uint32 Q_TYPE_ID = 'A02M';
    const uint32 W_TYPE_ID = 'A02N';
    const uint32 E_TYPE_ID = 'A02O';
    const uint32 R_TYPE_ID = 'A02Q';
    const uint32 T_TYPE_ID = 'A02R';

    void D( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            Sound::PlayHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'D1', 90.f, .0f );
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void Q( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
        {
            Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'Q1' );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            StunUnit( source, .3f );
            Jass::SetUnitAnimation( source, "spell slam one" );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 100.f, .0f );
        }
        else if ( ticks == 30 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );

            Jass::SetUnitAnimation( source, "spell throw six" );

            War3Image::DisplaceLinear( source, angle, dist, .1f, .01f, false, true );

            effect ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", Jass::MathPointProjectionX( x, angle, dist * .5f ), Jass::MathPointProjectionY( y, angle, dist * .5f ), .0f, angle, 3.f, 1.f );
            EffectAPI::SetTimedLife( ef, 3.f );

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            bool isEnhanced = Jass::GetUnitBuffLevel( source, BUFF_TYPE_ID ) > 0;
            if ( isEnhanced )
            {
                dmg *= 1.5f;
            }

            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );
            GroupEnumUnitsInLine( gEnum, x, y, angle, dist, 400.f );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    float u_x = Jass::GetUnitX( u );
                    float u_y = Jass::GetUnitY( u );

                    Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
                    War3Image::DisplaceLinear( u, Jass::MathAngleBetweenPoints( u_x, u_y, targX, targY ), 200.f, .5f, .01f, false, false );

                    DamageTarget( source, u, dmg );
                    if ( isEnhanced )
                    {
                        StunUnit( u, 1.f );
                    }
                }
            }

            Jass::UnitRemoveAbility( source, BUFF_TYPE_ID );

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void W( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
        {
            Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'W1' );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float dmg = 5.f * Jass::GetHeroLevel( source ) + .033f * Jass::GetHeroInt( source, true );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'W1', 100.f, .0f );
            StunUnit( source, .3f );
            Jass::SetUnitTimeScale( source, 2.f );
            Jass::SetUnitAnimation( source, "spell two" );
            Jass::SaveReal( DataHT, hid, '+dmg', Jass::GetUnitBuffLevel( source, BUFF_TYPE_ID ) == 0 ? dmg : 1.5f * dmg );
        }
        else
        {
            int slashes = Jass::LoadInteger( DataHT, hid, 'slsh' );

            if ( slashes < 30 )
            {
                if ( SpellAPI::Counter( DataHT, hid, 0, 2 ) )
                {
                    player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                    unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                    float x = Jass::GetUnitX( source );
                    float y = Jass::GetUnitY( source );
                    float angle = Jass::GetUnitFacing( source );
                    float dmg = Jass::LoadReal( DataHT, hid, '+dmg' );
                    bool isEffect = SpellAPI::Counter( DataHT, hid, 1, 10 );

                    effect ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\WEffect.mdl", Jass::MathPointProjectionX( x, angle, 150.f ), Jass::MathPointProjectionY( y, angle, 150.f ), .0f, angle, 1.5f, 1.f );
                    Jass::SetSpecialEffectAnimation( ef, "stand" );
                    Jass::SetSpecialEffectColour( ef, 0xFFFF00FF );
                    EffectAPI::SetTimedLife( ef, 1.f );

                    group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );
                    Jass::GroupEnumUnitsInRange( gEnum, Jass::GetSpecialEffectX( ef ), Jass::GetSpecialEffectY( ef ), 350.f, nil );

                    for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                    {
                        if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                        {
                            if ( isEffect )
                            {
                                Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
                                Jass::IssueImmediateOrder( u, "stop" );
                            }

                            if ( slashes == 29 )
                            {
                                Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", u, "chest" ) );
                            }

                            DamageTarget( source, u, dmg );
                        }
                    }

                    Jass::SaveInteger( DataHT, hid, 'slsh', slashes + 1 );
                }
            }
            else
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

                Jass::UnitRemoveAbility( source, BUFF_TYPE_ID );
                Jass::SetUnitAnimation( source, "stand" );
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }
        }
    }

    void E( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Jass::SaveBoolean( DataHT, hid, 'isex', Jass::GetUnitBuffLevel( source, BUFF_TYPE_ID ) > 0 );
            //DisableTeleport( target, Jass::GetUnitAbilityLevel( source, BUFF_TYPE_ID ) > 0 ? 1.5f : .5f );
        }

        if ( !Jass::LoadBoolean( DataHT, hid, 'isex' ) )
        {
            if ( SpellAPI::Stop( DataHT, hid, 1, true ) )
            {
                if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
                {
                    Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'R2' );
                }
                
                SpellAPI::ReleaseTimer( DataHT, tmr );
                return;
            }

            if ( ticks == 0 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float angle = GetUnitAngle( source, target );
                float dist = GetUnitDistance( source, target ) + 200.f;

                Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 90.f, .0f );

                StunUnit( source, .55f );
                Jass::SetUnitAnimation( source, "spell slam one" );
            }
            else if ( ticks == 50 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float targX = Jass::GetUnitX( target );
                float targY = Jass::GetUnitY( target );
                float angle = GetUnitAngle( source, target );
                float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

                SetUnitXY( source, Jass::MathPointProjectionX( targX, angle, 100.f ), Jass::MathPointProjectionY( targY, angle, 100.f ) );
                Jass::SetUnitAnimation( source, "spell throw six" );
                DamageTarget( source, target, dmg );
                StunUnit( target, 2.f );

                effect ef;

                ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, angle + 45.f, 2.f, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );

                ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, angle - 45.f, 2.f, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );

                Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }
        }
        else
        {
            if ( ticks < 125 )
            {
                if ( SpellAPI::Stop( DataHT, hid, 1, true ) )
                {
                    if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
                    {
                        Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'R2' );
                    }
                    
                    SpellAPI::ReleaseTimer( DataHT, tmr );
                    return;
                }
            }

            if ( ticks == 0 )
            {
                StunUnit( Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 1.5f );
            }
            else if ( ticks == 25 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float angle = GetUnitAngle( source, target );
                float dist = GetUnitDistance( source, target ) - 150.f;

                Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 90.f, .0f );
                Jass::SetUnitAnimation( source, "spell two alternate" );
                War3Image::DisplaceLinear( source, angle, dist, .25f, .01f, false, true );
            }
            else if ( ticks == 50 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float angle = GetUnitAngle( source, target );
                float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

                Sound::PlayHero( SoundHT, source, 'gsnd' + 1, 60.f, .0f );
                Jass::SetUnitAnimation( source, "spell slam one" );

                DamageTarget( source, target, dmg );
                Jass::SetUnitFlyHeight( target, 800.f, 4000.f );
                War3Image::DisplaceLinear( target, angle, 300.f, .4f, .01f, false, false, "" );
            }
            else if ( ticks == 75 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float angle = GetUnitAngle( source, target );
                float dist = GetUnitDistance( source, target ) - 150.f;

                Sound::PlayHero( SoundHT, source, 'psnd' + 'E1', 100.f, .0f );
                Jass::SetUnitFacing( source, angle );
                Jass::SetUnitAnimation( source, "spell throw three" );
                Jass::SetUnitFlyHeight( source, 600.f, 4000.f );
                SetUnitXY( source, Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, dist ), Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, dist ) );
            }
            else if ( ticks == 125 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float angle = GetUnitAngle( source, target );
                float dmg = 250.f + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );
                effect ef;

                Sound::PlayHero( SoundHT, source, 'psnd' + 'E2', 100.f, .0f );
                DamageTarget( source, target, dmg );

                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 800.f, angle, 1.5f, 3.f );
                EffectAPI::SetTimedLife( ef, 4.f );

                ef = EffectAPI::CreateEx( "GeneralEffects\\SlamEffect.mdl", x, y, 800.f, angle, 1.5f, 3.f );
                EffectAPI::SetTimedLife( ef, 3.f );

                Jass::SetUnitFlyHeight( target, 0.f, 2000.f );
                Jass::SetUnitFlyHeight( source, 0.f, 99999.f );
                War3Image::DisplaceLinear( target, angle, 400.f, .4f, .01f, false, false, "" );
            }
            else if ( ticks == 150 )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float targX = Jass::GetUnitX( target );
                float targY = Jass::GetUnitY( target );

                Jass::SetUnitAnimation( source, "spell throw two" );
                Jass::UnitRemoveAbility( source, BUFF_TYPE_ID );

                effect ef = EffectAPI::CreateEx( "GeneralEffects\\FuzzyStomp.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 3.f, 1.f );
                EffectAPI::SetTimedLife( ef, 1.f );

                for ( int i = 0; i < 5; i++ )
                {
                    float move = 25.f + 25.f * i;

                    ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 2.f, Jass::GetRandomReal( .5f, 2.f ) );
                    EffectAPI::SetTimedLife( ef, 4.f );
                }

                float dmg = 250.f + 25.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 500.f, nil );

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

    void R( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) || ticks == 305 )
        {

            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target ) - 200.f;

            Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 100.f, .0f );
            Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, D_TYPE_ID ), .01f );
            StunUnit( source, 3.f );
            Jass::SetUnitTimeScale( source, 2.f );
            Jass::SetUnitFacing( source, angle );
            Jass::SetUnitAnimation( source, "spell channel one" );
            War3Image::DisplaceLinear( source, angle, dist, .25f, .01f, false, true );
        }
        else if ( ticks == 25 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = 600.f;

            Jass::SetUnitAnimation( source, "spell throw four" );
            EffectAPI::InverseDash( target );

            War3Image::DisplaceLinear( source, angle, -dist * .5f, 1.f, .01f, false, false );
            War3Image::DisplaceLinear( target, angle, dist, 1.f, .01f, false, false );
        }
        else if ( ticks == 125 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            effect ef;

            Sound::PlayHero( SoundHT, source, 'psnd' + 'T2', 100.f, .0f );
            Jass::SetUnitAnimation( source, "spell throw five" );

            for ( int i = 0; i < 5; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( .0f, 360.f ), 1.f + .25f * i, Jass::GetRandomReal( .5f, 2.f ) );
                Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0x80, 0xC0 ) );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 50.f, angle, 1.5f, 2.f );
            EffectAPI::SetTimedLife( ef, 4.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.f, 2.f );
            EffectAPI::SetTimedLife( ef, 3.f );

            Jass::SetUnitFacing( source, angle );
            Displacer::Unit::Move( source, angle, dist, 1.f, .015f, 400.f );
            string mdl = Jass::GetUnitModel( source );

            for ( int i = 0; i < 15; i++ )
            {
                ef = EffectAPI::CreateEx( mdl, x, y, .0f, angle, 1.f, 1.f );
                EffectAPI::SetTimedLife( ef, 1.f );
                Jass::SetSpecialEffectAnimation( ef, "spell throw five" );
                Jass::SetSpecialEffectAlpha( ef, 0xFF - 25 * i );
                War3Image::DisplaceWithArgs( ef, angle, dist, 1.f + .1f * i, .02f, 400.f );
            }
        }
        else if ( ticks == 225 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = Jass::GetUnitFacing( source );
            float dmg = 4000.f + 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            effect ef;

            Sound::PlayHero( SoundHT, source, 'gsnd' + 2, 80.f, .0f );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'D1', 100.f, .0f );

            StunUnit( target, 1.f );
            DamageTarget( source, target, dmg );

            Jass::SetUnitFacing( source, angle );
            Jass::SetUnitAnimation( source, "spell throw six" );
            War3Image::DisplaceLinear( source, angle, 250.f, .8f, .01f, false, false );
            EffectAPI::Dash( source );

            for ( int i = 0; i < 4; i++ )
            {
                ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, .0f, 270.f, 4.f, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );

                ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, ( angle + Jass::Pow( -1.f, i ) ) * 30.f, 3.f, .5f );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            for ( int i = 0; i < 5; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );

                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );
            }
        }
    }

    void T( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
        {
            Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            StunUnit( source, 2.f );
            Jass::SetUnitAnimation( source, "stand" );
            Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, D_TYPE_ID ), .01f );
        }
        else if ( ticks == 50 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'T3', 100.f, .0f );
            Jass::SetUnitTimeScale( source, .25f );
            Jass::SetUnitAnimation( source, "spell one alternate" );
        }
        else if ( ticks == 90 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );

            Jass::SetUnitTimeScale( source, 1.f );
            Jass::SetUnitAnimation( source, "attack" );

            effect ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\REffect.mdl", Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, 50.f ), Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, 50.f ), 100.f, angle, 1.f, 1.f );
            Jass::SaveEffectHandle( DataHT, hid, '+eff', ef );

            Jass::SaveBoolean( DataHT, hid, 'skip', true );
            Jass::SaveInteger( DataHT, hid, 'tick', ticks + 5 );
        }
        else if ( ticks == 95 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );

            if ( War3Image::DisplaceToTarget( Jass::LoadEffectHandle( DataHT, hid, '+eff' ), target, 20.f, 75.f ) )
            {
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );
                float targX = Jass::GetUnitX( target );
                float targY = Jass::GetUnitY( target );
                float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
                float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
                string mdl = Jass::GetUnitModel( source );

                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralSounds\\BlackBlink.mdx", x, y ) );
                Jass::SetUnitTimeScale( source, 1.f );
                Jass::SetUnitFlyHeight( source, 200.f, 99999.f );
                Jass::SetUnitAnimation( source, "spell channel three" );
                SetUnitXY( source, targX, targY );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralSounds\\BlackBlink.mdx", targX, targY ) );

                effect ef = EffectAPI::CreateEx( mdl, Jass::MathPointProjectionX( targX, angle, 150.f ), Jass::MathPointProjectionY( targY, angle, 150.f ), .0f, -angle, 1.f, 1.f );
                Jass::SetSpecialEffectAlpha( ef, 0xB0 );
                EffectAPI::SetTimedLife( ef, .8f );
                Jass::SetSpecialEffectAnimation( ef, "spell slam three" );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralSounds\\BlackBlink.mdx", Jass::GetSpecialEffectX( ef ), Jass::GetSpecialEffectY( ef ) ) );

                Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
                Jass::SaveBoolean( DataHT, hid, 'skip', false );
                Jass::SaveInteger( DataHT, hid, 'tick', ticks + 5 );
                return;
            }
        }
        else if ( ticks == 130 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = GetUnitAngle( source, target );
            effect ef;

            Jass::SetUnitAnimation( source, "spell throw six" );
            Jass::SetUnitFlyHeight( source, 0, 99999.f );
            War3Image::DisplaceLinear( source, angle, -300.f, .4f, .01f, false, false );

            for ( int i = 0; i < 3; i++ )
            {
                ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 4.f, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );

                ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\NanayaShikiQEffect.mdl", targX, targY, .0f, angle + 45.f - 45.f * i, 1.f, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralSounds\\26.mdx", targX, targY ) );
        }
        else if ( ticks == 170 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float dmg = 6000.f + 400.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

            StunUnit( target, 2.f );
            DamageTarget( source, target, dmg );
            Jass::SetUnitTimeScale( source, 1.f );
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
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'Q1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'W1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T3' ) );
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
            Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, Sound::Create( "GeneralSounds\\KickSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 2, Sound::Create( "GeneralSounds\\GlassShatterSound.mp3" ) );

            Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
        }

        if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            string path = "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpell";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', Sound::Create( path + "V.mp3"  ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', Sound::Create( path + "Q.mp3"  ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', Sound::Create( path + "W.wav"  ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', Sound::Create( path + "E1.wav" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E2', Sound::Create( path + "E2.wav" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', Sound::Create( path + "R1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', Sound::Create( path + "R2.wav" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', Sound::Create( path + "T1.wav" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', Sound::Create( path + "T2.wav" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T3', Sound::Create( path + "T3.mp3" ) );

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
                        case D_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @D ); break;
                        case Q_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @Q ); break;
                        case W_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @W ); break;
                        case E_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @E ); break;
                        case R_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @R ); break;
                        case T_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @T ); break;
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
