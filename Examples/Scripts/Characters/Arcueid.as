#include "Base.as"

namespace Arcueid
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00K';
    const uint32 ITEM_TYPE_ID = 'I00E';
    const uint32 BUFF_TYPE_ID = '0000';
    const string MODEL_PATH = "Characters\\Arcueid\\Arcueid";
    const string ICON_PATH = "Characters\\Arcueid\\ReplaceableTextures\\CommandButtons\\BTNArcueidIcon.blp";
    const float SCALE = 2.4f;
    const uint32 D_TYPE_ID = 'A02B';
    const uint32 Q_TYPE_ID = 'A01N';
    const uint32 W_TYPE_ID = 'A01Y';
    const uint32 E_TYPE_ID = 'A026';
    const uint32 R_TYPE_ID = 'A027';
    const uint32 T_TYPE_ID = 'A02A';

    void Q( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( !SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            int ticks = SpellAPI::Tick( DataHT, hid );

            if ( ticks == 0 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

                Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 100.f, .0f );
                StunUnit( source, .25f );
                Jass::SetUnitTimeScale( source, 2 );
                Jass::SetUnitAnimation( source, "Spell One" );
            }
            else if ( ticks == 20 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float dmg = 250.f + Jass::GetHeroLevel( source ) * 70.f + Jass::GetHeroInt( source, true );
                float x = Jass::LoadReal( DataHT, hid, 'srcX' );
                float y = Jass::LoadReal( DataHT, hid, 'srcY' );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Sound::PlayHero( SoundHT, source, 'gsnd' + 0, 100.f, .0f );
                Jass::GroupEnumUnitsInRange( gEnum, Jass::LoadReal( DataHT, hid, 'trgX' ), Jass::LoadReal( DataHT, hid, 'trgY' ), 300.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitEnemy( u, Jass::GetOwningPlayer( source ) ) )
                    {
                        float u_x = Jass::GetUnitX( u );
                        float u_y = Jass::GetUnitY( u );
                        float angle = Jass::MathAngleBetweenPoints( x, y, u_x, u_y );

                        Displacer::Unit::Move( u, angle, -300.f, .5f, .01f, 250.f );
                        DamageTarget( source, u, dmg );
                        Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", u_x, u_y ) );
                    }
                }

                Jass::SetUnitTimeScale( source, 1.f );
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }
        }
    }

    void W( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( !SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            if ( ticks == 0 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

                Sound::PlayHero( SoundHT, source, 'psnd' + 'W1', 100.f, .0f );

                StunUnit( source, .4f );
                Jass::SetUnitTimeScale( source, 1.75f );
                Jass::SetUnitAnimation( source, "Spell Five" );
            }
            if ( ticks == 10 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );

                for ( int i = 0; i < 5; i++ )
                {
                    effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, .0f, Jass::GetRandomReal( 1.5f, 2.f ), 1.5f );
                    Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
                    EffectAPI::SetTimedLife( ef, 4.f );
                }
            }
            else if ( ticks == 25 )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );
                float dmg = 350.f + 60.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, x, y, 450.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                    {
                        float targX = Jass::GetUnitX( u );
                        float targY = Jass::GetUnitY( u );
                        float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );

                        War3Image::DisplaceLinear( u, angle, 200.f, .15f, .01f, false, false );
                        DamageTarget( source, u, dmg );
                    }
                }
            }
            else if ( ticks == 40 )
            {
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }
        }
    }

    void E( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( !SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            if ( ticks == 0 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );
                effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, .0f, 1.5f, 1.5f );
                
                EffectAPI::SetTimedLife( ef, 4.f );
                StunUnit( source, .25f );
                Jass::SetUnitAnimation( source, "Attack Two" );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", x, y ) );
            }
            else if ( ticks == 15 )
            {
                Jass::ShowUnit( Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), false );
            }
            else if ( ticks >= 25 )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
                float targY = Jass::LoadReal( DataHT, hid, 'trgY' );
                float dmg = 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

                Sound::PlayHero( SoundHT, source, 'gsnd' + 3, 60.f, .0f );
                SetUnitXY( source, targX, targY );
                Jass::ShowUnit( source, true );
                SelectUnit( source, p );

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

                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\SlamEffect.mdx", targX, targY ) );

                for ( int i = 0; i < 3; i++ )
                {
                    effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, .0f, .0f, Jass::GetRandomReal( 1.5f, 2.f ), 1.5f );
                    Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
                    EffectAPI::SetTimedLife( ef, 4.f );
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

        if ( !SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            if ( ticks == 0 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                
                StunUnit( source, .8f );
                Jass::SetUnitTimeScale( source, 1.75f );
                Jass::SetUnitAnimation( source, "Attack Slam" );

                DisableTeleport( target, .8f );
            }
            else if ( ticks == 15 )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );
                float targX = Jass::GetUnitX( target );
                float targY = Jass::GetUnitY( target );
                float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
                float dmg = Jass::GetHeroLevel( source ) * 150 + Jass::GetHeroInt( source, true ) * .5f;

                effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, angle, 1.5f, 1.5f );
                Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
                EffectAPI::SetTimedLife( ef, 4.f );

                Sound::PlayHero( SoundHT, source, 'gsnd' + 1, 60.f, .0f );
                DamageTarget( source, target, dmg );
                Jass::SetUnitFlyHeight( target, 600.f, 4000.f );
            }
            else if ( ticks == 25 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );
            }
            else if ( ticks == 30 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

                Jass::SetUnitFlyHeight( source, 700.f, 4000.f );
                Jass::SetUnitAnimation( source, "Attack Two" );
            }
        }

        if ( ticks == 60 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
            float dmg = Jass::GetHeroLevel( source ) * 50 + Jass::GetHeroInt( source, true ) * .5f;

            effect ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 800.f, angle, 1.5f, 1.5f );
            Jass::SetSpecialEffectPitch( ef, -90.f );
            Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
            EffectAPI::SetTimedLife( ef, 4.f );

            DamageTarget( source, target, dmg );
            Jass::SetUnitFlyHeight( target, 0, 2000.f );
            Jass::SetUnitFlyHeight( source, 0, 99999.f );
            War3Image::DisplaceLinear( target, angle, 250.f, .2f, .01f, false, false );
        }
        else if ( ticks >= 80 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float dmg = 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            effect ef;
            
            ef = EffectAPI::CreateEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.5f, 1.f );
            EffectAPI::SetTimedLife( ef, 1.f );

            for ( int i = 0; i < 3; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, .0f, Jass::GetRandomReal( 1.5f, 2.f ), 1.5f );
                Jass::SetSpecialEffectAlpha( ef, 0xB9 ); // rgba -> 255, 255, 255, 185
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

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

        if ( !SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            int ticks = SpellAPI::Tick( DataHT, hid );

            if ( ticks == 0 )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float x = Jass::LoadReal( DataHT, hid, 'srcX' );
                float y = Jass::LoadReal( DataHT, hid, 'srcY' );

                Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 100.f, .0f );
                StunUnit( source, .5f );
                EffectAPI::SetTimedLife( Jass::AddSpecialEffect( "GeneralEffects\\ValkDust.mdl", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ), 4.f );
                Jass::SetUnitAnimation( source, "Spell Six" );

                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", x, y ) );
            }
            else if ( ticks == 25 )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

                Jass::ShowUnit( source, false );
                SetUnitXY( source, Jass::LoadReal( DataHT, hid, 'trgX' ), Jass::LoadReal( DataHT, hid, 'trgY' ) );
            }
            else if ( ticks == 45 )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
                float targY = Jass::LoadReal( DataHT, hid, 'trgY' );
                float dmg = 200.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );
    
                Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 600.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitEnemy( u, p ) )
                    {
                        for ( int i = 0; i < 3; i++ )
                        {
                            effect ef = EffectAPI::CreateEx( "GeneralEffects\\ShortSlash\\ShortSlash.mdl", Jass::GetUnitX( u ), Jass::GetUnitY( u ), Jass::GetUnitFlyHeight( u ) + 50.f, i * Jass::GetRandomInt( 60, 90 ), Jass::GetRandomReal( .75f, 1.f ), Jass::GetRandomReal( .75f, 1.f ) );
                            Jass::DestroyEffect( ef );
                        }

                        DamageTarget( source, u, dmg );
                        Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
                        Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "head" ) );
                    }
                }
            }
            else if ( ticks == 50 )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
                float targY = Jass::LoadReal( DataHT, hid, 'trgY' );

                Jass::ShowUnit( source, true );
                Jass::SetUnitAnimation( source, "Stand" );
                SelectUnit( source, p );

                for ( int i = 0; i < 3; i++ )
                {
                    effect ef = Jass::AddSpecialEffect( "GeneralEffects\\ValkDust.mdl", targX, targY );
                    Jass::SetSpecialEffectScale( ef, 2.f );
                    Jass::SetSpecialEffectTimeScale( ef, Jass::GetRandomReal( .5f, 2.f ) );
                    EffectAPI::SetTimedLife( ef, 4.f );
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
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'gsnd' + 0 ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'gsnd' + 1 ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'gsnd' + 3 ) );
        }

        if ( Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'Q1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'W1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R1' ) );
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
            Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, Sound::Create( "GeneralSounds\\KickSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 3, Sound::Create( "GeneralSounds\\SlamSound.mp3" ) );

            Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
        }

        if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            string path = "Characters\\Arcueid\\Sounds\\ArcueidSpell";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', Sound::Create( path + "QSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', Sound::Create( path + "WSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', Sound::Create( path + "ESound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', Sound::Create( path + "RSound1.mp3" ) );
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
                        case Q_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @Q ); break;
                        case W_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @W ); break;
                        case E_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @E ); break;
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
            Jass::SaveBoolean( DataHT, E_TYPE_ID, 'PATH', true );
            Jass::SaveBoolean( DataHT, T_TYPE_ID, 'PATH', true );

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
