namespace Sound
{
    hashtable HT = nil;

    sound Create( string filePath )
    {
        return Jass::CreateSound( filePath, false, false, false, 12700, 12700, "DefaultEAXON" );
    }

    void PlayWithVolume( sound soundHandle, float volumePercent, float startingOffset )
    {
        if ( soundHandle == nil )
        {
            return;
        }

        int result = Jass::MathIntegerClamp( Jass::R2I( volumePercent * Jass::I2R( 127 ) * .01f ), 0, 127 );

        Jass::SetSoundVolume( soundHandle, result );
        Jass::StartSound( soundHandle );
        Jass::SetSoundPlayPosition( soundHandle, Jass::R2I( startingOffset * 1000 ) );
    }

    void StopEx( sound snd, bool killWhenDone, bool fadeOut )
    {
        if ( !Jass::GetSoundIsPlaying( snd ) ) { return; }
        Jass::StopSound( snd, killWhenDone, fadeOut );
    }

	void PlayHero( hashtable ht, unit u, uint childKey, float volume, float startingOffset )
	{
		PlayWithVolume( Jass::LoadSoundHandle( ht, Jass::GetHandleId( u ), childKey ), volume, startingOffset );
	}

	void StopHero( hashtable ht, unit u, uint childKey )
	{
		StopEx( Jass::LoadSoundHandle( ht, Jass::GetHandleId( u ), childKey ), false, false );
	}

    void Init( hashtable whichHashTable )
    {
        HT = whichHashTable;
    }
}