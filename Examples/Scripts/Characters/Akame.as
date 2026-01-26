#include "Base.as"

namespace Akame
{
    hashtable DataHT = nil;
    hashtable SoundHT = nil;
    const uint32 UNIT_TYPE_ID = 'H00G';
    const uint32 ITEM_TYPE_ID = 'I01V';
    const uint32 BUFF_TYPE_ID = 'B006';
    const string MODEL_PATH = "Characters\\Akame\\Akame";
    const string ICON_PATH = "Characters\\Akame\\ReplaceableTextures\\CommandButtons\\BTNAkameIcon.blp";
    const float SCALE = 1.5f;
    const uint32 D1_TYPE_ID = 'A03K';
    const uint32 D2_TYPE_ID = 'A052';
    const uint32 Q_TYPE_ID = 'A03L';
    const uint32 W_TYPE_ID = 'A03M';
    const uint32 E_TYPE_ID = 'A03N';
    const uint32 R_TYPE_ID = 'A03O';
    const uint32 T_TYPE_ID = 'A03P';

	void PoisonCheck( unit source, unit targ, uint32 buffId = BUFF_TYPE_ID )
	{
		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );

		Jass::SaveUnitHandle( DataHT, hid, 'usrc', source );
		Jass::SaveUnitHandle( DataHT, hid, 'utrg', targ );
        Jass::SaveInteger( DataHT, hid, 'bfid', buffId );

		Jass::TimerStart
		(
			tmr,
			1.f,
			true,
			function()
			{
				timer tmr = Jass::GetExpiredTimer( );
				int hid = Jass::GetHandleId( tmr );
				unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
				unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
                uint32 buffId = Jass::LoadInteger( DataHT, hid, 'bfid' );

				if ( Jass::GetUnitAbilityLevel( target, buffId ) > 0 )
				{
					float dmg = 10 + Jass::GetHeroLevel( source ) + .1f * Jass::GetHeroInt( source, true );
					DamageTarget( source, target, dmg );
				}
				else
				{
					Jass::FlushChildHashtable( DataHT, hid );
					Jass::DestroyTimer( tmr );
				}
			}
		);
	}

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
            float dist = -400.f;

            if ( Jass::LoadInteger( DataHT, hid, 'atid' ) == D2_TYPE_ID )
            {
                dist = -350.f;
                Jass::ShowUnitAbility( source, Q_TYPE_ID, true );
                Jass::ShowUnitAbility( source, D2_TYPE_ID, false );
            }
            Sound::PlayHero( SoundHT, source, 'psnd' + 'D1', 80.f, .0f );
            StunUnit( source, .3f );
            Jass::SetUnitTimeScale( source, 2.f );
            Jass::SetUnitAnimation( source, "spell two" );
            Jass::SetUnitInvulnerable( source, true );
            Jass::SaveReal( DataHT, hid, 'dist', dist );
        }
        else if ( ticks == 20 )
        {
            Displacer::Unit::Move( Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), Jass::LoadReal( DataHT, hid, 'angl' ), Jass::LoadReal( DataHT, hid, 'dist' ), .2f, .01f, 0 );
        }
        else if ( ticks == 30 )
        {
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void Q( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );
        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) || ticks == 200 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            if ( ticks != 200 )
            {
                Sound::StopHero( SoundHT, source, 'psnd' + 'Q1' );
            }

            Jass::ShowUnitAbility( source, Q_TYPE_ID, true );
            Jass::ShowUnitAbility( source, D2_TYPE_ID, false );
            SpellAPI::ReleaseTimer( DataHT, tmr );
            return;
        }
        else if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            StunUnit( source, .2f );
            Jass::SetUnitAnimation( source, "Spell Four" );
        }
        else if ( ticks == 20 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float angle = Jass::GetUnitFacing( source );
            float dist = 200.f;
            float x = Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, dist );
            float y = Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, dist );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 60.f, .0f );

            Jass::ShowUnitAbility( source, Q_TYPE_ID, false );
            Jass::ShowUnitAbility( source, D2_TYPE_ID, true );

            for ( int i = 0; i < 5; i++ )
            {
                effect ef = EffectAPI::CreateEx( "GeneralEffects\\AkihaClaw.mdl", x, y, .0f, angle + 30.f, 1.5f, .8f );
                EffectAPI::SetTimedLife( ef, 4.f );
            }

            float dmg = 250.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            Jass::GroupEnumUnitsInRange( gEnum, x, y, 400.f, nil );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( u ), Jass::GetUnitY( u ) ) );
                    DamageTarget( source, u, dmg );
                    StunUnit( u, 1.f );
                }
            }
        }
    }

    void W( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            if ( SpellAPI::Stop( DataHT, hid, 0 ) )
            {
                Sound::StopHero( SoundHT, source, 'psnd' + 'W1' );
            }

            Jass::SetUnitVertexColor( source, 0xFF, 0xFF, 0xFF, 0xFF );
            Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
            SpellAPI::ReleaseTimer( DataHT, tmr );

            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            StunUnit( source, .2f );
            Jass::SetUnitPathing( source, false );
            Jass::SetUnitAnimation( source, "Spell Channel" );
            Jass::SaveInteger( DataHT, hid, 'acol', 0xFF );
            Jass::SaveEffectHandle( DataHT, hid, '+eff', Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );
        }
        else
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
            int alpha = Jass::MathIntegerClamp( Jass::LoadInteger( DataHT, hid, 'acol' ) - 5, 0, 0xFF );

            Jass::SetUnitVertexColor( source, 0xFF, 0xFF, 0xFF, alpha );
            Jass::SaveInteger( DataHT, hid, 'acol', alpha );

            if ( War3Image::DisplaceToTarget( source, target, 20.f, 100.f ) )
            {
                float dmg = 200.f + 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

                Sound::PlayHero( SoundHT, source, 'psnd' + 'W1', 100.f, .0f );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );

                for ( int i = 0; i < 5; i++ )
                {
                    effect ef = EffectAPI::CreateEx( "Characters\\RyougiShiki\\RyougiShikiWEffect.mdl", x, y, .0f, angle, 4.f, 1.f );
                    //Jass::SetSpecialEffectColour( ef, 0xFFFF7000 );
                    EffectAPI::SetTimedLife( ef, 3.f );
                }

                StunUnit( target, 1.f );
                DamageTarget( source, target, dmg );
                Jass::SetUnitAnimation( source, "attack" );

                Jass::SetUnitVertexColor( source, 0xFF, 0xFF, 0xFF, 0xFF );
                Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
                SpellAPI::ReleaseTimer( DataHT, tmr );
                return;
            }
        }
    }

    void E( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 0 ) )
        {
            Sound::StopHero( SoundHT, Jass::LoadUnitHandle( DataHT, hid, 'usrc' ), 'psnd' + 'E1' );
            SpellAPI::ReleaseTimer( DataHT, tmr );

            return;
        }

        int ticks = SpellAPI::Tick( DataHT, hid );

        if ( ticks == 0 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            StunUnit( source, .3f );
            Jass::SetUnitAnimation( source, "Spell Four" );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'E1', 100.f, .0f );
        }
        else if ( ticks == 30 )
        {
            player p = Jass::LoadPlayerHandle( DataHT, hid, '+ply' );
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            float angle = Jass::LoadReal( DataHT, hid, 'angl' );
            float dist = Jass::LoadReal( DataHT, hid, 'dist' );

            effect ef = EffectAPI::CreateEx( "GeneralEffects\\AkihaClaw.mdl", Jass::MathPointProjectionX( x, angle, dist * .5f ), Jass::MathPointProjectionY( y, angle, dist * .5f ), .0f, angle, 3.f, 1.f );
            EffectAPI::SetTimedLife( ef, 3.f );

            War3Image::DisplaceLinear( source, angle, dist, .1f, .01f, false, true );

            float dmg = 300.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );
            group gEnum = Jass::LoadGroupHandle( DataHT, Jass::GetHandleId( source ), 'egrp' );

            GroupEnumUnitsInLine( gEnum, x, y, angle, dist, 450.f );

            for ( unit u = Jass::GroupForEachUnit( gEnum ); u != nil; u = Jass::GroupForEachUnit( gEnum ) )
            {
                if ( Jass::IsUnitAlive( u ) && Jass::IsUnitEnemy( u, p ) )
                {
                    DamageTarget( source, u, dmg );
                    War3Image::DisplaceLinear( u, angle, 200.f, .5f, .01f, false, false );
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

        if ( SpellAPI::Stop( DataHT, hid, 1 ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            if ( SpellAPI::Stop( DataHT, hid, 0 ) )
            {
                Sound::StopHero( SoundHT, source, 'gsnd' + 0 );
                Sound::StopHero( SoundHT, source, 'gsnd' + 1 );
                Sound::StopHero( SoundHT, source, 'psnd' + 'D1' );
                Sound::StopHero( SoundHT, source, 'psnd' + 'W1' );
                Sound::StopHero( SoundHT, source, 'psnd' + 'R1' );
                Sound::StopHero( SoundHT, source, 'psnd' + 'R2' );
            }

            Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
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

            War3Image::DisplaceLinear( source, angle, dist - 150.f, .6f, .01f, false, false );
            Jass::SetUnitTimeScale( source, 2.f );
            StunUnit( source, 2.8f );
            Jass::SetUnitAnimation( source, "spell three" );
        }
        else if ( ticks == 40 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            float dmg = 250.f + 30.f * Jass::GetHeroLevel( source );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 1, 60.f, .0f );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'D1', 80.f, .0f );

            EffectAPI::PushWind( source, target );

            War3Image::DisplaceLinear( target, angle, 400.f, .5f, .01f, false, false );
            DamageTarget( source, target, dmg );
            Jass::SetUnitAnimation( source, "spell two" );
            Displacer::Unit::Move( source, angle, -400.f, 1, .01f, 0 );
        }
        else if ( ticks == 140 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'R2', 80.f, .0f );

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );
            Jass::ShowUnit( source, false );
            Jass::SaveBoolean( DataHT, hid, 'skip', true );
            Jass::SaveInteger( DataHT, hid, 'tick', ticks + 5 );
        }
        else if ( ticks == 145 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float dmg = 25.f + Jass::GetHeroLevel( source );
            int slashCount = Jass::LoadInteger( DataHT, hid, 'slct' );

            if ( slashCount < 20 )
            {
                float angle = slashCount * 18.f;
                float efX = Jass::MathPointProjectionX( Jass::GetUnitX( target ), angle, 150.f );
                float efY = Jass::MathPointProjectionY( Jass::GetUnitY( target ), angle, 150.f );
                effect ef;

                DamageTarget( source, target, dmg );

                if ( SpellAPI::Counter( DataHT, hid, 0, 4 ) )
                {
                    ef = Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "chest" );
                    Jass::SetSpecialEffectScale( ef, .5f );
                    Jass::DestroyEffect( ef );
                }
                
                ef = EffectAPI::CreateEx( "GeneralEffects\\BlackBlink.mdx", efX, efY, .0f, .0f, .75f, 1.f );
                Jass::DestroyEffect( ef );

                Jass::SaveInteger( DataHT, hid, 'slct', slashCount + 1 );
            }
            else
            {
                Jass::SaveBoolean( DataHT, hid, 'skip', false );
                Jass::SaveInteger( DataHT, hid, 'tick', ticks + 1 );
                Jass::ShowUnit( source, true );
                SelectUnit( source, Jass::LoadPlayerHandle( DataHT, hid, '+ply' ) );
                Jass::SetUnitFacing( source, GetUnitAngle( source, target ) );
                Jass::SetUnitTimeScale( source, .1f );
                Jass::SetUnitAnimation( source, "attack" );
                Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BlackBlink.mdx", Jass::GetUnitX( source ), Jass::GetUnitY( source ) ) );
                Jass::SaveEffectHandle( DataHT, hid, '+eff', Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );
                return;
            }
        }
        else if ( ticks == 190 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            SelectUnit( source, Jass::LoadPlayerHandle( DataHT, hid, '+ply' ) );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'W1', 90.f, .0f );
            Jass::SetUnitTimeScale( source, 2.f );
        }
        else if ( ticks == 210 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
            float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );

            Sound::PlayHero( SoundHT, source, 'psnd' + 'R1', 90.f, .0f );

            for ( int i = 0; i < 3; i++ )
            {
                effect ef = EffectAPI::CreateEx( "GeneralEffects\\AkihaClaw.mdl", targX, targY, .0f, angle, 4.f, 1.f ); // perhaps better to change logic of the effect...?
                EffectAPI::SetTimedLife( ef, 1.f );
            }

            War3Image::DisplaceLinear( source, angle, dist + 400.f, .2f, .01f, false, false );

            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "origin" ) );
        }
        else if ( ticks == 250 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            float x = Jass::GetUnitX( source );
            float y = Jass::GetUnitY( source );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float dmg = 500.f + 50.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

            StunUnit( target, 1 );
            Sound::PlayHero( SoundHT, source, 'gsnd' + 0, 60.f, .0f );
            DamageTarget( source, target, dmg );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", targX, targY ) );
            Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
            SpellAPI::ReleaseTimer( DataHT, tmr );
        }
    }

    void T( )
    {
        timer tmr = Jass::GetExpiredTimer( );
        int hid = Jass::GetHandleId( tmr );

        if ( SpellAPI::Stop( DataHT, hid, 1 ) )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );

            Sound::StopHero( SoundHT, source, 'gsnd' + 1 );
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
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );

            War3Image::DisplaceLinear( source, angle, dist - 150.f, .5f, .01f, false, false );
            StunUnit( source, 2.f );
            Jass::SetUnitAnimation( source, "spell three" );
            StunUnit( target, 2.f );
            Jass::SaveEffectHandle( DataHT, hid, '+eff', Jass::AddSpecialEffectTarget( "Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", source, "weapon" ) );
        }
        else if ( ticks == 50 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float targX = Jass::GetUnitX( target );
            float targY = Jass::GetUnitY( target );
            float angle = GetUnitAngle( source, target );
            float dist = GetUnitDistance( source, target );
            float dmg = 500.f + 50.f * Jass::GetHeroLevel( source );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 1, 60.f, .0f );

            EffectAPI::PushWind( source, target );

            effect ef;

            ef = EffectAPI::CreateEx( "GeneralEffects\\wave.mdl", targX, targY, 200.f, angle, 1.f, 1.f );
            Jass::SetSpecialEffectPitch( ef, -90.f );

            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\BloodEffect1.mdx", target, "chest" ) );
            Jass::DestroyEffect( Jass::AddSpecialEffectTarget( "GeneralEffects\\QQQQQ.mdx", target, "chest" ) );
            War3Image::DisplaceLinear( target, angle, 600.f, 1.f, .01f, false, false );
            DamageTarget( source, target, dmg );
        }
        else if ( ticks == 75 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float dist = GetUnitDistance( source, target ) + 600.f;
            float height = dist / 2.f;

            Displacer::Unit::Move( source, GetUnitAngle( source, target ), dist, .8f, .01f, Jass::MathRealClamp( height, 100.f, 250.f ) );
        }
        else if ( ticks == 155 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );

            Jass::SetUnitTimeScale( source, 1.75f );
            Sound::PlayHero( SoundHT, source, 'psnd' + 'Q1', 80.f, .0f );

            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\BloodEffect1.mdx", Jass::GetUnitX( target ), Jass::GetUnitY( target ) ) );
        }
        else if ( ticks == 205 )
        {
            unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
            unit target = Jass::LoadUnitHandle( DataHT, hid, 'utrg' );
            float dmg = 1000.f + 100.f * Jass::GetHeroLevel( source ) + Jass::GetHeroInt( source, true );

            Sound::PlayHero( SoundHT, source, 'gsnd' + 0, 60.f, .0f );
            Jass::DestroyEffect( Jass::LoadEffectHandle( DataHT, hid, '+eff' ) );
            Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\26.mdx", Jass::GetUnitX( target ), Jass::GetUnitY( target ) ) );

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
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'gsnd' + 0 ) );
            Jass::RemoveSound( Jass::LoadSoundHandle( SoundHT, hid, 'gsnd' + 1 ) );
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
            Jass::SaveSoundHandle( SoundHT, hid, 'gsnd' + 1, Sound::Create( "GeneralSounds\\KickSound1.mp3" ) );

            Jass::SaveBoolean( SoundHT, hid, 'gsnd', true );
        }

        if ( !Jass::LoadBoolean( SoundHT, hid, 'psnd' ) )
        {
            string path = "Characters\\Akame\\Sounds\\AkameSpell";

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
                        case D1_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @D ); break;
                        case D2_TYPE_ID: SpellAPI::Handler( DataHT, abil, source, nil, targX, targY, @D ); break;
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