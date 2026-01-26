#include "Base.as"

namespace SaberAlter
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00D';
    const uint32 ITEM_TYPE_ID = 'I01W';
    const uint32 BUFF_TYPE_ID = '0000';
    const string MODEL_PATH = "Characters\\SaberAlter\\SaberAlter";
    const string ICON_PATH = "Characters\\SaberAlter\\ReplaceableTextures\\CommandButtons\\BTNSaberAlterIcon.blp";
    const float SCALE = 2.2f;
    const uint32 D_TYPE_ID = 'A03S';
    const uint32 Q_TYPE_ID = 'A03T';
    const uint32 W_TYPE_ID = 'A03U';
    const uint32 E_TYPE_ID = 'A03V';
    const uint32 R_TYPE_ID = 'A03W';
    const uint32 T_TYPE_ID = 'A03X';

    void D( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'D1' );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'D1', 100.f, .0f );
            StunUnit( source, .2f );
            Jass::SetUnitAnimation( source, "Morph" );
        }
        else if ( ticks == 20 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );

            for ( int i = 0; i < 5; i++ )
            {
                effect ef = EffectAPI::CreateEx( "Characters\\SaberAlter\\DarkLightningNova.mdl", x, y, 50.f, .0f, .2f * i, .6f + .1f * i );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );
            
            Jass::GroupEnumUnitsInRange( gEnum, x, y, 300.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    float dist = GetUnitDistance( source, u );

                    DamageTarget( source, u, dmg );
                    Displacer::Unit::Move( u, GetUnitAngle( source, u ), 200.f, .5f, .01f, 200.f );
                }
            }

            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

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

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 100.f, .0f );
            StunUnit( source, .3f );
            Jass::SetUnitTimeScale( source, 1.5f );
            Jass::SetUnitAnimation( source, "spell Slam" );
        }
        else if ( ticks == 10 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );
            float targX = Jass::MathPointProjectionX( x, angle, dist * .5f );
            float targY = Jass::MathPointProjectionY( y, angle, dist * .5f );
        
            War3Image::DisplaceLinear( source, angle, dist, .1f, .01f, false, true );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q2', 100.f, .0f );

            effect ef = EffectAPI::CreateEx( "Characters\\SaberAlter\\SaberAlterClaw.mdl", targX, targY, .0f, angle, 3.f, .5f );
            Jass::SetSpecialEffectColour( ef, 0xFF800080 );
            EffectAPI::SetTimedLife( ef, 3.f );

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            GroupEnumUnitsInLine( gEnum, x, y, angle, dist, 400.f );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
                    War3Image::DisplaceLinear( u, angle, 200.f, .5f, .01f, false, false );
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
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );

            Jass::SetUnitAnimation( source, "spell Two" );
            EffectAPI::Jump( source );

            Displacer::Unit::Move( source, Jass::LoadReal( DataHT, hid, 'angl' ), dist, .4f, .01f, 200.f + dist / 5.f );
        }
        else if ( ticks == 40 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            effect ef;

            Sound::PlayHero( SoundHT, source, 'psnd' + 'W2', 100.f, .0f );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'W3', 100.f, .0f );

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\LightningStrike1.mdx", x, y ) );

            ef = EffectAPI::CreateEx( "Characters\\SaberAlter\\DarkExplosion.mdl", x, y, .0f, 270.f, .5f, 1.f );

            for ( int i = 0; i < 4; i++ )
            {
                ef = EffectAPI::CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 1.f + .25f * i, 1.f );
                Jass::SetSpecialEffectAlpha( ef, Jass::GetRandomInt( 0xA0, 0xC0 ) );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            float dmg = 150.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 300.f, nil );

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

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'E1', 100.f, .0f );
            StunUnit( source, .6f );
            // Jass::SaveGroupHandle( DataHT, hid, 'grpe', Jass::CreateGroup( ) );
            Jass::SetUnitAnimation( source, "spell Five" );
        }
        else if ( ticks == 60 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'E2', 100.f, .5f );
            Jass::SaveReal( DataHT, hid, 'srcX', Jass::GetUnitX( source ) );
            Jass::SaveReal( DataHT, hid, 'srcY', Jass::GetUnitY( source ) );
        }
        else if ( ticks > 60 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float move = Jass::LoadReal( DataHT, hid, 'move' ) + 150.f;
            int id = Jass::R2I( move / 150.f );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );
            float x = Jass::MathPointProjectionX( Jass::LoadReal( DataHT, hid, 'srcX' ), angle, move );
            float y = Jass::MathPointProjectionY( Jass::LoadReal( DataHT, hid, 'srcY' ), angle, move );
            group g = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'grpe' );

            effect ef = EffectAPI::CreateEx( "Characters\\SaberAlter\\ShadowBurstBigger.mdx", x, y, .0f, .0f, .2f + .05f * id, 1.f );
            EffectAPI::SetTimedLife( ef, 1.f + .025f * id );

            float dmg = 75.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 300.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) && !Jass::IsUnitInGroup( u, g ) )
                {
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 1.f );
                    Displacer::Unit::Move( u, .0f, .0f, .5f, .01f, 400.f );

                    Jass::GroupAddUnit( g, u );
                }
            }

            if ( move >= 1500.f )
            {
                Jass::GroupClear( g );
                SpellAPI::ReleaseTimer( DataHT, tmr );
                return;
            }

            Jass::SaveReal( DataHT, hid, 'move', move );
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

            StunUnit( source, 1.5f );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'R1', 100.f, .0f );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 100.f, .5f );
        }
        else if ( ticks >= 10 )
        {
            int slashes = Jass::LoadInteger( DataHT, hid, 'slsh' );

            if ( SpellAPI::Counter( DataHT, hid, 0, 40 ) )
            {
                player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
                unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                float x = Jass::GetUnitX( source );
                float y = Jass::GetUnitY( source );
                float angle = Jass::GetUnitFacing( source );
                float efX = Jass::MathPointProjectionX( x, angle, 50.f );
                float efY = Jass::MathPointProjectionY( y, angle, 50.f );

                Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 100.f, .5f );
                Jass::SetUnitAnimation( source, slashes == 0 || slashes == 2 ? "spell Three" : "spell Six" );

                for ( int i = 0; i < 5; i++ )
                {
                    effect ef = EffectAPI::CreateEx( "Characters\\SaberAlter\\SaberAlterSlash.mdl", efX, efY, .0f, angle, 1.f, 1.f );
                    EffectAPI::SetTimedLife( ef, 3.f );
                }

                War3Image::DisplaceLinear( source, angle, 100.f, .4f, .01f, false, false );

                float dmg = 30.f * Jass::GetHeroLevel( source ) + .25f * Jass::GetHeroInt( source, true );
                group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

                Jass::GroupEnumUnitsInRange( gEnum, efX, efY, 300.f, nil );

                for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
                {
                    if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                    {
                        DamageTarget( source, u, dmg );
                        Displacer::Unit::Move( u, angle, slashes < 3 ? 100.f : 300.f, .35f, .01f, 300.f );
                        Jass::DestroyEffect( Jass::AddSpecialEffectTarget( slashes < 3 ? "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl" : "GeneralEffects\\BloodEffect1.mdx", u, "chest" ) );
                    }
                }

                slashes++;
    
                if ( slashes > 3 )
                {
                    SpellAPI::ReleaseTimer( DataHT, tmr );
                    return;
                }
                else
                {
                    Jass::SaveInteger( DataHT, hid, 'slsh', slashes );
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
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'T1', 100.f, .0f );
            StunUnit( source, 1.f );
            Jass::SetUnitAnimation( source, "spell Channel One" );
            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "Characters\\SaberAlter\\ShadowBurst.mdx", source, "weapon" ) );

            EffectAPI::Jump( source );

            for ( int i = 0; i < 2; i++ )
            {
                effect ef = EffectAPI::CreateEx( "Characters\\SaberAlter\\DarkExplosion.mdl", x, y, .0f, .0f, Jass::GetRandomReal( .95f, 1.25f ), Jass::GetRandomReal( .45f, .7f ) );
                EffectAPI::SetTimedLife( ef, 2.f );
            }

            // Jass::SaveGroupHandle( DataHT, hid, 'grpt', Jass::CreateGroup( ) );
        }
        else if ( ticks == 100 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );

            Jass::SetUnitAnimation( source, "spell Channel Two" );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'T2', 100.f, .0f );

            effect ef = EffectAPI::CreateEx( "Characters\\SaberAlter\\DarkWave.mdl", x, y, 50.f, angle, 1.f, 1.f );
            Jass::SetSpecialEffectColour( ef, 0xFFA0FF70 );
            EffectAPI::SetTimedLife( ef, 3.f );

            Jass::SaveReal( DataHT, hid, 'srcX', x );
            Jass::SaveReal( DataHT, hid, 'srcY', y );
        }
        else if ( ticks >= 100 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            group g = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'grpt' );
            float x = Jass::LoadReal( DataHT, hid, 'srcX' );
            float y = Jass::LoadReal( DataHT, hid, 'srcY' );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );
            float moved = Jass::LoadReal( DataHT, hid, 'move' );
            bool isEff = ( moved % 400.f ) == 0.f;
            moved += 100.f;

            float efX = Jass::MathPointProjectionX( x, angle, moved );
            float efY = Jass::MathPointProjectionY( y, angle, moved );

            if ( isEff )
            {
                effect ef = EffectAPI::CreateEx( "GeneralEffects\\FuzzyStomp.mdl", efX, efY, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 3.f, 1.f );
                EffectAPI::SetTimedLife( ef, 1.f );
            }

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", efX, efY ) );

            float dmg = 300.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, efX, efY, 500.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) && !Jass::IsUnitInGroup( u, g ) )
                {
                    DamageTarget( source, u, dmg );

                    Jass::GroupAddUnit( g, u );
                }
            }

            if ( moved >= 3000 )
            {
                Jass::GroupClear( g );
                SpellAPI::ReleaseTimer( DataHT, tmr );
                return;
            }

            Jass::SaveReal( DataHT, hid, 'move', moved );
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
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'Q2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'W1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'W2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'W3' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'E2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'R2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T1' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T2' ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'psnd' + 'T3' ) );
        }

        Jass::DestroyGroup( Jass::LoadGroupHandle( DataHT, hid, 'egrp' ) );
        Jass::DestroyGroup( Jass::LoadGroupHandle( DataHT, hid, 'grpe' ) );
        Jass::DestroyGroup( Jass::LoadGroupHandle( DataHT, hid, 'grpt' ) );
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
            string path = "Characters\\SaberAlter\\Sounds\\SaberAlter";

            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'D1', Sound::Create( path + "C1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q1', Sound::Create( path + "Q1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'Q2', Sound::Create( path + "Q2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W1', Sound::Create( path + "W1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W2', Sound::Create( path + "W2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'W3', Sound::Create( path + "W3.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E1', Sound::Create( path + "E1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'E2', Sound::Create( path + "E2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R1', Sound::Create( path + "R1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'R2', Sound::Create( path + "R2.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T1', Sound::Create( path + "T1.mp3" ) );
            Jass::SaveSoundHandle( SoundHT, hid, 'psnd' + 'T2', Sound::Create( path + "T2.mp3" ) );
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
                        case E_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @E ); break;
                        case R_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @R ); break;
                        case T_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @T ); break;
                    }
                }
            );

            Jass::SaveTriggerHandle( DataHT, hid, '+trg', trg );
            Jass::SaveGroupHandle( DataHT, hid, 'egrp', Jass::CreateGroup() );
            Jass::SaveGroupHandle( DataHT, hid, 'grpe', Jass::CreateGroup() );
            Jass::SaveGroupHandle( DataHT, hid, 'grpt', Jass::CreateGroup() );
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
