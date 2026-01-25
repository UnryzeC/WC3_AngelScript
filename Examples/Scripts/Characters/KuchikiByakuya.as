#include "Base.as"

namespace KuchikiByakuya
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00F';
    const uint32 ITEM_TYPE_ID = 'I016';
    const uint32 BUFF_TYPE_ID = '0000';
    const string MODEL_PATH = "Characters\\KuchikiByakuya\\KuchikiByakuya";
    const string ICON_PATH = "Characters\\KuchikiByakuya\\ReplaceableTextures\\CommandButtons\\BTNKuchikiByakuyaIcon.blp";
    const float SCALE = 2.2f;
    const uint32 D_TYPE_ID = 'A03J';
    const uint32 Q_TYPE_ID = 'A03E';
    const uint32 W_TYPE_ID = 'A03D';
    const uint32 E_TYPE_ID = 'A03G';
    const uint32 R_TYPE_ID = 'A03H';
    const uint32 T_TYPE_ID = 'A03I';

    void Q( )
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

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q2', 90.f, .0f );

            StunUnit( source, .25f );
            Jass::SetUnitAnimation( source, "spell" );
        }
        else if ( ticks == 25 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::GetUnitFacing( source );
            effect ef = EffectAPI::CreateEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSpellQEffect.mdl", Jass::MathPointProjectionX( x, angle, 150.f ), Jass::MathPointProjectionY( y, angle, 150.f ), .0f, angle, 1.5f, 1.f );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 90.f, .0f );

            Jass::SaveEffectHandle( DataHT, hid, '+eff', ef );
            //Jass::SaveGroupHandle( DataHT, hid, 'grpq', Jass::CreateGroup( ) );

            War3Image::DisplaceLinear( ef, angle, 1250.f, .5f, .01f, false, false, "" );
        }

        if ( ticks >= 25 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            effect ef = Jass::LoadEffectHandle( DataHT, hid, '+eff' );
            group g = Jass::LoadGroupHandle( DataHT, hid, 'grpq' );
            float x = Jass::GetSpecialEffectX( ef );
            float y = Jass::GetSpecialEffectY( ef );
            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 250.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) && !Jass::IsUnitInGroup( u, g ) )
                {
                    DamageTarget( source, u, dmg );
                    Jass::GroupAddUnit( g, u );
                }
            }

            if ( ticks == 60 )
            {
                Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
                Jass::GroupClear( g );
                SpellAPI::ReleaseTimer( DataHT, tmr );
            }
        }
    }

    void W( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1, true ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            HandleListCleanEffects( Jass::LoadHandleList( DataHT, hid, 'elst' ), true, true );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'W1', 100.f, .0f );
            StunUnit( source, .25f );
            Jass::SetUnitAnimation( source, "spell channel one" );

            Jass::SaveHandleList( DataHT, hid, 'elst', Jass::HandleListCreate( ) );
        }
        else if ( ticks >= 10 && ticks <= 20 )
        {
            if ( SpellAPI::Counter( DataHT, hid, 0, 2 ) )
            {
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                float targX = Jass::GetUnitX( target );
                float targY = Jass::GetUnitY( target );
                float angle = GetUnitAngle( source, target );
                handlelist hl = Jass::LoadHandleList( DataHT, hid, 'elst' );
                int count = Jass::HandleListGetEffectCount( hl );
                float efAngle = 60.f * count;
                float efX = Jass::MathPointProjectionX( targX, efAngle, 100.f );
                float efY = Jass::MathPointProjectionY( targX, efAngle, 100.f );
                effect ef = EffectAPI::CreateEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSenkeiSword.mdl", efX, efY, 350.f, .0f, 3.f, 1.f );
                Jass::SetSpecialEffectAnimation( ef, "stand" );
                Jass::SetSpecialEffectPitch( ef, -85.f );
                EffectAPI::SetTimedLife( ef, .25f - count * .01f );

                Jass::HandleListAddHandle( hl, ef );
            }
        }
        else if ( ticks == 50 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            handlelist hl = Jass::LoadHandleList( DataHT, hid, 'elst' );
            float angleStep = 360.f / Jass::HandleListGetEffectCount( hl );

            for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
            {
                effect ef = Jass::HandleListGetEffectByIndex( hl, i );

                Jass::SetSpecialEffectPosition( ef, Jass::MathPointProjectionX( targX, i * angleStep, 100.f ), Jass::MathPointProjectionY( targY, i * angleStep, 100.f ) );
                Jass::SetSpecialEffectHeight( ef, 100.f );
            }

            float dmg = 245.f + 65.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

            DamageTarget( source, target, dmg );
            StunUnit( source, 1.f );

            effect ef = EffectAPI::CreateEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSpellQEffect.mdl", targX, targY, .0f, .0f, 1.5f, 1.f );
            EffectAPI::SetTimedLife( ef, .5f );

            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\Spark_Pink.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\Deadspirit Asuna.mdx", targX, targY ) );

            Jass::HandleListDestroy( hl );
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

            Sound::PlayHero( SoundHT, source, 'psnd' + 'E1', 90.f, .0f );

            StunUnit( source, 2.f );
            Jass::SetUnitAnimation( source, "spell Slam" );
        }
        else if ( ticks == 10 )
        {
            float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
            float targY = Jass::LoadReal( DataHT, hid, 'trgY' );

            for ( int i = 0; i < 5; i++ )
            {
                effect ef = EffectAPI::CreateEx( "GeneralEffects\\plasma.mdl", targX, targY, .0f, .0f, 1.3f + i * .1f, 1.f );
                Jass::SetSpecialEffectAnimation( ef, "stand" );
                Jass::SetSpecialEffectColour( ef, 0xFFFF3060 );
                EffectAPI::SetTimedLife( ef, 2.f );
            }
        }
        else if ( ticks >= 20 && ticks <= 200 )
        {
            if ( SpellAPI::Counter( DataHT, hid, 0, 20 ) )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float targX = Jass::LoadReal( DataHT, hid, 'trgX' );
                float targY = Jass::LoadReal( DataHT, hid, 'trgY' );

                float dmg = 3.f * Jass::GetHeroLevel( source ) + .05f * Jass::GetHeroInt( source, true );
                float dmgFin = 40.f * Jass::GetHeroLevel( source ) + .5f * Jass::GetHeroInt( source, true );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, targX, targY, 450.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                    {
                        if ( ticks != 200 )
                        {
                            DamageTarget( source, u, dmg );
                            AddBuffTimed( u, 'Bslo', 1.f, false );
                        }
                        else
                        {
                            DamageTarget( source, u, dmgFin );
                            StunUnit( u, 1.f );

                            War3Image::DisplaceLinear( u, Jass::MathAngleBetweenPoints( targX, targY, Jass::GetUnitX( u ), Jass::GetUnitY( u ) ), 300.f, .5f, .01f, false, false );
                        }

                        Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
                    }
                }

                if ( ticks == 200 )
                {
                    effect ef = EffectAPI::CreateEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSakuraExplosionEffect.mdl", targX, targY, 50.f, .0f, 1.f, .3f );
                    EffectAPI::SetTimedLife( ef, 5.f );

                    SpellAPI::ReleaseTimer( DataHT, tmr );
                }
            }
        }
    }

    void R( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( SpellAPI::Stop( DataHT, hid, 0, true ) || ticks > 1000 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            HandleListCleanEffects( Jass::LoadHandleList( DataHT, hid, 'elst' ), true, true );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        if ( ticks == 0 )
        {
            Jass::SetUnitAnimation( Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), "morph" );
            Jass::SaveHandleList( DataHT, hid, 'elst', Jass::HandleListCreate( ) );
        }
        else if ( ticks == 25 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            handlelist hl = Jass::LoadHandleList( DataHT, hid, 'elst' );
            effect ef;
            
            for ( int i = 0; i < 3; i++ )
            {
                ef = EffectAPI::CreateEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaBankaiEffect.mdl", x, y, 200.f * i, .0f, 1.f, 3.f );
                Jass::SetSpecialEffectTimeScale( ef, 3.f );
                Jass::HandleListAddHandle( hl, ef );
            }
        }
        else if ( ticks >= 100 )
        {
            float x = .0f;
            float y = .0f;
            handlelist hl = Jass::LoadHandleList( DataHT, hid, 'elst' );

            for ( int i = 0; i < Jass::HandleListGetEffectCount( hl ); i++ )
            {
                effect ef = Jass::HandleListGetEffectByIndex( hl, i );
                float newFacing = 0;

                if ( i == 0 )
                {
                    newFacing = 5.f;
                    x = Jass::GetSpecialEffectX( ef );
                    y = Jass::GetSpecialEffectY( ef );
                }
                else if ( i == 1 )
                {
                    newFacing = -5.f;
                }
                else if ( i == 2 )
                {
                    newFacing = 7.5f;
                }

                Jass::SetSpecialEffectFacing( ef, Jass::GetSpecialEffectFacing( ef ) + newFacing );
            }

            if ( SpellAPI::Counter( DataHT, hid, 0, 25 ) )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float dmg = 5.f * Jass::GetHeroLevel( source ) + .05f * Jass::GetHeroInt( source, true );
                bool isEffect = SpellAPI::Counter( DataHT, hid, 1, 5 );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, x, y, 800.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                    {
                        DamageTarget( source, u, dmg );

                        if ( isEffect )
                        {
                            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "chest" ) );
                            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", u, "head" ) );
                        }
                    }
                }
            }
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

            Sound::PlayHero( SoundHT, source, 'psnd' + 'T3', 100.f, .0f );
            StunUnit( source, 2.5f );
            Jass::SetUnitTimeScale( source, 2.f );
            Jass::SetUnitAnimation( source, "Attack Alternate One" );
        }
        else if ( ticks == 40 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 1, 60.f, .0f );

            EffectAPI::PushWind( source, target );

            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\QQQQQ.mdx", target, "chest" ) );
            StunUnit( target, 2.f );

            War3Image::DisplaceLinear( target, angle, 400.f, .4f, .01f, false, false );
        }
        else if ( ticks == 80 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'T2', 100.f, .0f );
            Jass::SetUnitTimeScale( source, 1.f );
            Jass::SetUnitAnimation( source, "spell three" );
        }
        else if ( ticks == 120 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            Jass::SetUnitAnimation( source, "spell four" );
            EffectAPI::Dash( source );

            War3Image::DisplaceLinear( source, angle, dist - 250.f, .5f, .01f, false, false );
        }
        else if ( ticks == 170 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 100.f, .0f );

            Jass::SetUnitAnimation( source, "spell one" );
            EffectAPI::Dash( source );
        }
        else if ( ticks == 180 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            effect ef;

            for ( int i = 0; i < 2; i++ )
            {
                ef = EffectAPI::CreateEx( "Characters\\RyougiShiki\\RyougiShikiQEffect.mdl", targX, targY, .0f, angle, 4.f, 1.f );
                //Jass::SetSpecialEffectColour( ef, 0xFFFF7000 );
                EffectAPI::SetTimedLife( ef, 3.f );
            }

            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\QQQQQ.mdx", target, "chest" ) );

            ef = EffectAPI::CreateEx( "GeneralEffects\\qianbenying8.mdl", targX, targY, .0f, .0f, 1.f, 1.f );
            EffectAPI::SetTimedLife( ef, .5f );

            War3Image::DisplaceLinear( source, angle, dist + 400.f, .6f, .01f, false, false );
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
            effect ef;
            float dmg = 3000.f + 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 0, 60.f, .0f );

            for ( int i = 0; i < 5; i++ )
            {
                ef = EffectAPI::CreateEx( "Characters\\KuchikiByakuya\\KuchikiByakuyaSakuraExplosionEffect.mdl", targX, targY, 50.f, .0f, .5f * i, .3f + i );
                EffectAPI::SetTimedLife( ef, 5.f );
            }

            ef = EffectAPI::CreateEx( "GeneralEffects\\qianbenying8.mdl", targX, targY, .0f, .0f, 1.f, 1.f );
            EffectAPI::SetTimedLife( ef, .5f );

            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "chest" ) );
            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\Spark_Pink.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\Deadspirit Asuna.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );

            StunUnit( target, 1.f );
            DamageTarget( source, target, dmg );
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
        }

        if ( Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'D1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'Q1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'Q2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'W1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T3' ) );
        }

        Jass::DestroyGroup( Jass::LoadGroupHandle( DataHT, hid, 'egrp' ) );
        Jass::DestroyGroup( Jass::LoadGroupHandle( DataHT, hid, 'grpq' ) );
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

            Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
        }

        if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            string path = "Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpell";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', Sound::Create( path + "DSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', Sound::Create( path + "QSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q2', Sound::Create( path + "QSound2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', Sound::Create( path + "WSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', Sound::Create( path + "ESound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', Sound::Create( path + "RSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', Sound::Create( path + "RSound2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', Sound::Create( path + "TSound1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', Sound::Create( path + "TSound2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T3', Sound::Create( path + "TSound3.mp3" ) );

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
                        case T_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, target, targX, targY, @T ); break;
                    }
                }
            );

            Jass::SaveTriggerHandle( DataHT, hid, '+trg', trg );
            Jass::SaveGroupHandle( DataHT, hid, 'egrp', Jass::CreateGroup() );
            Jass::SaveGroupHandle( DataHT, hid, 'grpq', Jass::CreateGroup() );
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
