namespace Test::Inventory
{
    void SetMax( int rows, int columns, bool moveFrames )
    {
        SetFrameGridSize( GetOriginFrame( ORIGIN_FRAME_INVENTORY_BAR, 0 ), rows, columns );

        if ( !moveFrames ) { return; }

        for ( int32 row = 0; row < rows; row++ )
        {
            for ( int32 column = 0; column < columns; column++ )
            {
                auto frm = GetOriginFrame( ORIGIN_FRAME_ITEM_BUTTON, row * 6 + column );
                ClearFrameAllPoints( frm );
                SetFrameAbsolutePoint( frm, FRAMEPOINT_CENTER, .25f + row * .05f, .25f + column * .05f );
            }
        }
    }
}