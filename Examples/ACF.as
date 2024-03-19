//#include "Scripts\\Blizzard.as"

bool SameHeroBoolean = false;
dialog ModeSelectionDialog = DialogCreate();
dialog KillSelectionDialog = DialogCreate();
group GetUnitDamagedGroup = CreateGroup();
group GroupEnum = CreateGroup();
hashtable GameHashTable = InitHashtable();
int iCaster = 100;
int iTarget = 101;
int LeftBosses = 1;
int RightBosses = 1;
int KillLimitInteger1 = 0;
int TotalPlayers = 0;
const int TotalHeroes = 11;
int HeroesSelected = 0;
float CameraReal = 2000.f;
float MapMinX = - 6100.f + GetCameraMargin(CAMERA_MARGIN_LEFT);
float MapMaxX = 6100.f - GetCameraMargin(CAMERA_MARGIN_RIGHT);
float MapMinY = - 4400.f + GetCameraMargin(CAMERA_MARGIN_BOTTOM);
float MapMaxY = 3350.f - GetCameraMargin(CAMERA_MARGIN_TOP);
timer CreepUpgradeTimer1 = CreateTimer();
timer CreepSpawnerTimer1 = CreateTimer();
timer KillSelectionTimer = CreateTimer();
rect worldBounds;
multiboarditem MBItem;
multiboard MainMultiboard;
trigger ResetCDTrigger;
timerdialog ModeSelectionTD;
unit MainBossUnit1;
unit GlobalUnit;
unit SysUnit;
unit SelectionUnit;
effect Ef_Selection;
effect Ef_SelectionBack;
item SysItem;
item It_LastRemoved;
array<button> SameHeroModeButtonArray( 12 );
array<bool> TeamOneSelected( PLAYER_NEUTRAL_AGGRESSIVE );
array<bool> TeamTwoSelected( PLAYER_NEUTRAL_AGGRESSIVE );
array<bool> HealthDisplayBooleanArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<bool> ESCLocationSaveBooleanArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<bool> HeroSelectedArray1( PLAYER_NEUTRAL_AGGRESSIVE );
array<effect> EF_SelectionHeroModelArray;
array<effect> EF_SelectionIconArray;
bool B_IsCreepSpawn = true;
int I_WinningTeam = -1;
array<int> TeamPlayers( 2 );
array<int> TeamKills( 2 );
array<int> TeamDeaths( 2 );
array<int> DyingUnitIntegerArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<int> KillingUnitIntegerArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<int> BossesKilledIntegerArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<int> TeleportationIDIntegerArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<int> NotificationEnabledIntArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<int> MBArr1( 12 );
array<int> BossIDArray( 9 );
array<int> HeroIDArray;
array<int> HeroItemIDArray;
group GR_LeftSide;
group GR_RightSide;
array<location> TeleportationLocationArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<player> GlobalPlayerArray1( PLAYER_NEUTRAL_AGGRESSIVE );
array<float> SetScaleArr;
array<rect> CircleRectArr(6);
array<rect> TeamStartRectArr(2);
array<sound> GeneralSounds;
array<sound> NanayaShikiSounds;
array<sound> ToonoShikiSounds;
array<sound> RyougiShikiSounds;
array<sound> SaberNeroSounds;
array<sound> KuchikiByakuyaSounds;
array<sound> AkameSounds;
array<sound> SaberAlterSounds;
array<sound> ScathachSounds;
array<sound> AkainuSounds;
array<sound> ReinforceSounds;
array<sound> ArcueidSounds;
array<string> PlayerColorStringArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<string> PlayerColoredNameArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<string> PlayerNameArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<string> HeroModelArray;
array<string> HeroIconArray;
trigger TR_SelectionMode;
array<trigger> GameTrigArr( 33 );
array<unit> DummyUnitDamageArr( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> U_SelectionSelArr( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> U_SelectionDumArr( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> HeroUnitArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> U_SelectionHeroDummyArr( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> KawarimiTriggerUnitArray( PLAYER_NEUTRAL_AGGRESSIVE );
array<unit> MUnitArray( PLAYER_NEUTRAL_AGGRESSIVE );

void TriggerRegisterAnyUnitEventRW( trigger t, playerunitevent whichEvent )
{
    for ( int i = 0; i < GetBJMaxPlayerSlots( ); i++ )
    {
        TriggerRegisterPlayerUnitEvent( t, Player( i ), whichEvent, nil );
    }
}

void TriggerRegisterAnyPlayerEventRW( trigger t, playerevent whichEvent )
{
    for ( int i = 0; i < GetBJMaxPlayerSlots( ); i++ )
    {
        TriggerRegisterPlayerEvent( t, Player( i ), whichEvent );
    }
}

void TriggerRegisterPlayerChatEventRW( trigger t, string text, bool caseSensitive )
{
    for ( int i = 0; i < GetBJMaxPlayerSlots( ); i++ )
    {
        TriggerRegisterPlayerChatEvent( t, Player( i ), text, caseSensitive );
    }
}

float AngleBetweenPointsRW(location locA, location locB)
{
    return 180.0f / 3.14159f * Atan2(GetLocationY(locB) - GetLocationY(locA), GetLocationX(locB) - GetLocationX(locA));
}
float AngleBetweenUnits(unit CasterUnit, unit TargetUnit)
{
    return 180.0f / 3.14159f * Atan2(GetUnitY(TargetUnit) - GetUnitY(CasterUnit), GetUnitX(TargetUnit) - GetUnitX(CasterUnit));
}

float DistanceBetweenPointsRW(location locA, location locB)
{
    float dx = GetLocationX(locB) - GetLocationX(locA);
    float dy = GetLocationY(locB) - GetLocationY(locA);
    return SquareRoot(dx * dx + dy * dy);
}

float RMinACF( float a, float b )
{
    if (a < b)
    {
        return a;
    }

    return b;
}

float RMaxACF( float a, float b )
{
    if (a < b)
    {
        return b;
    }

    return a;
}

int SwapAmount(int LocInt1, bool LocBool)
{
    if (LocBool)
    {
        LocInt1 = LocInt1 *  - 1;
    }
    return LocInt1;
}

float GetUnitStatePercentRW(unit whichUnit, unitstate whichState, unitstate whichMaxState)
{
    float value = GetUnitState(whichUnit, whichState);
    float maxValue = GetUnitState(whichUnit, whichMaxState);
    if ( whichUnit == nil || maxValue == 0)
    {
        return .0f;
    }
    return value / maxValue * 100.0f;
}

void CreateNUnitsAtLocACF(int count, int unitId, player whichPlayer, location loc, float face)
{
    while (true) {
        if (count == 0) break;
        GlobalUnit = CreateUnit(whichPlayer, unitId, GetLocationX(loc), GetLocationY(loc), face);
        count = count - 1;
    }
}

int CountUnitInGroupOfPlayer( player p, int id )
{
    int count = 0;
    group g = CreateGroup( );
    GroupEnumUnitsOfPlayer( g, p, nil );

    for ( int i = 0; i < GroupGetCount( g ); i++ )
    {
        unit u = GroupGetUnitByIndex( g, i );

        if ( IsUnitAlive( u ) && GetUnitTypeId( u ) == id )
        {
            count++;
        }
    }
    DestroyGroup( g );
    return count;
}

void CheckForStun()
{
    unit LocUnit = LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 0);
    int LocData = GetUnitUserData(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 0));

    if (LocData > 0)
    {
        SetUnitUserData(LocUnit, LocData - 1);
    }
    else {
        UnitRemoveAbility(LocUnit, FourCC("B00A"));
        PauseTimer(GetExpiredTimer());
        FlushChildHashtable(GameHashTable, GetHandleId(GetExpiredTimer()));
        DestroyTimer(GetExpiredTimer());
    }
}
void StunUnitACF(unit LocUnit, float LocReal)
{
    timer tmr = CreateTimer();
    int hid = GetHandleId(tmr);
    SetUnitUserData(LocUnit, R2I(LocReal * 100 + GetUnitUserData(LocUnit)));
    if (GetUnitAbilityLevel(LocUnit, FourCC("B00A")) == 0){
        GlobalUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC("u00C"), GetUnitX(LocUnit), GetUnitY(LocUnit), 0);
        UnitShareVision(LocUnit, Player(PLAYER_NEUTRAL_PASSIVE), true);
        IssueTargetOrder(GlobalUnit, "firebolt", LocUnit);
        SaveUnitHandle(GameHashTable, hid, 0, LocUnit);
        TimerStart(tmr, 0.01f, true, @CheckForStun);
    }
    else {
        DestroyTimer(tmr);
    }
}

void SetUnitScaleAndTime(unit LocUnit, float LocSize, float LocTime)
{
    SetUnitScale(LocUnit, LocSize, LocSize, LocSize);
    SetUnitTimeScale(LocUnit, LocTime);
}

int GetInventoryIndexOfItemTypeRW(unit whichUnit, int itemId)
{
    int index = 0;
    while (true) {
        SysItem = UnitItemInSlot(whichUnit, index);
        if (SysItem != nil && GetItemTypeId(SysItem) == itemId){
            return index + 1;
        }
        index = index + 1;
        if (index >= 6 ) break;
    }
    return 0;
}

item GetItemOfTypeFromUnitRW(unit whichUnit, int itemId)
{
    int index = GetInventoryIndexOfItemTypeRW(whichUnit, itemId);

    if (index == 0)
    {
        return nil;
    }

    return UnitItemInSlot(whichUnit, index - 1);
}

int CountItemsOfTypeFromUnitRW(unit whichUnit, int whatItemtype)
{
    int index = 0;
    int count = 0;
    while (true) {
        if (index >= 6 ) break;
        if (GetItemTypeId(UnitItemInSlot(whichUnit, index)) == whatItemtype){
            count = count + 1;
        }
        index = index + 1;
    }
    return count;
}

bool AvoidLeak()
{
    return true;
}

unit SelectedUnitACF(player LocPlayer)
{
    group g = CreateGroup();
    GroupEnumUnitsSelected(g, LocPlayer, Condition(@AvoidLeak));
    GlobalUnit = FirstOfGroup(g);
    DestroyGroup(g);
    return GlobalUnit;
}

bool UnitHasItemById(unit LocaUnitId, int LocalTargetItemId)
{
int index = 0;
    if (LocalTargetItemId != 0){
        while (true) {
            if (GetItemTypeId(UnitItemInSlot(LocaUnitId, index)) == LocalTargetItemId){
                return true;
            }
            index = index + 1;
            if (index >= 6) break;
        }
    }
    return false;
}

bool HasPersonalItemACF(unit LocUnit)
{
int index = 1;
    while (true) {
        if (index > TotalHeroes) break;
        if (UnitHasItemById(LocUnit, HeroItemIDArray[index])){
            return true;
        }
        index = index + 1;
    }
    return false;
}

void GameCreateVariables()
{
    int i = 0;
    while (true) {
        if (i > 7) break;
        TeleportationLocationArray[i] = Location(0.f, - 500.f);
        HeroSelectedArray1[i] = false;
        NotificationEnabledIntArray[i] = 1;
        DummyUnitDamageArr[i] = CreateUnit(Player(i), FourCC("h005"), 8000, 8000, 270);
        i = i + 1;
    }
}
void CameraSetHeight( )
{
    SetCameraField( CAMERA_FIELD_TARGET_DISTANCE, CameraReal, 0.f );

    if ( not HeroSelectedArray1[ GetPlayerId( GetLocalPlayer( ) ) ] )
    {
        PanCameraToTimed( -1800.f, 5800.f, .0f );
        SetCameraField( CAMERA_FIELD_ANGLE_OF_ATTACK, 270., 0.f );
    }
}

void CameraAdjustionAction()
{
    float InputAmount = S2R(SubString(GetEventPlayerChatString(), 8, 11));

    if (GetLocalPlayer() == GetTriggerPlayer())
    {
        if (InputAmount >= 50.f && InputAmount <= 250.f )
        {
            CameraReal = 20.f * InputAmount;
        }
    }
}

void GameCameraSystemInit()
{
    trigger t = CreateTrigger();
    TimerStart( CreateTimer(), .01f, true, @CameraSetHeight );
    TriggerRegisterPlayerChatEventRW( t, "-camera ", false);
    TriggerAddAction( t, @CameraAdjustionAction);
}

bool DamageTargetACF(unit LocTrigUnit, unit LocTargUnit, float LocDamage)
{
    if (HasPersonalItemACF(LocTrigUnit))
    {
        LocDamage = LocDamage * 1.15f;
    }
    return UnitDamageTarget(LocTrigUnit, LocTargUnit, LocDamage, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
}

void DialogShow(dialog DialogName, bool Show)
{
    int i = 0;
    while (true) {
        if (i > 7) break;
        DialogDisplay(Player(i), DialogName, Show);
        i = i + 1;
    }
}

bool CombineItemsCondition()
{
    return GetItemCharges(GetManipulatedItem()) > 0;
}

void CombineItemsAction()
{
int ItemLoop = 0;
int Charges = 0;
int Maximum = 2;
    while (true) {
        if (ItemLoop > 6) break;
        if (GetItemTypeId(GetManipulatedItem()) == GetItemTypeId(UnitItemInSlot(GetManipulatingUnit(), ItemLoop - 1))){
            if (GetItemCharges(UnitItemInSlot(GetManipulatingUnit(), ItemLoop - 1)) + GetItemCharges(GetManipulatedItem()) <= Maximum){
                if (UnitItemInSlot(GetManipulatingUnit(), ItemLoop - 1) != GetManipulatedItem()){
                    Charges = GetItemCharges(UnitItemInSlot(GetManipulatingUnit(), ItemLoop - 1)) + GetItemCharges(GetManipulatedItem());
                    SetItemCharges(UnitItemInSlot(GetManipulatingUnit(), ItemLoop - 1), Charges);
                    RemoveItem(GetManipulatedItem());
                    ItemLoop = 7;
                }
            }
        }
        ItemLoop = ItemLoop + 1;
    }
}

texttag TextTagCreate(string word, float x, float y, float z, float size, int red, int green, int blue, int alpha)
{
    texttag txtTag = CreateTextTag();
    SetTextTagText( txtTag, word, size * 0.023f / 10.f);
    SetTextTagPos( txtTag, x, y, z);
    SetTextTagColor( txtTag, red, green, blue, alpha);
    return txtTag;
}

void ItemCombinationsCommandAction()
{
    DisplayTimedTextToPlayer(GetTriggerPlayer(), 0.f, 0.f, 10.f, "*Mithril Shield+Champion Belt = |c0000ff00Gold Shield|r
	*Hero's Axe + Ninja's Slipper = |c0000ff00Minotaur's Axe|r
	*Speed Boots + Ninja's Slipper = |c0000ff00Blink Boots|r
	*Red Stone + Ninja's Slipper + Champion Belt = |c0000ff00Gold Medal|r
	*Red Stone + Red Stone = |c0000ff00Crystal|r
	*Mithril Shield + Hero's Axe = |c0000ff00Sword of King|r
	*Red Tablet + Stealth Cap = |c0000ff00Stealth Scroll|r");
}

void CommandsNotificationAction()
{
    UnitResetCooldown(MainBossUnit1);

    int id = GetPlayerId( GetLocalPlayer( ) );

    if ( NotificationEnabledIntArray[id] == 1 )
    {
        DisplayTextToPlayer( GetLocalPlayer( ), 0.f, 0.f, "|c0080ff00-commands|r: |c0000ffffdisplays available in-game commands|r.
        |c0080ff00-TestCommands|r: |c0000ffffdisplays available in-game test commands|r.
        |c0080ff00-noff/-non|r: |c0000ffffdisables/enables -commands notification|r.");
    }
}

void DisplayCommandsAction()
{
    DisplayTextToPlayer(GetTriggerPlayer(), 0.f, 0.f, "|c0080ff00-TestCommands|r: |c0000ffffDisplays available test commands|r.
	|c0080ff00-camera 50~250|r: |c0000ffffMap camera distance change|r.
	|c0080ff00-combinations|r: |c0000ffffA list of item combinations|r.
	|c0080ff00-T|r: |c0000ffffTeleports you to the saved location (Requires 8 bosses killed)|r.
	|c0080ff00-1|r: |c0000ffffWrites exact amount of hp of target if his hp exceeds 10000|r.
	|c0080ff00-2|r: |c0000ffffPush ESC button 2 times to save your current position|r.
	|c0080ff00-3|r: |c0000ffffShows the location where you saved|r.
	|c0080ff00-4|r: |c0000ffffShows the location where you and your teammates saved|r.
	|c0080ff00-clear|r: |c0000ffffClears text messages from chat|r.
	|c0080ff00-Contacts|r: |c0000ffffDisplays Map Maker and Contact information|r.");
}

void TestCommandsDisplayAction()
{
    DisplayTextToPlayer(GetTriggerPlayer(), 0.f, 0.f, "|c0080ff00-nc|r: |c0000ffffRemoves cooldowns on abilities|r.
	|c0080ff00-heroes|r: |c0000ffffGrants you all heroes available in the game|r.
	|c0080ff00-gold|r: |c0000ffffGrants you 100000000 gold when used|r.
	|cFFFFCC00-level XX|r: |c0000ffffSets the level of selected hero to XX|r.
	|c0080ff00-NoCreep|r: |c0000ffffStops mobs spawning on mid|r.
	|c0080ff00-SpawnTestUnit|r: |c0000ffffSpawns a unit, that has a lot of hp|r.");
}

void MapInfoAndContactsActions()
{
    DisplayTextToPlayer(GetTriggerPlayer(), 0.f, 0.f, "|cFFFFCC00Map Maker and Contact Info:|r Unryze (https://vk.com/acfwc3 / https://vendev.info/)

	|cFFFFCC00Helpers:|r Andutrache, Nelu_o, Maou, Sanyabane and Saasura");
}

void PlaySoundWithVolumeACF(sound soundHandle, float volumePercent, float startingOffset)
{
    if ( soundHandle == nil ) { return; }

    int result = MathIntegerClamp( R2I( volumePercent * I2R( 127 ) * .01f ), 0, 127 );

    SetSoundVolume( soundHandle, result);
    StartSound( soundHandle );
    SetSoundPlayPosition( soundHandle, R2I(startingOffset * 1000));
}

void MapStartData()
{
    int i = 0;
    PanCameraToTimed( -1800.f, 5900.f, .0f );
    PlayerColorStringArray[0] = "|c00FF0000";
    PlayerColorStringArray[1] = "|c000000FF";
    PlayerColorStringArray[2] = "|c0021E7B6";
    PlayerColorStringArray[3] = "|c005E0093";
    PlayerColorStringArray[4] = "|c00FFFF00";
    PlayerColorStringArray[5] = "|c00FF8000";
    PlayerColorStringArray[6] = "|c0000B400";
    PlayerColorStringArray[7] = "|c00FF64FF";
    PlayerColorStringArray[10] = "|c00FF0000";
    PlayerColorStringArray[11] = "|c000000FF";
    while (true)
    {
        if (i > 7) break;
        player p = Player(i);
    
        SetPlayerAbilityAvailable( p, FourCC("A03Q"), false );
        SetPlayerAbilityAvailable( p, FourCC("A047"), false );
        SetPlayerAbilityAvailable( p, FourCC("A02N"), false );
        SetPlayerAbilityAvailable( p, FourCC("A02O"), false );
        SetPlayerAbilityAvailable( p, FourCC("A02Q"), false );
        SetPlayerAbilityAvailable( p, FourCC("A02R"), false );
        SetPlayerAbilityAvailable( p, FourCC("A02V"), false );
        SetPlayerAbilityAvailable( p, FourCC("A02W"), false );
        SetPlayerAbilityAvailable( p, FourCC("A02Y"), false );
        SetPlayerAbilityAvailable( p, FourCC("A02Z"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03M"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03N"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03O"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03P"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03D"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03G"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03H"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03I"), false );
        SetPlayerAbilityAvailable( p, FourCC("A039"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03A"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03B"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03C"), false );
        SetPlayerAbilityAvailable( p, FourCC("A04H"), false );
        SetPlayerAbilityAvailable( p, FourCC("A04I"), false );
        SetPlayerAbilityAvailable( p, FourCC("A04J"), false );
        SetPlayerAbilityAvailable( p, FourCC("A04K"), false );
        SetPlayerAbilityAvailable( p, FourCC("A032"), false );
        SetPlayerAbilityAvailable( p, FourCC("A034"), false );
        SetPlayerAbilityAvailable( p, FourCC("A036"), false );
        SetPlayerAbilityAvailable( p, FourCC("A037"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03S"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03U"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03V"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03W"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03X"), false );
        SetPlayerAbilityAvailable( p, FourCC("A049"), false );
        SetPlayerAbilityAvailable( p, FourCC("A04C"), false );
        SetPlayerAbilityAvailable( p, FourCC("A04B"), false );
        SetPlayerAbilityAvailable( p, FourCC("A04D"), false );
        SetPlayerAbilityAvailable( p, FourCC("A04E"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03Y"), false );
        SetPlayerAbilityAvailable( p, FourCC("A03Z"), false );
        SetPlayerAbilityAvailable( p, FourCC("A040"), false );
        SetPlayerAbilityAvailable( p, FourCC("A042"), false );
        SetPlayerAbilityAvailable( p, FourCC("A043"), false );
        SetPlayerAbilityAvailable( p, FourCC("A044"), false );
        SetPlayerAbilityAvailable( p, FourCC("A04N"), false );
        SetPlayerAbilityAvailable( p, FourCC("A052"), false );
        SetPlayerAbilityAvailable( p, FourCC("A01Y"), false );
        SetPlayerAbilityAvailable( p, FourCC("A026"), false );
        SetPlayerAbilityAvailable( p, FourCC("A027"), false );
        SetPlayerAbilityAvailable( p, FourCC("A02A"), false );
        SetPlayerState( p, PLAYER_STATE_GIVES_BOUNTY, 1);
        i++;
    }
    SetPlayerHandicapXP(GetOwningPlayer(MainBossUnit1), 3);
}
void AISetItem(){
    It_LastRemoved = GetEnumItem();
}
bool AIItemFilter(){
    return IsItemVisible(GetFilterItem()) && GetWidgetLife(GetFilterItem()) > 0;
}
bool AIHasEmptyInventorySlot(unit u){
    return UnitItemInSlot(u, 0) == nil || UnitItemInSlot(u, 1) == nil || UnitItemInSlot(u, 2) == nil || UnitItemInSlot(u, 3) == nil || UnitItemInSlot(u, 4) == nil || UnitItemInSlot(u, 5) == nil;
}
bool AIFilterEnemyConditions(){
    return GetUnitCurrentLife(GetFilterUnit()) > 0 && IsPlayerEnemy(GetOwningPlayer(GetFilterUnit()), GetOwningPlayer(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 0)));
}
void AIHeroMoveLoop(){
    IssuePointOrder(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 0), "attack", GetRandomReal( - 1900.f, 1900.f), GetRandomReal( - 110.f, 180.f));
}
void AILoop()
{
    if ( true )
    {
        unit source = LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 0);
        unit uTemp;
        unit utarg;
        
        GroupClear( GroupEnum );
        GroupEnumUnitsInRange( GroupEnum, GetUnitX(source), GetUnitY(source), 600.f, Condition(@AIFilterEnemyConditions));

        for( int i = 0; i < GroupGetCount( GroupEnum ); i++ )
        {
            uTemp = GroupGetUnitByIndex( GroupEnum, i ); if ( uTemp == nil ) { break; }

            if ( IsUnitType( uTemp, UNIT_TYPE_HERO ) ) { utarg = uTemp; break; }
        }

        if ( utarg == nil )
        {
            utarg = FirstOfGroup( GroupEnum );
        }

        if ( utarg == nil )
        {
            It_LastRemoved = nil;
            EnumItemsInRange( GetUnitX(source), GetUnitY(source), 1600.f, Condition(@AIItemFilter), @AISetItem);
            if (It_LastRemoved != nil && (GetItemType(It_LastRemoved) == ITEM_TYPE_POWERUP || AIHasEmptyInventorySlot(source))){
                IssueTargetOrder(source, "smart", It_LastRemoved);
            }
        }
        else {
            IssueTargetOrder(source, "attack", uTemp);
            IssueTargetOrder(source, "purge", uTemp);
            IssueTargetOrder(source, "drain", uTemp);
            IssueTargetOrder(source, "curse", uTemp);
            IssuePointOrderLoc(source, "shockwave", GetUnitLoc(uTemp));
            IssuePointOrderLoc(source, "blizzard", GetUnitLoc(uTemp));
            IssuePointOrderLoc(source, "inferno", GetUnitLoc(uTemp));
            IssuePointOrderLoc(source, "carrionswarm", GetUnitLoc(uTemp));
            IssueImmediateOrder(source, "stomp");
            IssueImmediateOrder(source, "roar");
            if ((IsUnitType(uTemp, UNIT_TYPE_HERO) == false && GetUnitCurrentLife(uTemp) >= 500) || IsUnitType(uTemp, UNIT_TYPE_HERO)){
                IssueImmediateOrder(source, "thunderclap");
                IssueTargetOrder(source, "cripple", uTemp);
                IssueTargetOrder(source, "hex", uTemp);
                IssueTargetOrder(source, "banish", uTemp);
                IssuePointOrderLoc(source, "breathoffire", GetUnitLoc(uTemp));
                IssuePointOrderLoc(source, "earthquake", GetUnitLoc(uTemp));
            }
            if (GetUnitStatePercentRW(source, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE) <= 20 && source != MainBossUnit1){
                if (GetPlayerTeam(GetOwningPlayer(source)) == 0)
                {
                    IssuePointOrder(source, "move", -4288.f, -576.f);
                }
                else {
                    IssuePointOrder(source, "move", 4288.f, - 576.f);
                }
            }
        }
    }
}

void StartAI( unit u )
{
    timer tmr = CreateTimer();
    int hid = GetHandleId(tmr);

    SaveUnitHandle(GameHashTable, hid, 0, u);
    TimerStart(tmr, 1.f, true, @AILoop);

    if (u != MainBossUnit1)
    {
        if (GetAIDifficulty(GetOwningPlayer(u)) == AI_DIFFICULTY_NEWBIE){
            SetPlayerHandicapXP(GetOwningPlayer(u), 1.5f);
        }
        else if (GetAIDifficulty(GetOwningPlayer(u)) == AI_DIFFICULTY_NORMAL){
            SetPlayerHandicapXP(GetOwningPlayer(u), 2.f );
        }
        else if (GetAIDifficulty(GetOwningPlayer(u)) == AI_DIFFICULTY_INSANE){
                SetPlayerHandicapXP(GetOwningPlayer(u), 3.f );
            }
        IssuePointOrder(u, "attack", GetRandomReal( -1900.f, 1900.f), GetRandomReal( -1200.f, 200.f));

        tmr = CreateTimer();
        hid = GetHandleId( tmr );
        SaveUnitHandle(GameHashTable, hid, 0, u);
        TimerStart( tmr, 10.f, true, @AIHeroMoveLoop);
    }
}

void HeroPickArrayCreation()
{
    int i = 1;
    int SysHeroX = - 2600;
    int SysHeroY = 6200;
    int startX = 700;
    int startY = 6200;
    int size = TotalHeroes + 1;

    HeroIDArray.resize( size );
    SetScaleArr.resize( size );
    HeroItemIDArray.resize( size );
    HeroModelArray.resize( size );
    HeroIconArray.resize( size );
    HeroUnitArray.resize( size );
    U_SelectionHeroDummyArr.resize( size );
    EF_SelectionIconArray.resize( size );
    EF_SelectionHeroModelArray.resize( size );

    BossIDArray[1] = FourCC("U001");
    BossIDArray[2] = FourCC("U002");
    BossIDArray[3] = FourCC("U003");
    BossIDArray[4] = FourCC("U004");
    BossIDArray[5] = FourCC("U005");
    BossIDArray[6] = FourCC("U006");
    BossIDArray[7] = FourCC("U007");
    BossIDArray[8] = FourCC("U008");


    HeroIDArray[1] = FourCC("H00A");
    HeroIDArray[2] = FourCC("H00B");
    HeroIDArray[3] = FourCC("H00C");
    HeroIDArray[4] = FourCC("H00D");
    HeroIDArray[5] = FourCC("H00E");
    HeroIDArray[6] = FourCC("H00F");
    HeroIDArray[7] = FourCC("H00G");
    HeroIDArray[8] = FourCC("H00H");
    HeroIDArray[9] = FourCC("H00I");
    HeroIDArray[10] = FourCC("H00J");
    HeroIDArray[11] = FourCC("H00K");

    SetScaleArr[1] = 1.4f;
    SetScaleArr[2] = 1.4f;
    SetScaleArr[3] = 1.5f;
    SetScaleArr[4] = 2.2f;
    SetScaleArr[5] = 2.4f;
    SetScaleArr[6] = 2.2f;
    SetScaleArr[7] = 1.5f;
    SetScaleArr[8] = 2.4f;
    SetScaleArr[9] = 1.8f;
    SetScaleArr[10] = 2.4f;
    SetScaleArr[11] = 2.4f;

    HeroItemIDArray[1] = FourCC("I006");
    HeroItemIDArray[2] = FourCC("I01J");
    HeroItemIDArray[3] = FourCC("I01F");
    HeroItemIDArray[4] = FourCC("I01W");
    HeroItemIDArray[5] = FourCC("I008");
    HeroItemIDArray[6] = FourCC("I016");
    HeroItemIDArray[7] = FourCC("I01V");
    HeroItemIDArray[8] = FourCC("I01P");
    HeroItemIDArray[9] = FourCC("I018");
    HeroItemIDArray[10] = FourCC("I010");
    HeroItemIDArray[11] = FourCC("I00E");

    HeroModelArray[1] = "Characters\\NanayaShiki\\NanayaShiki";
    HeroModelArray[2] = "Characters\\ToonoShiki\\ToonoShiki";
    HeroModelArray[3] = "Characters\\RyougiShiki\\RyougiShiki";
    HeroModelArray[4] = "Characters\\SaberAlter\\SaberAlter";
    HeroModelArray[5] = "Characters\\SaberNero\\SaberNero";
    HeroModelArray[6] = "Characters\\KuchikiByakuya\\KuchikiByakuya";
    HeroModelArray[7] = "Characters\\Akame\\Akame";
    HeroModelArray[8] = "Characters\\Scathach\\Scathach";
    HeroModelArray[9] = "Characters\\Akainu\\Akainu";
    HeroModelArray[10] = "Characters\\Reinforce\\Reinforce";
    HeroModelArray[11] = "Characters\\Arcueid\\Arcueid";

    HeroIconArray[1] = "Characters\\NanayaShiki\\ReplaceableTextures\\CommandButtons\\BTNNanayaShikiIcon.blp";
    HeroIconArray[2] = "Characters\\ToonoShiki\\ReplaceableTextures\\CommandButtons\\BTNToonoShikiIcon.blp";
    HeroIconArray[3] = "Characters\\RyougiShiki\\ReplaceableTextures\\CommandButtons\\BTNRyougiShikiIcon.blp";
    HeroIconArray[4] = "Characters\\SaberAlter\\ReplaceableTextures\\CommandButtons\\BTNSaberAlterIcon.blp";
    HeroIconArray[5] = "Characters\\SaberNero\\ReplaceableTextures\\CommandButtons\\BTNSaberNeroIcon.blp";
    HeroIconArray[6] = "Characters\\KuchikiByakuya\\ReplaceableTextures\\CommandButtons\\BTNKuchikiByakuyaIcon.blp";
    HeroIconArray[7] = "Characters\\Akame\\ReplaceableTextures\\CommandButtons\\BTNAkameIcon.blp";
    HeroIconArray[8] = "Characters\\Scathach\\ReplaceableTextures\\CommandButtons\\BTNScathachIcon.blp";
    HeroIconArray[9] = "Characters\\Akainu\\ReplaceableTextures\\CommandButtons\\BTNAkainuIcon.blp";
    HeroIconArray[10] = "Characters\\Reinforce\\ReplaceableTextures\\CommandButtons\\BTNReinforceIcon.blp";
    HeroIconArray[11] = "Characters\\Arcueid\\ReplaceableTextures\\CommandButtons\\BTNArcueidIcon.blp";

    SelectionUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC("u012"), - 1800, 5525, 270);
    SetUnitScale( SelectionUnit, 2.5f, 2.5f, 2.5f);
    Ef_Selection = AddSpecialEffectTarget("HeroSelectionSystem\\HeroSelectionEffect.mdl", SelectionUnit, "origin");
    Ef_SelectionBack = AddSpecialEffectTarget("HeroSelectionSystem\\HeroSelectionBackground.mdl", SelectionUnit, "origin");
    while (true) {
        if (i > TotalHeroes) break;
        if (i == 6 || i == 11){
            SysHeroX = - 2600;
            SysHeroY = SysHeroY - 100;
            startX = 700;
            startY -= 150;
        }
        U_SelectionHeroDummyArr[i] = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC("u013"), SysHeroX, SysHeroY, 270);
        SetUnitVertexColor(U_SelectionHeroDummyArr[i], 255, 255, 255, 0);
        SetUnitUserData(U_SelectionHeroDummyArr[i], i);
        EF_SelectionIconArray[i] = AddSpecialEffect(HeroModelArray[i] + "Icon.mdl", SysHeroX, SysHeroY);
        HeroUnitArray[i] = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), HeroIDArray[i], startX, startY, 270);
        SetUnitInvulnerable(HeroUnitArray[i], true);
        SysHeroX = SysHeroX + 100;
        startX += 150;
        i = i + 1;
    }
}

void MoveHeroToTeamLocation(int pid, int HeroID)
{
    bool RevInt = false;
    int DataID = 0;

    if (HeroesSelected < TotalPlayers)
    {
        HeroesSelected = HeroesSelected + 1;
        HeroSelectedArray1[pid] = true;
    }
    if ((TeamPlayers[0] != 0 && TeamPlayers[1] != 0) && (TeamOneSelected[HeroID] == false && TeamTwoSelected[HeroID] == false)){
        HeroInit(HeroID);
    }
    if (GetPlayerTeam(Player(pid)) == 0)
    {
        DataID = pid + 1;
        TeamOneSelected[HeroID] = true;
    }
    else {
        DataID = pid + 2;
        TeamTwoSelected[HeroID] = true;
        RevInt = true;
    }
    MUnitArray[pid] = CreateUnit(Player(pid), HeroIDArray[HeroID], I2R( SwapAmount( -4480, RevInt) ), -480.f, 270.f );
    if (GetPlayerController(Player(pid)) == MAP_CONTROL_USER)
    {
        SetPlayerName(Player(pid), PlayerColoredNameArray[pid] + " [ " + GetUnitName(MUnitArray[pid]) + " ]");
        if ( GetLocalPlayer() == Player(pid) )
        {
            SetCameraField( CAMERA_FIELD_ANGLE_OF_ATTACK, 305.f, 0.f );
            CameraReal = 2000.f;
            PanCameraToTimed(GetUnitX(MUnitArray[pid]), GetUnitY(MUnitArray[pid]), 0.f );
            ClearSelection();
            SelectUnit(MUnitArray[pid], true);
        }
    }
    else
    {
        StartAI(MUnitArray[pid]);
        SetPlayerName(Player(pid), PlayerColorStringArray[pid] + GetHeroProperName(MUnitArray[pid]));
    }
    if ( not SameHeroBoolean )
    {
        RemoveUnit(HeroUnitArray[HeroID]);
        RemoveUnit(U_SelectionHeroDummyArr[HeroID]);
    }
    
    multiboarditem mbitem = MultiboardGetItem(MainMultiboard, DataID, 0);
    MultiboardSetItemIcon(mbitem, HeroIconArray[HeroID]);
    MultiboardReleaseItem( mbitem );
    mbitem = MultiboardGetItem(MainMultiboard, DataID, 0);
    MultiboardSetItemValue(mbitem, PlayerColoredNameArray[pid]);
    MultiboardReleaseItem( mbitem );

    DisplayTextToPlayer(GetLocalPlayer(), 0.f, 0.f, PlayerColoredNameArray[pid] + "|r:|c0000ffff has chosen " + PlayerColorStringArray[pid] + GetUnitName(MUnitArray[pid]) + "|r");
}
void ComputerHeroSelection()
{
    int i = 0;
    int HeroID = GetRandomInt(1, TotalHeroes);

    if (HeroesSelected == TotalPlayers)
    {
        DestroyEffect( Ef_Selection );
        DestroyEffect( Ef_SelectionBack );
        RemoveUnit(SelectionUnit);
        while (true) {
            if (i > 7) break;
            if (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING && GetPlayerController(Player(i)) == MAP_CONTROL_COMPUTER){
                while (true) {
                    if (TeamOneSelected[HeroID] == false && TeamTwoSelected[HeroID] == false) break;
                    HeroID = GetRandomInt(1, TotalHeroes);
                }
                MoveHeroToTeamLocation(i, HeroID);
            }
            i = i + 1;
        }
        i = 1;
        while (true) {
            if (i > TotalHeroes) break;
            DestroyEffect(EF_SelectionIconArray[i]);
            RemoveUnit(U_SelectionHeroDummyArr[i]);
            RemoveUnit(HeroUnitArray[i]);
            i = i + 1;
        }
        DisableTrigger(GameTrigArr[7]);
    }
}

void HeroSelectionAction()
{
    player p = GetTriggerPlayer( );
    int TeamID = GetPlayerTeam( p );
    int pid = GetPlayerId( p );
    int heroId = GetUnitUserData(GetTriggerUnit());
    string smdl = "";

    if ( not HeroSelectedArray1[pid] && GetUnitTypeId(GetTriggerUnit()) == FourCC( 'u013' ) )
    {
        if (U_SelectionSelArr[pid] != HeroUnitArray[heroId])
        {
            if ( GetLocalPlayer() == p )
            {
                smdl = HeroModelArray[heroId] + ".mdl";
                ClearSelection();
                SelectUnit(HeroUnitArray[heroId], true);
            }
            DestroyEffect(EF_SelectionHeroModelArray[pid]);
            RemoveUnit(U_SelectionDumArr[pid]);
            U_SelectionDumArr[pid] = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC( 'u012' ), -1800.f, 5525.f, 270.f );
            SetUnitTimeScale(U_SelectionDumArr[pid], 1.5f);
            SetUnitScale(U_SelectionDumArr[pid], SetScaleArr[heroId], SetScaleArr[heroId], SetScaleArr[heroId]);
            EF_SelectionHeroModelArray[pid] = AddSpecialEffectTarget(smdl, U_SelectionDumArr[pid], "origin" );

            U_SelectionSelArr[pid] = HeroUnitArray[heroId];
        }
        else 
        {
            if ((TeamOneSelected[heroId] == false && TeamID == 0) || (TeamTwoSelected[heroId] == false && TeamID == 1))
            {
                DestroyEffect(EF_SelectionHeroModelArray[pid]);
                RemoveUnit(U_SelectionDumArr[pid]);
                MoveHeroToTeamLocation(pid, heroId);
                ComputerHeroSelection();
            }
            else
            {
                DisplayTextToPlayer( p, .0f, .0f, "|c0000ffffHero already selected by your ally!" );
            }
        }
    }
}
void PlayerNameSettingAction()
{
    int tid = 1;

    for ( int i = 0; i < 12; i++ )
    {
        player p = Player( i );
        string name = "";

        if ( i <= 7 )
        {
            if ( GetPlayerSlotState( p ) == PLAYER_SLOT_STATE_PLAYING )
            {
                if ( GetPlayerController( p ) == MAP_CONTROL_COMPUTER )
                {
                    name = "Bot " + I2S( i + 1 );
                }
                else
                {
                    name = GetPlayerName( p );
                }
            }
            else
            {
                name = "- Empty Slot -";
            }
        }
        else if ( i >= 10 )
        {
            name = "Base Tower " + I2S( tid );
            tid++;
        }

        if ( name.isEmpty( ) ) { continue; }

        PlayerNameArray[i] = name;
        PlayerColoredNameArray[i] = PlayerColorStringArray[i] + PlayerNameArray[i] + "|r";

        SetPlayerName( p, PlayerColoredNameArray[i] ); // crashes -> PlayerColoredNameArray[i]
    }
}

bool ResetCDTargets(){
    if (GetOwningPlayer(GetFilterUnit()) != Player(PLAYER_NEUTRAL_AGGRESSIVE)){
        UnitResetCooldown(GetFilterUnit());
    }
    return true;
}
void ResetCooldownTimedAction(){
    GroupEnumUnitsInRect(GroupEnum, worldBounds, Condition(@ResetCDTargets));
}
void NoCooldownActivationAction(){
    if (IsTriggerEnabled(ResetCDTrigger)){
        DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 10.f, "|c00ff0000No-CoolDown Mode Operation Disabled!");
        DisableTrigger(ResetCDTrigger);
    }
    else {
        DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 10.f, "|c0000FF00No-CoolDown Mode Operation Enabled!");
        EnableTrigger(ResetCDTrigger);
    }
}
void AllHeroPickAction(){
int i = 1;
float CenterX = 4288.f;
    DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 10.f, "|c0000ff00The host got all heroes.|r");
    if (GetPlayerTeam(GetTriggerPlayer()) == 0){
        CenterX = - 4288.f;
    }
    while (true) {
        if (i > TotalHeroes) break;
        CreateUnit(GetTriggerPlayer(), HeroIDArray[i], CenterX, -576.f, 270.f );
        i = i + 1;
    }
}
void NoCreepAction(){
    if ( B_IsCreepSpawn )
    {
        DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c00ff0000Creeps on mid will no longer spawn.|r");
        B_IsCreepSpawn = false;
    }
    else
    {
        DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ff00Creeps on mid will start to spawn.|r");
        B_IsCreepSpawn = true;
    }
}
void TestUnitSpawnAction(){
    DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ff00Test Unit Has Been Spawned.|r");
    CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("tstu"), 0.f, -500.f, 270.f );
}
void GetUsedAbilityIDAction(){
    DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 10.f, "|c0000ff00Used Ability ID|r: " + "[" + Id2String(GetSpellAbilityId()) + "]");
}
void UnitIDAction(){
    DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 10.f, "|c0000ff00Selected unit ID|r: " + "[" + Id2String(GetUnitTypeId(GetTriggerUnit())) + "]");
}
void PickedUpItemIDAction(){
    DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 10.f, "|c0000ff00Picked Item ID|r: " + "[" + Id2String(GetItemTypeId(GetManipulatedItem())) + "]");
}
location CreateLocationACF(location LocalLocation1, float LocalReal1, float LocalReal2)
{
    return Location(GetLocationX(LocalLocation1) + LocalReal1 * Cos( Deg2Rad( LocalReal2 ) ), GetLocationY(LocalLocation1) + LocalReal1 * Sin( Deg2Rad( LocalReal2 ) ));
}
void SetUnitFacing2(unit LocalCaster1, location LocalLocation2, float LocalReal24){
location LocalLocation3 = GetUnitLoc(LocalCaster1);
    SetUnitFacingTimed(LocalCaster1, AngleBetweenPointsRW(LocalLocation3, LocalLocation2), LocalReal24);
    RemoveLocation(LocalLocation3);
}
void SetUnitFacing1(unit LocalCaster1, unit LocalTarg1, float LocalReal24){
location LocalLocation2 = GetUnitLoc(LocalTarg1);
    SetUnitFacing2(LocalCaster1, LocalLocation2, LocalReal24);
    RemoveLocation(LocalLocation2);
}

void LinearDisplacementAction()
{
    timer tmr = GetExpiredTimer();
    int hid = GetHandleId( tmr );
    float LocCos = LoadReal(GameHashTable, hid, 0);
    float LocSin = LoadReal(GameHashTable, hid, 1);
    float LocReal1 = LoadReal(GameHashTable, hid, 2);
    float LocReal2 = LoadReal(GameHashTable, hid, 3);
    float LocTrigUnitX = LoadReal(GameHashTable, hid, 4);
    float LocTrigUnitY = LoadReal(GameHashTable, hid, 5);
    unit LocTrigUnit = LoadUnitHandle(GameHashTable, hid, 6);
    bool LocPathing = LoadBoolean(GameHashTable, hid, 8);
    string LocAttach = LoadStr(GameHashTable, hid, 9);
    string LocEffect = LoadStr(GameHashTable, hid, 10);
    int LocInt1 = LoadInteger(GameHashTable, hid, 11);
    int LocInt2 = LoadInteger(GameHashTable, hid, 12);
    float LocMoveX = GetUnitX(LocTrigUnit) + LocReal1 * LocCos;
    float LocMoveY = GetUnitY(LocTrigUnit) + LocReal1 * LocSin;
    float LocDuration = LoadReal(GameHashTable, hid, 13);

    if (LocDuration > 0 && GetUnitCurrentLife(LocTrigUnit) > 0){
        SaveReal(GameHashTable, hid, 13, LocDuration - 1);
        if (LocPathing == false){
            if (IsTerrainPathable(LocMoveX, LocMoveY, PATHING_TYPE_WALKABILITY)){
                SaveInteger(GameHashTable, hid, 11, 0);
            }
            else {
                SetUnitX(LocTrigUnit, LocMoveX);
                SetUnitY(LocTrigUnit, LocMoveY);
            }
        }
        else {
            SetUnitX(LocTrigUnit, LocMoveX);
            SetUnitY(LocTrigUnit, LocMoveY);
        }
        if (LocInt2 == 0){
            if (GetUnitFlyHeight(LocTrigUnit) < 5.f){
                DestroyEffect(AddSpecialEffect(LocEffect, GetUnitX(LocTrigUnit), GetUnitY(LocTrigUnit)));
            }
        }
        if (LocInt2 == 2){
            SaveInteger(GameHashTable, hid, 12, 0);
        }
        SaveReal(GameHashTable, hid, 2, LocReal1 - LocReal2);
        if (LocReal1 <= 0 || RMinACF(RMaxACF(LocTrigUnitX * 1, MapMinX), MapMaxX) != LocTrigUnitX || RMinACF(RMaxACF(LocTrigUnitY * 1, MapMinY), MapMaxY) != LocTrigUnitY){
            SaveInteger(GameHashTable, hid, 11, 0);
        }
        if (LocInt1 == 0){
            SetUnitFlyHeight(LocTrigUnit, GetUnitDefaultFlyHeight(LocTrigUnit), 200);
            SetUnitTimeScale(LocTrigUnit, 1);
        }
    }
    else {
        PauseTimer( tmr );
        FlushChildHashtable(GameHashTable, hid);
        DestroyTimer( tmr );
    }
}

void LinearDisplacement(unit u, float LocFacing, float LocDistance, float LocTime, float LocRate, bool LocDestrDestruct, bool LocPathing, string LocAttach, string LocEffect)
{
    if ( u == nil ) { return; }

    timer t = CreateTimer();
    int hid = GetHandleId(t);
    SaveReal(GameHashTable, hid, 0, Cos(Deg2Rad(LocFacing)));
    SaveReal(GameHashTable, hid, 1, Sin(Deg2Rad(LocFacing)));
    SaveReal(GameHashTable, hid, 2, 2 * LocDistance * LocRate / LocTime);
    SaveReal(GameHashTable, hid, 3, (2 * LocDistance * LocRate / LocTime) * LocRate / LocTime);
    SaveReal(GameHashTable, hid, 4, GetUnitX(u));
    SaveReal(GameHashTable, hid, 5, GetUnitY(u));
    SaveUnitHandle(GameHashTable, hid, 6, u);
    SaveBoolean(GameHashTable, hid, 8, LocPathing);
    SaveStr(GameHashTable, hid, 9, LocAttach);
    SaveStr(GameHashTable, hid, 10, LocEffect);
    SaveInteger(GameHashTable, hid, 11, 1);
    SaveInteger(GameHashTable, hid, 12, 0);
    SaveReal(GameHashTable, hid, 13, LocTime / LocRate);
    TimerStart(t, LocRate, true, @LinearDisplacementAction);
}

void DisplaceUnitAction()
{
    timer tmr = GetExpiredTimer();
    int hid = GetHandleId( tmr );
    unit u = LoadUnitHandle(GameHashTable, hid, 0);
    float LocOrigHeigth = LoadReal(GameHashTable, hid, 1);
    float LocAngle = LoadReal(GameHashTable, hid, 2);
    float LocDist = LoadReal(GameHashTable, hid, 3);
    float LocHeightMax = LoadReal(GameHashTable, hid, 4);
    float LocDHeight = LoadReal(GameHashTable, hid, 5);
    float LocGetX = LoadReal(GameHashTable, hid, 6);
    float LocGetY = LoadReal(GameHashTable, hid, 7);
    int LocSteep = LoadInteger(GameHashTable, hid, 8);
    int LocSteepMax = LoadInteger(GameHashTable, hid, 9);
    int LocIsAffected = LoadInteger(GameHashTable, GetHandleId(u), 50);

    if ((LocSteep < LocSteepMax && LocIsAffected == 1) && GetUnitCurrentLife(u) > 0)
    {
        SetUnitX(u, RMinACF(RMaxACF(LocGetX + LocSteep * LocDist * Cos(LocAngle * 3.14159f / 180.f) * 1.f, MapMinX), MapMaxX));
        SetUnitY(u, RMinACF(RMaxACF(LocGetY + LocSteep * LocDist * Sin(LocAngle * 3.14159f / 180.f) * 1.f, MapMinY), MapMaxY));
        SaveInteger(GameHashTable, hid, 8, LocSteep + 1);
        SetUnitFlyHeight(u, ( - (2 * I2R(LocSteep) * LocDHeight - 1) * (2 * I2R(LocSteep) * LocDHeight - 1) + 1) * LocHeightMax + LocOrigHeigth, 99999);
        IssueImmediateOrder(u, "stop");
    }
    else
    {
        SetUnitFlyHeight(u, LocOrigHeigth, 99999);
        SetUnitPathing(u, true);
        SaveInteger(GameHashTable, GetHandleId(u), 50, 0);
        PauseTimer( tmr );
        FlushChildHashtable(GameHashTable, hid);
        DestroyTimer( tmr );
    }
}

void DisplaceUnitWithArgs(unit u, float LocAngle, float LocTotalDist, float LocTotalTime, float LocRate, float LocHeightMax)
{
    if ( u == nil ) { return; }
    int LocIsAffected = LoadInteger(GameHashTable, GetHandleId(u), 50); if (LocIsAffected == 1) { return; }

    timer t = CreateTimer();
    int hid = GetHandleId(t);
    float LocGetX = GetUnitX(u);
    float LocGetY = GetUnitY(u);
    int LocSteepMax = R2I(LocTotalTime / LocRate);
    int LocSteep = 0;
    float LocDist = LocTotalDist / LocSteepMax;
    float LocDHeight = 1.f / LocSteepMax;
    float LocOrigHeigth = GetUnitFlyHeight(u);

    int aid = FourCC( "Amrf" );

    if ( GetUnitAbility( u, aid ) == nil )
    {
        UnitAddAbility( u, aid );
        ShowAbility( GetUnitAbility( u, aid ), false );
    }

    SetUnitPathing(u, false);
    SaveInteger(GameHashTable, GetHandleId(u), 50, 1);
    SaveUnitHandle(GameHashTable, hid, 0, u);
    SaveReal(GameHashTable, hid, 1, LocOrigHeigth);
    SaveReal(GameHashTable, hid, 2, LocAngle);
    SaveReal(GameHashTable, hid, 3, LocDist);
    SaveReal(GameHashTable, hid, 4, LocHeightMax);
    SaveReal(GameHashTable, hid, 5, LocDHeight);
    SaveReal(GameHashTable, hid, 6, LocGetX);
    SaveReal(GameHashTable, hid, 7, LocGetY);
    SaveInteger(GameHashTable, hid, 8, LocSteep);
    SaveInteger(GameHashTable, hid, 9, LocSteepMax);
    TimerStart(t, LocRate, true, @DisplaceUnitAction);
}
void DamageVisualDrawNumber(string LocNumber, float LocPosX, float LocPosY, string LocSuffix){
    DestroyEffect(AddSpecialEffect("DamageSystemVisual\\Number_" + LocNumber + LocSuffix + ".mdx", LocPosX, LocPosY));
}
float DamageVisualGetPosition(float GraphicSpacement, float LocInitPos, int LocActual, int LocFinal, float LocRatio){
    return LocInitPos - (GraphicSpacement * LocRatio * (LocFinal / 2)) + (GraphicSpacement * LocRatio * LocActual);
}
void DamageVisualDrawNumberAction(unit LocSource, unit LocTarget, float LocAmount){
float GraphicSpacement = 70.f;
float LocPosX = GetUnitX(LocTarget);
float LocPosY = GetUnitY(LocTarget) + GetUnitFlyHeight(LocTarget) + 150;
string LocNumbers = I2S(R2I(LocAmount));
int LocSize = StringLength(LocNumbers);
float LocNewPosX = 0;
string LocSuffix = "";
float LocRatio = 0;
int index = 0;
    if (LocAmount >= 5000){
        LocSuffix = "_Large";
        LocRatio = 1.3f;
    }
    else if (LocAmount >= 500){
        LocSuffix = "";
        LocRatio = 1.0f;
    }
    else {
            LocSuffix = "_Small";
            LocRatio = 0.7f;
        }

    index = - 1;
    while (true) {
        index = index + 1;
        if (index > LocSize - 1) break;
        LocNewPosX = DamageVisualGetPosition(GraphicSpacement, LocPosX, index, LocSize, LocRatio);
        if (IsUnitInvisible(LocTarget, GetOwningPlayer(LocSource)) == false){
            DamageVisualDrawNumber(SubString(LocNumbers, index, index + 1), LocNewPosX, LocPosY, LocSuffix);
        }
    }
}
void AkamePoisonDamage(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 10 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) + .1f * GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (GetUnitAbilityLevel(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("B006")) > 0){
        DamageTargetACF(DummyUnitDamageArr[GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
    }
    else {
        FlushChildHashtable(GameHashTable, hid);
        DestroyTimer(GetExpiredTimer());
    }
}
void AkamePoisonCheck(unit LocTrigUnit, unit LocTargUnit){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveUnitHandle(GameHashTable, hid, iCaster, LocTrigUnit);
    SaveUnitHandle(GameHashTable, hid, iTarget, LocTargUnit);
    TimerStart(tmr, 1, true, @AkamePoisonDamage);
}
void OnPlayerUnitDamaged()
{
    float SourceDmg = GetEventDamage();

    if ( SourceDmg > 1.f )
    {
        trigger t = GetTriggeringTrigger();
        unit Source = GetEventDamageSource();
        unit Target = GetTriggerUnit();
        int LocID = GetUnitTypeId(Target);
        
        float Multiplier = 1;
        float DealtTrigDmg = 0;
        float DmgMult = 0;
        float LocReqHP = 0;

        DisableTrigger( t );
        if ( GetEventIsAttack( ) )
        {
            if ( LocID == FourCC("n000") && ( GetUnitTypeId(Source) == FourCC( "base" ) || IsUnitType( Source, UNIT_TYPE_HERO ) ) )
            {
                SetUnitPosition(KawarimiTriggerUnitArray[GetPlayerId(GetOwningPlayer(Target))], GetUnitX(Source), GetUnitY(Source));
                UnitApplyTimedLife(Target, FourCC("BOmi"), .01f);
            }

            if ( GetUnitTypeId( Source ) == FourCC("H00G") )
            {
                if (GetUnitAbilityLevel(Target, FourCC("B006")) <= 0)
                {
                    AkamePoisonCheck(Source, Target);
                }
                IssueTargetOrder(DummyUnitDamageArr[GetPlayerId(GetOwningPlayer(Source))], "slow", Target);
            }
            else if (GetUnitTypeId(Source) == FourCC("H00K"))
            {
                SetUnitCurrentLife(Source, SourceDmg * .15f + GetUnitCurrentLife(Source));
            }

            if (GetUnitAbilityLevel(Source, FourCC("B002")) > 0 || GetUnitAbilityLevel(Source, FourCC("B000")) > 0)
            {
                if (GetUnitAbilityLevel(Source, FourCC("B002")) > 0){
                    DmgMult = 10;
                }
                if (GetUnitAbilityLevel(Source, FourCC("B000")) > 0){
                    DmgMult = 20;
                }
                if (HasPersonalItemACF(Source)){
                    DmgMult = DmgMult + DmgMult / 2;
                    LocReqHP = 10;
                }
                else {
                    LocReqHP = 5;
                }
                DealtTrigDmg = GetHeroLevel(Source) * DmgMult + GetHeroInt(Source, true) * DmgMult / 100;
                if (GetUnitStatePercentRW(Target, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE) <= LocReqHP && Target != MainBossUnit1){
                    if (GetUnitAbilityLevel(Source, FourCC("B002")) > 0){
                        UnitRemoveAbility(Source, FourCC("A02X"));
                        UnitAddAbility(Source, FourCC("A02X"));
                        UnitRemoveAbility(Source, FourCC("B002"));
                    }
                    if (GetUnitAbilityLevel(Source, FourCC("B000")) > 0){
                        UnitRemoveAbility(Source, FourCC("A035"));
                        UnitAddAbility(Source, FourCC("A035"));
                        UnitRemoveAbility(Source, FourCC("B000"));
                    }
                    CreateUnit(GetOwningPlayer(Source), FourCC("u00J"), GetUnitX(Target), GetUnitY(Target), 270);
                    DealtTrigDmg = 100000000;
                    DestroyEffect(AddSpecialEffect("GeneralEffects\\BloodEffect1.mdx", GetUnitX(Target), GetUnitY(Target)));
                    DestroyEffect(AddSpecialEffect("GeneralEffects\\26.mdx", GetUnitX(Target), GetUnitY(Target)));
                }

                SetEventDamage( GetEventDamage( ) + DealtTrigDmg );
            }
            if (GetUnitTypeId(Source) == FourCC("H00J") && GetRandomInt(0, 100) <= 15){
                DealtTrigDmg = GetHeroLevel(Source) * 50 + GetHeroInt(Source, true);
                GlobalUnit = CreateUnit(GetOwningPlayer(Source), FourCC("u00E"), GetUnitX(Source), GetUnitY(Source), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 1.5f, .3f);
                GlobalUnit = CreateUnit(GetOwningPlayer(Source), FourCC("u00L"), GetUnitX(Source), GetUnitY(Source), AngleBetweenUnits(Source, Target));
                SetUnitScaleAndTime(GlobalUnit, 1.5f, .3f);
                DisplaceUnitWithArgs(Target, AngleBetweenUnits(Source, Target), 200, .25f, .01f, 0);
                SetEventDamage( GetEventDamage( ) + DealtTrigDmg );
                //DamageTargetACF(Source, Target, DealtTrigDmg);
            }
            if (GetUnitTypeId(Source) == FourCC("H00H")){
                if (IsUnitType(Target, UNIT_TYPE_HERO) == false){
                    DmgMult = 2;
                }
                DmgMult = 0.01f * Multiplier;
                DealtTrigDmg = .005f * Multiplier * GetUnitMaxLife(Target);

                SetEventDamage( GetEventDamage( ) + DealtTrigDmg );

                //DamageTargetACF(Source, Target, DealtTrigDmg);
                SetUnitCurrentLife(Source, GetUnitMaxLife(Source) * DmgMult + GetUnitCurrentLife(Source));
            }
        }

        if (GetUnitTypeId(Source) == FourCC("base"))
        {
            SetEventDamage( GetEventDamage( ) + GetUnitMaxLife(Target) * .02f );
        }

        SourceDmg = GetEventDamage(); // DealtTrigDmg + 
        if (GetUnitTypeId(Source) != FourCC("base"))
        {
            DamageVisualDrawNumberAction(Source, Target, SourceDmg);
        }

        if ( LocID == FourCC("tstu") )
        {
            SetEventDamage( .0f );
        }

        EnableTrigger( t );
    }
}
void SaberNeroHealthRegen(){
int hid = GetHandleId(GetExpiredTimer());
float MaxHP = GetUnitMaxLife(LoadUnitHandle(GameHashTable, hid, iCaster));
float CurrentHP = GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster));
    SetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster), (MaxHP - CurrentHP) * .04f + CurrentHP);
}
void EnteringUnitCheckAction(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
unit Unit = GetEnteringUnit();
player TrigPlayer = GetOwningPlayer(Unit);
int ID = GetPlayerId(TrigPlayer);
    if (IsUnitType(Unit, UNIT_TYPE_HERO) && Unit != MainBossUnit1){
        if (GetUnitTypeId(Unit) == FourCC("H00E")){
            SaveUnitHandle(GameHashTable, hid, iCaster, MUnitArray[ID]);
            TimerStart(tmr, 1, true, @SaberNeroHealthRegen);
        }
    }
}
void ReviveSystemTriggerFunction3(){
int hid = GetHandleId(GetExpiredTimer());
unit ReviveSystemLocalUnit1 = LoadUnitHandle(GameHashTable, hid, 0);
int ReviveUnitID = LoadInteger(GameHashTable, hid, 1);
bool RevInt = false;
    if (GetPlayerTeam(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, 0))) == 0){
        RevInt = true;
    }
    DestroyEffect(LoadEffectHandle(GameHashTable, hid, 1));
    ReviveHero(ReviveSystemLocalUnit1, SwapAmount(4288, RevInt), - 576, true);
    SetUnitFlyHeight(ReviveSystemLocalUnit1, 0, 2000);
    if (GetLocalPlayer() == GetOwningPlayer(ReviveSystemLocalUnit1)){
        ClearSelection();
        PanCameraToTimed(SwapAmount(4288, RevInt), - 576, .2f);
        SelectUnit(ReviveSystemLocalUnit1, true);
    }
    if (GetPlayerController(GetOwningPlayer(ReviveSystemLocalUnit1)) == MAP_CONTROL_COMPUTER){
        IssuePointOrder(ReviveSystemLocalUnit1, "attack", GetRandomReal( - 1900.f, 1900.f), GetRandomReal( - 1200.f, 200.f));
    }
    PauseTimer(GetExpiredTimer());
    FlushChildHashtable(GameHashTable, hid);
    DestroyTimer(GetExpiredTimer());
}
void ReviveSystemAction(){
timer ReviveSystemLocalTimer1 = CreateTimer();
int hid = GetHandleId(ReviveSystemLocalTimer1);
    if (IsUnitType(GetDyingUnit(), UNIT_TYPE_HERO) && GetPlayerSlotState(GetTriggerPlayer()) == PLAYER_SLOT_STATE_PLAYING && GetPlayerId(GetTriggerPlayer()) < 12){
        SaveUnitHandle(GameHashTable, hid, 0, GetTriggerUnit());
        SaveEffectHandle(GameHashTable, hid, 1, AddSpecialEffect("GeneralEffects\\UnitEffects\\DeathIndicator.mdl", GetUnitX(GetDyingUnit()), GetUnitY(GetDyingUnit()) + 300));
        TimerStart(ReviveSystemLocalTimer1, 4, false, @ReviveSystemTriggerFunction3);
    }
    else {
        DestroyTimer(ReviveSystemLocalTimer1);
    }
}
void AbilityTextTagCreationAction(){
texttag TextTag = CreateTextTag();
float speed = 100.f;
float angle = 90.f;
float size = 13.f;
float vel = speed * 0.071f / 128.f;
float xvel = vel * Cos( Deg2Rad( angle ) );
float yvel = vel * Sin( Deg2Rad( angle ) );
float textHeight = size * 0.023f / 10.f;
    if (GetSpellAbilityId() == FourCC("A021") || GetSpellAbilityId() == FourCC("A00X")){
    }
    else {
        UnitRemoveAbility(GetTriggerUnit(), FourCC("B018"));
        UnitRemoveAbility(GetTriggerUnit(), FourCC("Binv"));
    }
    if (IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) && GetSpellAbilityId() != FourCC("A055") && GetSpellAbilityId() != FourCC("A01S")){
        SetTextTagText(TextTag, GetObjectName(GetSpellAbilityId()), textHeight);
        SetTextTagColor(TextTag, 255, 0, 0, 100);
        SetTextTagPosUnit(TextTag, GetTriggerUnit(), 50);
        SetTextTagVelocity(TextTag, xvel, yvel);
        SetTextTagPermanent(TextTag, false);
        SetTextTagLifespan(TextTag, 2.f);
        SetTextTagFadepoint(TextTag, .25f);
    }
}
void BossCheckFunction1(){
    if ( ! (GetUnitX(MainBossUnit1) >=  - 544.f && GetUnitX(MainBossUnit1) <= 544.f && GetUnitY(MainBossUnit1) >=  - 4100.f && GetUnitY(MainBossUnit1) <=  - 2800.f)){
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX(MainBossUnit1), GetUnitY(MainBossUnit1)));
        SetUnitPosition(MainBossUnit1, 0.f, - 3850.f);
    }
}
void BossCheckInit(){
    TimerStart(CreateTimer(), 1, true, @BossCheckFunction1);
}
void MultiBoardCreationFunction1()
{
    DisplayTimedTextToPlayer(GetLocalPlayer(), 0.f, 0.f, 5.f, "|c00ff0000Welcome to Anime Character Fight|r
	|c00ff0000Wish you an amazing victory: |r|c0000ffffor a sweet defeat :)|r
	|c00ff0000SO!: |r|c0000ffffFor spells sounds download patch from vk.com/acfwc3 or chaosrealm.info!|r");
    MainMultiboard = CreateMultiboard();
    MultiboardSetRowCount(MainMultiboard, 11);
    MultiboardSetColumnCount(MainMultiboard, 3);
    MultiboardSetTitleText(MainMultiboard, "|Cff00ff00Scoreboard|r |c00ff0000" + I2S(TeamKills[0]) + "|r/|c000000ff" + I2S(TeamKills[1]) + "|r");
    MultiboardDisplay(MainMultiboard, true);
    MBItem = MultiboardGetItem(MainMultiboard, 10, 0);
    MultiboardSetItemWidth(MBItem, 12.f / 100.f);
    MultiboardReleaseItem(MBItem);
    MBItem = MultiboardGetItem(MainMultiboard, 10, 1);
    MultiboardSetItemWidth(MBItem, 12.f / 100.f);
    MultiboardReleaseItem(MBItem);
    int i = 0;
    int j = 0;
    while (true) 
    {
        if (i > 9) break;
        MBItem = MultiboardGetItem(MainMultiboard, i, 0);
        MultiboardSetItemWidth(MBItem, 12 / 100.0f);
        MultiboardReleaseItem(MBItem);
        MBItem = MultiboardGetItem(MainMultiboard, i, 1);
        MultiboardSetItemWidth(MBItem, 4 / 100.0f);
        MultiboardReleaseItem(MBItem);
        MBItem = MultiboardGetItem(MainMultiboard, i, 2);
        MultiboardSetItemWidth(MBItem, 4 / 100.0f);
        MultiboardReleaseItem(MBItem);
        if (i == 0 || i == 5){
            MBItem = MultiboardGetItem(MainMultiboard, i, 1);
            MultiboardSetItemValue(MBItem, "0");
            MultiboardReleaseItem(MBItem);
            MBItem = MultiboardGetItem(MainMultiboard, i, 2);
            MultiboardSetItemValue(MBItem, "0");
            MultiboardReleaseItem(MBItem);
            MBItem = MultiboardGetItem(MainMultiboard, i, 1);
            MultiboardSetItemIcon(MBItem, "ReplaceableTextures\\CommandButtons\\BTNTransmute.blp");
            MultiboardReleaseItem(MBItem);
            MBItem = MultiboardGetItem(MainMultiboard, i, 2);
            MultiboardSetItemIcon(MBItem, "ReplaceableTextures\\CommandButtons\\BTNDeathCoil.blp");
            MultiboardReleaseItem(MBItem);
        }
        if (i != 0 && i != 5){
            MBItem = MultiboardGetItem(MainMultiboard, i, 0);
            if (GetPlayerSlotState(Player(j)) == PLAYER_SLOT_STATE_PLAYING){
                MultiboardSetItemValue(MBItem, PlayerColoredNameArray[j] + "|r");
            }
            else {
                MultiboardSetItemValue(MBItem, PlayerColorStringArray[j] + "- Empty Slot -|r");
            }
            MultiboardSetItemIcon(MBItem, "UI\\Widgets\\Console\\Human\\CommandButton\\human-button-lvls-overlay.blp");
            MultiboardReleaseItem(MBItem);
            MBItem = MultiboardGetItem(MainMultiboard, i, 1);
            MultiboardSetItemIcon(MBItem, "ReplaceableTextures\\CommandButtons\\BTNArcaniteMelee.blp");
            MultiboardReleaseItem(MBItem);
            MBItem = MultiboardGetItem(MainMultiboard, i, 2);
            MultiboardSetItemIcon(MBItem, "ReplaceableTextures\\CommandButtons\\BTNFrostArmor.blp");
            MultiboardReleaseItem(MBItem);
            MBItem = MultiboardGetItem(MainMultiboard, i, 1);
            MultiboardSetItemValue(MBItem, PlayerColorStringArray[j] + "0" + "|r");
            MultiboardReleaseItem(MBItem);
            MBItem = MultiboardGetItem(MainMultiboard, i, 2);
            MultiboardSetItemValue(MBItem, PlayerColorStringArray[j] + "0" + "|r");
            MultiboardReleaseItem(MBItem);
            j++;
        }
        i++;
    }
    MBItem = MultiboardGetItem(MainMultiboard, 0, 0);
    MultiboardSetItemValue(MBItem, "|c00ff0000RED|r TEAM");
    MultiboardReleaseItem(MBItem);
    MBItem = MultiboardGetItem(MainMultiboard, 5, 0);
    MultiboardSetItemValue(MBItem, "|c000000ffBLUE|r TEAM");
    MultiboardReleaseItem(MBItem);
    MBItem = MultiboardGetItem(MainMultiboard, 10, 0);
    MultiboardSetItemValue(MBItem, "Kills: Undecided");
    MultiboardReleaseItem(MBItem);
    MBItem = MultiboardGetItem(MainMultiboard, 10, 1);
    MultiboardSetItemValue(MBItem, "0:0:0");
    MultiboardReleaseItem(MBItem);
    MBItem = MultiboardGetItem(MainMultiboard, 0, 0);
    MultiboardSetItemIcon(MBItem, "ReplaceableTextures\\CommandButtons\\BTNOrbofSlowness.blp");
    MultiboardReleaseItem(MBItem);
    MBItem = MultiboardGetItem(MainMultiboard, 5, 0);
    MultiboardSetItemIcon(MBItem, "ReplaceableTextures\\CommandButtons\\BTNMoonStone.blp");
    MultiboardReleaseItem(MBItem);
    MBItem = MultiboardGetItem(MainMultiboard, 10, 0);
    MultiboardSetItemIcon(MBItem, "ReplaceableTextures\\CommandButtons\\BTNLament.blp");
    MultiboardReleaseItem(MBItem);
    MBItem = MultiboardGetItem(MainMultiboard, 10, 1);
    MultiboardSetItemIcon(MBItem, "ReplaceableTextures\\WorldeditUI\\Events-time.blp");
    MultiboardReleaseItem(MBItem);
    MultiboardDisplay(MainMultiboard, true);
}
void InGameTimerAction()
{
    timer tmr = GetExpiredTimer();
    int hid = GetHandleId( tmr );
    int secs = LoadInteger(GameHashTable, hid, 0);
    int mins = LoadInteger(GameHashTable, hid, 1);
    int hours = LoadInteger(GameHashTable, hid, 2);

    if (secs == 59)
    {
        SaveInteger(GameHashTable, hid, 0, 0);
        SaveInteger(GameHashTable, hid, 1, mins + 1);
    }
    else
    {
        SaveInteger(GameHashTable, hid, 0, secs + 1);
    }
    if (mins == 59)
    {
        SaveInteger(GameHashTable, hid, 1, 0);
        SaveInteger(GameHashTable, hid, 2, hours + 1);
    }

    multiboarditem mbitem = MultiboardGetItem(MainMultiboard, 10, 1);
    MultiboardSetItemValue( mbitem, I2S( hours ) + ":" + I2S( mins ) + ":" + I2S( secs ) );
    MultiboardReleaseItem( mbitem );
}
bool RegisterHeroDeathCondition(){
    return IsUnitType(GetDyingUnit(), UNIT_TYPE_HERO) && IsUnitAlly(GetKillingUnit(), GetOwningPlayer(GetDyingUnit())) != true && GetOwningPlayer(GetDyingUnit()) != Player(PLAYER_NEUTRAL_AGGRESSIVE);
}
void RegisterHeroDeathAction(){
int FirstIndex = 0;
int SecondIndex = 0;
int FirstID = 0;
int SecondID = 0;
int KillingID = 1 + GetPlayerId(GetOwningPlayer(GetKillingUnit()));
int DyingID = 1 + GetPlayerId(GetOwningPlayer(GetDyingUnit()));
    if (GetPlayerTeam(GetOwningPlayer(GetDyingUnit())) == 0){
        FirstIndex = 5;
        FirstID = 1;
        KillingID = KillingID + 1;
    }
    else {
        SecondIndex = 5;
        SecondID = 1;
        DyingID = DyingID + 1;
    }
    if (GetOwningPlayer(GetKillingUnit()) != Player(PLAYER_NEUTRAL_AGGRESSIVE) && GetUnitTypeId(GetKillingUnit()) != FourCC("base")){
        DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 5, PlayerColoredNameArray[GetPlayerId(GetOwningPlayer(GetKillingUnit()))] + " |c008080c0Killed|r " + PlayerColoredNameArray[GetPlayerId(GetOwningPlayer(GetDyingUnit()))]);
        KillingUnitIntegerArray[KillingID] = KillingUnitIntegerArray[KillingID] + 1;
        MBItem = MultiboardGetItem(MainMultiboard, KillingID, 1);
        MultiboardSetItemValue(MBItem, PlayerColorStringArray[GetPlayerId(GetOwningPlayer(GetKillingUnit()))] + I2S(KillingUnitIntegerArray[KillingID]));
        MultiboardReleaseItem(MBItem);
        TeamKills[FirstID] = TeamKills[FirstID] + 1;
        MBItem = MultiboardGetItem(MainMultiboard, FirstIndex, 1);
        MultiboardSetItemValue(MBItem, I2S(TeamKills[FirstID]));
        MultiboardReleaseItem(MBItem);
    }
    DyingUnitIntegerArray[DyingID] = DyingUnitIntegerArray[DyingID] + 1;
    MBItem = MultiboardGetItem(MainMultiboard, DyingID, 2);
    MultiboardSetItemValue(MBItem, PlayerColorStringArray[GetPlayerId(GetOwningPlayer(GetDyingUnit()))] + I2S(DyingUnitIntegerArray[DyingID]));
    MultiboardReleaseItem(MBItem);
    TeamDeaths[SecondID] = TeamDeaths[SecondID] + 1;
    MBItem = MultiboardGetItem(MainMultiboard, SecondIndex, 2);
    MultiboardSetItemValue(MBItem, I2S(TeamDeaths[SecondID]));
    MultiboardReleaseItem(MBItem);
    MultiboardSetTitleText(MainMultiboard, "|Cff00ff00Scoreboard|r |c00ff0000" + I2S(TeamKills[0]) + "|r/|c000000ff" + I2S(TeamKills[1]) + "|r");
}
void KillSelectionDialogAction(){
int i = 0;
    while (true) {
        if (i > 8) break;
        if (GetClickedButton() == SameHeroModeButtonArray[i]){
            MBArr1[i] = MBArr1[i] + 1;
        }
        i = i + 1;
    }
}
void KillSelectionTimerExpireAction(){
int MaxVotes = 0;
int TotalVotes = 0;
int MaxVotesID = 0;
int index = 0;
bool VotesTied = false;
    DialogShow(KillSelectionDialog, false);
    DialogClear(KillSelectionDialog);
    DialogDestroy(KillSelectionDialog);
    TimerDialogDisplay(ModeSelectionTD, false);
    DestroyTimerDialog(ModeSelectionTD);
    MultiboardDisplay(MainMultiboard, true);
    while (true) {
        if (index > 8) break;
        if (MBArr1[index] > 0){
            TotalVotes = TotalVotes + 1;
        }
        if (MBArr1[index] == MaxVotes){
            VotesTied = true;
        }
        if (MBArr1[index] > MaxVotes){
            MaxVotes = MBArr1[index];
            MaxVotesID = index;
            VotesTied = false;
        }
        index = index + 1;
    }
    if (MaxVotesID == 0){
        KillLimitInteger1 = 20 * GetRandomInt(1, 7);
    }
    else if (MaxVotesID == 8){
        KillLimitInteger1 = 999999999;
    }
    else if (MaxVotesID != 0 && MaxVotesID != 8){
            KillLimitInteger1 = 20 * MaxVotesID;
        }
    if (VotesTied == true || TotalVotes <= 0){
        if (TotalPlayers == 1 || TeamPlayers[0] == 0 || TeamPlayers[1] == 0){
            KillLimitInteger1 = 999999999;
        }
        if (TeamPlayers[0] == 1 && TeamPlayers[1] == 1){
            KillLimitInteger1 = 20;
        }
        if ((TeamPlayers[0] == 1 && TeamPlayers[1] == 2) || (TeamPlayers[0] == 2 && TeamPlayers[1] == 1)){
            KillLimitInteger1 = 40;
        }
        if (TeamPlayers[0] == 2 && TeamPlayers[1] == 2){
            KillLimitInteger1 = 60;
        }
        if ((TeamPlayers[0] == 2 && TeamPlayers[1] == 3) || (TeamPlayers[0] == 3 && TeamPlayers[1] == 2)){
            KillLimitInteger1 = 80;
        }
        if (TeamPlayers[0] == 3 && TeamPlayers[1] == 3){
            KillLimitInteger1 = 100;
        }
        if ((TeamPlayers[0] == 3 && TeamPlayers[1] == 4) || (TeamPlayers[0] == 4 && TeamPlayers[1] == 3)){
            KillLimitInteger1 = 120;
        }
        if (TeamPlayers[0] == 4 && TeamPlayers[1] == 4){
            KillLimitInteger1 = 140;
        }
    }
    if (TotalVotes > 0){
        DisplayTimedTextToPlayer(GetLocalPlayer(), .0f, .0f, 5.f, "
		|cFFFFCC00Votes for |c0000ffff[Random]|r|cFFFFCC00:|r |c0000ffff" + I2S(MBArr1[0]) + "|r
		|cFFFFCC00Votes for |c0000ffff[20 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S(MBArr1[1]) + "|r
		|cFFFFCC00Votes for |c0000ffff[40 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S(MBArr1[2]) + "|r
		|cFFFFCC00Votes for |c0000ffff[60 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S(MBArr1[3]) + "|r
		|cFFFFCC00Votes for |c0000ffff[80 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S(MBArr1[4]) + "|r
		|cFFFFCC00Votes for |c0000ffff[100 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S(MBArr1[5]) + "|r
		|cFFFFCC00Votes for |c0000ffff[120 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S(MBArr1[6]) + "|r
		|cFFFFCC00Votes for |c0000ffff[140 Kills]|r|cFFFFCC00:|r |c0000ffff" + I2S(MBArr1[7]) + "|r
		|cFFFFCC00Votes for |c0000ffff[Unlimited Kills]|cFFFFCC00:|r |c0000ffff" + I2S(MBArr1[8]) + "|r");
    }
    MBItem = MultiboardGetItem(MainMultiboard, 10, 0);
    if (KillLimitInteger1 <= 140){
        DisplayTimedTextToPlayer(GetLocalPlayer(), .0f, .0f, 5.f, "|cFFFFCC00Kill Limit is:|r |c0000ffff[" + I2S(KillLimitInteger1) + "]|r |cFFFFCC00Kills|r");
        MultiboardSetItemValue(MBItem, "Kills: " + I2S(KillLimitInteger1));
    }
    else {
        DisplayTimedTextToPlayer(GetLocalPlayer(), .0f, .0f, 5.f, "|cFFFFCC00Kill Limit is:|r |c0000ffff[Unlimited]|r |cFFFFCC00Kills.|r");
        MultiboardSetItemValue(MBItem, "Kills: Unlimited");
    }
    MultiboardReleaseItem(MBItem);
    EnableTrigger(GameTrigArr[7]);
    DisplayTimedTextToPlayer(GetLocalPlayer(), .0f, .0f, 5.f, "|c0000ffffHero Selection has been activated!|r");
    MultiboardDisplay(MainMultiboard, false);
    MultiboardDisplay(MainMultiboard, true);
    TimerStart(CreateTimer(), 1, true, @InGameTimerAction);
}
void KillSelectionAction(){
    DisplayTimedTextToPlayer(GetLocalPlayer(), .0f, .0f, 5.f, "|c0000ffffAttention to All Players!

	You have 5 seconds to choose desirable Kill Limit");
    ModeSelectionTD = CreateTimerDialog(KillSelectionTimer);
    TimerDialogSetTitle(ModeSelectionTD, "|c00ffff00Kill Limit Selection");
    TimerDialogDisplay(ModeSelectionTD, true);
    TimerStart(KillSelectionTimer, 5, false, @KillSelectionTimerExpireAction);
    DialogSetMessage(KillSelectionDialog, "Select Kill Limit");
    SameHeroModeButtonArray[0] = DialogAddButton(KillSelectionDialog, "Random", 0);
    SameHeroModeButtonArray[1] = DialogAddButton(KillSelectionDialog, "20 Kills [1 vs 1]", 0);
    SameHeroModeButtonArray[2] = DialogAddButton(KillSelectionDialog, "40 Kills", 0);
    SameHeroModeButtonArray[3] = DialogAddButton(KillSelectionDialog, "60 Kills [2 vs 2]", 0);
    SameHeroModeButtonArray[4] = DialogAddButton(KillSelectionDialog, "80 Kills", 0);
    SameHeroModeButtonArray[5] = DialogAddButton(KillSelectionDialog, "100 Kills [3 vs 3]", 0);
    SameHeroModeButtonArray[6] = DialogAddButton(KillSelectionDialog, "120 Kills", 0);
    SameHeroModeButtonArray[7] = DialogAddButton(KillSelectionDialog, "140 Kills [4 vs 4]", 0);
    SameHeroModeButtonArray[8] = DialogAddButton(KillSelectionDialog, "Unlimited Kills", 0);
    DialogShow(KillSelectionDialog, true);
}
void ModeSelectionFunction2(){
    if (GetClickedButton() == SameHeroModeButtonArray[10]){
        MBArr1[10] = MBArr1[10] + 1;
    }
    if (GetClickedButton() == SameHeroModeButtonArray[11]){
        MBArr1[11] = MBArr1[11] + 1;
    }
}
void ModeSelectionFunction3(){
    DialogShow(ModeSelectionDialog, false);
    DialogClear(ModeSelectionDialog);
    DialogDestroy(ModeSelectionDialog);
    TimerDialogDisplay(ModeSelectionTD, false);
    MultiboardDisplay(MainMultiboard, true);
    DisplayTimedTextToPlayer(GetLocalPlayer(), .0f, .0f, 5.f, "|cFFFFCC00Same Hero Mode Results:
	For:|r |c0000ffff" + I2S(MBArr1[10]) + "|r |cFFFFCC00Against:|r |c0000ffff" + I2S(MBArr1[11]) + "|r" );
    if (MBArr1[10] > MBArr1[11]){
        SameHeroBoolean = true;
        DisplayTimedTextToPlayer(GetLocalPlayer(), .0f, .0f, 5.f, "|c0000FF00Same Hero Mode Enabled!");
    }
    else {
        DisplayTimedTextToPlayer(GetLocalPlayer(), .0f, .0f, 5.f, "|c00ff0000Same Hero Mode Disabled!");
    }
    TimerStart(KillSelectionTimer, 1, false, @KillSelectionAction);
}
void ModeSelectionFunction1(){
    timer tmr = CreateTimer();
    DisplayTimedTextToPlayer(GetLocalPlayer(), .0f, .0f, 5.f, "|c00FFFF00Hero Selection is disabled
	To enable it:
	Choose desirable kills and mode|r");
    ModeSelectionTD = CreateTimerDialog( tmr );
    TimerDialogSetTitle(ModeSelectionTD, "|c00ffff00Mode Selection");
    TimerDialogDisplay(ModeSelectionTD, true);
    DialogSetMessage(ModeSelectionDialog, "Same Hero Mode");
    SameHeroModeButtonArray[10] = DialogAddButton(ModeSelectionDialog, "|c0000FF00Enable|r", 0);
    SameHeroModeButtonArray[11] = DialogAddButton(ModeSelectionDialog, "|c00ff0000Disable|r", 0);
    DialogShow(ModeSelectionDialog, true);
    TimerStart( tmr, 5, false, @ModeSelectionFunction3);
}
void DecideWinnersAction(){
int index = 0;
    while (true) {
        if (index > 7) break;
        if (GetPlayerSlotState(Player(index)) == PLAYER_SLOT_STATE_PLAYING){
            if (GetPlayerTeam(Player(index)) == I_WinningTeam )
            {
                RemovePlayer(Player(index), PLAYER_GAME_RESULT_VICTORY);
            }
            else {
                RemovePlayer(Player(index), PLAYER_GAME_RESULT_DEFEAT);
            }
        }
        index = index + 1;
    }
    EndGame(true);
}
void GameEndUnitPauseFunction(){
bool RevInt = false;
int index = 0;
    while (true) {
        if (index > 7) break;
        if (GetLocalPlayer() == GetOwningPlayer(MUnitArray[index])){
            PanCameraToTimed(GetUnitX(MUnitArray[index]), GetUnitY(MUnitArray[index]), 0);
        }
        if (GetPlayerTeam(Player(index)) == 1){
            RevInt = true;
        }
        SetUnitPosition(MUnitArray[index], SwapAmount( - 800, RevInt), 1536.f);
        SetUnitFacing(MUnitArray[index], 270.f);
        SetUnitInvulnerable(MUnitArray[index], true);
        PauseUnit(MUnitArray[index], true);
        index = index + 1;
    }
}
void PrepareFinishGameAction(int LocTeam){
bool RevInt = true;
    I_WinningTeam = LocTeam;
    if (LocTeam == 0){
        RevInt = false;
    }
    TextTagCreate("|c0000FF00Winners!|r", SwapAmount( - 800, RevInt), 1700.f, 0, 20, 255, 255, 255, 0);
    TextTagCreate("|c00ff0000Losers!|r", SwapAmount(800, RevInt), 1700.f, 0, 20, 255, 255, 255, 0);
    TimerStart(CreateTimer(), 1, true, @GameEndUnitPauseFunction);
    TimerStart(CreateTimer(), 10, false, @DecideWinnersAction);
}
bool WinGameEndCondition1(){
    return TeamKills[0] >= KillLimitInteger1 || TeamKills[1] >= KillLimitInteger1;
}
void WinGameEndFunction1(){
    if (TeamKills[0] >= KillLimitInteger1){
        PrepareFinishGameAction(0);
    }
    if (TeamKills[1] >= KillLimitInteger1){
        PrepareFinishGameAction(1);
    }
}
void BossKillFunction1(){
    DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 10, PlayerColoredNameArray[GetPlayerId(GetOwningPlayer(GetKillingUnit()))] + " |c008080c0Killed|r " + "|c0000FF00" + GetHeroProperName(GetDyingUnit()));
    PrepareFinishGameAction(GetPlayerTeam(GetOwningPlayer(GetKillingUnit())));
}
void RegisterPlayerLeaveAction(){
int PlayerID = GetPlayerId(GetTriggerPlayer());
int ID = PlayerID + 1;
int TeamID = GetPlayerTeam(GetTriggerPlayer());
int LocRecievedGold = GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD) / (TeamPlayers[TeamID] - 1);
    if (TeamID == 1){
        ID = ID + 1;
    }
    MBItem = MultiboardGetItem(MainMultiboard, ID, 0);
    MultiboardSetItemValue(MBItem, PlayerColorStringArray[PlayerID] + "- Left -|r");
    MultiboardReleaseItem(MBItem);
    ID = 0;
    TotalPlayers = TotalPlayers - 1;
    TeamPlayers[TeamID] = TeamPlayers[TeamID] - 1;
    DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 5, PlayerColoredNameArray[PlayerID] + "|r Has left the game!");
    RemoveUnit(MUnitArray[PlayerID]);
    RemovePlayer(GetTriggerPlayer(), PLAYER_GAME_RESULT_DEFEAT);
    while (true) {
        if (ID > 7) break;
        if (GetPlayerSlotState(Player(ID)) == PLAYER_SLOT_STATE_PLAYING && IsPlayerAlly(GetTriggerPlayer(), Player(ID))){
            SetPlayerState(Player(ID), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(ID), PLAYER_STATE_RESOURCE_GOLD) + LocRecievedGold);
        }
        ID = ID + 1;
    }
    DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "Each player in Team " + I2S(TeamID + 1) + " has received |cFFFFCC00" + I2S(LocRecievedGold) + "|r gold from a leaver.");
    if (TeamPlayers[TeamID] == 0){
        if (TeamID == 0){
            ID = 1;
        }
        else {
            ID = 0;
        }
        PrepareFinishGameAction(ID);
    }
}
void CreepAndIllusionRemoverAction(){
    if (IsUnitType(GetEnteringUnit(), UNIT_TYPE_HERO) == false && IsUnitIllusion(GetEnteringUnit()) == false && IsUnitEnemy(GetEnteringUnit(), GetOwningPlayer(GetFilterUnit())) && GetOwningPlayer(GetEnteringUnit()) == Player(PLAYER_NEUTRAL_AGGRESSIVE)){
        KillUnit(GetEnteringUnit());
    }
}
void DisableSharedUnitsAct(){
int IndexA = 0;
int IndexB = 0;
    while (true) {
        if (IndexA > 11) break;
        if (Player(IndexA) != Player(IndexB)){
            SetPlayerAlliance(Player(IndexA), Player(IndexB), ALLIANCE_SHARED_CONTROL, false);
        }
        IndexB = IndexB + 1;
        if (IndexB > 11){
            IndexB = 0;
            IndexA = IndexA + 1;
        }
    }
}
void MainBossStatBoostAction(){
    if (IsUnitOwnedByPlayer(MainBossUnit1, Player(PLAYER_NEUTRAL_AGGRESSIVE)) && IsUnitType(GetDyingUnit(), UNIT_TYPE_HERO) && IsUnitEnemy(GetDyingUnit(), Player(PLAYER_NEUTRAL_AGGRESSIVE))){
        SetHeroStr(MainBossUnit1, GetHeroStr(MainBossUnit1, false) + GetHeroLevel(GetDyingUnit()) * 2, true);
        SetHeroAgi(MainBossUnit1, GetHeroAgi(MainBossUnit1, false) + GetHeroLevel(GetDyingUnit()) * 2, true);
        SetHeroInt(MainBossUnit1, GetHeroInt(MainBossUnit1, false) + GetHeroLevel(GetDyingUnit()) * 2, true);
        SetUnitCurrentLife(MainBossUnit1, GetUnitMaxLife(MainBossUnit1) * GetHeroLevel(GetDyingUnit()) * 0.01f + GetWidgetLife(MainBossUnit1));
        DestroyEffect(AddSpecialEffect("Characters\\Arcueid\\ArcueidREffect1.mdl", GetUnitX(MainBossUnit1), GetUnitY(MainBossUnit1)));
        DestroyEffect(AddSpecialEffect("Characters\\Arcueid\\ArcueidREffect2.mdl", GetUnitX(MainBossUnit1), GetUnitY(MainBossUnit1)));
    }
}
bool ShadowScrollItemUsageCondition(){
    return GetItemTypeId(GetManipulatedItem()) == FourCC("I01T");
}
void ShadowScrollItemUsageAction1(){
    SysItem = CreateItem(FourCC("I01U"), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()));
    SysUnit = CreateUnit(GetOwningPlayer(GetTriggerUnit()), FourCC("u000"), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 270);
    UnitAddItem(SysUnit, SysItem);
    UnitUseItemTarget(SysUnit, SysItem, GetTriggerUnit());
}
bool RedTabletUsageCondition(){
    return GetItemTypeId(GetManipulatedItem()) == FourCC("I01S");
}
void RedTabletUsageAction(){
    SysItem = CreateItem(FourCC("I00M"), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()));
    SysUnit = CreateUnit(GetOwningPlayer(GetTriggerUnit()), FourCC("u000"), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 270);
    UnitAddItem(SysUnit, SysItem);
    UnitUseItemTarget(SysUnit, SysItem, GetTriggerUnit());
}
bool KunaiOfBouldersCondition(){
    return GetSpellAbilityId() == FourCC("A00V");
}
void KunaiOfBouldersAction(){
int i = 0;
    while (true) {
        if (i > 9) break;
        GlobalUnit = CreateUnit(GetOwningPlayer(GetTriggerUnit()), FourCC("n002"), GetSpellTargetX() + GetRandomReal( - 125, 125), GetSpellTargetY() + GetRandomReal( - 125, 125), GetRandomReal(0, 360));
        UnitRemoveAbility(GlobalUnit, FourCC("Aatk"));
        UnitRemoveAbility(GlobalUnit, FourCC("Amov"));
        i = i + 1;
    }
}
void TopLeftSpawnNewBossAction(){
    GroupAddUnit( GR_LeftSide, CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), BossIDArray[LeftBosses], - 2200.f, 2800.f, 270));
    DestroyTimer(GetExpiredTimer());
}
void TopRightSpawnNewBossAction(){
    GroupAddUnit( GR_RightSide, CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), BossIDArray[RightBosses], 2200.f, 2800.f, 270));
    DestroyTimer(GetExpiredTimer());
}
bool KilledBossesCountCondition(){
    return IsUnitInGroup(GetDyingUnit(), GR_LeftSide ) || IsUnitInGroup(GetDyingUnit(), GR_RightSide);
}
void KilledBossesCountAction(){
player WhichPlayer = GetOwningPlayer(GetKillingUnit());
int ID = GetPlayerId(WhichPlayer);
int UnitID = GetUnitTypeId(GetDyingUnit());
    BossesKilledIntegerArray[ID] = BossesKilledIntegerArray[ID] + 1;
    DisplayTextToPlayer(WhichPlayer, 0, 0, "|cFFFFCC00Bosses Killed:|r |c00ff8040" + I2S(BossesKilledIntegerArray[ID]) + "|r");
    SetPlayerState(WhichPlayer, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(WhichPlayer, PLAYER_STATE_RESOURCE_LUMBER) + 1);
    if (BossesKilledIntegerArray[ID] == 8){
        DisplayTextToPlayer(GetLocalPlayer(), 0, 0, PlayerColoredNameArray[ID] + "|r has earnt enough kills for -T command");
        GlobalPlayerArray1[ID] = WhichPlayer;
    }
    if (IsUnitInGroup(GetDyingUnit(), GR_LeftSide )){
        LeftBosses = LeftBosses + 1;
        TimerStart(CreateTimer(), 10.f, false, @TopLeftSpawnNewBossAction);
    }
    if (IsUnitInGroup(GetDyingUnit(), GR_RightSide)){
        RightBosses = RightBosses + 1;
        TimerStart(CreateTimer(), 10.f, false, @TopRightSpawnNewBossAction);
    }
}
void CreepSpawn3Action(){
player p = Player(PLAYER_NEUTRAL_AGGRESSIVE);
int i = 0;
    if ( B_IsCreepSpawn )
    {
        while (true) {
            if (i == 4) break;
            if (i < 2){
                CreateUnit(p, FourCC("h003"), - 1888.f, - 160.f, 270);
                CreateUnit(p, FourCC("h004"), - 1888.f, - 864.f, 270);
                CreateUnit(p, FourCC("h007"), - 1184.f, - 864.f, 270);
                CreateUnit(p, FourCC("h015"), 384.f, - 896.f, 270);
                CreateUnit(p, FourCC("h003"), 1888.f, - 160.f, 270);
                CreateUnit(p, FourCC("h007"), 1184.f, - 864.f, 270);
                CreateUnit(p, FourCC("h004"), 1888.f, - 896.f, 270);
            }
            if (i < 3){
                CreateUnit(p, FourCC("h009"), - 1888.f, - 160.f, 270);
                CreateUnit(p, FourCC("h016"), - 1888.f, - 896.f, 270);
                CreateUnit(p, FourCC("h001"), - 1184.f, - 896.f, 270);
                CreateUnit(p, FourCC("h016"), - 384.f, - 160.f, 270);
                CreateUnit(p, FourCC("h001"), 384.f, - 160.f, 270);
                CreateUnit(p, FourCC("h009"), - 384.f, - 896.f, 270);
                CreateUnit(p, FourCC("h009"), 1888.f, - 160.f, 270);
                CreateUnit(p, FourCC("h001"), 1184.f, - 896.f, 270);
                CreateUnit(p, FourCC("h016"), 1888.f, - 896.f, 270);
            }
            CreateUnit(p, FourCC("h015"), - 1184.f, - 160.f, 270);
            CreateUnit(p, FourCC("h015"), 1184.f, - 160.f, 270);
            i = i + 1;
        }
    }
}
void CreepUpgrade2Action(){
    PauseTimer(CreepSpawnerTimer1);
    TimerStart(CreepSpawnerTimer1, 90.f, true, @CreepSpawn3Action);
}
void CreepSpawn2Action(){
player p = Player(PLAYER_NEUTRAL_AGGRESSIVE);
int i = 0;
    if ( B_IsCreepSpawn )
    {
        CreateUnit(p, FourCC("h009"), - 1888.f, - 160.f, 270);
        CreateUnit(p, FourCC("h016"), - 1888.f, - 896.f, 270);
        CreateUnit(p, FourCC("h001"), - 1184.f, - 896.f, 270);
        CreateUnit(p, FourCC("h009"), 1888.f, - 160.f, 270);
        CreateUnit(p, FourCC("h001"), 1184.f, - 896.f, 270);
        CreateUnit(p, FourCC("h016"), 1888.f, - 896.f, 270);
        while (true) {
            if (i == 6) break;
            if (i < 5){
                CreateUnit(p, FourCC("h008"), - 1888.f, - 160.f, 270);
                CreateUnit(p, FourCC("h002"), - 1888.f, - 896.f, 270);
                CreateUnit(p, FourCC("h000"), - 1184.f, - 896.f, 270);
                CreateUnit(p, FourCC("h002"), - 384.f, - 160.f, 270);
                CreateUnit(p, FourCC("h000"), 384.f, - 160.f, 270);
                CreateUnit(p, FourCC("h014"), 384.f, - 896.f, 270);
                CreateUnit(p, FourCC("h008"), - 384.f, - 896.f, 270);
                CreateUnit(p, FourCC("h008"), 1888.f, - 160.f, 270);
                CreateUnit(p, FourCC("h000"), 1184.f, - 896.f, 270);
                CreateUnit(p, FourCC("h002"), 1888.f, - 896.f, 270);
            }
            CreateUnit(p, FourCC("h014"), - 1184.f, - 160.f, 270);
            CreateUnit(p, FourCC("h014"), 1184.f, - 160.f, 270);
            i = i + 1;
        }
    }
}
void CreepUpgrade1Action(){
    PauseTimer(CreepSpawnerTimer1);
    TimerStart(CreepUpgradeTimer1, 600.f, false, @CreepUpgrade2Action);
    TimerStart(CreepSpawnerTimer1, 60.f, true, @CreepSpawn2Action);
}
void CreepSpawn1Action(){
player p = Player(PLAYER_NEUTRAL_AGGRESSIVE);
int i = 0;
    if ( B_IsCreepSpawn )
    {
        while (true) {
            if (i == 4) break;
            if (i < 2){
                CreateUnit(p, FourCC("h011"), - 1888.f, - 896.f, 270);
                CreateUnit(p, FourCC("h011"), - 384.f, - 896.f, 270);
                CreateUnit(p, FourCC("h011"), 1888.f, - 896.f, 270);
            }
            CreateUnit(p, FourCC("h010"), 384.f, - 896.f, 270);
            CreateUnit(p, FourCC("h010"), 1184.f, - 896.f, 270);
            CreateUnit(p, FourCC("h010"), - 1184.f, - 896.f, 270);
            CreateUnit(p, FourCC("h012"), - 1184.f, - 160.f, 270);
            CreateUnit(p, FourCC("h012"), 1888.f, - 160.f, 270);
            CreateUnit(p, FourCC("h012"), 384.f, - 160.f, 270);
            CreateUnit(p, FourCC("h013"), - 1888.f, - 160.f, 270);
            CreateUnit(p, FourCC("h013"), - 384.f, - 160.f, 270);
            CreateUnit(p, FourCC("h013"), 1184.f, - 160.f, 270);
            i = i + 1;
        }
    }
}
void UnitCreationAction(){
    TimerStart(CreepUpgradeTimer1, 300.f, false, @CreepUpgrade1Action);
    TimerStart(CreepSpawnerTimer1, 30.f, true, @CreepSpawn1Action);
}
bool UnitCreationWithCircleCond(){
    return IsUnitType(GetEnteringUnit(), UNIT_TYPE_HERO);
}
void UnitCreationOnTopLeftAction(){
int i = 0;
    if (CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h022")) <= 160){
        DisplayTextToPlayer(GetOwningPlayer(GetEnteringUnit()), 0, 0, "|c00CBFF75NPC Spawned");
        while (true) {
            if (i > 9) break;
            CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h022"), GetRandomReal( - 5632.f, - 3136.f), GetRandomReal(1088.f, 3136.f), GetRandomReal(0, 360));
            i = i + 1;
        }
    }
    else {
        DisplayTextToPlayer(GetOwningPlayer(GetEnteringUnit()), 0, 0, "|c00ff0000Maximum amount of units was reached!");
    }
}
void UnitCreationOnBottomRightAction(){
int i = 0;
    if (CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h020")) <= 30 || CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h023")) <= 30){
        DisplayTextToPlayer(GetOwningPlayer(GetEnteringUnit()), 0, 0, "|c00CBFF75NPC Spawned");
        while (true) {
            if (i > 1) break;
            if (CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h020")) <= 30){
                CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h020"), GetRandomReal(3200.f, 5664.f), GetRandomReal(1120.f, 3168.f), GetRandomReal(0, 360));
            }
            if (CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h023")) <= 30){
                CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h023"), GetRandomReal(3200.f, 5664.f), GetRandomReal(1120.f, 3168.f), GetRandomReal(0, 360));
            }
            i = i + 1;
        }
    }
    else {
        DisplayTextToPlayer(GetOwningPlayer(GetEnteringUnit()), 0, 0, "|c00ff0000Maximum amount of units was reached!");
    }
}
void UnitCreationOnTopRightAction(){
int i = 0;
    if (CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h017")) <= 160){
        DisplayTextToPlayer(GetOwningPlayer(GetEnteringUnit()), 0, 0, "|c00CBFF75NPC Spawned");
        while (true) {
            if (i > 9) break;
            CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h017"), GetRandomReal(3072.f, 5632.f), GetRandomReal( - 4160.f, - 2208.f), GetRandomReal(0, 360));
            i = i + 1;
        }
    }
    else {
        DisplayTextToPlayer(GetOwningPlayer(GetEnteringUnit()), 0, 0, "|c00ff0000Maximum amount of units was reached!");
    }
}
void UnitCreationOnBottomLeftAction(){
int i = 0;
    if (CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h018")) <= 30 || CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h021")) <= 30){
        DisplayTextToPlayer(GetOwningPlayer(GetEnteringUnit()), 0, 0, "|c00CBFF75NPC Spawned");
        while (true) {
            if (i > 1) break;
            if (CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h018")) <= 30){
                CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h018"), GetRandomReal( - 5632.f, - 3008.f), GetRandomReal( - 4160.f, - 2176.f), GetRandomReal(0, 360));
            }
            if (CountUnitInGroupOfPlayer(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h021")) <= 30){
                CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("h021"), GetRandomReal( - 5632.f, - 3008.f), GetRandomReal( - 4160.f, - 2176.f), GetRandomReal(0, 360));
            }
            i = i + 1;
        }
    }
    else {
        DisplayTextToPlayer(GetOwningPlayer(GetEnteringUnit()), 0, 0, "|c00ff0000Maximum amount of units was reached!");
    }
}
void HeroLevelUpCheck(){
int index = 1;
int LocalStat = 0;
unit LocUnit = GetLevelingUnit();
int LocalLevel = GetHeroLevel(LocUnit);
player LocPlayer = GetOwningPlayer(LocUnit);
    DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\LevelUp.mdl", LocUnit, "origin"));
    if (GetPlayerController(LocPlayer) == MAP_CONTROL_COMPUTER){
        if (GetAIDifficulty(LocPlayer) == AI_DIFFICULTY_NEWBIE){
            LocalStat = 2;
        }
        else if (GetAIDifficulty(LocPlayer) == AI_DIFFICULTY_NORMAL){
            LocalStat = 3;
        }
        else if (GetAIDifficulty(LocPlayer) == AI_DIFFICULTY_INSANE){
                LocalStat = 5;
            }
        if (LocalLevel >= 5 && LocalLevel < 10){
            LocalStat = LocalStat * 2;
        }
        else if (LocalLevel >= 10 && LocalLevel < 15){
            LocalStat = LocalStat * 3;
        }
        else if (LocalLevel >= 15){
                LocalStat = LocalStat * 5;
            }
        SetPlayerState(LocPlayer, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(LocPlayer, PLAYER_STATE_RESOURCE_GOLD) + 50 * LocalStat);
        SetHeroStr(LocUnit, GetHeroStr(LocUnit, false) + LocalStat, true);
        SetHeroAgi(LocUnit, GetHeroAgi(LocUnit, false) + LocalStat, true);
        SetHeroInt(LocUnit, GetHeroInt(LocUnit, false) + LocalStat, true);
        if (LocalLevel == 5){
            UnitAddItemById(LocUnit, FourCC("I03U"));
        }
        else if (LocalLevel == 8){
            UnitAddItemById(LocUnit, FourCC("I03X"));
        }
        else if (LocalLevel == 10){
                UnitAddItemById(LocUnit, FourCC("I03Z"));
            }
            else if (LocalLevel == 13){
                    UnitAddItemById(LocUnit, FourCC("I00H"));
                }
                else if (LocalLevel == 15){
                        while (true) {
                            if (HeroIDArray[index] == GetUnitTypeId(LocUnit)) break;
                            index = index + 1;
                        }
                        UnitAddItemById(LocUnit, HeroItemIDArray[index]);
                    }
                    else if (LocalLevel == 20){
                            UnitAddItemById(LocUnit, FourCC("I03V"));
                        }
                        else if (LocalLevel == 21){
                                UnitAddItemById(LocUnit, FourCC("I03Z"));
                            }
                            else if (LocalLevel == 25){
                                    UnitAddItemById(LocUnit, FourCC("I00X"));
                                }
                                else if (LocalLevel == 27){
                                        UnitAddItemById(LocUnit, FourCC("I00T"));
                                    }
    }
    else {
        if (GetUnitLevel(LocUnit) >= 50){
            SetHeroStr(LocUnit, GetHeroStr(LocUnit, false) + 3, true);
            SetHeroAgi(LocUnit, GetHeroAgi(LocUnit, false) + 3, true);
            SetHeroInt(LocUnit, GetHeroInt(LocUnit, false) + 3, true);
            SuspendHeroXP(LocUnit, true);
        }
    }
}
void PressEscToSaveLocationActivationAction(){
int ID = GetPlayerId(GetTriggerPlayer());
    if (ESCLocationSaveBooleanArray[ID] == false){
        ESCLocationSaveBooleanArray[ID] = true;
        DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "Push ESC to save current position function is: |c0000ffffActivated|r");
    }
    else {
        ESCLocationSaveBooleanArray[ID] = false;
        DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "Push ESC to save current position function is: |c00ff0000Deactivated|r");
    }
}
void SaveLocationAction(){
int ID = GetPlayerId(GetTriggerPlayer());
    DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ffffCurrent location was saved!");
    RemoveLocation(TeleportationLocationArray[ID]);
    TeleportationLocationArray[ID] = GetUnitLoc(MUnitArray[ID]);
}
void ESCToSaveAction(){
int ID = GetPlayerId(GetTriggerPlayer());
    if (ESCLocationSaveBooleanArray[ID] == true){
        DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ffffCurrent location was saved!");
        RemoveLocation(TeleportationLocationArray[ID]);
        TeleportationLocationArray[ID] = GetUnitLoc(MUnitArray[ID]);
    }
}
bool AntiTeleportationStoneCondition(){
    return GetSpellAbilityId() == FourCC("A01W");
}
void AntiTeleportationStoneAction(){
    if (GetUnitTypeId(GetSpellTargetUnit()) == FourCC("H02M")){
        UnitRemoveAbility(GetSpellTargetUnit(), FourCC("B003"));
        DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ffffInvalid Target!");
    }
}
bool ScrollOfTeleportationCondition(){
    return GetItemTypeId(GetManipulatedItem()) == FourCC("I003");
}
void ScrollOfTeleportationAction(){
    if (GetUnitAbilityLevel(GetTriggerUnit(), FourCC("B003")) > 0 || GetUnitAbilityLevel(GetTriggerUnit(), FourCC("B005")) > 0){
        DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ffffUnable to teleport!");
    }
    else {
        DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ffffYou have been teleported to saved position");
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit())));
        SetUnitPositionLoc(GetTriggerUnit(), TeleportationLocationArray[GetPlayerId(GetTriggerPlayer())]);
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit())));
        if (GetLocalPlayer() == GetOwningPlayer(GetTriggerUnit())){
            PanCameraToTimed(GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 0);
        }
    }
}
bool TeleportationCommandCondition(){
    return GetTriggerPlayer() == GlobalPlayerArray1[GetPlayerId(GetTriggerPlayer())];
}
void CheckTeleCooldown(){
int hid = GetHandleId(GetExpiredTimer());
int ID = LoadInteger(GameHashTable, hid, 0);
    if (TeleportationIDIntegerArray[ID] > 0){
        TeleportationIDIntegerArray[ID] = TeleportationIDIntegerArray[ID] - 1;
    }
    else {
        PauseTimer(GetExpiredTimer());
        FlushChildHashtable(GameHashTable, hid);
        DestroyTimer(GetExpiredTimer());
    }
}
void TeleportationCommandAction(){
timer SystemsLocalTimer = CreateTimer();
int hid = GetHandleId(SystemsLocalTimer);
int ID = GetPlayerId(GetTriggerPlayer());
    if (GetUnitAbilityLevel(MUnitArray[ID], FourCC("B00A")) > 0 || GetUnitAbilityLevel(MUnitArray[ID], FourCC("B005")) > 0 || IsUnitPaused(MUnitArray[ID]) == true){
        DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ffffUnable to teleport!");
    }
    else {
        if (TeleportationIDIntegerArray[ID] == 0){
            SaveInteger(GameHashTable, hid, 0, ID);
            TeleportationIDIntegerArray[ID] = 30;
            DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ffffYou have been teleported to saved position");
            DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX(MUnitArray[ID]), GetUnitY(MUnitArray[ID])));
            SetUnitPositionLoc(MUnitArray[ID], TeleportationLocationArray[ID]);
            DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Blink\\BlinkCaster.mdl", GetUnitX(MUnitArray[ID]), GetUnitY(MUnitArray[ID])));
            if (GetLocalPlayer() == GetOwningPlayer(MUnitArray[ID])){
                PanCameraToTimed(GetUnitX(MUnitArray[ID]), GetUnitY(MUnitArray[ID]), 0);
            }
            TimerStart(SystemsLocalTimer, 1, true, @CheckTeleCooldown);
        }
        else {
            DestroyTimer(SystemsLocalTimer);
            DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c00ffff00Teleportation Cooldown: " + I2S(TeleportationIDIntegerArray[ID]) + " seconds|r|c00ff0000!|r");
        }
    }
}
void DisplayHealthByTextAction(){
int ID = GetPlayerId(GetTriggerPlayer());
    if (HealthDisplayBooleanArray[ID] == false){
        HealthDisplayBooleanArray[ID] = true;
        DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "Health display by text is: |c0000ffffOn|r");
    }
    else {
        HealthDisplayBooleanArray[ID] = false;
        DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "Health display by text is: |c00ff0000Off|r");
    }
}
void HealthDisplayReaderAction(){
unit u = GetTriggerUnit();
int MaxHP = R2I(GetUnitMaxLife(u));
    if (HealthDisplayBooleanArray[GetPlayerId(GetTriggerPlayer())] && MaxHP >= 10000 && GetOwningPlayer(u) != Player(PLAYER_NEUTRAL_PASSIVE) && GetUnitTypeId(u) != FourCC("n000")){
        if (IsUnitType(u, UNIT_TYPE_HERO)){
            DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "|c0000ffff" + GetHeroProperName(u) + "|r has: |cFFFFCC00[" + I2S(MaxHP) + "]|r |c0000ffffHP|r");
        }
        else {
            DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "|c0000ffff" + GetUnitName(u) + "|r has: |cFFFFCC00[" + I2S(MaxHP) + "]|r |c0000ffffHP|r");
        }
    }
}
void PersonalItemAction1(){
int i = 0;
unit Hero = GetTriggerUnit();
player LocalPlayer = GetOwningPlayer(Hero);
int ID = GetPlayerId(LocalPlayer);
    while (true) {
        if (HeroIDArray[i] == GetUnitTypeId(Hero)) break;
        i = i + 1;
    }
    if (GetItemTypeId(GetManipulatedItem()) == FourCC("I02R")){
        RemoveItem(GetManipulatedItem());
        if (GetPlayerState(LocalPlayer, PLAYER_STATE_RESOURCE_GOLD) >= 10000){
            if (CountItemsOfTypeFromUnitRW(Hero, HeroItemIDArray[i]) < 1){
                UnitAddItemById(Hero, HeroItemIDArray[i]);
                SetPlayerState(LocalPlayer, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(LocalPlayer, PLAYER_STATE_RESOURCE_GOLD) - 10000);
                if (CountItemsOfTypeFromUnitRW(DummyUnitDamageArr[ID], HeroItemIDArray[i]) < 1){
                    UnitAddItemById(DummyUnitDamageArr[ID], HeroItemIDArray[i]);
                }
            }
        }
    }
    if (CountItemsOfTypeFromUnitRW(Hero, HeroItemIDArray[i]) > 1){
        RemoveItem(GetManipulatedItem());
        SetPlayerState(LocalPlayer, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(LocalPlayer, PLAYER_STATE_RESOURCE_GOLD) + 10000);
    }
}
void ItemOwnerSettingAction(){
    if (GetItemPlayer(GetManipulatedItem()) == Player(15)){
        SetItemPlayer(GetManipulatedItem(), GetOwningPlayer(GetTriggerUnit()), false);
    }
    else if (GetItemPlayer(GetManipulatedItem()) != GetOwningPlayer(GetTriggerUnit())){
        UnitRemoveItem(GetTriggerUnit(), GetManipulatedItem());
        DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()), 0, 0, "|c00ffff00That is not your Item!|r");
    }
}
void ItemCombinationAction(){
unit hero = GetTriggerUnit();
    if (GetItemTypeId(GetManipulatedItem()) == FourCC("I03U")){
        if (CountItemsOfTypeFromUnitRW(hero, FourCC("I03U")) > 1){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03U")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03U")));
            UnitAddItemById(hero, FourCC("I00Y"));
        }
    }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I03X")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I03Z")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I03U")) > 0){
        RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03U")));
        RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03Z")));
        RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03X")));
        UnitAddItemById(hero, FourCC("I00X"));
    }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I03V")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I03Z")) > 0){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03V")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03Z")));
            UnitAddItemById(hero, FourCC("I00R"));
        }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I03X")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I03Y")) > 0){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03Y")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03X")));
            UnitAddItemById(hero, FourCC("I00S"));
        }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I03Y")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I03V")) > 0){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03Y")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03V")));
            UnitAddItemById(hero, FourCC("I00Z"));
        }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I03X")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I03W")) > 0){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03X")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I03W")));
            UnitAddItemById(hero, FourCC("I00U"));
        }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I00Q")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I00K")) > 0){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I00Q")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I00K")));
            UnitAddItemById(hero, FourCC("I00R"));
        }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I00Q")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I00N")) > 0){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I00Q")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I00N")));
            UnitAddItemById(hero, FourCC("I00S"));
        }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I00O")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I00I")) > 0){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I00O")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I00I")));
            UnitAddItemById(hero, FourCC("I00U"));
        }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I00N")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I00K")) > 0){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I00N")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I00K")));
            UnitAddItemById(hero, FourCC("I00Z"));
        }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I02Q")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I00J")) > 0 && GetPlayerState(GetOwningPlayer(hero), PLAYER_STATE_RESOURCE_GOLD) >= 3800){
            SetPlayerState(GetOwningPlayer(hero), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetOwningPlayer(hero), PLAYER_STATE_RESOURCE_GOLD) - 3800);
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I02Q")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I00J")));
            UnitAddItemById(hero, FourCC("I00T"));
        }
    else if (CountItemsOfTypeFromUnitRW(hero, FourCC("I01K")) > 0 && CountItemsOfTypeFromUnitRW(hero, FourCC("I01S")) > 0){
        if (GetItemCharges(GetItemOfTypeFromUnitRW(hero, FourCC("I01S"))) == 1 && GetItemCharges(GetItemOfTypeFromUnitRW(hero, FourCC("I01K"))) == 1){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I01S")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I01K")));
            UnitAddItemById(hero, FourCC("I01T"));
        }
        else if (GetItemCharges(GetItemOfTypeFromUnitRW(hero, FourCC("I01S"))) == 2 && GetItemCharges(GetItemOfTypeFromUnitRW(hero, FourCC("I01K"))) == 1){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I01S")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I01K")));
            UnitAddItemById(hero, FourCC("I01T"));
            UnitAddItemById(hero, FourCC("I01S"));
        }
        else if (GetItemCharges(GetItemOfTypeFromUnitRW(hero, FourCC("I01S"))) == 1 && GetItemCharges(GetItemOfTypeFromUnitRW(hero, FourCC("I01K"))) == 2){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I01S")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I01K")));
            UnitAddItemById(hero, FourCC("I01T"));
            UnitAddItemById(hero, FourCC("I01K"));
        }
        else if (GetItemCharges(GetItemOfTypeFromUnitRW(hero, FourCC("I01S"))) == 2 && GetItemCharges(GetItemOfTypeFromUnitRW(hero, FourCC("I01K"))) == 2){
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I01S")));
            RemoveItem(GetItemOfTypeFromUnitRW(hero, FourCC("I01K")));
            UnitAddItemById(hero, FourCC("I01T"));
            UnitAddItemById(hero, FourCC("I01T"));
        }
    }
}
bool StrTomeUsageCondition(){
    return GetItemTypeId(GetManipulatedItem()) == FourCC("I04E");
}
void StrTomeAction(){
int hid = GetHandleId(GetExpiredTimer());
int LocID = LoadInteger(GameHashTable, hid, 1);
unit LocUnit = LoadUnitHandle(GameHashTable, hid, iCaster);
    if (GetPlayerState(Player(LocID), PLAYER_STATE_RESOURCE_GOLD) >= 1000){
        SetPlayerState(Player(LocID), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(LocID), PLAYER_STATE_RESOURCE_GOLD) - 1000);
        SetHeroStr(LocUnit, GetHeroStr(LocUnit, false) + 10, true);
    }
    else {
        PauseTimer(GetExpiredTimer());
        FlushChildHashtable(GameHashTable, hid);
        DestroyTimer(GetExpiredTimer());
    }
}
void StrTomeUsageAction(){
timer ItemsLocalTimer1 = CreateTimer();
int hid = GetHandleId(ItemsLocalTimer1);
    SaveInteger(GameHashTable, hid, 1, GetPlayerId(GetTriggerPlayer()));
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    TimerStart(ItemsLocalTimer1, .01f, true, @StrTomeAction);
}
bool AgiTomeUsageCondition(){
    return GetItemTypeId(GetManipulatedItem()) == FourCC("I04D");
}
void AgiTomeAction(){
int hid = GetHandleId(GetExpiredTimer());
int LocID = LoadInteger(GameHashTable, hid, 2);
unit LocUnit = LoadUnitHandle(GameHashTable, hid, iCaster);
    if (GetPlayerState(Player(LocID), PLAYER_STATE_RESOURCE_GOLD) >= 1000){
        SetPlayerState(Player(LocID), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(LocID), PLAYER_STATE_RESOURCE_GOLD) - 1000);
        SetHeroAgi(LocUnit, GetHeroAgi(LocUnit, false) + 10, true);
    }
    else {
        PauseTimer(GetExpiredTimer());
        FlushChildHashtable(GameHashTable, hid);
        DestroyTimer(GetExpiredTimer());
    }
}
void AgiTomeUsageAction(){
timer ItemsLocalTimer1 = CreateTimer();
int hid = GetHandleId(ItemsLocalTimer1);
    SaveInteger(GameHashTable, hid, 2, GetPlayerId(GetTriggerPlayer()));
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    TimerStart(ItemsLocalTimer1, .01f, true, @AgiTomeAction);
}
bool IntTomeUsageCondition(){
    return GetItemTypeId(GetManipulatedItem()) == FourCC("I00C");
}
void IntTomeAction(){
int hid = GetHandleId(GetExpiredTimer());
int LocID = LoadInteger(GameHashTable, hid, 3);
unit LocUnit = LoadUnitHandle(GameHashTable, hid, iCaster);
    if (GetPlayerState(Player(LocID), PLAYER_STATE_RESOURCE_GOLD) >= 1000){
        SetPlayerState(Player(LocID), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(LocID), PLAYER_STATE_RESOURCE_GOLD) - 1000);
        SetHeroInt(LocUnit, GetHeroInt(LocUnit, false) + 10, true);
    }
    else {
        PauseTimer(GetExpiredTimer());
        FlushChildHashtable(GameHashTable, hid);
        DestroyTimer(GetExpiredTimer());
    }
}
void IntTomeUsageAction(){
timer ItemsLocalTimer1 = CreateTimer();
int hid = GetHandleId(ItemsLocalTimer1);
    SaveInteger(GameHashTable, hid, 3, GetPlayerId(GetTriggerPlayer()));
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    TimerStart(ItemsLocalTimer1, .01f, true, @IntTomeAction);
}
void MapItemRemovalAction(){
float ItemX = GetItemX(GetManipulatedItem());
float ItemY = GetItemY(GetManipulatedItem());
    if (GetRectMinX( worldBounds ) <= ItemX && ItemX <= GetRectMaxX( worldBounds ) && GetRectMinY( worldBounds ) <= ItemY && ItemY <= GetRectMaxY( worldBounds ))
    {
        if (GetWidgetLife(GetManipulatedItem()) <= 0){
            RemoveItem(GetManipulatedItem());
        }
    }
}
void HeroAbilityUnlockAction(){
player OwningPlayer = GetOwningPlayer(GetLevelingUnit());
int Level = GetUnitLevel(GetLevelingUnit());
    if (Level >= 2){
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A04C"), true);
    }
    if (Level >= 3){
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A02N"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A02V"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03M"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03D"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A039"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A04H"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A032"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03U"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A040"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A01Y"), true);
    }
    if (Level >= 4){
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A04B"), true);
    }
    if (Level >= 5){
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A049"), true);
    }
    if (Level >= 6){
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03N"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A04I"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03S"), true);
    }
    if (Level >= 8){
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A041"), true);
    }
    if (Level >= 10){
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A02O"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A02W"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03O"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03G"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03A"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A04J"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A034"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03V"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A042"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A026"), true);
    }
    if (Level >= 15){
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A02Q"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A02Y"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03P"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03H"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03B"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A036"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03W"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A04D"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A043"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A027"), true);
    }
    if (Level >= 20){
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A02R"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A02Z"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03I"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03C"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A04K"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A037"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A03X"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A04E"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A044"), true);
        SetPlayerAbilityAvailable(OwningPlayer, FourCC("A02A"), true);
    }
}
bool DummyUnitRemovalCondition(){
    return GetUnitTypeId(GetEnteringUnit()) == FourCC("hdes");
}
void DummyUnitRemovalAction(){
    RemoveUnit(GetEnteringUnit());
}
void DisplayYourSavedPositionAction(){
int ID = GetPlayerId(GetTriggerPlayer());
    DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ffffDisplaying the saved position");
    if (GetLocalPlayer() == GetTriggerPlayer()){
        PingMinimapEx(GetLocationX(TeleportationLocationArray[ID]), GetLocationY(TeleportationLocationArray[ID]), 5, 0, 100, 0, false);
    }
}
void DisplayYourTeammatesSavedPositionAction(){
    DisplayTimedTextToPlayer(GetTriggerPlayer(), .0f, .0f, 5.f, "|c0000ffffDisplaying the saved position");
    if (GetPlayerTeam(GetTriggerPlayer()) == 0){
        if (GetPlayerSlotState(Player(0)) == PLAYER_SLOT_STATE_PLAYING){
            if (GetLocalPlayer() == GetTriggerPlayer()){
                PingMinimapEx(GetLocationX(TeleportationLocationArray[GetPlayerId(Player(0))]), GetLocationY(TeleportationLocationArray[GetPlayerId(Player(0))]), 5, 100, 0, 0, false);
            }
        }
        if (GetPlayerSlotState(Player(1)) == PLAYER_SLOT_STATE_PLAYING){
            if (GetLocalPlayer() == GetTriggerPlayer()){
                PingMinimapEx(GetLocationX(TeleportationLocationArray[GetPlayerId(Player(1))]), GetLocationY(TeleportationLocationArray[(GetPlayerId(Player(1)))]), 5, 0, 0, 100, false);
            }
        }
        if (GetPlayerSlotState(Player(2)) == PLAYER_SLOT_STATE_PLAYING){
            if (GetLocalPlayer() == GetTriggerPlayer()){
                PingMinimapEx(GetLocationX(TeleportationLocationArray[GetPlayerId(Player(2))]), GetLocationY(TeleportationLocationArray[GetPlayerId(Player(2))]), 5, 0, 100, 100, false);
            }
        }
        if (GetPlayerSlotState(Player(3)) == PLAYER_SLOT_STATE_PLAYING){
            if (GetLocalPlayer() == GetTriggerPlayer()){
                PingMinimapEx(GetLocationX(TeleportationLocationArray[GetPlayerId(Player(3))]), GetLocationY(TeleportationLocationArray[GetPlayerId(Player(3))]), 5, 43, 14, 51, false);
            }
        }
    }
    else {
        if (GetPlayerSlotState(Player(4)) == PLAYER_SLOT_STATE_PLAYING){
            if (GetLocalPlayer() == GetTriggerPlayer()){
                PingMinimapEx(GetLocationX(TeleportationLocationArray[GetPlayerId(Player(4))]), GetLocationY(TeleportationLocationArray[GetPlayerId(Player(4))]), 5, 100, 100, 0, false);
            }
        }
        if (GetPlayerSlotState(Player(5)) == PLAYER_SLOT_STATE_PLAYING){
            if (GetLocalPlayer() == GetTriggerPlayer()){
                PingMinimapEx(GetLocationX(TeleportationLocationArray[GetPlayerId(Player(5))]), GetLocationY(TeleportationLocationArray[GetPlayerId(Player(5))]), 5, 83, 37, 10, false);
            }
        }
        if (GetPlayerSlotState(Player(6)) == PLAYER_SLOT_STATE_PLAYING){
            if (GetLocalPlayer() == GetTriggerPlayer()){
                PingMinimapEx(GetLocationX(TeleportationLocationArray[GetPlayerId(Player(6))]), GetLocationY(TeleportationLocationArray[GetPlayerId(Player(6))]), 5, 0, 100, 0, false);
            }
        }
        if (GetPlayerSlotState(Player(7)) == PLAYER_SLOT_STATE_PLAYING){
            if (GetLocalPlayer() == GetTriggerPlayer()){
                PingMinimapEx(GetLocationX(TeleportationLocationArray[GetPlayerId(Player(7))]), GetLocationY(TeleportationLocationArray[GetPlayerId(Player(7))]), 5, 100, 50, 50, false);
            }
        }
    }
}
bool KawarimiUseCondition(){
    return GetItemTypeId(GetManipulatedItem()) == FourCC("I00V");
}
void KawarimiUseAction(){
int ID = GetPlayerId(GetOwningPlayer(GetTriggerUnit()));
unit KawarimiUnit = CreateUnit(Player(ID), FourCC("n000"), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 270);
    KawarimiTriggerUnitArray[ID] = GetTriggerUnit();
    SetUnitInvulnerable(KawarimiTriggerUnitArray[ID], true);
    PauseUnit(KawarimiTriggerUnitArray[ID], true);
    ShowUnit(KawarimiTriggerUnitArray[ID], false);
    UnitApplyTimedLife(KawarimiUnit, FourCC("BOmi"), 3);
    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\Polymorph\\PolyMorphTarget.mdl", GetUnitX(KawarimiUnit), GetUnitY(KawarimiUnit)));
}
bool KawarimiBreakCondition(){
    return GetUnitTypeId(GetDyingUnit()) == FourCC("n000");
}
void KawarimiBreakAction(){
int ID = GetPlayerId(GetOwningPlayer(GetDyingUnit()));
    SetUnitInvulnerable(KawarimiTriggerUnitArray[ID], false);
    ShowUnit(KawarimiTriggerUnitArray[ID], true);
    PauseUnit(KawarimiTriggerUnitArray[ID], false);
    CreateNUnitsAtLocACF(1, FourCC("n001"), GetOwningPlayer(KawarimiTriggerUnitArray[ID]), GetUnitLoc(KawarimiTriggerUnitArray[ID]), 270);
    UnitApplyTimedLife(GlobalUnit, FourCC("BOmi"), 1);
    IssueImmediateOrder(GlobalUnit, "stomp");
    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl", GetUnitX(GlobalUnit), GetUnitY(GlobalUnit)));
    if (GetLocalPlayer() == Player(ID)){
        ClearSelection();
        SelectUnit(KawarimiTriggerUnitArray[ID], true);
    }
}
void EnableNotificationAction(){
    DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "|c0000FF00Notifications have been enabled!");
    NotificationEnabledIntArray[GetPlayerId(GetTriggerPlayer())] = 1;
}
void DisableNotificationAction(){
    DisplayTextToPlayer(GetTriggerPlayer(), 0, 0, "|c00ff0000Notifications have been disabled!");
    NotificationEnabledIntArray[GetPlayerId(GetTriggerPlayer())] = 0;
}
void ClearMessagesAction(){
    if (GetLocalPlayer() == GetTriggerPlayer()){
        ClearTextMessages();
    }
}
void ClearAllData(int hid){
    PauseTimer(GetExpiredTimer());
    if (IsUnitPaused(LoadUnitHandle(GameHashTable, hid, iCaster))){
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
        IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
    }
    UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iTarget), 0, 2000);
    UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A04U"));
    SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iCaster), 0, 2000);
    UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04U"));
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
    ShowUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    PauseTimer(LoadTimerHandle(GameHashTable, hid, 105));
    KillUnit(LoadUnitHandle(GameHashTable, hid, 106));
    SetUnitInvulnerable(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
    DestroyEffect(LoadEffectHandle(GameHashTable, hid, 108));
    SetUnitVertexColor(LoadUnitHandle(GameHashTable, hid, iCaster), 255, 255, 255, 255);
    SaveUnitHandle(GameHashTable, hid, 106, nil);
    SaveUnitHandle(GameHashTable, hid, iCaster, nil);
    SaveUnitHandle(GameHashTable, hid, iTarget, nil);
    FlushChildHashtable(GameHashTable, hid);
    DestroyTimer(GetExpiredTimer());
}
bool StopSpell(int hid, int LocType){
    if (LocType == 0){
        if (GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) <= 0){
            ClearAllData(hid);
            return true;
        }
    }
    else {
        if (GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) <= 0 || GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) <= 0){
            ClearAllData(hid);
            return true;
        }
    }
    return false;
}
void ReinforceResetT(int hid){
    StopSound(ReinforceSounds[5], false, false);
    UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04K"));
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04K"));
    KillUnit(LoadUnitHandle(GameHashTable, hid, iTarget));
    ClearAllData(hid);
}
bool CloakOfFlamesDamage(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 30 + 10 * GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster));
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster))) && GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) > 0 && IsUnitInvisible(GetFilterUnit(), Player(ID))){
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
        DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedDamage.mdl", GetFilterUnit(), "chest"));
    }
    return true;
}
void CloakOfFlamesAction(){
int hid = GetHandleId(GetExpiredTimer());
    if (UnitHasItemById(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("I00P"))){
        GroupEnumUnitsInRange(GroupEnum, GetUnitX(LoadUnitHandle(GameHashTable, hid, iCaster)), GetUnitY(LoadUnitHandle(GameHashTable, hid, iCaster)), 300, Filter(@CloakOfFlamesDamage));
    }
    else {
        PauseTimer(GetExpiredTimer());
        FlushChildHashtable(GameHashTable, hid);
        DestroyTimer(GetExpiredTimer());
    }
}
void CloakOfFlamesPickUp(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (CountItemsOfTypeFromUnitRW(GetTriggerUnit(), FourCC("I00P")) == 1){
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        TimerStart(tmr, 1, true, @CloakOfFlamesAction);
    }
    else {
        DestroyTimer(tmr);
    }
}
bool NanayaShikiSpellDFunction1(){
    return GetSpellAbilityId() == FourCC("A02P");
}
void NanayaShikiSpellDFunction2(){
    PlaySoundWithVolumeACF(NanayaShikiSounds[5], 90, 0);
}
bool NanayaShikiSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A02M");
}
bool NanayaShikiSpellQFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 109, GetUnitLoc(GetFilterUnit()));
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 109), LoadLocationHandle(GameHashTable, hid, 103)), 200, .5f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        DestroyEffect(AddSpecialEffect("GeneralEffects\\BloodEffect1.mdx", GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())));
        if (GetUnitAbilityLevel(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("B001")) > 0){
            LocDamage = LocDamage * 1.5f;
            StunUnitACF(GetFilterUnit(), 1);
        }
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
    }
    return true;
}
void NanayaShikiSpellQFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 30){
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) * .5f, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .1f, .01f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(1, FourCC("u00A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 3, 3, 3);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 400, Filter(@NanayaShikiSpellQFunction2));
            UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("B001"));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell throw six");
            ClearAllData(hid);
        }
    }
}
void NanayaShikiSpellQFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell slam one");
        PlaySoundWithVolumeACF(NanayaShikiSounds[0], 100, 0);
        TimerStart(tmr, .01f, true, @NanayaShikiSpellQFunction3);
    }
    else
    {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool NanayaShikiSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A02N");
}
bool NanayaShikiSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
int LocCount = LoadInteger(GameHashTable, hid, 110);
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 5 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.033f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        IssueImmediateOrder(GetFilterUnit(), "stop");
        if (LocCount == 5 || LocCount == 15 || LocCount == 25){
            DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", GetFilterUnit(), "chest"));
        }
        if (LocCount == 29){
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", GetFilterUnit(), "chest"));
        }
        if (GetUnitAbilityLevel(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("B001")) > 0){
            LocDamage = LocDamage * 1.5f;
        }
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
    }
    return true;
}
void NanayaShikiSpellWFunction3(){
int hid = GetHandleId(GetExpiredTimer());
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 110, LoadInteger(GameHashTable, hid, 110) + 1);
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 350, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
        GlobalUnit = CreateUnitAtLoc(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("u00P"), LoadLocationHandle(GameHashTable, hid, 102), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)) + GetRandomReal( - 45, 45));
        SetUnitScale(GlobalUnit, 2, 2, 2);
        SetUnitVertexColor(GlobalUnit, 255, 100, 255, 255);
        GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 350, Filter(@NanayaShikiSpellWFunction2));
        if (LoadInteger(GameHashTable, hid, 110) >= 30){
            UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("B001"));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "stand");
            ClearAllData(hid);
        }
        else {
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
    }
}
void NanayaShikiSpellWFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(NanayaShikiSounds[1], 100, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell two");
        SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
        TimerStart(tmr, .025f, true, @NanayaShikiSpellWFunction3);
    }
    else
    {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool NanayaShikiSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A02O");
}
bool NanayaShikiSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 25 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.5f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
    }
    return true;
}
void NanayaShikiSpellEFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
float LocDamage = 1000 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 100 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SaveInteger(GameHashTable, hid, 0, LocTime + 1);
    if (GetUnitAbilityLevel(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("B001")) > 0){
        if (StopSpell(hid, 0) == false && LocTime < 125){
            if (LocTime == 25){
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 150, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
                SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
                SetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102)));
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell two alternate");
                DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", LoadLocationHandle(GameHashTable, hid, 102)));
                DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", LoadLocationHandle(GameHashTable, hid, 107)));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
            }
            if (LocTime == 50){
                PlaySoundWithVolumeACF(GeneralSounds[1], 60, 0);
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell slam one");
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                SetUnitScaleAndTime(GlobalUnit, 1.5f, 1.5f);
                CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                SetUnitScaleAndTime(GlobalUnit, 2.5f, .7f);
                CreateNUnitsAtLocACF(1, FourCC("u00G"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                SetUnitScaleAndTime(GlobalUnit, 2.f, 2.f);
                CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                SetUnitScale(GlobalUnit, 2, 2, 2);
                while (true) {
                    if (i > 5) break;
                    CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                    SetUnitScale(GlobalUnit, 2, 2, 2);
                    i = i + 1;
                }
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A04U"));
                SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A04U"), false);
                SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iTarget), 800, 4000);
                LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 300, .4f, .01f, false, false, "origin", "");
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            }
            if (LocTime == 75){
                UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04U"));
                SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A04U"), false);
                SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iCaster), 600, 4000);
                PlaySoundWithVolumeACF(NanayaShikiSounds[3], 100, 0);
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 200, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102))));
                PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell throw three");
                SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
                SetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
            }
        }
        if (LocTime == 125){
            LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 25 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.5f;
            PlaySoundWithVolumeACF(NanayaShikiSounds[2], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, 1.5f);
            SetUnitFlyHeight(GlobalUnit, 800, 99999);
            CreateNUnitsAtLocACF(1, FourCC("u00G"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 180);
            SetUnitScaleAndTime(GlobalUnit, 2.5f, 2.f);
            SetUnitFlyHeight(GlobalUnit, 800, 99999);
            SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iTarget), 0, 2000);
            SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iCaster), 0, 99999);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 400, .4f, .01f, false, false, "origin", "");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 150){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            CreateNUnitsAtLocACF(1, FourCC("u00D"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
            SetUnitScale(GlobalUnit, 3, 3, 3);
            i = 1;
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 2.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell throw two");
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 500, Filter(@NanayaShikiSpellEFunction2));
            UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("B001"));
            ClearAllData(hid);
        }
    }
    else {
        if (StopSpell(hid, 0) == false){
            if (LocTime == 50){
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 2);
                SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 300, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
                SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
                SetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                CreateNUnitsAtLocACF(1, FourCC("u00A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 45);
                SetUnitScale(GlobalUnit, 2, 2, 2);
                CreateNUnitsAtLocACF(1, FourCC("u00A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 45);
                SetUnitScale(GlobalUnit, 2, 2, 2);
                PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell throw six");
                DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", LoadLocationHandle(GameHashTable, hid, 102)));
                DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", LoadLocationHandle(GameHashTable, hid, 107)));
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                ClearAllData(hid);
            }
        }
    }
}
void NanayaShikiSpellEFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(NanayaShikiSounds[4], 90, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell slam one");
    TimerStart(tmr, .01f, true, @NanayaShikiSpellEFunction3);
}
bool NanayaShikiSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A02Q");
}
void NanayaShikiSpellRFunction2(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
float LocDamage = 4000 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 300 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 25){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, 1.5f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.5f, .7f);
            CreateNUnitsAtLocACF(1, FourCC("u00L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.f, 2.f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScale(GlobalUnit, 2, 2, 2);
                i = i + 1;
            }
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell throw four");
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102)), 300, 1, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 600, 1, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 125){
            PlaySoundWithVolumeACF(NanayaShikiSounds[7], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, 1.5f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.5f, .7f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell throw five");
            DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 200, 1, .015f, 400);
            i = 1;
            while (true) {
                if (i > 15) break;
                CreateNUnitsAtLocACF(1, FourCC("u00K"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                DisplaceUnitWithArgs(GlobalUnit, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 200, 1 + .1f * I2R(i), .02f, 400);
                UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 1);
                SetUnitAnimation(GlobalUnit, "spell throw five");
                SetUnitVertexColor(GlobalUnit, 255, 255, 255, (255 - (15 * i)));
                i = i + 1;
            }
        }
        if (LocTime == 225){
            PlaySoundWithVolumeACF(GeneralSounds[2], 80, 0);
            PlaySoundWithVolumeACF(NanayaShikiSounds[6], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 150, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell throw six");
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
            SetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 250, .8f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(3, FourCC("u00J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
            i = 1;
            while (true) {
                if (i > 8) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 2.f, GetRandomReal(.5f, 2));
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 2.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            i = 1;
            while (true) {
                if (i > 4) break;
                CreateNUnitsAtLocACF(1, FourCC("u00A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), ((AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))) + Pow( - 1, I2R(i)) * 30));
                SetUnitScaleAndTime(GlobalUnit, 3.f, .5f);
                i = i + 1;
            }
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
        if (LocTime == 305){
            ClearAllData(hid);
        }
    }
}
void NanayaShikiSpellRFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(NanayaShikiSounds[8], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A02P"));
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A02P"));
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 200, .25f, .015f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel one");
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
    TimerStart(tmr, .01f, true, @NanayaShikiSpellRFunction2);
}
bool NanayaShikiSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A02R");
}
void NanayaShikiSpellTFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 6000 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 400 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
int LocTime = LoadInteger(GameHashTable, hid, 0);
bool IsCounted = LoadBoolean(GameHashTable, hid, 10);
    if (StopSpell(hid, 0) == false){
        if (IsCounted == true){
            SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        }
        if (LocTime == 50){
            PlaySoundWithVolumeACF(NanayaShikiSounds[9], 100, 0);
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), .25f);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell one alternate");
        }
        if (LocTime == 90){
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 0);
            CreateNUnitsAtLocACF(1, FourCC("u00N"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SaveUnitHandle(GameHashTable, hid, 106, GlobalUnit);
            SetUnitPathing(GlobalUnit, false);
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            SaveBoolean(GameHashTable, hid, 10, false);
        }
        if (IsCounted == false){
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, 106)));
            SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 107), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107)) * .1f, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 107), LoadLocationHandle(GameHashTable, hid, 103))));
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, 106), LoadLocationHandle(GameHashTable, hid, 109));
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, 106), false);
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, 106), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            if (R2I(DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 109))) <= 75){
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                SaveLocationHandle(GameHashTable, hid, 114, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 150, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102))));
                RemoveUnit(LoadUnitHandle(GameHashTable, hid, 106));
                SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
                UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04U"));
                SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A04U"), false);
                SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iCaster), 200, 99999);
                SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel three");
                SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103));
                CreateNUnitsAtLocACF(1, FourCC("u00M"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 114), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), .8f);
                SetUnitAnimation(GlobalUnit, "spell slam three");
                SetUnitVertexColor(GlobalUnit, 255, 255, 255, 180);
                DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", LoadLocationHandle(GameHashTable, hid, 102)));
                DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", LoadLocationHandle(GameHashTable, hid, 114)));
                DestroyEffect(AddSpecialEffectLoc("GeneralSounds\\BlackBlink.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
                DestroyEffect(AddSpecialEffectLoc("GeneralSounds\\BlackBlink.mdx", LoadLocationHandle(GameHashTable, hid, 114)));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
                SaveBoolean(GameHashTable, hid, 10, true);
            }
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
        }
        if (LocTime == 130){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iCaster), 0, 99999);
            UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04U"));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 114), LoadLocationHandle(GameHashTable, hid, 103)), 300, .4f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(3, FourCC("u00J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
            CreateNUnitsAtLocACF(1, FourCC("u00A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 45);
            SetUnitScale(GlobalUnit, 3, 3, 3);
            CreateNUnitsAtLocACF(1, FourCC("u00A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 3, 3, 3);
            CreateNUnitsAtLocACF(1, FourCC("u00A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 45);
            SetUnitScale(GlobalUnit, 3, 3, 3);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectLoc("GeneralSounds\\26.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell throw six");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 114));
        }
        if (LocTime == 170){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 2);
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
            ClearAllData(hid);
        }
    }
}
void NanayaShikiSpellTFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveBoolean(GameHashTable, hid, 10, true);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A02P"));
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A02P"));
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "stand");
    TimerStart(tmr, .01f, true, @NanayaShikiSpellTFunction2);
}

void HeroInit1()
{
    trigger t;
    NanayaShikiSounds.resize( 10 );
    NanayaShikiSounds[0] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellQ.mp3", false, false, false, 10, 10, "DefaultEAXON");
    NanayaShikiSounds[1] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellW.wav", false, false, false, 10, 10, "DefaultEAXON");
    NanayaShikiSounds[2] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellE2.wav", false, false, false, 10, 10, "DefaultEAXON");
    NanayaShikiSounds[3] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellE1.wav", false, false, false, 10, 10, "DefaultEAXON");
    NanayaShikiSounds[4] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellR2.wav", false, false, false, 10, 10, "DefaultEAXON");
    NanayaShikiSounds[5] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellR1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    NanayaShikiSounds[6] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellD.mp3", false, false, false, 10, 10, "DefaultEAXON");
    NanayaShikiSounds[7] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellT2.wav", false, false, false, 10, 10, "DefaultEAXON");
    NanayaShikiSounds[8] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellT1.wav", false, false, false, 10, 10, "DefaultEAXON");
    NanayaShikiSounds[9] = CreateSound("Characters\\NanayaShiki\\Sounds\\NanayaShikiSpellT3.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@NanayaShikiSpellQFunction1));
    TriggerAddAction(t, @NanayaShikiSpellQFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@NanayaShikiSpellWFunction1));
    TriggerAddAction(t, @NanayaShikiSpellWFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@NanayaShikiSpellEFunction1));
    TriggerAddAction(t, @NanayaShikiSpellEFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@NanayaShikiSpellDFunction1));
    TriggerAddAction(t, @NanayaShikiSpellDFunction2);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@NanayaShikiSpellRFunction1));
    TriggerAddAction(t, @NanayaShikiSpellRFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@NanayaShikiSpellTFunction1));
    TriggerAddAction(t, @NanayaShikiSpellTFunction3);
}
bool ToonoShikiSpellDFunction1(){
    return GetSpellAbilityId() == FourCC("A02X");
}
void ToonoShikiSpellDFunction6(){
    PlaySoundWithVolumeACF(ToonoShikiSounds[0], 100, 0);
}
bool ToonoShikiSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A02U");
}
bool ToonoShikiSpellQFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 109, GetUnitLoc(GetFilterUnit()));
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 109), LoadLocationHandle(GameHashTable, hid, 103)), 200, .5f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        DestroyEffect(AddSpecialEffect("GeneralEffects\\BloodEffect1.mdx", GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())));
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
    }
    return true;
}
void ToonoShikiSpellQFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 30){
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) * .5f, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .1f, .01f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(1, FourCC("u02O"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 3, 3, 3);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 400, Filter(@ToonoShikiSpellQFunction2));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell four");
            ClearAllData(hid);
        }
    }
}
void ToonoShikiSpellQFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell three");
        PlaySoundWithVolumeACF(NanayaShikiSounds[0], 100, 0);
        TimerStart(tmr, .01f, true, @ToonoShikiSpellQFunction3);
    }
    else
    {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool ToonoShikiSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A02V");
}
bool ToonoShikiSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
int LocCount = LoadInteger(GameHashTable, hid, 110);
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 5 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.033f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        IssueImmediateOrder(GetFilterUnit(), "stop");
        if (LocCount == 5 || LocCount == 15 || LocCount == 25){
            DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", GetFilterUnit(), "chest"));
        }
        if (LocCount == 29){
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", GetFilterUnit(), "chest"));
        }
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
    }
    return true;
}
void ToonoShikiSpellWFunction3(){
int hid = GetHandleId(GetExpiredTimer());
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 110, LoadInteger(GameHashTable, hid, 110) + 1);
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 350, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
        GlobalUnit = CreateUnitAtLoc(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("u00P"), LoadLocationHandle(GameHashTable, hid, 102), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)) + GetRandomReal( - 45, 45));
        SetUnitScale(GlobalUnit, 2, 2, 2);
        SetUnitVertexColor(GlobalUnit, 200, 200, 255, 255);
        GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 350, Filter(@ToonoShikiSpellWFunction2));
        if (LoadInteger(GameHashTable, hid, 110) >= 30){
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "stand");
            ClearAllData(hid);
        }
        else {
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
    }
}
void ToonoShikiSpellWFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(ToonoShikiSounds[1], 100, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell two");
        SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
        TimerStart(tmr, .025f, true, @ToonoShikiSpellWFunction3);
    }
    else
    {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool ToonoShikiSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A02W");
}
void ToonoShikiSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
float LocDamage = 500 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 75 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            PlaySoundWithVolumeACF(ToonoShikiSounds[2], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell five");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 70){
            PlaySoundWithVolumeACF(GeneralSounds[2], 60, 0);
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)) - 180, 300, .25f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            CreateNUnitsAtLocACF(1, FourCC("u02O"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), (((AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))) + 45)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            CreateNUnitsAtLocACF(1, FourCC("u02O"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), (((AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))) - 45)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 90){
            ClearAllData(hid);
        }
    }
}
void ToonoShikiSpellEFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ToonoShikiSounds[3], 100, 0);
    SaveInteger(GameHashTable, hid, 0, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2.5f);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel three");
    GlobalUnit = CreateUnit(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("u00E"), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 0);
    SetUnitScaleAndTime(GlobalUnit, 1.5f, 1.5f);
    LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 50, .2f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
    DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", LoadLocationHandle(GameHashTable, hid, 102)));
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
    TimerStart(tmr, .01f, true, @ToonoShikiSpellEFunction2);
}
bool ToonoShikiSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A02Y");
}
bool ToonoShikiSpellRFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 500 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 40 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.50f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
    }
    return true;
}
void ToonoShikiSpellRFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 0;
int LocTime = LoadInteger(GameHashTable, hid, 0);
    SaveInteger(GameHashTable, hid, 0, LocTime + 1);
    if (StopSpell(hid, 0) == false && LocTime < 160){
        if (LocTime == 20){
            LocDamage = 325 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 32.5f + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.20f;
            PlaySoundWithVolumeACF(GeneralSounds[1], 60, 0);
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.25f, 1.5f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.25f, .7f);
            CreateNUnitsAtLocACF(1, FourCC("u00L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, 2.f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScale(GlobalUnit, 1.5f, 1.5f, 1.5f);
                i = i + 1;
            }
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 150, .2f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 40){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel three");
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Orc\\MirrorImage\\MirrorImageCaster.mdl", LoadLocationHandle(GameHashTable, hid, 102)));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 250, .1f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 60){
            PlaySoundWithVolumeACF(ToonoShikiSounds[5], 100, 0);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel one");
        }
        if (LocTime == 110){
            LocDamage = 750 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 60 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.25f;
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 3);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.25f, 1.5f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, .7f);
            CreateNUnitsAtLocACF(1, FourCC("u00G"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, 2.f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            i = 1;
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScale(GlobalUnit, 1.5f, 1.5f, 1.5f);
                i = i + 1;
            }
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04U"));
            SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A04U"), false);
            SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iCaster), 800, 2000);
            UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A04U"));
            SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A04U"), false);
            SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iTarget), 800, 2000);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 200, .4f, .01f, false, false, "origin", "");
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 200, .4f, .01f, false, false, "origin", "");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
    }
    if (LocTime == 160){
        LocDamage = 750 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 60 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.25f;
        PlaySoundWithVolumeACF(ToonoShikiSounds[6], 100, 0);
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
        SetUnitScaleAndTime(GlobalUnit, 1.25f, 1.5f);
        SetUnitFlyHeight(GlobalUnit, 900, 99999);
        CreateNUnitsAtLocACF(1, FourCC("u00G"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 180);
        SetUnitScaleAndTime(GlobalUnit, 1.5f, 2.f);
        SetUnitFlyHeight(GlobalUnit, 900, 99999);
        SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iCaster), 0, 3000);
        UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04U"));
        SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iTarget), 0, 3000);
        UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A04U"));
        LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102)), 200, .25f, .01f, false, false, "origin", "");
        LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 200, .25f, .01f, false, false, "origin", "");
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel four");
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
    }
    if (LocTime == 200){
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
        CreateNUnitsAtLocACF(1, FourCC("u00R"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
        SetUnitScale(GlobalUnit, 2, 2, 2);
        i = 1;
        while (true) {
            if (i > 8) break;
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(0, 360));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, GetRandomReal(.5f, 2));
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
            SetUnitScaleAndTime(GlobalUnit, 2.f, GetRandomReal(.5f, 2));
            i = i + 1;
        }
        GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 600, Filter(@ToonoShikiSpellRFunction2));
        ClearAllData(hid);
    }
}
void ToonoShikiSpellRFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveInteger(GameHashTable, hid, 0, 0);
    PlaySoundWithVolumeACF(ToonoShikiSounds[4], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 250, .1f, .015f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel five");
    TimerStart(tmr, .01f, true, @ToonoShikiSpellRFunction3);
}
bool ToonoShikiSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A02Z");
}
void ToonoShikiSpellTFunction2(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
float LocDamage = 3000 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 300 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 90){
            PlaySoundWithVolumeACF(GeneralSounds[2], 80, 0);
            PlaySoundWithVolumeACF(ToonoShikiSounds[7], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 200, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
            SetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 250, .4f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(3, FourCC("u00J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
            while (true) {
                if (i > 8) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 1.5f, GetRandomReal(.5f, 2));
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 1.5f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            i = 1;
            while (true) {
                if (i > 17) break;
                CreateNUnitsAtLocACF(1, FourCC("u02O"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                DisplaceUnitWithArgs(GlobalUnit, GetUnitFacing(GlobalUnit), GetRandomReal(200, 800), .1f, .01f, 0);
                SetUnitScaleAndTime(GlobalUnit, 2.f, .5f);
                i = i + 1;
            }
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 2);
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
            SaveReal(GameHashTable, hid, 110, 0);
        }
        if (LocTime == 130){
            ClearAllData(hid);
        }
    }
}
void ToonoShikiSpellTFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveInteger(GameHashTable, hid, 0, 0);
    PlaySoundWithVolumeACF(ToonoShikiSounds[3], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell one");
    GlobalUnit = CreateUnit(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("u00E"), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 0);
    SetUnitTimeScale(GlobalUnit, 1.5f);
    GlobalUnit = CreateUnit(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("u00E"), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 0);
    SetUnitScale(GlobalUnit, 1.5f, 1.5f, 1.5f);
    TimerStart(tmr, .01f, true, @ToonoShikiSpellTFunction2);
}

void HeroInit2()
{
    trigger t;

    ToonoShikiSounds.resize( 9 );
    ToonoShikiSounds[0] = CreateSound("Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundV1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ToonoShikiSounds[1] = CreateSound("Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundW1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ToonoShikiSounds[2] = CreateSound("Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundE2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ToonoShikiSounds[3] = CreateSound("Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundE3.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ToonoShikiSounds[4] = CreateSound("Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundR1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ToonoShikiSounds[5] = CreateSound("Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundR2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ToonoShikiSounds[6] = CreateSound("Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundR3.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ToonoShikiSounds[7] = CreateSound("Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundT1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ToonoShikiSounds[8] = CreateSound("Characters\\ToonoShiki\\Sounds\\ToonoShikiSoundT2.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ToonoShikiSpellQFunction1));
    TriggerAddAction(t, @ToonoShikiSpellQFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ToonoShikiSpellWFunction1));
    TriggerAddAction(t, @ToonoShikiSpellWFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ToonoShikiSpellEFunction1));
    TriggerAddAction(t, @ToonoShikiSpellEFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ToonoShikiSpellDFunction1));
    TriggerAddAction(t, @ToonoShikiSpellDFunction6);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ToonoShikiSpellRFunction1));
    TriggerAddAction(t, @ToonoShikiSpellRFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ToonoShikiSpellTFunction1));
    TriggerAddAction(t, @ToonoShikiSpellTFunction3);
}

bool RyougiShikiSpellDFunction1(){
    return GetSpellAbilityId() == FourCC("A035");
}
void RyougiShikiSpellDFunction6(){
    PlaySoundWithVolumeACF(RyougiShikiSounds[0], 60, 0);
}
bool RyougiShikiSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A033");
}
bool RyougiShikiSpellQFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 240 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 80 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
        SaveLocationHandle(GameHashTable, hid, 107, GetUnitLoc(GetFilterUnit()));
        DisplaceUnitWithArgs(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 107)), 300, .5f, .01f, 150);
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 107)));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
    }
    return true;
}
void RyougiShikiSpellQFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            PlaySoundWithVolumeACF(GeneralSounds[0], 50, 0);
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 200, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
            CreateNUnitsAtLocACF(5, FourCC("u00T"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 300, Filter(@RyougiShikiSpellQFunction2));
            ClearAllData(hid);
        }
    }
}
void RyougiShikiSpellQFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(RyougiShikiSounds[2], 80, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel four");
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1.5f);
    TimerStart(tmr, .01f, true, @RyougiShikiSpellQFunction3);
}
bool RyougiShikiSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A032");
}
bool RyougiShikiSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 109, GetUnitLoc(GetFilterUnit()));
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 109)), 150, .2f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 109)));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
    }
    return true;
}
void RyougiShikiSpellWFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 40){
            PlaySoundWithVolumeACF(GeneralSounds[0], 50, 0);
            UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A033"));
            UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A033"));
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 200, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
            CreateNUnitsAtLocACF(5, FourCC("u00T"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)));
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 400, Filter(@RyougiShikiSpellWFunction2));
            ClearAllData(hid);
        }
    }
}
void RyougiShikiSpellWFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(RyougiShikiSounds[1], 100, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
        LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .4f, .01f, false, true, "origin", "");
        SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Channel Slam");
        TimerStart(tmr, .01f, true, @RyougiShikiSpellWFunction3);
    }
    else {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool RyougiShikiSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A034");
}
bool RyougiShikiSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 75 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 109, GetUnitLoc(GetFilterUnit()));
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 109)));
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
    }
    return true;
}
void RyougiShikiSpellEFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 50){
            PlaySoundWithVolumeACF(GeneralSounds[0], 50, 0);
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), (DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) * .5f), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            CreateNUnitsAtLocACF(1, FourCC("u02O"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 3, 3, 3);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 600, Filter(@RyougiShikiSpellEFunction2));
            ClearAllData(hid);
        }
    }
}
void RyougiShikiSpellEFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(RyougiShikiSounds[3], 100, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1.75f);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel two");
        LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .4f, .01f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        TimerStart(tmr, .01f, true, @RyougiShikiSpellEFunction3);
    }
    else {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool RyougiShikiSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A036");
}
void RyougiShikiSpellRFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 1000 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 100 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * .50f;
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 25){
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 100, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel five");
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
            CreateNUnitsAtLocACF(5, FourCC("u00U"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            SetUnitScale(GlobalUnit, 4, 4, 4);
        }
        if (LocTime == 75){
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell slam one");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
        if (LocTime == 135){
            PlaySoundWithVolumeACF(GeneralSounds[0], 50, 0);
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            CreateNUnitsAtLocACF(3, FourCC("u00J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\26.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            ClearAllData(hid);
        }
    }
}
void RyougiShikiSpellRFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveInteger(GameHashTable, hid, 0, 0);
    PlaySoundWithVolumeACF(RyougiShikiSounds[6], 80, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    TimerStart(tmr, .01f, true, @RyougiShikiSpellRFunction2);
}
bool RyougiShikiSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A037");
}
void RyougiShikiSpellTFunction5(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
int LocCount = LoadInteger(GameHashTable, hid, 1);
float LocDamage = 1500 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 150 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.50f;
    if (StopSpell(hid, 1) == false){
        if (LoadBoolean(GameHashTable, hid, 10) == false){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 40, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
            SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103), 0);
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", LoadLocationHandle(GameHashTable, hid, 102)));
            if (R2I(DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107))) <= 600){
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                CreateNUnitsAtLocACF(2, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                SetUnitScale(GlobalUnit, 1.75f, 1.75f, 1.75f);
                PlaySoundWithVolumeACF(RyougiShikiSounds[4], 100, 0);
                SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 250, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
                LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 109)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 109)), .2f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel four");
                SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 109), 0);
                CreateNUnitsAtLocACF(3, FourCC("u02O"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), .5f);
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
                SaveBoolean(GameHashTable, hid, 10, true);
            }
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
        else {
            if (LoadInteger(GameHashTable, hid, 2) < 31){
                SaveInteger(GameHashTable, hid, 1, LocCount + 1);
                if (LocCount == 25){
                    SaveInteger(GameHashTable, hid, 1, 1);
                }
                SaveInteger(GameHashTable, hid, 2, LoadInteger(GameHashTable, hid, 2) + 1);
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                CreateNUnitsAtLocACF(3, FourCC("u02O"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 9 * (LoadInteger(GameHashTable, hid, 2)));
                PlaySoundWithVolumeACF(RyougiShikiSounds[5], 100, 0);
            }
            else {
                SaveInteger(GameHashTable, hid, 0, LocTime + 1);
            }
            if (LoadInteger(GameHashTable, hid, 2) == 30){
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 600, 1.1f, .01f, 250);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell");
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            }
            if (LocTime == 60){
                LocDamage = 1500 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 150 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.50f;
                PlaySoundWithVolumeACF(GeneralSounds[0], 70, 0);
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\26.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                CreateNUnitsAtLocACF(3, FourCC("u00J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                CreateNUnitsAtLocACF(3, FourCC("u02O"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                SetUnitScale(GlobalUnit, 4, 4, 4);
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            }
            if (LocTime == 110){
                ClearAllData(hid);
            }
        }
    }
}
void RyougiShikiSpellTFunction6(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveBoolean(GameHashTable, hid, 10, false);
    SaveInteger(GameHashTable, hid, 0, 1);
    SaveInteger(GameHashTable, hid, 1, 1);
    SaveInteger(GameHashTable, hid, 2, 1);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel three");
    PlaySoundWithVolumeACF(RyougiShikiSounds[0], 100, 0);
    TimerStart(tmr, .01f, true, @RyougiShikiSpellTFunction5);
}
void HeroInit3()
{
    trigger t;

    RyougiShikiSounds.resize( 7 );
    RyougiShikiSounds[0] = CreateSound("Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellDSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    RyougiShikiSounds[1] = CreateSound("Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellQSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    RyougiShikiSounds[2] = CreateSound("Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellWSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    RyougiShikiSounds[3] = CreateSound("Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellESound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    RyougiShikiSounds[4] = CreateSound("Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellRSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    RyougiShikiSounds[5] = CreateSound("Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellRSound2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    RyougiShikiSounds[6] = CreateSound("Characters\\RyougiShiki\\Sounds\\RyougiShikiSpellTSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@RyougiShikiSpellDFunction1));
    TriggerAddAction(t, @RyougiShikiSpellDFunction6);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@RyougiShikiSpellQFunction1));
    TriggerAddAction(t, @RyougiShikiSpellQFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@RyougiShikiSpellWFunction1));
    TriggerAddAction(t, @RyougiShikiSpellWFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@RyougiShikiSpellEFunction1));
    TriggerAddAction(t, @RyougiShikiSpellEFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@RyougiShikiSpellRFunction1));
    TriggerAddAction(t, @RyougiShikiSpellRFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@RyougiShikiSpellTFunction1));
    TriggerAddAction(t, @RyougiShikiSpellTFunction6);
}

bool SaberAlterSpellDFunction1(){
    return GetSpellAbilityId() == FourCC("A03S");
}
bool SaberAlterSpellDFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        DisplaceUnitWithArgs(GetFilterUnit(), AngleBetweenUnits(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit()), 200, .5f, .01f, 400);
    }
    return true;
}
void SaberAlterSpellDFunction3(){
float i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u01P"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
                SetUnitScaleAndTime(GlobalUnit, .2f * i, .6f + .1f * i);
                i = i + 1;
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 102), 400, Filter(@SaberAlterSpellDFunction2));
            ClearAllData(hid);
        }
    }
}
void SaberAlterSpellDFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(SaberAlterSounds[0], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Morph");
    TimerStart(tmr, .01f, true, @SaberAlterSpellDFunction3);
}
bool SaberAlterSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A03T");
}
bool SaberAlterSpellQFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 109, GetUnitLoc(GetFilterUnit()));
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 107), LoadLocationHandle(GameHashTable, hid, 109)), 200, .5f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 109)));
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
    }
    return true;
}
void SaberAlterSpellQFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 10){
            PlaySoundWithVolumeACF(SaberAlterSounds[2], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) * .5f, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .1f, .01f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(1, FourCC("u01Q"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 3, 3, 3);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 400, Filter(@SaberAlterSpellQFunction2));
        }
        if (LocTime == 30){
            ClearAllData(hid);
        }
    }
}
void SaberAlterSpellQFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        SaveInteger(GameHashTable, hid, 0, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1.5f);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Slam");
        PlaySoundWithVolumeACF(SaberAlterSounds[1], 100, 0);
        TimerStart(tmr, .01f, true, @SaberAlterSpellQFunction3);
    }
    else
    {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool SaberAlterSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A03U");
}
bool SaberAlterSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 150 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
    }
    return true;
}
void SaberAlterSpellWFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 40){
            PlaySoundWithVolumeACF(SaberAlterSounds[4], 100, 0);
            PlaySoundWithVolumeACF(SaberAlterSounds[5], 100, 0);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\LightningStrike1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            CreateNUnitsAtLocACF(1, FourCC("u01T"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
            while (true) {
                if (i > 4) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 3.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 300, Filter(@SaberAlterSpellWFunction2));
            ClearAllData(hid);
        }
    }
}
void SaberAlterSpellWFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(SaberAlterSounds[3], 100, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Two");
        CreateNUnitsAtLocACF(1, FourCC("u01T"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
        DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .4f, .01f, 600);
        TimerStart(tmr, .01f, true, @SaberAlterSpellWFunction3);
    }
    else
    {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool SaberAlterSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A03V");
}
bool SaberAlterSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 75 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster))) && IsUnitInGroup(GetFilterUnit(), LoadGroupHandle(GameHashTable, hid, 111)) == false){
        StunUnitACF(GetFilterUnit(), 1);
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        DisplaceUnitWithArgs(GetFilterUnit(), 0, 0, 1, .01f, 400);
        GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 111), GetFilterUnit());
    }
    return true;
}
void SaberAlterSpellEFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
    }
    else {
        RemoveUnit(LoadUnitHandle(GameHashTable, hid, iTarget));
    }
    if (LocTime == 60){
        PlaySoundWithVolumeACF(SaberAlterSounds[7], 100, 0.5f);
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
        IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
    }
    if (LocTime > 60){
        SaveReal(GameHashTable, hid, 110, LoadReal(GameHashTable, hid, 110) + 150);
        SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), LoadReal(GameHashTable, hid, 110), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
        DestroyEffect(AddSpecialEffectLoc("Characters\\SaberAlter\\ShadowBurstBigger.mdx", LoadLocationHandle(GameHashTable, hid, 107)));
        SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iTarget), LoadLocationHandle(GameHashTable, hid, 107));
        GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 300, Filter(@SaberAlterSpellEFunction2));
        if (LoadReal(GameHashTable, hid, 110) >= 1500.f || GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) <= 0){
            RemoveUnit(LoadUnitHandle(GameHashTable, hid, iTarget));
            DestroyGroup(LoadGroupHandle(GameHashTable, hid, 111));
            ClearAllData(hid);
        }
        else {
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
    }
}
void SaberAlterSpellEFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(SaberAlterSounds[6], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
    SaveGroupHandle(GameHashTable, hid, 111, CreateGroup());
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Five");
    CreateNUnitsAtLocACF(1, FourCC("u02H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
    SaveUnitHandle(GameHashTable, hid, iTarget, GlobalUnit);
    TimerStart(tmr, .01f, true, @SaberAlterSpellEFunction3);
}
bool SaberAlterSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A03W");
}
bool SaberAlterSpellRLastSlash(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 30 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.25f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        DisplaceUnitWithArgs(GetFilterUnit(), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)), 300, .35f, .01f, 0);
        DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", GetFilterUnit(), "origin"));
    }
    return true;
}
bool SaberAlterSpellRFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 30 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.25f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        DisplaceUnitWithArgs(GetFilterUnit(), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)), 100, .35f, .01f, 300);
        DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", GetFilterUnit(), "chest"));
    }
    return true;
}
void SaberAlterSpellRFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 10 || LocTime == 50 || LocTime == 90){
            if (LocTime == 50){
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Six");
            }
            else {
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Three");
            }
            PlaySoundWithVolumeACF(SaberAlterSounds[9], 100, 0.50f);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 50, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
            CreateNUnitsAtLocACF(5, FourCC("u01R"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)));
            if (IsTerrainPathable(GetLocationX(LoadLocationHandle(GameHashTable, hid, 103)), GetLocationY(LoadLocationHandle(GameHashTable, hid, 103)), PATHING_TYPE_WALKABILITY) == false){
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
                SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 100, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
                LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)), 100, .4f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 102), 300, Filter(@SaberAlterSpellRFunction2));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 120){
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Slam");
        }
        if (LocTime == 150){
            PlaySoundWithVolumeACF(SaberAlterSounds[9], 100, 0.50f);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 50, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), (DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) * .5f), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            CreateNUnitsAtLocACF(1, FourCC("u01Q"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 3, 3, 3);
            if (IsTerrainPathable(GetLocationX(LoadLocationHandle(GameHashTable, hid, 103)), GetLocationY(LoadLocationHandle(GameHashTable, hid, 103)), PATHING_TYPE_WALKABILITY) == false){
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
                SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 300, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
                LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .2f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 102), 300, Filter(@SaberAlterSpellRLastSlash));
            ClearAllData(hid);
        }
    }
}
void SaberAlterSpellRFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(SaberAlterSounds[8], 100, 0);
    PlaySoundWithVolumeACF(SaberAlterSounds[9], 100, 0.50f);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    TimerStart(tmr, .01f, true, @SaberAlterSpellRFunction3);
}
bool SaberAlterSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A03X");
}
bool SaberAlterSpellTFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 300 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster))) && IsUnitInGroup(GetFilterUnit(), LoadGroupHandle(GameHashTable, hid, 111)) == false){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 111), GetFilterUnit());
    }
    return true;
}
void SaberAlterSpellTFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 100){
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Channel Two");
            PlaySoundWithVolumeACF(SaberAlterSounds[11], 100, 0);
            PlaySoundWithVolumeACF(SaberAlterSounds[12], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            CreateNUnitsAtLocACF(1, FourCC("u01S"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
        }
        if (LocTime >= 100){
            SaveReal(GameHashTable, hid, 110, LoadReal(GameHashTable, hid, 110) + 100);
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), LoadReal(GameHashTable, hid, 110), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            SaveReal(GameHashTable, hid, 112, (LoadReal(GameHashTable, hid, 112) + 1));
            if (LoadReal(GameHashTable, hid, 112) >= 4){
                CreateNUnitsAtLocACF(1, FourCC("u00D"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), GetRandomReal(0, 360));
                SetUnitScale(GlobalUnit, 3, 3, 3);
                SaveReal(GameHashTable, hid, 112, 0);
            }
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 107)));
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 500, Filter(@SaberAlterSpellTFunction2));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
            if (LoadReal(GameHashTable, hid, 110) >= 3000){
                DestroyGroup(LoadGroupHandle(GameHashTable, hid, 111));
                ClearAllData(hid);
            }
        }
    }
}
void SaberAlterSpellTFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveInteger(GameHashTable, hid, 0, 0);
    PlaySoundWithVolumeACF(SaberAlterSounds[10], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
    SaveGroupHandle(GameHashTable, hid, 111, CreateGroup());
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Channel One");
    DestroyEffect(AddSpecialEffectTarget("Characters\\SaberAlter\\ShadowBurst.mdx", LoadUnitHandle(GameHashTable, hid, iCaster), "weapon"));
    CreateNUnitsAtLocACF(5, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
    UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 2);
    SetUnitScale(GlobalUnit, 2, 2, 2);
    CreateNUnitsAtLocACF(2, FourCC("u01T"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
    SetUnitTimeScale(GlobalUnit, .5f);
    UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 2);
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
    TimerStart(tmr, .01f, true, @SaberAlterSpellTFunction3);
}
void HeroInit4()
{
    trigger t;

    SaberAlterSounds.resize( 13 );
    SaberAlterSounds[0] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterC1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[1] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterQ1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[2] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterQ2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[3] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterW1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[4] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterW2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[5] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterW3.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[6] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterE1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[7] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterE2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[8] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterR1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[9] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterR2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[10] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterT1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[11] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterT2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberAlterSounds[12] = CreateSound("Characters\\SaberAlter\\Sounds\\SaberAlterT3.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberAlterSpellDFunction1));
    TriggerAddAction(t, @SaberAlterSpellDFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberAlterSpellQFunction1));
    TriggerAddAction(t, @SaberAlterSpellQFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberAlterSpellWFunction1));
    TriggerAddAction(t, @SaberAlterSpellWFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberAlterSpellEFunction1));
    TriggerAddAction(t, @SaberAlterSpellEFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberAlterSpellRFunction1));
    TriggerAddAction(t, @SaberAlterSpellRFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberAlterSpellTFunction1));
    TriggerAddAction(t, @SaberAlterSpellTFunction4);
}

bool SaberNeroSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A038");
}
bool SaberNeroSpellQFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 109, GetUnitLoc(GetFilterUnit()));
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 109)), 200, .3f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 109)));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
    }
    return true;
}
void SaberNeroSpellQFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 50){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 200, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
            CreateNUnitsAtLocACF(2, FourCC("u00X"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)));
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 400, Filter(@SaberNeroSpellQFunction2));
        }
        if (LocTime == 60){
            ClearAllData(hid);
        }
    }
}
void SaberNeroSpellQFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(SaberNeroSounds[0], 100, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
        LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .5f, .01f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell two");
        SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1.5f);
        TimerStart(tmr, .01f, true, @SaberNeroSpellQFunction3);
    }
    else {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool SaberNeroSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A039");
}
bool SaberNeroSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        StunUnitACF(GetFilterUnit(), 1);
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        SaveLocationHandle(GameHashTable, hid, 113, GetUnitLoc(GetFilterUnit()));
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 113)), 200, .25f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 113));
    }
    return true;
}
void SaberNeroSpellWFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 40){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\LightningStrike1.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
            CreateNUnitsAtLocACF(1, FourCC("u00R"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 270);
            SetUnitScale(GlobalUnit, 4, 4, 4);
            while (true) {
                if (i > 8) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 3.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 102), 450, Filter(@SaberNeroSpellWFunction2));
            ClearAllData(hid);
        }
    }
}
void SaberNeroSpellWFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(SaberNeroSounds[1], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack slam");
    TimerStart(tmr, .01f, true, @SaberNeroSpellWFunction3);
}
bool SaberNeroSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A03A");
}
bool SaberNeroSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
    }
    return true;
}
void SaberNeroSpellEFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 10;
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 35 || LocTime == 70 || LocTime == 105 || LocTime == 140){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            CreateNUnitsAtLocACF(1, FourCC("u019"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\RedAftershock.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 170){
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 200, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
            CreateNUnitsAtLocACF(1, FourCC("u00Y"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
            CreateNUnitsAtLocACF(1, FourCC("u00Z"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            CreateNUnitsAtLocACF(1, FourCC("u010"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            while (true) {
                if (i > 8) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 3.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 400, Filter(@SaberNeroSpellEFunction2));
            ClearAllData(hid);
        }
    }
}
void SaberNeroSpellEFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(SaberNeroSounds[2], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 2);
    LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), (DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 150), .1f, .015f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1.5f);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Three");
    TimerStart(tmr, .01f, true, @SaberNeroSpellEFunction3);
}
bool SaberNeroSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A03B");
}
bool SaberNeroSpellRUnitDrag1(){
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), iCaster)))){
        SetUnitPositionLoc(GetFilterUnit(), LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 107));
    }
    return true;
}
bool SaberNeroSpellRUnitDrag2(){
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), iCaster)))){
        SetUnitPositionLoc(GetFilterUnit(), LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 109));
    }
    return true;
}
bool SaberNeroSpellRFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 2000 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 125 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 2);
        DisplaceUnitWithArgs(GetFilterUnit(), AngleBetweenUnits(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit()), 1000, 1, .01f, 1000);
    }
    return true;
}
void SaberNeroSpellRFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime < 80){
            SaveReal(GameHashTable, hid, 110, LoadReal(GameHashTable, hid, 110) - 10);
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), LoadReal(GameHashTable, hid, 110), LoadReal(GameHashTable, hid, 110)));
            SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), LoadReal(GameHashTable, hid, 110), LoadReal(GameHashTable, hid, 110) + 180));
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 300, Filter(@SaberNeroSpellRUnitDrag1));
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 109), 300, Filter(@SaberNeroSpellRUnitDrag2));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", LoadLocationHandle(GameHashTable, hid, 107)));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Other\\Doom\\DoomDeath.mdl", LoadLocationHandle(GameHashTable, hid, 109)));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
        }
        if (LocTime == 80){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel one");
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) / 3, 1, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        }
        if (LocTime == 130){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), (DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) * .6f), .6f, .01f, 600);
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack slam");
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.f, 2.f);
            CreateNUnitsAtLocACF(1, FourCC("u01B"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
        }
        if (LocTime == 185){
            CreateNUnitsAtLocACF(1, FourCC("u00R"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
            SetUnitScale(GlobalUnit, 6, 6, 6);
            while (true) {
                if (i > 8) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 5.f, .6f);
                i = i + 1;
            }
            i = 1;
            while (true) {
                if (i > 12) break;
                SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 200, 30 * I2R(i)));
                CreateNUnitsAtLocACF(1, FourCC("u01A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), 0);
                UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 1);
                SetUnitAnimation(GlobalUnit, "birth");
                SetUnitVertexColor(GlobalUnit, 255, 100, 0, 255);
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
                SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 400, 30 * I2R(i)));
                CreateNUnitsAtLocACF(1, FourCC("u01A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), 0);
                UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 1);
                SetUnitAnimation(GlobalUnit, "birth");
                SetUnitVertexColor(GlobalUnit, 255, 100, 0, 255);
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
                SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 600, 30 * I2R(i)));
                CreateNUnitsAtLocACF(1, FourCC("u01A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), 0);
                UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 1);
                SetUnitAnimation(GlobalUnit, "birth");
                SetUnitVertexColor(GlobalUnit, 255, 100, 0, 255);
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
                i = i + 1;
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 800, Filter(@SaberNeroSpellRFunction2));
            ClearAllData(hid);
        }
    }
}
void SaberNeroSpellRFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(SaberNeroSounds[3], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
    SaveReal(GameHashTable, hid, 110, 800);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell One");
    TimerStart(tmr, .01f, true, @SaberNeroSpellRFunction3);
}
bool SaberNeroSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A03C");
}
void SaberNeroSpellTFunction2(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
bool IsCounted = LoadBoolean(GameHashTable, hid, 10);
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 20;
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 1) == false){
        if (IsCounted == false){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 50, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
            SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103), 0);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Fly Slam");
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\RedAftershock.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
            if (R2I(DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107))) <= 250){
                PlaySoundWithVolumeACF(SaberNeroSounds[4], 100, 0);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Three");
                SaveBoolean(GameHashTable, hid, 10, true);
            }
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
        else {
            SaveInteger(GameHashTable, hid, 0, LocTime + 1);
            if (LocTime == 30 || LocTime == 60 || LocTime == 90 || LocTime == 120){
                SaveReal(GameHashTable, hid, 110, LoadReal(GameHashTable, hid, 110) + 1);
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
                CreateNUnitsAtLocACF(1, FourCC("u019"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\RedAftershock.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
                RemoveLocation(LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 103));
            }
            if (LocTime == 170){
                SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\LightningStrike1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                while (true) {
                    if (i > 8) break;
                    CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                    SetUnitScaleAndTime(GlobalUnit, 3.f, GetRandomReal(.5f, 2));
                    i = i + 1;
                }
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iTarget), 0, 0, .9f, .01f, 600);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Five");
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            }
            if (LocTime == 250){
                PlaySoundWithVolumeACF(GeneralSounds[1], 60, 0);
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell One");
                PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                i = 1;
                while (true) {
                    if (i > 10) break;
                    CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(0, 360));
                    SetUnitScaleAndTime(GlobalUnit, 3.f, 1.5f);
                    i = i + 1;
                }
                CreateNUnitsAtLocACF(3, FourCC("u00X"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)));
                CreateNUnitsAtLocACF(1, FourCC("u01B"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 500, 1, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            }
            if (LocTime == 330){
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Attack Slam");
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                SetUnitScaleAndTime(GlobalUnit, 2.f, .8f);
                CreateNUnitsAtLocACF(1, FourCC("u01B"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
                i = 1;
                while (true) {
                    if (i > 5) break;
                    CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(0, 360));
                    SetUnitScaleAndTime(GlobalUnit, 2.f, .8f);
                    i = i + 1;
                }
                DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 950, .8f, .01f, 600);
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            }
            if (LocTime == 410){
                LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 180 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                PlaySoundWithVolumeACF(GeneralSounds[2], 80, 0);
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                CreateNUnitsAtLocACF(1, FourCC("u00R"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
                SetUnitScale(GlobalUnit, 4, 4, 4);
                i = 1;
                while (true) {
                    if (i > 10) break;
                    CreateNUnitsAtLocACF(1, FourCC("u01C"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 36.f * I2R(i));
                    SetUnitScaleAndTime(GlobalUnit, .5f * I2R(i), 1.5f - .1f * I2R(i));
                    SetUnitVertexColor(GlobalUnit, 255, 100, 0, 255);
                    i = i + 1;
                }
                i = 1;
                while (true) {
                    if (i > 10) break;
                    CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                    SetUnitScaleAndTime(GlobalUnit, 3.f, 1.5f);
                    i = i + 1;
                }
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\26.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
                ClearAllData(hid);
            }
        }
    }
}
void SaberNeroSpellTFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveBoolean(GameHashTable, hid, 10, false);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1.5f);
    SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    TimerStart(tmr, .01f, true, @SaberNeroSpellTFunction2);
}
void HeroInit5()
{
    trigger t;

    SaberNeroSounds.resize( 5 );
    SaberNeroSounds[0] = CreateSound("Characters\\SaberNero\\Sounds\\SaberNeroSoundQ1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberNeroSounds[1] = CreateSound("Characters\\SaberNero\\Sounds\\SaberNeroSoundW1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberNeroSounds[2] = CreateSound("Characters\\SaberNero\\Sounds\\SaberNeroSoundE1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberNeroSounds[3] = CreateSound("Characters\\SaberNero\\Sounds\\SaberNeroSoundR2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    SaberNeroSounds[4] = CreateSound("Characters\\SaberNero\\Sounds\\SaberNeroSoundT1.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberNeroSpellQFunction1));
    TriggerAddAction(t, @SaberNeroSpellQFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberNeroSpellWFunction1));
    TriggerAddAction(t, @SaberNeroSpellWFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberNeroSpellEFunction1));
    TriggerAddAction(t, @SaberNeroSpellEFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberNeroSpellRFunction1));
    TriggerAddAction(t, @SaberNeroSpellRFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@SaberNeroSpellTFunction1));
    TriggerAddAction(t, @SaberNeroSpellTFunction3);
}
bool KuchikiByakuyaSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A03E");
}
bool KuchikiByakuyaSpellQFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster))) && IsUnitInGroup(GetFilterUnit(), LoadGroupHandle(GameHashTable, hid, 111)) == false){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 111), GetFilterUnit());
    }
    return true;
}
void KuchikiByakuyaSpellQFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
float LocDistance = LoadReal(GameHashTable, hid, 30);
float LocFacing = LoadReal(GameHashTable, hid, 31);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 25){
            PlaySoundWithVolumeACF(KuchikiByakuyaSounds[1], 90, 0);
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
        }
        if (LocTime > 25){
            if (IsUnitType(LoadUnitHandle(GameHashTable, hid, 106), UNIT_TYPE_DEAD) != true){
                SaveLocationHandle(GameHashTable, hid, 115, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, 106)));
                SaveLocationHandle(GameHashTable, hid, 116, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 115), 20, LocFacing));
                SaveReal(GameHashTable, hid, 30, LocDistance - 25);
                SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, 106), LoadLocationHandle(GameHashTable, hid, 116));
                GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 115), 250, Filter(@KuchikiByakuyaSpellQFunction2));
                if (LocDistance <= 25){
                    KillUnit(LoadUnitHandle(GameHashTable, hid, 106));
                }
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 115));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 116));
            }
            else {
                DestroyGroup(LoadGroupHandle(GameHashTable, hid, 111));
                ClearAllData(hid);
            }
        }
    }
    else {
        DestroyGroup(LoadGroupHandle(GameHashTable, hid, 111));
    }
}
void KuchikiByakuyaSpellQFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(KuchikiByakuyaSounds[2], 90, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
    SaveGroupHandle(GameHashTable, hid, 111, CreateGroup());
    SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 150, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
    SaveReal(GameHashTable, hid, 30, 1250);
    SaveReal(GameHashTable, hid, 31, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
    CreateNUnitsAtLocACF(1, FourCC("u01E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 107), LoadLocationHandle(GameHashTable, hid, 103)));
    SetUnitPathing(LoadUnitHandle(GameHashTable, hid, 106), false);
    SaveUnitHandle(GameHashTable, hid, 106, GlobalUnit);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell");
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
    TimerStart(tmr, .01f, true, @KuchikiByakuyaSpellQFunction3);
}
bool KuchikiByakuyaSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A03D");
}
void KuchikiByakuyaSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
float LocDamage = 245 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 65 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 5 || LocTime == 10 || LocTime == 15 || LocTime == 20 || LocTime == 25 || LocTime == 30 || LocTime == 35 || LocTime == 40){
            SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 100, 45 * (LocTime / 5)));
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iTarget), LoadLocationHandle(GameHashTable, hid, 102));
            CreateNUnitsAtLocACF(1, FourCC("u01D"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102)));
            UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), .9f - I2R(LocTime * 2) / 100);
            SetUnitScale(GlobalUnit, 3, 3, 3);
            SetUnitFlyHeight(GlobalUnit, 200, 20000);
        }
        if (LocTime == 50){
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            CreateNUnitsAtLocACF(1, FourCC("u01E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
            SetUnitPathing(GlobalUnit, false);
            UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), .5f);
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "origin"));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Deadspirit Asuna.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
        }
        if (LocTime == 80){
            ClearAllData(hid);
        }
    }
}
void KuchikiByakuyaSpellWFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(KuchikiByakuyaSounds[3], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel one");
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
    TimerStart(tmr, .01f, true, @KuchikiByakuyaSpellWFunction2);
}
bool KuchikiByakuyaSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A03G");
}
bool KuchikiByakuyaSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 3 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.05f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", GetFilterUnit(), "chest"));
        GlobalUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC("u02T"), GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit()), 0);
        UnitShareVision(GetFilterUnit(), Player(PLAYER_NEUTRAL_PASSIVE), true);
        IssueTargetOrder(GlobalUnit, "slow", GetFilterUnit());
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
    }
    return true;
}
bool KuchikiByakuyaSpellEFunctionFinalDamage1(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 40 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.50f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", GetFilterUnit(), "chest"));
        StunUnitACF(GetFilterUnit(), 1);
        SaveLocationHandle(GameHashTable, hid, 107, GetUnitLoc(GetFilterUnit()));
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107)), 300, .5f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
    }
    return true;
}
void KuchikiByakuyaSpellEFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20 || LocTime == 40 || LocTime == 60 || LocTime == 80 || LocTime == 100 || LocTime == 120 || LocTime == 140 || LocTime == 160 || LocTime == 180 || LocTime == 200){
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 450, Filter(@KuchikiByakuyaSpellEFunction2));
        }
        if (LocTime == 200){
            CreateNUnitsAtLocACF(1, FourCC("u01H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            SetUnitScaleAndTime(GlobalUnit, 2.f, .8f);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            CreateNUnitsAtLocACF(1, FourCC("u01I"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), .5f);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 450, Filter(@KuchikiByakuyaSpellEFunctionFinalDamage1));
            ClearAllData(hid);
        }
    }
}
void KuchikiByakuyaSpellEFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(KuchikiByakuyaSounds[4], 90, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Slam");
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    CreateNUnitsAtLocACF(1, FourCC("u01J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 360);
    UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 2);
    CreateNUnitsAtLocACF(1, FourCC("u01J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 360);
    UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 2);
    CreateNUnitsAtLocACF(1, FourCC("u01J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 360);
    UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 2);
    CreateNUnitsAtLocACF(1, FourCC("u01J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 360);
    UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 2);
    CreateNUnitsAtLocACF(1, FourCC("u01J"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 360);
    UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 2);
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
    TimerStart(tmr, .01f, true, @KuchikiByakuyaSpellEFunction3);
}
bool KuchikiByakuyaSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A03H");
}
void KuchikiByakuyaSpellRKillDummy(){
    KillUnit(GetEnumUnit());
}
void KuchikiByakuyaSpellRCreateSFX(){
int hid = GetHandleId(GetExpiredTimer());
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    SaveLocationHandle(GameHashTable, hid, 117, GetUnitLoc(GetEnumUnit()));
    CreateNUnitsAtLocACF(1, FourCC("u01I"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 117), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 90);
    UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 1.5f);
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 117));
}
void KuchikiByakuyaSpellRTransparency(){
    SetUnitVertexColor(GetEnumUnit(), 255, 255, 255, 255 - R2I(LoadReal(GameHashTable, GetHandleId(GetExpiredTimer()), 118)));
}
void KuchikiByakuyaSpellRFunction2(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
bool IsCounted = LoadBoolean(GameHashTable, hid, 10);
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 4 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.02f;
float LocCount = LoadReal(GameHashTable, hid, 1);
    if (StopSpell(hid, 0) == false){
        if (IsCounted == true){
            SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        }
        else {
            SaveReal(GameHashTable, hid, 118, LoadReal(GameHashTable, hid, 118) + 7);
            ForGroup(LoadGroupHandle(GameHashTable, hid, 119), @KuchikiByakuyaSpellRTransparency);
            if (LoadReal(GameHashTable, hid, 118) >= 255){
                SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                ForGroup(LoadGroupHandle(GameHashTable, hid, 119), @KuchikiByakuyaSpellRKillDummy);
                CreateNUnitsAtLocACF(1, FourCC("u01L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
                SetUnitTimeScale(GlobalUnit, 3);
                SaveUnitHandle(GameHashTable, hid, 106, GlobalUnit);
                SaveBoolean(GameHashTable, hid, 10, true);
            }
        }
        if (LocTime == 30){
            PlaySoundWithVolumeACF(KuchikiByakuyaSounds[6], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 50, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            CreateNUnitsAtLocACF(1, FourCC("u02S"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
            SetUnitAnimation(GlobalUnit, "Morph Alternate");
            SetUnitTimeScale(GlobalUnit, .75f);
            UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 1.5f);
            SaveReal(GameHashTable, hid, 110, 0);
        }
        if (LocTime == 130){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 500, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 90));
            SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 500, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 90));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
            CreateNUnitsAtLocACF(1, FourCC("u01M"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 90);
            GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 119), GlobalUnit);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 107)));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", LoadLocationHandle(GameHashTable, hid, 107)));
            CreateNUnitsAtLocACF(1, FourCC("u01M"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 109), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 90);
            GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 119), GlobalUnit);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 109)));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", LoadLocationHandle(GameHashTable, hid, 109)));
        }
        if (LocTime == 140 || LocTime == 150 || LocTime == 160 || LocTime == 170){
            SaveReal(GameHashTable, hid, 110, LoadReal(GameHashTable, hid, 110) + 1);
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 115, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 107), 300 * LoadReal(GameHashTable, hid, 110), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            SaveLocationHandle(GameHashTable, hid, 116, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 109), 300 * LoadReal(GameHashTable, hid, 110), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            SaveLocationHandle(GameHashTable, hid, 120, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 107), 300 * LoadReal(GameHashTable, hid, 110), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102))));
            SaveLocationHandle(GameHashTable, hid, 121, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 109), 300 * LoadReal(GameHashTable, hid, 110), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102))));
            CreateNUnitsAtLocACF(1, FourCC("u01M"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 115), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 90);
            GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 119), GlobalUnit);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 115)));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", LoadLocationHandle(GameHashTable, hid, 115)));
            CreateNUnitsAtLocACF(1, FourCC("u01M"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 116), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 90);
            GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 119), GlobalUnit);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 116)));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", LoadLocationHandle(GameHashTable, hid, 116)));
            CreateNUnitsAtLocACF(1, FourCC("u01M"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 120), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 90);
            GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 119), GlobalUnit);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 120)));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", LoadLocationHandle(GameHashTable, hid, 120)));
            CreateNUnitsAtLocACF(1, FourCC("u01M"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 121), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 90);
            GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 119), GlobalUnit);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 121)));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Items\\AIil\\AIilTarget.mdl", LoadLocationHandle(GameHashTable, hid, 121)));
            if (LocTime == 170){
                PlaySoundWithVolumeACF(KuchikiByakuyaSounds[5], 100, 0);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell two");
                ForGroup(LoadGroupHandle(GameHashTable, hid, 119), @KuchikiByakuyaSpellRCreateSFX);
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
                SaveReal(GameHashTable, hid, 110, 0);
                SaveBoolean(GameHashTable, hid, 10, false);
            }
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 115));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 116));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 120));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 121));
        }
        if (LocTime == 250){
            PlaySoundWithVolumeACF(KuchikiByakuyaSounds[4], 100, 0);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), iCaster), "spell channel one");
            SetUnitFacing(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 106), GetUnitFacing(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 106)) + 1.5f);
        }
        if (LocTime >= 250 && LocTime <= 400){
            SaveReal(GameHashTable, hid, 1, LocCount + 1);
            if (LocCount == 2){
                SaveReal(GameHashTable, hid, 1, 0);
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                while (true) {
                    if (i > 4) break;
                    SaveLocationHandle(GameHashTable, hid, 122, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 1600, GetRandomReal(0, 360)));
                    CreateNUnitsAtLocACF(1, FourCC("u01K"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 122), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 122), LoadLocationHandle(GameHashTable, hid, 103)));
                    UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), .5f);
                    SetUnitFlyHeight(GlobalUnit, 250, 99999);
                    SetUnitScale(GlobalUnit, 3, 3, 3);
                    DisplaceUnitWithArgs(GlobalUnit, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 122), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 122), LoadLocationHandle(GameHashTable, hid, 103)) - 50, .4f, .01f, 0);
                    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 122));
                    i = i + 1;
                }
            }
        }
        if (LocTime == 400){
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            PlaySoundWithVolumeACF(KuchikiByakuyaSounds[2], 100, 0);
            DestroyGroup(LoadGroupHandle(GameHashTable, hid, 119));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Deadspirit Asuna.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            ClearAllData(hid);
        }
    }
    else {
        ForGroup(LoadGroupHandle(GameHashTable, hid, 119), @KuchikiByakuyaSpellRKillDummy);
        DestroyGroup(LoadGroupHandle(GameHashTable, hid, 119));
    }
}
void KuchikiByakuyaSpellRFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveBoolean(GameHashTable, hid, 10, true);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    SaveGroupHandle(GameHashTable, hid, 119, CreateGroup());
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "morph");
    SaveLocationHandle(GameHashTable, hid, iCaster, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, 102)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    TimerStart(tmr, .01f, true, @KuchikiByakuyaSpellRFunction2);
}
bool KuchikiByakuyaSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A03I");
}
void KuchikiByakuyaSpellTFunction2(){
float i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
float LocDamage = 3000 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 300 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 40){
            PlaySoundWithVolumeACF(GeneralSounds[1], 60, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 2.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            CreateNUnitsAtLocACF(1, FourCC("u01B"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\QQQQQ.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 2);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 400, .4f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 80){
            PlaySoundWithVolumeACF(KuchikiByakuyaSounds[8], 100, 0);
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell three");
        }
        if (LocTime == 120){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell four");
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.f, .8f);
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), (DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 400), .5f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 170){
            PlaySoundWithVolumeACF(KuchikiByakuyaSounds[7], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell one");
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.f, .8f);
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 180){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            CreateNUnitsAtLocACF(2, FourCC("u00U"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 4, 4, 4);
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\QQQQQ.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            CreateNUnitsAtLocACF(1, FourCC("u01I"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), .5f);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 400, .6f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 250){
            PlaySoundWithVolumeACF(GeneralSounds[0], 60, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            i = 1;
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u01H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
                SetUnitScaleAndTime(GlobalUnit, .5f * i, .3f + i);
                i = i + 1;
            }
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Spark_Pink.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\Deadspirit Asuna.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "origin"));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\26.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            CreateNUnitsAtLocACF(1, FourCC("u01I"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), .5f);
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            ClearAllData(hid);
        }
    }
}
void KuchikiByakuyaSpellTFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(KuchikiByakuyaSounds[9], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Attack Alternate One");
    TimerStart(tmr, .01f, true, @KuchikiByakuyaSpellTFunction2);
}
void HeroInit6()
{
    trigger t;

    KuchikiByakuyaSounds.resize( 10 );
    KuchikiByakuyaSounds[0] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellDSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    KuchikiByakuyaSounds[1] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellQSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    KuchikiByakuyaSounds[2] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellQSound2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    KuchikiByakuyaSounds[3] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellWSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    KuchikiByakuyaSounds[4] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellESound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    KuchikiByakuyaSounds[5] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellRSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    KuchikiByakuyaSounds[6] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellRSound2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    KuchikiByakuyaSounds[7] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellTSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    KuchikiByakuyaSounds[8] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellTSound2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    KuchikiByakuyaSounds[9] = CreateSound("Characters\\KuchikiByakuya\\Sounds\\KuchikiByakuyaSpellTSound3.mp3", false, false, false, 10, 10, "DefaultEAXON");
    
    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@KuchikiByakuyaSpellWFunction1));
    TriggerAddAction(t, @KuchikiByakuyaSpellWFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@KuchikiByakuyaSpellQFunction1));
    TriggerAddAction(t, @KuchikiByakuyaSpellQFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@KuchikiByakuyaSpellEFunction1));
    TriggerAddAction(t, @KuchikiByakuyaSpellEFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@KuchikiByakuyaSpellRFunction1));
    TriggerAddAction(t, @KuchikiByakuyaSpellRFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@KuchikiByakuyaSpellTFunction1));
    TriggerAddAction(t, @KuchikiByakuyaSpellTFunction3);
}

bool AkameSpellDFunction1(){
    return GetSpellAbilityId() == FourCC("A03K") || GetSpellAbilityId() == FourCC("A052");
}
void AkameSpellDFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadReal(GameHashTable, hid, 0), .2f, .01f, 0);
        }
        if (LocTime == 30){
            ClearAllData(hid);
        }
    }
}
void AkameSpellDFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
float LocDistance = - 400;
    if (GetSpellAbilityId() == FourCC("A052")){
        LocDistance = - 350;
        SetPlayerAbilityAvailable(GetOwningPlayer(GetTriggerUnit()), FourCC("A03L"), true);
        SetPlayerAbilityAvailable(GetOwningPlayer(GetTriggerUnit()), FourCC("A052"), false);
    }
    PlaySoundWithVolumeACF(AkameSounds[0], 80, 0);
    SetUnitTimeScale(GetTriggerUnit(), 2);
    SetUnitFacing(GetTriggerUnit(), AngleBetweenPointsRW(GetUnitLoc(GetTriggerUnit()), GetSpellTargetLoc()));
    PauseUnit(GetTriggerUnit(), true);
    SetUnitInvulnerable(GetTriggerUnit(), true);
    SetUnitAnimation(GetTriggerUnit(), "spell two");
    SaveReal(GameHashTable, hid, 0, LocDistance);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    TimerStart(tmr, .01f, true, @AkameSpellDFunction2);
}
bool AkameSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A03L");
}
bool AkameSpellQFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DestroyEffect(AddSpecialEffect("GeneralEffects\\BloodEffect1.mdx", GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit())));
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
    }
    return true;
}
void AkameSpellQFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A03L"), false);
            SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A052"), true);
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            PlaySoundWithVolumeACF(AkameSounds[1], 60, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 200, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
            CreateNUnitsAtLocACF(3, FourCC("u02P"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 30);
            SetUnitScaleAndTime(GlobalUnit, 1.5f, .8f);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 400, Filter(@AkameSpellQFunction2));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
        }
        if (LocTime == 220){
            SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A03L"), true);
            SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A052"), false);
            ClearAllData(hid);
        }
    }
}
void AkameSpellQFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Four");
    TimerStart(tmr, .01f, true, @AkameSpellQFunction3);
}
bool AkameSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A03M");
}
void AkameSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 200 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 100 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 110, LoadInteger(GameHashTable, hid, 110) - 10);
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
        SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) / 20, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
        SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
        SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103), 0);
        SetUnitVertexColor(LoadUnitHandle(GameHashTable, hid, iCaster), 255, 255, 255, LoadInteger(GameHashTable, hid, 110));
        if (R2I(DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107))) <= 150){
            PlaySoundWithVolumeACF(AkameSounds[2], 90, 0);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            CreateNUnitsAtLocACF(5, FourCC("u00T"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack");
            ClearAllData(hid);
        }
        else {
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
    }
}
void AkameSpellWFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Channel");
    SaveInteger(GameHashTable, hid, 110, 255);
    SaveEffectHandle(GameHashTable, hid, 108, AddSpecialEffectTarget("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", LoadUnitHandle(GameHashTable, hid, iCaster), "weapon"));
    DestroyEffect(AddSpecialEffect("GeneralEffects\\BlackBlink.mdx", GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit())));
    TimerStart(tmr, .01f, true, @AkameSpellWFunction2);
}
bool AkameSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A03N");
}
bool AkameSpellEFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 300 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 109, GetUnitLoc(GetFilterUnit()));
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 109), LoadLocationHandle(GameHashTable, hid, 103)), 200, .5f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 109)));
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
    }
    return true;
}
void AkameSpellEFunction4(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 30){
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) * .5f, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .1f, .01f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(1, FourCC("u02P"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 3, 3, 3);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 450, Filter(@AkameSpellEFunction3));
            ClearAllData(hid);
        }
    }
}
void AkameSpellEFunction5(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Four");
        PlaySoundWithVolumeACF(AkameSounds[3], 100, 0);
        TimerStart(tmr, .01f, true, @AkameSpellEFunction4);
    }
    else {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool AkameSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A03O");
}
void AkameSpellRFunction10(){
float LocDamage;
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
int LocTime = LoadInteger(GameHashTable, hid, 0);
int LocCount = LoadInteger(GameHashTable, hid, 1);
bool IsCounted = LoadBoolean(GameHashTable, hid, 10);
    if (StopSpell(hid, 1) == false){
        if (IsCounted == true){
            SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        }
        else {
            SaveInteger(GameHashTable, hid, 1, LocCount + 1);
        }
        if (LocTime == 40){
            LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 30;
            PlaySoundWithVolumeACF(AkameSounds[0], 80, 0);
            PlaySoundWithVolumeACF(GeneralSounds[1], 60, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 2.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            CreateNUnitsAtLocACF(1, FourCC("u01B"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\QQQQQ.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 400, .5f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell two");
            DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102)), 400, 1, .01f, 0);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 140){
            SaveBoolean(GameHashTable, hid, 10, false);
            PlaySoundWithVolumeACF(AkameSounds[5], 80, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BlackBlink.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
            ShowUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
        }
        if (IsCounted == false){
            if (LocCount == 2){
                SaveInteger(GameHashTable, hid, 1, 1);
                SaveReal(GameHashTable, hid, 110, LoadReal(GameHashTable, hid, 110) + 1);
                if (LoadReal(GameHashTable, hid, 110) < 20){
                    LocDamage = 25 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster));
                    DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
                    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                    if (LoadReal(GameHashTable, hid, 110) < 16){
                        DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
                        SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 150, LoadReal(GameHashTable, hid, 110) * 24));
                    }
                    DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BlackBlink.mdx", LoadLocationHandle(GameHashTable, hid, 107)));
                    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
                    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
                }
                else {
                    SaveBoolean(GameHashTable, hid, 10, true);
                    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
                    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
                    SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 500, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102))));
                    ShowUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                    if (GetLocalPlayer() == GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster))){
                        ClearSelection();
                        SelectUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                    }
                    SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
                    SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103), 0);
                    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), .1f);
                    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack");
                    DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BlackBlink.mdx", LoadLocationHandle(GameHashTable, hid, 107)));
                    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
                    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
                    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
                    SaveEffectHandle(GameHashTable, hid, 108, AddSpecialEffectTarget("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", LoadUnitHandle(GameHashTable, hid, iCaster), "weapon"));
                }
            }
        }
        if (LocTime == 190){
            PlaySoundWithVolumeACF(AkameSounds[2], 90, 0);
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
        }
        if (LocTime == 210){
            PlaySoundWithVolumeACF(AkameSounds[4], 90, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 500, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 200, .2f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(3, FourCC("u02P"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 4, 4, 4);
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "origin"));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 260){
            LocDamage = 500 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            PlaySoundWithVolumeACF(GeneralSounds[0], 60, 0);
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\26.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(LoadEffectHandle(GameHashTable, hid, 108));
            ClearAllData(hid);
        }
    }
}
void AkameSpellRFunction11(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveBoolean(GameHashTable, hid, 10, true);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 150, .6f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell three");
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
    TimerStart(tmr, .01f, true, @AkameSpellRFunction10);
}
bool AkameSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A03P");
}
void AkameSpellTFunction2(){
float i = 1;
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
int LocTime = LoadInteger(GameHashTable, hid, 0);
float LocDamage;
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 50){
            LocDamage = 500 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50;
            PlaySoundWithVolumeACF(GeneralSounds[1], 60, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 2.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            CreateNUnitsAtLocACF(1, FourCC("u01B"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2, 2, 2);
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\QQQQQ.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 600, 1, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 75){
            PlaySoundWithVolumeACF(AkameSounds[6], 80, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 600, .8f, .01f, 400);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 155){
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1.75f);
            PlaySoundWithVolumeACF(AkameSounds[1], 80, 0);
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 205){
            LocDamage = 1000 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 100 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            PlaySoundWithVolumeACF(GeneralSounds[0], 60, 0);
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\26.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            ClearAllData(hid);
        }
    }
}
void AkameSpellTFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 150, .6f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell three");
    StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 2);
    SaveEffectHandle(GameHashTable, hid, 108, AddSpecialEffectTarget("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", LoadUnitHandle(GameHashTable, hid, iCaster), "weapon"));
    TimerStart(tmr, .01f, true, @AkameSpellTFunction2);
}
void HeroInit7()
{
    trigger t;

    AkameSounds.resize( 7 );
    AkameSounds[0] = CreateSound("Characters\\Akame\\Sounds\\AkameSpellDSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkameSounds[1] = CreateSound("Characters\\Akame\\Sounds\\AkameSpellQSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkameSounds[2] = CreateSound("Characters\\Akame\\Sounds\\AkameSpellWSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkameSounds[3] = CreateSound("Characters\\Akame\\Sounds\\AkameSpellESound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkameSounds[4] = CreateSound("Characters\\Akame\\Sounds\\AkameSpellRSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkameSounds[5] = CreateSound("Characters\\Akame\\Sounds\\AkameSpellRSound2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkameSounds[6] = CreateSound("Characters\\Akame\\Sounds\\AkameSpellTSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkameSpellDFunction1));
    TriggerAddAction(t, @AkameSpellDFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkameSpellQFunction1));
    TriggerAddAction(t, @AkameSpellQFunction4);
    
    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkameSpellWFunction1));
    TriggerAddAction(t, @AkameSpellWFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkameSpellEFunction1));
    TriggerAddAction(t, @AkameSpellEFunction5);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkameSpellRFunction1));
    TriggerAddAction(t, @AkameSpellRFunction11);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkameSpellTFunction1));
    TriggerAddAction(t, @AkameSpellTFunction3);
}

void ResetScathachQ(int hid){
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A040"), true);
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A03Y"), false);
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A03Z"), false);
}
bool ScathachSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A040");
}
void ScathachSpellQFunction2(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 100 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.5f;
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) > 0 && GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iTarget)) > 0){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            if (GetUnitLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) >= 5){
                SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A040"), false);
                SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A03Y"), true);
                SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A03Z"), false);
            }
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 250, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102))));
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 107)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 107)), .35f, .02f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.5f, .7f);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
        if (LocTime == 55){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScale(GlobalUnit, 2, 2, 2);
                i = i + 1;
            }
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
    }
    if (LocTime == 300 || GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) <= 0 || GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iTarget)) <= 0){
        ResetScathachQ(hid);
        ClearAllData(hid);
    }
}
void ScathachSpellQFunction3(){
int i = 1;
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ScathachSounds[2], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Attack");
    while (true) {
        if (i > 5) break;
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(0, 360));
        SetUnitScale(GlobalUnit, 2, 2, 2);
        i = i + 1;
    }
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
    TimerStart(tmr, .01f, true, @ScathachSpellQFunction2);
}
bool ScathachSpellQSecondFunction1(){
    return GetSpellAbilityId() == FourCC("A03Y");
}
void ScathachSpellQSecondFunction2(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 50 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 25 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.5f;
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) > 0 && GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iTarget)) > 0){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 10){
            if (GetUnitLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) >= 8){
                SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A040"), false);
                SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A03Y"), false);
                SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A03Z"), true);
            }
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 200, .25f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2.5f, 2.5f, 2.5f);
            CreateNUnitsAtLocACF(1, FourCC("u00L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.f, 2.f);
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScale(GlobalUnit, 2, 2, 2);
                i = i + 1;
            }
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 35){
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
        }
    }
    if (LocTime == 300 || GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) <= 0 || GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iTarget)) <= 0){
        ResetScathachQ(hid);
        ClearAllData(hid);
    }
}
void ScathachSpellQSecondFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    PlaySoundWithVolumeACF(ScathachSounds[1], 100, 0);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), (DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 250), .1f, .02f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Three");
    TimerStart(tmr, .01f, true, @ScathachSpellQSecondFunction2);
}
bool ScathachSpellQThirdFunction1(){
    return GetSpellAbilityId() == FourCC("A03Z");
}
void ScathachSpellQThirdFunction2(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 100 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 25 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.5f;
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            ResetScathachQ(hid);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Attack");
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
        }
        if (LocTime == 45){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 200, .5f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScale(GlobalUnit, 2, 2, 2);
                i = i + 1;
            }
            CreateNUnitsAtLocACF(1, FourCC("u00L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.f, 2.f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, 2.5f, 2.5f, 2.5f);
            ClearAllData(hid);
        }
    }
}
void ScathachSpellQThirdFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    PlaySoundWithVolumeACF(ScathachSounds[0], 100, 0);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Three");
    LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), (DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 250), .2f, .02f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
    CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
    TimerStart(tmr, .01f, true, @ScathachSpellQThirdFunction2);
}
bool ScathachSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A041");
}
bool ScathachSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 2);
    }
    return true;
}
void ScathachSpellWFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 50){
            PlaySoundWithVolumeACF(ScathachSounds[2], 100, 0);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 400, Filter(@ScathachSpellWFunction2));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\LightningStrike1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\SlamEffect.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            DestroyEffect(LoadEffectHandle(GameHashTable, hid, 108));
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 2.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            ClearAllData(hid);
        }
    }
}
void ScathachSpellWFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(ScathachSounds[3], 100, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Throw");
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), (((AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))) + 0)));
        DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .5f, .01f, 600);
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
        SaveEffectHandle(GameHashTable, hid, 108, AddSpecialEffectTarget("Abilities\\Weapons\\PhoenixMissile\\Phoenix_Missile.mdl", LoadUnitHandle(GameHashTable, hid, iCaster), "weapon"));
        TimerStart(tmr, .01f, true, @ScathachSpellWFunction3);
    }
    else {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
void ScathachSpellEFunctionRemoveUnits(){
    KillUnit(GetEnumUnit());
}
bool ScathachSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A042");
}
void ScathachSpellEFunctionDisplaceDummy(){
int hid = GetHandleId(GetExpiredTimer());
    SaveLocationHandle(GameHashTable, hid, 123, GetUnitLoc(GetEnumUnit()));
    SaveLocationHandle(GameHashTable, hid, 124, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 123), 50, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
    SetUnitPositionLoc(GetEnumUnit(), LoadLocationHandle(GameHashTable, hid, 124));
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 123));
    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 124));
}
bool ScathachSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 75 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
    }
    return true;
}
void ScathachSpellEFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
bool IsCounted = LoadBoolean(GameHashTable, hid, 10);
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) > 0){
        if (IsCounted == true){
            SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        }
        else {
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 50, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 2);
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
            ForGroup(LoadGroupHandle(GameHashTable, hid, 119), @ScathachSpellEFunctionDisplaceDummy);
            SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103), 0);
            if (R2I(DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107))) <= 150){
                ForGroup(LoadGroupHandle(GameHashTable, hid, 119), @ScathachSpellEFunctionRemoveUnits);
                PlaySoundWithVolumeACF(ScathachSounds[5], 100, 0);
                PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Seven");
                DestroyGroup(LoadGroupHandle(GameHashTable, hid, 119));
                SaveBoolean(GameHashTable, hid, 10, true);
            }
            else {
                RemoveLocation(LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 102));
                RemoveLocation(LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 103));
                RemoveLocation(LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 107));
            }
        }
        if (LocTime == 45){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 500, .4f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 2.f, 3.f);
                i = i + 1;
            }
            CreateNUnitsAtLocACF(1, FourCC("u00L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 3.f, 2.f);
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, 2.5f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            CreateNUnitsAtLocACF(1, FourCC("u01Y"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell four");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 85){
            PlaySoundWithVolumeACF(ScathachSounds[6], 100, 0);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            CreateNUnitsAtLocACF(1, FourCC("u01Z"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SaveUnitHandle(GameHashTable, hid, 106, GlobalUnit);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime >= 85){
            SaveLocationHandle(GameHashTable, hid, 109, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, 106)));
            SaveLocationHandle(GameHashTable, hid, 115, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 116, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 109), 50, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 109), LoadLocationHandle(GameHashTable, hid, 115))));
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, 106), false);
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, 106), LoadLocationHandle(GameHashTable, hid, 116));
            SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, 106), LoadLocationHandle(GameHashTable, hid, 115), 0);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 109)));
            if (R2I(DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 115), LoadLocationHandle(GameHashTable, hid, 116))) <= 100){
                KillUnit(LoadUnitHandle(GameHashTable, hid, 106));
                GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 109), 600, Filter(@ScathachSpellEFunction2));
                i = 1;
                while (true) {
                    if (i > 10) break;
                    SaveLocationHandle(GameHashTable, hid, 125, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, 106)));
                    CreateNUnitsAtLocACF(1, FourCC("u01Y"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 125), 36 * i);
                    RemoveLocation(LoadLocationHandle(GameHashTable, hid, 125));
                    i = i + 1;
                }
                DestroyGroup(LoadGroupHandle(GameHashTable, hid, 119));
                ClearAllData(hid);
            }
            else {
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 115));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 116));
            }
        }
    }
    else {
        ForGroup(LoadGroupHandle(GameHashTable, hid, 119), @ScathachSpellEFunctionRemoveUnits);
        DestroyGroup(LoadGroupHandle(GameHashTable, hid, 119));
        ClearAllData(hid);
    }
}
void ScathachSpellEFunction4(){
float i = 1;
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveBoolean(GameHashTable, hid, 10, false);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    SaveGroupHandle(GameHashTable, hid, 119, CreateGroup());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Channel");
    while (true) {
        if (i > 10) break;
        SaveLocationHandle(GameHashTable, hid, 123, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
        SaveLocationHandle(GameHashTable, hid, 124, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 123), 80.f * i, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 123), LoadLocationHandle(GameHashTable, hid, 103)) - 160));
        CreateNUnitsAtLocACF(1, FourCC("u020"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 124), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 123), LoadLocationHandle(GameHashTable, hid, 103)));
        GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 119), GlobalUnit);
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 123));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 124));
        SaveLocationHandle(GameHashTable, hid, 123, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 124, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 123), 80.f * i, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 123), LoadLocationHandle(GameHashTable, hid, 103)) + 160));
        CreateNUnitsAtLocACF(1, FourCC("u020"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 124), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 123), LoadLocationHandle(GameHashTable, hid, 103)));
        GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 119), GlobalUnit);
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 123));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 124));
        i = i + 1;
    }
    TimerStart(tmr, .01f, true, @ScathachSpellEFunction3);
}
bool ScathachSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A043");
}
void ScathachSpellRFunction2(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 25 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.17f;
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 1){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            while (true) {
                if (i > 3) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 1.25f, 3.f);
                i = i + 1;
            }
            CreateNUnitsAtLocACF(1, FourCC("u00L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, 2.f);
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, .5f, 2.5f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Three");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 25 || LocTime == 50 || LocTime == 75 || LocTime == 100){
            SaveReal(GameHashTable, hid, 110, LoadReal(GameHashTable, hid, 110) + 1);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 50, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102))));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 107)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 107)), .2f, .01f, false, true, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            SetUnitAnimationWithRarity(LoadUnitHandle(GameHashTable, hid, iCaster), "attack", RARITY_RARE);
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 50, .25f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            while (true) {
                if (i > 3) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 1.25f, 3.f);
                i = i + 1;
            }
            CreateNUnitsAtLocACF(1, FourCC("u00L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 2.f, 2.f);
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, .5f, 2.5f);
            CreateNUnitsAtLocACF(1, FourCC("u00H"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
        if (LocTime == 125){
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Seven");
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            CreateNUnitsAtLocACF(1, FourCC("u01Y"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 2);
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 50, .25f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            ClearAllData(hid);
        }
    }
}
void ScathachSpellRFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ScathachSounds[4], 80, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    SaveReal(GameHashTable, hid, 110, 0);
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) - 150, .2f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack");
    TimerStart(tmr, .01f, true, @ScathachSpellRFunction2);
}
bool ScathachSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A044");
}
bool ScathachSpellTLinearMovementAction(){
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), iCaster)))){
        SetUnitPositionLoc(GetFilterUnit(), LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 109));
    }
    return true;
}
bool ScathachSpellTAoEDamageAction(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 300 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
    }
    return true;
}
void ScathachSpellTFunction2(){
float i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime <= 100){
            SaveReal(GameHashTable, hid, 110, LoadReal(GameHashTable, hid, 110) + 1);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103), 0);
            SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, 106), LoadLocationHandle(GameHashTable, hid, 103), 0);
            SetUnitScale(LoadUnitHandle(GameHashTable, hid, 106), 1 + LoadReal(GameHashTable, hid, 110) / 50, 1 + LoadReal(GameHashTable, hid, 110) / 50, 1 + LoadReal(GameHashTable, hid, 110) / 50);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
        }
        if (LocTime == 100){
            PlaySoundWithVolumeACF(ScathachSounds[7], 100, 0);
            PauseTimer(LoadTimerHandle(GameHashTable, hid, 105));
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            while (true) {
                if (i > 8) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 1.f + i / 5.f, 1.25f);
                SetUnitVertexColor(GlobalUnit, 255, 255, 255, 75);
                i = i + 1;
            }
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
            DestroyEffect(LoadEffectHandle(GameHashTable, hid, 108));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Four");
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            SaveReal(GameHashTable, hid, 110, 0);
        }
        if (LocTime >= 100){
            SaveLocationHandle(GameHashTable, hid, 107, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, 106)));
            SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 107), 50, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 107), LoadLocationHandle(GameHashTable, hid, 103))));
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, 106), LoadLocationHandle(GameHashTable, hid, 109));
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, 106), false);
            SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, 106), LoadLocationHandle(GameHashTable, hid, 103), 0);
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 107)));
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 400, Filter(@ScathachSpellTLinearMovementAction));
            if (DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 109)) <= 100){
                PlaySoundWithVolumeACF(GeneralSounds[2], 80, 0);
                GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 450, Filter(@ScathachSpellTAoEDamageAction));
                i = 1;
                while (true) {
                    if (i > 8) break;
                    CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                    SetUnitScaleAndTime(GlobalUnit, 1.f + i / 5.f, 1.25f);
                    SetUnitVertexColor(GlobalUnit, 255, 255, 255, 75);
                    i = i + 1;
                }
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\26.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
                ClearAllData(hid);
            }
        }
    }
}
void ScathachSpellTFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ScathachSounds[0], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell Three");
    CreateNUnitsAtLocACF(1, FourCC("u021"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
    SetUnitVertexColor(GlobalUnit, 128, 0, 0, 100);
    SaveUnitHandle(GameHashTable, hid, 106, GlobalUnit);
    TimerStart(tmr, .01f, true, @ScathachSpellTFunction2);
}
void HeroInit8()
{
    trigger t;

    ScathachSounds.resize( 8 );
    ScathachSounds[0] = CreateSound("Characters\\Scathach\\Sounds\\ScathachSpellQFirstSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ScathachSounds[1] = CreateSound("Characters\\Scathach\\Sounds\\ScathachSpellQSecondSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ScathachSounds[2] = CreateSound("Characters\\Scathach\\Sounds\\ScathachSpellQThirdSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ScathachSounds[3] = CreateSound("Characters\\Scathach\\Sounds\\ScathachSpellWSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ScathachSounds[4] = CreateSound("Characters\\Scathach\\Sounds\\ScathachSpellESound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ScathachSounds[5] = CreateSound("Characters\\Scathach\\Sounds\\ScathachSpellRSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ScathachSounds[6] = CreateSound("Characters\\Scathach\\Sounds\\ScathachSpellRSound2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ScathachSounds[7] = CreateSound("Characters\\Scathach\\Sounds\\ScathachSpellTSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ScathachSpellQFunction1));
    TriggerAddAction(t, @ScathachSpellQFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ScathachSpellQSecondFunction1));
    TriggerAddAction(t, @ScathachSpellQSecondFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ScathachSpellQThirdFunction1));
    TriggerAddAction(t, @ScathachSpellQThirdFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ScathachSpellWFunction1));
    TriggerAddAction(t, @ScathachSpellWFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ScathachSpellRFunction1));
    TriggerAddAction(t, @ScathachSpellRFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ScathachSpellEFunction1));
    TriggerAddAction(t, @ScathachSpellEFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ScathachSpellTFunction1));
    TriggerAddAction(t, @ScathachSpellTFunction3);
}

bool AkainuSpellDFunction1(){
    return GetSpellAbilityId() == FourCC("A049");
}
bool AkainuSpellDFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 12.5f + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.1f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl", GetFilterUnit(), "chest"));
    }
    return true;
}
void AkainuSpellDFunction3(){
int hid = GetHandleId(GetExpiredTimer());
    if (GetUnitAbilityLevel(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("B04H")) > 0){
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 102), 300, Filter(@AkainuSpellDFunction2));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
    }
    else {
        ClearAllData(hid);
    }
}
void AkainuSpellDFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(AkainuSounds[0], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveEffectHandle(GameHashTable, hid, 108, AddSpecialEffectTarget("GeneralEffects\\lavaspray.mdx", LoadUnitHandle(GameHashTable, hid, iCaster), "head"));
    TimerStart(tmr, .5f, true, @AkainuSpellDFunction3);
}
bool AkainuSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A04A");
}
bool AkainuSpellQFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 150 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 25 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.5f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
    }
    return true;
}
void AkainuSpellQFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 200 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 25 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.5f;
    if (StopSpell(hid, 0) == false){
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
        SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 20, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
        SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
        SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
        SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103), 0);
        if (R2I(DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107))) <= 100){
            PlaySoundWithVolumeACF(AkainuSounds[4], 90, 0);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell two");
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\QQQQQ.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
            CreateNUnitsAtLocACF(1, FourCC("u025"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + 90);
            KillUnit(GlobalUnit);
            CreateNUnitsAtLocACF(1, FourCC("u026"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            while (true) {
                if (i > 3) break;
                SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 150, 120 * i));
                CreateNUnitsAtLocACF(1, FourCC("u027"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 109), 0);
                KillUnit(GlobalUnit);
                CreateNUnitsAtLocACF(1, FourCC("u028"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 109), 120 * i);
                SetUnitScaleAndTime(GlobalUnit, .5f, 1.5f);
                KillUnit(GlobalUnit);
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
                i = i + 1;
            }
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 2);
            LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 300, .4f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 300, Filter(@AkainuSpellQFunction2));
            ClearAllData(hid);
        }
        else {
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
    }
}
void AkainuSpellQFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(AkainuSounds[5], 90, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell three");
    TimerStart(tmr, .01f, true, @AkainuSpellQFunction3);
}
bool AkainuSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A04C");
}
bool AkainuSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
    }
    return true;
}
void AkainuSpellWFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 50){
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\LightningStrike1.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            CreateNUnitsAtLocACF(1, FourCC("u00R"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 270);
            SetUnitScale(GlobalUnit, 1.5f, 1.5f, 1.5f);
            while (true) {
                if (i > 4) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, 1.5f, 1.25f);
                CreateNUnitsAtLocACF(1, FourCC("u028"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 90 * i);
                SetUnitScaleAndTime(GlobalUnit, .5f, 1.5f);
                KillUnit(GlobalUnit);
                i = i + 1;
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 350, Filter(@AkainuSpellWFunction2));
            ClearAllData(hid);
        }
    }
}
void AkainuSpellWFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(AkainuSounds[3], 90, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell one");
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
        DisplaceUnitWithArgs(LoadUnitHandle(GameHashTable, hid, iCaster), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), .5f, .01f, 600);
        TimerStart(tmr, .01f, true, @AkainuSpellWFunction3);
    }
    else {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}
bool AkainuSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A04B");
}
void AkainuSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
            CreateNUnitsAtLocACF(1, FourCC("u029"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SaveUnitHandle(GameHashTable, hid, 106, GlobalUnit);
            SetUnitPathing(GlobalUnit, false);
            CreateNUnitsAtLocACF(1, FourCC("u028"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScale(GlobalUnit, .5f, .5f, .5f);
            SaveUnitHandle(GameHashTable, hid, 126, GlobalUnit);
            SetUnitPathing(GlobalUnit, false);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime > 20){
            SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            SaveLocationHandle(GameHashTable, hid, 107, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, 106)));
            SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 107), 40, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 107), LoadLocationHandle(GameHashTable, hid, 103))));
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, 106), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, 106), false);
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, 106), LoadLocationHandle(GameHashTable, hid, 109));
            SetUnitFacing1(LoadUnitHandle(GameHashTable, hid, 126), LoadUnitHandle(GameHashTable, hid, iTarget), 0);
            SetUnitPathing(LoadUnitHandle(GameHashTable, hid, 126), false);
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, 126), LoadLocationHandle(GameHashTable, hid, 109));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", LoadLocationHandle(GameHashTable, hid, 107)));
            if (R2I(DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 109))) <= 300){
                KillUnit(LoadUnitHandle(GameHashTable, hid, 106));
                KillUnit(LoadUnitHandle(GameHashTable, hid, 126));
                DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\BloodEffect1.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
                DestroyEffect(AddSpecialEffectTarget("GeneralEffects\\QQQQQ.mdx", LoadUnitHandle(GameHashTable, hid, iTarget), "chest"));
                CreateNUnitsAtLocACF(1, FourCC("u026"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107)));
                CreateNUnitsAtLocACF(1, FourCC("u025"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107)) + 90);
                KillUnit(GlobalUnit);
                DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            }
            else {
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
            }
        }
        if (LocTime == 50){
            ClearAllData(hid);
        }
    }
}
void AkainuSpellEFunction3(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(AkainuSounds[2], 90, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack");
    TimerStart(tmr, .01f, true, @AkainuSpellEFunction2);
}
bool AkainuSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A04D");
}
bool AkainuSpellRFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 100 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster))) && IsUnitInGroup(GetFilterUnit(), LoadGroupHandle(GameHashTable, hid, 111)) == false){
        StunUnitACF(GetFilterUnit(), 1);
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 111), GetFilterUnit());
    }
    return true;
}
void AkainuSpellRFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1);
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 127, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 300, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            CreateNUnitsAtLocACF(1, FourCC("u02A"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 127), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 127));
            PlaySoundWithVolumeACF(AkainuSounds[5], 60, 0);
            PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            IssueImmediateOrder(LoadUnitHandle(GameHashTable, hid, iCaster), "stop");
        }
        if (LocTime > 20){
            SaveReal(GameHashTable, hid, 110, (LoadReal(GameHashTable, hid, 110) + 100));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), LoadReal(GameHashTable, hid, 110), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
            while (true) {
                if (i > 2) break;
                SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 107), GetRandomReal(0, 500), GetRandomReal(0, 360)));
                DestroyEffect(AddSpecialEffectLoc("abilities\\weapons\\catapult\\catapultmissile.mdl", LoadLocationHandle(GameHashTable, hid, 109)));
                CreateNUnitsAtLocACF(1, FourCC("u028"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 109), GetRandomReal(0, 360));
                SetUnitScale(GlobalUnit, .5f, .5f, .5f);
                KillUnit(GlobalUnit);
                RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
                i = i + 1;
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 500, Filter(@AkainuSpellRFunction2));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
            if (LoadReal(GameHashTable, hid, 110) >= 1500){
                DestroyGroup(LoadGroupHandle(GameHashTable, hid, 111));
                ClearAllData(hid);
            }
        }
    }
}
void AkainuSpellRFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(AkainuSounds[1], 90, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
    SaveGroupHandle(GameHashTable, hid, 111, CreateGroup());
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack");
    TimerStart(tmr, .01f, true, @AkainuSpellRFunction3);
}
bool AkainuSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A04E");
}
bool AkainuSpellTFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 25 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * 0.05f;
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
    }
    return true;
}
void AkainuSpellTFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
int LocCount = LoadInteger(GameHashTable, hid, 1);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        SaveReal(GameHashTable, hid, 110, LoadReal(GameHashTable, hid, 110) + 1);
        SaveReal(GameHashTable, hid, 118, LoadReal(GameHashTable, hid, 118) + 1);
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        if (LoadReal(GameHashTable, hid, 118) == 1){
            SaveReal(GameHashTable, hid, 5, - 90);
        }
        else {
            SaveReal(GameHashTable, hid, 5, 90);
            SaveReal(GameHashTable, hid, 118, 0);
        }
        if (LoadReal(GameHashTable, hid, 110) < 50){
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 70, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)) + LoadReal(GameHashTable, hid, 5)));
            CreateNUnitsAtLocACF(1, FourCC("u02C"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 107), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            ShowUnit(GlobalUnit, false);
            SetUnitScale(GlobalUnit, .5f, .5f, .5f);
            SetUnitAnimation(GlobalUnit, "stand");
            UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), .5f);
            SetUnitFlyHeight(GlobalUnit, 4400, 6000);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
        if (LocTime > 10){
            SaveInteger(GameHashTable, hid, 1, LocCount + 1);
            SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 550), GetRandomReal(0, 360)));
            CreateNUnitsAtLocACF(1, FourCC("u02B"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 109), GetRandomReal(0, 360));
            SetUnitScale(GlobalUnit, .65f, .65f, .65f);
            UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), .35f);
            if (LocCount > 7){
                GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 109), 500, Filter(@AkainuSpellTFunction2));
            }
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
        }
        if (LoadReal(GameHashTable, hid, 110) == 70){
            ClearAllData(hid);
        }
    }
}
void AkainuSpellTFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(AkainuSounds[6], 90, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell");
    TimerStart(tmr, .05f, true, @AkainuSpellTFunction3);
}
void HeroInit9()
{
    trigger t;

    AkainuSounds.resize( 7 );
    AkainuSounds[0] = CreateSound("Characters\\Akainu\\Sounds\\AkainuSpellDSound.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkainuSounds[1] = CreateSound("Characters\\Akainu\\Sounds\\AkainuSpellQSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkainuSounds[2] = CreateSound("Characters\\Akainu\\Sounds\\AkainuSpellWSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkainuSounds[3] = CreateSound("Characters\\Akainu\\Sounds\\AkainuSpellESound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkainuSounds[4] = CreateSound("Characters\\Akainu\\Sounds\\AkainuSpellRSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkainuSounds[5] = CreateSound("Characters\\Akainu\\Sounds\\AkainuSpellRSound2.mp3", false, false, false, 10, 10, "DefaultEAXON");
    AkainuSounds[6] = CreateSound("Characters\\Akainu\\Sounds\\AkainuSpellTSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkainuSpellDFunction1));
    TriggerAddAction(t, @AkainuSpellDFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkainuSpellQFunction1));
    TriggerAddAction(t, @AkainuSpellQFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkainuSpellWFunction1));
    TriggerAddAction(t, @AkainuSpellWFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkainuSpellEFunction1));
    TriggerAddAction(t, @AkainuSpellEFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkainuSpellRFunction1));
    TriggerAddAction(t, @AkainuSpellRFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@AkainuSpellTFunction1));
    TriggerAddAction(t, @AkainuSpellTFunction4);
}
bool ReinforceSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A04G");
}
bool ReinforceSpellQUnitDisplacement(){
int hid = GetHandleId(GetExpiredTimer());
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(GetFilterUnit()));
        SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), 10, ((AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102))) + (60))));
        SetUnitPositionLoc(GetFilterUnit(), LoadLocationHandle(GameHashTable, hid, 107));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
    }
    return true;
}
bool ReinforceSpellQFunction2()
{
    timer tmr = GetExpiredTimer();
int hid = GetHandleId( tmr );
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 2);
        SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(GetFilterUnit()));
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
        DisplaceUnitWithArgs(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 200, 1, .01f, 0);
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
    }
    return true;
}

void ReinforceSpellQFunction3()
{
    timer tmr = GetExpiredTimer();
    int hid = GetHandleId( tmr );
    int LocTime = LoadInteger(GameHashTable, hid, 0);

    if (StopSpell(hid, 0) == false)
    {
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 102), 400., Filter(@ReinforceSpellQUnitDisplacement));
        if (LocTime == 100){
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 102), 400, Filter(@ReinforceSpellQFunction2));
            CreateNUnitsAtLocACF(1, FourCC("u00L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 270);
            SetUnitScaleAndTime(GlobalUnit, 5.f, 2.f);
            CreateNUnitsAtLocACF(1, FourCC("u02D"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
            SetUnitTimeScale(GlobalUnit, .8f);
            ClearAllData(hid);
            DestroyTimer( tmr );
        }
    }
}
void ReinforceSpellQFunction4()
{
    timer tmr = CreateTimer();
    int hid = GetHandleId(tmr);

    PlaySoundWithVolumeACF(ReinforceSounds[1], 60, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetSpellTargetLoc());
    SaveReal(GameHashTable, hid, 10, 0);
    CreateNUnitsAtLocACF(1, FourCC("u009"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 270);
    CreateNUnitsAtLocACF(1, FourCC("u02F"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
    TimerStart(tmr, .01f, true, @ReinforceSpellQFunction3);
}
bool ReinforceSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A04H");
}
void ReinforceSpellWDummyFacing(){
    SetUnitFacing1(GetEnumUnit(), LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), iTarget), 0);
}
void ReinforceSpellWDummyMovement(){
int hid = GetHandleId(GetExpiredTimer());
    SetUnitFlyHeight(GetEnumUnit(), 0, 99999);
    SetUnitPositionLoc(GetEnumUnit(), LoadLocationHandle(GameHashTable, hid, 102));
    SetUnitFacing(GetEnumUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 102)));
}
void ReinforceSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 1) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        ForGroup(LoadGroupHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 119), @ReinforceSpellWDummyFacing);
        if (LocTime == 100){
            PauseTimer(LoadTimerHandle(GameHashTable, hid, 105));
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\26.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
            ForGroup(LoadGroupHandle(GameHashTable, hid, 119), @ReinforceSpellWDummyMovement);
            DestroyGroup(LoadGroupHandle(GameHashTable, hid, 119));
            StunUnitACF(LoadUnitHandle(GameHashTable, hid, iTarget), 1);
            DamageTargetACF(DummyUnitDamageArr[ID], LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            ClearAllData(hid);
        }
    }
}
void ReinforceSpellWFunction3(){
float i = 1;
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ReinforceSounds[2], 60, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    SaveGroupHandle(GameHashTable, hid, 119, CreateGroup());
    while (true) {
        if (i > 20) break;
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
        SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(100, 1000), 36 * i));
        CreateNUnitsAtLocACF(1, FourCC("u02N"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102)));
        GroupAddUnit(LoadGroupHandle(GameHashTable, hid, 119), GlobalUnit);
        CreateNUnitsAtLocACF(1, FourCC("u02G"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 102)));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
        i = i + 1;
    }
    TimerStart(tmr, .01f, true, @ReinforceSpellWFunction2);
}
bool ReinforceSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A04I");
}
bool ReinforceSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 60 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        GlobalUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC("u02T"), GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit()), 0);
        UnitShareVision(GetFilterUnit(), Player(PLAYER_NEUTRAL_PASSIVE), true);
        IssueTargetOrder(GlobalUnit, "slow", GetFilterUnit());
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
    }
    return true;
}
void ReinforceSpellEFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 100){
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
            DestroyEffect(AddSpecialEffectLoc("Characters\\Reinforce\\ApocalypseStomp.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
            CreateNUnitsAtLocACF(1, FourCC("u00Z"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
            GlobalUnit = CreateUnitAtLoc(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("u00E"), LoadLocationHandle(GameHashTable, hid, 102), 0);
            SetUnitScaleAndTime(GlobalUnit, 2.5f, .75f);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 102), 450, Filter(@ReinforceSpellEFunction2));
            ClearAllData(hid);
        }
    }
}
void ReinforceSpellEFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ReinforceSounds[3], 60, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetSpellTargetLoc());
    TimerStart(tmr, .01f, true, @ReinforceSpellEFunction3);
}
bool ReinforceSpellRFunction1(){
    return GetSpellAbilityId() == FourCC("A04J");
}
bool ReinforceSpellRFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 150 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
    }
    return true;
}
void ReinforceSpellRFunction3(){
int hid = GetHandleId(GetExpiredTimer());
    if (StopSpell(hid, 1) == false){
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
        SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 20, AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103))));
        SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 107));
        SetUnitFacing2(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103), 0);
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\NewDirtEx.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
        if (R2I(DistanceBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 107))) <= 150){
            CreateNUnitsAtLocACF(1, FourCC("u00L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitTimeScale(GlobalUnit, 2);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 400, Filter(@ReinforceSpellRFunction2));
            ClearAllData(hid);
        }
        else {
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
        }
    }
}
void ReinforceSpellRFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ReinforceSounds[0], 60, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitPathing(LoadUnitHandle(GameHashTable, hid, iCaster), false);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "walk");
    TimerStart(tmr, .01f, true, @ReinforceSpellRFunction3);
}
bool ReinforceSpellTFunction1(){
    return GetSpellAbilityId() == FourCC("A04K");
}
bool ReinforceSpellTUnitDisplacer1(){
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), iCaster)))){
        SetUnitPositionLoc(GetFilterUnit(), LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 107));
    }
    return true;
}
bool ReinforceSpellTUnitDisplacer2(){
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, GetHandleId(GetExpiredTimer()), iCaster)))){
        SetUnitPositionLoc(GetFilterUnit(), LoadLocationHandle(GameHashTable, GetHandleId(GetExpiredTimer()), 109));
    }
    return true;
}
bool ReinforceSpellTFunction2(){
int hid = GetHandleId(GetExpiredTimer());
int ID = GetPlayerId(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)));
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 400 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 104, GetUnitLoc(GetFilterUnit()));
        DamageTargetACF(DummyUnitDamageArr[ID], GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 103), LoadLocationHandle(GameHashTable, hid, 104)), 300, 1, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 104));
    }
    return true;
}
void ReinforceSpellTFunction3(){
float i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
bool IsCounted = LoadBoolean(GameHashTable, hid, 10);
    if (GetUnitCurrentLife(LoadUnitHandle(GameHashTable, hid, iCaster)) > 0){
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        if (IsCounted == true){
            SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        }
        else {
            SaveReal(GameHashTable, hid, 110, (LoadReal(GameHashTable, hid, 110) - 16));
            SaveLocationHandle(GameHashTable, hid, 107, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), LoadReal(GameHashTable, hid, 110), (((LoadReal(GameHashTable, hid, 110))) * (1))));
            SaveLocationHandle(GameHashTable, hid, 109, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 103), LoadReal(GameHashTable, hid, 110), (((((LoadReal(GameHashTable, hid, 110))) * (1))) + (180))));
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 107), 450, Filter(@ReinforceSpellTUnitDisplacer1));
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 109), 450, Filter(@ReinforceSpellTUnitDisplacer2));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl", LoadLocationHandle(GameHashTable, hid, 107)));
            DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Undead\\DeathandDecay\\DeathandDecayTarget.mdl", LoadLocationHandle(GameHashTable, hid, 109)));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 109));
            if (LoadReal(GameHashTable, hid, 110) <= 0){
                SaveBoolean(GameHashTable, hid, 10, true);
                SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack slam");
            }
        }
        if (LocTime == 20){
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "attack slam");
            CreateNUnitsAtLocACF(1, FourCC("u02M"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            SaveUnitHandle(GameHashTable, hid, iTarget, GlobalUnit);
            SetUnitAnimation(GlobalUnit, "birth");
        }
        if (LocTime == 70){
            SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
            SaveLocationHandle(GameHashTable, hid, 113, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 130, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel");
            while (true) {
                if (i > 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u02L"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
                SetUnitScaleAndTime(GlobalUnit, i, .05f * i);
                UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 1.8f);
                i = i + 1;
            }
            CreateNUnitsAtLocACF(1, FourCC("u02E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 113), 0);
            SetUnitFlyHeight(GlobalUnit, 30, 99999);
            UnitApplyTimedLife(GlobalUnit, FourCC("BTLF"), 3.6f);
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
            RemoveLocation(LoadLocationHandle(GameHashTable, hid, 113));
        }
        if (LocTime == 230){
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell slam");
        }
        if (LocTime == 250){
            CreateNUnitsAtLocACF(1, FourCC("u02K"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            SetUnitScale(GlobalUnit, 10, 10, 10);
            CreateNUnitsAtLocACF(1, FourCC("u00Z"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            SetUnitScale(GlobalUnit, 10, 10, 10);
            CreateNUnitsAtLocACF(1, FourCC("u010"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            SetUnitScale(GlobalUnit, 3.5f, 3.5f, 3.5f);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 900, Filter(@ReinforceSpellTFunction2));
            KillUnit(LoadUnitHandle(GameHashTable, hid, iTarget));
            ClearAllData(hid);
        }
    }
    else {
        ReinforceResetT(hid);
    }
}
void ReinforceSpellTFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    SaveBoolean(GameHashTable, hid, 10, false);
    PlaySoundWithVolumeACF(ReinforceSounds[5], 80, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
    SaveReal(GameHashTable, hid, 110, 800);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "spell channel");
    TimerStart(tmr, .01f, true, @ReinforceSpellTFunction3);
}
void HeroInit10()
{
    trigger t;

    ReinforceSounds.resize( 6 );
    ReinforceSounds[0] = CreateSound("Characters\\Reinforce\\Sounds\\ReinforceSpellCSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ReinforceSounds[1] = CreateSound("Characters\\Reinforce\\Sounds\\ReinforceSpellQSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ReinforceSounds[2] = CreateSound("Characters\\Reinforce\\Sounds\\ReinforceSpellWSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ReinforceSounds[3] = CreateSound("Characters\\Reinforce\\Sounds\\ReinforceSpellESound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ReinforceSounds[4] = CreateSound("Characters\\Reinforce\\Sounds\\ReinforceSpellRSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ReinforceSounds[5] = CreateSound("Characters\\Reinforce\\Sounds\\ReinforceSpellTSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ReinforceSpellQFunction1));
    TriggerAddAction(t, @ReinforceSpellQFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ReinforceSpellWFunction1));
    TriggerAddAction(t, @ReinforceSpellWFunction3);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ReinforceSpellEFunction1));
    TriggerAddAction(t, @ReinforceSpellEFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ReinforceSpellRFunction1));
    TriggerAddAction(t, @ReinforceSpellRFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ReinforceSpellTFunction1));
    TriggerAddAction(t, @ReinforceSpellTFunction4);
}
bool ArcueidSpellQFunction1(){
    return GetSpellAbilityId() == FourCC("A01N");
}
bool ArcueidSpellQFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 250 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 70 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 107, GetUnitLoc(GetFilterUnit()));
        DisplaceUnitWithArgs(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 107)), - 300, .5f, .01f, 250);
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BloodEffect1.mdx", LoadLocationHandle(GameHashTable, hid, 107)));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 107));
    }
    return true;
}
void ArcueidSpellQFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 20){
            PlaySoundWithVolumeACF(GeneralSounds[0], 50, 0);
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 300, Filter(@ArcueidSpellQFunction2));
            ClearAllData(hid);
        }
    }
}
void ArcueidSpellQFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ArcueidSounds[0], 100, 0);
    SaveInteger(GameHashTable, hid, 0, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, CreateLocationACF(LoadLocationHandle(GameHashTable, hid, 102), 300, GetUnitFacing(LoadUnitHandle(GameHashTable, hid, iCaster))));
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 2);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell One");
    TimerStart(tmr, .01f, true, @ArcueidSpellQFunction3);
}
bool ArcueidSpellWFunction1(){
    return GetSpellAbilityId() == FourCC("A01Y");
}
bool ArcueidSpellWFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = 350 + GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 60 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        SaveLocationHandle(GameHashTable, hid, 113, GetUnitLoc(GetFilterUnit()));
        LinearDisplacement(GetFilterUnit(), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 113)), 200, .15f, .01f, false, false, "origin", "Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl");
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 113));
    }
    return true;
}
void ArcueidSpellWFunction3(){
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
int i = 1;
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 10){
            while (true) {
                if (i == 5) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), GetRandomReal(0, 360));
                SetUnitScaleAndTime(GlobalUnit, GetRandomReal(1.5f, 2), 1.5f);
                SetUnitVertexColor(GlobalUnit, 255, 255, 255, 185);
                i = i + 1;
            }
        }
        if (LocTime == 25){
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 102), 450, Filter(@ArcueidSpellWFunction2));
        }
        if (LocTime == 40){
            ClearAllData(hid);
        }
    }
}
void ArcueidSpellWFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ArcueidSounds[1], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveInteger(GameHashTable, hid, 0, 0);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1.75f);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Five");
    TimerStart(tmr, .01f, true, @ArcueidSpellWFunction3);
}
bool ArcueidSpellEFunction1(){
    return GetSpellAbilityId() == FourCC("A026");
}
bool ArcueidSpellEFunction2(){
int hid = GetHandleId(GetExpiredTimer());
float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 100 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
    }
    return true;
}
void ArcueidSpellEFunction3(){
int i = 1;
int hid = GetHandleId(GetExpiredTimer());
int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false){
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 15){
            ShowUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
        }
        if (LocTime == 25){
            PlaySoundWithVolumeACF(GeneralSounds[3], 60, 0);
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103));
            ShowUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            if (GetLocalPlayer() == GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster))){
                ClearSelection();
                SelectUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            }
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 400, Filter(@ArcueidSpellEFunction2));
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\SlamEffect.mdx", LoadLocationHandle(GameHashTable, hid, 103)));
            while (true) {
                if (i == 3) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
                SetUnitScaleAndTime(GlobalUnit, GetRandomReal(1.5f, 2.f), 1.5f);
                SetUnitVertexColor(GlobalUnit, 255, 255, 255, 185);
                i = i + 1;
            }
            ClearAllData(hid);
        }
    }
}
void ArcueidSpellEFunction4(){
timer tmr = CreateTimer();
int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(ArcueidSounds[2], 100, 0);
        SaveInteger(GameHashTable, hid, 0, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Attack Two");
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BlackBlink.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
        TimerStart(tmr, .01f, true, @ArcueidSpellEFunction3);
    }
    else {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}

bool ArcueidSpellRFunction1()
{
    return GetSpellAbilityId() == FourCC("A027");
}

bool ArcueidSpellRFunction2()
{
    int hid = GetHandleId(GetExpiredTimer());
    float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        StunUnitACF(GetFilterUnit(), 1);
    }
    return true;
}

void ArcueidSpellRFunction3()
{
    int i = 1;
    int hid = GetHandleId(GetExpiredTimer());
    int LocTime = LoadInteger(GameHashTable, hid, 0);
    float LocDamage;

    if (StopSpell(hid, 0) == false)
    {
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 15){
            LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 150 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * .5f;
            PlaySoundWithVolumeACF(GeneralSounds[1], 60, 0);
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
            SetUnitScaleAndTime(GlobalUnit, 1.5f, 1.5f);
            SetUnitVertexColor(GlobalUnit, 255, 255, 255, 185);
            DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
            UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A04U"));
            SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A04U"), false);
            SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iTarget), 600, 4000);
        }
        if (LocTime == 25){
            DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BlackBlink.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
        }
        if (LocTime == 30){
            UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04U"));
            SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("A04U"), false);
            SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iCaster), 700, 4000);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Attack Two");
        }
    }
    if (LocTime == 60)
    {
        LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 50 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true) * .5f;
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), LoadUnitHandle(GameHashTable, hid, iTarget), LocDamage);
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)));
        SetUnitScaleAndTime(GlobalUnit, 1.5f, 1.5f);
        SetUnitVertexColor(GlobalUnit, 255, 255, 255, 185);
        SetUnitFlyHeight(GlobalUnit, 800, 99999);
        SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iTarget), 0, 2000);
        SetUnitFlyHeight(LoadUnitHandle(GameHashTable, hid, iCaster), 0, 99999);
        LinearDisplacement(LoadUnitHandle(GameHashTable, hid, iTarget), AngleBetweenPointsRW(LoadLocationHandle(GameHashTable, hid, 102), LoadLocationHandle(GameHashTable, hid, 103)), 250, .2f, .01f, false, false, "origin", "");
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 102));
        RemoveLocation(LoadLocationHandle(GameHashTable, hid, 103));
    }

    if (LocTime == 80)
    {
        SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
        CreateNUnitsAtLocACF(1, FourCC("u00D"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), GetRandomReal(0, 360));
        SetUnitScale(GlobalUnit, 1.5f, 1.5f, 1.5f);
        while (true) {
            if (i == 3) break;
            CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
            SetUnitScaleAndTime(GlobalUnit, GetRandomReal(1.5f, 2.f), 1.5f);
            SetUnitVertexColor(GlobalUnit, 255, 255, 255, 185);
            i = i + 1;
        }
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
        UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A04U"));
        UnitRemoveAbility(LoadUnitHandle(GameHashTable, hid, iCaster), FourCC("A04U"));
        GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 400, Filter(@ArcueidSpellRFunction2));
        ClearAllData(hid);
    }
}

void ArcueidSpellRFunction4()
{
    timer tmr = CreateTimer();
    int hid = GetHandleId(tmr);
    PlaySoundWithVolumeACF(ArcueidSounds[3], 100, 0);
    SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
    SaveUnitHandle(GameHashTable, hid, iTarget, GetSpellTargetUnit());
    SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
    SaveLocationHandle(GameHashTable, hid, 103, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iTarget)));
    UnitAddAbility(LoadUnitHandle(GameHashTable, hid, iTarget), FourCC("A054"));
    SetPlayerAbilityAvailable(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iTarget)), FourCC("A054"), false);
    PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    SetUnitTimeScale(LoadUnitHandle(GameHashTable, hid, iCaster), 1.75f);
    SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Attack Slam");
    TimerStart(tmr, .01f, true, @ArcueidSpellRFunction3);
}

bool ArcueidSpellTFunction1()
{
    return GetSpellAbilityId() == FourCC("A02A");
}

bool ArcueidSpellTFunction2()
{
    int i = 1;
    int hid = GetHandleId(GetExpiredTimer());
    float LocDamage = GetHeroLevel(LoadUnitHandle(GameHashTable, hid, iCaster)) * 200 + GetHeroInt(LoadUnitHandle(GameHashTable, hid, iCaster), true);
    if (IsUnitEnemy(GetFilterUnit(), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)))){
        while (true) {
            if (i == 3) break;
            GlobalUnit = CreateUnit(GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), FourCC("u011"), GetUnitX(GetFilterUnit()), GetUnitY(GetFilterUnit()), i * GetRandomInt(60, 90));
            UnitAddAbility(GlobalUnit, FourCC("A04U"));
            SetUnitFlyHeight(GlobalUnit, GetUnitFlyHeight(GetFilterUnit()) + 50, 9999);
            SetUnitScaleAndTime(GlobalUnit, .75f, .75f);
            i = i + 1;
        }
        DamageTargetACF(LoadUnitHandle(GameHashTable, hid, iCaster), GetFilterUnit(), LocDamage);
        DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", GetFilterUnit(), "chest"));
        DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", GetFilterUnit(), "head"));
    }
    return true;
}

void ArcueidSpellTFunction3()
{
    int i = 1;
    int hid = GetHandleId(GetExpiredTimer());
    int LocTime = LoadInteger(GameHashTable, hid, 0);
    if (StopSpell(hid, 0) == false)
    {
        SaveInteger(GameHashTable, hid, 0, LocTime + 1);
        if (LocTime == 25){
            ShowUnit(LoadUnitHandle(GameHashTable, hid, iCaster), false);
            SetUnitPositionLoc(LoadUnitHandle(GameHashTable, hid, iCaster), LoadLocationHandle(GameHashTable, hid, 103));
        }
        if (LocTime == 45){
            GroupEnumUnitsInRangeOfLoc(GroupEnum, LoadLocationHandle(GameHashTable, hid, 103), 600, Filter(@ArcueidSpellTFunction2));
        }
        if (LocTime == 50){
            ShowUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Stand");
            if (GetLocalPlayer() == GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster))){
                ClearSelection();
                SelectUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
            }
            while (true) {
                if (i == 3) break;
                CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 103), 0);
                SetUnitScaleAndTime(GlobalUnit, 2.f, GetRandomReal(.5f, 2));
                i = i + 1;
            }
            ClearAllData(hid);
        }
    }
}

void ArcueidSpellTFunction4()
{
    timer tmr = CreateTimer();
    int hid = GetHandleId(tmr);
    if (IsTerrainPathable(GetSpellTargetX(), GetSpellTargetY(), PATHING_TYPE_WALKABILITY) == false){
        PlaySoundWithVolumeACF(ArcueidSounds[4], 100, 0);
        SaveInteger(GameHashTable, hid, 0, 0);
        SaveUnitHandle(GameHashTable, hid, iCaster, GetTriggerUnit());
        SaveLocationHandle(GameHashTable, hid, 102, GetUnitLoc(LoadUnitHandle(GameHashTable, hid, iCaster)));
        SaveLocationHandle(GameHashTable, hid, 103, GetSpellTargetLoc());
        PauseUnit(LoadUnitHandle(GameHashTable, hid, iCaster), true);
        CreateNUnitsAtLocACF(1, FourCC("u00E"), GetOwningPlayer(LoadUnitHandle(GameHashTable, hid, iCaster)), LoadLocationHandle(GameHashTable, hid, 102), 0);
        SetUnitAnimation(LoadUnitHandle(GameHashTable, hid, iCaster), "Spell Six");
        DestroyEffect(AddSpecialEffectLoc("GeneralEffects\\BlackBlink.mdx", LoadLocationHandle(GameHashTable, hid, 102)));
        TimerStart(tmr, .01f, true, @ArcueidSpellTFunction3);
    }
    else {
        IssueImmediateOrder(GetTriggerUnit(), "stop");
        DestroyTimer(tmr);
    }
}

void HeroInit11()
{
    trigger t;

    ArcueidSounds.resize( 5 );
    ArcueidSounds[0] = CreateSound("Characters\\Arcueid\\Sounds\\ArcueidSpellQSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ArcueidSounds[1] = CreateSound("Characters\\Arcueid\\Sounds\\ArcueidSpellWSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ArcueidSounds[2] = CreateSound("Characters\\Arcueid\\Sounds\\ArcueidSpellESound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ArcueidSounds[3] = CreateSound("Characters\\Arcueid\\Sounds\\ArcueidSpellRSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    ArcueidSounds[4] = CreateSound("Characters\\Arcueid\\Sounds\\ArcueidSpellTSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ArcueidSpellQFunction1));
    TriggerAddAction(t, @ArcueidSpellQFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ArcueidSpellWFunction1));
    TriggerAddAction(t, @ArcueidSpellWFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ArcueidSpellEFunction1));
    TriggerAddAction(t, @ArcueidSpellEFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ArcueidSpellRFunction1));
    TriggerAddAction(t, @ArcueidSpellRFunction4);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(t, Condition(@ArcueidSpellTFunction1));
    TriggerAddAction(t, @ArcueidSpellTFunction4);
}

void HeroInit( int id )
{
    switch( id )
    {
        case 1: HeroInit1( ); break;
        case 2: HeroInit2( ); break;
        case 3: HeroInit3( ); break;
        case 4: HeroInit4( ); break;
        case 5: HeroInit5( ); break;
        case 6: HeroInit6( ); break;
        case 7: HeroInit7( ); break;
        case 8: HeroInit8( ); break;
        case 9: HeroInit9( ); break;
        case 10: HeroInit10( ); break;
        case 11: HeroInit11( ); break;
    }
}

void DefaultCommandsTriggers()
{
    trigger t;

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-save", true);
    TriggerAddAction(t, @SaveLocationAction);
    
    t = CreateTrigger();
    TriggerRegisterAnyPlayerEventRW(t, EVENT_PLAYER_END_CINEMATIC);
    TriggerAddAction(t, @ESCToSaveAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-t", true);
    TriggerAddCondition(t, Condition(@TeleportationCommandCondition));
    TriggerAddAction(t, @TeleportationCommandAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-combinations", true);
    TriggerAddAction(t, @ItemCombinationsCommandAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-1", true);
    TriggerAddAction(t, @DisplayHealthByTextAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-2", true);
    TriggerAddAction(t, @PressEscToSaveLocationActivationAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-3", true);
    TriggerAddAction(t, @DisplayYourSavedPositionAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-4", true);
    TriggerAddAction(t, @DisplayYourTeammatesSavedPositionAction);

    t = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(t, EVENT_PLAYER_UNIT_SELECTED);
    TriggerAddAction(t, @HealthDisplayReaderAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-commands", true);
    TriggerAddAction(t, @DisplayCommandsAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-TestCommands", true);
    TriggerAddAction(t, @TestCommandsDisplayAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-Contacts", true);
    TriggerAddAction(t, @MapInfoAndContactsActions);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-non", true);
    TriggerAddAction(t, @EnableNotificationAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-noff", true);
    TriggerAddAction(t, @DisableNotificationAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-clear", true);
    TriggerAddAction(t, @ClearMessagesAction);
}

void CreateLocalTimers()
{
    TimerStart(CreateTimer(), 30.f, true, @CommandsNotificationAction);
}

void GameTriggers()
{
    int i = 0;
    TR_SelectionMode = CreateTrigger();
    TriggerRegisterDialogEvent(TR_SelectionMode, ModeSelectionDialog);
    TriggerAddAction(TR_SelectionMode, @ModeSelectionFunction2);
    while (true) {
        if (i > 7) break;
        if (GetPlayerController(Player(i)) == MAP_CONTROL_USER && GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING){
            TotalPlayers = TotalPlayers + 1;
            if (GetPlayerTeam(Player(i)) == 0)
            {
                TeamPlayers[0]++;
            }
            else
            {
                TeamPlayers[1]++;
            }
        }
        i = i + 1;
    }
    i = 0;
    GameTrigArr[0] = CreateTrigger();
    while (true) {
        if (i > 9) break;
        TriggerRegisterPlayerAllianceChange(GameTrigArr[0], Player(i), ALLIANCE_SHARED_CONTROL);
        i = i + 1;
    }
    TriggerAddAction(GameTrigArr[0], @DisableSharedUnitsAct);
    GameTrigArr[1] = CreateTrigger();
    TriggerRegisterTimerEvent(GameTrigArr[1], 0, false);
    TriggerAddAction(GameTrigArr[1], @MultiBoardCreationFunction1);
    GameTrigArr[4] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[4], EVENT_PLAYER_UNIT_DEATH);
    TriggerAddCondition(GameTrigArr[4], Condition(@RegisterHeroDeathCondition));
    TriggerAddAction(GameTrigArr[4], @RegisterHeroDeathAction);
    GameTrigArr[5] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[5], EVENT_PLAYER_UNIT_DEATH);
    TriggerAddCondition(GameTrigArr[5], Condition(@WinGameEndCondition1));
    TriggerAddAction(GameTrigArr[5], @WinGameEndFunction1);
    GameTrigArr[6] = CreateTrigger();
    TriggerRegisterAnyPlayerEventRW(GameTrigArr[6], EVENT_PLAYER_LEAVE);
    TriggerAddAction(GameTrigArr[6], @RegisterPlayerLeaveAction);
    GameTrigArr[7] = CreateTrigger();
    DisableTrigger(GameTrigArr[7]);
    TriggerRegisterAnyUnitEventRW(GameTrigArr[7], EVENT_PLAYER_UNIT_SELECTED);
    TriggerAddAction(GameTrigArr[7], @HeroSelectionAction);
    GameTrigArr[8] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[8], EVENT_PLAYER_HERO_LEVEL);
    TriggerAddAction(GameTrigArr[8], @HeroLevelUpCheck);
    GameTrigArr[9] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[9], EVENT_PLAYER_UNIT_DEATH);
    TriggerAddAction(GameTrigArr[9], @MainBossStatBoostAction);
    GameTrigArr[10] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[10], EVENT_PLAYER_UNIT_PICKUP_ITEM);
    TriggerAddCondition(GameTrigArr[10], Condition(@CombineItemsCondition));
    TriggerAddAction(GameTrigArr[10], @CombineItemsAction);
    GameTrigArr[11] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[11], EVENT_PLAYER_UNIT_DROP_ITEM);
    TriggerAddAction(GameTrigArr[11], @MapItemRemovalAction);
    GameTrigArr[12] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[12], EVENT_PLAYER_HERO_LEVEL);
    TriggerAddAction(GameTrigArr[12], @HeroAbilityUnlockAction);
    GameTrigArr[13] = CreateTrigger();
    TriggerRegisterUnitEvent(GameTrigArr[13], MainBossUnit1, EVENT_UNIT_DEATH);
    TriggerAddAction(GameTrigArr[13], @BossKillFunction1);
    GameTrigArr[14] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[14], EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddAction(GameTrigArr[14], @AbilityTextTagCreationAction);
    GameTrigArr[15] = CreateTrigger();
    TriggerRegisterDialogEvent(GameTrigArr[15], KillSelectionDialog);
    TriggerAddAction(GameTrigArr[15], @KillSelectionDialogAction);
    GameTrigArr[16] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[16], EVENT_PLAYER_UNIT_PICKUP_ITEM);
    TriggerAddAction(GameTrigArr[16], @CloakOfFlamesPickUp);
    GameTrigArr[17] = CreateTrigger();
    TriggerRegisterPlayerUnitEvent(GameTrigArr[17], Player(PLAYER_NEUTRAL_AGGRESSIVE), EVENT_PLAYER_UNIT_DEATH, nil);
    TriggerAddCondition(GameTrigArr[17], Condition(@KilledBossesCountCondition));
    TriggerAddAction(GameTrigArr[17], @KilledBossesCountAction);
    GameTrigArr[18] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[18], EVENT_PLAYER_UNIT_PICKUP_ITEM);
    TriggerAddAction(GameTrigArr[18], @ItemOwnerSettingAction);
    GameTrigArr[19] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[19], EVENT_PLAYER_UNIT_PICKUP_ITEM);
    TriggerAddAction(GameTrigArr[19], @PersonalItemAction1);
    GameTrigArr[20] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[20], EVENT_PLAYER_UNIT_PICKUP_ITEM);
    TriggerAddCondition(GameTrigArr[20], Condition(@StrTomeUsageCondition));
    TriggerAddAction(GameTrigArr[20], @StrTomeUsageAction);
    GameTrigArr[21] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[21], EVENT_PLAYER_UNIT_PICKUP_ITEM);
    TriggerAddCondition(GameTrigArr[21], Condition(@AgiTomeUsageCondition));
    TriggerAddAction(GameTrigArr[21], @AgiTomeUsageAction);
    GameTrigArr[22] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[22], EVENT_PLAYER_UNIT_PICKUP_ITEM);
    TriggerAddCondition(GameTrigArr[22], Condition(@IntTomeUsageCondition));
    TriggerAddAction(GameTrigArr[22], @IntTomeUsageAction);
    GameTrigArr[23] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[23], EVENT_PLAYER_UNIT_USE_ITEM);
    TriggerAddCondition(GameTrigArr[23], Condition(@ShadowScrollItemUsageCondition));
    TriggerAddAction(GameTrigArr[23], @ShadowScrollItemUsageAction1);
    GameTrigArr[24] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[24], EVENT_PLAYER_UNIT_USE_ITEM);
    TriggerAddCondition(GameTrigArr[24], Condition(@RedTabletUsageCondition));
    TriggerAddAction(GameTrigArr[24], @RedTabletUsageAction);
    GameTrigArr[25] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[25], EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(GameTrigArr[25], Condition(@KunaiOfBouldersCondition));
    TriggerAddAction(GameTrigArr[25], @KunaiOfBouldersAction);
    GameTrigArr[26] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[26], EVENT_PLAYER_UNIT_SPELL_EFFECT);
    TriggerAddCondition(GameTrigArr[26], Condition(@AntiTeleportationStoneCondition));
    TriggerAddAction(GameTrigArr[26], @AntiTeleportationStoneAction);
    GameTrigArr[27] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[27], EVENT_PLAYER_UNIT_USE_ITEM);
    TriggerAddCondition(GameTrigArr[27], Condition(@ScrollOfTeleportationCondition));
    TriggerAddAction(GameTrigArr[27], @ScrollOfTeleportationAction);
    GameTrigArr[28] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[28], EVENT_PLAYER_UNIT_DEATH);
    TriggerAddAction(GameTrigArr[28], @ReviveSystemAction);
    GameTrigArr[29] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[29], EVENT_PLAYER_UNIT_USE_ITEM);
    TriggerAddCondition(GameTrigArr[29], Condition(@KawarimiUseCondition));
    TriggerAddAction(GameTrigArr[29], @KawarimiUseAction);
    GameTrigArr[30] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[30], EVENT_PLAYER_UNIT_DEATH);
    TriggerAddCondition(GameTrigArr[30], Condition(@KawarimiBreakCondition));
    TriggerAddAction(GameTrigArr[30], @KawarimiBreakAction);
    GameTrigArr[31] = CreateTrigger();
    TriggerRegisterAnyUnitEventRW(GameTrigArr[31], EVENT_PLAYER_UNIT_PICKUP_ITEM);
    TriggerAddAction(GameTrigArr[31], @ItemCombinationAction);

	trigger t = CreateTrigger( );
	TriggerRegisterAnyUnitEventRW( t, EVENT_PLAYER_UNIT_DAMAGED );
	TriggerAddAction( t, @OnPlayerUnitDamaged );
}

void GameSounds()
{
    GeneralSounds.resize( 4 );
    GeneralSounds[0] = CreateSound("GeneralSounds\\BloodFlow.mp3", false, false, false, 10, 10, "DefaultEAXON");
    GeneralSounds[1] = CreateSound("GeneralSounds\\KickSound1.mp3", false, false, false, 10, 10, "DefaultEAXON");
    GeneralSounds[2] = CreateSound("GeneralSounds\\GlassShatterSound.mp3", false, false, false, 10, 10, "DefaultEAXON");
    GeneralSounds[3] = CreateSound("GeneralSounds\\SlamSound.mp3", false, false, false, 10, 10, "DefaultEAXON");
}

void EnterRectEventsFunction()
{
    trigger t;
    region reg;

    worldBounds = GetWorldBounds();

    t = CreateTrigger();
    reg = CreateRegion( );
    RegionAddRect(reg, worldBounds );
    TriggerRegisterEnterRegion(t, reg, nil);
    TriggerAddAction(t, @EnteringUnitCheckAction);

    t = CreateTrigger();

    reg = CreateRegion( );
    RegionAddRect(reg, TeamStartRectArr[0]);
    TriggerRegisterEnterRegion(t, reg, nil);

    reg = CreateRegion( );
    RegionAddRect(reg, TeamStartRectArr[1]);
    TriggerRegisterEnterRegion(t, reg, nil);

    TriggerAddAction(t, @CreepAndIllusionRemoverAction);

    t = CreateTrigger();
    reg = CreateRegion( );
    RegionAddRect(reg, worldBounds );
    TriggerRegisterEnterRegion(t, reg, nil);
    TriggerAddCondition(t, Condition(@DummyUnitRemovalCondition));
    TriggerAddAction(t, @DummyUnitRemovalAction);

    t = CreateTrigger();
    reg = CreateRegion( );
    RegionAddRect(reg, CircleRectArr[0]);
    TriggerRegisterEnterRegion(t, reg, nil);
    TriggerAddCondition(t, Condition(@UnitCreationWithCircleCond));
    TriggerAddAction(t, @UnitCreationOnTopLeftAction);

    t = CreateTrigger();
    reg = CreateRegion( );
    RegionAddRect(reg, CircleRectArr[1]);
    TriggerRegisterEnterRegion(t, reg, nil);
    TriggerAddCondition(t, Condition(@UnitCreationWithCircleCond));
    TriggerAddAction(t, @UnitCreationOnBottomLeftAction);

    t = CreateTrigger();
    reg = CreateRegion( );
    RegionAddRect(reg, CircleRectArr[3]);
    TriggerRegisterEnterRegion(t, reg, nil);
    TriggerAddCondition(t, Condition(@UnitCreationWithCircleCond));
    TriggerAddAction(t, @UnitCreationOnTopRightAction);

    t = CreateTrigger();
    reg = CreateRegion( );
    RegionAddRect(reg, CircleRectArr[2]);
    TriggerRegisterEnterRegion(t, reg, nil);
    TriggerAddCondition(t, Condition(@UnitCreationWithCircleCond));
    TriggerAddAction(t, @UnitCreationOnBottomRightAction);
}

void AllRegions()
{
    CircleRectArr[1] = Rect( - 2688, - 1920, - 2432, - 1600);
    CircleRectArr[3] = Rect(2464, - 1920, 2720, - 1600);
    CircleRectArr[0] = Rect( - 2688, 704, - 2432, 960);
    CircleRectArr[2] = Rect(2464, 704, 2720, 960);
    TeamStartRectArr[0] = Rect( - 5440, - 1440, - 3520, 480);
    TeamStartRectArr[1] = Rect(3520, - 1440, 5440, 480);
}

void CreateAllUnits()
{
    int i = 1;
    int NeutID = 1;
    int NeutX = 0;
    int NeutY = 0;
    int ID = 1;
    int LocX = - 5184;
    int LocY = 0;
    bool RevInt = false;
    array<rect> LocRectArr( 6 );
    array<int> NeutralIntArr( 6 );

    LocRectArr[1] = CircleRectArr[0];
    LocRectArr[2] = CircleRectArr[1];
    LocRectArr[3] = Rect( - 672, - 1184, 672, 160);
    LocRectArr[4] = CircleRectArr[3];
    LocRectArr[5] = CircleRectArr[2];
    NeutralIntArr[1] = FourCC("mtk3");
    NeutralIntArr[2] = FourCC("mtk4");
    NeutralIntArr[3] = FourCC("mtk5");
    NeutralIntArr[4] = FourCC("mtk1");
    NeutralIntArr[5] = FourCC("mtk2");
    while (true) {
        if (i > 10) break;
        if (i == 6){
            LocX = 5120;
            LocY = 0;
            ID = 1;
        }
        GlobalUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC("wgt1"), LocX, LocY, 270);
        WaygateSetDestination(GlobalUnit, GetRectCenterX(LocRectArr[ID]), GetRectCenterY(LocRectArr[ID]));
        WaygateActivate(GlobalUnit, true);
        LocY = LocY - 256;
        ID = ID + 1;
        if (i != 3 && i < 6){
            CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC("cofp"), GetRectCenterX(LocRectArr[i]), GetRectCenterY(LocRectArr[i]), 270);
        }
        if (i < 3){
            NeutX = 4032;
            NeutY = - 128;
            NeutID = 1;
            if (i == 2){
                RevInt = true;
            }
            while (true) {
                if (NeutID > 5) break;
                if (NeutID == 2){
                    NeutX = NeutX + 100;
                }
                if (NeutID == 3){
                    NeutX = 4032;
                    NeutY = - 1088;
                }
                CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), NeutralIntArr[NeutID], SwapAmount(NeutX, RevInt), NeutY, 270);
                NeutX = NeutX + 256;
                NeutID = NeutID + 1;
            }
            GlobalUnit = CreateUnit(Player(12 - i), FourCC("base"), SwapAmount(4350, RevInt), - 500, 270);
            SetUnitVertexColor(GlobalUnit, 255, 255, 255, 75);
        }
        i = i + 1;
    }
    ID = GetRandomInt(1, 10);
    if ((TeamPlayers[0] != 0 && TeamPlayers[1] != 0) && (TeamOneSelected[ID] == false && TeamTwoSelected[ID] == false)){
        HeroInit(ID);
    }
    MainBossUnit1 = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), HeroIDArray[ID], 0.f, - 3900.f, 90);
    StartAI(MainBossUnit1);
    SetHeroLevel(MainBossUnit1, 50, false);
    SetHeroStr(MainBossUnit1, 5000, false);
    SetHeroAgi(MainBossUnit1, 5000, false);
    SetHeroInt(MainBossUnit1, 5000, false);
    UnitAddAbility(MainBossUnit1, FourCC("A017"));
    UnitAddAbility(MainBossUnit1, FourCC("A02F"));
    UnitAddItemById(MainBossUnit1, FourCC("I03S"));
    UnitAddItemById(MainBossUnit1, FourCC("I00S"));
    UnitAddItemById(MainBossUnit1, FourCC("I00U"));
    UnitAddItemById(MainBossUnit1, FourCC("I00H"));
    UnitAddItemById(MainBossUnit1, FourCC("I00T"));
    UnitAddItemById(MainBossUnit1, FourCC("I00R"));
}

void QuestCreationFunction()
{
    quest QuestCreation = CreateQuest();
    QuestSetTitle(QuestCreation, "|cFFFFCC00Gameplay Information|r");
    QuestSetDescription(QuestCreation, "|c0000ffffWhen you kill 8 bosses on the lanes you will get -T command|r.
	|cFFFFCC00-T|r: |c0000ffffTeleports you to your|r |cFFFFCC00-save|r |c0000ffff(saved) location|r.
	|cFFFFCC00-commands|r – |c0000ffffShows in-game commands|r.

	|cFFFFCC00Single Player Test Commands:|r
	|cFFFFCC00-nc|r – |c0000ffffRemoves cooldowns on abilities|r.
	|cFFFFCC00-heroes|r – |c0000ffffSpawns all the heroes on the base|r.
	|cFFFFCC00-gold X|r – |c0000ffffInstantly gives 10000000 gold to player X|r.
	|cFFFFCC00-level X|r – |c0000ffffSets the level of selected hero to X|r.
	|cFFFFCC00-NoCreep|r – |c0000ffffDisables creep spawn system in the middle|r.
	|cFFFFCC00-SpawnTestUnit|r – |c0000ffffSpawns a test unit for spell testing|r." );
    QuestSetIconPath(QuestCreation, "Characters\\SaberAlter\\ReplaceableTextures\\CommandButtons\\BTNSaberAlterIcon.blp");
    QuestSetRequired(QuestCreation, true);
    QuestSetDiscovered(QuestCreation, true);
    QuestSetCompleted(QuestCreation, false);
    QuestCreation = CreateQuest();
    QuestSetTitle(QuestCreation, "|cFFFFCC00Map Credits|r");
    QuestSetDescription(QuestCreation, "|c0000ffffThese are the people who have contributed to the map|r:
	|c00FFFF00Andutrache / Nelu_o|r |c00FF0000[FOCS English Team]|r
	|c00FF7F00Space_GlobalTM|r / |c0096FF96gnusik533|r |c0000ffff[ACF Team]|r
	|c00FFFF00Illussionisst / Tekirinmaru / mansuraybov12 / AK-Kisame / brostopchat|r |c006969FF[Bug Reports]|r
	|c00FFFF00brostopchat / Tekirinmaru / Steelvager|r |c006969FF[Map Testers]|r
	|c00FFFF00Kira_Izuru_3th / NN_Dragonforce / steel1606 / Maou / BahaSTI|r |c006969FF[Supporters]|r
	|c00FFFF00Sanyabane|r |c006969FF[Sounds / Textures]|r
	|c00FFFF00Saasura / x10azgmfx / moon_shin / Nagne|r |c006969FF[Animations]|r
	|c00FFFF00Cytyscwyt / Mr.Yagyu|r |c006969FF[Models]|r" );
    QuestSetIconPath(QuestCreation, "Characters\\SaberNero\\ReplaceableTextures\\CommandButtons\\BTNSaberNeroIcon.blp");
    QuestSetRequired(QuestCreation, false);
    QuestSetDiscovered(QuestCreation, true);
    QuestSetCompleted(QuestCreation, false);
    QuestCreation = CreateQuest();
    QuestSetTitle(QuestCreation, "|cFFFFCC00Sponsor Sites|r");
    QuestSetDescription(QuestCreation, "|cFFFFCC00VK Group|r: |c0000ffffhttps://vk.com/acfwc3|r
	|cFFFFCC00Platform|r: |c0000ffffhttps://warcis.com|r
	|cFFFFCC00Host Bot Forum|r: |c0000ffffhttps://vendev.info|r
	|cFFFFCC00WC3 Models and Maps|r: |c0000ffffhttp://chaosrealm.info|r" );
    QuestSetIconPath(QuestCreation, "Characters\\Scathach\\ReplaceableTextures\\CommandButtons\\BTNScathachIcon.blp");
    QuestSetRequired(QuestCreation, false);
    QuestSetDiscovered(QuestCreation, true);
    QuestSetCompleted(QuestCreation, false);
}

void MapCameraBounds()
{
    float minX = - 6144.f + GetCameraMargin(CAMERA_MARGIN_LEFT);
    float minY = - 5120.f + GetCameraMargin(CAMERA_MARGIN_BOTTOM);
    float maxX = 6144.f - GetCameraMargin(CAMERA_MARGIN_RIGHT);
    float maxY = 7168.f - GetCameraMargin(CAMERA_MARGIN_TOP);
    SetCameraBounds(minX, minY, maxX, maxY, minX, maxY, maxX, minY);
}

void TestTriggers()
{
    trigger t;

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-nc", true);
    TriggerAddAction(t, @NoCooldownActivationAction);

    ResetCDTrigger = CreateTrigger();
    DisableTrigger(ResetCDTrigger);
    TriggerRegisterTimerEvent(ResetCDTrigger, .01f, true);
    TriggerAddAction(ResetCDTrigger, @ResetCooldownTimedAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-heroes", true);
    TriggerAddAction(t, @AllHeroPickAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-NoCreep", true);
    TriggerAddAction(t, @NoCreepAction);

    t = CreateTrigger();
    TriggerRegisterPlayerChatEventRW(t, "-SpawnTestUnit", true);
    TriggerAddAction(t, @TestUnitSpawnAction);
}
void SoloGameDetection()
{
    GR_LeftSide = CreateGroup();
    GlobalUnit = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("U001"), - 2200.f, 2800.f, 270);
    GroupAddUnit( GR_LeftSide, GlobalUnit);
    GR_RightSide = CreateGroup();
    GlobalUnit = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), FourCC("U001"), 2200.f, 2800.f, 270);
    GroupAddUnit( GR_RightSide, GlobalUnit);
    if (TeamPlayers[0] == 0 || TeamPlayers[1] == 0)
    {
        SameHeroBoolean = true;
        for ( int i = 0; i < TotalHeroes; i++ )
        {
            HeroInit(i + 1);
        }
        KillLimitInteger1 = 999999999;
        B_IsCreepSpawn = false;
        DestroyTrigger(TR_SelectionMode);
        TestTriggers( );
        EnableTrigger(GameTrigArr[7]);
        TimerStart(CreateTimer(), 1, true, @InGameTimerAction);
    }
    else {
        TimerStart(CreateTimer(), 2, false, @ModeSelectionFunction1);
        CreepSpawn1Action( );
    }
}

void MapDataSetting()
{
    SetWaterBaseColor(255, 255, 255, 255);
    SetSkyModel("Environment\\Sky\\Sky\\SkyLight.mdl");
    SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl");
    SetFloatGameState(GAME_STATE_TIME_OF_DAY, 12.f);
    SetTimeOfDayScale(0.f);
    SuspendTimeOfDay(true);
    SetTerrainFogEx(0, 3000.f, 5000.f, .5f, .0f, .0f, .0f);
    NewSoundEnvironment("Default");
    SetMapMusic("Music", true, 0);
    SetMapFlag(MAP_LOCK_RESOURCE_TRADING, true);
    SetMapFlag(MAP_FOG_HIDE_TERRAIN, true);
    SetMapFlag(MAP_SHARED_ADVANCED_CONTROL, false);
    FogEnable(false);
    FogMaskEnable(false);
}

void main()
{
    //InitBlizzard( );
    BossCheckInit( );
    HeroPickArrayCreation( );
    GameSounds( );
    AllRegions( );
    CreateAllUnits( );
    GameCreateVariables( );
    GameCameraSystemInit( );
    DefaultCommandsTriggers( );
    GameTriggers( );
    CreateLocalTimers( );
    EnterRectEventsFunction( );
    MapDataSetting( );
    MapCameraBounds( );
    QuestCreationFunction( );
    MapStartData( );
    PlayerNameSettingAction( );
    SoloGameDetection( );
    UnitCreationAction( );
}

void config()
{
    SetPlayers(10);
    SetTeams(2);

    for ( int i = 0; i < 12; i++ )
    {
        if ( i == 8 || i == 9 ) { continue; }
        player p = Player( i );
        SetPlayerTeam( p, i > 3 && i != 10 ? 1 : 0 );
        SetPlayerRaceSelectable( p, false );
        SetPlayerController( p, i < 10 ? MAP_CONTROL_USER : MAP_CONTROL_COMPUTER );
        SetPlayerRacePreference( p, RACE_PREF_HUMAN );
    }
}
