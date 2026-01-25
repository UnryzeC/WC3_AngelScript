namespace War3Image
{
    hashtable DataHT = nil;

	bool DisplaceToTarget( war3image source, war3image target, float speed, float minDist )
	{
		float x = Jass::GetWar3ImageX( source );
		float y = Jass::GetWar3ImageY( source );
		float targX = Jass::GetWar3ImageX( target );
		float targY = Jass::GetWar3ImageY( target );
		float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
		float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );

		Jass::SetWar3ImageFacing( source, angle, true );

		if ( dist > minDist )
		{
			x = Jass::MathPointProjectionX( x, angle, speed );
			y = Jass::MathPointProjectionY( y, angle, speed );
			dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
			Jass::SetWar3ImagePosition( source, x, y );
		}

		return dist <= minDist;
	}

	void DisplaceWithArgs( war3image source, float angle, float dist, float time, float rate, float heightMax )
	{
		if ( source == nil || Jass::LoadInteger( DataHT, Jass::GetHandleId( source ), 'disp' ) > 0 ) { return; }

		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );
		float x = Jass::GetWar3ImageX( source );
		float y = Jass::GetWar3ImageY( source );
		int magnitudeMax = Jass::R2I( time / rate );
		int magnitude = 0;
		float step = dist / magnitudeMax;
		float heightStep = 1.f / magnitudeMax;
		float heightOrig = Jass::GetWar3ImageHeight( source );

		Jass::SaveInteger( DataHT, Jass::GetHandleId( source ), 'disp', 1 );
		Jass::SaveWar3ImageHandle( DataHT, hid, '+src', source );
		Jass::SaveReal( DataHT, hid, 'horg', heightOrig );
		Jass::SaveReal( DataHT, hid, 'angl', angle );
		Jass::SaveReal( DataHT, hid, 'step', step );
		Jass::SaveReal( DataHT, hid, 'hmax', heightMax );
		Jass::SaveReal( DataHT, hid, 'hstp', heightStep );
		Jass::SaveReal( DataHT, hid, 'srcX', x );
		Jass::SaveReal( DataHT, hid, 'srcY', y );
		Jass::SaveInteger( DataHT, hid, 'magc', magnitude );
		Jass::SaveInteger( DataHT, hid, 'magm', magnitudeMax );

		Jass::TimerStart
		(
			tmr,
			rate,
			true,
			function()
			{
				timer tmr = Jass::GetExpiredTimer( );
				int hid = Jass::GetHandleId( tmr );
				int magnitude = Jass::LoadInteger( DataHT, hid, 'magc' );
				int magnitudeMax = Jass::LoadInteger( DataHT, hid, 'magm' );
				float heightOrig = Jass::LoadReal( DataHT, hid, 'horg' );
				war3image source = Jass::LoadEffectHandle( DataHT, hid, '+src' );
				int isMoved = Jass::LoadInteger( DataHT, Jass::GetHandleId( source ), 'disp' );

				if ( ( magnitude < magnitudeMax && isMoved > 0 ) )
				{
					float angle = Jass::LoadReal( DataHT, hid, 'angl' );
					float step = Jass::LoadReal( DataHT, hid, 'step' );
					float x = Jass::LoadReal( DataHT, hid, 'srcX' );
					float y = Jass::LoadReal( DataHT, hid, 'srcY' );
					float moveX = Jass::MathPointProjectionX( x, angle, magnitude * step );
					float moveY = Jass::MathPointProjectionY( y, angle, magnitude * step );
					bool isMove = IsAxisReal( moveX, moveY );

					if ( isMove )
					{
						Jass::SetWar3ImagePosition( source, moveX, moveY );
					}
					
					float heightMax = Jass::LoadReal( DataHT, hid, 'hmax' );
					float heightStep = Jass::LoadReal( DataHT, hid, 'hstp' );
					float hmag = ( 2.f * Jass::I2R( magnitude ) * heightStep - 1 );
					Jass::SaveInteger( DataHT, hid, 'magc', magnitude + 1 );
					Jass::SetWar3ImageHeight( source, ( 1.f + -hmag * hmag ) * heightMax + heightOrig );
				}
				else
				{
					Jass::SetWar3ImageHeight( source, heightOrig );
					Jass::ResetWar3ImageZ( source );
					Jass::SaveInteger( DataHT, Jass::GetHandleId( source ), 'disp', isMoved - 1 );
					Jass::PauseTimer( tmr );
					Jass::FlushChildHashtable( DataHT, hid );
					Jass::DestroyTimer( tmr );
				}			
			}
		);
	}

    string LINEAR_MODEL = "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl";

	void DisplaceLinear
    (
        war3image source,
        float angle,
        float dist,
        float ticks,
        float rate,
        bool destDestr,
        bool ignorePathing,
        string effmdl = LINEAR_MODEL
    )
	{
		if ( source == nil )
		{
			return;
		}

		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );
		float step = 2.f * dist * rate / ticks;

		Jass::SaveReal( DataHT, hid, 'angl', angle );
		Jass::SaveReal( DataHT, hid, 'step', step );
		Jass::SaveReal( DataHT, hid, 'rate', step * rate / ticks );
		Jass::SaveWar3ImageHandle( DataHT, hid, '+src', source );
		Jass::SaveBoolean( DataHT, hid, 'PATH', !ignorePathing );
		Jass::SaveStr( DataHT, hid, 'emdl', effmdl );
		Jass::SaveReal( DataHT, hid, 'time', ticks / rate );

        //Jass::SaveHashtableHandle( DataHT, hid, 'htbl', ht );

		Jass::TimerStart
		(
			tmr,
			rate,
			true,
			function()
			{
				timer tmr = Jass::GetExpiredTimer( );
				int hid = Jass::GetHandleId( tmr );
                //hashtable ht = Jass::LoadHashtableHandle( DataHT, hid, 'htbl' );

				float angle = Jass::LoadReal( DataHT, hid, 'angl' );
				float step = Jass::LoadReal( DataHT, hid, 'step' );
				war3image source = Jass::LoadWar3ImageHandle( DataHT, hid, '+src' );
				float x = Jass::GetWar3ImageX( source );
				float y = Jass::GetWar3ImageY( source );
				float moveX = Jass::MathPointProjectionX( x, angle, step );
				float moveY = Jass::MathPointProjectionY( y, angle, step );
				bool isMove = Jass::LoadBoolean( DataHT, hid, 'PATH' ) ? !Jass::IsTerrainPathable( moveX, moveY, Jass::PATHING_TYPE_WALKABILITY ) : true;

				if ( step <= 0 || !IsAxisReal( moveX, moveY ) || !isMove )
				{
					Jass::PauseTimer( tmr );
					Jass::FlushChildHashtable( DataHT, hid );
					Jass::DestroyTimer( tmr );
					return;
				}

				string effMdl = Jass::LoadStr( DataHT, hid, 'emdl' );

				if ( !effMdl.isEmpty( ) )
				{
					Jass::DestroyEffect( Jass::AddSpecialEffect( effMdl, x, y ) );
				}

				Jass::SetWar3ImagePosition( source, moveX, moveY );
				Jass::SaveReal( DataHT, hid, 'step', step - Jass::LoadReal( DataHT, hid, 'rate' ) );
			}
		);
	}

    hashtable GetTable( )
    {
        return DataHT;
    }

    void Init( hashtable whichHashTable, string defLinearModel = LINEAR_MODEL )
    {
        hashtable prevHT = DataHT;

        if ( prevHT != nil )
        {
            Jass::FlushParentHashtable( prevHT );
        }

		DataHT = whichHashTable;
        LINEAR_MODEL = defLinearModel;
    }
}