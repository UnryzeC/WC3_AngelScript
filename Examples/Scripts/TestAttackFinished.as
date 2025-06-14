#include "TriggerAPI.as"

namespace Test::AttackFinished
{
    void Init( )
    {
		unit u = CreateUnit( Player( 0 ), 'Hpal', .0f, .0f, .0f );

		TriggerAPI::RegisterAnyUnitEvent
		(
			CreateTrigger( ),
			EVENT_UNIT_ATTACK_FINISHED,
			u,
			null,
			function( )
			{
				print( "[EVENT_UNIT_ATTACK_FINISHED]: GetAttacker( ) = " + GetHandleId( GetAttacker( ) ) + " | GetTriggerUnit( ) = " + GetHandleId( GetTriggerUnit( ) ) + "\n" );
			}
		);

		u = CreateUnit( Player( 0 ), 'Hamg', .0f, .0f, .0f );

		TriggerAPI::RegisterAnyUnitEvent
		(
			CreateTrigger( ),
			EVENT_UNIT_ATTACK_FINISHED,
			u,
			null,
			function( )
			{
				print( "[EVENT_UNIT_ATTACK_FINISHED]: GetAttacker( ) = " + GetHandleId( GetAttacker( ) ) + " | GetTriggerUnit( ) = " + GetHandleId( GetTriggerUnit( ) ) + "\n" );
			}
		);

		TriggerAPI::RegisterAnyPlayerUnitEvent
		(
			CreateTrigger( ),
			EVENT_PLAYER_UNIT_ATTACK_FINISHED,
			null,
			function( )
			{
				print( "[EVENT_PLAYER_UNIT_ATTACK_FINISHED]: GetAttacker( ) = " + GetHandleId( GetAttacker( ) ) + " | GetTriggerUnit( ) = " + GetHandleId( GetTriggerUnit( ) ) + "\n" );
			}
		);
    }
}