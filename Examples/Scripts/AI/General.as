namespace AI
{
    hashtable DataHT = nil;

	void Start( unit u )
	{
		if ( DataHT == nil ) { return; }

		int u_hid = Jass::GetHandleId( u );

		if ( Jass::LoadBoolean( DataHT, Jass::GetHandleId( u ), 'ISAI' ) ) { return; }
		Jass::SaveBoolean( DataHT, Jass::GetHandleId( u ), 'ISAI', true );

		timer tmr = Jass::CreateTimer( );
		int hid = Jass::GetHandleId( tmr );

		Jass::SaveUnitHandle( DataHT, hid, 'usrc', u );
		Jass::SaveHandleList( DataHT, hid, 'list', Jass::HandleListCreate( ) );
		
		/* AI Loop, disabled as it's not all that good.
		Jass::TimerStart
		(
			tmr,
			1.f,
			true,
			function()
			{
				if ( true )
				{
					timer tmr = Jass::GetExpiredTimer( );
					int hid = Jass::GetHandleId( tmr );
					unit source = Jass::LoadUnitHandle( DataHT, hid, 'usrc' );
					int tick = Jass::LoadInteger( DataHT, hid, 'tick' ) + 1;
					handlelist list = Jass::LoadHandleList( DataHT, hid, 'list' );
					player p = Jass::GetOwningPlayer( source );
					int team = Jass::GetPlayerTeam( p );
					unit boss = Jass::LoadUnitHandle( VarHT, 'BOSS', 'unit' );
					unit utarg = nil;

					Jass::SaveInteger( DataHT, hid, 'tick', tick );

					float x = Jass::GetUnitX( source );
					float y = Jass::GetUnitY( source );

					Jass::HandleListClear( list );
					Jass::HandleListEnumUnitsInRange( list, x, y, 600.f, nil );

					for( int i = 0; i < Jass::HandleListGetUnitCount( list ); i++ )
					{
						unit u = Jass::HandleListGetUnitByIndex( list, i );

						if ( Jass::IsUnitAlive( u ) && Jass::IsPlayerEnemy( Jass::GetOwningPlayer( u ), p ) )
						{
							utarg = u;

							if ( Jass::IsUnitType( u, Jass::UNIT_TYPE_HERO ) )
							{
								break;
							}
						}
					}

					if ( utarg == nil )
					{
						if ( source != boss )
						{
							Jass::HandleListClear( list );
							Jass::HandleListEnumItemsInRange( list, x, y, 1600.f, nil );

							for( int i = 0; i < Jass::HandleListGetItemCount( list ); i++ )
							{
								if ( !UnitHasEmptySlot( source ) ) { break; }
								item itm = Jass::HandleListGetItemByIndex( list, i );

								if ( Jass::IsItemVisible( itm ) && Jass::GetItemLife( itm ) >= .0f && Jass::GetItemType( itm ) == Jass::ITEM_TYPE_POWERUP )
								{
									Jass::IssueTargetOrder( source, "smart", itm );
									break;
								}
							}

							Jass::HandleListClear( list );
						}
					}
					else
					{
						float targX = Jass::GetUnitX( utarg );
						float targY = Jass::GetUnitY( utarg );

						Jass::IssueTargetOrder( source, "attack", utarg );
						Jass::IssueTargetOrder( source, "purge", utarg );
						Jass::IssueTargetOrder( source, "drain", utarg );
						Jass::IssueTargetOrder( source, "curse", utarg );
						Jass::IssuePointOrder( source, "shockwave", targX, targY );
						Jass::IssuePointOrder( source, "blizzard", targX, targY );
						Jass::IssuePointOrder( source, "inferno", targX, targY );
						Jass::IssuePointOrder( source, "carrionswarm", targX, targY );
						Jass::IssueImmediateOrder( source, "stomp" );
						Jass::IssueImmediateOrder( source, "roar" );

						if ( ( !Jass::IsUnitType( utarg, Jass::UNIT_TYPE_HERO ) && Jass::GetUnitCurrentLife( utarg ) >= 500.f ) || Jass::IsUnitType( utarg, Jass::UNIT_TYPE_HERO ) )
						{
							Jass::IssueImmediateOrder( source, "thunderclap" );
							Jass::IssueTargetOrder( source, "cripple", utarg );
							Jass::IssueTargetOrder( source, "hex", utarg );
							Jass::IssueTargetOrder( source, "banish", utarg );
							Jass::IssuePointOrder( source, "breathoffire", targX, targY );
							Jass::IssuePointOrder( source, "earthquake", targX, targY );
						}

						if ( source != boss )
						{
							if ( GetUnitStatePercent( source, Jass::UNIT_STATE_LIFE, Jass::UNIT_STATE_MAX_LIFE ) <= 20.f )
							{
								Jass::IssuePointOrder( source, "move", team == 0 ? -4288.f : 4288.f, -576.f );
							}
							else
							{
								if ( tick >= 10 )
								{
									Jass::IssuePointOrder( source, "attack", Jass::GetRandomReal( -1900.f, 1900.f ), Jass::GetRandomReal( -110.f, 180.f ) );
									tick = 0;
								}
							}
						}
					}
				}			
			}
		);
		*/

		if ( u != Jass::LoadUnitHandle( VarHT, 'BOSS', 'unit' ) )
		{
			player p = Jass::GetOwningPlayer( u );
			aidifficulty ai = Jass::GetAIDifficulty( p );

			if ( ai == Jass::AI_DIFFICULTY_NEWBIE )
			{
				Jass::SetPlayerHandicapXP( p, 1.5f );
			}
			else if ( ai == Jass::AI_DIFFICULTY_NORMAL )
			{
				Jass::SetPlayerHandicapXP( p, 2.f );
			}
			else if ( ai == Jass::AI_DIFFICULTY_INSANE )
			{
				Jass::SetPlayerHandicapXP( p, 3.f );
			}

			Jass::IssuePointOrder( u, "attack", Jass::GetRandomReal( -1900.f, 1900.f ), Jass::GetRandomReal( -1200.f, 200.f ) );
		}
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