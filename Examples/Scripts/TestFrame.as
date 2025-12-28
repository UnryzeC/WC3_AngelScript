#include "TriggerAPI.as"

namespace Test::Frame
{
    void ButtonBaseInit( framehandle btn, float x, float y )
    {
        Jass::ClearFrameAllPoints( btn );
        Jass::SetFrameAbsolutePoint( btn, Jass::FRAMEPOINT_CENTER, x, y );
        Jass::SetFrameSize( btn, .02f, .02f );

        Jass::RegisterFrameMouseButton( btn, Jass::MOUSE_BUTTON_TYPE_MIDDLE, true );
        Jass::RegisterFrameMouseButton( btn, Jass::MOUSE_BUTTON_TYPE_RIGHT, true );

        Jass::SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-Background.blp", 0, false );
        Jass::SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-BackgroundPressed.blp", 1, false );
        Jass::SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-BackgroundDisabled.blp", 2, false );
        Jass::SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-Check.blp", 5, false );
        Jass::SetFrameTexture( btn, "UI\\Widgets\\Glues\\GlueScreen-Checkbox-CheckDisabled.blp", 6, false );

        TriggerAPI::RegisterFrameEvent
        (
            Jass::CreateTrigger( ),
            btn,
            Jass::FRAMEEVENT_MOUSE_DOWN,
            null,
            function( )
            {
                print( "[FRAMEEVENT_MOUSE_DOWN]: " + Jass::GetTimeStamp( false, 0 ) + "\n" );
                print( "GetTriggerFrameEvent: " + Jass::GetHandleId( Jass::GetTriggerFrameEvent( ) ) + "\n" );
                print( "GetTriggerFrameMouseButton: " + Jass::GetHandleId( Jass::GetTriggerFrameMouseButton( ) ) + "\n" );

                print( "IsLMB: " + B2S( Jass::GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_LEFT ) + "\n" );
                print( "IsMMB: " + B2S( Jass::GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_MIDDLE ) + "\n" );
                print( "IsRMB: " + B2S( Jass::GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_RIGHT ) + "\n" );
            }
        );

        TriggerAPI::RegisterFrameEvent
        (
            Jass::CreateTrigger( ),
            btn,
            Jass::FRAMEEVENT_CONTROL_CLICK,
            null,
            function( )
            {
                print( "[FRAMEEVENT_CONTROL_CLICK]: " + Jass::GetTimeStamp( false, 0 ) + "\n" );
                print( "GetTriggerFrameEvent: " + Jass::GetHandleId( Jass::GetTriggerFrameEvent( ) ) + "\n" );
                print( "GetTriggerFrameMouseButton: " + Jass::GetHandleId( Jass::GetTriggerFrameMouseButton( ) ) + "\n" );

                print( "IsLMB: " + B2S( Jass::GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_LEFT ) + "\n" );
                print( "IsMMB: " + B2S( Jass::GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_MIDDLE ) + "\n" );
                print( "IsRMB: " + B2S( Jass::GetTriggerFrameMouseButton( ) == MOUSE_BUTTON_TYPE_RIGHT ) + "\n" );
            }
        );
    }

    void Backdrop( float x, float y )
    {
        framehandle gameUI = Jass::GetOriginFrame( Jass::ORIGIN_FRAME_GAME_UI, 0 );

        framehandle frm = Jass::CreateFrameByType( "BACKDROP", "", gameUI, "", 0 );

        Jass::SetFrameTexture( frm, "Textures\\Black32.blp", 0, false );

        Jass::ClearFrameAllPoints( frm );
        Jass::SetFrameSize( frm, 0.04f, 0.04f );
        Jass::SetFrameAbsolutePoint( frm, Jass::FRAMEPOINT_CENTER, x, y );

        Jass::SetFrameAlpha( frm, 100 );
    }

	framehandle SimpleButton( float x, float y )
	{
        framehandle gameUI = Jass::GetOriginFrame( Jass::ORIGIN_FRAME_GAME_UI, 0 );
        framehandle frm = Jass::CreateFrameByType( "SHRINKINGBUTTON", "", gameUI, "", 0 );

        ButtonBaseInit( frm, .2f, .4f );

        return frm;
	}

	void Button( float x, float y )
	{
        framehandle gameUI = Jass::GetOriginFrame( Jass::ORIGIN_FRAME_GAME_UI, 0 );
        framehandle btn = Jass::CreateFrameByType( "BUTTON", "", gameUI, "", 0 );

        Jass::SetFrameControlFlag( btn, Jass::CONTROL_STYLE_AUTOTRACK, true );
        Jass::SetFrameControlFlag( btn, Jass::CONTROL_STYLE_HIGHLIGHT_ON_MOUSE_OVER, true );
        Jass::SetFrameControlFlag( btn, Jass::CONTROL_STYLE_DRAW, true );

        ButtonBaseInit( btn, x, y );
	}

    void Slider( )
    {
        framehandle gameUI = Jass::GetOriginFrame( Jass::ORIGIN_FRAME_GAME_UI, 0 );
        framehandle slider = Jass::CreateFrameByType( "SLIDER", "TestSlider", gameUI, "", 0 );

        Jass::ClearFrameAllPoints( slider );
        Jass::SetFrameAbsolutePoint( slider, Jass::FRAMEPOINT_CENTER, .3f, .4f );
        Jass::SetFrameSize( slider, 0.012f, 0.06f );

        Jass::SetFrameBackdropTexture( slider, 0, "UI\\Widgets\\Glues\\GlueScreen-Scrollbar-BackdropBackground.blp", true, true, "UI\\Widgets\\Glues\\GlueScreen-Scrollbar-BackdropBorder.blp", 0xFF, true );
        Jass::SetFrameStepSize( slider, 1.f );
        Jass::SetFrameMinMaxValues( slider, 1.f, 1.f );

        return;

        TriggerAPI::RegisterFrameEvent
        (
            Jass::CreateTrigger( ),
            slider,
            Jass::FRAMEEVENT_MOUSE_WHEEL,
            null,
            function( )
            {
                print( "[FRAMEEVENT_MOUSE_WHEEL]: " + Jass::etTimeStamp( false, 0 ) + "\n" );
                print( "GetTriggerFrameEvent: " + Jass::GetHandleId( Jass::GetTriggerFrameEvent( ) ) + "\n" );
                print( "GetTriggerFrameReal: " + Jass::GetTriggerFrameReal( ) + "\n" );
            }
        );

        TriggerAPI::RegisterFrameEvent
        (
            Jass::CreateTrigger( ),
            slider,
            Jass::FRAMEEVENT_SLIDER_VALUE_CHANGED,
            null,
            function( )
            {
                print( "[FRAMEEVENT_SLIDER_VALUE_CHANGED]: " + Jass::GetTimeStamp( false, 0 ) + "\n" );
                print( "GetTriggerFrameEvent: " + Jass::GetHandleId( Jass::GetTriggerFrameEvent( ) ) + "\n" );
                print( "GetTriggerFrameReal: " + Jass::GetTriggerFrameReal( ) + "\n" );
            }
        );
    }

    void ListBox( )
    {
        framehandle gameUI = Jass::GetOriginFrame( Jass::ORIGIN_FRAME_GAME_UI, 0 );
        framehandle myListBox = Jass::CreateFrameByType( "LISTBOX", "", gameUI, "", 0 );

        Jass::ClearFrameAllPoints( myListBox );
        Jass::SetFrameRelativePoint( myListBox, Jass::FRAMEPOINT_CENTER, gameUI, Jass::FRAMEPOINT_CENTER, -.2f, .0f );
        Jass::SetFrameSize( myListBox, .12f, .15f );
        Jass::SetFrameItemsBorder( myListBox, .01f );
        Jass::SetFrameItemsHeight( myListBox, .02f );
        Jass::SetFrameControlFlag( myListBox, Jass::CONTROL_STYLE_DRAW, true );
        Jass::SetFrameBackdropTexture( myListBox, 1, "UI\\widgets\\BattleNet\\bnet-tooltip-background.blp", true, true, "UI\\widgets\\BattleNet\\bnet-tooltip-border.blp", Jass::BORDER_FLAG_ALL, false );
        Jass::SetFrameBorderSize( myListBox, 1, .0125f );
        Jass::SetFrameBackgroundSize( myListBox, 1, .256f );
        Jass::SetFrameBackgroundInsets( myListBox, 1, .005f, .005f, .005f, .005f );
        AddFrameSlider( myListBox );

        float itemHeight = Jass::GetFrameItemsHeight( myListBox );
        framehandle listScrollFrame = Jass::GetFrameChild( myListBox, 2 );

        for ( int32 i = 0; i < 15; i++ )
        {
            framehandle backDropFrame = Jass::CreateFrameByType( "BACKDROP", "", listScrollFrame, "", 0 );
            framehandle listItemFrame = Jass::AddFrameListItem( myListBox, "", backDropFrame );

            Jass::SetFrameBackdropTexture( backDropFrame, 1, "UI\\widgets\\BattleNet\\bnet-tooltip-background.blp", true, true, "UI\\widgets\\BattleNet\\bnet-tooltip-border.blp", Jass::BORDER_FLAG_ALL, false );
            Jass::SetFrameHeight( backDropFrame, .02f );
            Jass::SetFrameBorderSize( backDropFrame, 1, .0125f );
            Jass::SetFrameBackgroundSize( backDropFrame, 1, .128f );
            Jass::SetFrameBackgroundInsets( backDropFrame, 1, .005f, .005f, .005f, .005f );
            
            framehandle textFrame = Jass::CreateFrameByType( "TEXT", "", backDropFrame, "", 0 );
            Jass::ClearFrameAllPoints( textFrame );
            //Jass::SetFrameAbsolutePoint( textFrame, Jass::FRAMEPOINT_CENTER, .0f, .0f );
            Jass::SetFrameRelativePoint( textFrame, Jass::FRAMEPOINT_CENTER, backDropFrame, Jass::FRAMEPOINT_CENTER, .0f, .0f );
            Jass::SetFrameText( textFrame, Jass::IntToChar( 'A' + i ) );

            //Jass::SetFrameRelativePoint( textFrame, Jass::FRAMEPOINT_CENTER, listItemFrame, Jass::FRAMEPOINT_CENTER, .0, .0 );
            //framehandle listItemFrame = Jass::AddFrameListItem( myListBox, "New Item " + Jass::IntToChar( start + i ), null );
        }
    }
}