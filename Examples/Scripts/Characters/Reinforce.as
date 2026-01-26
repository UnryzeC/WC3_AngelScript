#include "Base.as"

namespace Reinforce
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00J';
    const uint32 ITEM_TYPE_ID = 'I010';
    const uint32 BUFF_TYPE_ID = '0000';
    const string MODEL_PATH = "Characters\\Reinforce\\Reinforce";
    const string ICON_PATH = "Characters\\Reinforce\\ReplaceableTextures\\CommandButtons\\BTNReinforceIcon.blp";
    const float SCALE = 2.4f;
    const uint32 D_TYPE_ID = 'A04R';
    const uint32 Q_TYPE_ID = 'A04G';
    const uint32 W_TYPE_ID = 'A04H';
    const uint32 E_TYPE_ID = 'A04I';
    const uint32 R_TYPE_ID = 'A04J';
    const uint32 T_TYPE_ID = 'A04K';

    void Q( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            Sound::StopHero( SoundHT, source, 'psnd' + 'Q1' );

            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );
            effect ef;

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 60.f, .0f );

            ef = EffectAPI::CreateEx( "Characters\\Reinforce\\BlackHole.mdl", targX, targY, .0f, 270.f, 1.2f, 1.f );
            EffectAPI::SetTimedLife( ef, 1.f );

            ef = EffectAPI::CreateEx( "Characters\\SaberAlter\\DarkExplosion.mdl", targX, targY, .0f, 270.f, 1.2f, 1.f );
            EffectAPI::SetTimedLife( ef, 3.f );
        }
        else
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );

            if ( ticks <= 100 )
            {
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 400.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                    {
                        float x = Jass::GetUnitX( u );
                        float y = Jass::GetUnitY( u );
                        float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY ) + 60.f;

                        SetUnitXY( u, Jass::MathPointProjectionX( x, angle, 10.f ), Jass::MathPointProjectionY( y, angle, 10.f ) );
                    }
                }
            }
            else
            {
                effect ef;

                ef = EffectAPI::CreateEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, 50.f, 270.f, 5.f, 2.f );
                EffectAPI::SetTimedLife( ef, 3.f );

                ef = EffectAPI::CreateEx( "Characters\\Reinforce\\firaga6.mdl", targX, targY, 75.f, 270.f, 4.f, .8f );
                EffectAPI::SetTimedLife( ef, 3.f );

                float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 400.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                    {
                        float x = Jass::GetUnitX( u );
                        float y = Jass::GetUnitY( u );
                        float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );

                        if ( DamageTarget( source, u, dmg ) )
                        {
                            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );
                            StunUnit( u, 2.f );
                        }
                        
                        Displacer::Unit::Move( u, angle, -200.f, 1, .01f, 0 );
                    }
                }

                SpellAPI::ReleaseTimer( DataHT, tmr );
            }
        }
    }

    void W( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        
        if ( SpellAPI::Stop( DataHT, hid, 1 ) )
        {
            Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'W1' );
            HandleListCleanEffects( Jass::LoadHandleList( DataHT, hid, 'elst' ), true, true );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            handlelist hl = Jass::HandleListCreate( );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'W1', 60.f, .0f );
            Jass::SaveHandleList( DataHT, hid, 'elst', hl );

            for ( int i = 0; i < 20; i++ )
            {
                float face = 36.f * i;
                float dist = Jass::GetRandomReal( 100.f, 1000.f );
                float x = Jass::MathPointProjectionX( targX, face, dist );
                float y = Jass::MathPointProjectionY( targY, face, dist );
                float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
                float height = Jass::GetRandomReal( 500.f, 1000.f );

                effect ef;

                ef = EffectAPI::CreateEx( "Characters\\NanayaShiki\\REffect.mdl", x, y, height, angle, 1.5f, 1.f );
                Jass::SetSpecialEffectColour( ef, 0xFFFF0000 );
                Jass::SetSpecialEffectPitch( ef, -45.f );

                Jass::HandleListAddHandle( hl, ef );

                ef = EffectAPI::CreateEx( "Abilities\\Spells\\Orc\\FeralSpirit\\feralspirittarget.mdl", x, y, height, angle, 1.f, 1.f );
                Jass::SetSpecialEffectColour( ef, 0xFFFF0000 );
                Jass::DestroyEffect( ef );
            }
        }
        else if ( ticks >= 100 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            handlelist eflist = Jass::LoadHandleList( DataHT, hid, 'elst' );

            for ( int i = 0; i < Jass::HandleListGetEffectCount( eflist ); i++ )
            {
                effect ef = Jass::HandleListGetEffectByIndex( eflist, i );
                Jass::SetSpecialEffectFacing( ef, Jass::MathAngleBetweenPoints( Jass::GetSpecialEffectX( ef ), Jass::GetSpecialEffectY( ef ), targX, targY ) );
                Jass::SetSpecialEffectX( ef, targX );
                Jass::SetSpecialEffectY( ef, targY );
                Jass::SetSpecialEffectHeight( ef, .0f );
            }

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
            StunUnit( target, 1 );
            DamageTarget( source, target, dmg );
            HandleListCleanEffects( Jass::LoadHandleList( DataHT, hid, 'elst' ), true, true );
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void E( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        if ( ticks == 0 )
        {
            Sound::PlayHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'E1', 60.f, .0f );
        }
        else if ( ticks == 100 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );
            effect ef;

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "Characters\\Reinforce\\ApocalypseStomp.mdx", targX, targY ) );

            ef = EffectAPI::CreateEx( "GeneralEffects\\moonwrath.mdl", targX, targY, 0.f, .0f, 4.f, 1.f );
            Jass::SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
            EffectAPI::SetTimedLife( ef, 4.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, .0f, .0f, 2.5f, .75f );
            EffectAPI::SetTimedLife( ef, 4.f );

            float dmg = 60.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 450.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    if ( DamageTarget( Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), u, dmg ) )
                    {
                        AddBuffTimed( u, 'Bslo', 1.f );
                    }
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void R( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) )
        {
            Sound::StopHero( SoundHT, source, 'psnd' + 'R1' );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );
        unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );

        if ( ticks == 0 )
        {
            Sound::PlayHero( SoundHT, source, 'psnd' + 'R1', 60.f, .0f );
            StunUnit( source, .25f );
            Jass::SetUnitPathing( source, false );
            Jass::SetUnitAnimation( source, "walk" );
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
            effect ef;

            ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 50.f, angle, 1.5f, 2.f );
            Jass::SetSpecialEffectPitch( ef, -90.f );
            EffectAPI::SetTimedLife( ef, 4.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\SlamEffect.mdl", x, y, 50.f, angle, 1.5f, 2.f );
            Jass::SetSpecialEffectPitch( ef, -90.f );
            EffectAPI::SetTimedLife( ef, 3.f );

            float dmg = 150.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, Jass::GetUnitX( target ), Jass::GetUnitY( target ), 400.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                }
            }

            Sound::StopHero( SoundHT, source, 'psnd' + 'R1' );
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void T( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 100.f, .0f );
            Jass::SaveReal( DataHT, hid, 'disp', 800 );
            DisableTeleport( source, 3.f );
            StunUnit( source, 3.f );
            Jass::SetUnitAnimation( source, "spell channel" );
        }

        if ( ticks < 70 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            if ( Jass::IsUnitDead( source ) )
            {
                Jass::StopSound( Jass::LoadSoundHandle( SoundHT, Jass::GetHandleId( source ), 'psnd' + 'T1' ), false, false );
                Jass::SetAbilityRemainingCooldown( Jass::GetUnitAbility( source, T_TYPE_ID ), .01f );
                EffectAPI::Remove( Jass::LoadEffectHandle( DataHT, hid, '+eff' + 0 ) );

                SpellAPI::ReleaseTimer( DataHT, tmr );
                return;
            }

            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );
            float mangl = Jass::LoadReal( DataHT, hid, 'disp' );

            DisplaceCircular( p, targX, targY, 450.f, mangl, 2.5f, "Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl" );

            Jass::SaveReal( DataHT, hid, 'disp', mangl - 16.f );
        }
        else if ( ticks == 70 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            effect ef = EffectAPI::CreateEx( "Characters\\Reinforce\\CosmicField.mdl", Jass::LoadReal( DataHT, hid, 'trgX' ), Jass::LoadReal( DataHT, hid, 'trgY' ), .0f, .0f, 5.f, 1.f );
            //Jass::SetSpecialEffectAnimation( ef, "birth" );
            Jass::SaveEffectHandle( DataHT, hid, '+eff' + 0, ef );

            Jass::SetUnitAnimation( source, "attack slam" );
        }
        else if ( ticks == 120 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float facing = Jass::GetUnitFacing( source );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            effect ef;

            Jass::SetUnitAnimation( source, "spell channel" );

            for ( int i = 1; i < 6; i++ )
            {
                ef = EffectAPI::CreateEx( "Characters\\Reinforce\\mfqwd.mdl", x, y, .0f, .0f, 1.f * i, .05f * i );
                Jass::SetSpecialEffectColour( ef, 0xFFFF32FF ); // green = 50
                EffectAPI::SetTimedLife( ef, 1.8f );
            }

            float targX = Jass::MathPointProjectionX( x, Jass::GetUnitFacing( source ), 130.f );
            float targY = Jass::MathPointProjectionY( y, Jass::GetUnitFacing( source ), 130.f );

            ef = EffectAPI::CreateEx( "Characters\\Reinforce\\t_xuliyy.mdl", targX, targY, 30.f, .0f, 1.f, 1.f );
            Jass::SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
            EffectAPI::SetTimedLife( ef, 2.f ); // 3.6f
        }
        else if ( ticks == 280 )
        {
            Jass::SetUnitAnimation( Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), "spell slam" );
        }
        else if ( ticks == 300 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );
            float dmg = 400.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            effect ef;

            ef = EffectAPI::CreateEx( "Characters\\Reinforce\\ShadowExplosion.mdl", targX, targY, 50.f, .0f, 10.f, 1.f );
            EffectAPI::SetTimedLife( ef, 4.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\moonwrath.mdl", targX, targY, 0.f, .0f, 10.f, 1.f );
            Jass::SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
            EffectAPI::SetTimedLife( ef, 4.f );

            ef = EffectAPI::CreateEx( "GeneralEffects\\apocalypsecowstomp.mdl", targX, targY, 0.f, .0f, 3.5f, 1.f );
            Jass::SetSpecialEffectColour( ef, 0xFFFF00FF ); // green = 0
            EffectAPI::SetTimedLife( ef, 3.f );

            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 900.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 1.f );
                    War3Image::DisplaceLinear( u, Jass::MathAngleBetweenPoints( targX, targY, Jass::GetUnitX( u ), Jass::GetUnitY( u ) ), 300.f, 1.f, .01f, false, false );
                }
            }

            EffectAPI::Remove( Jass::LoadEffectHandle( DataHT, hid, '+eff' + 0 ) );
            SpellAPI::ReleaseTimer( DataHT, tmr );
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

            Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
        }

        if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            string path = "Characters\\Reinforce\\Sounds\\ReinforceSpell";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', Sound::Create( path + "QSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', Sound::Create( path + "WSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', Sound::Create( path + "ESound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', Sound::Create( path + "CSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', Sound::Create( path + "RSound1.mp3" ) );
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
                        case W_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @W ); break;
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