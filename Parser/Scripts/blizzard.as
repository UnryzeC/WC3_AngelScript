namespace BJ
{
    const float bj_PI = 3.14159f;
    const float bj_E = 2.71828f;
    const float bj_CELLWIDTH = 128.f;
    const float bj_CLIFFHEIGHT = 128.f;
    const float bj_UNIT_FACING = 270.f;
    const float bj_RADTODEG = 180.f / bj_PI;
    const float bj_DEGTORAD = bj_PI / 180.f;
    const float bj_TEXT_DELAY_QUEST = 20.f;
    const float bj_TEXT_DELAY_QUESTUPDATE = 20.f;
    const float bj_TEXT_DELAY_QUESTDONE = 20.f;
    const float bj_TEXT_DELAY_QUESTFAILED = 20.f;
    const float bj_TEXT_DELAY_QUESTREQUIREMENT = 20.f;
    const float bj_TEXT_DELAY_MISSIONFAILED = 20.f;
    const float bj_TEXT_DELAY_ALWAYSHINT = 12.f;
    const float bj_TEXT_DELAY_HINT = 12.f;
    const float bj_TEXT_DELAY_SECRET = 10.f;
    const float bj_TEXT_DELAY_UNITACQUIRED = 15.f;
    const float bj_TEXT_DELAY_UNITAVAILABLE = 10.f;
    const float bj_TEXT_DELAY_ITEMACQUIRED = 10.f;
    const float bj_TEXT_DELAY_WARNING = 12.f;
    const float bj_QUEUE_DELAY_QUEST = 5.f;
    const float bj_QUEUE_DELAY_HINT = 5.f;
    const float bj_QUEUE_DELAY_SECRET = 3.f;
    const float bj_HANDICAP_EASY = 60.f;
    const float bj_GAME_STARTED_THRESHOLD = .01f;
    const float bj_WAIT_FOR_COND_MIN_INTERVAL = .1f;
    const float bj_POLLED_WAIT_INTERVAL = .1f;
    const float bj_POLLED_WAIT_SKIP_THRESHOLD = 2.f;
    const int bj_MAX_INVENTORY = 6;
    const int bj_MAX_PLAYERS = Jass::GetBJMaxPlayers( );
    const int bj_PLAYER_NEUTRAL_VICTIM = Jass::GetBJPlayerNeutralVictim( );
    const int bj_PLAYER_NEUTRAL_EXTRA = Jass::GetBJPlayerNeutralExtra( );
    const int bj_MAX_PLAYER_SLOTS = Jass::GetBJMaxPlayerSlots( );
    const int bj_MAX_SKELETONS = 25;
    const int bj_MAX_STOCK_ITEM_SLOTS = 11;
    const int bj_MAX_STOCK_UNIT_SLOTS = 11;
    const int bj_MAX_ITEM_LEVEL = 10;
    const float bj_TOD_DAWN = 6.f;
    const float bj_TOD_DUSK = 18.f;
    const float bj_MELEE_STARTING_TOD = 8.f;
    const int bj_MELEE_STARTING_GOLD_V0 = 750;
    const int bj_MELEE_STARTING_GOLD_V1 = 500;
    const int bj_MELEE_STARTING_LUMBER_V0 = 200;
    const int bj_MELEE_STARTING_LUMBER_V1 = 150;
    const int bj_MELEE_STARTING_HERO_TOKENS = 1;
    const int bj_MELEE_HERO_LIMIT = 3;
    const int bj_MELEE_HERO_TYPE_LIMIT = 1;
    const float bj_MELEE_MINE_SEARCH_RADIUS = 2000.f;
    const float bj_MELEE_CLEAR_UNITS_RADIUS = 1500.f;
    const float bj_MELEE_CRIPPLE_TIMEOUT = 120.f;
    const float bj_MELEE_CRIPPLE_MSG_DURATION = 20.f;
    const int bj_MELEE_MAX_TWINKED_HEROES_V0 = 3;
    const int bj_MELEE_MAX_TWINKED_HEROES_V1 = 1;
    const float bj_CREEP_ITEM_DELAY = 0.5f;
    const float bj_STOCK_RESTOCK_INITIAL_DELAY = 120.f;
    const float bj_STOCK_RESTOCK_INTERVAL = 30.f;
    const int bj_STOCK_MAX_ITERATIONS = 20;
    const int bj_MAX_DEST_IN_REGION_EVENTS = 64;
    const int bj_CAMERA_MIN_FARZ = 100;
    const int bj_CAMERA_DEFAULT_DISTANCE = 1650;
    const int bj_CAMERA_DEFAULT_FARZ = 5000;
    const int bj_CAMERA_DEFAULT_AOA = 304;
    const int bj_CAMERA_DEFAULT_FOV = 70;
    const int bj_CAMERA_DEFAULT_ROLL = 0;
    const int bj_CAMERA_DEFAULT_ROTATION = 90;
    const float bj_RESCUE_PING_TIME = 2.f;
    const float bj_NOTHING_SOUND_DURATION = 5.f;
    const float bj_TRANSMISSION_PING_TIME = 1.f;
    const int bj_TRANSMISSION_IND_RED = 255;
    const int bj_TRANSMISSION_IND_BLUE = 255;
    const int bj_TRANSMISSION_IND_GREEN = 255;
    const int bj_TRANSMISSION_IND_ALPHA = 255;
    const float bj_TRANSMISSION_PORT_HANGTIME = 1.5f;
    const float bj_CINEMODE_INTERFACEFADE = .5f;
    const gamespeed bj_CINEMODE_GAMESPEED = Jass::MAP_SPEED_NORMAL;
    const float bj_CINEMODE_VOLUME_UNITMOVEMENT = .4f;
    const float bj_CINEMODE_VOLUME_UNITSOUNDS = .0f;
    const float bj_CINEMODE_VOLUME_COMBAT = .4f;
    const float bj_CINEMODE_VOLUME_SPELLS = .4f;
    const float bj_CINEMODE_VOLUME_UI = .0f;
    const float bj_CINEMODE_VOLUME_MUSIC = 0.55f;
    const float bj_CINEMODE_VOLUME_AMBIENTSOUNDS = 1.f;
    const float bj_CINEMODE_VOLUME_FIRE = 0.6f;
    const float bj_SPEECH_VOLUME_UNITMOVEMENT = .25f;
    const float bj_SPEECH_VOLUME_UNITSOUNDS = .0f;
    const float bj_SPEECH_VOLUME_COMBAT = .25f;
    const float bj_SPEECH_VOLUME_SPELLS = .25f;
    const float bj_SPEECH_VOLUME_UI = .0f;
    const float bj_SPEECH_VOLUME_MUSIC = .55f;
    const float bj_SPEECH_VOLUME_AMBIENTSOUNDS = 1.f;
    const float bj_SPEECH_VOLUME_FIRE = .6f;
    const float bj_SMARTPAN_TRESHOLD_PAN = 500.f;
    const float bj_SMARTPAN_TRESHOLD_SNAP = 3500.f;
    const int bj_MAX_QUEUED_TRIGGERS = 100;
    const float bj_QUEUED_TRIGGER_TIMEOUT = 180.f;
    const int bj_CAMPAIGN_INDEX_T = 0;
    const int bj_CAMPAIGN_INDEX_H = 1;
    const int bj_CAMPAIGN_INDEX_U = 2;
    const int bj_CAMPAIGN_INDEX_O = 3;
    const int bj_CAMPAIGN_INDEX_N = 4;
    const int bj_CAMPAIGN_INDEX_XN = 5;
    const int bj_CAMPAIGN_INDEX_XH = 6;
    const int bj_CAMPAIGN_INDEX_XU = 7;
    const int bj_CAMPAIGN_INDEX_XO = 8;
    const int bj_CAMPAIGN_OFFSET_T = 0;
    const int bj_CAMPAIGN_OFFSET_H = 1;
    const int bj_CAMPAIGN_OFFSET_U = 2;
    const int bj_CAMPAIGN_OFFSET_O = 3;
    const int bj_CAMPAIGN_OFFSET_N = 4;
    const int bj_CAMPAIGN_OFFSET_XN = 0;
    const int bj_CAMPAIGN_OFFSET_XH = 1;
    const int bj_CAMPAIGN_OFFSET_XU = 2;
    const int bj_CAMPAIGN_OFFSET_XO = 3;
    const int bj_MISSION_INDEX_T00 = bj_CAMPAIGN_OFFSET_T;
    const int bj_MISSION_INDEX_T01 = bj_CAMPAIGN_OFFSET_T;
    const int bj_MISSION_INDEX_H00 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H01 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H02 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H03 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H04 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H05 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H06 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H07 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H08 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H09 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H10 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_H11 = bj_CAMPAIGN_OFFSET_H;
    const int bj_MISSION_INDEX_U00 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_U01 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_U02 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_U03 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_U05 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_U07 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_U08 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_U09 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_U10 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_U11 = bj_CAMPAIGN_OFFSET_U;
    const int bj_MISSION_INDEX_O00 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O01 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O02 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O03 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O04 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O05 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O06 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O07 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O08 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O09 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_O10 = bj_CAMPAIGN_OFFSET_O;
    const int bj_MISSION_INDEX_N00 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_N01 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_N02 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_N03 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_N04 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_N05 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_N06 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_N07 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_N08 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_N09 = bj_CAMPAIGN_OFFSET_N;
    const int bj_MISSION_INDEX_XN00 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN01 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN02 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN03 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN04 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN05 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN06 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN07 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN08 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN09 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XN10 = bj_CAMPAIGN_OFFSET_XN;
    const int bj_MISSION_INDEX_XH00 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XH01 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XH02 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XH03 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XH04 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XH05 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XH06 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XH07 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XH08 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XH09 = bj_CAMPAIGN_OFFSET_XH;
    const int bj_MISSION_INDEX_XU00 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU01 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU02 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU03 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU04 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU05 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU06 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU07 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU08 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU09 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU10 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU11 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU12 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XU13 = bj_CAMPAIGN_OFFSET_XU;
    const int bj_MISSION_INDEX_XO00 = bj_CAMPAIGN_OFFSET_XO;
    const int bj_CINEMATICINDEX_TOP = 0;
    const int bj_CINEMATICINDEX_HOP = 1;
    const int bj_CINEMATICINDEX_HED = 2;
    const int bj_CINEMATICINDEX_OOP = 3;
    const int bj_CINEMATICINDEX_OED = 4;
    const int bj_CINEMATICINDEX_UOP = 5;
    const int bj_CINEMATICINDEX_UED = 6;
    const int bj_CINEMATICINDEX_NOP = 7;
    const int bj_CINEMATICINDEX_NED = 8;
    const int bj_CINEMATICINDEX_XOP = 9;
    const int bj_CINEMATICINDEX_XED = 10;
    const int bj_ALLIANCE_UNALLIED = 0;
    const int bj_ALLIANCE_UNALLIED_VISION = 1;
    const int bj_ALLIANCE_ALLIED = 2;
    const int bj_ALLIANCE_ALLIED_VISION = 3;
    const int bj_ALLIANCE_ALLIED_UNITS = 4;
    const int bj_ALLIANCE_ALLIED_ADVUNITS = 5;
    const int bj_ALLIANCE_NEUTRAL = 6;
    const int bj_ALLIANCE_NEUTRAL_VISION = 7;
    const int bj_KEYEVENTTYPE_DEPRESS = 0;
    const int bj_KEYEVENTTYPE_RELEASE = 1;
    const int bj_KEYEVENTKEY_LEFT = 0;
    const int bj_KEYEVENTKEY_RIGHT = 1;
    const int bj_KEYEVENTKEY_DOWN = 2;
    const int bj_KEYEVENTKEY_UP = 3;
    const int bj_TIMETYPE_ADD = 0;
    const int bj_TIMETYPE_SET = 1;
    const int bj_TIMETYPE_SUB = 2;
    const int bj_CAMERABOUNDS_ADJUST_ADD = 0;
    const int bj_CAMERABOUNDS_ADJUST_SUB = 1;
    const int bj_QUESTTYPE_REQ_DISCOVERED = 0;
    const int bj_QUESTTYPE_REQ_UNDISCOVERED = 1;
    const int bj_QUESTTYPE_OPT_DISCOVERED = 2;
    const int bj_QUESTTYPE_OPT_UNDISCOVERED = 3;
    const int bj_QUESTMESSAGE_DISCOVERED = 0;
    const int bj_QUESTMESSAGE_UPDATED = 1;
    const int bj_QUESTMESSAGE_COMPLETED = 2;
    const int bj_QUESTMESSAGE_FAILED = 3;
    const int bj_QUESTMESSAGE_REQUIREMENT = 4;
    const int bj_QUESTMESSAGE_MISSIONFAILED = 5;
    const int bj_QUESTMESSAGE_ALWAYSHINT = 6;
    const int bj_QUESTMESSAGE_HINT = 7;
    const int bj_QUESTMESSAGE_SECRET = 8;
    const int bj_QUESTMESSAGE_UNITACQUIRED = 9;
    const int bj_QUESTMESSAGE_UNITAVAILABLE = 10;
    const int bj_QUESTMESSAGE_ITEMACQUIRED = 11;
    const int bj_QUESTMESSAGE_WARNING = 12;
    const int bj_SORTTYPE_SORTBYVALUE = 0;
    const int bj_SORTTYPE_SORTBYPLAYER = 1;
    const int bj_SORTTYPE_SORTBYLABEL = 2;
    const int bj_CINEFADETYPE_FADEIN = 0;
    const int bj_CINEFADETYPE_FADEOUT = 1;
    const int bj_CINEFADETYPE_FADEOUTIN = 2;
    const int bj_REMOVEBUFFS_POSITIVE = 0;
    const int bj_REMOVEBUFFS_NEGATIVE = 1;
    const int bj_REMOVEBUFFS_ALL = 2;
    const int bj_REMOVEBUFFS_NONTLIFE = 3;
    const int bj_BUFF_POLARITY_POSITIVE = 0;
    const int bj_BUFF_POLARITY_NEGATIVE = 1;
    const int bj_BUFF_POLARITY_EITHER = 2;
    const int bj_BUFF_RESIST_MAGIC = 0;
    const int bj_BUFF_RESIST_PHYSICAL = 1;
    const int bj_BUFF_RESIST_EITHER = 2;
    const int bj_BUFF_RESIST_BOTH = 3;
    const int bj_HEROSTAT_STR = 0;
    const int bj_HEROSTAT_AGI = 1;
    const int bj_HEROSTAT_INT = 2;
    const int bj_MODIFYMETHOD_ADD = 0;
    const int bj_MODIFYMETHOD_SUB = 1;
    const int bj_MODIFYMETHOD_SET = 2;
    const int bj_UNIT_STATE_METHOD_ABSOLUTE = 0;
    const int bj_UNIT_STATE_METHOD_RELATIVE = 1;
    const int bj_UNIT_STATE_METHOD_DEFAULTS = 2;
    const int bj_UNIT_STATE_METHOD_MAXIMUM = 3;
    const int bj_GATEOPERATION_CLOSE = 0;
    const int bj_GATEOPERATION_OPEN = 1;
    const int bj_GATEOPERATION_DESTROY = 2;
    const int bj_GAMECACHE_BOOLEAN = 0;
    const int bj_GAMECACHE_INTEGER = 1;
    const int bj_GAMECACHE_REAL = 2;
    const int bj_GAMECACHE_UNIT = 3;
    const int bj_GAMECACHE_STRING = 4;
    const int bj_HASHTABLE_BOOLEAN = 0;
    const int bj_HASHTABLE_INTEGER = 1;
    const int bj_HASHTABLE_REAL = 2;
    const int bj_HASHTABLE_STRING = 3;
    const int bj_HASHTABLE_HANDLE = 4;
    const int bj_ITEM_STATUS_HIDDEN = 0;
    const int bj_ITEM_STATUS_OWNED = 1;
    const int bj_ITEM_STATUS_INVULNERABLE = 2;
    const int bj_ITEM_STATUS_POWERUP = 3;
    const int bj_ITEM_STATUS_SELLABLE = 4;
    const int bj_ITEM_STATUS_PAWNABLE = 5;
    const int bj_ITEMCODE_STATUS_POWERUP = 0;
    const int bj_ITEMCODE_STATUS_SELLABLE = 1;
    const int bj_ITEMCODE_STATUS_PAWNABLE = 2;
    const int bj_MINIMAPPINGSTYLE_SIMPLE = 0;
    const int bj_MINIMAPPINGSTYLE_FLASHY = 1;
    const int bj_MINIMAPPINGSTYLE_ATTACK = 2;
    const float bj_CORPSE_MAX_DEATH_TIME = 8.f;
    const int bj_CORPSETYPE_FLESH = 0;
    const int bj_CORPSETYPE_BONE = 1;
    const int bj_ELEVATOR_BLOCKER_CODE = 'DTep';
    const int bj_ELEVATOR_CODE01 = 'DTrf';
    const int bj_ELEVATOR_CODE02 = 'DTrx';
    const int bj_ELEVATOR_WALL_TYPE_ALL = 0;
    const int bj_ELEVATOR_WALL_TYPE_EAST = 1;
    const int bj_ELEVATOR_WALL_TYPE_NORTH = 2;
    const int bj_ELEVATOR_WALL_TYPE_SOUTH = 3;
    const int bj_ELEVATOR_WALL_TYPE_WEST = 4;
    force bj_FORCE_ALL_PLAYERS;
    array<force> bj_FORCE_PLAYER( bj_MAX_PLAYER_SLOTS );
    int bj_MELEE_MAX_TWINKED_HEROES = 0;
    rect bj_mapInitialPlayableArea;
    rect bj_mapInitialCameraBounds;
    int bj_forLoopAIndex = 0;
    int bj_forLoopBIndex = 0;
    int bj_forLoopAIndexEnd = 0;
    int bj_forLoopBIndexEnd = 0;
    bool bj_slotControlReady = false;
    array<bool> bj_slotControlUsed( bj_MAX_PLAYER_SLOTS );
    array<mapcontrol> bj_slotControl( bj_MAX_PLAYER_SLOTS );
    timer bj_gameStartedTimer;
    bool bj_gameStarted = false;
    timer bj_volumeGroupsTimer;
    bool bj_isSinglePlayer = false;
    trigger bj_dncSoundsDay;
    trigger bj_dncSoundsNight;
    sound bj_dayAmbientSound;
    sound bj_nightAmbientSound;
    trigger bj_dncSoundsDawn;
    trigger bj_dncSoundsDusk;
    sound bj_dawnSound;
    sound bj_duskSound;
    bool bj_useDawnDuskSounds = true;
    bool bj_dncIsDaytime = false;
    sound bj_rescueSound;
    sound bj_questDiscoveredSound;
    sound bj_questUpdatedSound;
    sound bj_questCompletedSound;
    sound bj_questFailedSound;
    sound bj_questHintSound;
    sound bj_questSecretSound;
    sound bj_questItemAcquiredSound;
    sound bj_questWarningSound;
    sound bj_victoryDialogSound;
    sound bj_defeatDialogSound;
    trigger bj_stockItemPurchased;
    timer bj_stockUpdateTimer;
    array<bool> bj_stockAllowedPermanent( bj_MAX_ITEM_LEVEL + 1 );
    array<bool> bj_stockAllowedCharged( bj_MAX_ITEM_LEVEL + 1 );
    array<bool> bj_stockAllowedArtifact( bj_MAX_ITEM_LEVEL + 1 );
    int bj_stockPickedItemLevel = 0;
    itemtype bj_stockPickedItemType;
    trigger bj_meleeVisibilityTrained;
    bool bj_meleeVisibilityIsDay = true;
    bool bj_meleeGrantHeroItems = false;
    location bj_meleeNearestMineToLoc;
    unit bj_meleeNearestMine;
    float bj_meleeNearestMineDist = .0f;
    bool bj_meleeGameOver = false;
    array<bool> bj_meleeDefeated( bj_MAX_PLAYER_SLOTS );
    array<bool> bj_meleeVictoried( bj_MAX_PLAYER_SLOTS );
    array<unit> bj_ghoul( bj_MAX_PLAYER_SLOTS );
    array<timer> bj_crippledTimer( bj_MAX_PLAYER_SLOTS );
    array<timerdialog> bj_crippledTimerWindows( bj_MAX_PLAYER_SLOTS );
    array<bool> bj_playerIsCrippled( bj_MAX_PLAYER_SLOTS );
    array<bool> bj_playerIsExposed( bj_MAX_PLAYER_SLOTS );
    bool bj_finishSoonAllExposed = false;
    timerdialog bj_finishSoonTimerDialog;
    array<int> bj_meleeTwinkedHeroes( bj_MAX_PLAYER_SLOTS );
    trigger bj_rescueUnitBehavior;
    bool bj_rescueChangeColorUnit = true;
    bool bj_rescueChangeColorBldg = true;
    timer bj_cineSceneEndingTimer;
    sound bj_cineSceneLastSound;
    trigger bj_cineSceneBeingSkipped;
    gamespeed bj_cineModePriorSpeed = Jass::MAP_SPEED_NORMAL;
    bool bj_cineModePriorFogSetting = false;
    bool bj_cineModePriorMaskSetting = false;
    bool bj_cineModeAlreadyIn = false;
    bool bj_cineModePriorDawnDusk = false;
    int bj_cineModeSavedSeed = 0;
    timer bj_cineFadeFinishTimer;
    timer bj_cineFadeContinueTimer;
    float bj_cineFadeContinueRed = .0f;
    float bj_cineFadeContinueGreen = .0f;
    float bj_cineFadeContinueBlue = .0f;
    float bj_cineFadeContinueTrans = .0f;
    float bj_cineFadeContinueDuration = .0f;
    string bj_cineFadeContinueTex = "";
    int bj_queuedExecTotal = 0;
    array<trigger> bj_queuedExecTriggers( bj_MAX_QUEUED_TRIGGERS );
    array<bool> bj_queuedExecUseConds( bj_MAX_QUEUED_TRIGGERS );
    timer bj_queuedExecTimeoutTimer;
    trigger bj_queuedExecTimeout;
    int bj_destInRegionDiesCount = 0;
    trigger bj_destInRegionDiesTrig;
    int bj_groupCountUnits = 0;
    int bj_forceCountPlayers = 0;
    int bj_groupEnumTypeId = 0;
    player bj_groupEnumOwningPlayer;
    group bj_groupAddGroupDest;
    group bj_groupRemoveGroupDest;
    int bj_groupRandomConsidered = 0;
    unit bj_groupRandomCurrentPick;
    group bj_groupLastCreatedDest;
    group bj_randomSubGroupGroup;
    int bj_randomSubGroupWant = 0;
    int bj_randomSubGroupTotal = 0;
    float bj_randomSubGroupChance = .0f;
    int bj_destRandomConsidered = 0;
    destructable bj_destRandomCurrentPick;
    destructable bj_elevatorWallBlocker;
    destructable bj_elevatorNeighbor;
    int bj_itemRandomConsidered = 0;
    item bj_itemRandomCurrentPick;
    int bj_forceRandomConsidered = 0;
    player bj_forceRandomCurrentPick;
    unit bj_makeUnitRescuableUnit;
    bool bj_makeUnitRescuableFlag = true;
    bool bj_pauseAllUnitsFlag = true;
    location bj_enumDestructableCenter;
    float bj_enumDestructableRadius = .0f;
    playercolor bj_setPlayerTargetColor;
    bool bj_isUnitGroupDeadResult = true;
    bool bj_isUnitGroupEmptyResult = true;
    bool bj_isUnitGroupInRectResult = true;
    rect bj_isUnitGroupInRectRect;
    bool bj_changeLevelShowScores = false;
    string bj_changeLevelMapName;
    group bj_suspendDecayFleshGroup;
    group bj_suspendDecayBoneGroup;
    timer bj_delayedSuspendDecayTimer;
    trigger bj_delayedSuspendDecayTrig;
    int bj_livingPlayerUnitsTypeId = 0;
    widget bj_lastDyingWidget;
    uint bj_randDistCount = 0;
    array<int> bj_randDistID;
    array<int> bj_randDistChance;
    unit bj_lastCreatedUnit;
    item bj_lastCreatedItem;
    item bj_lastRemovedItem;
    unit bj_lastHauntedGoldMine;
    destructable bj_lastCreatedDestructable;
    group bj_lastCreatedGroup;
    fogmodifier bj_lastCreatedFogModifier;
    effect bj_lastCreatedEffect;
    weathereffect bj_lastCreatedWeatherEffect;
    terraindeformation bj_lastCreatedTerrainDeformation;
    quest bj_lastCreatedQuest;
    questitem bj_lastCreatedQuestItem;
    defeatcondition bj_lastCreatedDefeatCondition;
    timer bj_lastStartedTimer;
    timerdialog bj_lastCreatedTimerDialog;
    leaderboard bj_lastCreatedLeaderboard;
    multiboard bj_lastCreatedMultiboard;
    sound bj_lastPlayedSound;
    string bj_lastPlayedMusic = "";
    float bj_lastTransmissionDuration = .0f;
    gamecache bj_lastCreatedGameCache;
    hashtable bj_lastCreatedHashtable;
    unit bj_lastLoadedUnit;
    button bj_lastCreatedButton;
    unit bj_lastReplacedUnit;
    texttag bj_lastCreatedTextTag;
    lightning bj_lastCreatedLightning;
    image bj_lastCreatedImage;
    ubersplat bj_lastCreatedUbersplat;
    boolexpr filterIssueHauntOrderAtLocBJ;
    boolexpr filterEnumDestructablesInCircleBJ;
    boolexpr filterGetUnitsInRectOfPlayer;
    boolexpr filterGetUnitsOfTypeIdAll;
    boolexpr filterGetUnitsOfPlayerAndTypeId;
    boolexpr filterMeleeTrainedUnitIsHeroBJ;
    boolexpr filterLivingPlayerUnitsOfTypeId;
    bool bj_wantDestroyGroup = false;

    void BJDebugMsg( string msg )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            Jass::DisplayTimedTextToPlayer( Jass::Player( i ), .0f, .0f, 60.f, msg );
        }
    }

    float RMinBJ( float a, float b )
    {
        if ( a < b )
        {
            return a;
        }
        
        return b;
    }

    float RMaxBJ( float a, float b )
    {
        if ( a < b )
        {
            return b;
        }
        
        return a;
    }

    float RAbsBJ( float a )
    {
        if ( a >= .0f )
        {
            return a;
        }

        return -a;
    }

    float RSignBJ( float a )
    {
        if ( a >= 0.f )
        {
            return 1.f;
        }

        return -1.0;
    }

    int IMinBJ( int a, int b )
    {
        if ( a < b )
        {
            return a;
        }
        
        return b;
    }

    int IMaxBJ( int a, int b )
    {
        if ( a < b )
        {
            return b;
        }
        
        return a;
    }

    int IAbsBJ( int a )
    {
        if ( a >= 0 )
        {
            return a;
        }

        return -a;
    }

    int ISignBJ( int a )
    {
        if ( a >= 0 )
        {
            return 1;
        }
        
        return -1;
    }

    float SinBJ( float degrees )
    {
        return Jass::Sin( degrees * bj_DEGTORAD );
    }

    float CosBJ( float degrees )
    {
        return Jass::Cos( degrees * bj_DEGTORAD );
    }

    float TanBJ( float degrees )
    {
        return Jass::Tan( degrees * bj_DEGTORAD );
    }

    float AsinBJ( float degrees )
    {
        return Jass::Asin( degrees ) * bj_RADTODEG;
    }

    float AcosBJ( float degrees )
    {
        return Jass::Acos( degrees ) * bj_RADTODEG;
    }

    float AtanBJ( float degrees )
    {
        return Jass::Atan( degrees ) * bj_RADTODEG;
    }

    float Atan2BJ( float y, float x )
    {
        return Jass::Atan2( y, x ) * bj_RADTODEG;
    }

    float AngleBetweenPoints( location locA, location locB )
    {
        return bj_RADTODEG * Jass::Atan2( Jass::GetLocationY( locB ) - Jass::GetLocationY( locA ), Jass::GetLocationX( locB ) - Jass::GetLocationX( locA ) );
    }

    float DistanceBetweenPoints( location locA, location locB )
    {
        float dx = Jass::GetLocationX( locB ) - Jass::GetLocationX( locA );
        float dy = Jass::GetLocationY( locB ) - Jass::GetLocationY( locA );
        return Jass::SquareRoot( dx * dx + dy * dy );
    }

    location PolarProjectionBJ( location source, float dist, float angle )
    {
        float x = Jass::GetLocationX( source ) + dist * Jass::Cos( angle * bj_DEGTORAD );
        float y = Jass::GetLocationY( source ) + dist * Jass::Sin( angle * bj_DEGTORAD );
        return Jass::Location( x, y );
    }

    float GetRandomDirectionDeg( )
    {
        return Jass::GetRandomReal( .0f, 360.f );
    }

    float GetRandomPercentageBJ( )
    {
        return Jass::GetRandomReal( .0f, 100.f );
    }

    location GetRandomLocInRect( rect whichRect )
    {
        return Jass::Location( Jass::GetRandomReal( Jass::GetRectMinX( whichRect ), Jass::GetRectMaxX( whichRect ) ), Jass::GetRandomReal( Jass::GetRectMinY( whichRect ), Jass::GetRectMaxY( whichRect ) ) );
    }

    int ModuloInteger( int dividend, int divisor )
    {
        int modulus = dividend - ( dividend / divisor ) * divisor;

        // If the dividend was negative, the above modulus calculation will
        // be negative, but within ( -divisor..0 ).  We can add ( divisor ) to
        // shift this result into the desired range of ( 0..divisor ).
        if ( modulus < 0 )
        {
            modulus = modulus + divisor;
        }

        return modulus;
    }

    float ModuloReal( float dividend, float divisor )
    {
        float modulus = dividend - Jass::I2R( Jass::R2I( dividend / divisor ) ) * divisor;

        // If the dividend was negative, the above modulus calculation will
        // be negative, but within ( -divisor..0 ).  We can add ( divisor ) to
        // shift this result into the desired range of ( 0..divisor ).
        if ( modulus < 0 )
        {
            modulus = modulus + divisor;
        }

        return modulus;
    }

    location OffsetLocation( location loc, float dx, float dy )
    {
        return Jass::Location( Jass::GetLocationX( loc ) + dx, Jass::GetLocationY( loc ) + dy );
    }

    rect OffsetRectBJ( rect r, float dx, float dy )
    {
        return Jass::Rect( Jass::GetRectMinX( r ) + dx, Jass::GetRectMinY( r ) + dy, Jass::GetRectMaxX( r ) + dx, Jass::GetRectMaxY( r ) + dy );
    }

    rect RectFromCenterSizeBJ( location center, float width, float height )
    {
        float x = Jass::GetLocationX( center );
        float y = Jass::GetLocationY( center );
        return Jass::Rect( x - width * 0.5f, y - height * 0.5f, x + width * 0.5f, y + height * 0.5f );
    }

    bool RectContainsCoords( rect r, float x, float y )
    {
        return ( Jass::GetRectMinX( r ) <= x ) && ( x <= Jass::GetRectMaxX( r ) ) && ( Jass::GetRectMinY( r ) <= y ) && ( y <= Jass::GetRectMaxY( r ) );
    }

    bool RectContainsLoc( rect r, location loc )
    {
        return RectContainsCoords( r, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
    }

    bool RectContainsUnit( rect r, unit whichUnit )
    {
        return RectContainsCoords( r, Jass::GetUnitX( whichUnit ), Jass::GetUnitY( whichUnit ) );
    }

    bool RectContainsItem( item whichItem, rect r )
    {
        if ( whichItem == nil )
        {
            return false;
        }

        if ( Jass::IsItemOwned( whichItem ) )
        {
            return false;
        }

        return RectContainsCoords( r, Jass::GetItemX( whichItem ), Jass::GetItemY( whichItem ) );
    }

    void ConditionalTriggerExecute( trigger trig )
    {
        if ( Jass::TriggerEvaluate( trig ) )
        {
            Jass::TriggerExecute( trig );
        }
    }

    bool TriggerExecuteBJ( trigger trig, bool checkConditions )
    {
        if ( checkConditions )
        {
            if ( !Jass::TriggerEvaluate( trig ) )
            {
                return false;
            }
        }

        Jass::TriggerExecute( trig );
        return true;
    }

    bool PostTriggerExecuteBJ( trigger trig, bool checkConditions )
    {
        if ( checkConditions )
        {
            if ( !Jass::TriggerEvaluate( trig ) )
            {
                return false;
            }
        }

        Jass::TriggerRegisterTimerEvent( trig, 0, false );
        return true;
    }

    void QueuedTriggerCheck( )
    {
        string s = "TrigQueue Check ";
        
        for ( int i = 0; i < bj_queuedExecTotal; i++ )
        {
            s = s + "q[" + Jass::I2S( i ) + "]=";
            if ( bj_queuedExecTriggers[i] == nil )
            {
                s = s + "nil ";
            }
            else
            {
                s = s + "x ";
            }
        }
        
        s = s + "( " + Jass::I2S( bj_queuedExecTotal ) + " total )";
        Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, 600.f, s );
    }

    int QueuedTriggerGetIndex( trigger trig )
    {
        // Determine which, if any, of the queued triggers is being removed.

        for ( int i = 0; i < bj_queuedExecTotal; i++ )
        {
            if ( bj_queuedExecTriggers[i] == trig )
            {
                return i;
            }
        }

        return -1;
    }

    bool QueuedTriggerRemoveByIndex( int trigIndex )
    {
        // If the to-be-removed index is out of range, fail.
        if ( trigIndex >= bj_queuedExecTotal )
        {
            return false;
        }

        // Shift all queue entries down to fill in the gap.
        bj_queuedExecTotal--;
        
        for ( int i = trigIndex; i < bj_queuedExecTotal; i++ )
        {
            bj_queuedExecTriggers[i] = bj_queuedExecTriggers[i + 1];
            bj_queuedExecUseConds[i] = bj_queuedExecUseConds[i + 1];
        }

        return true;
    }

    bool QueuedTriggerAttemptExec( )
    {
        while ( bj_queuedExecTotal > 0 )
        {
            if ( TriggerExecuteBJ( bj_queuedExecTriggers[0], bj_queuedExecUseConds[0] ) )
            {
                // Timeout the queue if it sits at the front of the queue for too long.
                Jass::TimerStart( bj_queuedExecTimeoutTimer, bj_QUEUED_TRIGGER_TIMEOUT, false, null );
                return true;
            }

            QueuedTriggerRemoveByIndex( 0 );
        }

        return false;
    }

    bool QueuedTriggerAddBJ( trigger trig, bool checkConditions )
    {
        // Make sure our queue isn't full.  If it is, return failure.
        if ( bj_queuedExecTotal >= bj_MAX_QUEUED_TRIGGERS )
        {
            return false;
        }

        // Add the trigger to an array of to-be-executed triggers.
        bj_queuedExecTriggers[bj_queuedExecTotal] = trig;
        bj_queuedExecUseConds[bj_queuedExecTotal] = checkConditions;
        bj_queuedExecTotal++;

        // If this is the only trigger in the queue, run it.
        if ( bj_queuedExecTotal == 1 )
        {
            QueuedTriggerAttemptExec( );
        }

        return true;
    }

    void QueuedTriggerRemoveBJ( trigger trig )
    {
        // Find the trigger's index.
        int trigIndex = QueuedTriggerGetIndex( trig );
        if ( trigIndex == -1 )
        {
            return;
        }

        // Shuffle the other trigger entries down to fill in the gap.
        QueuedTriggerRemoveByIndex( trigIndex );

        // If we just axed the currently running trigger, run the next one.
        if ( trigIndex == 0 )
        {
            Jass::PauseTimer( bj_queuedExecTimeoutTimer );
            QueuedTriggerAttemptExec( );
        }
    }

    void QueuedTriggerDoneBJ( )
    {
        // Make sure there's something on the queue to remove.
        if ( bj_queuedExecTotal <= 0 )
        {
            return;
        }

        // Remove the currently running trigger from the array.
        QueuedTriggerRemoveByIndex( 0 );

        // If other triggers are waiting to run, run one of them.
        Jass::PauseTimer( bj_queuedExecTimeoutTimer );
        QueuedTriggerAttemptExec( );
    }

    void QueuedTriggerClearBJ( )
    {
        Jass::PauseTimer( bj_queuedExecTimeoutTimer );
        bj_queuedExecTotal = 0;
    }

    void QueuedTriggerClearInactiveBJ( )
    {
        bj_queuedExecTotal = IMinBJ( bj_queuedExecTotal, 1 );
    }

    int QueuedTriggerCountBJ( )
    {
        return bj_queuedExecTotal;
    }

    bool IsTriggerQueueEmptyBJ( )
    {
        return bj_queuedExecTotal <= 0;
    }

    bool IsTriggerQueuedBJ( trigger trig )
    {
        return QueuedTriggerGetIndex( trig ) != -1;
    }

    int GetForLoopIndexA( )
    {
        return bj_forLoopAIndex;
    }

    void SetForLoopIndexA( int newIndex )
    {
        bj_forLoopAIndex = newIndex;
    }

    int GetForLoopIndexB( )
    {
        return bj_forLoopBIndex;
    }

    void SetForLoopIndexB( int newIndex )
    {
        bj_forLoopBIndex = newIndex;
    }

    void PolledWait( float duration )
    {
        if ( duration > .0f )
        {
            timer t = Jass::CreateTimer( );
            Jass::TimerStart( t, duration, false, null );
            float timeRemaining = .0f;

            do
            {
                timeRemaining = Jass::TimerGetRemaining( t );

                // If we have a bit of time left, skip past 10% of the remaining
                // duration instead of checking every interval, to minimize the
                // polling on long waits.
                if ( timeRemaining > bj_POLLED_WAIT_SKIP_THRESHOLD )
                {
                    Jass::TriggerSleepAction( 0.1f * timeRemaining );
                }
                else
                {
                    Jass::TriggerSleepAction( bj_POLLED_WAIT_INTERVAL );
                }
            }
            while ( timeRemaining > .0f );

            Jass::DestroyTimer( t );
        }
    }

    int IntegerTertiaryOp( bool flag, int valueA, int valueB )
    {
        return flag ? valueA : valueB;
    }

    void DoNothing( ) { }

    void CommentString( string commentString ) { }

    string StringIdentity( string theString )
    {
        return Jass::GetLocalizedString( theString );
    }

    bool GetBooleanAnd( bool valueA, bool valueB )
    {
        return valueA && valueB;
    }

    bool GetBooleanOr( bool valueA, bool valueB )
    {
        return valueA || valueB;
    }

    int PercentToInt( float percentage, int max )
    {
        int result = Jass::R2I( percentage * Jass::I2R( max ) * 0.01f );

        if ( result < 0 )
        {
            result = 0;
        }
        else if ( result > max )
        {
            result = max;
        }

        return result;
    }

    int PercentTo255( float percentage )
    {
        return PercentToInt( percentage, 255 );
    }

    float GetTimeOfDay( )
    {
        return Jass::GetFloatGameState( Jass::GAME_STATE_TIME_OF_DAY );
    }

    void SetTimeOfDay( float whatTime )
    {
        Jass::SetFloatGameState( Jass::GAME_STATE_TIME_OF_DAY, whatTime );
    }

    void SetTimeOfDayScalePercentBJ( float scalePercent )
    {
        Jass::SetTimeOfDayScale( scalePercent * 0.01f );
    }

    float GetTimeOfDayScalePercentBJ( )
    {
        return Jass::GetTimeOfDayScale( ) * 100.f;
    }

    void PlaySound( string soundName )
    {
        sound soundHandle = Jass::CreateSound( soundName, false, false, true, 12700, 12700, "" );
        Jass::StartSound( soundHandle );
        Jass::KillSoundWhenDone( soundHandle );
    }

    bool CompareLocationsBJ( location A, location B )
    {
        return Jass::GetLocationX( A ) == Jass::GetLocationX( B ) && Jass::GetLocationY( A ) == Jass::GetLocationY( B );
    }

    bool CompareRectsBJ( rect A, rect B )
    {
        return Jass::GetRectMinX( A ) == Jass::GetRectMinX( B ) && Jass::GetRectMinY( A ) == Jass::GetRectMinY( B ) && Jass::GetRectMaxX( A ) == Jass::GetRectMaxX( B ) && Jass::GetRectMaxY( A ) == Jass::GetRectMaxY( B );
    }

    rect GetRectFromCircleBJ( location center, float radius )
    {
        float centerX = Jass::GetLocationX( center );
        float centerY = Jass::GetLocationY( center );
        return Jass::Rect( centerX - radius, centerY - radius, centerX + radius, centerY + radius );
    }

    camerasetup GetCurrentCameraSetup( )
    {
        camerasetup theCam = Jass::CreateCameraSetup( );
        float duration = .0f;
        Jass::CameraSetupSetField( theCam, Jass::CAMERA_FIELD_TARGET_DISTANCE, Jass::GetCameraField( Jass::CAMERA_FIELD_TARGET_DISTANCE ), duration );
        Jass::CameraSetupSetField( theCam, Jass::CAMERA_FIELD_FARZ,            Jass::GetCameraField( Jass::CAMERA_FIELD_FARZ ),            duration );
        Jass::CameraSetupSetField( theCam, Jass::CAMERA_FIELD_ZOFFSET,         Jass::GetCameraField( Jass::CAMERA_FIELD_ZOFFSET ),         duration );
        Jass::CameraSetupSetField( theCam, Jass::CAMERA_FIELD_ANGLE_OF_ATTACK, bj_RADTODEG * Jass::GetCameraField( Jass::CAMERA_FIELD_ANGLE_OF_ATTACK ), duration );
        Jass::CameraSetupSetField( theCam, Jass::CAMERA_FIELD_FIELD_OF_VIEW,   bj_RADTODEG * Jass::GetCameraField( Jass::CAMERA_FIELD_FIELD_OF_VIEW ),   duration );
        Jass::CameraSetupSetField( theCam, Jass::CAMERA_FIELD_ROLL,            bj_RADTODEG * Jass::GetCameraField( Jass::CAMERA_FIELD_ROLL ),            duration );
        Jass::CameraSetupSetField( theCam, Jass::CAMERA_FIELD_ROTATION,        bj_RADTODEG * Jass::GetCameraField( Jass::CAMERA_FIELD_ROTATION ),        duration );
        Jass::CameraSetupSetDestPosition( theCam, Jass::GetCameraTargetPositionX( ), Jass::GetCameraTargetPositionY( ), duration );
        return theCam;
    }

    void CameraSetupApplyForPlayer( bool doPan, camerasetup whichSetup, player whichPlayer, float duration )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::CameraSetupApplyForceDuration( whichSetup, doPan, duration );
        }
    }

    float CameraSetupGetFieldSwap( camerafield whichField, camerasetup whichSetup )
    {
        return Jass::CameraSetupGetField( whichSetup, whichField );
    }

    void SetCameraFieldForPlayer( player whichPlayer, camerafield whichField, float value, float duration )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetCameraField( whichField, value, duration );
        }
    }

    void SetCameraTargetControllerNoZForPlayer( player whichPlayer, unit whichUnit, float xoffset, float yoffset, bool inheritOrientation )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetCameraTargetController( whichUnit, xoffset, yoffset, inheritOrientation );
        }
    }

    void SetCameraPositionForPlayer( player whichPlayer, float x, float y )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetCameraPosition( x, y );
        }
    }

    void SetCameraPositionLocForPlayer( player whichPlayer, location loc )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetCameraPosition( Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
        }
    }

    void RotateCameraAroundLocBJ( float degrees, location loc, player whichPlayer, float duration )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetCameraRotateMode( Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), bj_DEGTORAD * degrees, duration );
        }
    }

    void PanCameraToForPlayer( player whichPlayer, float x, float y )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::PanCameraTo( x, y );
        }
    }

    void PanCameraToLocForPlayer( player whichPlayer, location loc )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::PanCameraTo( Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
        }
    }

    void PanCameraToTimedForPlayer( player whichPlayer, float x, float y, float duration )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::PanCameraToTimed( x, y, duration );
        }
    }

    void PanCameraToTimedLocForPlayer( player whichPlayer, location loc, float duration )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::PanCameraToTimed( Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), duration );
        }
    }

    void PanCameraToTimedLocWithZForPlayer( player whichPlayer, location loc, float zOffset, float duration )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::PanCameraToTimedWithZ( Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), zOffset, duration );
        }
    }

    void SmartCameraPanBJ( player whichPlayer, location loc, float duration )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.

            float dist = DistanceBetweenPoints( loc, Jass::GetCameraTargetPositionLoc( ) );
            if ( dist >= bj_SMARTPAN_TRESHOLD_SNAP )
            {
                // If the user is too far away, snap the camera.
                Jass::PanCameraToTimed( Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), 0 );
            }
            else if ( dist >= bj_SMARTPAN_TRESHOLD_PAN )
            {
                // If the user is moderately close, pan the camera.
                Jass::PanCameraToTimed( Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), duration );
            }
            else
            {
                // User is close enough, so don't touch the camera.
            }
        }
    }

    void SetCinematicCameraForPlayer( player whichPlayer, string cameraModelFile )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetCinematicCamera( cameraModelFile );
        }
    }

    void ResetToGameCameraForPlayer( player whichPlayer, float duration )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::ResetToGameCamera( duration );
        }
    }

    void CameraSetSourceNoiseForPlayer( player whichPlayer, float magnitude, float velocity )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::CameraSetSourceNoise( magnitude, velocity );
        }
    }

    void CameraSetTargetNoiseForPlayer( player whichPlayer, float magnitude, float velocity )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::CameraSetTargetNoise( magnitude, velocity );
        }
    }

    void CameraSetEQNoiseForPlayer( player whichPlayer, float magnitude )
    {
        float richter = magnitude;

        if ( richter > 5.f )
        {
            richter = 5.f;
        }

        if ( richter < 2.f )
        {
            richter = 2.f;
        }

        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::CameraSetTargetNoiseEx( magnitude * 2.f, magnitude * Jass::Pow( 10, richter ), true );
            Jass::CameraSetSourceNoiseEx( magnitude * 2.f, magnitude * Jass::Pow( 10, richter ), true );
        }
    }

    void CameraClearNoiseForPlayer( player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::CameraSetSourceNoise( .0f, .0f );
            Jass::CameraSetTargetNoise( .0f, .0f );
        }
    }

    rect GetCurrentCameraBoundsMapRectBJ( )
    {
        return Jass::Rect( Jass::GetCameraBoundMinX( ), Jass::GetCameraBoundMinY( ), Jass::GetCameraBoundMaxX( ), Jass::GetCameraBoundMaxY( ) );
    }

    rect GetCameraBoundsMapRect( )
    {
        return bj_mapInitialCameraBounds;
    }

    rect GetPlayableMapRect( )
    {
        return bj_mapInitialPlayableArea;
    }

    rect GetEntireMapRect( )
    {
        return Jass::GetWorldBounds( );
    }

    void SetCameraBoundsToRect( rect r )
    {
        float minX = Jass::GetRectMinX( r );
        float minY = Jass::GetRectMinY( r );
        float maxX = Jass::GetRectMaxX( r );
        float maxY = Jass::GetRectMaxY( r );
        Jass::SetCameraBounds( minX, minY, minX, maxY, maxX, maxY, maxX, minY );
    }

    void SetCameraBoundsToRectForPlayerBJ( player whichPlayer, rect r )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            SetCameraBoundsToRect( r );
        }
    }

    void AdjustCameraBoundsBJ( int adjustMethod, float dxWest, float dxEast, float dyNorth, float dySouth )
    {
        float scale = .0f;

        switch( adjustMethod )
        {
            case bj_CAMERABOUNDS_ADJUST_ADD: scale = 1.f; break;
            case bj_CAMERABOUNDS_ADJUST_SUB: scale = -1.f; break;
            default: return; // Unrecognized adjustment method - ignore the request.
        }

        // Adjust the actual camera values
        float minX = Jass::GetCameraBoundMinX( ) - scale * dxWest;
        float maxX = Jass::GetCameraBoundMaxX( ) + scale * dxEast;
        float minY = Jass::GetCameraBoundMinY( ) - scale * dySouth;
        float maxY = Jass::GetCameraBoundMaxY( ) + scale * dyNorth;

        // Make sure the camera bounds are still valid.
        if ( maxX < minX )
        {
            minX = ( minX + maxX ) * .5f;
            maxX = minX;
        }

        if ( maxY < minY )
        {
            minY = ( minY + maxY ) * .5f;
            maxY = minY;
        }

        // Apply the new camera values.
        Jass::SetCameraBounds( minX, minY, minX, maxY, maxX, maxY, maxX, minY );
    }

    void AdjustCameraBoundsForPlayerBJ( int adjustMethod, player whichPlayer, float dxWest, float dxEast, float dyNorth, float dySouth )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            AdjustCameraBoundsBJ( adjustMethod, dxWest, dxEast, dyNorth, dySouth );
        }
    }

    void SetCameraQuickPositionForPlayer( player whichPlayer, float x, float y )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetCameraQuickPosition( x, y );
        }
    }

    void SetCameraQuickPositionLocForPlayer( player whichPlayer, location loc )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetCameraQuickPosition( Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
        }
    }

    void SetCameraQuickPositionLoc( location loc )
    {
        Jass::SetCameraQuickPosition( Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
    }

    void StopCameraForPlayerBJ( player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::StopCamera( );
        }
    }

    void SetCameraOrientControllerForPlayerBJ( player whichPlayer, unit whichUnit, float xoffset, float yoffset )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetCameraOrientController( whichUnit, xoffset, yoffset );
        }
    }

    void CameraSetSmoothingFactorBJ( float factor )
    {
        Jass::CameraSetSmoothingFactor( factor );
    }

    void CameraResetSmoothingFactorBJ( )
    {
        Jass::CameraSetSmoothingFactor( .0f );
    }

    void DisplayTextToForce( force toForce, string message )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), toForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::DisplayTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, message );
        }
    }

    void DisplayTimedTextToForce( force toForce, float duration, string message )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), toForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, duration, message );
        }
    }

    void ClearTextMessagesBJ( force toForce )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), toForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::ClearTextMessages( );
        }
    }

    string SubStringBJ( string source, int start, int end )
    {
        return Jass::SubString( source, start - 1, end );
    }

    int GetHandleIdBJ( handle h )
    {
        return Jass::GetHandleId( h );
    }

    int StringHashBJ( string s )
    {
        return Jass::StringHash( s );
    }

    event TriggerRegisterTimerEventPeriodic( trigger trig, float timeout )
    {
        return Jass::TriggerRegisterTimerEvent( trig, timeout, true );
    }

    event TriggerRegisterTimerEventSingle( trigger trig, float timeout )
    {
        return Jass::TriggerRegisterTimerEvent( trig, timeout, false );
    }

    event TriggerRegisterTimerExpireEventBJ( trigger trig, timer t )
    {
        return Jass::TriggerRegisterTimerExpireEvent( trig, t );
    }

    event TriggerRegisterPlayerUnitEventSimple( trigger trig, player whichPlayer, playerunitevent whichEvent )
    {
        return Jass::TriggerRegisterPlayerUnitEvent( trig, whichPlayer, whichEvent, nil );
    }

    void TriggerRegisterAnyUnitEventBJ( trigger trig, playerunitevent whichEvent )
    {
        for ( int i = 0; i < bj_MAX_PLAYER_SLOTS; i++ )
        {
            Jass::TriggerRegisterPlayerUnitEvent( trig, Jass::Player( i ), whichEvent, nil );
        }
    }

    event TriggerRegisterPlayerSelectionEventBJ( trigger trig, player whichPlayer, bool selected )
    {
        if ( selected )
        {
            return Jass::TriggerRegisterPlayerUnitEvent( trig, whichPlayer, Jass::EVENT_PLAYER_UNIT_SELECTED, nil );
        }

        return Jass::TriggerRegisterPlayerUnitEvent( trig, whichPlayer, Jass::EVENT_PLAYER_UNIT_DESELECTED, nil );
    }

    event TriggerRegisterPlayerKeyEventBJ( trigger trig, player whichPlayer, int keType, int keKey )
    {
        if ( keType != bj_KEYEVENTTYPE_DEPRESS && keType != bj_KEYEVENTTYPE_RELEASE ) { return nil; }
        // Depress/Release event - find out what key
        
        switch( keKey )
        {
            case bj_KEYEVENTKEY_LEFT:   return Jass::TriggerRegisterPlayerEvent( trig, whichPlayer, keType == bj_KEYEVENTTYPE_DEPRESS ? Jass::EVENT_PLAYER_ARROW_LEFT_DOWN : Jass::EVENT_PLAYER_ARROW_LEFT_UP );
            case bj_KEYEVENTKEY_RIGHT:  return Jass::TriggerRegisterPlayerEvent( trig, whichPlayer, keType == bj_KEYEVENTTYPE_DEPRESS ? Jass::EVENT_PLAYER_ARROW_RIGHT_DOWN : Jass::EVENT_PLAYER_ARROW_LEFT_UP );
            case bj_KEYEVENTKEY_DOWN:   return Jass::TriggerRegisterPlayerEvent( trig, whichPlayer, keType == bj_KEYEVENTTYPE_DEPRESS ? Jass::EVENT_PLAYER_ARROW_DOWN_DOWN : Jass::EVENT_PLAYER_ARROW_DOWN_UP );
            case bj_KEYEVENTKEY_UP:     return Jass::TriggerRegisterPlayerEvent( trig, whichPlayer, keType == bj_KEYEVENTTYPE_DEPRESS ? Jass::EVENT_PLAYER_ARROW_UP_DOWN : Jass::EVENT_PLAYER_ARROW_UP_UP );
        }

        return nil; // Unrecognized key - ignore the request && return failure.
    }

    event TriggerRegisterPlayerEventVictory( trigger trig, player whichPlayer )
    {
        return Jass::TriggerRegisterPlayerEvent( trig, whichPlayer, Jass::EVENT_PLAYER_VICTORY );
    }

    event TriggerRegisterPlayerEventDefeat( trigger trig, player whichPlayer )
    {
        return Jass::TriggerRegisterPlayerEvent( trig, whichPlayer, Jass::EVENT_PLAYER_DEFEAT );
    }

    event TriggerRegisterPlayerEventLeave( trigger trig, player whichPlayer )
    {
        return Jass::TriggerRegisterPlayerEvent( trig, whichPlayer, Jass::EVENT_PLAYER_LEAVE );
    }

    event TriggerRegisterPlayerEventAllianceChanged( trigger trig, player whichPlayer )
    {
        return Jass::TriggerRegisterPlayerEvent( trig, whichPlayer, Jass::EVENT_PLAYER_ALLIANCE_CHANGED );
    }

    event TriggerRegisterPlayerEventEndCinematic( trigger trig, player whichPlayer )
    {
        return Jass::TriggerRegisterPlayerEvent( trig, whichPlayer, Jass::EVENT_PLAYER_END_CINEMATIC );
    }

    event TriggerRegisterGameStateEventTimeOfDay( trigger trig, limitop opcode, float limitval )
    {
        return Jass::TriggerRegisterGameStateEvent( trig, Jass::GAME_STATE_TIME_OF_DAY, opcode, limitval );
    }

    event TriggerRegisterEnterRegionSimple( trigger trig, region whichRegion )
    {
        return Jass::TriggerRegisterEnterRegion( trig, whichRegion, nil );
    }

    event TriggerRegisterLeaveRegionSimple( trigger trig, region whichRegion )
    {
        return Jass::TriggerRegisterLeaveRegion( trig, whichRegion, nil );
    }

    event TriggerRegisterEnterRectSimple( trigger trig, rect r )
    {
        region rectRegion = Jass::CreateRegion( );
        Jass::RegionAddRect( rectRegion, r );
        return Jass::TriggerRegisterEnterRegion( trig, rectRegion, nil );
    }

    event TriggerRegisterLeaveRectSimple( trigger trig, rect r )
    {
        region rectRegion = Jass::CreateRegion( );
        Jass::RegionAddRect( rectRegion, r );
        return Jass::TriggerRegisterLeaveRegion( trig, rectRegion, nil );
    }

    event TriggerRegisterDistanceBetweenUnits( trigger trig, unit whichUnit, boolexpr condition, float range )
    {
        return Jass::TriggerRegisterUnitInRange( trig, whichUnit, range, condition );
    }

    event TriggerRegisterUnitInRangeSimple( trigger trig, float range, unit whichUnit )
    {
        return Jass::TriggerRegisterUnitInRange( trig, whichUnit, range, nil );
    }

    event TriggerRegisterUnitLifeEvent( trigger trig, unit whichUnit, limitop opcode, float limitval )
    {
        return Jass::TriggerRegisterUnitStateEvent( trig, whichUnit, Jass::UNIT_STATE_LIFE, opcode, limitval );
    }

    event TriggerRegisterUnitManaEvent( trigger trig, unit whichUnit, limitop opcode, float limitval )
    {
        return Jass::TriggerRegisterUnitStateEvent( trig, whichUnit, Jass::UNIT_STATE_MANA, opcode, limitval );
    }

    event TriggerRegisterDialogEventBJ( trigger trig, dialog whichDialog )
    {
        return Jass::TriggerRegisterDialogEvent( trig, whichDialog );
    }

    event TriggerRegisterShowSkillEventBJ( trigger trig )
    {
        return Jass::TriggerRegisterGameEvent( trig, Jass::EVENT_GAME_SHOW_SKILL );
    }

    event TriggerRegisterBuildSubmenuEventBJ( trigger trig )
    {
        return Jass::TriggerRegisterGameEvent( trig, Jass::EVENT_GAME_BUILD_SUBMENU );
    }

    event TriggerRegisterGameLoadedEventBJ( trigger trig )
    {
        return Jass::TriggerRegisterGameEvent( trig, Jass::EVENT_GAME_LOADED );
    }

    event TriggerRegisterGameSavedEventBJ( trigger trig )
    {
        return Jass::TriggerRegisterGameEvent( trig, Jass::EVENT_GAME_SAVE );
    }

    void RegisterDestDeathInRegionEnum( )
    {
        bj_destInRegionDiesCount++;
        if ( bj_destInRegionDiesCount <= bj_MAX_DEST_IN_REGION_EVENTS )
        {
            Jass::TriggerRegisterDeathEvent( bj_destInRegionDiesTrig, Jass::GetEnumDestructable( ) );
        }
    }

    void TriggerRegisterDestDeathInRegionEvent( trigger trig, rect r )
    {
        bj_destInRegionDiesTrig = trig;
        bj_destInRegionDiesCount = 0;
        Jass::EnumDestructablesInRect( r, nil, @RegisterDestDeathInRegionEnum );
    }

    weathereffect AddWeatherEffectSaveLast( rect where, int effectID )
    {
        bj_lastCreatedWeatherEffect = Jass::AddWeatherEffect( where, effectID );
        return bj_lastCreatedWeatherEffect;
    }

    weathereffect GetLastCreatedWeatherEffect( )
    {
        return bj_lastCreatedWeatherEffect;
    }

    void RemoveWeatherEffectBJ( weathereffect whichWeatherEffect )
    {
        Jass::RemoveWeatherEffect( whichWeatherEffect );
    }

    terraindeformation TerrainDeformationCraterBJ( float duration, bool permanent, location where, float radius, float depth )
    {
        bj_lastCreatedTerrainDeformation = Jass::TerrainDeformCrater( Jass::GetLocationX( where ), Jass::GetLocationY( where ), radius, depth, Jass::R2I( duration * 1000.f ), permanent );
        return bj_lastCreatedTerrainDeformation;
    }

    terraindeformation TerrainDeformationRippleBJ( float duration, bool limitNeg, location where, float startRadius, float endRadius, float depth, float wavePeriod, float waveWidth )
    {
        if ( endRadius <= .0f || waveWidth <= .0f || wavePeriod <= .0f )
        {
            return nil;
        }

        float timeWave = 2.f * duration / wavePeriod;
        float spaceWave = 2.f * endRadius / waveWidth;
        float radiusRatio = startRadius / endRadius;

        bj_lastCreatedTerrainDeformation = Jass::TerrainDeformRipple( Jass::GetLocationX( where ), Jass::GetLocationY( where ), endRadius, depth, Jass::R2I( duration * 1000.f ), 1, spaceWave, timeWave, radiusRatio, limitNeg );
        return bj_lastCreatedTerrainDeformation;
    }

    terraindeformation TerrainDeformationWaveBJ( float duration, location source, location target, float radius, float depth, float trailDelay )
    {
        float distance = DistanceBetweenPoints( source, target );
        
        if ( distance == .0f || duration <= .0f )
        {
            return nil;
        }

        float dirX = ( Jass::GetLocationX( target ) - Jass::GetLocationX( source ) ) / distance;
        float dirY = ( Jass::GetLocationY( target ) - Jass::GetLocationY( source ) ) / distance;
        float speed = distance / duration;

        bj_lastCreatedTerrainDeformation = Jass::TerrainDeformWave( Jass::GetLocationX( source ), Jass::GetLocationY( source ), dirX, dirY, distance, speed, radius, depth, Jass::R2I( trailDelay * 1000.f ), 1 );
        return bj_lastCreatedTerrainDeformation;
    }

    terraindeformation TerrainDeformationRandomBJ( float duration, location where, float radius, float minDelta, float maxDelta, float updateInterval )
    {
        bj_lastCreatedTerrainDeformation = Jass::TerrainDeformRandom( Jass::GetLocationX( where ), Jass::GetLocationY( where ), radius, minDelta, maxDelta, Jass::R2I( duration * 1000.f ), Jass::R2I( updateInterval * 1000.f ) );
        return bj_lastCreatedTerrainDeformation;
    }

    void TerrainDeformationStopBJ( terraindeformation deformation, float duration )
    {
        Jass::TerrainDeformStop( deformation, Jass::R2I( duration * 1000.f ) );
    }

    terraindeformation GetLastCreatedTerrainDeformation( )
    {
        return bj_lastCreatedTerrainDeformation;
    }

    lightning AddLightningLoc( string codeName, location where1, location where2 )
    {
        bj_lastCreatedLightning = Jass::AddLightningEx( codeName, true, Jass::GetLocationX( where1 ), Jass::GetLocationY( where1 ), Jass::GetLocationZ( where1 ), Jass::GetLocationX( where2 ), Jass::GetLocationY( where2 ), Jass::GetLocationZ( where2 ) );
        return bj_lastCreatedLightning;
    }

    bool DestroyLightningBJ( lightning whichBolt )
    {
        return Jass::DestroyLightning( whichBolt );
    }

    bool MoveLightningLoc( lightning whichBolt, location where1, location where2 )
    {
        return Jass::MoveLightningEx( whichBolt, true, Jass::GetLocationX( where1 ), Jass::GetLocationY( where1 ), Jass::GetLocationZ( where1 ), Jass::GetLocationX( where2 ), Jass::GetLocationY( where2 ), Jass::GetLocationZ( where2 ) );
    }

    float GetLightningColorABJ( lightning whichBolt )
    {
        return Jass::GetLightningColorA( whichBolt );
    }

    float GetLightningColorRBJ( lightning whichBolt )
    {
        return Jass::GetLightningColorR( whichBolt );
    }

    float GetLightningColorGBJ( lightning whichBolt )
    {
        return Jass::GetLightningColorG( whichBolt );
    }

    float GetLightningColorBBJ( lightning whichBolt )
    {
        return Jass::GetLightningColorB( whichBolt );
    }

    bool SetLightningColorBJ( lightning whichBolt, float r, float g, float b, float a )
    {
        return Jass::SetLightningColor( whichBolt, r, g, b, a );
    }

    lightning GetLastCreatedLightningBJ( )
    {
        return bj_lastCreatedLightning;
    }

    string GetAbilityEffectBJ( int abilcode, effecttype t, int index )
    {
        return Jass::GetAbilityEffectById( abilcode, t, index );
    }

    string GetAbilitySoundBJ( int abilcode, soundtype t )
    {
        return Jass::GetAbilitySoundById( abilcode, t );
    }

    int GetTerrainCliffLevelBJ( location where )
    {
        return Jass::GetTerrainCliffLevel( Jass::GetLocationX( where ), Jass::GetLocationY( where ) );
    }

    int GetTerrainTypeBJ( location where )
    {
        return Jass::GetTerrainType( Jass::GetLocationX( where ), Jass::GetLocationY( where ) );
    }

    int GetTerrainVarianceBJ( location where )
    {
        return Jass::GetTerrainVariance( Jass::GetLocationX( where ), Jass::GetLocationY( where ) );
    }

    void SetTerrainTypeBJ( location where, int terrainType, int variation, int area, int shape )
    {
        Jass::SetTerrainType( Jass::GetLocationX( where ), Jass::GetLocationY( where ), terrainType, variation, area, shape );
    }

    bool IsTerrainPathableBJ( location where, pathingtype t )
    {
        return Jass::IsTerrainPathable( Jass::GetLocationX( where ), Jass::GetLocationY( where ), t );
    }

    void SetTerrainPathableBJ( location where, pathingtype t, bool flag )
    {
        Jass::SetTerrainPathable( Jass::GetLocationX( where ), Jass::GetLocationY( where ), t, flag );
    }

    void SetWaterBaseColorBJ( float red, float green, float blue, float transparency )
    {
        Jass::SetWaterBaseColor( PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    fogmodifier CreateFogModifierRectSimple( player whichPlayer, fogstate whichFogState, rect r, bool afterUnits )
    {
        bj_lastCreatedFogModifier = Jass::CreateFogModifierRect( whichPlayer, whichFogState, r, true, afterUnits );
        return bj_lastCreatedFogModifier;
    }

    fogmodifier CreateFogModifierRadiusLocSimple( player whichPlayer, fogstate whichFogState, location center, float radius, bool afterUnits )
    {
        bj_lastCreatedFogModifier = Jass::CreateFogModifierRadiusLoc( whichPlayer, whichFogState, center, radius, true, afterUnits );
        return bj_lastCreatedFogModifier;
    }

    fogmodifier CreateFogModifierRectBJ( bool enabled, player whichPlayer, fogstate whichFogState, rect r )
    {
        bj_lastCreatedFogModifier = Jass::CreateFogModifierRect( whichPlayer, whichFogState, r, true, false );

        if ( enabled )
        {
            Jass::FogModifierStart( bj_lastCreatedFogModifier );
        }

        return bj_lastCreatedFogModifier;
    }

    fogmodifier CreateFogModifierRadiusLocBJ( bool enabled, player whichPlayer, fogstate whichFogState, location center, float radius )
    {
        bj_lastCreatedFogModifier = Jass::CreateFogModifierRadiusLoc( whichPlayer, whichFogState, center, radius, true, false );

        if ( enabled )
        {
            Jass::FogModifierStart( bj_lastCreatedFogModifier );
        }

        return bj_lastCreatedFogModifier;
    }

    fogmodifier GetLastCreatedFogModifier( )
    {
        return bj_lastCreatedFogModifier;
    }

    void FogEnableOn( )
    {
        Jass::FogEnable( true );
    }

    void FogEnableOff( )
    {
        Jass::FogEnable( false );
    }

    void FogMaskEnableOn( )
    {
        Jass::FogMaskEnable( true );
    }

    void FogMaskEnableOff( )
    {
        Jass::FogMaskEnable( false );
    }

    void UseTimeOfDayBJ( bool flag )
    {
        Jass::SuspendTimeOfDay( !flag );
    }

    void SetTerrainFogExBJ( int style, float zstart, float zend, float density, float red, float green, float blue )
    {
        Jass::SetTerrainFogEx( style, zstart, zend, density, red * 0.01f, green * 0.01f, blue * 0.01f );
    }

    void ResetTerrainFogBJ( )
    {
        Jass::ResetTerrainFog( );
    }

    void SetDoodadAnimationBJ( string animName, int doodadID, float radius, location center )
    {
        Jass::SetDoodadAnimation( Jass::GetLocationX( center ), Jass::GetLocationY( center ), radius, doodadID, false, animName, false );
    }

    void SetDoodadAnimationRectBJ( string animName, int doodadID, rect r )
    {
        Jass::SetDoodadAnimationRect( r, doodadID, animName, false );
    }

    void AddUnitAnimationPropertiesBJ( bool add, string animProperties, unit whichUnit )
    {
        Jass::AddUnitAnimationProperties( whichUnit, animProperties, add );
    }

    image CreateImageBJ( string file, float size, location where, float zOffset, int imageType )
    {
        bj_lastCreatedImage = Jass::CreateImage( file, size, size, size, Jass::GetLocationX( where ), Jass::GetLocationY( where ), zOffset, 0, 0, 0, imageType );
        return bj_lastCreatedImage;
    }

    void ShowImageBJ( bool flag, image whichImage )
    {
        Jass::ShowImage( whichImage, flag );
    }

    void SetImagePositionBJ( image whichImage, location where, float zOffset )
    {
        Jass::SetImagePosition( whichImage, Jass::GetLocationX( where ), Jass::GetLocationY( where ), zOffset );
    }

    void SetImageColorBJ( image whichImage, float red, float green, float blue, float alpha )
    {
        Jass::SetImageColor( whichImage, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - alpha ) );
    }

    image GetLastCreatedImage( )
    {
        return bj_lastCreatedImage;
    }

    ubersplat CreateUbersplatBJ( location where, string name, float red, float green, float blue, float alpha, bool forcePaused, bool noBirthTime )
    {
        bj_lastCreatedUbersplat = Jass::CreateUbersplat( Jass::GetLocationX( where ), Jass::GetLocationY( where ), name, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - alpha ), forcePaused, noBirthTime );
        return bj_lastCreatedUbersplat;
    }

    void ShowUbersplatBJ( bool flag, ubersplat whichSplat )
    {
        Jass::ShowUbersplat( whichSplat, flag );
    }

    ubersplat GetLastCreatedUbersplat( )
    {
        return bj_lastCreatedUbersplat;
    }

    void PlaySoundBJ( sound soundHandle )
    {
        bj_lastPlayedSound = soundHandle;

        if ( soundHandle != nil )
        {
            Jass::StartSound( soundHandle );
        }
    }

    void StopSoundBJ( sound soundHandle, bool fadeOut )
    {
        Jass::StopSound( soundHandle, false, fadeOut );
    }

    void SetSoundVolumeBJ( sound soundHandle, float volumePercent )
    {
        Jass::SetSoundVolume( soundHandle, PercentToInt( volumePercent, 127 ) );
    }

    void SetSoundOffsetBJ( float newOffset, sound soundHandle )
    {
        Jass::SetSoundPlayPosition( soundHandle, Jass::R2I( newOffset * 1000.f ) );
    }

    void SetSoundDistanceCutoffBJ( sound soundHandle, float cutoff )
    {
        Jass::SetSoundDistanceCutoff( soundHandle, cutoff );
    }

    void SetSoundPitchBJ( sound soundHandle, float pitch )
    {
        Jass::SetSoundPitch( soundHandle, pitch );
    }

    void SetSoundPositionLocBJ( sound soundHandle, location loc, float z )
    {
        Jass::SetSoundPosition( soundHandle, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), z );
    }

    void AttachSoundToUnitBJ( sound soundHandle, unit whichUnit )
    {
        Jass::AttachSoundToUnit( soundHandle, whichUnit );
    }

    void SetSoundConeAnglesBJ( sound soundHandle, float inside, float outside, float outsideVolumePercent )
    {
        Jass::SetSoundConeAngles( soundHandle, inside, outside, PercentToInt( outsideVolumePercent, 127 ) );
    }

    void KillSoundWhenDoneBJ( sound soundHandle )
    {
        Jass::KillSoundWhenDone( soundHandle );
    }

    void PlaySoundAtPointBJ( sound soundHandle, float volumePercent, location loc, float z )
    {
        SetSoundPositionLocBJ( soundHandle, loc, z );
        SetSoundVolumeBJ( soundHandle, volumePercent );
        PlaySoundBJ( soundHandle );
    }

    void PlaySoundOnUnitBJ( sound soundHandle, float volumePercent, unit whichUnit )
    {
        AttachSoundToUnitBJ( soundHandle, whichUnit );
        SetSoundVolumeBJ( soundHandle, volumePercent );
        PlaySoundBJ( soundHandle );
    }

    void PlaySoundFromOffsetBJ( sound soundHandle, float volumePercent, float startingOffset )
    {
        SetSoundVolumeBJ( soundHandle, volumePercent );
        PlaySoundBJ( soundHandle );
        SetSoundOffsetBJ( startingOffset, soundHandle );
    }

    void PlayMusicBJ( string musicFileName )
    {
        bj_lastPlayedMusic = musicFileName;
        Jass::PlayMusic( musicFileName );
    }

    void PlayMusicExBJ( string musicFileName, float startingOffset, float fadeInTime )
    {
        bj_lastPlayedMusic = musicFileName;
        Jass::PlayMusicEx( musicFileName, Jass::R2I( startingOffset * 1000.f ), Jass::R2I( fadeInTime * 1000.f ) );
    }

    void SetMusicOffsetBJ( float newOffset )
    {
        Jass::SetMusicPlayPosition( Jass::R2I( newOffset * 1000.f ) );
    }

    void PlayThematicMusicBJ( string musicName )
    {
        Jass::PlayThematicMusic( musicName );
    }

    void PlayThematicMusicExBJ( string musicName, float startingOffset )
    {
        Jass::PlayThematicMusicEx( musicName, Jass::R2I( startingOffset * 1000.f ) );
    }

    void SetThematicMusicOffsetBJ( float newOffset )
    {
        Jass::SetThematicMusicPlayPosition( Jass::R2I( newOffset * 1000.f ) );
    }

    void EndThematicMusicBJ( )
    {
        Jass::EndThematicMusic( );
    }

    void StopMusicBJ( bool fadeOut )
    {
        Jass::StopMusic( fadeOut );
    }

    void ResumeMusicBJ( )
    {
        Jass::ResumeMusic( );
    }

    void SetMusicVolumeBJ( float volumePercent )
    {
        Jass::SetMusicVolume( PercentToInt( volumePercent, 127 ) );
    }

    float GetSoundDurationBJ( sound soundHandle )
    {
        if ( soundHandle == nil )
        {
            return bj_NOTHING_SOUND_DURATION;
        }

        return Jass::I2R( Jass::GetSoundDuration( soundHandle ) ) * 0.001f;
    }

    float GetSoundFileDurationBJ( string musicFileName )
    {
        return Jass::I2R( Jass::GetSoundFileDuration( musicFileName ) ) * 0.001;
    }

    sound GetLastPlayedSound( )
    {
        return bj_lastPlayedSound;
    }

    string GetLastPlayedMusic( )
    {
        return bj_lastPlayedMusic;
    }

    void VolumeGroupSetVolumeBJ( volumegroup vgroup, float percent )
    {
        Jass::VolumeGroupSetVolume( vgroup, percent * 0.01f );
    }

    void SetCineModeVolumeGroupsImmediateBJ( )
    {
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_UNITMOVEMENT,  bj_CINEMODE_VOLUME_UNITMOVEMENT );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_UNITSOUNDS,    bj_CINEMODE_VOLUME_UNITSOUNDS );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_COMBAT,        bj_CINEMODE_VOLUME_COMBAT );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_SPELLS,        bj_CINEMODE_VOLUME_SPELLS );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_UI,            bj_CINEMODE_VOLUME_UI );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_MUSIC,         bj_CINEMODE_VOLUME_MUSIC );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_AMBIENTSOUNDS, bj_CINEMODE_VOLUME_AMBIENTSOUNDS );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_FIRE,          bj_CINEMODE_VOLUME_FIRE );
    }

    void SetCineModeVolumeGroupsBJ( )
    {
        // Delay the request if it occurs at map init.
        if ( bj_gameStarted )
        {
            SetCineModeVolumeGroupsImmediateBJ( );
        }
        else
        {
            Jass::TimerStart( bj_volumeGroupsTimer, bj_GAME_STARTED_THRESHOLD, false, @SetCineModeVolumeGroupsImmediateBJ );
        }
    }

    void SetSpeechVolumeGroupsImmediateBJ( )
    {
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_UNITMOVEMENT,  bj_SPEECH_VOLUME_UNITMOVEMENT );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_UNITSOUNDS,    bj_SPEECH_VOLUME_UNITSOUNDS );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_COMBAT,        bj_SPEECH_VOLUME_COMBAT );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_SPELLS,        bj_SPEECH_VOLUME_SPELLS );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_UI,            bj_SPEECH_VOLUME_UI );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_MUSIC,         bj_SPEECH_VOLUME_MUSIC );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_AMBIENTSOUNDS, bj_SPEECH_VOLUME_AMBIENTSOUNDS );
        Jass::VolumeGroupSetVolume( Jass::SOUND_VOLUMEGROUP_FIRE,          bj_SPEECH_VOLUME_FIRE );
    }

    void SetSpeechVolumeGroupsBJ( )
    {
        // Delay the request if it occurs at map init.
        if ( bj_gameStarted )
        {
            SetSpeechVolumeGroupsImmediateBJ( );
        }
        else
        {
            Jass::TimerStart( bj_volumeGroupsTimer, bj_GAME_STARTED_THRESHOLD, false, @SetSpeechVolumeGroupsImmediateBJ );
        }
    }

    void VolumeGroupResetImmediateBJ( )
    {
        Jass::VolumeGroupReset( );
    }

    void VolumeGroupResetBJ( )
    {
        // Delay the request if it occurs at map init.
        if ( bj_gameStarted )
        {
            VolumeGroupResetImmediateBJ( );
        }
        else
        {
            Jass::TimerStart( bj_volumeGroupsTimer, bj_GAME_STARTED_THRESHOLD, false, @VolumeGroupResetImmediateBJ );
        }
    }

    bool GetSoundIsPlayingBJ( sound soundHandle )
    {
        return Jass::GetSoundIsLoading( soundHandle ) || Jass::GetSoundIsPlaying( soundHandle );
    }

    void WaitForSoundBJ( sound soundHandle, float off )
    {
        Jass::TriggerWaitForSound( soundHandle, off );
    }

    void SetMapMusicIndexedBJ( string musicName, int index )
    {
        Jass::SetMapMusic( musicName, false, index );
    }

    void SetMapMusicRandomBJ( string musicName )
    {
        Jass::SetMapMusic( musicName, true, 0 );
    }

    void ClearMapMusicBJ( )
    {
        Jass::ClearMapMusic( );
    }

    void SetStackedSoundBJ( bool add, sound soundHandle, rect r )
    {
        float width = Jass::GetRectMaxX( r ) - Jass::GetRectMinX( r );
        float height = Jass::GetRectMaxY( r ) - Jass::GetRectMinY( r );

        Jass::SetSoundPosition( soundHandle, Jass::GetRectCenterX( r ), Jass::GetRectCenterY( r ), 0 );
        if ( add )
        {
            Jass::RegisterStackedSound( soundHandle, true, width, height );
        }
        else
        {
            Jass::UnregisterStackedSound( soundHandle, true, width, height );
        }
    }

    void StartSoundForPlayerBJ( player whichPlayer, sound soundHandle )
    {
        if ( whichPlayer == Jass::GetLocalPlayer( ) )
        {
            Jass::StartSound( soundHandle );
        }
    }

    void VolumeGroupSetVolumeForPlayerBJ( player whichPlayer, volumegroup vgroup, float scale )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            Jass::VolumeGroupSetVolume( vgroup, scale );
        }
    }

    void EnableDawnDusk( bool flag )
    {
        bj_useDawnDuskSounds = flag;
    }

    bool IsDawnDuskEnabled( )
    {
        return bj_useDawnDuskSounds;
    }

    void SetAmbientDaySound( string inLabel )
    {
        // Stop old sound, if necessary
        if ( bj_dayAmbientSound != nil )
        {
            Jass::StopSound( bj_dayAmbientSound, true, true );
        }

        // Create new sound
        bj_dayAmbientSound = Jass::CreateMIDISound( inLabel, 20, 20 );

        // Start the sound if necessary, based on current time
        float ToD = GetTimeOfDay( );

        if ( ToD >= bj_TOD_DAWN && ToD < bj_TOD_DUSK )
        {
            Jass::StartSound( bj_dayAmbientSound );
        }
    }

    void SetAmbientNightSound( string inLabel )
    {
        // Stop old sound, if necessary
        if ( bj_nightAmbientSound != nil )
        {
            Jass::StopSound( bj_nightAmbientSound, true, true );
        }

        // Create new sound
        bj_nightAmbientSound = Jass::CreateMIDISound( inLabel, 20, 20 );

        // Start the sound if necessary, based on current time
        float ToD = GetTimeOfDay( );

        if ( ToD < bj_TOD_DAWN || ToD >= bj_TOD_DUSK )
        {
            Jass::StartSound( bj_nightAmbientSound );
        }
    }

    effect AddSpecialEffectLocBJ( location where, string modelName )
    {
        bj_lastCreatedEffect = Jass::AddSpecialEffectLoc( modelName, where );
        return bj_lastCreatedEffect;
    }

    effect AddSpecialEffectTargetUnitBJ( string attachPointName, widget targetWidget, string modelName )
    {
        bj_lastCreatedEffect = Jass::AddSpecialEffectTarget( modelName, targetWidget, attachPointName );
        return bj_lastCreatedEffect;
    }

    void DestroyEffectBJ( effect whichEffect )
    {
        Jass::DestroyEffect( whichEffect );
    }

    effect GetLastCreatedEffectBJ( )
    {
        return bj_lastCreatedEffect;
    }

    location GetItemLoc( item whichItem )
    {
        return Jass::Location( Jass::GetItemX( whichItem ), Jass::GetItemY( whichItem ) );
    }

    float GetItemLifeBJ( widget whichWidget )
    {
        return Jass::GetWidgetLife( whichWidget );
    }

    void SetItemLifeBJ( widget whichWidget, float life )
    {
        Jass::SetWidgetLife( whichWidget, life );
    }

    void AddHeroXPSwapped( int xpToAdd, unit whichHero, bool showEyeCandy )
    {
        Jass::AddHeroXP( whichHero, xpToAdd, showEyeCandy );
    }

    void SetHeroLevelBJ( unit whichHero, int newLevel, bool showEyeCandy )
    {
        int oldLevel = Jass::GetHeroLevel( whichHero );

        if ( newLevel > oldLevel )
        {
            Jass::SetHeroLevel( whichHero, newLevel, showEyeCandy );
        }
        else if ( newLevel < oldLevel )
        {
            Jass::UnitStripHeroLevel( whichHero, oldLevel - newLevel );
        }
        else
        {
            // No change in level - ignore the request.
        }
    }

    int DecUnitAbilityLevelSwapped( int abilcode, unit whichUnit )
    {
        return Jass::DecUnitAbilityLevel( whichUnit, abilcode );
    }

    int IncUnitAbilityLevelSwapped( int abilcode, unit whichUnit )
    {
        return Jass::IncUnitAbilityLevel( whichUnit, abilcode );
    }

    int SetUnitAbilityLevelSwapped( int abilcode, unit whichUnit, int level )
    {
        return Jass::SetUnitAbilityLevel( whichUnit, abilcode, level );
    }

    int GetUnitAbilityLevelSwapped( int abilcode, unit whichUnit )
    {
        return Jass::GetUnitAbilityLevel( whichUnit, abilcode );
    }

    bool UnitHasBuffBJ( unit whichUnit, int buffcode )
    {
        return ( Jass::GetUnitAbilityLevel( whichUnit, buffcode ) > 0 );
    }

    bool UnitRemoveBuffBJ( int buffcode, unit whichUnit )
    {
        return Jass::UnitRemoveAbility( whichUnit, buffcode );
    }

    bool UnitAddItemSwapped( item whichItem, unit whichHero )
    {
        return Jass::UnitAddItem( whichHero, whichItem );
    }

    item UnitAddItemByIdSwapped( int itemId, unit whichHero )
    {
        // Create the item at the hero's feet first, && { give it to him.
        // This is to ensure that the item will be left at the hero's feet if
        // his inventory is full. 
        bj_lastCreatedItem = Jass::CreateItem( itemId, Jass::GetUnitX( whichHero ), Jass::GetUnitY( whichHero ) );
        Jass::UnitAddItem( whichHero, bj_lastCreatedItem );
        return bj_lastCreatedItem;
    }

    void UnitRemoveItemSwapped( item whichItem, unit whichHero )
    {
        bj_lastRemovedItem = whichItem;
        Jass::UnitRemoveItem( whichHero, whichItem );
    }

    item UnitRemoveItemFromSlotSwapped( int itemSlot, unit whichHero )
    {
        bj_lastRemovedItem = Jass::UnitRemoveItemFromSlot( whichHero, itemSlot - 1 );
        return bj_lastRemovedItem;
    }

    item CreateItemLoc( int itemId, location loc )
    {
        bj_lastCreatedItem = Jass::CreateItem( itemId, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
        return bj_lastCreatedItem;
    }

    item GetLastCreatedItem( )
    {
        return bj_lastCreatedItem;
    }

    item GetLastRemovedItem( )
    {
        return bj_lastRemovedItem;
    }

    void SetItemPositionLoc( item whichItem, location loc )
    {
        Jass::SetItemPosition( whichItem, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
    }

    int GetLearnedSkillBJ( )
    {
        return Jass::GetLearnedSkill( );
    }

    void SuspendHeroXPBJ( bool flag, unit whichHero )
    {
        Jass::SuspendHeroXP( whichHero, !flag );
    }

    void SetPlayerHandicapXPBJ( player whichPlayer, float handicapPercent )
    {
        Jass::SetPlayerHandicapXP( whichPlayer, handicapPercent * 0.01f );
    }

    float GetPlayerHandicapXPBJ( player whichPlayer )
    {
        return Jass::GetPlayerHandicapXP( whichPlayer ) * 100.f;
    }

    void SetPlayerHandicapBJ( player whichPlayer, float handicapPercent )
    {
        Jass::SetPlayerHandicap( whichPlayer, handicapPercent * 0.01f );
    }

    float GetPlayerHandicapBJ( player whichPlayer )
    {
        return Jass::GetPlayerHandicap( whichPlayer ) * 100.f;
    }

    int GetHeroStatBJ( int whichStat, unit whichHero, bool includeBonuses )
    {
        switch( whichStat )
        {
            case bj_HEROSTAT_STR: return Jass::GetHeroStr( whichHero, includeBonuses );
            case bj_HEROSTAT_AGI: return Jass::GetHeroAgi( whichHero, includeBonuses );
            case bj_HEROSTAT_INT: return Jass::GetHeroInt( whichHero, includeBonuses );
        }

        // Unrecognized hero stat - return 0
        return 0;
    }

    void SetHeroStat( unit whichHero, int whichStat, int value )
    {
        // Ignore requests for negative hero stats.
        if ( value <= 0 )
        {
            return;
        }

        switch( whichStat )
        {
            case bj_HEROSTAT_STR: Jass::SetHeroStr( whichHero, value, true ); break;
            case bj_HEROSTAT_AGI: Jass::SetHeroAgi( whichHero, value, true ); break;
            case bj_HEROSTAT_INT: Jass::SetHeroInt( whichHero, value, true ); break;
            default: break; // Unrecognized hero stat - ignore the request.
        }
    }

    void ModifyHeroStat( int whichStat, unit whichHero, int modifyMethod, int value )
    {
        switch( modifyMethod )
        {
            case bj_MODIFYMETHOD_ADD: SetHeroStat( whichHero, whichStat, GetHeroStatBJ( whichStat, whichHero, false ) + value ); break;
            case bj_MODIFYMETHOD_SUB: SetHeroStat( whichHero, whichStat, GetHeroStatBJ( whichStat, whichHero, false ) - value ); break;
            case bj_MODIFYMETHOD_SET: SetHeroStat( whichHero, whichStat, value ); break;
            default: break; // Unrecognized hero stat - ignore the request.
        }
    }

    bool ModifyHeroSkillPoints( unit whichHero, int modifyMethod, int value )
    {
        switch( modifyMethod )
        {
            case bj_MODIFYMETHOD_ADD: return Jass::UnitModifySkillPoints( whichHero, value );
            case bj_MODIFYMETHOD_SUB: return Jass::UnitModifySkillPoints( whichHero, -value );
            case bj_MODIFYMETHOD_SET: return Jass::UnitModifySkillPoints( whichHero, value - Jass::GetHeroSkillPoints( whichHero ) );
        }

        // Unrecognized modification method - ignore the request && return failure.
        return false;
    }

    bool UnitDropItemPointBJ( unit whichUnit, item whichItem, float x, float y )
    {
        return Jass::UnitDropItemPoint( whichUnit, whichItem, x, y );
    }

    bool UnitDropItemPointLoc( unit whichUnit, item whichItem, location loc )
    {
        return Jass::UnitDropItemPoint( whichUnit, whichItem, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
    }

    bool UnitDropItemSlotBJ( unit whichUnit, item whichItem, int slot )
    {
        return Jass::UnitDropItemSlot( whichUnit, whichItem, slot - 1 );
    }

    bool UnitDropItemTargetBJ( unit whichUnit, item whichItem, widget target )
    {
        return Jass::UnitDropItemTarget( whichUnit, whichItem, target );
    }

    bool UnitUseItemDestructable( unit whichUnit, item whichItem, widget target )
    {
        return Jass::UnitUseItemTarget( whichUnit, whichItem, target );
    }

    bool UnitUseItemPointLoc( unit whichUnit, item whichItem, location loc )
    {
        return Jass::UnitUseItemPoint( whichUnit, whichItem, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
    }

    item UnitItemInSlotBJ( unit whichUnit, int itemSlot )
    {
        return Jass::UnitItemInSlot( whichUnit, itemSlot - 1 );
    }

    int GetInventoryIndexOfItemTypeBJ( unit whichUnit, int itemId )
    {
        for ( int i = 0; i < bj_MAX_INVENTORY; i++ )
        {
            item indexItem = Jass::UnitItemInSlot( whichUnit, i );
            if ( indexItem != nil && Jass::GetItemTypeId( indexItem ) == itemId )
            {
                return i + 1;
            }
        }

        return 0;
    }

    item GetItemOfTypeFromUnitBJ( unit whichUnit, int itemId )
    {
        int i = GetInventoryIndexOfItemTypeBJ( whichUnit, itemId );

        if ( i > 0 )
        {
            return Jass::UnitItemInSlot( whichUnit, i - 1 );
        }
        
        return nil;
    }

    bool UnitHasItemOfTypeBJ( unit whichUnit, int itemId )
    {
        return GetInventoryIndexOfItemTypeBJ( whichUnit, itemId ) > 0;
    }

    int UnitInventoryCount( unit whichUnit )
    {
        int count = 0;

        for ( int i = 0; i < bj_MAX_INVENTORY; i++ )
        {
            if ( Jass::UnitItemInSlot( whichUnit, i ) != nil )
            {
                count++;
            }
        }

        return count;
    }

    int UnitInventorySizeBJ( unit whichUnit )
    {
        return Jass::UnitInventorySize( whichUnit );
    }

    void SetItemInvulnerableBJ( item whichItem, bool flag )
    {
        Jass::SetItemInvulnerable( whichItem, flag );
    }

    void SetItemDropOnDeathBJ( item whichItem, bool flag )
    {
        Jass::SetItemDropOnDeath( whichItem, flag );
    }

    void SetItemDroppableBJ( item whichItem, bool flag )
    {
        Jass::SetItemDroppable( whichItem, flag );
    }

    void SetItemPlayerBJ( item whichItem, player whichPlayer, bool changeColor )
    {
        Jass::SetItemPlayer( whichItem, whichPlayer, changeColor );
    }

    void SetItemVisibleBJ( bool show, item whichItem )
    {
        Jass::SetItemVisible( whichItem, show );
    }

    bool IsItemHiddenBJ( item whichItem )
    {
        return !Jass::IsItemVisible( whichItem );
    }

    int ChooseRandomItemBJ( int level )
    {
        return Jass::ChooseRandomItem( level );
    }

    int ChooseRandomItemExBJ( int level, itemtype whichType )
    {
        return Jass::ChooseRandomItemEx( whichType, level );
    }

    int ChooseRandomNPBuildingBJ( )
    {
        return Jass::ChooseRandomNPBuilding( );
    }

    int ChooseRandomCreepBJ( int level )
    {
        return Jass::ChooseRandomCreep( level );
    }

    void EnumItemsInRectBJ( rect r, CallbackFunc @actionFunc )
    {
        Jass::EnumItemsInRect( r, nil, actionFunc );
    }

    void RandomItemInRectBJEnum( )
    {
        bj_itemRandomConsidered++;

        if ( Jass::GetRandomInt( 1, bj_itemRandomConsidered ) == 1 )
        {
            bj_itemRandomCurrentPick = Jass::GetEnumItem( );
        }
    }

    item RandomItemInRectBJ( rect r, boolexpr filter )
    {
        bj_itemRandomConsidered = 0;
        bj_itemRandomCurrentPick = nil;
        Jass::EnumItemsInRect( r, filter, @RandomItemInRectBJEnum );
        Jass::DestroyBoolExpr( filter );
        return bj_itemRandomCurrentPick;
    }

    item RandomItemInRectSimpleBJ( rect r )
    {
        return RandomItemInRectBJ( r, nil );
    }

    bool CheckItemStatus( item whichItem, int status )
    {
        switch( status )
        {
            case bj_ITEM_STATUS_HIDDEN:         return !Jass::IsItemVisible( whichItem );
            case bj_ITEM_STATUS_OWNED:          return Jass::IsItemOwned( whichItem );
            case bj_ITEM_STATUS_INVULNERABLE:   return Jass::IsItemInvulnerable( whichItem );
            case bj_ITEM_STATUS_POWERUP:        return Jass::IsItemPowerup( whichItem );
            case bj_ITEM_STATUS_SELLABLE:       return Jass::IsItemSellable( whichItem );
            case bj_ITEM_STATUS_PAWNABLE:       return Jass::IsItemPawnable( whichItem );
        }

        // Unrecognized status - return false
        return false;
    }

    bool CheckItemcodeStatus( int itemId, int status )
    {
        switch( status )
        {
            case bj_ITEMCODE_STATUS_POWERUP:    return !Jass::IsItemIdPowerup( itemId );
            case bj_ITEMCODE_STATUS_SELLABLE:   return Jass::IsItemIdSellable( itemId );
            case bj_ITEMCODE_STATUS_PAWNABLE:   return Jass::IsItemIdPawnable( itemId );
        }

        // Unrecognized status - return false
        return false;
    }

    int UnitId2OrderIdBJ( int unitId )
    {
        return unitId;
    }

    int String2UnitIdBJ( string unitIdString )
    {
        return Jass::UnitId( unitIdString );
    }

    string UnitId2StringBJ( int unitId )
    {
        return Jass::UnitId2String( unitId );
    }

    int String2OrderIdBJ( string orderIdString )
    {
        // Check to see if it's a generic order.
        int orderId = Jass::OrderId( orderIdString );
        if ( orderId != 0 )
        {
            return orderId;
        }

        // Check to see if it's a ( train ) unit order.
        orderId = Jass::UnitId( orderIdString );
        if ( orderId != 0 )
        {
            return orderId;
        }

        // Unrecognized - return 0
        return 0;
    }

    string OrderId2StringBJ( int orderId )
    {
        // Check to see if it's a generic order.
        string orderString = Jass::OrderId2String( orderId );
        if ( !orderString.isEmpty( ) )
        {
            return orderString;
        }

        // Check to see if it's a ( train ) unit order.
        return Jass::UnitId2String( orderId );
    }

    int GetIssuedOrderIdBJ( )
    {
        return Jass::GetIssuedOrderId( );
    }

    unit GetKillingUnitBJ( )
    {
        return Jass::GetKillingUnit( );
    }

    unit CreateUnitAtLocSaveLast( player id, int unitid, location loc, float face )
    {
        if ( unitid == 'ugol' )
        {
            bj_lastCreatedUnit = Jass::CreateBlightedGoldmine( id, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), face );
        }
        else
        {
            bj_lastCreatedUnit = Jass::CreateUnitAtLoc( id, unitid, loc, face );
        }

        return bj_lastCreatedUnit;
    }

    unit GetLastCreatedUnit( )
    {
        return bj_lastCreatedUnit;
    }

    group CreateNUnitsAtLoc( int count, int unitId, player whichPlayer, location loc, float face )
    {
        Jass::GroupClear( bj_lastCreatedGroup );
        
        for ( int i = count; i >= 0; i-- )
        {
            CreateUnitAtLocSaveLast( whichPlayer, unitId, loc, face );
            Jass::GroupAddUnit( bj_lastCreatedGroup, bj_lastCreatedUnit );
        }

        return bj_lastCreatedGroup;
    }

    group CreateNUnitsAtLocFacingLocBJ( int count, int unitId, player whichPlayer, location loc, location lookAt )
    {
        return CreateNUnitsAtLoc( count, unitId, whichPlayer, loc, AngleBetweenPoints( loc, lookAt ) );
    }

    void GetLastCreatedGroupEnum( )
    {
        Jass::GroupAddUnit( bj_groupLastCreatedDest, Jass::GetEnumUnit( ) );
    }

    group GetLastCreatedGroup( )
    {
        bj_groupLastCreatedDest = Jass::CreateGroup( );
        Jass::ForGroup( bj_lastCreatedGroup, @GetLastCreatedGroupEnum );
        return bj_groupLastCreatedDest;
    }

    unit CreateCorpseLocBJ( int unitid, player whichPlayer, location loc )
    {
        bj_lastCreatedUnit = Jass::CreateCorpse( whichPlayer, unitid, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), Jass::GetRandomReal( .0f, 360.f ) );
        return bj_lastCreatedUnit;
    }

    void UnitSuspendDecayBJ( bool suspend, unit whichUnit )
    {
        Jass::UnitSuspendDecay( whichUnit, suspend );
    }

    void DelayedSuspendDecayStopAnimEnum( )
    {
        unit enumUnit = Jass::GetEnumUnit( );

        if ( Jass::GetUnitState( enumUnit, Jass::UNIT_STATE_LIFE ) <= .0f )
        {
            Jass::SetUnitTimeScale( enumUnit, 0.0001f );
        }
    }

    void DelayedSuspendDecayBoneEnum( )
    {
        unit enumUnit = Jass::GetEnumUnit( );

        if ( Jass::GetUnitState( enumUnit, Jass::UNIT_STATE_LIFE ) <= .0f )
        {
            Jass::UnitSuspendDecay( enumUnit, true );
            Jass::SetUnitTimeScale( enumUnit, 0.0001f );
        }
    }

    void DelayedSuspendDecayFleshEnum( )
    {
        unit enumUnit = Jass::GetEnumUnit( );

        if ( Jass::GetUnitState( enumUnit, Jass::UNIT_STATE_LIFE ) <= .0f )
        {
            Jass::UnitSuspendDecay( enumUnit, true );
            Jass::SetUnitTimeScale( enumUnit, 10.f );
            Jass::SetUnitAnimation( enumUnit, "decay flesh" );
        }
    }

    void DelayedSuspendDecay( )
    {
        // Switch the global unit groups over to variables && recreate
        // the global versions, so that this @can handle overlapping
        // calls.
        group boneGroup = bj_suspendDecayBoneGroup;
        group fleshGroup = bj_suspendDecayFleshGroup;
        bj_suspendDecayBoneGroup = Jass::CreateGroup( );
        bj_suspendDecayFleshGroup = Jass::CreateGroup( );

        Jass::ForGroup( fleshGroup, @DelayedSuspendDecayStopAnimEnum );
        Jass::ForGroup( boneGroup, @DelayedSuspendDecayStopAnimEnum );

        Jass::TriggerSleepAction( bj_CORPSE_MAX_DEATH_TIME );
        Jass::ForGroup( fleshGroup, @DelayedSuspendDecayFleshEnum );
        Jass::ForGroup( boneGroup, @DelayedSuspendDecayBoneEnum );

        Jass::TriggerSleepAction( 0.05f );
        Jass::ForGroup( fleshGroup, @DelayedSuspendDecayStopAnimEnum );

        Jass::DestroyGroup( boneGroup );
        Jass::DestroyGroup( fleshGroup );
    }

    void DelayedSuspendDecayCreate( )
    {
        bj_delayedSuspendDecayTrig = Jass::CreateTrigger( );
        Jass::TriggerRegisterTimerExpireEvent( bj_delayedSuspendDecayTrig, bj_delayedSuspendDecayTimer );
        Jass::TriggerAddAction( bj_delayedSuspendDecayTrig, @DelayedSuspendDecay );
    }

    unit CreatePermanentCorpseLocBJ( int style, int unitid, player whichPlayer, location loc, float facing )
    {
        bj_lastCreatedUnit = Jass::CreateCorpse( whichPlayer, unitid, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), facing );
        Jass::SetUnitBlendTime( bj_lastCreatedUnit, 0 );

        switch( style )
        {
            case bj_CORPSETYPE_FLESH:
            {
                Jass::SetUnitAnimation( bj_lastCreatedUnit, "decay flesh" );
                Jass::GroupAddUnit( bj_suspendDecayFleshGroup, bj_lastCreatedUnit );
                break;
            }
            case bj_CORPSETYPE_BONE:
            {
                Jass::SetUnitAnimation( bj_lastCreatedUnit, "decay bone" );
                Jass::GroupAddUnit( bj_suspendDecayBoneGroup, bj_lastCreatedUnit );
                break;
            }
            default:
            {
                // Unknown decay style - treat as skeletal.
                Jass::SetUnitAnimation( bj_lastCreatedUnit, "decay bone" );
                Jass::GroupAddUnit( bj_suspendDecayBoneGroup, bj_lastCreatedUnit );
                break;
            }
        }

        Jass::TimerStart( bj_delayedSuspendDecayTimer, 0.05f, false, null );
        return bj_lastCreatedUnit;
    }

    float GetUnitStateSwap( unitstate whichState, unit whichUnit )
    {
        return Jass::GetUnitState( whichUnit, whichState );
    }

    float GetUnitStatePercent( unit whichUnit, unitstate whichState, unitstate whichMaxState )
    {
        float value    = Jass::GetUnitState( whichUnit, whichState );
        float maxValue = Jass::GetUnitState( whichUnit, whichMaxState );

        // Return 0 for nil units.
        if ( whichUnit == nil || maxValue == 0 )
        {
            return .0f;
        }

        return value / maxValue * 100.f;
    }

    float GetUnitLifePercent( unit whichUnit )
    {
        return GetUnitStatePercent( whichUnit, Jass::UNIT_STATE_LIFE, Jass::UNIT_STATE_MAX_LIFE );
    }

    float GetUnitManaPercent( unit whichUnit )
    {
        return GetUnitStatePercent( whichUnit, Jass::UNIT_STATE_MANA, Jass::UNIT_STATE_MAX_MANA );
    }

    void SelectUnitSingle( unit whichUnit )
    {
        Jass::ClearSelection( );
        Jass::SelectUnit( whichUnit, true );
    }

    void SelectGroupBJEnum( )
    {
        Jass::SelectUnit( Jass::GetEnumUnit( ), true );
    }

    void SelectGroupBJ( group g )
    {
        Jass::ClearSelection( );
        Jass::ForGroup( g, @SelectGroupBJEnum );
    }

    void SelectUnitAdd( unit whichUnit )
    {
        Jass::SelectUnit( whichUnit, true );
    }

    void SelectUnitRemove( unit whichUnit )
    {
        Jass::SelectUnit( whichUnit, false );
    }

    void ClearSelectionForPlayer( player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::ClearSelection( );
        }
    }

    void SelectUnitForPlayerSingle( unit whichUnit, player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::ClearSelection( );
            Jass::SelectUnit( whichUnit, true );
        }
    }

    void SelectGroupForPlayerBJ( group g, player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::ClearSelection( );
            Jass::ForGroup( g, @SelectGroupBJEnum );
        }
    }

    void SelectUnitAddForPlayer( unit whichUnit, player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SelectUnit( whichUnit, true );
        }
    }

    void SelectUnitRemoveForPlayer( unit whichUnit, player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SelectUnit( whichUnit, false );
        }
    }

    void SetUnitLifeBJ( unit whichUnit, float newValue )
    {
        Jass::SetUnitState( whichUnit, Jass::UNIT_STATE_LIFE, RMaxBJ( .0f, newValue ) );
    }

    void SetUnitManaBJ( unit whichUnit, float newValue )
    {
        Jass::SetUnitState( whichUnit, Jass::UNIT_STATE_MANA, RMaxBJ( .0f, newValue ) );
    }

    void SetUnitLifePercentBJ( unit whichUnit, float percent )
    {
        Jass::SetUnitState( whichUnit, Jass::UNIT_STATE_LIFE, Jass::GetUnitState( whichUnit, Jass::UNIT_STATE_MAX_LIFE ) * RMaxBJ( .0f, percent ) * 0.01f );
    }

    void SetUnitManaPercentBJ( unit whichUnit, float percent )
    {
        Jass::SetUnitState( whichUnit, Jass::UNIT_STATE_MANA, Jass::GetUnitState( whichUnit, Jass::UNIT_STATE_MAX_MANA ) * RMaxBJ( .0f, percent ) * 0.01f );
    }

    bool IsUnitDeadBJ( unit whichUnit )
    {
        return Jass::GetUnitState( whichUnit, Jass::UNIT_STATE_LIFE ) <= .0f;
    }

    bool IsUnitAliveBJ( unit whichUnit )
    {
        return !IsUnitDeadBJ( whichUnit );
    }

    void IsUnitGroupDeadBJEnum( )
    {
        if ( !IsUnitDeadBJ( Jass::GetEnumUnit( ) ) )
        {
            bj_isUnitGroupDeadResult = false;
        }
    }

    bool IsUnitGroupDeadBJ( group g )
    {
        // If the user wants the group destroyed, remember that fact && clear
        // the flag, in case it is used again in the callback.
        bool wantDestroy = bj_wantDestroyGroup;
        bj_wantDestroyGroup = false;

        bj_isUnitGroupDeadResult = true;
        Jass::ForGroup( g, @IsUnitGroupDeadBJEnum );

        // If the user wants the group destroyed, do so now.
        if ( wantDestroy )
        {
            Jass::DestroyGroup( g );
        }
        return bj_isUnitGroupDeadResult;
    }

    void IsUnitGroupEmptyBJEnum( )
    {
        bj_isUnitGroupEmptyResult = false;
    }

    bool IsUnitGroupEmptyBJ( group g )
    {
        // If the user wants the group destroyed, remember that fact && clear
        // the flag, in case it is used again in the callback.
        bool wantDestroy = bj_wantDestroyGroup;
        bj_wantDestroyGroup = false;

        bj_isUnitGroupEmptyResult = true;
        Jass::ForGroup( g, @IsUnitGroupEmptyBJEnum );

        // If the user wants the group destroyed, do so now.
        if ( wantDestroy )
        {
            Jass::DestroyGroup( g );
        }

        return bj_isUnitGroupEmptyResult;
    }

    void IsUnitGroupInRectBJEnum( )
    {
        if ( !RectContainsUnit( bj_isUnitGroupInRectRect, Jass::GetEnumUnit( ) ) )
        {
            bj_isUnitGroupInRectResult = false;
        }
    }

    bool IsUnitGroupInRectBJ( group g, rect r )
    {
        bj_isUnitGroupInRectResult = true;
        bj_isUnitGroupInRectRect = r;
        Jass::ForGroup( g, @IsUnitGroupInRectBJEnum );
        return bj_isUnitGroupInRectResult;
    }

    bool IsUnitHiddenBJ( unit whichUnit )
    {
        return Jass::IsUnitHidden( whichUnit );
    }

    void ShowUnitHide( unit whichUnit )
    {
        Jass::ShowUnit( whichUnit, false );
    }

    void ShowUnitShow( unit whichUnit )
    {
        // Prevent dead heroes from being unhidden.
        if ( Jass::IsUnitType( whichUnit, Jass::UNIT_TYPE_HERO ) && IsUnitDeadBJ( whichUnit ) )
        {
            return;
        }

        Jass::ShowUnit( whichUnit, true );
    }

    bool IssueHauntOrderAtLocBJFilter( )
    {
        return Jass::GetUnitTypeId( Jass::GetFilterUnit( ) ) == 'ngol';
    }

    bool IssueHauntOrderAtLocBJ( unit whichPeon, location loc )
    {
        // Search for a gold mine within a 1-cell radius of the specified location.
        group g = Jass::CreateGroup( );
        Jass::GroupEnumUnitsInRangeOfLoc( g, loc, 2.f * bj_CELLWIDTH, filterIssueHauntOrderAtLocBJ );
        unit goldMine = Jass::FirstOfGroup( g );
        Jass::DestroyGroup( g );

        // If no mine was found, abort the request.
        if ( goldMine == nil )
        {
            return false;
        }

        // Issue the Haunt Gold Mine order.
        return Jass::IssueTargetOrderById( whichPeon, 'ugol', goldMine );
    }

    bool IssueBuildOrderByIdLocBJ( unit whichPeon, int unitId, location loc )
    {
        if ( unitId == 'ugol' )
        {
            return IssueHauntOrderAtLocBJ( whichPeon, loc );
        }

        return Jass::IssueBuildOrderById( whichPeon, unitId, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
    }

    bool IssueTrainOrderByIdBJ( unit whichUnit, int unitId )
    {
        return Jass::IssueImmediateOrderById( whichUnit, unitId );
    }

    bool GroupTrainOrderByIdBJ( group g, int unitId )
    {
        return Jass::GroupImmediateOrderById( g, unitId );
    }

    bool IssueUpgradeOrderByIdBJ( unit whichUnit, int techId )
    {
        return Jass::IssueImmediateOrderById( whichUnit, techId );
    }

    unit GetAttackedUnitBJ( )
    {
        return Jass::GetTriggerUnit( );
    }

    void SetUnitFlyHeightBJ( unit whichUnit, float newHeight, float rate )
    {
        Jass::SetUnitFlyHeight( whichUnit, newHeight, rate );
    }

    void SetUnitTurnSpeedBJ( unit whichUnit, float turnSpeed )
    {
        Jass::SetUnitTurnSpeed( whichUnit, turnSpeed );
    }

    void SetUnitPropWindowBJ( unit whichUnit, float propWindow )
    {
        float angle = propWindow;

        if ( angle <= .0f )
        {
            angle = 1.f;
        }
        else if ( angle >= 360.f )
        {
            angle = 359.f;
        }
        angle = angle * bj_DEGTORAD;

        Jass::SetUnitPropWindow( whichUnit, angle );
    }

    float GetUnitPropWindowBJ( unit whichUnit )
    {
        return Jass::GetUnitPropWindow( whichUnit ) * bj_RADTODEG;
    }

    float GetUnitDefaultPropWindowBJ( unit whichUnit )
    {
        return Jass::GetUnitDefaultPropWindow( whichUnit );
    }

    void SetUnitBlendTimeBJ( unit whichUnit, float blendTime )
    {
        Jass::SetUnitBlendTime( whichUnit, blendTime );
    }

    void SetUnitAcquireRangeBJ( unit whichUnit, float acquireRange )
    {
        Jass::SetUnitAcquireRange( whichUnit, acquireRange );
    }

    void UnitSetCanSleepBJ( unit whichUnit, bool canSleep )
    {
        Jass::UnitAddSleep( whichUnit, canSleep );
    }

    bool UnitCanSleepBJ( unit whichUnit )
    {
        return Jass::UnitCanSleep( whichUnit );
    }

    void UnitWakeUpBJ( unit whichUnit )
    {
        Jass::UnitWakeUp( whichUnit );
    }

    bool UnitIsSleepingBJ( unit whichUnit )
    {
        return Jass::UnitIsSleeping( whichUnit );
    }

    void WakePlayerUnitsEnum( )
    {
        Jass::UnitWakeUp( Jass::GetEnumUnit( ) );
    }

    void WakePlayerUnits( player whichPlayer )
    {
        group g = Jass::CreateGroup( );
        Jass::GroupEnumUnitsOfPlayer( g, whichPlayer, nil );
        Jass::ForGroup( g, @WakePlayerUnitsEnum );
        Jass::DestroyGroup( g );
    }

    void EnableCreepSleepBJ( bool enable )
    {
        Jass::SetPlayerState( Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE ), Jass::PLAYER_STATE_NO_CREEP_SLEEP, IntegerTertiaryOp( enable, 0, 1 ) );

        // If we're disabling, attempt to wake any already-sleeping creeps.
        if ( !enable )
        {
            WakePlayerUnits( Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE ) );
        }
    }

    bool UnitGenerateAlarms( unit whichUnit, bool generate )
    {
        return Jass::UnitIgnoreAlarm( whichUnit, !generate );
    }

    bool DoesUnitGenerateAlarms( unit whichUnit )
    {
        return !Jass::UnitIgnoreAlarmToggled( whichUnit );
    }

    void PauseAllUnitsBJEnum( )
    {
        Jass::PauseUnit( Jass::GetEnumUnit( ), bj_pauseAllUnitsFlag );
    }

    void PauseAllUnitsBJ( bool pause )
    {
        bj_pauseAllUnitsFlag = pause;
        group g = Jass::CreateGroup( );

        for ( int i = 0; i < bj_MAX_PLAYER_SLOTS; i++ )
        {
            player p = Jass::Player( i );

            // If this is a computer slot, pause/resume the AI.
            if ( Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_COMPUTER )
            {
                Jass::PauseCompAI( p, pause );
            }

            // Enumerate && unpause every unit owned by the player.
            Jass::GroupEnumUnitsOfPlayer( g, p, nil );
            Jass::ForGroup( g, @PauseAllUnitsBJEnum );
            Jass::GroupClear( g );
        }

        Jass::DestroyGroup( g );
    }

    void PauseUnitBJ( bool pause, unit whichUnit )
    {
        Jass::PauseUnit( whichUnit, pause );
    }

    bool IsUnitPausedBJ( unit whichUnit )
    {
        return Jass::IsUnitPaused( whichUnit );
    }

    void UnitPauseTimedLifeBJ( bool flag, unit whichUnit )
    {
        Jass::UnitPauseTimedLife( whichUnit, flag );
    }

    void UnitApplyTimedLifeBJ( float duration, int buffId, unit whichUnit )
    {
        Jass::UnitApplyTimedLife( whichUnit, buffId, duration );
    }

    void UnitShareVisionBJ( bool share, unit whichUnit, player whichPlayer )
    {
        Jass::UnitShareVision( whichUnit, whichPlayer, share );
    }

    void UnitRemoveBuffsBJ( int buffType, unit whichUnit )
    {
        switch( buffType )
        {
            case bj_REMOVEBUFFS_POSITIVE:   Jass::UnitRemoveBuffs( whichUnit, true, false ); break;
            case bj_REMOVEBUFFS_NEGATIVE:   Jass::UnitRemoveBuffs( whichUnit, false, true ); break;
            case bj_REMOVEBUFFS_ALL:        Jass::UnitRemoveBuffs( whichUnit, true, true ); break;
            case bj_REMOVEBUFFS_NONTLIFE:   Jass::UnitRemoveBuffsEx( whichUnit, true, true, false, false, false, true, false ); break;
            default: break; // Unrecognized dispel type - ignore the request.
        }
    }

    void UnitRemoveBuffsExBJ( int polarity, int resist, unit whichUnit, bool bTLife, bool bAura )
    {
        bool bPos   = ( polarity == bj_BUFF_POLARITY_EITHER ) || ( polarity == bj_BUFF_POLARITY_POSITIVE );
        bool bNeg   = ( polarity == bj_BUFF_POLARITY_EITHER ) || ( polarity == bj_BUFF_POLARITY_NEGATIVE );
        bool bMagic = ( resist == bj_BUFF_RESIST_BOTH ) || ( resist == bj_BUFF_RESIST_MAGIC );
        bool bPhys  = ( resist == bj_BUFF_RESIST_BOTH ) || ( resist == bj_BUFF_RESIST_PHYSICAL );

        Jass::UnitRemoveBuffsEx( whichUnit, bPos, bNeg, bMagic, bPhys, bTLife, bAura, false );
    }

    int UnitCountBuffsExBJ( int polarity, int resist, unit whichUnit, bool bTLife, bool bAura )
    {
        bool bPos   = ( polarity == bj_BUFF_POLARITY_EITHER ) || ( polarity == bj_BUFF_POLARITY_POSITIVE );
        bool bNeg   = ( polarity == bj_BUFF_POLARITY_EITHER ) || ( polarity == bj_BUFF_POLARITY_NEGATIVE );
        bool bMagic = ( resist == bj_BUFF_RESIST_BOTH ) || ( resist == bj_BUFF_RESIST_MAGIC );
        bool bPhys  = ( resist == bj_BUFF_RESIST_BOTH ) || ( resist == bj_BUFF_RESIST_PHYSICAL );

        return Jass::UnitCountBuffsEx( whichUnit, bPos, bNeg, bMagic, bPhys, bTLife, bAura, false );
    }

    bool UnitRemoveAbilityBJ( int abilityId, unit whichUnit )
    {
        return Jass::UnitRemoveAbility( whichUnit, abilityId );
    }

    bool UnitAddAbilityBJ( int abilityId, unit whichUnit )
    {
        return Jass::UnitAddAbility( whichUnit, abilityId );
    }

    bool UnitRemoveTypeBJ( unittype whichType, unit whichUnit )
    {
        return Jass::UnitRemoveType( whichUnit, whichType );
    }

    bool UnitAddTypeBJ( unittype whichType, unit whichUnit )
    {
        return Jass::UnitAddType( whichUnit, whichType );
    }

    bool UnitMakeAbilityPermanentBJ( bool permanent, int abilityId, unit whichUnit )
    {
        return Jass::UnitMakeAbilityPermanent( whichUnit, permanent, abilityId );
    }

    void SetUnitExplodedBJ( unit whichUnit, bool exploded )
    {
        Jass::SetUnitExploded( whichUnit, exploded );
    }

    void ExplodeUnitBJ( unit whichUnit )
    {
        Jass::SetUnitExploded( whichUnit, true );
        Jass::KillUnit( whichUnit );
    }

    unit GetTransportUnitBJ( )
    {
        return Jass::GetTransportUnit( );
    }

    unit GetLoadedUnitBJ( )
    {
        return Jass::GetLoadedUnit( );
    }

    bool IsUnitInTransportBJ( unit whichUnit, unit whichTransport )
    {
        return Jass::IsUnitInTransport( whichUnit, whichTransport );
    }

    bool IsUnitLoadedBJ( unit whichUnit )
    {
        return Jass::IsUnitLoaded( whichUnit );
    }

    bool IsUnitIllusionBJ( unit whichUnit )
    {
        return Jass::IsUnitIllusion( whichUnit );
    }

    unit ReplaceUnitBJ( unit whichUnit, int newUnitId, int unitStateMethod )
    {
        unit oldUnit = whichUnit;
        unit newUnit;

        // If we have bogus data, don't attempt the replace.
        if ( oldUnit == nil )
        {
            bj_lastReplacedUnit = oldUnit;
            return oldUnit;
        }

        // Hide the original unit.
        bool wasHidden = Jass::IsUnitHidden( oldUnit );
        Jass::ShowUnit( oldUnit, false );

        // Create the replacement unit.
        if ( newUnitId == 'ugol' )
        {
            newUnit = Jass::CreateBlightedGoldmine( Jass::GetOwningPlayer( oldUnit ), Jass::GetUnitX( oldUnit ), Jass::GetUnitY( oldUnit ), Jass::GetUnitFacing( oldUnit ) );
        }
        else
        {
            newUnit = Jass::CreateUnit( Jass::GetOwningPlayer( oldUnit ), newUnitId, Jass::GetUnitX( oldUnit ), Jass::GetUnitY( oldUnit ), Jass::GetUnitFacing( oldUnit ) );
        }
        
        float oldRatio = .0f;

        // Set the unit's life && mana according to the requested method.
        if ( unitStateMethod == bj_UNIT_STATE_METHOD_RELATIVE )
        {
            // Set the replacement's current/max life ratio to that of the old unit.
            // If both units have mana, do the same for mana.
            if ( Jass::GetUnitState( oldUnit, Jass::UNIT_STATE_MAX_LIFE ) > .0f )
            {
                oldRatio = Jass::GetUnitState( oldUnit, Jass::UNIT_STATE_LIFE ) / Jass::GetUnitState( oldUnit, Jass::UNIT_STATE_MAX_LIFE );
                Jass::SetUnitState( newUnit, Jass::UNIT_STATE_LIFE, oldRatio * Jass::GetUnitState( newUnit, Jass::UNIT_STATE_MAX_LIFE ) );
            }

            if ( Jass::GetUnitState( oldUnit, Jass::UNIT_STATE_MAX_MANA ) > .0f && Jass::GetUnitState( newUnit, Jass::UNIT_STATE_MAX_MANA ) > .0f )
            {
                oldRatio = Jass::GetUnitState( oldUnit, Jass::UNIT_STATE_MANA ) / Jass::GetUnitState( oldUnit, Jass::UNIT_STATE_MAX_MANA );
                Jass::SetUnitState( newUnit, Jass::UNIT_STATE_MANA, oldRatio * Jass::GetUnitState( newUnit, Jass::UNIT_STATE_MAX_MANA ) );
            }
        }
        else if ( unitStateMethod == bj_UNIT_STATE_METHOD_ABSOLUTE )
        {
            // Set the replacement's current life to that of the old unit.
            // If the new unit has mana, do the same for mana.
            Jass::SetUnitState( newUnit, Jass::UNIT_STATE_LIFE, Jass::GetUnitState( oldUnit, Jass::UNIT_STATE_LIFE ) );
            if ( Jass::GetUnitState( newUnit, Jass::UNIT_STATE_MAX_MANA ) > .0f )
            {
                Jass::SetUnitState( newUnit, Jass::UNIT_STATE_MANA, Jass::GetUnitState( oldUnit, Jass::UNIT_STATE_MANA ) );
            }
        }
        else if ( unitStateMethod == bj_UNIT_STATE_METHOD_DEFAULTS )
        {
            // The newly created unit should already have default life && mana.
        }
        else if ( unitStateMethod == bj_UNIT_STATE_METHOD_MAXIMUM )
        {
            // Use max life && mana.
            Jass::SetUnitState( newUnit, Jass::UNIT_STATE_LIFE, Jass::GetUnitState( newUnit, Jass::UNIT_STATE_MAX_LIFE ) );
            Jass::SetUnitState( newUnit, Jass::UNIT_STATE_MANA, Jass::GetUnitState( newUnit, Jass::UNIT_STATE_MAX_MANA ) );
        }
        else
        {
            // Unrecognized unit state method - ignore the request.
        }

        // Mirror properties of the old unit onto the new unit.
        //PauseUnit( newUnit, IsUnitPaused( oldUnit ) )
        Jass::SetResourceAmount( newUnit, Jass::GetResourceAmount( oldUnit ) );

        // If both the old && new units are heroes, handle their hero info.
        if ( Jass::IsUnitType( oldUnit, Jass::UNIT_TYPE_HERO ) && Jass::IsUnitType( newUnit, Jass::UNIT_TYPE_HERO ) )
        {
            Jass::SetHeroXP( newUnit, Jass::GetHeroXP( oldUnit ), false );
            
            for ( int i = 0; i < bj_MAX_INVENTORY; i++ )
            {
                item it = Jass::UnitItemInSlot( oldUnit, i );
                if ( it != nil )
                {
                    Jass::UnitRemoveItem( oldUnit, it );
                    Jass::UnitAddItem( newUnit, it );
                }
            }
        }

        // Remove || kill the original unit.  It is sometimes unsafe to remove
        // hidden units, so kill the original unit if it was previously hidden.
        if ( wasHidden )
        {
            Jass::KillUnit( oldUnit );
            Jass::RemoveUnit( oldUnit );
        }
        else
        {
            Jass::RemoveUnit( oldUnit );
        }

        bj_lastReplacedUnit = newUnit;
        return newUnit;
    }

    unit GetLastReplacedUnitBJ( )
    {
        return bj_lastReplacedUnit;
    }

    void SetUnitPositionLocFacingBJ( unit whichUnit, location loc, float facing )
    {
        Jass::SetUnitPositionLoc( whichUnit, loc );
        Jass::SetUnitFacing( whichUnit, facing );
    }

    void SetUnitPositionLocFacingLocBJ( unit whichUnit, location loc, location lookAt )
    {
        Jass::SetUnitPositionLoc( whichUnit, loc );
        Jass::SetUnitFacing( whichUnit, AngleBetweenPoints( loc, lookAt ) );
    }

    void AddItemToStockBJ( int itemId, unit whichUnit, int currentStock, int stockMax )
    {
        Jass::AddItemToStock( whichUnit, itemId, currentStock, stockMax );
    }

    void AddUnitToStockBJ( int unitId, unit whichUnit, int currentStock, int stockMax )
    {
        Jass::AddUnitToStock( whichUnit, unitId, currentStock, stockMax );
    }

    void RemoveItemFromStockBJ( int itemId, unit whichUnit )
    {
        Jass::RemoveItemFromStock( whichUnit, itemId );
    }

    void RemoveUnitFromStockBJ( int unitId, unit whichUnit )
    {
        Jass::RemoveUnitFromStock( whichUnit, unitId );
    }

    void SetUnitUseFoodBJ( bool enable, unit whichUnit )
    {
        Jass::SetUnitUseFood( whichUnit, enable );
    }

    bool UnitDamagePointLoc( unit whichUnit, float delay, float radius, location loc, float amount, attacktype whichAttack, damagetype whichDamage )
    {
        return Jass::UnitDamagePoint( whichUnit, delay, radius, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), amount, true, false, whichAttack, whichDamage, Jass::WEAPON_TYPE_WHOKNOWS );
    }

    bool UnitDamageTargetBJ( unit whichUnit, unit target, float amount, attacktype whichAttack, damagetype whichDamage )
    {
        return Jass::UnitDamageTarget( whichUnit, target, amount, true, false, whichAttack, whichDamage, Jass::WEAPON_TYPE_WHOKNOWS );
    }

    destructable CreateDestructableLoc( int objectid, location loc, float facing, float scale, int variation )
    {
        bj_lastCreatedDestructable = Jass::CreateDestructable( objectid, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), facing, scale, variation );
        return bj_lastCreatedDestructable;
    }

    destructable CreateDeadDestructableLocBJ( int objectid, location loc, float facing, float scale, int variation )
    {
        bj_lastCreatedDestructable = Jass::CreateDeadDestructable( objectid, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), facing, scale, variation );
        return bj_lastCreatedDestructable;
    }

    destructable GetLastCreatedDestructable( )
    {
        return bj_lastCreatedDestructable;
    }

    void ShowDestructableBJ( bool flag, destructable d )
    {
        Jass::ShowDestructable( d, flag );
    }

    void SetDestructableInvulnerableBJ( destructable d, bool flag )
    {
        Jass::SetDestructableInvulnerable( d, flag );
    }

    bool IsDestructableInvulnerableBJ( destructable d )
    {
        return Jass::IsDestructableInvulnerable( d );
    }

    location GetDestructableLoc( destructable whichDestructable )
    {
        return Jass::Location( Jass::GetDestructableX( whichDestructable ), Jass::GetDestructableY( whichDestructable ) );
    }

    void EnumDestructablesInRectAll( rect r, CallbackFunc @actionFunc )
    {
        Jass::EnumDestructablesInRect( r, nil, actionFunc );
    }

    bool EnumDestructablesInCircleBJFilter( )
    {
        location destLoc = GetDestructableLoc( Jass::GetFilterDestructable( ) );
        bool result = DistanceBetweenPoints( destLoc, bj_enumDestructableCenter ) <= bj_enumDestructableRadius;
        Jass::RemoveLocation( destLoc );
        return result;
    }

    bool IsDestructableDeadBJ( destructable d )
    {
        return Jass::GetDestructableLife( d ) <= .0f;
    }

    bool IsDestructableAliveBJ( destructable d )
    {
        return !IsDestructableDeadBJ( d );
    }

    void RandomDestructableInRectBJEnum( )
    {
        bj_destRandomConsidered++;

        if ( Jass::GetRandomInt( 1, bj_destRandomConsidered ) == 1 )
        {
            bj_destRandomCurrentPick = Jass::GetEnumDestructable( );
        }
    }

    destructable RandomDestructableInRectBJ( rect r, boolexpr filter )
    {
        bj_destRandomConsidered = 0;
        bj_destRandomCurrentPick = nil;
        Jass::EnumDestructablesInRect( r, filter, @RandomDestructableInRectBJEnum );
        Jass::DestroyBoolExpr( filter );
        return bj_destRandomCurrentPick;
    }

    destructable RandomDestructableInRectSimpleBJ( rect r )
    {
        return RandomDestructableInRectBJ( r, nil );
    }

    void EnumDestructablesInCircleBJ( float radius, location loc, CallbackFunc @actionFunc )
    {
        rect r;

        if ( radius >= 0 )
        {
            bj_enumDestructableCenter = loc;
            bj_enumDestructableRadius = radius;
            r = GetRectFromCircleBJ( loc, radius );
            Jass::EnumDestructablesInRect( r, filterEnumDestructablesInCircleBJ, actionFunc );
            Jass::RemoveRect( r );
        }
    }

    void SetDestructableLifePercentBJ( destructable d, float percent )
    {
        Jass::SetDestructableLife( d, Jass::GetDestructableMaxLife( d ) * percent * 0.01f );
    }

    void SetDestructableMaxLifeBJ( destructable d, float max )
    {
        Jass::SetDestructableMaxLife( d, max );
    }

    void ModifyGateBJ( int gateOperation, destructable d )
    {
        switch( gateOperation )
        {
            case bj_GATEOPERATION_CLOSE:
            {
                if ( Jass::GetDestructableLife( d ) <= .0f )
                {
                    Jass::DestructableRestoreLife( d, Jass::GetDestructableMaxLife( d ), true );
                }
                Jass::SetDestructableAnimation( d, "stand" );
                break;
            }
            case bj_GATEOPERATION_OPEN:
            {
                if ( Jass::GetDestructableLife( d ) > .0f )
                {
                    Jass::KillDestructable( d );
                }
                Jass::SetDestructableAnimation( d, "death alternate" );
                break;
            }
            case bj_GATEOPERATION_DESTROY:
            {
                if ( Jass::GetDestructableLife( d ) > .0f )
                {
                    Jass::KillDestructable( d );
                }
                Jass::SetDestructableAnimation( d, "death" );
                break;
            }
            default: break; // Unrecognized gate state - ignore the request.
        }
    }

    int GetElevatorHeight( destructable d )
    {
        int height = 1 + Jass::R2I( Jass::GetDestructableOccluderHeight( d ) / bj_CLIFFHEIGHT );

        if ( height < 1 || height > 3 )
        {
            height = 1;
        }

        return height;
    }

    void ChangeElevatorHeight( destructable d, int newHeight )
    {
        // Cap the new height within the supported range.
        newHeight = IMaxBJ( 1, newHeight );
        newHeight = IMinBJ( 3, newHeight );

        // Find out what height the elevator is already at.
        int oldHeight = GetElevatorHeight( d );

        // Set the elevator's occlusion height.
        Jass::SetDestructableOccluderHeight( d, bj_CLIFFHEIGHT * ( newHeight - 1 ) );

        switch( newHeight )
        {
            case 1:
            {
                switch( oldHeight )
                {
                    case 2:
                    {
                        Jass::SetDestructableAnimation( d, "birth" );
                        Jass::QueueDestructableAnimation( d, "stand" );
                        break;
                    }
                    case 3:
                    {
                        Jass::SetDestructableAnimation( d, "birth third" );
                        Jass::QueueDestructableAnimation( d, "stand" );
                        break;
                    }
                    default:
                    {
                        // Unrecognized old height - snap to new height.
                        Jass::SetDestructableAnimation( d, "stand" );
                        break;
                    }
                }

                break;
            }
            case 2:
            {
                switch( oldHeight )
                {
                    case 1:
                    {
                        Jass::SetDestructableAnimation( d, "death" );
                        Jass::QueueDestructableAnimation( d, "stand second" );
                        break;
                    }
                    case 3:
                    {
                        Jass::SetDestructableAnimation( d, "birth second" );
                        Jass::QueueDestructableAnimation( d, "stand second" );
                        break;
                    }
                    default:
                    {
                        // Unrecognized old height - snap to new height.
                        Jass::SetDestructableAnimation( d, "stand second" );
                        break;
                    }
                }

                break;
            }
            case 3:
            {
                switch( oldHeight )
                {
                    case 1:
                    {
                        Jass::SetDestructableAnimation( d, "death third" );
                        Jass::QueueDestructableAnimation( d, "stand third" );
                        break;
                    }
                    case 2:
                    {
                        Jass::SetDestructableAnimation( d, "death second" );
                        Jass::QueueDestructableAnimation( d, "stand third" );
                        break;
                    }
                    default:
                    {
                        // Unrecognized old height - snap to new height.
                        Jass::SetDestructableAnimation( d, "stand third" );
                        break;
                    }
                }

                break;
            }
            default: return; // Unrecognized new height - ignore the request.
        }
    }

    void NudgeUnitsInRectEnum( )
    {
        unit nudgee = Jass::GetEnumUnit( );

        Jass::SetUnitPosition( nudgee, Jass::GetUnitX( nudgee ), Jass::GetUnitY( nudgee ) );
    }

    void NudgeItemsInRectEnum( )
    {
        item nudgee = Jass::GetEnumItem( );

        Jass::SetItemPosition( nudgee, Jass::GetItemX( nudgee ), Jass::GetItemY( nudgee ) );
    }

    void NudgeObjectsInRect( rect nudgeArea )
    {
        group g = Jass::CreateGroup( );
        Jass::GroupEnumUnitsInRect( g, nudgeArea, nil );
        Jass::ForGroup( g, @NudgeUnitsInRectEnum );
        Jass::DestroyGroup( g );

        Jass::EnumItemsInRect( nudgeArea, nil, @NudgeItemsInRectEnum );
    }

    void NearbyElevatorExistsEnum( )
    {
        destructable d = Jass::GetEnumDestructable( );
        int dType = Jass::GetDestructableTypeId( d );

        if ( dType == bj_ELEVATOR_CODE01 || dType == bj_ELEVATOR_CODE02 )
        {
            bj_elevatorNeighbor = d;
        }
    }

    bool NearbyElevatorExists( float x, float y )
    {
        float findThreshold = 32.f;
        // If another elevator is overlapping this one, ignore the wall.
        rect r = Jass::Rect( x - findThreshold, y - findThreshold, x + findThreshold, y + findThreshold );
        bj_elevatorNeighbor = nil;
        Jass::EnumDestructablesInRect( r, nil, @NearbyElevatorExistsEnum );
        Jass::RemoveRect( r );

        return bj_elevatorNeighbor != nil;
    }

    void FindElevatorWallBlockerEnum( )
    {
        bj_elevatorWallBlocker = Jass::GetEnumDestructable( );
    }

    void ChangeElevatorWallBlocker( float x, float y, float facing, bool open )
    {
        destructable blocker;
        float findThreshold = 32.f;
        float nudgeLength   = 4.25f * bj_CELLWIDTH;
        float nudgeWidth    = 1.25f * bj_CELLWIDTH;

        // Search for the pathing blocker within the general area.
        rect r = Jass::Rect( x - findThreshold, y - findThreshold, x + findThreshold, y + findThreshold );
        bj_elevatorWallBlocker = nil;
        Jass::EnumDestructablesInRect( r, nil, @FindElevatorWallBlockerEnum );
        Jass::RemoveRect( r );
        blocker = bj_elevatorWallBlocker;

        // Ensure that the blocker exists.
        if ( blocker == nil )
        {
            blocker = Jass::CreateDeadDestructable( bj_ELEVATOR_BLOCKER_CODE, x, y, facing, 1, 0 );
        }
        else if ( Jass::GetDestructableTypeId( blocker ) != bj_ELEVATOR_BLOCKER_CODE )
        {
            // If a different destructible exists in the blocker's spot, ignore
            // the request.  ( Two destructibles cannot occupy the same location
            // on the map, so we cannot create an elevator blocker here. )
            return;
        }

        if ( open )
        {
            // Ensure that the blocker is dead.
            if ( Jass::GetDestructableLife( blocker ) > .0f )
            {
                Jass::KillDestructable( blocker );
            }
        }
        else
        {
            // Ensure that the blocker is alive.
            if ( Jass::GetDestructableLife( blocker ) <= .0f )
            {
                Jass::DestructableRestoreLife( blocker, Jass::GetDestructableMaxLife( blocker ), false );
            }

            // Nudge any objects standing in the blocker's way.
            if ( facing == .0f )
            {
                r = Jass::Rect( x - nudgeWidth / 2.f, y - nudgeLength / 2.f, x + nudgeWidth / 2.f, y + nudgeLength / 2.f );
                NudgeObjectsInRect( r );
                Jass::RemoveRect( r );
            }
            else if ( facing == 90.f )
            {
                r = Jass::Rect( x - nudgeLength / 2.f, y - nudgeWidth / 2.f, x + nudgeLength / 2.f, y + nudgeWidth / 2.f );
                NudgeObjectsInRect( r );
                Jass::RemoveRect( r );
            }
            else
            {
                // Unrecognized blocker angle - don't nudge anything.
            }
        }
    }

    void ChangeElevatorWalls( bool open, int walls, destructable d )
    {
        float x = Jass::GetDestructableX( d );
        float y = Jass::GetDestructableY( d );
        float distToBlocker = 192.f;
        float distToNeighbor = 256.f;

        if ( walls == bj_ELEVATOR_WALL_TYPE_ALL || walls == bj_ELEVATOR_WALL_TYPE_EAST )
        {
            if ( !NearbyElevatorExists( x + distToNeighbor, y ) )
            {
                ChangeElevatorWallBlocker( x + distToBlocker, y, 0, open );
            }
        }

        if ( walls == bj_ELEVATOR_WALL_TYPE_ALL || walls == bj_ELEVATOR_WALL_TYPE_NORTH )
        {
            if ( !NearbyElevatorExists( x, y + distToNeighbor ) )
            {
                ChangeElevatorWallBlocker( x, y + distToBlocker, 90.f, open );
            }
        }

        if ( walls == bj_ELEVATOR_WALL_TYPE_ALL || walls == bj_ELEVATOR_WALL_TYPE_SOUTH )
        {
            if ( !NearbyElevatorExists( x, y - distToNeighbor ) )
            {
                ChangeElevatorWallBlocker( x, y - distToBlocker, 90.f, open );
            }
        }

        if ( walls == bj_ELEVATOR_WALL_TYPE_ALL || walls == bj_ELEVATOR_WALL_TYPE_WEST )
        {
            if ( !NearbyElevatorExists( x - distToNeighbor, y ) )
            {
                ChangeElevatorWallBlocker( x - distToBlocker, y, .0f, open );
            }
        }
    }

    void WaygateActivateBJ( bool activate, unit waygate )
    {
        Jass::WaygateActivate( waygate, activate );
    }

    bool WaygateIsActiveBJ( unit waygate )
    {
        return Jass::WaygateIsActive( waygate );
    }

    void WaygateSetDestinationLocBJ( unit waygate, location loc )
    {
        Jass::WaygateSetDestination( waygate, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ) );
    }

    location WaygateGetDestinationLocBJ( unit waygate )
    {
        return Jass::Location( Jass::WaygateGetDestinationX( waygate ), Jass::WaygateGetDestinationY( waygate ) );
    }

    void UnitSetUsesAltIconBJ( bool flag, unit whichUnit )
    {
        Jass::UnitSetUsesAltIcon( whichUnit, flag );
    }

    void ForceUIKeyBJ( player whichPlayer, string key )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::ForceUIKey( key );
        }
    }

    void ForceUICancelBJ( player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::ForceUICancel( );
        }
    }

    void ForGroupBJ( group whichGroup, CallbackFunc @callback )
    {
        // If the user wants the group destroyed, remember that fact && clear
        // the flag, in case it is used again in the callback.
        bool wantDestroy = bj_wantDestroyGroup;
        bj_wantDestroyGroup = false;

        Jass::ForGroup( whichGroup, callback );

        // If the user wants the group destroyed, do so now.
        if ( wantDestroy )
        {
            Jass::DestroyGroup( whichGroup );
        }
    }

    void GroupAddUnitSimple( unit whichUnit, group whichGroup )
    {
        Jass::GroupAddUnit( whichGroup, whichUnit );
    }

    void GroupRemoveUnitSimple( unit whichUnit, group whichGroup )
    {
        Jass::GroupRemoveUnit( whichGroup, whichUnit );
    }

    void GroupAddGroupEnum( )
    {
        Jass::GroupAddUnit( bj_groupAddGroupDest, Jass::GetEnumUnit( ) );
    }

    void GroupAddGroup( group sourceGroup, group destGroup )
    {
        // If the user wants the group destroyed, remember that fact && clear
        // the flag, in case it is used again in the callback.
        bool wantDestroy = bj_wantDestroyGroup;
        bj_wantDestroyGroup = false;

        bj_groupAddGroupDest = destGroup;
        Jass::ForGroup( sourceGroup, @GroupAddGroupEnum );

        // If the user wants the group destroyed, do so now.
        if ( wantDestroy )
        {
            Jass::DestroyGroup( sourceGroup );
        }
    }

    void GroupRemoveGroupEnum( )
    {
        Jass::GroupRemoveUnit( bj_groupRemoveGroupDest, Jass::GetEnumUnit( ) );
    }

    void GroupRemoveGroup( group sourceGroup, group destGroup )
    {
        // If the user wants the group destroyed, remember that fact && clear
        // the flag, in case it is used again in the callback.
        bool wantDestroy = bj_wantDestroyGroup;
        bj_wantDestroyGroup = false;

        bj_groupRemoveGroupDest = destGroup;
        Jass::ForGroup( sourceGroup, @GroupRemoveGroupEnum );

        // If the user wants the group destroyed, do so now.
        if ( wantDestroy )
        {
            Jass::DestroyGroup( sourceGroup );
        }
    }

    void ForceAddPlayerSimple( player whichPlayer, force whichForce )
    {
        Jass::ForceAddPlayer( whichForce, whichPlayer );
    }

    void ForceRemovePlayerSimple( player whichPlayer, force whichForce )
    {
        Jass::ForceRemovePlayer( whichForce, whichPlayer );
    }

    void GroupPickRandomUnitEnum( )
    {
        bj_groupRandomConsidered++;

        if ( Jass::GetRandomInt( 1, bj_groupRandomConsidered ) == 1 )
        {
            bj_groupRandomCurrentPick = Jass::GetEnumUnit( );
        }
    }

    unit GroupPickRandomUnit( group whichGroup )
    {
        // If the user wants the group destroyed, remember that fact && clear
        // the flag, in case it is used again in the callback.
        bool wantDestroy = bj_wantDestroyGroup;
        bj_wantDestroyGroup = false;

        bj_groupRandomConsidered = 0;
        bj_groupRandomCurrentPick = nil;
        Jass::ForGroup( whichGroup, @GroupPickRandomUnitEnum );

        // If the user wants the group destroyed, do so now.
        if ( wantDestroy )
        {
            Jass::DestroyGroup( whichGroup );
        }

        return bj_groupRandomCurrentPick;
    }

    void ForcePickRandomPlayerEnum( )
    {
        bj_forceRandomConsidered++;

        if ( Jass::GetRandomInt( 1, bj_forceRandomConsidered ) == 1 )
        {
            bj_forceRandomCurrentPick = Jass::GetEnumPlayer( );
        }
    }

    player ForcePickRandomPlayer( force whichForce )
    {
        bj_forceRandomConsidered = 0;
        bj_forceRandomCurrentPick = nil;
        Jass::ForForce( whichForce, @ForcePickRandomPlayerEnum );
        return bj_forceRandomCurrentPick;
    }

    void EnumUnitsSelected( player whichPlayer, boolexpr enumFilter, CallbackFunc @enumAction )
    {
        group g = Jass::CreateGroup( );
        Jass::SyncSelections( );
        Jass::GroupEnumUnitsSelected( g, whichPlayer, enumFilter );
        Jass::DestroyBoolExpr( enumFilter );
        Jass::ForGroup( g, enumAction );
        Jass::DestroyGroup( g );
    }

    group GetUnitsInRectMatching( rect r, boolexpr filter )
    {
        group g = Jass::CreateGroup( );
        Jass::GroupEnumUnitsInRect( g, r, filter );
        Jass::DestroyBoolExpr( filter );
        return g;
    }

    group GetUnitsInRectAll( rect r )
    {
        return GetUnitsInRectMatching( r, nil );
    }

    bool GetUnitsInRectOfPlayerFilter( )
    {
        return Jass::GetOwningPlayer( Jass::GetFilterUnit( ) ) == bj_groupEnumOwningPlayer;
    }

    group GetUnitsInRectOfPlayer( rect r, player whichPlayer )
    {
        group g = Jass::CreateGroup( );
        bj_groupEnumOwningPlayer = whichPlayer;
        Jass::GroupEnumUnitsInRect( g, r, filterGetUnitsInRectOfPlayer );
        return g;
    }

    group GetUnitsInRangeOfLocMatching( float radius, location whichLocation, boolexpr filter )
    {
        group g = Jass::CreateGroup( );
        Jass::GroupEnumUnitsInRangeOfLoc( g, whichLocation, radius, filter );
        Jass::DestroyBoolExpr( filter );
        return g;
    }

    group GetUnitsInRangeOfLocAll( float radius, location whichLocation )
    {
        return GetUnitsInRangeOfLocMatching( radius, whichLocation, nil );
    }

    bool GetUnitsOfTypeIdAllFilter( )
    {
        return Jass::GetUnitTypeId( Jass::GetFilterUnit( ) ) == bj_groupEnumTypeId;
    }

    group GetUnitsOfTypeIdAll( int unitid )
    {
        group result = Jass::CreateGroup( );
        group g      = Jass::CreateGroup( );
        
        for ( int i = 0; i < bj_MAX_PLAYER_SLOTS; i++ )
        {
            Jass::GroupClear( g );
            Jass::GroupEnumUnitsOfPlayer( g, Jass::Player( i ), filterGetUnitsOfTypeIdAll );
            GroupAddGroup( g, result );
        }

        Jass::DestroyGroup( g );

        return result;
    }

    group GetUnitsOfPlayerMatching( player whichPlayer, boolexpr filter )
    {
        group g = Jass::CreateGroup( );
        Jass::GroupEnumUnitsOfPlayer( g, whichPlayer, filter );
        Jass::DestroyBoolExpr( filter );
        return g;
    }

    group GetUnitsOfPlayerAll( player whichPlayer )
    {
        return GetUnitsOfPlayerMatching( whichPlayer, nil );
    }

    bool GetUnitsOfPlayerAndTypeIdFilter( )
    {
        return Jass::GetUnitTypeId( Jass::GetFilterUnit( ) ) == bj_groupEnumTypeId;
    }

    group GetUnitsOfPlayerAndTypeId( player whichPlayer, int unitid )
    {
        group g = Jass::CreateGroup( );
        bj_groupEnumTypeId = unitid;
        Jass::GroupEnumUnitsOfPlayer( g, whichPlayer, filterGetUnitsOfPlayerAndTypeId );
        return g;
    }

    group GetUnitsSelectedAll( player whichPlayer )
    {
        group g = Jass::CreateGroup( );
        Jass::SyncSelections( );
        Jass::GroupEnumUnitsSelected( g, whichPlayer, nil );
        return g;
    }

    force GetForceOfPlayer( player whichPlayer )
    {
        force f = Jass::CreateForce( );
        Jass::ForceAddPlayer( f, whichPlayer );
        return f;
    }

    force GetPlayersAll( )
    {
        return bj_FORCE_ALL_PLAYERS;
    }

    force GetPlayersByMapControl( mapcontrol whichControl )
    {
        force f = Jass::CreateForce( );

        for ( int i = 0; i < bj_MAX_PLAYER_SLOTS; i++ )
        {
            player p = Jass::Player( i );
            if ( Jass::GetPlayerController( p ) == whichControl )
            {
                Jass::ForceAddPlayer( f, p );
            }
        }

        return f;
    }

    force GetPlayersAllies( player whichPlayer )
    {
        force f = Jass::CreateForce( );
        Jass::ForceEnumAllies( f, whichPlayer, nil );
        return f;
    }

    force GetPlayersEnemies( player whichPlayer )
    {
        force f = Jass::CreateForce( );
        Jass::ForceEnumEnemies( f, whichPlayer, nil );
        return f;
    }

    force GetPlayersMatching( boolexpr filter )
    {
        force f = Jass::CreateForce( );
        Jass::ForceEnumPlayers( f, filter );
        Jass::DestroyBoolExpr( filter );
        return f;
    }

    void CountUnitsInGroupEnum( )
    {
        bj_groupCountUnits++;
    }

    int CountUnitsInGroup( group g )
    {
        // If the user wants the group destroyed, remember that fact && clear
        // the flag, in case it is used again in the callback.
        bool wantDestroy = bj_wantDestroyGroup;
        bj_wantDestroyGroup = false;

        bj_groupCountUnits = 0;
        Jass::ForGroup( g, @CountUnitsInGroupEnum );

        // If the user wants the group destroyed, do so now.
        if ( wantDestroy )
        {
            Jass::DestroyGroup( g );
        }

        return bj_groupCountUnits;
    }

    void CountPlayersInForceEnum( )
    {
        bj_forceCountPlayers++;
    }

    int CountPlayersInForceBJ( force f )
    {
        bj_forceCountPlayers = 0;
        Jass::ForForce( f, @CountPlayersInForceEnum );
        return bj_forceCountPlayers;
    }

    void GetRandomSubGroupEnum( )
    {
        if ( bj_randomSubGroupWant > 0 )
        {
            if ( ( bj_randomSubGroupWant >= bj_randomSubGroupTotal ) || ( Jass::GetRandomReal( .0f, 1.f ) < bj_randomSubGroupChance ) )
            {
                // We either need every remaining unit, || the unit passed its chance check.
                Jass::GroupAddUnit( bj_randomSubGroupGroup, Jass::GetEnumUnit( ) );
                bj_randomSubGroupWant--;
            }
        }

        bj_randomSubGroupTotal--;
    }

    group GetRandomSubGroup( int count, group sourceGroup )
    {
        group g = Jass::CreateGroup( );

        bj_randomSubGroupGroup = g;
        bj_randomSubGroupWant  = count;
        bj_randomSubGroupTotal = CountUnitsInGroup( sourceGroup );

        if ( bj_randomSubGroupWant <= 0 || bj_randomSubGroupTotal <= 0 )
        {
            return g;
        }

        bj_randomSubGroupChance = Jass::I2R( bj_randomSubGroupWant ) / Jass::I2R( bj_randomSubGroupTotal );
        Jass::ForGroup( sourceGroup, @GetRandomSubGroupEnum );
        return g;
    }

    bool LivingPlayerUnitsOfTypeIdFilter( )
    {
        unit filterUnit = Jass::GetFilterUnit( );
        return IsUnitAliveBJ( filterUnit ) && Jass::GetUnitTypeId( filterUnit ) == bj_livingPlayerUnitsTypeId;
    }

    int CountLivingPlayerUnitsOfTypeId( int unitId, player whichPlayer )
    {
        group g = Jass::CreateGroup( );
        bj_livingPlayerUnitsTypeId = unitId;
        Jass::GroupEnumUnitsOfPlayer( g, whichPlayer, filterLivingPlayerUnitsOfTypeId );
        int matchedCount = CountUnitsInGroup( g );
        Jass::DestroyGroup( g );

        return matchedCount;
    }

    void ResetUnitAnimation( unit whichUnit )
    {
        Jass::SetUnitAnimation( whichUnit, "stand" );
    }

    void SetUnitTimeScalePercent( unit whichUnit, float percentScale )
    {
        Jass::SetUnitTimeScale( whichUnit, percentScale * 0.01f );
    }

    void SetUnitScalePercent( unit whichUnit, float percentScaleX, float percentScaleY, float percentScaleZ )
    {
        Jass::SetUnitScale( whichUnit, percentScaleX * 0.01f, percentScaleY * 0.01f, percentScaleZ * 0.01f );
    }

    void SetUnitVertexColorBJ( unit whichUnit, float red, float green, float blue, float transparency )
    {
        Jass::SetUnitVertexColor( whichUnit, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void UnitAddIndicatorBJ( unit whichUnit, float red, float green, float blue, float transparency )
    {
        Jass::AddIndicator( whichUnit, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void DestructableAddIndicatorBJ( destructable whichDestructable, float red, float green, float blue, float transparency )
    {
        Jass::AddIndicator( whichDestructable, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void ItemAddIndicatorBJ( item whichItem, float red, float green, float blue, float transparency )
    {
        Jass::AddIndicator( whichItem, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void SetUnitFacingToFaceLocTimed( unit whichUnit, location target, float duration )
    {
        location unitLoc = Jass::GetUnitLoc( whichUnit );

        Jass::SetUnitFacingTimed( whichUnit, AngleBetweenPoints( unitLoc, target ), duration );
        Jass::RemoveLocation( unitLoc );
    }

    void SetUnitFacingToFaceUnitTimed( unit whichUnit, unit target, float duration )
    {
        location unitLoc = Jass::GetUnitLoc( target );

        SetUnitFacingToFaceLocTimed( whichUnit, unitLoc, duration );
        Jass::RemoveLocation( unitLoc );
    }

    void QueueUnitAnimationBJ( unit whichUnit, string whichAnimation )
    {
        Jass::QueueUnitAnimation( whichUnit, whichAnimation );
    }

    void SetDestructableAnimationBJ( destructable d, string whichAnimation )
    {
        Jass::SetDestructableAnimation( d, whichAnimation );
    }

    void QueueDestructableAnimationBJ( destructable d, string whichAnimation )
    {
        Jass::QueueDestructableAnimation( d, whichAnimation );
    }

    void SetDestAnimationSpeedPercent( destructable d, float percentScale )
    {
        Jass::SetDestructableAnimationSpeed( d, percentScale * 0.01f );
    }

    void DialogDisplayBJ( bool flag, dialog whichDialog, player whichPlayer )
    {
        Jass::DialogDisplay( whichPlayer, whichDialog, flag );
    }

    void DialogSetMessageBJ( dialog whichDialog, string message )
    {
        Jass::DialogSetMessage( whichDialog, message );
    }

    button DialogAddButtonBJ( dialog whichDialog, string buttonText )
    {
        bj_lastCreatedButton = Jass::DialogAddButton( whichDialog, buttonText, 0 );
        return bj_lastCreatedButton;
    }

    button DialogAddButtonWithHotkeyBJ( dialog whichDialog, string buttonText, int hotkey )
    {
        bj_lastCreatedButton = Jass::DialogAddButton( whichDialog, buttonText,hotkey );
        return bj_lastCreatedButton;
    }

    void DialogClearBJ( dialog whichDialog )
    {
        Jass::DialogClear( whichDialog );
    }

    button GetLastCreatedButtonBJ( )
    {
        return bj_lastCreatedButton;
    }

    button GetClickedButtonBJ( )
    {
        return Jass::GetClickedButton( );
    }

    dialog GetClickedDialogBJ( )
    {
        return Jass::GetClickedDialog( );
    }

    void SetPlayerAllianceBJ( player sourcePlayer, alliancetype whichAllianceSetting, bool value, player otherPlayer )
    {
        // Prevent players from attempting to ally with themselves.
        if ( sourcePlayer == otherPlayer )
        {
            return;
        }

        Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, whichAllianceSetting, value );
    }

    void SetPlayerAllianceStateAllyBJ( player sourcePlayer, player otherPlayer, bool flag )
    {
        Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_PASSIVE,       flag );
        Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_HELP_REQUEST,  flag );
        Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_HELP_RESPONSE, flag );
        Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_SHARED_XP,     flag );
        Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_SHARED_SPELLS, flag );
    }

    void SetPlayerAllianceStateVisionBJ( player sourcePlayer, player otherPlayer, bool flag )
    {
        Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_SHARED_VISION, flag );
    }

    void SetPlayerAllianceStateControlBJ( player sourcePlayer, player otherPlayer, bool flag )
    {
        Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_SHARED_CONTROL, flag );
    }

    void SetPlayerAllianceStateFullControlBJ( player sourcePlayer, player otherPlayer, bool flag )
    {
        Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_SHARED_ADVANCED_CONTROL, flag );
    }

    void SetPlayerAllianceStateBJ( player sourcePlayer, player otherPlayer, int allianceState )
    {
        // Prevent players from attempting to ally with themselves.
        if ( sourcePlayer == otherPlayer )
        {
            return;
        }

        switch( allianceState )
        {
            case bj_ALLIANCE_UNALLIED:
            {
                SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false );
                break;
            }
            case bj_ALLIANCE_UNALLIED_VISION:
            {
                SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false );
                break;
            }
            case bj_ALLIANCE_ALLIED:
            {
                SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false );
                break;
            }
            case bj_ALLIANCE_ALLIED_VISION:
            {
                SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false );
                break;
            }
            case bj_ALLIANCE_ALLIED_UNITS:
            {
                SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false );
                break;
            }
            case bj_ALLIANCE_ALLIED_ADVUNITS:
            {
                SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, true  );
                break;
            }
            case bj_ALLIANCE_NEUTRAL:
            {
                SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false );
                Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_PASSIVE, true );
                break;
            }
            case bj_ALLIANCE_NEUTRAL_VISION:
            {
                SetPlayerAllianceStateAllyBJ(        sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateVisionBJ(      sourcePlayer, otherPlayer, true  );
                SetPlayerAllianceStateControlBJ(     sourcePlayer, otherPlayer, false );
                SetPlayerAllianceStateFullControlBJ( sourcePlayer, otherPlayer, false );
                Jass::SetPlayerAlliance( sourcePlayer, otherPlayer, Jass::ALLIANCE_PASSIVE, true );
                break;
            }
            default: return; // Unrecognized alliance state - ignore the request.
        }


    }

    void SetForceAllianceStateBJ( force sourceForce, force targetForce, int allianceState )
    {
        for ( int i = 0; i < bj_MAX_PLAYER_SLOTS; i++ )
        {
            if ( sourceForce == bj_FORCE_ALL_PLAYERS || Jass::IsPlayerInForce( Jass::Player( i ), sourceForce ) )
            {
                for ( int j = 0; j < bj_MAX_PLAYER_SLOTS; j++ )
                {
                    if ( targetForce == bj_FORCE_ALL_PLAYERS || Jass::IsPlayerInForce( Jass::Player( j ), targetForce ) )
                    {
                        SetPlayerAllianceStateBJ( Jass::Player( i ), Jass::Player( j ), allianceState );
                    }
                }
            }
        }
    }

    bool PlayersAreCoAllied( player playerA, player playerB )
    {
        // Players are considered to be allied with themselves.
        if ( playerA == playerB )
        {
            return true;
        }

        // Co-allies are both allied with each other.
        if ( Jass::GetPlayerAlliance( playerA, playerB, Jass::ALLIANCE_PASSIVE ) && Jass::GetPlayerAlliance( playerB, playerA, Jass::ALLIANCE_PASSIVE ) )
        {
            return true;
        }

        return false;
    }

    void ShareEverythingWithTeamAI( player whichPlayer )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            if ( PlayersAreCoAllied( whichPlayer, p ) && whichPlayer != p )
            {
                if ( Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_COMPUTER )
                {
                    Jass::SetPlayerAlliance( whichPlayer, p, Jass::ALLIANCE_SHARED_VISION, true );
                    Jass::SetPlayerAlliance( whichPlayer, p, Jass::ALLIANCE_SHARED_CONTROL, true );
                    Jass::SetPlayerAlliance( whichPlayer, p, Jass::ALLIANCE_SHARED_ADVANCED_CONTROL, true );
                }
            }
        }
    }

    void ShareEverythingWithTeam( player whichPlayer )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            if ( PlayersAreCoAllied( whichPlayer, p ) && whichPlayer != p )
            {
                Jass::SetPlayerAlliance( whichPlayer, p, Jass::ALLIANCE_SHARED_VISION, true );
                Jass::SetPlayerAlliance( whichPlayer, p, Jass::ALLIANCE_SHARED_CONTROL, true );
                Jass::SetPlayerAlliance( p, whichPlayer, Jass::ALLIANCE_SHARED_CONTROL, true );
                Jass::SetPlayerAlliance( whichPlayer, p, Jass::ALLIANCE_SHARED_ADVANCED_CONTROL, true );
            }
        }
    }

    void ConfigureNeutralVictim( )
    {
        player neutralVictim = Jass::Player( bj_PLAYER_NEUTRAL_VICTIM );

        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            Jass::SetPlayerAlliance( neutralVictim, p, Jass::ALLIANCE_PASSIVE, true );
            Jass::SetPlayerAlliance( p, neutralVictim, Jass::ALLIANCE_PASSIVE, false );
        }

        // Neutral Victim && Neutral Aggressive should !fight each other.
        player p = Jass::Player( Jass::PLAYER_NEUTRAL_AGGRESSIVE );
        Jass::SetPlayerAlliance( neutralVictim, p, Jass::ALLIANCE_PASSIVE, true );
        Jass::SetPlayerAlliance( p, neutralVictim, Jass::ALLIANCE_PASSIVE, true );

        // Neutral Victim does !give bounties.
        Jass::SetPlayerState( neutralVictim, Jass::PLAYER_STATE_GIVES_BOUNTY, 0 );
    }

    void MakeUnitsPassiveForPlayerEnum( )
    {
        Jass::SetUnitOwner( Jass::GetEnumUnit( ), Jass::Player( bj_PLAYER_NEUTRAL_VICTIM ), false );
    }

    void MakeUnitsPassiveForPlayer( player whichPlayer )
    {
        group   playerUnits = Jass::CreateGroup( );
        Jass::CachePlayerHeroData( whichPlayer );
        Jass::GroupEnumUnitsOfPlayer( playerUnits, whichPlayer, nil );
        Jass::ForGroup( playerUnits, @MakeUnitsPassiveForPlayerEnum );
        Jass::DestroyGroup( playerUnits );
    }

    void MakeUnitsPassiveForTeam( player whichPlayer )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            if ( PlayersAreCoAllied( whichPlayer, p ) )
            {
                MakeUnitsPassiveForPlayer( p );
            }
        }
    }

    bool AllowVictoryDefeat( playergameresult gameResult )
    {
        if ( gameResult == Jass::PLAYER_GAME_RESULT_VICTORY )
        {
            return !Jass::IsNoVictoryCheat( );
        }

        if ( gameResult == Jass::PLAYER_GAME_RESULT_DEFEAT )
        {
            return !Jass::IsNoDefeatCheat( );
        }

        if ( gameResult == Jass::PLAYER_GAME_RESULT_NEUTRAL )
        {
            return !Jass::IsNoVictoryCheat( ) && !Jass::IsNoDefeatCheat( );
        }

        return true;
    }

    void EndGameBJ( )
    {
        Jass::EndGame( true );
    }

    void MeleeVictoryDialogBJ( player whichPlayer, bool leftGame )
    {
        trigger t = Jass::CreateTrigger( );
        dialog  d = Jass::DialogCreate( );
        string formatString;

        // Display "player was victorious" || "player has left the game" message
        if ( leftGame )
        {
            formatString = Jass::GetLocalizedString( "PLAYER_LEFT_GAME" );
        }
        else
        {
            formatString = Jass::GetLocalizedString( "PLAYER_VICTORIOUS" );
        }

        Jass::DisplayTimedTextFromPlayer( whichPlayer, .0f, .0f, 60.f, formatString );

        Jass::DialogSetMessage( d, Jass::GetLocalizedString( "GAMEOVER_VICTORY_MSG" ) );
        Jass::DialogAddButton( d, Jass::GetLocalizedString( "GAMEOVER_CONTINUE_GAME" ), Jass::GetLocalizedHotkey( "GAMEOVER_CONTINUE_GAME" ) );

        t = Jass::CreateTrigger( );
        Jass::TriggerRegisterDialogButtonEvent( t, Jass::DialogAddQuitButton( d, true, Jass::GetLocalizedString( "GAMEOVER_QUIT_GAME" ), Jass::GetLocalizedHotkey( "GAMEOVER_QUIT_GAME" ) ) );

        Jass::DialogDisplay( whichPlayer, d, true );
        StartSoundForPlayerBJ( whichPlayer, bj_victoryDialogSound );
    }

    void MeleeDefeatDialogBJ( player whichPlayer, bool leftGame )
    {
        trigger t = Jass::CreateTrigger( );
        dialog  d = Jass::DialogCreate( );
        string formatString;

        // Display "player was defeated" || "player has left the game" message
        if ( leftGame )
        {
            formatString = Jass::GetLocalizedString( "PLAYER_LEFT_GAME" );
        }
        else
        {
            formatString = Jass::GetLocalizedString( "PLAYER_DEFEATED" );
        }

        Jass::DisplayTimedTextFromPlayer( whichPlayer, .0f, .0f, 60.f, formatString );

        Jass::DialogSetMessage( d, Jass::GetLocalizedString( "GAMEOVER_DEFEAT_MSG" ) );

        // Only show the continue button if the game is !over && observers on death are allowed
        if ( !bj_meleeGameOver && Jass::IsMapFlagSet( Jass::MAP_OBSERVERS_ON_DEATH ) )
        {
            Jass::DialogAddButton( d, Jass::GetLocalizedString( "GAMEOVER_CONTINUE_OBSERVING" ), Jass::GetLocalizedHotkey( "GAMEOVER_CONTINUE_OBSERVING" ) );
        }

        t = Jass::CreateTrigger( );
        Jass::TriggerRegisterDialogButtonEvent( t, Jass::DialogAddQuitButton( d, true, Jass::GetLocalizedString( "GAMEOVER_QUIT_GAME" ), Jass::GetLocalizedHotkey( "GAMEOVER_QUIT_GAME" ) ) );

        Jass::DialogDisplay( whichPlayer, d, true );
        StartSoundForPlayerBJ( whichPlayer, bj_defeatDialogSound );
    }

    void GameOverDialogBJ( player whichPlayer, bool leftGame )
    {
        trigger t = Jass::CreateTrigger( );
        dialog  d = Jass::DialogCreate( );
        string  s;

        // Display "player left the game" message
        Jass::DisplayTimedTextFromPlayer( whichPlayer, .0f, .0f, 60.f, Jass::GetLocalizedString( "PLAYER_LEFT_GAME" ) );

        if ( Jass::GetIntegerGameState( Jass::GAME_STATE_DISCONNECTED ) != 0 )
        {
            s = Jass::GetLocalizedString( "GAMEOVER_DISCONNECTED" );
        }
        else
        {
            s = Jass::GetLocalizedString( "GAMEOVER_GAME_OVER" );
        }

        Jass::DialogSetMessage( d, s );

        t = Jass::CreateTrigger( );
        Jass::TriggerRegisterDialogButtonEvent( t, Jass::DialogAddQuitButton( d, true, Jass::GetLocalizedString( "GAMEOVER_OK" ), Jass::GetLocalizedHotkey( "GAMEOVER_OK" ) ) );

        Jass::DialogDisplay( whichPlayer, d, true );
        StartSoundForPlayerBJ( whichPlayer, bj_defeatDialogSound );
    }

    void RemovePlayerPreserveUnitsBJ( player whichPlayer, playergameresult gameResult, bool leftGame )
    {
        if ( AllowVictoryDefeat( gameResult ) )
        {
            Jass::RemovePlayer( whichPlayer, gameResult );

            if ( gameResult == Jass::PLAYER_GAME_RESULT_VICTORY )
            {
                MeleeVictoryDialogBJ( whichPlayer, leftGame );
            }
            else if ( gameResult == Jass::PLAYER_GAME_RESULT_DEFEAT )
            {
                MeleeDefeatDialogBJ( whichPlayer, leftGame );
            }
            else
            {
                GameOverDialogBJ( whichPlayer, leftGame );
            }
        }
    }

    void CustomVictoryOkBJ( )
    {
        if ( bj_isSinglePlayer )
        {
            Jass::PauseGame( false );
            // Bump the difficulty back up to the default.
            Jass::SetGameDifficulty( Jass::GetDefaultDifficulty( ) );
        }

        if ( bj_changeLevelMapName.isEmpty( ) )
        {
            Jass::EndGame( bj_changeLevelShowScores );
        }
        else
        {
            Jass::ChangeLevel( bj_changeLevelMapName, bj_changeLevelShowScores );
        }
    }

    void CustomVictoryQuitBJ( )
    {
        if ( bj_isSinglePlayer )
        {
            Jass::PauseGame( false );
            // Bump the difficulty back up to the default.
            Jass::SetGameDifficulty( Jass::GetDefaultDifficulty( ) );
        }

        Jass::EndGame( bj_changeLevelShowScores );
    }

    void CustomVictoryDialogBJ( player whichPlayer )
    {
        trigger t = Jass::CreateTrigger( );
        dialog  d = Jass::DialogCreate( );

        Jass::DialogSetMessage( d, Jass::GetLocalizedString( "GAMEOVER_VICTORY_MSG" ) );

        t = Jass::CreateTrigger( );
        Jass::TriggerRegisterDialogButtonEvent( t, Jass::DialogAddButton( d, Jass::GetLocalizedString( "GAMEOVER_CONTINUE" ), Jass::GetLocalizedHotkey( "GAMEOVER_CONTINUE" ) ) );
        Jass::TriggerAddAction( t, @CustomVictoryOkBJ );

        t = Jass::CreateTrigger( );
        Jass::TriggerRegisterDialogButtonEvent( t, Jass::DialogAddButton( d, Jass::GetLocalizedString( "GAMEOVER_QUIT_MISSION" ), Jass::GetLocalizedHotkey( "GAMEOVER_QUIT_MISSION" ) ) );
        Jass::TriggerAddAction( t, @CustomVictoryQuitBJ );

        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            Jass::EnableUserControl( true );
            if ( bj_isSinglePlayer ) 
            {
                Jass::PauseGame( true );
            }
            Jass::EnableUserUI( false );
        }

        Jass::DialogDisplay( whichPlayer, d, true );
        VolumeGroupSetVolumeForPlayerBJ( whichPlayer, Jass::SOUND_VOLUMEGROUP_UI, 1.f );
        StartSoundForPlayerBJ( whichPlayer, bj_victoryDialogSound );
    }

    void CustomVictorySkipBJ( player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            if ( bj_isSinglePlayer )
            {
                // Bump the difficulty back up to the default.
                Jass::SetGameDifficulty( Jass::GetDefaultDifficulty( ) );
            }

            if ( bj_changeLevelMapName.isEmpty( ) )
            {
                Jass::EndGame( bj_changeLevelShowScores );
            }
            else
            {
                Jass::ChangeLevel( bj_changeLevelMapName, bj_changeLevelShowScores );
            }
        }
    }

    void CustomVictoryBJ( player whichPlayer, bool showDialog, bool showScores )
    {
        if ( AllowVictoryDefeat( Jass::PLAYER_GAME_RESULT_VICTORY ) )
        {
            Jass::RemovePlayer( whichPlayer, Jass::PLAYER_GAME_RESULT_VICTORY );

            if ( !bj_isSinglePlayer )
            {
                Jass::DisplayTimedTextFromPlayer( whichPlayer, .0f, .0f, 60.f, Jass::GetLocalizedString( "PLAYER_VICTORIOUS" ) );
            }

            // UI only needs to be displayed to users.
            if ( Jass::GetPlayerController( whichPlayer ) == Jass::MAP_CONTROL_USER )
            {
                bj_changeLevelShowScores = showScores;
                if ( showDialog )
                {
                    CustomVictoryDialogBJ( whichPlayer );
                }
                else
                {
                    CustomVictorySkipBJ( whichPlayer );
                }
            }
        }
    }

    void CustomDefeatRestartBJ( )
    {
        Jass::PauseGame( false );
        Jass::RestartGame( true );
    }

    void CustomDefeatReduceDifficultyBJ( )
    {
        gamedifficulty diff = Jass::GetGameDifficulty( );

        Jass::PauseGame( false );

        // Knock the difficulty down, if possible.

        if ( diff == Jass::MAP_DIFFICULTY_EASY )
        {
            // Sorry, but it doesn't get any easier than this.
        }
        else if ( diff == Jass::MAP_DIFFICULTY_NORMAL )
        {
            Jass::SetGameDifficulty( Jass::MAP_DIFFICULTY_EASY );
        }
        else if ( diff == Jass::MAP_DIFFICULTY_HARD )
        {
            Jass::SetGameDifficulty( Jass::MAP_DIFFICULTY_NORMAL );
        }
        else
        {
            // Unrecognized difficulty
        }

        Jass::RestartGame( true );
    }

    void CustomDefeatLoadBJ( )
    {
        Jass::PauseGame( false );
        Jass::DisplayLoadDialog( );
    }

    void CustomDefeatQuitBJ( )
    {
        if ( bj_isSinglePlayer )
        {
            Jass::PauseGame( false );
        }

        // Bump the difficulty back up to the default.
        Jass::SetGameDifficulty( Jass::GetDefaultDifficulty( ) );
        Jass::EndGame( true );
    }

    void CustomDefeatDialogBJ( player whichPlayer, string message )
    {
        trigger t = Jass::CreateTrigger( );
        dialog  d = Jass::DialogCreate( );

        Jass::DialogSetMessage( d, message );

        if ( bj_isSinglePlayer )
        {
            t = Jass::CreateTrigger( );
            Jass::TriggerRegisterDialogButtonEvent( t, Jass::DialogAddButton( d, Jass::GetLocalizedString( "GAMEOVER_RESTART" ), Jass::GetLocalizedHotkey( "GAMEOVER_RESTART" ) ) );
            Jass::TriggerAddAction( t, @CustomDefeatRestartBJ );

            if ( Jass::GetGameDifficulty( ) != Jass::MAP_DIFFICULTY_EASY )
            {
                t = Jass::CreateTrigger( );
                Jass::TriggerRegisterDialogButtonEvent( t, Jass::DialogAddButton( d, Jass::GetLocalizedString( "GAMEOVER_REDUCE_DIFFICULTY" ), Jass::GetLocalizedHotkey( "GAMEOVER_REDUCE_DIFFICULTY" ) ) );
                Jass::TriggerAddAction( t, @CustomDefeatReduceDifficultyBJ );
            }

            t = Jass::CreateTrigger( );
            Jass::TriggerRegisterDialogButtonEvent( t, Jass::DialogAddButton( d, Jass::GetLocalizedString( "GAMEOVER_LOAD" ), Jass::GetLocalizedHotkey( "GAMEOVER_LOAD" ) ) );
            Jass::TriggerAddAction( t, @CustomDefeatLoadBJ );
        }

        t = Jass::CreateTrigger( );
        Jass::TriggerRegisterDialogButtonEvent( t, Jass::DialogAddButton( d, Jass::GetLocalizedString( "GAMEOVER_QUIT_MISSION" ), Jass::GetLocalizedHotkey( "GAMEOVER_QUIT_MISSION" ) ) );
        Jass::TriggerAddAction( t, @CustomDefeatQuitBJ );

        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            Jass::EnableUserControl( true );
            if ( bj_isSinglePlayer )
            {
                Jass::PauseGame( true );
            }
            Jass::EnableUserUI( false );
        }

        Jass::DialogDisplay( whichPlayer, d, true );
        VolumeGroupSetVolumeForPlayerBJ( whichPlayer, Jass::SOUND_VOLUMEGROUP_UI, 1.f );
        StartSoundForPlayerBJ( whichPlayer, bj_defeatDialogSound );
    }

    void CustomDefeatBJ( player whichPlayer, string message )
    {
        if ( AllowVictoryDefeat( Jass::PLAYER_GAME_RESULT_DEFEAT ) )
        {
            Jass::RemovePlayer( whichPlayer, Jass::PLAYER_GAME_RESULT_DEFEAT );

            if ( !bj_isSinglePlayer )
            {
                Jass::DisplayTimedTextFromPlayer( whichPlayer, .0f, .0f, 60.f, Jass::GetLocalizedString( "PLAYER_DEFEATED" ) );
            }

            // UI only needs to be displayed to users.
            if ( Jass::GetPlayerController( whichPlayer ) == Jass::MAP_CONTROL_USER )
            {
                CustomDefeatDialogBJ( whichPlayer, message );
            }
        }
    }

    void SetNextLevelBJ( string nextLevel )
    {
        if ( nextLevel == "" )
        {
            bj_changeLevelMapName = "";
        }
        else
        {
            bj_changeLevelMapName = nextLevel;
        }
    }

    void SetPlayerOnScoreScreenBJ( bool flag, player whichPlayer )
    {
        Jass::SetPlayerOnScoreScreen( whichPlayer, flag );
    }

    quest CreateQuestBJ( int questType, string title, string description, string iconPath )
    {
        bool required   = ( questType == bj_QUESTTYPE_REQ_DISCOVERED ) || ( questType == bj_QUESTTYPE_REQ_UNDISCOVERED );
        bool discovered = ( questType == bj_QUESTTYPE_REQ_DISCOVERED ) || ( questType == bj_QUESTTYPE_OPT_DISCOVERED );

        bj_lastCreatedQuest = Jass::CreateQuest( );
        Jass::QuestSetTitle( bj_lastCreatedQuest, title );
        Jass::QuestSetDescription( bj_lastCreatedQuest, description );
        Jass::QuestSetIconPath( bj_lastCreatedQuest, iconPath );
        Jass::QuestSetRequired( bj_lastCreatedQuest, required );
        Jass::QuestSetDiscovered( bj_lastCreatedQuest, discovered );
        Jass::QuestSetCompleted( bj_lastCreatedQuest, false );
        return bj_lastCreatedQuest;
    }

    void DestroyQuestBJ( quest whichQuest )
    {
        Jass::DestroyQuest( whichQuest );
    }

    void QuestSetEnabledBJ( bool enabled, quest whichQuest )
    {
        Jass::QuestSetEnabled( whichQuest, enabled );
    }

    void QuestSetTitleBJ( quest whichQuest, string title )
    {
        Jass::QuestSetTitle( whichQuest, title );
    }

    void QuestSetDescriptionBJ( quest whichQuest, string description )
    {
        Jass::QuestSetDescription( whichQuest, description );
    }

    void QuestSetCompletedBJ( quest whichQuest, bool completed )
    {
        Jass::QuestSetCompleted( whichQuest, completed );
    }

    void QuestSetFailedBJ( quest whichQuest, bool failed )
    {
        Jass::QuestSetFailed( whichQuest, failed );
    }

    void QuestSetDiscoveredBJ( quest whichQuest, bool discovered )
    {
        Jass::QuestSetDiscovered( whichQuest, discovered );
    }

    quest GetLastCreatedQuestBJ( )
    {
        return bj_lastCreatedQuest;
    }

    questitem CreateQuestItemBJ( quest whichQuest, string description )
    {
        bj_lastCreatedQuestItem = Jass::QuestCreateItem( whichQuest );
        Jass::QuestItemSetDescription( bj_lastCreatedQuestItem, description );
        Jass::QuestItemSetCompleted( bj_lastCreatedQuestItem, false );
        return bj_lastCreatedQuestItem;
    }

    void QuestItemSetDescriptionBJ( questitem whichQuestItem, string description )
    {
        Jass::QuestItemSetDescription( whichQuestItem, description );
    }

    void QuestItemSetCompletedBJ( questitem whichQuestItem, bool completed )
    {
        Jass::QuestItemSetCompleted( whichQuestItem, completed );
    }

    questitem GetLastCreatedQuestItemBJ( )
    {
        return bj_lastCreatedQuestItem;
    }

    defeatcondition CreateDefeatConditionBJ( string description )
    {
        bj_lastCreatedDefeatCondition = Jass::CreateDefeatCondition( );
        Jass::DefeatConditionSetDescription( bj_lastCreatedDefeatCondition, description );
        return bj_lastCreatedDefeatCondition;
    }

    void DestroyDefeatConditionBJ( defeatcondition whichCondition )
    {
        Jass::DestroyDefeatCondition( whichCondition );
    }

    void DefeatConditionSetDescriptionBJ( defeatcondition whichCondition, string description )
    {
        Jass::DefeatConditionSetDescription( whichCondition, description );
    }

    defeatcondition GetLastCreatedDefeatConditionBJ( )
    {
        return bj_lastCreatedDefeatCondition;
    }

    void FlashQuestDialogButtonBJ( )
    {
        Jass::FlashQuestDialogButton( );
    }

    void QuestMessageBJ( force f, int messageType, string message )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), f ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            switch( messageType )
            {
                case bj_QUESTMESSAGE_DISCOVERED:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_QUEST, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_QUEST, message );
                    Jass::StartSound( bj_questDiscoveredSound );
                    Jass::FlashQuestDialogButton( );
                    break;
                }
                case bj_QUESTMESSAGE_UPDATED:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_QUESTUPDATE, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_QUESTUPDATE, message );
                    Jass::StartSound( bj_questUpdatedSound );
                    Jass::FlashQuestDialogButton( );
                    break;
                }
                case bj_QUESTMESSAGE_COMPLETED:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_QUESTDONE, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_QUESTDONE, message );
                    Jass::StartSound( bj_questCompletedSound );
                    Jass::FlashQuestDialogButton( );
                    break;
                }
                case bj_QUESTMESSAGE_FAILED:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_QUESTFAILED, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_QUESTFAILED, message );
                    Jass::StartSound( bj_questFailedSound );
                    Jass::FlashQuestDialogButton( );
                    break;
                }
                case bj_QUESTMESSAGE_REQUIREMENT:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_QUESTREQUIREMENT, message );
                    break;
                }
                case bj_QUESTMESSAGE_MISSIONFAILED:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_MISSIONFAILED, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_MISSIONFAILED, message );
                    Jass::StartSound( bj_questFailedSound );
                    break;
                }
                case bj_QUESTMESSAGE_HINT:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_HINT, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_HINT, message );
                    Jass::StartSound( bj_questHintSound );
                    break;
                }
                case bj_QUESTMESSAGE_ALWAYSHINT:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_ALWAYSHINT, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_ALWAYSHINT, message );
                    Jass::StartSound( bj_questHintSound );
                    break;
                }
                case bj_QUESTMESSAGE_SECRET:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_SECRET, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_SECRET, message );
                    Jass::StartSound( bj_questSecretSound );
                    break;
                }
                case bj_QUESTMESSAGE_UNITACQUIRED:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_UNITACQUIRED, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_UNITACQUIRED, message );
                    Jass::StartSound( bj_questHintSound );
                    break;
                }
                case bj_QUESTMESSAGE_UNITAVAILABLE:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_UNITAVAILABLE, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_UNITAVAILABLE, message );
                    Jass::StartSound( bj_questHintSound );
                    break;
                }
                case bj_QUESTMESSAGE_ITEMACQUIRED:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_ITEMACQUIRED, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_ITEMACQUIRED, message );
                    Jass::StartSound( bj_questItemAcquiredSound );
                    break;
                }
                case bj_QUESTMESSAGE_WARNING:
                {
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_WARNING, " " );
                    Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_TEXT_DELAY_WARNING, message );
                    Jass::StartSound( bj_questWarningSound );
                    break;
                }
                default: break; // Unrecognized message type - ignore the request.
            }
        }
    }

    timer StartTimerBJ( timer t, bool periodic, float timeout )
    {
        bj_lastStartedTimer = t;
        Jass::TimerStart( t, timeout, periodic, null );
        return bj_lastStartedTimer;
    }

    timer CreateTimerBJ( bool periodic, float timeout )
    {
        bj_lastStartedTimer = Jass::CreateTimer( );
        Jass::TimerStart( bj_lastStartedTimer, timeout, periodic, null );
        return bj_lastStartedTimer;
    }

    void DestroyTimerBJ( timer whichTimer )
    {
        Jass::DestroyTimer( whichTimer );
    }

    void PauseTimerBJ( bool pause, timer whichTimer )
    {
        if ( pause )
        {
            Jass::PauseTimer( whichTimer );
        }
        else
        {
            Jass::ResumeTimer( whichTimer );
        }
    }

    timer GetLastCreatedTimerBJ( )
    {
        return bj_lastStartedTimer;
    }

    timerdialog CreateTimerDialogBJ( timer t, string title )
    {
        bj_lastCreatedTimerDialog = Jass::CreateTimerDialog( t );
        Jass::TimerDialogSetTitle( bj_lastCreatedTimerDialog, title );
        Jass::TimerDialogDisplay( bj_lastCreatedTimerDialog, true );
        return bj_lastCreatedTimerDialog;
    }

    void DestroyTimerDialogBJ( timerdialog td )
    {
        Jass::DestroyTimerDialog( td );
    }

    void TimerDialogSetTitleBJ( timerdialog td, string title )
    {
        Jass::TimerDialogSetTitle( td, title );
    }

    void TimerDialogSetTitleColorBJ( timerdialog td, float red, float green, float blue, float transparency )
    {
        Jass::TimerDialogSetTitleColor( td, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void TimerDialogSetTimeColorBJ( timerdialog td, float red, float green, float blue, float transparency )
    {
        Jass::TimerDialogSetTimeColor( td, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void TimerDialogSetSpeedBJ( timerdialog td, float speedMultFactor )
    {
        Jass::TimerDialogSetSpeed( td, speedMultFactor );
    }

    void TimerDialogDisplayForPlayerBJ( bool show, timerdialog td, player whichPlayer )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::TimerDialogDisplay( td, show );
        }
    }

    void TimerDialogDisplayBJ( bool show, timerdialog td )
    {
        Jass::TimerDialogDisplay( td, show );
    }

    timerdialog GetLastCreatedTimerDialogBJ( )
    {
        return bj_lastCreatedTimerDialog;
    }

    void LeaderboardResizeBJ( leaderboard lb )
    {
        int size = Jass::LeaderboardGetItemCount( lb );

        if ( Jass::LeaderboardGetLabelText( lb ) == "" )
        {
            size--;
        }

        Jass::LeaderboardSetSizeByItemCount( lb, size );
    }

    void LeaderboardSetPlayerItemValueBJ( player whichPlayer, leaderboard lb, int val )
    {
        Jass::LeaderboardSetItemValue( lb, Jass::LeaderboardGetPlayerIndex( lb, whichPlayer ), val );
    }

    void LeaderboardSetPlayerItemLabelBJ( player whichPlayer, leaderboard lb, string val )
    {
        Jass::LeaderboardSetItemLabel( lb, Jass::LeaderboardGetPlayerIndex( lb, whichPlayer ), val );
    }

    void LeaderboardSetPlayerItemStyleBJ( player whichPlayer, leaderboard lb, bool showLabel, bool showValue, bool showIcon )
    {
        Jass::LeaderboardSetItemStyle( lb, Jass::LeaderboardGetPlayerIndex( lb, whichPlayer ), showLabel, showValue, showIcon );
    }

    void LeaderboardSetPlayerItemLabelColorBJ( player whichPlayer, leaderboard lb, float red, float green, float blue, float transparency )
    {
        Jass::LeaderboardSetItemLabelColor( lb, Jass::LeaderboardGetPlayerIndex( lb, whichPlayer ), PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void LeaderboardSetPlayerItemValueColorBJ( player whichPlayer, leaderboard lb, float red, float green, float blue, float transparency )
    {
        Jass::LeaderboardSetItemValueColor( lb, Jass::LeaderboardGetPlayerIndex( lb, whichPlayer ), PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void LeaderboardSetLabelColorBJ( leaderboard lb, float red, float green, float blue, float transparency )
    {
        Jass::LeaderboardSetLabelColor( lb, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void LeaderboardSetValueColorBJ( leaderboard lb, float red, float green, float blue, float transparency )
    {
        Jass::LeaderboardSetValueColor( lb, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void LeaderboardSetLabelBJ( leaderboard lb, string label )
    {
        Jass::LeaderboardSetLabel( lb, label );
        LeaderboardResizeBJ( lb );
    }

    void LeaderboardSetStyleBJ( leaderboard lb, bool showLabel, bool showNames, bool showValues, bool showIcons )
    {
        Jass::LeaderboardSetStyle( lb, showLabel, showNames, showValues, showIcons );
    }

    int LeaderboardGetItemCountBJ( leaderboard lb )
    {
        return Jass::LeaderboardGetItemCount( lb );
    }

    bool LeaderboardHasPlayerItemBJ( leaderboard lb, player whichPlayer )
    {
        return Jass::LeaderboardHasPlayerItem( lb, whichPlayer );
    }

    void ForceSetLeaderboardBJ( leaderboard lb, force toForce )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            if ( Jass::IsPlayerInForce( p, toForce ) )
            {
                Jass::PlayerSetLeaderboard( p, lb );
            }
        }
    }

    leaderboard CreateLeaderboardBJ( force toForce, string label )
    {
        bj_lastCreatedLeaderboard = Jass::CreateLeaderboard( );
        Jass::LeaderboardSetLabel( bj_lastCreatedLeaderboard, label );
        ForceSetLeaderboardBJ( bj_lastCreatedLeaderboard, toForce );
        Jass::LeaderboardDisplay( bj_lastCreatedLeaderboard, true );
        return bj_lastCreatedLeaderboard;
    }

    void DestroyLeaderboardBJ( leaderboard lb )
    {
        Jass::DestroyLeaderboard( lb );
    }

    void LeaderboardDisplayBJ( bool show, leaderboard lb )
    {
        Jass::LeaderboardDisplay( lb, show );
    }

    void LeaderboardAddItemBJ( player whichPlayer, leaderboard lb, string label, int value )
    {
        if ( Jass::LeaderboardHasPlayerItem( lb, whichPlayer ) )
        {
            Jass::LeaderboardRemovePlayerItem( lb, whichPlayer );
        }
        Jass::LeaderboardAddItem( lb, label, value, whichPlayer );
        LeaderboardResizeBJ( lb );
        //LeaderboardSetSizeByItemCount( lb, LeaderboardGetItemCount( lb ) );
    }

    void LeaderboardRemovePlayerItemBJ( player whichPlayer, leaderboard lb )
    {
        Jass::LeaderboardRemovePlayerItem( lb, whichPlayer );
        LeaderboardResizeBJ( lb );
    }

    void LeaderboardSortItemsBJ( leaderboard lb, int sortType, bool ascending )
    {
        switch( sortType )
        {
            case bj_SORTTYPE_SORTBYVALUE:   Jass::LeaderboardSortItemsByValue( lb, ascending ); break;
            case bj_SORTTYPE_SORTBYPLAYER:  Jass::LeaderboardSortItemsByPlayer( lb, ascending ); break;
            case bj_SORTTYPE_SORTBYLABEL:   Jass::LeaderboardSortItemsByLabel( lb, ascending ); break;
            default: break; // Unrecognized sort type - ignore the request.
        }
    }

    void LeaderboardSortItemsByPlayerBJ( leaderboard lb, bool ascending )
    {
        Jass::LeaderboardSortItemsByPlayer( lb, ascending );
    }

    void LeaderboardSortItemsByLabelBJ( leaderboard lb, bool ascending )
    {
        Jass::LeaderboardSortItemsByLabel( lb, ascending );
    }

    int LeaderboardGetPlayerIndexBJ( player whichPlayer, leaderboard lb )
    {
        return Jass::LeaderboardGetPlayerIndex( lb, whichPlayer ) + 1;
    }

    player LeaderboardGetIndexedPlayerBJ( int position, leaderboard lb )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            if ( ( Jass::LeaderboardGetPlayerIndex( lb, p ) == position - 1 ) )
            {
                return p;
            }
        }

        return Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE );
    }

    leaderboard PlayerGetLeaderboardBJ( player whichPlayer )
    {
        return Jass::PlayerGetLeaderboard( whichPlayer );
    }

    leaderboard GetLastCreatedLeaderboard( )
    {
        return bj_lastCreatedLeaderboard;
    }

    multiboard CreateMultiboardBJ( int cols, int rows, string title )
    {
        bj_lastCreatedMultiboard = Jass::CreateMultiboard( );
        Jass::MultiboardSetRowCount( bj_lastCreatedMultiboard, rows );
        Jass::MultiboardSetColumnCount( bj_lastCreatedMultiboard, cols );
        Jass::MultiboardSetTitleText( bj_lastCreatedMultiboard, title );
        Jass::MultiboardDisplay( bj_lastCreatedMultiboard, true );
        return bj_lastCreatedMultiboard;
    }

    void DestroyMultiboardBJ( multiboard mb )
    {
        Jass::DestroyMultiboard( mb );
    }

    multiboard GetLastCreatedMultiboard( )
    {
        return bj_lastCreatedMultiboard;
    }

    void MultiboardDisplayBJ( bool show, multiboard mb )
    {
        Jass::MultiboardDisplay( mb, show );
    }

    void MultiboardMinimizeBJ( bool minimize, multiboard mb )
    {
        Jass::MultiboardMinimize( mb, minimize );
    }

    void MultiboardSetTitleTextColorBJ( multiboard mb, float red, float green, float blue, float transparency )
    {
        Jass::MultiboardSetTitleTextColor( mb, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void MultiboardAllowDisplayBJ( bool flag )
    {
        Jass::MultiboardSuppressDisplay( !flag );
    }

    void MultiboardSetItemStyleBJ( multiboard mb, int col, int row, bool showValue, bool showIcon )
    {
        int numRows = Jass::MultiboardGetRowCount( mb );
        int numCols = Jass::MultiboardGetColumnCount( mb );

        // Loop over columns, using 1-based index
        for ( int curRow = 1; curRow <= numRows; curRow++ )
        {
            // Apply setting to the requested row, || all rows ( if row is 0 )
            if ( row == 0 || row == curRow )
            {
                // Loop over columns, using 1-based index
                for ( int curCol = 1; curCol <= numCols; curCol++ )
                {
                    // Apply setting to the requested column, || all columns ( if col is 0 )
                    if ( col == 0 || col == curCol )
                    {
                        multiboarditem mbitem = Jass::MultiboardGetItem( mb, curRow - 1, curCol - 1 );
                        Jass::MultiboardSetItemStyle( mbitem, showValue, showIcon );
                        Jass::MultiboardReleaseItem( mbitem );
                    }
                }
            }
        }
    }

    void MultiboardSetItemValueBJ( multiboard mb, int col, int row, string val )
    {
        int numRows = Jass::MultiboardGetRowCount( mb );
        int numCols = Jass::MultiboardGetColumnCount( mb );

        // Loop over columns, using 1-based index
        for ( int curRow = 1; curRow <= numRows; curRow++ )
        {
            // Apply setting to the requested row, || all rows ( if row is 0 )
            if ( row == 0 || row == curRow )
            {
                // Loop over columns, using 1-based index
                for ( int curCol = 1; curCol <= numCols; curCol++ )
                {
                    // Apply setting to the requested column, || all columns ( if col is 0 )
                    if ( col == 0 || col == curCol )
                    {
                        multiboarditem mbitem = Jass::MultiboardGetItem( mb, curRow - 1, curCol - 1 );
                        Jass::MultiboardSetItemValue( mbitem, val );
                        Jass::MultiboardReleaseItem( mbitem );
                    }
                }
            }
        }
    }

    void MultiboardSetItemColorBJ( multiboard mb, int col, int row, float red, float green, float blue, float transparency )
    {
        int numRows = Jass::MultiboardGetRowCount( mb );
        int numCols = Jass::MultiboardGetColumnCount( mb );

        // Loop over columns, using 1-based index
        for ( int curRow = 1; curRow <= numRows; curRow++ )
        {
            // Apply setting to the requested row, || all rows ( if row is 0 )
            if ( row == 0 || row == curRow )
            {
                // Loop over columns, using 1-based index
                for ( int curCol = 1; curCol <= numCols; curCol++ )
                {
                    // Apply setting to the requested column, || all columns ( if col is 0 )
                    if ( col == 0 || col == curCol )
                    {
                        multiboarditem mbitem = Jass::MultiboardGetItem( mb, curRow - 1, curCol - 1 );
                        Jass::MultiboardSetItemValueColor( mbitem, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
                        Jass::MultiboardReleaseItem( mbitem );
                    }
                }
            }
        }
    }

    void MultiboardSetItemWidthBJ( multiboard mb, int col, int row, float width )
    {
        int numRows = Jass::MultiboardGetRowCount( mb );
        int numCols = Jass::MultiboardGetColumnCount( mb );

        // Loop over columns, using 1-based index
        for ( int curRow = 1; curRow <= numRows; curRow++ )
        {
            // Apply setting to the requested row, || all rows ( if row is 0 )
            if ( row == 0 || row == curRow )
            {
                // Loop over columns, using 1-based index
                for ( int curCol = 1; curCol <= numCols; curCol++ )
                {
                    // Apply setting to the requested column, || all columns ( if col is 0 )
                    if ( col == 0 || col == curCol )
                    {
                        multiboarditem mbitem = Jass::MultiboardGetItem( mb, curRow - 1, curCol - 1 );
                        Jass::MultiboardSetItemWidth( mbitem, width / 100.f );
                        Jass::MultiboardReleaseItem( mbitem );
                    }
                }
            }
        }
    }

    void MultiboardSetItemIconBJ( multiboard mb, int col, int row, string iconFileName )
    {
        int numRows = Jass::MultiboardGetRowCount( mb );
        int numCols = Jass::MultiboardGetColumnCount( mb );

        // Loop over columns, using 1-based index
        for ( int curRow = 1; curRow <= numRows; curRow++ )
        {
            // Apply setting to the requested row, || all rows ( if row is 0 )
            if ( row == 0 || row == curRow )
            {
                // Loop over columns, using 1-based index
                for ( int curCol = 1; curCol <= numCols; curCol++ )
                {
                    // Apply setting to the requested column, || all columns ( if col is 0 )
                    if ( col == 0 || col == curCol )
                    {
                        multiboarditem mbitem = Jass::MultiboardGetItem( mb, curRow - 1, curCol - 1 );
                        Jass::MultiboardSetItemIcon( mbitem, iconFileName );
                        Jass::MultiboardReleaseItem( mbitem );
                    }
                }
            }
        }
    }

    float TextTagSize2Height( float size )
    {
        return size * 0.023f / 10.f;
    }

    float TextTagSpeed2Velocity( float speed )
    {
        return speed * 0.071f / 128.f;
    }

    void SetTextTagColorBJ( texttag tt, float red, float green, float blue, float transparency )
    {
        Jass::SetTextTagColor( tt, PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - transparency ) );
    }

    void SetTextTagVelocityBJ( texttag tt, float speed, float angle )
    {
        float vel = TextTagSpeed2Velocity( speed );
        float xvel = vel * Jass::Cos( angle * bj_DEGTORAD );
        float yvel = vel * Jass::Sin( angle * bj_DEGTORAD );

        Jass::SetTextTagVelocity( tt, xvel, yvel );
    }

    void SetTextTagTextBJ( texttag tt, string s, float size )
    {
        float textHeight = TextTagSize2Height( size );

        Jass::SetTextTagText( tt, s, textHeight );
    }

    void SetTextTagPosBJ( texttag tt, location loc, float zOffset )
    {
        Jass::SetTextTagPos( tt, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), zOffset );
    }

    void SetTextTagPosUnitBJ( texttag tt, unit whichUnit, float zOffset )
    {
        Jass::SetTextTagPosUnit( tt, whichUnit, zOffset );
    }

    void SetTextTagSuspendedBJ( texttag tt, bool flag )
    {
        Jass::SetTextTagSuspended( tt, flag );
    }

    void SetTextTagPermanentBJ( texttag tt, bool flag )
    {
        Jass::SetTextTagPermanent( tt, flag );
    }

    void SetTextTagAgeBJ( texttag tt, float age )
    {
        Jass::SetTextTagAge( tt, age );
    }

    void SetTextTagLifespanBJ( texttag tt, float lifespan )
    {
        Jass::SetTextTagLifespan( tt, lifespan );
    }

    void SetTextTagFadepointBJ( texttag tt, float fadepoint )
    {
        Jass::SetTextTagFadepoint( tt, fadepoint );
    }

    texttag CreateTextTagLocBJ( string s, location loc, float zOffset, float size, float red, float green, float blue, float transparency )
    {
        bj_lastCreatedTextTag = Jass::CreateTextTag( );
        SetTextTagTextBJ( bj_lastCreatedTextTag, s, size );
        SetTextTagPosBJ( bj_lastCreatedTextTag, loc, zOffset );
        SetTextTagColorBJ( bj_lastCreatedTextTag, red, green, blue, transparency );

        return bj_lastCreatedTextTag;
    }

    texttag CreateTextTagUnitBJ( string s, unit whichUnit, float zOffset, float size, float red, float green, float blue, float transparency )
    {
        bj_lastCreatedTextTag = Jass::CreateTextTag( );
        SetTextTagTextBJ( bj_lastCreatedTextTag, s, size );
        SetTextTagPosUnitBJ( bj_lastCreatedTextTag, whichUnit, zOffset );
        SetTextTagColorBJ( bj_lastCreatedTextTag, red, green, blue, transparency );

        return bj_lastCreatedTextTag;
    }

    void DestroyTextTagBJ( texttag tt )
    {
        Jass::DestroyTextTag( tt );
    }

    void ShowTextTagForceBJ( bool show, texttag tt, force whichForce )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), whichForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::SetTextTagVisibility( tt, show );
        }
    }

    texttag GetLastCreatedTextTag( )
    {
        return bj_lastCreatedTextTag;
    }

    void PauseGameOn( )
    {
        Jass::PauseGame( true );
    }

    void PauseGameOff( )
    {
        Jass::PauseGame( false );
    }

    void SetUserControlForceOn( force whichForce )
    {
        if ( ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), whichForce ) ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::EnableUserControl( true );
        }
    }

    void SetUserControlForceOff( force whichForce )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), whichForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::EnableUserControl( false );
        }
    }

    void ShowInterfaceForceOn( force whichForce, float fadeDuration )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), whichForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::ShowInterface( true, fadeDuration );
        }
    }

    void ShowInterfaceForceOff( force whichForce, float fadeDuration )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), whichForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::ShowInterface( false, fadeDuration );
        }
    }

    void PingMinimapForForce( force whichForce, float x, float y, float duration )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), whichForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::PingMinimap( x, y, duration );
            //StartSound( bj_pingMinimapSound )
        }
    }

    void PingMinimapLocForForce( force whichForce, location loc, float duration )
    {
        PingMinimapForForce( whichForce, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), duration );
    }

    void PingMinimapForPlayer( player whichPlayer, float x, float y, float duration )
    {
        if ( Jass::GetLocalPlayer( ) == whichPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::PingMinimap( x, y, duration );
            //StartSound( bj_pingMinimapSound );
        }
    }

    void PingMinimapLocForPlayer( player whichPlayer, location loc, float duration )
    {
        PingMinimapForPlayer( whichPlayer, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), duration );
    }

    void PingMinimapForForceEx( force whichForce, float x, float y, float duration, int style, float red, float green, float blue )
    {
        int red255   = PercentTo255( red );
        int green255 = PercentTo255( green );
        int blue255  = PercentTo255( blue );

        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), whichForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.

            // Prevent 100% red simple && flashy pings, as they become "attack" pings.
            if ( red255 == 255 && green255 == 0 && blue255 == 0 )
            {
                red255 = 254;
            }

            switch( style )
            {
                case bj_MINIMAPPINGSTYLE_SIMPLE: Jass::PingMinimapEx( x, y, duration, red255, green255, blue255, false ); break;
                case bj_MINIMAPPINGSTYLE_FLASHY: Jass::PingMinimapEx( x, y, duration, red255, green255, blue255, true ); break;
                case bj_MINIMAPPINGSTYLE_ATTACK: Jass::PingMinimapEx( x, y, duration, 255, 0, 0, false ); break;
                default: break; // Unrecognized ping style - ignore the request.
            }

            //StartSound( bj_pingMinimapSound )
        }
    }

    void PingMinimapLocForForceEx( force whichForce, location loc, float duration, int style, float red, float green, float blue )
    {
        PingMinimapForForceEx( whichForce, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), duration, style, red, green, blue );
    }

    void EnableWorldFogBoundaryBJ( bool enable, force f )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), f ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::EnableWorldFogBoundary( enable );
        }
    }

    void EnableOcclusionBJ( bool enable, force f )
    {
        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), f ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.
            Jass::EnableOcclusion( enable );
        }
    }

    void CancelCineSceneBJ( )
    {
        StopSoundBJ( bj_cineSceneLastSound, true );
        Jass::EndCinematicScene( );
    }

    void TryInitCinematicBehaviorBJ( )
    {
        if ( bj_cineSceneBeingSkipped == nil )
        {
            bj_cineSceneBeingSkipped = Jass::CreateTrigger( );

            for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
            {
                Jass::TriggerRegisterPlayerEvent( bj_cineSceneBeingSkipped, Jass::Player( i ), Jass::EVENT_PLAYER_END_CINEMATIC );
            }

            Jass::TriggerAddAction( bj_cineSceneBeingSkipped, @CancelCineSceneBJ );
        }
    }

    void SetCinematicSceneBJ( sound soundHandle, int portraitUnitId, playercolor color, string speakerTitle, string text, float sceneDuration, float voiceoverDuration )
    {
        bj_cineSceneLastSound = soundHandle;
        PlaySoundBJ( soundHandle );
        Jass::SetCinematicScene( portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration );
    }

    float GetTransmissionDuration( sound soundHandle, int timeType, float timeVal )
    {
        float duration = .0f;

        switch( timeType )
        {
            case bj_TIMETYPE_ADD: duration = GetSoundDurationBJ( soundHandle ) + timeVal; break;
            case bj_TIMETYPE_SET: duration = timeVal; break;
            case bj_TIMETYPE_SUB: duration = GetSoundDurationBJ( soundHandle ) - timeVal; break;
            default: duration = GetSoundDurationBJ( soundHandle ); break; // Unrecognized timeType - ignore timeVal.
        }

        // Make sure we have a non-negative duration.
        if ( duration < .0f )
        {
            duration = .0f;
        }

        return duration;
    }

    void WaitTransmissionDuration( sound soundHandle, int timeType, float timeVal )
    {
        switch( timeType )
        {
            case bj_TIMETYPE_SET: Jass::TriggerSleepAction( timeVal ); break; // If we have a static duration wait, just perform the wait.
            case bj_TIMETYPE_SUB: WaitForSoundBJ( soundHandle, timeVal ); break; // If the transmission is cutting off the sound, wait for the sound to be mostly finished.
            case bj_TIMETYPE_ADD:
            {
                // If the transmission is extending beyond the sound's length, wait for it to finish, and wait the additional time.
                WaitForSoundBJ( soundHandle, 0 );
                Jass::TriggerSleepAction( timeVal );
                break;
            }
            default:
            {
                if ( soundHandle == nil ) { Jass::TriggerSleepAction( bj_NOTHING_SOUND_DURATION ); } // If the sound does not exist, perform a default length wait.
                else { } // Unrecognized timeType - ignore.

                break;
            }
        }
    }

    void DoTransmissionBasicsXYBJ( int unitId, playercolor color, float x, float y, sound soundHandle, string unitName, string message, float duration )
    {
        SetCinematicSceneBJ( soundHandle, unitId, color, unitName, message, duration + bj_TRANSMISSION_PORT_HANGTIME, duration );

        if ( unitId != 0 )
        {
            Jass::PingMinimap( x, y, bj_TRANSMISSION_PING_TIME );
            //SetCameraQuickPosition( x, y )
        }
    }

    void TransmissionFromUnitWithNameBJ( force toForce, unit whichUnit, string unitName, sound soundHandle, string message, int timeType, float timeVal, bool wait )
    {
        TryInitCinematicBehaviorBJ( );

        // Ensure that the time value is non-negative.
        timeVal = RMaxBJ( timeVal, .0f );

        bj_lastTransmissionDuration = GetTransmissionDuration( soundHandle, timeType, timeVal );
        bj_lastPlayedSound = soundHandle;

        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), toForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.

            if ( whichUnit == nil )
            {
                // If the unit reference is invalid, send the transmission from the center of the map with no portrait.
                DoTransmissionBasicsXYBJ( 0, Jass::PLAYER_COLOR_RED, 0, 0, soundHandle, unitName, message, bj_lastTransmissionDuration );
            }
            else
            {
                DoTransmissionBasicsXYBJ( Jass::GetUnitTypeId( whichUnit ), Jass::GetPlayerColor( Jass::GetOwningPlayer( whichUnit ) ), Jass::GetUnitX( whichUnit ), Jass::GetUnitY( whichUnit ), soundHandle, unitName, message, bj_lastTransmissionDuration );
                if ( !Jass::IsUnitHidden( whichUnit ) )
                {
                    Jass::UnitAddIndicator( whichUnit, bj_TRANSMISSION_IND_RED, bj_TRANSMISSION_IND_BLUE, bj_TRANSMISSION_IND_GREEN, bj_TRANSMISSION_IND_ALPHA );
                }
            }
        }

        if ( wait && ( bj_lastTransmissionDuration > .0f ) )
        {
            // TriggerSleepAction( bj_lastTransmissionDuration )
            WaitTransmissionDuration( soundHandle, timeType, timeVal );
        }
    }

    void TransmissionFromUnitTypeWithNameBJ( force toForce, player fromPlayer, int unitId, string unitName, location loc, sound soundHandle, string message, int timeType, float timeVal, bool wait )
    {
        TryInitCinematicBehaviorBJ( );

        // Ensure that the time value is non-negative.
        timeVal = RMaxBJ( timeVal, .0f );

        bj_lastTransmissionDuration = GetTransmissionDuration( soundHandle, timeType, timeVal );
        bj_lastPlayedSound = soundHandle;

        if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), toForce ) )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.

            DoTransmissionBasicsXYBJ( unitId, Jass::GetPlayerColor( fromPlayer ), Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), soundHandle, unitName, message, bj_lastTransmissionDuration );
        }

        if ( wait && ( bj_lastTransmissionDuration > .0f ) )
        {
            // TriggerSleepAction( bj_lastTransmissionDuration )
            WaitTransmissionDuration( soundHandle, timeType, timeVal );
        }
    }

    float GetLastTransmissionDurationBJ( )
    {
        return bj_lastTransmissionDuration;
    }

    void ForceCinematicSubtitlesBJ( bool flag )
    {
        Jass::ForceCinematicSubtitles( flag );
    }

    void CinematicModeExBJ( bool cineMode, force forForce, float interfaceFadeTime )
    {
        // If the game hasn't started yet, perform interface fades immediately
        if ( !bj_gameStarted )
        {
            interfaceFadeTime = .0f;
        }

        if ( cineMode )
        {
            // Save the UI state so that we can restore it later.
            if ( !bj_cineModeAlreadyIn )
            {
                bj_cineModeAlreadyIn = true;
                bj_cineModePriorSpeed = Jass::GetGameSpeed( );
                bj_cineModePriorFogSetting = Jass::IsFogEnabled( );
                bj_cineModePriorMaskSetting = Jass::IsFogMaskEnabled( );
                bj_cineModePriorDawnDusk = IsDawnDuskEnabled( );
                bj_cineModeSavedSeed = Jass::GetRandomInt( 0, 1000000 );
            }

            // Perform changes
            if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), forForce ) )
            {
                // Use only code ( no net traffic ) within this block to avoid desyncs.
                Jass::ClearTextMessages( );
                Jass::ShowInterface( false, interfaceFadeTime );
                Jass::EnableUserControl( false );
                Jass::EnableOcclusion( false );
                SetCineModeVolumeGroupsBJ( );
            }

            // Perform global changes
            Jass::SetGameSpeed( bj_CINEMODE_GAMESPEED );
            Jass::SetMapFlag( Jass::MAP_LOCK_SPEED, true );
            Jass::FogMaskEnable( false );
            Jass::FogEnable( false );
            Jass::EnableWorldFogBoundary( false );
            EnableDawnDusk( false );

            // Use a fixed random seed, so that cinematics play consistently.
            Jass::SetRandomSeed( 0 );
        }
        else
        {
            bj_cineModeAlreadyIn = false;

            // Perform changes
            if ( Jass::IsPlayerInForce( Jass::GetLocalPlayer( ), forForce ) )
            {
                // Use only code ( no net traffic ) within this block to avoid desyncs.
                Jass::ShowInterface( true, interfaceFadeTime );
                Jass::EnableUserControl( true );
                Jass::EnableOcclusion( true );
                Jass::VolumeGroupReset( );
                Jass::EndThematicMusic( );
                CameraResetSmoothingFactorBJ( );
            }

            // Perform global changes
            Jass::SetMapFlag( Jass::MAP_LOCK_SPEED, false );
            Jass::SetGameSpeed( bj_cineModePriorSpeed );
            Jass::FogMaskEnable( bj_cineModePriorMaskSetting );
            Jass::FogEnable( bj_cineModePriorFogSetting );
            Jass::EnableWorldFogBoundary( true );
            EnableDawnDusk( bj_cineModePriorDawnDusk );
            Jass::SetRandomSeed( bj_cineModeSavedSeed );
        }
    }

    void CinematicModeBJ( bool cineMode, force forForce )
    {
        CinematicModeExBJ( cineMode, forForce, bj_CINEMODE_INTERFACEFADE );
    }

    void DisplayCineFilterBJ( bool flag )
    {
        Jass::DisplayCineFilter( flag );
    }

    void CinematicFadeCommonBJ( float red, float green, float blue, float duration, string tex, float startTrans, float endTrans )
    {
        if ( duration == 0 )
        {
            // If the fade is instant, use the same starting && ending values,
            // so that we effectively do a rather than a fade.
            startTrans = endTrans;
        }
        Jass::EnableUserUI( false );
        Jass::SetCineFilterTexture( tex );
        Jass::SetCineFilterBlendMode( Jass::BLEND_MODE_BLEND );
        Jass::SetCineFilterTexMapFlags( Jass::TEXMAP_FLAG_NONE );
        Jass::SetCineFilterStartUV( 0, 0, 1, 1 );
        Jass::SetCineFilterEndUV( 0, 0, 1, 1 );
        Jass::SetCineFilterStartColor( PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - startTrans ) );
        Jass::SetCineFilterEndColor( PercentTo255( red ), PercentTo255( green ), PercentTo255( blue ), PercentTo255( 100.f - endTrans ) );
        Jass::SetCineFilterDuration( duration );
        Jass::DisplayCineFilter( true );
    }

    void FinishCinematicFadeBJ( )
    {
        Jass::DestroyTimer( bj_cineFadeFinishTimer );
        bj_cineFadeFinishTimer = nil;
        Jass::DisplayCineFilter( false );
        Jass::EnableUserUI( true );
    }

    void FinishCinematicFadeAfterBJ( float duration )
    {
        // Create a timer to end the cinematic fade.
        bj_cineFadeFinishTimer = Jass::CreateTimer( );
        Jass::TimerStart( bj_cineFadeFinishTimer, duration, false, @FinishCinematicFadeBJ );
    }

    void ContinueCinematicFadeBJ( )
    {
        Jass::DestroyTimer( bj_cineFadeContinueTimer );
        bj_cineFadeContinueTimer = nil;
        CinematicFadeCommonBJ( bj_cineFadeContinueRed, bj_cineFadeContinueGreen, bj_cineFadeContinueBlue, bj_cineFadeContinueDuration, bj_cineFadeContinueTex, bj_cineFadeContinueTrans, 100 );
    }

    void ContinueCinematicFadeAfterBJ( float duration, float red, float green, float blue, float trans, string tex )
    {
        bj_cineFadeContinueRed = red;
        bj_cineFadeContinueGreen = green;
        bj_cineFadeContinueBlue = blue;
        bj_cineFadeContinueTrans = trans;
        bj_cineFadeContinueDuration = duration;
        bj_cineFadeContinueTex = tex;

        // Create a timer to continue the cinematic fade.
        bj_cineFadeContinueTimer = Jass::CreateTimer( );
        Jass::TimerStart( bj_cineFadeContinueTimer, duration, false, @ContinueCinematicFadeBJ );
    }

    void AbortCinematicFadeBJ( )
    {
        if ( bj_cineFadeContinueTimer != nil )
        {
            Jass::DestroyTimer( bj_cineFadeContinueTimer );
        }

        if ( bj_cineFadeFinishTimer != nil )
        {
            Jass::DestroyTimer( bj_cineFadeFinishTimer );
        }
    }

    void CinematicFadeBJ( int fadetype, float duration, string tex, float red, float green, float blue, float trans )
    {
        switch( fadetype )
        {
            case bj_CINEFADETYPE_FADEOUT:
            {
                // Fade out to the requested color.
                AbortCinematicFadeBJ( );
                CinematicFadeCommonBJ( red, green, blue, duration, tex, 100, trans );
                break;
            }
            case bj_CINEFADETYPE_FADEIN:
            {
                // Fade in from the requested color.
                AbortCinematicFadeBJ( );
                CinematicFadeCommonBJ( red, green, blue, duration, tex, trans, 100 );
                FinishCinematicFadeAfterBJ( duration );
                break;
            }
            case bj_CINEFADETYPE_FADEOUTIN:
            {
                // Fade out to the requested color, && { fade back in from it.
                if ( duration > 0 )
                {
                    AbortCinematicFadeBJ( );
                    CinematicFadeCommonBJ( red, green, blue, duration * 0.5, tex, 100, trans );
                    ContinueCinematicFadeAfterBJ( duration * 0.5, red, green, blue, trans, tex );
                    FinishCinematicFadeAfterBJ( duration );
                }

                break;
            }
            default: break; // Unrecognized fadetype - ignore the request.
        }
    }

    void CinematicFilterGenericBJ( float duration, blendmode bmode, string tex, float red0, float green0, float blue0, float trans0, float red1, float green1, float blue1, float trans1 )
    {
        AbortCinematicFadeBJ( );
        Jass::SetCineFilterTexture( tex );
        Jass::SetCineFilterBlendMode( bmode );
        Jass::SetCineFilterTexMapFlags( Jass::TEXMAP_FLAG_NONE );
        Jass::SetCineFilterStartUV( 0, 0, 1, 1 );
        Jass::SetCineFilterEndUV( 0, 0, 1, 1 );
        Jass::SetCineFilterStartColor( PercentTo255( red0 ), PercentTo255( green0 ), PercentTo255( blue0 ), PercentTo255( 100.f - trans0 ) );
        Jass::SetCineFilterEndColor( PercentTo255( red1 ), PercentTo255( green1 ), PercentTo255( blue1 ), PercentTo255( 100.f - trans1 ) );
        Jass::SetCineFilterDuration( duration );
        Jass::DisplayCineFilter( true );
    }

    void RescueUnitBJ( unit whichUnit, player rescuer, bool changeColor )
    {
        if ( IsUnitDeadBJ( whichUnit ) || Jass::GetOwningPlayer( whichUnit ) == rescuer )
        {
            return;
        }

        Jass::StartSound( bj_rescueSound );
        Jass::SetUnitOwner( whichUnit, rescuer, changeColor );
        Jass::UnitAddIndicator( whichUnit, 0, 255, 0, 255 );
        PingMinimapForPlayer( rescuer, Jass::GetUnitX( whichUnit ), Jass::GetUnitY( whichUnit ), bj_RESCUE_PING_TIME );
    }

    void TriggerActionUnitRescuedBJ( )
    {
        unit theUnit = Jass::GetTriggerUnit( );

        if ( Jass::IsUnitType( theUnit, Jass::UNIT_TYPE_STRUCTURE ) )
        {
            RescueUnitBJ( theUnit, Jass::GetOwningPlayer( Jass::GetRescuer( ) ), bj_rescueChangeColorBldg );
        }
        else
        {
            RescueUnitBJ( theUnit, Jass::GetOwningPlayer( Jass::GetRescuer( ) ), bj_rescueChangeColorUnit );
        }
    }

    void TryInitRescuableTriggersBJ( )
    {
        if ( bj_rescueUnitBehavior == nil )
        {
            bj_rescueUnitBehavior = Jass::CreateTrigger( );
            
            for ( int i = 0; i < bj_MAX_PLAYER_SLOTS; i++ )
            {
                Jass::TriggerRegisterPlayerUnitEvent( bj_rescueUnitBehavior, Jass::Player( i ), Jass::EVENT_PLAYER_UNIT_RESCUED, nil );
            }

            Jass::TriggerAddAction( bj_rescueUnitBehavior, @TriggerActionUnitRescuedBJ );
        }
    }

    void SetRescueUnitColorChangeBJ( bool changeColor )
    {
        bj_rescueChangeColorUnit = changeColor;
    }

    void SetRescueBuildingColorChangeBJ( bool changeColor )
    {
        bj_rescueChangeColorBldg = changeColor;
    }

    void MakeUnitRescuableToForceBJEnum( )
    {
        TryInitRescuableTriggersBJ( );
        Jass::SetUnitRescuable( bj_makeUnitRescuableUnit, Jass::GetEnumPlayer( ), bj_makeUnitRescuableFlag );
    }

    void MakeUnitRescuableToForceBJ( unit whichUnit, bool isRescuable, force whichForce )
    {
        // Flag the unit as rescuable/unrescuable for the appropriate players.
        bj_makeUnitRescuableUnit = whichUnit;
        bj_makeUnitRescuableFlag = isRescuable;
        Jass::ForForce( whichForce, @MakeUnitRescuableToForceBJEnum );
    }

    void InitRescuableBehaviorBJ( )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            // If at least one player slot is "Rescuable"-controlled, init the
            // rescue behavior triggers.
            if ( Jass::GetPlayerController( Jass::Player( i ) ) == Jass::MAP_CONTROL_RESCUABLE )
            {
                TryInitRescuableTriggersBJ( );
                return;
            }
        }
    }

    void SetPlayerTechResearchedSwap( int techid, int levels, player whichPlayer )
    {
        Jass::SetPlayerTechResearched( whichPlayer, techid, levels );
    }

    void SetPlayerTechMaxAllowedSwap( int techid, int maximum, player whichPlayer )
    {
        Jass::SetPlayerTechMaxAllowed( whichPlayer, techid, maximum );
    }

    void SetPlayerMaxHeroesAllowed( int maximum, player whichPlayer )
    {
        Jass::SetPlayerTechMaxAllowed( whichPlayer, 'HERO', maximum );
    }

    int GetPlayerTechCountSimple( int techid, player whichPlayer )
    {
        return Jass::GetPlayerTechCount( whichPlayer, techid, true );
    }

    int GetPlayerTechMaxAllowedSwap( int techid, player whichPlayer )
    {
        return Jass::GetPlayerTechMaxAllowed( whichPlayer, techid );
    }

    void SetPlayerAbilityAvailableBJ( bool avail, int abilid, player whichPlayer )
    {
        Jass::SetPlayerAbilityAvailable( whichPlayer, abilid, avail );
    }

    void SetCampaignMenuRaceBJ( int campaignNumber )
    {
        switch( campaignNumber )
        {
            case bj_CAMPAIGN_INDEX_T:   Jass::SetCampaignMenuRace( Jass::RACE_OTHER ); break;
            case bj_CAMPAIGN_INDEX_H:   Jass::SetCampaignMenuRace( Jass::RACE_HUMAN ); break;
            case bj_CAMPAIGN_INDEX_U:   Jass::SetCampaignMenuRace( Jass::RACE_UNDEAD ); break;
            case bj_CAMPAIGN_INDEX_O:   Jass::SetCampaignMenuRace( Jass::RACE_ORC ); break;
            case bj_CAMPAIGN_INDEX_N:   Jass::SetCampaignMenuRace( Jass::RACE_NIGHTELF ); break;
            case bj_CAMPAIGN_INDEX_XN:  Jass::SetCampaignMenuRaceEx( bj_CAMPAIGN_OFFSET_XN ); break;
            case bj_CAMPAIGN_INDEX_XH:  Jass::SetCampaignMenuRaceEx( bj_CAMPAIGN_OFFSET_XH ); break;
            case bj_CAMPAIGN_INDEX_XU:  Jass::SetCampaignMenuRaceEx( bj_CAMPAIGN_OFFSET_XU ); break;
            case bj_CAMPAIGN_INDEX_XO:  Jass::SetCampaignMenuRaceEx( bj_CAMPAIGN_OFFSET_XO ); break;
            default: break; // Unrecognized campaign - ignore the request
        }

    }

    void SetMissionAvailableBJ( bool available, int missionIndex )
    {
        int campaignNumber = missionIndex / 1000;
        int missionNumber = missionIndex - campaignNumber * 1000;

        Jass::SetMissionAvailable( campaignNumber, missionNumber, available );
    }

    void SetCampaignAvailableBJ( bool available, int campaignNumber )
    {
        if ( campaignNumber == bj_CAMPAIGN_INDEX_H )
        {
            Jass::SetTutorialCleared( true );
        }

        int campaignOffset = campaignNumber;

        switch( campaignNumber )
        {
            case bj_CAMPAIGN_INDEX_XN: campaignOffset = bj_CAMPAIGN_OFFSET_XN; break;
            case bj_CAMPAIGN_INDEX_XH: campaignOffset = bj_CAMPAIGN_OFFSET_XH; break;
            case bj_CAMPAIGN_INDEX_XU: campaignOffset = bj_CAMPAIGN_OFFSET_XU; break;
            case bj_CAMPAIGN_INDEX_XO: campaignOffset = bj_CAMPAIGN_OFFSET_XO; break;
        }

        Jass::SetCampaignAvailable( campaignOffset, available );
        SetCampaignMenuRaceBJ( campaignNumber );
        Jass::ForceCampaignSelectScreen( );
    }

    void SetCinematicAvailableBJ( bool available, int cinematicIndex )
    {
        switch( cinematicIndex )
        {
            case bj_CINEMATICINDEX_TOP:
            {
                Jass::SetOpCinematicAvailable( bj_CAMPAIGN_INDEX_T, available );
                Jass::PlayCinematic( "TutorialOp" );
                break;
            }
            case bj_CINEMATICINDEX_HOP:
            {
                Jass::SetOpCinematicAvailable( bj_CAMPAIGN_INDEX_H, available );
                Jass::PlayCinematic( "HumanOp" );
                break;
            }
            case bj_CINEMATICINDEX_HED:
            {
                Jass::SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_H, available );
                Jass::PlayCinematic( "HumanEd" );
                break;
            }
            case bj_CINEMATICINDEX_OOP:
            {
                Jass::SetOpCinematicAvailable( bj_CAMPAIGN_INDEX_O, available );
                Jass::PlayCinematic( "OrcOp" );
                break;
            }
            case bj_CINEMATICINDEX_OED:
            {
                Jass::SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_O, available );
                Jass::PlayCinematic( "OrcEd" );
                break;
            }
            case bj_CINEMATICINDEX_UOP:
            {
                Jass::SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_U, available );
                Jass::PlayCinematic( "UndeadOp" );
                break;
            }
            case bj_CINEMATICINDEX_UED:
            {
                Jass::SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_U, available );
                Jass::PlayCinematic( "UndeadEd" );
                break;
            }
            case bj_CINEMATICINDEX_NOP:
            {
                Jass::SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_N, available );
                Jass::PlayCinematic( "NightElfOp" );
                break;
            }
            case bj_CINEMATICINDEX_NED:
            {
                Jass::SetEdCinematicAvailable( bj_CAMPAIGN_INDEX_N, available );
                Jass::PlayCinematic( "NightElfEd" );
                break;
            }
            case bj_CINEMATICINDEX_XOP:
            {
                Jass::SetOpCinematicAvailable( bj_CAMPAIGN_OFFSET_XN, available );
                Jass::PlayCinematic( "IntroX" );
                break;
            }
            case bj_CINEMATICINDEX_XED:
            {
                Jass::SetEdCinematicAvailable( bj_CAMPAIGN_OFFSET_XU, available );
                Jass::PlayCinematic( "OutroX" );
                break;
            }
            default: break; // Unrecognized cinematic - ignore the request.
        }
    }

    gamecache InitGameCacheBJ( string campaignFile )
    {
        bj_lastCreatedGameCache = Jass::InitGameCache( campaignFile );
        return bj_lastCreatedGameCache;
    }

    bool SaveGameCacheBJ( gamecache cache )
    {
        return Jass::SaveGameCache( cache );
    }

    gamecache GetLastCreatedGameCacheBJ( )
    {
        return bj_lastCreatedGameCache;
    }

    hashtable InitHashtableBJ( )
    {
        bj_lastCreatedHashtable = Jass::InitHashtable( );
        return bj_lastCreatedHashtable;
    }

    hashtable GetLastCreatedHashtableBJ( )
    {
        return bj_lastCreatedHashtable;
    }

    void StoreRealBJ( float value, string key, string missionKey, gamecache cache )
    {
        Jass::StoreReal( cache, missionKey, key, value );
    }

    void StoreIntegerBJ( int value, string key, string missionKey, gamecache cache )
    {
        Jass::StoreInteger( cache, missionKey, key, value );
    }

    void StoreBooleanBJ( bool value, string key, string missionKey, gamecache cache )
    {
        Jass::StoreBoolean( cache, missionKey, key, value );
    }

    bool StoreStringBJ( string value, string key, string missionKey, gamecache cache )
    {
        return Jass::StoreString( cache, missionKey, key, value );
    }

    bool StoreUnitBJ( unit whichUnit, string key, string missionKey, gamecache cache )
    {
        return Jass::StoreUnit( cache, missionKey, key, whichUnit );
    }

    void SaveRealBJ( float value, int key, int missionKey, hashtable table )
    {
        Jass::SaveReal( table, missionKey, key, value );
    }

    void SaveIntegerBJ( int value, int key, int missionKey, hashtable table )
    {
        Jass::SaveInteger( table, missionKey, key, value );
    }

    void SaveBooleanBJ( bool value, int key, int missionKey, hashtable table )
    {
        Jass::SaveBoolean( table, missionKey, key, value );
    }

    bool SaveStringBJ( string value, int key, int missionKey, hashtable table )
    {
        return Jass::SaveStr( table, missionKey, key, value );
    }

    bool SavePlayerHandleBJ( player whichPlayer, int key, int missionKey, hashtable table )
    {
        return Jass::SavePlayerHandle( table, missionKey, key, whichPlayer );
    }

    bool SaveWidgetHandleBJ( widget whichWidget, int key, int missionKey, hashtable table )
    {
        return Jass::SaveWidgetHandle( table, missionKey, key, whichWidget );
    }

    bool SaveDestructableHandleBJ( destructable whichDestructable, int key, int missionKey, hashtable table )
    {
        return Jass::SaveDestructableHandle( table, missionKey, key, whichDestructable );
    }

    bool SaveItemHandleBJ( item whichItem, int key, int missionKey, hashtable table )
    {
        return Jass::SaveItemHandle( table, missionKey, key, whichItem );
    }

    bool SaveUnitHandleBJ( unit whichUnit, int key, int missionKey, hashtable table )
    {
        return Jass::SaveUnitHandle( table, missionKey, key, whichUnit );
    }

    bool SaveAbilityHandleBJ( ability whichAbility, int key, int missionKey, hashtable table )
    {
        return Jass::SaveAbilityHandle( table, missionKey, key, whichAbility );
    }

    bool SaveTimerHandleBJ( timer whichTimer, int key, int missionKey, hashtable table )
    {
        return Jass::SaveTimerHandle( table, missionKey, key, whichTimer );
    }

    bool SaveTriggerHandleBJ( trigger whichTrigger, int key, int missionKey, hashtable table )
    {
        return Jass::SaveTriggerHandle( table, missionKey, key, whichTrigger );
    }

    bool SaveTriggerConditionHandleBJ( triggercondition whichTriggercondition, int key, int missionKey, hashtable table )
    {
        return Jass::SaveTriggerConditionHandle( table, missionKey, key, whichTriggercondition );
    }

    bool SaveTriggerActionHandleBJ( triggeraction whichTriggeraction, int key, int missionKey, hashtable table )
    {
        return Jass::SaveTriggerActionHandle( table, missionKey, key, whichTriggeraction );
    }

    bool SaveTriggerEventHandleBJ( event whichEvent, int key, int missionKey, hashtable table )
    {
        return Jass::SaveTriggerEventHandle( table, missionKey, key, whichEvent );
    }

    bool SaveForceHandleBJ( force whichForce, int key, int missionKey, hashtable table )
    {
        return Jass::SaveForceHandle( table, missionKey, key, whichForce );
    }

    bool SaveGroupHandleBJ( group whichGroup, int key, int missionKey, hashtable table )
    {
        return Jass::SaveGroupHandle( table, missionKey, key, whichGroup );
    }

    bool SaveLocationHandleBJ( location whichLocation, int key, int missionKey, hashtable table )
    {
        return Jass::SaveLocationHandle( table, missionKey, key, whichLocation );
    }

    bool SaveRectHandleBJ( rect whichRect, int key, int missionKey, hashtable table )
    {
        return Jass::SaveRectHandle( table, missionKey, key, whichRect );
    }

    bool SaveBooleanExprHandleBJ( boolexpr whichBoolexpr, int key, int missionKey, hashtable table )
    {
        return Jass::SaveBooleanExprHandle( table, missionKey, key, whichBoolexpr );
    }

    bool SaveSoundHandleBJ( sound whichSound, int key, int missionKey, hashtable table )
    {
        return Jass::SaveSoundHandle( table, missionKey, key, whichSound );
    }

    bool SaveEffectHandleBJ( effect whichEffect, int key, int missionKey, hashtable table )
    {
        return Jass::SaveEffectHandle( table, missionKey, key, whichEffect );
    }

    bool SaveUnitPoolHandleBJ( unitpool whichUnitpool, int key, int missionKey, hashtable table )
    {
        return Jass::SaveUnitPoolHandle( table, missionKey, key, whichUnitpool );
    }

    bool SaveItemPoolHandleBJ( itempool whichItempool, int key, int missionKey, hashtable table )
    {
        return Jass::SaveItemPoolHandle( table, missionKey, key, whichItempool );
    }

    bool SaveQuestHandleBJ( quest whichQuest, int key, int missionKey, hashtable table )
    {
        return Jass::SaveQuestHandle( table, missionKey, key, whichQuest );
    }

    bool SaveQuestItemHandleBJ( questitem whichQuestitem, int key, int missionKey, hashtable table )
    {
        return Jass::SaveQuestItemHandle( table, missionKey, key, whichQuestitem );
    }

    bool SaveDefeatConditionHandleBJ( defeatcondition whichDefeatcondition, int key, int missionKey, hashtable table )
    {
        return Jass::SaveDefeatConditionHandle( table, missionKey, key, whichDefeatcondition );
    }

    bool SaveTimerDialogHandleBJ( timerdialog whichTimerdialog, int key, int missionKey, hashtable table )
    {
        return Jass::SaveTimerDialogHandle( table, missionKey, key, whichTimerdialog );
    }

    bool SaveLeaderboardHandleBJ( leaderboard whichLeaderboard, int key, int missionKey, hashtable table )
    {
        return Jass::SaveLeaderboardHandle( table, missionKey, key, whichLeaderboard );
    }

    bool SaveMultiboardHandleBJ( multiboard whichMultiboard, int key, int missionKey, hashtable table )
    {
        return Jass::SaveMultiboardHandle( table, missionKey, key, whichMultiboard );
    }

    bool SaveMultiboardItemHandleBJ( multiboarditem whichMultiboarditem, int key, int missionKey, hashtable table )
    {
        return Jass::SaveMultiboardItemHandle( table, missionKey, key, whichMultiboarditem );
    }

    bool SaveTrackableHandleBJ( trackable whichTrackable, int key, int missionKey, hashtable table )
    {
        return Jass::SaveTrackableHandle( table, missionKey, key, whichTrackable );
    }

    bool SaveDialogHandleBJ( dialog whichDialog, int key, int missionKey, hashtable table )
    {
        return Jass::SaveDialogHandle( table, missionKey, key, whichDialog );
    }

    bool SaveButtonHandleBJ( button whichButton, int key, int missionKey, hashtable table )
    {
        return Jass::SaveButtonHandle( table, missionKey, key, whichButton );
    }

    bool SaveTextTagHandleBJ( texttag whichTexttag, int key, int missionKey, hashtable table )
    {
        return Jass::SaveTextTagHandle( table, missionKey, key, whichTexttag );
    }

    bool SaveLightningHandleBJ( lightning whichLightning, int key, int missionKey, hashtable table )
    {
        return Jass::SaveLightningHandle( table, missionKey, key, whichLightning );
    }

    bool SaveImageHandleBJ( image whichImage, int key, int missionKey, hashtable table )
    {
        return Jass::SaveImageHandle( table, missionKey, key, whichImage );
    }

    bool SaveUbersplatHandleBJ( ubersplat whichUbersplat, int key, int missionKey, hashtable table )
    {
        return Jass::SaveUbersplatHandle( table, missionKey, key, whichUbersplat );
    }

    bool SaveRegionHandleBJ( region whichRegion, int key, int missionKey, hashtable table )
    {
        return Jass::SaveRegionHandle( table, missionKey, key, whichRegion );
    }

    bool SaveFogStateHandleBJ( fogstate whichFogState, int key, int missionKey, hashtable table )
    {
        return Jass::SaveFogStateHandle( table, missionKey, key, whichFogState );
    }

    bool SaveFogModifierHandleBJ( fogmodifier whichFogModifier, int key, int missionKey, hashtable table )
    {
        return Jass::SaveFogModifierHandle( table, missionKey, key, whichFogModifier );
    }

    bool SaveAgentHandleBJ( agent whichAgent, int key, int missionKey, hashtable table )
    {
        return Jass::SaveAgentHandle( table, missionKey, key, whichAgent );
    }

    bool SaveHashtableHandleBJ( hashtable whichHashtable, int key, int missionKey, hashtable table )
    {
        return Jass::SaveHashtableHandle( table, missionKey, key, whichHashtable );
    }

    float GetStoredRealBJ( string key, string missionKey, gamecache cache )
    {
        //Jass::SyncStoredReal( cache, missionKey, key );
        return Jass::GetStoredReal( cache, missionKey, key );
    }

    int GetStoredIntegerBJ( string key, string missionKey, gamecache cache )
    {
        //Jass::SyncStoredInteger( cache, missionKey, key );
        return Jass::GetStoredInteger( cache, missionKey, key );
    }

    bool GetStoredBooleanBJ( string key, string missionKey, gamecache cache )
    {
        //Jass::SyncStoredBoolean( cache, missionKey, key );
        return Jass::GetStoredBoolean( cache, missionKey, key );
    }

    string GetStoredStringBJ( string key, string missionKey, gamecache cache )
    {
        //SyncStoredString( cache, missionKey, key );
        string s = Jass::GetStoredString( cache, missionKey, key );
        if ( s.isEmpty( ) )
        {
            return "";
        }

        return s;
    }

    float LoadRealBJ( int key, int missionKey, hashtable table )
    {
        //SyncStoredReal( table, missionKey, key );
        return Jass::LoadReal( table, missionKey, key );
    }

    int LoadIntegerBJ( int key, int missionKey, hashtable table )
    {
        //SyncStoredInteger( table, missionKey, key );
        return Jass::LoadInteger( table, missionKey, key );
    }

    bool LoadBooleanBJ( int key, int missionKey, hashtable table )
    {
        //SyncStoredBoolean( table, missionKey, key );
        return Jass::LoadBoolean( table, missionKey, key );
    }

    string LoadStringBJ( int key, int missionKey, hashtable table )
    {
        //SyncStoredString( table, missionKey, key );
        string s = Jass::LoadStr( table, missionKey, key );
        if ( s.isEmpty( ) )
        {
            return "";
        }

        return s;
    }

    player LoadPlayerHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadPlayerHandle( table, missionKey, key );
    }

    widget LoadWidgetHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadWidgetHandle( table, missionKey, key );
    }

    destructable LoadDestructableHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadDestructableHandle( table, missionKey, key );
    }

    item LoadItemHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadItemHandle( table, missionKey, key );
    }

    unit LoadUnitHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadUnitHandle( table, missionKey, key );
    }

    ability LoadAbilityHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadAbilityHandle( table, missionKey, key );
    }

    timer LoadTimerHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadTimerHandle( table, missionKey, key );
    }

    trigger LoadTriggerHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadTriggerHandle( table, missionKey, key );
    }

    triggercondition LoadTriggerConditionHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadTriggerConditionHandle( table, missionKey, key );
    }

    triggeraction LoadTriggerActionHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadTriggerActionHandle( table, missionKey, key );
    }

    event LoadTriggerEventHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadTriggerEventHandle( table, missionKey, key );
    }

    force LoadForceHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadForceHandle( table, missionKey, key );
    }

    group LoadGroupHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadGroupHandle( table, missionKey, key );
    }

    location LoadLocationHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadLocationHandle( table, missionKey, key );
    }

    rect LoadRectHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadRectHandle( table, missionKey, key );
    }

    boolexpr LoadBooleanExprHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadBooleanExprHandle( table, missionKey, key );
    }

    sound LoadSoundHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadSoundHandle( table, missionKey, key );
    }

    effect LoadEffectHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadEffectHandle( table, missionKey, key );
    }

    unitpool LoadUnitPoolHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadUnitPoolHandle( table, missionKey, key );
    }

    itempool LoadItemPoolHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadItemPoolHandle( table, missionKey, key );
    }

    quest LoadQuestHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadQuestHandle( table, missionKey, key );
    }

    questitem LoadQuestItemHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadQuestItemHandle( table, missionKey, key );
    }

    defeatcondition LoadDefeatConditionHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadDefeatConditionHandle( table, missionKey, key );
    }

    timerdialog LoadTimerDialogHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadTimerDialogHandle( table, missionKey, key );
    }

    leaderboard LoadLeaderboardHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadLeaderboardHandle( table, missionKey, key );
    }

    multiboard LoadMultiboardHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadMultiboardHandle( table, missionKey, key );
    }

    multiboarditem LoadMultiboardItemHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadMultiboardItemHandle( table, missionKey, key );
    }

    trackable LoadTrackableHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadTrackableHandle( table, missionKey, key );
    }

    dialog LoadDialogHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadDialogHandle( table, missionKey, key );
    }

    button LoadButtonHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadButtonHandle( table, missionKey, key );
    }

    texttag LoadTextTagHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadTextTagHandle( table, missionKey, key );
    }

    lightning LoadLightningHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadLightningHandle( table, missionKey, key );
    }

    image LoadImageHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadImageHandle( table, missionKey, key );
    }

    ubersplat LoadUbersplatHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadUbersplatHandle( table, missionKey, key );
    }

    region LoadRegionHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadRegionHandle( table, missionKey, key );
    }

    fogstate LoadFogStateHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadFogStateHandle( table, missionKey, key );
    }

    fogmodifier LoadFogModifierHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadFogModifierHandle( table, missionKey, key );
    }

    hashtable LoadHashtableHandleBJ( int key, int missionKey, hashtable table )
    {
        return Jass::LoadHashtableHandle( table, missionKey, key );
    }

    unit RestoreUnitLocFacingAngleBJ( string key, string missionKey, gamecache cache, player forWhichPlayer, location loc, float facing )
    {
        //SyncStoredUnit( cache, missionKey, key );
        bj_lastLoadedUnit = Jass::RestoreUnit( cache, missionKey, key, forWhichPlayer, Jass::GetLocationX( loc ), Jass::GetLocationY( loc ), facing );
        return bj_lastLoadedUnit;
    }

    unit RestoreUnitLocFacingPointBJ( string key, string missionKey, gamecache cache, player forWhichPlayer, location loc, location lookAt )
    {
        //SyncStoredUnit( cache, missionKey, key );
        return RestoreUnitLocFacingAngleBJ( key, missionKey, cache, forWhichPlayer, loc, AngleBetweenPoints( loc, lookAt ) );
    }

    unit GetLastRestoredUnitBJ( )
    {
        return bj_lastLoadedUnit;
    }

    void FlushGameCacheBJ( gamecache cache )
    {
        Jass::FlushGameCache( cache );
    }

    void FlushStoredMissionBJ( string missionKey, gamecache cache )
    {
        Jass::FlushStoredMission( cache, missionKey );
    }

    void FlushParentHashtableBJ( hashtable table )
    {
        Jass::FlushParentHashtable( table );
    }

    void FlushChildHashtableBJ( int missionKey, hashtable table )
    {
        Jass::FlushChildHashtable( table, missionKey );
    }

    bool HaveStoredValue( string key, int valueType, string missionKey, gamecache cache )
    {
        switch( valueType )
        {
            case bj_GAMECACHE_BOOLEAN:  return Jass::HaveStoredBoolean( cache, missionKey, key );
            case bj_GAMECACHE_INTEGER:  return Jass::HaveStoredInteger( cache, missionKey, key );
            case bj_GAMECACHE_REAL:     return Jass::HaveStoredReal( cache, missionKey, key );
            case bj_GAMECACHE_UNIT:     return Jass::HaveStoredUnit( cache, missionKey, key );
            case bj_GAMECACHE_STRING:   return Jass::HaveStoredString( cache, missionKey, key );
        }

        // Unrecognized value type - ignore the request.
        return false;
    }

    bool HaveSavedValue( int key, int valueType, int missionKey, hashtable table )
    {
        switch( valueType )
        {
            case bj_HASHTABLE_BOOLEAN:  return Jass::HaveSavedBoolean( table, missionKey, key );
            case bj_HASHTABLE_INTEGER:  return Jass::HaveSavedInteger( table, missionKey, key );
            case bj_HASHTABLE_REAL:     return Jass::HaveSavedReal( table, missionKey, key );
            case bj_HASHTABLE_STRING:   return Jass::HaveSavedString( table, missionKey, key );
            case bj_HASHTABLE_HANDLE:   return Jass::HaveSavedHandle( table, missionKey, key );
        }

        // Unrecognized value type - ignore the request.
        return false;
    }

    void ShowCustomCampaignButton( bool show, int whichButton )
    {
        Jass::SetCustomCampaignButtonVisible( whichButton - 1, show );
    }

    bool IsCustomCampaignButtonVisibile( int whichButton )
    {
        return Jass::GetCustomCampaignButtonVisible( whichButton - 1 );
    }

    void LoadGameBJ( string loadFileName, bool doScoreScreen )
    {
        Jass::LoadGame( loadFileName, doScoreScreen );
    }

    void SaveAndChangeLevelBJ( string saveFileName, string newLevel, bool doScoreScreen )
    {
        Jass::SaveGame( saveFileName );
        Jass::ChangeLevel( newLevel, doScoreScreen );
    }

    void SaveAndLoadGameBJ( string saveFileName, string loadFileName, bool doScoreScreen )
    {
        Jass::SaveGame( saveFileName );
        Jass::LoadGame( loadFileName, doScoreScreen );
    }

    bool RenameSaveDirectoryBJ( string sourceDirName, string destDirName )
    {
        return Jass::RenameSaveDirectory( sourceDirName, destDirName );
    }

    bool RemoveSaveDirectoryBJ( string sourceDirName )
    {
        return Jass::RemoveSaveDirectory( sourceDirName );
    }

    bool CopySaveGameBJ( string sourceSaveName, string destSaveName )
    {
        return Jass::CopySaveGame( sourceSaveName, destSaveName );
    }

    float GetPlayerStartLocationX( player whichPlayer )
    {
        return Jass::GetStartLocationX( Jass::GetPlayerStartLocation( whichPlayer ) );
    }

    float GetPlayerStartLocationY( player whichPlayer )
    {
        return Jass::GetStartLocationY( Jass::GetPlayerStartLocation( whichPlayer ) );
    }

    location GetPlayerStartLocationLoc( player whichPlayer )
    {
        return Jass::GetStartLocationLoc( Jass::GetPlayerStartLocation( whichPlayer ) );
    }

    location GetRectCenter( rect whichRect )
    {
        return Jass::Location( Jass::GetRectCenterX( whichRect ), Jass::GetRectCenterY( whichRect ) );
    }

    bool IsPlayerSlotState( player whichPlayer, playerslotstate whichState )
    {
        return Jass::GetPlayerSlotState( whichPlayer ) == whichState;
    }

    float GetFadeFromSecondsAsReal( float seconds )
    {
        if ( seconds != .0f )
        {
            return 128.f / seconds;
        }

        return 10000.f;
    }

    int GetFadeFromSeconds( float seconds )
    {
        return Jass::R2I( GetFadeFromSecondsAsReal( seconds ) );
    }

    void AdjustPlayerStateSimpleBJ( player whichPlayer, playerstate whichPlayerState, int delta )
    {
        Jass::SetPlayerState( whichPlayer, whichPlayerState, Jass::GetPlayerState( whichPlayer, whichPlayerState ) + delta );
    }

    void AdjustPlayerStateBJ( int delta, player whichPlayer, playerstate whichPlayerState )
    {
        // If the change was positive, apply the difference to the player's
        // gathered resources property as well.
        if ( delta > 0 )
        {
            if ( whichPlayerState == Jass::PLAYER_STATE_RESOURCE_GOLD )
            {
                AdjustPlayerStateSimpleBJ( whichPlayer, Jass::PLAYER_STATE_GOLD_GATHERED, delta );
            }
            else if ( whichPlayerState == Jass::PLAYER_STATE_RESOURCE_LUMBER )
            {
                AdjustPlayerStateSimpleBJ( whichPlayer, Jass::PLAYER_STATE_LUMBER_GATHERED, delta );
            }
        }

        AdjustPlayerStateSimpleBJ( whichPlayer, whichPlayerState, delta );
    }

    void SetPlayerStateBJ( player whichPlayer, playerstate whichPlayerState, int value )
    {
        int oldValue = Jass::GetPlayerState( whichPlayer, whichPlayerState );
        AdjustPlayerStateBJ( value - oldValue, whichPlayer, whichPlayerState );
    }

    void SetPlayerFlagBJ( playerstate whichPlayerFlag, bool flag, player whichPlayer )
    {
        Jass::SetPlayerState( whichPlayer, whichPlayerFlag, IntegerTertiaryOp( flag, 1, 0 ) );
    }

    void SetPlayerTaxRateBJ( int rate, playerstate whichResource, player sourcePlayer, player otherPlayer )
    {
        Jass::SetPlayerTaxRate( sourcePlayer, otherPlayer, whichResource, rate );
    }

    int GetPlayerTaxRateBJ( playerstate whichResource, player sourcePlayer, player otherPlayer )
    {
        return Jass::GetPlayerTaxRate( sourcePlayer, otherPlayer, whichResource );
    }

    bool IsPlayerFlagSetBJ( playerstate whichPlayerFlag, player whichPlayer )
    {
        return Jass::GetPlayerState( whichPlayer, whichPlayerFlag ) == 1;
    }

    void AddResourceAmountBJ( int delta, unit whichUnit )
    {
        Jass::AddResourceAmount( whichUnit, delta );
    }

    int GetConvertedPlayerId( player whichPlayer )
    {
        return Jass::GetPlayerId( whichPlayer ) + 1;
    }

    player ConvertedPlayer( int convertedPlayerId )
    {
        return Jass::Player( convertedPlayerId - 1 );
    }

    float GetRectWidthBJ( rect r )
    {
        return Jass::GetRectMaxX( r ) - Jass::GetRectMinX( r );
    }

    float GetRectHeightBJ( rect r )
    {
        return Jass::GetRectMaxY( r ) - Jass::GetRectMinY( r );
    }

    unit BlightGoldMineForPlayerBJ( unit goldMine, player whichPlayer )
    {
        // Make sure we're replacing a Gold Mine && !some other type of unit.
        if ( Jass::GetUnitTypeId( goldMine ) != 'ngol' )
        {
            return nil;
        }

        // Save the Gold Mine's properties && remove it.
        float mineX    = Jass::GetUnitX( goldMine );
        float mineY    = Jass::GetUnitY( goldMine );
        int mineGold = Jass::GetResourceAmount( goldMine );
        Jass::RemoveUnit( goldMine );

        // Create a Haunted Gold Mine to replace the Gold Mine.
        unit newMine = Jass::CreateBlightedGoldmine( whichPlayer, mineX, mineY, bj_UNIT_FACING );
        Jass::SetResourceAmount( newMine, mineGold );
        return newMine;
    }

    unit BlightGoldMineForPlayer( unit goldMine, player whichPlayer )
    {
        bj_lastHauntedGoldMine = BlightGoldMineForPlayerBJ( goldMine, whichPlayer );
        return bj_lastHauntedGoldMine;
    }

    unit GetLastHauntedGoldMine( )
    {
        return bj_lastHauntedGoldMine;
    }

    bool IsPointBlightedBJ( location where )
    {
        return Jass::IsPointBlighted( Jass::GetLocationX( where ), Jass::GetLocationY( where ) );
    }

    void SetPlayerColorBJEnum( )
    {
        Jass::SetUnitColor( Jass::GetEnumUnit( ), bj_setPlayerTargetColor );
    }

    void SetPlayerColorBJ( player whichPlayer, playercolor color, bool changeExisting )
    {
        Jass::SetPlayerColor( whichPlayer, color );

        if ( changeExisting )
        {
            bj_setPlayerTargetColor = color;
            group g = Jass::CreateGroup( );
            Jass::GroupEnumUnitsOfPlayer( g, whichPlayer, nil );
            Jass::ForGroup( g, @SetPlayerColorBJEnum );
            Jass::DestroyGroup( g );
        }
    }

    void SetPlayerUnitAvailableBJ( int unitId, bool allowed, player whichPlayer )
    {
        if ( allowed )
        {
            Jass::SetPlayerTechMaxAllowed( whichPlayer, unitId, -1 );
        }
        else
        {
            Jass::SetPlayerTechMaxAllowed( whichPlayer, unitId, 0 );
        }
    }

    void LockGameSpeedBJ( )
    {
        Jass::SetMapFlag( Jass::MAP_LOCK_SPEED, true );
    }

    void UnlockGameSpeedBJ( )
    {
        Jass::SetMapFlag( Jass::MAP_LOCK_SPEED, false );
    }

    bool IssueTargetOrderBJ( unit whichUnit, string order, widget targetWidget )
    {
        return Jass::IssueTargetOrder( whichUnit, order, targetWidget );
    }

    bool IssuePointOrderLocBJ( unit whichUnit, string order, location whichLocation )
    {
        return Jass::IssuePointOrderLoc( whichUnit, order, whichLocation );
    }

    bool IssueTargetDestructableOrder( unit whichUnit, string order, widget targetWidget )
    {
        return Jass::IssueTargetOrder( whichUnit, order, targetWidget );
    }

    bool IssueTargetItemOrder( unit whichUnit, string order, widget targetWidget )
    {
        return Jass::IssueTargetOrder( whichUnit, order, targetWidget );
    }

    bool IssueImmediateOrderBJ( unit whichUnit, string order )
    {
        return Jass::IssueImmediateOrder( whichUnit, order );
    }

    bool GroupTargetOrderBJ( group whichGroup, string order, widget targetWidget )
    {
        return Jass::GroupTargetOrder( whichGroup, order, targetWidget );
    }

    bool GroupPointOrderLocBJ( group whichGroup, string order, location whichLocation )
    {
        return Jass::GroupPointOrderLoc( whichGroup, order, whichLocation );
    }

    bool GroupImmediateOrderBJ( group whichGroup, string order )
    {
        return Jass::GroupImmediateOrder( whichGroup, order );
    }

    bool GroupTargetDestructableOrder( group whichGroup, string order, widget targetWidget )
    {
        return Jass::GroupTargetOrder( whichGroup, order, targetWidget );
    }

    bool GroupTargetItemOrder( group whichGroup, string order, widget targetWidget )
    {
        return Jass::GroupTargetOrder( whichGroup, order, targetWidget );
    }

    destructable GetDyingDestructable( )
    {
        return Jass::GetTriggerDestructable( );
    }

    void SetUnitRallyPoint( unit whichUnit, location targPos )
    {
        IssuePointOrderLocBJ( whichUnit, "setrally", targPos );
    }

    void SetUnitRallyUnit( unit whichUnit, unit targUnit )
    {
        Jass::IssueTargetOrder( whichUnit, "setrally", targUnit );
    }

    void SetUnitRallyDestructable( unit whichUnit, destructable targDest )
    {
        Jass::IssueTargetOrder( whichUnit, "setrally", targDest );
    }

    void SaveDyingWidget( )
    {
        bj_lastDyingWidget = Jass::GetTriggerWidget( );
    }

    void SetBlightRectBJ( bool addBlight, player whichPlayer, rect r )
    {
        Jass::SetBlightRect( whichPlayer, r, addBlight );
    }

    void SetBlightRadiusLocBJ( bool addBlight, player whichPlayer, location loc, float radius )
    {
        Jass::SetBlightLoc( whichPlayer, loc, radius, addBlight );
    }

    string GetAbilityName( int abilcode )
    {
        return Jass::GetObjectName( abilcode );
    }

    void MeleeStartingVisibility( )
    {
        // Start by setting the ToD.
        Jass::SetFloatGameState( Jass::GAME_STATE_TIME_OF_DAY, bj_MELEE_STARTING_TOD );

        // FogMaskEnable( true );
        // FogEnable( true );
    }

    void MeleeStartingResources( )
    {
        int startingGold = 0;
        int startingLumber = 0;

        version v = Jass::VersionGet( );
        if ( v == Jass::VERSION_REIGN_OF_CHAOS )
        {
            startingGold = bj_MELEE_STARTING_GOLD_V0;
            startingLumber = bj_MELEE_STARTING_LUMBER_V0;
        }
        else
        {
            startingGold = bj_MELEE_STARTING_GOLD_V1;
            startingLumber = bj_MELEE_STARTING_LUMBER_V1;
        }

        // Set each player's starting resources.
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            if ( Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING )
            {
                Jass::SetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_GOLD, startingGold );
                Jass::SetPlayerState( p, Jass::PLAYER_STATE_RESOURCE_LUMBER, startingLumber );
            }
        }
    }

    void ReducePlayerTechMaxAllowed( player whichPlayer, int techId, int limit )
    {
        int oldMax = Jass::GetPlayerTechMaxAllowed( whichPlayer, techId );

        // A value of -1 is used to indicate no limit, so check for that as well.
        if ( oldMax < 0 || oldMax > limit )
        {
            Jass::SetPlayerTechMaxAllowed( whichPlayer, techId, limit );
        }
    }

    void MeleeStartingHeroLimit( )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            
            // max heroes per player
            SetPlayerMaxHeroesAllowed( bj_MELEE_HERO_LIMIT, p );

            // each player is restricted to a limit per hero type as well
            ReducePlayerTechMaxAllowed( p, 'Hamg', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Hmkg', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Hpal', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Hblm', bj_MELEE_HERO_TYPE_LIMIT );

            ReducePlayerTechMaxAllowed( p, 'Obla', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Ofar', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Otch', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Oshd', bj_MELEE_HERO_TYPE_LIMIT );

            ReducePlayerTechMaxAllowed( p, 'Edem', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Ekee', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Emoo', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Ewar', bj_MELEE_HERO_TYPE_LIMIT );

            ReducePlayerTechMaxAllowed( p, 'Udea', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Udre', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Ulic', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Ucrl', bj_MELEE_HERO_TYPE_LIMIT );

            ReducePlayerTechMaxAllowed( p, 'Npbm', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Nbrn', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Nngs', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Nplh', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Nbst', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Nalc', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Ntin', bj_MELEE_HERO_TYPE_LIMIT );
            ReducePlayerTechMaxAllowed( p, 'Nfir', bj_MELEE_HERO_TYPE_LIMIT );
        }
    }

    bool MeleeTrainedUnitIsHeroBJFilter( )
    {
        return Jass::IsUnitType( Jass::GetFilterUnit( ), Jass::UNIT_TYPE_HERO );
    }

    void MeleeGrantItemsToHero( unit whichUnit )
    {
        int owner = Jass::GetPlayerId( Jass::GetOwningPlayer( whichUnit ) );

        // If we haven't twinked N heroes for this player yet, twink away.
        if ( bj_meleeTwinkedHeroes[owner] < bj_MELEE_MAX_TWINKED_HEROES )
        {
            Jass::UnitAddItemById( whichUnit, 'stwp' );
            bj_meleeTwinkedHeroes[owner]++;
        }
    }

    void MeleeGrantItemsToTrainedHero( )
    {
        MeleeGrantItemsToHero( Jass::GetTrainedUnit( ) );
    }

    void MeleeGrantItemsToHiredHero( )
    {
        MeleeGrantItemsToHero( Jass::GetSoldUnit( ) );
    }

    void MeleeGrantHeroItems( )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            // Initialize the twinked hero counts.
            bj_meleeTwinkedHeroes[ i ] = 0;

            // Register for an event whenever a hero is trained, so that we can give
            // him/her their starting items.
            trigger trig = Jass::CreateTrigger( );
            Jass::TriggerRegisterPlayerUnitEvent( trig, Jass::Player( i ), Jass::EVENT_PLAYER_UNIT_TRAIN_FINISH, filterMeleeTrainedUnitIsHeroBJ );
            Jass::TriggerAddAction( trig, @MeleeGrantItemsToTrainedHero );
        }

        // Register for an event whenever a neutral hero is hired, so that we
        // can give him/her their starting items.
        trigger trig = Jass::CreateTrigger( );
        Jass::TriggerRegisterPlayerUnitEvent( trig, Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE ), Jass::EVENT_PLAYER_UNIT_SELL, filterMeleeTrainedUnitIsHeroBJ );
        Jass::TriggerAddAction( trig, @MeleeGrantItemsToHiredHero );

        // Flag that we are giving starting items to heroes, so that the melee
        // starting units code can create them as necessary.
        bj_meleeGrantHeroItems = true;
    }

    void MeleeClearExcessUnit( )
    {
        unit theUnit = Jass::GetEnumUnit( );
        int owner = Jass::GetPlayerId( Jass::GetOwningPlayer( theUnit ) );

        if ( owner == Jass::PLAYER_NEUTRAL_AGGRESSIVE )
        {
            // Remove any Neutral Hostile units from the area.
            Jass::RemoveUnit( Jass::GetEnumUnit( ) );
        }
        else if ( owner == Jass::PLAYER_NEUTRAL_PASSIVE )
        {
            // Remove non-structure Neutral Passive units from the area.
            if ( !Jass::IsUnitType( theUnit, Jass::UNIT_TYPE_STRUCTURE ) )
            {
                Jass::RemoveUnit( Jass::GetEnumUnit( ) );
            }
        }
    }

    void MeleeClearNearbyUnits( float x, float y, float range )
    {
        group nearbyUnits = Jass::CreateGroup( );
        Jass::GroupEnumUnitsInRange( nearbyUnits, x, y, range, nil );
        Jass::ForGroup( nearbyUnits, @MeleeClearExcessUnit );
        Jass::DestroyGroup( nearbyUnits );
    }

    void MeleeClearExcessUnits( )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            // If the player slot is being used, clear any nearby creeps.
            if ( Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING )
            {
                MeleeClearNearbyUnits( Jass::GetStartLocationX( Jass::GetPlayerStartLocation( p ) ), Jass::GetStartLocationY( Jass::GetPlayerStartLocation( p ) ), bj_MELEE_CLEAR_UNITS_RADIUS );
            }
        }
    }

    void MeleeEnumFindNearestMine( )
    {
        unit enumUnit = Jass::GetEnumUnit( );

        if ( Jass::GetUnitTypeId( enumUnit ) == 'ngol' )
        {
            location unitLoc = Jass::GetUnitLoc( enumUnit );
            float dist = DistanceBetweenPoints( unitLoc, bj_meleeNearestMineToLoc );
            Jass::RemoveLocation( unitLoc );

            // If this is our first mine, || the closest thusfar, use it instead.
            if ( bj_meleeNearestMineDist < .0f || dist < bj_meleeNearestMineDist )
            {
                bj_meleeNearestMine = enumUnit;
                bj_meleeNearestMineDist = dist;
            }
        }
    }

    unit MeleeFindNearestMine( location src, float range )
    {
        bj_meleeNearestMine = nil;
        bj_meleeNearestMineDist = -1;
        bj_meleeNearestMineToLoc = src;

        group nearbyMines = Jass::CreateGroup( );
        Jass::GroupEnumUnitsInRangeOfLoc( nearbyMines, src, range, nil );
        Jass::ForGroup( nearbyMines, @MeleeEnumFindNearestMine );
        Jass::DestroyGroup( nearbyMines );

        return bj_meleeNearestMine;
    }

    unit MeleeRandomHeroLoc( player p, int id1, int id2, int id3, int id4, location loc )
    {
        int roll = 0;

        // The selection of heroes is dependant on the game version.
        version v = Jass::VersionGet( );

        if ( v == Jass::VERSION_REIGN_OF_CHAOS )
        {
            roll = Jass::GetRandomInt( 1, 3 );
        }
        else
        {
            roll = Jass::GetRandomInt( 1, 4 );
        }

        int pick = 0;

        // Translate the roll into a unitid.
        switch( roll )
        {
            case 1: pick = id1; break;
            case 2: pick = id2; break;
            case 3: pick = id3; break;
            case 4: pick = id4; break;
            default: pick = id1; break; // Unrecognized id index - pick the first hero in the list.
        }

        // Create the hero.
        unit hero = Jass::CreateUnitAtLoc( p, pick, loc, bj_UNIT_FACING );
        if ( bj_meleeGrantHeroItems )
        {
            MeleeGrantItemsToHero( hero );
        }
        return hero;
    }

    location MeleeGetProjectedLoc( location src, location targ, float distance, float deltaAngle )
    {
        float srcX = Jass::GetLocationX( src );
        float srcY = Jass::GetLocationY( src );
        float direction = Jass::Atan2( Jass::GetLocationY( targ ) - srcY, Jass::GetLocationX( targ ) - srcX ) + deltaAngle;
        return Jass::Location( srcX + distance * Jass::Cos( direction ), srcY + distance * Jass::Sin( direction ) );
    }

    float MeleeGetNearestValueWithin( float val, float minVal, float maxVal )
    {
        if ( val < minVal )
        {
            return minVal;
        }
        else if ( val > maxVal )
        {
            return maxVal;
        }

        return val;
    }

    location MeleeGetLocWithinRect( location src, rect r )
    {
        float withinX = MeleeGetNearestValueWithin( Jass::GetLocationX( src ), Jass::GetRectMinX( r ), Jass::GetRectMaxX( r ) );
        float withinY = MeleeGetNearestValueWithin( Jass::GetLocationY( src ), Jass::GetRectMinY( r ), Jass::GetRectMaxY( r ) );
        return Jass::Location( withinX, withinY );
    }

    void MeleeStartingUnitsHuman( player whichPlayer, location startLoc, bool doHeroes, bool doCamera, bool doPreload )
    {
        bool  useRandomHero = Jass::IsMapFlagSet( Jass::MAP_RANDOM_HERO );
        float unitSpacing   = 64.f;

        location nearMineLoc;
        location heroLoc;
        float peonX = .0f;
        float peonY = .0f;
        unit townHall;

        if ( doPreload )
        {
            Jass::Preloader( "scripts\\HumanMelee.pld" );
        }

        unit nearestMine = MeleeFindNearestMine( startLoc, bj_MELEE_MINE_SEARCH_RADIUS );
        if ( nearestMine != nil )
        {
            // Spawn Town Hall at the start location.
            townHall = Jass::CreateUnitAtLoc( whichPlayer, 'htow', startLoc, bj_UNIT_FACING );
            
            // Spawn Peasants near the mine.
            nearMineLoc = MeleeGetProjectedLoc( Jass::GetUnitLoc( nearestMine ), startLoc, 320, 0 );
            peonX = Jass::GetLocationX( nearMineLoc );
            peonY = Jass::GetLocationY( nearMineLoc );
            Jass::CreateUnit( whichPlayer, 'hpea', peonX + 0.f * unitSpacing, peonY + 1.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'hpea', peonX + 1.f * unitSpacing, peonY + 0.15f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'hpea', peonX - 1.f * unitSpacing, peonY + 0.15f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'hpea', peonX + 0.6f * unitSpacing, peonY - 1.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'hpea', peonX - 0.6f * unitSpacing, peonY - 1.f * unitSpacing, bj_UNIT_FACING );

            // Set random hero spawn point to be off to the side of the start location.
            heroLoc = MeleeGetProjectedLoc( Jass::GetUnitLoc( nearestMine ), startLoc, 384, 45 );
        }
        else
        {
            // Spawn Town Hall at the start location.
            townHall = Jass::CreateUnitAtLoc( whichPlayer, 'htow', startLoc, bj_UNIT_FACING );
            
            // Spawn Peasants directly south of the town hall.
            peonX = Jass::GetLocationX( startLoc );
            peonY = Jass::GetLocationY( startLoc ) - 224.f;
            Jass::CreateUnit( whichPlayer, 'hpea', peonX + 2.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'hpea', peonX + 1.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'hpea', peonX + 0.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'hpea', peonX - 1.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'hpea', peonX - 2.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );

            // Set random hero spawn point to be just south of the start location.
            heroLoc = Jass::Location( peonX, peonY - 2.00 * unitSpacing );
        }

        if ( townHall != nil )
        {
            UnitAddAbilityBJ( 'Amic', townHall );
            UnitMakeAbilityPermanentBJ( true, 'Amic', townHall );
        }

        if ( doHeroes )
        {
            // If the "Random Hero" option is set, start the player with a random hero.
            // Otherwise, give them a "free hero" token.
            if ( useRandomHero )
            {
                MeleeRandomHeroLoc( whichPlayer, 'Hamg', 'Hmkg', 'Hpal', 'Hblm', heroLoc );
            }
            else
            {
                Jass::SetPlayerState( whichPlayer, Jass::PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS );
            }
        }

        if ( doCamera )
        {
            // Center the camera on the initial Peasants.
            SetCameraPositionForPlayer( whichPlayer, peonX, peonY );
            SetCameraQuickPositionForPlayer( whichPlayer, peonX, peonY );
        }
    }

    void MeleeStartingUnitsOrc( player whichPlayer, location startLoc, bool doHeroes, bool doCamera, bool doPreload )
    {
        bool useRandomHero = Jass::IsMapFlagSet( Jass::MAP_RANDOM_HERO );
        float unitSpacing   = 64.f;

        location nearMineLoc;
        location heroLoc;
        float peonX = .0f;
        float peonY = .0f;

        if ( doPreload )
        {
            Jass::Preloader( "scripts\\OrcMelee.pld" );
        }

        unit nearestMine = MeleeFindNearestMine( startLoc, bj_MELEE_MINE_SEARCH_RADIUS );
        if ( nearestMine != nil )
        {
            // Spawn Great Hall at the start location.
            Jass::CreateUnitAtLoc( whichPlayer, 'ogre', startLoc, bj_UNIT_FACING );
            
            // Spawn Peons near the mine.
            nearMineLoc = MeleeGetProjectedLoc( Jass::GetUnitLoc( nearestMine ), startLoc, 320, 0 );
            peonX = Jass::GetLocationX( nearMineLoc );
            peonY = Jass::GetLocationY( nearMineLoc );
            Jass::CreateUnit( whichPlayer, 'opeo', peonX + 0.f * unitSpacing, peonY + 1.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'opeo', peonX + 1.f * unitSpacing, peonY + 0.15f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'opeo', peonX - 1.f * unitSpacing, peonY + 0.15f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'opeo', peonX + 0.6f * unitSpacing, peonY - 1.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'opeo', peonX - 0.6f * unitSpacing, peonY - 1.f * unitSpacing, bj_UNIT_FACING );

            // Set random hero spawn point to be off to the side of the start location.
            heroLoc = MeleeGetProjectedLoc( Jass::GetUnitLoc( nearestMine ), startLoc, 384, 45 );
        }
        else
        {
            // Spawn Great Hall at the start location.
            Jass::CreateUnitAtLoc( whichPlayer, 'ogre', startLoc, bj_UNIT_FACING );
            
            // Spawn Peons directly south of the town hall.
            peonX = Jass::GetLocationX( startLoc );
            peonY = Jass::GetLocationY( startLoc ) - 224.f;
            Jass::CreateUnit( whichPlayer, 'opeo', peonX + 2.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'opeo', peonX + 1.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'opeo', peonX + 0.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'opeo', peonX - 1.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'opeo', peonX - 2.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );

            // Set random hero spawn point to be just south of the start location.
            heroLoc = Jass::Location( peonX, peonY - 2.f * unitSpacing );
        }

        if ( doHeroes )
        {
            // If the "Random Hero" option is set, start the player with a random hero.
            // Otherwise, give them a "free hero" token.
            if ( useRandomHero )
            {
                MeleeRandomHeroLoc( whichPlayer, 'Obla', 'Ofar', 'Otch', 'Oshd', heroLoc );
            }
            else
            {
                Jass::SetPlayerState( whichPlayer, Jass::PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS );
            }
        }

        if ( doCamera )
        {
            // Center the camera on the initial Peons.
            SetCameraPositionForPlayer( whichPlayer, peonX, peonY );
            SetCameraQuickPositionForPlayer( whichPlayer, peonX, peonY );
        }
    }

    void MeleeStartingUnitsUndead( player whichPlayer, location startLoc, bool doHeroes, bool doCamera, bool doPreload )
    {
        bool useRandomHero = Jass::IsMapFlagSet( Jass::MAP_RANDOM_HERO );
        float unitSpacing   = 64.f;
        location heroLoc;
        float peonX;
        float peonY;
        float ghoulX;
        float ghoulY;

        if ( doPreload )
        {
            Jass::Preloader( "scripts\\UndeadMelee.pld" );
        }

        unit nearestMine = MeleeFindNearestMine( startLoc, bj_MELEE_MINE_SEARCH_RADIUS );

        if ( nearestMine != nil )
        {
            // Spawn Necropolis at the start location.
            Jass::CreateUnitAtLoc( whichPlayer, 'unpl', startLoc, bj_UNIT_FACING );
            
            // Replace the nearest gold mine with a blighted version.
            nearestMine = BlightGoldMineForPlayerBJ( nearestMine, whichPlayer );

            // Spawn Ghoul near the Necropolis.
            location nearTownLoc = MeleeGetProjectedLoc( startLoc, Jass::GetUnitLoc( nearestMine ), 288, 0 );
            ghoulX = Jass::GetLocationX( nearTownLoc );
            ghoulY = Jass::GetLocationY( nearTownLoc );
            bj_ghoul[ Jass::GetPlayerId( whichPlayer ) ] = Jass::CreateUnit( whichPlayer, 'ugho', ghoulX + 0.f * unitSpacing, ghoulY + 0.f * unitSpacing, bj_UNIT_FACING );

            // Spawn Acolytes near the mine.
            location nearMineLoc = MeleeGetProjectedLoc( Jass::GetUnitLoc( nearestMine ), startLoc, 320, 0 );
            peonX = Jass::GetLocationX( nearMineLoc );
            peonY = Jass::GetLocationY( nearMineLoc );
            Jass::CreateUnit( whichPlayer, 'uaco', peonX + 0.f * unitSpacing, peonY + 0.5f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'uaco', peonX + 0.65f * unitSpacing, peonY - 0.5f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'uaco', peonX - 0.65f * unitSpacing, peonY - 0.5f * unitSpacing, bj_UNIT_FACING );

            // Create a patch of blight around the gold mine.
            Jass::SetBlightLoc( whichPlayer,nearMineLoc, 768, true );

            // Set random hero spawn point to be off to the side of the start location.
            heroLoc = MeleeGetProjectedLoc( Jass::GetUnitLoc( nearestMine ), startLoc, 384, 45 );
        }
        else
        {
            // Spawn Necropolis at the start location.
            Jass::CreateUnitAtLoc( whichPlayer, 'unpl', startLoc, bj_UNIT_FACING );
            
            // Spawn Acolytes && Ghoul directly south of the Necropolis.
            peonX = Jass::GetLocationX( startLoc );
            peonY = Jass::GetLocationY( startLoc ) - 224.f;
            Jass::CreateUnit( whichPlayer, 'uaco', peonX - 1.5f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'uaco', peonX - 0.5f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'uaco', peonX + 0.5f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'ugho', peonX + 1.5f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );

            // Create a patch of blight around the start location.
            Jass::SetBlightLoc( whichPlayer,startLoc, 768, true );

            // Set random hero spawn point to be just south of the start location.
            heroLoc = Jass::Location( peonX, peonY - 2.f * unitSpacing );
        }

        if ( doHeroes )
        {
            // If the "Random Hero" option is set, start the player with a random hero.
            // Otherwise, give them a "free hero" token.
            if ( useRandomHero ) 
            {
                MeleeRandomHeroLoc( whichPlayer, 'Udea', 'Udre', 'Ulic', 'Ucrl', heroLoc );
            }
            else
            {
                Jass::SetPlayerState( whichPlayer, Jass::PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS );
            }
        }

        if ( doCamera )
        {
            // Center the camera on the initial Acolytes.
            SetCameraPositionForPlayer( whichPlayer, peonX, peonY );
            SetCameraQuickPositionForPlayer( whichPlayer, peonX, peonY );
        }
    }

    void MeleeStartingUnitsNightElf( player whichPlayer, location startLoc, bool doHeroes, bool doCamera, bool doPreload )
    {
        bool useRandomHero = Jass::IsMapFlagSet( Jass::MAP_RANDOM_HERO );
        float unitSpacing   = 64.f;
        float minTreeDist   = 3.5f * bj_CELLWIDTH;
        float minWispDist   = 1.75f * bj_CELLWIDTH;
        location nearMineLoc;
        location wispLoc;
        location heroLoc;
        float peonX = .0f;
        float peonY = .0f;
        unit tree;

        if ( doPreload )
        {
            Jass::Preloader( "scripts\\NightElfMelee.pld" );
        }

        unit nearestMine = MeleeFindNearestMine( startLoc, bj_MELEE_MINE_SEARCH_RADIUS );
        if ( nearestMine != nil )
        {
            // Spawn Tree of Life near the mine && have it entangle the mine.
            // Project the Tree's coordinates from the gold mine, && { snap
            // the X && Y values to within minTreeDist of the Gold Mine.
            nearMineLoc = MeleeGetProjectedLoc( Jass::GetUnitLoc( nearestMine ), startLoc, 650, 0 );
            nearMineLoc = MeleeGetLocWithinRect( nearMineLoc, GetRectFromCircleBJ( Jass::GetUnitLoc( nearestMine ), minTreeDist ) );
            tree = Jass::CreateUnitAtLoc( whichPlayer, 'etol', nearMineLoc, bj_UNIT_FACING );
            Jass::IssueTargetOrder( tree, "entangleinstant", nearestMine );

            // Spawn Wisps at the start location.
            wispLoc = MeleeGetProjectedLoc( Jass::GetUnitLoc( nearestMine ), startLoc, 320, 0 );
            wispLoc = MeleeGetLocWithinRect( wispLoc, GetRectFromCircleBJ( Jass::GetUnitLoc( nearestMine ), minWispDist ) );
            peonX = Jass::GetLocationX( wispLoc );
            peonY = Jass::GetLocationY( wispLoc );
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX + 0.f * unitSpacing, peonY + 1.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX + 1.f * unitSpacing, peonY + 0.15f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX - 1.f * unitSpacing, peonY + 0.15f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX + 0.58f * unitSpacing, peonY - 1.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX - 0.58f * unitSpacing, peonY - 1.f * unitSpacing, bj_UNIT_FACING );

            // Set random hero spawn point to be off to the side of the start location.
            heroLoc = MeleeGetProjectedLoc( Jass::GetUnitLoc( nearestMine ), startLoc, 384, 45 );
        }
        else
        {
            // Spawn Tree of Life at the start location.
            Jass::CreateUnitAtLoc( whichPlayer, 'etol', startLoc, bj_UNIT_FACING );

            // Spawn Wisps directly south of the town hall.
            peonX = Jass::GetLocationX( startLoc );
            peonY = Jass::GetLocationY( startLoc ) - 224.f;
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX - 2.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX - 1.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX + 0.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX + 1.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );
            Jass::CreateUnit( whichPlayer, 'ewsp', peonX + 2.f * unitSpacing, peonY + 0.f * unitSpacing, bj_UNIT_FACING );

            // Set random hero spawn point to be just south of the start location.
            heroLoc = Jass::Location( peonX, peonY - 2.f * unitSpacing );
        }

        if ( doHeroes )
        {
            // If the "Random Hero" option is set, start the player with a random hero.
            // Otherwise, give them a "free hero" token.
            if ( useRandomHero )
            {
                MeleeRandomHeroLoc( whichPlayer, 'Edem', 'Ekee', 'Emoo', 'Ewar', heroLoc );
            }
            else
            {
                Jass::SetPlayerState( whichPlayer, Jass::PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS );
            }
        }

        if ( doCamera )
        {
            // Center the camera on the initial Wisps.
            SetCameraPositionForPlayer( whichPlayer, peonX, peonY );
            SetCameraQuickPositionForPlayer( whichPlayer, peonX, peonY );
        }
    }

    void MeleeStartingUnitsUnknownRace( player whichPlayer, location startLoc, bool doHeroes, bool doCamera, bool doPreload )
    {
        if ( doPreload )
        {
            
        }

        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            Jass::CreateUnit( whichPlayer, 'nshe', Jass::GetLocationX( startLoc ) + Jass::GetRandomReal( -256.f, 256.f ), Jass::GetLocationY( startLoc ) + Jass::GetRandomReal( -256.f, 256.f ), Jass::GetRandomReal( .0f, 360.f ) );
        }

        if ( doHeroes )
        {
            // Give them a "free hero" token, out of pity.
            Jass::SetPlayerState( whichPlayer, Jass::PLAYER_STATE_RESOURCE_HERO_TOKENS, bj_MELEE_STARTING_HERO_TOKENS );
        }

        if ( doCamera )
        {
            // Center the camera on the initial sheep.
            SetCameraPositionLocForPlayer( whichPlayer, startLoc );
            SetCameraQuickPositionLocForPlayer( whichPlayer, startLoc );
        }
    }

    void MeleeStartingUnits( )
    {
        Jass::Preloader( "scripts\\SharedMelee.pld" );
        
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            if ( Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING )
            {
                location indexStartLoc = Jass::GetStartLocationLoc( Jass::GetPlayerStartLocation( p ) );
                race indexRace = Jass::GetPlayerRace( p );

                // Create initial race-specific starting units
                if ( indexRace == Jass::RACE_HUMAN )
                {
                    MeleeStartingUnitsHuman( p, indexStartLoc, true, true, true );
                }
                else if ( indexRace == Jass::RACE_ORC )
                {
                    MeleeStartingUnitsOrc( p, indexStartLoc, true, true, true );
                }
                else if ( indexRace == Jass::RACE_UNDEAD )
                {
                    MeleeStartingUnitsUndead( p, indexStartLoc, true, true, true );
                }
                else if ( indexRace == Jass::RACE_NIGHTELF )
                {
                    MeleeStartingUnitsNightElf( p, indexStartLoc, true, true, true );
                }
                else
                {
                    MeleeStartingUnitsUnknownRace( p, indexStartLoc, true, true, true );
                }
            }
        }
    }

    void MeleeStartingUnitsForPlayer( race whichRace, player whichPlayer, location loc, bool doHeroes )
    {
        // Create initial race-specific starting units
        if ( whichRace == Jass::RACE_HUMAN )
        {
            MeleeStartingUnitsHuman( whichPlayer, loc, doHeroes, false, false );
        }
        else if ( whichRace == Jass::RACE_ORC )
        {
            MeleeStartingUnitsOrc( whichPlayer, loc, doHeroes, false, false );
        }
        else if ( whichRace == Jass::RACE_UNDEAD )
        {
            MeleeStartingUnitsUndead( whichPlayer, loc, doHeroes, false, false );
        }
        else if ( whichRace == Jass::RACE_NIGHTELF )
        {
            MeleeStartingUnitsNightElf( whichPlayer, loc, doHeroes, false, false );
        }
        else
        {
            // Unrecognized race - ignore the request.
        }
    }

    void PickMeleeAI( player num, string s1, string s2, string s3 )
    {
        // easy difficulty never uses any custom AI scripts
        // that are designed to be a bit more challenging
        //
        if ( Jass::GetAIDifficulty( num ) == Jass::AI_DIFFICULTY_NEWBIE )
        {
            Jass::StartMeleeAI( num,s1 );
            return;
        }

        int pick = 0;

        if ( s2.isEmpty( ) )
        {
            pick = 1;
        }
        else if ( s3.isEmpty( ) )
        {
            pick = Jass::GetRandomInt( 1, 2 );
        }
        else
        {
            pick = Jass::GetRandomInt( 1, 3 );
        }

        switch( pick )
        {
            case 1: Jass::StartMeleeAI( num, s1 ); break;
            case 2: Jass::StartMeleeAI( num, s2 ); break;
            default: Jass::StartMeleeAI( num, s3 ); break;
        }
    }

    void MeleeStartingAI( )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            if ( Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING )
            {
                race indexRace = Jass::GetPlayerRace( p );
                if ( Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_COMPUTER )
                {
                    // Run a race-specific melee AI script.
                    if ( indexRace == Jass::RACE_HUMAN )
                    {
                        PickMeleeAI( p, "human.ai", "", "" );
                    }
                    else if ( indexRace == Jass::RACE_ORC )
                    {
                        PickMeleeAI( p, "orc.ai", "", "" );
                    }
                    else if ( indexRace == Jass::RACE_UNDEAD )
                    {
                        PickMeleeAI( p, "undead.ai", "", "" );
                        Jass::RecycleGuardPosition( bj_ghoul[i] );
                    }
                    else if ( indexRace == Jass::RACE_NIGHTELF )
                    {
                        PickMeleeAI( p, "elf.ai", "", "" );
                    }
                    else
                    {
                        // Unrecognized race.
                    }
                    ShareEverythingWithTeamAI( p );
                }
            }
        }
    }

    void LockGuardPosition( unit targ )
    {
        Jass::SetUnitCreepGuard( targ, true );
    }

    bool MeleePlayerIsOpponent( int playerIndex, int opponentIndex )
    {
        player thePlayer = Jass::Player( playerIndex );
        player theOpponent = Jass::Player( opponentIndex );

        // The player himself is !an opponent.
        if ( playerIndex == opponentIndex )
        {
            return false;
        }

        // Unused player slots are !opponents.
        if ( Jass::GetPlayerSlotState( theOpponent ) != Jass::PLAYER_SLOT_STATE_PLAYING )
        {
            return false;
        }

        // Players who are already defeated are !opponents.
        if ( bj_meleeDefeated[opponentIndex] )
        {
            return false;
        }

        // Allied players with allied victory are !opponents.
        if ( Jass::GetPlayerAlliance( thePlayer, theOpponent, Jass::ALLIANCE_PASSIVE ) )
        {
            if ( Jass::GetPlayerAlliance( theOpponent, thePlayer, Jass::ALLIANCE_PASSIVE ) )
            {
                if ( Jass::GetPlayerState( thePlayer, Jass::PLAYER_STATE_ALLIED_VICTORY ) == 1 )
                {
                    if ( Jass::GetPlayerState( theOpponent, Jass::PLAYER_STATE_ALLIED_VICTORY ) == 1 )
                    {
                        return false;
                    }
                }
            }
        }

        return true;
    }

    int MeleeGetAllyStructureCount( player whichPlayer )
    {
        int buildingCount = 0;

        // Count the number of buildings controlled by all !-yet-defeated co-allies.
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            // uncomment to cause defeat even if you have control of ally structures, but yours have been nixed
            //if ( PlayersAreCoAllied( whichPlayer, indexPlayer ) && !bj_meleeDefeated[playerIndex] ) {
            
            if ( PlayersAreCoAllied( whichPlayer, p ) )
            {
                buildingCount += Jass::GetPlayerStructureCount( p, true );
            }
        }

        return buildingCount;
    }

    int MeleeGetAllyCount( player whichPlayer )
    {
        int playerCount = 0;

        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            
            // Count the number of !-yet-defeated co-allies.
            if ( PlayersAreCoAllied( whichPlayer, p ) && !bj_meleeDefeated[i] && whichPlayer != p )
            {
                playerCount++;
            }
        }

        return playerCount;
    }

    int MeleeGetAllyKeyStructureCount( player whichPlayer )
    {
        int keyStructs = 0;

        // Count the number of buildings controlled by all !-yet-defeated co-allies.
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            
            // Count the number of !-yet-defeated co-allies.
            if ( PlayersAreCoAllied( whichPlayer, p ) )
            {
                keyStructs += Jass::GetPlayerTypedUnitCount( p, "townhall", true, true );
                keyStructs += Jass::GetPlayerTypedUnitCount( p, "greathall", true, true );
                keyStructs += Jass::GetPlayerTypedUnitCount( p, "treeoflife", true, true );
                keyStructs += Jass::GetPlayerTypedUnitCount( p, "necropolis", true, true );
            }
        }

        return keyStructs;
    }

    void MeleeDoDrawEnum( )
    {
        player thePlayer = Jass::GetEnumPlayer( );

        Jass::CachePlayerHeroData( thePlayer );
        RemovePlayerPreserveUnitsBJ( thePlayer, Jass::PLAYER_GAME_RESULT_TIE, false );
    }

    void MeleeDoVictoryEnum( )
    {
        player thePlayer = Jass::GetEnumPlayer( );
        int playerIndex = Jass::GetPlayerId( thePlayer );

        if ( !bj_meleeVictoried[playerIndex] )
        {
            bj_meleeVictoried[playerIndex] = true;
            Jass::CachePlayerHeroData( thePlayer );
            RemovePlayerPreserveUnitsBJ( thePlayer, Jass::PLAYER_GAME_RESULT_VICTORY, false );
        }
    }

    void MeleeDoDefeat( player whichPlayer )
    {
        bj_meleeDefeated[ Jass::GetPlayerId( whichPlayer ) ] = true;
        RemovePlayerPreserveUnitsBJ( whichPlayer, Jass::PLAYER_GAME_RESULT_DEFEAT, false );
    }

    void MeleeDoDefeatEnum( )
    {
        player thePlayer = Jass::GetEnumPlayer( );

        // needs to happen before ownership change
        Jass::CachePlayerHeroData( thePlayer );
        MakeUnitsPassiveForTeam( thePlayer );
        MeleeDoDefeat( thePlayer );
    }

    void MeleeDoLeave( player whichPlayer )
    {
        if ( Jass::GetIntegerGameState( Jass::GAME_STATE_DISCONNECTED ) != 0 )
        {
            GameOverDialogBJ( whichPlayer, true );
        }
        else
        {
            bj_meleeDefeated[Jass::GetPlayerId( whichPlayer )] = true;
            RemovePlayerPreserveUnitsBJ( whichPlayer, Jass::PLAYER_GAME_RESULT_DEFEAT, true );
        }
    }

    void MeleeRemoveObservers( )
    {
        // Give all observers the game over dialog
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            
            // Count the number of !-yet-defeated co-allies.
            if ( Jass::IsPlayerObserver( p ) )
            {
                RemovePlayerPreserveUnitsBJ( p, Jass::PLAYER_GAME_RESULT_NEUTRAL, false );
            }
        }
    }

    force MeleeCheckForVictors( )
    {
        force opponentlessPlayers = Jass::CreateForce( );
        bool gameOver = false;

        // Check to see if any players have opponents remaining.
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            
            if ( !bj_meleeDefeated[ i ] )
            {
                // Determine whether || !this player has any remaining opponents.
                for ( int j = 0; j < bj_MAX_PLAYERS; j++ )
                {
                    // If anyone has an opponent, noone can be victorious yet.
                    if ( MeleePlayerIsOpponent( i, j ) )
                    {
                        Jass::DestroyForce( opponentlessPlayers );
                        return Jass::CreateForce( );
                    }
                }
                
                // Keep track of each opponentless player so that we can give
                // them a victory later.
                Jass::ForceAddPlayer( opponentlessPlayers, p );
                gameOver = true;
            }
        }

        return opponentlessPlayers;
    }

    void MeleeCheckForLosersAndVictors( )
    {
        // If the game is already over, do nothing
        if ( bj_meleeGameOver )
        {
            return;
        }

        // If the game was disconnected { it is over, in this case we
        // don't want to report results for anyone as they will most likely
        // conflict with the actual game results
        if ( Jass::GetIntegerGameState( Jass::GAME_STATE_DISCONNECTED ) != 0 )
        {
            bj_meleeGameOver = true;
            return;
        }

        force defeatedPlayers = Jass::CreateForce();
        // Check each player to see if he || she has been defeated yet.
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            
            if ( !bj_meleeDefeated[ i ] && !bj_meleeVictoried[ i ] )
            {
                //DisplayTimedTextToPlayer( GetLocalPlayer( ), .0f, .0f, 60.f, "Player" + I2S( playerIndex ) + " has " + I2S( MeleeGetAllyStructureCount( p ) ) + " ally buildings." );
                if ( MeleeGetAllyStructureCount( p ) <= 0 )
                {

                    // Keep track of each defeated player so that we can give
                    // them a defeat later.
                    Jass::ForceAddPlayer( defeatedPlayers, p );

                    // Set their defeated flag now so MeleeCheckForVictors
                    // can detect victors.
                    bj_meleeDefeated[ i ] = true;
                }
            }
        }

        // Now that the defeated flags are set, check if there are any victors
        force victoriousPlayers = MeleeCheckForVictors( );

        // Defeat all defeated players
        Jass::ForForce( defeatedPlayers, @MeleeDoDefeatEnum );
        Jass::DestroyForce( defeatedPlayers );

        // Give victory to all victorious players
        Jass::ForForce( victoriousPlayers, @MeleeDoVictoryEnum );
        Jass::DestroyForce( victoriousPlayers );

        // If the game is over we should remove all observers
        if ( bj_meleeGameOver )
        {
            MeleeRemoveObservers( );
        }
    }

    string MeleeGetCrippledWarningMessage( player whichPlayer )
    {
        race r = Jass::GetPlayerRace( whichPlayer );

        if ( r == Jass::RACE_HUMAN )
        {
            return Jass::GetLocalizedString( "CRIPPLE_WARNING_HUMAN" );
        }
        else if ( r == Jass::RACE_ORC )
        {
            return Jass::GetLocalizedString( "CRIPPLE_WARNING_ORC" );
        }
        else if ( r == Jass::RACE_NIGHTELF )
        {
            return Jass::GetLocalizedString( "CRIPPLE_WARNING_NIGHTELF" );
        }
        else if ( r == Jass::RACE_UNDEAD )
        {
            return Jass::GetLocalizedString( "CRIPPLE_WARNING_UNDEAD" );
        }

        // Unrecognized Race
        return "";
    }

    string MeleeGetCrippledTimerMessage( player whichPlayer )
    {
        race r = Jass::GetPlayerRace( whichPlayer );

        if ( r == Jass::RACE_HUMAN )
        {
            return Jass::GetLocalizedString( "CRIPPLE_TIMER_HUMAN" );
        }
        else if ( r == Jass::RACE_ORC )
        {
            return Jass::GetLocalizedString( "CRIPPLE_TIMER_ORC" );
        }
        else if ( r == Jass::RACE_NIGHTELF )
        {
            return Jass::GetLocalizedString( "CRIPPLE_TIMER_NIGHTELF" );
        }
        else if ( r == Jass::RACE_UNDEAD )
        {
            return Jass::GetLocalizedString( "CRIPPLE_TIMER_UNDEAD" );
        }

        // Unrecognized Race
        return "";
    }

    string MeleeGetCrippledRevealedMessage( player whichPlayer )
    {
        return Jass::GetLocalizedString( "CRIPPLE_REVEALING_PREFIX" ) + Jass::GetPlayerName( whichPlayer ) + Jass::GetLocalizedString( "CRIPPLE_REVEALING_POSTFIX" );
    }

    void MeleeExposePlayer( player whichPlayer, bool expose )
    {
        force toExposeTo = Jass::CreateForce( );

        Jass::CripplePlayer( whichPlayer, toExposeTo, false );

        bj_playerIsExposed[ Jass::GetPlayerId( whichPlayer ) ] = expose;
        
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            if ( !PlayersAreCoAllied( whichPlayer, p ) )
            {
                Jass::ForceAddPlayer( toExposeTo, p );
            }
        }

        Jass::CripplePlayer( whichPlayer, toExposeTo, expose );
        Jass::DestroyForce( toExposeTo );
    }

    void MeleeExposeAllPlayers( )
    {
        force toExposeTo = Jass::CreateForce( );

        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            Jass::ForceClear( toExposeTo );
            Jass::CripplePlayer( p, toExposeTo, false );

            for ( int j = 0; j < bj_MAX_PLAYERS; j++ )
            {
                player pOther = Jass::Player( j );

                if ( i != j )
                {
                    if ( !PlayersAreCoAllied( p, pOther ) )
                    {
                        Jass::ForceAddPlayer( toExposeTo, pOther );
                    }
                }
            }

            Jass::CripplePlayer( p, toExposeTo, true );
        }

        Jass::DestroyForce( toExposeTo );
    }

    void MeleeCrippledPlayerTimeout( )
    {
        timer expiredTimer = Jass::GetExpiredTimer( );
        int playerIndex = 0;

        // Determine which player's timer expired.
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            if ( bj_crippledTimer[ i ] == expiredTimer )
            {
                playerIndex = i;
                break;
            }
        }
        
        if ( playerIndex == bj_MAX_PLAYERS )
        {
            return;
        }
        player exposedPlayer = Jass::Player( playerIndex );

        if ( Jass::GetLocalPlayer( ) == exposedPlayer )
        {
            // Use only code ( no net traffic ) within this block to avoid desyncs.

            // Hide the timer window for this player.
            Jass::TimerDialogDisplay( bj_crippledTimerWindows[playerIndex], false );
        }

        // Display a text message to all players, explaining the exposure.
        Jass::DisplayTimedTextToPlayer( Jass::GetLocalPlayer( ), .0f, .0f, bj_MELEE_CRIPPLE_MSG_DURATION, MeleeGetCrippledRevealedMessage( exposedPlayer ) );

        // Expose the player.
        MeleeExposePlayer( exposedPlayer, true );
    }

    bool MeleePlayerIsCrippled( player whichPlayer )
    {
        int allyStructures    = MeleeGetAllyStructureCount( whichPlayer );
        int allyKeyStructures = MeleeGetAllyKeyStructureCount( whichPlayer );

        // Dead teams are !considered to be crippled.
        return ( allyStructures > 0 ) && ( allyKeyStructures <= 0 );
    }

    void MeleeCheckForCrippledPlayers( )
    {
        // The "finish soon" exposure of all players overrides any "crippled" exposure
        if ( bj_finishSoonAllExposed )
        {
            return;
        }

        // Check each player to see if he or she has been crippled or uncrippled.
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            bool isNowCrippled = MeleePlayerIsCrippled( p );

            if ( !bj_playerIsCrippled[ i ] && isNowCrippled )
            {

                // Player became crippled; start their cripple timer.
                bj_playerIsCrippled[ i ] = true;
                Jass::TimerStart( bj_crippledTimer[ i ], bj_MELEE_CRIPPLE_TIMEOUT, false, @MeleeCrippledPlayerTimeout );

                if ( Jass::GetLocalPlayer( ) == p )
                {
                    // Use only code ( no net traffic ) within this block to avoid desyncs.

                    // Show the timer window.
                    Jass::TimerDialogDisplay( bj_crippledTimerWindows[ i ], true );

                    // Display a warning message.
                    Jass::DisplayTimedTextToPlayer( p, 0, 0, bj_MELEE_CRIPPLE_MSG_DURATION, MeleeGetCrippledWarningMessage( p ) );
                }
            }
            else if ( bj_playerIsCrippled[ i ] && !isNowCrippled )
            {
                // Player became uncrippled; stop their cripple timer.
                bj_playerIsCrippled[ i ] = false;
                Jass::PauseTimer( bj_crippledTimer[ i ] );

                if ( Jass::GetLocalPlayer( ) == p )
                {
                    // Use only code ( no net traffic ) within this block to avoid desyncs.

                    // Hide the timer window for this player.
                    Jass::TimerDialogDisplay( bj_crippledTimerWindows[ i ], false );

                    // Display a confirmation message if the player's team is still alive.
                    if ( MeleeGetAllyStructureCount( p ) > 0 )
                    {
                        if ( bj_playerIsExposed[ i ] )
                        {
                            Jass::DisplayTimedTextToPlayer( p, .0f, .0f, bj_MELEE_CRIPPLE_MSG_DURATION, Jass::GetLocalizedString( "CRIPPLE_UNREVEALED" ) );
                        }
                        else
                        {
                            Jass::DisplayTimedTextToPlayer( p, .0f, .0f, bj_MELEE_CRIPPLE_MSG_DURATION, Jass::GetLocalizedString( "CRIPPLE_UNCRIPPLED" ) );
                        }
                    }
                }

                // If the player granted shared vision, deny that vision now.
                MeleeExposePlayer( p, false );
            }
        }
    }

    void MeleeCheckLostUnit( unit lostUnit )
    {
        player lostUnitOwner = Jass::GetOwningPlayer( lostUnit );

        // We only need to check for mortality if this was the last building.
        if ( Jass::GetPlayerStructureCount( lostUnitOwner, true ) <= 0 )
        {
            MeleeCheckForLosersAndVictors( );
        }

        // Check if the lost unit has crippled or uncrippled the player.
        // ( A team with 0 units is dead, and thus considered uncrippled. )
        MeleeCheckForCrippledPlayers( );
    }

    void MeleeCheckAddedUnit( unit addedUnit )
    {
        player addedUnitOwner = Jass::GetOwningPlayer( addedUnit );

        // If the player was crippled, this unit may have uncrippled him/her.
        if ( bj_playerIsCrippled[ Jass::GetPlayerId( addedUnitOwner ) ] )
        {
            MeleeCheckForCrippledPlayers( );
        }
    }

    void MeleeTriggerActionConstructCancel( )
    {
        MeleeCheckLostUnit( Jass::GetCancelledStructure( ) );
    }

    void MeleeTriggerActionUnitDeath( )
    {
        if ( Jass::IsUnitType( Jass::GetDyingUnit( ), Jass::UNIT_TYPE_STRUCTURE ) )
        {
            MeleeCheckLostUnit( Jass::GetDyingUnit( ) );
        }
    }

    void MeleeTriggerActionUnitConstructionStart( )
    {
        MeleeCheckAddedUnit( Jass::GetConstructingStructure( ) );
    }

    void MeleeTriggerActionPlayerDefeated( )
    {
        player thePlayer = Jass::GetTriggerPlayer( );
        Jass::CachePlayerHeroData( thePlayer );

        if ( MeleeGetAllyCount( thePlayer ) > 0 )
        {
            // If at least one ally is still alive && kicking, share units with
            // them && proceed with death.
            ShareEverythingWithTeam( thePlayer );
            if ( !bj_meleeDefeated[ Jass::GetPlayerId( thePlayer ) ] )
            {
                MeleeDoDefeat( thePlayer );
            }
        }
        else
        {
            // If no living allies remain, swap all units && buildings over to
            // neutral_passive && proceed with death.
            MakeUnitsPassiveForTeam( thePlayer );
            if ( !bj_meleeDefeated[ Jass::GetPlayerId( thePlayer ) ] )
            {
                MeleeDoDefeat( thePlayer );
            }
        }
        MeleeCheckForLosersAndVictors( );
    }

    void MeleeTriggerActionPlayerLeft( )
    {
        player thePlayer = Jass::GetTriggerPlayer( );

        // Just show game over for observers when they leave
        if ( Jass::IsPlayerObserver( thePlayer ) )
        {
            RemovePlayerPreserveUnitsBJ( thePlayer, Jass::PLAYER_GAME_RESULT_NEUTRAL, false );
            return;
        }

        Jass::CachePlayerHeroData( thePlayer );

        // This is the same as defeat except the player generates the message 
        // "player left the game" as opposed to "player was defeated".

        if ( MeleeGetAllyCount( thePlayer ) > 0 )
        {
            // If at least one ally is still alive && kicking, share units with
            // them && proceed with death.
            ShareEverythingWithTeam( thePlayer );
            MeleeDoLeave( thePlayer );
        }
        else
        {
            // If no living allies remain, swap all units && buildings over to
            // neutral_passive && proceed with death.
            MakeUnitsPassiveForTeam( thePlayer );
            MeleeDoLeave( thePlayer );
        }
        MeleeCheckForLosersAndVictors( );
    }

    void MeleeTriggerActionAllianceChange( )
    {
        MeleeCheckForLosersAndVictors( );
        MeleeCheckForCrippledPlayers( );
    }

    void MeleeTriggerTournamentFinishSoon( )
    {
        // Note: We may get this trigger multiple times
        float timeRemaining = Jass::GetTournamentFinishSoonTimeRemaining( );

        if ( !bj_finishSoonAllExposed )
        {
            bj_finishSoonAllExposed = true;

            // Reall crippled players && their timers, && hide the crippled timer dialog
            for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
            {
                if ( bj_playerIsCrippled[ i ] )
                {
                    // Uncripple the player
                    bj_playerIsCrippled[ i ] = false;
                    Jass::PauseTimer( bj_crippledTimer[ i ] );

                    if ( Jass::GetLocalPlayer( ) == Jass::Player( i ) )
                    {
                        // Use only code ( no net traffic ) within this block to avoid desyncs.

                        // Hide the timer window.
                        Jass::TimerDialogDisplay( bj_crippledTimerWindows[ i ], false );
                    }

                }
                
            }
            // Expose all players
            MeleeExposeAllPlayers( );
        }

        // Show the "finish soon" timer dialog && the float time remaining
        Jass::TimerDialogDisplay( bj_finishSoonTimerDialog, true );
        Jass::TimerDialogSetRealTimeRemaining( bj_finishSoonTimerDialog, timeRemaining );
    }

    bool MeleeWasUserPlayer( player whichPlayer )
    {
        if ( Jass::GetPlayerController( whichPlayer ) != Jass::MAP_CONTROL_USER )
        {
            return false;
        }

        playerslotstate slotState = Jass::GetPlayerSlotState( whichPlayer );

        return slotState == Jass::PLAYER_SLOT_STATE_PLAYING || slotState == Jass::PLAYER_SLOT_STATE_LEFT;
    }

    void MeleeTournamentFinishNowRuleA( int multiplier )
    {
        array<int> playerScore( bj_MAX_PLAYERS );
        array<int> teamScore( bj_MAX_PLAYERS );
        array<force> teamForce( bj_MAX_PLAYERS );

        // Compute individual player scores
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            if ( MeleeWasUserPlayer( p ) )
            {
                playerScore[ i ] = Jass::GetTournamentScore( p );
                if ( playerScore[ i ] <= 0 )
                {
                    playerScore[ i ] = 1;
                }
            }
            else
            {
                playerScore[ i ] = 0;
            }
        }

        // Compute team scores && team forces
        int teamCount = 0;
        
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            if ( playerScore[i] != 0 )
            {
                player p = Jass::Player( i );

                teamScore[teamCount] = 0;
                teamForce[teamCount] = Jass::CreateForce( );

                for ( int j = i; j < bj_MAX_PLAYERS; j++ )
                {
                    if ( playerScore[ j ] != 0 )
                    {
                        player pOther = Jass::Player( j );

                        if ( PlayersAreCoAllied( p, pOther ) )
                        {
                            teamScore[teamCount] += playerScore[ j ];
                            Jass::ForceAddPlayer( teamForce[teamCount], pOther );
                            playerScore[ j ] = 0;
                        }
                    }
                }
                
                teamCount++;
            }
        }

        // The game is now over
        bj_meleeGameOver = true;

        // There should always be at least one team, but continue to work if !
        if ( teamCount != 0 )
        {
            // Find best team score
            int bestTeam = -1;
            int bestScore = -1;
            
            for ( int i = 0; i < teamCount; i++ )
            {
                if ( teamScore[i] > bestScore )
                {
                    bestTeam = i;
                    bestScore = teamScore[i];
                }
            }

            // Check whether the best team's score is 'multiplier' times better than
            // every other team. In the case of multiplier == 1 && exactly equal team
            // scores, the first team ( which was randomly chosen by the server ) will win.
            bool draw = false;
            
            for ( int i = 0; i < teamCount; i++ )
            {
                if ( i != bestTeam )
                {
                    if ( bestScore < ( multiplier * teamScore[i] ) )
                    {
                        draw = true;
                    }
                }
            }

            if ( draw )
            {
                // Give draw to all players on all teams
                for ( int i = 0; i < teamCount; i++ )
                {
                    Jass::ForForce( teamForce[i], @MeleeDoDrawEnum );
                }
            }
            else
            {
                // Give defeat to all players on teams other than the best team
                for ( int i = 0; i < teamCount; i++ )
                {
                    Jass::ForForce( teamForce[i], @MeleeDoDefeatEnum );
                }
                // Give victory to all players on the best team
                Jass::ForForce( teamForce[bestTeam], @MeleeDoVictoryEnum );
            }
        }

    }

    void MeleeTriggerTournamentFinishNow( )
    {
        int rule = Jass::GetTournamentFinishNowRule( );

        // If the game is already over, do nothing
        if ( bj_meleeGameOver )
        {
            return;
        }

        if ( rule == 1 )
        {
            // Finals games
            MeleeTournamentFinishNowRuleA( 1 );
        }
        else
        {
            // Preliminary games
            MeleeTournamentFinishNowRuleA( 3 );
        }

        // Since the game is over we should remove all observers
        MeleeRemoveObservers( );

    }

    void MeleeInitVictoryDefeat( )
    {
        // Create a timer window for the "finish soon" timeout period, it has no timer
        // because it is driven by float time ( outside of the game state to avoid desyncs )
        bj_finishSoonTimerDialog = Jass::CreateTimerDialog( nil );

        trigger trig;

        // Set a trigger to fire when we receive a "finish soon" game event
        trig = Jass::CreateTrigger( );
        Jass::TriggerRegisterGameEvent( trig, Jass::EVENT_GAME_TOURNAMENT_FINISH_SOON );
        Jass::TriggerAddAction( trig, @MeleeTriggerTournamentFinishSoon );

        // Set a trigger to fire when we receive a "finish now" game event
        trig = Jass::CreateTrigger( );
        Jass::TriggerRegisterGameEvent( trig, Jass::EVENT_GAME_TOURNAMENT_FINISH_NOW );
        Jass::TriggerAddAction( trig, @MeleeTriggerTournamentFinishNow );

        // Set up each player's mortality code.
        
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            // Make sure this player slot is playing.
            if ( Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING )
            {
                bj_meleeDefeated[i] = false;
                bj_meleeVictoried[i] = false;

                // Create a timer && timer window in case the player is crippled.
                bj_playerIsCrippled[i] = false;
                bj_playerIsExposed[i] = false;
                bj_crippledTimer[i] = Jass::CreateTimer( );
                bj_crippledTimerWindows[i] = Jass::CreateTimerDialog( bj_crippledTimer[i] );
                Jass::TimerDialogSetTitle( bj_crippledTimerWindows[i], MeleeGetCrippledTimerMessage( p ) );

                // Set a trigger to fire whenever a building is cancelled for this player.
                trig = Jass::CreateTrigger( );
                Jass::TriggerRegisterPlayerUnitEvent( trig, p, Jass::EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL, nil );
                Jass::TriggerAddAction( trig, @MeleeTriggerActionConstructCancel );

                // Set a trigger to fire whenever a unit dies for this player.
                trig = Jass::CreateTrigger( );
                Jass::TriggerRegisterPlayerUnitEvent( trig, p, Jass::EVENT_PLAYER_UNIT_DEATH, nil );
                Jass::TriggerAddAction( trig, @MeleeTriggerActionUnitDeath );

                // Set a trigger to fire whenever a unit begins construction for this player
                trig = Jass::CreateTrigger( );
                Jass::TriggerRegisterPlayerUnitEvent( trig, p, Jass::EVENT_PLAYER_UNIT_CONSTRUCT_START, nil );
                Jass::TriggerAddAction( trig, @MeleeTriggerActionUnitConstructionStart );

                // Set a trigger to fire whenever this player defeats-out
                trig = Jass::CreateTrigger( );
                Jass::TriggerRegisterPlayerEvent( trig, p, Jass::EVENT_PLAYER_DEFEAT );
                Jass::TriggerAddAction( trig, @MeleeTriggerActionPlayerDefeated );

                // Set a trigger to fire whenever this player leaves
                trig = Jass::CreateTrigger( );
                Jass::TriggerRegisterPlayerEvent( trig, p, Jass::EVENT_PLAYER_LEAVE );
                Jass::TriggerAddAction( trig, @MeleeTriggerActionPlayerLeft );

                // Set a trigger to fire whenever this player changes his/her alliances.
                trig = Jass::CreateTrigger( );
                Jass::TriggerRegisterPlayerAllianceChange( trig, p, Jass::ALLIANCE_PASSIVE );
                Jass::TriggerRegisterPlayerStateEvent( trig, p, Jass::PLAYER_STATE_ALLIED_VICTORY, Jass::EQUAL, 1 );
                Jass::TriggerAddAction( trig, @MeleeTriggerActionAllianceChange );
            }
            else
            {
                bj_meleeDefeated[i] = true;
                bj_meleeVictoried[i] = false;

                // Handle leave events for observers
                if ( Jass::IsPlayerObserver( p ) )
                {
                    // Set a trigger to fire whenever this player leaves
                    trig = Jass::CreateTrigger( );
                    Jass::TriggerRegisterPlayerEvent( trig, p, Jass::EVENT_PLAYER_LEAVE );
                    Jass::TriggerAddAction( trig, @MeleeTriggerActionPlayerLeft );
                }
            }
        }

        // Test for victory / defeat at startup, in case the user has already won / lost.
        // Allow for a short time to pass first, so that the map can finish loading.
        Jass::TimerStart( Jass::CreateTimer( ), 2.f, false, @MeleeTriggerActionAllianceChange );
    }

    void CheckInitPlayerSlotAvailability( )
    {
        if ( !bj_slotControlReady )
        {
            for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
            {
                bj_slotControlUsed[i] = false;
                bj_slotControl[i] = Jass::MAP_CONTROL_USER;
            }
        }
    }

    void SetPlayerSlotAvailable( player whichPlayer, mapcontrol control )
    {
        int playerIndex = Jass::GetPlayerId( whichPlayer );

        CheckInitPlayerSlotAvailability( );
        bj_slotControlUsed[playerIndex] = true;
        bj_slotControl[playerIndex] = control;
    }

    void TeamInitPlayerSlots( int teamCount )
    {
        Jass::SetTeams( teamCount );
        CheckInitPlayerSlotAvailability( );
        int team = 0;
        
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            if ( bj_slotControlUsed[i] )
            {
                Jass::SetPlayerTeam( Jass::Player( i ), team );
                team++;
                if ( team >= teamCount )
                {
                    team = 0;
                }
            }
        }
    }

    void MeleeInitPlayerSlots( )
    {
        TeamInitPlayerSlots( bj_MAX_PLAYERS );
    }

    void FFAInitPlayerSlots( )
    {
        TeamInitPlayerSlots( bj_MAX_PLAYERS );
    }

    void OneOnOneInitPlayerSlots( )
    {
        // Limit the game to 2 players.
        Jass::SetTeams( 2 );
        Jass::SetPlayers( 2 );
        TeamInitPlayerSlots( 2 );
    }

    void InitGenericPlayerSlots( )
    {
        gametype gType = Jass::GetGameTypeSelected( );

        if ( gType == Jass::GAME_TYPE_MELEE )
        {
            MeleeInitPlayerSlots( );
        }
        else if ( gType == Jass::GAME_TYPE_FFA )
        {
            FFAInitPlayerSlots( );
        }
        else if ( gType == Jass::GAME_TYPE_USE_MAP_SETTINGS )
        {
            // Do nothing; the map-specific script handles this.
        }
        else if ( gType == Jass::GAME_TYPE_ONE_ON_ONE )
        {
            OneOnOneInitPlayerSlots( );
        }
        else if ( gType == Jass::GAME_TYPE_TWO_TEAM_PLAY )
        {
            TeamInitPlayerSlots( 2 );
        }
        else if ( gType == Jass::GAME_TYPE_THREE_TEAM_PLAY )
        {
            TeamInitPlayerSlots( 3 );
        }
        else if ( gType == Jass::GAME_TYPE_FOUR_TEAM_PLAY )
        {
            TeamInitPlayerSlots( 4 );
        }
        else
        {
            // Unrecognized Game Type
        }
    }

    void SetDNCSoundsDawn( )
    {
        if ( bj_useDawnDuskSounds )
        {
            Jass::StartSound( bj_dawnSound );
        }
    }

    void SetDNCSoundsDusk( )
    {
        if ( bj_useDawnDuskSounds )
        {
            Jass::StartSound( bj_duskSound );
        }
    }

    void SetDNCSoundsDay( )
    {
        float ToD = GetTimeOfDay( );

        if ( ( ToD >= bj_TOD_DAWN && ToD < bj_TOD_DUSK ) && !bj_dncIsDaytime )
        {
            bj_dncIsDaytime = true;

            // change ambient sounds
            Jass::StopSound( bj_nightAmbientSound, false, true );
            Jass::StartSound( bj_dayAmbientSound );
        }
    }

    void SetDNCSoundsNight( )
    {
        float ToD = GetTimeOfDay( );

        if ( ( ToD < bj_TOD_DAWN || ToD >= bj_TOD_DUSK ) && bj_dncIsDaytime )
        {
            bj_dncIsDaytime = false;

            // change ambient sounds
            Jass::StopSound( bj_dayAmbientSound, false, true );
            Jass::StartSound( bj_nightAmbientSound );
        }
    }

    void InitDNCSounds( )
    {
        // Create sounds to be played at dawn and dusk.
        bj_dawnSound = Jass::CreateSoundFromLabel( "RoosterSound", false, false, false, 10000, 10000 );
        bj_duskSound = Jass::CreateSoundFromLabel( "WolfSound", false, false, false, 10000, 10000 );

        // Set up triggers to respond to dawn and dusk.
        bj_dncSoundsDawn = Jass::CreateTrigger( );
        Jass::TriggerRegisterGameStateEvent( bj_dncSoundsDawn, Jass::GAME_STATE_TIME_OF_DAY, Jass::EQUAL, bj_TOD_DAWN );
        Jass::TriggerAddAction( bj_dncSoundsDawn, @SetDNCSoundsDawn );

        bj_dncSoundsDusk = Jass::CreateTrigger( );
        Jass::TriggerRegisterGameStateEvent( bj_dncSoundsDusk, Jass::GAME_STATE_TIME_OF_DAY, Jass::EQUAL, bj_TOD_DUSK );
        Jass::TriggerAddAction( bj_dncSoundsDusk, @SetDNCSoundsDusk );

        // Set up triggers to respond to changes from day to night or vice-versa.
        bj_dncSoundsDay = Jass::CreateTrigger( );
        Jass::TriggerRegisterGameStateEvent( bj_dncSoundsDay,   Jass::GAME_STATE_TIME_OF_DAY, Jass::GREATER_THAN_OR_EQUAL, bj_TOD_DAWN );
        Jass::TriggerRegisterGameStateEvent( bj_dncSoundsDay,   Jass::GAME_STATE_TIME_OF_DAY, Jass::LESS_THAN,             bj_TOD_DUSK );
        Jass::TriggerAddAction( bj_dncSoundsDay, @SetDNCSoundsDay );

        bj_dncSoundsNight = Jass::CreateTrigger( );
        Jass::TriggerRegisterGameStateEvent( bj_dncSoundsNight, Jass::GAME_STATE_TIME_OF_DAY, Jass::LESS_THAN,             bj_TOD_DAWN );
        Jass::TriggerRegisterGameStateEvent( bj_dncSoundsNight, Jass::GAME_STATE_TIME_OF_DAY, Jass::GREATER_THAN_OR_EQUAL, bj_TOD_DUSK );
        Jass::TriggerAddAction( bj_dncSoundsNight, @SetDNCSoundsNight );
    }

    void InitBlizzardGlobals( )
    {
        // Init filter @vars
        filterIssueHauntOrderAtLocBJ = Jass::Filter( @IssueHauntOrderAtLocBJFilter );
        filterEnumDestructablesInCircleBJ = Jass::Filter( @EnumDestructablesInCircleBJFilter );
        filterGetUnitsInRectOfPlayer = Jass::Filter( @GetUnitsInRectOfPlayerFilter );
        filterGetUnitsOfTypeIdAll = Jass::Filter( @GetUnitsOfTypeIdAllFilter );
        filterGetUnitsOfPlayerAndTypeId = Jass::Filter( @GetUnitsOfPlayerAndTypeIdFilter );
        filterMeleeTrainedUnitIsHeroBJ = Jass::Filter( @MeleeTrainedUnitIsHeroBJFilter );
        filterLivingPlayerUnitsOfTypeId = Jass::Filter( @LivingPlayerUnitsOfTypeIdFilter );

        // Init force presets
        for ( int i = 0; i < bj_MAX_PLAYER_SLOTS; i++ )
        {
            bj_FORCE_PLAYER[i] = Jass::CreateForce( );
            Jass::ForceAddPlayer( bj_FORCE_PLAYER[i], Jass::Player( i ) );
        }

        bj_FORCE_ALL_PLAYERS = Jass::CreateForce( );
        Jass::ForceEnumPlayers( bj_FORCE_ALL_PLAYERS, nil );

        // Init Cinematic Mode history
        bj_cineModePriorSpeed = Jass::GetGameSpeed( );
        bj_cineModePriorFogSetting = Jass::IsFogEnabled( );
        bj_cineModePriorMaskSetting = Jass::IsFogMaskEnabled( );

        // Init Trigger Queue
        for ( int i = 0; i < bj_MAX_QUEUED_TRIGGERS; i++ )
        {
            bj_queuedExecTriggers[i] = nil;
            bj_queuedExecUseConds[i] = false;
        }

        // Init singleplayer check
        bj_isSinglePlayer = false;
        int userControlledPlayers = 0;
        
        for ( int i = 0; i <= bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );

            if ( Jass::GetPlayerController( p ) == Jass::MAP_CONTROL_USER && Jass::GetPlayerSlotState( p ) == Jass::PLAYER_SLOT_STATE_PLAYING )
            {
                userControlledPlayers++;
            }
        }

        bj_isSinglePlayer = userControlledPlayers == 1;

        // Init sounds
        //bj_pingMinimapSound = Jass::CreateSoundFromLabel( "AutoCastButtonClick", false, false, false, 10000, 10000 );
        bj_rescueSound = Jass::CreateSoundFromLabel( "Rescue", false, false, false, 10000, 10000 );
        bj_questDiscoveredSound = Jass::CreateSoundFromLabel( "QuestNew", false, false, false, 10000, 10000 );
        bj_questUpdatedSound = Jass::CreateSoundFromLabel( "QuestUpdate", false, false, false, 10000, 10000 );
        bj_questCompletedSound = Jass::CreateSoundFromLabel( "QuestCompleted", false, false, false, 10000, 10000 );
        bj_questFailedSound = Jass::CreateSoundFromLabel( "QuestFailed", false, false, false, 10000, 10000 );
        bj_questHintSound = Jass::CreateSoundFromLabel( "Hint", false, false, false, 10000, 10000 );
        bj_questSecretSound = Jass::CreateSoundFromLabel( "SecretFound", false, false, false, 10000, 10000 );
        bj_questItemAcquiredSound = Jass::CreateSoundFromLabel( "ItemReward", false, false, false, 10000, 10000 );
        bj_questWarningSound = Jass::CreateSoundFromLabel( "Warning", false, false, false, 10000, 10000 );
        bj_victoryDialogSound = Jass::CreateSoundFromLabel( "QuestCompleted", false, false, false, 10000, 10000 );
        bj_defeatDialogSound = Jass::CreateSoundFromLabel( "QuestFailed", false, false, false, 10000, 10000 );

        // Init corpse creation triggers.
        DelayedSuspendDecayCreate( );

        // Init version-specific data
        version v = Jass::VersionGet( );
        if ( v == Jass::VERSION_REIGN_OF_CHAOS )
        {
            bj_MELEE_MAX_TWINKED_HEROES = bj_MELEE_MAX_TWINKED_HEROES_V0;
        }
        else
        {
            bj_MELEE_MAX_TWINKED_HEROES = bj_MELEE_MAX_TWINKED_HEROES_V1;
        }
    }

    void InitQueuedTriggers( )
    {
        bj_queuedExecTimeout = Jass::CreateTrigger( );
        Jass::TriggerRegisterTimerExpireEvent( bj_queuedExecTimeout, bj_queuedExecTimeoutTimer );
        Jass::TriggerAddAction( bj_queuedExecTimeout, @QueuedTriggerDoneBJ );
    }

    void InitMapRects( )
    {
        bj_mapInitialPlayableArea = Jass::Rect
        (
            Jass::GetCameraBoundMinX( ) - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_LEFT ),
            Jass::GetCameraBoundMinY( ) - Jass::GetCameraMargin( Jass::CAMERA_MARGIN_BOTTOM ),
            Jass::GetCameraBoundMaxX( ) + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_RIGHT ),
            Jass::GetCameraBoundMaxY( ) + Jass::GetCameraMargin( Jass::CAMERA_MARGIN_TOP )
        );
        bj_mapInitialCameraBounds = GetCurrentCameraBoundsMapRectBJ( );
    }

    void InitSummonableCaps( )
    {
        for ( int i = 0; i < bj_MAX_PLAYERS; i++ )
        {
            player p = Jass::Player( i );
            // upgraded units
            // Note: Only do this if the corresponding upgrade is !yet researched
            // Barrage - Siege Engines
            if ( !Jass::GetPlayerTechResearched( p, 'Rhrt', true ) )
            {
                Jass::SetPlayerTechMaxAllowed( p, 'hrtt', 0 );
            }

            // Berserker Upgrade - Troll Berserkers
            if ( !Jass::GetPlayerTechResearched( p, 'Robk', true ) )
            {
                Jass::SetPlayerTechMaxAllowed( p, 'otbk', 0 );
            }

            // max skeletons per player
            Jass::SetPlayerTechMaxAllowed( p, 'uske', bj_MAX_SKELETONS );
        }
    }

    void UpdateStockAvailability( item whichItem )
    {
        itemtype iType  = Jass::GetItemType( whichItem );
        int  iLevel = Jass::GetItemLevel( whichItem );

        // Update allowed type/level combinations.
        if ( iType == Jass::ITEM_TYPE_PERMANENT )
        {
            bj_stockAllowedPermanent[iLevel] = true;
        }
        else if ( iType == Jass::ITEM_TYPE_CHARGED )
        {
            bj_stockAllowedCharged[iLevel] = true;
        }
        else if ( iType == Jass::ITEM_TYPE_ARTIFACT )
        {
            bj_stockAllowedArtifact[iLevel] = true;
        }
        else
        {
            // Not interested in this item type - ignore the item.
        }
    }

    void UpdateEachStockBuildingEnum( )
    {
        int iteration = 0;
        int pickedItemId = 0;

        do
        {
            pickedItemId = Jass::ChooseRandomItemEx( bj_stockPickedItemType, bj_stockPickedItemLevel );
            iteration++;
            if ( iteration > bj_STOCK_MAX_ITERATIONS )
            {
                return;
            }
        }
        while( Jass::IsItemIdSellable( pickedItemId ) );

        Jass::AddItemToStock( Jass::GetEnumUnit( ), pickedItemId, 1, 1 );
    }

    void UpdateEachStockBuilding( itemtype iType, int iLevel )
    {
        bj_stockPickedItemType = iType;
        bj_stockPickedItemLevel = iLevel;

        group g = Jass::CreateGroup( );
        Jass::GroupEnumUnitsOfType( g, "marketplace", nil );
        Jass::ForGroup( g, @UpdateEachStockBuildingEnum );
        Jass::DestroyGroup( g );
    }

    void PerformStockUpdates( )
    {
        itemtype pickedItemType;
        int pickedItemLevel = 0;
        int allowedCombinations = 0;

        // Give each type/level combination a chance of being picked.
        
        for ( int iLevel = 1; iLevel <= bj_MAX_ITEM_LEVEL; iLevel++ )
        {
            if ( bj_stockAllowedPermanent[iLevel] )
            {
                allowedCombinations++;
                if ( Jass::GetRandomInt( 1, allowedCombinations ) == 1 )
                {
                    pickedItemType = Jass::ITEM_TYPE_PERMANENT;
                    pickedItemLevel = iLevel;
                }
            }

            if ( bj_stockAllowedCharged[iLevel] )
            {
                allowedCombinations++;
                if ( Jass::GetRandomInt( 1, allowedCombinations ) == 1 )
                {
                    pickedItemType = Jass::ITEM_TYPE_CHARGED;
                    pickedItemLevel = iLevel;
                }
            }

            if ( bj_stockAllowedArtifact[iLevel] )
            {
                allowedCombinations++;
                if ( Jass::GetRandomInt( 1, allowedCombinations ) == 1 )
                {
                    pickedItemType = Jass::ITEM_TYPE_ARTIFACT;
                    pickedItemLevel = iLevel;
                }
            }
        }

        // Make sure we found a valid item type to add.
        if ( allowedCombinations == 0 )
        {
            return;
        }

        UpdateEachStockBuilding( pickedItemType, pickedItemLevel );
    }

    void StartStockUpdates( )
    {
        PerformStockUpdates( );
        Jass::TimerStart( bj_stockUpdateTimer, bj_STOCK_RESTOCK_INTERVAL, true, @PerformStockUpdates );
    }

    void RemovePurchasedItem( )
    {
        Jass::RemoveItemFromStock( Jass::GetSellingUnit( ), Jass::GetItemTypeId( Jass::GetSoldItem( ) ) );
    }

    void InitNeutralBuildings( )
    {
        // Chart of allowed stock items.
        for ( int iLevel = 0; iLevel <= bj_MAX_ITEM_LEVEL; iLevel++ )
        {
            bj_stockAllowedPermanent[iLevel] = false;
            bj_stockAllowedCharged[iLevel] = false;
            bj_stockAllowedArtifact[iLevel] = false;
        }

        // Limit stock inventory slots.
        Jass::SetAllItemTypeSlots( bj_MAX_STOCK_ITEM_SLOTS );
        Jass::SetAllUnitTypeSlots( bj_MAX_STOCK_UNIT_SLOTS );

        // Arrange the first update.
        bj_stockUpdateTimer = Jass::CreateTimer( );
        Jass::TimerStart( bj_stockUpdateTimer, bj_STOCK_RESTOCK_INITIAL_DELAY, false, @StartStockUpdates );

        // Set up a trigger to fire whenever an item is sold.
        bj_stockItemPurchased = Jass::CreateTrigger( );
        Jass::TriggerRegisterPlayerUnitEvent( bj_stockItemPurchased, Jass::Player( Jass::PLAYER_NEUTRAL_PASSIVE ), Jass::EVENT_PLAYER_UNIT_SELL_ITEM, nil );
        Jass::TriggerAddAction( bj_stockItemPurchased, @RemovePurchasedItem );
    }

    void MarkGameStarted( )
    {
        bj_gameStarted = true;
        Jass::DestroyTimer( bj_gameStartedTimer );
    }

    void DetectGameStarted( )
    {
        bj_gameStartedTimer = Jass::CreateTimer( );
        Jass::TimerStart( bj_gameStartedTimer, bj_GAME_STARTED_THRESHOLD, false, @MarkGameStarted );
    }

    void InitBlizzard( )
    {
        // Set up the Neutral Victim player slot, to torture the abandoned units
        // of defeated players.  Since some triggers expect this player slot to
        // exist, this is performed for all maps.
        ConfigureNeutralVictim( );

        InitBlizzardGlobals( );
        InitQueuedTriggers( );
        InitRescuableBehaviorBJ( );
        InitDNCSounds( );
        InitMapRects( );
        InitSummonableCaps( );
        InitNeutralBuildings( );
        DetectGameStarted( );
    }

    void RandomDistReset( )
    {
        bj_randDistCount = 0;
    }

    void RandomDistAddItem( int inID, int inChance )
    {
        uint size = bj_randDistCount;

        if ( size > bj_randDistID.length( ) )
        {
            bj_randDistID.resize( size );
        }

        if ( size > bj_randDistChance.length( ) )
        {
            bj_randDistChance.resize( size );
        }

        bj_randDistID[size] = inID;
        bj_randDistChance[size] = inChance;
        bj_randDistCount++;
    }

    int RandomDistChoose( )
    {
        // No items?
        if ( bj_randDistCount == 0 )
        {
            return -1;
        }

        int sum = 0;
        // Find sum of all chances
        for ( uint i = 0; i < bj_randDistCount; i++ )
        {
            sum += bj_randDistChance[i];
        }

        // Choose random number within the total range
        int chance = Jass::GetRandomInt( 1, sum );

        // Find ID which corresponds to this chance
        sum = 0;
        int foundID = 0;
        bool done = false;
        
        for( uint i = 0; !done; )
        {
            sum += bj_randDistChance[i];

            if ( chance <= sum )
            {
                foundID = bj_randDistID[i];
                done = true;
            }

            i++;
            if ( i == bj_randDistCount )
            {
                done = true;
            }
        }

        return foundID;
    }

    item UnitDropItem( unit inUnit, int inItemID )
    {
        if ( inItemID == -1 )
        {
            return nil;
        }

        float radius = 32.f;
        
        float unitX = Jass::GetUnitX( inUnit );
        float unitY = Jass::GetUnitY( inUnit );

        float x = Jass::GetRandomReal( unitX - radius, unitX + radius );
        float y = Jass::GetRandomReal( unitY - radius, unitY + radius );

        item droppedItem = Jass::CreateItem( inItemID, x, y );

        Jass::SetItemDropID( droppedItem, Jass::GetUnitTypeId( inUnit ) );
        UpdateStockAvailability( droppedItem );

        return droppedItem;
    }

    item WidgetDropItem( widget inWidget, int inItemID )
    {
        if ( inItemID == -1 )
        {
            return nil;
        }

        float radius = 32.f;

        float widgetX = Jass::GetWidgetX( inWidget );
        float widgetY = Jass::GetWidgetY( inWidget );

        float x = Jass::GetRandomReal( widgetX - radius, widgetX + radius );
        float y = Jass::GetRandomReal( widgetY - radius, widgetY + radius );

        return Jass::CreateItem( inItemID, x, y );
    }
}