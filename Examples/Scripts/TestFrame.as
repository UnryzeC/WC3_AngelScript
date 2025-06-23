#include "TriggerAPI.as"

namespace Test::Frame
{
    void ButtonBaseInit( framehandle btn, float x, float y )
    {
        ClearFrameAllPoints( btn );
        SetFrameAbsolutePoint( btn, FRAMEPOINT_CENTER, x, y );
        SetFrameSize( btn, .02f, .02f );

        RegisterFrameMouseButton( btn, MOUSE_BUTTON_TYPE_MIDDLE, true );
        RegisterFrameMouseButton( btn, MOUSE_BUTTON_TYPE_RIGHT, true );

        SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-Background.blp", 0, false );
        SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-BackgroundPressed.blp", 1, false );
        SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-BackgroundDisabled.blp", 2, false );
        SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-Check.blp", 5, false );
        SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-CheckDisabled.blp", 6, false );

        print( "GetFrameAlpha( btn ) = " + GetFrameAlpha( btn ) + "\n" );
        SetFrameAlpha( btn, 0xA0 );
        print( "GetFrameAlpha( btn ) = " + GetFrameAlpha( btn ) + "\n" );

        TriggerAPI::RegisterFrameEvent
        (
            CreateTrigger( ),
            btn,
            FRAMEEVENT_MOUSE_DOWN,
            null,
            function( )
            {
                print( "[FRAMEEVENT_MOUSE_DOWN]: " + GetTimeStamp( false, 0 ) + "\n" );
                print( "GetTriggerFrameEvent: " + GetHandleId( GetTriggerFrameEvent( ) ) + "\n" );
                print( "GetTriggerFrameMouseButton: " + GetHandleId( GetTriggerFrameMouseButton( ) ) + "\n" );

                print( "IsLMB: " + B2S( GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_LEFT ) + "\n" );
                print( "IsMMB: " + B2S( GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_MIDDLE ) + "\n" );
                print( "IsRMB: " + B2S( GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_RIGHT ) + "\n" );
            }
        );

        TriggerAPI::RegisterFrameEvent
        (
            CreateTrigger( ),
            btn,
            FRAMEEVENT_CONTROL_CLICK,
            null,
            function( )
            {
                print( "[FRAMEEVENT_CONTROL_CLICK]: " + GetTimeStamp( false, 0 ) + "\n" );
                print( "GetTriggerFrameEvent: " + GetHandleId( GetTriggerFrameEvent( ) ) + "\n" );
                print( "GetTriggerFrameMouseButton: " + GetHandleId( GetTriggerFrameMouseButton( ) ) + "\n" );

                print( "IsLMB: " + B2S( GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_LEFT ) + "\n" );
                print( "IsMMB: " + B2S( GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_MIDDLE ) + "\n" );
                print( "IsRMB: " + B2S( GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_RIGHT ) + "\n" );
            }
        );
    }

    void Backdrop( float x, float y )
    {
        framehandle gameUI = GetOriginFrame( ORIGIN_FRAME_GAME_UI, 0 );

        framehandle frm = CreateFrameByType( "BACKDROP", "", gameUI, "", 0 );

        SetFrameTexture( frm, "Textures\\Black32.blp", 0, false );

        ClearFrameAllPoints( frm );
        SetFrameSize( frm, 0.04f, 0.04f );
        SetFrameAbsolutePoint( frm, FRAMEPOINT_CENTER, x, y );

        SetFrameAlpha( frm, 100 );
    }

	void SimpleButton( float x, float y )
	{
        framehandle gameUI = GetOriginFrame( ORIGIN_FRAME_GAME_UI, 0 );

        ButtonBaseInit( CreateFrameByType( "SIMPLEBUTTON", "", gameUI, "", 0 ), .2f, .4f );
	}

	void Button( float x, float y )
	{
        framehandle gameUI = GetOriginFrame( ORIGIN_FRAME_GAME_UI, 0 );
        framehandle btn = CreateFrameByType( "BUTTON", "", gameUI, "", 0 );

        SetFrameControlFlag( btn, CONTROL_STYLE_AUTOTRACK, true );
        SetFrameControlFlag( btn, CONTROL_STYLE_HIGHLIGHT_ON_MOUSE_OVER, true );
        SetFrameControlFlag( btn, CONTROL_STYLE_DRAW, true );

        ButtonBaseInit( btn, x, y );
	}

    void Slider( )
    {
        framehandle gameUI = GetOriginFrame( ORIGIN_FRAME_GAME_UI, 0 );
        framehandle slider = CreateFrameByType( "SLIDER", "TestSlider", gameUI, "", 0 );

        ClearFrameAllPoints( slider );
        SetFrameAbsolutePoint( slider, FRAMEPOINT_CENTER, .3f, .4f );
        SetFrameSize( slider, 0.012f, 0.06f );

        SetFrameBackdropTexture( slider, 0, "UI\\Widgets\\Glues\\GlueScreen-Scrollbar-BackdropBackground.blp", true, true, "UI\\Widgets\\Glues\\GlueScreen-Scrollbar-BackdropBorder.blp", 0xFF, true );
        SetFrameStepSize( slider, 1.f );
        SetFrameMinMaxValues( slider, 1.f, 1.f );
        return;

        TriggerAPI::RegisterFrameEvent
        (
            CreateTrigger( ),
            slider,
            FRAMEEVENT_MOUSE_WHEEL,
            null,
            function( )
            {
                print( "[FRAMEEVENT_MOUSE_WHEEL]: " + GetTimeStamp( false, 0 ) + "\n" );
                print( "GetTriggerFrameEvent: " + GetHandleId( GetTriggerFrameEvent( ) ) + "\n" );
                print( "GetTriggerFrameReal: " + GetTriggerFrameReal( ) + "\n" );
            }
        );

        TriggerAPI::RegisterFrameEvent
        (
            CreateTrigger( ),
            slider,
            FRAMEEVENT_SLIDER_VALUE_CHANGED,
            null,
            function( )
            {
                print( "[FRAMEEVENT_SLIDER_VALUE_CHANGED]: " + GetTimeStamp( false, 0 ) + "\n" );
                print( "GetTriggerFrameEvent: " + GetHandleId( GetTriggerFrameEvent( ) ) + "\n" );
                print( "GetTriggerFrameReal: " + GetTriggerFrameReal( ) + "\n" );
            }
        );
    }

    void ListBox( )
    {
        framehandle gameUI = GetOriginFrame( ORIGIN_FRAME_GAME_UI, 0 );
        framehandle myListBox = CreateFrameByType( "LISTBOX", "", gameUI, "", 0 );

        ClearFrameAllPoints( myListBox );
        SetFrameRelativePoint( myListBox, FRAMEPOINT_CENTER, gameUI, FRAMEPOINT_CENTER, -.2f, .0f );
        SetFrameSize( myListBox, .12f, .15f );
        SetFrameItemsBorder( myListBox, .01f );
        SetFrameItemsHeight( myListBox, .02f );
        SetFrameControlFlag( myListBox, CONTROL_STYLE_DRAW, true );
        SetFrameBackdropTexture( myListBox, 1, "UI\\widgets\\BattleNet\\bnet-tooltip-background.blp", true, true, "UI\\widgets\\BattleNet\\bnet-tooltip-border.blp", BORDER_FLAG_ALL, false );
        SetFrameBorderSize( myListBox, 1, .0125f );
        SetFrameBackgroundSize( myListBox, 1, .256f );
        SetFrameBackgroundInsets( myListBox, 1, .005f, .005f, .005f, .005f );
        AddFrameSlider( myListBox );

        float itemHeight = GetFrameItemsHeight( myListBox );
        framehandle listScrollFrame = GetFrameChild( myListBox, 2 );

        for ( int32 i = 0; i < 15; i++ )
        {
            framehandle backDropFrame = CreateFrameByType( "BACKDROP", "", listScrollFrame, "", 0 );
            framehandle listItemFrame = AddFrameListItem( myListBox, "", backDropFrame );

            SetFrameBackdropTexture( backDropFrame, 1, "UI\\widgets\\BattleNet\\bnet-tooltip-background.blp", true, true, "UI\\widgets\\BattleNet\\bnet-tooltip-border.blp", BORDER_FLAG_ALL, false );
            SetFrameHeight( backDropFrame, .02f );
            SetFrameBorderSize( backDropFrame, 1, .0125f );
            SetFrameBackgroundSize( backDropFrame, 1, .128f );
            SetFrameBackgroundInsets( backDropFrame, 1, .005f, .005f, .005f, .005f );
            
            framehandle textFrame = CreateFrameByType( "TEXT", "", backDropFrame, "", 0 );
            ClearFrameAllPoints( textFrame );
            //SetFrameAbsolutePoint( textFrame, FRAMEPOINT_CENTER, .0f, .0f );
            SetFrameRelativePoint( textFrame, FRAMEPOINT_CENTER, backDropFrame, FRAMEPOINT_CENTER, .0f, .0f );
            SetFrameText( textFrame, IntToChar( 'A' + i ) );

            //SetFrameRelativePoint( textFrame, FRAMEPOINT_CENTER, listItemFrame, FRAMEPOINT_CENTER, .0, .0 );
            //framehandle listItemFrame = AddFrameListItem( myListBox, "New Item " + IntToChar( start + i ), null );
        }
    }
}