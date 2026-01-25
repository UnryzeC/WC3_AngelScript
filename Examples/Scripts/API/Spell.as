namespace SpellAPI
{
    hashtable handlerHT = nil;

	int Tick( hashtable ht, int hid )
	{
		int tick = Jass::LoadInteger( ht, hid, 'tick' ); if ( Jass::LoadBoolean( ht, hid, 'skip' ) ) { return tick; }
		Jass::SaveInteger( ht, hid, 'tick', tick + 1 );
		return tick;
	}

	int Tick( int hid, hashtable ht = handlerHT )
	{
		return Tick( ht, hid );
	}

	bool Counter( hashtable ht, int hid, int id, int max )
	{
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

	bool Counter( int hid, int id, int max, hashtable ht = handlerHT )
	{
		return Counter( ht, hid, id, max );
	}

	void ReleaseTimer( hashtable ht, timer tmr, bool extraClean = true )
	{
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
			Jass::SetUnitTimeScale( source, 1 );
			Jass::ShowUnit( source, true );
			Jass::SetUnitPathing( source, true );
			Jass::KillUnit( Jass::LoadUnitHandle( ht, hid, 106 ) );
			Jass::SetUnitInvulnerable( source, false );
			Jass::RemoveLocation( Jass::LoadLocationHandle( ht, hid, 102 ) );
			Jass::RemoveLocation( Jass::LoadLocationHandle( ht, hid, 103 ) );
			Jass::RemoveLocation( Jass::LoadLocationHandle( ht, hid, 107 ) );
			Jass::DestroyEffect( Jass::LoadEffectHandle( ht, hid, '+eff' ) );
			Jass::SetUnitVertexColor( source, 255, 255, 255, 255 );
		}

		Jass::FlushChildHashtable( ht, hid );
		Jass::DestroyTimer( tmr );
	}

	void ReleaseTimer( timer tmr, bool extraClean = true, hashtable ht = handlerHT )
	{
		ReleaseTimer( ht, tmr, extraClean );
	}

	void Clear( int hid, hashtable ht = handlerHT )
	{
		SpellAPI::ReleaseTimer( handlerHT, Jass::GetExpiredTimer( ), true );
	}

	bool Stop( hashtable ht, int hid, int mod, bool onlyCheck = false )
	{
		unit source = Jass::LoadUnitHandle( ht, hid, 'usrc' );
		unit target = Jass::LoadUnitHandle( ht, hid, 'utrg' );
		bool isClear = false;

		if ( mod == 0 )
		{
			isClear = Jass::GetUnitCurrentLife( source ) <= .0f;
		}
		else
		{
			isClear = Jass::GetUnitCurrentLife( source ) <= .0f || Jass::GetUnitCurrentLife( target ) <= .0f;
		}

		if ( isClear && !onlyCheck )
		{
			Clear( hid, ht );
		}

		return isClear;
	}

	bool Stop( int hid, int mod, bool onlyCheck = false, hashtable ht = handlerHT )
	{
		return Stop( ht, mod, onlyCheck, ht );
	}

	timer Handler( hashtable ht, ability abil, unit source, unit target, float targX, float targY, CallbackFunc@ act )
	{
		timer tmr = Jass::CreateTimer( );
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

		if ( !( act is null ) )
		{
			Jass::TimerStart( tmr, .01f, true, act );
		}
		
		return tmr;
	}

	timer Handler( ability abil, unit source, unit target, float targX, float targY, CallbackFunc@ act, hashtable ht = handlerHT )
	{
		return Handler( ht, abil, source, target, targX, targY, act );
	}

	timer Handler( CallbackFunc@ act )
	{
		return Handler( nil, nil, nil, .0f, .0f, act, handlerHT );
	}

	bool IsStopCast( unit target, float targX, float targY )
	{
		return target == nil && Jass::IsTerrainPathable( targX, targY, Jass::PATHING_TYPE_WALKABILITY );
	}

    void Init( hashtable ht, uint32 flags = ( 1 ) )
    {
        if ( handlerHT == nil || ( flags & 1 ) == 1 )
        {
            handlerHT = ht;
        }
    }
}