namespace TriggerAPI
{
    void AddConditionAndAction( trigger whichTrigger, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        if ( !( cond is null ) )
        {
            TriggerAddCondition( whichTrigger, Condition( cond ) );
        }

        if ( !( act is null ) )
        {
            TriggerAddAction( whichTrigger, act );
        }
    }

    void RegisterPlayerSyncEvent( trigger whichTrigger, string prefix, bool fromServer, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        for ( int i = 0; i < GetBJMaxPlayers( ); i++ )
        {
            TriggerRegisterPlayerSyncEvent( whichTrigger, Player( i ), prefix, fromServer );
        }

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterPlayerHashtableSyncEvent( trigger whichTrigger, hashtable whichHashtable, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        for ( int i = 0; i < GetBJMaxPlayers( ); i++ )
        {
            TriggerRegisterPlayerHashtableDataSyncEvent( whichTrigger, Player( i ), whichHashtable );
        }

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterPlayerEvent( trigger whichTrigger, playerevent whichEvent, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        for ( int i = 0; i < GetBJMaxPlayers( ); i++ )
        {
            TriggerRegisterPlayerEvent( whichTrigger, Player( i ), whichEvent );
        }

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterPlayerUnitEvent( trigger whichTrigger, playerunitevent whichEvent, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        for ( int i = 0; i < GetBJMaxPlayers( ); i++ )
        {
            TriggerRegisterPlayerUnitEvent( whichTrigger, Player( i ), whichEvent, nil );
        }

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterUnitEvent( trigger whichTrigger, unitevent whichEvent, unit whichUnit, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        TriggerRegisterUnitEvent( whichTrigger, whichUnit, whichEvent );

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterFrameEvent( trigger whichTrigger, framehandle whichFrame, frameeventtype whichEvent, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        TriggerRegisterFrameEvent( whichTrigger, whichFrame, whichEvent );

        AddConditionAndAction( whichTrigger, cond, act );
    }
}