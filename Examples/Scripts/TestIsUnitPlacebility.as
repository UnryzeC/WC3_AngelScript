namespace Test::Unit::Placebility
{
    bool IsPlaceableAtById( uint uid, player whichPlayer, float x, float y )
    {
        return ::IsUnitPlaceableAtById( uid, whichPlayer, x, y, 0, 0, 0, 0, true, false, false, false, false, false );
    }
}