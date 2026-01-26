namespace SpellAPI
{
	int Tick( hashtable ht, int hid )
	{
		if ( ht == nil ) { return 0; }

		int tick = Jass::LoadInteger( ht, hid, 'tick' ); if ( Jass::LoadBoolean( ht, hid, 'skip' ) ) { return tick; }
		Jass::SaveInteger( ht, hid, 'tick', tick + 1 );
		return tick;
	}

	bool Counter( hashtable ht, int hid, int id, int max )
	{
		if ( ht == nil ) { return false; }

		int count = Jass::LoadInteger( ht, hid, 'icnt' + id );

		if ( !Jass::LoadBoolean( ht, hid, 'bcnt' + id ) )
		{
			Jass::SaveBoolean( ht, hid, 'bcnt' + id, true );
			return true;
		}

		if ( count + 1 >= max )
		{
			Jass::SaveInteger( ht, hid, 'icnt' + id, 0 );
			return true;
		}
		else
		{
			Jass::SaveInteger( ht, hid, 'icnt' + id, count + 1 );
		}

		return false;
	}

	void ReleaseTimer( hashtable ht, timer tmr, bool extraClean = true )
	{
		if ( ht == nil || tmr == nil ) { return; }

		int hid = Jass::GetHandleId( tmr );
		unit source = Jass::LoadUnitHandle( ht, hid, 'usrc' );
		unit target = Jass::LoadUnitHandle( ht, hid, 'utrg' );

		Jass::PauseTimer( tmr );

		if ( extraClean )
		{
			if ( Jass::IsUnitPaused( source ) )
			{
				Jass::PauseUnit( source, false );
				Jass::IssueImmediateOrder( source, "stop" );
			}

			Jass::SetUnitTimeScale( source, 1.f );
			Jass::ShowUnit( source, true );
			Jass::SetUnitPathing( source, true );
			Jass::SetUnitInvulnerable( source, false );
			Jass::DestroyEffect( Jass::LoadEffectHandle( ht, hid, '+eff' ) );
			Jass::SetUnitVertexColor( source, 255, 255, 255, 255 );
		}

		Jass::FlushChildHashtable( ht, hid );
		Jass::DestroyTimer( tmr );
	}

	bool IsStopCast( unit target, float targX, float targY )
	{
		return target == nil && Jass::IsTerrainPathable( targX, targY, Jass::PATHING_TYPE_WALKABILITY );
	}

	bool Stop( hashtable ht, int hid, int mod )
	{
		if ( ht == nil ) { return false; }

		unit source = Jass::LoadUnitHandle( ht, hid, 'usrc' );
		unit target = Jass::LoadUnitHandle( ht, hid, 'utrg' );
		bool isStop = false;

		if ( mod == 0 )
		{
			isStop = Jass::GetUnitCurrentLife( source ) <= .0f;
		}
		else
		{
			isStop = Jass::GetUnitCurrentLife( source ) <= .0f || Jass::GetUnitCurrentLife( target ) <= .0f;
		}

		return isStop;
	}

	timer Handler( hashtable ht, ability abil, unit source, unit target, float targX, float targY, CallbackFunc@ act )
	{
		timer tmr = Jass::CreateTimer( );

		if ( ht != nil )
		{
			int hid = Jass::GetHandleId( tmr );
			int aid = Jass::GetAbilityTypeId( abil );
			int alvl = Jass::GetAbilityLevel( abil );
			int lvl = Jass::GetHeroLevel( source );
			int uid = Jass::GetUnitTypeId( source );
			player p = Jass::GetOwningPlayer( source );
			float x = Jass::GetUnitX( source );
			float y = Jass::GetUnitY( source );
			float facing = Jass::GetUnitFacing( source );
			float angle = facing;

			Jass::SaveInteger( ht, hid, 'utid', uid );
			Jass::SaveInteger( ht, hid, 'ulvl', lvl );
			Jass::SaveInteger( ht, hid, 'atid', aid );
			Jass::SaveInteger( ht, hid, 'alvl', alvl );

			Jass::SaveReal( ht, hid, 'srcX', Jass::GetUnitX( source ) );
			Jass::SaveReal( ht, hid, 'srcY', Jass::GetUnitY( source ) );
			Jass::SaveReal( ht, hid, 'face', facing );

			Jass::SavePlayerHandle( ht, hid, '+ply', p );
			Jass::SaveAbilityHandle( ht, hid, 'abil', abil );
			Jass::SaveUnitHandle( ht, hid, 'usrc', source );

			if ( target != nil )
			{
				Jass::SaveUnitHandle( ht, hid, 'utrg', target );
				targX = Jass::GetUnitX( target );
				targY = Jass::GetUnitY( target );
			}

			Jass::SaveReal( ht, hid, 'angl', x == targX && y == targY ? facing : Jass::MathAngleBetweenPoints( x, y, targX, targY ) );
			Jass::SaveReal( ht, hid, 'dist', Jass::MathDistanceBetweenPoints( x, y, targX, targY ) );
			Jass::SaveReal( ht, hid, 'trgX', targX );
			Jass::SaveReal( ht, hid, 'trgY', targY );
		}

		if ( !( act is null ) )
		{
			Jass::TimerStart( tmr, .01f, true, act );
		}
		
		return tmr;
	}

	timer Handler( CallbackFunc@ act, hashtable ht = nil )
	{
		Handler( ht, nil, nil, nil, .0f, .0f, act );
	}
}