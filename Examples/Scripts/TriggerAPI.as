namespace TriggerAPI
{
    void AddConditionAndAction( trigger whichTrigger, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        if ( !( cond is null ) )
        {
            Jass::TriggerAddCondition( whichTrigger, Jass::Condition( cond ) );
        }

        if ( !( act is null ) )
        {
            Jass::TriggerAddAction( whichTrigger, act );
        }
    }

    void RegisterPlayerSyncEvent( trigger whichTrigger, string prefix, bool fromServer, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        for ( int i = 0; i < Jass::GetBJMaxPlayers( ); i++ )
        {
            Jass::TriggerRegisterPlayerSyncEvent( whichTrigger, Jass::Player( i ), prefix, fromServer );
        }

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterPlayerHashtableSyncEvent( trigger whichTrigger, hashtable whichHashtable, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        for ( int i = 0; i < Jass::GetBJMaxPlayers( ); i++ )
        {
            Jass::TriggerRegisterPlayerHashtableDataSyncEvent( whichTrigger, Jass::Player( i ), whichHashtable );
        }

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterPlayerEvent( trigger whichTrigger, playerevent whichEvent, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        for ( int i = 0; i < Jass::GetBJMaxPlayers( ); i++ )
        {
            Jass::TriggerRegisterPlayerEvent( whichTrigger, Jass::Player( i ), whichEvent );
        }

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterPlayerUnitEvent( trigger whichTrigger, playerunitevent whichEvent, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        for ( int i = 0; i < Jass::GetBJMaxPlayers( ); i++ )
        {
            Jass::TriggerRegisterPlayerUnitEvent( whichTrigger, Jass::Player( i ), whichEvent, nil );
        }

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterUnitEvent( trigger whichTrigger, unitevent whichEvent, unit whichUnit, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        Jass::TriggerRegisterUnitEvent( whichTrigger, whichUnit, whichEvent );

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterChatEvent( trigger whichTrigger, string text, bool caseSensetive = false, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        for ( int i = 0; i < Jass::GetBJMaxPlayers( ); i++ )
        {
            Jass::TriggerRegisterPlayerChatEvent( whichTrigger, Jass::Player( i ), text, caseSensetive );
        }

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterGameEvent( trigger whichTrigger, gameevent whichEvent, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        Jass::TriggerRegisterGameEvent( whichTrigger, whichEvent );

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterDialogEvent( trigger whichTrigger, dialog whichDialog, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        Jass::TriggerRegisterDialogEvent( whichTrigger, whichDialog );

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterTimerEvent( trigger whichTrigger, float timeOut, bool isPeriodic, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        Jass::TriggerRegisterTimerEvent( whichTrigger, timeOut, isPeriodic );

        AddConditionAndAction( whichTrigger, cond, act );
    }

    void RegisterFrameEvent( trigger whichTrigger, framehandle whichFrame, frameeventtype whichEvent, BoolexprFunc@ cond = null, CallbackFunc@ act = null )
    {
        if ( whichTrigger == nil ) { return; }

        Jass::TriggerRegisterFrameEvent( whichTrigger, whichFrame, whichEvent );

        AddConditionAndAction( whichTrigger, cond, act );
    }
}