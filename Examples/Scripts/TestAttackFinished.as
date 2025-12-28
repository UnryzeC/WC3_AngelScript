#include "TriggerAPI.as"

namespace Test::AttackFinished
{
    void Init( )
    {
		unit u = Jass::CreateUnit( Jass::Player( 0 ), 'Hpal', .0f, .0f, .0f );

		TriggerAPI::RegisterAnyUnitEvent
		(
			Jass::CreateTrigger( ),
			Jass::EVENT_UNIT_ATTACK_FINISHED,
			u,
			null,
			function( )
			{
				print( "[EVENT_UNIT_ATTACK_FINISHED]: GetAttacker( ) = " + Jass::GetHandleId( Jass::GetAttacker( ) ) + " | GetTriggerUnit( ) = " + Jass::GetHandleId( Jass::GetTriggerUnit( ) ) + "\n" );
			}
		);

		u = Jass::CreateUnit( Jass::Player( 0 ), 'Hamg', .0f, .0f, .0f );

		TriggerAPI::RegisterAnyUnitEvent
		(
			Jass::CreateTrigger( ),
			Jass::EVENT_UNIT_ATTACK_FINISHED,
			u,
			null,
			function( )
			{
				print( "[EVENT_UNIT_ATTACK_FINISHED]: GetAttacker( ) = " + Jass::GetHandleId( Jass::GetAttacker( ) ) + " | GetTriggerUnit( ) = " + Jass::GetHandleId( Jass::GetTriggerUnit( ) ) + "\n" );
			}
		);

		TriggerAPI::RegisterAnyPlayerUnitEvent
		(
			Jass::CreateTrigger( ),
			Jass::EVENT_PLAYER_UNIT_ATTACK_FINISHED,
			null,
			function( )
			{
				print( "[EVENT_PLAYER_UNIT_ATTACK_FINISHED]: GetAttacker( ) = " + Jass::GetHandleId( Jass::GetAttacker( ) ) + " | GetTriggerUnit( ) = " + Jass::GetHandleId( Jass::GetTriggerUnit( ) ) + "\n" );
			}
		);
    }
}