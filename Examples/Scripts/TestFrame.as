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
        framehandle slider = CreateFrameByType( "SCROLLBAR", "TestSlider", gameUI, "QuestMainListScrollBar", 0 );

        ClearFrameAllPoints( slider );
        SetFrameAbsolutePoint( slider, FRAMEPOINT_CENTER, .3f, .4f );
        SetFrameSize( slider, 0.012f, 0.06f );

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
}