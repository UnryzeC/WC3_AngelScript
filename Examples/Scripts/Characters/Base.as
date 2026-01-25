#include "..\\API\\General.as"
#include "..\\API\\Spell.as"
#include "..\\API\\Trigger.as"

class Character
{
    private uint32 _unit_type_id;
    private uint32 _item_typeId;
    private uint32 _buff_type_id;
    private string _icon_path;
    private string _model_path;
    private float _scale;

    Character( )
    {
        
    }

    Character( uint32 unitTypeId, uint32 itemTypeId, uint32 buffTypeId, string iconPath, string modelPath, float scale )
    {
        init( unitTypeId, itemTypeId, buffTypeId, iconPath, modelPath, scale );
    }

    void init( uint32 unitTypeId, uint32 itemTypeId, uint32 buffTypeId, string iconPath, string modelPath, float scale )
    {
        _unit_type_id = unitTypeId;
        _item_typeId = itemTypeId;
        _buff_type_id = buffTypeId;
        _icon_path = iconPath;
        _model_path = modelPath;
        _scale = scale;
    }

    uint32 UNIT_TYPE_ID
    {
        get const { return _unit_type_id; }
    }

    uint32 ITEM_TYPE_ID
    {
        get const { return _item_typeId; }
    }

    uint32 BUFF_TYPE_ID
    {
        get const { return _buff_type_id; }
    }

    string ICON_PATH
    {
        get const { return _icon_path; }
    }

    string MODEL_PATH
    {
        get const { return _model_path; }
    }

    float SCALE
    {
        get const { return _scale; }
    }

    void InitData( hashtable ht, uint32 index )
    {
        PickSystem::InitHeroData( ht, index, UNIT_TYPE_ID, ITEM_TYPE_ID, BUFF_TYPE_ID, ICON_PATH, MODEL_PATH, SCALE );
    }

    void AddData( hashtable ht )
    {
        PickSystem::AddHeroData( ht, UNIT_TYPE_ID, ITEM_TYPE_ID, BUFF_TYPE_ID, ICON_PATH, MODEL_PATH, SCALE );
    }

    // void D( ) { }
    // void Q( ) { }
    // void W( ) { }
    // void E( ) { }
    // void R( ) { }
    // void T( ) { }

    // void Release( unit u ) { }
    // void Init( unit u, hashtable whichHashTable, hashtable whichSoundTable, uint32 loadFlags = ( 1 | 2 ) ) { }
}