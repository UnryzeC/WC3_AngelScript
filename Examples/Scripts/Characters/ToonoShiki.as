#include "Base.as"

namespace ToonoShiki
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00B';
    const uint32 ITEM_TYPE_ID = 'I01J';
    const uint32 BUFF_TYPE_ID = '0000';
    const string MODEL_PATH = "Characters\\ToonoShiki\\ToonoShiki";
    const string ICON_PATH = "Characters\\ToonoShiki\\ReplaceableTextures\\CommandButtons\\BTNToonoShikiIcon.blp";
    const float SCALE = 1.4f;
    const uint32 D_TYPE_ID = 'A02X';
    const uint32 Q_TYPE_ID = 'A02U';
    const uint32 W_TYPE_ID = 'A02V';
    const uint32 E_TYPE_ID = 'A02W';
    const uint32 R_TYPE_ID = 'A02Y';
    const uint32 T_TYPE_ID = 'A02Z';

    void D( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            Sound::PlayHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'D1', 100.f, .0f );
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void Q( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
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
            Jass::SetUnitAnimation( source, "spell three" );
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

            Jass::SetUnitAnimation( source, "spell four" );

            War3Image::DisplaceLinear( source, angle, dist, .1f, .01f, false, true );

            effect ef = EffectAPI::CreateEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", Jass::MathPointProjectionX( x, angle, dist * .5f ), Jass::MathPointProjectionY( y, angle, dist * .5f ), .0f, angle, 3.f, 1.f );
            EffectAPI::SetTimedLife( ef, 3.f );

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
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
                    Jass::SetSpecialEffectColour( ef, 0xFF4040FF ); // 0xFFC0C0FF
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

                Jass::SetUnitAnimation( source, "stand" );
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }
        }
    }

    void E( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::StopHero( SoundHT, source, 'psnd' + 'E2' );
            Sound::StopHero( SoundHT, source, 'psnd' + 'E3' );
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
            
            Sound::PlayHero( SoundHT, source, 'psnd' + 'E3', 100.f, .0f );
            StunUnit( source, .9f );
            Jass::SetUnitTimeScale( source, 2.5f );
            Jass::SetUnitAnimation( source, "spell channel three" );
            EffectAPI::Dash( source );
            War3Image::DisplaceLinear( source, angle, dist + 100.f, .2f, .01f, false, false );
        }
        else if ( ticks == 20 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'E2', 100.f, .0f );
            Jass::SetUnitAnimation( source, "spell five" );
        }
        else if ( ticks == 70 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            float dmg = 500.f + 75.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 2, 60.f, .0f );
            Jass::SetUnitTimeScale( source, 1 );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
            War3Image::DisplaceLinear( source, angle, -300.f, .25f, .01f, false, false );
            StunUnit( target, 1 );
            DamageTarget( source, target, dmg );

            effect ef;

            ef = EffectAPI::CreateEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle + 45.f, 2.f, 1.f );
            EffectAPI::SetTimedLife( ef, 4.f );

            ef = EffectAPI::CreateEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle - 45.f, 2.f, 1.f );
            EffectAPI::SetTimedLife( ef, 4.f );
        }
        else if ( ticks == 95 )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void R( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) && ticks < 160 )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'R1', 100.f, .0f );
            StunUnit( source, 2.f );
            Jass::SetUnitTimeScale( source, 2.f );
            Jass::SetUnitAnimation( source, "spell channel five" );
            EffectAPI::Dash( source );
            War3Image::DisplaceLinear( source, angle, dist - 150.f, .1f, .01f, false, false );
        }
        else if ( ticks == 20 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            float dmg = 325.f + 32.5f * Jass::GetHeroLevel( source ) + .2f * Jass::GetHeroInt( source, true );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 1, 60.f, .0f );

            EffectAPI::PushWind( source, target );
            War3Image::DisplaceLinear( target, angle, 150.f, .2f, .01f, false, false );
            DamageTarget( source, target, dmg );
            StunUnit( target, 1.f );
        }
        else if ( ticks == 40 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            Jass::SetUnitAnimation( source, "spell channel three" );
            War3Image::DisplaceLinear( source, angle, dist - 150.f, .1f, .01f, false, false );
        }
        else if ( ticks == 60 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 100.f, .0f );
            Jass::SetUnitAnimation( source, "spell channel one" );
        }
        else if ( ticks == 110 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            float dmg = 750.f + 60.f * Jass::GetHeroLevel( source ) + .25f * Jass::GetHeroInt( source, true );

            Jass::SetUnitTimeScale( source, 3 );
            EffectAPI::PushWind( source, target, 50.f, -45.f );
            DamageTarget( source, target, dmg );
            Jass::SetUnitFlyHeight( source, 800.f, 2000.f );
            Jass::SetUnitFlyHeight( target, 800.f, 2000.f );
            War3Image::DisplaceLinear( source, angle, 200.f, .4f, .01f, false, false );
            War3Image::DisplaceLinear( target, angle, 200.f, .4f, .01f, false, false );
        }
        else if ( ticks == 160 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            float dmg = 750.f + 60.f * Jass::GetHeroLevel( source ) + .25f * Jass::GetHeroInt( source, true );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'R3', 100.f, .0f );
            Jass::SetUnitAnimation( source, "spell channel four" );
            EffectAPI::PushWind( source, target, 700.f, 45.f );

            Jass::SetUnitFlyHeight( source, 0.f, 3000.f );
            Jass::SetUnitFlyHeight( target, 0.f, 3000.f );
            War3Image::DisplaceLinear( source, angle, 200.f, .25f, .01f, false, false );
            War3Image::DisplaceLinear( target, angle, 200.f, .25f, .01f, false, false );
            DamageTarget( source, target, dmg );
        }
        else if ( ticks == 200 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
            effect ef;

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

            float dmg = 500.f + 40.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 600.f, nil );

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
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            StunUnit( source, 1.3f );
            Jass::SetUnitAnimation( source, "spell one" );
            Jass::SetUnitFacing( source, angle );

            for ( int i = 0; i < 5; i++ )
            {
                effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
                Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                EffectAPI::SetTimedLife( ef, 4.f );
            }
        }
        else if ( ticks == 90 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            float dmg = 3000.f + 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            effect ef;

            Sound::PlayHero( SoundHT, source, 'gsnd' + 2, 80.f, .0f );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 100.f, .0f );

            War3Image::DisplaceLinear( source, angle, dist + 250.f, .4f, .01f, false, false );
            
            for ( int i = 0; i < 17; i++ )
            {
                if ( i < 3 )
                {
                    ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 4.f, 1.f );
                    EffectAPI::SetTimedLife( ef, 4.f );
                }

                if ( i < 8 )
                {
                    ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
                    Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                    EffectAPI::SetTimedLife( ef, 4.f );
                }

                float face = Jass::GetRandomReal( 0.f, 360.f );

                ef = EffectAPI::CreateEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, face, 2.f, .5f );
                War3Image::DisplaceWithArgs( ef, face, Jass::GetRandomReal( 200.f, 800.f ), .1f, .01f, .0f );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            StunUnit( target, 2.f );
            DamageTarget( source, target, dmg );
        }
        else if ( ticks == 130 )
        {
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
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E3' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R3' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T2' ) );
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
            string path = "Characters\\ToonoShiki\\Sounds\\ToonoShikiSound";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', Sound::Create( path + "V1.mp3"  ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', Sound::Create( "Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellQ.mp3"  ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', Sound::Create( path + "W1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E2', Sound::Create( path + "E2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E3', Sound::Create( path + "E3.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', Sound::Create( path + "R1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', Sound::Create( path + "R2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R3', Sound::Create( path + "R3.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', Sound::Create( path + "T1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', Sound::Create( path + "T2.mp3" ) );

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
