namespace EffectAPI
{
    timer LifeTimer = nil;
    hashtable LifeHT = Jass::InitHashtable( );

    effect Create( string model, float x, float y, float facing )
    {
        effect ef = Jass::AddSpecialEffect( model, x, y );
        Jass::SetSpecialEffectFacing( ef, facing );

        return ef;
    }

    effect CreateEx( string model, float x, float y, float height = .0f, float facing = 270.f, float scale = 1.f, float timeScale = 1.f )
    {
        effect ef = Create( model, x, y, facing );
        Jass::SetSpecialEffectHeight( ef, height );
        Jass::SetSpecialEffectScale( ef, scale );
        Jass::SetSpecialEffectTimeScale( ef, timeScale );

        return ef;
    }

    void Remove( effect ef )
    {
        if ( ef == nil ) { return; }

        Jass::SetSpecialEffectVisible( ef, false );
        Jass::DestroyEffect( ef );
    }

    void SetTimedLife( effect ef, float time, string anim = "" )
    {
        if ( Jass::IsHandleDestroyed( ef ) ) { return; } // returns true if ef is nil, or underlaying object was destroyed.

        int ef_hid = Jass::GetHandleId( ef );
        Jass::SaveReal( LifeHT, ef_hid, 'LIFE', time );
        Jass::SaveStr( LifeHT, ef_hid, 'ANIM', anim );

        int hid = Jass::GetHandleId( LifeTimer );
        handlelist hl = Jass::LoadHandleList( LifeHT, hid, 'ELST' );

        if ( hl == nil )
        {
            LifeTimer = Jass::CreateTimer( );
            hid = Jass::GetHandleId( LifeTimer );
            hl = Jass::HandleListCreate( );

            Jass::SaveHandleList( LifeHT, hid, 'ELST', hl );

            Jass::TimerStart
            (
                LifeTimer,
                .05f,
                true,
                function()
                {
                    int hid = Jass::GetHandleId( Jass::GetExpiredTimer( ) );
                    handlelist hl = Jass::LoadHandleList( LifeHT, hid, 'ELST' ); if ( hl == nil ) { return; }
                    int max = Jass::HandleListGetCount( hl );

                    //print( "OnProcessEffectList: " + "hl = " + Jass::I2S( Jass::GetHandleId( hl ) ) + " | max: " + Jass::I2S( max ) + "\n" );

                    for ( int i = 0; i < max; i++ )
                    {
                        effect ef = Jass::HandleListGetEffectByIndex( hl, i ); if ( ef == nil ) { break; }
                        int ef_hid = Jass::GetHandleId( ef );
                        float life = Jass::LoadReal( LifeHT, ef_hid, 'LIFE' ) - .05f;

                        if ( life <= .0f )
                        {
                            Jass::HandleListRemoveHandle( hl, ef );

                            string anim = Jass::LoadStr( LifeHT, ef_hid, 'ANIM' );

                            if ( anim.isEmpty( ) )
                            {
                                Remove( ef );
                            }
                            else
                            {
                                Jass::SetSpecialEffectAnimation( ef, anim );
                                Jass::DestroyEffect( ef );
                            }
                            
                            i--;
                            max = Jass::HandleListGetCount( hl );
                        }
                        else
                        {
                            Jass::SaveReal( LifeHT, ef_hid, 'LIFE', life );
                        }
                    }				
                }
            );
        }

        Jass::HandleListAddHandle( hl, ef );
    }


    void Dash( unit source, int effCount = 6, float moveStep = 40.f, float initSize = .4f, float sizeStep = .25f, float timeScale = 1.25f, float height = 50.f )
    {
        float angle = Jass::GetUnitFacing( source );
        float x = Jass::MathPointProjectionX( Jass::GetUnitX( source ), angle, 100.f );
        float y = Jass::MathPointProjectionY( Jass::GetUnitY( source ), angle, 100.f );
        effect ef;

        for ( int i = 0; i < effCount; i++ )
        {
            float move = -( moveStep + moveStep * i );

            ef = CreateEx( "GeneralEffects\\ValkDust.mdl", Jass::MathPointProjectionX( x, angle, move ), Jass::MathPointProjectionY( y, angle, move ), height, angle, initSize + sizeStep * i, timeScale );
            Jass::SetSpecialEffectAlpha( ef, 0xA0 );
            Jass::SetSpecialEffectPitch( ef, -90.f );
            SetTimedLife( ef, 4.f );
        }
    }

    void Jump( unit source, int effCount = 6 )
    {
        float x = Jass::GetUnitX( source );
        float y = Jass::GetUnitY( source );
        float angle = Jass::GetUnitFacing( source );
        effect ef;

        //ef = CreateEx( "GeneralEffects\\FuzzyStomp.mdl", x, y, 0.f, Jass::GetRandomReal( 0.f, 360.f ), 3.f, 1.f );
        //SetTimedLife( ef, 1.f );
        Jass::DestroyEffect( Jass::AddSpecialEffect( "GeneralEffects\\NewDirtEx.mdx", x, y ) );

        for ( int i = 0; i < effCount; i++ )
        {
            ef = CreateEx( "GeneralEffects\\ValkDust.mdl", x, y, .0f, Jass::GetRandomReal( .0f, 360.f ), 1.f + .25f * i, Jass::GetRandomReal( .5f, 1.5f ) );
            Jass::SetSpecialEffectAlpha( ef, 0xA0 );
            SetTimedLife( ef, 4.f );
        }
    }

    void InverseDash( unit source, int effCount = 6, float moveStep = 25.f, float initSize = .4f, float sizeStep = .15f, float timeScale = 1.25f, float height = 50.f )
    {
        Dash( source, effCount, -moveStep, initSize, sizeStep, timeScale, height );
    }

    void PushWind( unit source, unit target, float baseHeight = 50.f, float pitch = -90.f )
    {
        float x = Jass::GetUnitX( source );
        float y = Jass::GetUnitY( source );
        float targX = Jass::GetUnitX( target );
        float targY = Jass::GetUnitY( target );
        float angle = Jass::MathAngleBetweenPoints( x, y, targX, targY );
        float dist = Jass::MathDistanceBetweenPoints( x, y, targX, targY );
        effect ef;

        for ( int i = 0; i < 3; i++ )
        {
            float move = 25.f + 25.f * i;

            ef = CreateEx( "GeneralEffects\\ValkDust.mdl", Jass::MathPointProjectionX( x, angle, move ), Jass::MathPointProjectionY( y, angle, move ), 50.f, angle, 1.f + .25f * i, 1.f );
            Jass::SetSpecialEffectPitch( ef, pitch );
            SetTimedLife( ef, 4.f );
        }

        ef = CreateEx( "GeneralEffects\\ValkDust.mdl", targX, targY, baseHeight, angle, 1.5f, 2.f );
        Jass::SetSpecialEffectPitch( ef, pitch );
        SetTimedLife( ef, 4.f );

        ef = CreateEx( "GeneralEffects\\SlamEffect.mdl", targX, targY, baseHeight, angle, 1.f, 2.f );
        Jass::SetSpecialEffectPitch( ef, pitch );
        SetTimedLife( ef, 3.f );
    }
}