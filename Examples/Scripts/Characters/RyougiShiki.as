#include "Base.as"

namespace RyougiShiki
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00C';
    const uint32 ITEM_TYPE_ID = 'I01F';
    const uint32 BUFF_TYPE_ID = 'B000';
    const string MODEL_PATH = "Characters\\RyougiShiki\\RyougiShiki";
    const string ICON_PATH = "Characters\\RyougiShiki\\ReplaceableTextures\\CommandButtons\\BTNRyougiShikiIcon.blp";
    const float SCALE = 1.5f;
    const uint32 D_TYPE_ID = 'A035';
    const uint32 Q_TYPE_ID = 'A033';
    const uint32 W_TYPE_ID = 'A032';
    const uint32 E_TYPE_ID = 'A034';
    const uint32 R_TYPE_ID = 'A036';
    const uint32 T_TYPE_ID = 'A037';

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

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'W1', 100.f, .0f );

            StunUnit( source, .2f );
            Jass::SetUnitTimeScale( source, 1.5f );
            Jass::SetUnitAnimation( source, "spell channel four" );
        }
        else if ( ticks == 20 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::GetUnitFacing( source );
            float targX = Jass::MathPointProjectionX( x, angle, 200.f );
            float targY = Jass::MathPointProjectionY( y, angle, 200.f );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 0, 50.f, .0f );
            Jass::SetUnitTimeScale( source, 1.f );

            for ( int i = 0; i < 5; i++ )
            {
                effect ef = EffectAPI::CreateEx( "Characters\\RyougiShiki\\RyougiShikiWEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            float dmg = 240.f + 80.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 300.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 1.f );

                    Displacer::Unit::Move( u, angle, 300.f, .5f, .01f, 150.f );
                    Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void W( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 100.f, .0f );
            StunUnit( source, .4f );
            Jass::SetUnitAnimation( source, "Spell Channel Slam" );
            Jass::SetUnitTimeScale( source, 2.f );
            EffectAPI::Dash( source );

            War3Image::DisplaceLinear( source, Jass::GetUnitFacing( source ), dist, .4f, .01f, false, true );
        }
        else if ( ticks == 40 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::GetUnitFacing( source );
            float targX = Jass::MathPointProjectionX( x, angle, 200.f );
            float targY = Jass::MathPointProjectionY( y, angle, 200.f );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 0, 50.f, .0f );
            Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, Q_TYPE_ID ), .01f );

            for ( int i = 0; i < 5; i++ )
            {
                effect ef = EffectAPI::CreateEx( "Characters\\RyougiShiki\\RyougiShikiWEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
                //Jass::SetSpecialEffectColour( ef, 0xFFFF7000 );
                EffectAPI::SetTimedLife( ef, 3.f );
            }

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 400.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 1.f );
                    Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
                    War3Image::DisplaceLinear( u, angle, 150.f, .2f, .01f, false, false );
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void E( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

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
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'E1', 100.f, .0f );
            StunUnit( source, .5f );
            Jass::SetUnitTimeScale( source, 1.75f );
            Jass::SetUnitAnimation( source, "spell channel two" );
            War3Image::DisplaceLinear( source, angle, dist, .4f, .01f, false, true );

            Jass::SaveReal( DataHT, hid, 'srcX', x );
            Jass::SaveReal( DataHT, hid, 'srcY', y );
            Jass::SaveReal( DataHT, hid, 'trgX', Jass::MathPointProjectionX( x, angle, dist * .5f ) );
            Jass::SaveReal( DataHT, hid, 'trgY', Jass::MathPointProjectionY( y, angle, dist * .5f ) );
        }
        else if ( ticks == 50 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float origX = Jass::LoadReal( DataHT, hid, 'srcX' );
            float origY = Jass::LoadReal( DataHT, hid, 'srcX' );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );
            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 0, 50.f, .0f );

            effect ef = EffectAPI::CreateEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle, 3.f, .5f );
            EffectAPI::SetTimedLife( ef, 3.f );

            float dmg = 75.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            GroupEnumUnitsInLine( gEnum, origX, origY, angle, dist, 600.f );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void R( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1, true ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            StunUnit( source, 1.35f );
            Jass::SetUnitAnimation( source, "spell one" );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 80.f, .0f );
        }
        else if ( ticks == 25 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

            Jass::SetUnitAnimation( source, "spell channel five" );
            DamageTarget( source, target, dmg );
            SetUnitXY( source, Jass::MathPointProjectionX( targX, angle, 100.f ), Jass::MathPointProjectionY( targY, angle, 100.f ) );

            for ( int i = 0; i < 5; i++ )
            {
                effect ef = EffectAPI::CreateEx( "Characters\\RyougiShiki\\RyougiShikiQEffect.mdl", targX, targY, .0f, angle, 2.f, 1.f );
                //Jass::SetSpecialEffectColour( ef, 0xFFFF7000 );
                EffectAPI::SetTimedLife( ef, 3.f );
            }
        }
        else if ( ticks == 75 )
        {
            Jass::SetUnitAnimation( Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), "spell slam one" );
        }
        else if ( ticks == 135 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 0, 50.f, .0f );
            DamageTarget( source, target, dmg );
            StunUnit( target, 1.f );

            for ( int i = 0; i < 3; i++ )
            {
                effect ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 100.f, 270.f, 4.f, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void T( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1, true ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            StunUnit( source, 1.25f );
            Jass::SetUnitAnimation( source, "spell channel three" );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'D1', 100.f, .0f );
            Jass::SaveBoolean( DataHT, hid, 'skip', true );
            Jass::SaveInteger( DataHT, hid, 'tick', ticks + 1 );
        }
        else if ( ticks == 1 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );

            if ( War3Image::DisplaceToTarget( source, target, 40.f, 600.f ) )
            {
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );
                float targX = Jass::GetUnitX( target );
                float targY = Jass::GetUnitY( target );
                float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
                float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
                float dmg = 1500.f + 150.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

                Sound::PlayHero( SoundHT, source, 'psnd' + 'R1', 100.f, .0f );
                Jass::SetUnitAnimation( source, "spell channel four" );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );

                for ( int i = 0; i < 3; i++ )
                {
                    effect ef = EffectAPI::CreateEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle, 1.f, 1.f );
                    EffectAPI::SetTimedLife( ef, 4.f );

                    ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
                    Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                    EffectAPI::SetTimedLife( ef, 4.f );
                }

                War3Image::DisplaceLinear( source, angle, dist + 250.f, .2f, .01f, false, false );
                
                DamageTarget( source, target, dmg );
                StunUnit( target, .5f );
                Jass::SaveInteger( DataHT, hid, 'tick', 5 );
                return;
            }
        }
        else if ( ticks == 5 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            int slashes = Jass::LoadInteger( DataHT, hid, 'slsh' );

            if ( slashes < 30 )
            {
                Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 100.f, .0f );

                for ( int i = 0; i < 3; i++ )
                {
                    effect ef = EffectAPI::CreateEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, slashes * 12.f, 1.f, 1.f );
                    EffectAPI::SetTimedLife( ef, 4.f );
                }

                Jass::SaveInteger( DataHT, hid, 'slsh', slashes + 1 );
            }
            else
            {
                float angle = GetUnitAngle( source, target );
                float dist = GetUnitDistance( source, target );

                Jass::SetUnitAnimation( source, "spell" );
                Displacer::Unit::Move( source, angle, dist + 600.f, 1.1f, .01f, 250.f );
                Jass::SaveInteger( DataHT, hid, 'tick', 10 );
                Jass::SaveBoolean( DataHT, hid, 'skip', false );
                return;
            }
        }
        else if ( ticks == 70 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = GetUnitAngle( source, target );
            effect ef;
            float dmg = 1500.f + 150.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 0, 70.f, .0f );

            StunUnit( target, 1.f );
            DamageTarget( source, target, dmg );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );

            for ( int i = 0; i < 3; i++ )
            {
                ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\REffect2.mdl", targX, targY, 0.f, angle, 4.f, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );

                ef = EffectAPI::CreateEx( "Characters\\ToonoShiki\\TohnoShikiQEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
                EffectAPI::SetTimedLife( ef, 4.f );
            }
        }
        else if ( ticks == 120 )
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
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'gsnd' + 0 ) );
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
            Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 0, Sound::Create( "GeneralSounds\\BloodFlow.mp3" ) );

            Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
        }

        if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            string path = "Characters\\RyougiShiki\\Sounds\\RyougiShikiSpell";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', Sound::Create( path + "DSound1.mp3" ) );
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
                        case D_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @D ); break;
                        case Q_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @Q ); break;
                        case W_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @W ); break;
                        case E_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @E ); break;
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
