namespace Displacer::Unit
{
    hashtable DataHT = nil;

    void Move( unit u, float angle, float dist, float time, float rate, float heightMax )
    {
        if ( u == nil || Jass::LoadInteger( DataHT, Jass::GetHandleId( u ), 'disp' ) > 0 ) { return; }

        timer tmr = Jass::CreateTimer( );
        int hid = Jass::GetHandleId( tmr );
        float x = Jass::GetUnitX( u );
        float y = Jass::GetUnitY( u );
        int magnitudeMax = Jass::R2I( time / rate );
        int magnitude = 0;
        float step = dist / magnitudeMax;
        float heightStep = 1.f / magnitudeMax;
        float heightOrig = Jass::GetUnitFlyHeight( u );

        Jass::SetUnitPathing( u, false );
        Jass::SaveInteger( DataHT, Jass::GetHandleId( u ), 'disp', 1 );
        Jass::SaveUnitHandle( DataHT, hid, 'usrc', u );
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
                unit u = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
                int isMoved = Jass::LoadInteger( DataHT, Jass::GetHandleId( u ), 'disp' );

                if ( ( magnitude < magnitudeMax && isMoved > 0 ) && Jass::IsUnitAlive( u ) )
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
                        SetUnitXY( u, moveX, moveY );
                    }
                    
                    float heightMax = Jass::LoadReal( DataHT, hid, 'hmax' );
                    float heightStep = Jass::LoadReal( DataHT, hid, 'hstp' );
                    float hmag = ( 2.f * Jass::I2R( magnitude ) * heightStep - 1 );
                    Jass::SaveInteger( DataHT, hid, 'magc', magnitude + 1 );
                    Jass::SetUnitFlyHeight( u, ( 1.f + -hmag * hmag ) * heightMax + heightOrig, 99999.f );
                }
                else
                {
                    Jass::SetUnitFlyHeight( u, heightOrig, 99999.f );
                    Jass::SetUnitPathing( u, true );
                    Jass::SaveInteger( DataHT, Jass::GetHandleId( u ), 'disp', isMoved - 1 );
                    Jass::PauseTimer( tmr );
                    Jass::FlushChildHashtable( DataHT, hid );
                    Jass::DestroyTimer( tmr );
                }
            }
        );
    }

    hashtable GetTable( )
    {
        return DataHT;
    }

    void Init( hashtable whichHashTable )
    {
        hashtable prevHT = DataHT;

        if ( prevHT != nil )
        {
            Jass::FlushParentHashtable( prevHT );
        }

        DataHT = whichHashTable;
    }
}