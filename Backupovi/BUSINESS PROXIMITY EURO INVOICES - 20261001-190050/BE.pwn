#include <Vozila>
#include <map-zones>
#include <Mape>
#include <zcmd>
#define FILTERSCRIPT
#include <a_samp>
#include <dof2>
#include <streamer> // DODAJ OVO OVDE

#pragma unused DOF2_Exit
#pragma tabsize 0
#pragma dynamic 65536


// --- DEFINICIJE ---
#define PLAVA_BOJA     0x9EC7E0FF
#define PLAVA_LINIJA   0x0042FFFF
#define ZUTA_BOJA      0xF9A602FF
#define BELA_BOJA      0xFFFFFFFF
#define SSCANF_NO_NICE_FEATURES
#include <sscanf2>

forward LoadHouses();
forward UcitajOglase();
forward UcitajZlataru();
forward InitRevolutionHud();
forward UpdateHudTip(tip);
forward UcitajTrafike();
forward UcitajLabele();
forward LoadAdminParkedVehicles();

#define BANK_ROBBERY_FILE "BalkanRP/BankRobbery.ini"
#define DIALOG_REGISTRACIJA 1001
#define DIALOG_LOGIN        1002
#define DIALOG_POL          1003
#define DIALOG_GODINE       1004
#define DIALOG_DRZAVA       1005
#define DIALOG_RADIO 555 // Ili bilo koji slobodan broj
#define DIALOG_STATS 105
#define DIALOG_ADMINKOD 106
#define DIALOG_HELPERKOD 999
#define MAX_KUCA 200
#define DIALOG_INVENTORY 15016
#define DIALOG_MARKET_SIM 150      // Mo?e? staviti bilo koji broj koji se ne koristi
#define DIALOG_MARKET_HRANA 151
#define MAX_ZLATARE 10 // Umjesto 10 stavi onoliko zlatara koliko maksimalno ima? na serveru
#define DIALOG_ORG_MEMBERS 9999
#define DIALOG_ORG_HELP 9876
#define DIALOG_AH 15000
#define DIALOG_HELP 15001
#define DIALOG_SET_ADMIN_CODE 15002
#define DIALOG_ADMIN_CODE_NOTICE 15003
#define DIALOG_RENT 15004
#define DIALOG_DOSIJE 15005
#define DIALOG_ADMIN_HELP 15006
#define DIALOG_ADMIN_CHECK 15007
#define DIALOG_PRAVILA 15008
#define DIALOG_GOTOJOB 15009
#define DIALOG_GOTOPIJACA 15010
#define DIALOG_PAYDAY_REPORT 15011
#define DIALOG_HAPPYJOB 15012
#define DIALOG_RIBOLOVAC_KUPI_MAMAC 15013
#define DIALOG_RIBOLOVAC_IZABERI_MAMAC 15014
#define DIALOG_RIBOLOVAC_ZARADA 15015
#define DIALOG_BIZZ_SELL_STATE 15017
#define DIALOG_BIZZ_SELL_PLAYER 15018
#define DIALOG_BIZZ_INFO 15019
#define DIALOG_BIZZ_HELP 15020
#define DIALOG_HELP_GENERAL 15021
#define DIALOG_HELP_PLAYER 15022
#define DIALOG_HELP_VEHICLE 15023
#define DIALOG_HELP_JOB 15024
#define DIALOG_JOB_INFO 15025
#define DIALOG_PRICEPRODUCTS_CATEGORY 15026
#define DIALOG_PRICEPRODUCTS_BOATS 15027
#define DIALOG_PRICEPRODUCTS_BOAT_OPTIONS 15028
#define DIALOG_PRICEPRODUCTS_BOAT_PRICE 15029
#define DIALOG_PRICEPRODUCTS_BOAT_TIME 15030
#define DIALOG_FISHING_BOAT_RENT 15031
#define DIALOG_RIBOLOVAC_KUPI_STAP 15032
#define DIALOG_CREATE_JOB_BUSINESS 15033
#define DIALOG_COOWNER_OFFER 15034
#define DIALOG_BUY_INVOICES 15035
#define DIALOG_PRICEPRODUCTS_BAIT_LIST 15036
#define DIALOG_PRICEPRODUCTS_BAIT_OPTIONS 15037
#define DIALOG_PRICEPRODUCTS_BAIT_AMOUNT 15038
#define DIALOG_PRICEPRODUCTS_BAIT_PRICE 15039
#define DIALOG_PRICEPRODUCTS_ROD_LIST 15040
#define DIALOG_PRICEPRODUCTS_ROD_PRICE 15041
#define DIALOG_HELP_HOUSE 15042
#define DIALOG_HELP_FACTION 15043
#define DIALOG_BIZZ_BANK_MENU_BASE 15100
#define DIALOG_BIZZ_BANK_DEPOSIT_BASE 15200
#define DIALOG_BIZZ_BANK_WITHDRAW_BASE 15300
#define BIZZ_BANK_STAGE_NONE 0
#define BIZZ_BANK_STAGE_MENU 1
#define BIZZ_BANK_STAGE_DEPOSIT 2
#define BIZZ_BANK_STAGE_WITHDRAW 3
#define MAX_MONEY_VALUE 2147483647
#define MAX_TRAFIKA 50 // Mo?e? staviti koliki god maksimalan broj trafika ?eli?
#define DIALOG_TRAFIKA         100 // Mo?e? staviti bilo koji slobodan broj koji se ne poklapa sa drugim
#define DIALOG_TRAFIKA_SOK     101
#define DIALOG_TRAFIKA_HRANA   102
#define DIALOG_TRAFIKA_KREDIT  103

#define RANK_ADMIN_1 1
#define RANK_ADMIN_3 2
#define RANK_ADMIN_5 3
#define RANK_HEAD_ADMIN 4
#define RANK_DIRECTOR 5
#define RANK_MAPPER 6
#define RANK_SKRIPTER 7
#define RANK_SUVLASNIK 8
#define RANK_VLASNIK 9

#define MAX_CUSTOM_LABELS 100
new Float:CustomLabelX[MAX_CUSTOM_LABELS], Float:CustomLabelY[MAX_CUSTOM_LABELS], Float:CustomLabelZ[MAX_CUSTOM_LABELS];
new PickupCustom[MAX_CUSTOM_LABELS];
new Text3D:LabelCustom[MAX_CUSTOM_LABELS];
new CustomLabelNaziv[MAX_CUSTOM_LABELS][32];
// --- VARIJABLE ---
new IntroKorak[MAX_PLAYERS];
new TimerIntro[MAX_PLAYERS];
new RegLozinka[MAX_PLAYERS][64];
new RegPol[MAX_PLAYERS];
new RegGodine[MAX_PLAYERS];
new RegDrzava[MAX_PLAYERS][32];
new PlayerZlato[MAX_PLAYERS];
new PlayerRespekti[MAX_PLAYERS];
new PlayerMinute[MAX_PLAYERS];
new SessionPaydayMinutes[MAX_PLAYERS];
new SessionContinuousMinutes[MAX_PLAYERS];
new RentPaidSincePayday[MAX_PLAYERS];
// Dodaj ovo na vrh skripte (gde defini?e? ostale globalne varijable)
new LastOglasTick;
new PlayerSat[MAX_PLAYERS];
new IgracKrediti[MAX_PLAYERS];
new HappyHourMultiplier = 1;
new HappyJobId = 0;
new HealthTickMinutes[MAX_PLAYERS];
new PoliceTrackTarget[MAX_PLAYERS];
#define POLICE_TRACK_MAP_ICON 31
#define MEDICAL_TREATMENT_PRICE 500
#define STATS_SETTINGS_FILE "BalkanRP/StatsSettings.ini"
#define JOB_NONE 0
#define JOB_CISTAC_ULICA 1
#define JOB_POSTAR 2
#define JOB_RIBOLOVAC 3

#define BIZ_TYPE_NONE 0
#define BIZ_TYPE_MARKET 1
#define BIZ_TYPE_JOB 2
#define BIZ_TYPE_STRIP_CLUB 3
#define BIZ_TYPE_RESTAURANT 4
#define BIZ_TYPE_GAS_STATION 5
#define MAX_BUSINESS_TYPE 5
#define MAX_BUSINESS_PRODUCTS 250
#define MAX_BUSINESS_INVOICES 100
#define MAX_BUSINESS_ENTRANCE_FEE 10000
#define BUSINESS_DATA_VERSION 9

#define JOB_STAGE_NONE 0
#define JOB_STAGE_GET_EQUIPMENT 1
#define JOB_STAGE_GO_TO_FISHING_SPOT 2
#define JOB_STAGE_READY_TO_FISH 3
#define JOB_STAGE_FISHING 4
#define JOB_STAGE_CATCH_READY 5
#define JOB_STAGE_RETURN_TO_MARKET 6
#define JOB_STAGE_SELLING 7

// Ribarsko pristaniste na Santa Maria Beachu.
#define RIBOLOVAC_POS_X 393.95410156
#define RIBOLOVAC_POS_Y -2070.46850585
#define RIBOLOVAC_POS_Z 8.92717170
#define RIBOLOVAC_SMJENA_X 397.21475219
#define RIBOLOVAC_SMJENA_Y -2073.23217773
#define RIBOLOVAC_SMJENA_Z 7.83593750
#define RIBOLOVAC_STAP_MODEL 18632
#define RIBOLOVAC_STAP_SLOT 8
#define RIBOLOVAC_MAMAC_SLOT 7
#define RIBOLOVAC_MAX_ULOV 10
#define RIBOLOVAC_SKIN 35
#define MAX_RIBOLOVAC_RIBA 9
#define RIBOLOVAC_MAX_LEVEL 5
#define RIBOLOVAC_LEVEL_VERSION 2
#define RIBOLOVAC_PRODAJA_X 369.31781005
#define RIBOLOVAC_PRODAJA_Y -2078.36254882
#define RIBOLOVAC_PRODAJA_Z 7.83593750
#define RIBOLOVAC_MAMAC_X 372.46868896
#define RIBOLOVAC_MAMAC_Y -2078.19335937
#define RIBOLOVAC_MAMAC_Z 7.83593750
#define RIBOLOVAC_STAP_X 377.81393432
#define RIBOLOVAC_STAP_Y -2069.57080078
#define RIBOLOVAC_STAP_Z 7.83593750
#define MAX_RIBOLOVAC_MAMACA 3
#define MAX_BUSINESS_VEHICLES 5
#define FISHING_BOAT_MODEL 453
#define FISHING_BOAT_PRICE 100000
#define FISHING_BOAT_RENT_MIN_MINUTES 5
#define FISHING_BOAT_RENT_MAX_MINUTES 120
#define OFFSHORE_MIN_X 698.8413
#define OFFSHORE_MAX_X 894.7234
#define OFFSHORE_MIN_Y -3007.8770
#define OFFSHORE_MAX_Y -2815.1606
#define OFFSHORE_CENTER_X 796.78235
#define OFFSHORE_CENTER_Y -2911.5188

forward HandleTemporaryNameConnect(playerid, playername[]);
forward SaveRibolovacCatch(playerid);
forward SaveRibolovacBait(playerid);
forward SellRibolovacCatch(playerid);
forward StartRibolovacFishing(playerid);
forward UpdateRibolovacBaitObject(playerid);
forward ApplyPendingDeathPenalty(playerid, bool:notify);
forward HasSpecialCommandAccess(playerid);
forward bool:IsFishingBusiness(businessid);
forward bool:IsPlayerInOffshoreFishingZone(playerid);
forward bool:IsPlayerInOwnRentedFishingBoat(playerid);
forward bool:IsBusinessOwner(playerid, businessid);
forward bool:IsBusinessCoOwner(playerid, businessid);
forward bool:CanManageBusiness(playerid, businessid);
forward bool:CanManageBusinessHere(playerid, businessid);
forward bool:CanBusinessUseProducts(businessid);
forward bool:CanBusinessUseEntranceFee(businessid);
forward bool:HasBusinessProducts(businessid, amount = 1);
forward BusinessInvoiceTick();
forward HandleBusinessBankDialog(playerid, dialogid, response, listitem, inputtext[]);
new kapija_parking;
new bool:BigEar[MAX_PLAYERS];
new bool:ScriptJetpack[MAX_PLAYERS];
new JetpackDropGuardUntil[MAX_PLAYERS];
new LastLocationZone[MAX_PLAYERS];
new bool:HasMapMarker[MAX_PLAYERS];
new Float:MapMarkerX[MAX_PLAYERS], Float:MapMarkerY[MAX_PLAYERS], Float:MapMarkerZ[MAX_PLAYERS];
new MapTeleportSerial[MAX_PLAYERS];
new RentVehicleOwner[MAX_VEHICLES]; // 0 = slobodno, inace playerid + 1
new RentPlayerVehicle[MAX_PLAYERS]; // 0 = nema renta
new RentPendingVehicle[MAX_PLAYERS];
new RentExpiresAt[MAX_PLAYERS];
new PlayerText:RentTextDraw[MAX_PLAYERS];
new RentBusinessId[MAX_PLAYERS];
new RentBusinessSlot[MAX_PLAYERS];
new bool:OffshoreCheckpoint[MAX_PLAYERS];
new OffshoreFishingZone;

#define PUTARINA_CIJENA 100
new STREAMER_TAG_OBJECT:PutarinaRampa[2];
new PutarinaKorak[2], PutarinaStanje[2], PutarinaOtvorenaDo[2];

// --- TAXI SISTEM GLOBALNE PROMENLJIVE ---
new G_TaxiCaller = INVALID_PLAYER_ID;
new Float:G_TaxiPos[3];
new bool:G_HasTaxiCall = false;
new Float:TaxiDutyPos[3] = {1753.6607, -1894.3673, 13.5571}; // Koordinate za /duty
new G_TaxiPrice = 0; // Pamti cenu voznje
new bool:G_TaxiDuty = false; // Da li je neko na duznosti
new G_AcceptedTaxiDriver = INVALID_PLAYER_ID;
// Pljacka banke: jedno hakovanje i jedan zajednicki cooldown za sve igrace.
new BankHackPlayer = INVALID_PLAYER_ID;
new BankHackStartedAt;
new BankHackCooldownUntil;
new BankLaserDisableAt;
new BankHackSuccessPlayer = INVALID_PLAYER_ID;
new BankResetAt;
new bool:BankDoorsOpen;
new bool:BankLasersOff;
new bool:BankLaserWarned[MAX_PLAYERS];
new Float:BankLaserOriginalZ[11];
new Float:BankHackStartX, Float:BankHackStartY, Float:BankHackStartZ;

// Druga faza pljacke banke.
new BankDynamiteObject;
new BankDynamiteUntil;
new bool:BankVaultDoorDown;
new BankRobber = INVALID_PLAYER_ID;
new BankRobberyUntil;
new BankRobberyCooldownUntil;
new bool:BankRobberyFinishedThisCycle;
new bool:BankMoneyBag[MAX_PLAYERS];
new WantedPoints[MAX_PLAYERS];
new PendingDeathFine[MAX_PLAYERS];
new PendingDeathWanted[MAX_PLAYERS];
new DeathPenaltySerial[MAX_PLAYERS];
new WantedReason[MAX_PLAYERS][64];
new PlayerText:TD_WantedHint[MAX_PLAYERS];
new PlayerText:TD_WantedStars[MAX_PLAYERS];
new bool:WantedHintBlinkVisible[MAX_PLAYERS];
new WantedHintToggleAt[MAX_PLAYERS];
new BankLaserLastCheck[MAX_PLAYERS];
new BankLaserLastAlert[MAX_PLAYERS];
new bool:BankLaserPrevValid[MAX_PLAYERS];
new Float:BankLaserPrevX[MAX_PLAYERS], Float:BankLaserPrevY[MAX_PLAYERS], Float:BankLaserPrevZ[MAX_PLAYERS];

new PlayerOrg[MAX_PLAYERS];
new bool:IsHealing[MAX_PLAYERS];
new LastAntiSpamTick[MAX_PLAYERS];
#define ANTI_SPAM_DELAY_MS 1200
new SafeTeleportSerial[MAX_PLAYERS];
new PlayerCurrentSkin[MAX_PLAYERS];



// HUD: zajednicki dijelovi se prave jednom, podaci posebno za svakog igraca.
// Elementi HUD-a direktno iz korisnikovog DTD.pwn exporta.
new Text:TD_NewHud[35];
new Text:TD_VehicleFrame[11];
new Text:TD_Auth[13];
new Text:TD_HappyJobStatus;
new bool:AuthTDShown[MAX_PLAYERS];
new PlayerText:TD_Vozilo[MAX_PLAYERS][12];
new bool:VoziloHudShown[MAX_PLAYERS];
new bool:VehicleHudInitialized[MAX_VEHICLES], bool:VehicleHudOutOfFuel[MAX_VEHICLES];
new Float:VehicleHudFuel[MAX_VEHICLES], Float:VehicleHudKm[MAX_VEHICLES];
new Float:VehicleHudLastX[MAX_VEHICLES], Float:VehicleHudLastY[MAX_VEHICLES], Float:VehicleHudLastZ[MAX_VEHICLES];
new bool:VehicleHudLastPosValid[MAX_VEHICLES];
new VehicleHudLastSpeed[MAX_PLAYERS];
new VehicleHudNextStartTry[MAX_VEHICLES], VehicleHudNextStallAt[MAX_VEHICLES];
new VehicleHudLastDamage[MAX_VEHICLES];
new bool:VehicleHudBrokenNotice[MAX_VEHICLES], bool:VehicleHudStalled[MAX_VEHICLES];
new bool:AdminSpawnedVehicle[MAX_VEHICLES];
new bool:AdminParkedVehicle[MAX_VEHICLES];
new Float:AdminParkX[MAX_VEHICLES],Float:AdminParkY[MAX_VEHICLES],Float:AdminParkZ[MAX_VEHICLES],Float:AdminParkA[MAX_VEHICLES];
new VehicleHudModelNames[212][] = {
    "Landstalker",
    "Bravura",
    "Buffalo",
    "Linerunner",
    "Perrenial",
    "Sentinel",
    "Dumper",
    "Firetruck",
    "Trashmaster",
    "Stretch",
    "Manana",
    "Infernus",
    "Voodoo",
    "Pony",
    "Mule",
    "Cheetah",
    "Ambulance",
    "Leviathan",
    "Moonbeam",
    "Esperanto",
    "Taxi",
    "Washington",
    "Bobcat",
    "Mr Whoopee",
    "BF Injection",
    "Hunter",
    "Premier",
    "Enforcer",
    "Securicar",
    "Banshee",
    "Predator",
    "Bus",
    "Rhino",
    "Barracks",
    "Hotknife",
    "Trailer 1",
    "Previon",
    "Coach",
    "Cabbie",
    "Stallion",
    "Rumpo",
    "RC Bandit",
    "Romero",
    "Packer",
    "Monster",
    "Admiral",
    "Squalo",
    "Seasparrow",
    "Pizzaboy",
    "Tram",
    "Trailer 2",
    "Turismo",
    "Speeder",
    "Reefer",
    "Tropic",
    "Flatbed",
    "Yankee",
    "Caddy",
    "Solair",
    "Berkley's RC Van",
    "Skimmer",
    "PCJ-600",
    "Faggio",
    "Freeway",
    "RC Baron",
    "RC Raider",
    "Glendale",
    "Oceanic",
    "Sanchez",
    "Sparrow",
    "Patriot",
    "Quad",
    "Coastguard",
    "Dinghy",
    "Hermes",
    "Sabre",
    "Rustler",
    "ZR-350",
    "Walton",
    "Regina",
    "Comet",
    "BMX",
    "Burrito",
    "Camper",
    "Marquis",
    "Baggage",
    "Dozer",
    "Maverick",
    "News Chopper",
    "Rancher",
    "FBI Rancher",
    "Virgo",
    "Greenwood",
    "Jetmax",
    "Hotring",
    "Sandking",
    "Blista Compact",
    "Police Maverick",
    "Boxville",
    "Benson",
    "Mesa",
    "RC Goblin",
    "Hotring Racer A",
    "Hotring Racer B",
    "Bloodring Banger",
    "Rancher",
    "Super GT",
    "Elegant",
    "Journey",
    "Bike",
    "Mountain Bike",
    "Beagle",
    "Cropdust",
    "Stunt",
    "Tanker",
    "Roadtrain",
    "Nebula",
    "Majestic",
    "Buccaneer",
    "Shamal",
    "Hydra",
    "FCR-900",
    "NRG-500",
    "HPV1000",
    "Cement Truck",
    "Tow Truck",
    "Fortune",
    "Cadrona",
    "FBI Truck",
    "Willard",
    "Forklift",
    "Tractor",
    "Combine",
    "Feltzer",
    "Remington",
    "Slamvan",
    "Blade",
    "Freight",
    "Streak",
    "Vortex",
    "Vincent",
    "Bullet",
    "Clover",
    "Sadler",
    "Firetruck LA",
    "Hustler",
    "Intruder",
    "Primo",
    "Cargobob",
    "Tampa",
    "Sunrise",
    "Merit",
    "Utility",
    "Nevada",
    "Yosemite",
    "Windsor",
    "Monster A",
    "Monster B",
    "Uranus",
    "Jester",
    "Sultan",
    "Stratum",
    "Elegy",
    "Raindance",
    "RC Tiger",
    "Flash",
    "Tahoma",
    "Savanna",
    "Bandito",
    "Freight Flat",
    "Streak Carriage",
    "Kart",
    "Mower",
    "Duneride",
    "Sweeper",
    "Broadway",
    "Tornado",
    "AT-400",
    "DFT-30",
    "Huntley",
    "Stafford",
    "BF-400",
    "Newsvan",
    "Tug",
    "Trailer 3",
    "Emperor",
    "Wayfarer",
    "Euros",
    "Hotdog",
    "Club",
    "Freight Carriage",
    "Trailer 3",
    "Andromada",
    "Dodo",
    "RC Cam",
    "Launch",
    "Police Car (LSPD)",
    "Police Car (SFPD)",
    "Police Car (LVPD)",
    "Police Ranger",
    "Picador",
    "S.W.A.T. Van",
    "Alpha",
    "Phoenix",
    "Glendale",
    "Sadler",
    "Luggage Trailer A",
    "Luggage Trailer B",
    "Stair Trailer",
    "Boxville",
    "Farm Plow",
    "Utility Trailer"
};
new Text:TD_HudPoruka;
new PlayerText:TD_NovacPlavi[MAX_PLAYERS];
new PlayerText:TD_Euro[MAX_PLAYERS];
new PlayerText:TD_Zlato[MAX_PLAYERS];
new PlayerText:TD_Grad[MAX_PLAYERS];
new PlayerText:TD_Lokacija[MAX_PLAYERS];

new PlayerText:TD_HudDatum[MAX_PLAYERS];
new PlayerText:TD_HudVrijeme[MAX_PLAYERS];

new LastHudMinute[MAX_PLAYERS];
new Text3D:AdminText[MAX_PLAYERS] = {Text3D:INVALID_3DTEXT_ID, ...};
new JuniorMutedUntil[MAX_PLAYERS], JuniorJailedUntil[MAX_PLAYERS];
new JuniorGMutedUntil[MAX_PLAYERS], JuniorAdMutedUntil[MAX_PLAYERS];
new JuniorAskMutedUntil[MAX_PLAYERS], JuniorReportMutedUntil[MAX_PLAYERS];
new Text3D:JuniorMuteLabel[MAX_PLAYERS] = {Text3D:INVALID_3DTEXT_ID, ...};
new bool:JuniorFrozen[MAX_PLAYERS], bool:JuniorSpectating[MAX_PLAYERS];
new bool:PhoneSpecDisabled[MAX_PLAYERS];
new JuniorSpecTarget[MAX_PLAYERS];
new Float:JuniorSpecX[MAX_PLAYERS], Float:JuniorSpecY[MAX_PLAYERS], Float:JuniorSpecZ[MAX_PLAYERS];
new JuniorSpecInterior[MAX_PLAYERS], JuniorSpecWorld[MAX_PLAYERS];
new bool:JuniorGlobalChatLocked;
new bool:RacAdminInProgress, bool:RestartAdminInProgress;
new bool:JuniorEventActive;
new Float:JuniorEventX, Float:JuniorEventY, Float:JuniorEventZ;
new JuniorEventInterior, JuniorEventWorld;
new bool:BrziPrstiActive;
new BrziPrstiKod[16];
new BrziPrstiNagrada;
new Text3D:RentVehicleLabel[MAX_VEHICLES] = {Text3D:INVALID_3DTEXT_ID, ...};
new Text3D:HelperLabel[MAX_PLAYERS] = {Text3D:INVALID_3DTEXT_ID, ...};
#define MAX_ADMIN_GIFTS 20
new STREAMER_TAG_OBJECT:AdminGiftObject[MAX_ADMIN_GIFTS];
new STREAMER_TAG_PICKUP:AdminGiftPickup[MAX_ADMIN_GIFTS];
new bool:AdminGiftActive[MAX_ADMIN_GIFTS];
new Float:AdminGiftX[MAX_ADMIN_GIFTS], Float:AdminGiftY[MAX_ADMIN_GIFTS], Float:AdminGiftZ[MAX_ADMIN_GIFTS];
new AdminGiftInterior[MAX_ADMIN_GIFTS], AdminGiftWorld[MAX_ADMIN_GIFTS];
new Float:AdminGiftRotation[MAX_ADMIN_GIFTS];
new LastDamageIssuer[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new LastDamageWeapon[MAX_PLAYERS], LastDamageAt[MAX_PLAYERS];
new LastKilledPlayer[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};
new LastKillWeapon[MAX_PLAYERS], LastKillAt[MAX_PLAYERS];
// Pamcenje da li igrac radi turu i na kom je koraku
new IsDoingPosta[MAX_PLAYERS];
new PostarStep[MAX_PLAYERS];

enum E_PLAYER_JOB_DATA
{
    JobID,
    JobLevel,
    JobXP,
    bool:JobDuty,
    JobStage,
    JobVehicle,
    JobCargo,
    JobCheckpoint,
    JobObject,
    JobTaskSerial,
    JobPreviousSkin
};
new PlayerJobData[MAX_PLAYERS][E_PLAYER_JOB_DATA];

#define MAX_RIBOLOVAC_MJESTA 3
new Float:RibolovacMjesta[MAX_RIBOLOVAC_MJESTA][3] =
{
    {403.1054, -2088.3875, 7.8359},
    {383.0518, -2088.1648, 7.8359},
    {362.0184, -2088.4216, 7.8359}
};
new RibolovacAktivnoMjesto[MAX_PLAYERS];
new Float:RibolovacStartX[MAX_PLAYERS];
new Float:RibolovacStartY[MAX_PLAYERS];
new Float:RibolovacStartZ[MAX_PLAYERS];

enum E_RIBOLOVAC_RIBA
{
    RibaNaziv[16],
    RibaMinGrama,
    RibaMaxGrama,
    RibaCijenaPoKg
};
new RibolovacRibe[MAX_RIBOLOVAC_RIBA][E_RIBOLOVAC_RIBA] =
{
    {"Sardina", 300, 800, 80},
    {"Skusa", 500, 1400, 100},
    {"Brancin", 800, 2500, 140},
    {"Tuna", 1800, 5000, 180},
    {"Lignja", 800, 2500, 220},
    {"Velika Tuna", 4000, 12000, 260},
    {"Sabljarka", 6000, 16000, 320},
    {"Jastog", 600, 1800, 500},
    {"Morski Pas", 9000, 22000, 280}
};
new RibolovacRibaKolicina[MAX_PLAYERS][MAX_RIBOLOVAC_RIBA];
new RibolovacUkupnoGrama[MAX_PLAYERS];
new RibolovacVrijednost[MAX_PLAYERS];
new RibolovacMamac[MAX_PLAYERS][MAX_RIBOLOVAC_MAMACA];
new RibolovacAktivniMamac[MAX_PLAYERS];
new RibolovacKoristeniMamac[MAX_PLAYERS];
new RibolovacStap[MAX_PLAYERS]; // 0 nema, 1 pocetnicki, 2 profesionalni
new bool:RibolovacOffshoreAttempt[MAX_PLAYERS];
new const RibolovacMamacNaziv[MAX_RIBOLOVAC_MAMACA][20] =
{
    "Hljeb",
    "Crv",
    "Lignja"
};
new const RibolovacMamacCijena[MAX_RIBOLOVAC_MAMACA] = {300, 700, 1500};

new Float:PostarRute[16][3] = {
    {330.3491, -1516.8910, 35.4390},  // [0] Magacin (Pocetak - ovde kuca komandu)
    {478.7272, -1592.8779, 22.7695},  // [1]
    {677.9338, -1586.3257, 13.5500},  // [2]
    {829.5987, -1613.3223, 12.9484},  // [3]
    {809.1125, -1760.5427, 12.9538},  // [4]
    {871.8068, -1784.6364, 13.2111},  // [5]
    {1043.9939, -1851.2404, 12.9620}, // [6]
    {1025.5894, -2122.4080, 12.5046}, // [7]
    {1065.3210, -2323.5112, 12.3593}, // [8]
    {1348.6144, -2295.4553, 12.9485}, // [9]
    {1538.1099, -2195.6187, 12.9407}, // [10]
    {1723.9205, -2195.8611, 12.9407}, // [11]
    {1839.3733, -2165.5046, 12.9485}, // [12]
    {1954.5013, -2165.4641, 12.9485}, // [13]
    {2066.5229, -2262.1719, 13.1188}, // [14]
    {2001.8545, -2315.8989, 13.1194}  // [15] Aerodrom / Lager (Ovde ceka 10 sekundi)
};
#define UKUPNO_POSTAR_TACAKA 16

// Enum za definiciju telefona
enum E_TELEFONI
{
    tNaziv[32],
    tCijena
}

// Lista 5 telefona (od jeftinijeg ka skupljem)
new const TelLista[5][E_TELEFONI] = {
    {"Xiaomi Redmi A3", 150},
    {"Huawei Nova 11", 450},
    {"Samsung Galaxy S25", 900},
    {"iPhone 16 Pro", 1300},
    {"iPhone 17 Pro Max", 1800}
};
#define MAX_SLOBODNIH_OBJEKATA 100 // Maksimum koliko ih mo?e? imati

enum e_SlobodanObjekt
{
    sModel,
    Float:sX, Float:sY, Float:sZ,
    Float:sRX, Float:sRY, Float:sRZ,
    sObjID
}
new SlobodanObjekt[MAX_SLOBODNIH_OBJEKATA][e_SlobodanObjekt];
#define MAX_LABELA 100 // Maksimalan broj labela koje mozes kreirati

enum E_LABEL_DATA
{
    bool:lKreiran,
    Float:lX,
    Float:lY,
    Float:lZ,
    lInterior,
    lVW,
    lTekst[128],
    Text3D:l3DText,
    lPickupID
}
new LabelInfo[MAX_LABELA][E_LABEL_DATA];
#define MAX_TRAFIKE 50 // Mo?e? promijeniti po ?elji

enum e_TrafikaInfo
{
    tOwned,
    tOwner[MAX_PLAYER_NAME],
    tNaziv[32],
    Float:tEntranceX,
    Float:tEntranceY,
    Float:tEntranceZ,
    tCena,
    tLevel,
    tBudzet,
    tProizvodi,
    tCenaProizvoda,
    Text3D:tLabel,
    tPickup
};
new TrafikaInfo[MAX_TRAFIKE][e_TrafikaInfo];
#define MAX_ZLATA 15 // Maksimalan broj zlatara na serveru

enum ZlataEnum
{
    zOwned,
    zOwner[MAX_PLAYER_NAME],
    zNaziv[32],
    Float:zEntranceX,
    Float:zEntranceY,
    Float:zEntranceZ,
    Float:zExitX,
    Float:zExitY,
    Float:zExitZ,
    zInterior,
    zCena,
    zLevel,
    zUlaznaCena,
    zBudzet,
    zProizvodi,
    zCenaProizvoda,

    // Vizuelni elementi
    Text3D:zLabel,
    zPickup
};
new ZlataInfo[MAX_ZLATA][ZlataEnum];
#define MAX_OGLASA 20

enum OglasiEnum
{
    oOwned,
    oOwner[MAX_PLAYER_NAME],
    oNaziv[32],
    Float:oEntranceX,
    Float:oEntranceY,
    Float:oEntranceZ,
    Float:oExitX,
    Float:oExitY,
    Float:oExitZ,
    oInterior,
    oCena,
    oLevel,
    oUlaznaCena,
    oBudzet,
    oProizvodi,
    oCenaProizvoda,

    // Vizuelni elementi
    Text3D:oLabel,
    oPickup
};
new OglasiInfo[MAX_OGLASA][OglasiEnum];

#define MAX_MARKETA 50 // Mo?e? promijeniti na koliko god market? ?eli?

enum MarketEnum
{
    mOwned,
    mType, // 0 = 24/7 market, 1 = biznis vezan za posao
    mJobId,
    mOwner[MAX_PLAYER_NAME],
    mNaziv[32],
    mOpis[64],
    mIznuda,
    mFakture,
    mBizVehicleModel,
    mBizVehicleColor1,
    mBizVehicleColor2,
    Float:mBizVehicleX,
    Float:mBizVehicleY,
    Float:mBizVehicleZ,
    Float:mBizVehicleA,
    mBizVehicleId,
    Float:mEntranceX,
    Float:mEntranceY,
    Float:mEntranceZ,
    Float:mExitX,
    Float:mExitY,
    Float:mExitZ,
    mInterior,
    mCena,
    mLevel,
    mUlaznaCena,
    mBudzet,
    mProizvodi,
    mCenaProizvoda,

    // Vizuelni elementi
    Text3D:mLabel,
    mPickup
};
new MarketInfo[MAX_MARKETA][MarketEnum];
new BusinessVehicleModel[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new BusinessVehicleColor1[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new BusinessVehicleColor2[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new Float:BusinessVehicleX[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new Float:BusinessVehicleY[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new Float:BusinessVehicleZ[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new Float:BusinessVehicleA[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new BusinessVehicleId[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new BusinessVehicleRentPrice[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new BusinessVehicleRentMinutes[MAX_MARKETA][MAX_BUSINESS_VEHICLES];
new BusinessCoOwner[MAX_MARKETA][MAX_PLAYER_NAME];
new BusinessBaitPrice[MAX_MARKETA][MAX_RIBOLOVAC_MAMACA];
new BusinessBaitAmount[MAX_MARKETA][MAX_RIBOLOVAC_MAMACA];
new BusinessRodPrice[MAX_MARKETA][2];
new PendingPriceBusiness[MAX_PLAYERS];
new PendingPriceBoatSlot[MAX_PLAYERS];
new PendingPriceItem[MAX_PLAYERS];
new PendingBusinessCreateType[MAX_PLAYERS];
new PendingBusinessCreatePrice[MAX_PLAYERS];
new PendingBusinessCreateLevel[MAX_PLAYERS];
new PendingBusinessCreateName[MAX_PLAYERS][32];
new PendingCoOwnerBusiness[MAX_PLAYERS];
new PendingBizzBankBusiness[MAX_PLAYERS];
new PendingBizzBankStage[MAX_PLAYERS];
new PendingBizzBankExpiresAt[MAX_PLAYERS];
new PendingCoOwnerOwner[MAX_PLAYERS];
new PendingCoOwnerPrice[MAX_PLAYERS];
new PendingCoOwnerExpiresAt[MAX_PLAYERS];
new PlayerBusinessInvoices[MAX_PLAYERS];
new const Float:FishingBoatSlotPos[MAX_BUSINESS_VEHICLES][4] =
{
    {440.0007, -2099.8123, -0.2135, 181.4921},
    {434.7697, -2100.4038, -0.2816, 181.3388},
    {429.2695, -2100.0222, -0.4595, 179.4834},
    {423.8627, -2099.6472, -0.2909, 180.0721},
    {418.7195, -2099.4019, -0.2223, 178.7942}
};
new PendingBizzStateSale[MAX_PLAYERS];
new PendingBizzSeller[MAX_PLAYERS];
new PendingBizzId[MAX_PLAYERS];
new PendingBizzPrice[MAX_PLAYERS];

#define MAX_SERVER_NPCS 100
enum E_SERVER_NPC
{
    bool:NpcExists,
    NpcSkin,
    Float:NpcX,
    Float:NpcY,
    Float:NpcZ,
    Float:NpcAngle,
    NpcInterior,
    NpcWorld,
    STREAMER_TAG_ACTOR:NpcActorId
};
new ServerNpc[MAX_SERVER_NPCS][E_SERVER_NPC];

enum E_PLAYER_INFO
{
    pLevel,
    pNovac,
    pZlato,
    pGodine,
    pRespekti,
    pSati,
    pPol,
    pDrzava[32],
    pKuca, // <--- Dodajte ovo ovde!
    pBizz, // <--- DODAJ OVO OVDE
    pLider,
	pImenik,
	pBrojTelefona,
	pMeso,
	pMleko,
	pHleb,
	pJabuke,
	pBanana,
	pSok,
};

new PlayerInfo[MAX_PLAYERS][E_PLAYER_INFO];

enum kucaInfo
{
    kOwned, // 0 = Na prodaju, 1 = Kupljena
    Float:kEntranceX,
    Float:kEntranceY,
    Float:kEntranceZ,
    Float:kExitX,
    Float:kExitY,
    Float:kExitZ,
    kInterior,
    kCena,
    kLevel,
    kKlasa, // 1 = Mala, 2 = Velika
    kLocked,
    kOwner[MAX_PLAYER_NAME],
    Text3D:kLabel,
    kPickup

};
new HouseInfo[MAX_KUCA][kucaInfo];


main()
{
    print("\n----------------------------------");
    print("  Balkan Revolution RP se pokrece...");
    print("----------------------------------\n");
}
stock UcitajSlobodneObjekte()
{
    new file[64] = "BalkanRP/Objekti.ini";
    if(!DOF2_FileExists(file)) return 1;

    for(new i = 0; i < MAX_SLOBODNIH_OBJEKATA; i++)
    {
        new tag[32];

        format(tag, sizeof(tag), "Obj_%d_Model", i);
        if(DOF2_GetInt(file, tag) != 0)
        {
            SlobodanObjekt[i][sModel] = DOF2_GetInt(file, tag);

            format(tag, sizeof(tag), "Obj_%d_X", i);
            SlobodanObjekt[i][sX] = DOF2_GetFloat(file, tag);

            format(tag, sizeof(tag), "Obj_%d_Y", i);
            SlobodanObjekt[i][sY] = DOF2_GetFloat(file, tag);

            format(tag, sizeof(tag), "Obj_%d_Z", i);
            SlobodanObjekt[i][sZ] = DOF2_GetFloat(file, tag);

            format(tag, sizeof(tag), "Obj_%d_RX", i);
            SlobodanObjekt[i][sRX] = DOF2_GetFloat(file, tag);

            format(tag, sizeof(tag), "Obj_%d_RY", i);
            SlobodanObjekt[i][sRY] = DOF2_GetFloat(file, tag);

            format(tag, sizeof(tag), "Obj_%d_RZ", i);
            SlobodanObjekt[i][sRZ] = DOF2_GetFloat(file, tag);

            SlobodanObjekt[i][sObjID] = CreateDynamicObject(SlobodanObjekt[i][sModel], SlobodanObjekt[i][sX], SlobodanObjekt[i][sY], SlobodanObjekt[i][sZ], SlobodanObjekt[i][sRX], SlobodanObjekt[i][sRY], SlobodanObjekt[i][sRZ]);
        }
    }
    printf("Ucitano slobodnih objekata iz Objekti.ini");
    return 1;
}
stock PlayerText:CreateRentTextDraw(playerid)
{
    new PlayerText:td;
    td = CreatePlayerTextDraw(playerid, 112.000000, 415.000000, "~y~RENT VAM ISTICE ZA: ~w~N/A");
    	PlayerTextDrawFont(playerid, td, 2);
    	PlayerTextDrawLetterSize(playerid, td, 0.191666, 1.399999);
    	PlayerTextDrawTextSize(playerid, td, 463.500000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, td, 1);
    	PlayerTextDrawSetShadow(playerid, td, 1);
    	PlayerTextDrawAlignment(playerid, td, 1);
    	PlayerTextDrawColor(playerid, td, -1);
    	PlayerTextDrawBackgroundColor(playerid, td, 255);
    	PlayerTextDrawBoxColor(playerid, td, 50);
    	PlayerTextDrawUseBox(playerid, td, 0);
    	PlayerTextDrawSetProportional(playerid, td, 1);
    	PlayerTextDrawSetSelectable(playerid, td, 0);
    return td;
}

stock HasAdminCommandAccess(playerid)
{
    if(IsPlayerAdmin(playerid)) return 1;
    if(!GetPVarInt(playerid, "BR_LoggedIn")) return 0;
    new name[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    return (DOF2_FileExists(file) && DOF2_GetInt(file, "Admin") >= 1);
}

stock ShowMainHelp(playerid)
{
    new categories[256];
    strcat(categories, "GENERAL\n", sizeof(categories));
    strcat(categories, "IGRAC\n", sizeof(categories));
    strcat(categories, "VOZILA\n", sizeof(categories));
    strcat(categories, "POSLOVI\n", sizeof(categories));
    strcat(categories, "BIZNIS\n", sizeof(categories));
    strcat(categories, "KUCE\n", sizeof(categories));
    strcat(categories, "FRAKCIJE", sizeof(categories));
    if(HasAdminCommandAccess(playerid)) strcat(categories, "\nADMIN", sizeof(categories));
    ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Balkan Revolution - Pomoc", categories, "Odaberi", "Zatvori");
    return 1;
}

stock ShowGeneralHelp(playerid)
{
    new text[1536];
    strcat(text, "{00FF00}/pravila {FFFFFF}- Pregled pravila servera\n", sizeof(text));
    strcat(text, "{00FF00}/stats {FFFFFF}- Pregled licnih podataka i statistike\n", sizeof(text));
    strcat(text, "{00FF00}/time {FFFFFF}- Pregled vremena i datuma\n", sizeof(text));
    strcat(text, "{00FF00}/mp3 {FFFFFF}- Otvaranje radio menija\n", sizeof(text));
    strcat(text, "{00FF00}/ugasimp3 {FFFFFF}- Gasenje trenutno ukljucenog radija\n", sizeof(text));
    strcat(text, "{00FF00}/askq {FFFFFF}- Slanje pitanja Staff Teamu\n", sizeof(text));
    strcat(text, "{00FF00}/report {FFFFFF}- Prijava igraca administraciji\n", sizeof(text));
    strcat(text, "{00FF00}/dosije {FFFFFF}- Pregled trenutnih Wanted Levela\n", sizeof(text));
    strcat(text, "{00FF00}/stablo {FFFFFF}- Pregled hijerarhije servera", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_HELP_GENERAL, DIALOG_STYLE_MSGBOX, "Pomoc - General", text, "Nazad", "Zatvori");
    return 1;
}

stock ShowPlayerHelp(playerid)
{
    new text[1792];
    strcat(text, "{00FF00}/inventory {FFFFFF}- Otvaranje inventara\n", sizeof(text));
    strcat(text, "{00FF00}/buyinventory {FFFFFF}- Kupovina predmeta na odgovarajucem mjestu\n", sizeof(text));
    strcat(text, "{00FF00}/kupitelefon {FFFFFF}- Kupovina mobilnog telefona\n", sizeof(text));
    strcat(text, "{00FF00}/kupibrojtel {FFFFFF}- Kupovina telefonskog broja\n", sizeof(text));
    strcat(text, "{00FF00}/sms {FFFFFF}- Slanje privatne SMS poruke\n", sizeof(text));
    strcat(text, "{00FF00}/smsad {FFFFFF}- Slanje SMS oglasa\n", sizeof(text));
    strcat(text, "{00FF00}/call {FFFFFF}- Pozivanje drugog igraca\n", sizeof(text));
    strcat(text, "{00FF00}/me {FFFFFF}- Opis radnje vaseg lika\n", sizeof(text));
    strcat(text, "{00FF00}/do {FFFFFF}- Opis stanja ili okoline\n", sizeof(text));
    strcat(text, "{00FF00}/b {FFFFFF}- Lokalni OOC chat\n", sizeof(text));
    strcat(text, "{00FF00}/otvoriracun {FFFFFF}- Otvaranje bankovnog racuna u banci", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_HELP_PLAYER, DIALOG_STYLE_MSGBOX, "Pomoc - Igrac", text, "Nazad", "Zatvori");
    return 1;
}

stock ShowVehicleHelp(playerid)
{
    new text[1280];
    strcat(text, "{00FF00}/engine {FFFFFF}- Paljenje ili gasenje motora vozila\n", sizeof(text));
    strcat(text, "{00FF00}/fill {FFFFFF}- Tocenje goriva dok vozilo miruje i motor je ugasen\n", sizeof(text));
    strcat(text, "{00FF00}/platiputarinu {FFFFFF}- Placanje putarine i otvaranje rampe iz vozila\n", sizeof(text));
    strcat(text, "{00FF00}/unrent {FFFFFF}- Prekid trenutnog najma vozila\n", sizeof(text));
    strcat(text, "{00FF00}/rentvehiclehelp {FFFFFF}- Pomoc za iznajmljena vozila", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_HELP_VEHICLE, DIALOG_STYLE_MSGBOX, "Pomoc - Vozila", text, "Nazad", "Zatvori");
    return 1;
}

stock ShowJobHelp(playerid)
{
    new text[2304];
    strcat(text, "{00FF00}/posao {FFFFFF}- Zaposljavanje na oznacenom mjestu posla\n", sizeof(text));
    strcat(text, "{00FF00}/otkaz {FFFFFF}- Davanje otkaza na trenutnom poslu\n", sizeof(text));
    strcat(text, "{00FF00}/smjena {FFFFFF}- Pocetak ili zavrsetak radne smjene\n", sizeof(text));
    strcat(text, "{00FF00}/jobinfo {FFFFFF}- Posao, level, XP, smjena i posebni podaci posla\n\n", sizeof(text));
    strcat(text, "{FFFF00}Ribolovac\n", sizeof(text));
    strcat(text, "{00FF00}LIJEVI KLIK {FFFFFF}- Zabacivanje na oznacenom ribarskom mjestu\n", sizeof(text));
    strcat(text, "{00FF00}/kupistap {FFFFFF}- Kupovina ribarskog stapa\n", sizeof(text));
    strcat(text, "{00FF00}/kupimamac {FFFFFF}- Kupovina mamaca\n", sizeof(text));
    strcat(text, "{00FF00}/mamac {FFFFFF}- Izbor kupljenog mamca\n", sizeof(text));
    strcat(text, "{00FF00}/prodajribu {FFFFFF}- Prodaja ulova na ribarskom standu\n\n", sizeof(text));
    strcat(text, "{FFFF00}Postar\n", sizeof(text));
    strcat(text, "{00FF00}/dovezipostu {FFFFFF}- Dovoz poste iz lagera u magacin\n", sizeof(text));
    strcat(text, "{00FF00}/prekiniposao {FFFFFF}- Prekid aktivne postarske ture", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_HELP_JOB, DIALOG_STYLE_MSGBOX, "Pomoc - Poslovi", text, "Nazad", "Zatvori");
    return 1;
}

stock ShowBusinessHelp(playerid)
{
    new text[3072];
    strcat(text, "{00FF00}/buybizz {FFFFFF}- Kupovina biznisa\n", sizeof(text));
    strcat(text, "{00FF00}/sellbizz {FFFFFF}- Prodaja biznisa drzavi\n", sizeof(text));
    strcat(text, "{00FF00}/psellto {FFFFFF}- Prodaja biznisa drugom igracu\n", sizeof(text));
    strcat(text, "{00FF00}/bizzinfo {FFFFFF}- Pregled informacija vaseg biznisa\n", sizeof(text));
    strcat(text, "{00FF00}/priceproducts {FFFFFF}- Upravljanje cijenama podrzanih proizvoda i usluga\n", sizeof(text));
    strcat(text, "{00FF00}/esterbon {FFFFFF}- Ponuda mjesta suvlasnika\n", sizeof(text));
    strcat(text, "{00FF00}/uklonisuvlasnika {FFFFFF}- Uklanjanje suvlasnika\n", sizeof(text));
    strcat(text, "{00FF00}/bizzname {FFFFFF}- Postavljanje opisa biznisa\n", sizeof(text));
    strcat(text, "{00FF00}/bizzfee {FFFFFF}- Postavljanje cijene ulaza ako je biznis podrzava\n", sizeof(text));
    strcat(text, "{00FF00}/bizzbank {FFFFFF}- Deposit i Withdraw novca preko dijaloga\n", sizeof(text));
    strcat(text, "{00FF00}/ob buy {FFFFFF}- Da kupite vozilo za vasu firmu\n", sizeof(text));
    strcat(text, "{00FF00}/ob sell {FFFFFF}- Da prodate firmino vozilo\n", sizeof(text));
    strcat(text, "{00FF00}/ob park {FFFFFF}- Da parkirate firmino vozilo\n", sizeof(text));
    strcat(text, "{00FF00}/ob sellcar {FFFFFF}- Da prodate firmino vozilo na otpad\n", sizeof(text));
    strcat(text, "{00FF00}/obcolor {FFFFFF}- Promjena boje firminog vozila\n\n", sizeof(text));
    strcat(text, "{33AAFF}FAKTURE ZA BIZNIS\n", sizeof(text));
    strcat(text, "{00FF00}/kupifakture {FFFFFF}- Kupovina od 1 do najvise 10 faktura odjednom\n", sizeof(text));
    strcat(text, "{00FF00}/keepingbizz [kolicina] {FFFFFF}- Ubacivanje vasih faktura u biznis\n", sizeof(text));
    strcat(text, "{33AAFF}Maksimum biznisa: {FFFFFF}100 faktura\n", sizeof(text));
    strcat(text, "{33AAFF}Potrosnja: {FFFFFF}1 faktura svakih 60 minuta", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_BIZZ_HELP, DIALOG_STYLE_MSGBOX, "{66CCFF}Komande za Biznise", text, "Nazad", "Zatvori");
    return 1;
}

stock ShowHouseHelp(playerid)
{
    new text[1024];
    strcat(text, "{00FF00}/buyhouse {FFFFFF}- Kupovina slobodne kuce\n", sizeof(text));
    strcat(text, "{00FF00}/sellhouse {FFFFFF}- Prodaja vlastite kuce\n", sizeof(text));
    strcat(text, "{00FF00}/lockhouse {FFFFFF}- Zakljucavanje vlastite kuce\n", sizeof(text));
    strcat(text, "{00FF00}/unlockhouse {FFFFFF}- Otkljucavanje vlastite kuce", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_HELP_HOUSE, DIALOG_STYLE_MSGBOX, "Pomoc - Kuce", text, "Nazad", "Zatvori");
    return 1;
}

stock ShowFactionHelp(playerid)
{
    new text[1792];
    strcat(text, "{00FF00}/orghelp {FFFFFF}- Detaljna pomoc za vasu organizaciju\n", sizeof(text));
    strcat(text, "{00FF00}/member {FFFFFF}- Pregled clanova organizacije\n", sizeof(text));
    strcat(text, "{00FF00}/f {FFFFFF}- Chat organizacije\n", sizeof(text));
    strcat(text, "{00FF00}/d {FFFFFF}- Chat drzavnih organizacija\n", sizeof(text));
    strcat(text, "{00FF00}/uninviteme {FFFFFF}- Samostalni izlazak iz organizacije\n\n", sizeof(text));
    strcat(text, "{FFFF00}Komande lidera\n", sizeof(text));
    strcat(text, "{00FF00}/invite {FFFFFF}- Pozivanje igraca u organizaciju\n", sizeof(text));
    strcat(text, "{00FF00}/uninvite {FFFFFF}- Izbacivanje clana\n", sizeof(text));
    strcat(text, "{00FF00}/kazniclana {FFFFFF}- Kaznjavanje clana organizacije\n", sizeof(text));
    strcat(text, "{00FF00}/giverank {FFFFFF}- Promjena ranka clana", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_HELP_FACTION, DIALOG_STYLE_MSGBOX, "Pomoc - Frakcije", text, "Nazad", "Zatvori");
    return 1;
}

stock ShowAdminHelp(playerid)
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    return ShowAH(playerid);
}

stock IsAntiSpamExempt(playerid)
{
    if(IsPlayerAdmin(playerid)) return 1;
    new name[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    if(!DOF2_FileExists(file)) return 0;
    return DOF2_GetInt(file, "Admin") > 0 || DOF2_GetInt(file, "Helper") > 0;
}

stock CheckPlayerAntiSpam(playerid)
{
    if(IsAntiSpamExempt(playerid)) return 1;
    new now = GetTickCount();
    if(LastAntiSpamTick[playerid] != 0 && now - LastAntiSpamTick[playerid] < ANTI_SPAM_DELAY_MS)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[ANTI SPAM] Sacekajte malo pre nego sto ponovo napisete poruku/komandu.");
        return 0;
    }
    LastAntiSpamTick[playerid] = now;
    return 1;
}

stock JuniorTeleport(playerid, Float:x, Float:y, Float:z, interior = 0, world = 0)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        SetVehicleVirtualWorld(vehicleid, world);
        LinkVehicleToInterior(vehicleid, interior);
        for(new p = 0; p < MAX_PLAYERS; p++) if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid))
        {
            SetPlayerInterior(p, interior);
            SetPlayerVirtualWorld(p, world);
        }
        SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
        SetVehiclePos(vehicleid, x, y, z);
        VehicleHudLastPosValid[vehicleid] = false;
    }
    else
    {
        if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
        SetPlayerInterior(playerid, interior);
        SetPlayerVirtualWorld(playerid, world);
        SetPlayerPos(playerid, x, y, z);
        SetCameraBehindPlayer(playerid);
    }
    return 1;
}

stock UpdateZlatoTD(playerid)
{
    new label[32];
    format(label, sizeof(label), "~y~ZLATO: %d", PlayerZlato[playerid]);
    PlayerTextDrawSetString(playerid, TD_Zlato[playerid], label);
    return 1;
}

stock UpdateBankaTD(playerid, amount)
{
    new label[32];
    format(label, sizeof(label), "~b~BANK: %d", amount);
    PlayerTextDrawSetString(playerid, TD_NovacPlavi[playerid], label);
    PlayerTextDrawShow(playerid, TD_NovacPlavi[playerid]);
    return 1;
}

stock IsRentVehicle(vehicleid)
{
    return vehicleid >= PrvoRentVozilo && vehicleid <= ZadnjeRentVozilo && PrvoRentVozilo > 0;
}

stock UpdateRentTextDraw(playerid)
{
    if(!RentPlayerVehicle[playerid]) return 0;
    new remaining = RentExpiresAt[playerid] - gettime();
    if(remaining < 0) remaining = 0;
    new label[64];
    if(RentBusinessId[playerid] >= 0)
        format(label, sizeof(label), "~y~BROD RENT: ~w~%02d:%02d", remaining / 60, remaining % 60);
    else
        format(label, sizeof(label), "~y~RENT: ~w~%02d:%02d", remaining / 60, remaining % 60);
    PlayerTextDrawSetString(playerid, RentTextDraw[playerid], label);
    return 1;
}

stock HasOpenedBankAccount(file[])
{
    return DOF2_IsSet(file, "BankovniRacun") && DOF2_GetInt(file, "BankovniRacun") > 0;
}

stock RegisterIpAlias(playerid, aliases[], size)
{
    aliases[0] = EOS;
    new ip[24], ipKey[32], playerName[MAX_PLAYER_NAME], file[128], originalName[MAX_PLAYER_NAME];
    GetPlayerIp(playerid, ip, sizeof(ip));
    GetPlayerName(playerid, playerName, sizeof(playerName));
    format(ipKey, sizeof(ipKey), "%s", ip);
    for(new i = 0; ipKey[i] != EOS; i++) if(ipKey[i] == '.') ipKey[i] = '_';
    format(file, sizeof(file), "Korisnici/%s.ini", playerName);
    if(DOF2_FileExists(file) && DOF2_IsSet(file, "NameOriginal"))
        format(originalName, sizeof(originalName), "%s", DOF2_GetString(file, "NameOriginal"));

    new registry[64] = "BalkanRP/Aliasi.ini", countKey[48], count;
    if(!DOF2_FileExists(registry)) DOF2_CreateFile(registry);
    format(countKey, sizeof(countKey), "IP_%s_Count", ipKey);
    count = DOF2_GetInt(registry, countKey);
    if(count < 0) count = 0;
    if(count > 20) count = 20;

    new bool:known = false, key[64], savedName[MAX_PLAYER_NAME];
    for(new i = 0; i < count; i++)
    {
        format(key, sizeof(key), "IP_%s_Name_%d", ipKey, i);
        format(savedName, sizeof(savedName), "%s", DOF2_GetString(registry, key));
        if(savedName[0] == EOS) continue;
        if(!strcmp(savedName, playerName, true)) known = true;
        if(!strcmp(savedName, playerName, true) || (originalName[0] != EOS && !strcmp(savedName, originalName, true))) continue;
        if(aliases[0] != EOS) strcat(aliases, ", ", size);
        strcat(aliases, savedName, size);
    }
    if(!known && count < 20)
    {
        format(key, sizeof(key), "IP_%s_Name_%d", ipKey, count);
        DOF2_SetString(registry, key, playerName);
        DOF2_SetInt(registry, countKey, count + 1);
        DOF2_SaveFile();
    }
    return 1;
}

stock SendPlayerConnectionInfo(playerid)
{
    new name[MAX_PLAYER_NAME], ip[24], aliases[256], message[384];
    GetPlayerName(playerid, name, sizeof(name));
    GetPlayerIp(playerid, ip, sizeof(ip));
    format(message, sizeof(message), "{9900CC}[INFO]: %s je usao na server.", name);
    for(new viewer = 0; viewer < MAX_PLAYERS; viewer++)
        if(IsPlayerConnected(viewer) && !HasAdminCommandAccess(viewer)) SendClientMessage(viewer, 0xC2A2DAFF, message);
    RegisterIpAlias(playerid, aliases, sizeof(aliases));
    if(aliases[0] != EOS)
        format(message, sizeof(message), "{9900CC}[INFO]: %s[%d] je usao na server (%s). (Alias: %s)", name, playerid, ip, aliases);
    else
        format(message, sizeof(message), "{9900CC}[INFO]: %s[%d] je usao na server (%s).", name, playerid, ip);
    for(new i = 0; i < MAX_PLAYERS; i++)
        if(IsPlayerConnected(i) && HasAdminCommandAccess(i)) SendClientMessage(i, 0xC2A2DAFF, message);
    return 1;
}

stock ContainsProfanity(const text[])
{
    new const badWords[][] = {"jeb", "jebo", "jebem", "jebes", "kurac", "kurva", "picka", "pi?ka", "pizda", "govno", "sranje", "mater", "majku", "retard", "idiot"};
    for(new i = 0; i < sizeof(badWords); i++) if(strfind(text, badWords[i], true) != -1) return 1;
    return 0;
}

stock ReportProfanity(playerid, const channel[], const text[])
{
    if(!ContainsProfanity(text)) return 0;
    new name[MAX_PLAYER_NAME], message[256];
    GetPlayerName(playerid, name, sizeof(name));
    format(message, sizeof(message), "[Chat: %s]: Igrac: [%s[%d]] > %s <!", channel, name, playerid, text);
    for(new i = 0; i < MAX_PLAYERS; i++)
        if(IsPlayerConnected(i) && HasAdminCommandAccess(i)) SendClientMessage(i, 0x33FF33FF, message);
    return 1;
}

stock GetChatCommandName(const cmdtext[], channel[], size)
{
    new command[24];
    if(sscanf(cmdtext, "s[24]", command)) return 0;
    if(!strcmp(command, "/b", true) || !strcmp(command, "/f", true) || !strcmp(command, "/d", true) ||
       !strcmp(command, "/g", true) || !strcmp(command, "/sms", true) || !strcmp(command, "/smsad", true) ||
       !strcmp(command, "/pm", true) || !strcmp(command, "/o", true) || !strcmp(command, "/pr", true) ||
       !strcmp(command, "/me", true) || !strcmp(command, "/do", true) || !strcmp(command, "/l", true) ||
       !strcmp(command, "/a", true) || !strcmp(command, "/h", true) || !strcmp(command, "/askq", true) ||
       !strcmp(command, "/report", true) || !strcmp(command, "/gov", true))
    {
        format(channel, size, "%s", command[1]);
        return 1;
    }
    return 0;
}

forward BrziPrstiTimer();
public BrziPrstiTimer()
{
    if(BrziPrstiActive) return 1;
    new const alphabet[] = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    for(new i = 0; i < 9; i++) BrziPrstiKod[i] = alphabet[random(sizeof(alphabet) - 1)];
    BrziPrstiKod[9] = EOS;
    BrziPrstiNagrada = 100 + random(401);
    BrziPrstiActive = true;
    new message[144];
    SendClientMessageToAll(0xFF6B35FF, "|============| BRZI PRSTI |============|");
    format(message, sizeof(message), "|- Ko prvi ukuca %s osvaja %d dinara !", BrziPrstiKod, BrziPrstiNagrada);
    SendClientMessageToAll(0xFF6B35FF, message);
    return 1;
}

stock CreateRentVehicleLabels()
{
    for(new vehicleid = PrvoRentVozilo; vehicleid <= ZadnjeRentVozilo; vehicleid++)
    {
        if(vehicleid <= 0 || GetVehicleModel(vehicleid) == 0) continue;
        RentVehicleLabel[vehicleid] = Create3DTextLabel("[RENT VOZILO]", 0x33CCFFFF, 0.0, 0.0, 0.0, 25.0, 0, 1);
        Attach3DTextLabelToVehicle(RentVehicleLabel[vehicleid], vehicleid, 0.0, 0.0, 0.4);
    }
    return 1;
}

stock UcitajBankuEksterijer()
{
    // BEogradska Banka Exterijer ByRile.txt
    new STREAMER_TAG_OBJECT:tmpobjid;
    tmpobjid = CreateDynamicObjectEx(18981, 1444.482299, -1021.299255, 18.236219, 0.000000, 0.000000, -90.000053, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000066);
    tmpobjid = CreateDynamicObjectEx(18981, 1469.381225, -1021.299255, 18.236219, 0.000000, 0.000000, -90.000053, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000066);
    tmpobjid = CreateDynamicObjectEx(18981, 1479.774291, -1021.309265, 18.236219, 0.000000, 0.000000, -90.000053, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF000066);
    tmpobjid = CreateDynamicObjectEx(18980, 1451.502441, -1021.316284, 18.216239, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF003300);
    tmpobjid = CreateDynamicObjectEx(18980, 1472.503784, -1021.326293, 18.216239, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF003300);
    tmpobjid = CreateDynamicObjectEx(18980, 1432.431518, -1021.306274, 18.216239, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF003300);
    tmpobjid = CreateDynamicObjectEx(18980, 1491.771240, -1021.316284, 18.216239, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF003300);
    tmpobjid = CreateDynamicObjectEx(18980, 1461.862670, -1021.240722, 31.109930, -89.899887, 2.500000, -87.400001, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF003300);
    tmpobjid = CreateDynamicObjectEx(4732, 1461.688720, -1021.811889, 29.368179, 0.000000, 0.000000, 145.200027, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "Banka Intesa", 80, "Calibri", 20, 0, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObjectEx(4732, 1442.134643, -1021.803405, 26.538185, 0.000000, 0.000000, 145.200027, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "KlIjenti nam vjeruju", 80, "Calibri", 20, 0, 0xFFFFFFFF, 0x00000000, 1);
    tmpobjid = CreateDynamicObjectEx(4732, 1481.715454, -1021.819763, 26.538185, 0.000000, 0.000000, 145.200027, 300.00, 300.00);
    SetDynamicObjectMaterialText(tmpobjid, 0, "Beogradska Banka", 80, "Calibri", 20, 0, 0xFFFFFFFF, 0x00000000, 1);
    return 1;
}

stock UcitajBGGranica()
{
    // BG SA Granica.txt
    new STREAMER_TAG_OBJECT:tmpobjid;
    tmpobjid = CreateDynamicObjectEx(18766, 1781.832031, 775.857666, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18980, 1777.371459, 777.835571, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18766, 1781.841674, 766.006530, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18766, 1781.830932, 770.937988, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18980, 1777.399169, 764.084838, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18766, 1791.829956, 766.007507, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18766, 1791.835571, 770.971740, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18766, 1791.842407, 775.891113, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18766, 1801.736328, 765.986816, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18766, 1801.731323, 770.909729, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18766, 1801.728149, 775.869689, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18766, 1809.286743, 766.026245, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18980, 1813.741821, 764.446838, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18766, 1809.305053, 770.966003, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18766, 1809.292724, 775.883544, 18.743200, 90.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF0099FF);
    tmpobjid = CreateDynamicObjectEx(18980, 1813.718383, 777.872802, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18980, 1794.016967, 777.680847, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18980, 1796.779174, 764.014709, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18980, 1797.638549, 777.696716, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18980, 1792.779663, 764.162292, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18980, 1780.402832, 764.020690, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18980, 1780.455566, 777.702941, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18980, 1810.493408, 777.845092, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(18980, 1810.349975, 764.276977, 6.589799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0xFF663333);
    tmpobjid = CreateDynamicObjectEx(19360, 1779.244628, 763.882202, 10.183696, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1779.244628, 763.882202, 13.213697, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1779.244628, 763.882202, 16.583700, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1779.045532, 777.640441, 12.323699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1779.059570, 777.605163, 15.723699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1779.059570, 777.605224, 16.603700, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1795.941528, 777.655212, 12.323699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1796.022827, 777.648315, 15.723699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1795.819702, 777.609497, 16.603700, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1811.834228, 777.953735, 12.323699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1812.077514, 777.949829, 15.723699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1812.250366, 777.939514, 16.603700, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1794.752441, 764.134094, 12.323699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1794.834716, 764.168212, 15.483699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1794.647216, 764.169128, 16.583700, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1812.275024, 764.227294, 12.323699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1812.433105, 764.223571, 15.483699, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1812.265502, 764.235656, 16.583700, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    tmpobjid = CreateDynamicObjectEx(19360, 1787.332031, 778.323364, 15.353708, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "Sarajevo Beograd ", 90, "Engravers MT", 20, 0, 0xFFFFFFFF, 0x00000000, 0);
    tmpobjid = CreateDynamicObjectEx(19360, 1803.882812, 763.572753, 15.353708, 0.000000, 0.000000, 90.000000, 300.00, 300.00);
    SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
    SetDynamicObjectMaterialText(tmpobjid, 0, "Beograd Sarajevo", 90, "Engravers MT", 20, 0, 0xFFFFFFFF, 0x00000000, 0);
    tmpobjid = CreateDynamicObjectEx(19425, 1798.892578, 764.138488, 11.176799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1802.176391, 764.113891, 11.176799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1805.461059, 764.117187, 11.176799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1808.668823, 764.106811, 11.176799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1790.681152, 764.053283, 11.176799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1787.412475, 764.053833, 11.176799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1784.100830, 764.068908, 11.176799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1782.387817, 764.058898, 11.176799, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1808.384277, 777.694519, 10.696800, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1805.105834, 777.693847, 10.696800, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1801.804931, 777.697021, 10.696800, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1799.225341, 777.695556, 10.696800, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1791.870727, 777.614074, 10.736800, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1788.669433, 777.600219, 10.736800, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1785.427490, 777.614624, 10.736800, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19425, 1782.623901, 777.611328, 10.736800, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19087, 1790.906738, 778.288146, 19.206699, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(4641, 1793.037109, 769.681213, 12.622599, 0.000000, 0.000000, -2.500011, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(4641, 1796.872070, 770.830932, 12.622599, 0.000000, 0.000000, -7.900012, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19428, 1789.229980, 778.288146, 16.875600, 90.000000, 0.000000, 90.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19428, 1785.808715, 778.304443, 16.875600, 90.000000, 0.000000, 90.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19087, 1784.227050, 778.298278, 19.206699, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19087, 1800.230590, 763.594177, 19.206699, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19428, 1801.892211, 763.580688, 16.875600, 90.000000, 0.000000, 90.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19428, 1805.320800, 763.575683, 16.875600, 90.000000, 0.000000, 90.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19087, 1806.919555, 763.583068, 19.206699, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1791.344238, 768.285949, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1799.092895, 771.657714, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(966, 1807.285034, 771.876770, 10.896140, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    PutarinaRampa[1] = CreateDynamicObjectEx(968, 1807.372436, 771.869384, 11.628600, 0.000000, -90.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1810.454467, 765.818481, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1810.494995, 767.225891, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1810.615356, 768.749023, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1810.526489, 770.540100, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1810.270141, 771.938659, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1809.098022, 771.915588, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1810.471313, 773.792480, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1810.460937, 775.831665, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(966, 1790.313110, 768.756225, 11.036100, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    PutarinaRampa[0] = CreateDynamicObjectEx(968, 1790.364135, 768.771240, 11.768600, 0.000000, -90.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1782.356567, 769.072875, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1780.829223, 769.020935, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1780.594360, 767.378845, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1780.498901, 765.593078, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1780.838867, 770.825805, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1780.985107, 772.674804, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1781.097900, 774.699340, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1781.235595, 776.300842, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1776.311645, 763.752502, 11.260999, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1814.453857, 779.669311, 10.630993, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(1237, 1808.077514, 771.915588, 11.001000, 0.000000, 0.000000, 0.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(18880, 1780.312988, 778.640930, 10.686400, 0.000000, 0.000000, -185.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(18880, 1796.960327, 778.611022, 10.686400, 0.000000, 0.000000, -185.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(18880, 1810.913330, 779.156311, 10.686400, 0.000000, 0.000000, -185.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(18880, 1810.675170, 763.043579, 10.686400, 0.000000, 0.000000, -4.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(18880, 1796.074340, 762.432373, 10.686400, 0.000000, 0.000000, -4.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(18880, 1780.014770, 762.542602, 10.686400, 0.000000, 0.000000, -4.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(5820, 1774.042114, 768.536682, 14.313500, 0.000000, 0.000000, -90.000000, 300.00, 300.00);
    tmpobjid = CreateDynamicObjectEx(19360, 1777.258178, 765.842285, 18.183700, 0.000000, 109.000000, 178.000000, 300.00, 300.00);
    return 1;
}

forward PutarinaTick();
public PutarinaTick()
{
    for(new gate = 0; gate < 2; gate++)
    {
        if(!IsValidDynamicObject(PutarinaRampa[gate])) continue;
        if(PutarinaStanje[gate] == 1 || PutarinaStanje[gate] == 3)
        {
            if(PutarinaStanje[gate] == 1) PutarinaKorak[gate]++;
            else PutarinaKorak[gate]--;
            SetDynamicObjectRot(PutarinaRampa[gate], 0.0, -90.0 + float(PutarinaKorak[gate]) * 5.0, 0.0);
            if(PutarinaKorak[gate] >= 18)
            {
                PutarinaKorak[gate] = 18;
                PutarinaStanje[gate] = 2;
                PutarinaOtvorenaDo[gate] = gettime() + 15;
            }
            else if(PutarinaKorak[gate] <= 0)
            {
                PutarinaKorak[gate] = 0;
                PutarinaStanje[gate] = 0;
            }
        }
        else if(PutarinaStanje[gate] == 2 && gettime() >= PutarinaOtvorenaDo[gate])
        {
            new bool:voziloKodRampe = false;
            new Float:x = gate == 0 ? 1790.364135 : 1807.372436;
            new Float:y = gate == 0 ? 768.771240 : 771.869384;
            for(new p = 0; p < MAX_PLAYERS; p++)
            {
                if(IsPlayerConnected(p) && IsPlayerInAnyVehicle(p) &&
                   GetPlayerInterior(p) == 0 && GetPlayerVirtualWorld(p) == 0 &&
                   IsPlayerInRangeOfPoint(p, 6.0, x, y, 11.8))
                {
                    voziloKodRampe = true;
                    break;
                }
            }
            if(!voziloKodRampe) PutarinaStanje[gate] = 3;
        }
    }
    return 1;
}

CMD:platiputarinu(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xFF7777FF, "[PUTARINA]: Morate biti u vozilu.");
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[PUTARINA]: Niste kod granice.");
    new gate = -1;
    if(IsPlayerInRangeOfPoint(playerid, 6.0, 1787.20605468, 770.88598632, 11.96806526)) gate = 0;
    else if(IsPlayerInRangeOfPoint(playerid, 6.0, 1803.46044921, 769.75775146, 11.97515678)) gate = 1;
    if(gate == -1)
        return SendClientMessage(playerid, 0xFF7777FF, "[PUTARINA]: Priblizite se rampi na granici.");
    if(!IsValidDynamicObject(PutarinaRampa[gate]))
        return SendClientMessage(playerid, 0xFF7777FF, "[PUTARINA]: Rampa trenutno nije dostupna.");
    if(PutarinaStanje[gate] != 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[PUTARINA]: Rampa je vec otvorena ili se pomjera.");
    if(GetPlayerMoney(playerid) < PUTARINA_CIJENA)
        return SendClientMessage(playerid, 0xFF7777FF, "[PUTARINA]: Nemate dovoljno RSD za putarinu.");

    GivePlayerMoney(playerid, -PUTARINA_CIJENA);
    PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
    new ime[MAX_PLAYER_NAME], file[128], poruka[128];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
        DOF2_SaveFile();
    }
    PutarinaStanje[gate] = 1;
    format(poruka, sizeof(poruka), "[PUTARINA]: Platili ste %d RSD. Rampa se dize; imate 15 sekundi za prolaz.", PUTARINA_CIJENA);
    SendClientMessage(playerid, 0x33CCFFFF, poruka);
    return 1;
}

CMD:otvoriracun(playerid, params[])
{
    #pragma unused params
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Prvo se prijavite na nalog.");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 124.23156738, 1693.66345214, -0.85856127) ||
       GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Morate biti na salteru za otvaranje racuna.");

    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file)))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Vas korisnicki nalog nije pronaden.");
    if(HasOpenedBankAccount(file))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Vec imate otvoren bankovni racun.");

    DOF2_SetInt(file, "BankovniRacun", 1);
    if(!DOF2_IsSet(file, "Banka")) DOF2_SetInt(file, "Banka", 0);
    DOF2_SaveFile();
    SendClientMessage(playerid, 0x33CCFFFF, "[BANKA]: Uspjesno ste otvorili bankovni racun.");
    return 1;
}

public OnGameModeInit()
{
    // Health sada kontrolise HealthSystemTick: zdravi -1/10 min, bolesni -2/min.
    SetTimer("TajmerZaMinute", 60000, true); // 60000 ms = 1 minuta
    SetTimer("GlobalniPayDay", 3600000, true);
    SetTimer("BrziPrstiTimer", 300000, true);
    SetTimer("ServerTipsTimer", 300000, true);
    SetTimer("CheckTemporaryNames", 60000, true);
    SetTimer("RentTick", 1000, true);
    SetTimer("UpdateLocationDisplays", 2000, true);
    SetTimer("UpdateVehicleHud", 500, true);
    SetTimer("UpdateVehicleSpeed", 150, true);
    SetTimer("JuniorAdminTick", 1000, true);
    SetTimer("HealthSystemTick", 60000, true);
    SetTimer("BusinessInvoiceTick", 3600000, true);
    OffshoreFishingZone = GangZoneCreate(OFFSHORE_MIN_X, OFFSHORE_MIN_Y, OFFSHORE_MAX_X, OFFSHORE_MAX_Y);
    if(DOF2_FileExists(STATS_SETTINGS_FILE))
    {
        HappyHourMultiplier = DOF2_GetInt(STATS_SETTINGS_FILE, "HappyHourMultiplier");
        if(HappyHourMultiplier != 2)
            HappyHourMultiplier = 1;
        HappyJobId = DOF2_GetInt(STATS_SETTINGS_FILE, "HappyJobId");
        if(HappyJobId < 1 || HappyJobId > JOB_RIBOLOVAC) HappyJobId = 0;
    }
    AddPlayerClass(0, 1685.8652, -2331.2102, 13.5469, 90.2917, 0, 0, 0, 0, 0, 0);
    CallLocalFunction("InitRevolutionHud", "");
    CallLocalFunction("UpdateHudTip", "i", random(29));
    SetGameModeText("Balkan Revolution RP");
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF); // Bez kvadratica igraca na radaru/mapi.
    EnableStuntBonusForAll(0); // Bez stunt bonusa i njihovih poruka.
    UcitajServerMape();     // Ucitava objekte/mape iz Mape.inc
    if(DOF2_FileExists(BANK_ROBBERY_FILE))
    {
        BankRobberyCooldownUntil = DOF2_GetInt(BANK_ROBBERY_FILE, "CooldownUntil");
        if(BankRobberyCooldownUntil > gettime()) BankHackCooldownUntil = BankRobberyCooldownUntil;
    }
    SetTimer("BankHackTick", 1000, true);
    CreateDynamic3DTextLabel("{FF4444}BEOGRADSKA BANKA{FFFFFF}\n/iskljucilasere - hakovanje sistema", 0xFFFFFFFF, 117.7143, 1689.2194, -12.4302, 12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    CreateDynamic3DTextLabel("{FF4444}TREZOR{FFFFFF}\n/postavidinamit", 0xFFFFFFFF, 116.2238, 1710.0984, -12.5103, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    CreateDynamic3DTextLabel("{33CCFF}NOVAC BANKE{FFFFFF}\n/robbank", 0xFFFFFFFF, 116.3219, 1725.2919, -12.6224, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    UcitajBankuEksterijer(); // Spoljasnja mapa banke
    UcitajBGGranica(); // Granica Beograd - Sarajevo
    SetTimer("PutarinaTick", 200, true);
    CreateDynamic3DTextLabel("{33CCFF}/platiputarinu{FFFFFF}", 0xFFFFFFFF, 1787.20605468, 770.88598632, 11.96806526, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    CreateDynamic3DTextLabel("{33CCFF}/platiputarinu{FFFFFF}", 0xFFFFFFFF, 1803.46044921, 769.75775146, 11.97515678, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    CreateDynamic3DTextLabel("{33CCFF}BANKA{FFFFFF}\nDa udete u Banku pritisnite F", 0xFFFFFFFF, 1462.90759277, -1022.80725097, 24.53310317, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    CreateDynamic3DTextLabel("{33CCFF}Izlaz iz Banke{FFFFFF}\nPritisnite F", 0xFFFFFFFF, 153.79109191, 1702.71630859, -0.15856175, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    CreateDynamic3DTextLabel("{33CCFF}OTVARANJE RACUNA{FFFFFF}\nDa otvorite racun kucaj /otvoriracun", 0xFFFFFFFF, 124.23156738, 1693.66345214, -0.85856127, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    UcitajVozilaServera();  // Ucitava vozila i motore iz Vozila.inc
    CreateRentVehicleLabels();
    CallLocalFunction("LoadAdminParkedVehicles", "");
    CallLocalFunction("UcitajOglase", "");
    CallLocalFunction("UcitajZlataru", ""); // <--- OVDE DODAJ Ovu liniju!
    CallLocalFunction("UcitajTrafike", "");
    UcitajSlobodneObjekte();
    CallLocalFunction("UcitajLabele", "");
    CallLocalFunction("LoadHouses", ""); // <--- DODAJ OVU LINIJU OVDE!
    InitParkingServisVozila();
    CallLocalFunction("CheckTemporaryNames", "");
    LoadServerNpcs();
    
    kapija_parking = CreateObject(980, 1022.08948, -927.09814, 43.73440, 0.00000, 0.00000, 98.00000);

    // --- UCITAVANJE KREIRANIH CUSTOM LABELA (TRAFIKA) ---
    for(new i = 0; i < MAX_CUSTOM_LABELS; i++)
    {
        new path[64];
        format(path, sizeof(path), "BalkanRP/CustomLabels/label_%d.ini", i);
        if(DOF2_FileExists(path))
        {
            CustomLabelX[i] = DOF2_GetFloat(path, "X");
            CustomLabelY[i] = DOF2_GetFloat(path, "Y");
            CustomLabelZ[i] = DOF2_GetFloat(path, "Z");
            format(CustomLabelNaziv[i], 32, "%s", DOF2_GetString(path, "Naziv"));

            PickupCustom[i] = CreateDynamicPickup(1239, 23, CustomLabelX[i], CustomLabelY[i], CustomLabelZ[i], 0);

            new string[128];
            format(string, sizeof(string), "{FFFFFF}%s\n{FFFFFF}Da kupite proizvode na trafici kucajte {FF0000}/trafika", CustomLabelNaziv[i]);
            LabelCustom[i] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, CustomLabelX[i], CustomLabelY[i], CustomLabelZ[i]+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
        }
    }
    // ----------------------------------------------------

    // --- UCITAVANJE KUCA I KREIRANJE LABELA/PIKUPA ---
    for(new h = 0; h < MAX_KUCA; h++)
    {
        new file[64];
        format(file, sizeof(file), "BalkanRP/Kuce/kuca_%d.ini", h);

        if(DOF2_FileExists(file))
        {
            HouseInfo[h][kEntranceX] = DOF2_GetFloat(file, "EntranceX");
            HouseInfo[h][kEntranceY] = DOF2_GetFloat(file, "EntranceY");
            HouseInfo[h][kEntranceZ] = DOF2_GetFloat(file, "EntranceZ");

            HouseInfo[h][kExitX]     = DOF2_GetFloat(file, "ExitX");
            HouseInfo[h][kExitY]     = DOF2_GetFloat(file, "ExitY");
            HouseInfo[h][kExitZ]     = DOF2_GetFloat(file, "ExitZ");
            HouseInfo[h][kInterior]  = DOF2_GetInt(file, "Interior");
            HouseInfo[h][kLocked]    = DOF2_GetInt(file, "Locked");
            HouseInfo[h][kCena]      = DOF2_GetInt(file, "Cena");
            HouseInfo[h][kLevel]     = DOF2_GetInt(file, "Level");
            HouseInfo[h][kOwned]     = DOF2_GetInt(file, "Owned");

            format(HouseInfo[h][kOwner], MAX_PLAYER_NAME, "%s", DOF2_GetString(file, "Owner"));

            UpdateHouseCP(h);
        }
    }
    // ------------------------------------------------

    // --- UCITAVANJE MARKETA I KREIRANJE LABELA/PIKUPA ---
    for(new m = 0; m < MAX_MARKETA; m++)
    {
        new file[64];
        format(file, sizeof(file), "BalkanRP/Marketi/market_%d.ini", m);

        if(DOF2_FileExists(file))
        {
            new bool:businessDataNeedsSave = false;
            MarketInfo[m][mOwned] = DOF2_GetInt(file, "Owned") == 1;
            new businessDataVersion = DOF2_IsSet(file, "BusinessDataVersion") ? DOF2_GetInt(file, "BusinessDataVersion") : 0;
            if(DOF2_IsSet(file, "BusinessType"))
            {
                // Format koji su koristile ranije faze reworka (BusinessDataVersion do 8).
                MarketInfo[m][mType] = DOF2_GetInt(file, "BusinessType");
                MarketInfo[m][mJobId] = DOF2_IsSet(file, "BusinessJobID") ? DOF2_GetInt(file, "BusinessJobID") : JOB_NONE;
            }
            else if(DOF2_IsSet(file, "Type"))
            {
                new savedType = DOF2_GetInt(file, "Type");
                if(businessDataVersion >= 2)
                {
                    MarketInfo[m][mType] = savedType;
                    MarketInfo[m][mJobId] = DOF2_IsSet(file, "JobId") ? DOF2_GetInt(file, "JobId") : JOB_NONE;
                }
                else
                {
                    // Najstariji format: Type 0 je Market, a Type 1 je job business.
                    MarketInfo[m][mType] = (savedType == 1) ? BIZ_TYPE_JOB : BIZ_TYPE_MARKET;
                    MarketInfo[m][mJobId] = DOF2_IsSet(file, "JobId") ? DOF2_GetInt(file, "JobId") : JOB_NONE;
                }
            }
            else
            {
                MarketInfo[m][mType] = BIZ_TYPE_MARKET;
                MarketInfo[m][mJobId] = JOB_NONE;
            }
            if(MarketInfo[m][mType] < BIZ_TYPE_MARKET || MarketInfo[m][mType] > MAX_BUSINESS_TYPE)
            {
                MarketInfo[m][mType] = BIZ_TYPE_MARKET;
                MarketInfo[m][mJobId] = JOB_NONE;
                businessDataNeedsSave = true;
            }
            if(MarketInfo[m][mType] != BIZ_TYPE_JOB) MarketInfo[m][mJobId] = JOB_NONE;
            else if(MarketInfo[m][mJobId] < JOB_CISTAC_ULICA || MarketInfo[m][mJobId] > JOB_RIBOLOVAC)
            {
                MarketInfo[m][mJobId] = JOB_NONE;
                businessDataNeedsSave = true;
            }
            if(DOF2_IsSet(file, "Owner")) format(MarketInfo[m][mOwner], MAX_PLAYER_NAME, "%s", DOF2_GetString(file, "Owner"));
            else format(MarketInfo[m][mOwner], MAX_PLAYER_NAME, "Nitko");
            if(DOF2_IsSet(file, "CoOwner")) format(BusinessCoOwner[m], MAX_PLAYER_NAME, "%s", DOF2_GetString(file, "CoOwner"));
            else format(BusinessCoOwner[m], MAX_PLAYER_NAME, "Nema");
            if(!strlen(MarketInfo[m][mOwner]) || !strcmp(MarketInfo[m][mOwner], "Nema", true))
                format(MarketInfo[m][mOwner], MAX_PLAYER_NAME, "Nitko");
            if(!strlen(BusinessCoOwner[m]) || !strcmp(BusinessCoOwner[m], "Nitko", true))
                format(BusinessCoOwner[m], MAX_PLAYER_NAME, "Nema");
            if(!strcmp(MarketInfo[m][mOwner], "Nitko", true)) MarketInfo[m][mOwned] = 0;
            if(!MarketInfo[m][mOwned])
            {
                format(MarketInfo[m][mOwner], MAX_PLAYER_NAME, "Nitko");
                format(BusinessCoOwner[m], MAX_PLAYER_NAME, "Nema");
            }
            format(MarketInfo[m][mNaziv], 32, "%s", DOF2_GetString(file, "Naziv"));
            if(DOF2_IsSet(file, "Opis")) format(MarketInfo[m][mOpis], 64, "%s", DOF2_GetString(file, "Opis"));
            else format(MarketInfo[m][mOpis], 64, "Nema opisa");
            MarketInfo[m][mIznuda] = DOF2_IsSet(file, "Iznuda") ? DOF2_GetInt(file, "Iznuda") : 0;
            MarketInfo[m][mFakture] = DOF2_IsSet(file, "Fakture") ? DOF2_GetInt(file, "Fakture") : 0;
            if(MarketInfo[m][mFakture] < 0) MarketInfo[m][mFakture] = 0;
            if(MarketInfo[m][mFakture] > MAX_BUSINESS_INVOICES) MarketInfo[m][mFakture] = MAX_BUSINESS_INVOICES;
            MarketInfo[m][mBizVehicleModel] = DOF2_IsSet(file, "BizVehicleModel") ? DOF2_GetInt(file, "BizVehicleModel") : 0;
            MarketInfo[m][mBizVehicleColor1] = DOF2_GetInt(file, "BizVehicleColor1");
            MarketInfo[m][mBizVehicleColor2] = DOF2_GetInt(file, "BizVehicleColor2");
            MarketInfo[m][mBizVehicleX] = DOF2_GetFloat(file, "BizVehicleX");
            MarketInfo[m][mBizVehicleY] = DOF2_GetFloat(file, "BizVehicleY");
            MarketInfo[m][mBizVehicleZ] = DOF2_GetFloat(file, "BizVehicleZ");
            MarketInfo[m][mBizVehicleA] = DOF2_GetFloat(file, "BizVehicleA");
            MarketInfo[m][mBizVehicleId] = 0;
            for(new slot = 0; slot < MAX_BUSINESS_VEHICLES; slot++)
            {
                new key[40];
                format(key, sizeof(key), "BusinessVehicleModel%d", slot);
                BusinessVehicleModel[m][slot] = DOF2_IsSet(file, key) ? DOF2_GetInt(file, key) : 0;
                format(key, sizeof(key), "BusinessVehicleColor1%d", slot); BusinessVehicleColor1[m][slot] = DOF2_GetInt(file, key);
                format(key, sizeof(key), "BusinessVehicleColor2%d", slot); BusinessVehicleColor2[m][slot] = DOF2_GetInt(file, key);
                format(key, sizeof(key), "BusinessVehicleX%d", slot); BusinessVehicleX[m][slot] = DOF2_GetFloat(file, key);
                format(key, sizeof(key), "BusinessVehicleY%d", slot); BusinessVehicleY[m][slot] = DOF2_GetFloat(file, key);
                format(key, sizeof(key), "BusinessVehicleZ%d", slot); BusinessVehicleZ[m][slot] = DOF2_GetFloat(file, key);
                format(key, sizeof(key), "BusinessVehicleA%d", slot); BusinessVehicleA[m][slot] = DOF2_GetFloat(file, key);
                format(key, sizeof(key), "BusinessVehicleRentPrice%d", slot);
                BusinessVehicleRentPrice[m][slot] = DOF2_IsSet(file, key) ? DOF2_GetInt(file, key) : 5000;
                format(key, sizeof(key), "BusinessVehicleRentMinutes%d", slot);
                BusinessVehicleRentMinutes[m][slot] = DOF2_IsSet(file, key) ? DOF2_GetInt(file, key) : 20;
                if(BusinessVehicleModel[m][slot] < 400 || BusinessVehicleModel[m][slot] > 611)
                    BusinessVehicleModel[m][slot] = 0;
                if(BusinessVehicleRentPrice[m][slot] < 1 || BusinessVehicleRentPrice[m][slot] > 1000000)
                    BusinessVehicleRentPrice[m][slot] = 5000;
                if(BusinessVehicleRentMinutes[m][slot] < FISHING_BOAT_RENT_MIN_MINUTES || BusinessVehicleRentMinutes[m][slot] > FISHING_BOAT_RENT_MAX_MINUTES)
                    BusinessVehicleRentMinutes[m][slot] = 20;
                BusinessVehicleId[m][slot] = 0;
                if(MarketInfo[m][mType] == BIZ_TYPE_JOB && MarketInfo[m][mJobId] == JOB_RIBOLOVAC && BusinessVehicleModel[m][slot] == FISHING_BOAT_MODEL)
                {
                    BusinessVehicleColor1[m][slot] = 56;
                    BusinessVehicleColor2[m][slot] = 56;
                    BusinessVehicleX[m][slot] = FishingBoatSlotPos[slot][0];
                    BusinessVehicleY[m][slot] = FishingBoatSlotPos[slot][1];
                    BusinessVehicleZ[m][slot] = FishingBoatSlotPos[slot][2];
                    BusinessVehicleA[m][slot] = FishingBoatSlotPos[slot][3];
                }
            }
            // Jednokratna kompatibilnost sa starim jednim firminim vozilom.
            if(BusinessVehicleModel[m][0] == 0 && MarketInfo[m][mBizVehicleModel] >= 400)
            {
                BusinessVehicleModel[m][0] = MarketInfo[m][mBizVehicleModel];
                BusinessVehicleColor1[m][0] = MarketInfo[m][mBizVehicleColor1];
                BusinessVehicleColor2[m][0] = MarketInfo[m][mBizVehicleColor2];
                BusinessVehicleX[m][0] = MarketInfo[m][mBizVehicleX];
                BusinessVehicleY[m][0] = MarketInfo[m][mBizVehicleY];
                BusinessVehicleZ[m][0] = MarketInfo[m][mBizVehicleZ];
                BusinessVehicleA[m][0] = MarketInfo[m][mBizVehicleA];
            }
            if(MarketInfo[m][mType] == BIZ_TYPE_JOB && MarketInfo[m][mJobId] == JOB_RIBOLOVAC && BusinessVehicleModel[m][0] == FISHING_BOAT_MODEL)
            {
                BusinessVehicleColor1[m][0] = 56;
                BusinessVehicleColor2[m][0] = 56;
                BusinessVehicleX[m][0] = FishingBoatSlotPos[0][0];
                BusinessVehicleY[m][0] = FishingBoatSlotPos[0][1];
                BusinessVehicleZ[m][0] = FishingBoatSlotPos[0][2];
                BusinessVehicleA[m][0] = FishingBoatSlotPos[0][3];
            }

            MarketInfo[m][mEntranceX] = DOF2_GetFloat(file, "EntranceX");
            MarketInfo[m][mEntranceY] = DOF2_GetFloat(file, "EntranceY");
            MarketInfo[m][mEntranceZ] = DOF2_GetFloat(file, "EntranceZ");

            MarketInfo[m][mExitX] = DOF2_GetFloat(file, "ExitX");
            MarketInfo[m][mExitY] = DOF2_GetFloat(file, "ExitY");
            MarketInfo[m][mExitZ] = DOF2_GetFloat(file, "ExitZ");

            MarketInfo[m][mInterior] = DOF2_GetInt(file, "Interior");
            MarketInfo[m][mCena] = DOF2_GetInt(file, "Cena");
            MarketInfo[m][mLevel] = DOF2_GetInt(file, "Level");
            if(MarketInfo[m][mCena] < 0) MarketInfo[m][mCena] = 0;
            if(MarketInfo[m][mLevel] < 1) MarketInfo[m][mLevel] = 1;
            MarketInfo[m][mUlaznaCena] = DOF2_IsSet(file, "UlaznaCena") ? DOF2_GetInt(file, "UlaznaCena") : 0;
            if(MarketInfo[m][mUlaznaCena] < 0) MarketInfo[m][mUlaznaCena] = 0;
            if(MarketInfo[m][mUlaznaCena] > MAX_BUSINESS_ENTRANCE_FEE) MarketInfo[m][mUlaznaCena] = MAX_BUSINESS_ENTRANCE_FEE;
            MarketInfo[m][mBudzet] = DOF2_IsSet(file, "Budzet") ? DOF2_GetInt(file, "Budzet") : 0;
            if(MarketInfo[m][mBudzet] < 0) MarketInfo[m][mBudzet] = 0;
            MarketInfo[m][mProizvodi] = DOF2_IsSet(file, "Proizvodi") ? DOF2_GetInt(file, "Proizvodi") : (CanBusinessUseProducts(m) ? 100 : 0);
            MarketInfo[m][mCenaProizvoda] = DOF2_IsSet(file, "CenaProizvoda") ? DOF2_GetInt(file, "CenaProizvoda") : 100;
            if(MarketInfo[m][mProizvodi] < 0) MarketInfo[m][mProizvodi] = 0;
            if(MarketInfo[m][mProizvodi] > MAX_BUSINESS_PRODUCTS) MarketInfo[m][mProizvodi] = MAX_BUSINESS_PRODUCTS;
            if(MarketInfo[m][mCenaProizvoda] < 1 || MarketInfo[m][mCenaProizvoda] > 100000) MarketInfo[m][mCenaProizvoda] = 100;
            for(new bait = 0; bait < MAX_RIBOLOVAC_MAMACA; bait++)
            {
                new key[32], legacyKey[32];
                format(key, sizeof(key), "BaitPrice%d", bait);
                format(legacyKey, sizeof(legacyKey), "FishingBaitPrice%d", bait);
                if(DOF2_IsSet(file, key)) BusinessBaitPrice[m][bait] = DOF2_GetInt(file, key);
                else if(DOF2_IsSet(file, legacyKey)) BusinessBaitPrice[m][bait] = DOF2_GetInt(file, legacyKey);
                else BusinessBaitPrice[m][bait] = RibolovacMamacCijena[bait];
                format(key, sizeof(key), "BaitAmount%d", bait);
                format(legacyKey, sizeof(legacyKey), "FishingBaitAmount%d", bait);
                if(DOF2_IsSet(file, key)) BusinessBaitAmount[m][bait] = DOF2_GetInt(file, key);
                else if(DOF2_IsSet(file, legacyKey)) BusinessBaitAmount[m][bait] = DOF2_GetInt(file, legacyKey);
                else BusinessBaitAmount[m][bait] = 5;
                if(BusinessBaitPrice[m][bait] < 1 || BusinessBaitPrice[m][bait] > 100000)
                    BusinessBaitPrice[m][bait] = RibolovacMamacCijena[bait];
                if(BusinessBaitAmount[m][bait] < 1 || BusinessBaitAmount[m][bait] > 100)
                    BusinessBaitAmount[m][bait] = 5;
            }
            if(DOF2_IsSet(file, "BeginnerRodPrice")) BusinessRodPrice[m][0] = DOF2_GetInt(file, "BeginnerRodPrice");
            else if(DOF2_IsSet(file, "FishingRodPrice1")) BusinessRodPrice[m][0] = DOF2_GetInt(file, "FishingRodPrice1");
            else BusinessRodPrice[m][0] = 500;
            if(DOF2_IsSet(file, "ProfessionalRodPrice")) BusinessRodPrice[m][1] = DOF2_GetInt(file, "ProfessionalRodPrice");
            else if(DOF2_IsSet(file, "FishingRodPrice2")) BusinessRodPrice[m][1] = DOF2_GetInt(file, "FishingRodPrice2");
            else BusinessRodPrice[m][1] = 15000;
            if(BusinessRodPrice[m][0] < 1 || BusinessRodPrice[m][0] > 1000000) BusinessRodPrice[m][0] = 500;
            if(BusinessRodPrice[m][1] < 1 || BusinessRodPrice[m][1] > 1000000) BusinessRodPrice[m][1] = 15000;

            MarketInfo[m][mLabel] = Text3D:INVALID_3DTEXT_ID;
            MarketInfo[m][mPickup] = 0;
            UpdateMarketCP(m);
            LoadBusinessVehicle(m);
            if(businessDataVersion < BUSINESS_DATA_VERSION || businessDataNeedsSave) SaveMarket(m);
        }
    }
    // ---------------------------------------------------

    // --- DODANE LOKACIJE ZA TELEFON I GIGATRON ---

    // 1. Mjesto za kupovinu telefona
    Create3DTextLabel("Kupi telefon\nKucaj: /kupitelefon", 0x00BFFFFF, -537.5564, 2589.3081, 10.9875, 20.0, 0, 0);
    CreatePickup(1239, 23, -537.5564, 2589.3081, 10.9875, 0);

    // 2. Unutra?njost / Izlaz iz Gigatrona
    Create3DTextLabel("Pritisni 'F' za izlazak iz Gigatrona", 0xFFFF00FF, -540.8716, 2596.0989, 10.9875, 20.0, 0, 0);
    CreatePickup(1318, 23, -540.8716, 2596.0989, 10.9875, 0);

    // 3. Glavni ulaz u Gigatron
    Create3DTextLabel("Pritisni 'F' za ulazak u Gigatron", 0xFFFF00FF, 1412.1534, -1700.0010, 13.5395, 20.0, 0, 0);
    CreatePickup(1318, 23, 1412.1534, -1700.0010, 13.5395, 0);

    // Kreiranje 3D Text Labele na tvojim koordinatama (-526.6230, 2595.7686, 10.9875)
    Create3DTextLabel("{00BFFF}Gigatron / Prodaja Telefona\n{FFFFFF}Kucaj {FF0000}/kupibrojtel {FFFFFF}da kupite broj telefona!", 0x00BFFFFFFF, -526.6230, 2595.7686, 10.9875, 20.0, 0, 0);

    AddStaticPickup(1239, 2, -526.6230, 2595.7686, 10.9875, 0);
    Create3DTextLabel("{00BFFF}Gigatron / Kupovina Slu?alica\n{FFFFFF}Kucaj {FF0000}/kupislusalice {FFFFFF}da kupite slu?alice!", 0x00BFFFFFFF, -530.8458, 2603.3523, 10.9875, 20.0, 0, 0);

	// Labeli sa ispravnim enterijerom (10 umjesto 17)
    CreateDynamic3DTextLabel("{00FF00}PRODAVNICA\n{FFFFFF}Kucaj: /kupi", 0xFFFFFFFF, 2.4111, -28.4906, 1003.5494, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 10);

    CreateDynamic3DTextLabel("{00FF00}NAMIRNICE\n{FFFFFF}Kucaj: /buyinventory", 0xFFFFFFFF, 7.0822, -22.7557, 1003.5494, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 10);
    // ----------------------------------------------
    // 1. Label za kupovinu zlata
	CreateDynamic3DTextLabel("{00C0FF}Za kupovinu zlata kucajte:\n{FFFFFF}/kupizlato", 0xFFFFFEFF, 603.5775, -1503.2429, 2.7801, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 0, -1);

	// 2. Label za prodaju zlata
	CreateDynamic3DTextLabel("{00C0FF}Za prodaju zlata kucajte:\n{FFFFFF}/prodajzlato", 0xFFFFFEFF, 601.5987, -1506.8588, 2.7801, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 0, -1);

	// 3. Label za kupovinu sata
	CreateDynamic3DTextLabel("{00C0FF}Za kupovinu sata kucajte:\n{FFFFFF}/kupisat", 0xFFFFFEFF, 602.4924, -1519.7023, 2.7801, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, 0, -1);
	
	// Ulaz u Op?tinu (Ispred zgrade)
    CreatePickup(1239, 1, 1481.0885, -1771.9858, 18.7958, 0);
    Create3DTextLabel("Gradska Op?tina\n{FFFFFF}Da udete u gradsku op?tinu pritisnite {FFFF00}'F'", 0x00BFFFFF, 1481.0885, -1771.9858, 18.7958 + 0.5, 15.0, 0, 0);

    // Izlaz iz Op?tine (Unutar enterijera ID: 3)
    CreatePickup(1239, 1, 386.52, 173.63, 1008.38, 0);
    Create3DTextLabel("Izlaz\n{FFFFFF}Pritisnite {FFFF00}'F' {FFFFFF}da izadete", 0x00BFFFFF, 386.52, 173.63, 1008.38 + 0.5, 15.0, 0, 0);

	// Ubaci ovo unutar public OnGameModeInit()
	Create3DTextLabel("{FFFF00}Parking Servis\n{FFFFFF}Da preuzmete vozilo kucajte {00FF00}/preuzmivozilo", 0xFFFFFFFF, 1019.4164, -927.8874, 42.1797, 20.0, 0, 0);
	
	// 3D Text spolja na ulazu u policiju
	Create3DTextLabel("Beogradska Policija\nPritisnite 'F' da udete", 0x33CCFFFF, 1555.1368, -1675.6598, 16.1953, 20.0, 0, 0);

	// 3D Text unutra na izlazu iz policije
	Create3DTextLabel("Izlaz iz policije\nPritisnite 'F' da izadete", 0x33CCFFFF, 246.66, 65.80, 1003.64, 20.0, 6, 0);
	
	
	// Kreiramo pickup za po?tara (samo vizuelno, komanda radi preko koordinata)
    CreatePickup(1239, 23, 330.6513, -1509.8417, 36.0391, -1);
    Create3DTextLabel("Da se zaposlite kao postar\nKucajte /posao", 0xFFFFFFAA, 330.6513, -1509.8417, 36.0391, 15.0, 0, 1);

    // Ribolovac: odvojene lokacije za zaposljavanje i pocetak/kraj smjene.
    CreatePickup(1239, 23, RIBOLOVAC_POS_X, RIBOLOVAC_POS_Y, RIBOLOVAC_POS_Z, 0);
    Create3DTextLabel("{FFFF00}RIBAR\n{FFFFFF}Da se zaposlite kao Ribar - /posao\nDa pocnete raditi kao Ribar - /smjena", 0xFFFFFFFF,
        RIBOLOVAC_POS_X, RIBOLOVAC_POS_Y, RIBOLOVAC_POS_Z + 0.5, 18.0, 0, 1);
    CreatePickup(1239, 23, RIBOLOVAC_PRODAJA_X, RIBOLOVAC_PRODAJA_Y, RIBOLOVAC_PRODAJA_Z, 0);
    Create3DTextLabel("{FFFF00}STAND ZA PRODAJU RIBE\n{FFFFFF}/prodajribu", 0xFFFFFFFF,
        RIBOLOVAC_PRODAJA_X, RIBOLOVAC_PRODAJA_Y, RIBOLOVAC_PRODAJA_Z + 1.0, 18.0, 0, 1);
    CreatePickup(1239, 23, RIBOLOVAC_MAMAC_X, RIBOLOVAC_MAMAC_Y, RIBOLOVAC_MAMAC_Z, 0);
    Create3DTextLabel("{FFFF00}STAND ZA PRODAJU MAMACA\n{FFFFFF}/kupimamac", 0xFFFFFFFF,
        RIBOLOVAC_MAMAC_X, RIBOLOVAC_MAMAC_Y, RIBOLOVAC_MAMAC_Z + 1.0, 18.0, 0, 1);
    CreatePickup(1239, 23, RIBOLOVAC_STAP_X, RIBOLOVAC_STAP_Y, RIBOLOVAC_STAP_Z, 0);
    Create3DTextLabel("{FFFF00}STAND ZA PRODAJU STAPOVA\n{FFFFFF}/kupistap", 0xFFFFFFFF,
        RIBOLOVAC_STAP_X, RIBOLOVAC_STAP_Y, RIBOLOVAC_STAP_Z + 1.0, 18.0, 0, 1);
    CreateDynamicPickup(1239, 23, 358.78833007, 182.69433593, 1008.38281250, 0, 3);
    CreateDynamic3DTextLabel("{FFFF00}FAKTURE ZA BIZNIS\n{FFFFFF}/kupifakture", 0xFFFFFFFF,
        358.78833007, 182.69433593, 1009.08281250, 12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 3);
    for(new fishingSpot = 0; fishingSpot < MAX_RIBOLOVAC_MJESTA; fishingSpot++)
    {
        CreateDynamic3DTextLabel("{33CCFF}RIBOLOVNO MJESTO{FFFFFF}\nLIJEVI KLIK - pecanje", 0xFFFFFFFF,
            RibolovacMjesta[fishingSpot][0], RibolovacMjesta[fishingSpot][1], RibolovacMjesta[fishingSpot][2] + 0.5,
            12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    }
	
	// Ulaz spolja
	CreateDynamic3DTextLabel("Pritisni 'F' za ulazak u bolnicu", 0x00FF00FF, 1172.4083, -1323.3091, 15.4029, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	// Izlaz iz unutra?njosti
	CreateDynamic3DTextLabel("Pritisni 'F' za izlazak iz bolnice", 0xFF0000FF, -23.7858, 1500.6514, -3.3132, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

    //UsePlayerPedAnims();
    DisableInteriorEnterExits();
    return 1;
}
public OnPlayerConnect(playerid)
{
    AuthTDShown[playerid] = false;
    LastAntiSpamTick[playerid] = 0;
    PendingBizzStateSale[playerid] = -1;
    PendingBizzSeller[playerid] = INVALID_PLAYER_ID;
    PendingBizzId[playerid] = -1;
    PendingBizzPrice[playerid] = 0;
    new connectDutyFile[128], connectDutyName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, connectDutyName, sizeof(connectDutyName));
    format(connectDutyFile, sizeof(connectDutyFile), "Korisnici/%s.ini", connectDutyName);
    if(DOF2_FileExists(connectDutyFile))
    {
        DOF2_SetInt(connectDutyFile, "AdminDuty", 0);
        DOF2_SaveFile();
    }
    BankMoneyBag[playerid] = false;
    JetpackDropGuardUntil[playerid] = 0;
    SetPVarInt(playerid, "BR_LoggedIn", 0);
    ResetPlayerJobRuntimeData(playerid);
    // Ucitaj animacije prije nego sto ih igrac prvi put koristi.
    ApplyAnimation(playerid, "BOMBER", "null", 4.1, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "SAMP", "null", 4.1, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "BASEBALL", "null", 4.1, 0, 0, 0, 0, 0);

    WantedPoints[playerid] = 0;
    WantedHintToggleAt[playerid] = 0;
    PendingDeathFine[playerid] = 0;
    PendingDeathWanted[playerid] = 0;
    DeathPenaltySerial[playerid]++;
    IsHealing[playerid] = false;
    format(WantedReason[playerid], 64, "Nema");
    LastHudMinute[playerid] = -1;
    LastLocationZone[playerid] = -999;
    HasMapMarker[playerid] = false;
    MapTeleportSerial[playerid]++;
    ScriptJetpack[playerid] = false;
    JuniorMutedUntil[playerid] = 0;
    JuniorGMutedUntil[playerid] = 0;
    JuniorAdMutedUntil[playerid] = 0;
    JuniorAskMutedUntil[playerid] = 0;
    JuniorReportMutedUntil[playerid] = 0;
    JuniorMuteLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    JuniorJailedUntil[playerid] = 0;
    JuniorSpecTarget[playerid] = INVALID_PLAYER_ID;
    LastDamageIssuer[playerid] = INVALID_PLAYER_ID;
    LastKilledPlayer[playerid] = INVALID_PLAYER_ID;
    JuniorFrozen[playerid] = false;
    JuniorSpectating[playerid] = false;
    PhoneSpecDisabled[playerid] = false;
    JuniorSpecTarget[playerid] = INVALID_PLAYER_ID;
    JuniorSpecTarget[playerid] = INVALID_PLAYER_ID;
    RentPlayerVehicle[playerid] = 0;
    RentPendingVehicle[playerid] = 0;
    RentExpiresAt[playerid] = 0;
    RentBusinessId[playerid] = -1;
    RentBusinessSlot[playerid] = -1;
    OffshoreCheckpoint[playerid] = false;
    PendingPriceBusiness[playerid] = -1;
    PendingPriceBoatSlot[playerid] = -1;
    PendingPriceItem[playerid] = -1;
    PendingBusinessCreateType[playerid] = BIZ_TYPE_NONE;
    PendingBusinessCreatePrice[playerid] = 0;
    PendingBusinessCreateLevel[playerid] = 0;
    PendingBusinessCreateName[playerid][0] = EOS;
    PendingCoOwnerBusiness[playerid] = -1;
    PendingCoOwnerOwner[playerid] = INVALID_PLAYER_ID;
    PendingCoOwnerPrice[playerid] = 0;
    PendingCoOwnerExpiresAt[playerid] = 0;
    PendingBizzBankBusiness[playerid] = -1;
    PendingBizzBankStage[playerid] = BIZZ_BANK_STAGE_NONE;
    PendingBizzBankExpiresAt[playerid] = 0;
    PlayerBusinessInvoices[playerid] = DOF2_FileExists(connectDutyFile) && DOF2_IsSet(connectDutyFile, "BusinessInvoices") ? DOF2_GetInt(connectDutyFile, "BusinessInvoices") : 0;
    if(PlayerBusinessInvoices[playerid] < 0) PlayerBusinessInvoices[playerid] = 0;
    RentPaidSincePayday[playerid] = 0;
    HealthTickMinutes[playerid] = 0;
    PoliceTrackTarget[playerid] = INVALID_PLAYER_ID;
    RentTextDraw[playerid] = CreateRentTextDraw(playerid);
    GangZoneShowForPlayer(playerid, OffshoreFishingZone, 0xFFFFFF55);
    // --- PROVJERA IMENA (Ime_Prezime) ---
    new playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    if(!HandleTemporaryNameConnect(playerid, playername)) return 0;
    SetPlayerColor(playerid, 0xFFFFFFFF);
    UkloniMapeObjekte(playerid); // Bri?e objekte za igraca

    if(!IsValidRPName(playername))
    {
        new file_check[128];
        format(file_check, sizeof(file_check), "Korisnici/%s.ini", playername);

        // Ako nema donje crte I NEMA njegovog fajla u folderu -> KIKUJ GA!
        if(!DOF2_FileExists(file_check))
        {
            SendClientMessage(playerid, 0xFF0000FF, "[SERVER]: Morate imati RP format imena (Ime_Prezime) da biste igrali!");
            SetTimerEx("KickPlayerDelayed", 500, false, "i", playerid); // Odlo?eni kik sprecava "Server closed the connection" pucanje
            return 0;
        }
        // Ako fajl POSTOJI (ti si mu ga kreirao/stavio), preskace kik i pu?ta ga unutra!
    }
    // ------------------------------------

    // Muzika pocinje cim igrac klikne na "Connect" i ude na server
    PlayAudioStreamForPlayer(playerid, "https://a7.asurahosting.com/listen/balkan_radio_hit/radio.mp3");
    IntroKorak[playerid] = 0;
    PlayerZlato[playerid] = 0;
    PlayerRespekti[playerid] = 0;
    PlayerMinute[playerid] = 0;
    SessionPaydayMinutes[playerid] = 0;
    SessionContinuousMinutes[playerid] = 0;

    // Resetujemo admin labelu pri konekciji da je cista
    AdminText[playerid] = Text3D:INVALID_3DTEXT_ID;

    CreateRevolutionPlayerHud(playerid);

    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", playername);

    if(DOF2_FileExists(file))
    {
        PrikaziLoginProzor(playerid);
    }
    else
    {
        PrikaziRegisterProzor(playerid);
    }
    SendPlayerConnectionInfo(playerid);
    return 1;
}

// Dodaj ovo negde na dno skripte da podr?i odlo?eni kik bez pucanja konekcije:
forward KickPlayerDelayed(playerid);
public KickPlayerDelayed(playerid)
{
    Kick(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SaveRibolovacCatch(playerid);
    ResetPlayerJobTask(playerid, true, false);
    AuthTDShown[playerid] = false;
    RemovePlayerMapIcon(playerid, POLICE_TRACK_MAP_ICON);
    PoliceTrackTarget[playerid] = INVALID_PLAYER_ID;
    HealthTickMinutes[playerid] = 0;
    for(new officer = 0; officer < MAX_PLAYERS; officer++)
    {
        if(!IsPlayerConnected(officer) || PoliceTrackTarget[officer] != playerid) continue;
        RemovePlayerMapIcon(officer, POLICE_TRACK_MAP_ICON);
        PoliceTrackTarget[officer] = INVALID_PLAYER_ID;
        SendClientMessage(officer, 0xFF7777FF, "[POLICIJA]: Praceni igrac je napustio server.");
    }
    new disconnectName[MAX_PLAYER_NAME], disconnectMessage[144], disconnectAdminMessage[144];
    GetPlayerName(playerid, disconnectName, sizeof(disconnectName));
    if(reason == 0)
    {
        format(disconnectMessage, sizeof(disconnectMessage), "[INFO]: %s je izasao sa servera [Crashed].", disconnectName);
        format(disconnectAdminMessage, sizeof(disconnectAdminMessage), "[INFO]: %s[%d] je izasao sa servera [Crashed].", disconnectName, playerid);
    }
    else
    {
        format(disconnectMessage, sizeof(disconnectMessage), "[INFO]: %s je izasao sa servera [Leaving].", disconnectName);
        format(disconnectAdminMessage, sizeof(disconnectAdminMessage), "[INFO]: %s[%d] je izasao sa servera [Leaving].", disconnectName, playerid);
    }
    for(new viewer = 0; viewer < MAX_PLAYERS; viewer++)
    {
        if(!IsPlayerConnected(viewer)) continue;
        if(HasAdminCommandAccess(viewer)) SendClientMessage(viewer, 0x33CCFFFF, disconnectAdminMessage);
        else SendClientMessage(viewer, 0x33CCFFFF, disconnectMessage);
    }
    for(new spectator = 0; spectator < MAX_PLAYERS; spectator++)
    {
        if(!IsPlayerConnected(spectator) || !JuniorSpectating[spectator] || JuniorSpecTarget[spectator] != playerid) continue;
        TogglePlayerSpectating(spectator, 0);
        JuniorSpectating[spectator] = false;
        JuniorSpecTarget[spectator] = INVALID_PLAYER_ID;
        PhoneSpecDisabled[spectator] = false;
        SetPlayerInterior(spectator, JuniorSpecInterior[spectator]);
        SetPlayerVirtualWorld(spectator, JuniorSpecWorld[spectator]);
        SetPlayerPos(spectator, JuniorSpecX[spectator], JuniorSpecY[spectator], JuniorSpecZ[spectator]);
        SetCameraBehindPlayer(spectator);
        SendClientMessage(spectator, 0xFF7777FF, "[SPEC]: Igrac kojeg ste posmatrali je napustio server. Telefon je ponovo ukljucen.");
    }
    SessionPaydayMinutes[playerid] = 0;
    SessionContinuousMinutes[playerid] = 0;
    RentPaidSincePayday[playerid] = 0;
    PhoneSpecDisabled[playerid] = false;
    new dutyFile[128], dutyName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, dutyName, sizeof(dutyName));
    format(dutyFile, sizeof(dutyFile), "Korisnici/%s.ini", dutyName);
    if(DOF2_FileExists(dutyFile))
    {
        DOF2_SetInt(dutyFile, "AdminDuty", 0);
        DOF2_SaveFile();
    }

    SafeTeleportSerial[playerid]++; // Ponistava eventualni stari timer ucitavanja za ovaj slot.
    if(JuniorMuteLabel[playerid] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(JuniorMuteLabel[playerid]);
        JuniorMuteLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    }
    ApplyPendingDeathPenalty(playerid, false);
    DeathPenaltySerial[playerid]++;
    JetpackDropGuardUntil[playerid] = 0;
    HasMapMarker[playerid] = false;
    if(BankHackPlayer == playerid) BankAbortHack();
    BankLaserWarned[playerid] = false;
    if(BankHackSuccessPlayer == playerid) BankHackSuccessPlayer = INVALID_PLAYER_ID;
    if(BankRobber == playerid) BankAbortRobbery(false);
    if(BankMoneyBag[playerid]) RemovePlayerAttachedObject(playerid, 9);
    BankMoneyBag[playerid] = false;
    BankLaserLastCheck[playerid] = 0;
    BankLaserLastAlert[playerid] = 0;
    BankLaserPrevValid[playerid] = false;
    MapTeleportSerial[playerid]++;
    StopPlayerRent(playerid, true);
    PendingCoOwnerBusiness[playerid] = -1;
    PendingCoOwnerOwner[playerid] = INVALID_PLAYER_ID;
    PendingCoOwnerPrice[playerid] = 0;
    PendingCoOwnerExpiresAt[playerid] = 0;
    for(new offerTarget = 0; offerTarget < MAX_PLAYERS; offerTarget++)
    {
        if(PendingCoOwnerOwner[offerTarget] != playerid) continue;
        PendingCoOwnerBusiness[offerTarget] = -1;
        PendingCoOwnerOwner[offerTarget] = INVALID_PLAYER_ID;
        PendingCoOwnerPrice[offerTarget] = 0;
        PendingCoOwnerExpiresAt[offerTarget] = 0;
        if(IsPlayerConnected(offerTarget))
            SendClientMessage(offerTarget, 0xFF7777FF, "[BIZNIS]: Ponuda za suvlasnistvo je istekla jer je vlasnik napustio server.");
    }
    PlayerTextDrawDestroy(playerid, RentTextDraw[playerid]);
    ScriptJetpack[playerid] = false;
    // --- AUTOMATSKO SKIDANJE SA ADMIN DU?NOSTI I SNIMANJE PODATAKA ---
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(DOF2_FileExists(file))
    {
        if(GetPVarInt(playerid, "BR_LoggedIn"))
        {
            DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
            DOF2_SetInt(file, "DosijeWanted", WantedPoints[playerid]);
            DOF2_SetString(file, "DosijeRazlog", WantedReason[playerid]);
            DOF2_SetInt(file, "MinuteIgranja", PlayerMinute[playerid]);
            DOF2_SetInt(file, "Respekti", PlayerRespekti[playerid]);
            if(WantedPoints[playerid] > 0)
                DOF2_SetInt(file, "DosijeLTA", DOF2_GetInt(file, "DosijeLTA") + 1);
        }
        DOF2_SetInt(file, "AdminDuty", 0);
        DOF2_SetInt(file, "Lider", PlayerInfo[playerid][pLider]);
        new disconnectSkin = GetPlayerSkin(playerid);
        if(DOF2_GetInt(file, "RibolovacUniformaAktivna"))
        {
            new originalFishingSkin = DOF2_GetInt(file, "RibolovacOriginalSkin");
            if(originalFishingSkin >= 0 && originalFishingSkin <= 311 && originalFishingSkin != 74)
                disconnectSkin = originalFishingSkin;
            DOF2_SetInt(file, "RibolovacUniformaAktivna", 0);
        }
        DOF2_SetInt(file, "Skin", disconnectSkin);
        DOF2_SaveFile();
    }
    // --------------------------------------------------------

    // Tvoji postojeci textdrawovi koji se bri?u pri diskonekciji
    DestroyRevolutionPlayerHud(playerid);

    return 1;
}
forward FinishSafeTeleport(playerid, serial);
public FinishSafeTeleport(playerid, serial)
{
    if(!IsPlayerConnected(playerid) || serial != SafeTeleportSerial[playerid]) return 1;
    Streamer_Update(playerid);
    SetCameraBehindPlayer(playerid);
    if(!IsHealing[playerid] && !JuniorFrozen[playerid]) TogglePlayerControllable(playerid, 1);
    return 1;
}

stock SafeTeleportPlayer(playerid, Float:x, Float:y, Float:z, interior, world, Float:angle = -999.0)
{
    if(!IsPlayerConnected(playerid)) return 0;
    SafeTeleportSerial[playerid]++;
    TogglePlayerControllable(playerid, 0);
    SetPlayerInterior(playerid, interior);
    SetPlayerVirtualWorld(playerid, world);
    SetPlayerPos(playerid, x, y, z);
    if(angle > -998.0) SetPlayerFacingAngle(playerid, angle);
    Streamer_UpdateEx(playerid, x, y, z, world, interior, -1, 0, 0);
    SetCameraBehindPlayer(playerid);
    SetTimerEx("FinishSafeTeleport", 900, false, "ii", playerid, SafeTeleportSerial[playerid]);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    ScriptJetpack[playerid] = false;
    SetTimerEx("ApplySpawnHealth", 1000, false, "i", playerid);
    // GTA wanted level se resetuje tek nakon sto se zavrsi respawn.
    SetTimerEx("FinishSpawnWantedReset", 750, false, "ii", playerid, DeathPenaltySerial[playerid]);
    if(PendingDeathFine[playerid] > 0)
        SetTimerEx("FinishDeathPenalty", 300, false, "ii", playerid, DeathPenaltySerial[playerid]);
    // Aktivna admin jail kazna ima prednost nad bolnicom i svim obicnim spawnovima.
    if(JuniorJailedUntil[playerid] > gettime())
    {
        IsHealing[playerid] = false;
        SafeTeleportPlayer(playerid, 264.63, 77.57, 1001.04, 6, 0);
        SendClientMessage(playerid, 0xFF7777FF, "[ZATVOR]: Kazna jos traje. Respawnovani ste u zatvoru.");
        return 1;
    }

    // Ako je igrac umro i nalazi se na lecenju u bolnici 5 sekundi (skin se ne mijenja)
    if(IsHealing[playerid])
    {
        // Klijent i streamer dobijaju vrijeme da ucitaju pod bolnice prije kretanja.
        SafeTeleportPlayer(playerid, -20.6776, 1481.3562, -3.3132, 0, 0, 179.0601);

        SendClientMessage(playerid, 0xFF0000FF, "[BOLNICA]: Nalazite se na lecenju 5 sekundi...");
        GameTextForPlayer(playerid, "~r~Lijecenje u toku...~n~~w~Trajanje: ~g~5 sekundi", 5000, 3);

        SetTimerEx("ZavrsiLecenje", 5000, false, "i", playerid);
        return 1;
    }

    // --- PROVJERA ADMINA, HELPERA I SKINA PRIJE SPAWNA ---
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    new helper_lvl = 0;
    new sazvani_skin = 26;
    new clan_lvl = 0;
    new orgid = 0;

    if(DOF2_FileExists(file))
    {
        admin_lvl = DOF2_GetInt(file, "Admin");
        helper_lvl = DOF2_GetInt(file, "Helper");
        clan_lvl = DOF2_GetInt(file, "Clan");
        if(clan_lvl == 0) clan_lvl = DOF2_GetInt(file, "Member");

        orgid = clan_lvl;

        if(DOF2_IsSet(file, "Skin"))
        {
            sazvani_skin = DOF2_GetInt(file, "Skin");
        }
    }
    if(sazvani_skin < 0 || sazvani_skin > 311 || sazvani_skin == 74)
        sazvani_skin = admin_lvl > 0 ? 294 : 26;

    // --- PROVERA DA LI JE LIDER U Lideri.ini ---
    new lideri_file[64] = "BalkanRP/Lideri.ini";
    if(DOF2_FileExists(lideri_file))
    {
        for(new i = 1; i <= 20; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, ime, true) == 0)
                {
                    orgid = i;
                    break;
                }
            }
        }
    }

    // Pamtimo organizaciju igraca za slucaj smrti
    PlayerOrg[playerid] = orgid;

    if(admin_lvl > 0)
    {
        // /setskin je trajan i za admine; spawn vise ne prepisuje spremljeni skin.
        SetPlayerSkin(playerid, sazvani_skin);

        if(admin_lvl >= RANK_SUVLASNIK)
        {
            SetPlayerColor(playerid, 0x000000FF);
        }
        else
        {
            SetPlayerColor(playerid, 0xFFFFFFFF);
        }
    }
    else if(helper_lvl > 0)
    {
        SetPlayerSkin(playerid, sazvani_skin);
        SetPlayerColor(playerid, 0xFFFF00FF);
    }
    else
    {
        SetPlayerSkin(playerid, sazvani_skin);
        SetPlayerColor(playerid, 0xFFFFFFFF);
    }

    if(orgid == 1)
    {
        SafeTeleportPlayer(playerid, 230.6200, 75.2964, 1005.0391, 6, 0, 270.3857);
    }
    else if(orgid == 4)
    {
        SafeTeleportPlayer(playerid, 1754.1577, -1903.0061, 13.5634, 0, 0, 0.0);
    }
    else if(orgid == 5)
    {
        SafeTeleportPlayer(playerid, -13.7780, 1465.4548, -3.2142, 0, 0, 3.1334);
    }
    else if(orgid == 7)
    {
        SafeTeleportPlayer(playerid, 1072.9264, -878.3057, 43.3932, 0, 0, 0.0);
    }
    else
    {
        SafeTeleportPlayer(playerid, 1685.8652, -2331.2102, 13.5469, 0, 0, 90.2917);
    }

    ClearAnimations(playerid);

    ShowRevolutionHud(playerid);

    if(IntroKorak[playerid] == 0)
    {
        // Ceka registraciju/login
    }
    else
    {
        if(orgid != 1)
        {
            SetPlayerInterior(playerid, 0);
        }
    }

    UpdateAdminLabel(playerid);

    return 1;
}
// --- PROZORI (DIALOGULI) ---

stock PrikaziRegisterProzor(playerid)
{
    ShowAuthTextDraws(playerid);
    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    new string[512];
    format(string, sizeof(string),
        "Dobrodosao na **Balkan Revolution RolePlay**!\n\n"\
        "|-------------------------------------------------------|\n\n"\
        "-Vase Ime: **%s**\n\n"\
        "-Forum: **balkan-extreme.halofight.com**\n\n"\
        "-Account: **Vi nemate registrovan account**\n\n"\
        "Unesite zeljeni password:\n\n"\
        "|-------------------------------------------------------|",
        ime);

    ShowPlayerDialog(playerid, DIALOG_REGISTRACIJA, DIALOG_STYLE_PASSWORD, "Register", string, "Register", "Exit");
    return 1;
}

stock PrikaziLoginProzor(playerid)
{
    ShowAuthTextDraws(playerid);
    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    new string[512];
    format(string, sizeof(string),
        "Dobrodosli nazad na **Balkan Revolution RolePlay**!\n\n"\
        "|-------------------------------------------------------|\n\n"\
        "-Vase Ime: **%s**\n\n"\
        "-Account: **Vas account vec postoji**\n\n"\
        "Unesite vas password da biste se ulogovali:\n\n"\
        "|-------------------------------------------------------|",
        ime);

    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", string, "Login", "Exit");
    return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if((dialogid >= DIALOG_BIZZ_BANK_MENU_BASE && dialogid < DIALOG_BIZZ_BANK_MENU_BASE + MAX_MARKETA) ||
       (dialogid >= DIALOG_BIZZ_BANK_DEPOSIT_BASE && dialogid < DIALOG_BIZZ_BANK_DEPOSIT_BASE + MAX_MARKETA) ||
       (dialogid >= DIALOG_BIZZ_BANK_WITHDRAW_BASE && dialogid < DIALOG_BIZZ_BANK_WITHDRAW_BASE + MAX_MARKETA))
    {
        return HandleBusinessBankDialog(playerid, dialogid, response, listitem, inputtext);
    }

    switch(dialogid)
    {
        case DIALOG_CREATE_JOB_BUSINESS:
        {
            if(!response) return 1;
            new jobid = listitem + 1;
            if(jobid < JOB_CISTAC_ULICA || jobid > JOB_RIBOLOVAC || PendingBusinessCreateType[playerid] != BIZ_TYPE_JOB) return 1;
            new businessid = CreateBusinessAtPlayer(playerid, BIZ_TYPE_JOB, jobid, PendingBusinessCreateName[playerid],
                PendingBusinessCreatePrice[playerid], PendingBusinessCreateLevel[playerid]);
            if(businessid == -2) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Za izabrani posao vec postoji biznis.");
            if(businessid < 0) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Nema slobodnog mjesta za novi biznis.");
            new jobName[32], message[160];
            GetJobName(jobid, jobName, sizeof(jobName));
            format(message, sizeof(message), "Kreiran je job biznis '%s' (ID %d) za posao %s.", PendingBusinessCreateName[playerid], businessid, jobName);
            SendClientMessage(playerid, 0x00BFFFFF, message);
            PendingBusinessCreateType[playerid] = BIZ_TYPE_NONE;
            return 1;
        }
        case DIALOG_COOWNER_OFFER:
        {
            new businessid = PendingCoOwnerBusiness[playerid], ownerid = PendingCoOwnerOwner[playerid], price = PendingCoOwnerPrice[playerid];
            new expiresAt = PendingCoOwnerExpiresAt[playerid];
            PendingCoOwnerBusiness[playerid] = -1;
            PendingCoOwnerOwner[playerid] = INVALID_PLAYER_ID;
            PendingCoOwnerPrice[playerid] = 0;
            PendingCoOwnerExpiresAt[playerid] = 0;
            if(!response) return 1;
            if(expiresAt < gettime())
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Ponuda za suvlasnistvo je istekla.");
            if(!IsPlayerConnected(ownerid) || businessid < 0 || businessid >= MAX_MARKETA || !IsBusinessOwner(ownerid, businessid))
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Ponuda vise nije vazeca.");
            if(price < 0)
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Ponuda sadrzi neispravnu cijenu.");
            if(strlen(BusinessCoOwner[businessid]) && strcmp(BusinessCoOwner[businessid], "Nema", true) != 0)
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Biznis vec ima suvlasnika.");
            if(IsBusinessOwner(playerid, businessid) || GetManagedBusinessId(playerid) != -1)
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Vec upravljate biznisom.");
            if(GetPlayerMoney(playerid) < price)
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Nemate dovoljno novca za ovu ponudu.");
            if(GetPlayerMoney(ownerid) > 0 && price > MAX_MONEY_VALUE - GetPlayerMoney(ownerid))
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Transakcija bi prekoracila dozvoljeni iznos novca vlasnika.");
            new targetName[MAX_PLAYER_NAME], targetAccount[128], ownerAccount[128];
            GetPlayerName(playerid, targetName, sizeof(targetName));
            if(!GetPlayerAccountPath(playerid, targetAccount, sizeof(targetAccount)) ||
               !GetPlayerAccountPath(ownerid, ownerAccount, sizeof(ownerAccount)))
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Korisnicki racun nije dostupan. Transakcija je otkazana.");
            GivePlayerMoney(playerid, -price);
            GivePlayerMoney(ownerid, price);
            PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
            PlayerInfo[ownerid][pNovac] = GetPlayerMoney(ownerid);
            DOF2_SetInt(targetAccount, "Novac", PlayerInfo[playerid][pNovac]);
            DOF2_SetInt(ownerAccount, "Novac", PlayerInfo[ownerid][pNovac]);
            format(BusinessCoOwner[businessid], MAX_PLAYER_NAME, "%s", targetName);
            SaveMarket(businessid);
            UpdateMarketCP(businessid);
            DOF2_SaveFile();
            SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Postali ste suvlasnik biznisa.");
            SendClientMessage(ownerid, 0x00FF00FF, "[BIZNIS]: Igrac je prihvatio ponudu za suvlasnika.");
            return 1;
        }
        case DIALOG_BUY_INVOICES:
        {
            if(!response) return 1;
            new amount = strval(inputtext);
            if(amount < 1 || amount > 10) return SendClientMessage(playerid, 0xFF7777FF, "[FAKTURE]: Mozete kupiti od 1 do 10 faktura odjednom.");
            if(GetPlayerInterior(playerid) != 3 || GetPlayerVirtualWorld(playerid) != 0 ||
               !IsPlayerInRangeOfPoint(playerid, 4.0, 358.78833007, 182.69433593, 1008.38281250))
                return SendClientMessage(playerid, 0xFF7777FF, "[FAKTURE]: Morate biti kod saltera za fakture u opstini.");
            new cost = amount * 100;
            if(GetPlayerMoney(playerid) < cost) return SendClientMessage(playerid, 0xFF7777FF, "[FAKTURE]: Nemate dovoljno novca.");
            if(PlayerBusinessInvoices[playerid] > MAX_MONEY_VALUE - amount)
                return SendClientMessage(playerid, 0xFF7777FF, "[FAKTURE]: Dostigli ste maksimalnu dozvoljenu kolicinu faktura.");
            new account[128];
            if(!GetPlayerAccountPath(playerid, account, sizeof(account)))
                return SendClientMessage(playerid, 0xFF7777FF, "[FAKTURE]: Korisnicki racun nije dostupan. Kupovina je otkazana.");
            GivePlayerMoney(playerid, -cost);
            PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
            PlayerBusinessInvoices[playerid] += amount;
            DOF2_SetInt(account, "Novac", PlayerInfo[playerid][pNovac]);
            DOF2_SetInt(account, "BusinessInvoices", PlayerBusinessInvoices[playerid]);
            DOF2_SaveFile();
            new message[128];
            format(message, sizeof(message), "[FAKTURE]: Kupili ste %d faktura za %d RSD. Sada imate %d.", amount, cost, PlayerBusinessInvoices[playerid]);
            SendClientMessage(playerid, 0x00FF00FF, message);
            return 1;
        }
        case DIALOG_PRICEPRODUCTS_CATEGORY:
        {
            new businessid = PendingPriceBusiness[playerid];
            if(!response) return 1;
            if(businessid < 0 || businessid >= MAX_MARKETA || !CanManageBusinessHere(playerid, businessid) || !IsFishingBusiness(businessid))
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Biznis vise nije dostupan.");
            if(listitem == 0)
            {
                ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BAIT_LIST, DIALOG_STYLE_LIST, "{66CCFF}Mamci", "Hljeb\nCrv\nLignja", "Izaberi", "Nazad");
                return 1;
            }
            if(listitem == 1)
            {
                ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_ROD_LIST, DIALOG_STYLE_LIST, "{66CCFF}Stapovi", "Pocetnicki stap\nProfesionalni stap", "Izaberi", "Nazad");
                return 1;
            }
            if(listitem == 2) return ShowFishingBusinessBoatList(playerid, businessid);
            return 1;
        }
        case DIALOG_PRICEPRODUCTS_BAIT_LIST:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_CATEGORY, DIALOG_STYLE_LIST, "{66CCFF}Ribarski biznis - Cijene", "Mamci\nStapovi\nBrodovi", "Izaberi", "Zatvori");
            new businessid = PendingPriceBusiness[playerid];
            if(!CanManageBusinessHere(playerid, businessid) || !IsFishingBusiness(businessid) || listitem < 0 || listitem >= MAX_RIBOLOVAC_MAMACA) return 1;
            PendingPriceItem[playerid] = listitem;
            new text[160];
            format(text, sizeof(text), "Opcija\tVrijednost\nKolicina u paketu\t%d komada\nCijena paketa\t%d RSD", BusinessBaitAmount[businessid][listitem], BusinessBaitPrice[businessid][listitem]);
            ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BAIT_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS, "{66CCFF}Postavke mamca", text, "Izaberi", "Nazad");
            return 1;
        }
        case DIALOG_PRICEPRODUCTS_BAIT_OPTIONS:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BAIT_LIST, DIALOG_STYLE_LIST, "{66CCFF}Mamci", "Hljeb\nCrv\nLignja", "Izaberi", "Nazad");
            if(listitem == 0) ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BAIT_AMOUNT, DIALOG_STYLE_INPUT, "{66CCFF}Kolicina mamca", "Unesite broj komada u paketu (1-100):", "Sacuvaj", "Odustani");
            else if(listitem == 1) ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BAIT_PRICE, DIALOG_STYLE_INPUT, "{66CCFF}Cijena mamca", "Unesite cijenu paketa (1-100000 RSD):", "Sacuvaj", "Odustani");
            return 1;
        }
        case DIALOG_PRICEPRODUCTS_BAIT_AMOUNT:
        {
            if(!response) return 1;
            new businessid = PendingPriceBusiness[playerid], bait = PendingPriceItem[playerid], amount = strval(inputtext);
            if(!CanManageBusinessHere(playerid, businessid) || !IsFishingBusiness(businessid) || bait < 0 || bait >= MAX_RIBOLOVAC_MAMACA) return 1;
            if(amount < 1 || amount > 100) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Kolicina mora biti 1-100 komada.");
            BusinessBaitAmount[businessid][bait] = amount; SaveMarket(businessid);
            return SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Kolicina mamca je sacuvana.");
        }
        case DIALOG_PRICEPRODUCTS_BAIT_PRICE:
        {
            if(!response) return 1;
            new businessid = PendingPriceBusiness[playerid], bait = PendingPriceItem[playerid], price = strval(inputtext);
            if(!CanManageBusinessHere(playerid, businessid) || !IsFishingBusiness(businessid) || bait < 0 || bait >= MAX_RIBOLOVAC_MAMACA) return 1;
            if(price < 1 || price > 100000) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Cijena mora biti 1-100000 RSD.");
            BusinessBaitPrice[businessid][bait] = price; SaveMarket(businessid);
            return SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Cijena mamca je sacuvana.");
        }
        case DIALOG_PRICEPRODUCTS_ROD_LIST:
        {
            if(!response) return ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_CATEGORY, DIALOG_STYLE_LIST, "{66CCFF}Ribarski biznis - Cijene", "Mamci\nStapovi\nBrodovi", "Izaberi", "Zatvori");
            new businessid = PendingPriceBusiness[playerid];
            if(!CanManageBusinessHere(playerid, businessid) || !IsFishingBusiness(businessid) || listitem < 0 || listitem > 1) return 1;
            PendingPriceItem[playerid] = listitem;
            new text[128]; format(text, sizeof(text), "Trenutna cijena: %d RSD\nUnesite novu cijenu (1-1000000 RSD):", BusinessRodPrice[businessid][listitem]);
            ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_ROD_PRICE, DIALOG_STYLE_INPUT, "{66CCFF}Cijena stapa", text, "Sacuvaj", "Odustani");
            return 1;
        }
        case DIALOG_PRICEPRODUCTS_ROD_PRICE:
        {
            if(!response) return 1;
            new businessid = PendingPriceBusiness[playerid], rod = PendingPriceItem[playerid], price = strval(inputtext);
            if(!CanManageBusinessHere(playerid, businessid) || !IsFishingBusiness(businessid) || rod < 0 || rod > 1) return 1;
            if(price < 1 || price > 1000000) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Cijena mora biti 1-1000000 RSD.");
            BusinessRodPrice[businessid][rod] = price; SaveMarket(businessid);
            return SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Cijena stapa je sacuvana.");
        }
        case DIALOG_PRICEPRODUCTS_BOATS:
        {
            new businessid = PendingPriceBusiness[playerid];
            if(!response)
            {
                ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_CATEGORY, DIALOG_STYLE_LIST,
                    "{66CCFF}Ribarski biznis - Cijene", "Mamci\nStapovi\nBrodovi", "Izaberi", "Zatvori");
                return 1;
            }
            if(businessid < 0 || !CanManageBusinessHere(playerid, businessid)) return 1;
            new slot = GetFishingBoatSlotFromList(businessid, listitem);
            if(slot == -1) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Brod vise nije dostupan.");
            PendingPriceBoatSlot[playerid] = slot;
            new text[256], title[64], vehicleid = BusinessVehicleId[businessid][slot];
            format(title, sizeof(title), "{66CCFF}BROD #%d - Reefer", slot + 1);
            format(text, sizeof(text), "Opcija\tVrijednost\nPromijeni cijenu\t%d RSD\nPromijeni vrijeme\t%d minuta\nStatus\t%s",
                BusinessVehicleRentPrice[businessid][slot], BusinessVehicleRentMinutes[businessid][slot],
                (vehicleid > 0 && vehicleid < MAX_VEHICLES && RentVehicleOwner[vehicleid]) ? ("Iznajmljen") : ("Slobodan"));
            ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BOAT_OPTIONS, DIALOG_STYLE_TABLIST_HEADERS,
                title, text, "Izaberi", "Nazad");
            return 1;
        }
        case DIALOG_PRICEPRODUCTS_BOAT_OPTIONS:
        {
            if(!response) return ShowFishingBusinessBoatList(playerid, PendingPriceBusiness[playerid]);
            new businessid = PendingPriceBusiness[playerid], slot = PendingPriceBoatSlot[playerid];
            if(businessid < 0 || businessid >= MAX_MARKETA || !CanManageBusinessHere(playerid, businessid) ||
               !IsFishingBusiness(businessid) || slot < 0 || slot >= MAX_BUSINESS_VEHICLES ||
               BusinessVehicleModel[businessid][slot] != FISHING_BOAT_MODEL)
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Brod ili biznis vise nije dostupan.");
            if(listitem == 0)
                ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BOAT_PRICE, DIALOG_STYLE_INPUT, "{66CCFF}Cijena rente", "Unesite cijenu rente (1-1000000 RSD):", "Sacuvaj", "Odustani");
            else if(listitem == 1)
                ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BOAT_TIME, DIALOG_STYLE_INPUT, "{66CCFF}Vrijeme rente", "Unesite trajanje rente u minutama (5-120):", "Sacuvaj", "Odustani");
            return 1;
        }
        case DIALOG_PRICEPRODUCTS_BOAT_PRICE:
        {
            if(!response) return 1;
            new businessid = PendingPriceBusiness[playerid], value = strval(inputtext), slot = PendingPriceBoatSlot[playerid];
            if(businessid < 0 || !CanManageBusinessHere(playerid, businessid)) return 1;
            if(slot == -2)
            {
                if(value < 1 || value > 100000) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Cijena mora biti 1-100000 RSD.");
                MarketInfo[businessid][mCenaProizvoda] = value;
            }
            else
            {
                if(slot < 0 || slot >= MAX_BUSINESS_VEHICLES || BusinessVehicleModel[businessid][slot] != FISHING_BOAT_MODEL) return 1;
                if(value < 1 || value > 1000000) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Cijena rente mora biti 1-1000000 RSD.");
                BusinessVehicleRentPrice[businessid][slot] = value;
            }
            SaveMarket(businessid);
            SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Cijena je uspjesno sacuvana.");
            return 1;
        }
        case DIALOG_PRICEPRODUCTS_BOAT_TIME:
        {
            if(!response) return 1;
            new businessid = PendingPriceBusiness[playerid], slot = PendingPriceBoatSlot[playerid], minutes = strval(inputtext);
            if(businessid < 0 || !CanManageBusinessHere(playerid, businessid) || slot < 0 || slot >= MAX_BUSINESS_VEHICLES ||
               BusinessVehicleModel[businessid][slot] != FISHING_BOAT_MODEL) return 1;
            if(minutes < FISHING_BOAT_RENT_MIN_MINUTES || minutes > FISHING_BOAT_RENT_MAX_MINUTES)
                return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Vrijeme rente mora biti izmedju 5 i 120 minuta.");
            BusinessVehicleRentMinutes[businessid][slot] = minutes;
            SaveMarket(businessid);
            SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Vrijeme rente je uspjesno sacuvano.");
            return 1;
        }
        case DIALOG_FISHING_BOAT_RENT:
        {
            new vehicleid = RentPendingVehicle[playerid];
            RentPendingVehicle[playerid] = 0;
            if(!response)
            {
                if(IsPlayerInVehicle(playerid, vehicleid)) RemovePlayerFromVehicle(playerid);
                return 1;
            }
            new businessid = -1, slot = -1;
            if(!GetBusinessVehicleSlotById(vehicleid, businessid, slot) || !IsFishingBusiness(businessid) ||
               BusinessVehicleModel[businessid][slot] != FISHING_BOAT_MODEL || GetVehicleModel(vehicleid) != FISHING_BOAT_MODEL)
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Brod vise nije dostupan.");
            if(!IsPlayerInVehicle(playerid, vehicleid))
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Morate ostati u brodu dok potvrdjujete najam.");
            if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC)
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Ovaj brod mogu iznajmiti samo Ribolovci.");
            if(PlayerJobData[playerid][JobLevel] < RIBOLOVAC_MAX_LEVEL)
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Ovaj brod mozete iznajmiti tek na 5. levelu Ribolovca.");
            if(RentPlayerVehicle[playerid] || RentVehicleOwner[vehicleid])
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Brod je vec iznajmljen ili vec imate rent vozilo.");
            new price = BusinessVehicleRentPrice[businessid][slot], minutes = BusinessVehicleRentMinutes[businessid][slot];
            if(price < 1 || minutes < FISHING_BOAT_RENT_MIN_MINUTES || minutes > FISHING_BOAT_RENT_MAX_MINUTES)
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Rent postavke ovog broda nisu ispravne.");
            if(GetPlayerMoney(playerid) < price)
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Nemate dovoljno RSD za iznajmljivanje broda.");
            if(MarketInfo[businessid][mBudzet] < 0 || price > MAX_MONEY_VALUE - MarketInfo[businessid][mBudzet])
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Budzet biznisa je dostigao dozvoljeni maksimum.");
            new file[128];
            if(!GetPlayerAccountPath(playerid, file, sizeof(file)))
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Korisnicki racun nije dostupan. Rent je otkazan.");

            RentVehicleOwner[vehicleid] = playerid + 1;
            RentPlayerVehicle[playerid] = vehicleid;
            RentBusinessId[playerid] = businessid;
            RentBusinessSlot[playerid] = slot;
            RentExpiresAt[playerid] = gettime() + minutes * 60;
            if(!IsPlayerInVehicle(playerid, vehicleid) && !PutPlayerInVehicle(playerid, vehicleid, 0))
            {
                StopPlayerRent(playerid, true);
                return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Ulazak u brod nije uspio. Nista nije naplaceno.");
            }
            GivePlayerMoney(playerid, -price);
            PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
            MarketInfo[businessid][mBudzet] += price;
            DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
            SaveMarket(businessid);
            DOF2_SaveFile();
            SetPlayerCheckpoint(playerid, OFFSHORE_CENTER_X, OFFSHORE_CENTER_Y, 0.0, 12.0);
            OffshoreCheckpoint[playerid] = true;
            UpdateRentTextDraw(playerid);
            PlayerTextDrawShow(playerid, RentTextDraw[playerid]);
            SendClientMessage(playerid, 0x00FF00FF, "[RENT]: Brod je iznajmljen. Checkpoint vas vodi do offshore fishing zone.");
            return 1;
        }
        case DIALOG_BIZZ_SELL_STATE:
        {
            new id=PendingBizzStateSale[playerid]; PendingBizzStateSale[playerid]=-1;
            if(!response)return 1;
            if(id<0||id>=MAX_MARKETA||GetOwnedBusinessId(playerid)!=id||!IsAtOwnedBusiness(playerid,id))return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Morate biti kod svog biznisa.");
            new refund=MarketInfo[id][mCena]/2,file[128];
            if(!GetPlayerAccountPath(playerid,file,sizeof(file))) return SendClientMessage(playerid,0xFF7777FF,"GRESKA: Korisnicki racun nije dostupan.");
            new euro=DOF2_IsSet(file,"Euro")?DOF2_GetInt(file,"Euro"):0;
            if(euro<0)euro=0;
            if(refund<0||euro>MAX_MONEY_VALUE-refund)return SendClientMessage(playerid,0xFF7777FF,"GRESKA: Ne mozete primiti vise eura.");
            DOF2_SetInt(file,"Euro",euro+refund); PlayerInfo[playerid][pBizz]=-1;
            DOF2_SetInt(file,"Bizz",-1);
            MarketInfo[id][mOwned]=0; MarketInfo[id][mFakture]=0; format(MarketInfo[id][mOwner],MAX_PLAYER_NAME,"Nitko"); format(BusinessCoOwner[id],MAX_PLAYER_NAME,"Nema"); DestroyBusinessVehicle(id,true); SaveMarket(id); UpdateMarketCP(id); DOF2_SaveFile();
            UpdateRevolutionHudData(playerid);
            new msg[128]; format(msg,sizeof(msg),"[BIZNIS]: Biznis je prodan drzavi za %d EUR.",refund); SendClientMessage(playerid,0x00FF00FF,msg); return 1;
        }
        case DIALOG_BIZZ_SELL_PLAYER:
        {
            new seller=PendingBizzSeller[playerid],id=PendingBizzId[playerid],price=PendingBizzPrice[playerid];
            PendingBizzSeller[playerid]=INVALID_PLAYER_ID; PendingBizzId[playerid]=-1; PendingBizzPrice[playerid]=0;
            if(!response)return 1;
            if(!IsPlayerConnected(seller)||id<0||id>=MAX_MARKETA||GetOwnedBusinessId(seller)!=id||!CanManageBusinessHere(seller,id))return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Ponuda vise nije vazeca.");
            if(GetOwnedBusinessId(playerid)!=-1)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Vec posjedujete biznis.");
            new buyerFile[128],sellerFile[128],buyerName[MAX_PLAYER_NAME],sellerName[MAX_PLAYER_NAME];
            GetPlayerName(playerid,buyerName,sizeof(buyerName)); GetPlayerName(seller,sellerName,sizeof(sellerName));
            if(!GetPlayerAccountPath(playerid,buyerFile,sizeof(buyerFile))||!GetPlayerAccountPath(seller,sellerFile,sizeof(sellerFile)))return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Korisnicki racun nije dostupan.");
            if(DOF2_GetInt(buyerFile,"Level")<MarketInfo[id][mLevel])return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Nemate potreban level za ovaj biznis.");
            new buyerEuro=DOF2_IsSet(buyerFile,"Euro")?DOF2_GetInt(buyerFile,"Euro"):0, sellerEuro=DOF2_IsSet(sellerFile,"Euro")?DOF2_GetInt(sellerFile,"Euro"):0;
            if(buyerEuro<price)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Nemate dovoljno eura.");
            if(sellerEuro<0)sellerEuro=0;
            if(price<1||sellerEuro>MAX_MONEY_VALUE-price)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Prodavac ne moze primiti vise eura.");
            PlayerInfo[playerid][pBizz]=id; PlayerInfo[seller][pBizz]=-1;
            DOF2_SetInt(buyerFile,"Bizz",id); DOF2_SetInt(buyerFile,"Euro",buyerEuro-price); DOF2_SetInt(sellerFile,"Bizz",-1); DOF2_SetInt(sellerFile,"Euro",sellerEuro+price);
            MarketInfo[id][mOwned]=1; format(MarketInfo[id][mOwner],MAX_PLAYER_NAME,"%s",buyerName); format(BusinessCoOwner[id],MAX_PLAYER_NAME,"Nema"); SaveMarket(id); UpdateMarketCP(id); DOF2_SaveFile();
            UpdateRevolutionHudData(playerid); UpdateRevolutionHudData(seller);
            SendClientMessage(playerid,0x00FF00FF,"[BIZNIS]: Kupili ste biznis od igraca."); SendClientMessage(seller,0x00FF00FF,"[BIZNIS]: Prodali ste biznis igracu."); return 1;
        }
        case DIALOG_RIBOLOVAC_KUPI_MAMAC:
        {
            if(!response) return 1;
            if(listitem < 0 || listitem >= MAX_RIBOLOVAC_MAMACA) return 1;
            if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC)
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Niste zaposleni kao Ribolovac.");
            if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0 ||
               !IsPlayerInRangeOfPoint(playerid, 4.0, RIBOLOVAC_MAMAC_X, RIBOLOVAC_MAMAC_Y, RIBOLOVAC_MAMAC_Z))
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Mamac mozete kupiti samo na standu za prodaju mamaca.");
            new businessid = FindJobBusiness(JOB_RIBOLOVAC);
            new price = RibolovacMamacCijena[listitem], amount = 5;
            if(businessid != -1)
            {
                price = BusinessBaitPrice[businessid][listitem];
                amount = BusinessBaitAmount[businessid][listitem];
                if(!HasBusinessProducts(businessid, 1)) return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Ribarski biznis trenutno nema proizvoda na stanju.");
                if(MarketInfo[businessid][mBudzet] < 0 || price > MAX_MONEY_VALUE - MarketInfo[businessid][mBudzet])
                    return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Budzet ribarskog biznisa je dostigao dozvoljeni maksimum.");
            }
            if(price < 1 || amount < 1 || amount > 100)
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Postavke ovog paketa mamaca nisu ispravne.");
            if(GetPlayerMoney(playerid) < price)
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Nemate dovoljno novca za taj paket mamaca.");
            if(RibolovacMamac[playerid][listitem] > MAX_MONEY_VALUE - amount)
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Ne mozete nositi vise tog mamca.");
            new file[128];
            if(!GetPlayerAccountPath(playerid, file, sizeof(file)))
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Korisnicki racun nije dostupan. Kupovina je otkazana.");

            GivePlayerMoney(playerid, -price);
            PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
            RibolovacMamac[playerid][listitem] += amount;
            RibolovacAktivniMamac[playerid] = listitem;
            UpdateRibolovacBaitObject(playerid);
            if(businessid != -1)
            {
                MarketInfo[businessid][mBudzet] += price;
                RemoveBusinessProducts(businessid, 1);
            }

            new baitMessage[144];
            DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
            SaveRibolovacBait(playerid);
            format(baitMessage, sizeof(baitMessage), "[POSAO]: Kupili ste %d komada mamca %s za %d RSD. Mamac je automatski izabran.",
                amount, RibolovacMamacNaziv[listitem], price);
            SendClientMessage(playerid, 0x00FF00FF, baitMessage);
            return 1;
        }
        case DIALOG_RIBOLOVAC_IZABERI_MAMAC:
        {
            if(!response) return 1;
            if(listitem < 0 || listitem >= MAX_RIBOLOVAC_MAMACA) return 1;
            if(RibolovacMamac[playerid][listitem] <= 0)
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Nemate taj mamac. Kupite ga na ribarskom standu.");

            RibolovacAktivniMamac[playerid] = listitem;
            SaveRibolovacBait(playerid);
            UpdateRibolovacBaitObject(playerid);
            new baitMessage[112];
            format(baitMessage, sizeof(baitMessage), "[POSAO]: Izabrali ste mamac %s. Preostalo: %d.",
                RibolovacMamacNaziv[listitem], RibolovacMamac[playerid][listitem]);
            SendClientMessage(playerid, 0x00FF00FF, baitMessage);
            return 1;
        }
        case DIALOG_RIBOLOVAC_KUPI_STAP:
        {
            if(!response) return 1;
            if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC) return 1;
            if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0 ||
               !IsPlayerInRangeOfPoint(playerid, 4.0, RIBOLOVAC_STAP_X, RIBOLOVAC_STAP_Y, RIBOLOVAC_STAP_Z))
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Stap mozete kupiti samo na ribarskom standu.");
            if(listitem < 0 || listitem > 1) return 1;
            new businessid = FindJobBusiness(JOB_RIBOLOVAC);
            new price = (listitem == 0) ? 500 : 15000;
            if(businessid != -1)
            {
                price = BusinessRodPrice[businessid][listitem];
                if(!HasBusinessProducts(businessid, 1)) return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Ribarski biznis trenutno nema proizvoda na stanju.");
                if(MarketInfo[businessid][mBudzet] < 0 || price > MAX_MONEY_VALUE - MarketInfo[businessid][mBudzet])
                    return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Budzet ribarskog biznisa je dostigao dozvoljeni maksimum.");
            }
            if(price < 1 || price > 1000000)
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Cijena ovog stapa nije ispravna.");
            if(listitem == 1 && PlayerJobData[playerid][JobLevel] < RIBOLOVAC_MAX_LEVEL)
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Profesionalni stap mozete kupiti tek na 5. levelu Ribolovca.");
            if(GetPlayerMoney(playerid) < price)
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Nemate dovoljno novca za taj stap.");
            new file[128];
            if(!GetPlayerAccountPath(playerid, file, sizeof(file)))
                return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Korisnicki racun nije dostupan. Kupovina je otkazana.");
            GivePlayerMoney(playerid, -price);
            PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
            RibolovacStap[playerid] = listitem + 1;
            if(businessid != -1)
            {
                MarketInfo[businessid][mBudzet] += price;
                RemoveBusinessProducts(businessid, 1);
            }
            DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
            DOF2_SetInt(file, "RibolovacStap", RibolovacStap[playerid]);
            DOF2_SaveFile();
            if(PlayerJobData[playerid][JobDuty]) GiveRibolovacEquipment(playerid);
            SendClientMessage(playerid, 0x00FF00FF, listitem == 0 ? ("[POSAO]: Kupili ste Pocetnicki stap.") : ("[POSAO]: Kupili ste Profesionalni stap."));
            return 1;
        }
        case DIALOG_HAPPYJOB:
        {
            if(!response) return 1;
            if(!HasSpecialCommandAccess(playerid))
                return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: /happyjob je dostupan samo Vlasniku.");
            if(listitem == 0)
            {
                HappyJobId = 0;
                if(!DOF2_FileExists(STATS_SETTINGS_FILE)) DOF2_CreateFile(STATS_SETTINGS_FILE);
                DOF2_SetInt(STATS_SETTINGS_FILE, "HappyJobId", HappyJobId);
                DOF2_SaveFile();
                UpdateHudTip(0);
                SendClientMessageToAll(0xFFD700FF, "[HAPPY JOB]: Happy Job je ugasen.");
                return 1;
            }

            HappyJobId = listitem;
            if(HappyJobId < 1 || HappyJobId > JOB_RIBOLOVAC) return 1;
            if(!DOF2_FileExists(STATS_SETTINGS_FILE)) DOF2_CreateFile(STATS_SETTINGS_FILE);
            DOF2_SetInt(STATS_SETTINGS_FILE, "HappyJobId", HappyJobId);
            DOF2_SaveFile();
            UpdateHudTip(0);
            new jobName[32], message[128];
            GetJobName(HappyJobId, jobName, sizeof(jobName));
            format(message, sizeof(message), "[HAPPY JOB]: 2x %s je ukljucen.", jobName);
            SendClientMessageToAll(0xFFD700FF, message);
            return 1;
        }
        case DIALOG_GOTOJOB:
        {
            if(!response)return 1;switch(listitem){case 0:JuniorTeleport(playerid,1642.2,-1872.8,13.5);case 1:JuniorTeleport(playerid,330.7,-1509.8,36.0);case 2:JuniorTeleport(playerid,1753.7,-1894.4,13.6);case 3:JuniorTeleport(playerid,1019.4,-927.9,42.2);case 4:JuniorTeleport(playerid,RIBOLOVAC_POS_X,RIBOLOVAC_POS_Y,RIBOLOVAC_POS_Z);}return 1;
        }
        case DIALOG_GOTOPIJACA:
        {
            if(!response)return 1;switch(listitem){case 0:JuniorTeleport(playerid,1127.0,-1439.2,15.8);case 1:JuniorTeleport(playerid,-1954.0,287.0,35.5);case 2:JuniorTeleport(playerid,2131.0,1405.0,10.8);case 3:JuniorTeleport(playerid,1095.0,-1765.0,13.4);}return 1;
        }
        case DIALOG_AH:
        {
            return 1;
        }

        case DIALOG_RENT:
        {
            new vehicleid = RentPendingVehicle[playerid];
            RentPendingVehicle[playerid] = 0;
            if(!response)
            {
                if(IsPlayerInVehicle(playerid, vehicleid)) RemovePlayerFromVehicle(playerid);
                SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Odustali ste od iznajmljivanja vozila.");
                return 1;
            }
            if(listitem < 0 || listitem > 2 || !IsRentVehicle(vehicleid) || GetVehicleModel(vehicleid) == 0)
            {
                if(IsPlayerInVehicle(playerid, vehicleid)) RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Vozilo vise nije dostupno.");
            }
            if(RentPlayerVehicle[playerid])
            {
                if(IsPlayerInVehicle(playerid, vehicleid)) RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Vec imas iznajmljeno vozilo. Koristi /unrent.");
            }
            if(RentVehicleOwner[vehicleid])
            {
                if(IsPlayerInVehicle(playerid, vehicleid)) RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Ovo vozilo je vec iznajmljeno.");
            }
            if(!GetPVarInt(playerid, "BR_LoggedIn"))
            {
                if(IsPlayerInVehicle(playerid, vehicleid)) RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Prvo se prijavi na nalog.");
            }

            new Float:x, Float:y, Float:z;
            GetVehiclePos(vehicleid, x, y, z);
            if(!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
            {
                if(IsPlayerInVehicle(playerid, vehicleid)) RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Previse si se udaljio od vozila.");
            }

            new minutes, price;
            switch(listitem)
            {
                case 0: { minutes = 10; price = 200; }
                case 1: { minutes = 15; price = 300; }
                case 2: { minutes = 30; price = 600; }
            }
            if(GetPlayerMoney(playerid) < price)
            {
                if(IsPlayerInVehicle(playerid, vehicleid)) RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Nemas dovoljno RSD za iznajmljivanje.");
            }

            RentVehicleOwner[vehicleid] = playerid + 1;
            RentPlayerVehicle[playerid] = vehicleid;
            RentExpiresAt[playerid] = gettime() + minutes * 60;
            if(!IsPlayerInVehicle(playerid, vehicleid) && !PutPlayerInVehicle(playerid, vehicleid, 0))
            {
                StopPlayerRent(playerid, false);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Ulazak u vozilo nije uspio. Nista nije naplaceno.");
            }

            GivePlayerMoney(playerid, -price);
            RentPaidSincePayday[playerid] += price;
            PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
            new name[MAX_PLAYER_NAME], file[128];
            GetPlayerName(playerid, name, sizeof(name));
            format(file, sizeof(file), "Korisnici/%s.ini", name);
            if(DOF2_FileExists(file))
            {
                DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
                DOF2_SaveFile();
                UpdateBankaTD(playerid, DOF2_GetInt(file, "Banka"));
            }
            UpdateRentTextDraw(playerid);
            PlayerTextDrawShow(playerid, RentTextDraw[playerid]);
            new message[128];
            format(message, sizeof(message), "[RENT]: Vozilo iznajmljeno na %d min za %d RSD. /unrent za vracanje.", minutes, price);
            SendClientMessage(playerid, 0x00BFFFFF, message);
            return 1;
        }

        case DIALOG_HELP:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0: return ShowGeneralHelp(playerid);
                case 1: return ShowPlayerHelp(playerid);
                case 2: return ShowVehicleHelp(playerid);
                case 3: return ShowJobHelp(playerid);
                case 4: return ShowBusinessHelp(playerid);
                case 5: return ShowHouseHelp(playerid);
                case 6: return ShowFactionHelp(playerid);
                case 7:
                {
                    if(HasAdminCommandAccess(playerid)) return ShowAdminHelp(playerid);
                }
            }
            return 1;
        }

        case DIALOG_HELP_GENERAL, DIALOG_HELP_PLAYER, DIALOG_HELP_VEHICLE, DIALOG_HELP_JOB,
             DIALOG_BIZZ_HELP, DIALOG_HELP_HOUSE, DIALOG_HELP_FACTION:
        {
            if(response) return ShowMainHelp(playerid);
            return 1;
        }

        case DIALOG_ORG_MEMBERS:
        {
            // Samo zatvara prozor sa spiskom clanova kada se pritisne "Ok"
            return 1;
        }

        case DIALOG_REGISTRACIJA:
        {
            if(!response) return Kick(playerid);
            if(strlen(inputtext) < 4 || strlen(inputtext) > 30) return PrikaziRegisterProzor(playerid);

            format(RegLozinka[playerid], 64, "%s", inputtext);
            ShowPlayerDialog(playerid, DIALOG_POL, DIALOG_STYLE_LIST, "Da li ste Mu?ko ili ?ensko?", "Mu?ko\n?ensko", "U redu", "Odustani");
            return 1;
        }

        case DIALOG_LOGIN:
        {
            if(!response) return Kick(playerid);

            new file[128], pass[64], ime[MAX_PLAYER_NAME];
            GetPlayerName(playerid, ime, sizeof(ime));
            format(file, sizeof(file), "Korisnici/%s.ini", ime);

            if(DOF2_FileExists(file))
            {
                format(pass, sizeof(pass), "%s", DOF2_GetString(file, "Password"));
                if(!strcmp(pass, inputtext, false))
                {
                    new admin_lvl = DOF2_GetInt(file, "Admin");
                    if(admin_lvl > 0 && DOF2_IsSet(file, "AdminKod"))
                    {
                        ShowPlayerDialog(playerid, DIALOG_ADMINKOD, DIALOG_STYLE_PASSWORD, "Admin Login Kod", "{FFFFFF}Unesite va? tajni admin kod da biste potvrdili identitet:\n{FF0000}Napomena: Pogre?an kod vas automatski kickuje sa servera!", "Potvrdi", "Izlaz");
                        return 1;
                    }

                    new helper_lvl = DOF2_GetInt(file, "Helper");
                    if(helper_lvl > 0 && DOF2_IsSet(file, "HelperCode"))
                    {
                        ShowPlayerDialog(playerid, DIALOG_HELPERKOD, DIALOG_STYLE_PASSWORD, "Helper Login Kod", "{FFFFFF}Unesite va? tajni helper kod da biste potvrdili identitet:\n{FF0000}Napomena: Pogre?an kod vas automatski kickuje sa servera!", "Potvrdi", "Izlaz");
                        return 1;
                    }

                    SendClientMessage(playerid, PLAVA_BOJA, "[Balkan Revolution]: Uspje?no ste se ulogovali!");
                    SetPlayerScore(playerid, DOF2_GetInt(file, "Level"));
                    ResetPlayerMoney(playerid);
                    GivePlayerMoney(playerid, DOF2_GetInt(file, "Novac"));
                    PlayerZlato[playerid] = DOF2_GetInt(file, "Zlato");
                    IgracKrediti[playerid] = DOF2_GetInt(file, "Krediti");
                    UpdateZlatoTD(playerid);
                    UpdateBankaTD(playerid, DOF2_GetInt(file, "Banka"));
                    PlayerTextDrawShow(playerid, TD_Grad[playerid]);
                    PlayerTextDrawShow(playerid, TD_Lokacija[playerid]);
                    SetSpawnInfo(playerid, 0, 247, 1759.1915, -1898.1232, 13.5568, 0.0, 0, 0, 0, 0, 0, 0);
                    SpawnPlayer(playerid);
                    PrikaziPorukuDobrodoslice(playerid);
                    HideAuthTextDraws(playerid);
                    SetPVarInt(playerid, "BR_LoggedIn", 1);
                    SetTimerEx("JuniorApplyPenalties", 750, false, "i", playerid);
                    LoadWantedState(playerid);
                }
                else
                {
                    SendClientMessage(playerid, ZUTA_BOJA, "[Balkan Revolution]: Pogre?na lozinka!");
                    PrikaziLoginProzor(playerid);
                }
            }
            return 1;
        }

        case DIALOG_POL:
        {
            if(!response) return PrikaziRegisterProzor(playerid);
            RegPol[playerid] = listitem;
            ShowPlayerDialog(playerid, DIALOG_GODINE, DIALOG_STYLE_LIST, "Koliko imate godina?", "10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23\n24\n25\n26\n27\n28\n29\n30\n31\n32\n33\n34\n35\n36\n37\n38\n39\n40", "U redu", "Odustani");
            return 1;
        }

        case DIALOG_GODINE:
        {
            if(!response) return 1;
            RegGodine[playerid] = 10 + listitem;
            ShowPlayerDialog(playerid, DIALOG_DRZAVA, DIALOG_STYLE_LIST, "Odakle ste?", "Srbija\nBosna i Hercegovina\nRepublika Srpska\nHrvatska\nCrna Gora\nMakedonija\nSlovenija\nOstalo", "U redu", "Odustani");
            return 1;
        }

        case DIALOG_DRZAVA:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0: format(RegDrzava[playerid], 32, "Srbija");
                case 1: format(RegDrzava[playerid], 32, "Bosna i Hercegovina");
                case 2: format(RegDrzava[playerid], 32, "Republika Srpska");
                case 3: format(RegDrzava[playerid], 32, "Hrvatska");
                case 4: format(RegDrzava[playerid], 32, "Crna Gora");
                case 5: format(RegDrzava[playerid], 32, "Makedonija");
                case 6: format(RegDrzava[playerid], 32, "Slovenija");
                default: format(RegDrzava[playerid], 32, "Ostalo");
            }
            new file[128], name[MAX_PLAYER_NAME];
            GetPlayerName(playerid, name, sizeof(name));
            format(file, sizeof(file), "Korisnici/%s.ini", name);
            DOF2_CreateFile(file);
            DOF2_SetString(file, "Password", RegLozinka[playerid]);
            DOF2_SetInt(file, "Pol", RegPol[playerid]);
            DOF2_SetInt(file, "Godine", RegGodine[playerid]);
            DOF2_SetString(file, "Drzava", RegDrzava[playerid]);
            DOF2_SetInt(file, "Level", 1);
            DOF2_SetInt(file, "Novac", 5000);
            DOF2_SetInt(file, "Banka", 0);
            DOF2_SetInt(file, "BankovniRacun", 0);
            DOF2_SetInt(file, "Euro", 0);
            DOF2_SetInt(file, "Zlato", 0);
            DOF2_SetInt(file, "Krediti", 0);
            DOF2_SetInt(file, "Respekti", 0);
            DOF2_SetInt(file, "Sati", 0);
            DOF2_SetInt(file, "MinuteIgranja", 0);
            DOF2_SetInt(file, "Upozorenja", 0);
            DOF2_SetInt(file, "Osiguranja", 0);
            DOF2_SetInt(file, "RolePlayRank", 0);
            DOF2_SetInt(file, "DonatePoeni", 0);
            DOF2_SetInt(file, "DosijeUbistva", 0);
            DOF2_SetInt(file, "DosijeSmrti", 0);
            DOF2_SetInt(file, "DosijeZlocini", 0);
            DOF2_SetInt(file, "DosijeUhapsen", 0);
            DOF2_SetInt(file, "DosijeTiketi", 0);
            DOF2_SetInt(file, "DosijeLTA", 0);
            DOF2_SetInt(file, "AdminKazne", 0);
            DOF2_SetInt(file, "BolestanDo", 0);
            DOF2_SetInt(file, "Posao", JOB_NONE);
            DOF2_SetInt(file, "JobLevel_3", 1);
            DOF2_SetInt(file, "JobXP_3", 0);
            DOF2_SetInt(file, "RibolovacUlov", 0);
            DOF2_SetInt(file, "RibolovacTezina", 0);
            DOF2_SetInt(file, "RibolovacVrijednost", 0);
            DOF2_SetInt(file, "RibolovacSardina", 0);
            DOF2_SetInt(file, "RibolovacSkusa", 0);
            DOF2_SetInt(file, "RibolovacBrancin", 0);
            DOF2_SetInt(file, "RibolovacTuna", 0);
            DOF2_SetInt(file, "RibolovacMamacHljeb", 0);
            DOF2_SetInt(file, "RibolovacMamacCrvi", 0);
            DOF2_SetInt(file, "RibolovacMamacLignja", 0);
            DOF2_SetInt(file, "RibolovacAktivniMamac", -1);
            DOF2_SetInt(file, "RibolovacBonusRibe", 0);
            DOF2_SetInt(file, "RibolovacOriginalSkin", -1);
            DOF2_SetInt(file, "RibolovacUniformaAktivna", 0);
            DOF2_SetInt(file, "Kuca", -1);
            DOF2_SetInt(file, "Bizz", -1);
            DOF2_SetInt(file, "Vozilo1", -1);
            DOF2_SetInt(file, "Vozilo2", -1);
            DOF2_SetInt(file, "VoziloDonator", -1);
            new regYear, regMonth, regDay, regHour, regMinute, regSecond, registration[32];
            getdate(regYear, regMonth, regDay);
            gettime(regHour, regMinute, regSecond);
            format(registration, sizeof(registration), "%02d.%02d.%04d | %02d:%02d:%02d", regDay, regMonth, regYear, regHour, regMinute, regSecond);
            DOF2_SetString(file, "Registrovan", registration);
            DOF2_SaveFile();
            SetPlayerScore(playerid, 1);
            ResetPlayerMoney(playerid);
            GivePlayerMoney(playerid, 5000);
            HideAuthTextDraws(playerid);
            SetPVarInt(playerid, "BR_LoggedIn", 1);
            SetTimerEx("JuniorApplyPenalties", 750, false, "i", playerid);
            LoadWantedState(playerid);
            PlayerZlato[playerid] = 0;
            PlayerRespekti[playerid] = 0;
            PlayerMinute[playerid] = 0;
            IgracKrediti[playerid] = 0;
            UpdateZlatoTD(playerid);
            UpdateBankaTD(playerid, 0);
            PlayerTextDrawShow(playerid, TD_Grad[playerid]);
            PlayerTextDrawShow(playerid, TD_Lokacija[playerid]);
            SendClientMessage(playerid, PLAVA_BOJA, "[Balkan Revolution]: Uspje?no ste se registrovali i dobili 5000 dinara!");
            PokreniIntro(playerid);
            return 1;
        }

        case DIALOG_RADIO:
        {
            if(response)
            {
                new radioIme[32];
                switch(listitem)
                {
                    case 0: { PlayAudioStreamForPlayer(playerid, "https://a7.asurahosting.com/listen/balkan_radio_hit/radio.mp3"); format(radioIme, 32, "Balkan Radio Hit"); }
                    case 1: { PlayAudioStreamForPlayer(playerid, "https://coolradio.rs/player/"); format(radioIme, 32, "Cool Radio"); }
                    case 2: { PlayAudioStreamForPlayer(playerid, "https://radiosehara.net/"); format(radioIme, 32, "Radio Sehara"); }
                    case 3: { PlayAudioStreamForPlayer(playerid, "https://streaming.extrafm.hr/stream/extradab.html"); format(radioIme, 32, "Extra FM"); }
                    case 4: { PlayAudioStreamForPlayer(playerid, "http://91.222.11.134:8000/"); format(radioIme, 32, "RTV Puls Brcko"); }
                }
                ApplySavedHeadphones(playerid);
                new string[128];
                format(string, sizeof(string), "[BR]: Pustili ste radio: %s.", radioIme);
                SendClientMessage(playerid, PLAVA_BOJA, string);
            }
            return 1;
        }

        case DIALOG_ADMIN_CODE_NOTICE:
        {
            return 1;
        }

        case DIALOG_SET_ADMIN_CODE:
        {
            if(!response) return 1;
            if(!GetPVarInt(playerid, "BR_LoggedIn"))
                return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Prvo se prijavite na nalog.");

            new file[128], ime[MAX_PLAYER_NAME];
            GetPlayerName(playerid, ime, sizeof(ime));
            format(file, sizeof(file), "Korisnici/%s.ini", ime);
            if(!DOF2_FileExists(file))
                return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Nalog nije pronaden.");
            if(DOF2_GetInt(file, "Admin") < 9 && !IsPlayerAdmin(playerid))
                return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Samo vlasnik ili RCON admin moze promijeniti kod.");

            new length = strlen(inputtext);
            if(length < 1 || length > 32)
                return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Kod mora imati 1-32 znaka.");
            for(new i = 0; i < length; i++)
            {
                if(inputtext[i] < 33 || inputtext[i] > 126 || inputtext[i] == '=')
                    return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Koristi vidljive znakove bez razmaka i znaka =.");
            }

            DOF2_SetString(file, "AdminKod", inputtext);
            DOF2_SaveFile();
            SendClientMessage(playerid, 0x00BFFFFF, "[ADMIN KOD]: Novi admin kod je sacuvan. Koristi ga pri sljedecoj prijavi.");
            return 1;
        }
        case DIALOG_ADMINKOD:
        {
            if(!response) return Kick(playerid);
            new file[128], ime[MAX_PLAYER_NAME];
            GetPlayerName(playerid, ime, sizeof(ime));
            format(file, sizeof(file), "Korisnici/%s.ini", ime);
            if(DOF2_FileExists(file))
            {
                new sacuvani_kod[64];
                format(sacuvani_kod, sizeof(sacuvani_kod), "%s", DOF2_GetString(file, "AdminKod"));
                if(strlen(sacuvani_kod) && !strcmp(inputtext, sacuvani_kod, false))
                {
                    SendClientMessage(playerid, 0x00FF00FF, "[Balkan Revolution]: Uspje?no ste unijeli admin kod. Dobrodo?li nazad!");
                    SetPlayerScore(playerid, DOF2_GetInt(file, "Level"));
                    ResetPlayerMoney(playerid);
                    GivePlayerMoney(playerid, DOF2_GetInt(file, "Novac"));
                    PlayerZlato[playerid] = DOF2_GetInt(file, "Zlato");
                    IgracKrediti[playerid] = DOF2_GetInt(file, "Krediti");
                    UpdateZlatoTD(playerid);
                    UpdateBankaTD(playerid, DOF2_GetInt(file, "Banka"));
                    PlayerTextDrawShow(playerid, TD_Grad[playerid]);
                    PlayerTextDrawShow(playerid, TD_Lokacija[playerid]);
                    SetSpawnInfo(playerid, 0, 247, 1759.1915, -1898.1232, 13.5568, 0.0, 0, 0, 0, 0, 0, 0);
                    SpawnPlayer(playerid);
                    PrikaziPorukuDobrodoslice(playerid);
                    HideAuthTextDraws(playerid);
                    SetPVarInt(playerid, "BR_LoggedIn", 1);
                    SetTimerEx("JuniorApplyPenalties", 750, false, "i", playerid);
                    LoadWantedState(playerid);
                }
                else
                {
                    SendClientMessage(playerid, 0xFF0000FF, "[ANTICHETE/ADMIN]: Unijeli ste pogre?an admin kod! Izbaceni ste sa servera.");
                    Kick(playerid);
                }
            }
            return 1;
        }

        case DIALOG_HELPERKOD:
        {
            if(!response) return Kick(playerid);
            new file[128], ime[MAX_PLAYER_NAME];
            GetPlayerName(playerid, ime, sizeof(ime));
            format(file, sizeof(file), "Korisnici/%s.ini", ime);
            if(DOF2_FileExists(file))
            {
                new sacuvani_kod[32];
                format(sacuvani_kod, sizeof(sacuvani_kod), "%s", DOF2_GetString(file, "HelperCode"));
                if(!strcmp(sacuvani_kod, inputtext, false))
                {
                    SendClientMessage(playerid, 0x00FF00FF, "[Balkan Revolution]: Uspje?no ste unijeli helper kod. Dobrodo?li nazad!");
                    SetPlayerScore(playerid, DOF2_GetInt(file, "Level"));
                    ResetPlayerMoney(playerid);
                    GivePlayerMoney(playerid, DOF2_GetInt(file, "Novac"));
                    PlayerZlato[playerid] = DOF2_GetInt(file, "Zlato");
                    IgracKrediti[playerid] = DOF2_GetInt(file, "Krediti");
                    UpdateZlatoTD(playerid);
                    UpdateBankaTD(playerid, DOF2_GetInt(file, "Banka"));
                    PlayerTextDrawShow(playerid, TD_Grad[playerid]);
                    PlayerTextDrawShow(playerid, TD_Lokacija[playerid]);
                    SetSpawnInfo(playerid, 0, 247, 1759.1915, -1898.1232, 13.5568, 0.0, 0, 0, 0, 0, 0, 0);
                    SpawnPlayer(playerid);
                    PrikaziPorukuDobrodoslice(playerid);
                    HideAuthTextDraws(playerid);
                    SetPVarInt(playerid, "BR_LoggedIn", 1);
                    SetTimerEx("JuniorApplyPenalties", 750, false, "i", playerid);
                    LoadWantedState(playerid);
                }
                else
                {
                    SendClientMessage(playerid, 0xFF0000FF, "[ANTICHETE/HELPER]: Unijeli ste pogre?an helper kod! Izbaceni ste sa servera.");
                    Kick(playerid);
                }
            }
            return 1;
        }

        // --- DIJALOZI ZA TRAFIKU ---
        case DIALOG_TRAFIKA: {
            if(!response) return 1;

            if(listitem == 0) // Sokovi
            {
                ShowPlayerDialog(playerid, DIALOG_TRAFIKA_SOK, DIALOG_STYLE_TABLIST_HEADERS, "Trafika - Sokovi",
                    "Proizvod\tCena\tHP\n\
                    Pepsi\t40 RSD\t8 HP\n\
                    Koka Kola\t50 RSD\t10 HP\n\
                    Sprajt\t50 RSD\t10 HP\n\
                    Kokta\t60 RSD\t12 HP\n\
                    Sveps\t50 RSD\t10 HP", "Kupi", "Odustani");
            }
            else if(listitem == 1) // Hrana
            {
                ShowPlayerDialog(playerid, DIALOG_TRAFIKA_HRANA, DIALOG_STYLE_TABLIST_HEADERS, "Trafika - Hrana",
                    "Proizvod\tCena\tHP\n\
                    Cips\t40 RSD\t8 HP\n\
                    Smoki\t40 RSD\t8 HP\n\
                    Cokoladica\t25 RSD\t5 HP\n\
                    Zvaka\t10 RSD\t2 HP", "Kupi", "Odustani");
            }
            else if(listitem == 2) // Kredit
            {
                ShowPlayerDialog(playerid, DIALOG_TRAFIKA_KREDIT, DIALOG_STYLE_TABLIST_HEADERS, "Trafika - Kredit",
                    "Usluga\tCena\n\
                    100 Kredita\t200 RSD\n\
                    200 Kredita\t400 RSD\n\
                    500 Kredita\t1000 RSD\n\
                    1000 Kredita\t2000 RSD", "Kupi", "Odustani");
            }
            return 1;
        }

        case DIALOG_TRAFIKA_SOK: {
            if(!response) return 1;

            new cijene_trafika[] = {40, 50, 50, 60, 50};
            new hpplus_trafika[] = {8, 10, 10, 12, 10};

            if(listitem < 0 || listitem >= sizeof(cijene_trafika)) return 1;

            if(GetPlayerMoney(playerid) < cijene_trafika[listitem]) {
                return SendClientMessage(playerid, 0xFF0000FF, "Greska: Nemate dovoljno novca (RSD)!");
            }

            GivePlayerMoney(playerid, -cijene_trafika[listitem]);

            new Float:hp;
            GetPlayerHealth(playerid, hp);
            SetPlayerHealth(playerid, hp + hpplus_trafika[listitem]);

            new tid = -1;
            for(new i = 0; i < MAX_TRAFIKE; i++)
            {
                if(TrafikaInfo[i][tEntranceX] != 0.0 && IsPlayerInRangeOfPoint(playerid, 6.0, TrafikaInfo[i][tEntranceX], TrafikaInfo[i][tEntranceY], TrafikaInfo[i][tEntranceZ]))
                {
                    tid = i;
                    break;
                }
            }
            if(tid != -1)
            {
                TrafikaInfo[tid][tBudzet] += (cijene_trafika[listitem] / 2);
                UpdateTrafikuCP(tid);
                SaveTrafiku(tid);
            }

            new file[64], pname[MAX_PLAYER_NAME];
            GetPlayerName(playerid, pname, sizeof(pname));
            format(file, sizeof(file), "Korisnici/%s.ini", pname);
            if(DOF2_FileExists(file))
            {
                DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
                DOF2_SaveFile();
            }

            SendClientMessage(playerid, 0x00FF00FF, "Trafika: Uspje?no ste kupili sok i osvje?ili se!");
            return 1;
        }

        case DIALOG_TRAFIKA_HRANA: {
            if(!response) return 1;

            new cijene_tr_hrana[] = {40, 40, 25, 10};
            new hpplus_tr_hrana[] = {8, 8, 5, 2};

            if(listitem < 0 || listitem >= sizeof(cijene_tr_hrana)) return 1;

            if(GetPlayerMoney(playerid) < cijene_tr_hrana[listitem]) {
                return SendClientMessage(playerid, 0xFF0000FF, "Greska: Nemate dovoljno novca (RSD)!");
            }

            GivePlayerMoney(playerid, -cijene_tr_hrana[listitem]);

            new Float:hp;
            GetPlayerHealth(playerid, hp);
            SetPlayerHealth(playerid, hp + hpplus_tr_hrana[listitem]);

            new tid = -1;
            for(new i = 0; i < MAX_TRAFIKE; i++)
            {
                if(TrafikaInfo[i][tEntranceX] != 0.0 && IsPlayerInRangeOfPoint(playerid, 6.0, TrafikaInfo[i][tEntranceX], TrafikaInfo[i][tEntranceY], TrafikaInfo[i][tEntranceZ]))
                {
                    tid = i;
                    break;
                }
            }
            if(tid != -1)
            {
                TrafikaInfo[tid][tBudzet] += (cijene_tr_hrana[listitem] / 2);
                UpdateTrafikuCP(tid);
                SaveTrafiku(tid);
            }

            new file[64], pname[MAX_PLAYER_NAME];
            GetPlayerName(playerid, pname, sizeof(pname));
            format(file, sizeof(file), "Korisnici/%s.ini", pname);
            if(DOF2_FileExists(file))
            {
                DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
                DOF2_SaveFile();
            }

            SendClientMessage(playerid, 0x00FF00FF, "Trafika: Uspje?no ste pojeli proizvod!");
            return 1;
        }

        case DIALOG_TRAFIKA_KREDIT: {
            if(!response) return 1;

            new cijene_kredit[] = {200, 400, 1000, 2000};
            new kreditiAdd[] = {100, 200, 500, 1000};

            if(listitem < 0 || listitem >= sizeof(cijene_kredit)) return 1;

            if(GetPlayerMoney(playerid) < cijene_kredit[listitem]) {
                return SendClientMessage(playerid, 0xFF0000FF, "Greska: Nemate dovoljno novca (RSD) za kredite!");
            }

            GivePlayerMoney(playerid, -cijene_kredit[listitem]);
            IgracKrediti[playerid] += kreditiAdd[listitem];

            new tid = -1;
            for(new i = 0; i < MAX_TRAFIKE; i++)
            {
                if(TrafikaInfo[i][tEntranceX] != 0.0 && IsPlayerInRangeOfPoint(playerid, 6.0, TrafikaInfo[i][tEntranceX], TrafikaInfo[i][tEntranceY], TrafikaInfo[i][tEntranceZ]))
                {
                    tid = i;
                    break;
                }
            }
            if(tid != -1)
            {
                TrafikaInfo[tid][tBudzet] += (cijene_kredit[listitem] / 2);
                UpdateTrafikuCP(tid);
                SaveTrafiku(tid);
            }

            new file[64], pname[MAX_PLAYER_NAME];
            GetPlayerName(playerid, pname, sizeof(pname));
            format(file, sizeof(file), "Korisnici/%s.ini", pname);
            if(DOF2_FileExists(file))
            {
                DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
                DOF2_SetInt(file, "Krediti", IgracKrediti[playerid]);
                DOF2_SaveFile();
            }

            SendClientMessage(playerid, 0x00FF00FF, "Trafika: Uspje?no ste kupili kredite!");
            return 1;
        }

        // --- DIJALOG ZA KUPOVINU SATA U ZLATARE ---
        case 9875:
        {
            if(!response)
            {
                DeletePVar(playerid, "ZlataraID");
                return 1;
            }

            new zlatara_id = GetPVarInt(playerid, "ZlataraID");
            DeletePVar(playerid, "ZlataraID");

            // Sigurnosna detaljna provera ukoliko PVar nije bio postavljen
            if(zlatara_id < 0 || zlatara_id >= MAX_ZLATA)
            {
                new vw_z = GetPlayerVirtualWorld(playerid);
                if(vw_z >= 6000 && (vw_z - 6000) < MAX_ZLATA)
                {
                    zlatara_id = vw_z - 6000;
                }
                else
                {
                    for(new z = 0; z < MAX_ZLATA; z++)
                    {
                        if(IsPlayerInRangeOfPoint(playerid, 10.0, ZlataInfo[z][zEntranceX], ZlataInfo[z][zEntranceY], ZlataInfo[z][zEntranceZ]) ||
                           IsPlayerInRangeOfPoint(playerid, 10.0, ZlataInfo[z][zExitX], ZlataInfo[z][zExitY], ZlataInfo[z][zExitZ]))
                        {
                            zlatara_id = z;
                            break;
                        }
                    }
                }
            }

            new cijena = 0;
            new naziv_sata[32];

            switch(listitem)
            {
                case 0: { cijena = 15000; format(naziv_sata, sizeof(naziv_sata), "Rolex Gold"); }
                case 1: { cijena = 10000; format(naziv_sata, sizeof(naziv_sata), "Diamond Watch"); }
                case 2: { cijena = 7500;  format(naziv_sata, sizeof(naziv_sata), "Platinum Chronograph"); }
                case 3: { cijena = 3000;  format(naziv_sata, sizeof(naziv_sata), "Classic Silver Watch"); }
                case 4: { cijena = 800;   format(naziv_sata, sizeof(naziv_sata), "Digital Plastic Watch"); }
                default: return 1;
            }

            if(GetPlayerMoney(playerid) < cijena)
            {
                SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Nemate dovoljno novca za ovaj sat!");
                return 1;
            }

            GivePlayerMoney(playerid, -cijena);

            if(zlatara_id >= 0 && zlatara_id < MAX_ZLATA)
            {
                new zarada_zlatare = floatround(cijena * 0.60);
                ZlataInfo[zlatara_id][zBudzet] += zarada_zlatare;
                UpdateZlataruCP(zlatara_id);
                SaveZlataru(zlatara_id);
            }

            new file[64], pname[MAX_PLAYER_NAME];
            GetPlayerName(playerid, pname, sizeof(pname));
            format(file, sizeof(file), "Korisnici/%s.ini", pname);
            if(DOF2_FileExists(file))
            {
                DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
                DOF2_SetString(file, "Sat", naziv_sata);
                DOF2_SaveFile();
            }

            SendClientMessage(playerid, 0x00BFFFFF, "--------------------------------------------------");
            new string[128];
            format(string, sizeof(string), "Uspje?no ste kupili rucni sat: {FFFF00}%s {00BFFF}za {00AA00}$%d.", naziv_sata, cijena);
            SendClientMessage(playerid, 0x00BFFFFF, string);
            SendClientMessage(playerid, 0xFFFFFFFF, "Sada u svakom trenutku mo?ete ukucati komandu {FFFF00}/time {FFFFFF}da vidite tacno vrijeme na ekranu.");
            SendClientMessage(playerid, 0x00BFFFFF, "--------------------------------------------------");
            return 1;
        }

        case 9988:
        {
            if(!response) return 1;
            if(listitem < 0) return 1;

            new cijena = TelLista[listitem][tCijena];
            if(GetPlayerMoney(playerid) < cijena)
            {
                SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Nemate dovoljno novca za ovaj telefon!");
                return 1;
            }
            GivePlayerMoney(playerid, -cijena);
            new file[128], ime[MAX_PLAYER_NAME];
            GetPlayerName(playerid, ime, sizeof(ime));
            format(file, sizeof(file), "Korisnici/%s.ini", ime);
            if(DOF2_FileExists(file))
            {
                new preostali_novac = DOF2_GetInt(file, "Novac") - cijena;
                DOF2_SetInt(file, "Novac", preostali_novac);
                DOF2_SetString(file, "Telefon", TelLista[listitem][tNaziv]);
                DOF2_SaveFile();
            }
            new poruka[128];
            format(poruka, sizeof(poruka), "[Balkan Revolution]: Uspje?no ste kupili telefon %s za $%d!", TelLista[listitem][tNaziv], cijena);
            SendClientMessage(playerid, 0x00BFFFFF, poruka);
            return 1;
        }

        case DIALOG_MARKET_SIM:
        {
            if(!response) return 1;

            new cijene_sim[] = {1000, 500, 1000, 100, 1000, 10000, 10000, 1000, 300, 100, 500};
            new nazivi_sim[11][32] = {
                "Imenik", "SIM Kartica", "Kockica", "Kondom",
                "Foto aparat", "Sat", "Oprema za pecanje",
                "Konopac", "Sprej", "Upaljac", "Cigarete"
            };

            if(listitem < 0 || listitem >= sizeof(cijene_sim)) return 1;

            // PREPOZNAVANJE TACNOG MARKETA (VW + POZICIJA)
            new marketidx_sim = -1;
            new vw_sim = GetPlayerVirtualWorld(playerid);

            if(vw_sim >= 5000 && (vw_sim - 5000) < MAX_MARKETA)
            {
                marketidx_sim = vw_sim - 5000;
            }
            else
            {
                for(new m = 0; m < MAX_MARKETA; m++)
                {
                    if(IsPlayerInRangeOfPoint(playerid, 10.0, MarketInfo[m][mEntranceX], MarketInfo[m][mEntranceY], MarketInfo[m][mEntranceZ]) ||
                       IsPlayerInRangeOfPoint(playerid, 10.0, MarketInfo[m][mExitX], MarketInfo[m][mExitY], MarketInfo[m][mExitZ]))
                    {
                        marketidx_sim = m;
                        break;
                    }
                }
            }

            if(GetPlayerMoney(playerid) < cijene_sim[listitem]) {
                new string[128];
                format(string, sizeof(string), "[Gre?ka] {FFFFFF}Nemate dovoljno novca! Artikal ko?ta $%d.", cijene_sim[listitem]);
                SendClientMessage(playerid, 0xFF0000FF, string);
                return 1;
            }

            GivePlayerMoney(playerid, -cijene_sim[listitem]);

            if(marketidx_sim >= 0 && marketidx_sim < MAX_MARKETA)
            {
                MarketInfo[marketidx_sim][mBudzet] += cijene_sim[listitem];
                UpdateMarketCP(marketidx_sim);
                SaveMarket(marketidx_sim);
            }

            switch(listitem)
            {
                case 0: PlayerInfo[playerid][pImenik] = 1;
                case 1:
                {
                    new random_broj = 0, multiplier = 1;
                    for(new i = 0; i < 6; i++)
                    {
                        new cifra = 1 + random(8);
                        random_broj += cifra * multiplier;
                        multiplier *= 10;
                    }
                    PlayerInfo[playerid][pBrojTelefona] = random_broj;
                    new tel_msg[128];
                    format(tel_msg, sizeof(tel_msg), "{00FF00}[Telefon] {FFFFFF}Uspje?no ste kupili SIM karticu. Va? novi broj: %d", random_broj);
                    SendClientMessage(playerid, -1, tel_msg);
                }
                case 5: SendClientMessage(playerid, 0x00FF00FF, "[Market] {FFFFFF}Uspje?no ste kupili i stavili sat na ruku!");
            }

            if(listitem != 1)
            {
                new string[128];
                format(string, sizeof(string), "[Market] {FFFFFF}Uspje?no ste kupili {00FF00}%s {FFFFFF}za ${FFCC00}%d.", nazivi_sim[listitem], cijene_sim[listitem]);
                SendClientMessage(playerid, 0x00FF00FF, string);
            }

            new file[64], pname[MAX_PLAYER_NAME];
            GetPlayerName(playerid, pname, sizeof(pname));
            format(file, sizeof(file), "Korisnici/%s.ini", pname);
            if(DOF2_FileExists(file))
            {
                DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
                DOF2_SetInt(file, "Imenik", PlayerInfo[playerid][pImenik]);
                DOF2_SetInt(file, "BrojTelefona", PlayerInfo[playerid][pBrojTelefona]);
                DOF2_SaveFile();
            }
            return 1;
        }

        case DIALOG_MARKET_HRANA:
        {
            if(!response) return 1;

            new cijene_hrana[] = {350, 120, 80, 50, 60, 90};
            new nazivi_hrana[6][20] = {"Meso", "Mleko", "Hleb", "Jabuke", "Banana", "Sok"};

            if(listitem < 0 || listitem >= sizeof(cijene_hrana)) return 1;

            // PREPOZNAVANJE TACNOG MARKETA (VW + POZICIJA)
            new marketidx_hrana = -1;
            new vw_hrana = GetPlayerVirtualWorld(playerid);

            if(vw_hrana >= 5000 && (vw_hrana - 5000) < MAX_MARKETA)
            {
                marketidx_hrana = vw_hrana - 5000;
            }
            else
            {
                for(new m = 0; m < MAX_MARKETA; m++)
                {
                    if(IsPlayerInRangeOfPoint(playerid, 10.0, MarketInfo[m][mEntranceX], MarketInfo[m][mEntranceY], MarketInfo[m][mEntranceZ]) ||
                       IsPlayerInRangeOfPoint(playerid, 10.0, MarketInfo[m][mExitX], MarketInfo[m][mExitY], MarketInfo[m][mExitZ]))
                    {
                        marketidx_hrana = m;
                        break;
                    }
                }
            }

            if(GetPlayerMoney(playerid) < cijene_hrana[listitem]) {
                new string[128];
                format(string, sizeof(string), "[Gre?ka] {FFFFFF}Nemate dovoljno novca! Artikal ko?ta $%d.", cijene_hrana[listitem]);
                SendClientMessage(playerid, 0xFF0000FF, string);
                return 1;
            }

            GivePlayerMoney(playerid, -cijene_hrana[listitem]);

            switch(listitem)
            {
                case 0: PlayerInfo[playerid][pMeso] += 10;
                case 1: PlayerInfo[playerid][pMleko] += 10;
                case 2: PlayerInfo[playerid][pHleb] += 10;
                case 3: PlayerInfo[playerid][pJabuke] += 10;
                case 4: PlayerInfo[playerid][pBanana] += 10;
                case 5: PlayerInfo[playerid][pSok] += 10;
            }

            if(marketidx_hrana >= 0 && marketidx_hrana < MAX_MARKETA)
            {
                MarketInfo[marketidx_hrana][mBudzet] += cijene_hrana[listitem];
                UpdateMarketCP(marketidx_hrana);
                SaveMarket(marketidx_hrana);
            }

            new file[64], pname[MAX_PLAYER_NAME];
            GetPlayerName(playerid, pname, sizeof(pname));
            format(file, sizeof(file), "Korisnici/%s.ini", pname);
            if(DOF2_FileExists(file))
            {
                DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
                DOF2_SetInt(file, "Meso", PlayerInfo[playerid][pMeso]);
                DOF2_SetInt(file, "Mleko", PlayerInfo[playerid][pMleko]);
                DOF2_SetInt(file, "Hleb", PlayerInfo[playerid][pHleb]);
                DOF2_SetInt(file, "Jabuke", PlayerInfo[playerid][pJabuke]);
                DOF2_SetInt(file, "Banana", PlayerInfo[playerid][pBanana]);
                DOF2_SetInt(file, "Sok", PlayerInfo[playerid][pSok]);
                DOF2_SaveFile();
            }

            new string[128];
            format(string, sizeof(string), "[Market] {FFFFFF}Uspje?no ste kupili {00FF00}10x %s {FFFFFF}za ${FFCC00}%d.", nazivi_hrana[listitem], cijene_hrana[listitem]);
            SendClientMessage(playerid, 0x00FF00FF, string);
            return 1;
        }
    }
    return 0;
}
stock PokreniIntro(playerid)
{
    IntroKorak[playerid] = 1;
    TogglePlayerSpectating(playerid, 1);
    TimerIntro[playerid] = SetTimerEx("ZavrsiIntroKorak", 6000, true, "i", playerid);

    SetPlayerCameraPos(playerid, 1642.12, -2240.15, 120.45);
    SetPlayerCameraLookAt(playerid, 1759.19, -1898.12, 13.55);
    return 1;
}

stock PrikaziPorukuDobrodoslice(playerid)
{
    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    // Ucitavamo level i admin rank iz fajla
    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new nivo = DOF2_GetInt(file, "Level");
    new admin_lvl = DOF2_GetInt(file, "Admin");
    new vip = 0; // Ako bude? pravio VIP sistem kasnije

    // Pretvaramo broj admin ranka u tekst za poruku dobrodo?lice
    new admin_naziv[32];
    switch(admin_lvl)
    {
        case 1: format(admin_naziv, sizeof(admin_naziv), "Admin 1");
        case 2: format(admin_naziv, sizeof(admin_naziv), "Admin 3"); // Prateci tvoju skalu
        case 3: format(admin_naziv, sizeof(admin_naziv), "Admin 5");
        case 4: format(admin_naziv, sizeof(admin_naziv), "Head Admin");
        case 5: format(admin_naziv, sizeof(admin_naziv), "Director");
        case 6: format(admin_naziv, sizeof(admin_naziv), "Mapper");
        case 7: format(admin_naziv, sizeof(admin_naziv), "Skrippter");
        case 8: format(admin_naziv, sizeof(admin_naziv), "Suvlasnik");
        case 9: format(admin_naziv, sizeof(admin_naziv), "Vlasnik");
        default: format(admin_naziv, sizeof(admin_naziv), "Nema");
    }

    SendClientMessage(playerid, PLAVA_LINIJA, "--------------------| Balkan-Revolution |--------------------");
    new string[128];
    format(string, sizeof(string), "Pozz Tebra %s, Dobrodosao na Balkan Revolution RolePlay", ime);
    SendClientMessage(playerid, ZUTA_BOJA, string);
    SendClientMessage(playerid, BELA_BOJA, "Za sve informacije ukucajte /help");
    SendClientMessage(playerid, BELA_BOJA, "Website: www.balkanextremerp.site40.net, Uzivajte u ovom divnom danu");

    // Ovde sada pokazuje pravi admin rank umjesto levela
    format(string, sizeof(string), "Admin: %s | Vip: %d", admin_naziv, vip);
    SendClientMessage(playerid, BELA_BOJA, string);

    format(string, sizeof(string), "Level: %d", nivo);
    SendClientMessage(playerid, BELA_BOJA, string);
    SendClientMessage(playerid, PLAVA_LINIJA, "------------------------------------------------------------------");
}
forward ZavrsiIntroKorak(playerid);
public ZavrsiIntroKorak(playerid)
{
    IntroKorak[playerid]++;

    switch(IntroKorak[playerid])
    {
        case 2: // OPSTINA
        {
            SetPlayerCameraPos(playerid, 1481.56, -1770.23, 60.12);
            SetPlayerCameraLookAt(playerid, 1481.56, -1740.23, 13.55);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ OPSTINA ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Ovo je gradska opstina, mesto gde se uzimaju poslovi i jos mnogo toga.");
            SendClientMessage(playerid, PLAVA_BOJA, " Ovo je takode centar zbivanja u Beogradu");
            SendClientMessage(playerid, PLAVA_BOJA, " Savet:Idite do opstine sto je pre moguce, uzmite posao i krenite sa zaradivanjem novca,");
            SendClientMessage(playerid, PLAVA_BOJA, " kasnije mozete kupiti neko vozilo ili nesto sl.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 3: // POLICIJA
        {
            SetPlayerCameraPos(playerid, 1550.22, -1675.44, 45.89);
            SetPlayerCameraLookAt(playerid, 1550.22, -1633.44, 20.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ POLICIJA ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Policija i SAJ su tu da vas zastite od kriminalama.");
            SendClientMessage(playerid, PLAVA_BOJA, " Ako vidite Policiju/SAJ nemorate se bojati.");
            SendClientMessage(playerid, PLAVA_BOJA, " Nemojte vredati Policiju jer su oni tu da vas zastite od kriminalaca.");
            SendClientMessage(playerid, PLAVA_BOJA, " Ako vas neko uznemirava ,pozovite policiju tako sto cete ukucati /call 911.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 4: // BOLNICA
        {
            SetPlayerCameraPos(playerid, 1175.33, -1323.11, 40.50);
            SetPlayerCameraLookAt(playerid, 1175.33, -1323.11, 20.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ BOLNICA ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Bolnica je ustanova zdravstvene nege.");
            SendClientMessage(playerid, PLAVA_BOJA, " Osoblje bolnice cine profesionalno skolovani lekari.");
            SendClientMessage(playerid, PLAVA_BOJA, " Ako se osecate lose ,morate posetiti doktora.");
            SendClientMessage(playerid, PLAVA_BOJA, " Da biste pozvali hitnu pomoc, pozovite broj /call 911");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 5: // MAFIJE I BANDE
        {
            SetPlayerCameraPos(playerid, 2488.11, -1666.22, 50.00);
            SetPlayerCameraLookAt(playerid, 2488.11, -1666.22, 20.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ MAFIJE I BANDE ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Kad-Tad ce vam se desiti da slucajno naidete na nekog clana Mafije ili Bande.");
            SendClientMessage(playerid, PLAVA_BOJA, " Bande i Mafije se nalaze po celom Beogradu.");
            SendClientMessage(playerid, PLAVA_BOJA, " Clan Bande ili Mafije moze da vas kidnazuje i oduzme sav novac koji imate.");
            SendClientMessage(playerid, PLAVA_BOJA, " Mafije su jace od bandi i mogu da ucenjuju Bande.");
            SendClientMessage(playerid, PLAVA_BOJA, " Izbegavajte kontakt s njima.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 6: // AUTO SKOLA
        {
            SetPlayerCameraPos(playerid, 2026.44, -2050.12, 35.20);
            SetPlayerCameraLookAt(playerid, 2026.44, -2050.12, 20.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ AUTO SKOLA ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Nemate dozvolu za voznju automobila/letelica/brodova ?? Sramota.");
            SendClientMessage(playerid, PLAVA_BOJA, " Dodite u auto skolu i polozite za neku od dozvola.");
            SendClientMessage(playerid, PLAVA_BOJA, " Da bi lakse polozili tu su ljubazni instruktori koji ce vam objasniti svaki korak tokom voznje.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 7: // BINCO
        {
            SetPlayerCameraPos(playerid, 2244.55, -1665.33, 30.10);
            SetPlayerCameraLookAt(playerid, 2244.55, -1665.33, 18.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ BINCO ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " BINCO prodavnica odece je mesto gde mozete kupiti skin za vaseg lika.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 8: // HIPER MARKET
        {
            SetPlayerCameraPos(playerid, 1725.12, -1700.44, 30.00);
            SetPlayerCameraLookAt(playerid, 1725.12, -1700.44, 18.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ HIPER MARKET ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Ovde mozete da kupujete razne stvari.");
            SendClientMessage(playerid, PLAVA_BOJA, " Mozete kupiti hranu koristite komandu /useinventory a na /inventory.");
            SendClientMessage(playerid, PLAVA_BOJA, " Gledate stanje vaseg ranca sa hranom, mozete uzeti GPS ili Telefon i sve");
            SendClientMessage(playerid, PLAVA_BOJA, " U vezi telefona isto tako mozete kupiti i cvece.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 9: // BANKA
        {
            SetPlayerCameraPos(playerid, 1420.11, -995.22, 50.00);
            SetPlayerCameraLookAt(playerid, 1420.11, -995.22, 20.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ BANKA ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Ovo je mesto gde mozete ostaviti vas tesko zaradeni novac.");
            SendClientMessage(playerid, PLAVA_BOJA, " Banka je zbog novca cesto na meta bandi i mafija");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 10: // OGLASI
        {
            SetPlayerCameraPos(playerid, 1190.55, -1250.33, 60.00);
            SetPlayerCameraLookAt(playerid, 1190.55, -1250.33, 25.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ OGLASI ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Uvek cete morati nesto da kupite ili da prodate.");
            SendClientMessage(playerid, PLAVA_BOJA, " Ali ne znate kako to da vide drugi ljudi?");
            SendClientMessage(playerid, PLAVA_BOJA, " Ovo je mesto za vas, ovde objavite sve sto zelite, oglas takode mozete dati i na /smsad.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 11: // BURGER SHOT
        {
            SetPlayerCameraPos(playerid, 1199.11, -920.55, 45.00);
            SetPlayerCameraLookAt(playerid, 1199.11, -920.55, 20.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ Burger shot ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Ogladneli ste, zelite malo zabave/drustva ?.");
            SendClientMessage(playerid, PLAVA_BOJA, " Ovo je pravo mesto za vas, ovde mozete pojesti ukusne specijalitete spremljene od strane profesionalnih kuvara.");
            SendClientMessage(playerid, PLAVA_BOJA, " Dodite sa drustvom i provedite se odlicno, jer to moze samo u Burgu.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 12: // MOST RADOSTI
        {
            SetPlayerCameraPos(playerid, -1885.55, 850.11, 80.00);
            SetPlayerCameraLookAt(playerid, -1885.55, 850.11, 30.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ MOST RADOSTI ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Most radosti je mesto za nesrecne slucajeve, kojima ocajnicki trebaju pare.");
            SendClientMessage(playerid, PLAVA_BOJA, " Ako skocite sa mosta preko komande /most dobicete 180 $ od slucajnih prolaznika.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 13: // KRAJ - SPAWN LIKA
        {
            KillTimer(TimerIntro[playerid]);
            TogglePlayerSpectating(playerid, 0);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ KRAJ ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Postoji mnogo zanimljivih mesta u Beogradu, ali cete ih morati otkriti sami.");
            SendClientMessage(playerid, PLAVA_BOJA, " Nemojte zaboraviti na RP pravila, jer ze zbog non-rp igre dobijaju razne kazne!");
            SendClientMessage(playerid, PLAVA_BOJA, " Uzivajte na nasem serveru, Balkan Revolution RolePlay.");
            SendClientMessage(playerid, PLAVA_BOJA, " Posetite nas forum www.balkanextremerp.site40.net");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
            SetSpawnInfo(playerid, 0, 247, 1759.1915, -1898.1232, 13.5568, 0.0, 0, 0, 0, 0, 0, 0);
            SpawnPlayer(playerid);
            PrikaziPorukuDobrodoslice(playerid);
        }
    }
    return 1;
}
#define ATTACHMENT_TEMPLATE_FILE "BalkanRP/AttachmentPositions.ini"

stock ApplySavedHeadphones(playerid)
{
    new bone = 2;
    new Float:offX = 0.0, Float:offY = 0.0, Float:offZ = 0.0;
    new Float:rotX = 0.0, Float:rotY = 0.0, Float:rotZ = 0.0;
    new Float:scaleX = 1.0, Float:scaleY = 1.0, Float:scaleZ = 1.0;
    if(DOF2_FileExists(ATTACHMENT_TEMPLATE_FILE) && DOF2_GetInt(ATTACHMENT_TEMPLATE_FILE, "Model19421_Used") == 1)
    {
        bone = DOF2_GetInt(ATTACHMENT_TEMPLATE_FILE, "Model19421_Bone");
        offX = DOF2_GetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_OffX");
        offY = DOF2_GetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_OffY");
        offZ = DOF2_GetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_OffZ");
        rotX = DOF2_GetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_RotX");
        rotY = DOF2_GetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_RotY");
        rotZ = DOF2_GetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_RotZ");
        scaleX = DOF2_GetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_ScaleX");
        scaleY = DOF2_GetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_ScaleY");
        scaleZ = DOF2_GetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_ScaleZ");
    }
    SetPlayerAttachedObject(playerid, 0, 19421, bone, offX, offY, offZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ);
    return 1;
}

CMD:ugasimp3(playerid, params[])
{
    #pragma unused params
    StopAudioStreamForPlayer(playerid);
    if(IsPlayerAttachedObjectSlotUsed(playerid, 0)) RemovePlayerAttachedObject(playerid, 0);
    SendClientMessage(playerid, 0x00BFFFFF, "[MP3]: Muzika je ugasena.");
    return 1;
}

CMD:skinidodatke(playerid, params[])
{
    #pragma unused params
    for(new slot = 1; slot < 10; slot++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) RemovePlayerAttachedObject(playerid, slot);
    }
    SendClientMessage(playerid, 0x00BFFFFF, "[DODACI]: Skinuli ste sve dodatke osim MP3 slusalica.");
    return 1;
}

CMD:editattachedobject(playerid, params[])
{
    new ime[MAX_PLAYER_NAME], file[128], slot;
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    new admin_lvl = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;
    if(!IsPlayerAdmin(playerid) && admin_lvl < 9)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Komandu moze koristiti samo Vlasnik.");
    if(sscanf(params, "i", slot))
        return SendClientMessage(playerid, 0xFFFFFFFF, "KORISCENJE: /editattachedobject 0");
    if(slot != 0) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Trenutno se podesavaju MP3 slusalice u slotu 0.");
    if(!IsPlayerAttachedObjectSlotUsed(playerid, 0)) ApplySavedHeadphones(playerid);
    SetPVarInt(playerid, "BR_EditGlobalAttachment", 1);
    EditAttachedObject(playerid, 0);
    SendClientMessage(playerid, 0xFFFF00FF, "[DODATAK]: Namjestite slusalice i pritisnite ikonu za cuvanje.");
    return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid,
    Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,
    Float:fRotX, Float:fRotY, Float:fRotZ,
    Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(!GetPVarInt(playerid, "BR_EditGlobalAttachment") || index != 0) return 1;
    DeletePVar(playerid, "BR_EditGlobalAttachment");
    if(response != EDIT_RESPONSE_FINAL) return SendClientMessage(playerid, 0xFF7777FF, "[DODATAK]: Izmjena nije sacuvana.");
    if(!DOF2_FileExists(ATTACHMENT_TEMPLATE_FILE)) DOF2_CreateFile(ATTACHMENT_TEMPLATE_FILE);
    DOF2_SetInt(ATTACHMENT_TEMPLATE_FILE, "Model19421_Used", 1);
    DOF2_SetInt(ATTACHMENT_TEMPLATE_FILE, "Model19421_Bone", boneid);
    DOF2_SetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_OffX", fOffsetX);
    DOF2_SetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_OffY", fOffsetY);
    DOF2_SetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_OffZ", fOffsetZ);
    DOF2_SetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_RotX", fRotX);
    DOF2_SetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_RotY", fRotY);
    DOF2_SetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_RotZ", fRotZ);
    DOF2_SetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_ScaleX", fScaleX);
    DOF2_SetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_ScaleY", fScaleY);
    DOF2_SetFloat(ATTACHMENT_TEMPLATE_FILE, "Model19421_ScaleZ", fScaleZ);
    DOF2_SaveFile();
    SetPlayerAttachedObject(playerid, 0, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ,
        fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
    SendClientMessage(playerid, 0x00FF00FF, "[DODATAK]: Pozicija slusalica je sacuvana za sve igrace.");
    return 1;
}

CMD:mp3(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    // Provjera da li fajl postoji i da li ima kljuc "Slusalice"
    if(!DOF2_FileExists(file) || !DOF2_IsSet(file, "Slusalice") || DOF2_GetInt(file, "Slusalice") == 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Nema? slu?alice! Mora? ih kupiti komandom {FFFFFF}/kupislusalice{FF0000}.");
        return 1;
    }

    // Slusalice se prikazuju tek nakon izbora radio stanice.
    // Otvaranje dijaloga da igrac izabere stanicu
    ShowPlayerDialog(playerid, DIALOG_RADIO, DIALOG_STYLE_LIST, "Balkan Radio Meni",
        "1. Balkan Radio Hit\n2. Cool Radio\n3. Radio Sehara\n4. Extra FM\n5. RTV Puls Brcko",
        "Odaberi", "Izlaz");

    return 1;
}
CMD:stats(playerid, params[])
{
    #pragma unused params
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF7777FF, "[STATS]: Prvo se prijavite na nalog.");

    new file[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    if(!GetPlayerAccountPath(playerid, file, sizeof(file)))
        return SendClientMessage(playerid, 0xFF7777FF, "[STATS]: Vas korisnicki fajl nije pronaden.");

    new level = DOF2_GetInt(file, "Level");
    if(level < 1) level = 1;
    new respects = DOF2_GetInt(file, "Respekti");
    new statsAdminLevel = DOF2_GetInt(file, "Admin");
    new needed = level * 4;
    new hours = DOF2_GetInt(file, "Sati");
    new minutes = PlayerMinute[playerid];
    new bank = DOF2_GetInt(file, "Banka");
    new euro = DOF2_GetInt(file, "Euro");
    new gold = DOF2_GetInt(file, "Zlato");
    new credits = DOF2_GetInt(file, "Krediti");
    new warnings = DOF2_GetInt(file, "Upozorenja");
    new insurance = DOF2_GetInt(file, "Osiguranja");
    new roleplayRank = DOF2_GetInt(file, "RolePlayRank");
    new donatePoints = DOF2_GetInt(file, "DonatePoeni");
    new adminPunishments = DOF2_GetInt(file, "AdminKazne");
    new muteSeconds = DOF2_GetInt(file, "AdminMuteUntil") - gettime();
    if(muteSeconds < 0) muteSeconds = 0;
    new muteMinutes = (muteSeconds + 59) / 60;

    new phone[32], phoneNumber[24], country[32], gender[12], registered[40], marriage[MAX_PLAYER_NAME];
    if(DOF2_IsSet(file, "Telefon")) format(phone, sizeof(phone), "%s", DOF2_GetString(file, "Telefon"));
    else format(phone, sizeof(phone), "Nema");
    if(DOF2_IsSet(file, "BrojTelefona") && DOF2_GetInt(file, "BrojTelefona") > 0)
        format(phoneNumber, sizeof(phoneNumber), "%d", DOF2_GetInt(file, "BrojTelefona"));
    else format(phoneNumber, sizeof(phoneNumber), "Nema");
    if(DOF2_IsSet(file, "Drzava")) format(country, sizeof(country), "%s", DOF2_GetString(file, "Drzava"));
    else format(country, sizeof(country), "Nepoznato");
    if(DOF2_GetInt(file, "Pol") == 0) format(gender, sizeof(gender), "Musko");
    else format(gender, sizeof(gender), "Zensko");
    if(DOF2_IsSet(file, "Registrovan")) format(registered, sizeof(registered), "%s", DOF2_GetString(file, "Registrovan"));
    else format(registered, sizeof(registered), "Nepoznato");
    if(DOF2_IsSet(file, "Brak")) format(marriage, sizeof(marriage), "%s", DOF2_GetString(file, "Brak"));
    else format(marriage, sizeof(marriage), "Ni sa kim");

    new orgid = DOF2_GetInt(file, "Member");
    new orgRank = DOF2_GetInt(file, "Rank");
    new leader = 0;
    new leadersFile[64] = "BalkanRP/Lideri.ini";
    if(DOF2_FileExists(leadersFile))
    {
        for(new i = 1; i <= 20; i++)
        {
            new key[24], leaderName[MAX_PLAYER_NAME];
            format(key, sizeof(key), "Lider_%d", i);
            if(!DOF2_IsSet(leadersFile, key)) continue;
            format(leaderName, sizeof(leaderName), "%s", DOF2_GetString(leadersFile, key));
            if(!strcmp(leaderName, name, true))
            {
                orgid = i;
                leader = 1;
                break;
            }
        }
    }

    new orgName[40], rankName[24], jobName[32];
    switch(orgid)
    {
        case 1: format(orgName, sizeof(orgName), "Policija");
        case 2: format(orgName, sizeof(orgName), "Vojska");
        case 3: format(orgName, sizeof(orgName), "Zandarmerija");
        case 4: format(orgName, sizeof(orgName), "Taxi Sluzba");
        case 5: format(orgName, sizeof(orgName), "Hitna Pomoc");
        case 6: format(orgName, sizeof(orgName), "Novinari");
        case 7: format(orgName, sizeof(orgName), "Parking Servis");
        case 8: format(orgName, sizeof(orgName), "Hitman");
        case 9: format(orgName, sizeof(orgName), "La Cosa Nostra");
        case 10: format(orgName, sizeof(orgName), "GHS");
        case 11: format(orgName, sizeof(orgName), "Yamaguchi");
        case 12: format(orgName, sizeof(orgName), "Ruska Mafija");
        case 13: format(orgName, sizeof(orgName), "Grove Street Family");
        case 14: format(orgName, sizeof(orgName), "Ballas Family");
        case 15: format(orgName, sizeof(orgName), "MS-13");
        case 16: format(orgName, sizeof(orgName), "Los Surenos");
        case 17: format(orgName, sizeof(orgName), "Privatna Organizacija 1");
        case 18: format(orgName, sizeof(orgName), "Privatna Organizacija 2");
        case 19: format(orgName, sizeof(orgName), "Bajkeri");
        default: format(orgName, sizeof(orgName), "Nema");
    }
    if(orgid == 0) format(rankName, sizeof(rankName), "Nema");
    else if(leader) format(rankName, sizeof(rankName), "Lider");
    else format(rankName, sizeof(rankName), "Rank %d", orgRank);

    switch(DOF2_GetInt(file, "Posao"))
    {
        case 1: format(jobName, sizeof(jobName), "Cistac ulica");
        case 2: format(jobName, sizeof(jobName), "Postar");
        case 3: format(jobName, sizeof(jobName), "Ribolovac");
        default: format(jobName, sizeof(jobName), "Nezaposlen");
    }

    new sickUntil = DOF2_GetInt(file, "BolestanDo");
    new healthStatus[40], spawnHealth;
    if(sickUntil > 0)
    {
        spawnHealth = 50;
        format(healthStatus, sizeof(healthStatus), "Bolestan - potrebno lijecenje");
    }
    else
    {
        spawnHealth = 100;
        format(healthStatus, sizeof(healthStatus), "Zdrav");
    }

    new punishmentStatus[40];
    if(adminPunishments > 0) format(punishmentStatus, sizeof(punishmentStatus), "Kaznjavan %d puta", adminPunishments);
    else format(punishmentStatus, sizeof(punishmentStatus), "Niste kaznjavani");

    new donorText[24];
    if(DOF2_GetInt(file, "DonatorRank") > 0)
        format(donorText, sizeof(donorText), "Rank %d", DOF2_GetInt(file, "DonatorRank"));
    else format(donorText, sizeof(donorText), "Nema");

    new houseText[16], businessText[16];
    new house = DOF2_GetInt(file, "Kuca");
    new business = DOF2_GetInt(file, "Bizz");
    if(house < 0) format(houseText, sizeof(houseText), "Nema"); else format(houseText, sizeof(houseText), "%d", house);
    if(business < 0) format(businessText, sizeof(businessText), "Nema"); else format(businessText, sizeof(businessText), "%d", business);

    new bingoText[8];
    if(DOF2_GetInt(file, "Bingo") > 0) format(bingoText, sizeof(bingoText), "Da");
    else format(bingoText, sizeof(bingoText), "Ne");

    new text[7000], line[600];
    format(line, sizeof(line), "{00BFFF}Ime: {FFFFFF}%s | ID: %d\n{00BFFF}Status: {FFFFFF}[%s]\n", name, playerid, punishmentStatus);
    strcat(text, line, sizeof(text));
    strcat(text, "{FFFFFF}----------- {FF3333}Osnovni Podaci {FFFFFF}-----------\n", sizeof(text));
    if(statsAdminLevel > 0 || HappyHourMultiplier == 2)
        format(line, sizeof(line), "{00BFFF}Level: {FFFFFF}[%d]\n{00BFFF}Experience: {FFFFFF}[%d/%d] {FF8C00}Dupli respekti\n", level, respects, needed);
    else
        format(line, sizeof(line), "{00BFFF}Level: {FFFFFF}[%d]\n{00BFFF}Experience: {FFFFFF}[%d/%d]\n", level, respects, needed);
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{00BFFF}Donatorski Rank: {FFFFFF}[%s] [Dani: %d | Sati: %d]\n{00BFFF}Bap Poeni: {FFFFFF}[%d]\n", donorText, DOF2_GetInt(file, "DonatorDani"), DOF2_GetInt(file, "DonatorSati"), DOF2_GetInt(file, "BapPoeni"));
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{00BFFF}Mute: {FFFFFF}[%d min]\n{00BFFF}Telefon: {FFFFFF}[%s]\n{00BFFF}Broj Telefona: {FFFFFF}[%s]\n", muteMinutes, phone, phoneNumber);
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{00BFFF}Spawn Helti: {FFFFFF}[%d%%] [%s]\n{00BFFF}Upozorenja: {FFFFFF}[%d/3]\n{00BFFF}Sati Igranja: {FFFFFF}[%d h %d min]\n", spawnHealth, healthStatus, warnings, hours, minutes);
    strcat(text, line, sizeof(text));

    strcat(text, "{FFFFFF}----------- {FF3333}Bankarski Racuni {FFFFFF}-----------\n", sizeof(text));
    format(line, sizeof(line), "{00BFFF}Novcanik: {FFFFFF}[%d dinara]\n{00BFFF}Banka: {FFFFFF}[%d dinara]\n{00BFFF}Euro: {FFFFFF}[%d]\n", GetPlayerMoney(playerid), bank, euro);
    strcat(text, line, sizeof(text));

    strcat(text, "{FFFFFF}----------- {FF3333}Licna Karta {FFFFFF}-----------\n", sizeof(text));
    format(line, sizeof(line), "{00BFFF}Registrovan: {FFFFFF}[%s]\n{00BFFF}Drzava: {FFFFFF}[%s]\n{00BFFF}Pol: {FFFFFF}[%s]\n{00BFFF}Godine: {FFFFFF}[%d]\n", registered, country, gender, DOF2_GetInt(file, "Godine"));
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{00BFFF}U Braku: {FFFFFF}[%s]\n{00BFFF}Organizacija: {FFFFFF}[%s]\n{00BFFF}Rank: {FFFFFF}[%s]\n{00BFFF}Posao: {FFFFFF}[%s]\n", marriage, orgName, rankName, jobName);
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{00BFFF}Osiguranja: {FFFFFF}[%d]\n{00BFFF}RolePlay Rank: {FFFFFF}[%d]\n", insurance, roleplayRank);
    strcat(text, line, sizeof(text));

    strcat(text, "{FFFFFF}----------- {FF3333}Dosije {FFFFFF}-----------\n", sizeof(text));
    format(line, sizeof(line), "{00BFFF}Wanted: {FFFFFF}[%d]  {00BFFF}Ubistva: {FFFFFF}[%d]\n{00BFFF}Smrti: {FFFFFF}[%d]  {00BFFF}Zlocini: {FFFFFF}[%d]\n", WantedPoints[playerid], DOF2_GetInt(file, "DosijeUbistva"), DOF2_GetInt(file, "DosijeSmrti"), DOF2_GetInt(file, "DosijeZlocini"));
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{00BFFF}Hapsen Puta: {FFFFFF}[%d]  {00BFFF}Tiketi: {FFFFFF}[%d]\n{00BFFF}Bezanje sa Servera: {FFFFFF}[%d]\n{00BFFF}Administrativne Kazne: {FFFFFF}[%d]\n", DOF2_GetInt(file, "DosijeUhapsen"), DOF2_GetInt(file, "DosijeTiketi"), DOF2_GetInt(file, "DosijeLTA"), adminPunishments);
    strcat(text, line, sizeof(text));

    strcat(text, "{FFFFFF}----------- {FF3333}Torba {FFFFFF}-----------\n", sizeof(text));
    format(line, sizeof(line), "{00BFFF}Lotto Broj: {FFFFFF}[%d]  {00BFFF}Bingo: {FFFFFF}[%s]\n{00BFFF}Zlato: {FFFFFF}[%d kom]  {00BFFF}Telefonski Kredit: {FFFFFF}[%d]\n", DOF2_GetInt(file, "LottoBroj"), bingoText, gold, credits);
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{00BFFF}Neobradena Droga: {FFFFFF}[%d]  {00BFFF}Droga: {FFFFFF}[%d]\n{00BFFF}Vrecice Semena: {FFFFFF}[%d]  {00BFFF}Materijali: {FFFFFF}[%d]\n", DOF2_GetInt(file, "NeobradenaDroga"), DOF2_GetInt(file, "Droga"), DOF2_GetInt(file, "VreciceSemena"), DOF2_GetInt(file, "Materijali"));
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{00BFFF}Alat: {FFFFFF}[%d]  {00BFFF}Dinamit: {FFFFFF}[%d]\n", DOF2_GetInt(file, "Alat"), DOF2_GetInt(file, "Dinamit"));
    strcat(text, line, sizeof(text));

    strcat(text, "{FFFFFF}----------- {FF3333}Skillovi {FFFFFF}-----------\n", sizeof(text));
    format(line, sizeof(line), "{00BFFF}News Reporter: {FFFFFF}[%d]\n{00BFFF}Donate Poeni: {FFFFFF}[%d]\n", DOF2_GetInt(file, "NewsReporterSkill"), donatePoints);
    strcat(text, line, sizeof(text));
    strcat(text, "{FFFFFF}----------- {FF3333}Kljucevi {FFFFFF}-----------\n", sizeof(text));
    format(line, sizeof(line), "{00BFFF}Kuca: {FFFFFF}[%s] {00BFFF}Firma: {FFFFFF}[%s] {00BFFF}Veh1: {FFFFFF}[Nema] {00BFFF}Veh2: {FFFFFF}[Nema] {00BFFF}Veh3: {FFFFFF}[Nema]\n\n", houseText, businessText);
    strcat(text, line, sizeof(text));
    strcat(text, "{FF3333}Svaka zloupotreba Stats-a je strogo kaznjiva!", sizeof(text));

    new chatMessage[96];
    format(chatMessage, sizeof(chatMessage), "* %s gleda svoju licnu kartu (/stats).", name);
    SendClientMessage(playerid, 0xC2A2DAFF, chatMessage);
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for(new i = 0; i < MAX_PLAYERS; i++)
        if(i != playerid && IsPlayerConnected(i) && GetPlayerDistanceFromPoint(i, x, y, z) < 5.0)
            SendClientMessage(i, 0xC2A2DAFF, chatMessage);

    ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{00BFFF}Status | Balkan Revolution", text, "Ok", "Zatvori");
    return 1;
}
stock IsValidRPName(const name[])
{
    new underscores = 0;
    new len = strlen(name);

    // Ime mora imati minimalno 4 znaka (npr. A_Bc) a maksimalno 20
    if(len < 3 || len > 20) return 0;

    // Prvo slovo mora biti veliko
    if(name[0] < 'A' || name[0] > 'Z') return 0;

    for(new i = 0; i < len; i++)
    {
        // Provjera da li ima donja crta
        if(name[i] == '_')
        {
            underscores++;
            // Donja crta ne smije biti na pocetku, kraju, niti ih smije biti vi?e od jedne
            if(i == 0 || i == len - 1 || underscores > 1) return 0;

            // Slovo odmah nakon donje crte mora biti veliko
            if(name[i + 1] < 'A' || name[i + 1] > 'Z') return 0;
        }
        else
        {
            // Dozvoljena su samo slova (i velika i mala)
            if(!((name[i] >= 'A' && name[i] <= 'Z') || (name[i] >= 'a' && name[i] <= 'z')))
            {
                return 0;
            }
        }
    }

    // Mora tacno postojati jedna donja crta
    return (underscores == 1);
}
stock bool:BankPlayerHasWeapon(playerid)
{
    new weaponid, ammo;
    for(new slot = 1; slot <= 12; slot++)
    {
        GetPlayerWeaponData(playerid, slot, weaponid, ammo);
        if(weaponid >= 1 && weaponid <= 39 && ammo > 0) return true;
    }
    return false;
}

stock bool:BankHackerStillHere(playerid)
{
    if(!IsPlayerConnected(playerid) || GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return false;
    if(IsPlayerInAnyVehicle(playerid)) return false;
    return (IsPlayerInRangeOfPoint(playerid, 0.85, BankHackStartX, BankHackStartY, BankHackStartZ) != 0);
}

stock BankAbortHack()
{
    if(BankHackPlayer == INVALID_PLAYER_ID) return 0;
    if(IsPlayerConnected(BankHackPlayer))
    {
        GameTextForPlayer(BankHackPlayer, "~r~HAKOVANJE PREKINUTO", 3000, 3);
        SendClientMessage(BankHackPlayer, 0xFF7777FF, "[BANKA]: Pomjerili ste se. Hakovanje je prekinuto; novo je moguce za 10 minuta.");
    }
    BankHackPlayer = INVALID_PLAYER_ID;
    BankHackCooldownUntil = gettime() + 600;
    return 1;
}

stock BankAbortRobbery(bool:killed)
{
    if(BankRobber == INVALID_PLAYER_ID) return 0;
    new robber = BankRobber;
    BankRobber = INVALID_PLAYER_ID;
    BankRobberyUntil = 0;
    BankRobberyFinishedThisCycle = true;
    BankRobberyCooldownUntil = gettime() + 1800;
    BankResetAt = gettime() + 480; // Vrata i laseri se vracaju poslije 8 minuta.
    BankHackCooldownUntil = BankRobberyCooldownUntil;
    if(!DOF2_FileExists(BANK_ROBBERY_FILE)) DOF2_CreateFile(BANK_ROBBERY_FILE);
    DOF2_SetInt(BANK_ROBBERY_FILE, "CooldownUntil", BankRobberyCooldownUntil);
    DOF2_SaveFile();
    if(IsPlayerConnected(robber) && !killed)
    {
        TogglePlayerControllable(robber, 1);
        ClearAnimations(robber);
        SendClientMessage(robber, 0xFF7777FF, "[BANKA]: Pljacka je prekinuta. Banka je zatvorena narednih 30 minuta.");
    }
    if(killed)
        SendClientMessageToAll(0xFF7777FF, "{FF0000}[VESTI] {FF7777}Pljacka Beogradske Banke je uspesno obustavljena! Policija, Zandarmerija i Vojska osiguravaju banku.");
    else
        SendClientMessageToAll(0xFF7777FF, "{FF0000}[VESTI] {FF7777}Pljacka Beogradske Banke je prekinuta. Banka je zatvorena narednih 30 minuta.");
    return 1;
}

forward BankRobberyLoopAnim(playerid);
public BankRobberyLoopAnim(playerid)
{
    if(BankRobber != playerid || !IsPlayerConnected(playerid)) return 1;
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 1, 1, 1, 1, 0, 1);
    return 1;
}

stock UpdateWantedNameColor(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(WantedPoints[playerid] > 0)
    {
        SetPlayerColor(playerid, 0xFF7777FF);
        return 1;
    }
    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file)))
    {
        SetPlayerColor(playerid, 0xFFFFFFFF);
        return 1;
    }
    new adminLevel = DOF2_GetInt(file, "Admin");
    new helperLevel = DOF2_GetInt(file, "Helper");
    if(adminLevel >= RANK_SUVLASNIK) SetPlayerColor(playerid, 0x000000FF);
    else if(helperLevel > 0) SetPlayerColor(playerid, 0xFFFF00FF);
    else SetPlayerColor(playerid, 0xFFFFFFFF);
    return 1;
}

stock UpdateWantedHint(playerid)
{
    UpdateWantedNameColor(playerid);
    if(WantedPoints[playerid] <= 0)
    {
        PlayerTextDrawHide(playerid, TD_WantedHint[playerid]);
        PlayerTextDrawHide(playerid, TD_WantedStars[playerid]);
        WantedHintBlinkVisible[playerid] = false;
        WantedHintToggleAt[playerid] = 0;
        return 1;
    }

    new shownWanted = WantedPoints[playerid];
    if(shownWanted > 6) shownWanted = 6;
    new stars[24];
    switch(shownWanted)
    {
        case 1: format(stars, sizeof(stars), "~y~]");
        case 2: format(stars, sizeof(stars), "~y~]]");
        case 3: format(stars, sizeof(stars), "~y~]]]");
        case 4: format(stars, sizeof(stars), "~y~]]]]");
        case 5: format(stars, sizeof(stars), "~y~]]]]]");
        default: format(stars, sizeof(stars), "~y~]]]]]]");
    }
    PlayerTextDrawSetString(playerid, TD_WantedStars[playerid], stars);
    PlayerTextDrawShow(playerid, TD_WantedHint[playerid]);
    PlayerTextDrawShow(playerid, TD_WantedStars[playerid]);
    WantedHintBlinkVisible[playerid] = true;
    if(WantedHintToggleAt[playerid] == 0) WantedHintToggleAt[playerid] = gettime() + 1;
    return 1;
}

stock LoadWantedState(playerid)
{
    new name[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    WantedPoints[playerid] = 0;
    format(WantedReason[playerid], 64, "Nema");
    if(DOF2_FileExists(file))
    {
        if(DOF2_IsSet(file, "DosijeWanted")) WantedPoints[playerid] = DOF2_GetInt(file, "DosijeWanted");
        if(DOF2_IsSet(file, "DosijeRazlog"))
            format(WantedReason[playerid], 64, "%s", DOF2_GetString(file, "DosijeRazlog"));
    }
    if(WantedPoints[playerid] < 0) WantedPoints[playerid] = 0;
    if(WantedPoints[playerid] > 1000) WantedPoints[playerid] = 1000;
    // Broj se cuva u dosijeu; GTA zvjezdice se ne prikazuju preko gornjeg HUD-a.
    SetPlayerWantedLevel(playerid, 0);
    UpdateWantedHint(playerid);
    return 1;
}

stock AddWantedPoints(playerid, amount, const reason[])
{
    if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn")) return 0;
    new nativeWanted = GetPlayerWantedLevel(playerid);
    if(nativeWanted > WantedPoints[playerid]) WantedPoints[playerid] = nativeWanted;
    WantedPoints[playerid] += amount;
    if(WantedPoints[playerid] > 1000) WantedPoints[playerid] = 1000;
    format(WantedReason[playerid], 64, "%s", reason);
    // Broj se cuva u dosijeu; GTA zvjezdice se ne prikazuju preko gornjeg HUD-a.
    SetPlayerWantedLevel(playerid, 0);
    UpdateWantedHint(playerid);

    new name[MAX_PLAYER_NAME], file[128], message[160];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "DosijeWanted", WantedPoints[playerid]);
        DOF2_SetString(file, "DosijeRazlog", WantedReason[playerid]);
        DOF2_SetInt(file, "DosijeZlocini", DOF2_GetInt(file, "DosijeZlocini") + 1);
        DOF2_SaveFile();
    }
    format(message, sizeof(message), "{FF7777}[DOSIJE] Dobili ste %d Wanted Levela. [Razlog] %s. Ukupno: %d. /dosije", amount, reason, WantedPoints[playerid]);
    SendClientMessage(playerid, 0xFF7777FF, message);
    return 1;
}

CMD:su(playerid, params[])
{
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF0000FF, "[POLICIJA]: Prvo se prijavite na svoj nalog.");

    new officerOrg = PlayerOrg[playerid];
    if(PlayerInfo[playerid][pLider] > 0) officerOrg = PlayerInfo[playerid][pLider];
    if(officerOrg != 1 && officerOrg != 2 && officerOrg != 3)
        return SendClientMessage(playerid, 0xFF0000FF, "[POLICIJA]: Ovu komandu mogu koristiti Policija, Vojska i Zandarmerija.");

    new targetid, wantedAmount, reason[64];
    if(sscanf(params, "uis[64]", targetid, wantedAmount, reason))
        return SendClientMessage(playerid, 0xAFAFAFFF, "Koristenje: /su [ID/Ime] [Broj Wanted Levela] [Razlog]");
    if(!IsPlayerConnected(targetid) || !GetPVarInt(targetid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF0000FF, "[POLICIJA]: Taj igrac nije prijavljen i online.");
    if(targetid == playerid)
        return SendClientMessage(playerid, 0xFF0000FF, "[POLICIJA]: Ne mozete sami sebi dati Wanted Level.");
    if(wantedAmount < 1 || wantedAmount > 6)
        return SendClientMessage(playerid, 0xFF0000FF, "[POLICIJA]: Broj Wanted Levela mora biti od 1 do 6.");

    AddWantedPoints(targetid, wantedAmount, reason);

    new officerName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME], message[180];
    GetPlayerName(playerid, officerName, sizeof(officerName));
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(message, sizeof(message), "[POLICIJA]: Dali ste igracu %s %d Wanted Levela. Razlog: %s. Ukupno: %d.", targetName, wantedAmount, reason, WantedPoints[targetid]);
    SendClientMessage(playerid, 0x33CCFFFF, message);
    format(message, sizeof(message), "[POLICIJA]: Sluzbenik %s vam je izdao Wanted Level.", officerName);
    SendClientMessage(targetid, 0x33CCFFFF, message);
    return 1;
}

stock IsBankStateOrganization(playerid)
{
    new org = PlayerOrg[playerid];
    if(PlayerInfo[playerid][pLider] > 0) org = PlayerInfo[playerid][pLider];
    return (org == 1 || org == 2 || org == 3 || org == 5 || org == 6 || org == 7);
}

stock BankCheckLaserForPlayer(playerid)
{
    if(BankLasersOff || !IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn"))
    {
        BankLaserPrevValid[playerid] = false;
        return 0;
    }
    new tick = GetTickCount();
    if(tick - BankLaserLastCheck[playerid] < 180) return 0;
    BankLaserLastCheck[playerid] = tick;
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
    {
        BankLaserWarned[playerid] = false;
        BankLaserPrevValid[playerid] = false;
        return 0;
    }
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    // Cetiri vidljiva snopa idu izmedu parova objekata kroz cijeli hodnik.
    // Provjeri sadasnju poziciju i putanju od proslog uzorka da trcanje ne preskoci alarm.
    new Float:beamMinX[4] = {92.8124, 98.2916, 95.6615, 99.1312};
    new Float:beamMaxX[4] = {111.4826, 111.7345, 110.9737, 111.1882};
    new Float:beamY[4] = {1699.0545, 1694.6413, 1703.2066, 1707.6756};
    new Float:beamZ[4] = {-13.4650, -13.4650, -13.4650, -13.4650};
    new bool:touched = false;
    for(new i = 0; i < 4; i++)
    {
        if(px >= beamMinX[i] - 0.55 && px <= beamMaxX[i] + 0.55 &&
            floatabs(py - beamY[i]) <= 0.55 && floatabs(pz - beamZ[i]) <= 1.25)
        {
            touched = true;
            break;
        }
        if(!BankLaserPrevValid[playerid]) continue;
        new Float:dx = px - BankLaserPrevX[playerid];
        new Float:dy = py - BankLaserPrevY[playerid];
        new Float:dz = pz - BankLaserPrevZ[playerid];
        if(dx * dx + dy * dy + dz * dz > 16.0 || floatabs(dy) < 0.001) continue;
        new Float:t = (beamY[i] - BankLaserPrevY[playerid]) / dy;
        if(t < 0.0 || t > 1.0) continue;
        new Float:crossX = BankLaserPrevX[playerid] + t * dx;
        new Float:crossZ = BankLaserPrevZ[playerid] + t * dz;
        if(crossX >= beamMinX[i] - 0.55 && crossX <= beamMaxX[i] + 0.55 &&
            floatabs(crossZ - beamZ[i]) <= 1.25)
        {
            touched = true;
            break;
        }
    }
    BankLaserPrevX[playerid] = px;
    BankLaserPrevY[playerid] = py;
    BankLaserPrevZ[playerid] = pz;
    BankLaserPrevValid[playerid] = true;
    if(!touched) { BankLaserWarned[playerid] = false; return 0; }
    if(!BankLaserWarned[playerid])
    {
        BankLaserWarned[playerid] = true;
        AddWantedPoints(playerid, 6, "Dodirivanje sigurnosnog lasera");
        if(gettime() >= BankLaserLastAlert[playerid])
        {
            BankLaserLastAlert[playerid] = gettime() + 10;
            SendClientMessageToAll(0xFF7777FF, "{FF0000}[VESTI] {FF7777}Neko pokusava da opljacka Beogradsku Banku, molimo da Policija intervenise.");
        }
    }
    return 1;
}

stock ResetBankCycle(bool:clearCooldown)
{
    if(BankHackPlayer != INVALID_PLAYER_ID && IsPlayerConnected(BankHackPlayer))
        SendClientMessage(BankHackPlayer, 0xFF7777FF, "[BANKA]: Administrator je resetovao banku. Hakovanje je prekinuto.");
    BankHackPlayer = INVALID_PLAYER_ID;
    BankHackStartedAt = 0;
    BankHackSuccessPlayer = INVALID_PLAYER_ID;

    if(BankRobber != INVALID_PLAYER_ID && IsPlayerConnected(BankRobber))
    {
        TogglePlayerControllable(BankRobber, 1);
        ClearAnimations(BankRobber);
        SendClientMessage(BankRobber, 0xFF7777FF, "[BANKA]: Administrator je resetovao banku. Pljacka je prekinuta.");
    }
    BankRobber = INVALID_PLAYER_ID;
    BankRobberyUntil = 0;

    StopObject(BankaVrata[0]);
    StopObject(BankaVrata[1]);
    StopObject(BankaTrezorVrata);
    SetObjectPos(BankaVrata[0], 115.434486, 1690.312866, -13.214599);
    SetObjectRot(BankaVrata[0], 0.0, 0.0, 0.0);
    SetObjectPos(BankaVrata[1], 117.156379, 1690.316406, -13.214599);
    SetObjectRot(BankaVrata[1], 0.0, 0.0, 180.0);
    SetObjectPos(BankaTrezorVrata, 116.217002, 1710.814819, -12.734299);
    SetObjectRot(BankaTrezorVrata, 0.0, 0.0, 180.0);
    if(BankDynamiteObject)
    {
        DestroyObject(BankDynamiteObject);
        BankDynamiteObject = 0;
    }
    BankDynamiteUntil = 0;
    BankVaultDoorDown = false;

    if(BankLasersOff)
    {
        new Float:x, Float:y, Float:z;
        for(new i = 0; i < sizeof(BankaLaseri); i++)
        {
            GetObjectPos(BankaLaseri[i], x, y, z);
            SetObjectPos(BankaLaseri[i], x, y, BankLaserOriginalZ[i]);
        }
    }
    BankDoorsOpen = false;
    BankLasersOff = false;
    BankLaserDisableAt = 0;

    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(clearCooldown && IsPlayerConnected(playerid) && BankMoneyBag[playerid])
            RemovePlayerAttachedObject(playerid, 9);
        if(clearCooldown) BankMoneyBag[playerid] = false;
        BankLaserWarned[playerid] = false;
        BankLaserPrevValid[playerid] = false;
        BankLaserLastCheck[playerid] = 0;
        BankLaserLastAlert[playerid] = 0;
    }
    BankResetAt = 0;
    // Automatsko zatvaranje ne smije ukinuti zabranu nove pljacke od 30 minuta.
    if(clearCooldown || BankRobberyCooldownUntil <= gettime())
    {
        BankRobberyFinishedThisCycle = false;
        BankRobberyCooldownUntil = 0;
        if(!DOF2_FileExists(BANK_ROBBERY_FILE)) DOF2_CreateFile(BANK_ROBBERY_FILE);
        DOF2_SetInt(BANK_ROBBERY_FILE, "CooldownUntil", 0);
        DOF2_SaveFile();
    }
    if(clearCooldown || BankHackCooldownUntil <= gettime()) BankHackCooldownUntil = 0;
    return 1;
}

forward BankHackTick();
public BankHackTick()
{
    new now = gettime();
    if(BankHackPlayer != INVALID_PLAYER_ID)
    {
        if(!BankHackerStillHere(BankHackPlayer)) BankAbortHack();
        else
        {
            new left = 60 - (now - BankHackStartedAt);
            if(left > 0)
            {
                new countText[64];
                format(countText, sizeof(countText), "~b~HAKOVANJE BANKE~n~~w~%d sekundi", left);
                GameTextForPlayer(BankHackPlayer, countText, 1200, 3);
            }
            else
            {
                new hacker = BankHackPlayer;
                BankHackPlayer = INVALID_PLAYER_ID;
                BankDoorsOpen = true;
                BankLaserDisableAt = now + 15;
                BankHackSuccessPlayer = hacker;
                BankResetAt = now + 600;
                BankHackCooldownUntil = BankResetAt;
                BankRobberyFinishedThisCycle = false;
                MoveObject(BankaVrata[0], 114.294486, 1690.312866, -13.214599, 1.0);
                MoveObject(BankaVrata[1], 118.2964, 1690.3164, -13.2146, 1.0);
                GameTextForPlayer(hacker, "~g~USPJESNO HAKOVANJE", 4000, 3);
                SendClientMessage(hacker, 0x66FF66FF, "[BANKA]: Vrata su otvorena. Sacekajte jos 15 sekundi da se laseri ugase.");
            }
        }
    }
    if(BankDoorsOpen && !BankLasersOff && BankLaserDisableAt && now < BankLaserDisableAt && BankHackSuccessPlayer != INVALID_PLAYER_ID && IsPlayerConnected(BankHackSuccessPlayer))
    {
        new laserText[64];
        format(laserText, sizeof(laserText), "~y~GASENJE LASERA~n~~w~%d sekundi", BankLaserDisableAt - now);
        GameTextForPlayer(BankHackSuccessPlayer, laserText, 1200, 3);
    }
    if(BankDoorsOpen && !BankLasersOff && BankLaserDisableAt && now >= BankLaserDisableAt)
    {
        new Float:x, Float:y, Float:z;
        for(new i = 0; i < sizeof(BankaLaseri); i++)
        {
            GetObjectPos(BankaLaseri[i], x, y, z);
            BankLaserOriginalZ[i] = z;
            SetObjectPos(BankaLaseri[i], x, y, z - 50.0);
        }
        BankLasersOff = true;
        BankHackSuccessPlayer = INVALID_PLAYER_ID;
        for(new playerid = 0; playerid < MAX_PLAYERS; playerid++) BankLaserWarned[playerid] = false;
        SendClientMessageToAll(0x99FF99FF, "[BANKA]: Sigurnosni laseri u banci su ugaseni.");
    }
    if(BankDynamiteUntil && now < BankDynamiteUntil)
    {
        new warning[64];
        format(warning, sizeof(warning), "~r~EKSPLOZIJA ZA %d SEKUNDI", BankDynamiteUntil - now);
        for(new p = 0; p < MAX_PLAYERS; p++)
            if(IsPlayerConnected(p) && GetPlayerInterior(p) == 0 && GetPlayerVirtualWorld(p) == 0 && IsPlayerInRangeOfPoint(p, 20.0, 116.2170, 1710.8148, -13.3103))
                GameTextForPlayer(p, warning, 1200, 3);
    }
    if(BankDynamiteUntil && now >= BankDynamiteUntil)
    {
        BankDynamiteUntil = 0;
        if(BankDynamiteObject) { DestroyObject(BankDynamiteObject); BankDynamiteObject = 0; }
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(!IsPlayerConnected(p) || GetPlayerInterior(p) != 0 || GetPlayerVirtualWorld(p) != 0) continue;
            new Float:distance = GetPlayerDistanceFromPoint(p, 116.2170, 1710.8148, -13.3103);
            if(distance > 25.0) continue;
            CreateExplosionForPlayer(p, 116.2170, 1710.8148, -13.3103, 1, 8.0);
            new Float:damage = 0.0, Float:health;
            if(distance < 2.5) damage = 100.0;
            else if(distance < 5.0) damage = 70.0;
            else if(distance < 8.0) damage = 40.0;
            else if(distance < 12.0) damage = 20.0;
            if(damage > 0.0)
            {
                GetPlayerHealth(p, health);
                SetPlayerHealth(p, health - damage > 0.0 ? health - damage : 0.0);
            }
        }
        MoveObject(BankaTrezorVrata, 116.2275, 1712.4453, -14.2743, 2.0, 90.0, 0.0, 180.0);
        BankVaultDoorDown = true;
        SendClientMessageToAll(0xFF7777FF, "{FF0000}[VESTI] {FF7777}Eksplozija u Beogradskoj Banci! Vrata trezora su pala.");
    }
    if(BankRobber != INVALID_PLAYER_ID)
    {
        if(!IsPlayerConnected(BankRobber) || GetPlayerInterior(BankRobber) != 0 || GetPlayerVirtualWorld(BankRobber) != 0 ||
            !IsPlayerInRangeOfPoint(BankRobber, 3.0, 116.3219, 1725.2919, -13.4224)) BankAbortRobbery(false);
        else if(now < BankRobberyUntil)
        {
            new robberyText[64];
            format(robberyText, sizeof(robberyText), "~b~PLJACKA BANKE~n~~w~%d:%02d", (BankRobberyUntil - now) / 60, (BankRobberyUntil - now) % 60);
            GameTextForPlayer(BankRobber, robberyText, 1200, 3);
        }
        else
        {
            new robber = BankRobber;
            BankRobber = INVALID_PLAYER_ID;
            BankRobberyUntil = 0;
            BankRobberyFinishedThisCycle = true;
            TogglePlayerControllable(robber, 1);
            ClearAnimations(robber);
            new reward = 10000 + random(65001);
            new robberName[MAX_PLAYER_NAME], robberFile[128], robberyNews[144];
            GetPlayerName(robber, robberName, sizeof(robberName));
            format(robberFile, sizeof(robberFile), "Korisnici/%s.ini", robberName);
            GivePlayerMoney(robber, reward);
            PlayerInfo[robber][pNovac] = GetPlayerMoney(robber);
            if(DOF2_FileExists(robberFile))
            {
                DOF2_SetInt(robberFile, "Novac", PlayerInfo[robber][pNovac]);
                DOF2_SaveFile();
            }
            format(robberyNews, sizeof(robberyNews), "{FF0000}[VESTI] {FF7777}Banka je opljackana i ukradeno je %d RSD.", reward);
            SendClientMessageToAll(0xFF7777FF, robberyNews);
            SetPlayerAttachedObject(robber, 9, 1550, 1, 0.0, -0.22, 0.0, 0.0, 90.0, 0.0);
            BankMoneyBag[robber] = true;
            BankRobberyCooldownUntil = now + 1800;
            BankResetAt = now + 480; // Banka se fizicki zatvara za 8 minuta.
            BankHackCooldownUntil = BankRobberyCooldownUntil;
            if(!DOF2_FileExists(BANK_ROBBERY_FILE)) DOF2_CreateFile(BANK_ROBBERY_FILE);
            DOF2_SetInt(BANK_ROBBERY_FILE, "CooldownUntil", BankRobberyCooldownUntil);
            DOF2_SaveFile();
            GameTextForPlayer(robber, "~g~BANKA OPLJACKANA", 5000, 3);
            SendClientMessage(robber, 0x66FF66FF, "[BANKA]: Uspjesno ste uzeli novac. Ruksak je na ledima; banka je zakljucana narednih 30 minuta.");
        }
    }
    if(BankDoorsOpen && BankResetAt && now >= BankResetAt) ResetBankCycle(false);
    if(BankRobberyCooldownUntil && now >= BankRobberyCooldownUntil)
    {
        BankRobberyCooldownUntil = 0;
        BankRobberyFinishedThisCycle = false;
        for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
        {
            if(!BankMoneyBag[playerid]) continue;
            if(IsPlayerConnected(playerid)) RemovePlayerAttachedObject(playerid, 9);
            BankMoneyBag[playerid] = false;
        }
        if(BankHackCooldownUntil <= now) BankHackCooldownUntil = 0;
        if(DOF2_FileExists(BANK_ROBBERY_FILE))
        {
            DOF2_SetInt(BANK_ROBBERY_FILE, "CooldownUntil", 0);
            DOF2_SaveFile();
        }
    }
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
        if(IsPlayerConnected(playerid)) BankCheckLaserForPlayer(playerid);
    return 1;
}

CMD:iskljucilasere(playerid, params[])
{
    if(!GetPVarInt(playerid, "BR_LoggedIn")) return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Prvo se prijavite na nalog.");
    // /setleader odmah upisuje pLider, dok se PlayerOrg inace osvjezi tek pri spawnu.
    new memberOrg = PlayerOrg[playerid];
    new leaderOrg = PlayerInfo[playerid][pLider];
    if((memberOrg < 13 || memberOrg > 16) && (leaderOrg < 13 || leaderOrg > 16))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Hakovanje je dostupno samo clanovima i liderima organizacija 13-16.");
    if(!BankPlayerHasWeapon(playerid)) return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Za hakovanje morate imati oruzje.");
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0 ||
        !IsPlayerInRangeOfPoint(playerid, 2.5, 117.7143, 1689.2194, -13.4302) || IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Dodite do mjesta za hakovanje u banci.");
    if(BankHackPlayer != INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Hakovanje je vec u toku.");
    if(BankDoorsOpen || BankHackCooldownUntil > gettime())
    {
        new msg[96], left = BankHackCooldownUntil - gettime();
        if(left < 1) left = 1;
        format(msg, sizeof(msg), "[BANKA]: Sacekajte jos %d minuta i %d sekundi.", left / 60, left % 60);
        return SendClientMessage(playerid, 0xFF7777FF, msg);
    }
    GetPlayerPos(playerid, BankHackStartX, BankHackStartY, BankHackStartZ);
    BankHackPlayer = playerid;
    BankHackStartedAt = gettime();
    SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Hakovanje traje 60 sekundi. Ako se pomjerite, hakovanje se prekida i svi cekaju 10 minuta.");
    GameTextForPlayer(playerid, "~b~HAKOVANJE BANKE~n~~w~60 sekundi", 1200, 3);
    return 1;
}

CMD:postavidinamit(playerid, params[])
{
    #pragma unused params
    if(!GetPVarInt(playerid, "BR_LoggedIn")) return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Prvo se prijavite.");
    if(!BankDoorsOpen || !BankLasersOff || BankRobberyFinishedThisCycle || BankRobberyCooldownUntil > gettime())
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Prvo hakujte banku i sacekajte da se laseri ugase.");
    if(BankDynamiteUntil || BankVaultDoorDown) return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Vrata trezora su vec minirana ili otvorena.");
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0 || IsPlayerInAnyVehicle(playerid) ||
        !IsPlayerInRangeOfPoint(playerid, 2.5, 116.2238, 1710.0984, -13.3103))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Stanite kod vrata trezora za /postavidinamit.");
    new file[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    if(!DOF2_FileExists(file) || DOF2_GetInt(file, "Dinamit") < 1)
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Nemate dinamit u inventaru.");
    DOF2_SetInt(file, "Dinamit", DOF2_GetInt(file, "Dinamit") - 1);
    DOF2_SaveFile();
    BankDynamiteObject = CreateObject(1654, 116.2170, 1710.45, -13.25, 0.0, 0.0, 90.0, 100.0);
    BankDynamiteUntil = gettime() + 15;
    BankResetAt = BankDynamiteUntil + 600;
    BankHackCooldownUntil = BankResetAt;
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Crouch_In", 4.1, 0, 0, 0, 0, 0, 1);
    SendClientMessageToAll(0xFF7777FF, "{FF0000}[VESTI] {FF7777}Postavljen je dinamit u Beogradskoj Banci! Udaljite se od vrata trezora, eksplozija za 15 sekundi.");
    return 1;
}

CMD:robbank(playerid, params[])
{
    #pragma unused params
    if(!GetPVarInt(playerid, "BR_LoggedIn")) return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Prvo se prijavite.");
    if(!BankDoorsOpen || !BankLasersOff || !BankVaultDoorDown)
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Prvo otvorite trezor i ugasite lasere.");
    if(BankRobber != INVALID_PLAYER_ID) return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Jedan igrac vec pljacka banku.");
    if(BankRobberyFinishedThisCycle || BankRobberyCooldownUntil > gettime())
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Banka je zatvorena. Sacekajte 30 minuta prije nove pljacke.");
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0 || IsPlayerInAnyVehicle(playerid) ||
        !IsPlayerInRangeOfPoint(playerid, 2.5, 116.3219, 1725.2919, -13.4224))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Stanite kod novca u trezoru za /robbank.");
    // Pljackas dobija 6, ostali osumnjiceni u donjem dijelu banke po 4.
    AddWantedPoints(playerid, 6, "Pljacka Beogradske banke");
    for(new nearby = 0; nearby < MAX_PLAYERS; nearby++)
    {
        if(nearby == playerid || !IsPlayerConnected(nearby) || !GetPVarInt(nearby, "BR_LoggedIn")) continue;
        if(IsBankStateOrganization(nearby)) continue;
        if(GetPlayerInterior(nearby) != 0 || GetPlayerVirtualWorld(nearby) != 0) continue;
        new Float:x, Float:y, Float:z;
        GetPlayerPos(nearby, x, y, z);
        if(x >= 85.0 && x <= 150.0 && y >= 1680.0 && y <= 1740.0 && z >= -18.0 && z <= -8.0)
            AddWantedPoints(nearby, 4, "Prisustvo pljacki banke");
    }
    BankRobber = playerid;
    BankRobberyUntil = gettime() + 300;
    BankResetAt = BankRobberyUntil + 600;
    BankHackCooldownUntil = BankResetAt;
    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Crouch_In", 4.1, 0, 1, 1, 1, 0, 1);
    SetTimerEx("BankRobberyLoopAnim", 1500, false, "i", playerid);
    SendClientMessageToAll(0xFF7777FF, "{FF0000}[VESTI] {FF7777}U toku je pljacka Beogradske Banke, molimo policiju da intervenise.");
    SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Skupljanje novca traje 5 minuta. Ne mozete se pomjerati.");
    return 1;
}

CMD:dosije(playerid, params[])
{
    #pragma unused params
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF7777FF, "[DOSIJE] Prvo se prijavite na nalog.");
    new message[80];
    format(message, sizeof(message), "{FF7777}Imate %d Wanted Levela", WantedPoints[playerid]);
    ShowPlayerDialog(playerid, DIALOG_DOSIJE, DIALOG_STYLE_MSGBOX, "{FF7777}DOSIJE", message, "Zatvori", "");
    return 1;
}

CMD:resetbanku(playerid, params[])
{
    #pragma unused params
    new file[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    new rank = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;
    if(!IsPlayerAdmin(playerid) && (!GetPVarInt(playerid, "BR_LoggedIn") || rank < 6 || rank > 9))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Potreban je admin rank 6-9 ili RCON admin.");

    ResetBankCycle(true);
    SendClientMessage(playerid, 0x66FF66FF, "[BANKA]: Banka je resetovana. Pljacka je odmah ponovo dostupna.");
    return 1;
}

CMD:dajdinamit(playerid, params[])
{
    new file[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    new rank = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;
    if(!IsPlayerAdmin(playerid) && (!GetPVarInt(playerid, "BR_LoggedIn") || rank < 6 || rank > 9))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Potreban je admin rank 6-9 ili RCON admin.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xFF7777FF, "[KORISTENJE]: /dajdinamit [ID/Ime]");
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Taj igrac nije online.");

    new targetName[MAX_PLAYER_NAME], targetFile[128], msg[144];
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(targetFile, sizeof(targetFile), "Korisnici/%s.ini", targetName);
    if(!DOF2_FileExists(targetFile))
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Igrac nema registrovan nalog.");

    new total = DOF2_GetInt(targetFile, "Dinamit") + 1;
    DOF2_SetInt(targetFile, "Dinamit", total);
    DOF2_SaveFile();
    format(msg, sizeof(msg), "[BANKA]: Dali ste dinamit igracu %s. Sada ima %d komad(a).", targetName, total);
    SendClientMessage(playerid, 0x66FF66FF, msg);
    format(msg, sizeof(msg), "[BANKA]: Dobili ste dinamit! Sada imate %d komad(a). Pogledajte /inventory i koristite /postavidinamit kod trezora.", total);
    SendClientMessage(targetid, 0x66FF66FF, msg);
    return 1;
}

CMD:pravila(playerid, params[])
{
    #pragma unused params
    new text[6000];

    strcat(text, "{75B9E6}Balkan Revolution je RolePlay server i kao takav moraju se postovati RolePlay pravila. Naravno, postoje\n", sizeof(text));
    strcat(text, "mnoga RolePlay pravila, ali kod nas vaze samo ona koja su ovde napisana. To znaci da mozete biti\n", sizeof(text));
    strcat(text, "kaznjeni samo za pravila koja stoje u ovoj listi. Takode postoje jos neka pravila koja se kaznjavaju, ali ne\n", sizeof(text));
    strcat(text, "stoje na ovoj listi jer server sam obavlja taj posao. Za odredena pravila na ovoj listi navedeno je za sta se\n", sizeof(text));
    strcat(text, "tacno kaznjava. Sva RolePlay pravila mozete pogledati na nasem forumu. Pravila su obavezna za testiranje\n", sizeof(text));
    strcat(text, "u Administraciju, a koriste ih i drzavne organizacije.\n\n", sizeof(text));

    strcat(text, "{FF3333}DeathMatching (DM) - Ubijanje ljudi bez ikakvog RP razloga. {75B9E6}Kaznjava se: Ubistvo civila, ubistvo clana\n", sizeof(text));
    strcat(text, "drzavne organizacije osim Policije/Zandarmerije i ubistvo radnika dok radi legalan posao. Igrac koga\n", sizeof(text));
    strcat(text, "prijavite ce biti kaznjen samo ukoliko ga vi ne napadnete! {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}BugAbuse (BA) - Iskoristavanje poznatih i nepoznatih BUGova na skripti. {66CC66}Kazna: Prison 1h\n", sizeof(text));
    strcat(text, "{FF3333}Powergaming (PG) - Radnja koju je nemoguce izvesti u stvarnom zivotu. {75B9E6}Kaznjava se: Ako udete\n", sizeof(text));
    strcat(text, "na G preko zida, ukoliko vas Policajac /cuff ili /pu preko zida ili u vazduhu bez koriscenja /me i /do\n", sizeof(text));
    strcat(text, "komandi. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}SpawnKill (SK) - Ubijanje igraca na mjestu spawn-a. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Non RolePlay (NonRP) - Ometanje RP radnji koje izvrsavaju drugi igraci. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Logging To Avoid (LTA) - Napustanje igrice da biste nesto izbjegli. {66CC66}Kazna: Prison 1 - 5h\n", sizeof(text));
    strcat(text, "{FF3333}Player vs Player (PvP) - Odnos izmedu igraca na serveru. {75B9E6}Kaznjava se: Izivljavanje nad drugim\n", sizeof(text));
    strcat(text, "igracima, tjeranje sa servera, ponizavanje i slicno. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Player vs Environment (PvE) - Odnos igraca sa svojom okolinom. {75B9E6}Kaznjava se: Konstantno udaranje\n", sizeof(text));
    strcat(text, "vozilom (Dune, Autobus, Sleper, Kamion). {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Drive By (DB) - Odnosi se na stetu nanesenu drugom igracu iz vozila. {75B9E6}Kaznjava se: Zabranjeno je\n", sizeof(text));
    strcat(text, "parkirati se na druge igrace i cekati njihovu smrt, te ubijanje elisom helikoptera. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Fake Account (FA) - Pravljenje novih naloga radi ostvarivanja prednosti, a vec posjedujete nalog\n", sizeof(text));
    strcat(text, "{75B9E6}(ukoliko vam je potreban novi nalog, obavezno se obratite na FB stranicu). {66CC66}Kazna: Cenzura\n", sizeof(text));
    strcat(text, "{FF3333}VIP Abusing (VA) - Zloupotreba komandi VIP-a. {75B9E6}Kaznjava se: Spasavanje igraca sa Wanted Levelom\n", sizeof(text));
    strcat(text, "tako sto ga negde portate. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Forum/Zalba. {66CC66}Kazna: Po pravilniku\n", sizeof(text));
    strcat(text, "{FF3333}Stablo - Omalovazavanje administracije i nepostovanje stabla > /stablo. {66CC66}Kazna: Prison 1 - 5h\n", sizeof(text));
    strcat(text, "{FF3333}Nacionalizam. {66CC66}Kazna: Ludnica 5 - 50h\n", sizeof(text));
    strcat(text, "{FF3333}Vrijedanje. {66CC66}Kazna: Ludnica 1 - 24h + mute 1 - 24h\n", sizeof(text));
    strcat(text, "{FF3333}Spam - Ponavljanje istih recenica ili rijeci vise puta zaredom, na bilo kom chatu. Vazi i za OOC\n", sizeof(text));
    strcat(text, "chatove. {66CC66}Kazna: Slap, Kick ili Lavirint\n", sizeof(text));
    strcat(text, "{FF3333}Invalid AD - Pisanje gluposti na oglasima i stvari koje krse pravilo > /mg.\n", sizeof(text));
    strcat(text, "{66CC66}Kazna: 30 - 60 min + mute 1 - 3h\n", sizeof(text));
    strcat(text, "{FF3333}Cit - Koriscenje bilo kakvih citova/modova koji daju prednost u odnosu na ostale igrace.\n", sizeof(text));
    strcat(text, "{66CC66}Kazna: Robija, a ukoliko igrac i dalje koristi cit slijedi cenzura\n", sizeof(text));
    strcat(text, "{FF3333}Reklamiranje bilo kakvih zajednica, sajtova... {66CC66}Kazna: Robija\n", sizeof(text));
    strcat(text, "{FF3333}Zabranjeno zapocinjanje price o nekom drugom serveru. {66CC66}Kazna: Rengban\n", sizeof(text));
    strcat(text, "{FF3333}Zabranjene su imovinske prevare, provale na tude naloge i slicno. {75B9E6}Kod kupovine/prodaje\n", sizeof(text));
    strcat(text, "obavezno zovite helpera; ako nema helpera, a dode do prevare, obavezno slikajte FB.\n", sizeof(text));
    strcat(text, "{66CC66}Kazna: Resava vrhovna komanda\n", sizeof(text));
    strcat(text, "{FF3333}Invalid /askq - Glupiranje na /askq i postavljanje glupih pitanja. {66CC66}Kazna: Lavirint\n", sizeof(text));
    strcat(text, "{FF3333}Voznja bicikla sa WL-om i ulaz u kucu sa healthom i armorom tokom akcije. {66CC66}Kazna: 30 min", sizeof(text));

    ShowPlayerDialog(playerid, DIALOG_PRAVILA, DIALOG_STYLE_MSGBOX, "Pravila", text, "Ok", "");
    return 1;
}
CMD:help(playerid, params[])
{
    #pragma unused params
    return ShowMainHelp(playerid);
}
// Pozovi ovu funkciju kad god igrac dobije PayDay (platu na sat vremena)
stock GetPlayerAccountPath(playerid, file[], size)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, size, "Korisnici/%s.ini", name);
    return DOF2_FileExists(file);
}

stock AddPlayerSavedStat(playerid, key[], amount)
{
    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file))) return 0;
    DOF2_SetInt(file, key, DOF2_GetInt(file, key) + amount);
    DOF2_SaveFile();
    return 1;
}

stock LoadExtendedPlayerStats(playerid)
{
    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file))) return 0;
    PlayerMinute[playerid] = DOF2_GetInt(file, "MinuteIgranja");
    if(PlayerMinute[playerid] < 0 || PlayerMinute[playerid] > 59) PlayerMinute[playerid] = 0;
    PlayerRespekti[playerid] = DOF2_GetInt(file, "Respekti");
    PlayerInfo[playerid][pBrojTelefona] = DOF2_GetInt(file, "BrojTelefona");
    IgracKrediti[playerid] = DOF2_GetInt(file, "Krediti");
    PlayerInfo[playerid][pLevel] = DOF2_GetInt(file, "Level");
    PlayerInfo[playerid][pSati] = DOF2_GetInt(file, "Sati");
    PlayerInfo[playerid][pRespekti] = PlayerRespekti[playerid];
    if(!DOF2_IsSet(file, "Kuca")) DOF2_SetInt(file, "Kuca", -1);
    if(!DOF2_IsSet(file, "Bizz")) DOF2_SetInt(file, "Bizz", -1);
    if(!DOF2_IsSet(file, "Vozilo1")) DOF2_SetInt(file, "Vozilo1", -1);
    if(!DOF2_IsSet(file, "Vozilo2")) DOF2_SetInt(file, "Vozilo2", -1);
    if(!DOF2_IsSet(file, "VoziloDonator")) DOF2_SetInt(file, "VoziloDonator", -1);
    if(!DOF2_IsSet(file, "Registrovan")) DOF2_SetString(file, "Registrovan", "Prije novog Stats sistema");
    DOF2_SaveFile();
    return 1;
}

forward ApplySpawnHealth(playerid);
public ApplySpawnHealth(playerid)
{
    if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn")) return 1;
    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file))) return 1;
    if(DOF2_GetInt(file, "BolestanDo") > 0) SetPlayerHealth(playerid, 50.0);
    else SetPlayerHealth(playerid, 100.0);
    return 1;
}

stock DajPayDayRespekt(playerid)
{
    if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn")) return 0;
    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file))) return 0;

    new level = DOF2_GetInt(file, "Level");
    new sati = DOF2_GetInt(file, "Sati") + 1;
    new admin_lvl = DOF2_GetInt(file, "Admin");
    new helper_lvl = DOF2_GetInt(file, "Helper");
    if(level < 1) level = 1;

    new experienceMultiplier = HappyHourMultiplier;
    if(admin_lvl > 0) experienceMultiplier *= 2;
    PlayerRespekti[playerid] = DOF2_GetInt(file, "Respekti") + experienceMultiplier;
    DOF2_SetInt(file, "Sati", sati);

    new salary = 0, oldBank = DOF2_GetInt(file, "Banka"), newBank = oldBank;
    new interest = 0, wealthTax = 0, pension = 0, timeBonus = 0;
    new insurance = DOF2_GetInt(file, "Osiguranja");
    new houseid = DOF2_IsSet(file, "Kuca") ? DOF2_GetInt(file, "Kuca") : -1;
    new bool:hasHouse = houseid >= 0 && houseid < MAX_KUCA;
    new electricityBill = 0, waterBill = 0, communalBill = 0;
    if(hasHouse)
    {
        electricityBill = 100 + random(151);
        waterBill = 60 + random(91);
        communalBill = 50 + random(101);
    }
    if(SessionContinuousMinutes[playerid] >= 180) timeBonus = 6000;
    new bool:bankOpen = HasOpenedBankAccount(file) != 0;
    if(admin_lvl > 0) salary = 2000;
    else if(helper_lvl > 0) salary = 1000;
    else if(sati % 2 == 0) salary = 2500;
    if(bankOpen)
    {
        if(oldBank > 0) interest = oldBank / 100000;
        if(oldBank >= 100000) wealthTax = oldBank / 1250;
        newBank = oldBank + salary + pension + timeBonus + interest - wealthTax - electricityBill - waterBill - communalBill;
        DOF2_SetInt(file, "Banka", newBank);
        UpdateBankaTD(playerid, newBank);
    }
    else
    {
        salary = 0;
        timeBonus = 0;
        SendClientMessage(playerid, 0xFF7777FF, "[PAYDAY]: Nemate otvoren bankovni racun i niste dobili platu.");
    }

    new oldLevel = level;
    new needed = level * 4;
    while(PlayerRespekti[playerid] >= needed)
    {
        PlayerRespekti[playerid] -= needed;
        level++;
        needed = level * 4;
    }
    DOF2_SetInt(file, "Level", level);
    DOF2_SetInt(file, "Respekti", PlayerRespekti[playerid]);
    PlayerInfo[playerid][pLevel] = level;
    PlayerInfo[playerid][pSati] = sati;
    PlayerInfo[playerid][pRespekti] = PlayerRespekti[playerid];
    SetPlayerScore(playerid, level);

    new sickUntil = DOF2_GetInt(file, "BolestanDo");
    if(sickUntil == 0 && random(100) < 10)
    {
        DOF2_SetInt(file, "BolestanDo", 1);
        SendClientMessage(playerid, 0xFFAA66FF, "[ZDRAVLJE]: Razbolili ste se. Uhvatili ste gripu, idite u Bolnicu da se izlijecite.");
    }
    DOF2_SaveFile();

    new message[160];
    format(message, sizeof(message), "[PAYDAY]: Dobili ste %dx Experience i %d RSD na banku. Experience: %d/%d.", experienceMultiplier, salary, PlayerRespekti[playerid], level * 4);
    SendClientMessage(playerid, 0x00FF00FF, message);
    new report[2400], reportPart[512], bankStatus[160], stateText[220], quoteText[220], horoscopeText[280], suggestionText[180];
    if(bankOpen) format(bankStatus, sizeof(bankStatus), "{FF9900}Staro Stanje: %d dinara\n{009933}Novo Stanje: %d dinara", oldBank, newBank);
    else format(bankStatus, sizeof(bankStatus), "{FF4444}Racun nije otvoren - plata nije uplacena.");

    switch(random(3))
    {
        case 0: format(stateText, sizeof(stateText), "{FF3333}Finansijsko stanje u drzavi: JAKO Nestabilno, DRZAVNA KRIZA i Mora MNOGO vise da se radi !");
        case 1: format(stateText, sizeof(stateText), "{FF9900}Finansijsko stanje u drzavi: Srednje, drzava posluje promjenjivo i potrebno je vise rada !");
        case 2: format(stateText, sizeof(stateText), "{009933}Finansijsko stanje u drzavi: Stabilno i dobro, drzava profitira i narod lijepo zivi !");
    }
    switch(random(5))
    {
        case 0: format(quoteText, sizeof(quoteText), "Znati da znas ono sto znas i da ne znas ono sto ne znas, eto ti najveceg znanja.");
        case 1: format(quoteText, sizeof(quoteText), "Kada se ide u pogresnom smjeru, onda najnapredniji vuku unazad...");
        case 2: format(quoteText, sizeof(quoteText), "Nije vazno koliko sporo ides sve dok se ne zaustavis.");
        case 3: format(quoteText, sizeof(quoteText), "Ko rano ustane, taj ima vise vremena da pogrijesi.");
        case 4: format(quoteText, sizeof(quoteText), "Najbolji put do uspjeha je da svaki dan uradis bar jednu dobru stvar.");
    }
    switch(random(5))
    {
        case 0:
        {
            format(horoscopeText, sizeof(horoscopeText), "Vodolija - Delujete raspolozeno i svoj posao obavljate rutinski, bez dodatnih sumnji. Pokusavate pravilno razumjeti neciju emotivnu reakciju.");
            if(random(2)) format(suggestionText, sizeof(suggestionText), "Izbegavajte stresne situacije i ne reagujte ishitreno.");
            else format(suggestionText, sizeof(suggestionText), "Budite strpljivi i saslusajte osobu do koje vam je stalo.");
        }
        case 1:
        {
            format(horoscopeText, sizeof(horoscopeText), "Jarac - Potrebno je da kontrolisete psihicku i emotivnu napetost kroz pojacanu radnu aktivnost.");
            if(random(2)) format(suggestionText, sizeof(suggestionText), "Odvojite vrijeme za odmor i smanjite nepotrebnu napetost.");
            else format(suggestionText, sizeof(suggestionText), "Zavrsavajte obaveze redom i ne preuzimajte previse posla.");
        }
        case 2:
        {
            format(horoscopeText, sizeof(horoscopeText), "Lav - Danas vas prati dobra energija, ali ne donosite vazne odluke u zurbi.");
            if(random(2)) format(suggestionText, sizeof(suggestionText), "Saslusajte druge prije nego donesete vaznu odluku.");
            else format(suggestionText, sizeof(suggestionText), "Iskoristite energiju za posao koji vec dugo odlazete.");
        }
        case 3:
        {
            format(horoscopeText, sizeof(horoscopeText), "Blizanci - Ocekuje vas zanimljiv razgovor i prilika da rijesite stari nesporazum.");
            if(random(2)) format(suggestionText, sizeof(suggestionText), "Razgovarajte smireno i jasno recite ono sto mislite.");
            else format(suggestionText, sizeof(suggestionText), "Ne donosite zakljucke prije nego cujete drugu stranu.");
        }
        case 4:
        {
            format(horoscopeText, sizeof(horoscopeText), "Ribe - Posvetite vise vremena odmoru i ljudima koji vam donose mir.");
            if(random(2)) format(suggestionText, sizeof(suggestionText), "Posvetite vrijeme sebi i ljudima kojima vjerujete.");
            else format(suggestionText, sizeof(suggestionText), "Izbegavajte rasprave i pronadite vrijeme za miran odmor.");
        }
    }

    format(report, sizeof(report), "{00008B}			|----------| BANKARSKI IZVESTAJ |----------|			\n");
    format(reportPart, sizeof(reportPart), "{FF9900}Drzavna plata: %d dinara || Penzija: %d dinara\n", salary, pension);
    strcat(report, reportPart);
    format(reportPart, sizeof(reportPart), "{00008B}OSIGURANJE: Dobili ste platu, ali ne zaboravite na osiguranje: %d\n", insurance);
    strcat(report, reportPart);
    if(timeBonus > 0)
        format(reportPart, sizeof(reportPart), "{009933}VREMENSKI BONUS: Skupili ste 3 sata neprekidnog igranja i dobili bonus od %d dinara\n", timeBonus);
    else
        format(reportPart, sizeof(reportPart), "{009933}VREMENSKI BONUS: Niste jos skupili 3 sata neprekidnog igranja da bi dobili bonus od 6000 dinara\n");
    strcat(report, reportPart);
    format(reportPart, sizeof(reportPart), "{FF9900}Stecen interes od para u banci: %d dinara\n{FF3333}Porez na bogatstvo: -%d dinara\n", interest, wealthTax);
    strcat(report, reportPart);
    strcat(report, "{00008B}|-------------------------------|\n");
    format(reportPart, sizeof(reportPart), "{FF3333}Racun za struju: -%d dinara\nRacun za vodu: -%d dinara\nRacun za komunalije: -%d dinara\n", electricityBill, waterBill, communalBill);
    strcat(report, reportPart);
    strcat(report, "{00008B}|-------------------------------|\n");
    format(reportPart, sizeof(reportPart), "{FF3333}Rent: -%d dinara\n", RentPaidSincePayday[playerid]);
    strcat(report, reportPart);
    strcat(report, "{009933}Kamatna stopa: {FFD700}0.001 posto\n{00008B}|-------------------------------|\n");
    strcat(report, bankStatus);
    strcat(report, "\n{00008B}|-------------- STATUS DRZAVE -----------------|\n");
    strcat(report, stateText);
    strcat(report, "\n{FFFFFF}PORUKA DANA: ");
    strcat(report, quoteText);
    strcat(report, "\n{FF3333}HOROSKOP: ");
    strcat(report, horoscopeText);
    strcat(report, "\n{FF3333}Sugestija: ");
    strcat(report, suggestionText);
    ShowPlayerDialog(playerid, DIALOG_PAYDAY_REPORT, DIALOG_STYLE_MSGBOX, "Bankarski Izvestaj gradana!", report, "Ok", "");
    RentPaidSincePayday[playerid] = 0;
    if(bankOpen) GameTextForPlayer(playerid, "~y~PLATA JE SJELA NA VAS RACUN", 5000, 3);
    if(level > oldLevel)
    {
        format(message, sizeof(message), "[SERVER]: Cestitamo! Presli ste sa levela %d na level %d.", oldLevel, level);
        SendClientMessage(playerid, 0xFFFF00FF, message);
    }
    return 1;
}
CMD:setadmincode(playerid, params[])
{
    if(strlen(params))
        return SendClientMessage(playerid, 0x00BFFFFF, "Koristenje: /setadmincode (novi kod se unosi u prozoru)");
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Prvo se prijavite na nalog.");

    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Nalog nije pronaden.");
    if(DOF2_GetInt(file, "Admin") < 9 && !IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Samo vlasnik ili RCON admin moze promijeniti kod.");

    ShowPlayerDialog(playerid, DIALOG_SET_ADMIN_CODE, DIALOG_STYLE_PASSWORD,
        "Promjena admin koda", "Unesite novi admin kod (1-32 znaka):", "Sacuvaj", "Odustani");
    return 1;
}
CMD:setcodeadmin(playerid, params[])
{
    // Provjera da li je igrac RCON admin ILI Vlasnik
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_rank = 0;
    if(DOF2_FileExists(file)) {
        admin_rank = DOF2_GetInt(file, "Admin");
    }

    // Ako nije admin, ne radi ni?ta (za obicne igrace)
    if(admin_rank < 1 && !IsPlayerAdmin(playerid)) return 0;

    // Ako je admin ali nije Vlasnik, daje mu gre?ku
    if(!IsPlayerAdmin(playerid) && admin_rank < 9)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste Vlasnik servera i ne mozete koristiti ovu komandu!");
        return 1;
    }

    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/setcodeadmin [ID / Ime]");
        return 1;
    }

    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac nije na serveru!");
        return 1;
    }

    // Generisanje koda
    new random_code = 1000 + random(9000);

    // Snimanje u fajl
    new target_file[128], target_name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, target_name, sizeof(target_name));
    format(target_file, sizeof(target_file), "Korisnici/%s.ini", target_name);

    if(!DOF2_FileExists(target_file))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Fajl tog igraca ne postoji!");
        return 1;
    }

    DOF2_SetInt(target_file, "AdminKod", random_code);
    DOF2_SaveFile();

    // Slanje dijaloga igracu
    new dialog_string[512];
    format(dialog_string, sizeof(dialog_string),
        "{FFFFFF}Admin %s vam je dodijelio tajni kod!\n\n\
        Vas novi admin kod je: {FF0000}%d\n\n\
        {FFFFFF}OBAVEZNO slikajte (F8) ili zapamtite ovaj kod.\n\
        Trebace vam na Loginu da pristupite admin komandama!",
        ime, random_code);

    ShowPlayerDialog(targetid, DIALOG_ADMIN_CODE_NOTICE, DIALOG_STYLE_MSGBOX, "Admin Kod - Balkan Revolution", dialog_string, "Razumijem", "");

    // Obavjestenje onome ko kuca komandu
    new string[128];
    format(string, sizeof(string), "Uspje?no ste generisali admin kod (%d) za igraca %s.", random_code, target_name);
    SendClientMessage(playerid, 0x00BFFFFF, string);

    return 1;
}

CMD:dajadmina(playerid, params[])
{
    new actorFile[128], actorName[MAX_PLAYER_NAME], actorRank;
    GetPlayerName(playerid, actorName, sizeof(actorName));
    format(actorFile, sizeof(actorFile), "Korisnici/%s.ini", actorName);
    if(DOF2_FileExists(actorFile)) actorRank = DOF2_GetInt(actorFile, "Admin");
    if(!IsPlayerAdmin(playerid) && actorRank < RANK_SUVLASNIK)
        return SendClientMessage(playerid, 0xFF0000FF, "GRE?KA: Komandu mogu koristiti Suvlasnik, Vlasnik i RCON admin.");

    new targetid, rank;
    if(sscanf(params, "ui", targetid, rank))
        return SendClientMessage(playerid, 0x00BFFFFF, "KORI?TENJE: /dajadmina [ID/Ime] [Rank 0-9]");
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRE?KA: Igra? nije na serveru.");
    if(rank < 0 || rank > RANK_VLASNIK)
        return SendClientMessage(playerid, 0xFF0000FF, "GRE?KA: Admin rank mora biti izmedu 0 i 9.");
    if(!IsPlayerAdmin(playerid) && rank >= actorRank && rank > 0)
        return SendClientMessage(playerid, 0xFF0000FF, "GRE?KA: Ne mo?ete dodijeliti rank jednak ili ve?i od svog.");

    new targetFile[128], targetName[MAX_PLAYER_NAME], message[180];
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(targetFile, sizeof(targetFile), "Korisnici/%s.ini", targetName);
    if(!DOF2_FileExists(targetFile))
        return SendClientMessage(playerid, 0xFF0000FF, "GRE?KA: Korisni?ki fajl igra?a nije pronaden.");

    DOF2_SetInt(targetFile, "Admin", rank);
    DOF2_SetInt(targetFile, "AdminDuty", 0);
    if(rank == 0)
    {
        DOF2_SetString(targetFile, "AdminKod", "");
        DOF2_SaveFile();
        UpdateAdminLabel(targetid);
        format(message, sizeof(message), "Administrator %s vam je uklonio admin poziciju.", actorName);
        SendClientMessage(targetid, 0xFF7777FF, message);
        format(message, sizeof(message), "Uspje?no ste uklonili admin poziciju igra?u %s.", targetName);
        return SendClientMessage(playerid, 0x33CCFFFF, message);
    }

    new code[12];
    format(code, sizeof(code), "%d", 100000 + random(900000));
    DOF2_SetString(targetFile, "AdminKod", code);
    DOF2_SaveFile();
    UpdateAdminLabel(targetid);
    format(message, sizeof(message), "Administrator %s vam je dodijelio Admin rank %d. Va? login kod je: %s", actorName, rank, code);
    SendClientMessage(targetid, 0x33CCFFFF, message);
    format(message, sizeof(message), "Uspje?no ste dodijelili Admin rank %d igra?u %s. Kod: %s", rank, targetName, code);
    SendClientMessage(playerid, 0x33CCFFFF, message);
    return 1;
}

CMD:dajadmin(playerid, params[]) return cmd_dajadmina(playerid, params);

CMD:admini(playerid, params[])
{
    new player_file[128], player_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, player_name, sizeof(player_name));
    format(player_file, sizeof(player_file), "Korisnici/%s.ini", player_name);

    new admin_rank = 0;
    if(DOF2_FileExists(player_file))
    {
        admin_rank = DOF2_GetInt(player_file, "Admin");
    }

    if(admin_rank < 1 && !IsPlayerAdmin(playerid)) return 1;

    new dialog_string[4096], count = 0;

    // 1. Dio: Online admini
    format(dialog_string, sizeof(dialog_string), "{FFFFFF}ONLINE ADMINI:\n");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new i_file[128], i_name[MAX_PLAYER_NAME];
            GetPlayerName(i, i_name, sizeof(i_name));
            format(i_file, sizeof(i_file), "Korisnici/%s.ini", i_name);

            if(DOF2_FileExists(i_file))
            {
                new i_admin = DOF2_GetInt(i_file, "Admin");
                if(i_admin > 0)
                {
                    new duznost[32];
                    if(DOF2_GetInt(i_file, "AdminDuty") == 1) duznost = "{00FF00}Na duznosti!";
                    else duznost = "{FF0000}Nije na duznosti!";

                    format(dialog_string, sizeof(dialog_string), "%s{FFFFFF}[ID %d] %s | Admin Level: %d | Duznost: %s\n", dialog_string, i, i_name, i_admin, duznost);
                    count++;
                }
            }
        }
    }

    if(count == 0)
    {
        format(dialog_string, sizeof(dialog_string), "%s{FFFFFF}Trenutno nema admina online.\n", dialog_string);
    }

    // 2. Dio: Spisak slotova od 0 do 20 (Vracen tvoj tacan originalni kod)
    format(dialog_string, sizeof(dialog_string), "%s\n{FFFFFF}[SPISAK SVIH ADMINA]\n========================================\n", dialog_string);

    for(new slot = 0; slot <= 20; slot++)
    {
        new slot_ime[MAX_PLAYER_NAME] = "Nema";
        new slot_datum[32] = "-";
        new slot_admin_level = 0;
        new zauzet_slot = 0;

        // Prvo provjeravamo da li je neki online igrac u ovom slotu
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                new i_file[128], i_name[MAX_PLAYER_NAME];
                GetPlayerName(i, i_name, sizeof(i_name));
                format(i_file, sizeof(i_file), "Korisnici/%s.ini", i_name);

                if(DOF2_FileExists(i_file))
                {
                    new i_admin = DOF2_GetInt(i_file, "Admin");
                    new i_slot = DOF2_GetInt(i_file, "AdminSlot");

                    if(i_admin > 0 && i_slot == slot)
                    {
                        format(slot_ime, sizeof(slot_ime), "%s", i_name);
                        slot_admin_level = i_admin;
                        if(DOF2_IsSet(i_file, "AdminDatum") && strlen(DOF2_GetString(i_file, "AdminDatum")) > 0)
                            format(slot_datum, sizeof(slot_datum), "%s", DOF2_GetString(i_file, "AdminDatum"));
                        else format(slot_datum, sizeof(slot_datum), "Nije zabiljezen");
                        zauzet_slot = 1;
                        break;
                    }
                }
            }
        }

        // Prazan slot ostaje oznacen kao slobodan.
        if(zauzet_slot == 0) slot_admin_level = 0;

        format(dialog_string, sizeof(dialog_string), "%s{FFFFFF}[ADMIN LEVEL %d] [SLOT %d]: %s | Datum: %s\n", dialog_string, slot_admin_level, slot, slot_ime, slot_datum);
    }

    ShowPlayerDialog(playerid, 998, DIALOG_STYLE_MSGBOX, "Admin Balkan Revolution Server", dialog_string, "Ok", "");
    return 1;
}
CMD:adminduty(playerid, params[])
{
    // Provjera da li je igrac admin preko njegovog .ini fajla
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_rank = 0;
    if(DOF2_FileExists(file)) {
        admin_rank = DOF2_GetInt(file, "Admin");
    }

    // Ako igrac nije admin, ne radi ni?ta (obicni igraci vide Unknown command)
    if(admin_rank < 1 && !IsPlayerAdmin(playerid)) return 0;

    // Trenutno stanje du?nosti iz fajla
    new current_duty = DOF2_GetInt(file, "AdminDuty");
    new string[128];

    if(current_duty == 0)
    {
        // Prelazi na du?nost
        DOF2_SetInt(file, "AdminDuty", 1);
        DOF2_SaveFile();

        // Postavljamo Health i Armor na 100
        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 100.0);

        // Format poruke sa zvjezdicama, imenom, ID-om i statusom
        format(string, sizeof(string), "** ADMIN: %s[%d] je sada na Admin du?nosti **", ime, playerid);
    }
    else
    {
        // Skida se sa du?nosti
        DOF2_SetInt(file, "AdminDuty", 0);
        DOF2_SaveFile();

        // Kada skine duty, bri?emo mu armor (stavljamo na 0) i vracamo normalno tro?enje
        SetPlayerArmour(playerid, 0.0);

        // Format poruke kad nije vi?e na du?nosti
        format(string, sizeof(string), "** ADMIN: %s[%d] vi?e nije na Admin du?nosti **", ime, playerid);
    }

    // Slanje poruke ISKLJUCIVO online adminima u zlatno-?utoj boji (0xF9A602FF)
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new i_file[128], i_name[MAX_PLAYER_NAME];
            GetPlayerName(i, i_name, sizeof(i_name));
            format(i_file, sizeof(i_file), "Korisnici/%s.ini", i_name);

            if(DOF2_FileExists(i_file))
            {
                if(DOF2_GetInt(i_file, "Admin") > 0 || IsPlayerAdmin(i))
                {
                    SendClientMessage(i, 0xF9A602FF, string);
                }
            }
        }
    }

    return 1;
}
CMD:dajhelpera(playerid, params[])
{
    // Provjera admin ranka igraca koji kuca komandu
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_rank = 0;
    if(DOF2_FileExists(file)) {
        admin_rank = DOF2_GetInt(file, "Admin");
    }

    // Dozvola: Samo Skripter(7), Suvlasnik(8) i Vlasnik(9) mogu koristiti komandu
    if(!IsPlayerAdmin(playerid) && admin_rank < 7)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje da koristite ovu komandu!");
        return 1;
    }

    new targetid, rank;
    if(sscanf(params, "ui", targetid, rank))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/dajhelpera [ID / Ime] [Rank (0-5)]");
        return 1;
    }

    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac nije na serveru!");
        return 1;
    }

    if(rank < 0 || rank > 5)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Rank helpera mora biti izmedu 0 i 5!");
        return 1;
    }

    new target_file[128], target_name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, target_name, sizeof(target_name));
    format(target_file, sizeof(target_file), "Korisnici/%s.ini", target_name);

    if(!DOF2_FileExists(target_file))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Fajl tog igraca ne postoji!");
        return 1;
    }

    // --- AKO JE RANK 0 -> SKIDA MU HELPERA ---
    if(rank == 0)
    {
        DOF2_SetInt(target_file, "Helper", 0);
        DOF2_SetInt(target_file, "HDuty", 0);
        DOF2_SetInt(target_file, "HelperSlot", -1);
        DOF2_SetString(target_file, "HelperCode", "");
        DOF2_SaveFile();

        // Bri?emo staru labelu ako je ima
        if(HelperLabel[targetid] != Text3D:INVALID_3DTEXT_ID)
        {
            Delete3DTextLabel(HelperLabel[targetid]);
            HelperLabel[targetid] = Text3D:INVALID_3DTEXT_ID;
        }

        new string[128];
        format(string, sizeof(string), "Admin %s vam je skinuo helper poziciju.", ime);
        SendClientMessage(targetid, 0xFF0000FF, string);

        format(string, sizeof(string), "Uspjesno ste skinuli helper poziciju igracu %s.", target_name);
        SendClientMessage(playerid, 0x00BFFFFF, string);
        return 1;
    }

    // --- AUTOMATSKO DODELJIVANJE HELPER SLOTA (0-20) KROZ SVE IGRACE ---
    new slobodan_slot = -1;
    for(new s = 0; s <= 20; s++)
    {
        new zauzet = 0;
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                new i_file[128], i_name[MAX_PLAYER_NAME];
                GetPlayerName(i, i_name, sizeof(i_name));
                format(i_file, sizeof(i_file), "Korisnici/%s.ini", i_name);

                if(DOF2_FileExists(i_file))
                {
                    if(DOF2_GetInt(i_file, "Helper") > 0 && DOF2_GetInt(i_file, "HelperSlot") == s)
                    {
                        if(i != targetid)
                        {
                            zauzet = 1;
                            break;
                        }
                    }
                }
            }
        }
        if(zauzet == 0) { slobodan_slot = s; break; }
    }

    if(slobodan_slot == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nema vise slobodnih helper slotova (sva 20 su zauzeta)!");
        return 1;
    }
    // ----------------------------------------------------

    // Odredivanje skina na osnovu ranga
    new odabrani_skin = 188;
    if(rank == 4) odabrani_skin = 60;
    else if(rank == 5) odabrani_skin = 186;

    // Upisivanje i snimanje fajla
    DOF2_SetInt(target_file, "Helper", rank);
    DOF2_SetInt(target_file, "HDuty", 0);
    DOF2_SetInt(target_file, "HelperSlot", slobodan_slot);
    DOF2_SetInt(target_file, "Skin", odabrani_skin);
    DOF2_SaveFile(); // Cuva se trajno na disk!

    // Postavljanje skina
    SetPlayerSkin(targetid, odabrani_skin);

    // --- DIREKTNO KREIRANJE LABELA U VELIKIM ZAGRADAMA ---
    if(HelperLabel[targetid] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(HelperLabel[targetid]);
        HelperLabel[targetid] = Text3D:INVALID_3DTEXT_ID;
    }

    new label_string[64];
    format(label_string, sizeof(label_string), "{FFFF00}[Helper Level: %d]", rank);
    HelperLabel[targetid] = Create3DTextLabel(label_string, 0xFFFFFFFF, 0.0, 0.0, 0.0, 40.0, 0, 1);
    Attach3DTextLabelToPlayer(HelperLabel[targetid], targetid, 0.0, 0.0, 0.28);
    // ----------------------------------------------------

    // Poruke
    new string[128];
    format(string, sizeof(string), "Admin %s vam je dodijelio helper rank: %d (Slot: %d)", ime, rank, slobodan_slot);
    SendClientMessage(targetid, 0x00BFFFFF, string);

    format(string, sizeof(string), "Uspjesno ste dodijelili helper rank %d igracu %s na slotu %d (Skin: %d).", rank, target_name, slobodan_slot, odabrani_skin);
    SendClientMessage(playerid, 0x00BFFFFF, string);

    return 1;
}


stock UpdateHelperLabel(playerid)
{
    if(HelperLabel[playerid] != Text3D:INVALID_3DTEXT_ID) Delete3DTextLabel(HelperLabel[playerid]);

    new file[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    new rank = DOF2_GetInt(file, "Helper");
    if(rank == 0) return 1;

    new labeltext[64], rankname[32];
    switch(rank) {
        case 1: rankname = "Helper 1";
        case 2: rankname = "Helper 2";
        case 3: rankname = "Helper 3";
        case 4: rankname = "Z. Head Helpera";
        case 5: rankname = "Head Helper";
    }

    format(labeltext, sizeof(labeltext), "{FFFF00}%s", rankname);
    HelperLabel[playerid] = Create3DTextLabel(labeltext, 0xFFFFFFFF, 0, 0, 0, 15.0, 0, 1);
    Attach3DTextLabelToPlayer(HelperLabel[playerid], playerid, 0.0, 0.0, 0.35);
    return 1;
}
CMD:hduty(playerid, params[])
{
    new file[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(DOF2_GetInt(file, "Helper") < 1) return 0;

    new duty = DOF2_GetInt(file, "HDuty");
    new string[128], adminString[128];

    if(duty == 0) {
        DOF2_SetInt(file, "HDuty", 1);
        SetPlayerColor(playerid, 0xFFFF00FF); // Skroz cista zuta boja u TAB-u

        // Postavljamo Health i Armor na 100 kad ude na du?nost
        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 100.0);

        format(string, sizeof(string), "** HELPER: %s je sada na Helper duznosti **", name);
        format(adminString, sizeof(adminString), "** HELPER: %s[%d] je sada na Helper duznosti **", name, playerid);
    } else {
        DOF2_SetInt(file, "HDuty", 0);
        SetPlayerColor(playerid, 0xFFFFFFFF); // Vraca na bijelo

        // Kada skine helper du?nost, bri?emo mu armor (stavljamo na 0) i vracamo normalno tro?enje
        SetPlayerArmour(playerid, 0.0);

        format(string, sizeof(string), "** HELPER: %s vise nije na Helper duznosti **", name);
        format(adminString, sizeof(adminString), "** HELPER: %s[%d] vise nije na Helper duznosti **", name, playerid);
    }
    for(new viewer = 0; viewer < MAX_PLAYERS; viewer++)
    {
        if(!IsPlayerConnected(viewer)) continue;
        if(HasAdminCommandAccess(viewer)) SendClientMessage(viewer, 0xFFFF00FF, adminString);
        else SendClientMessage(viewer, 0xFFFF00FF, string);
    }
    DOF2_SaveFile();
    return 1;
}
CMD:helperi(playerid, params[])
{
    new player_file[128], player_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, player_name, sizeof(player_name));
    format(player_file, sizeof(player_file), "Korisnici/%s.ini", player_name);

    new admin_rank = 0, helper_rank = 0;
    if(DOF2_FileExists(player_file))
    {
        admin_rank = DOF2_GetInt(player_file, "Admin");
        helper_rank = DOF2_GetInt(player_file, "Helper");
    }

    // Samo admini i helperi mogu da vide spisak helpera
    if(admin_rank < 1 && helper_rank < 1 && !IsPlayerAdmin(playerid)) return 1;

    new dialog_string[2048], count = 0;

    // 1. Dio: Online helperi
    format(dialog_string, sizeof(dialog_string), "{FFFFFF}ONLINE HELPERI:\n");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new i_file[128], i_name[MAX_PLAYER_NAME];
            GetPlayerName(i, i_name, sizeof(i_name));
            format(i_file, sizeof(i_file), "Korisnici/%s.ini", i_name);

            if(DOF2_FileExists(i_file))
            {
                new i_helper = DOF2_GetInt(i_file, "Helper");
                if(i_helper > 0)
                {
                    new duznost[32];
                    if(DOF2_GetInt(i_file, "HDuty") == 1) duznost = "{00FF00}Na duznosti!";
                    else duznost = "{FF0000}Nije na duznosti!";

                    new h_naziv[32];
                    switch(i_helper) {
                        case 1: h_naziv = "Helper 1";
                        case 2: h_naziv = "Helper 2";
                        case 3: h_naziv = "Helper 3";
                        case 4: h_naziv = "Z. Head Helpera";
                        case 5: h_naziv = "Head Helper";
                        default: h_naziv = "Helper";
                    }

                    format(dialog_string, sizeof(dialog_string), "%s[ID %d] %s | %s | Duznost: %s\n", dialog_string, i, i_name, h_naziv, duznost);
                    count++;
                }
            }
        }
    }

    if(count == 0)
    {
        format(dialog_string, sizeof(dialog_string), "%sTrenutno nema helpera online.\n", dialog_string);
    }

    // 2. Dio: Spisak slotova od 0 do 20 za helpere
    format(dialog_string, sizeof(dialog_string), "%s\n{FFFFFF}[SPISAK SVIH HELPER SLOTOVA]\n========================================\n", dialog_string);

    for(new slot = 0; slot <= 20; slot++)
    {
        new slot_ime[MAX_PLAYER_NAME] = "Nema";
        new slot_prikaz[64];
        new zauzet_slot = 0;

        // Prvo provjeravamo da li je neki online igrac u ovom slotu
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                new i_file[128], i_name[MAX_PLAYER_NAME];
                GetPlayerName(i, i_name, sizeof(i_name));
                format(i_file, sizeof(i_file), "Korisnici/%s.ini", i_name);

                if(DOF2_FileExists(i_file))
                {
                    new i_helper = DOF2_GetInt(i_file, "Helper");
                    new i_slot = DOF2_GetInt(i_file, "HelperSlot"); // Slot za helpere u .ini fajlu

                    if(i_helper > 0 && i_slot == slot)
                    {
                        format(slot_ime, sizeof(slot_ime), "%s", i_name);

                        new h_naziv[32];
                        switch(i_helper) {
                            case 1: h_naziv = "Helper 1";
                            case 2: h_naziv = "Helper 2";
                            case 3: h_naziv = "Helper 3";
                            case 4: h_naziv = "Z. Head";
                            case 5: h_naziv = "Head Helper";
                            default: h_naziv = "Helper";
                        }
                        format(slot_prikaz, sizeof(slot_prikaz), "%s", h_naziv);
                        zauzet_slot = 1;
                        break;
                    }
                }
            }
        }

        // Ako slot nema online igraca, ispisuje se zadana vrijednost za prazno (npr. 239 ili Nema)
        if(zauzet_slot == 0)
        {
            format(slot_prikaz, sizeof(slot_prikaz), "239");
        }

        format(dialog_string, sizeof(dialog_string), "%s[HELPER] [SLOT %d]: %s | %s\n", dialog_string, slot, slot_ime, slot_prikaz);
    }

    ShowPlayerDialog(playerid, 997, DIALOG_STYLE_MSGBOX, "Helperi - Balkan Revolution Server", dialog_string, "Ok", "");
    return 1;
}
CMD:setcodehelper(playerid, params[])
{
    // Provjera admin ranka igraca koji kuca komandu
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_rank = 0;
    if(DOF2_FileExists(file)) {
        admin_rank = DOF2_GetInt(file, "Admin");
    }

    // Dozvola: Samo Skripter(7), Suvlasnik(8) i Vlasnik(9) mogu koristiti komandu
    if(!IsPlayerAdmin(playerid) && admin_rank < 7)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje da koristite ovu komandu!");
        return 1;
    }

    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/setcodehelper [ID / Ime]");
        return 1;
    }

    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac nije na serveru!");
        return 1;
    }

    // Ucitavanje fajla ciljanog igraca
    new target_file[128], target_name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, target_name, sizeof(target_name));
    format(target_file, sizeof(target_file), "Korisnici/%s.ini", target_name);

    if(!DOF2_FileExists(target_file))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Fajl ovog igraca ne postoji!");
        return 1;
    }

    // --- AUTOMATSKO GENERISANJE NASUMICNOG KODA ---
    // Generi?e nasumicni broj izmedu 100000 i 999999 i pretvara ga u string kod
    new random_kod[32];
    format(random_kod, sizeof(random_kod), "%d", 100000 + random(900000));

    // Upisivanje automatski generisanog koda u fajl
    DOF2_SetString(target_file, "HelperCode", random_kod);
    DOF2_SaveFile();

    // Poruke potvrde (ispisuje kod i igracu i adminu da vide)
    new string[128];
    format(string, sizeof(string), "Admin %s vam je dodijelio automatski helper kod: %s", ime, random_kod);
    SendClientMessage(targetid, 0x00BFFFFF, string);

    format(string, sizeof(string), "Uspjesno ste automatski generisali kod '%s' za igraca %s.", random_kod, target_name);
    SendClientMessage(playerid, 0x00BFFFFF, string);

    return 1;
}
forward GlobalniPayDay();
public GlobalniPayDay()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && GetPVarInt(i, "BR_LoggedIn"))
        {
            if(SessionPaydayMinutes[i] >= 45) DajPayDayRespekt(i);
            else SendClientMessage(i, 0xFF7777FF, "[PAYDAY]: Zao nam je, niste dovoljno dugo igrali za platu.");
            SessionPaydayMinutes[i] = 0;
        }
    }
    return 1;
}
// Na vrhu skripte provjeri da li ima?: new Text3D:AdminText[MAX_PLAYERS];

forward UpdateAdminLabel(playerid);
public UpdateAdminLabel(playerid)
{
    // Ako vec ima labelu, bri?emo je da se ne duplira
    if(AdminText[playerid] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(AdminText[playerid]);
        AdminText[playerid] = Text3D:INVALID_3DTEXT_ID;
    }

    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(DOF2_FileExists(file))
    {
        new admin_lvl = DOF2_GetInt(file, "Admin");
        if(admin_lvl > 0)
        {
            new string[128];

            // Dodate uglaste zagrade oko svakog ispisa
            switch(admin_lvl)
            {
                case RANK_ADMIN_1: format(string, sizeof(string), "{00BFFF}[Junior Admin]");
                case RANK_ADMIN_3: format(string, sizeof(string), "{000000}[Admin Level: 3]");
                case RANK_ADMIN_5: format(string, sizeof(string), "{000000}[Admin Level: 5]");
                case RANK_HEAD_ADMIN: format(string, sizeof(string), "{000000}[Head Admin]");
                case RANK_DIRECTOR: format(string, sizeof(string), "{000000}[Director]");
                case RANK_MAPPER: format(string, sizeof(string), "{000000}[Mapper]");
                case RANK_SKRIPTER: format(string, sizeof(string), "{000000}[Skripter]");
                case RANK_SUVLASNIK: format(string, sizeof(string), "{000000}[Suvlasnik]");
                case RANK_VLASNIK: format(string, sizeof(string), "{000000}[Vlasnik]");
                default: format(string, sizeof(string), "{000000}[Admin Level: %d]", admin_lvl);
            }

            // Kreiramo labelu i kacimo je tacno iznad imena
            AdminText[playerid] = Create3DTextLabel(string, 0xFFFFFFFF, 0.0, 0.0, 0.0, 40.0, 0, 1);
            Attach3DTextLabelToPlayer(AdminText[playerid], playerid, 0.0, 0.0, 0.28);
        }
    }
    return 1;
}
forward TajmerZaMinute();
public TajmerZaMinute()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !GetPVarInt(i, "BR_LoggedIn")) continue;
        new file[128];
        if(!GetPlayerAccountPath(i, file, sizeof(file))) continue;
        PlayerMinute[i]++;
        SessionPaydayMinutes[i]++;
        SessionContinuousMinutes[i]++;
        if(PlayerMinute[i] >= 60)
        {
            PlayerMinute[i] = 0;
            DOF2_SetInt(file, "MinuteIgranja", 0);
            DOF2_SaveFile();
        }
        else
        {
            DOF2_SetInt(file, "MinuteIgranja", PlayerMinute[i]);
            DOF2_SaveFile();
        }
    }
    return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if(issuerid != INVALID_PLAYER_ID && issuerid != playerid && IsPlayerConnected(issuerid))
    {
        LastDamageIssuer[playerid] = issuerid; LastDamageWeapon[playerid] = weaponid; LastDamageAt[playerid] = gettime();
    }
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(DOF2_FileExists(file))
    {
        // ?teta se blokira SAMO ako je na admin ili helper du?nosti
        if(DOF2_GetInt(file, "AdminDuty") == 1 || DOF2_GetInt(file, "HDuty") == 1)
        {
            SetPlayerHealth(playerid, 100.0);
            SetPlayerArmour(playerid, 100.0);
            return 0; // Poni?tava ?tetu
        }
    }
    return 1; // Cim skine du?nost, vraca se na normalno gubljenje HP-a i armora!
}
stock UpdateHouseCP(houseid)
{
    // Uni?tavanje starog 3D Labela samo ako je va?eci
    if(HouseInfo[houseid][kLabel] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(HouseInfo[houseid][kLabel]);
        HouseInfo[houseid][kLabel] = Text3D:INVALID_3DTEXT_ID;
    }

    // Uni?tavanje starog pikapa samo ako zapravo postoji (ne bri?e Pikap 0)
    if(HouseInfo[houseid][kPickup] != -1)
    {
        DestroyPickup(HouseInfo[houseid][kPickup]);
        HouseInfo[houseid][kPickup] = -1;
    }

    new string[300];
    if(HouseInfo[houseid][kOwned] == 0) // Na prodaju (Zelena ikonica 1273)
    {
        HouseInfo[houseid][kPickup] = CreatePickup(1273, 23, HouseInfo[houseid][kEntranceX], HouseInfo[houseid][kEntranceY], HouseInfo[houseid][kEntranceZ], -1);

        format(string, sizeof(string), "{00FFCC}Kuca je na Prodaju\n{00FFCC}Klasa: %s\n{00FFCC}Broj: %d\n{00FFCC}Vrsta: Na Prodaju\n{00FFCC}Level: %d\n{00FFCC}Cena: %d Dinar\n{00FFCC}Adresa Kuce: Los Santos\n{00FFCC}Da kupite kucu\n{00FFCC}kucajte /buyhouse",
            (HouseInfo[houseid][kKlasa] == 1) ? ("Mala Kuca") : ("Velika Kuca"),
            houseid,
            HouseInfo[houseid][kLevel],
            HouseInfo[houseid][kCena]);
    }
    else // Kupljena (Crvena ikonica 1272)
    {
        HouseInfo[houseid][kPickup] = CreatePickup(1272, 23, HouseInfo[houseid][kEntranceX], HouseInfo[houseid][kEntranceY], HouseInfo[houseid][kEntranceZ], -1);

        format(string, sizeof(string), "{00FFCC}Kuca vlasnistvo: {00FF00}%s\n{00FFCC}Klasa: %s\n{00FFCC}Broj: %d\n{00FFCC}Level: %d\n{00FFCC}Cena: %d Dinar\n{00FFCC}Adresa Kuce: Los Santos",
            HouseInfo[houseid][kOwner],
            (HouseInfo[houseid][kKlasa] == 1) ? ("Mala Kuca") : ("Velika Kuca"),
            houseid,
            HouseInfo[houseid][kLevel],
            HouseInfo[houseid][kCena]);
    }

    HouseInfo[houseid][kLabel] = Create3DTextLabel(string, 0x00FFCCFF, HouseInfo[houseid][kEntranceX], HouseInfo[houseid][kEntranceY], HouseInfo[houseid][kEntranceZ], 20.0, 0, 0);
    return 1;
}
stock SaveHouse(houseid)
{
    new file[128];
    format(file, sizeof(file), "BalkanRP/Kuce/kuca_%d.ini", houseid);

    if(!DOF2_FileExists(file)) DOF2_CreateFile(file);

    DOF2_SetInt(file, "Owned", HouseInfo[houseid][kOwned]);
    DOF2_SetFloat(file, "EntranceX", HouseInfo[houseid][kEntranceX]);
    DOF2_SetFloat(file, "EntranceY", HouseInfo[houseid][kEntranceY]);
    DOF2_SetFloat(file, "EntranceZ", HouseInfo[houseid][kEntranceZ]);
    DOF2_SetFloat(file, "ExitX", HouseInfo[houseid][kExitX]);
    DOF2_SetFloat(file, "ExitY", HouseInfo[houseid][kExitY]);
    DOF2_SetFloat(file, "ExitZ", HouseInfo[houseid][kExitZ]);
    DOF2_SetInt(file, "Interior", HouseInfo[houseid][kInterior]);
    DOF2_SetInt(file, "Cena", HouseInfo[houseid][kCena]);
    DOF2_SetInt(file, "Level", HouseInfo[houseid][kLevel]);
    DOF2_SetInt(file, "Klasa", HouseInfo[houseid][kKlasa]);
    DOF2_SetInt(file, "Locked", HouseInfo[houseid][kLocked]);
    DOF2_SetString(file, "Owner", HouseInfo[houseid][kOwner]);
    DOF2_SaveFile();
    return 1;
}
public LoadHouses()
{
    for(new h = 0; h < MAX_KUCA; h++)
    {
        // KLJUCNA IZMENA: Stavljamo na -1 pre ucitavanja da ne bri?e pikap/label 0
        HouseInfo[h][kPickup] = -1;
        HouseInfo[h][kLabel] = Text3D:INVALID_3DTEXT_ID;

        new file[128];
        format(file, sizeof(file), "BalkanRP/Kuce/kuca_%d.ini", h);
        if(DOF2_FileExists(file))
        {
            HouseInfo[h][kOwned] = DOF2_GetInt(file, "Owned");
            HouseInfo[h][kEntranceX] = DOF2_GetFloat(file, "EntranceX");
            HouseInfo[h][kEntranceY] = DOF2_GetFloat(file, "EntranceY");
            HouseInfo[h][kEntranceZ] = DOF2_GetFloat(file, "EntranceZ");
            HouseInfo[h][kExitX] = DOF2_GetFloat(file, "ExitX");
            HouseInfo[h][kExitY] = DOF2_GetFloat(file, "ExitY");
            HouseInfo[h][kExitZ] = DOF2_GetFloat(file, "ExitZ");
            HouseInfo[h][kInterior] = DOF2_GetInt(file, "Interior");
            HouseInfo[h][kCena] = DOF2_GetInt(file, "Cena");
            HouseInfo[h][kLevel] = DOF2_GetInt(file, "Level");
            HouseInfo[h][kKlasa] = DOF2_GetInt(file, "Klasa");
            HouseInfo[h][kLocked] = DOF2_GetInt(file, "Locked");
            format(HouseInfo[h][kOwner], MAX_PLAYER_NAME, "%s", DOF2_GetString(file, "Owner"));

            UpdateHouseCP(h);
        }
    }
    return 1;
}
CMD:napravikucu(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file))
    {
        admin_lvl = DOF2_GetInt(file, "Admin");
    }

    // Dozvoljeno samo adminu level 9 ili RCON adminu
    if(!IsPlayerAdmin(playerid) && admin_lvl < 9)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Samo Vlasnik (Admin 9) ili RCON admin moze kreirati kucu!");
        return 1;
    }

    new klasa, cena, level;
    if(sscanf(params, "iii", klasa, cena, level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/napravikucu [Klasa (1-Mala, 2-Velika)] [Cena] [Level]");
        return 1;
    }

    if(klasa < 1 || klasa > 2)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Klasa mora biti 1 (Mala) ili 2 (Velika)!");
        return 1;
    }

    // PRONALAZENJE SLOBODNOG SLOTA U MEMORIJI
    new id = -1;
    for(new h = 0; h < MAX_KUCA; h++)
    {
        if(HouseInfo[h][kEntranceX] == 0.0) // Ako je koordinata 0, slot je slobodan
        {
            id = h;
            break;
        }
    }

    if(id == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Dostignut je maksimalan broj kuca na serveru!");
        return 1;
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    // Postavljanje osnovnih podataka
    HouseInfo[id][kOwned] = 0;
    HouseInfo[id][kEntranceX] = x;
    HouseInfo[id][kEntranceY] = y;
    HouseInfo[id][kEntranceZ] = z;
    HouseInfo[id][kCena] = cena;
    HouseInfo[id][kLevel] = level;
    HouseInfo[id][kKlasa] = klasa;
    HouseInfo[id][kLocked] = 1;
    format(HouseInfo[id][kOwner], MAX_PLAYER_NAME, "Drzava");

    // ORIGINALNI GTA SA ENTERIJERI
    if(klasa == 1) // 1 = Mala kuca
    {
        HouseInfo[id][kExitX] = 227.1700;
        HouseInfo[id][kExitY] = 1114.3300;
        HouseInfo[id][kExitZ] = 1080.9900;
        HouseInfo[id][kInterior] = 5;
    }
    else // 2 = Velika kuca
    {
        HouseInfo[id][kExitX] = 2324.5400;
        HouseInfo[id][kExitY] = -1149.5300;
        HouseInfo[id][kExitZ] = 1050.7100;
        HouseInfo[id][kInterior] = 12;
    }

    // INICIJALIZACIJA ID-OVA (Sprecava brisanje kuce ID 0)
    HouseInfo[id][kPickup] = -1;
    HouseInfo[id][kLabel] = Text3D:INVALID_3DTEXT_ID;

    SaveHouse(id);
    UpdateHouseCP(id);

    new string[128];
    format(string, sizeof(string), "Uspjesno ste kreirali kucu ID: %d (Klasa: %s).", id, (klasa == 1) ? ("Mala") : ("Velika"));
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
CMD:izbrisikucu(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id;
    if(sscanf(params, "i", id)) return SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/izbrisikucu [ID Kuce]");

    new hfile[128];
    format(hfile, sizeof(hfile), "BalkanRP/Kuce/kuca_%d.ini", id);
    if(!DOF2_FileExists(hfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ta kuca ne postoji!");

    DOF2_RemoveFile(hfile);
    if(HouseInfo[id][kLabel] != Text3D:INVALID_3DTEXT_ID) Delete3DTextLabel(HouseInfo[id][kLabel]);

    DestroyPickup(HouseInfo[id][kPickup]); // Samo uni?tavamo pikap bez provjere

    HouseInfo[id][kOwned] = 0;
    HouseInfo[id][kCena] = 0;

    SendClientMessage(playerid, 0x00BFFFFF, "Uspjesno ste obrisali kucu!");
    return 1;
}

CMD:editujkucu(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id, nova_cijena, novi_level;
    if(sscanf(params, "iii", id, nova_cijena, novi_level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/editujkucu [ID Kuce] [Nova Cijena] [Novi Level]");
        return 1;
    }
    if(id < 0 || id >= MAX_MARKETA)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: ID biznisa mora biti izmedju 0 i 49.");
    if(nova_cijena < 0 || novi_level < 1)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Cijena ne moze biti negativna, a level mora biti najmanje 1.");
    if(id < 0 || id >= MAX_MARKETA || nova_cijena < 0 || novi_level < 1)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: ID, cijena ili level nisu ispravni.");

    new hfile[128];
    format(hfile, sizeof(hfile), "BalkanRP/Kuce/kuca_%d.ini", id);
    if(!DOF2_FileExists(hfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ta kuca ne postoji!");

    // Postavljamo i cijenu i level odednom
    HouseInfo[id][kCena] = nova_cijena;
    HouseInfo[id][kLevel] = novi_level;

    // Snimamo promjene i osvje?avamo kucu
    SaveHouse(id);
    UpdateHouseCP(id);

    new string[128];
    format(string, sizeof(string), "Uspje?no si izmijenio kucu ID: %d | Nova cijena: $%d | Novi level: %d", id, nova_cijena, novi_level);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
stock RemoveJetpackClean(playerid)
{
    // Prekid leta prije resetovanja akcije uklanja i zvuk jetpacka.
    ClearAnimations(playerid);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    ScriptJetpack[playerid] = false;
    return 1;
}

CMD:jetpack(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_rank = 0;
    if(DOF2_FileExists(file)) admin_rank = DOF2_GetInt(file, "Admin");
    if(!IsPlayerAdmin(playerid) && admin_rank < 1)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje za /jetpack.");
    if(IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ne mozete koristiti /jetpack dok ste u vozilu.");

    if(ScriptJetpack[playerid] || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
    {
        RemoveJetpackClean(playerid);
        return 1;
    }

    if(!SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK)) return 1;
    ScriptJetpack[playerid] = true;
    JetpackDropGuardUntil[playerid] = 0;
    SendClientMessageToAll(0xAFAFAFFF, "* Leti kao zmaj");
    return 1;
}
stock FindOwnedHouseByName(const name[])
{
    for(new h = 0; h < MAX_KUCA; h++)
    {
        if(HouseInfo[h][kOwned] == 1 && strcmp(HouseInfo[h][kOwner], name, true) == 0)
            return h;
    }
    return -1;
}
CMD:buyhouse(playerid, params[])
{
    // --- OSVJE?AVANJE LEVELA I NOVCA IZ FAJLA DA NE BUDE BAGS ---
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    if(!DOF2_FileExists(file)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Vas nalog nije pronaden!");
    PlayerInfo[playerid][pLevel] = DOF2_GetInt(file, "Level");
    PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
    // -----------------------------------------------------------

    // 1. Provjeravamo da li igrac stoji blizu neke kuce
    new houseid = -1;
    for(new h = 0; h < MAX_KUCA; h++)
    {
        // Provjerava da li je igrac u krugu od 3 metra od ulaza kuce
        if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][kEntranceX], HouseInfo[h][kEntranceY], HouseInfo[h][kEntranceZ]))
        {
            houseid = h;
            break;
        }
    }

    if(houseid == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste blizu nijedne kuce koju mo?ete kupiti!");
        return 1;
    }

    // 2. Provjeravamo da li je kuca vec prodata
    if(HouseInfo[houseid][kOwned] == 1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ova kuca vec ima svog vlasnika!");
        return 1;
    }

    // Vlasnistvo provjeravamo u svim kucama, ne samo preko pKuca.
    new ownedhouse = FindOwnedHouseByName(ime);
    if(ownedhouse != -1)
    {
        PlayerInfo[playerid][pKuca] = ownedhouse;
        if(!DOF2_IsSet(file, "Kuca") || DOF2_GetInt(file, "Kuca") != ownedhouse)
        {
            DOF2_SetInt(file, "Kuca", ownedhouse);
            DOF2_SaveFile();
        }
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Vec posjedujete kucu! Mozete imati samo jednu kucu.");
    }
    PlayerInfo[playerid][pKuca] = -1;
    if(DOF2_IsSet(file, "Kuca") && DOF2_GetInt(file, "Kuca") != -1)
    {
        DOF2_SetInt(file, "Kuca", -1);
        DOF2_SaveFile();
    }
    // 4. Provjeravamo da li igrac ima dovoljan level
    if(PlayerInfo[playerid][pLevel] < HouseInfo[houseid][kLevel])
    {
        new string[128];
        format(string, sizeof(string), "GRESKA: Nemate dovoljan level! (Tvoj level: %d | Potreban: %d)", PlayerInfo[playerid][pLevel], HouseInfo[houseid][kLevel]);
        SendClientMessage(playerid, 0xFF0000FF, string);
        return 1;
    }

    // 5. Provjeravamo novac u ruci
    if(PlayerInfo[playerid][pNovac] < HouseInfo[houseid][kCena])
    {
        new string[128];
        format(string, sizeof(string), "GRESKA: Nemate dovoljno novca! (Imate: $%d | Cijena: $%d)", PlayerInfo[playerid][pNovac], HouseInfo[houseid][kCena]);
        SendClientMessage(playerid, 0xFF0000FF, string);
        return 1;
    }

    // --- SVE JE U REDU, PROCES KUPOVINE ---

    // Oduzimamo novac u igri i pamtimo novo stanje
    GivePlayerMoney(playerid, -HouseInfo[houseid][kCena]);
    PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);

    // Snimamo novi novac i ID kuce u igracev .ini fajl
    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
        DOF2_SetInt(file, "Kuca", houseid);
        DOF2_SaveFile();
    }

    // Postavljamo podatke kuce
    HouseInfo[houseid][kOwned] = 1;
    GetPlayerName(playerid, HouseInfo[houseid][kOwner], MAX_PLAYER_NAME);

    // Upisujemo igracu da posjeduje ovu kucu
    PlayerInfo[playerid][pKuca] = houseid;

    // Spremamo kucu u fajl i a?uriramo 3D text/pikap
    SaveHouse(houseid);
    UpdateHouseCP(houseid);

    // Poruka uspjeha
    new succstring[128];
    format(succstring, sizeof(succstring), "Cestitamo! Uspje?no ste kupili kucu ID: %d za $%d.", houseid, HouseInfo[houseid][kCena]);
    SendClientMessage(playerid, 0x00BFFFFF, succstring);

    return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    // Ribolovac zabacuje udicu lijevim klikom dok je na smjeni.
    if((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE) &&
       PlayerJobData[playerid][JobID] == JOB_RIBOLOVAC &&
       PlayerJobData[playerid][JobDuty])
    {
        return StartRibolovacFishing(playerid);
    }

    // Admin vehicle jump: H podize vozilo i cuva trenutni pravac/brzinu.
    if((newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH) &&
        GetPlayerState(playerid) == PLAYER_STATE_DRIVER && HasAdminCommandAccess(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        new Float:vx, Float:vy, Float:vz;
        GetVehicleVelocity(vehicleid, vx, vy, vz);
        SetVehicleVelocity(vehicleid, vx, vy, vz + 0.35);
        return 1;
    }
    if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK) &&
        (ScriptJetpack[playerid] || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK))
    {
        // SA-MP klijent moze lokalno ostaviti odlozeni jetpack. Ponovno podizanje odmah skidamo.
        JetpackDropGuardUntil[playerid] = gettime() + 90;
        RemoveJetpackClean(playerid);
        SendClientMessage(playerid, 0x00BFFFFF, "[JETPACK]: Jetpack je uklonjen.");
        return 1;
    }

    // =========================================================================
    // TASTER "C" (PE?KE) ILI "H" (U VOZILU) -> KEY_CROUCH
    // =========================================================================
    if((newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH))
    {
        // 1. PROVERA ZA VOZILO ("H" u autu)
        if(IsPlayerInAnyVehicle(playerid) && IsPlayerInRangeOfPoint(playerid, 10.0, 1022.0895, -927.0981, 43.7344))
        {
            new file[128], ime[MAX_PLAYER_NAME];
            GetPlayerName(playerid, ime, sizeof(ime));
            format(file, sizeof(file), "Korisnici/%s.ini", ime);

            new clan_lvl = 0;
            if(DOF2_FileExists(file))
            {
                clan_lvl = DOF2_GetInt(file, "Clan");
                if(clan_lvl == 0) clan_lvl = DOF2_GetInt(file, "Member");
            }

            // Provera lidera u Lideri.ini
            new org_lider = 0;
            new lideri_file[64] = "BalkanRP/Lideri.ini";
            if(DOF2_FileExists(lideri_file))
            {
                for(new i = 1; i <= 20; i++)
                {
                    new key[32];
                    format(key, sizeof(key), "Lider_%d", i);
                    if(DOF2_IsSet(lideri_file, key))
                    {
                        new l_name[MAX_PLAYER_NAME];
                        format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                        if(strcmp(l_name, ime, true) == 0)
                        {
                            org_lider = i;
                            break;
                        }
                    }
                }
            }

            // Ako NIJE clan niti lider Parking Servisa
            if(clan_lvl != 7 && org_lider != 7)
            {
                SendClientMessage(playerid, 0xFF0000FF, "Niste clan Parking Servisa!");
                return 1;
            }

            // Otvaranje kapije za clana u autu
            MoveObject(kapija_parking, 1022.08948, -927.09814, 38.39440, 3.0);
            SetTimer("ZatvoriParkingKapiju", 15000, false);

            SendClientMessage(playerid, 0x00FF00FF, "* Trubnuo si. Kapija se otvara i zatvorice se za 15 sekundi.");
            return 1;
        }

        // 2. PROVERA ZA PE?KE ("C" van vozila)
        if(!IsPlayerInAnyVehicle(playerid) && IsPlayerInRangeOfPoint(playerid, 5.0, 1019.4164, -927.8874, 42.1797))
        {
            new file[128], ime[MAX_PLAYER_NAME];
            GetPlayerName(playerid, ime, sizeof(ime));
            format(file, sizeof(file), "Korisnici/%s.ini", ime);

            new clan_lvl = 0;
            if(DOF2_FileExists(file))
            {
                clan_lvl = DOF2_GetInt(file, "Clan");
                if(clan_lvl == 0) clan_lvl = DOF2_GetInt(file, "Member");
            }

            // Provera lidera u Lideri.ini
            new org_lider = 0;
            new lideri_file[64] = "BalkanRP/Lideri.ini";
            if(DOF2_FileExists(lideri_file))
            {
                for(new i = 1; i <= 20; i++)
                {
                    new key[32];
                    format(key, sizeof(key), "Lider_%d", i);
                    if(DOF2_IsSet(lideri_file, key))
                    {
                        new l_name[MAX_PLAYER_NAME];
                        format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                        if(strcmp(l_name, ime, true) == 0)
                        {
                            org_lider = i;
                            break;
                        }
                    }
                }
            }

            // Ako NIJE clan niti lider Parking Servisa
            if(clan_lvl != 7 && org_lider != 7)
            {
                SendClientMessage(playerid, 0xFF0000FF, "Niste clan Parking Servisa!");
                return 1;
            }

            // Otvaranje kapije za clana pe?ke (bez skidanja para)
            MoveObject(kapija_parking, 1022.08948, -927.09814, 38.39440, 3.0);
            SetTimer("ZatvoriParkingKapiju", 15000, false);

            SendClientMessage(playerid, 0x00FF00FF, "Otvorili ste kapiju Parking Servisa pritiskom na slovo C.");
            return 1;
        }
    }

    // =========================================================================
    // TASTERI F / ENTER (KEY_SECONDARY_ATTACK) ZA ULAZE / IZLAZE
    // =========================================================================
    if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK))
    {
        new pVW = GetPlayerVirtualWorld(playerid);
        new pInt = GetPlayerInterior(playerid);

        // BANKA: obje tacke su u interioru 0 i virtualnom svijetu 0.
        if(!IsPlayerInAnyVehicle(playerid) && pVW == 0 && pInt == 0)
        {
            if(IsPlayerInRangeOfPoint(playerid, 2.5, 1462.90759277, -1022.80725097, 23.83310317))
            {
                SafeTeleportPlayer(playerid, 153.79109191, 1702.71630859, -0.85856175, 0, 0);
                SendClientMessage(playerid, 0x33CCFFFF, "[BANKA]: Usli ste u banku.");
                return 1;
            }
            if(IsPlayerInRangeOfPoint(playerid, 2.5, 153.79109191, 1702.71630859, -0.85856175))
            {
                SafeTeleportPlayer(playerid, 1462.90759277, -1022.80725097, 23.83310317, 0, 0);
                SendClientMessage(playerid, 0x33CCFFFF, "[BANKA]: Izasli ste iz banke.");
                return 1;
            }
        }

        // 1. KUCE - IZLAZ
        for(new h = 0; h < MAX_KUCA; h++)
        {
            if(pVW == h && IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][kExitX], HouseInfo[h][kExitY], HouseInfo[h][kExitZ]))
            {
                SafeTeleportPlayer(playerid, HouseInfo[h][kEntranceX], HouseInfo[h][kEntranceY], HouseInfo[h][kEntranceZ], 0, 0);
                return 1;
            }
        }

        // 2. KUCE - ULAZ
        for(new h = 0; h < MAX_KUCA; h++)
        {
            if(pVW == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][kEntranceX], HouseInfo[h][kEntranceY], HouseInfo[h][kEntranceZ]))
            {
                new ime[MAX_PLAYER_NAME];
                GetPlayerName(playerid, ime, sizeof(ime));

                if(HouseInfo[h][kLocked] == 1 && strcmp(HouseInfo[h][kOwner], ime, true) != 0)
                {
                    SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ova kuca je zakljucana!");
                    GameTextForPlayer(playerid, "~r~ZAKLJUCANA", 2000, 3);
                    return 1;
                }

                SafeTeleportPlayer(playerid, HouseInfo[h][kExitX], HouseInfo[h][kExitY], HouseInfo[h][kExitZ], HouseInfo[h][kInterior], h);
                return 1;
            }
        }

        // 3. MARKETA - IZLAZ
        for(new m = 0; m < MAX_MARKETA; m++)
        {
            if(pVW == (m + 5000) && IsPlayerInRangeOfPoint(playerid, 3.0, MarketInfo[m][mExitX], MarketInfo[m][mExitY], MarketInfo[m][mExitZ]))
            {
                SafeTeleportPlayer(playerid, MarketInfo[m][mEntranceX], MarketInfo[m][mEntranceY], MarketInfo[m][mEntranceZ], 0, 0);
                return 1;
            }
        }

        // 4. MARKETA - ULAZ
        for(new m = 0; m < MAX_MARKETA; m++)
        {
            if(CanBusinessUseEntranceFee(m) && pVW == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, MarketInfo[m][mEntranceX], MarketInfo[m][mEntranceY], MarketInfo[m][mEntranceZ]))
            {
                if(MarketInfo[m][mUlaznaCena] > 0 && !CanManageBusiness(playerid, m))
                {
                    if(GetPlayerMoney(playerid) < MarketInfo[m][mUlaznaCena])
                        return SendClientMessage(playerid, 0xFF0000FF, "[BIZNIS]: Nemate dovoljno novca za ulaz.");
                    if(MarketInfo[m][mBudzet] < 0 || MarketInfo[m][mUlaznaCena] > MAX_MONEY_VALUE - MarketInfo[m][mBudzet])
                        return SendClientMessage(playerid, 0xFF0000FF, "[BIZNIS]: Ulaz trenutno nije dostupan.");
                    new accountFile[128];
                    if(!GetPlayerAccountPath(playerid, accountFile, sizeof(accountFile)))
                        return SendClientMessage(playerid, 0xFF0000FF, "[BIZNIS]: Vas korisnicki racun nije dostupan. Ulaz nije naplacen.");
                    GivePlayerMoney(playerid, -MarketInfo[m][mUlaznaCena]);
                    PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
                    MarketInfo[m][mBudzet] += MarketInfo[m][mUlaznaCena];
                    DOF2_SetInt(accountFile, "Novac", PlayerInfo[playerid][pNovac]);
                    SaveMarket(m);
                    DOF2_SaveFile();
                }
                SafeTeleportPlayer(playerid, MarketInfo[m][mExitX], MarketInfo[m][mExitY], MarketInfo[m][mExitZ], MarketInfo[m][mInterior], m + 5000);
                return 1;
            }
        }

        // 5. ZLATARE - IZLAZ
        for(new z = 0; z < MAX_ZLATA; z++)
        {
            if(pVW == (z + 6000) && IsPlayerInRangeOfPoint(playerid, 3.0, ZlataInfo[z][zExitX], ZlataInfo[z][zExitY], ZlataInfo[z][zExitZ]))
            {
                SafeTeleportPlayer(playerid, ZlataInfo[z][zEntranceX], ZlataInfo[z][zEntranceY], ZlataInfo[z][zEntranceZ], 0, 0);
                return 1;
            }
        }

        // 6. ZLATARE - ULAZ
        for(new z = 0; z < MAX_ZLATA; z++)
        {
            if(pVW == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, ZlataInfo[z][zEntranceX], ZlataInfo[z][zEntranceY], ZlataInfo[z][zEntranceZ]))
            {
                SafeTeleportPlayer(playerid, ZlataInfo[z][zExitX], ZlataInfo[z][zExitY], ZlataInfo[z][zExitZ], ZlataInfo[z][zInterior], z + 6000);
                return 1;
            }
        }

        // 7. GIGATRON - ULAZ I IZLAZ
        if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, 1412.1534, -1700.0010, 13.5395))
        {
            SafeTeleportPlayer(playerid, -540.8716, 2596.0989, 10.9875, 10, 0);
            SendClientMessage(playerid, 0x00BFFFFF, "[Balkan Revolution]: U?li ste u Gigatron!");
            return 1;
        }
        else if(pInt == 10 && IsPlayerInRangeOfPoint(playerid, 3.0, -540.8716, 2596.0989, 10.9875))
        {
            SafeTeleportPlayer(playerid, 1412.1534, -1700.0010, 13.5395, 0, 0);
            SendClientMessage(playerid, 0x00BFFFFF, "[Balkan Revolution]: Izi?li ste iz Gigatrona!");
            return 1;
        }

        // 8. OP?TINA - ULAZ I IZLAZ
        if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, 1481.0885, -1771.9858, 18.7958))
        {
            SafeTeleportPlayer(playerid, 386.52, 173.63, 1008.38, 3, 0, 90.0);
            SendClientMessage(playerid, 0x00FF00FF, "[OP?TINA]: U?li ste u Gradsku Op?tinu.");
            return 1;
        }
        else if(pInt == 3 && IsPlayerInRangeOfPoint(playerid, 3.0, 386.52, 173.63, 1008.38))
        {
            SafeTeleportPlayer(playerid, 1481.0885, -1771.9858, 18.7958, 0, 0, 177.9518);
            SendClientMessage(playerid, 0x00FF00FF, "[OP?TINA]: Iza?li ste iz Gradske Op?tine.");
            return 1;
        }

        // 9. POLICIJSKA STANICA (Beogradska Policija) - ULAZ I IZLAZ
        if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, 1555.1368, -1675.6598, 16.1953))
        {
            SafeTeleportPlayer(playerid, 246.66, 65.80, 1003.64, 6, 0, 0.0);
            SendClientMessage(playerid, 0x33CCFFFF, "[Balkan Revolution]: U?li ste u stanicu policije.");
            return 1;
        }
        else if(pInt == 6 && IsPlayerInRangeOfPoint(playerid, 3.0, 246.66, 65.80, 1003.64))
        {
            SafeTeleportPlayer(playerid, 1555.1368, -1675.6598, 16.1953, 0, 0, 272.5560);
            SendClientMessage(playerid, 0x33CCFFFF, "[Balkan Revolution]: Iza?li ste iz stanice policije.");
            return 1;
        }

        // 10. BOLNICA - ULAZ I IZLAZ
        if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, 1172.4083, -1323.3091, 15.4029))
        {
            SafeTeleportPlayer(playerid, -23.7858, 1500.6514, -3.3132, 0, 0);
            SendClientMessage(playerid, 0x00FF00FF, "[BOLNICA]: U?li ste u bolnicu.");
            new hospitalFile[128];
            if(GetPlayerAccountPath(playerid, hospitalFile, sizeof(hospitalFile)) && DOF2_GetInt(hospitalFile, "BolestanDo") > 0)
            {
                DOF2_SetInt(hospitalFile, "BolestanDo", 0);
                DOF2_SaveFile();
                HealthTickMinutes[playerid] = 0;
                SetPlayerHealth(playerid, 100.0);
                SendClientMessage(playerid, 0x00FF00FF, "[BOLNICA]: Uspjesno ste se izlijecili od gripe.");
            }
            return 1;
        }
        else if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, -23.7858, 1500.6514, -3.3132))
        {
            SafeTeleportPlayer(playerid, 1172.4083, -1323.3091, 15.4029, 0, 0);
            SendClientMessage(playerid, 0xFF0000FF, "[BOLNICA]: Iza?li ste iz bolnice.");
            return 1;
        }
    }
    return 1;
}
CMD:gotohouse(playerid, params[])
{
    new houseid;
    if(sscanf(params, "i", houseid))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/gotohouse [ID Kuce]");
        return 1;
    }

    // Provjera da li kuca postoji preko .ini fajla
    new hfile[128];
    format(hfile, sizeof(hfile), "BalkanRP/Kuce/kuca_%d.ini", houseid);
    if(!DOF2_FileExists(hfile))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ta kuca ne postoji!");
    }

    // Ucitavamo ime igraca i njegov admin level iz njegovog fajla
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file))
    {
        admin_lvl = DOF2_GetInt(file, "Admin");
    }

    // PROVJERA: Da li je RCON admin, ili admin level >= 9, ILI vlasnik ove kuce
    new je_vlasnik = 0;
    if(strcmp(HouseInfo[houseid][kOwner], ime, true) == 0)
    {
        je_vlasnik = 1;
    }

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9 && je_vlasnik == 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlastenje! Ovu komandu mo?e koristiti samo vlasnik kuce ili vi?i admin.");
        return 1;
    }

    // Postavljanje svijeta, interiora i pozicije na ulaz kuce
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, HouseInfo[houseid][kEntranceX], HouseInfo[houseid][kEntranceY], HouseInfo[houseid][kEntranceZ]);

    new string[128];
    format(string, sizeof(string), "Uspje?no ste se teleportovali do kuce ID: %d.", houseid);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
CMD:sellhouse(playerid, params[])
{
    // Pronalazimo kucu u kojoj se igrac trenutno nalazi (ili kod cijeg ulaza stoji)
    new houseid = -1;
    for(new h = 0; h < MAX_KUCA; h++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][kEntranceX], HouseInfo[h][kEntranceY], HouseInfo[h][kEntranceZ]))
        {
            houseid = h;
            break;
        }
    }

    if(houseid == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste blizu nijedne kuce!");
        return 1;
    }

    // Provjera da li igrac posjeduje ovu kucu
    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    if(strcmp(HouseInfo[houseid][kOwner], ime, true) != 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ova kuca nije u va?em vlasni?tvu!");
        return 1;
    }

    // Racunamo pola cijene za povrat novca
    new povrat_novca = HouseInfo[houseid][kCena] / 2;

    // Vracamo novac igracu (prilagodi funkciju za novac ako koristi? drugu, npr. GivePlayerMoney)
    GivePlayerMoney(playerid, povrat_novca);

    // Resetujemo podatke kuce na "Drzava"
    HouseInfo[houseid][kOwned] = 0;
    HouseInfo[houseid][kLocked] = 1;
    format(HouseInfo[houseid][kOwner], MAX_PLAYER_NAME, "Drzava");

    // Snimamo promjene u fajl i a?uriramo checkpoint
    SaveHouse(houseid);
    UpdateHouseCP(houseid);
    new remaininghouse = FindOwnedHouseByName(ime);
    PlayerInfo[playerid][pKuca] = remaininghouse;
    new accountfile[128];
    format(accountfile, sizeof(accountfile), "Korisnici/%s.ini", ime);
    if(DOF2_FileExists(accountfile))
    {
        DOF2_SetInt(accountfile, "Kuca", remaininghouse);
        DOF2_SetInt(accountfile, "Novac", GetPlayerMoney(playerid));
        DOF2_SaveFile();
    }
    new string[128];
    format(string, sizeof(string), "Uspje?no ste prodali kucu dr?avi i dobili nazad $%d (pola cijene).", povrat_novca);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
CMD:lockhouse(playerid, params[])
{
    new houseid = -1;
    for(new h = 0; h < MAX_KUCA; h++)
    {
        // Provjeravamo da li je igrac blizu ulaza ili izlaza iz kuce
        if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][kEntranceX], HouseInfo[h][kEntranceY], HouseInfo[h][kEntranceZ]) ||
           IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][kExitX], HouseInfo[h][kExitY], HouseInfo[h][kExitZ]))
        {
            houseid = h;
            break;
        }
    }

    if(houseid == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste blizu svoje kuce (ni na ulazu ni unutra)!");
        return 1;
    }

    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    if(strcmp(HouseInfo[houseid][kOwner], ime, true) != 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste vlasnik ove kuce!");
        return 1;
    }

    if(HouseInfo[houseid][kLocked] == 1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Kuca je vec zakljucana!");
        return 1;
    }

    HouseInfo[houseid][kLocked] = 1;
    SaveHouse(houseid);

    SendClientMessage(playerid, 0x00BFFFFF, "Uspje?no ste zakljucali kucu.");
    return 1;
}
CMD:unlockhouse(playerid, params[])
{
    new houseid = -1;
    for(new h = 0; h < MAX_KUCA; h++)
    {
        // Provjeravamo da li je igrac blizu ulaza ili izlaza iz kuce
        if(IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][kEntranceX], HouseInfo[h][kEntranceY], HouseInfo[h][kEntranceZ]) ||
           IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][kExitX], HouseInfo[h][kExitY], HouseInfo[h][kExitZ]))
        {
            houseid = h;
            break;
        }
    }

    if(houseid == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste blizu svoje kuce (ni na ulazu ni unutra)!");
        return 1;
    }

    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    if(strcmp(HouseInfo[houseid][kOwner], ime, true) != 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste vlasnik ove kuce!");
        return 1;
    }

    if(HouseInfo[houseid][kLocked] == 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Kuca je vec otkljucana!");
        return 1;
    }

    HouseInfo[houseid][kLocked] = 0;
    SaveHouse(houseid);

    SendClientMessage(playerid, 0x00BFFFFF, "Uspje?no ste otkljucali kucu.");
    return 1;
}
stock GetBusinessTypeName(type, destination[], size)
{
    switch(type)
    {
        case BIZ_TYPE_MARKET: format(destination, size, "Market");
        case BIZ_TYPE_JOB: format(destination, size, "Za poslove");
        case BIZ_TYPE_STRIP_CLUB: format(destination, size, "Strip Club");
        case BIZ_TYPE_RESTAURANT: format(destination, size, "Restaurant");
        case BIZ_TYPE_GAS_STATION: format(destination, size, "Gas Station");
        default: format(destination, size, "Nepoznat");
    }
    return 1;
}

stock bool:IsJobBusiness(businessid)
{
    return businessid >= 0 && businessid < MAX_MARKETA && MarketInfo[businessid][mType] == BIZ_TYPE_JOB;
}

stock bool:CanBusinessUseProducts(businessid)
{
    if(businessid < 0 || businessid >= MAX_MARKETA) return false;
    switch(MarketInfo[businessid][mType])
    {
        case BIZ_TYPE_MARKET, BIZ_TYPE_JOB, BIZ_TYPE_RESTAURANT, BIZ_TYPE_GAS_STATION: return true;
    }
    return false;
}

stock bool:CanBusinessUseEntranceFee(businessid)
{
    if(businessid < 0 || businessid >= MAX_MARKETA) return false;
    // Trenutno samo Market ima stvarni interior i aktivnu ulaz/izlaz logiku.
    // Ostali tipovi se ovdje mogu ukljuciti kada dobiju funkcionalan interior.
    return MarketInfo[businessid][mType] == BIZ_TYPE_MARKET;
}

stock bool:ParseBusinessEntranceFee(const inputtext[], &fee)
{
    new length = strlen(inputtext), value = 0;
    if(length < 1 || length > 5) return false;

    for(new index = 0; index < length; index++)
    {
        if(inputtext[index] < '0' || inputtext[index] > '9') return false;
        new digit = inputtext[index] - '0';
        if(value > (MAX_BUSINESS_ENTRANCE_FEE - digit) / 10) return false;
        value = value * 10 + digit;
    }

    if(value < 0 || value > MAX_BUSINESS_ENTRANCE_FEE) return false;
    fee = value;
    return true;
}

stock bool:IsBusinessOwner(playerid, businessid)
{
    if(!IsPlayerConnected(playerid) || businessid < 0 || businessid >= MAX_MARKETA || !MarketInfo[businessid][mOwned]) return false;
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return !strcmp(MarketInfo[businessid][mOwner], name, true);
}

stock bool:IsBusinessCoOwner(playerid, businessid)
{
    if(!IsPlayerConnected(playerid) || businessid < 0 || businessid >= MAX_MARKETA || !MarketInfo[businessid][mOwned]) return false;
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return strlen(BusinessCoOwner[businessid]) > 0 && strcmp(BusinessCoOwner[businessid], "Nema", true) != 0 &&
        !strcmp(BusinessCoOwner[businessid], name, true);
}

stock bool:CanManageBusiness(playerid, businessid)
{
    return IsBusinessOwner(playerid, businessid) || IsBusinessCoOwner(playerid, businessid);
}

stock bool:CanManageBusinessHere(playerid, businessid)
{
    if(businessid < 0 || businessid >= MAX_MARKETA || !CanManageBusiness(playerid, businessid) ||
       MarketInfo[businessid][mEntranceX] == 0.0) return false;
    return GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0 &&
        IsPlayerInRangeOfPoint(playerid, 5.0, MarketInfo[businessid][mEntranceX],
            MarketInfo[businessid][mEntranceY], MarketInfo[businessid][mEntranceZ]);
}

stock GetManagedBusinessId(playerid)
{
    for(new businessid = 0; businessid < MAX_MARKETA; businessid++)
        if(MarketInfo[businessid][mEntranceX] != 0.0 && CanManageBusiness(playerid, businessid)) return businessid;
    return -1;
}

stock ResetBusinessBankDialogState(playerid)
{
    PendingBizzBankBusiness[playerid] = -1;
    PendingBizzBankStage[playerid] = BIZZ_BANK_STAGE_NONE;
    PendingBizzBankExpiresAt[playerid] = 0;
    return 1;
}

stock bool:IsValidBusinessBankAccess(playerid, businessid)
{
    if(businessid < 0 || businessid >= MAX_MARKETA) return false;
    if(MarketInfo[businessid][mEntranceX] == 0.0 || !MarketInfo[businessid][mOwned]) return false;
    return CanManageBusinessHere(playerid, businessid);
}

stock bool:ParsePositiveBusinessAmount(const inputtext[], &amount)
{
    new length = strlen(inputtext), value = 0;
    if(length < 1 || length > 10) return false;

    for(new index = 0; index < length; index++)
    {
        if(inputtext[index] < '0' || inputtext[index] > '9') return false;
        new digit = inputtext[index] - '0';
        if(value > (MAX_MONEY_VALUE - digit) / 10) return false;
        value = value * 10 + digit;
    }

    if(value <= 0) return false;
    amount = value;
    return true;
}

stock ShowBusinessBankInput(playerid, businessid, bool:withdraw)
{
    new text[160];
    if(withdraw)
    {
        format(text, sizeof(text), "Novac u biznisu: %d\n\nUnesite zeljenu sumu da podignete pare:", MarketInfo[businessid][mBudzet]);
        PendingBizzBankStage[playerid] = BIZZ_BANK_STAGE_WITHDRAW;
        ShowPlayerDialog(playerid, DIALOG_BIZZ_BANK_WITHDRAW_BASE + businessid, DIALOG_STYLE_INPUT,
            "{66CCFF}Bizz Bank - Withdraw", text, "Podigni", "Odustani");
    }
    else
    {
        format(text, sizeof(text), "Novac u biznisu: %d\n\nUnesite zeljenu sumu da ostavite pare u biznisu:", MarketInfo[businessid][mBudzet]);
        PendingBizzBankStage[playerid] = BIZZ_BANK_STAGE_DEPOSIT;
        ShowPlayerDialog(playerid, DIALOG_BIZZ_BANK_DEPOSIT_BASE + businessid, DIALOG_STYLE_INPUT,
            "{66CCFF}Bizz Bank - Deposit", text, "Ostavi", "Odustani");
    }
    PendingBizzBankExpiresAt[playerid] = gettime() + 60;
    return 1;
}

public HandleBusinessBankDialog(playerid, dialogid, response, listitem, inputtext[])
{
    new businessid = -1, requiredStage = BIZZ_BANK_STAGE_NONE;
    if(dialogid >= DIALOG_BIZZ_BANK_MENU_BASE && dialogid < DIALOG_BIZZ_BANK_MENU_BASE + MAX_MARKETA)
    {
        businessid = dialogid - DIALOG_BIZZ_BANK_MENU_BASE;
        requiredStage = BIZZ_BANK_STAGE_MENU;
    }
    else if(dialogid >= DIALOG_BIZZ_BANK_DEPOSIT_BASE && dialogid < DIALOG_BIZZ_BANK_DEPOSIT_BASE + MAX_MARKETA)
    {
        businessid = dialogid - DIALOG_BIZZ_BANK_DEPOSIT_BASE;
        requiredStage = BIZZ_BANK_STAGE_DEPOSIT;
    }
    else if(dialogid >= DIALOG_BIZZ_BANK_WITHDRAW_BASE && dialogid < DIALOG_BIZZ_BANK_WITHDRAW_BASE + MAX_MARKETA)
    {
        businessid = dialogid - DIALOG_BIZZ_BANK_WITHDRAW_BASE;
        requiredStage = BIZZ_BANK_STAGE_WITHDRAW;
    }

    if(businessid < 0 || PendingBizzBankBusiness[playerid] != businessid ||
       PendingBizzBankStage[playerid] != requiredStage || PendingBizzBankExpiresAt[playerid] < gettime())
    {
        ResetBusinessBankDialogState(playerid);
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Ovaj bankovni dialog vise nije vazeci.");
    }
    if(!IsValidBusinessBankAccess(playerid, businessid))
    {
        ResetBusinessBankDialogState(playerid);
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Vise nemate pravo upravljati tim biznisom.");
    }

    if(requiredStage == BIZZ_BANK_STAGE_MENU)
    {
        if(!response)
        {
            ResetBusinessBankDialogState(playerid);
            return 1;
        }
        if(listitem == 0) return ShowBusinessBankInput(playerid, businessid, false);
        if(listitem == 1) return ShowBusinessBankInput(playerid, businessid, true);
        ResetBusinessBankDialogState(playerid);
        return 1;
    }

    // Stanje se ponistava prije transakcije, pa isti odgovor ne moze biti izvrsen dvaput.
    ResetBusinessBankDialogState(playerid);
    if(!response) return 1;

    new amount;
    if(!ParsePositiveBusinessAmount(inputtext, amount))
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Unesite ispravan pozitivan iznos bez overflowa.");

    // Pravo upravljanja i postojanje biznisa ponovo se provjeravaju neposredno prije izmjene novca.
    if(!IsValidBusinessBankAccess(playerid, businessid))
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Transakcija je odbijena jer biznis vise nije dostupan.");

    new playerMoney = GetPlayerMoney(playerid), account[128], message[160];
    if(!GetPlayerAccountPath(playerid, account, sizeof(account)))
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Vas korisnicki racun nije dostupan. Transakcija je otkazana.");
    if(requiredStage == BIZZ_BANK_STAGE_DEPOSIT)
    {
        if(playerMoney < amount)
            return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Nemate dovoljno novca za taj deposit.");
        if(MarketInfo[businessid][mBudzet] < 0 || amount > MAX_MONEY_VALUE - MarketInfo[businessid][mBudzet])
            return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Transakcija bi prekoracila dozvoljeni iznos biznis budzeta.");

        GivePlayerMoney(playerid, -amount);
        MarketInfo[businessid][mBudzet] += amount;
        PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
        DOF2_SetInt(account, "Novac", PlayerInfo[playerid][pNovac]);
        SaveMarket(businessid);
        DOF2_SaveFile();
        format(message, sizeof(message), "[BIZNIS]: Ostavili ste %d RSD. Biznis sada ima %d RSD.", amount, MarketInfo[businessid][mBudzet]);
        return SendClientMessage(playerid, 0x00FF00FF, message);
    }

    if(MarketInfo[businessid][mBudzet] < amount)
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Biznis nema dovoljno novca za taj withdraw.");
    if(playerMoney > 0 && amount > MAX_MONEY_VALUE - playerMoney)
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Transakcija bi prekoracila dozvoljeni iznos novca igraca.");

    MarketInfo[businessid][mBudzet] -= amount;
    GivePlayerMoney(playerid, amount);
    PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
    DOF2_SetInt(account, "Novac", PlayerInfo[playerid][pNovac]);
    SaveMarket(businessid);
    DOF2_SaveFile();
    format(message, sizeof(message), "[BIZNIS]: Podigli ste %d RSD. U biznisu je ostalo %d RSD.", amount, MarketInfo[businessid][mBudzet]);
    return SendClientMessage(playerid, 0x00FF00FF, message);
}

stock SaveServerNpc(npcid)
{
    if(npcid < 0 || npcid >= MAX_SERVER_NPCS || !ServerNpc[npcid][NpcExists]) return 0;
    new file[64]; format(file, sizeof(file), "BalkanRP/NPC_%d.ini", npcid);
    if(!DOF2_FileExists(file)) DOF2_CreateFile(file);
    DOF2_SetInt(file, "Skin", ServerNpc[npcid][NpcSkin]);
    DOF2_SetFloat(file, "X", ServerNpc[npcid][NpcX]);
    DOF2_SetFloat(file, "Y", ServerNpc[npcid][NpcY]);
    DOF2_SetFloat(file, "Z", ServerNpc[npcid][NpcZ]);
    DOF2_SetFloat(file, "Angle", ServerNpc[npcid][NpcAngle]);
    DOF2_SetInt(file, "Interior", ServerNpc[npcid][NpcInterior]);
    DOF2_SetInt(file, "VirtualWorld", ServerNpc[npcid][NpcWorld]);
    DOF2_SaveFile();
    return 1;
}

stock SpawnServerNpc(npcid)
{
    if(npcid < 0 || npcid >= MAX_SERVER_NPCS || !ServerNpc[npcid][NpcExists]) return 0;
    if(IsValidDynamicActor(ServerNpc[npcid][NpcActorId])) DestroyDynamicActor(ServerNpc[npcid][NpcActorId]);
    ServerNpc[npcid][NpcActorId] = CreateDynamicActor(ServerNpc[npcid][NpcSkin], ServerNpc[npcid][NpcX], ServerNpc[npcid][NpcY], ServerNpc[npcid][NpcZ],
        ServerNpc[npcid][NpcAngle], true, 100.0, ServerNpc[npcid][NpcWorld], ServerNpc[npcid][NpcInterior]);
    return IsValidDynamicActor(ServerNpc[npcid][NpcActorId]);
}

stock LoadServerNpcs()
{
    for(new npcid = 0; npcid < MAX_SERVER_NPCS; npcid++)
    {
        ServerNpc[npcid][NpcExists] = false;
        ServerNpc[npcid][NpcActorId] = STREAMER_TAG_ACTOR:INVALID_STREAMER_ID;
        new file[64]; format(file, sizeof(file), "BalkanRP/NPC_%d.ini", npcid);
        if(!DOF2_FileExists(file)) continue;
        ServerNpc[npcid][NpcExists] = true;
        ServerNpc[npcid][NpcSkin] = DOF2_IsSet(file, "Skin") ? DOF2_GetInt(file, "Skin") : 0;
        if(ServerNpc[npcid][NpcSkin] < 0 || ServerNpc[npcid][NpcSkin] > 311 || ServerNpc[npcid][NpcSkin] == 74)
            ServerNpc[npcid][NpcSkin] = 0;
        ServerNpc[npcid][NpcX] = DOF2_GetFloat(file, "X");
        ServerNpc[npcid][NpcY] = DOF2_GetFloat(file, "Y");
        ServerNpc[npcid][NpcZ] = DOF2_GetFloat(file, "Z");
        ServerNpc[npcid][NpcAngle] = DOF2_GetFloat(file, "Angle");
        ServerNpc[npcid][NpcInterior] = DOF2_IsSet(file, "Interior") ? DOF2_GetInt(file, "Interior") : 0;
        ServerNpc[npcid][NpcWorld] = DOF2_IsSet(file, "VirtualWorld") ? DOF2_GetInt(file, "VirtualWorld") : 0;
        if(ServerNpc[npcid][NpcInterior] < 0) ServerNpc[npcid][NpcInterior] = 0;
        if(ServerNpc[npcid][NpcWorld] < 0) ServerNpc[npcid][NpcWorld] = 0;
        SpawnServerNpc(npcid);
    }
    return 1;
}

CMD:kreirajnpc(playerid, params[])
{
    if(!HasSpecialCommandAccess(playerid)) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Komandu moze koristiti samo Vlasnik.");
    new skinid; if(sscanf(params, "i", skinid) || skinid < 0 || skinid > 311 || skinid == 74)
        return SendClientMessage(playerid, -1, "KORISCENJE: /kreirajnpc [SkinID]");
    new npcid = -1;
    for(new index = 0; index < MAX_SERVER_NPCS; index++) if(!ServerNpc[index][NpcExists]) { npcid = index; break; }
    if(npcid == -1) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Dostignut je maksimalan broj NPC-eva.");
    ServerNpc[npcid][NpcExists] = true;
    ServerNpc[npcid][NpcSkin] = skinid;
    GetPlayerPos(playerid, ServerNpc[npcid][NpcX], ServerNpc[npcid][NpcY], ServerNpc[npcid][NpcZ]);
    GetPlayerFacingAngle(playerid, ServerNpc[npcid][NpcAngle]);
    ServerNpc[npcid][NpcInterior] = GetPlayerInterior(playerid);
    ServerNpc[npcid][NpcWorld] = GetPlayerVirtualWorld(playerid);
    SpawnServerNpc(npcid); SaveServerNpc(npcid);
    new message[96]; format(message, sizeof(message), "[NPC]: Kreiran je NPC ID %d sa skinom %d.", npcid, skinid);
    return SendClientMessage(playerid, 0x00FF00FF, message);
}

CMD:editnpc(playerid, params[])
{
    if(!HasSpecialCommandAccess(playerid)) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Komandu moze koristiti samo Vlasnik.");
    new npcid; if(sscanf(params, "i", npcid)) return SendClientMessage(playerid, -1, "KORISCENJE: /editnpc [ID]");
    if(npcid < 0 || npcid >= MAX_SERVER_NPCS || !ServerNpc[npcid][NpcExists]) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Taj NPC ne postoji.");
    GetPlayerPos(playerid, ServerNpc[npcid][NpcX], ServerNpc[npcid][NpcY], ServerNpc[npcid][NpcZ]);
    GetPlayerFacingAngle(playerid, ServerNpc[npcid][NpcAngle]);
    ServerNpc[npcid][NpcInterior] = GetPlayerInterior(playerid);
    ServerNpc[npcid][NpcWorld] = GetPlayerVirtualWorld(playerid);
    SpawnServerNpc(npcid); SaveServerNpc(npcid);
    return SendClientMessage(playerid, 0x00FF00FF, "[NPC]: Pozicija NPC-a je sacuvana.");
}

CMD:obrisinpc(playerid, params[])
{
    if(!HasSpecialCommandAccess(playerid)) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Komandu moze koristiti samo Vlasnik.");
    new npcid; if(sscanf(params, "i", npcid)) return SendClientMessage(playerid, -1, "KORISCENJE: /obrisinpc [ID]");
    if(npcid < 0 || npcid >= MAX_SERVER_NPCS || !ServerNpc[npcid][NpcExists]) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Taj NPC ne postoji.");
    if(IsValidDynamicActor(ServerNpc[npcid][NpcActorId])) DestroyDynamicActor(ServerNpc[npcid][NpcActorId]);
    new file[64]; format(file, sizeof(file), "BalkanRP/NPC_%d.ini", npcid); if(DOF2_FileExists(file)) DOF2_RemoveFile(file);
    ServerNpc[npcid][NpcExists] = false; ServerNpc[npcid][NpcActorId] = STREAMER_TAG_ACTOR:INVALID_STREAMER_ID;
    return SendClientMessage(playerid, 0x00FF00FF, "[NPC]: NPC je obrisan.");
}

CMD:npcinfo(playerid, params[])
{
    if(!HasSpecialCommandAccess(playerid)) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Komandu moze koristiti samo Vlasnik.");
    new npcid; if(sscanf(params, "i", npcid)) return SendClientMessage(playerid, -1, "KORISCENJE: /npcinfo [ID]");
    if(npcid < 0 || npcid >= MAX_SERVER_NPCS || !ServerNpc[npcid][NpcExists]) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Taj NPC ne postoji.");
    new message[192]; format(message, sizeof(message), "[NPC]: ID %d | Skin %d | Pos %.3f, %.3f, %.3f | Angle %.2f | Interior %d | VW %d",
        npcid, ServerNpc[npcid][NpcSkin], ServerNpc[npcid][NpcX], ServerNpc[npcid][NpcY], ServerNpc[npcid][NpcZ], ServerNpc[npcid][NpcAngle], ServerNpc[npcid][NpcInterior], ServerNpc[npcid][NpcWorld]);
    return SendClientMessage(playerid, 0xAFAFAFFF, message);
}

stock bool:HasBusinessProducts(businessid, amount = 1)
{
    return CanBusinessUseProducts(businessid) && amount > 0 && MarketInfo[businessid][mProizvodi] >= amount;
}

stock RemoveBusinessProducts(businessid, amount)
{
    if(!HasBusinessProducts(businessid, amount)) return 0;
    MarketInfo[businessid][mProizvodi] -= amount;
    SaveMarket(businessid);
    UpdateMarketCP(businessid);
    return 1;
}

forward SaveMarket(marketid);
public SaveMarket(marketid)
{
    if(marketid < 0 || marketid >= MAX_MARKETA) return 0;
    new file[128];
    format(file, sizeof(file), "BalkanRP/Marketi/market_%d.ini", marketid);
    if(!DOF2_FileExists(file)) DOF2_CreateFile(file);

    DOF2_SetInt(file, "Owned", MarketInfo[marketid][mOwned]);
    DOF2_SetInt(file, "Type", MarketInfo[marketid][mType]);
    DOF2_SetInt(file, "JobId", MarketInfo[marketid][mJobId]);
    DOF2_SetInt(file, "BusinessDataVersion", BUSINESS_DATA_VERSION);
    // Zadrzani su i nazivi kljuceva iz ranijih faza radi kompatibilnosti sa postojecim INI fajlovima.
    DOF2_SetInt(file, "BusinessType", MarketInfo[marketid][mType]);
    DOF2_SetInt(file, "BusinessJobID", MarketInfo[marketid][mJobId]);
    DOF2_SetString(file, "Owner", MarketInfo[marketid][mOwner]);
    DOF2_SetString(file, "CoOwner", BusinessCoOwner[marketid]);
    DOF2_SetString(file, "Naziv", MarketInfo[marketid][mNaziv]);
    DOF2_SetString(file, "Opis", MarketInfo[marketid][mOpis]);
    DOF2_SetInt(file, "Iznuda", MarketInfo[marketid][mIznuda]);
    DOF2_SetInt(file, "Fakture", MarketInfo[marketid][mFakture]);
    DOF2_SetInt(file, "BizVehicleModel", MarketInfo[marketid][mBizVehicleModel]);
    DOF2_SetInt(file, "BizVehicleColor1", MarketInfo[marketid][mBizVehicleColor1]);
    DOF2_SetInt(file, "BizVehicleColor2", MarketInfo[marketid][mBizVehicleColor2]);
    DOF2_SetFloat(file, "BizVehicleX", MarketInfo[marketid][mBizVehicleX]);
    DOF2_SetFloat(file, "BizVehicleY", MarketInfo[marketid][mBizVehicleY]);
    DOF2_SetFloat(file, "BizVehicleZ", MarketInfo[marketid][mBizVehicleZ]);
    DOF2_SetFloat(file, "BizVehicleA", MarketInfo[marketid][mBizVehicleA]);
    for(new slot = 0; slot < MAX_BUSINESS_VEHICLES; slot++)
    {
        new key[40];
        format(key, sizeof(key), "BusinessVehicleModel%d", slot); DOF2_SetInt(file, key, BusinessVehicleModel[marketid][slot]);
        format(key, sizeof(key), "BusinessVehicleColor1%d", slot); DOF2_SetInt(file, key, BusinessVehicleColor1[marketid][slot]);
        format(key, sizeof(key), "BusinessVehicleColor2%d", slot); DOF2_SetInt(file, key, BusinessVehicleColor2[marketid][slot]);
        format(key, sizeof(key), "BusinessVehicleX%d", slot); DOF2_SetFloat(file, key, BusinessVehicleX[marketid][slot]);
        format(key, sizeof(key), "BusinessVehicleY%d", slot); DOF2_SetFloat(file, key, BusinessVehicleY[marketid][slot]);
        format(key, sizeof(key), "BusinessVehicleZ%d", slot); DOF2_SetFloat(file, key, BusinessVehicleZ[marketid][slot]);
        format(key, sizeof(key), "BusinessVehicleA%d", slot); DOF2_SetFloat(file, key, BusinessVehicleA[marketid][slot]);
        format(key, sizeof(key), "BusinessVehicleRentPrice%d", slot); DOF2_SetInt(file, key, BusinessVehicleRentPrice[marketid][slot]);
        format(key, sizeof(key), "BusinessVehicleRentMinutes%d", slot); DOF2_SetInt(file, key, BusinessVehicleRentMinutes[marketid][slot]);
    }

    DOF2_SetFloat(file, "EntranceX", MarketInfo[marketid][mEntranceX]);
    DOF2_SetFloat(file, "EntranceY", MarketInfo[marketid][mEntranceY]);
    DOF2_SetFloat(file, "EntranceZ", MarketInfo[marketid][mEntranceZ]);

    DOF2_SetFloat(file, "ExitX", MarketInfo[marketid][mExitX]);
    DOF2_SetFloat(file, "ExitY", MarketInfo[marketid][mExitY]);
    DOF2_SetFloat(file, "ExitZ", MarketInfo[marketid][mExitZ]);

    DOF2_SetInt(file, "Interior", MarketInfo[marketid][mInterior]);
    DOF2_SetInt(file, "Cena", MarketInfo[marketid][mCena]);
    DOF2_SetInt(file, "Level", MarketInfo[marketid][mLevel]);
    DOF2_SetInt(file, "UlaznaCena", MarketInfo[marketid][mUlaznaCena]);
    DOF2_SetInt(file, "Budzet", MarketInfo[marketid][mBudzet]);
    DOF2_SetInt(file, "Proizvodi", MarketInfo[marketid][mProizvodi]);
    DOF2_SetInt(file, "CenaProizvoda", MarketInfo[marketid][mCenaProizvoda]);
    for(new bait = 0; bait < MAX_RIBOLOVAC_MAMACA; bait++)
    {
        new key[32];
        format(key, sizeof(key), "BaitPrice%d", bait); DOF2_SetInt(file, key, BusinessBaitPrice[marketid][bait]);
        format(key, sizeof(key), "BaitAmount%d", bait); DOF2_SetInt(file, key, BusinessBaitAmount[marketid][bait]);
        format(key, sizeof(key), "FishingBaitPrice%d", bait); DOF2_SetInt(file, key, BusinessBaitPrice[marketid][bait]);
        format(key, sizeof(key), "FishingBaitAmount%d", bait); DOF2_SetInt(file, key, BusinessBaitAmount[marketid][bait]);
    }
    DOF2_SetInt(file, "BeginnerRodPrice", BusinessRodPrice[marketid][0]);
    DOF2_SetInt(file, "ProfessionalRodPrice", BusinessRodPrice[marketid][1]);
    DOF2_SetInt(file, "FishingRodPrice1", BusinessRodPrice[marketid][0]);
    DOF2_SetInt(file, "FishingRodPrice2", BusinessRodPrice[marketid][1]);

    DOF2_SaveFile();
    return 1;
}

forward UpdateMarketCP(marketid);
public UpdateMarketCP(marketid)
{
    if(marketid < 0 || marketid >= MAX_MARKETA || MarketInfo[marketid][mEntranceX] == 0.0) return 0;
    if(IsValidDynamic3DTextLabel(MarketInfo[marketid][mLabel])) DestroyDynamic3DTextLabel(MarketInfo[marketid][mLabel]);
    if(IsValidDynamicPickup(MarketInfo[marketid][mPickup])) DestroyDynamicPickup(MarketInfo[marketid][mPickup]);

    new string[768], line[160], vlasnik[MAX_PLAYER_NAME], suvlasnik[MAX_PLAYER_NAME], status[32], typeName[32], jobName[32];

    if(MarketInfo[marketid][mOwned] == 1)
    {
        format(vlasnik, sizeof(vlasnik), "%s", MarketInfo[marketid][mOwner]);
        format(status, sizeof(status), "Otvoreno");
    }
    else
    {
        format(vlasnik, sizeof(vlasnik), "Nitko");
        format(status, sizeof(status), "Na Prodaju");
    }
    if(!strlen(BusinessCoOwner[marketid]) || !strcmp(BusinessCoOwner[marketid], "Nitko", true)) format(suvlasnik, sizeof(suvlasnik), "Nema");
    else format(suvlasnik, sizeof(suvlasnik), "%s", BusinessCoOwner[marketid]);
    GetBusinessTypeName(MarketInfo[marketid][mType], typeName, sizeof(typeName));
    format(string, sizeof(string),
        "{FFFF00}%s\n{FFFFFF}%s\n{00C0FF}Tip: {FFFFFF}%s | {00C0FF}Status: {FFFFFF}%s\n{00C0FF}Vlasnik: {FFFFFF}%s\n{00C0FF}Suvlasnik: {FFFFFF}%s",
        MarketInfo[marketid][mNaziv], MarketInfo[marketid][mOpis], typeName, status, vlasnik, suvlasnik);
    if(IsJobBusiness(marketid))
    {
        GetJobName(MarketInfo[marketid][mJobId], jobName, sizeof(jobName));
        format(line, sizeof(line), "\n{00C0FF}Posao: {FFFFFF}%s", jobName);
        strcat(string, line, sizeof(string));
    }
    format(line, sizeof(line), "\n{00C0FF}Biznis ID: {FFFFFF}%d | {00C0FF}Cijena: {FFFFFF}%d EUR | {00C0FF}Level: {FFFFFF}%d",
        marketid, MarketInfo[marketid][mCena], MarketInfo[marketid][mLevel]);
    strcat(string, line, sizeof(string));
    if(CanBusinessUseProducts(marketid))
    {
        format(line, sizeof(line), "\n{00C0FF}Produkti: {FFFFFF}%d/%d", MarketInfo[marketid][mProizvodi], MAX_BUSINESS_PRODUCTS);
        strcat(string, line, sizeof(string));
    }
    if(CanBusinessUseEntranceFee(marketid))
    {
        if(MarketInfo[marketid][mUlaznaCena] > 0)
            format(line, sizeof(line), "\n{00C0FF}Ulaz: {FFFFFF}%d dinara", MarketInfo[marketid][mUlaznaCena]);
        else format(line, sizeof(line), "\n{00C0FF}Ulaz: {FFFFFF}Besplatan");
        strcat(string, line, sizeof(string));
    }
    if(!MarketInfo[marketid][mOwned]) strcat(string, "\n{FFFFFF}Kupovina: {00FFFF}/buybizz", sizeof(string));

    MarketInfo[marketid][mLabel] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, MarketInfo[marketid][mEntranceX], MarketInfo[marketid][mEntranceY], MarketInfo[marketid][mEntranceZ]+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, -1, -1);

    // Dinamicki pikup preko streamera (1239 je znak dolara $)
    MarketInfo[marketid][mPickup] = CreateDynamicPickup(1239, 23, MarketInfo[marketid][mEntranceX], MarketInfo[marketid][mEntranceY], MarketInfo[marketid][mEntranceZ], 0, 0);
    return 1;
}
// --- KREIRANJE BIZNISA (VLASNIK) ---
stock CreateBusinessAtPlayer(playerid, type, jobid, const name[], price, level)
{
    if(type < BIZ_TYPE_MARKET || type > MAX_BUSINESS_TYPE) return -1;
    if(type != BIZ_TYPE_JOB) jobid = JOB_NONE;
    if(type == BIZ_TYPE_JOB)
    {
        for(new check = 0; check < MAX_MARKETA; check++)
            if(MarketInfo[check][mEntranceX] != 0.0 && IsJobBusiness(check) && MarketInfo[check][mJobId] == jobid) return -2;
    }

    new businessid = -1;
    for(new index = 0; index < MAX_MARKETA; index++)
        if(MarketInfo[index][mEntranceX] == 0.0) { businessid = index; break; }
    if(businessid == -1) return -3;

    GetPlayerPos(playerid, MarketInfo[businessid][mEntranceX], MarketInfo[businessid][mEntranceY], MarketInfo[businessid][mEntranceZ]);
    MarketInfo[businessid][mOwned] = 0;
    MarketInfo[businessid][mType] = type;
    MarketInfo[businessid][mJobId] = jobid;
    format(MarketInfo[businessid][mOwner], MAX_PLAYER_NAME, "Nitko");
    format(BusinessCoOwner[businessid], MAX_PLAYER_NAME, "Nema");
    format(MarketInfo[businessid][mNaziv], 32, "%s", name);
    format(MarketInfo[businessid][mOpis], 64, "Nema opisa");
    MarketInfo[businessid][mIznuda] = 0;
    MarketInfo[businessid][mFakture] = MAX_BUSINESS_INVOICES;
    MarketInfo[businessid][mCena] = price;
    MarketInfo[businessid][mLevel] = level;
    MarketInfo[businessid][mUlaznaCena] = 0;
    MarketInfo[businessid][mBudzet] = 0;
    MarketInfo[businessid][mProizvodi] = CanBusinessUseProducts(businessid) ? 100 : 0;
    MarketInfo[businessid][mCenaProizvoda] = 100;
    MarketInfo[businessid][mBizVehicleModel] = 0;
    MarketInfo[businessid][mBizVehicleId] = 0;

    if(type == BIZ_TYPE_MARKET)
    {
        MarketInfo[businessid][mExitX] = 6.08;
        MarketInfo[businessid][mExitY] = -28.89;
        MarketInfo[businessid][mExitZ] = 1003.54;
        MarketInfo[businessid][mInterior] = 10;
    }
    else
    {
        MarketInfo[businessid][mExitX] = 0.0;
        MarketInfo[businessid][mExitY] = 0.0;
        MarketInfo[businessid][mExitZ] = 0.0;
        MarketInfo[businessid][mInterior] = 0;
    }

    for(new bait = 0; bait < MAX_RIBOLOVAC_MAMACA; bait++)
    {
        BusinessBaitPrice[businessid][bait] = RibolovacMamacCijena[bait];
        BusinessBaitAmount[businessid][bait] = 5;
    }
    BusinessRodPrice[businessid][0] = 500;
    BusinessRodPrice[businessid][1] = 15000;
    for(new slot = 0; slot < MAX_BUSINESS_VEHICLES; slot++)
    {
        BusinessVehicleModel[businessid][slot] = 0;
        BusinessVehicleId[businessid][slot] = 0;
        BusinessVehicleRentPrice[businessid][slot] = 5000;
        BusinessVehicleRentMinutes[businessid][slot] = 20;
    }
    SaveMarket(businessid);
    UpdateMarketCP(businessid);
    return businessid;
}

CMD:napravibizz(playerid, params[])
{
    new file[128], adminName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, adminName, sizeof(adminName));
    format(file, sizeof(file), "Korisnici/%s.ini", adminName);
    new adminLevel = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;
    if(!IsPlayerAdmin(playerid) && adminLevel < RANK_VLASNIK)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Komandu moze koristiti samo Vlasnik.");

    new enteredName[32], name[32], type, price, level;
    if(sscanf(params, "s[32]iii", enteredName, type, price, level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/napravibizz [Ime biznisa] [ID Biznisa] [Cena] [Level]");
        SendClientMessage(playerid, 0xAFAFAFFF, "ID Biznisa:");
        for(new businessType = BIZ_TYPE_MARKET; businessType <= MAX_BUSINESS_TYPE; businessType++)
        {
            new typeName[32], line[64];
            GetBusinessTypeName(businessType, typeName, sizeof(typeName));
            format(line, sizeof(line), "%d. %s", businessType, typeName);
            SendClientMessage(playerid, 0xAFAFAFFF, line);
        }
        return 1;
    }
    if(type < BIZ_TYPE_MARKET || type > MAX_BUSINESS_TYPE)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Unesite postojeci ID biznisa sa sive liste.");
    if(price < 1 || level < 1)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Cijena i level moraju biti veci od nule.");

    new begin = 0, finish = strlen(enteredName);
    if(finish >= 2 && enteredName[0] == '[' && enteredName[finish - 1] == ']') { begin = 1; finish--; }
    strmid(name, enteredName, begin, finish, sizeof(name));
    for(new index = 0; index < strlen(name); index++) if(name[index] == '_') name[index] = ' ';
    if(!strlen(name)) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Unesite ispravno ime biznisa.");

    if(type == BIZ_TYPE_JOB)
    {
        PendingBusinessCreateType[playerid] = type;
        PendingBusinessCreatePrice[playerid] = price;
        PendingBusinessCreateLevel[playerid] = level;
        format(PendingBusinessCreateName[playerid], 32, "%s", name);
        ShowPlayerDialog(playerid, DIALOG_CREATE_JOB_BUSINESS, DIALOG_STYLE_LIST,
            "{66CCFF}Izaberite posao", "Cistac ulica\nPostar\nRibolovac", "Izaberi", "Odustani");
        return 1;
    }

    new businessid = CreateBusinessAtPlayer(playerid, type, JOB_NONE, name, price, level);
    if(businessid < 0) return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Nema slobodnog mjesta za novi biznis.");
    new message[160], typeName[32];
    GetBusinessTypeName(type, typeName, sizeof(typeName));
    format(message, sizeof(message), "Kreiran je %s '%s' (ID %d). Cijena: %d EUR | Level: %d.", typeName, name, businessid, price, level);
    SendClientMessage(playerid, 0x00BFFFFF, message);
    return 1;
}

CMD:obrisibizz(playerid, params[])
{
    #pragma unused params
    if(!HasSpecialCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Komandu moze koristiti samo Vlasnik.");

    new businessid = -1;
    for(new id = 0; id < MAX_MARKETA; id++)
    {
        if(MarketInfo[id][mEntranceX] == 0.0) continue;
        if(IsPlayerInRangeOfPoint(playerid, 5.0, MarketInfo[id][mEntranceX], MarketInfo[id][mEntranceY], MarketInfo[id][mEntranceZ]))
        {
            businessid = id;
            break;
        }
    }
    if(businessid == -1)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Niste pored biznisa koji zelite obrisati.");

    new ownerFile[128];
    if(MarketInfo[businessid][mOwned] && strcmp(MarketInfo[businessid][mOwner], "Nitko", true) != 0)
    {
        format(ownerFile, sizeof(ownerFile), "Korisnici/%s.ini", MarketInfo[businessid][mOwner]);
        if(DOF2_FileExists(ownerFile)) DOF2_SetInt(ownerFile, "Bizz", -1);
    }
    for(new targetid = 0; targetid < MAX_PLAYERS; targetid++)
    {
        if(IsPlayerConnected(targetid) && PlayerInfo[targetid][pBizz] == businessid)
            PlayerInfo[targetid][pBizz] = -1;
    }

    if(IsValidDynamic3DTextLabel(MarketInfo[businessid][mLabel])) DestroyDynamic3DTextLabel(MarketInfo[businessid][mLabel]);
    if(IsValidDynamicPickup(MarketInfo[businessid][mPickup])) DestroyDynamicPickup(MarketInfo[businessid][mPickup]);
    DestroyBusinessVehicle(businessid, true);

    new businessFile[64];
    format(businessFile, sizeof(businessFile), "BalkanRP/Marketi/market_%d.ini", businessid);
    if(DOF2_FileExists(businessFile)) DOF2_RemoveFile(businessFile);

    MarketInfo[businessid][mOwned] = 0;
    MarketInfo[businessid][mType] = BIZ_TYPE_NONE;
    MarketInfo[businessid][mJobId] = JOB_NONE;
    MarketInfo[businessid][mEntranceX] = 0.0;
    MarketInfo[businessid][mEntranceY] = 0.0;
    MarketInfo[businessid][mEntranceZ] = 0.0;
    MarketInfo[businessid][mLabel] = Text3D:INVALID_3DTEXT_ID;
    MarketInfo[businessid][mPickup] = 0;
    format(MarketInfo[businessid][mOwner], MAX_PLAYER_NAME, "Nitko");
    format(BusinessCoOwner[businessid], MAX_PLAYER_NAME, "Nema");
    DOF2_SaveFile();

    new message[96];
    format(message, sizeof(message), "[BIZNIS]: Uspjesno ste obrisali biznis ID %d.", businessid);
    return SendClientMessage(playerid, 0x00FF00FF, message);
}
// --- 2. UREDIVANJE MARKETA (ADMIN) ---
CMD:editujmarket(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id, nova_cijena, novi_level;
    if(sscanf(params, "iii", id, nova_cijena, novi_level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/editujmarket [ID Marketa] [Nova Cijena] [Novi Level]");
        return 1;
    }

    new mfile[128];
    format(mfile, sizeof(mfile), "BalkanRP/Marketi/market_%d.ini", id);
    if(!DOF2_FileExists(mfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj market ne postoji!");

    MarketInfo[id][mCena] = nova_cijena;
    MarketInfo[id][mLevel] = novi_level;

    SaveMarket(id);
    UpdateMarketCP(id);

    new string[128];
    format(string, sizeof(string), "Uspje?no si izmijenio market ID: %d | Nova cijena: %d EUR | Novi level: %d", id, nova_cijena, novi_level);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

// --- 3. BRISANJE MARKETA (ADMIN) ---
// --- 3. BRISANJE MARKETA (ADMIN) ---
CMD:obrisimarket(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id;
    if(sscanf(params, "i", id))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/obrisimarket [ID Marketa]");
        return 1;
    }
    if(id < 0 || id >= MAX_MARKETA)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: ID biznisa mora biti izmedju 0 i 49.");

    new mfile[128];
    format(mfile, sizeof(mfile), "BalkanRP/Marketi/market_%d.ini", id);
    if(!DOF2_FileExists(mfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj market ne postoji!");

    new ownerFile[128];
    if(MarketInfo[id][mOwned] && strcmp(MarketInfo[id][mOwner], "Nitko", true) != 0)
    {
        format(ownerFile, sizeof(ownerFile), "Korisnici/%s.ini", MarketInfo[id][mOwner]);
        if(DOF2_FileExists(ownerFile)) DOF2_SetInt(ownerFile, "Bizz", -1);
    }
    for(new targetid = 0; targetid < MAX_PLAYERS; targetid++)
        if(IsPlayerConnected(targetid) && PlayerInfo[targetid][pBizz] == id) PlayerInfo[targetid][pBizz] = -1;

    DestroyBusinessVehicle(id, true);
    DOF2_RemoveFile(mfile);

    if(IsValidDynamic3DTextLabel(MarketInfo[id][mLabel])) DestroyDynamic3DTextLabel(MarketInfo[id][mLabel]);

    // Umjesto DestroyPickup, koristimo ispravnu streamer funkciju za dinamicke pikupove:
    if(IsValidDynamicPickup(MarketInfo[id][mPickup])) DestroyDynamicPickup(MarketInfo[id][mPickup]);

    // Resetovanje u memoriji
    MarketInfo[id][mOwned] = 0;
    MarketInfo[id][mType] = 0;
    MarketInfo[id][mJobId] = 0;
    format(MarketInfo[id][mOwner], MAX_PLAYER_NAME, "Nitko");
    format(BusinessCoOwner[id], MAX_PLAYER_NAME, "Nema");
    MarketInfo[id][mCena] = 0;
    MarketInfo[id][mLevel] = 0;
    MarketInfo[id][mEntranceX] = 0.0;
    MarketInfo[id][mEntranceY] = 0.0;
    MarketInfo[id][mEntranceZ] = 0.0;

    new string[128];
    format(string, sizeof(string), "Uspje?no si obrisao market ID: %d", id);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

stock GetOwnedBusinessId(playerid)
{
    new name[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    if(!DOF2_FileExists(file)) return -1;
    new businessid = DOF2_GetInt(file, "Bizz");
    if(businessid < 0 || businessid >= MAX_MARKETA || MarketInfo[businessid][mEntranceX] == 0.0 ||
       !MarketInfo[businessid][mOwned] || strcmp(MarketInfo[businessid][mOwner], name, true) != 0) return -1;
    PlayerInfo[playerid][pBizz] = businessid;
    return businessid;
}

stock IsAtOwnedBusiness(playerid, businessid)
{
    return CanManageBusinessHere(playerid, businessid);
}

stock bool:IsFishingBusiness(businessid)
{
    return businessid >= 0 && businessid < MAX_MARKETA && MarketInfo[businessid][mType] == BIZ_TYPE_JOB &&
        MarketInfo[businessid][mJobId] == JOB_RIBOLOVAC;
}

stock GetBusinessVehicleCount(businessid)
{
    new count;
    if(businessid < 0 || businessid >= MAX_MARKETA) return 0;
    for(new slot = 0; slot < MAX_BUSINESS_VEHICLES; slot++)
        if(BusinessVehicleModel[businessid][slot] >= 400) count++;
    return count;
}

stock GetFreeBusinessVehicleSlot(businessid)
{
    if(businessid < 0 || businessid >= MAX_MARKETA) return -1;
    for(new slot = 0; slot < MAX_BUSINESS_VEHICLES; slot++)
        if(BusinessVehicleModel[businessid][slot] == 0) return slot;
    return -1;
}

stock GetBusinessVehicleSlotById(vehicleid, &businessid, &slotid)
{
    businessid = -1;
    slotid = -1;
    if(vehicleid <= 0) return 0;
    for(new b = 0; b < MAX_MARKETA; b++)
    {
        for(new s = 0; s < MAX_BUSINESS_VEHICLES; s++)
        {
            if(BusinessVehicleId[b][s] == vehicleid)
            {
                businessid = b;
                slotid = s;
                return 1;
            }
        }
    }
    return 0;
}

stock ResetFishingBoatToSlot(businessid, slotid)
{
    if(!IsFishingBusiness(businessid) || slotid < 0 || slotid >= MAX_BUSINESS_VEHICLES) return 0;
    new vehicleid = BusinessVehicleId[businessid][slotid];
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || GetVehicleModel(vehicleid) == 0) return 0;
    for(new p = 0; p < MAX_PLAYERS; p++)
        if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid)) RemovePlayerFromVehicle(p);
    SetVehiclePos(vehicleid, FishingBoatSlotPos[slotid][0], FishingBoatSlotPos[slotid][1], FishingBoatSlotPos[slotid][2]);
    SetVehicleZAngle(vehicleid, FishingBoatSlotPos[slotid][3]);
    SetVehicleHealth(vehicleid, 1000.0);
    RepairVehicle(vehicleid);
    return 1;
}

stock DestroyBusinessVehicleSlot(businessid, slotid, bool:resetData = true)
{
    if(businessid < 0 || businessid >= MAX_MARKETA || slotid < 0 || slotid >= MAX_BUSINESS_VEHICLES) return 0;
    new vehicleid = BusinessVehicleId[businessid][slotid];
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES && GetVehicleModel(vehicleid) != 0)
    {
        if(RentVehicleOwner[vehicleid])
        {
            new renter = RentVehicleOwner[vehicleid] - 1;
            if(renter >= 0 && renter < MAX_PLAYERS && IsPlayerConnected(renter)) StopPlayerRent(renter, false);
            RentVehicleOwner[vehicleid] = 0;
        }
        DestroyVehicle(vehicleid);
    }
    BusinessVehicleId[businessid][slotid] = 0;
    if(resetData)
    {
        BusinessVehicleModel[businessid][slotid] = 0;
        BusinessVehicleColor1[businessid][slotid] = 0;
        BusinessVehicleColor2[businessid][slotid] = 0;
        BusinessVehicleX[businessid][slotid] = 0.0;
        BusinessVehicleY[businessid][slotid] = 0.0;
        BusinessVehicleZ[businessid][slotid] = 0.0;
        BusinessVehicleA[businessid][slotid] = 0.0;
        BusinessVehicleRentPrice[businessid][slotid] = 0;
        BusinessVehicleRentMinutes[businessid][slotid] = 0;
    }
    return 1;
}

stock DestroyBusinessVehicle(businessid, bool:resetData = true)
{
    if(businessid < 0 || businessid >= MAX_MARKETA) return 0;
    for(new slot = 0; slot < MAX_BUSINESS_VEHICLES; slot++)
        DestroyBusinessVehicleSlot(businessid, slot, resetData);
    MarketInfo[businessid][mBizVehicleId] = 0;
    if(resetData) MarketInfo[businessid][mBizVehicleModel] = 0;
    return 1;
}

stock LoadBusinessVehicleSlot(businessid, slotid)
{
    if(businessid < 0 || businessid >= MAX_MARKETA || slotid < 0 || slotid >= MAX_BUSINESS_VEHICLES ||
       BusinessVehicleModel[businessid][slotid] < 400 || BusinessVehicleModel[businessid][slotid] > 611) return 0;
    DestroyBusinessVehicleSlot(businessid, slotid, false);
    BusinessVehicleId[businessid][slotid] = CreateVehicle(BusinessVehicleModel[businessid][slotid],
        BusinessVehicleX[businessid][slotid], BusinessVehicleY[businessid][slotid], BusinessVehicleZ[businessid][slotid],
        BusinessVehicleA[businessid][slotid], BusinessVehicleColor1[businessid][slotid], BusinessVehicleColor2[businessid][slotid], -1);
    if(BusinessVehicleId[businessid][slotid] == INVALID_VEHICLE_ID ||
       BusinessVehicleId[businessid][slotid] <= 0 || BusinessVehicleId[businessid][slotid] >= MAX_VEHICLES)
    {
        BusinessVehicleId[businessid][slotid] = 0;
        if(slotid == 0) MarketInfo[businessid][mBizVehicleId] = 0;
        return 0;
    }
    if(slotid == 0)
    {
        MarketInfo[businessid][mBizVehicleId] = BusinessVehicleId[businessid][slotid];
        MarketInfo[businessid][mBizVehicleModel] = BusinessVehicleModel[businessid][slotid];
    }
    return BusinessVehicleId[businessid][slotid];
}

stock LoadBusinessVehicle(businessid)
{
    if(businessid < 0 || businessid >= MAX_MARKETA) return 0;
    for(new slot = 0; slot < MAX_BUSINESS_VEHICLES; slot++)
        if(BusinessVehicleModel[businessid][slot] >= 400) LoadBusinessVehicleSlot(businessid, slot);
    return 1;
}

stock AutoSellBusinessForNoInvoices(businessid)
{
    if(businessid < 0 || businessid >= MAX_MARKETA || !MarketInfo[businessid][mOwned]) return 0;
    new oldOwner[MAX_PLAYER_NAME], ownerFile[128];
    format(oldOwner, sizeof(oldOwner), "%s", MarketInfo[businessid][mOwner]);
    format(ownerFile, sizeof(ownerFile), "Korisnici/%s.ini", oldOwner);
    if(DOF2_FileExists(ownerFile)) DOF2_SetInt(ownerFile, "Bizz", -1);
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid)) continue;
        new playerName[MAX_PLAYER_NAME]; GetPlayerName(playerid, playerName, sizeof(playerName));
        if(!strcmp(playerName, oldOwner, true))
        {
            PlayerInfo[playerid][pBizz] = -1;
            SendClientMessage(playerid, 0xFF0000FF, "[BIZNIS]: Biznis je automatski prodan drzavi jer je ostao bez faktura.");
            break;
        }
    }
    MarketInfo[businessid][mOwned] = 0;
    MarketInfo[businessid][mFakture] = 0;
    format(MarketInfo[businessid][mOwner], MAX_PLAYER_NAME, "Nitko");
    format(BusinessCoOwner[businessid], MAX_PLAYER_NAME, "Nema");
    // Budzet, proizvodi i firmna vozila ostaju sacuvani za sljedeceg vlasnika.
    SaveMarket(businessid);
    UpdateMarketCP(businessid);
    DOF2_SaveFile();
    return 1;
}

public BusinessInvoiceTick()
{
    for(new businessid = 0; businessid < MAX_MARKETA; businessid++)
    {
        if(MarketInfo[businessid][mEntranceX] == 0.0 || !MarketInfo[businessid][mOwned]) continue;
        if(MarketInfo[businessid][mFakture] > 0) MarketInfo[businessid][mFakture]--;
        if(MarketInfo[businessid][mFakture] <= 0) AutoSellBusinessForNoInvoices(businessid);
        else
        {
            SaveMarket(businessid);
            UpdateMarketCP(businessid);
        }
    }
    return 1;
}

CMD:bizzhelp(playerid, params[])
{
    #pragma unused params
    return ShowBusinessHelp(playerid);
}

CMD:bizzinfo(playerid, params[])
{
    #pragma unused params
    new id = GetManagedBusinessId(playerid);
    if(id == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ne posjedujete biznis.");
    if(!CanManageBusinessHere(playerid, id)) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Morate biti u blizini svog biznisa.");
    new text[768], vehicleCount = GetBusinessVehicleCount(id), typeName[32], jobName[32], entranceFee[64];
    GetBusinessTypeName(MarketInfo[id][mType], typeName, sizeof(typeName));
    if(IsJobBusiness(id)) GetJobName(MarketInfo[id][mJobId], jobName, sizeof(jobName)); else format(jobName, sizeof(jobName), "Nema");
    if(CanBusinessUseEntranceFee(id))
    {
        if(MarketInfo[id][mUlaznaCena] > 0) format(entranceFee, sizeof(entranceFee), "\n{66CCFF}Cijena ulaza: {FFFFFF}%d RSD", MarketInfo[id][mUlaznaCena]);
        else format(entranceFee, sizeof(entranceFee), "\n{66CCFF}Cijena ulaza: {FFFFFF}Besplatan");
    }
    else entranceFee[0] = EOS;
    format(text, sizeof(text), "{66CCFF}Naziv: {FFFFFF}%s\n{66CCFF}Opis: {FFFFFF}%s\n{66CCFF}Tip: {FFFFFF}%s\n{66CCFF}Posao: {FFFFFF}%s\n{66CCFF}Vlasnik: {FFFFFF}%s\n{66CCFF}Suvlasnik: {FFFFFF}%s\n{66CCFF}Vrijednost: {FFFFFF}%d EUR\n{66CCFF}Budzet: {FFFFFF}%d RSD\n{66CCFF}Fakture: {FFFFFF}%d/%d\n{66CCFF}Produkti: {FFFFFF}%d/%d%s\n{66CCFF}Firmina vozila: {FFFFFF}%d/%d",
        MarketInfo[id][mNaziv], MarketInfo[id][mOpis], typeName, jobName, MarketInfo[id][mOwner], BusinessCoOwner[id], MarketInfo[id][mCena],
        MarketInfo[id][mBudzet], MarketInfo[id][mFakture], MAX_BUSINESS_INVOICES, MarketInfo[id][mProizvodi], MAX_BUSINESS_PRODUCTS,
        entranceFee, vehicleCount, MAX_BUSINESS_VEHICLES);
    ShowPlayerDialog(playerid, DIALOG_BIZZ_INFO, DIALOG_STYLE_MSGBOX, "{66CCFF}Informacije biznisa", text, "Zatvori", "");
    return 1;
}

stock ShowFishingBusinessBoatList(playerid, businessid)
{
    if(businessid < 0 || businessid >= MAX_MARKETA || !CanManageBusinessHere(playerid, businessid) || !IsFishingBusiness(businessid))
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Ribarski biznis vise nije dostupan.");
    new list[640], line[112], count;
    for(new slot = 0; slot < MAX_BUSINESS_VEHICLES; slot++)
    {
        if(BusinessVehicleModel[businessid][slot] != FISHING_BOAT_MODEL) continue;
        new vehicleid = BusinessVehicleId[businessid][slot];
        format(line, sizeof(line), "Brod #%d - Reefer\t%s\n", slot + 1,
            (vehicleid > 0 && vehicleid < MAX_VEHICLES && RentVehicleOwner[vehicleid]) ? ("Iznajmljen") : ("Slobodan"));
        strcat(list, line, sizeof(list));
        count++;
    }
    if(!count) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Nemate trenutno firmino vozilo.");
    ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BOATS, DIALOG_STYLE_TABLIST,
        "{66CCFF}Ribarski biznis - Brodovi", list, "Izaberi", "Nazad");
    return 1;
}

stock GetFishingBoatSlotFromList(businessid, listitem)
{
    if(businessid < 0 || businessid >= MAX_MARKETA || listitem < 0) return -1;
    new index;
    for(new slot = 0; slot < MAX_BUSINESS_VEHICLES; slot++)
    {
        if(BusinessVehicleModel[businessid][slot] != FISHING_BOAT_MODEL) continue;
        if(index == listitem) return slot;
        index++;
    }
    return -1;
}

CMD:priceproducts(playerid, params[])
{
    #pragma unused params
    new id = GetManagedBusinessId(playerid);
    if(id == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ne posjedujete biznis.");
    if(!CanManageBusinessHere(playerid, id)) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Morate biti u blizini svog biznisa.");
    if(!CanBusinessUseProducts(id)) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Ovaj tip biznisa nema proizvode kojima se podesava cijena.");
    PendingPriceBusiness[playerid] = id;
    PendingPriceBoatSlot[playerid] = -1;
    if(IsFishingBusiness(id))
    {
        ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_CATEGORY, DIALOG_STYLE_LIST,
            "{66CCFF}Ribarski biznis - Cijene", "Mamci\nStapovi\nBrodovi", "Izaberi", "Zatvori");
        return 1;
    }
    ShowPlayerDialog(playerid, DIALOG_PRICEPRODUCTS_BOAT_PRICE, DIALOG_STYLE_INPUT,
        "{66CCFF}Cijena produkata", "Unesite novu cijenu produkata (1-100000 RSD):", "Sacuvaj", "Odustani");
    PendingPriceBoatSlot[playerid] = -2;
    return 1;
}
CMD:esterbon(playerid, params[])
{
    new businessid = GetOwnedBusinessId(playerid), targetid, price;
    if(businessid == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Samo vlasnik moze ponuditi suvlasnistvo.");
    if(!CanManageBusinessHere(playerid, businessid)) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Morate biti u blizini svog biznisa.");
    if(strlen(BusinessCoOwner[businessid]) && strcmp(BusinessCoOwner[businessid], "Nema", true) != 0)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Biznis vec ima suvlasnika. Prvo koristite /uklonisuvlasnika.");
    if(sscanf(params, "ui", targetid, price) || price < 0)
        return SendClientMessage(playerid, -1, "KORISCENJE: /esterbon [ID/Ime igraca] [Cijena]");
    if(!IsPlayerConnected(targetid) || targetid == playerid)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Izaberite drugog online igraca.");
    if(GetManagedBusinessId(targetid) != -1)
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Taj igrac vec upravlja biznisom.");
    if(PendingCoOwnerBusiness[targetid] != -1 && PendingCoOwnerExpiresAt[targetid] >= gettime())
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Taj igrac vec ima aktivnu ponudu za suvlasnistvo.");
    PendingCoOwnerBusiness[targetid] = businessid;
    PendingCoOwnerOwner[targetid] = playerid;
    PendingCoOwnerPrice[targetid] = price;
    PendingCoOwnerExpiresAt[targetid] = gettime() + 60;
    new ownerName[MAX_PLAYER_NAME], text[256];
    GetPlayerName(playerid, ownerName, sizeof(ownerName));
    format(text, sizeof(text), "{FFFFFF}%s vam nudi suvlasnistvo biznisa {FFFF00}%s{FFFFFF} za {00FF00}%d RSD.\nPrihvatanjem dobijate pravo upravljanja, ali ne i prodaje biznisa.",
        ownerName, MarketInfo[businessid][mNaziv], price);
    ShowPlayerDialog(targetid, DIALOG_COOWNER_OFFER, DIALOG_STYLE_MSGBOX, "{66CCFF}Ponuda za suvlasnika", text, "Prihvati", "Odbij");
    SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Ponuda za suvlasnika je poslana.");
    return 1;
}

CMD:uklonisuvlasnika(playerid, params[])
{
    #pragma unused params
    new businessid = GetOwnedBusinessId(playerid);
    if(businessid == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Samo vlasnik moze ukloniti suvlasnika.");
    if(!CanManageBusinessHere(playerid, businessid)) return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Morate biti u blizini svog biznisa.");
    if(!strlen(BusinessCoOwner[businessid]) || !strcmp(BusinessCoOwner[businessid], "Nema", true))
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Ovaj biznis nema suvlasnika.");
    format(BusinessCoOwner[businessid], MAX_PLAYER_NAME, "Nema");
    SaveMarket(businessid);
    UpdateMarketCP(businessid);
    SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Suvlasnik je uklonjen.");
    return 1;
}
CMD:bizzname(playerid, params[])
{
    new id=GetManagedBusinessId(playerid); if(id==-1)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Ne upravljate biznisom.");
    if(!CanManageBusinessHere(playerid,id))return SendClientMessage(playerid,0xFF7777FF,"[BIZNIS]: Morate biti u blizini svog biznisa.");
    if(strlen(params)<2 || strlen(params)>63)return SendClientMessage(playerid,-1,"KORISCENJE: /bizzname [Opis biznisa]");
    format(MarketInfo[id][mOpis],64,"%s",params); SaveMarket(id); UpdateMarketCP(id); SendClientMessage(playerid,0x00FF00FF,"[BIZNIS]: Opis biznisa je promijenjen."); return 1;
}
CMD:bizzfee(playerid, params[])
{
    new id = GetManagedBusinessId(playerid), fee;
    if(id < 0 || id >= MAX_MARKETA || MarketInfo[id][mEntranceX] == 0.0 || !MarketInfo[id][mOwned] || !CanManageBusinessHere(playerid, id))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ne upravljate biznisom.");
    if(!CanBusinessUseEntranceFee(id))
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Na ovom tipu biznisa ne mozete postaviti ulaznicu.");
    if(!ParseBusinessEntranceFee(params, fee))
        return SendClientMessage(playerid, -1, "KORISCENJE: /bizzfee [0-10000]");

    MarketInfo[id][mUlaznaCena] = fee;
    SaveMarket(id);
    UpdateMarketCP(id);
    new message[112];
    if(fee == 0) format(message, sizeof(message), "[BIZNIS]: Ulaz u biznis je sada besplatan.");
    else format(message, sizeof(message), "[BIZNIS]: Cijena ulaza je postavljena na %d RSD.", fee);
    return SendClientMessage(playerid, 0x00FF00FF, message);
}
CMD:bizzbank(playerid, params[])
{
    #pragma unused params
    new id = GetManagedBusinessId(playerid);
    if(id == -1 || !IsValidBusinessBankAccess(playerid, id))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ne upravljate biznisom.");

    if(PendingBizzBankStage[playerid] != BIZZ_BANK_STAGE_NONE && PendingBizzBankExpiresAt[playerid] >= gettime())
        return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Bankovni dialog je vec otvoren.");

    PendingBizzBankBusiness[playerid] = id;
    PendingBizzBankStage[playerid] = BIZZ_BANK_STAGE_MENU;
    PendingBizzBankExpiresAt[playerid] = gettime() + 60;
    ShowPlayerDialog(playerid, DIALOG_BIZZ_BANK_MENU_BASE + id, DIALOG_STYLE_LIST,
        "{66CCFF}Bizz Bank", "Deposit\nWithdraw", "Izaberi", "Zatvori");
    return 1;
}
CMD:keepingbizz(playerid, params[])
{
    new id=GetManagedBusinessId(playerid), amount; if(id==-1)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Ne upravljate biznisom.");
    if(!IsAtOwnedBusiness(playerid,id)) return SendClientMessage(playerid,0xFF7777FF,"GRESKA: Morate biti kod svog biznisa.");
    if(sscanf(params,"i",amount)||amount<1)return SendClientMessage(playerid,-1,"KORISCENJE: /keepingbizz [Broj faktura]");
    if(PlayerBusinessInvoices[playerid] < amount)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Nemate toliko faktura kod sebe.");
    new available=MAX_BUSINESS_INVOICES-MarketInfo[id][mFakture];
    if(available<=0)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Biznis vec ima maksimalno 100 faktura.");
    if(amount>available)return SendClientMessage(playerid,0xFF7777FF,"GRESKA: Ta kolicina bi prekoracila maksimalnih 100 faktura u biznisu.");
    new file[128];
    if(!GetPlayerAccountPath(playerid,file,sizeof(file)))return SendClientMessage(playerid,0xFF7777FF,"GRESKA: Korisnicki racun nije dostupan.");
    PlayerBusinessInvoices[playerid]-=amount;
    MarketInfo[id][mFakture]+=amount;
    DOF2_SetInt(file,"BusinessInvoices",PlayerBusinessInvoices[playerid]);
    SaveMarket(id); UpdateMarketCP(id); DOF2_SaveFile();
    new message[128]; format(message,sizeof(message),"[BIZNIS]: Ubacili ste %d faktura. Biznis sada ima %d/100.",amount,MarketInfo[id][mFakture]);
    SendClientMessage(playerid,0x00FF00FF,message); return 1;
}

CMD:kupifakture(playerid, params[])
{
    #pragma unused params
    if(GetPlayerInterior(playerid) != 3 || GetPlayerVirtualWorld(playerid) != 0 ||
       !IsPlayerInRangeOfPoint(playerid, 4.0, 358.78833007, 182.69433593, 1008.38281250))
        return SendClientMessage(playerid, 0xFF7777FF, "[FAKTURE]: Morate biti kod saltera za fakture u opstini.");
    ShowPlayerDialog(playerid, DIALOG_BUY_INVOICES, DIALOG_STYLE_INPUT, "{66CCFF}Kupovina faktura",
        "{FFFFFF}Unesite koliko faktura zelite kupiti (1-10).\nCijena jedne fakture: {FFFF00}100 RSD", "Kupi", "Odustani");
    return 1;
}

CMD:psellto(playerid, params[])
{
    new id=GetOwnedBusinessId(playerid), targetid, price; if(id==-1)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Ne posjedujete biznis.");
    if(!CanManageBusinessHere(playerid,id))return SendClientMessage(playerid,0xFF7777FF,"[BIZNIS]: Morate biti u blizini svog biznisa.");
    if(sscanf(params,"ui",targetid,price)||price<1)return SendClientMessage(playerid,-1,"KORISCENJE: /psellto [ID/Ime] [Cijena]");
    if(!IsPlayerConnected(targetid)||targetid==playerid)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Izaberite drugog online igraca.");
    if(GetOwnedBusinessId(targetid)!=-1)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Taj igrac vec posjeduje biznis.");
    PendingBizzSeller[targetid]=playerid; PendingBizzId[targetid]=id; PendingBizzPrice[targetid]=price;
    new seller[MAX_PLAYER_NAME],text[256]; GetPlayerName(playerid,seller,sizeof(seller));
    format(text,sizeof(text),"{FFFFFF}Igrac {66CCFF}%s {FFFFFF}vam nudi biznis {FFFF00}%s {FFFFFF}za {00FF00}%d EUR.",seller,MarketInfo[id][mNaziv],price);
    ShowPlayerDialog(targetid,DIALOG_BIZZ_SELL_PLAYER,DIALOG_STYLE_MSGBOX,"{66CCFF}Ponuda za biznis",text,"Kupi","Odbij");
    SendClientMessage(playerid,0x00FF00FF,"[BIZNIS]: Ponuda je poslana igracu."); return 1;
}

stock bool:CanBusinessOwnVehicleModel(businessid, modelid)
{
    if(IsFishingBusiness(businessid)) return modelid == FISHING_BOAT_MODEL;
    if(businessid < 0 || businessid >= MAX_MARKETA || modelid < 400 || modelid > 611) return false;
    switch(MarketInfo[businessid][mType])
    {
        case BIZ_TYPE_MARKET: return modelid == 414 || modelid == 440 || modelid == 456 || modelid == 459 || modelid == 482 || modelid == 498 || modelid == 499;
        case BIZ_TYPE_JOB:
        {
            switch(MarketInfo[businessid][mJobId])
            {
                case JOB_CISTAC_ULICA: return modelid == 552 || modelid == 574 || modelid == 583;
                case JOB_POSTAR: return modelid == 413 || modelid == 414 || modelid == 440 || modelid == 482 || modelid == 498 || modelid == 499;
            }
            return false;
        }
        case BIZ_TYPE_STRIP_CLUB: return modelid >= 400 && modelid <= 603 && modelid != 432 && modelid != 433;
        case BIZ_TYPE_RESTAURANT: return modelid == 413 || modelid == 414 || modelid == 448 || modelid == 459 || modelid == 482 || modelid == 498;
        case BIZ_TYPE_GAS_STATION: return modelid == 403 || modelid == 514 || modelid == 515 || modelid == 584;
    }
    return false;
}

CMD:ob(playerid, params[])
{
    new id = GetManagedBusinessId(playerid), action[16];
    if(id == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ne posjedujete biznis.");
    if(!CanManageBusinessHere(playerid,id)) return SendClientMessage(playerid,0xFF7777FF,"[BIZNIS]: Morate biti u blizini svog biznisa.");
    if(sscanf(params, "s[16]", action)) return SendClientMessage(playerid, -1, "KORISCENJE: /ob [buy/sell/park/sellcar]");

    if(!strcmp(action, "buy", true))
    {
        new model, c1, c2, dummy[16];
        if(sscanf(params, "s[16]iii", dummy, model, c1, c2))
            return SendClientMessage(playerid, -1, "KORISCENJE: /ob buy [Model ID] [Boja 1] [Boja 2]");
        if(model < 400 || model > 611)
            return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Model vozila mora biti 400-611.");
        if(!CanBusinessOwnVehicleModel(id, model))
            return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Ribarski biznis trenutno moze kupiti samo brod model ID 453.");
        new slot = GetFreeBusinessVehicleSlot(id);
        if(slot == -1)
            return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Vas biznis vec ima maksimalnih 5 firmnih vozila.");
        if(MarketInfo[id][mBudzet] < FISHING_BOAT_PRICE)
            return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: U budzetu biznisa je potrebno 100000 RSD.");

        MarketInfo[id][mBudzet] -= FISHING_BOAT_PRICE;
        BusinessVehicleModel[id][slot] = model;
        BusinessVehicleRentPrice[id][slot] = 5000;
        BusinessVehicleRentMinutes[id][slot] = 20;
        if(IsFishingBusiness(id))
        {
            BusinessVehicleColor1[id][slot] = 56;
            BusinessVehicleColor2[id][slot] = 56;
            BusinessVehicleX[id][slot] = FishingBoatSlotPos[slot][0];
            BusinessVehicleY[id][slot] = FishingBoatSlotPos[slot][1];
            BusinessVehicleZ[id][slot] = FishingBoatSlotPos[slot][2];
            BusinessVehicleA[id][slot] = FishingBoatSlotPos[slot][3];
        }
        else
        {
            BusinessVehicleColor1[id][slot] = c1;
            BusinessVehicleColor2[id][slot] = c2;
            GetPlayerPos(playerid, BusinessVehicleX[id][slot], BusinessVehicleY[id][slot], BusinessVehicleZ[id][slot]);
            GetPlayerFacingAngle(playerid, BusinessVehicleA[id][slot]);
        }
        LoadBusinessVehicleSlot(id, slot);
        SaveMarket(id);
        new message[128];
        format(message, sizeof(message), "[BIZNIS]: Kupljeno je firmino vozilo #%d za 100000 RSD.", slot + 1);
        SendClientMessage(playerid, 0x00FF00FF, message);
        return 1;
    }

    new vehicleid = GetPlayerVehicleID(playerid), vehicleBusiness = -1, vehicleSlot = -1;
    if(!vehicleid || !GetBusinessVehicleSlotById(vehicleid, vehicleBusiness, vehicleSlot) || vehicleBusiness != id)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Morate voziti firmino vozilo koje zelite urediti.");

    if(!strcmp(action, "park", true))
    {
        if(IsFishingBusiness(id))
            return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Ribarski brodovi imaju fiksne rent slotove i ne mogu se preparkirati.");
        GetVehiclePos(vehicleid, BusinessVehicleX[id][vehicleSlot], BusinessVehicleY[id][vehicleSlot], BusinessVehicleZ[id][vehicleSlot]);
        GetVehicleZAngle(vehicleid, BusinessVehicleA[id][vehicleSlot]);
        SaveMarket(id);
        return SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Firmino vozilo je parkirano.");
    }
    if(!strcmp(action, "sell", true) || !strcmp(action, "sellcar", true))
    {
        new refund = !strcmp(action, "sell", true) ? 50000 : 25000;
        if(MarketInfo[id][mBudzet] < 0) MarketInfo[id][mBudzet] = 0;
        if(MarketInfo[id][mBudzet] > MAX_MONEY_VALUE - refund)
            return SendClientMessage(playerid, 0xFF7777FF, "[BIZNIS]: Budzet biznisa je dostigao maksimalnu vrijednost.");
        MarketInfo[id][mBudzet] += refund;
        DestroyBusinessVehicleSlot(id, vehicleSlot, true);
        SaveMarket(id);
        if(!strcmp(action, "sell", true)) return SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Firmino vozilo je prodano za 50000 RSD.");
        return SendClientMessage(playerid, 0x00FF00FF, "[BIZNIS]: Firmino vozilo je prodano na otpad za 25000 RSD.");
    }
    return SendClientMessage(playerid, -1, "KORISCENJE: /ob [buy/sell/park/sellcar]");
}

CMD:obcolor(playerid, params[])
{
    new id=GetManagedBusinessId(playerid),c1,c2; if(id==-1)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Ne upravljate biznisom.");
    if(!CanManageBusinessHere(playerid,id))return SendClientMessage(playerid,0xFF7777FF,"[BIZNIS]: Morate biti u blizini svog biznisa.");
    if(sscanf(params,"ii",c1,c2))return SendClientMessage(playerid,-1,"KORISCENJE: /obcolor [Boja 1] [Boja 2]");
    if(IsFishingBusiness(id)) return SendClientMessage(playerid,0xFF7777FF,"[BIZNIS]: Ribarski rent brodovi koriste fiksnu boju 56/56.");
    new vehicleid=GetPlayerVehicleID(playerid),businessid=-1,slotid=-1;
    if(!vehicleid||!GetBusinessVehicleSlotById(vehicleid,businessid,slotid)||businessid!=id)return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Morate voziti svoje firmino vozilo.");
    ChangeVehicleColor(vehicleid,c1,c2); BusinessVehicleColor1[id][slotid]=c1; BusinessVehicleColor2[id][slotid]=c2; SaveMarket(id);
    SendClientMessage(playerid,0x00FF00FF,"[BIZNIS]: Boja firminog vozila je promijenjena."); return 1;
}

// --- 4. KUPOVINA MARKETA (IGRAC) ---
CMD:buybizz(playerid, params[])
{
    #pragma unused params
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    if(fexist(file))
    {
        PlayerInfo[playerid][pLevel] = DOF2_GetInt(file, "Level");
        PlayerInfo[playerid][pNovac] = DOF2_GetInt(file, "Novac");
        PlayerInfo[playerid][pBizz] = DOF2_GetInt(file, "Bizz");
    }

    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Biznis morate kupiti kod njegovog ulaza.");
    new marketid = -1;
    for(new m = 0; m < MAX_MARKETA; m++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, MarketInfo[m][mEntranceX], MarketInfo[m][mEntranceY], MarketInfo[m][mEntranceZ]))
        {
            marketid = m;
            break;
        }
    }

    if(marketid == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste blizu nijednog marketa koji mo?ete kupiti!");
        return 1;
    }

    if(MarketInfo[marketid][mOwned] == 1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ovaj market vec ima svog vlasnika!");
        return 1;
    }

    if(GetManagedBusinessId(playerid) != -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Vec posjedujete biznis! Ne mo?ete imati vi?e biznisa.");
        return 1;
    }

    if(PlayerInfo[playerid][pLevel] < MarketInfo[marketid][mLevel])
    {
        new string[128];
        format(string, sizeof(string), "GRESKA: Nemate dovoljan level! (Tvoj level: %d | Potreban: %d)", PlayerInfo[playerid][pLevel], MarketInfo[marketid][mLevel]);
        SendClientMessage(playerid, 0xFF0000FF, string);
        return 1;
    }

    new playerEuro = DOF2_IsSet(file, "Euro") ? DOF2_GetInt(file, "Euro") : 0;
    if(playerEuro < 0) playerEuro = 0;
    if(playerEuro < MarketInfo[marketid][mCena])
    {
        new string[128];
        format(string, sizeof(string), "GRESKA: Nemate dovoljno eura! (Imate: %d EUR | Cijena: %d EUR)", playerEuro, MarketInfo[marketid][mCena]);
        SendClientMessage(playerid, 0xFF0000FF, string);
        return 1;
    }

    playerEuro -= MarketInfo[marketid][mCena];

    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Euro", playerEuro);
        DOF2_SetInt(file, "Bizz", marketid);
        DOF2_SaveFile();
    }

    MarketInfo[marketid][mOwned] = 1;
    GetPlayerName(playerid, MarketInfo[marketid][mOwner], MAX_PLAYER_NAME);
    format(BusinessCoOwner[marketid], MAX_PLAYER_NAME, "Nema");
    PlayerInfo[playerid][pBizz] = marketid;
    MarketInfo[marketid][mFakture] = MAX_BUSINESS_INVOICES;

    SaveMarket(marketid);
    UpdateMarketCP(marketid);
    UpdateRevolutionHudData(playerid);

    new succstring[128];
    format(succstring, sizeof(succstring), "Cestitamo! Uspje?no ste kupili biznis ID: %d za %d EUR. Biznis ima 100 faktura.", marketid, MarketInfo[marketid][mCena]);
    SendClientMessage(playerid, 0x00BFFFFF, succstring);

    return 1;
}

// --- 5. PRODAJA MARKETA DR?AVI (IGRAC) ---
CMD:sellbizz(playerid, params[])
{
    #pragma unused params
    new marketid = GetOwnedBusinessId(playerid);
    if(marketid == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ne posjedujete biznis.");
    if(!IsAtOwnedBusiness(playerid, marketid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Morate biti kod svog biznisa.");
    new refund = MarketInfo[marketid][mCena] / 2, text[256];
    PendingBizzStateSale[playerid] = marketid;
    format(text, sizeof(text), "{FFFFFF}Da li ste sigurni da zelite prodati svoj biznis drzavi za {00FF00}%d EUR?\\n\\n{AAAAAA}To je 50%% cijene po kojoj je biznis kupljen.", refund);
    ShowPlayerDialog(playerid, DIALOG_BIZZ_SELL_STATE, DIALOG_STYLE_MSGBOX, "{FF0000}Prodaja biznisa", text, "Prodaj", "Odustani");
    return 1;
}
CMD:gotomarket(playerid, params[])
{
    // Provjera admin levela ili RCON admina u igracevom .ini fajlu
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9)
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje da koristite ovu komandu!");
    }

    new id;
    if(sscanf(params, "i", id))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/gotomarket [ID Marketa]");
        return 1;
    }

    new mfile[128];
    format(mfile, sizeof(mfile), "BalkanRP/Marketi/market_%d.ini", id);
    if(!DOF2_FileExists(mfile))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj market ne postoji!");
    }

    // Postavljanje igraca vani na ulaz marketa (Virtualni svijet 0, Interior 0)
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, MarketInfo[id][mEntranceX], MarketInfo[id][mEntranceY], MarketInfo[id][mEntranceZ]);

    new string[128];
    format(string, sizeof(string), "Uspje?no si se teleportovao do marketa ID: %d", id);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
CMD:kick(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    new admin_lvl = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;

    // Dozvoljava RCON adminima, vlasniku (Rile) i svim adminima od levela 1 pa nadalje
    if(!IsPlayerAdmin(playerid) && admin_lvl < 1 && strcmp(ime, "Rile", true) != 0)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new targetid, razlog[128];
    if(sscanf(params, "us[128]", targetid, razlog))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /kick [ID/DeoImena] [Razlog]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "Taj igrac trenutno nije na serveru.");
    if(targetid == playerid)
        return SendClientMessage(playerid, 0xFF0000FF, "Ne mozete kikovati sami sebe!");

    new targetName[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetName, sizeof(targetName));
    GetPlayerName(playerid, adminName, sizeof(adminName));

    if(strcmp(targetName, "Rile", true) == 0 && !IsPlayerAdmin(playerid) && strcmp(ime, "Rile", true) != 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Ne mozete kikovati Vlasnika servera!");
        return 1;
    }

    // Javna poruka svima
    new javnaporuka[144];
    format(javnaporuka, sizeof(javnaporuka), "Igrac %s je kikovan od strane AdminTeama. Razlog: %s", targetName, razlog);
    SendClientMessageToAll(0xFA8072FF, javnaporuka);

    // Poruka direktno igracu koji se kikuje
    new igrac_poruka[128];
    format(igrac_poruka, sizeof(igrac_poruka), "Kikovan si od strane AdminTeama. Razlog: %s", razlog);
    SendClientMessage(targetid, 0xFA8072FF, igrac_poruka);

    // Admin log poruka
    new adminporuka[144];
    format(adminporuka, sizeof(adminporuka), "[ADMIN LOG] Admin %s je kikovao igraca %s. Razlog: %s", adminName, targetName, razlog);
    // PosaljiAdminimaIliVlasniku(adminporuka);

    // Pokrece timer koji ce nakon 500ms zaista izbaciti igraca
    AddPlayerSavedStat(targetid, "AdminKazne", 1);
    SetTimerEx("IzvrsiKick", 500, false, "i", targetid);
    return 1;
}
CMD:ban(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    new admin_lvl = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new targetid, razlog[128];
    if(sscanf(params, "us[128]", targetid, razlog)) return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /ban [ID/DeoImena] [Razlog]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF0000FF, "Taj igrac trenutno nije na serveru.");
    if(targetid == playerid) return SendClientMessage(playerid, 0xFF0000FF, "Ne mozete banovati sami sebe!");

    new targetName[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetName, sizeof(targetName));
    GetPlayerName(playerid, adminName, sizeof(adminName));

    if(strcmp(targetName, "Rile", true) == 0 && !IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Ne mozete banovati Vlasnika servera!");
        return 1;
    }

    // Javna poruka za ban (u skladu sa slikom koju si poslao)
    new javnaporuka[144];
    format(javnaporuka, sizeof(javnaporuka), "[BAN] Igrac %s je banovan od strane AdminTeama. Razlog: %s", targetName, razlog);
    SendClientMessageToAll(0xFF0000FF, javnaporuka);

    // Admin log poruka
    new adminporuka[144];
    format(adminporuka, sizeof(adminporuka), "[ADMIN LOG] Admin %s je banovao igraca %s. Razlog: %s", adminName, targetName, razlog);
    // PosaljiAdminimaIliVlasniku(adminporuka);

    // Ovde ide funkcija/komanda za banovanje (npr. Ban(targetid) ili snimanje u fajl)
    AddPlayerSavedStat(targetid, "AdminKazne", 1);
    SetTimerEx("IzvrsiBan", 500, false, "i", targetid);
    return 1;
}
CMD:setlevel(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    new admin_lvl = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new targetid, nivo;
    if(sscanf(params, "ui", targetid, nivo)) return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /setlevel [ID/DeoImena] [Level]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF0000FF, "Taj igrac trenutno nije na serveru.");
    if(nivo < 1 || nivo > 5000) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Level mora biti izmedu 1 i 5000!");

    new targetName[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetName, sizeof(targetName));
    GetPlayerName(playerid, adminName, sizeof(adminName));

    // Postavljanje levela u varijabli
    PlayerInfo[targetid][pLevel] = nivo;

    // Upis u njegov .ini fajl
    new targetfile[128];
    format(targetfile, sizeof(targetfile), "Korisnici/%s.ini", targetName);
    if(DOF2_FileExists(targetfile))
    {
        DOF2_SetInt(targetfile, "Level", nivo);
        DOF2_SaveFile();
    }
    SetPlayerScore(targetid, nivo); // Odmah osvjezi level na TAB listi.

    new msg[128];
    format(msg, sizeof(msg), "Administrator %s vam je postavio level na: %d.", adminName, nivo);
    SendClientMessage(targetid, 0x00BFFFFF, msg);

    format(msg, sizeof(msg), "Uspje?no ste postavili igracu %s level na: %d.", targetName, nivo);
    SendClientMessage(playerid, 0x00BFFFFF, msg);
    return 1;
}
CMD:unbanip(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    new admin_lvl = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new ip[32];
    if(sscanf(params, "s[32]", ip)) return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /unbanip [IP Adresa]");

    new string[128];
    format(string, sizeof(string), "unbanip %s", ip); // <--- OVDE JE DODANO sizeof(string)
    SendRconCommand(string);

    format(string, sizeof(string), "Administrator %s je skinuo IP ban sa adrese: %s", ime, ip);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
stock GetPlayerAdminRankValue(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(IsPlayerAdmin(playerid)) return 10;
    new rankName[MAX_PLAYER_NAME], rankFile[128];
    GetPlayerName(playerid, rankName, sizeof(rankName));
    format(rankFile, sizeof(rankFile), "Korisnici/%s.ini", rankName);
    if(!DOF2_FileExists(rankFile)) return 0;
    return DOF2_GetInt(rankFile, "Admin");
}

stock IsRankProtectedAdminCommand(const command[])
{
    if(!strcmp(command, "/kick", true) || !strcmp(command, "/akick", true) ||
       !strcmp(command, "/ban", true) || !strcmp(command, "/kill", true) ||
       !strcmp(command, "/setskin", true) || !strcmp(command, "/askin", true) ||
       !strcmp(command, "/slap", true) || !strcmp(command, "/rpslap", true) ||
       !strcmp(command, "/gethere", true) || !strcmp(command, "/givegun", true) ||
       !strcmp(command, "/givemoney", true) || !strcmp(command, "/setlevel", true) ||
       !strcmp(command, "/sethealth", true) || !strcmp(command, "/sethp", true) ||
       !strcmp(command, "/setarmour", true) || !strcmp(command, "/setarmor", true) ||
       !strcmp(command, "/freeze", true) || !strcmp(command, "/unfreeze", true) ||
       !strcmp(command, "/auntie", true) || !strcmp(command, "/mute", true) ||
       !strcmp(command, "/unmute", true) || !strcmp(command, "/ajail", true) ||
       !strcmp(command, "/jailed", true) || !strcmp(command, "/name", true) ||
       !strcmp(command, "/specname", true) || !strcmp(command, "/spec", true) ||
       !strcmp(command, "/check", true) || !strcmp(command, "/checkinv", true) ||
       !strcmp(command, "/checklic", true) || !strcmp(command, "/checkdm", true) ||
       !strcmp(command, "/checkw", true) || !strcmp(command, "/setage", true) ||
       !strcmp(command, "/setjob", true) || !strcmp(command, "/awl", true) ||
       !strcmp(command, "/mutegchat", true) || !strcmp(command, "/mutead", true) ||
       !strcmp(command, "/muteaskq", true) || !strcmp(command, "/mutereport", true) ||
       !strcmp(command, "/dajadmin", true) || !strcmp(command, "/dajhelpera", true)) return 1;
    return 0;
}

stock CheckAdminCommandHierarchy(playerid, const cmdtext[])
{
    new actorRank = GetPlayerAdminRankValue(playerid);
    if(actorRank <= 0) return 1;

    new command[32], targetid = INVALID_PLAYER_ID;
    if(sscanf(cmdtext, "s[32]", command)) return 1;

    if(!strcmp(command, "/goto", true))
    {
        new destination;
        if(sscanf(cmdtext, "s[32]uu", command, destination, targetid)) return 1;
    }
    else
    {
        if(!IsRankProtectedAdminCommand(command)) return 1;
        if(sscanf(cmdtext, "s[32]u", command, targetid)) return 1;
    }

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid) || targetid == playerid) return 1;
    new targetRank = GetPlayerAdminRankValue(targetid);
    if(targetRank > actorRank)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ne mozete koristiti admin komande na adminu veceg levela.");
        return 0;
    }
    return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
    if(!CheckPlayerAntiSpam(playerid)) return 0;
    if(!CheckAdminCommandHierarchy(playerid, cmdtext)) return 0;
    new profanityChannel[24];
    if(GetChatCommandName(cmdtext, profanityChannel, sizeof(profanityChannel)))
    {
        new separator = strfind(cmdtext, " ");
        if(separator != -1)
        {
            new chatText[160];
            strmid(chatText, cmdtext, separator + 1, strlen(cmdtext), sizeof(chatText));
            ReportProfanity(playerid, profanityChannel, chatText);
        }
    }
    new ime_be[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime_be, sizeof(ime_be));

    new log_string_be[144];
    format(log_string_be, sizeof(log_string_be), "[BIGEAR CMD] [ID: %d] %s kuca: %s", playerid, ime_be, cmdtext);
    SendBigEarLog(log_string_be);

    // Ovde provjerava da li komanda uop?te postoji u modu
    return 1; // Dozvoljava izvr?avanje
}

// Ova funkcija se poziva automatski kada kuca nepostojecu komandu u ZCMD-u:
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success)
    {
        SendClientMessage(playerid, 0xFF0000FF, "(Greska!) {FFFFFF}Uneli ste nepostojecu komandu, spisak svih komandi mozete videti na /help");
        return 1; // Vraca 1 da sprijeci defaultni SA-MP "Unknown command." tekst
    }
    return 1;
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(fX < -3000.0 || fX > 3000.0 || fY < -3000.0 || fY > 3000.0) return 0;
    MapMarkerX[playerid] = fX;
    MapMarkerY[playerid] = fY;
    MapMarkerZ[playerid] = fZ;
    HasMapMarker[playerid] = true;
    SendClientMessage(playerid, 0x00BFFFFF, "[MARKER]: Oznaka je sacuvana. Koristi /gotomarker za teleport.");
    return 0;
}

forward FinishGotoMarker(playerid, serial);
public FinishGotoMarker(playerid, serial)
{
    if(!IsPlayerConnected(playerid) || serial != MapTeleportSerial[playerid] || !HasMapMarker[playerid]) return 1;

    new Float:searchZ = MapMarkerZ[playerid];
    if(searchZ < 1.0) searchZ = 700.0;
    else searchZ += 50.0;
    SetPlayerPosFindZ(playerid, MapMarkerX[playerid], MapMarkerY[playerid], searchZ);
    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);
    SendClientMessage(playerid, 0x00BFFFFF, "[MARKER]: Teleportovan si na oznacenu lokaciju.");
    return 1;
}

CMD:gotomarker(playerid, params[])
{
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF0000FF, "[MARKER]: Prvo se prijavi na nalog.");
    if(!HasMapMarker[playerid])
        return SendClientMessage(playerid, 0xFF0000FF, "[MARKER]: Otvori mapu i postavi oznaku desnim klikom misa.");

    if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    TogglePlayerControllable(playerid, 0);
    SetPlayerPos(playerid, MapMarkerX[playerid], MapMarkerY[playerid], 300.0);
    MapTeleportSerial[playerid]++;
    SetTimerEx("FinishGotoMarker", 1500, false, "ii", playerid, MapTeleportSerial[playerid]);
    SendClientMessage(playerid, 0x00BFFFFF, "[MARKER]: Ucitavam teren na oznacenoj lokaciji...");
    return 1;
}
// Komanda za portanje na kordinate /gotopos [x] [y] [z]
CMD:gotopos(playerid, params[])
{
    new Float:x, Float:y, Float:z;

    // Provjera ako igrac nije unio koordinate
    if(sscanf(params, "fff", x, y, z))
    {
        return SendClientMessage(playerid, -1, "Koristi: /gotopos [x] [y] [z]");
    }

    // Postavljanje igraca na ?eljene koordinate
    SetPlayerPos(playerid, x, y, z);

    // Poruka igracu da se portao
    new string[128];
    format(string, sizeof(string), "Portao si se na koordinate: X:%.2f, Y:%.2f, Z:%.2f", x, y, z);
    SendClientMessage(playerid, 0x33AA33AA, string);

    return 1;
}
CMD:kupitelefon(playerid, params[])
{
    // Provjera je li igrac blizu lokacije za kupovinu telefona (-537.55, 2589.30)
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -537.5564, 2589.3081, 10.9875))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nisi blizu mjesta za kupovinu telefona!");

    // Slo?it cemo dijalog sa spiskom telefona i cijenama
    new string[512];
    format(string, sizeof(string), "Model telefona\tCijena\n");

    for(new i = 0; i < 5; i++)
    {
        new redak[64];
        format(redak, sizeof(redak), "%s\t$%d\n", TelLista[i][tNaziv], TelLista[i][tCijena]);
        strcat(string, redak, sizeof(string));
    }

    // Prikaz dijaloga igracu (ID dijaloga mo?e? prilagoditi svom modu, npr. DIALOG_TELEFONI)
    ShowPlayerDialog(playerid, 9988, DIALOG_STYLE_TABLIST_HEADERS, "Gigatron - Ponuda Telefona", string, "Kupi", "Odustani");
    return 1;
}
CMD:kupibrojtel(playerid, params[])
{
    // Provjera da li je igrac blizu lokacije (-526.6230, 2595.7686, 10.9875) u krugu od 3 metra
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -526.6230, 2595.7686, 10.9875))
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Niste na mjestu za kupovinu broja telefona!");
        return 1;
    }

    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(!DOF2_FileExists(file)) return 1;

    // Provjera da li igrac vec ima kupljen broj telefona
    if(DOF2_IsSet(file, "BrojTelefona"))
    {
        new vec_ima[128];
        format(vec_ima, sizeof(vec_ima), "[Balkan Revolution]: Vec posjedujete broj telefona: {00BFFF}[%d]", DOF2_GetInt(file, "BrojTelefona"));
        SendClientMessage(playerid, 0xFF0000FF, vec_ima);
        return 1;
    }

    // Generisanje random 6-cifrenog broja (od 100000 do 999999)
    new random_broj = 100000 + random(900000);

    // Snimanje u .ini fajl
    DOF2_SetInt(file, "BrojTelefona", random_broj);
    DOF2_SaveFile();

    // Poruka uspjeha igracu
    new poruka[128];
    format(poruka, sizeof(poruka), "[Balkan Revolution]: Uspje?no ste kupili broj telefona! Va? novi broj je: {00BFFF}[%d]", random_broj);
    SendClientMessage(playerid, 0x00BFFFFF, poruka);

    return 1;
}
CMD:kupislusalice(playerid, params[])
{
    // Provjera da li je igrac na tvojoj lokaciji (-530.8458, 2603.3523, 10.9875) u krugu od 3 metra
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -530.8458, 2603.3523, 10.9875))
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Niste na mjestu za kupovinu slu?alica!");
        return 1;
    }

    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(!DOF2_FileExists(file)) return 1;

    // Provjera da li igrac vec ima slu?alice
    if(DOF2_IsSet(file, "Slusalice") && DOF2_GetInt(file, "Slusalice") == 1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Vec posjedujete slu?alice!");
        return 1;
    }

    // Upisivanje u bazu da posjeduje slu?alice
    DOF2_SetInt(file, "Slusalice", 1);
    DOF2_SaveFile();

    SendClientMessage(playerid, 0x00BFFFFF, "[Balkan Revolution]: Uspje?no ste kupili slu?alice! Sada mo?ete koristiti komandu {FFFFFF}/mp3.");
    return 1;
}
CMD:lideri(playerid, params[])
{
    #pragma unused params

    new string[4096], query[128], imeLidera[MAX_PLAYER_NAME];
    new orgs[19][32] = {
        "Beogradska Policija", "Vojska", "Zandarmerija", "Taxi", "Hitna Pomoc", "Novinari", "Parking Servis",
        "Hitman", "LCN", "GHS", "Yamaguchi", "Ruska Mafija", "Groove Street Family", "Ballas Family", "MS-13",
        "Los Surenos", "Privatna Organizacija 1", "Privatna Organizacija 2", "Bajkeri"
    };

    string[0] = EOS;

    new lideri_file[64] = "BalkanRP/Lideri.ini";

    // Ako fajl ne postoji, kreiramo ga automatski da nema gresaka
    if(!DOF2_FileExists(lideri_file))
    {
        DOF2_CreateFile(lideri_file);
        for(new i = 0; i < 19; i++)
        {
            format(query, sizeof(query), "Lider_%d", i + 1);
            DOF2_SetString(lideri_file, query, "Nema");
        }
        DOF2_SaveFile();
    }

    // --- 1. ONLINE LIDERI SEKCIJA ---
    strcat(string, "LISTA ONLINE LIDERA\n\n");
    new online_lideri_count = 0;

    for(new i = 0; i < 19; i++)
    {
        new key[32];
        format(key, sizeof(key), "Lider_%d", i + 1);

        if(DOF2_IsSet(lideri_file, key))
        {
            format(imeLidera, sizeof(imeLidera), "%s", DOF2_GetString(lideri_file, key));

            // Ako je upisan stvarni lider (a ne "Nema")
            if(strcmp(imeLidera, "Nema", true) != 0 && strlen(imeLidera) > 0)
            {
                // Provjeravamo da li je taj lider trenutno online
                for(new p = 0; p < MAX_PLAYERS; p++)
                {
                    if(IsPlayerConnected(p))
                    {
                        new pName[MAX_PLAYER_NAME];
                        GetPlayerName(p, pName, sizeof(pName));

                        if(strcmp(pName, imeLidera, true) == 0)
                        {
                            format(query, sizeof(query), "%s | %s [ID:%d]\n", orgs[i], imeLidera, p);
                            strcat(string, query);
                            online_lideri_count++;
                            break;
                        }
                    }
                }
            }
        }
    }

    if(online_lideri_count == 0)
    {
        strcat(string, "Nema online lidera.\n");
    }

    // --- 2. KOMPLETAN SPISAK ORGANIZACIJA ---
    strcat(string, "\nLISTA SVIH LIDERA\n\n");

    for(new i = 0; i < 19; i++)
    {
        new key[32];
        format(key, sizeof(key), "Lider_%d", i + 1);

        // Uzimamo ime lidera iz DOF2 fajla
        if(DOF2_IsSet(lideri_file, key))
        {
            format(imeLidera, sizeof(imeLidera), "%s", DOF2_GetString(lideri_file, key));
        }
        else
        {
            format(imeLidera, sizeof(imeLidera), "Nema");
        }

        if(strcmp(imeLidera, "Nema", true) != 0 && strlen(imeLidera) > 0)
        {
            format(query, sizeof(query), "[ID:%d] %s | Lider: %s\n", i + 1, orgs[i], imeLidera);
            strcat(string, query);
        }
        else
        {
            format(query, sizeof(query), "[ID:%d] %s | Lider: Nema\n", i + 1, orgs[i], imeLidera);
            strcat(string, query);
        }
    }

    ShowPlayerDialog(playerid, 9876, DIALOG_STYLE_MSGBOX, "Lista lidera", string, "U redu", "");
    return 1;
}
CMD:inventory(playerid, params[])
{
    #pragma unused params

    new string[350];
    format(string, sizeof(string),
        "--- VAS INVENTORY (NAMIRNICE) ---\n\n\
        ? Meso: %d kom\n\
        ? Mleko: %d kom\n\
        ? Hleb: %d kom\n\
        ? Jabuke: %d kom\n\
        ? Banana: %d kom\n\
        ? Sok: %d kom",
        PlayerInfo[playerid][pMeso],
        PlayerInfo[playerid][pMleko],
        PlayerInfo[playerid][pHleb],
        PlayerInfo[playerid][pJabuke],
        PlayerInfo[playerid][pBanana],
        PlayerInfo[playerid][pSok]
    );

    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_MSGBOX, "Balkan Revolution RP - Inventory", string, "U redu", "");
    return 1;
}
CMD:buyinventory(playerid, params[])
{
    #pragma unused params

    // Provjera enterijera 10 (umjesto 17) i tacne lokacije sa radijusom 4.0
    if(GetPlayerInterior(playerid) != 10 || !IsPlayerInRangeOfPoint(playerid, 4.0, 7.0822, -22.7557, 1003.5494))
        return SendClientMessage(playerid, 0xFF0000FF, "[Gre?ka] {FFFFFF}Niste na kasi za inventar/namirnice!");

    new dialogstring[300];
    format(dialogstring, sizeof(dialogstring), "Proizvod\tCijena\nMeso\t350 RSD\nMleko\t120 RSD\nHleb\t80 RSD\nJabuke\t50 RSD\nBanana\t60 RSD\nSok\t90 RSD");
    ShowPlayerDialog(playerid, DIALOG_MARKET_HRANA, DIALOG_STYLE_TABLIST_HEADERS, "24/7 - Namirnice", dialogstring, "Kupi", "Izadi");
    return 1;
}

CMD:kupi(playerid, params[])
{
    #pragma unused params

    // Da vidimo ?ta ti tacno server ocita u igri:
    new string[128];
    format(string, sizeof(string), "DEBUG -> Tvoj Interior: %d | Udaljenost: %f", GetPlayerInterior(playerid), GetPlayerDistanceFromPoint(playerid, 2.4111, -28.4906, 1003.5494));
    SendClientMessage(playerid, -1, string);

    // Privremeno micemo provjeru enterijera da vidimo hoce li otvoriti dialog ako si blizu 10 metara
    if(!IsPlayerInRangeOfPoint(playerid, 10.0, 2.4111, -28.4906, 1003.5494))
        return SendClientMessage(playerid, 0xFF0000FF, "[Gre?ka] {FFFFFF}Predaleko ste od mjesta za kupovinu!");

    new dialogstring[600];
    format(dialogstring, sizeof(dialogstring), "Proizvod\tCena\n\
        Imenik\t1000 RSD\n\
        SIM Kartica\t500 RSD\n\
        Kockica\t1000 RSD\n\
        Kondom\t100 RSD\n\
        Foto aparat\t1000 RSD\n\
        Sat\t10000 RSD\n\
        Oprema za pecanje\t10000 RSD\n\
        Konopac\t1000 RSD\n\
        Sprej\t300 RSD\n\
        Upaljac\t100 RSD\n\
        Cigarete\t500 RSD");

    ShowPlayerDialog(playerid, DIALOG_MARKET_SIM, DIALOG_STYLE_TABLIST_HEADERS, "24/7 prodavnica", dialogstring, "Kupi", "Izadi");
    return 1;
}
CMD:sms(playerid, params[])
{
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    new targetid, messageText[100];
    if(sscanf(params, "us[100]", targetid, messageText))
        return SendClientMessage(playerid, -1, "Koristenje: /sms [ID/Ime] [Poruka]");
    if(!IsPlayerConnected(targetid) || targetid == playerid)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Izaberite drugog online igraca.");
    new senderFile[128], targetFile[128];
    if(!GetPlayerAccountPath(playerid, senderFile, sizeof(senderFile)) || !GetPlayerAccountPath(targetid, targetFile, sizeof(targetFile)))
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Korisnicki nalog nije pronaden.");
    if(!DOF2_IsSet(senderFile, "Telefon") || DOF2_GetInt(senderFile, "BrojTelefona") <= 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Morate kupiti telefon i broj telefona.");
    if(!DOF2_IsSet(targetFile, "Telefon") || DOF2_GetInt(targetFile, "BrojTelefona") <= 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Taj igrac nema telefon ili broj.");
    if(PhoneSpecDisabled[targetid])
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Telefon tog igraca je trenutno iskljucen.");
    if(IgracKrediti[playerid] < 1)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Nemate telefonskog kredita. Kupite ga na trafici.");

    IgracKrediti[playerid]--;
    DOF2_SetInt(senderFile, "Krediti", IgracKrediti[playerid]);
    DOF2_SaveFile();

    new senderName[MAX_PLAYER_NAME], senderMessage[144], targetMessage[144];
    GetPlayerName(playerid, senderName, sizeof(senderName));
    format(senderMessage, sizeof(senderMessage), "[SMS za %d]: %s", DOF2_GetInt(targetFile, "BrojTelefona"), messageText);
    SendClientMessage(playerid, 0x66CCFFFF, senderMessage);
    format(targetMessage, sizeof(targetMessage), "[SMS od %s | %d]: %s", senderName, DOF2_GetInt(senderFile, "BrojTelefona"), messageText);
    SendClientMessage(targetid, 0x66CCFFFF, targetMessage);
    return 1;
}
CMD:smsad(playerid, params[])
{
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    new smsadFile[128];
    if(!GetPlayerAccountPath(playerid, smsadFile, sizeof(smsadFile)) ||
       !DOF2_IsSet(smsadFile, "Telefon") || DOF2_GetInt(smsadFile, "BrojTelefona") <= 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMSAD]: Morate kupiti telefon i broj telefona.");
    if(JuniorAdMutedUntil[playerid] > gettime())
        return SendClientMessage(playerid, 0xFF7777FF, "[SMSAD]: Oduzeto vam je pravo pisanja oglasa.");
    // 1. Globalni cooldown - provjera da li je pro?la 1 minuta od posljednjeg oglasa
    if(gettime() - LastOglasTick < 60)
    {
        new preostalo = 60 - (gettime() - LastOglasTick);
        new string_cd[128];
        format(string_cd, sizeof(string_cd), "{FF0000}[Gre?ka] {FFFFFF}Oglas mo?ete dati ponovo za %d sekundi.", preostalo);
        return SendClientMessage(playerid, -1, string_cd);
    }

    // 2. Provjera levela (preko Score-a)
    if(GetPlayerScore(playerid) < 3)
        return SendClientMessage(playerid, -1, "{FF0000}[Gre?ka] {FFFFFF}Morate biti level 3 ili vi?e da biste dali oglas!");

    // 3. Provjera unosa (sscanf)
    new tekst[128];
    if(sscanf(params, "s[128]", tekst))
        return SendClientMessage(playerid, -1, "{BFC0C2}Koristite: {FFFFFF}/smsad [Tekst oglasa]");

    // Provjera da oglas nije prekratak
    if(strlen(tekst) < 3)
        return SendClientMessage(playerid, -1, "{FF0000}[Gre?ka] {FFFFFF}Tekst oglasa je prekratak.");

    // 4. Racunamo koliko oglas ima karaktera
    if(IgracKrediti[playerid] < 1)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMSAD]: Nemate telefonskog kredita. Kupite ga na trafici.");

    new brojKaraktera = strlen(tekst);

    // 5. Provjera novca
    if(GetPlayerMoney(playerid) < brojKaraktera)
    {
        new string_err[128];
        format(string_err, sizeof(string_err), "{FF0000}[Gre?ka] {FFFFFF}Nemate dovoljno novca! Oglas ko?ta $%d.", brojKaraktera);
        return SendClientMessage(playerid, -1, string_err);
    }

    // 6. Bilje?imo vrijeme
    LastOglasTick = gettime();

    // 7. Oduzimamo novac igracu i cuvamo preko DOF2
    GivePlayerMoney(playerid, -brojKaraktera);
    IgracKrediti[playerid]--;

    new file[64], pname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), "Korisnici/%s.ini", pname);

    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
        DOF2_SetInt(file, "Krediti", IgracKrediti[playerid]);
        DOF2_SaveFile();
    }

    // --- DODAVANJE 70% U BUD?ET BIZNISA MALI OGLASI (ID 0) ---
    new zarada_biznisa = (brojKaraktera * 70) / 100; // Racunamo 70% od cijene oglasa
    OglasiInfo[0][oBudzet] += zarada_biznisa;       // Dodajemo u bud?et biznisa ID 0
    SaveOglase(0);                                  // Snimamo promjene u fajl biznisa
    UpdateOglaseCP(0);                              // A?uriramo 3D label na vratima biznisa
    // --------------------------------------------------------

    // Provjera broja telefona: Ako nema upisan broj, dajemo mu defaultni da ne prekida komandu
    new brTelefona = PlayerInfo[playerid][pBrojTelefona];
    if(brTelefona <= 0) brTelefona = 555111;

    // 8. Slanje oglasa svima
    new string[256];
    format(string, sizeof(string), "{00AA00}[OGLAS] {0085FF}%s{FFFFFF}. {00AA00}Telefon: {0085FF}/call %d {0085FF}(/smsad)", tekst, brTelefona);
    SendClientMessageToAll(-1, string);

    // 9. Obavje?tenje igracu
    new string_info[128];
    format(string_info, sizeof(string_info), "{FF0000}[Telefon] {FFFFFF}Oduzeto vam je %d RSD i 1 kredit za slanje oglasa.", brojKaraktera);
    SendClientMessage(playerid, -1, string_info);

    return 1;
}
// --- 1. KREIRANJE MALI OGLASI (ADMIN) ---
CMD:napravioglase(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new cena, level;
    if(sscanf(params, "ii", cena, level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/napravioglase [Cijena] [Level]");
        return 1;
    }

    new oglasid = -1;
    for(new o = 0; o < MAX_OGLASA; o++)
    {
        new ofile[64];
        format(ofile, sizeof(ofile), "BalkanRP/Oglasi/oglas_%d.ini", o);
        if(!DOF2_FileExists(ofile))
        {
            oglasid = o;
            break;
        }
    }

    if(oglasid == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Dostignut je maksimalan broj biznisa Mali Oglasi!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    OglasiInfo[oglasid][oOwned] = 0;
    format(OglasiInfo[oglasid][oOwner], MAX_PLAYER_NAME, "Nitko");
    format(OglasiInfo[oglasid][oNaziv], 32, "Mali Oglasi");

    OglasiInfo[oglasid][oEntranceX] = x;
    OglasiInfo[oglasid][oEntranceY] = y;
    OglasiInfo[oglasid][oEntranceZ] = z;

    OglasiInfo[oglasid][oExitX] = 6.08;
    OglasiInfo[oglasid][oExitY] = -28.89;
    OglasiInfo[oglasid][oExitZ] = 1003.54;
    OglasiInfo[oglasid][oInterior] = 10;

    OglasiInfo[oglasid][oCena] = cena;
    OglasiInfo[oglasid][oLevel] = level;
    OglasiInfo[oglasid][oUlaznaCena] = 50;
    OglasiInfo[oglasid][oBudzet] = 0;
    OglasiInfo[oglasid][oProizvodi] = 100;
    OglasiInfo[oglasid][oCenaProizvoda] = 100;

    SaveOglase(oglasid);
    UpdateOglaseCP(oglasid);

    new string[128];
    format(string, sizeof(string), "Uspje?no si kreirao biznis Mali Oglasi ID: %d", oglasid);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

// --- 2. UREDIVANJE MALI OGLASI (ADMIN) ---
CMD:editujoglase(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id, nova_cijena, novi_level;
    if(sscanf(params, "iii", id, nova_cijena, novi_level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/editujoglase [ID Oglasa] [Nova Cijena] [Novi Level]");
        return 1;
    }

    new ofile[128];
    format(ofile, sizeof(ofile), "BalkanRP/Oglasi/oglas_%d.ini", id);
    if(!DOF2_FileExists(ofile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj biznis oglasa ne postoji!");

    OglasiInfo[id][oCena] = nova_cijena;
    OglasiInfo[id][oLevel] = novi_level;

    SaveOglase(id);
    UpdateOglaseCP(id);

    new string[128];
    format(string, sizeof(string), "Uspje?no si izmijenio biznis oglasa ID: %d | Nova cijena: $%d | Novi level: %d", id, nova_cijena, novi_level);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

// --- 3. BRISANJE MALI OGLASI (ADMIN) ---
CMD:obrisioglase(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id;
    if(sscanf(params, "i", id))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/obrisioglase [ID Oglasa]");
        return 1;
    }

    new ofile[128];
    format(ofile, sizeof(ofile), "BalkanRP/Oglasi/oglas_%d.ini", id);
    if(!DOF2_FileExists(ofile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj biznis oglasa ne postoji!");

    DOF2_RemoveFile(ofile);

    if(IsValidDynamic3DTextLabel(OglasiInfo[id][oLabel])) DestroyDynamic3DTextLabel(OglasiInfo[id][oLabel]);
    if(IsValidDynamicPickup(OglasiInfo[id][oPickup])) DestroyDynamicPickup(OglasiInfo[id][oPickup]);

    OglasiInfo[id][oOwned] = 0;
    format(OglasiInfo[id][oOwner], MAX_PLAYER_NAME, "Nitko");
    OglasiInfo[id][oCena] = 0;
    OglasiInfo[id][oLevel] = 0;

    new string[128];
    format(string, sizeof(string), "Uspje?no si obrisao biznis oglasa ID: %d", id);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
stock SaveOglase(id)
{
    new file[64];
    format(file, sizeof(file), "BalkanRP/Oglasi/oglas_%d.ini", id);
    if(!DOF2_FileExists(file)) DOF2_CreateFile(file);

    DOF2_SetInt(file, "Owned", OglasiInfo[id][oOwned]);
    DOF2_SetString(file, "Owner", OglasiInfo[id][oOwner]);
    DOF2_SetString(file, "Naziv", OglasiInfo[id][oNaziv]);
    DOF2_SetFloat(file, "EntranceX", OglasiInfo[id][oEntranceX]);
    DOF2_SetFloat(file, "EntranceY", OglasiInfo[id][oEntranceY]);
    DOF2_SetFloat(file, "EntranceZ", OglasiInfo[id][oEntranceZ]);
    DOF2_SetFloat(file, "ExitX", OglasiInfo[id][oExitX]);
    DOF2_SetFloat(file, "ExitY", OglasiInfo[id][oExitY]);
    DOF2_SetFloat(file, "ExitZ", OglasiInfo[id][oExitZ]);
    DOF2_SetInt(file, "Interior", OglasiInfo[id][oInterior]);
    DOF2_SetInt(file, "Cena", OglasiInfo[id][oCena]);
    DOF2_SetInt(file, "Level", OglasiInfo[id][oLevel]);
    DOF2_SetInt(file, "UlaznaCena", OglasiInfo[id][oUlaznaCena]);
    DOF2_SetInt(file, "Budzet", OglasiInfo[id][oBudzet]);
    DOF2_SetInt(file, "Proizvodi", OglasiInfo[id][oProizvodi]);
    DOF2_SetInt(file, "CenaProizvoda", OglasiInfo[id][oCenaProizvoda]);
    DOF2_SaveFile();
    return 1;
}
stock UpdateOglaseCP(id)
{
    if(IsValidDynamic3DTextLabel(OglasiInfo[id][oLabel])) DestroyDynamic3DTextLabel(OglasiInfo[id][oLabel]);
    if(IsValidDynamicPickup(OglasiInfo[id][oPickup])) DestroyDynamicPickup(OglasiInfo[id][oPickup]);

    new string[512], vlasnik[MAX_PLAYER_NAME], opis[32];

    if(OglasiInfo[id][oOwned] == 0)
    {
        format(vlasnik, sizeof(vlasnik), "Nitko");
        format(opis, sizeof(opis), "Na Prodaju");
    }
    else
    {
        format(vlasnik, sizeof(vlasnik), "%s", OglasiInfo[id][oOwner]);
        format(opis, sizeof(opis), "Otvoreno");
    }

    format(string, sizeof(string), "{00C0FF}Naziv Firme: {FFFFFF}%s\n{00C0FF}Opis: {FFFFFF}%s\n{00C0FF}Vlasnik Firme: {FFFFFF}%s\n{00C0FF}ID: {FFFFFF}%d | {00C0FF}Cijena: {FFFFFF}$%d | {00C0FF}Level: {FFFFFF}%d\n{00C0FF}Cijena Ulaza: {FFFFFF}$%d\n{00C0FF}Bud?et: {FFFFFF}$%d\n{00C0FF}Potrebni Produkti: {FFFFFF}%d | {00C0FF}Cijena Produkta: {FFFFFF}$%d",
        OglasiInfo[id][oNaziv],
        opis,
        vlasnik,
        id,
        OglasiInfo[id][oCena],
        OglasiInfo[id][oLevel],
        OglasiInfo[id][oUlaznaCena],
        OglasiInfo[id][oBudzet],
        OglasiInfo[id][oProizvodi],
        OglasiInfo[id][oCenaProizvoda]
    );

    OglasiInfo[id][oLabel] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, OglasiInfo[id][oEntranceX], OglasiInfo[id][oEntranceY], OglasiInfo[id][oEntranceZ]+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, -1, -1);
    OglasiInfo[id][oPickup] = CreateDynamicPickup(1274, 23, OglasiInfo[id][oEntranceX], OglasiInfo[id][oEntranceY], OglasiInfo[id][oEntranceZ], -1, -1, -1, 100.0);
    return 1;
}
public UcitajOglase()
{
    new file[64];
    for(new i = 0; i < MAX_OGLASA; i++)
    {
        format(file, sizeof(file), "BalkanRP/Oglasi/oglas_%d.ini", i);
        if(DOF2_FileExists(file))
        {
            OglasiInfo[i][oOwned] = DOF2_GetInt(file, "Owned");

            // Ispravno ucitavanje stringova za DOF2
            format(OglasiInfo[i][oOwner], MAX_PLAYER_NAME, "%s", DOF2_GetString(file, "Owner"));
            format(OglasiInfo[i][oNaziv], 32, "%s", DOF2_GetString(file, "Naziv"));

            OglasiInfo[i][oEntranceX] = DOF2_GetFloat(file, "EntranceX");
            OglasiInfo[i][oEntranceY] = DOF2_GetFloat(file, "EntranceY");
            OglasiInfo[i][oEntranceZ] = DOF2_GetFloat(file, "EntranceZ");
            OglasiInfo[i][oExitX] = DOF2_GetFloat(file, "ExitX");
            OglasiInfo[i][oExitY] = DOF2_GetFloat(file, "ExitY");
            OglasiInfo[i][oExitZ] = DOF2_GetFloat(file, "ExitZ");
            OglasiInfo[i][oInterior] = DOF2_GetInt(file, "Interior");
            OglasiInfo[i][oCena] = DOF2_GetInt(file, "Cena");
            OglasiInfo[i][oLevel] = DOF2_GetInt(file, "Level");
            OglasiInfo[i][oUlaznaCena] = DOF2_GetInt(file, "UlaznaCena");
            OglasiInfo[i][oBudzet] = DOF2_GetInt(file, "Budzet");
            OglasiInfo[i][oProizvodi] = DOF2_GetInt(file, "Proizvodi");
            OglasiInfo[i][oCenaProizvoda] = DOF2_GetInt(file, "CenaProizvoda");

            // Kreira label i pickup na mapi cim se server ucita
            UpdateOglaseCP(i);
            printf("Ucitan biznis Mali Oglasi ID: %d", i);
        }
    }
    return 1;
}
// --- 1. KREIRANJE ZLATARE (ADMIN) ---
CMD:napravizlataru(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new cena, level;
    if(sscanf(params, "ii", cena, level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/napravizlataru [Cijena] [Level]");
        return 1;
    }

    new zlataid = -1;
    for(new z = 0; z < MAX_ZLATA; z++)
    {
        new zfile[64];
        format(zfile, sizeof(zfile), "BalkanRP/Zlatara/zlatara_%d.ini", z);
        if(!DOF2_FileExists(zfile))
        {
            zlataid = z;
            break;
        }
    }

    if(zlataid == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Dostignut je maksimalan broj zlatara!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    ZlataInfo[zlataid][zOwned] = 0;
    format(ZlataInfo[zlataid][zOwner], MAX_PLAYER_NAME, "Nitko");
    format(ZlataInfo[zlataid][zNaziv], 32, "Zlatara");

    ZlataInfo[zlataid][zEntranceX] = x;
    ZlataInfo[zlataid][zEntranceY] = y;
    ZlataInfo[zlataid][zEntranceZ] = z;

    // Koordinate unutra?njosti koje si dao za zlataru
    ZlataInfo[zlataid][zExitX] = 615.6920;
    ZlataInfo[zlataid][zExitY] = -1512.0142;
    ZlataInfo[zlataid][zExitZ] = 1.2601;
    ZlataInfo[zlataid][zInterior] = 0; // Promijeni enterijer ako je potrebno

    ZlataInfo[zlataid][zCena] = cena;
    ZlataInfo[zlataid][zLevel] = level;
    ZlataInfo[zlataid][zUlaznaCena] = 50;
    ZlataInfo[zlataid][zBudzet] = 0;
    ZlataInfo[zlataid][zProizvodi] = 100;
    ZlataInfo[zlataid][zCenaProizvoda] = 100;

    SaveZlataru(zlataid);
    UpdateZlataruCP(zlataid);

    new string[128];
    format(string, sizeof(string), "Uspje?no si kreirao zlataru ID: %d", zlataid);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

// --- 2. UREDIVANJE ZLATARE (ADMIN) ---
CMD:editujzlataru(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id, nova_cijena, novi_level;
    if(sscanf(params, "iii", id, nova_cijena, novi_level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/editujzlataru [ID Zlatare] [Nova Cijena] [Novi Level]");
        return 1;
    }

    new zfile[128];
    format(zfile, sizeof(zfile), "BalkanRP/Zlatara/zlatara_%d.ini", id);
    if(!DOF2_FileExists(zfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ta zlatara ne postoji!");

    ZlataInfo[id][zCena] = nova_cijena;
    ZlataInfo[id][zLevel] = novi_level;

    SaveZlataru(id);
    UpdateZlataruCP(id);

    new string[128];
    format(string, sizeof(string), "Uspje?no si izmijenio zlataru ID: %d | Nova cijena: $%d | Novi level: %d", id, nova_cijena, novi_level);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

// --- 3. BRISANJE ZLATARE (ADMIN) ---
CMD:obrisizlataru(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id;
    if(sscanf(params, "i", id))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/obrisizlataru [ID Zlatare]");
        return 1;
    }

    new zfile[128];
    format(zfile, sizeof(zfile), "BalkanRP/Zlatara/zlatara_%d.ini", id);
    if(!DOF2_FileExists(zfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ta zlatara ne postoji!");

    DOF2_RemoveFile(zfile);

    if(IsValidDynamic3DTextLabel(ZlataInfo[id][zLabel])) DestroyDynamic3DTextLabel(ZlataInfo[id][zLabel]);
    if(IsValidDynamicPickup(ZlataInfo[id][zPickup])) DestroyDynamicPickup(ZlataInfo[id][zPickup]);

    ZlataInfo[id][zOwned] = 0;
    format(ZlataInfo[id][zOwner], MAX_PLAYER_NAME, "Nitko");
    ZlataInfo[id][zCena] = 0;
    ZlataInfo[id][zLevel] = 0;

    new string[128];
    format(string, sizeof(string), "Uspje?no si obrisao zlataru ID: %d", id);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
stock SaveZlataru(id)
{
    new file[64];
    format(file, sizeof(file), "BalkanRP/Zlatara/zlatara_%d.ini", id);
    if(!DOF2_FileExists(file)) DOF2_CreateFile(file);

    DOF2_SetInt(file, "Owned", ZlataInfo[id][zOwned]);
    DOF2_SetString(file, "Owner", ZlataInfo[id][zOwner]);
    DOF2_SetString(file, "Naziv", ZlataInfo[id][zNaziv]);
    DOF2_SetFloat(file, "EntranceX", ZlataInfo[id][zEntranceX]);
    DOF2_SetFloat(file, "EntranceY", ZlataInfo[id][zEntranceY]);
    DOF2_SetFloat(file, "EntranceZ", ZlataInfo[id][zEntranceZ]);
    DOF2_SetFloat(file, "ExitX", ZlataInfo[id][zExitX]);
    DOF2_SetFloat(file, "ExitY", ZlataInfo[id][zExitY]);
    DOF2_SetFloat(file, "ExitZ", ZlataInfo[id][zExitZ]);
    DOF2_SetInt(file, "Interior", ZlataInfo[id][zInterior]);
    DOF2_SetInt(file, "Cena", ZlataInfo[id][zCena]);
    DOF2_SetInt(file, "Level", ZlataInfo[id][zLevel]);
    DOF2_SetInt(file, "UlaznaCena", ZlataInfo[id][zUlaznaCena]);
    DOF2_SetInt(file, "Budzet", ZlataInfo[id][zBudzet]);
    DOF2_SetInt(file, "Proizvodi", ZlataInfo[id][zProizvodi]);
    DOF2_SetInt(file, "CenaProizvoda", ZlataInfo[id][zCenaProizvoda]);
    DOF2_SaveFile();
    return 1;
}
stock UpdateZlataruCP(id)
{
    if(IsValidDynamic3DTextLabel(ZlataInfo[id][zLabel])) DestroyDynamic3DTextLabel(ZlataInfo[id][zLabel]);
    if(IsValidDynamicPickup(ZlataInfo[id][zPickup])) DestroyDynamicPickup(ZlataInfo[id][zPickup]);

    new string[512], vlasnik[MAX_PLAYER_NAME], opis[32];

    if(ZlataInfo[id][zOwned] == 0)
    {
        format(vlasnik, sizeof(vlasnik), "Nitko");
        format(opis, sizeof(opis), "Na Prodaju");
    }
    else
    {
        format(vlasnik, sizeof(vlasnik), "%s", ZlataInfo[id][zOwner]);
        format(opis, sizeof(opis), "Otvoreno");
    }

    format(string, sizeof(string), "{00C0FF}Naziv Firme: {FFFFFF}%s\n{00C0FF}Opis: {FFFFFF}%s\n{00C0FF}Vlasnik Firme: {FFFFFF}%s\n{00C0FF}ID: {FFFFFF}%d | {00C0FF}Cijena: {FFFFFF}$%d | {00C0FF}Level: {FFFFFF}%d\n{00C0FF}Cijena Ulaza: {FFFFFF}$%d\n{00C0FF}Bud?et: {FFFFFF}$%d\n{00C0FF}Potrebni Produkti: {FFFFFF}%d | {00C0FF}Cijena Produkta: {FFFFFF}$%d",
        ZlataInfo[id][zNaziv],
        opis,
        vlasnik,
        id,
        ZlataInfo[id][zCena],
        ZlataInfo[id][zLevel],
        ZlataInfo[id][zUlaznaCena],
        ZlataInfo[id][zBudzet],
        ZlataInfo[id][zProizvodi],
        ZlataInfo[id][zCenaProizvoda]
    );

    ZlataInfo[id][zLabel] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, ZlataInfo[id][zEntranceX], ZlataInfo[id][zEntranceY], ZlataInfo[id][zEntranceZ]+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, -1, -1);
    ZlataInfo[id][zPickup] = CreateDynamicPickup(1274, 23, ZlataInfo[id][zEntranceX], ZlataInfo[id][zEntranceY], ZlataInfo[id][zEntranceZ], -1, -1, -1, 100.0);
    return 1;
}
public UcitajZlataru()
{
    new file[64];
    for(new i = 0; i < MAX_ZLATA; i++)
    {
        format(file, sizeof(file), "BalkanRP/Zlatara/zlatara_%d.ini", i);
        if(DOF2_FileExists(file))
        {
            ZlataInfo[i][zOwned] = DOF2_GetInt(file, "Owned");
            format(ZlataInfo[i][zOwner], MAX_PLAYER_NAME, "%s", DOF2_GetString(file, "Owner"));
            format(ZlataInfo[i][zNaziv], 32, "%s", DOF2_GetString(file, "Naziv"));
            ZlataInfo[i][zEntranceX] = DOF2_GetFloat(file, "EntranceX");
            ZlataInfo[i][zEntranceY] = DOF2_GetFloat(file, "EntranceY");
            ZlataInfo[i][zEntranceZ] = DOF2_GetFloat(file, "EntranceZ");
            ZlataInfo[i][zExitX] = DOF2_GetFloat(file, "ExitX");
            ZlataInfo[i][zExitY] = DOF2_GetFloat(file, "ExitY");
            ZlataInfo[i][zExitZ] = DOF2_GetFloat(file, "ExitZ");
            ZlataInfo[i][zInterior] = DOF2_GetInt(file, "Interior");
            ZlataInfo[i][zCena] = DOF2_GetInt(file, "Cena");
            ZlataInfo[i][zLevel] = DOF2_GetInt(file, "Level");
            ZlataInfo[i][zUlaznaCena] = DOF2_GetInt(file, "UlaznaCena");
            ZlataInfo[i][zBudzet] = DOF2_GetInt(file, "Budzet");
            ZlataInfo[i][zProizvodi] = DOF2_GetInt(file, "Proizvodi");
            ZlataInfo[i][zCenaProizvoda] = DOF2_GetInt(file, "CenaProizvoda");

            UpdateZlataruCP(i);
            printf("Ucitana Zlatara ID: %d", i);
        }
    }
    return 1;
}
// --- 1. KUPOVINA ZLATA ---
CMD:kupizlato(playerid, params[])
{
    // Provjeravamo preko PVara da li je igrac uop?te unutar neke zlatare
    new zlatara_id = GetPVarInt(playerid, "UnutarZlatare");

    if(zlatara_id == -1 || zlatara_id >= MAX_ZLATARE)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste unutar zlatare!");

    new kolicina;
    if(sscanf(params, "i", kolicina) || kolicina < 1)
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/kupizlato [Kolicina u gramima]");
        SendClientMessage(playerid, 0x00BFFFFF, "Cijena: {00AA00}$500 {FFFFFF}po gramu.");
        return 1;
    }

    new ukupna_cijena = kolicina * 500;
    if(GetPlayerMoney(playerid) < ukupna_cijena)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate dovoljno novca!");
        return 1;
    }

    GivePlayerMoney(playerid, -ukupna_cijena);
    PlayerZlato[playerid] += kolicina; // Dodajemo zlato igracu

    // Direktno uvecavamo bud?et zlatare u kojoj se igrac nalazi
    ZlataInfo[zlatara_id][zBudzet] += ukupna_cijena;
    UpdateZlataruCP(zlatara_id); // Osvje?ava 3D text label sa novim bud?etom
    SaveZlataru(zlatara_id);      // Snima promjene zlatare u fajl

    // Snimanje novih podataka igraca u njegov .ini fajl
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
        DOF2_SetInt(file, "Zlato", PlayerZlato[playerid]);
        DOF2_SaveFile();
    }

    // Odmah osvje?i TextDraw zlata na ekranu
    UpdateZlatoTD(playerid);

    new string[128];
    format(string, sizeof(string), "Uspje?no si kupio {0085FF}%d grama {FFFFFF}zlata za {00AA00}$%d.", kolicina, ukupna_cijena);
    SendClientMessage(playerid, 0xFFFFFFFF, string);
    return 1;
}

// --- 2. PRODAJA ZLATA ---
CMD:prodajzlato(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 601.5987, -1506.8588, 2.7801))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste na ?alteru za prodaju zlata!");

    new kolicina;
    if(sscanf(params, "i", kolicina) || kolicina < 1)
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/prodajzlato [Kolicina u gramima]");
        SendClientMessage(playerid, 0x00BFFFFF, "Otkupna cijena: {00AA00}$350 {FFFFFF}po gramu.");
        return 1;
    }

    if(PlayerZlato[playerid] < kolicina)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate toliko zlata kod sebe!");
        return 1;
    }

    new ukupna_zarada = kolicina * 350;

    // Pronalazimo zlataru
    new zlatara_id = -1;
    for(new i = 0; i < MAX_ZLATARE; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, ZlataInfo[i][zEntranceX], ZlataInfo[i][zEntranceY], ZlataInfo[i][zEntranceZ]))
        {
            zlatara_id = i;
            break;
        }
    }

    // Provjera da li zlatara ima dovoljno novca u bud?etu da otkupi zlato od igraca
    if(zlatara_id != -1 && ZlataInfo[zlatara_id][zBudzet] < ukupna_zarada)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Zlatara trenutno nema dovoljno novca u bud?etu da otkupi ovu kolicinu zlata!");
        return 1;
    }

    PlayerZlato[playerid] -= kolicina;
    UpdateZlatoTD(playerid);
    GivePlayerMoney(playerid, ukupna_zarada);

    // Oduzimamo novac iz bud?eta zlatare jer isplacuje igraca
    if(zlatara_id != -1)
    {
        ZlataInfo[zlatara_id][zBudzet] -= ukupna_zarada;
        UpdateZlataruCP(zlatara_id);
        // SaveZlataru(zlatara_id);
    }

    new string[128];
    format(string, sizeof(string), "Uspje?no si prodao {0085FF}%d grama {FFFFFF}zlata za {00AA00}$%d.", kolicina, ukupna_zarada);
    SendClientMessage(playerid, 0xFFFFFFFF, string);
    return 1;
}
CMD:kupisat(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 602.4924, -1519.7023, 2.7801))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste na pultu za prodaju satova!");

    // Postavljamo ID zlatare (ako ima? samo jednu zlataru, ostaje 0;
    // ako ima? vi?e zlatara na serveru, ovde upi?i ID te konkretne zlatare)
    SetPVarInt(playerid, "ZlataraID", 0);

    ShowPlayerDialog(playerid, 9875, DIALOG_STYLE_LIST, "{00C0FF}Zlatara - Kupovina Rucnog Sata",
        "1. Rolex Gold (Luksuzni) - $15,000\n\
        2. Diamond Watch - $10,000\n\
        3. Platinum Chronograph - $7,500\n\
        4. Classic Silver Watch - $3,000\n\
        5. Digital Plastic Watch - $800",
        "Kupi", "Odustani");
    return 1;
}
stock Text:CreateConfiguredGlobalTD(Float:x, Float:y, caption[], font, Float:letterX, Float:letterY,
    Float:sizeX, Float:sizeY, outline, shadow, alignment, color, background, boxColor, useBox)
{
    new Text:td = TextDrawCreate(x, y, caption);
    TextDrawFont(td, font);
    TextDrawLetterSize(td, letterX, letterY);
    TextDrawTextSize(td, sizeX, sizeY);
    TextDrawSetOutline(td, outline);
    TextDrawSetShadow(td, shadow);
    TextDrawAlignment(td, alignment);
    TextDrawColor(td, color);
    TextDrawBackgroundColor(td, background);
    TextDrawBoxColor(td, boxColor);
    TextDrawUseBox(td, useBox);
    TextDrawSetProportional(td, 1);
    TextDrawSetSelectable(td, 0);
    return td;
}

stock InitAuthTextDraws()
{
    TD_Auth[0] = CreateConfiguredGlobalTD(295.0, -1.0, "_", 1, 1.016666, 15.300003, 298.5, 695.0, 1, 0, 2, -1, 255, 85, 1);
    TD_Auth[1] = CreateConfiguredGlobalTD(295.0, 309.0, "_", 1, 1.016666, 15.300003, 298.5, 695.0, 1, 0, 2, -1, 255, 85, 1);
    TD_Auth[2] = CreateConfiguredGlobalTD(325.0, 307.0, "_", 1, 1.016666, -0.449997, 298.5, 695.0, 1, 0, 2, -1, 255, 1687547391, 1);
    TD_Auth[3] = CreateConfiguredGlobalTD(325.0, 143.0, "_", 1, 1.016666, -0.449997, 298.5, 695.0, 1, 0, 2, -1, 255, 1687547391, 1);
    TD_Auth[4] = CreateConfiguredGlobalTD(316.0, 400.0, "_", 1, 1.016666, -0.849995, 323.5, 154.5, 1, 0, 2, -1, 255, 1687547391, 1);
    TD_Auth[5] = CreateConfiguredGlobalTD(291.0, 29.0, "BR", 2, 0.799997, 4.699998, 400.0, 17.0, 0, 1, 1, -1, 255, 50, 0);
    TD_Auth[6] = CreateConfiguredGlobalTD(212.0, 68.0, "BALKAN REVOLUTION", 2, 0.537500, 3.449996, 785.0, 67.0, 0, 1, 1, 1687547391, 255, 50, 0);
    TD_Auth[7] = CreateConfiguredGlobalTD(286.0, 107.0, "ROLEPLAY", 2, 0.279166, 1.500000, 585.0, -58.0, 0, 1, 1, -1, 255, 50, 0);
    TD_Auth[8] = CreateConfiguredGlobalTD(316.0, 337.0, "DOBRODOSLI NA BALKAN REVOLUTION ROLEPLAY SERVER BR V0.0.1 BY ADMIN WWW.BALKANRE.NET", 2, 0.249999, 1.200001, 841.5, 107.0, 0, 1, 2, -1, 255, 50, 0);
    TD_Auth[9] = CreateConfiguredGlobalTD(80.0, 400.0, "_", 1, 1.016666, -0.849995, 323.5, 154.5, 1, 0, 2, -1, 255, 1687547391, 1);
    TD_Auth[10] = CreateConfiguredGlobalTD(64.0, 383.0, "VERZIJA SKRIPTE: v0.0.1", 2, 0.249999, 1.200001, 906.5, 177.0, 0, 1, 2, -1, 255, 50, 0);
    TD_Auth[11] = CreateConfiguredGlobalTD(279.0, 36.0, "\"", 1, 0.600000, 2.000000, 400.0, 17.0, 0, 1, 1, 65535, 255, 50, 0);
    TD_Auth[12] = CreateConfiguredGlobalTD(336.0, 59.0, "\"", 1, 0.600000, 2.000000, 400.0, 17.0, 0, 1, 1, -16776961, 255, 50, 0);
    return 1;
}

forward HealthSystemTick();
public HealthSystemTick()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn")) continue;
        if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_NONE || IsHealing[playerid]) continue;
        new file[128];
        if(!GetPlayerAccountPath(playerid, file, sizeof(file))) continue;
        new sickUntil = DOF2_GetInt(file, "BolestanDo");

        new damage = 0;
        if(sickUntil > 0) damage = 2;
        else
        {
            HealthTickMinutes[playerid]++;
            if(HealthTickMinutes[playerid] >= 10)
            {
                HealthTickMinutes[playerid] = 0;
                damage = 1;
                if(random(100) < 3)
                {
                    DOF2_SetInt(file, "BolestanDo", 1);
                    DOF2_SaveFile();
                    SendClientMessage(playerid, 0xFFAA66FF, "[ZDRAVLJE]: Razbolili ste se. Uhvatili ste gripu, idite u Bolnicu da se izlijecite.");
                }
            }
        }
        if(damage > 0)
        {
            new Float:health;
            GetPlayerHealth(playerid, health);
            health -= float(damage);
            if(health < 5.0) health = 5.0;
            SetPlayerHealth(playerid, health);
        }
    }
    return 1;
}

stock IsPoliceTracker(playerid)
{
    new org = PlayerOrg[playerid];
    if(PlayerInfo[playerid][pLider] > 0) org = PlayerInfo[playerid][pLider];
    return (org == 1 || org == 2 || org == 3);
}

CMD:fs(playerid, params[])
{
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF0000FF, "[POLICIJA]: Prvo se prijavite na svoj nalog.");
    if(!IsPoliceTracker(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[POLICIJA]: Ovu komandu mogu koristiti Policija, Vojska i Zandarmerija.");
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xAFAFAFFF, "Koristenje: /fs [ID/Ime]");
    if(!IsPlayerConnected(targetid) || !GetPVarInt(targetid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF0000FF, "[POLICIJA]: Taj igrac nije prijavljen i online.");
    RemovePlayerMapIcon(playerid, POLICE_TRACK_MAP_ICON);
    PoliceTrackTarget[playerid] = INVALID_PLAYER_ID;
    if(WantedPoints[targetid] <= 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[POLICIJA]: Taj igrac nema Wanted Level.");
    if(GetPlayerInterior(targetid) != 0 || GetPlayerVirtualWorld(targetid) != 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[POLICIJA]: Taj igrac je u enterijeru.");

    PoliceTrackTarget[playerid] = targetid;
    new Float:x, Float:y, Float:z, targetName[MAX_PLAYER_NAME], message[128];
    GetPlayerPos(targetid, x, y, z);
    SetPlayerMapIcon(playerid, POLICE_TRACK_MAP_ICON, x, y, z, 0, 0xFF7777FF, MAPICON_GLOBAL);
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(message, sizeof(message), "[POLICIJA]: Pratite lokaciju igraca %s[%d].", targetName, targetid);
    SendClientMessage(playerid, 0x33CCFFFF, message);
    return 1;
}

stock ShowAuthTextDraws(playerid)
{
    if(AuthTDShown[playerid]) return 1;
    for(new i = 0; i < 13; i++) TextDrawShowForPlayer(playerid, TD_Auth[i]);
    AuthTDShown[playerid] = true;
    return 1;
}

stock HideAuthTextDraws(playerid)
{
    if(!AuthTDShown[playerid]) return 1;
    for(new i = 0; i < 13; i++) TextDrawHideForPlayer(playerid, TD_Auth[i]);
    AuthTDShown[playerid] = false;
    return 1;
}



public InitRevolutionHud()
{
    TD_NewHud[0] = TextDrawCreate(601.000000, 428.500000, "LD_BEAT:chit");
    	TextDrawFont(TD_NewHud[0], 4);
    	TextDrawLetterSize(TD_NewHud[0], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[0], 26.500000, 24.000000);
    	TextDrawSetOutline(TD_NewHud[0], 1);
    	TextDrawSetShadow(TD_NewHud[0], 0);
    	TextDrawAlignment(TD_NewHud[0], 1);
    	TextDrawColor(TD_NewHud[0], -65281);
    	TextDrawBackgroundColor(TD_NewHud[0], 255);
    	TextDrawBoxColor(TD_NewHud[0], 50);
    	TextDrawUseBox(TD_NewHud[0], 1);
    	TextDrawSetProportional(TD_NewHud[0], 1);
    	TextDrawSetSelectable(TD_NewHud[0], 0);

    TD_NewHud[1] = TextDrawCreate(320.000000, 435.000000, "_");
    	TextDrawFont(TD_NewHud[1], 1);
    	TextDrawLetterSize(TD_NewHud[1], 0.600000, 1.300003);
    	TextDrawTextSize(TD_NewHud[1], 358.500000, 580.000000);
    	TextDrawSetOutline(TD_NewHud[1], 2);
    	TextDrawSetShadow(TD_NewHud[1], 0);
    	TextDrawAlignment(TD_NewHud[1], 2);
    	TextDrawColor(TD_NewHud[1], 1097458175);
    	TextDrawBackgroundColor(TD_NewHud[1], 255);
    	TextDrawBoxColor(TD_NewHud[1], 421339391);
    	TextDrawUseBox(TD_NewHud[1], 1);
    	TextDrawSetProportional(TD_NewHud[1], 1);
    	TextDrawSetSelectable(TD_NewHud[1], 0);

    TD_NewHud[2] = TextDrawCreate(11.000000, 430.500000, "LD_BEAT:chit");
    	TextDrawFont(TD_NewHud[2], 4);
    	TextDrawLetterSize(TD_NewHud[2], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[2], 26.500000, 24.000000);
    	TextDrawSetOutline(TD_NewHud[2], 1);
    	TextDrawSetShadow(TD_NewHud[2], 0);
    	TextDrawAlignment(TD_NewHud[2], 1);
    	TextDrawColor(TD_NewHud[2], -65281);
    	TextDrawBackgroundColor(TD_NewHud[2], 255);
    	TextDrawBoxColor(TD_NewHud[2], 50);
    	TextDrawUseBox(TD_NewHud[2], 1);
    	TextDrawSetProportional(TD_NewHud[2], 1);
    	TextDrawSetSelectable(TD_NewHud[2], 0);

    TD_NewHud[3] = TextDrawCreate(13.000000, 428.500000, "LD_BEAT:chit");
    	TextDrawFont(TD_NewHud[3], 4);
    	TextDrawLetterSize(TD_NewHud[3], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[3], 26.500000, 24.000000);
    	TextDrawSetOutline(TD_NewHud[3], 1);
    	TextDrawSetShadow(TD_NewHud[3], 0);
    	TextDrawAlignment(TD_NewHud[3], 1);
    	TextDrawColor(TD_NewHud[3], 1097458175);
    	TextDrawBackgroundColor(TD_NewHud[3], 255);
    	TextDrawBoxColor(TD_NewHud[3], 50);
    	TextDrawUseBox(TD_NewHud[3], 1);
    	TextDrawSetProportional(TD_NewHud[3], 1);
    	TextDrawSetSelectable(TD_NewHud[3], 0);

    TD_NewHud[4] = TextDrawCreate(319.000000, 434.000000, "_");
    	TextDrawFont(TD_NewHud[4], 1);
    	TextDrawLetterSize(TD_NewHud[4], 0.633333, -0.100000);
    	TextDrawTextSize(TD_NewHud[4], 278.000000, 589.500000);
    	TextDrawSetOutline(TD_NewHud[4], 1);
    	TextDrawSetShadow(TD_NewHud[4], 0);
    	TextDrawAlignment(TD_NewHud[4], 2);
    	TextDrawColor(TD_NewHud[4], 1097458175);
    	TextDrawBackgroundColor(TD_NewHud[4], 255);
    	TextDrawBoxColor(TD_NewHud[4], 255);
    	TextDrawUseBox(TD_NewHud[4], 1);
    	TextDrawSetProportional(TD_NewHud[4], 1);
    	TextDrawSetSelectable(TD_NewHud[4], 0);

    TD_NewHud[5] = TextDrawCreate(11.000000, 428.500000, "LD_BEAT:chit");
    	TextDrawFont(TD_NewHud[5], 4);
    	TextDrawLetterSize(TD_NewHud[5], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[5], 26.500000, 24.000000);
    	TextDrawSetOutline(TD_NewHud[5], 1);
    	TextDrawSetShadow(TD_NewHud[5], 0);
    	TextDrawAlignment(TD_NewHud[5], 1);
    	TextDrawColor(TD_NewHud[5], -65281);
    	TextDrawBackgroundColor(TD_NewHud[5], 255);
    	TextDrawBoxColor(TD_NewHud[5], 50);
    	TextDrawUseBox(TD_NewHud[5], 1);
    	TextDrawSetProportional(TD_NewHud[5], 1);
    	TextDrawSetSelectable(TD_NewHud[5], 0);

    TD_NewHud[6] = TextDrawCreate(12.500000, 429.500000, "LD_BEAT:chit");
    	TextDrawFont(TD_NewHud[6], 4);
    	TextDrawLetterSize(TD_NewHud[6], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[6], 29.000000, 24.000000);
    	TextDrawSetOutline(TD_NewHud[6], 1);
    	TextDrawSetShadow(TD_NewHud[6], 0);
    	TextDrawAlignment(TD_NewHud[6], 1);
    	TextDrawColor(TD_NewHud[6], 421339391);
    	TextDrawBackgroundColor(TD_NewHud[6], 255);
    	TextDrawBoxColor(TD_NewHud[6], 50);
    	TextDrawUseBox(TD_NewHud[6], 1);
    	TextDrawSetProportional(TD_NewHud[6], 1);
    	TextDrawSetSelectable(TD_NewHud[6], 0);

    TD_NewHud[7] = TextDrawCreate(602.000000, 430.500000, "LD_BEAT:chit");
    	TextDrawFont(TD_NewHud[7], 4);
    	TextDrawLetterSize(TD_NewHud[7], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[7], 26.500000, 24.000000);
    	TextDrawSetOutline(TD_NewHud[7], 1);
    	TextDrawSetShadow(TD_NewHud[7], 0);
    	TextDrawAlignment(TD_NewHud[7], 1);
    	TextDrawColor(TD_NewHud[7], -65281);
    	TextDrawBackgroundColor(TD_NewHud[7], 255);
    	TextDrawBoxColor(TD_NewHud[7], 50);
    	TextDrawUseBox(TD_NewHud[7], 1);
    	TextDrawSetProportional(TD_NewHud[7], 1);
    	TextDrawSetSelectable(TD_NewHud[7], 0);

    TD_NewHud[8] = TextDrawCreate(600.000000, 430.500000, "LD_BEAT:chit");
    	TextDrawFont(TD_NewHud[8], 4);
    	TextDrawLetterSize(TD_NewHud[8], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[8], 26.500000, 24.000000);
    	TextDrawSetOutline(TD_NewHud[8], 1);
    	TextDrawSetShadow(TD_NewHud[8], 0);
    	TextDrawAlignment(TD_NewHud[8], 1);
    	TextDrawColor(TD_NewHud[8], 421339391);
    	TextDrawBackgroundColor(TD_NewHud[8], 255);
    	TextDrawBoxColor(TD_NewHud[8], 50);
    	TextDrawUseBox(TD_NewHud[8], 1);
    	TextDrawSetProportional(TD_NewHud[8], 1);
    	TextDrawSetSelectable(TD_NewHud[8], 0);

    TD_NewHud[9] = TextDrawCreate(319.000000, 434.000000, "_");
    	TextDrawFont(TD_NewHud[9], 1);
    	TextDrawLetterSize(TD_NewHud[9], 0.633333, -0.100000);
    	TextDrawTextSize(TD_NewHud[9], 278.000000, 589.500000);
    	TextDrawSetOutline(TD_NewHud[9], 1);
    	TextDrawSetShadow(TD_NewHud[9], 0);
    	TextDrawAlignment(TD_NewHud[9], 2);
    	TextDrawColor(TD_NewHud[9], -1);
    	TextDrawBackgroundColor(TD_NewHud[9], 255);
    	TextDrawBoxColor(TD_NewHud[9], -65281);
    	TextDrawUseBox(TD_NewHud[9], 1);
    	TextDrawSetProportional(TD_NewHud[9], 1);
    	TextDrawSetSelectable(TD_NewHud[9], 0);

    TD_NewHud[10] = TextDrawCreate(21.000000, 425.000000, ".");
    	TextDrawFont(TD_NewHud[10], 1);
    	TextDrawLetterSize(TD_NewHud[10], 0.341666, 1.299998);
    	TextDrawTextSize(TD_NewHud[10], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[10], 0);
    	TextDrawSetShadow(TD_NewHud[10], 0);
    	TextDrawAlignment(TD_NewHud[10], 1);
    	TextDrawColor(TD_NewHud[10], -65281);
    	TextDrawBackgroundColor(TD_NewHud[10], 255);
    	TextDrawBoxColor(TD_NewHud[10], 50);
    	TextDrawUseBox(TD_NewHud[10], 0);
    	TextDrawSetProportional(TD_NewHud[10], 1);
    	TextDrawSetSelectable(TD_NewHud[10], 0);

    TD_NewHud[11] = TextDrawCreate(267.000000, 423.000000, "~w~www.~y~balkanrevolution~w~.com");
    	TextDrawFont(TD_NewHud[11], 1);
    	TextDrawLetterSize(TD_NewHud[11], 0.216664, 1.000000);
    	TextDrawTextSize(TD_NewHud[11], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[11], 1);
    	TextDrawSetShadow(TD_NewHud[11], 0);
    	TextDrawAlignment(TD_NewHud[11], 1);
    	TextDrawColor(TD_NewHud[11], -65281);
    	TextDrawBackgroundColor(TD_NewHud[11], 255);
    	TextDrawBoxColor(TD_NewHud[11], 50);
    	TextDrawUseBox(TD_NewHud[11], 0);
    	TextDrawSetProportional(TD_NewHud[11], 1);
    	TextDrawSetSelectable(TD_NewHud[11], 0);

    TD_NewHud[12] = TextDrawCreate(21.000000, 434.000000, "BR");
    	TextDrawFont(TD_NewHud[12], 2);
    	TextDrawLetterSize(TD_NewHud[12], 0.224996, 1.499999);
    	TextDrawTextSize(TD_NewHud[12], 680.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[12], 0);
    	TextDrawSetShadow(TD_NewHud[12], 0);
    	TextDrawAlignment(TD_NewHud[12], 1);
    	TextDrawColor(TD_NewHud[12], -1);
    	TextDrawBackgroundColor(TD_NewHud[12], 255);
    	TextDrawBoxColor(TD_NewHud[12], 50);
    	TextDrawUseBox(TD_NewHud[12], 0);
    	TextDrawSetProportional(TD_NewHud[12], 1);
    	TextDrawSetSelectable(TD_NewHud[12], 0);

    TD_NewHud[13] = TextDrawCreate(558.000000, 435.000000, "V");
    	TextDrawFont(TD_NewHud[13], 2);
    	TextDrawLetterSize(TD_NewHud[13], 0.199999, 1.349997);
    	TextDrawTextSize(TD_NewHud[13], 680.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[13], 0);
    	TextDrawSetShadow(TD_NewHud[13], 0);
    	TextDrawAlignment(TD_NewHud[13], 1);
    	TextDrawColor(TD_NewHud[13], -65281);
    	TextDrawBackgroundColor(TD_NewHud[13], 255);
    	TextDrawBoxColor(TD_NewHud[13], 50);
    	TextDrawUseBox(TD_NewHud[13], 0);
    	TextDrawSetProportional(TD_NewHud[13], 1);
    	TextDrawSetSelectable(TD_NewHud[13], 0);

    TD_NewHud[14] = TextDrawCreate(85.000000, 430.000000, "/");
    	TextDrawFont(TD_NewHud[14], 1);
    	TextDrawLetterSize(TD_NewHud[14], 0.237498, 2.000000);
    	TextDrawTextSize(TD_NewHud[14], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[14], 0);
    	TextDrawSetShadow(TD_NewHud[14], 0);
    	TextDrawAlignment(TD_NewHud[14], 1);
    	TextDrawColor(TD_NewHud[14], -65281);
    	TextDrawBackgroundColor(TD_NewHud[14], 255);
    	TextDrawBoxColor(TD_NewHud[14], 50);
    	TextDrawUseBox(TD_NewHud[14], 0);
    	TextDrawSetProportional(TD_NewHud[14], 1);
    	TextDrawSetSelectable(TD_NewHud[14], 0);

    TD_NewHud[15] = TextDrawCreate(33.000000, 436.000000, "BALKAN");
    	TextDrawFont(TD_NewHud[15], 2);
    	TextDrawLetterSize(TD_NewHud[15], 0.125000, 0.750000);
    	TextDrawTextSize(TD_NewHud[15], 680.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[15], 0);
    	TextDrawSetShadow(TD_NewHud[15], 0);
    	TextDrawAlignment(TD_NewHud[15], 1);
    	TextDrawColor(TD_NewHud[15], -1);
    	TextDrawBackgroundColor(TD_NewHud[15], 255);
    	TextDrawBoxColor(TD_NewHud[15], 50);
    	TextDrawUseBox(TD_NewHud[15], 0);
    	TextDrawSetProportional(TD_NewHud[15], 1);
    	TextDrawSetSelectable(TD_NewHud[15], 0);

    TD_NewHud[16] = TextDrawCreate(33.000000, 440.000000, "REVOLUTION");
    	TextDrawFont(TD_NewHud[16], 2);
    	TextDrawLetterSize(TD_NewHud[16], 0.125000, 0.750000);
    	TextDrawTextSize(TD_NewHud[16], 680.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[16], 0);
    	TextDrawSetShadow(TD_NewHud[16], 0);
    	TextDrawAlignment(TD_NewHud[16], 1);
    	TextDrawColor(TD_NewHud[16], -1);
    	TextDrawBackgroundColor(TD_NewHud[16], 255);
    	TextDrawBoxColor(TD_NewHud[16], 50);
    	TextDrawUseBox(TD_NewHud[16], 0);
    	TextDrawSetProportional(TD_NewHud[16], 1);
    	TextDrawSetSelectable(TD_NewHud[16], 0);

    TD_NewHud[17] = TextDrawCreate(70.000000, 437.000000, "]");
    	TextDrawFont(TD_NewHud[17], 2);
    	TextDrawLetterSize(TD_NewHud[17], 0.220832, 0.999997);
    	TextDrawTextSize(TD_NewHud[17], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[17], 1);
    	TextDrawSetShadow(TD_NewHud[17], 0);
    	TextDrawAlignment(TD_NewHud[17], 1);
    	TextDrawColor(TD_NewHud[17], 421339391);
    	TextDrawBackgroundColor(TD_NewHud[17], -65281);
    	TextDrawBoxColor(TD_NewHud[17], 50);
    	TextDrawUseBox(TD_NewHud[17], 0);
    	TextDrawSetProportional(TD_NewHud[17], 1);
    	TextDrawSetSelectable(TD_NewHud[17], 0);

    TD_NewHud[18] = TextDrawCreate(96.000000, 437.000000, "ld_chat:badchat");
    	TextDrawFont(TD_NewHud[18], 4);
    	TextDrawLetterSize(TD_NewHud[18], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[18], 9.500000, 9.000000);
    	TextDrawSetOutline(TD_NewHud[18], 1);
    	TextDrawSetShadow(TD_NewHud[18], 0);
    	TextDrawAlignment(TD_NewHud[18], 1);
    	TextDrawColor(TD_NewHud[18], -1);
    	TextDrawBackgroundColor(TD_NewHud[18], 255);
    	TextDrawBoxColor(TD_NewHud[18], 50);
    	TextDrawUseBox(TD_NewHud[18], 1);
    	TextDrawSetProportional(TD_NewHud[18], 1);
    	TextDrawSetSelectable(TD_NewHud[18], 0);

    TD_NewHud[19] = TextDrawCreate(372.000000, 436.000000, "Preview_Model");
    	TextDrawFont(TD_NewHud[19], 5);
    	TextDrawLetterSize(TD_NewHud[19], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[19], 13.500000, 11.500000);
    	TextDrawSetOutline(TD_NewHud[19], 0);
    	TextDrawSetShadow(TD_NewHud[19], 0);
    	TextDrawAlignment(TD_NewHud[19], 1);
    	TextDrawColor(TD_NewHud[19], -1);
    	TextDrawBackgroundColor(TD_NewHud[19], 0);
    	TextDrawBoxColor(TD_NewHud[19], 255);
    	TextDrawUseBox(TD_NewHud[19], 0);
    	TextDrawSetProportional(TD_NewHud[19], 1);
    	TextDrawSetSelectable(TD_NewHud[19], 0);
    	TextDrawSetPreviewModel(TD_NewHud[19], 1239);
    	TextDrawSetPreviewRot(TD_NewHud[19], -10.000000, 0.000000, 0.000000, 1.000000);
    	TextDrawSetPreviewVehCol(TD_NewHud[19], 1, 1);

    TD_NewHud[20] = TextDrawCreate(117.000000, 436.500000, "SPORUKE SU VEOMA BITNA STVAR I TO TREBAMO DA GLEDAMO KAO DOBRO");
    	TextDrawFont(TD_NewHud[20], 2);
    	TextDrawLetterSize(TD_NewHud[20], 0.141662, 1.000000);
    	TextDrawTextSize(TD_NewHud[20], 1165.000000, -143.000000);
    	TextDrawSetOutline(TD_NewHud[20], 0);
    	TextDrawSetShadow(TD_NewHud[20], 0);
    	TextDrawAlignment(TD_NewHud[20], 1);
    	TextDrawColor(TD_NewHud[20], -1);
    	TextDrawBackgroundColor(TD_NewHud[20], 255);
    	TextDrawBoxColor(TD_NewHud[20], 50);
    	TextDrawUseBox(TD_NewHud[20], 0);
    	TextDrawSetProportional(TD_NewHud[20], 1);
    	TextDrawSetSelectable(TD_NewHud[20], 0);

    TD_NewHud[21] = TextDrawCreate(361.000000, 434.500000, "...");
    	TextDrawFont(TD_NewHud[21], 1);
    	TextDrawLetterSize(TD_NewHud[21], 0.287499, 1.049998);
    	TextDrawTextSize(TD_NewHud[21], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[21], 0);
    	TextDrawSetShadow(TD_NewHud[21], 0);
    	TextDrawAlignment(TD_NewHud[21], 1);
    	TextDrawColor(TD_NewHud[21], -65281);
    	TextDrawBackgroundColor(TD_NewHud[21], 1097458175);
    	TextDrawBoxColor(TD_NewHud[21], 50);
    	TextDrawUseBox(TD_NewHud[21], 0);
    	TextDrawSetProportional(TD_NewHud[21], 1);
    	TextDrawSetSelectable(TD_NewHud[21], 0);

    TD_NewHud[22] = TextDrawCreate(385.000000, 435.000000, "HAPPYJOB:");
    	TextDrawFont(TD_NewHud[22], 2);
    	TextDrawLetterSize(TD_NewHud[22], 0.125000, 0.750000);
    	TextDrawTextSize(TD_NewHud[22], 680.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[22], 0);
    	TextDrawSetShadow(TD_NewHud[22], 0);
    	TextDrawAlignment(TD_NewHud[22], 1);
    	TextDrawColor(TD_NewHud[22], -1);
    	TextDrawBackgroundColor(TD_NewHud[22], 255);
    	TextDrawBoxColor(TD_NewHud[22], 50);
    	TextDrawUseBox(TD_NewHud[22], 0);
    	TextDrawSetProportional(TD_NewHud[22], 1);
    	TextDrawSetSelectable(TD_NewHud[22], 0);

    TD_NewHud[23] = TextDrawCreate(385.000000, 440.000000, "UGASENO");
    	TextDrawFont(TD_NewHud[23], 2);
    	TextDrawLetterSize(TD_NewHud[23], 0.125000, 0.750000);
    	TextDrawTextSize(TD_NewHud[23], 680.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[23], 0);
    	TextDrawSetShadow(TD_NewHud[23], 0);
    	TextDrawAlignment(TD_NewHud[23], 1);
    	TextDrawColor(TD_NewHud[23], -1);
    	TextDrawBackgroundColor(TD_NewHud[23], 255);
    	TextDrawBoxColor(TD_NewHud[23], 50);
    	TextDrawUseBox(TD_NewHud[23], 0);
    	TextDrawSetProportional(TD_NewHud[23], 1);
    	TextDrawSetSelectable(TD_NewHud[23], 0);

    TD_NewHud[24] = TextDrawCreate(442.000000, 436.000000, "ld_grav:timer");
    	TextDrawFont(TD_NewHud[24], 4);
    	TextDrawLetterSize(TD_NewHud[24], 0.600000, 2.000000);
    	TextDrawTextSize(TD_NewHud[24], 11.000000, 10.000000);
    	TextDrawSetOutline(TD_NewHud[24], 1);
    	TextDrawSetShadow(TD_NewHud[24], 0);
    	TextDrawAlignment(TD_NewHud[24], 1);
    	TextDrawColor(TD_NewHud[24], -1);
    	TextDrawBackgroundColor(TD_NewHud[24], 255);
    	TextDrawBoxColor(TD_NewHud[24], 50);
    	TextDrawUseBox(TD_NewHud[24], 1);
    	TextDrawSetProportional(TD_NewHud[24], 1);
    	TextDrawSetSelectable(TD_NewHud[24], 0);

    TD_NewHud[27] = TextDrawCreate(83.000000, 430.000000, "/");
    	TextDrawFont(TD_NewHud[27], 1);
    	TextDrawLetterSize(TD_NewHud[27], 0.237498, 2.000000);
    	TextDrawTextSize(TD_NewHud[27], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[27], 0);
    	TextDrawSetShadow(TD_NewHud[27], 0);
    	TextDrawAlignment(TD_NewHud[27], 1);
    	TextDrawColor(TD_NewHud[27], -65281);
    	TextDrawBackgroundColor(TD_NewHud[27], 255);
    	TextDrawBoxColor(TD_NewHud[27], 50);
    	TextDrawUseBox(TD_NewHud[27], 0);
    	TextDrawSetProportional(TD_NewHud[27], 1);
    	TextDrawSetSelectable(TD_NewHud[27], 0);

    TD_NewHud[28] = TextDrawCreate(549.000000, 430.000000, "/");
    	TextDrawFont(TD_NewHud[28], 1);
    	TextDrawLetterSize(TD_NewHud[28], 0.237498, 2.000000);
    	TextDrawTextSize(TD_NewHud[28], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[28], 0);
    	TextDrawSetShadow(TD_NewHud[28], 0);
    	TextDrawAlignment(TD_NewHud[28], 1);
    	TextDrawColor(TD_NewHud[28], -65281);
    	TextDrawBackgroundColor(TD_NewHud[28], 255);
    	TextDrawBoxColor(TD_NewHud[28], 50);
    	TextDrawUseBox(TD_NewHud[28], 0);
    	TextDrawSetProportional(TD_NewHud[28], 1);
    	TextDrawSetSelectable(TD_NewHud[28], 0);

    TD_NewHud[29] = TextDrawCreate(547.000000, 430.000000, "/");
    	TextDrawFont(TD_NewHud[29], 1);
    	TextDrawLetterSize(TD_NewHud[29], 0.237498, 2.000000);
    	TextDrawTextSize(TD_NewHud[29], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[29], 0);
    	TextDrawSetShadow(TD_NewHud[29], 0);
    	TextDrawAlignment(TD_NewHud[29], 1);
    	TextDrawColor(TD_NewHud[29], -65281);
    	TextDrawBackgroundColor(TD_NewHud[29], 255);
    	TextDrawBoxColor(TD_NewHud[29], 50);
    	TextDrawUseBox(TD_NewHud[29], 0);
    	TextDrawSetProportional(TD_NewHud[29], 1);
    	TextDrawSetSelectable(TD_NewHud[29], 0);

    TD_NewHud[30] = TextDrawCreate(563.000000, 439.000000, "ERSION:");
    	TextDrawFont(TD_NewHud[30], 2);
    	TextDrawLetterSize(TD_NewHud[30], 0.141662, 0.799996);
    	TextDrawTextSize(TD_NewHud[30], 680.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[30], 0);
    	TextDrawSetShadow(TD_NewHud[30], 0);
    	TextDrawAlignment(TD_NewHud[30], 1);
    	TextDrawColor(TD_NewHud[30], -1);
    	TextDrawBackgroundColor(TD_NewHud[30], 255);
    	TextDrawBoxColor(TD_NewHud[30], 50);
    	TextDrawUseBox(TD_NewHud[30], 0);
    	TextDrawSetProportional(TD_NewHud[30], 1);
    	TextDrawSetSelectable(TD_NewHud[30], 0);

    TD_NewHud[31] = TextDrawCreate(589.000000, 437.000000, "0.0.1");
    	TextDrawFont(TD_NewHud[31], 2);
    	TextDrawLetterSize(TD_NewHud[31], 0.158333, 1.049998);
    	TextDrawTextSize(TD_NewHud[31], 680.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[31], 0);
    	TextDrawSetShadow(TD_NewHud[31], 0);
    	TextDrawAlignment(TD_NewHud[31], 1);
    	TextDrawColor(TD_NewHud[31], -1);
    	TextDrawBackgroundColor(TD_NewHud[31], 255);
    	TextDrawBoxColor(TD_NewHud[31], 50);
    	TextDrawUseBox(TD_NewHud[31], 0);
    	TextDrawSetProportional(TD_NewHud[31], 1);
    	TextDrawSetSelectable(TD_NewHud[31], 0);

    TD_NewHud[32] = TextDrawCreate(497.000000, 2.000000, "~y~~h~Balkan");
    	TextDrawFont(TD_NewHud[32], 1);
    	TextDrawLetterSize(TD_NewHud[32], 0.404166, 1.799998);
    	TextDrawTextSize(TD_NewHud[32], 695.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[32], 1);
    	TextDrawSetShadow(TD_NewHud[32], 0);
    	TextDrawAlignment(TD_NewHud[32], 1);
    	TextDrawColor(TD_NewHud[32], -65281);
    	TextDrawBackgroundColor(TD_NewHud[32], 255);
    	TextDrawBoxColor(TD_NewHud[32], 50);
    	TextDrawUseBox(TD_NewHud[32], 0);
    	TextDrawSetProportional(TD_NewHud[32], 1);
    	TextDrawSetSelectable(TD_NewHud[32], 0);

    TD_NewHud[33] = TextDrawCreate(549.000000, 2.000000, "R~r~e~y~~h~volution");
    	TextDrawFont(TD_NewHud[33], 1);
    	TextDrawLetterSize(TD_NewHud[33], 0.404166, 1.799998);
    	TextDrawTextSize(TD_NewHud[33], 695.000000, 17.000000);
    	TextDrawSetOutline(TD_NewHud[33], 1);
    	TextDrawSetShadow(TD_NewHud[33], 0);
    	TextDrawAlignment(TD_NewHud[33], 1);
    	TextDrawColor(TD_NewHud[33], -65281);
    	TextDrawBackgroundColor(TD_NewHud[33], 255);
    	TextDrawBoxColor(TD_NewHud[33], 50);
    	TextDrawUseBox(TD_NewHud[33], 0);
    	TextDrawSetProportional(TD_NewHud[33], 1);
    	TextDrawSetSelectable(TD_NewHud[33], 0);

    TD_VehicleFrame[0] = TextDrawCreate(560.000000, 343.899993, "_");
    	TextDrawFont(TD_VehicleFrame[0], 1);
    	TextDrawLetterSize(TD_VehicleFrame[0], 0.600000, 8.399991);
    	TextDrawTextSize(TD_VehicleFrame[0], 317.500000, 130.000000);
    	TextDrawSetOutline(TD_VehicleFrame[0], 1);
    	TextDrawSetShadow(TD_VehicleFrame[0], 0);
    	TextDrawAlignment(TD_VehicleFrame[0], 2);
    	TextDrawColor(TD_VehicleFrame[0], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[0], 255);
    	TextDrawBoxColor(TD_VehicleFrame[0], 421339391);
    	TextDrawUseBox(TD_VehicleFrame[0], 1);
    	TextDrawSetProportional(TD_VehicleFrame[0], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[0], 0);

    TD_VehicleFrame[1] = TextDrawCreate(493.000000, 344.000000, "_");
    	TextDrawFont(TD_VehicleFrame[1], 1);
    	TextDrawLetterSize(TD_VehicleFrame[1], 0.600000, 8.399991);
    	TextDrawTextSize(TD_VehicleFrame[1], 306.500000, -4.000000);
    	TextDrawSetOutline(TD_VehicleFrame[1], 1);
    	TextDrawSetShadow(TD_VehicleFrame[1], 0);
    	TextDrawAlignment(TD_VehicleFrame[1], 2);
    	TextDrawColor(TD_VehicleFrame[1], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[1], 255);
    	TextDrawBoxColor(TD_VehicleFrame[1], -65281);
    	TextDrawUseBox(TD_VehicleFrame[1], 1);
    	TextDrawSetProportional(TD_VehicleFrame[1], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[1], 0);

    TD_VehicleFrame[2] = TextDrawCreate(558.900024, 423.000000, "_");
    	TextDrawFont(TD_VehicleFrame[2], 1);
    	TextDrawLetterSize(TD_VehicleFrame[2], 0.600000, -0.150000);
    	TextDrawTextSize(TD_VehicleFrame[2], 479.000000, 130.500000);
    	TextDrawSetOutline(TD_VehicleFrame[2], 1);
    	TextDrawSetShadow(TD_VehicleFrame[2], 0);
    	TextDrawAlignment(TD_VehicleFrame[2], 2);
    	TextDrawColor(TD_VehicleFrame[2], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[2], 255);
    	TextDrawBoxColor(TD_VehicleFrame[2], -65281);
    	TextDrawUseBox(TD_VehicleFrame[2], 1);
    	TextDrawSetProportional(TD_VehicleFrame[2], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[2], 0);

    TD_VehicleFrame[3] = TextDrawCreate(560.000000, 363.000000, "_");
    	TextDrawFont(TD_VehicleFrame[3], 1);
    	TextDrawLetterSize(TD_VehicleFrame[3], 0.600000, -0.150000);
    	TextDrawTextSize(TD_VehicleFrame[3], 479.000000, 130.500000);
    	TextDrawSetOutline(TD_VehicleFrame[3], 1);
    	TextDrawSetShadow(TD_VehicleFrame[3], 0);
    	TextDrawAlignment(TD_VehicleFrame[3], 2);
    	TextDrawColor(TD_VehicleFrame[3], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[3], 255);
    	TextDrawBoxColor(TD_VehicleFrame[3], -65281);
    	TextDrawUseBox(TD_VehicleFrame[3], 1);
    	TextDrawSetProportional(TD_VehicleFrame[3], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[3], 0);

    TD_VehicleFrame[4] = TextDrawCreate(558.900024, 342.000000, "_");
    	TextDrawFont(TD_VehicleFrame[4], 1);
    	TextDrawLetterSize(TD_VehicleFrame[4], 0.600000, -0.150000);
    	TextDrawTextSize(TD_VehicleFrame[4], 479.000000, 130.500000);
    	TextDrawSetOutline(TD_VehicleFrame[4], 1);
    	TextDrawSetShadow(TD_VehicleFrame[4], 0);
    	TextDrawAlignment(TD_VehicleFrame[4], 2);
    	TextDrawColor(TD_VehicleFrame[4], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[4], 255);
    	TextDrawBoxColor(TD_VehicleFrame[4], -65281);
    	TextDrawUseBox(TD_VehicleFrame[4], 1);
    	TextDrawSetProportional(TD_VehicleFrame[4], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[4], 0);

    TD_VehicleFrame[5] = TextDrawCreate(526.000000, 364.000000, "BRZINA:");
    	TextDrawFont(TD_VehicleFrame[5], 2);
    	TextDrawLetterSize(TD_VehicleFrame[5], 0.174998, 1.299998);
    	TextDrawTextSize(TD_VehicleFrame[5], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_VehicleFrame[5], 0);
    	TextDrawSetShadow(TD_VehicleFrame[5], 1);
    	TextDrawAlignment(TD_VehicleFrame[5], 3);
    	TextDrawColor(TD_VehicleFrame[5], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[5], 255);
    	TextDrawBoxColor(TD_VehicleFrame[5], 50);
    	TextDrawUseBox(TD_VehicleFrame[5], 0);
    	TextDrawSetProportional(TD_VehicleFrame[5], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[5], 0);

    TD_VehicleFrame[6] = TextDrawCreate(527.000000, 374.000000, "GORIVO:");
    	TextDrawFont(TD_VehicleFrame[6], 2);
    	TextDrawLetterSize(TD_VehicleFrame[6], 0.174998, 1.299998);
    	TextDrawTextSize(TD_VehicleFrame[6], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_VehicleFrame[6], 0);
    	TextDrawSetShadow(TD_VehicleFrame[6], 1);
    	TextDrawAlignment(TD_VehicleFrame[6], 3);
    	TextDrawColor(TD_VehicleFrame[6], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[6], 255);
    	TextDrawBoxColor(TD_VehicleFrame[6], 50);
    	TextDrawUseBox(TD_VehicleFrame[6], 0);
    	TextDrawSetProportional(TD_VehicleFrame[6], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[6], 0);

    TD_VehicleFrame[7] = TextDrawCreate(524.000000, 384.000000, "VRSTA:");
    	TextDrawFont(TD_VehicleFrame[7], 2);
    	TextDrawLetterSize(TD_VehicleFrame[7], 0.174998, 1.299998);
    	TextDrawTextSize(TD_VehicleFrame[7], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_VehicleFrame[7], 0);
    	TextDrawSetShadow(TD_VehicleFrame[7], 1);
    	TextDrawAlignment(TD_VehicleFrame[7], 3);
    	TextDrawColor(TD_VehicleFrame[7], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[7], 255);
    	TextDrawBoxColor(TD_VehicleFrame[7], 50);
    	TextDrawUseBox(TD_VehicleFrame[7], 0);
    	TextDrawSetProportional(TD_VehicleFrame[7], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[7], 0);

    TD_VehicleFrame[8] = TextDrawCreate(537.000000, 394.000000, "KILOMETRI:");
    	TextDrawFont(TD_VehicleFrame[8], 2);
    	TextDrawLetterSize(TD_VehicleFrame[8], 0.174998, 1.299998);
    	TextDrawTextSize(TD_VehicleFrame[8], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_VehicleFrame[8], 0);
    	TextDrawSetShadow(TD_VehicleFrame[8], 1);
    	TextDrawAlignment(TD_VehicleFrame[8], 3);
    	TextDrawColor(TD_VehicleFrame[8], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[8], 255);
    	TextDrawBoxColor(TD_VehicleFrame[8], 50);
    	TextDrawUseBox(TD_VehicleFrame[8], 0);
    	TextDrawSetProportional(TD_VehicleFrame[8], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[8], 0);

    TD_VehicleFrame[9] = TextDrawCreate(498.000000, 405.000000, "KVAROVI:");
    	TextDrawFont(TD_VehicleFrame[9], 2);
    	TextDrawLetterSize(TD_VehicleFrame[9], 0.174998, 1.299998);
    	TextDrawTextSize(TD_VehicleFrame[9], 400.000000, 17.000000);
    	TextDrawSetOutline(TD_VehicleFrame[9], 0);
    	TextDrawSetShadow(TD_VehicleFrame[9], 1);
    	TextDrawAlignment(TD_VehicleFrame[9], 1);
    	TextDrawColor(TD_VehicleFrame[9], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[9], 255);
    	TextDrawBoxColor(TD_VehicleFrame[9], 50);
    	TextDrawUseBox(TD_VehicleFrame[9], 0);
    	TextDrawSetProportional(TD_VehicleFrame[9], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[9], 0);

    TD_VehicleFrame[10] = TextDrawCreate(626.000000, 342.000000, "_");
    	TextDrawFont(TD_VehicleFrame[10], 1);
    	TextDrawLetterSize(TD_VehicleFrame[10], 0.600000, 8.849987);
    	TextDrawTextSize(TD_VehicleFrame[10], 306.500000, -4.000000);
    	TextDrawSetOutline(TD_VehicleFrame[10], 1);
    	TextDrawSetShadow(TD_VehicleFrame[10], 0);
    	TextDrawAlignment(TD_VehicleFrame[10], 2);
    	TextDrawColor(TD_VehicleFrame[10], -1);
    	TextDrawBackgroundColor(TD_VehicleFrame[10], 255);
    	TextDrawBoxColor(TD_VehicleFrame[10], -65281);
    	TextDrawUseBox(TD_VehicleFrame[10], 1);
    	TextDrawSetProportional(TD_VehicleFrame[10], 1);
    	TextDrawSetSelectable(TD_VehicleFrame[10], 0);

    TD_HudPoruka = TD_NewHud[20];
    TD_HappyJobStatus = TD_NewHud[23];
    InitAuthTextDraws();
    return 1;
}

stock GetJobName(jobid, name[], size)
{
    switch(jobid)
    {
        case 1: format(name, size, "Cistac ulica");
        case 2: format(name, size, "Postar");
        case 3: format(name, size, "Ribolovac");
        default: format(name, size, "USKORO");
    }
    return 1;
}

stock CalculateJobPayment(playerid, jobid, basePayment, file[])
{
    new payment = basePayment, message[144], jobName[32];
    GetJobName(jobid, jobName, sizeof(jobName));
    if(HappyJobId == jobid)
    {
        payment *= 2;
        format(message, sizeof(message), "[HAPPY JOB]: %s je aktivan. Dobili ste duplu platu.", jobName);
        SendClientMessage(playerid, 0xFFD700FF, message);
    }
    new key[32];
    format(key, sizeof(key), "JobZavrsetak_%d", jobid);
    new completed = DOF2_GetInt(file, key) + 1;
    if(completed >= 3)
    {
        completed = 0;
        payment += 500;
        format(message, sizeof(message), "[POSAO BONUS]: Tri puta ste zavrsili posao %s i dobili bonus od 500 RSD.", jobName);
        SendClientMessage(playerid, 0x00FF00FF, message);
    }
    DOF2_SetInt(file, key, completed);
    return payment;
}

public UpdateHudTip(tip)
{
    if(HappyJobId > 0)
    {
        new jobName[32], happyJobText[40];
        GetJobName(HappyJobId, jobName, sizeof(jobName));
        format(happyJobText, sizeof(happyJobText), "2x %s", jobName);
        TextDrawSetString(TD_HappyJobStatus, happyJobText);
    }
    else TextDrawSetString(TD_HappyJobStatus, "UGASENO");

    switch(tip)
    {
        case 0: TextDrawSetString(TD_HudPoruka, "POSLOVI I POMOC: /ASKQ");
        case 1: TextDrawSetString(TD_HudPoruka, "CUVAJ NOVAC U BANCI");
        case 2: TextDrawSetString(TD_HudPoruka, "POMOC ADMINA: /ASKQ");
        case 3: TextDrawSetString(TD_HudPoruka, "REDOVNO KUPUJ HRANU");
        case 4: TextDrawSetString(TD_HudPoruka, "RAZGOVOR ORGANIZACIJE: /F");
        case 5: TextDrawSetString(TD_HudPoruka, "NE OTKRIVAJ LOZINKU");
        case 6: TextDrawSetString(TD_HudPoruka, "POSJETI ZLATARU");
        case 7: TextDrawSetString(TD_HudPoruka, "ZAKLJUCAJ VOZILO: /LOCK");
        case 8: TextDrawSetString(TD_HudPoruka, "POZOVI MEHANICARA");
        case 9: TextDrawSetString(TD_HudPoruka, "POSTUJ SAOBRACAJNA PRAVILA");
        case 10: TextDrawSetString(TD_HudPoruka, "KOMANDE I POMOC: /HELP");
        case 11: TextDrawSetString(TD_HudPoruka, "POSTUJ ROLEPLAY PRAVILA");
        case 12: TextDrawSetString(TD_HudPoruka, "KUPI KUCU: /BUYHOUSE");
        case 13: TextDrawSetString(TD_HudPoruka, "CUVAJ NOVAC U KUCNOM SEFU");
        case 14: TextDrawSetString(TD_HudPoruka, "KUPI MOBILNI TELEFON");
        case 15: TextDrawSetString(TD_HudPoruka, "POSTAVI OGLAS: /SMSAD");
        case 16: TextDrawSetString(TD_HudPoruka, "PAZI SE POLICIJE");
        case 17: TextDrawSetString(TD_HudPoruka, "SARADUJ SA SVOJOM ORG");
        case 18: TextDrawSetString(TD_HudPoruka, "KORISTI ANIMACIJE ZA PROVOD");
        case 19: TextDrawSetString(TD_HudPoruka, "POSJETI BUTIK ODECE");
        case 20: TextDrawSetString(TD_HudPoruka, "ZAPOSLI SE I ZARADI");
        case 21: TextDrawSetString(TD_HudPoruka, "ISTRAZI POSLOVE NA MAPI");
        case 22: TextDrawSetString(TD_HudPoruka, "POLOZI VOZACKI ISPIT");
        case 23: TextDrawSetString(TD_HudPoruka, "IZVADI DOZVOLU ZA ORUZJE");
        case 24: TextDrawSetString(TD_HudPoruka, "NATOCI GORIVO: /FILL");
        case 25: TextDrawSetString(TD_HudPoruka, "POPRAVI VOZILO KOD MEHANICARA");
        case 26: TextDrawSetString(TD_HudPoruka, "BANKA CUVA TVOJ NOVAC");
        case 27: TextDrawSetString(TD_HudPoruka, "STEDI I KUPI BIZNIS");
        case 28: TextDrawSetString(TD_HudPoruka, "DRUZI SE S IGRACIMA NA TS3");
    }
    return 1;
}

stock CreateRevolutionPlayerHud(playerid)
{
    TD_HudDatum[playerid] = CreatePlayerTextDraw(playerid, 476.000000, 435.500000, "00.00.0000");
    	PlayerTextDrawFont(playerid, TD_HudDatum[playerid], 2);
    	PlayerTextDrawLetterSize(playerid, TD_HudDatum[playerid], 0.170827, 1.149999);
    	PlayerTextDrawTextSize(playerid, TD_HudDatum[playerid], 400.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_HudDatum[playerid], 0);
    	PlayerTextDrawSetShadow(playerid, TD_HudDatum[playerid], 0);
    	PlayerTextDrawAlignment(playerid, TD_HudDatum[playerid], 2);
    	PlayerTextDrawColor(playerid, TD_HudDatum[playerid], -1);
    	PlayerTextDrawBackgroundColor(playerid, TD_HudDatum[playerid], 255);
    	PlayerTextDrawBoxColor(playerid, TD_HudDatum[playerid], 50);
    	PlayerTextDrawUseBox(playerid, TD_HudDatum[playerid], 0);
    	PlayerTextDrawSetProportional(playerid, TD_HudDatum[playerid], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_HudDatum[playerid], 0);

    TD_HudVrijeme[playerid] = CreatePlayerTextDraw(playerid, 521.000000, 435.500000, "00:00");
    	PlayerTextDrawFont(playerid, TD_HudVrijeme[playerid], 2);
    	PlayerTextDrawLetterSize(playerid, TD_HudVrijeme[playerid], 0.170000, 1.149000);
    	PlayerTextDrawTextSize(playerid, TD_HudVrijeme[playerid], 400.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_HudVrijeme[playerid], 0);
    	PlayerTextDrawSetShadow(playerid, TD_HudVrijeme[playerid], 0);
    	PlayerTextDrawAlignment(playerid, TD_HudVrijeme[playerid], 2);
    	PlayerTextDrawColor(playerid, TD_HudVrijeme[playerid], -1);
    	PlayerTextDrawBackgroundColor(playerid, TD_HudVrijeme[playerid], 255);
    	PlayerTextDrawBoxColor(playerid, TD_HudVrijeme[playerid], 50);
    	PlayerTextDrawUseBox(playerid, TD_HudVrijeme[playerid], 0);
    	PlayerTextDrawSetProportional(playerid, TD_HudVrijeme[playerid], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_HudVrijeme[playerid], 0);

    TD_NovacPlavi[playerid] = CreatePlayerTextDraw(playerid, 497.000000, 105.000000, "~b~BANK: 000000000");
    	PlayerTextDrawFont(playerid, TD_NovacPlavi[playerid], 2);
    	PlayerTextDrawLetterSize(playerid, TD_NovacPlavi[playerid], 0.237498, 1.000000);
    	PlayerTextDrawTextSize(playerid, TD_NovacPlavi[playerid], 665.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_NovacPlavi[playerid], 1);
    	PlayerTextDrawSetShadow(playerid, TD_NovacPlavi[playerid], 0);
    	PlayerTextDrawAlignment(playerid, TD_NovacPlavi[playerid], 1);
    	PlayerTextDrawColor(playerid, TD_NovacPlavi[playerid], 1097458175);
    	PlayerTextDrawBackgroundColor(playerid, TD_NovacPlavi[playerid], 255);
    	PlayerTextDrawBoxColor(playerid, TD_NovacPlavi[playerid], 50);
    	PlayerTextDrawUseBox(playerid, TD_NovacPlavi[playerid], 0);
    	PlayerTextDrawSetProportional(playerid, TD_NovacPlavi[playerid], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_NovacPlavi[playerid], 0);

    TD_Euro[playerid] = CreatePlayerTextDraw(playerid, 497.000000, 117.000000, "~p~EURO: 000000000");
    	PlayerTextDrawFont(playerid, TD_Euro[playerid], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Euro[playerid], 0.237498, 1.000000);
    	PlayerTextDrawTextSize(playerid, TD_Euro[playerid], 665.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_Euro[playerid], 1);
    	PlayerTextDrawSetShadow(playerid, TD_Euro[playerid], 0);
    	PlayerTextDrawAlignment(playerid, TD_Euro[playerid], 1);
    	PlayerTextDrawColor(playerid, TD_Euro[playerid], -905198081);
    	PlayerTextDrawBackgroundColor(playerid, TD_Euro[playerid], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Euro[playerid], 50);
    	PlayerTextDrawUseBox(playerid, TD_Euro[playerid], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Euro[playerid], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Euro[playerid], 0);

    TD_Zlato[playerid] = CreatePlayerTextDraw(playerid, 497.000000, 129.000000, "~y~ZLATO: 00000000");
    	PlayerTextDrawFont(playerid, TD_Zlato[playerid], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Zlato[playerid], 0.237498, 1.000000);
    	PlayerTextDrawTextSize(playerid, TD_Zlato[playerid], 675.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_Zlato[playerid], 1);
    	PlayerTextDrawSetShadow(playerid, TD_Zlato[playerid], 0);
    	PlayerTextDrawAlignment(playerid, TD_Zlato[playerid], 1);
    	PlayerTextDrawColor(playerid, TD_Zlato[playerid], -65281);
    	PlayerTextDrawBackgroundColor(playerid, TD_Zlato[playerid], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Zlato[playerid], 50);
    	PlayerTextDrawUseBox(playerid, TD_Zlato[playerid], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Zlato[playerid], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Zlato[playerid], 0);

    TD_Grad[playerid] = CreatePlayerTextDraw(playerid, 497.000000, 141.000000, "BEOGRAD");
    	PlayerTextDrawFont(playerid, TD_Grad[playerid], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Grad[playerid], 0.237498, 1.000000);
    	PlayerTextDrawTextSize(playerid, TD_Grad[playerid], 400.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_Grad[playerid], 1);
    	PlayerTextDrawSetShadow(playerid, TD_Grad[playerid], 0);
    	PlayerTextDrawAlignment(playerid, TD_Grad[playerid], 1);
    	PlayerTextDrawColor(playerid, TD_Grad[playerid], -1);
    	PlayerTextDrawBackgroundColor(playerid, TD_Grad[playerid], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Grad[playerid], 50);
    	PlayerTextDrawUseBox(playerid, TD_Grad[playerid], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Grad[playerid], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Grad[playerid], 0);

    TD_Lokacija[playerid] = CreatePlayerTextDraw(playerid, 497.000000, 152.000000, "LOKACIJA");
    	PlayerTextDrawFont(playerid, TD_Lokacija[playerid], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Lokacija[playerid], 0.237498, 1.000000);
    	PlayerTextDrawTextSize(playerid, TD_Lokacija[playerid], 640.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_Lokacija[playerid], 1);
    	PlayerTextDrawSetShadow(playerid, TD_Lokacija[playerid], 0);
    	PlayerTextDrawAlignment(playerid, TD_Lokacija[playerid], 1);
    	PlayerTextDrawColor(playerid, TD_Lokacija[playerid], -1);
    	PlayerTextDrawBackgroundColor(playerid, TD_Lokacija[playerid], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Lokacija[playerid], 50);
    	PlayerTextDrawUseBox(playerid, TD_Lokacija[playerid], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Lokacija[playerid], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Lokacija[playerid], 0);

    TD_Vozilo[playerid][0] = CreatePlayerTextDraw(playerid, 617.000000, 345.000000, "- IME VOZILA -");
    	PlayerTextDrawFont(playerid, TD_Vozilo[playerid][0], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][0], 0.404166, 1.399999);
    	PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][0], 400.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][0], 0);
    	PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][0], 1);
    	PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][0], 3);
    	PlayerTextDrawColor(playerid, TD_Vozilo[playerid][0], -1);
    	PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][0], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][0], 50);
    	PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][0], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][0], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][0], 0);

    TD_Vozilo[playerid][1] = CreatePlayerTextDraw(playerid, 527.000000, 364.000000, "~g~40~w~KM/H");
    	PlayerTextDrawFont(playerid, TD_Vozilo[playerid][1], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][1], 0.174998, 1.299998);
    	PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][1], 680.000000, 14.500000);
    	PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][1], 0);
    	PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][1], 1);
    	PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][1], 1);
    	PlayerTextDrawColor(playerid, TD_Vozilo[playerid][1], 1433087999);
    	PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][1], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][1], 50);
    	PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][1], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][1], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][1], 0);

    TD_Vozilo[playerid][2] = CreatePlayerTextDraw(playerid, 527.000000, 374.000000, "~w~250.0/~r~250.0");
    	PlayerTextDrawFont(playerid, TD_Vozilo[playerid][2], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][2], 0.174998, 1.299998);
    	PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][2], 710.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][2], 0);
    	PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][2], 1);
    	PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][2], 1);
    	PlayerTextDrawColor(playerid, TD_Vozilo[playerid][2], 1433087999);
    	PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][2], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][2], 50);
    	PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][2], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][2], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][2], 0);

    TD_Vozilo[playerid][3] = CreatePlayerTextDraw(playerid, 525.000000, 384.000000, "BENZIN");
    	PlayerTextDrawFont(playerid, TD_Vozilo[playerid][3], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][3], 0.174998, 1.299998);
    	PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][3], 400.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][3], 0);
    	PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][3], 1);
    	PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][3], 1);
    	PlayerTextDrawColor(playerid, TD_Vozilo[playerid][3], -1);
    	PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][3], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][3], 50);
    	PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][3], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][3], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][3], 0);

    TD_Vozilo[playerid][4] = CreatePlayerTextDraw(playerid, 538.000000, 394.000000, "85590");
    	PlayerTextDrawFont(playerid, TD_Vozilo[playerid][4], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][4], 0.174998, 1.299998);
    	PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][4], 400.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][4], 0);
    	PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][4], 1);
    	PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][4], 1);
    	PlayerTextDrawColor(playerid, TD_Vozilo[playerid][4], -1);
    	PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][4], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][4], 50);
    	PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][4], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][4], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][4], 0);

    TD_Vozilo[playerid][5] = CreatePlayerTextDraw(playerid, 533.000000, 405.000000, "~w~5/~r~5");
    	PlayerTextDrawFont(playerid, TD_Vozilo[playerid][5], 2);
    	PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][5], 0.174998, 1.299998);
    	PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][5], 680.000000, 17.000000);
    	PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][5], 0);
    	PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][5], 1);
    	PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][5], 1);
    	PlayerTextDrawColor(playerid, TD_Vozilo[playerid][5], -1);
    	PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][5], 255);
    	PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][5], 50);
    	PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][5], 0);
    	PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][5], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][5], 0);

    TD_WantedHint[playerid] = CreatePlayerTextDraw(playerid, 310.000000, 352.000000, "~r~TRAZENI STE~n~~r~JURI VAS ~b~POLICIJA~n~~r~/DOSIJE");
    	PlayerTextDrawFont(playerid, TD_WantedHint[playerid], 2);
    	PlayerTextDrawLetterSize(playerid, TD_WantedHint[playerid], 0.320832, 1.250000);
    	PlayerTextDrawTextSize(playerid, TD_WantedHint[playerid], 415.000000, 159.500000);
    	PlayerTextDrawSetOutline(playerid, TD_WantedHint[playerid], 1);
    	PlayerTextDrawSetShadow(playerid, TD_WantedHint[playerid], 0);
    	PlayerTextDrawAlignment(playerid, TD_WantedHint[playerid], 2);
    	PlayerTextDrawColor(playerid, TD_WantedHint[playerid], -1962934017);
    	PlayerTextDrawBackgroundColor(playerid, TD_WantedHint[playerid], 255);
    	PlayerTextDrawBoxColor(playerid, TD_WantedHint[playerid], 50);
    	PlayerTextDrawUseBox(playerid, TD_WantedHint[playerid], 0);
    	PlayerTextDrawSetProportional(playerid, TD_WantedHint[playerid], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_WantedHint[playerid], 0);

    TD_WantedStars[playerid] = CreatePlayerTextDraw(playerid, 310.000000, 389.000000, "~y~]]]]]]");
    	PlayerTextDrawFont(playerid, TD_WantedStars[playerid], 2);
    	PlayerTextDrawLetterSize(playerid, TD_WantedStars[playerid], 0.358332, 1.549999);
    	PlayerTextDrawTextSize(playerid, TD_WantedStars[playerid], 415.000000, 159.500000);
    	PlayerTextDrawSetOutline(playerid, TD_WantedStars[playerid], 1);
    	PlayerTextDrawSetShadow(playerid, TD_WantedStars[playerid], 0);
    	PlayerTextDrawAlignment(playerid, TD_WantedStars[playerid], 2);
    	PlayerTextDrawColor(playerid, TD_WantedStars[playerid], -1962934017);
    	PlayerTextDrawBackgroundColor(playerid, TD_WantedStars[playerid], 255);
    	PlayerTextDrawBoxColor(playerid, TD_WantedStars[playerid], 50);
    	PlayerTextDrawUseBox(playerid, TD_WantedStars[playerid], 0);
    	PlayerTextDrawSetProportional(playerid, TD_WantedStars[playerid], 1);
    	PlayerTextDrawSetSelectable(playerid, TD_WantedStars[playerid], 0);

    VoziloHudShown[playerid] = false;
    return 1;
}

stock DestroyRevolutionPlayerHud(playerid)
{
    PlayerTextDrawDestroy(playerid, TD_HudDatum[playerid]);
    PlayerTextDrawDestroy(playerid, TD_HudVrijeme[playerid]);
    PlayerTextDrawDestroy(playerid, TD_WantedHint[playerid]);
    PlayerTextDrawDestroy(playerid, TD_WantedStars[playerid]);
    PlayerTextDrawDestroy(playerid, TD_NovacPlavi[playerid]);
    PlayerTextDrawDestroy(playerid, TD_Euro[playerid]);
    PlayerTextDrawDestroy(playerid, TD_Zlato[playerid]);
    PlayerTextDrawDestroy(playerid, TD_Grad[playerid]);
    PlayerTextDrawDestroy(playerid, TD_Lokacija[playerid]);
    for(new i = 0; i < 6; i++) PlayerTextDrawDestroy(playerid, TD_Vozilo[playerid][i]);
    VoziloHudShown[playerid] = false;
    return 1;
}

stock ShowRevolutionHud(playerid)
{
    TextDrawShowForPlayer(playerid, TD_NewHud[32]);
    TextDrawShowForPlayer(playerid, TD_NewHud[33]);
    PlayerTextDrawShow(playerid, TD_NovacPlavi[playerid]);
    PlayerTextDrawShow(playerid, TD_Euro[playerid]);
    PlayerTextDrawShow(playerid, TD_Zlato[playerid]);
    PlayerTextDrawShow(playerid, TD_Grad[playerid]);
    PlayerTextDrawShow(playerid, TD_Lokacija[playerid]);
    UpdateZlatoTD(playerid);
    UpdateWantedHint(playerid);
    return 1;
}

stock VehicleHudNoFuel(model)
{
    return (model == 481 || model == 509 || model == 510 || model == 449 ||
            model == 537 || model == 538 || model == 569 || model == 570 || model == 590);
}

stock VehicleHudIsTruck(model)
{
    return (model == 403 || model == 406 || model == 407 || model == 408 ||
            model == 414 || model == 416 || model == 428 || model == 431 ||
            model == 437 || model == 443 || model == 455 || model == 456 ||
            model == 498 || model == 499 || model == 514 || model == 515 ||
            model == 524 || model == 525 || model == 531 || model == 544 ||
            model == 552 || model == 578 || model == 582 || model == 588 || model == 609);
}

stock VehicleHudIsMotorcycle(model)
{
    return (model == 448 || model == 461 || model == 462 || model == 463 || model == 468 ||
            model == 471 || model == 481 || model == 509 || model == 510 || model == 521 ||
            model == 522 || model == 523 || model == 581 || model == 586);
}

stock VehicleHudIsAircraft(model)
{
    return (model == 417 || model == 425 || model == 447 || model == 460 || model == 469 ||
            model == 476 || model == 487 || model == 488 || model == 497 || model == 511 ||
            model == 512 || model == 513 || model == 519 || model == 520 || model == 548 ||
            model == 553 || model == 563 || model == 577 || model == 592 || model == 593);
}

stock VehicleHudIsPremiumGasoline(model)
{
    return (model == 402 || model == 411 || model == 415 || model == 429 || model == 434 ||
            model == 451 || model == 477 || model == 480 || model == 494 || model == 495 ||
            model == 502 || model == 503 || model == 506 || model == 541 || model == 555 ||
            model == 558 || model == 559 || model == 560 || model == 561 || model == 562 ||
            model == 565 || model == 587 || model == 589 || model == 602 || model == 603);
}

stock Float:VehicleHudFuelCapacity(model)
{
    if(VehicleHudNoFuel(model)) return 0.0;
    if(VehicleHudIsTruck(model) || VehicleHudIsAircraft(model)) return 250.0;
    switch(model % 4)
    {
        case 0: return 50.0;
        case 1: return 60.0;
        case 2: return 70.0;
    }
    return 80.0;
}

stock VehicleHudFuelType(model, output[], size)
{
    if(VehicleHudNoFuel(model)) format(output, size, "NEMA");
    else if(VehicleHudIsAircraft(model)) format(output, size, "KEROZIN");
    else if(VehicleHudIsMotorcycle(model)) format(output, size, "BENZIN");
    else if(VehicleHudIsTruck(model))
    {
        if(model % 2) format(output, size, "DIZEL");
        else format(output, size, "BENZIN");
    }
    else if(VehicleHudIsPremiumGasoline(model)) format(output, size, "BENZIN");
    else if(model % 3) format(output, size, "DIZEL");
    else format(output, size, "BENZIN");
    return 1;
}

CMD:dajpayday(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ovu komandu mogu koristiti samo administratori.");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0x00BFFFFF, "KORISTENJE: /dajpayday [ID/Ime]");
    if(!IsPlayerConnected(targetid) || !GetPVarInt(targetid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac nije prijavljen na server.");

    if(!DajPayDayRespekt(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: PayDay nije mogao biti dodijeljen.");

    new adminName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME], message[144];
    GetPlayerName(playerid, adminName, sizeof(adminName));
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(message, sizeof(message), "[PAYDAY TEST]: Admin %s je odmah dao PayDay igracu %s.", adminName, targetName);
    SendClientMessage(playerid, 0x33CCFFFF, message);
    if(targetid != playerid) SendClientMessage(targetid, 0x33CCFFFF, message);
    return 1;
}

stock VehicleHudDamageLevel(vehicleid)
{
    new Float:health;
    GetVehicleHealth(vehicleid, health);
    if(health < 300.0) return 5;
    if(health < 450.0) return 4;
    if(health < 600.0) return 3;
    if(health < 750.0) return 2;
    if(health < 900.0) return 1;
    return 0;
}

stock VehicleHudRepair(vehicleid)
{
    if(!RepairVehicle(vehicleid)) return 0;
    SetVehicleHealth(vehicleid, 1000.0);
    VehicleHudBrokenNotice[vehicleid] = false;
    VehicleHudStalled[vehicleid] = false;
    VehicleHudNextStartTry[vehicleid] = 0;
    VehicleHudNextStallAt[vehicleid] = 0;
    VehicleHudLastDamage[vehicleid] = 0;
    return 1;
}

stock VehicleHudUpdateSpeed(playerid, vehicleid)
{
    new Float:vx, Float:vy, Float:vz, label[12];
    GetVehicleVelocity(vehicleid, vx, vy, vz);
    new speed = floatround(floatsqroot(vx * vx + vy * vy + vz * vz) * 180.0);
    if(speed < 0) speed = 0;
    if(speed == VehicleHudLastSpeed[playerid]) return 1;
    format(label, sizeof(label), "~g~%d~w~KM/H", speed);
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][1], label);
    VehicleHudLastSpeed[playerid] = speed;
    return 1;
}

forward UpdateVehicleSpeed();
public UpdateVehicleSpeed()
{
    for(new p = 0; p < MAX_PLAYERS; p++)
    {
        if(!IsPlayerConnected(p)) continue;
        new playerState = GetPlayerState(p);
        if(playerState != PLAYER_STATE_DRIVER && playerState != PLAYER_STATE_PASSENGER) continue;

        new vehicleid = GetPlayerVehicleID(p);
        if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || !GetVehicleModel(vehicleid)) continue;

        // /veh vozila imaju N/A podatke i skripta im nikada ne mijenja fiziku.
        if(AdminSpawnedVehicle[vehicleid])
        {
            VehicleHudOutOfFuel[vehicleid] = false;
            VehicleHudBrokenNotice[vehicleid] = false;
            VehicleHudStalled[vehicleid] = false;
            VehicleHudNextStallAt[vehicleid] = 0;
            VehicleHudLastDamage[vehicleid] = 0;
            if(VoziloHudShown[p]) VehicleHudUpdateSpeed(p, vehicleid);
            continue;
        }

        if(playerState == PLAYER_STATE_DRIVER)
        {
            new damage = VehicleHudDamageLevel(vehicleid);
            new engine, lights, alarm, doors, bonnet, boot, objective;
            GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

            if(damage >= 5)
            {
                // Zaustavljanje se izvrsi samo jednom. Timer vise ne zakucava velocity svakih 150 ms.
                if(!VehicleHudBrokenNotice[vehicleid])
                {
                    if(engine != 0)
                        SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
                    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
                    SendClientMessage(p, 0xFF7777FF, "[VOZILO]: Kvarovi su 5/5. Motor je stao; vozilo treba popraviti.");
                    VehicleHudBrokenNotice[vehicleid] = true;
                }
                VehicleHudStalled[vehicleid] = true;
                VehicleHudNextStallAt[vehicleid] = 0;
            }
            else if(damage == 4)
            {
                VehicleHudBrokenNotice[vehicleid] = false;
                if(VehicleHudStalled[vehicleid])
                {
                    if(engine != 0)
                        SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
                }
                else
                {
                    new Float:vx, Float:vy, Float:vz;
                    GetVehicleVelocity(vehicleid, vx, vy, vz);
                    new Float:speed = floatsqroot(vx * vx + vy * vy + vz * vz) * 180.0;
                    if(engine == 1 || speed > 3.0)
                    {
                        if(VehicleHudNextStallAt[vehicleid] == 0)
                            VehicleHudNextStallAt[vehicleid] = gettime() + 15 + random(11);
                        if(gettime() >= VehicleHudNextStallAt[vehicleid])
                        {
                            SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
                            VehicleHudStalled[vehicleid] = true;
                            VehicleHudNextStallAt[vehicleid] = 0;
                            SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
                            SendClientMessage(p, 0xFF7777FF, "[VOZILO]: Motor se ugasio zbog kvarova (4/5). Pokusajte /engine.");
                        }
                    }
                }
            }
            else
            {
                // Kod 0-3 kvarova skripta samo prikazuje stanje i ne dira GTA fiziku vozila.
                VehicleHudBrokenNotice[vehicleid] = false;
                VehicleHudStalled[vehicleid] = false;
                VehicleHudNextStallAt[vehicleid] = 0;
            }
            VehicleHudLastDamage[vehicleid] = damage;
        }

        if(VoziloHudShown[p]) VehicleHudUpdateSpeed(p, vehicleid);
    }
    return 1;
}

// Stalna vozila imaju stabilan ID u Vozila.inc. Kilometraza pripada vozilu,
// ne vozacu, i zato ostaje ista kada se vozilo jednog dana proda drugom igracu.
stock VehicleHudSaveKm(vehicleid)
{
    if(vehicleid <= 0 || vehicleid > ZadnjePostarskoVozilo || !VehicleHudInitialized[vehicleid] || GetVehicleModel(vehicleid) == 0) return 0;
    new file[64];
    format(file, sizeof(file), "Kilometraza/%d.ini", vehicleid);
    if(!DOF2_FileExists(file)) DOF2_CreateFile(file);
    DOF2_SetInt(file, "Model", GetVehicleModel(vehicleid));
    DOF2_SetFloat(file, "Km", VehicleHudKm[vehicleid]);
    DOF2_SaveFile();
    return 1;
}

stock VehicleHudLoadKm(vehicleid)
{
    if(vehicleid <= 0 || vehicleid > ZadnjePostarskoVozilo) return 0;
    new file[64];
    format(file, sizeof(file), "Kilometraza/%d.ini", vehicleid);
    if(!DOF2_FileExists(file)) return 0;
    if(DOF2_GetInt(file, "Model") != GetVehicleModel(vehicleid)) return 0;
    VehicleHudKm[vehicleid] = DOF2_GetFloat(file, "Km");
    if(VehicleHudKm[vehicleid] < 0.0) VehicleHudKm[vehicleid] = 0.0;
    return 1;
}

public OnGameModeExit()
{
    for(new vehicleid = 1; vehicleid <= ZadnjePostarskoVozilo; vehicleid++)
        if(VehicleHudInitialized[vehicleid]) VehicleHudSaveKm(vehicleid);
    for(new i = 0; i < 13; i++) TextDrawDestroy(TD_Auth[i]);
    for(new i = 0; i <= 24; i++) TextDrawDestroy(TD_NewHud[i]);
    for(new i = 27; i <= 33; i++) TextDrawDestroy(TD_NewHud[i]);
    for(new i = 0; i < 11; i++) TextDrawDestroy(TD_VehicleFrame[i]);
    return 1;
}

stock VehicleHudInitData(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || GetVehicleModel(vehicleid) == 0) return 0;
    if(!VehicleHudInitialized[vehicleid])
    {
        VehicleHudInitialized[vehicleid] = true;
        VehicleHudFuel[vehicleid] = VehicleHudFuelCapacity(GetVehicleModel(vehicleid));
        VehicleHudKm[vehicleid] = 0.0;
        VehicleHudLoadKm(vehicleid);
        VehicleHudLastPosValid[vehicleid] = false;
        VehicleHudOutOfFuel[vehicleid] = false;
    }
    return 1;
}

stock VehicleHudStopForNoFuel(vehicleid)
{
    if(VehicleHudOutOfFuel[vehicleid]) return 1;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    VehicleHudOutOfFuel[vehicleid] = true;
    for(new p = 0; p < MAX_PLAYERS; p++)
        if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid))
            SendClientMessage(p, 0xFF7777FF, "[GORIVO]: Rezervoar je prazan. Zaustavite se i upisite /fill.");
    return 1;
}

stock VehicleHudHide(playerid)
{
    if(!VoziloHudShown[playerid]) return 0;
    for(new i = 0; i < 11; i++) TextDrawHideForPlayer(playerid, TD_VehicleFrame[i]);
    for(new i = 0; i < 6; i++) PlayerTextDrawHide(playerid, TD_Vozilo[playerid][i]);
    VoziloHudShown[playerid] = false;
    VehicleHudLastSpeed[playerid] = -1;
    return 1;
}

stock VehicleHudShow(playerid)
{
    if(VoziloHudShown[playerid]) return 0;
    for(new i = 0; i < 11; i++) TextDrawShowForPlayer(playerid, TD_VehicleFrame[i]);
    for(new i = 0; i < 6; i++) PlayerTextDrawShow(playerid, TD_Vozilo[playerid][i]);
    VoziloHudShown[playerid] = true;
    VehicleHudLastSpeed[playerid] = -1;
    return 1;
}

stock VehicleHudUpdatePlayer(playerid, vehicleid)
{
    new model = GetVehicleModel(vehicleid);
    if(model < 400 || model > 611) return VehicleHudHide(playerid);
    new name[32], label[64], fuelType[16], Float:fuelCapacity = VehicleHudFuelCapacity(model);
    if(VehicleHudFuel[vehicleid] > fuelCapacity) VehicleHudFuel[vehicleid] = fuelCapacity;
    format(name, sizeof(name), "%s", VehicleHudModelNames[model - 400]);
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][0], name);
    VehicleHudUpdateSpeed(playerid, vehicleid);
    if(AdminSpawnedVehicle[vehicleid])
    {
        VehicleHudOutOfFuel[vehicleid] = false;
        PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][2], "N/A");
        PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][3], "N/A");
        PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][4], "N/A");
        PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][5], "N/A");
        VehicleHudShow(playerid);
        return 1;
    }
    format(label, sizeof(label), "~w~%.1f/~r~%.1f", VehicleHudFuel[vehicleid], fuelCapacity);
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][2], label);
    VehicleHudFuelType(model, fuelType, sizeof(fuelType));
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][3], fuelType);
    format(label, sizeof(label), "%d", floatround(VehicleHudKm[vehicleid], floatround_floor));
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][4], label);
    format(label, sizeof(label), "~w~%d/~r~5", VehicleHudDamageLevel(vehicleid));
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][5], label);
    VehicleHudShow(playerid);
    return 1;
}

forward UpdateVehicleHud();
public UpdateVehicleHud()
{
    for(new p = 0; p < MAX_PLAYERS; p++)
    {
        if(!IsPlayerConnected(p)) continue;
        new playerState = GetPlayerState(p);
        if(playerState != PLAYER_STATE_DRIVER && playerState != PLAYER_STATE_PASSENGER)
        {
            VehicleHudHide(p);
            continue;
        }
        new vehicleid = GetPlayerVehicleID(p);
        if(!VehicleHudInitData(vehicleid))
        {
            VehicleHudHide(p);
            continue;
        }
        if(AdminSpawnedVehicle[vehicleid])
        {
            VehicleHudOutOfFuel[vehicleid] = false;
            VehicleHudLastPosValid[vehicleid] = false;
            VehicleHudUpdatePlayer(p, vehicleid);
            continue;
        }
        if(VehicleHudFuel[vehicleid] > 0.0) VehicleHudOutOfFuel[vehicleid] = false;
        if(playerState == PLAYER_STATE_DRIVER)
        {
            new Float:x, Float:y, Float:z;
            GetVehiclePos(vehicleid, x, y, z);
            if(VehicleHudLastPosValid[vehicleid])
            {
                new Float:dx = x - VehicleHudLastX[vehicleid];
                new Float:dy = y - VehicleHudLastY[vehicleid];
                new Float:dz = z - VehicleHudLastZ[vehicleid];
                new Float:metres = floatsqroot(dx * dx + dy * dy + dz * dz);
                if(metres < 100.0 && metres > 0.1)
                {
                    new oldTenthKm = floatround(VehicleHudKm[vehicleid] * 10.0, floatround_floor);
                    VehicleHudKm[vehicleid] += metres / 1000.0;
                    if(floatround(VehicleHudKm[vehicleid] * 10.0, floatround_floor) > oldTenthKm)
                        VehicleHudSaveKm(vehicleid);
                    if(!VehicleHudNoFuel(GetVehicleModel(vehicleid)) && VehicleHudFuel[vehicleid] > 0.0)
                    {
                        new engine, lights, alarm, doors, bonnet, boot, objective;
                        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                        if(engine == 1 || engine == -1)
                        {
                            VehicleHudFuel[vehicleid] -= metres * 0.00016; // 16 litara / 100 km.
                            if(VehicleHudFuel[vehicleid] <= 0.0)
                            {
                                VehicleHudFuel[vehicleid] = 0.0;
                                VehicleHudStopForNoFuel(vehicleid);
                            }
                        }
                    }
                }
            }
            VehicleHudLastX[vehicleid] = x;
            VehicleHudLastY[vehicleid] = y;
            VehicleHudLastZ[vehicleid] = z;
            VehicleHudLastPosValid[vehicleid] = true;
        }
        VehicleHudUpdatePlayer(p, vehicleid);
    }
    return 1;
}

CMD:fill(playerid, params[])
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return SendClientMessage(playerid, 0xFF7777FF, "[GORIVO]: Morate biti vozac vozila.");
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!VehicleHudInitData(vehicleid))
        return SendClientMessage(playerid, 0xFF7777FF, "[GORIVO]: Vozilo nije dostupno.");
    if(AdminSpawnedVehicle[vehicleid])
        return SendClientMessage(playerid, 0x33CCFFFF, "[GORIVO]: Privremeno /veh vozilo ima beskonacno gorivo.");
    if(VehicleHudNoFuel(GetVehicleModel(vehicleid)))
        return SendClientMessage(playerid, 0xFF7777FF, "[GORIVO]: Ovo vozilo ne koristi gorivo.");
    new Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);
    if(floatsqroot(vx * vx + vy * vy + vz * vz) * 180.0 > 3.0)
        return SendClientMessage(playerid, 0xFF7777FF, "[GORIVO]: Zaustavite vozilo prije tocenja.");
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if(engine == 1)
        return SendClientMessage(playerid, 0xFF7777FF, "[GORIVO]: Prvo ugasite motor komandom /engine.");
    new Float:fuelCapacity = VehicleHudFuelCapacity(GetVehicleModel(vehicleid));
    new Float:missing = fuelCapacity - VehicleHudFuel[vehicleid];
    if(missing < 0.1)
        return SendClientMessage(playerid, 0xFF7777FF, "[GORIVO]: Rezervoar je vec pun.");
    new price = floatround(missing * 10.0, floatround_ceil);
    if(GetPlayerMoney(playerid) < price)
        return SendClientMessage(playerid, 0xFF7777FF, "[GORIVO]: Nemate dovoljno RSD za pun rezervoar.");
    GivePlayerMoney(playerid, -price);
    PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
    VehicleHudFuel[vehicleid] = fuelCapacity;
    VehicleHudOutOfFuel[vehicleid] = false;
    new name[MAX_PLAYER_NAME], file[128], message[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
        DOF2_SaveFile();
    }
    format(message, sizeof(message), "[GORIVO]: Natoceno %.1f litara za %d RSD. Upalite motor komandom /engine.", missing, price);
    SendClientMessage(playerid, 0x33CCFFFF, message);
    VehicleHudUpdatePlayer(playerid, vehicleid);
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
    {
        VehicleHudFuel[vehicleid] = VehicleHudFuelCapacity(GetVehicleModel(vehicleid));
        VehicleHudLastPosValid[vehicleid] = false;
        VehicleHudOutOfFuel[vehicleid] = false;
        if(!VehicleHudInitialized[vehicleid]) VehicleHudLoadKm(vehicleid);
        VehicleHudInitialized[vehicleid] = true;
        VehicleHudBrokenNotice[vehicleid] = false;
        VehicleHudStalled[vehicleid] = false;
        VehicleHudNextStartTry[vehicleid] = 0;
        VehicleHudNextStallAt[vehicleid] = 0;
        VehicleHudLastDamage[vehicleid] = 0;
    }
    return 1;
}

stock UpdateRevolutionHudData(playerid)
{
    new hour, minute, second, day, month, year, label[64];
    gettime(hour, minute, second);
    if(minute != LastHudMinute[playerid])
    {
        getdate(year, month, day);
        format(label, sizeof(label), "%02d.%02d.%04d", day, month, year);
        PlayerTextDrawSetString(playerid, TD_HudDatum[playerid], label);
        format(label, sizeof(label), "%02d:%02d", hour, minute);
        PlayerTextDrawSetString(playerid, TD_HudVrijeme[playerid], label);
        LastHudMinute[playerid] = minute;
    }
    if(!GetPVarInt(playerid, "BR_LoggedIn")) return 0;
    new ime[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    if(DOF2_FileExists(file))
    {
        new bank = DOF2_IsSet(file, "Banka") ? DOF2_GetInt(file, "Banka") : 0;
        UpdateBankaTD(playerid, bank);
        new euro = DOF2_IsSet(file, "Euro") ? DOF2_GetInt(file, "Euro") : 0;
        format(label, sizeof(label), "~p~EURO: %d", euro);
        PlayerTextDrawSetString(playerid, TD_Euro[playerid], label);
        PlayerTextDrawShow(playerid, TD_Euro[playerid]);
    }
    return 1;
}

CMD:time(playerid, params[])
{
    // Provjera da li igrac posjeduje sat
    if(PlayerSat[playerid] == 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Nemate rucni sat! Morate ga kupiti u zlatari da biste videli vrijeme.");
        return 1;
    }

    // Uzimamo trenutno server vrijeme
    new sat, minut, sekund;
    gettime(sat, minut, sekund);

    // Formatiranje i slanje poruke igracu u chat
    new string[128];
    format(string, sizeof(string), "[Balkan Revolution]: Tacno vrijeme na va?em satu je: {FFFF00}%02d:%02d:%02d", sat, minut, sekund);
    SendClientMessage(playerid, 0x00BFFFFF, string);

    // Ako ?eli? da mu se pojavi i krupno na sred ekrana (GameText), otkomentari?i liniju ispod:
    // GameTextForPlayer(playerid, string, 3000, 3);

    return 1;
}
CMD:setleader(playerid, params[])
{
    new targetid, orgid;
    if(sscanf(params, "ud", targetid, orgid))
        return SendClientMessage(playerid, 0xFF0000FF, "[Koristenje]: /setleader [ID/Ime] [ID Organizacije (0-19)]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Taj igrac nije online!");

    if(orgid < 0 || orgid > 19)
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: ID organizacije mora biti izmedu 0 i 19!");

    new targetName[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetName, sizeof(targetName));

    new lideri_file[64] = "BalkanRP/Lideri.ini";

    if(!DOF2_FileExists(lideri_file))
    {
        DOF2_CreateFile(lideri_file);
        for(new i = 0; i < 19; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i + 1);
            DOF2_SetString(lideri_file, key, "Nema");
        }
        DOF2_SaveFile();
    }

    for(new i = 0; i < 19; i++)
    {
        new key[32];
        format(key, sizeof(key), "Lider_%d", i + 1);
        if(DOF2_IsSet(lideri_file, key))
        {
            new current_lider[MAX_PLAYER_NAME];
            format(current_lider, sizeof(current_lider), "%s", DOF2_GetString(lideri_file, key));
            if(!strcmp(current_lider, targetName, true))
            {
                DOF2_SetString(lideri_file, key, "Nema");
            }
        }
    }

    new novi_skin = 299;
    new org_ime_set[32];
    format(org_ime_set, sizeof(org_ime_set), "Nema");

    if(orgid > 0)
    {
        new key[32];
        format(key, sizeof(key), "Lider_%d", orgid);
        DOF2_SetString(lideri_file, key, targetName);

        switch(orgid)
        {
            case 1:  { novi_skin = 283; format(org_ime_set, sizeof(org_ime_set), "Policija"); }
            case 2:  { novi_skin = 287; format(org_ime_set, sizeof(org_ime_set), "Vojska"); }
            case 3:  { novi_skin = 286; format(org_ime_set, sizeof(org_ime_set), "?andarmerija"); }
            case 4:  { novi_skin = 61;  format(org_ime_set, sizeof(org_ime_set), "Taxi slu?ba"); }
            case 5:  { novi_skin = 70;  format(org_ime_set, sizeof(org_ime_set), "Hitna Pomoc"); }
            case 6:  { novi_skin = 261; format(org_ime_set, sizeof(org_ime_set), "Novinari"); }
            case 7:  { novi_skin = 15;  format(org_ime_set, sizeof(org_ime_set), "Parking Servis"); }
            case 8:  { novi_skin = 23;  format(org_ime_set, sizeof(org_ime_set), "Hitman"); }
            case 9:  { novi_skin = 295; format(org_ime_set, sizeof(org_ime_set), "La Cosa Nostra"); }
            case 10: { novi_skin = 44;  format(org_ime_set, sizeof(org_ime_set), "GHS"); }
            case 11: { novi_skin = 228; format(org_ime_set, sizeof(org_ime_set), "Yamaguchi"); }
            case 12: { novi_skin = 113; format(org_ime_set, sizeof(org_ime_set), "Ruska Mafija"); }
            case 13: { novi_skin = 270; format(org_ime_set, sizeof(org_ime_set), "Groove Street Family"); }
            case 14: { novi_skin = 296; format(org_ime_set, sizeof(org_ime_set), "Ballas Family"); }
            case 15: { novi_skin = 110; format(org_ime_set, sizeof(org_ime_set), "MS-13"); }
            case 16: { novi_skin = 173; format(org_ime_set, sizeof(org_ime_set), "Los Surenos"); }
            case 17: { novi_skin = 299; format(org_ime_set, sizeof(org_ime_set), "Privatna Organizacija 1"); }
            case 18: { novi_skin = 22;  format(org_ime_set, sizeof(org_ime_set), "Privatne Organizacija 2"); }
            case 19: { novi_skin = 258; format(org_ime_set, sizeof(org_ime_set), "Bajkeri"); }
        }
    }

    DOF2_SaveFile();

    new player_file[128];
    format(player_file, sizeof(player_file), "Korisnici/%s.ini", targetName);
    if(DOF2_FileExists(player_file))
    {
        DOF2_SetInt(player_file, "Lider", orgid);
        DOF2_SetInt(player_file, "Skin", novi_skin);
        DOF2_SaveFile();
    }

    PlayerInfo[targetid][pLider] = orgid;
    if(orgid > 0) PlayerOrg[targetid] = orgid;
    else
    {
        // Kad se skine lider, ostaje njegova stvarna clanska organizacija.
        PlayerOrg[targetid] = 0;
        if(DOF2_FileExists(player_file))
        {
            PlayerOrg[targetid] = DOF2_GetInt(player_file, "Clan");
            if(PlayerOrg[targetid] == 0) PlayerOrg[targetid] = DOF2_GetInt(player_file, "Member");
        }
    }
    SetPlayerSkin(targetid, novi_skin);

    new string[140];
    if(orgid == 0)
    {
        format(string, sizeof(string), "[Balkan Revolution]: Vlasnik vam je skinuo lider poziciju.");
        SendClientMessage(targetid, 0x00BFFFFF, string);
        format(string, sizeof(string), "[Balkan Revolution]: Uspje?no ste skinuli lidera igracu %s.", targetName);
        SendClientMessage(playerid, 0x00BFFFFF, string);
    }
    else
    {
        format(string, sizeof(string), "[Balkan Revolution]: Cestitamo! Postali ste Lider organizacije %s.", org_ime_set);
        SendClientMessage(targetid, 0x00BFFFFF, string);

        format(string, sizeof(string), "[Balkan Revolution]: Uspje?no ste postavili lidera igracu %s organizacije %s.", targetName, org_ime_set);
        SendClientMessage(playerid, 0x00BFFFFF, string);
    }
    return 1;
}
forward IzvrsiKick(playerid);
public IzvrsiKick(playerid)
{
    Kick(playerid);
    return 1;
}
CMD:goto(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Samo admin moze koristiti /goto.");
    new destination, targetid;
    if(sscanf(params, "uu", destination, targetid))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /goto [kod koga] [koga]");
    if(!IsPlayerConnected(destination) || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Oba igraca moraju biti online.");
    if(destination == targetid)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Odaberite dva razlicita igraca.");
    if(GetPlayerState(destination) == PLAYER_STATE_WASTED || GetPlayerState(destination) == PLAYER_STATE_NONE)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac kod kojeg teleportujete mora biti ziv i spawnovan.");
    if(GetPlayerState(targetid) == PLAYER_STATE_WASTED || GetPlayerState(targetid) == PLAYER_STATE_NONE)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac kojeg teleportujete mora biti ziv i spawnovan.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(destination, x, y, z);
    new interior = GetPlayerInterior(destination);
    new world = GetPlayerVirtualWorld(destination);
    if(GetPlayerState(targetid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(targetid))
    {
        new vehicleid = GetPlayerVehicleID(targetid);
        if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || GetVehicleModel(vehicleid) == 0)
            return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Vozilo igraca nije dostupno.");

        // Vozac vodi svoje vozilo i sve putnike; sacuvaj sjedista prije promjene svijeta.
        new occupants[MAX_PLAYERS], seats[MAX_PLAYERS], count = 0;
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(!IsPlayerConnected(p) || !IsPlayerInVehicle(p, vehicleid)) continue;
            occupants[count] = p;
            seats[count] = GetPlayerVehicleSeat(p);
            count++;
        }
        SetVehicleVirtualWorld(vehicleid, world);
        LinkVehicleToInterior(vehicleid, interior);
        for(new i = 0; i < count; i++)
        {
            SetPlayerInterior(occupants[i], interior);
            SetPlayerVirtualWorld(occupants[i], world);
        }
        SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
        SetVehiclePos(vehicleid, x + 3.0, y, z + 0.5);
        for(new i = 0; i < count; i++)
        {
            if(!IsPlayerInVehicle(occupants[i], vehicleid))
                PutPlayerInVehicle(occupants[i], vehicleid, seats[i]);
            SetCameraBehindPlayer(occupants[i]);
        }
        VehicleHudLastPosValid[vehicleid] = false; // Teleport se ne racuna u kilometrazu.
    }
    else
    {
        // Suvozac i ostali putnici idu sami, bez premjestanja vozila i drugih igraca.
        if(IsPlayerInAnyVehicle(targetid)) RemovePlayerFromVehicle(targetid);
        SetPlayerInterior(targetid, interior);
        SetPlayerVirtualWorld(targetid, world);
        SetPlayerPos(targetid, x + 1.5, y, z + 0.3);
        SetCameraBehindPlayer(targetid);
    }

    new destName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME], message[128];
    GetPlayerName(destination, destName, sizeof(destName));
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(message, sizeof(message), "[ADMIN]: Teleportovali ste %s do %s.", targetName, destName);
    SendClientMessage(playerid, 0x00BFFFFF, message);
    format(message, sizeof(message), "[ADMIN]: Teleportovani ste do %s.", destName);
    SendClientMessage(targetid, 0x00BFFFFF, message);
    return 1;
}

CMD:kill(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Samo admin moze koristiti /kill.");
    new targetid, reason[80];
    if(sscanf(params, "us[80]", targetid, reason))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /kill [ID/Ime] [Razlog]");
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac nije online.");
    if(GetPlayerState(targetid) == PLAYER_STATE_WASTED || GetPlayerState(targetid) == PLAYER_STATE_NONE)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac je vec mrtav ili nije spawnovan.");
    new adminName[MAX_PLAYER_NAME], targetName[MAX_PLAYER_NAME], message[144];
    GetPlayerName(playerid, adminName, sizeof(adminName));
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(message, sizeof(message), "[ADMIN]: %s je ubio igraca %s. Razlog: %s", adminName, targetName, reason);
    SendClientMessageToAll(0xFF7777FF, message);
    SetPlayerHealth(targetid, 0.0);
    return 1;
}

CMD:setskin(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Samo admin moze koristiti /setskin.");
    new targetid, skinid;
    if(sscanf(params, "ui", targetid, skinid))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /setskin [ID/Ime] [ID Skina]");
    if(!IsPlayerConnected(targetid) || !GetPVarInt(targetid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac nije prijavljen i online.");
    if(skinid < 0 || skinid > 311 || skinid == 74)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Validni skinovi su 0-311, osim ID 74.");
    if(GetPlayerState(targetid) != PLAYER_STATE_ONFOOT || IsPlayerInAnyVehicle(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac mora biti ziv i van vozila za promjenu skina.");
    new name[MAX_PLAYER_NAME], file[128], message[128];
    GetPlayerName(targetid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nalog igraca nije pronaden.");
    if(GetPlayerSpecialAction(targetid) == SPECIAL_ACTION_DUCK)
    {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(targetid, x, y, z);
        SetPlayerPos(targetid, x, y, z);
    }
    ClearAnimations(targetid);
    SetPlayerSkin(targetid, skinid);
    PlayerCurrentSkin[targetid] = skinid;
    DOF2_SetInt(file, "Skin", skinid);
    DOF2_SaveFile();
    format(message, sizeof(message), "[ADMIN]: Postavili ste skin %d igracu %s.", skinid, name);
    SendClientMessage(playerid, 0x00BFFFFF, message);
    format(message, sizeof(message), "[ADMIN]: Vas skin je postavljen na ID %d.", skinid);
    SendClientMessage(targetid, 0x00BFFFFF, message);
    return 1;
}

CMD:slap(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    new admin_lvl = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;

    // Ovde je promijenjeno sa 9 na 1, ?to znaci da svaki admin (level 1+) mo?e koristiti komandu
    if(!IsPlayerAdmin(playerid) && admin_lvl < 1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new targetid, razlog[128];
    if(sscanf(params, "us[128]", targetid, razlog)) return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /slap [ID/DeoImena] [Razlog]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF0000FF, "Taj igrac trenutno nije na serveru.");

    new targetName[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetName, sizeof(targetName));
    GetPlayerName(playerid, adminName, sizeof(adminName));

    if(targetid != playerid && strcmp(targetName, "Rile", true) == 0 && !IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Ne mozete o?amariti Vlasnika servera!");
        return 1;
    }

    // Podi?emo igraca u zrak (slap efekat)
    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(targetid, x, y, z + 5.0); // di?e ga 5 metara u vis

    // Poruka direktno o?amarenom igracu u tra?enom formatu i sa istom bojom
    new igrac_poruka[128];
    format(igrac_poruka, sizeof(igrac_poruka), "Osamareni ste od strane AdminTeama. Razlog: %s", razlog);
    SendClientMessage(targetid, 0xFA8072FF, igrac_poruka);

    // Javna obavijest svima
    new javnaporuka[144];
    format(javnaporuka, sizeof(javnaporuka), "Igrac %s je osamaren od strane AdminTeama. Razlog: %s", targetName, razlog);
    SendClientMessageToAll(0xFA8072FF, javnaporuka);

    AddPlayerSavedStat(targetid, "AdminKazne", 1);
    return 1;
}
CMD:gov(playerid, params[])
{
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    if(isnull(params)) return SendClientMessage(playerid, -1, "Koristenje: /gov [Obavjestenje]");

    new name[MAX_PLAYER_NAME], file[128], orgid, rank, bool:isLeader = false;
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    if(!DOF2_FileExists(file)) return SendClientMessage(playerid, 0xFF7777FF, "[GOV]: Vas nalog nije pronaden.");
    orgid = DOF2_GetInt(file, "Member");
    rank = DOF2_GetInt(file, "Rank");

    new leadersFile[64] = "BalkanRP/Lideri.ini";
    if(DOF2_FileExists(leadersFile))
    {
        for(new i = 1; i <= 3; i++)
        {
            new key[24], leaderName[MAX_PLAYER_NAME];
            format(key, sizeof(key), "Lider_%d", i);
            if(!DOF2_IsSet(leadersFile, key)) continue;
            format(leaderName, sizeof(leaderName), "%s", DOF2_GetString(leadersFile, key));
            if(!strcmp(leaderName, name, true))
            {
                orgid = i;
                isLeader = true;
                break;
            }
        }
    }
    if(orgid < 1 || orgid > 3 || (!isLeader && rank < 4))
        return SendClientMessage(playerid, 0xFF7777FF, "[GOV]: Komandu mogu koristiti sefovi i zamjenici Policije, Vojske i Zandarmerije.");

    new orgName[24], title[48], message[256];
    switch(orgid)
    {
        case 1: format(orgName, sizeof(orgName), "Policije");
        case 2: format(orgName, sizeof(orgName), "Vojske");
        case 3: format(orgName, sizeof(orgName), "Zandarmerije");
    }
    if(isLeader) format(title, sizeof(title), "Sef %s", orgName);
    else format(title, sizeof(title), "Zamjenik Sefa %s", orgName);
    SendClientMessageToAll(0xFFFFFFFF, "|____________ Obavje?tenje za Gradane ____________|");
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(HasAdminCommandAccess(i))
            format(message, sizeof(message), "{3377FF}%s %s[%d]: {FFFFFF}%s", title, name, playerid, params);
        else
            format(message, sizeof(message), "{3377FF}%s %s: {FFFFFF}%s", title, name, params);
        SendClientMessage(i, 0xFFFFFFFF, message);
    }
    return 1;
}

CMD:l(playerid, params[])
{
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    // Provjeravamo admin nivo direktno iz njegovog fajla
    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    new admin_lvl = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;

    // Provjeravamo direktno u Lideri.ini da li je igrac upisan kao lider
    new is_lider = 0;
    new org_id = 0;
    new lideri_file[64] = "BalkanRP/Lideri.ini";

    if(DOF2_FileExists(lideri_file))
    {
        for(new i = 1; i <= 19; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name, true) == 0)
                {
                    is_lider = 1;
                    org_id = i; // Prona?li smo tacan ID organizacije iz master fajla!
                    break;
                }
            }
        }
    }

    // Provjera ko mo?e pisati: Vlasnik (Rile), Lideri (is_lider == 1) ili Admini (admin_lvl >= 1)
    if(strcmp(name, "Rile", true) != 0 && is_lider == 0 && admin_lvl < 1)
    {
        return SendClientMessage(playerid, 0xFF0000FF, "Niste lider niti ovla?teno osoblje!");
    }

    new tekst[128];
    if(sscanf(params, "s[128]", tekst))
        return SendClientMessage(playerid, -1, "Koristi: /l [tekst]");

    new string[256], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    // Formatiranje poruke u zavisnosti od toga ko pi?e
    if(strcmp(ime, "Rile", true) == 0 || admin_lvl == 9)
    {
        format(string, sizeof(string), "{FF00FF}[Lider Chat] Vlasnik %s: %s", ime, tekst);
    }
    else if(admin_lvl >= 1)
    {
        new adminNaziv[32];

        if(admin_lvl == 8) format(adminNaziv, sizeof(adminNaziv), "Suvlasnik");
        else if(admin_lvl == 7) format(adminNaziv, sizeof(adminNaziv), "Direktor");
        else if(admin_lvl == 6) format(adminNaziv, sizeof(adminNaziv), "Head Admin");
        else format(adminNaziv, sizeof(adminNaziv), "Admin");

        format(string, sizeof(string), "{FF00FF}[Lider Chat] %s %s: %s", adminNaziv, ime, tekst);
    }
    else
    {
        new orgIme[64];
        switch(org_id)
        {
            case 1: format(orgIme, sizeof(orgIme), "Policije");
            case 2: format(orgIme, sizeof(orgIme), "Vojske");
            case 3: format(orgIme, sizeof(orgIme), "Zandarmerije");
            case 4: format(orgIme, sizeof(orgIme), "Taxi sluzbe");
            case 5: format(orgIme, sizeof(orgIme), "Hitne Pomoci");
            case 6: format(orgIme, sizeof(orgIme), "Novinara");
            case 7: format(orgIme, sizeof(orgIme), "Parking Servisa");
            case 8: format(orgIme, sizeof(orgIme), "Hitmana");
            case 9: format(orgIme, sizeof(orgIme), "La Cosa Nostre");
            case 10: format(orgIme, sizeof(orgIme), "GHS-a");
            case 11: format(orgIme, sizeof(orgIme), "Yamaguchija");
            case 12: format(orgIme, sizeof(orgIme), "Ruske Mafije");
            case 13: format(orgIme, sizeof(orgIme), "Groove Street Family-a");
            case 14: format(orgIme, sizeof(orgIme), "Ballas Family-a");
            case 15: format(orgIme, sizeof(orgIme), "MS-13");
            case 16: format(orgIme, sizeof(orgIme), "Los Surenosa");
            case 17: format(orgIme, sizeof(orgIme), "Privatne Organizacije 1");
            case 18: format(orgIme, sizeof(orgIme), "Privatne Organizacije 2");
            case 19: format(orgIme, sizeof(orgIme), "Bajkera");
            default: format(orgIme, sizeof(orgIme), "Nepoznato");
        }
        format(string, sizeof(string), "{FF00FF}[Lider Chat] Lider %s, %s: %s", orgIme, ime, tekst);
    }

    // Slanje poruke svima koji su lideri, admini ili vlasnik
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new pName[MAX_PLAYER_NAME];
            GetPlayerName(i, pName, sizeof(pName));

            // Provjeravamo admin nivo za primatelja
            new target_file[128];
            format(target_file, sizeof(target_file), "Korisnici/%s.ini", pName);
            new target_admin_lvl = DOF2_FileExists(target_file) ? DOF2_GetInt(target_file, "Admin") : 0;

            // Provjeravamo da li je primatelj lider preko Lideri.ini fajla
            new target_is_lider = 0;
            if(DOF2_FileExists(lideri_file))
            {
                for(new j = 1; j <= 19; j++)
                {
                    new key[32];
                    format(key, sizeof(key), "Lider_%d", j);
                    if(DOF2_IsSet(lideri_file, key))
                    {
                        new l_name[MAX_PLAYER_NAME];
                        format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                        if(strcmp(l_name, pName, true) == 0)
                        {
                            target_is_lider = 1;
                            break;
                        }
                    }
                }
            }

            if(target_is_lider == 1 || target_admin_lvl >= 1 || strcmp(pName, "Rile", true) == 0)
            {
                SendClientMessage(i, 0xFF00FFFF, string);
            }
        }
    }
    return 1;
}
CMD:gethere(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    new admin_lvl = DOF2_FileExists(file) ? DOF2_GetInt(file, "Admin") : 0;

    // Dozvoljava RCON adminima, vlasniku (Rile) i svim adminima od levela 1 pa nadalje
    if(!IsPlayerAdmin(playerid) && admin_lvl < 1 && strcmp(ime, "Rile", true) != 0)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovla?tenje!");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /gethere [ID/DeoImena]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "Taj igrac trenutno nije na serveru.");
    if(targetid == playerid)
        return SendClientMessage(playerid, 0xFF0000FF, "Ne mo?ete portati sami sebe!");

    new targetName[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetName, sizeof(targetName));

    // Uzimamo poziciju, enterijer i virtuelni svijet admina
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new interior = GetPlayerInterior(playerid);
    new world = GetPlayerVirtualWorld(playerid);

    // Postavljamo igraca na adminovu poziciju (sa malim pomakom po X osi da ne padnu jedno kroz drugo)
    SetPlayerInterior(targetid, interior);
    SetPlayerVirtualWorld(targetid, world);
    SetPlayerPos(targetid, x + 1.5, y, z);

    // Poruka igracu
    SendClientMessage(targetid, 0xFA8072FF, "Teleportovani ste od strane Admina.");

    // Poruka adminu
    new admin_poruka[128];
    format(admin_poruka, sizeof(admin_poruka), "Teleportovali ste igraca %s do sebe.", targetName);
    SendClientMessage(playerid, 0x00FF00FF, admin_poruka);

    return 1;
}
CMD:b(playerid, params[])
{
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    new tekst[128];
    if(sscanf(params, "s[128]", tekst))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /b [OOC tekst]");

    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    new chatFile[128], chatAdmin = 0, chatHelper = 0, chatColor = 0xC2C2C2FF;
    format(chatFile, sizeof(chatFile), "Korisnici/%s.ini", ime);
    if(DOF2_FileExists(chatFile))
    {
        chatAdmin = DOF2_GetInt(chatFile, "Admin");
        chatHelper = DOF2_GetInt(chatFile, "Helper");
    }

    // Formatiranje poruke u lokalnom OOC stilu sa skrivenim staff imenom.
    new string[256], adminString[256];
    if(JuniorSpectating[playerid] && chatAdmin > 0)
    {
        format(string, sizeof(string), "(( Administrator kaze: %s ))", tekst);
        format(adminString, sizeof(adminString), "%s", string);
        chatColor = 0x000000FF;
    }
    else if(JuniorSpectating[playerid] && chatHelper > 0)
    {
        format(string, sizeof(string), "(( Helper kaze: %s ))", tekst);
        format(adminString, sizeof(adminString), "%s", string);
        chatColor = 0x000000FF;
    }
    else
    {
        format(string, sizeof(string), "(( %s: %s ))", ime, tekst);
        format(adminString, sizeof(adminString), "(( [%d] %s: %s ))", playerid, ime, tekst);
    }

    // Uzimamo poziciju, virtuelni svijet i enterijer igraca koji pi?e
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new playerVW = GetPlayerVirtualWorld(playerid);
    new playerInterior = GetPlayerInterior(playerid);

    // Petlja koja prolazi kroz sve igrace i ?alje poruku samo onima u blizini
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            // Provjera da li je igrac u istom virtuelnom svijetu i enterijeru
            if(GetPlayerVirtualWorld(i) == playerVW && GetPlayerInterior(i) == playerInterior)
            {
                // Provjera udaljenosti (u krugu od 20 metara)
                if(IsPlayerInRangeOfPoint(i, 20.0, x, y, z))
                {
                    if(HasAdminCommandAccess(i)) SendClientMessage(i, chatColor, adminString);
                    else SendClientMessage(i, chatColor, string);
                }
            }
        }
    }
    return 1;
}
CMD:me(playerid, params[])
{
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    new tekst[128];
    if(sscanf(params, "s[128]", tekst))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /me [Akcija]");

    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    new string[256];
    format(string, sizeof(string), "* %s %s", ime, tekst);

    // Uzimamo poziciju, virtuelni svijet i enterijer
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new playerVW = GetPlayerVirtualWorld(playerid);
    new playerInterior = GetPlayerInterior(playerid);

    // ?aljemo poruku samo igracima u blizini (20 metara)
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(GetPlayerVirtualWorld(i) == playerVW && GetPlayerInterior(i) == playerInterior)
            {
                if(IsPlayerInRangeOfPoint(i, 20.0, x, y, z))
                {
                    // Svjetlo plava boja (0x33CCFFFF)
                    SendClientMessage(i, 0x33CCFFFF, string);
                }
            }
        }
    }
    return 1;
}
CMD:do(playerid, params[])
{
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    new tekst[128];
    if(sscanf(params, "s[128]", tekst))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /do [Opis okoline/situacije]");

    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    new string[256];
    format(string, sizeof(string), "* %s (( %s ))", tekst, ime);

    // Uzimamo poziciju, virtuelni svijet i enterijer
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new playerVW = GetPlayerVirtualWorld(playerid);
    new playerInterior = GetPlayerInterior(playerid);

    // ?aljemo poruku samo igracima u blizini (20 metara)
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(GetPlayerVirtualWorld(i) == playerVW && GetPlayerInterior(i) == playerInterior)
            {
                if(IsPlayerInRangeOfPoint(i, 20.0, x, y, z))
                {
                    // Svjetlo plava boja (0x33CCFFFF)
                    SendClientMessage(i, 0x33CCFFFF, string);
                }
            }
        }
    }
    return 1;
}
CMD:member(playerid, params[])
{
    return PrikaziClanoveOrganizacije(playerid);
}

stock PrikaziClanoveOrganizacije(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    // Citamo podatke direktno iz licnog fajla igraca
    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Gre?ka pri ucitavanju va?eg fajla!");

    new orgid = DOF2_GetInt(file, "Member"); // Cita organizaciju iz fajla

    // Ako nije upisan kao clan, provjeravamo da li je lider u Lideri.ini
    if(orgid == 0)
    {
        new lideri_file[64] = "BalkanRP/Lideri.ini";
        if(DOF2_FileExists(lideri_file))
        {
            for(new i = 1; i <= 20; i++)
            {
                new key[32];
                format(key, sizeof(key), "Lider_%d", i);
                if(DOF2_IsSet(lideri_file, key))
                {
                    new l_name[MAX_PLAYER_NAME];
                    format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                    if(strcmp(l_name, name, true) == 0)
                    {
                        orgid = i;
                        break;
                    }
                }
            }
        }
    }

    // Ako i dalje nema organizaciju, prekida se bez slanja poruke da gleda spisak
    if(orgid == 0)
    {
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Niste clan niti lider nijedne organizacije!");
    }

    // TEK SADA KADA SMO SIGURNI DA JE CLAN/LIDER, ?ALJEMO PORUKU U CHAT
    new string_chat[128];
    format(string_chat, sizeof(string_chat), "{33CCFF}[Balkan Revolution]: %s je otvorio spisak clanova i gleda. (/member)", name);
    SendClientMessage(playerid, 0x33CCFFFF, string_chat);

    // Definisanje imena organizacije na osnovu ID-ja (uskladeno sa /invite)
    new org_name[32];
    switch(orgid)
    {
        case 1: format(org_name, sizeof(org_name), "Policije");
        case 2: format(org_name, sizeof(org_name), "Vojske");
        case 3: format(org_name, sizeof(org_name), "Zandarmerije");
        case 4: format(org_name, sizeof(org_name), "Taxi slu?be");
        case 5: format(org_name, sizeof(org_name), "Hitne Pomoci");
        case 6: format(org_name, sizeof(org_name), "Novinara");
        case 7: format(org_name, sizeof(org_name), "Parking Servisa");
        case 8: format(org_name, sizeof(org_name), "Hitmana");
        case 9: format(org_name, sizeof(org_name), "La Cosa Nostre");
        case 10: format(org_name, sizeof(org_name), "GHS-a");
        case 11: format(org_name, sizeof(org_name), "Yamaguchija");
        case 12: format(org_name, sizeof(org_name), "Ruske Mafije");
        case 13: format(org_name, sizeof(org_name), "Groove Street Family-a");
        case 14: format(org_name, sizeof(org_name), "Ballas Family-a");
        case 15: format(org_name, sizeof(org_name), "MS-13");
        case 16: format(org_name, sizeof(org_name), "Los Surenosa");
        case 17: format(org_name, sizeof(org_name), "Privatne Organizacije 1");
        case 18: format(org_name, sizeof(org_name), "Privatne Organizacije 2");
        case 19: format(org_name, sizeof(org_name), "Bajkera");
        default: format(org_name, sizeof(org_name), "Organizacije");
    }

    new dialog_string[2048];

    // --- 1. DIO: ONLINE CLANOVI ---
    new header_online[128];
    format(header_online, sizeof(header_online), "{FFFFFF}BR Clanovi %s (Online):\n", org_name);
    strcat(dialog_string, header_online);

    new online_count = 0;
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new pName[MAX_PLAYER_NAME];
            GetPlayerName(i, pName, sizeof(pName));

            new p_file[128];
            format(p_file, sizeof(p_file), "Korisnici/%s.ini", pName);

            new p_org = DOF2_FileExists(p_file) ? DOF2_GetInt(p_file, "Member") : 0;
            new p_rank = DOF2_FileExists(p_file) ? DOF2_GetInt(p_file, "Rank") : 0;
            new is_lider = 0;

            new l_file[64] = "BalkanRP/Lideri.ini";
            if(DOF2_FileExists(l_file))
            {
                new key[32];
                format(key, sizeof(key), "Lider_%d", orgid);
                if(DOF2_IsSet(l_file, key))
                {
                    new l_name[MAX_PLAYER_NAME];
                    format(l_name, sizeof(l_name), "%s", DOF2_GetString(l_file, key));
                    if(strcmp(l_name, pName, true) == 0)
                    {
                        p_org = orgid;
                        is_lider = 1;
                    }
                }
            }

            if(p_org == orgid)
            {
                new line[128];
                if(is_lider)
                {
                    format(line, sizeof(line), "{00FF00}[ID %d] {FFFFFF}%s | {FFFFFF}Lider\n", i, pName);
                }
                else
                {
                    format(line, sizeof(line), "{00FF00}[ID %d] {FFFFFF}%s | {FFFFFF}Rank: %d\n", i, pName, p_rank);
                }
                strcat(dialog_string, line);
                online_count++;
            }
        }
    }

    if(online_count == 0)
    {
        strcat(dialog_string, "{FF0000}Nema online clanova ove organizacije.\n");
    }

    // --- 2. DIO: SPISAK SVIH SLOTOVA ---
    new header_slots[128];
    format(header_slots, sizeof(header_slots), "\n{FFFFFF}[SPISAK SVIH CLANOVA - %s (SLOTOVI)]\n========================================\n", org_name);
    strcat(dialog_string, header_slots);

    new org_file[64];
    format(org_file, sizeof(org_file), "BalkanRP/Org_%d.ini", orgid);

    if(!DOF2_FileExists(org_file))
    {
        DOF2_CreateFile(org_file);
        for(new s = 0; s < 30; s++)
        {
            new key[32];
            format(key, sizeof(key), "Slot_%d", s);
            DOF2_SetString(org_file, key, "Nema");
        }
        DOF2_SaveFile();
    }

    for(new s = 0; s < 30; s++)
    {
        new key[32];
        format(key, sizeof(key), "Slot_%d", s);

        new member_name[MAX_PLAYER_NAME];
        if(DOF2_IsSet(org_file, key))
        {
            format(member_name, sizeof(member_name), "%s", DOF2_GetString(org_file, key));
        }
        else
        {
            format(member_name, sizeof(member_name), "Nema");
        }

        new slot_line[128];
        format(slot_line, sizeof(slot_line), "[SLOT %d]: {FFFFFF}%s\n", s, member_name);
        strcat(dialog_string, slot_line);
    }

    new dialog_title[64];
    format(dialog_title, sizeof(dialog_title), "BR Clanovi - %s", org_name);

    ShowPlayerDialog(playerid, DIALOG_ORG_MEMBERS, DIALOG_STYLE_MSGBOX, dialog_title, dialog_string, "Ok", "");
    return 1;
}
CMD:invite(playerid, params[])
{
    new targetid, slotid;
    if(sscanf(params, "dd", targetid, slotid))
        return SendClientMessage(playerid, 0x33CCFFFF, "[Balkan Revolution]: Koristi: /invite [ID Igraca] [Broj Slota (0-29)]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Taj igrac nije online!");

    if(slotid < 0 || slotid > 29)
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Broj slota mora biti izmedu 0 i 29!");

    new name[MAX_PLAYER_NAME], targetname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    GetPlayerName(targetid, targetname, sizeof(targetname));

    // PROVJERA LIDERSKE KAZNE U FAJLU IGRACA
    new target_file_check[128];
    format(target_file_check, sizeof(target_file_check), "Korisnici/%s.ini", targetname);
    if(DOF2_FileExists(target_file_check))
    {
        if(DOF2_GetInt(target_file_check, "OrgKazna") == 1)
        {
            SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Ovaj igrac ima aktivnu lidersku kaznu i ne moze uci u organizaciju!");

            new msg_kazna[128];
            format(msg_kazna, sizeof(msg_kazna), "{33CCFF}Ne mozete postat clan Organizacije dok ne platite kaznu u Opstini /skiniorgkaznu");
            SendClientMessage(targetid, 0x33CCFFFF, msg_kazna);
            return 1;
        }
    }

    // Provjera levela igraca (mora imati minimalno level 3)
    if(GetPlayerScore(targetid) < 3)
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Taj igrac mora biti minimalno level 3 da bi u?ao u organizaciju!");

    // Provjera organizacije lidera
    new lideri_file[64] = "BalkanRP/Lideri.ini";
    new orgid = 0;

    if(DOF2_FileExists(lideri_file))
    {
        for(new i = 1; i <= 20; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name, true) == 0)
                {
                    orgid = i;
                    break;
                }
            }
        }
    }

    if(orgid == 0)
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Niste lider nijedne organizacije!");

    // Definisanje svih tvojih organizacija prema ID-ju
    new org_name[32];
    switch(orgid)
    {
        case 1: format(org_name, sizeof(org_name), "Policije");
        case 2: format(org_name, sizeof(org_name), "Vojske");
        case 3: format(org_name, sizeof(org_name), "Zandarmerije");
        case 4: format(org_name, sizeof(org_name), "Taxi sluzbe");
        case 5: format(org_name, sizeof(org_name), "Hitne Pomoci");
        case 6: format(org_name, sizeof(org_name), "Novinara");
        case 7: format(org_name, sizeof(org_name), "Parking Servisa");
        case 8: format(org_name, sizeof(org_name), "Hitmana");
        case 9: format(org_name, sizeof(org_name), "La Cosa Nostre");
        case 10: format(org_name, sizeof(org_name), "GHS-a");
        case 11: format(org_name, sizeof(org_name), "Yamaguchija");
        case 12: format(org_name, sizeof(org_name), "Ruske Mafije");
        case 13: format(org_name, sizeof(org_name), "Groove Street Family-a");
        case 14: format(org_name, sizeof(org_name), "Ballas Family-a");
        case 15: format(org_name, sizeof(org_name), "MS-13");
        case 16: format(org_name, sizeof(org_name), "Los Surenosa");
        case 17: format(org_name, sizeof(org_name), "Privatne Organizacije 1");
        case 18: format(org_name, sizeof(org_name), "Privatne Organizacije 2");
        case 19: format(org_name, sizeof(org_name), "Bajkera");
        default: format(org_name, sizeof(org_name), "Organizacije");
    }

    // Provjera org fajla
    new org_file[64];
    format(org_file, sizeof(org_file), "BalkanRP/Org_%d.ini", orgid);

    if(!DOF2_FileExists(org_file)) DOF2_CreateFile(org_file);

    new slot_key[32];
    format(slot_key, sizeof(slot_key), "Slot_%d", slotid);

    if(DOF2_IsSet(org_file, slot_key))
    {
        new current_holder[MAX_PLAYER_NAME];
        format(current_holder, sizeof(current_holder), "%s", DOF2_GetString(org_file, slot_key));
        if(strcmp(current_holder, "Nema", true) != 0)
            return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Slot je vec zauzet!");
    }

    // Upisivanje u organizacijski slot
    DOF2_SetString(org_file, slot_key, targetname);
    DOF2_SaveFile();

    // Upisivanje u licni fajl igraca
    new target_file[128];
    format(target_file, sizeof(target_file), "Korisnici/%s.ini", targetname);
    DOF2_SetInt(target_file, "Member", orgid);
    DOF2_SetInt(target_file, "Rank", 1);

    // Ako je Taxi u pitanju, automatski mu postavljamo skin 259
    if(orgid == 4)
    {
        DOF2_SetInt(target_file, "Skin", 259);
        SetPlayerSkin(targetid, 259);
    }
    // Ako je Parking Servis u pitanju, automatski mu postavljamo skin 16
    else if(orgid == 7)
    {
        DOF2_SetInt(target_file, "Skin", 16);
        SetPlayerSkin(targetid, 16);
    }

    DOF2_SaveFile();

    // Ispis lideru u svijetlo plavoj boji
    new msg_lider[128];
    format(msg_lider, sizeof(msg_lider), "{33CCFF}Ubacili ste igraca %s na slot %d (/member)", targetname, slotid);
    SendClientMessage(playerid, 0x33CCFFFF, msg_lider);

    // Ispis igracu u svijetlo plavoj boji
    new msg1[128], msg2[128];
    format(msg1, sizeof(msg1), "{33CCFF}Ubaceni ste u organizaciju od strane Lidera %s.", name);
    format(msg2, sizeof(msg2), "{33CCFF}Sada ste clan organizacije %s.", org_name);
    SendClientMessage(targetid, 0x33CCFFFF, msg1);
    SendClientMessage(targetid, 0x33CCFFFF, msg2);

    return 1;
}
CMD:uninvite(playerid, params[])
{
    new targetid, slotid;
    if(sscanf(params, "dd", targetid, slotid))
        return SendClientMessage(playerid, 0x33CCFFFF, "[Balkan Revolution]: Koristi: /uninvite [ID Igraca] [Broj Slota (0-29)]");

    if(slotid < 0 || slotid > 29)
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Broj slota mora biti izmedu 0 i 29!");

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    // Provjera organizacije lidera iz Lideri.ini (isto kao u /invite i /member)
    new lideri_file[64] = "BalkanRP/Lideri.ini";
    new orgid = 0;

    if(DOF2_FileExists(lideri_file))
    {
        for(new i = 1; i <= 20; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name, true) == 0)
                {
                    orgid = i;
                    break;
                }
            }
        }
    }

    // Ako igrac nije lider nijedne organizacije, prekida se
    if(orgid == 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Niste lider nijedne organizacije!");

    // Definisanje imena organizacije
    new org_name[32];
    switch(orgid)
    {
        case 1: format(org_name, sizeof(org_name), "Policije");
        case 2: format(org_name, sizeof(org_name), "Vojske");
        case 3: format(org_name, sizeof(org_name), "Zandarmerije");
        case 4: format(org_name, sizeof(org_name), "Taxi sluzbe");
        case 5: format(org_name, sizeof(org_name), "Hitne Pomoci");
        case 6: format(org_name, sizeof(org_name), "Novinara");
        case 7: format(org_name, sizeof(org_name), "Parking Servisa");
        case 8: format(org_name, sizeof(org_name), "Hitmana");
        case 9: format(org_name, sizeof(org_name), "La Cosa Nostre");
        case 10: format(org_name, sizeof(org_name), "GHS-a");
        case 11: format(org_name, sizeof(org_name), "Yamaguchija");
        case 12: format(org_name, sizeof(org_name), "Ruske Mafije");
        case 13: format(org_name, sizeof(org_name), "Groove Street Family-a");
        case 14: format(org_name, sizeof(org_name), "Ballas Family-a");
        case 15: format(org_name, sizeof(org_name), "MS-13");
        case 16: format(org_name, sizeof(org_name), "Los Surenosa");
        case 17: format(org_name, sizeof(org_name), "Privatne Organizacije 1");
        case 18: format(org_name, sizeof(org_name), "Privatne Organizacije 2");
        case 19: format(org_name, sizeof(org_name), "Bajkera");
        default: format(org_name, sizeof(org_name), "Organizacije");
    }

    // Otvaramo fajl organizacije da nademo ko je na tom slotu
    new org_file[64];
    format(org_file, sizeof(org_file), "BalkanRP/Org_%d.ini", orgid);

    if(!DOF2_FileExists(org_file))
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Gre?ka: Fajl organizacije ne postoji!");

    new slot_key[32];
    format(slot_key, sizeof(slot_key), "Slot_%d", slotid);

    if(!DOF2_IsSet(org_file, slot_key))
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Taj slot je vec prazan!");

    new targetname[MAX_PLAYER_NAME];
    format(targetname, sizeof(targetname), "%s", DOF2_GetString(org_file, slot_key));

    if(strcmp(targetname, "Nema", true) == 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Na tom slotu nema nikoga!");

    // Bri?emo igraca sa tog slota u organizaciji (postavljamo na "Nema")
    DOF2_SetString(org_file, slot_key, "Nema");
    DOF2_SaveFile();

    // Bri?emo mu organizaciju u njegovom licnom fajlu (Member na 0, Rank na 0)
    new target_file[128];
    format(target_file, sizeof(target_file), "Korisnici/%s.ini", targetname);
    if(DOF2_FileExists(target_file))
    {
        DOF2_SetInt(target_file, "Member", 0);
        DOF2_SetInt(target_file, "Rank", 0);
        DOF2_SaveFile();
    }

    // Poruka lideru (Svijetlo plava boja)
    new msg_lider[128];
    format(msg_lider, sizeof(msg_lider), "{33CCFF}Izbacili ste igraca %s iz organizacije.", targetname);
    SendClientMessage(playerid, 0x33CCFFFF, msg_lider);

    // Poruka igracu ako je online (Svijetlo plava boja)
    if(IsPlayerConnected(targetid))
    {
        new msg_target[128];
        format(msg_target, sizeof(msg_target), "{33CCFF}Izbaceni ste od strane Lidera %s iz organizacije %s.", name, org_name);
        SendClientMessage(targetid, 0x33CCFFFF, msg_target);
    }

    return 1;
}
CMD:orghelp(playerid, params[])
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    // 1. Citamo podatke igraca iz njegovog fajla
    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Gre?ka pri ucitavanju va?eg fajla!");

    new orgid = DOF2_GetInt(file, "Member");
    new is_lider = 0;

    // 2. Provjeravamo da li je igrac lider u Lideri.ini
    new lideri_file[64] = "BalkanRP/Lideri.ini";
    if(DOF2_FileExists(lideri_file))
    {
        for(new i = 1; i <= 20; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name, true) == 0)
                {
                    orgid = i;
                    is_lider = 1;
                    break;
                }
            }
        }
    }

    // Ako igrac nije ni clan ni lider nijedne organizacije
    if(orgid == 0)
    {
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Niste clan niti lider nijedne organizacije!");
    }

    new dialog_string[3000];
    dialog_string[0] = EOS;

    strcat(dialog_string, "{FFFFFF}---------------- {FF0000}POMOC ZA ORGANIZACIJU {FFFFFF}----------------\n\n");

    // Ako je LIDER, prikazujemo mu liderske komande (/invite, /uninvite itd.)
    if(is_lider)
    {
        strcat(dialog_string, "{00BFFF}=== LIDER KOMANDE ===\n");
        strcat(dialog_string, "/invite - Da ubacite clana u Organizaciju\n");
        strcat(dialog_string, "/uninvite - Da izbacite clana iz Organizacije\n");
        strcat(dialog_string, "/member - Da vidite spisak svih clanova u Organizaciji\n");
        strcat(dialog_string, "/kazniclana - Da izbacite clana iz Ogranizacije sa Kaznom\n\n");

        // Ako je lider TAXI organizacije (ID 4) dodajemo mu i taxi komande
        if(orgid == 4)
        {
            strcat(dialog_string, "{00BFFF}=== TAXI KOMANDE ===\n");
            strcat(dialog_string, "{00BFFF}/duty {FFFFFF}[cjena voznje] - Da budete Taxi na duznosti\n");
            strcat(dialog_string, "{00BFFF}/acceptfaren {FFFFFF}- Da prihvatite voznju\n");
            strcat(dialog_string, "{00BFFF}/f {FFFFFF}- Org chat (komunikacija sa clanovima)\n");
            strcat(dialog_string, "{00BFFF}/d {FFFFFF}- Department chat (komunikacija sa dr?avnim slu?bama)\n\n");
        }
    }

    // Ako je clan dr?avnih organa (Policija, Vojska, ?andarmerija - ID 1, 2, 3) ili njihov lider
    if(orgid == 1 || orgid == 2 || orgid == 3)
    {
        strcat(dialog_string, "{00BFFF}=== DR?AVNE / POLICIJSKE KOMANDE ===\n");
        strcat(dialog_string, "{00BFFF}/cuff {FFFFFF}- Da stavite lisice igracu\n");
        strcat(dialog_string, "{00BFFF}/drag {FFFFFF}- Da izbacite igraca iz vozila\n");
        strcat(dialog_string, "{00BFFF}/pu {FFFFFF}- Da ubacite igraca u svoje vozilo\n");
        strcat(dialog_string, "{00BFFF}/su {FFFFFF}[ID/Ime] [1-6] [Razlog] - Dajte igracu Wanted Level\n");
        strcat(dialog_string, "{00BFFF}/fs {FFFFFF}[ID/Ime] - Pratite trazenog igraca na mapi\n");
        strcat(dialog_string, "{00BFFF}/bk {FFFFFF}- Da postavite barikade\n");
        strcat(dialog_string, "{00BFFF}/pretresi {FFFFFF}- Da pretreses igraca\n");
        strcat(dialog_string, "{00BFFF}/oduzmi {FFFFFF}- Da oduzmes igracu ilegalne supstance\n");
        strcat(dialog_string, "{00BFFF}/wl {FFFFFF}- Da vidite spisak igraca koji imaju Wanted Level\n");
        strcat(dialog_string, "{00BFFF}/dajwl {FFFFFF}- Da date Wanted Level igracu\n");
        strcat(dialog_string, "{00BFFF}/f {FFFFFF}- Org chat\n");
        strcat(dialog_string, "{00BFFF}/d {FFFFFF}- Department chat\n\n");

        // Opis/Upozorenje za policijske komande
        strcat(dialog_string, "{FF0000}Opis:\nSvako iskoristavanje ovih komandi nepotrebno mo?ete biti ka?njeni!\n\n");
    }
    else if(!is_lider)
    {
        // Za obicne clanove ostalih organizacija (Taxi, Hitna, Novinari...) koji NISU lideri
        if(orgid == 4)
        {
            strcat(dialog_string, "{00BFFF}=== TAXI KOMANDE ===\n");
            strcat(dialog_string, "{00BFFF}/duty {FFFFFF}[cjena voznje] - Da budete Taxi na duznosti\n");
            strcat(dialog_string, "{00BFFF}/acceptfaren {FFFFFF}- Da prihvatite voznju\n");
            strcat(dialog_string, "{00BFFF}/f {FFFFFF}- Org chat\n");
            strcat(dialog_string, "{00BFFF}/d {FFFFFF}- Department chat\n\n");
        }
        else if(orgid >= 1 && orgid <= 7) // Za ostale dr?avne/javne slu?be koje nemaju posebne komande iznad, a koriste /f i /d
        {
            strcat(dialog_string, "{00BFFF}=== SLU?BENE KOMANDE ===\n");
            strcat(dialog_string, "{00BFFF}/f {FFFFFF}- Org chat\n");
            strcat(dialog_string, "{00BFFF}/d {FFFFFF}- Department chat\n\n");
        }
        else
        {
            strcat(dialog_string, "{00BFFF}=== CLANSKE KOMANDE ===\n");
            strcat(dialog_string, "{FFFFFF}Trenutno nemate dodatnih specificnih komandi za svoju organizaciju.\n\n");
        }
    }

    // Samo LIDERI dobijaju onaj ugovor na dnu
    if(is_lider)
    {
        strcat(dialog_string, "{FF0000}Opis :\n");
        strcat(dialog_string, "{FFFFFF}Ugovor Lidera organizacije traje 3 dana, ukoliko skinete Lidera ranije bicete ka?njeni i mo?ete zavr?iti na Black Listi Lidera.");
    }

    ShowPlayerDialog(playerid, DIALOG_ORG_HELP, DIALOG_STYLE_MSGBOX, "{00BFFF}Organizacija - Pomoc (/orghelp)", dialog_string, "U redu", "");
    return 1;
}
CMD:kazniclana(playerid, params[])
{
    new targetid, slotid;
    if(sscanf(params, "dd", targetid, slotid))
        return SendClientMessage(playerid, 0x33CCFFFF, "[Balkan Revolution]: Koristi: /kazniclana [ID Igraca] [Broj Slota (0-29)]");

    if(slotid < 0 || slotid > 29)
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Broj slota mora biti izmedu 0 i 29!");

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    // Provjera organizacije lidera
    new lideri_file[64] = "BalkanRP/Lideri.ini";
    new orgid = 0;

    if(DOF2_FileExists(lideri_file))
    {
        for(new i = 1; i <= 20; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name, true) == 0)
                {
                    orgid = i;
                    break;
                }
            }
        }
    }

    if(orgid == 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Niste lider nijedne organizacije!");

    // Naziv organizacije
    new org_name[32];
    switch(orgid)
    {
        case 1: format(org_name, sizeof(org_name), "Policije");
        case 2: format(org_name, sizeof(org_name), "Vojske");
        case 3: format(org_name, sizeof(org_name), "Zandarmerije");
        case 4: format(org_name, sizeof(org_name), "Taxi sluzbe");
        case 5: format(org_name, sizeof(org_name), "Hitne Pomoci");
        case 6: format(org_name, sizeof(org_name), "Novinara");
        case 7: format(org_name, sizeof(org_name), "Parking Servisa");
        case 8: format(org_name, sizeof(org_name), "Hitmana");
        case 9: format(org_name, sizeof(org_name), "La Cosa Nostre");
        case 10: format(org_name, sizeof(org_name), "GHS-a");
        case 11: format(org_name, sizeof(org_name), "Yamaguchija");
        case 12: format(org_name, sizeof(org_name), "Ruske Mafije");
        case 13: format(org_name, sizeof(org_name), "Groove Street Family-a");
        case 14: format(org_name, sizeof(org_name), "Ballas Family-a");
        case 15: format(org_name, sizeof(org_name), "MS-13");
        case 16: format(org_name, sizeof(org_name), "Los Surenosa");
        case 17: format(org_name, sizeof(org_name), "Privatne Organizacije 1");
        case 18: format(org_name, sizeof(org_name), "Privatne Organizacije 2");
        case 19: format(org_name, sizeof(org_name), "Bajkera");
        default: format(org_name, sizeof(org_name), "Organizacije");
    }

    // Provjera slota u organizaciji
    new org_file[64];
    format(org_file, sizeof(org_file), "BalkanRP/Org_%d.ini", orgid);

    if(!DOF2_FileExists(org_file))
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Gre?ka: Fajl organizacije ne postoji!");

    new slot_key[32];
    format(slot_key, sizeof(slot_key), "Slot_%d", slotid);

    if(!DOF2_IsSet(org_file, slot_key))
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Taj slot je vec prazan!");

    new targetname[MAX_PLAYER_NAME];
    format(targetname, sizeof(targetname), "%s", DOF2_GetString(org_file, slot_key));

    if(strcmp(targetname, "Nema", true) == 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Na tom slotu nema nikoga!");

    // Brisanje sa slota
    DOF2_SetString(org_file, slot_key, "Nema");
    DOF2_SaveFile();

    // Upisivanje kazne i brisanje organizacije u licnom fajlu igraca
    new target_file[128];
    format(target_file, sizeof(target_file), "Korisnici/%s.ini", targetname);
    if(DOF2_FileExists(target_file))
    {
        DOF2_SetInt(target_file, "Member", 0);
        DOF2_SetInt(target_file, "Rank", 0);
        DOF2_SetInt(target_file, "OrgKazna", 1); // Postavlja lidersku kaznu na 1
        DOF2_SaveFile();
    }

    // Poruka lideru (svijetlo plava)
    new msg_lider[128];
    format(msg_lider, sizeof(msg_lider), "{33CCFF}Izbacili ste igraca %s iz organizacije sa kaznom.", targetname);
    SendClientMessage(playerid, 0x33CCFFFF, msg_lider);

    // Poruka igracu ako je online (svijetlo plava)
    if(IsPlayerConnected(targetid))
    {
        new msg_target[128];
        format(msg_target, sizeof(msg_target), "{33CCFF}Izbaceni ste iz Organizacije %s od strane Lidera %s sa Kaznom.", org_name, name);
        SendClientMessage(targetid, 0x33CCFFFF, msg_target);
    }

    return 1;
}
stock SaveTrafiku(id)
{
    new file[64];
    format(file, sizeof(file), "BalkanRP/Trafika/trafika_%d.ini", id);
    if(!DOF2_FileExists(file)) DOF2_CreateFile(file);

    DOF2_SetInt(file, "Owned", TrafikaInfo[id][tOwned]);
    DOF2_SetString(file, "Owner", TrafikaInfo[id][tOwner]);
    DOF2_SetString(file, "Naziv", TrafikaInfo[id][tNaziv]);
    DOF2_SetFloat(file, "EntranceX", TrafikaInfo[id][tEntranceX]);
    DOF2_SetFloat(file, "EntranceY", TrafikaInfo[id][tEntranceY]);
    DOF2_SetFloat(file, "EntranceZ", TrafikaInfo[id][tEntranceZ]);
    DOF2_SetInt(file, "Cena", TrafikaInfo[id][tCena]);
    DOF2_SetInt(file, "Level", TrafikaInfo[id][tLevel]);
    DOF2_SetInt(file, "Budzet", TrafikaInfo[id][tBudzet]);
    DOF2_SetInt(file, "Proizvodi", TrafikaInfo[id][tProizvodi]);
    DOF2_SetInt(file, "CenaProizvoda", TrafikaInfo[id][tCenaProizvoda]);
    DOF2_SaveFile();
    return 1;
}

stock UpdateTrafikuCP(id)
{
    if(IsValidDynamic3DTextLabel(TrafikaInfo[id][tLabel])) DestroyDynamic3DTextLabel(TrafikaInfo[id][tLabel]);
    if(IsValidDynamicPickup(TrafikaInfo[id][tPickup])) DestroyDynamicPickup(TrafikaInfo[id][tPickup]);

    new string[512], vlasnik[MAX_PLAYER_NAME], opis[32];

    if(TrafikaInfo[id][tOwned] == 0)
    {
        format(vlasnik, sizeof(vlasnik), "Nitko");
        format(opis, sizeof(opis), "Na Prodaju");
    }
    else
    {
        format(vlasnik, sizeof(vlasnik), "%s", TrafikaInfo[id][tOwner]);
        format(opis, sizeof(opis), "Otvoreno");
    }

    format(string, sizeof(string), "{00C0FF}Naziv Trafike: {FFFFFF}%s\n{00C0FF}Opis: {FFFFFF}%s\n{00C0FF}Vlasnik: {FFFFFF}%s\n{00C0FF}ID: {FFFFFF}%d | {00C0FF}Cijena: {FFFFFF}$%d | {00C0FF}Level: {FFFFFF}%d\n{00C0FF}Bud?et: {FFFFFF}$%d\n{00C0FF}Potrebni Produkti: {FFFFFF}%d | {00C0FF}Cijena Produkta: {FFFFFF}$%d\n{FFFFFF}Kucajte {00C0FF}/trafika {FFFFFF}za kupovinu!",
        TrafikaInfo[id][tNaziv],
        opis,
        vlasnik,
        id,
        TrafikaInfo[id][tCena],
        TrafikaInfo[id][tLevel],
        TrafikaInfo[id][tBudzet],
        TrafikaInfo[id][tProizvodi],
        TrafikaInfo[id][tCenaProizvoda]
    );

    TrafikaInfo[id][tLabel] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, TrafikaInfo[id][tEntranceX], TrafikaInfo[id][tEntranceY], TrafikaInfo[id][tEntranceZ]+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, -1, -1);
    TrafikaInfo[id][tPickup] = CreateDynamicPickup(1239, 23, TrafikaInfo[id][tEntranceX], TrafikaInfo[id][tEntranceY], TrafikaInfo[id][tEntranceZ], -1, -1, -1, 100.0);
    return 1;
}

public UcitajTrafike()
{
    new file[64];
    for(new i = 0; i < MAX_TRAFIKE; i++)
    {
        format(file, sizeof(file), "BalkanRP/Trafika/trafika_%d.ini", i);
        if(DOF2_FileExists(file))
        {
            TrafikaInfo[i][tOwned] = DOF2_GetInt(file, "Owned");
            format(TrafikaInfo[i][tOwner], MAX_PLAYER_NAME, "%s", DOF2_GetString(file, "Owner"));
            format(TrafikaInfo[i][tNaziv], 32, "%s", DOF2_GetString(file, "Naziv"));
            TrafikaInfo[i][tEntranceX] = DOF2_GetFloat(file, "EntranceX");
            TrafikaInfo[i][tEntranceY] = DOF2_GetFloat(file, "EntranceY");
            TrafikaInfo[i][tEntranceZ] = DOF2_GetFloat(file, "EntranceZ");
            TrafikaInfo[i][tCena] = DOF2_GetInt(file, "Cena");
            TrafikaInfo[i][tLevel] = DOF2_GetInt(file, "Level");
            TrafikaInfo[i][tBudzet] = DOF2_GetInt(file, "Budzet");
            TrafikaInfo[i][tProizvodi] = DOF2_GetInt(file, "Proizvodi");
            TrafikaInfo[i][tCenaProizvoda] = DOF2_GetInt(file, "CenaProizvoda");

            UpdateTrafikuCP(i);
            printf("Ucitana Trafika ID: %d", i);
        }
    }
    return 1;
}
CMD:napravitrafiku(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new cena, level;
    if(sscanf(params, "ii", cena, level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/napravitrafiku [Cijena] [Level]");
        return 1;
    }

    new trafikaid = -1;
    for(new t = 0; t < MAX_TRAFIKE; t++)
    {
        new tfile[64];
        format(tfile, sizeof(tfile), "BalkanRP/Trafika/trafika_%d.ini", t);
        if(!DOF2_FileExists(tfile))
        {
            trafikaid = t;
            break;
        }
    }

    if(trafikaid == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Dostignut je maksimalan broj trafika!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    TrafikaInfo[trafikaid][tOwned] = 0;
    format(TrafikaInfo[trafikaid][tOwner], MAX_PLAYER_NAME, "Nitko");
    format(TrafikaInfo[trafikaid][tNaziv], 32, "Trafika");

    TrafikaInfo[trafikaid][tEntranceX] = x;
    TrafikaInfo[trafikaid][tEntranceY] = y;
    TrafikaInfo[trafikaid][tEntranceZ] = z;

    TrafikaInfo[trafikaid][tCena] = cena;
    TrafikaInfo[trafikaid][tLevel] = level;
    TrafikaInfo[trafikaid][tBudzet] = 0;
    TrafikaInfo[trafikaid][tProizvodi] = 100;
    TrafikaInfo[trafikaid][tCenaProizvoda] = 100;

    SaveTrafiku(trafikaid);
    UpdateTrafikuCP(trafikaid);

    new string[128];
    format(string, sizeof(string), "Uspje?no si kreirao trafiku ID: %d", trafikaid);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

CMD:editujtrafiku(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id, nova_cijena, novi_level;
    if(sscanf(params, "iii", id, nova_cijena, novi_level))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/editujtrafiku [ID Trafike] [Nova Cijena] [Novi Level]");
        return 1;
    }

    new tfile[128];
    format(tfile, sizeof(tfile), "BalkanRP/Trafika/trafika_%d.ini", id);
    if(!DOF2_FileExists(tfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ta trafika ne postoji!");

    TrafikaInfo[id][tCena] = nova_cijena;
    TrafikaInfo[id][tLevel] = novi_level;

    SaveTrafiku(id);
    UpdateTrafikuCP(id);

    new string[128];
    format(string, sizeof(string), "Uspje?no si izmijenio trafiku ID: %d | Nova cijena: $%d | Novi level: %d", id, nova_cijena, novi_level);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

CMD:obrisitrafiku(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new id;
    if(sscanf(params, "i", id))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/obrisitrafiku [ID Trafike]");
        return 1;
    }

    new tfile[128];
    format(tfile, sizeof(tfile), "BalkanRP/Trafika/trafika_%d.ini", id);
    if(!DOF2_FileExists(tfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ta trafika ne postoji!");

    DOF2_RemoveFile(tfile);

    if(IsValidDynamic3DTextLabel(TrafikaInfo[id][tLabel])) DestroyDynamic3DTextLabel(TrafikaInfo[id][tLabel]);
    if(IsValidDynamicPickup(TrafikaInfo[id][tPickup])) DestroyDynamicPickup(TrafikaInfo[id][tPickup]);

    TrafikaInfo[id][tOwned] = 0;
    format(TrafikaInfo[id][tOwner], MAX_PLAYER_NAME, "Nitko");
    TrafikaInfo[id][tCena] = 0;
    TrafikaInfo[id][tLevel] = 0;

    new string[128];
    format(string, sizeof(string), "Uspje?no si obrisao trafiku ID: %d", id);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
CMD:kreirajobjekat(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new objectid;
    if(sscanf(params, "i", objectid))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/kreirajobjekat [ID Objekta]");
        return 1;
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new id_kreiranog = CreateDynamicObject(objectid, x + 2.0, y, z, 0.0, 0.0, 0.0);

    // Pronalazimo slobodan slot i upisujemo podatke
    for(new i = 0; i < MAX_SLOBODNIH_OBJEKATA; i++)
    {
        if(SlobodanObjekt[i][sModel] == 0)
        {
            SlobodanObjekt[i][sModel] = objectid;
            SlobodanObjekt[i][sObjID] = id_kreiranog;
            SlobodanObjekt[i][sX] = x + 2.0;
            SlobodanObjekt[i][sY] = y;
            SlobodanObjekt[i][sZ] = z;
            SlobodanObjekt[i][sRX] = 0.0;
            SlobodanObjekt[i][sRY] = 0.0;
            SlobodanObjekt[i][sRZ] = 0.0;
            break;
        }
    }

    // ODMAH pozivamo snimanje da se fajl pojavi u folderu!
    SnimiSlobodneObjekte();

    EditDynamicObject(playerid, id_kreiranog);
    SetPVarInt(playerid, "EditujemSlobodanObjekt", id_kreiranog);

    SendClientMessage(playerid, 0x00BFFFFF, "Uspje?no si kreirao objekt. Fajl je napravljen, namjesti ga mi?em i pritisni Save!");
    return 1;
}
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    // Provjera ako edituje slobodan objekt
    if(GetPVarInt(playerid, "EditujemSlobodanObjekt") == objectid)
    {
        if(response == EDIT_RESPONSE_CANCEL)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Otkazali ste postavljanje/uredivanje objekta.");
            DeletePVar(playerid, "EditujemSlobodanObjekt");
            return 1;
        }

        if(response == EDIT_RESPONSE_FINAL)
        {
            SetDynamicObjectPos(objectid, x, y, z);
            SetDynamicObjectRot(objectid, rx, ry, rz);

            // 1. Ovde pronalazimo slobodan slot u nizu i upisujemo podatke tog objekta
            for(new i = 0; i < MAX_SLOBODNIH_OBJEKATA; i++)
            {
                // Ako je slot prazan ili ako vec editujemo taj isti objekt
                if(SlobodanObjekt[i][sModel] == 0 || SlobodanObjekt[i][sObjID] == objectid)
                {
                    // Uzimamo model objekta (ako ima? sacuvan model, ili ga upisujemo)
                    SlobodanObjekt[i][sX] = x;
                    SlobodanObjekt[i][sY] = y;
                    SlobodanObjekt[i][sZ] = z;
                    SlobodanObjekt[i][sRX] = rx;
                    SlobodanObjekt[i][sRY] = ry;
                    SlobodanObjekt[i][sRZ] = rz;
                    SlobodanObjekt[i][sObjID] = objectid;
                    break;
                }
            }

            // 2. Pozivamo funkciju da snimi sve u "Objekti.ini" fajl!
            SnimiSlobodneObjekte();

            // Ispisujemo ti u chat potvrdu
            new string[144];
            format(string, sizeof(string), "Objekt sacuvan i upisan u fajl! Pozicija: %f, %f, %f", x, y, z);
            SendClientMessage(playerid, 0x00FFFF00, string);

            DeletePVar(playerid, "EditujemSlobodanObjekt");
            return 1;
        }
    }

    // Uredjivanje vec sacuvanog objekta preko /editujobjekt.
    // Slot se u PVar cuva uvecan za 1 kako bi i slot 0 mogao biti prepoznat.
    new editedSlot = GetPVarInt(playerid, "EditujemSlobodanSlot") - 1;
    if(editedSlot >= 0 && editedSlot < MAX_SLOBODNIH_OBJEKATA &&
        SlobodanObjekt[editedSlot][sModel] != 0 &&
        SlobodanObjekt[editedSlot][sObjID] == objectid)
    {
        if(response == EDIT_RESPONSE_CANCEL)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Otkazali ste uredjivanje objekta.");
            DeletePVar(playerid, "EditujemSlobodanSlot");
            return 1;
        }

        if(response == EDIT_RESPONSE_FINAL)
        {
            SetDynamicObjectPos(objectid, x, y, z);
            SetDynamicObjectRot(objectid, rx, ry, rz);

            SlobodanObjekt[editedSlot][sX] = x;
            SlobodanObjekt[editedSlot][sY] = y;
            SlobodanObjekt[editedSlot][sZ] = z;
            SlobodanObjekt[editedSlot][sRX] = rx;
            SlobodanObjekt[editedSlot][sRY] = ry;
            SlobodanObjekt[editedSlot][sRZ] = rz;

            SnimiSlobodneObjekte();

            new string[160];
            format(string, sizeof(string), "Objekt iz slota %d je sacuvan. Pozicija: %.4f, %.4f, %.4f", editedSlot, x, y, z);
            SendClientMessage(playerid, 0x00FFFF00, string);
            DeletePVar(playerid, "EditujemSlobodanSlot");
            return 1;
        }
    }
    return 1;
}
CMD:editujobjekt(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new slot;
    if(sscanf(params, "i", slot))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/editujobjekt [Slot iz fajla (npr. 0)]");
        return 1;
    }

    // Provjeravamo da li slot postoji u opsegu i da li objekt u njemu postoji
    if(slot < 0 || slot >= MAX_SLOBODNIH_OBJEKATA || SlobodanObjekt[slot][sModel] == 0)
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj slot ne postoji ili je prazan!");
    }

    new objid = SlobodanObjekt[slot][sObjID];

    // Provjeravamo da li taj dinamicki objekt uop?te postoji u svijetu
    if(!IsValidDynamicObject(objid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Objekt u tom slotu ne postoji u svijetu!");
    }

    // Pokrecemo editovanje tog objekta mi?em
    EditDynamicObject(playerid, objid);

    // Cuvamo slot + 1, jer GetPVarInt vraca 0 i kada PVar ne postoji.
    SetPVarInt(playerid, "EditujemSlobodanSlot", slot + 1);

    new string[128];
    format(string, sizeof(string), "Uspje?no si preuzeo objekt iz slota %d. Pomjeri ga mi?em i pritisni Save!", slot);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
stock SnimiSlobodneObjekte()
{
    new file[64] = "BalkanRP/Objekti.ini";

    // Ako fajl ne postoji, moramo ga prvo kreirati da DOF2 mo?e upisivati u njega!
    if(!DOF2_FileExists(file))
    {
        DOF2_CreateFile(file);
    }

    for(new i = 0; i < MAX_SLOBODNIH_OBJEKATA; i++)
    {
        if(SlobodanObjekt[i][sModel] != 0) // Ako objekt postoji
        {
            new tag[32];

            // 1. Snimamo model objekta
            format(tag, sizeof(tag), "Obj_%d_Model", i);
            DOF2_SetInt(file, tag, SlobodanObjekt[i][sModel]);

            // 2. Snimamo koordinate (X, Y, Z)
            format(tag, sizeof(tag), "Obj_%d_X", i);
            DOF2_SetFloat(file, tag, SlobodanObjekt[i][sX]);

            format(tag, sizeof(tag), "Obj_%d_Y", i);
            DOF2_SetFloat(file, tag, SlobodanObjekt[i][sY]);

            format(tag, sizeof(tag), "Obj_%d_Z", i);
            DOF2_SetFloat(file, tag, SlobodanObjekt[i][sZ]);

            // 3. Snimamo rotacije (RX, RY, RZ)
            format(tag, sizeof(tag), "Obj_%d_RX", i);
            DOF2_SetFloat(file, tag, SlobodanObjekt[i][sRX]);

            format(tag, sizeof(tag), "Obj_%d_RY", i);
            DOF2_SetFloat(file, tag, SlobodanObjekt[i][sRY]);

            format(tag, sizeof(tag), "Obj_%d_RZ", i);
            DOF2_SetFloat(file, tag, SlobodanObjekt[i][sRZ]);
        }
        else
        {
            // Model 0 trajno oznacava prazan/obrisan slot. Bez ovog upisa bi
            // stari model ostao u INI fajlu i objekt bi se vratio nakon restarta.
            new tag[32];
            format(tag, sizeof(tag), "Obj_%d_Model", i);
            DOF2_SetInt(file, tag, 0);
        }
    }

    // Obavezno cuvamo promjene na fajlu
    DOF2_SaveFile();
    return 1;
}
CMD:obrisiobjekat(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new slot;
    if(sscanf(params, "i", slot))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/obrisiobjekat [Slot iz fajla (npr. 0)]");
        return 1;
    }

    if(slot < 0 || slot >= MAX_SLOBODNIH_OBJEKATA || SlobodanObjekt[slot][sModel] == 0)
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj slot ne postoji ili je prazan!");
    }

    // Bri?emo objekt iz igre ako validan ID postoji
    if(IsValidDynamicObject(SlobodanObjekt[slot][sObjID]))
    {
        DestroyDynamicObject(SlobodanObjekt[slot][sObjID]);
    }

    // Resetujemo podatke u nizu za taj slot
    SlobodanObjekt[slot][sModel] = 0;
    SlobodanObjekt[slot][sObjID] = 0;
    SlobodanObjekt[slot][sX] = 0.0;
    SlobodanObjekt[slot][sY] = 0.0;
    SlobodanObjekt[slot][sZ] = 0.0;
    SlobodanObjekt[slot][sRX] = 0.0;
    SlobodanObjekt[slot][sRY] = 0.0;
    SlobodanObjekt[slot][sRZ] = 0.0;

    // Snimamo izmjene u fajl (izbrisat ce ga iz Objekti.ini)
    SnimiSlobodneObjekte();

    SendClientMessage(playerid, 0x00FF00FF, "Uspje?no si obrisao objekt i uklonjen je iz fajla!");
    return 1;
}
stock UpdateTrafikuLabel(id)
{
    if(IsValidDynamic3DTextLabel(TrafikaInfo[id][tLabel]))
        DestroyDynamic3DTextLabel(TrafikaInfo[id][tLabel]);

    new string[128];
    // Prikazuje tacno onaj tekst koji ?eli?, bez suvi?nih informacija
    format(string, sizeof(string), "{FFFFFF}Trafika %s\n{FFFFFF}Kucajte {FF0000}/trafika {FFFFFF}za kupovinu!", TrafikaInfo[id][tNaziv]);

    TrafikaInfo[id][tLabel] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, TrafikaInfo[id][tEntranceX], TrafikaInfo[id][tEntranceY], TrafikaInfo[id][tEntranceZ]+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);
    return 1;
}
CMD:trafika(playerid, params[])
{
    new blizu = 0;

    // 1. Provera za stare (biznis) trafike
    for(new i = 0; i < MAX_TRAFIKE; i++)
    {
        if(TrafikaInfo[i][tEntranceX] != 0.0 && IsPlayerInRangeOfPoint(playerid, 3.0, TrafikaInfo[i][tEntranceX], TrafikaInfo[i][tEntranceY], TrafikaInfo[i][tEntranceZ]))
        {
            blizu = 1;
            break;
        }
    }

    // 2. Provera za nove custom trafike kreirane preko /kreirajlabel
    if(!blizu)
    {
        for(new i = 0; i < MAX_CUSTOM_LABELS; i++)
        {
            if(CustomLabelX[i] != 0.0 && IsPlayerInRangeOfPoint(playerid, 3.0, CustomLabelX[i], CustomLabelY[i], CustomLabelZ[i]))
            {
                blizu = 1;
                break;
            }
        }
    }

    // Ako nije blizu nijedne
    if(!blizu)
    {
        return SendClientMessage(playerid, 0xFF0000FF, "[Gre?ka]: {FFFFFF}Niste blizu nijedne trafike!");
    }

    // Ako jeste blizu bilo koje, otvara dijalog
    ShowPlayerDialog(playerid, DIALOG_TRAFIKA, DIALOG_STYLE_LIST, "Trafika - Meni", "Sokovi\nHrana\nKredit", "Odaberi", "Izlaz");
    return 1;
}
CMD:kreirajlabeltrafika(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new naziv[32];
    if(sscanf(params, "s[32]", naziv))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/kreirajlabel [Naziv Trafike]");
        return 1;
    }

    new id = -1;
    for(new i = 0; i < MAX_CUSTOM_LABELS; i++)
    {
        if(CustomLabelX[i] == 0.0 && CustomLabelY[i] == 0.0)
        {
            id = i;
            break;
        }
    }
    if(id == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Maksimum kreiranih labela dostignut!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    CustomLabelX[id] = x;
    CustomLabelY[id] = y;
    CustomLabelZ[id] = z;
    format(CustomLabelNaziv[id], 32, "%s", naziv);

    PickupCustom[id] = CreateDynamicPickup(1239, 23, x, y, z, 0);

    new string[128];
    format(string, sizeof(string), "{FFFFFF}%s\n{FFFFFF}Da kupite proizvode na trafici kucajte {FF0000}/trafika", naziv);
    LabelCustom[id] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, x, y, z+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0);

    // Snimanje u fajl
    new path[64];
    format(path, sizeof(path), "BalkanRP/CustomLabels/label_%d.ini", id);
    DOF2_CreateFile(path);
    DOF2_SetString(path, "Naziv", naziv);
    DOF2_SetFloat(path, "X", x);
    DOF2_SetFloat(path, "Y", y);
    DOF2_SetFloat(path, "Z", z);
    DOF2_SaveFile();

    SendClientMessage(playerid, 0x00FF00FF, "Uspje?no kreiran i sacuvan label i pickup!");
    return 1;
}
CMD:obrisilabeltrafika(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(!IsPlayerAdmin(playerid) && admin_lvl < 9) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new obrisan = 0;
    for(new i = 0; i < MAX_CUSTOM_LABELS; i++)
    {
        if(CustomLabelX[i] != 0.0 && IsPlayerInRangeOfPoint(playerid, 3.0, CustomLabelX[i], CustomLabelY[i], CustomLabelZ[i]))
        {
            DestroyDynamicPickup(PickupCustom[i]);
            DestroyDynamic3DTextLabel(LabelCustom[i]);

            // Brisanje fajla da se ne ucita ponovo posle restarta
            new path[64];
            format(path, sizeof(path), "BalkanRP/CustomLabels/label_%d.ini", i);
            if(DOF2_FileExists(path)) DOF2_RemoveFile(path);

            CustomLabelX[i] = 0.0;
            CustomLabelY[i] = 0.0;
            CustomLabelZ[i] = 0.0;
            PickupCustom[i] = 0;
            LabelCustom[i] = Text3D:-1;
            CustomLabelNaziv[i][0] = EOS;

            obrisan = 1;
            SendClientMessage(playerid, 0x00FF00FF, "Uspje?no si obrisao label, pickup i fajl!");
            break;
        }
    }

    if(!obrisan)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste blizu nijednog labela!");
    }
    return 1;
}
CMD:kreirajlabel(playerid, params[])
{
    if(isnull(params)) return SendClientMessage(playerid, 0xFFFFFFFF, "Koristite: {FFFF00}/kreirajlabel [tekst]");

    new slot = -1;
    for(new i = 0; i < MAX_LABELA; i++)
    {
        if(!LabelInfo[i][lKreiran])
        {
            slot = i;
            break;
        }
    }

    if(slot == -1) return SendClientMessage(playerid, 0xFF0000FF, "Greska: Popunjeni su svi slotovi za labele!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new intID = GetPlayerInterior(playerid);
    new vwID = GetPlayerVirtualWorld(playerid);

    LabelInfo[slot][lKreiran] = true;
    LabelInfo[slot][lX] = x;
    LabelInfo[slot][lY] = y;
    LabelInfo[slot][lZ] = z;
    LabelInfo[slot][lInterior] = intID;
    LabelInfo[slot][lVW] = vwID;
    format(LabelInfo[slot][lTekst], 128, "%s", params);

    LabelInfo[slot][lPickupID] = CreatePickup(1239, 1, x, y, z, vwID);
    LabelInfo[slot][l3DText] = Create3DTextLabel(params, 0x00BFFFFF, x, y, z + 0.5, 20.0, vwID, 0);

    // Tacna putanja: scriptfiles/BalkanRP/Label/Label_X.ini
    new file[64];
    format(file, sizeof(file), "BalkanRP/Label/Label_%d.ini", slot);

    DOF2_CreateFile(file);
    DOF2_SetFloat(file, "X", x);
    DOF2_SetFloat(file, "Y", y);
    DOF2_SetFloat(file, "Z", z);
    DOF2_SetInt(file, "Interior", intID);
    DOF2_SetInt(file, "VirtualWorld", vwID);
    DOF2_SetString(file, "Tekst", params);
    DOF2_SaveFile();

    new poruka[128];
    format(poruka, sizeof(poruka), "[LABEL]: Uspje?no ste kreirali label ID: %d sa tekstom: '%s'", slot, params);
    SendClientMessage(playerid, 0x00FF00FF, poruka);
    return 1;
}
public UcitajLabele()
{
    new file[64], ucitano = 0;
    for(new i = 0; i < MAX_LABELA; i++)
    {
        format(file, sizeof(file), "BalkanRP/Label/Label_%d.ini", i);
        if(DOF2_FileExists(file))
        {
            LabelInfo[i][lKreiran] = true;
            LabelInfo[i][lX] = DOF2_GetFloat(file, "X");
            LabelInfo[i][lY] = DOF2_GetFloat(file, "Y");
            LabelInfo[i][lZ] = DOF2_GetFloat(file, "Z");
            LabelInfo[i][lInterior] = DOF2_GetInt(file, "Interior");
            LabelInfo[i][lVW] = DOF2_GetInt(file, "VirtualWorld");
            format(LabelInfo[i][lTekst], 128, "%s", DOF2_GetString(file, "Tekst"));

            LabelInfo[i][lPickupID] = CreatePickup(1239, 1, LabelInfo[i][lX], LabelInfo[i][lY], LabelInfo[i][lZ], LabelInfo[i][lVW]);
            LabelInfo[i][l3DText] = Create3DTextLabel(LabelInfo[i][lTekst], 0x00BFFFFF, LabelInfo[i][lX], LabelInfo[i][lY], LabelInfo[i][lZ] + 0.5, 20.0, LabelInfo[i][lVW], 0);
            ucitano++;
        }
    }
    printf("[LABEL SYSTEM]: Uspje?no ucitano %d labela iz baze.", ucitano);
    return 1;
}
CMD:obrisilabel(playerid, params[])
{
    new id = -1;

    for(new i = 0; i < MAX_LABELA; i++)
    {
        if(LabelInfo[i][lKreiran])
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, LabelInfo[i][lX], LabelInfo[i][lY], LabelInfo[i][lZ]))
            {
                id = i;
                break;
            }
        }
    }

    if(id == -1) return SendClientMessage(playerid, 0xFF0000FF, "Greska: Niste u blizini nijednog kreiranog labela!");

    DestroyPickup(LabelInfo[id][lPickupID]);
    Delete3DTextLabel(LabelInfo[id][l3DText]);

    LabelInfo[id][lKreiran] = false;

    // Brise iz scriptfiles/BalkanRP/Label/Label_X.ini
    new file[64];
    format(file, sizeof(file), "BalkanRP/Label/Label_%d.ini", id);
    if(DOF2_FileExists(file))
    {
        DOF2_RemoveFile(file);
    }

    new poruka[128];
    format(poruka, sizeof(poruka), "[LABEL]: Uspje?no ste obrisali label (ID: %d).", id);
    SendClientMessage(playerid, 0x00FF00FF, poruka);
    return 1;
}
forward RelockAdminEnteredVehicle(vehicleid);
public RelockAdminEnteredVehicle(vehicleid)
{
    if(vehicleid<1||vehicleid>=MAX_VEHICLES||GetVehicleModel(vehicleid)==0)return 1;
    new engine,lights,alarm,doors,bonnet,boot,objective;GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);SetVehicleParamsEx(vehicleid,engine,lights,alarm,1,bonnet,boot,objective);return 1;
}
public OnPlayerEnterVehicle(playerid,vehicleid,ispassenger)
{
    #pragma unused ispassenger
    if(!HasAdminCommandAccess(playerid)||IsTaxiVozilo(vehicleid)||IsHitnaVozilo(vehicleid)||IsParkingServisVozilo(vehicleid)||IsPostarVozilo(vehicleid))return 1;
    new engine,lights,alarm,doors,bonnet,boot,objective;GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);if(doors==1){SetVehicleParamsEx(vehicleid,engine,lights,alarm,0,bonnet,boot,objective);SetTimerEx("RelockAdminEnteredVehicle",3500,false,"i",vehicleid);}return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
        ScriptJetpack[playerid] = false;
    // Proveravamo kada igrac postane vozac nekog vozila
    if(newstate == PLAYER_STATE_DRIVER)
    {
        SetPVarInt(playerid, "BR_StaffVehicleProtect", IsAntiSpamExempt(playerid));
        new vehicleid = GetPlayerVehicleID(playerid);
        new vehicleBusiness = -1, vehicleSlot = -1;
        if(GetBusinessVehicleSlotById(vehicleid, vehicleBusiness, vehicleSlot))
        {
            if(IsFishingBusiness(vehicleBusiness) && BusinessVehicleModel[vehicleBusiness][vehicleSlot] == FISHING_BOAT_MODEL)
            {
                if(RentVehicleOwner[vehicleid] == playerid + 1 && RentPlayerVehicle[playerid] == vehicleid) return 1;
                if(RentVehicleOwner[vehicleid])
                {
                    RemovePlayerFromVehicle(playerid);
                    return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Ovaj brod je vec iznajmljen.");
                }
                if(RentPlayerVehicle[playerid])
                {
                    RemovePlayerFromVehicle(playerid);
                    return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Vec imate iznajmljeno vozilo. Koristite /unrent.");
                }
                if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC)
                {
                    RemovePlayerFromVehicle(playerid);
                    return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Ovaj brod mogu iznajmiti samo Ribolovci.");
                }
                if(PlayerJobData[playerid][JobLevel] < RIBOLOVAC_MAX_LEVEL)
                {
                    RemovePlayerFromVehicle(playerid);
                    return SendClientMessage(playerid, 0xFF7777FF, "[RENT]: Ovaj brod mozete iznajmiti tek na 5. levelu Ribolovca.");
                }
                RentPendingVehicle[playerid] = vehicleid;
                new rentText[192];
                format(rentText, sizeof(rentText), "{FFFFFF}Brod: {33CCFF}Reefer\n{FFFFFF}Cijena: {00FF00}%d RSD\n{FFFFFF}Vrijeme: {FFFF00}%d minuta\n\n{FFFFFF}Zelite li iznajmiti ovaj brod?",
                    BusinessVehicleRentPrice[vehicleBusiness][vehicleSlot], BusinessVehicleRentMinutes[vehicleBusiness][vehicleSlot]);
                ShowPlayerDialog(playerid, DIALOG_FISHING_BOAT_RENT, DIALOG_STYLE_MSGBOX, "{33CCFF}Rent ribarskog broda", rentText, "Iznajmi", "Odustani");
                return 1;
            }
            if(!CanManageBusiness(playerid, vehicleBusiness) && !HasAdminCommandAccess(playerid))
            {
                RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[BIZNIS]: Ovo firmino vozilo moze voziti samo vlasnik biznisa.");
            }
        }
        if(IsRentVehicle(vehicleid))
        {
            if(RentVehicleOwner[vehicleid] == playerid + 1 && RentPlayerVehicle[playerid] == vehicleid)
                return 1;
            if(RentVehicleOwner[vehicleid])
            {
                RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Ovo vozilo je vec iznajmljeno.");
            }
            if(RentPlayerVehicle[playerid])
            {
                RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Vec imas rent vozilo. Koristi /unrent.");
            }
            if(!GetPVarInt(playerid, "BR_LoggedIn"))
            {
                RemovePlayerFromVehicle(playerid);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Prvo se prijavi na nalog.");
            }
            RentPendingVehicle[playerid] = vehicleid;
            ShowPlayerDialog(playerid, DIALOG_RENT, DIALOG_STYLE_TABLIST_HEADERS,
                "Iznajmljivanje vozila", "Vreme\tCena\n10 min\t200 RSD\n15 min\t300 RSD\n30 min\t600 RSD",
                "Iznajmi", "Odustani");
            return 1;
        }

        new file[128], ime[MAX_PLAYER_NAME];
        GetPlayerName(playerid, ime, sizeof(ime));
        format(file, sizeof(file), "Korisnici/%s.ini", ime);

        new clan_lvl = 0;
        new player_job = 0; // Varijabla za posao

        if(DOF2_FileExists(file))
        {
            clan_lvl = DOF2_GetInt(file, "Clan");
            if(clan_lvl == 0) clan_lvl = DOF2_GetInt(file, "Member");

            player_job = DOF2_GetInt(file, "Posao"); // Ucitavamo posao iz fajla
        }

        // Provera da li je igrac lider ove organizacije preko Lideri.ini
        new org_lider = 0;
        new lideri_file[64] = "BalkanRP/Lideri.ini";
        if(DOF2_FileExists(lideri_file))
        {
            for(new i = 1; i <= 20; i++)
            {
                new key[32];
                format(key, sizeof(key), "Lider_%d", i);
                if(DOF2_IsSet(lideri_file, key))
                {
                    new l_name[MAX_PLAYER_NAME];
                    format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                    if(strcmp(l_name, ime, true) == 0)
                    {
                        org_lider = i; // Vraca ID organizacije ciji je lider
                        break;
                    }
                }
            }
        }

        // 1. Provera za Taxi (Org ID 4)
        if(IsTaxiVozilo(vehicleid))
        {
            if(clan_lvl != 4 && org_lider != 4)
            {
                RemovePlayerFromVehicle(playerid);
                ClearAnimations(playerid);
                SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste clan Taxi organizacije da biste vozili ovo vozilo!");
                return 1;
            }
        }
        // 2. Provera za Hitnu Pomoc (Org ID 3)
        else if(IsHitnaVozilo(vehicleid))
        {
            if(clan_lvl != 3 && org_lider != 3)
            {
                RemovePlayerFromVehicle(playerid);
                ClearAnimations(playerid);
                SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste clan Hitne Pomoci da biste vozili ovo vozilo!");
                return 1;
            }
        }
        // 3. Provera za Parking Servis (Org ID 7)
        else if(IsParkingServisVozilo(vehicleid))
        {
            if(clan_lvl != 7 && org_lider != 7)
            {
                RemovePlayerFromVehicle(playerid);
                ClearAnimations(playerid);
                SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste zaposleni u Parking Servisu da biste vozili ovo vozilo!");
                return 1;
            }
        }
        // 4. Provera za Po?tara (Posao ID 2)
        else if(IsPostarVozilo(vehicleid))
        {
            if(player_job != 2)
            {
                RemovePlayerFromVehicle(playerid);
                ClearAnimations(playerid);
                SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste zaposleni kao Postar da biste vozili ovo vozilo! Kucajte /uzmiposao 2.");
                return 1;
            }
        }
    }
    return 1;
}
CMD:givegun(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(!GetPVarInt(playerid, "BR_LoggedIn") && !IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Prvo se prijavite na nalog.");

    new admin_rank = 0;
    if(DOF2_FileExists(file)) admin_rank = DOF2_GetInt(file, "Admin");
    if(!IsPlayerAdmin(playerid) && (admin_rank < 6 || admin_rank > 9))
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Za /givegun je potreban admin rank 6-9 ili RCON admin.");

    new targetid, weaponid, ammo;
    if(sscanf(params, "ddd", targetid, weaponid, ammo))
        return SendClientMessage(playerid, -1, "{FF0000}[KORISTENJE]: {FFFFFF}/givegun [ID Igraca] [ID Oruzja] [Metci]");

    if(targetid < 0 || targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Taj igrac nije online!");
    if(weaponid < 0 || weaponid > 46)
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}ID oruzja mora biti izmedu 0 i 46!");
    if(ammo < 1 || ammo > 9999)
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Kolicina metaka mora biti izmedu 1 i 9999!");

    GivePlayerWeapon(targetid, weaponid, ammo);

    new targetname[MAX_PLAYER_NAME], s_msg[128];
    GetPlayerName(targetid, targetname, sizeof(targetname));
    format(s_msg, sizeof(s_msg), "{33CCFF}[ADMIN]: {FFFFFF}Uspjesno ste dali oruzje (ID: %d) igracu %s sa %d metaka.", weaponid, targetname, ammo);
    SendClientMessage(playerid, -1, s_msg);
    format(s_msg, sizeof(s_msg), "{33CCFF}[ADMIN]: {FFFFFF}Admin vam je dodijelio oruzje (ID: %d) sa %d metaka.", weaponid, ammo);
    SendClientMessage(targetid, -1, s_msg);
    return 1;
}

CMD:givemoney(playerid, params[]) // Dodane uglaste zagrade [] ako je params niz u tvom modu!
{
    // Provera admin levela (9+) ili RCON-a
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(admin_lvl < 9 && !IsPlayerAdmin(playerid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste ovla?ceni da koristite ovu komandu!");
    }

    new targetid, money;
    // Ako je params definisan kao niz, ovo ce raditi bez gre?ke:
    if(sscanf(params, "dd", targetid, money))
    {
        return SendClientMessage(playerid, 0xCECECEFF, "Koristite: /givemoney [ID Igraca] [Kolicina]");
    }

    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj igrac nije na serveru!");
    }
    if(money <= 0) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Kolicina novca mora biti veca od nule!");
    new currentMoney = GetPlayerMoney(targetid);
    if(currentMoney > 0 && money > 2147483647 - currentMoney)
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Prevelika kolicina novca!");

    new string[128], targetname[MAX_PLAYER_NAME], targetfile[128];
    GetPlayerName(targetid, targetname, sizeof(targetname));
    format(targetfile, sizeof(targetfile), "Korisnici/%s.ini", targetname);
    if(!DOF2_FileExists(targetfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nalog igraca nije pronaden!");

    GivePlayerMoney(targetid, money);
    PlayerInfo[targetid][pNovac] = GetPlayerMoney(targetid);
    DOF2_SetInt(targetfile, "Novac", PlayerInfo[targetid][pNovac]);
    DOF2_SaveFile();

    format(string, sizeof(string), "[ADMIN]: Administrator vam je dao %d dinara.", money);
    SendClientMessage(targetid, 0x00FF00FF, string);

    format(string, sizeof(string), "[ADMIN]: Dali ste igracu %s %d dinara.", targetname, money);
    SendClientMessage(playerid, 0x00FF00FF, string);
    return 1;
}

// --- /RESTART ---
CMD:restart(playerid, params)
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(admin_lvl < 9 && !IsPlayerAdmin(playerid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste ovla?ceni da koristite ovu komandu!");
    }

    if(RestartAdminInProgress)
        return SendClientMessage(playerid, 0xFF7777FF, "Komanda je vec izvrsena.");
    RestartAdminInProgress = true;

    // Poruka na sred ekrana svima
    GameTextForAll("~r~Uskoro ce restart!\n~w~Zavrsavajte svoje poslove.", 6000, 3);
    SendClientMessageToAll(0xFF0000FF, "[SERVER]: Administrator je pokrenuo restart servera za 1 minut!");

    // Pokrece tajmer na 60 sekundi (1 minut)
    SetTimer("RestartServerTimer", 60000, false);
    return 1;
}

// --- /RAC (RESPAWN NEISKORI?CENIH VOZILA) ---
CMD:rac(playerid, params)
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(admin_lvl < 9 && !IsPlayerAdmin(playerid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste ovla?ceni da koristite ovu komandu!");
    }

    if(RacAdminInProgress)
        return SendClientMessage(playerid, 0xFF7777FF, "Komanda je vec izvrsena.");
    RacAdminInProgress = true;

    SendClientMessageToAll(0x00BFFFFF, "Administrator je pokrenuo Respawn vozila, sva vozila neiskoristena bice Respawnovana za 30 sekundi!");

    // Pokrece tajmer na 30 sekundi (pola minuta)
    SetTimer("RespawnUnusedVehiclesTimer", 30000, false);
    return 1;
}

stock VehicleCommandAdmin(playerid)
{
    if(IsPlayerAdmin(playerid)) return 1;
    if(!GetPVarInt(playerid, "BR_LoggedIn")) return 0;

    new name[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    return DOF2_FileExists(file) && DOF2_GetInt(file, "Admin") >= 1;
}

public LoadAdminParkedVehicles()
{
    new f[64]="BalkanRP/AdminParkedVehicles.ini",key[32];if(!DOF2_FileExists(f))return 1;
    for(new v=1;
        v<MAX_VEHICLES;
        v++)if(GetVehicleModel(v)!=0){format(key,sizeof(key),"V%d_Set",v);
    if(!DOF2_GetInt(f,key))continue;
        AdminParkedVehicle[v]=true;
        format(key,sizeof(key),"V%d_X",v);
        AdminParkX[v]=DOF2_GetFloat(f,key);
        format(key,sizeof(key),"V%d_Y",v);
        AdminParkY[v]=DOF2_GetFloat(f,key);
        format(key,sizeof(key),"V%d_Z",v);
        AdminParkZ[v]=DOF2_GetFloat(f,key);
        format(key,sizeof(key),"V%d_A",v);
        AdminParkA[v]=DOF2_GetFloat(f,key);
        RespawnAtAdminPark(v);
    }return 1;
        
}
stock RespawnAtAdminPark(vehicleid)
{
    SetVehicleToRespawn(vehicleid);
    if(AdminParkedVehicle[vehicleid])
    {
        SetVehiclePos(vehicleid,AdminParkX[vehicleid],AdminParkY[vehicleid],AdminParkZ[vehicleid]);
        SetVehicleZAngle(vehicleid,AdminParkA[vehicleid]);
    }
    return 1;
}
stock RespawnVehicleNow(vehicleid)
{
    if(vehicleid <= 0 || GetVehicleModel(vehicleid) == 0) return 0;
    if(IsRentVehicle(vehicleid) && RentVehicleOwner[vehicleid])
    {
        new owner = RentVehicleOwner[vehicleid] - 1;
        if(owner >= 0 && owner < MAX_PLAYERS && IsPlayerConnected(owner))
            StopPlayerRent(owner, false);
        else RentVehicleOwner[vehicleid] = 0;
    }
    for(new p = 0; p < MAX_PLAYERS; p++)
    {
        if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid))
            RemovePlayerFromVehicle(p);
    }
    if(AdminSpawnedVehicle[vehicleid])
    {
        AdminSpawnedVehicle[vehicleid] = false;
        if(DestroyVehicle(vehicleid)) return 2;
        return 0;
    }
    return RespawnAtAdminPark(vehicleid);
}

CMD:rtc(playerid, params[])
{
    if(!VehicleCommandAdmin(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Ovu komandu mogu koristiti samo admini.");
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Morate sjediti u vozilu.");

    new vehicleid = GetPlayerVehicleID(playerid);
    new result = RespawnVehicleNow(vehicleid);
    if(!result)
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Respawn vozila nije uspio.");
    if(result == 2) SendClientMessage(playerid, 0x00BFFFFF, "[VOZILO]: Spawnovano vozilo je uklonjeno.");
    else SendClientMessage(playerid, 0x00BFFFFF, "[VOZILO]: Vozilo je vraceno na pocetnu poziciju.");
    return 1;
}

CMD:artc(playerid, params[])
{
    if(!VehicleCommandAdmin(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Ovu komandu mogu koristiti samo admini.");
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0x00BFFFFF, "Koristenje: /artc [ID/Ime igraca]");
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Igrac nije na serveru.");
    if(!IsPlayerInAnyVehicle(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Taj igrac nije u vozilu.");

    new vehicleid = GetPlayerVehicleID(targetid);
    new result = RespawnVehicleNow(vehicleid);
    if(!result)
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Respawn vozila nije uspio.");
    if(result == 2) SendClientMessage(playerid, 0x00BFFFFF, "[VOZILO]: Spawnovano vozilo igraca je uklonjeno.");
    else SendClientMessage(playerid, 0x00BFFFFF, "[VOZILO]: Vozilo igraca je vraceno na pocetnu poziciju.");
    if(targetid != playerid)
        SendClientMessage(targetid, 0x00BFFFFF, "[VOZILO]: Admin je respawnao vozilo u kojem ste sjedili.");
    return 1;
}

CMD:fix(playerid, params[])
{
    if(!VehicleCommandAdmin(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Ovu komandu mogu koristiti samo admini.");
    new targetid;
    if(sscanf(params, "u", targetid) || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0x00BFFFFF, "Koristenje: /fix [ID/Ime igraca]");
    if(!IsPlayerInAnyVehicle(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Taj igrac nije u vozilu.");

    new vehicleid = GetPlayerVehicleID(targetid);
    if(!VehicleHudRepair(vehicleid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Popravka vozila nije uspjela.");
    SendClientMessage(playerid, 0x00BFFFFF, "[VOZILO]: Vozilo je popravljeno.");
    if(targetid != playerid)
        SendClientMessage(targetid, 0x00BFFFFF, "[VOZILO]: Admin je popravio vozilo u kojem sjedite.");
    return 1;
}

CMD:artcveh(playerid, params[])
{
    if(!VehicleCommandAdmin(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Ovu komandu mogu koristiti samo admini.");

    new vehicleid;
    if(sscanf(params, "i", vehicleid))
        return SendClientMessage(playerid, 0x00BFFFFF, "Koristenje: /artcveh [ID vozila iz /dl]");
    if(vehicleid < 1 || vehicleid >= MAX_VEHICLES || GetVehicleModel(vehicleid) == 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Vozilo s tim ID-om ne postoji.");

    for(new p = 0; p < MAX_PLAYERS; p++)
    {
        if(p != playerid && IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid))
            SendClientMessage(p, 0x00BFFFFF, "[VOZILO]: Admin je respawnao vozilo u kojem ste sjedili.");
    }
    new result = RespawnVehicleNow(vehicleid);
    if(!result)
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Respawn vozila nije uspio.");

    new message[128];
    if(result == 2) format(message, sizeof(message), "[VOZILO]: Spawnovano vozilo ID %d je uklonjeno.", vehicleid);
    else format(message, sizeof(message), "[VOZILO]: Vozilo ID %d je vraceno na pocetnu poziciju.", vehicleid);
    SendClientMessage(playerid, 0x00BFFFFF, message);
    return 1;
}

CMD:afixveh(playerid, params[])
{
    if(!VehicleCommandAdmin(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Ovu komandu mogu koristiti samo admini.");

    new vehicleid;
    if(sscanf(params, "i", vehicleid))
        return SendClientMessage(playerid, 0x00BFFFFF, "Koristenje: /afixveh [ID vozila iz /dl]");
    if(vehicleid < 1 || vehicleid >= MAX_VEHICLES || GetVehicleModel(vehicleid) == 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Vozilo s tim ID-om ne postoji.");
    if(!VehicleHudRepair(vehicleid))
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Popravka vozila nije uspjela.");

    new message[128];
    format(message, sizeof(message), "[VOZILO]: Vozilo ID %d je popravljeno.", vehicleid);
    SendClientMessage(playerid, 0x00BFFFFF, message);
    return 1;
}
// Pomocna funkcija koja proverava da li neko sedi u vozilu
// Rent se odnosi samo na 30 vozila oznacenih u Vozila.inc.
stock UpdateLocationTD(playerid)
{
    if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn")) return 0;

    new zoneid, name[32];
    if(GetPlayerInterior(playerid) > 0)
    {
        zoneid = -2;
        format(name, sizeof(name), "Interior");
        PlayerTextDrawSetString(playerid, TD_Grad[playerid], "JUGOSLAVIJA");
    }
    else
    {
        PlayerTextDrawSetString(playerid, TD_Grad[playerid], "BEOGRAD");
        new MapZone:zone = GetPlayerMapZone(playerid);
        zoneid = _:zone;
        if(zone == INVALID_MAP_ZONE_ID || !GetMapZoneName(zone, name, sizeof(name)))
            format(name, sizeof(name), "San Andreas");
    }

    if(LastLocationZone[playerid] == zoneid) return 1;
    LastLocationZone[playerid] = zoneid;
    PlayerTextDrawSetString(playerid, TD_Lokacija[playerid], name);
    return 1;
}

forward UpdateLocationDisplays();
public UpdateLocationDisplays()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(IsPlayerConnected(playerid))
        {
            UpdateLocationTD(playerid);
            UpdateRevolutionHudData(playerid);
        }
    }
    return 1;
}
stock StopPlayerRent(playerid, bool:respawn)
{
    new vehicleid = RentPlayerVehicle[playerid];
    new businessid = RentBusinessId[playerid], slotid = RentBusinessSlot[playerid];
    RentPendingVehicle[playerid] = 0;
    RentPlayerVehicle[playerid] = 0;
    RentExpiresAt[playerid] = 0;
    RentBusinessId[playerid] = -1;
    RentBusinessSlot[playerid] = -1;
    if(OffshoreCheckpoint[playerid])
    {
        DisablePlayerCheckpoint(playerid);
        OffshoreCheckpoint[playerid] = false;
    }
    PlayerTextDrawHide(playerid, RentTextDraw[playerid]);
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
    if(RentVehicleOwner[vehicleid] == playerid + 1) RentVehicleOwner[vehicleid] = 0;
    if(respawn && GetVehicleModel(vehicleid) != 0)
    {
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid))
                RemovePlayerFromVehicle(p);
        }
        if(businessid >= 0 && slotid >= 0) ResetFishingBoatToSlot(businessid, slotid);
        else SetVehicleToRespawn(vehicleid);
    }
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    new businessid = -1, slotid = -1;
    new bool:isBusinessBoat = GetBusinessVehicleSlotById(vehicleid, businessid, slotid) && IsFishingBusiness(businessid);
    if(!IsRentVehicle(vehicleid) && !isBusinessBoat) return 1;
    if(RentVehicleOwner[vehicleid])
    {
        new owner = RentVehicleOwner[vehicleid] - 1;
        if(owner >= 0 && owner < MAX_PLAYERS && IsPlayerConnected(owner))
        {
            StopPlayerRent(owner, false);
            SendClientMessage(owner, 0xFF0000FF, "[RENT]: Iznajmljeno vozilo je unisteno. Rent je prekinut.");
        }
        else RentVehicleOwner[vehicleid] = 0;
    }
    if(isBusinessBoat) SetTimerEx("ResetFishingBoatDelayed", 3000, false, "ii", businessid, slotid);
    else SetVehicleToRespawn(vehicleid);
    return 1;
}

forward ResetFishingBoatDelayed(businessid, slotid);
public ResetFishingBoatDelayed(businessid, slotid)
{
    return ResetFishingBoatToSlot(businessid, slotid);
}
forward RentTick();
public RentTick()
{
    new now = gettime();
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid) || !RentPlayerVehicle[playerid]) continue;
        if(now >= RentExpiresAt[playerid])
        {
            StopPlayerRent(playerid, true);
            SendClientMessage(playerid, 0x00BFFFFF, "[RENT]: Vrijeme najma broda je isteklo. Vozilo je vraceno.");
        }
        else
        {
            UpdateRentTextDraw(playerid);
            PlayerTextDrawShow(playerid, RentTextDraw[playerid]);
        }
    }
    return 1;
}

CMD:unrent(playerid, params[])
{
    if(!RentPlayerVehicle[playerid])
        return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Nemas iznajmljeno vozilo.");
    StopPlayerRent(playerid, true);
    SendClientMessage(playerid, 0x00BFFFFF, "[RENT]: Vozilo je vraceno. Preostalo vrijeme je ponisteno.");
    return 1;
}

CMD:rentvehiclehelp(playerid, params[])
{
    SendClientMessage(playerid, 0x00BFFFFF, "[RENT]: Sjedi za volan Faggia, Glendalea ili Premiera kod aerodroma i izaberi vrijeme.");
    SendClientMessage(playerid, 0x00BFFFFF, "[RENT]: 10 min = 200 RSD, 15 min = 300 RSD, 30 min = 600 RSD.");
    SendClientMessage(playerid, 0x00BFFFFF, "[RENT]: Preostalo vrijeme pise na dnu ekrana. /unrent odmah vraca vozilo.");
    return 1;
}
stock IsVehicleOccupied(carid)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && IsPlayerInVehicle(i, carid)) return 1;
    }
    return 0;
}

// Tajmer za restart servera nakon 1 min
forward RestartServerTimer();
public RestartServerTimer()
{
    RestartAdminInProgress = false;
    SendRconCommand("gmx"); // Ako ?eli? potpuno ga?enje servera umesto gmx (gamemode restart), zameni sa "exit"
    return 1;
}

// Tajmer za respawn praznih vozila nakon pola minuta (30s)
forward RespawnUnusedVehiclesTimer();
public RespawnUnusedVehiclesTimer()
{
    new deletedTemp = 0, returnedRent = 0, returnedParked = 0;
    for(new vehicleid = 1; vehicleid < MAX_VEHICLES; vehicleid++)
    {
        if(GetVehicleModel(vehicleid) == 0 || IsVehicleOccupied(vehicleid)) continue;

        if(AdminSpawnedVehicle[vehicleid])
        {
            AdminSpawnedVehicle[vehicleid] = false;
            VehicleHudInitialized[vehicleid] = false;
            VehicleHudOutOfFuel[vehicleid] = false;
            VehicleHudLastPosValid[vehicleid] = false;
            VehicleHudBrokenNotice[vehicleid] = false;
            VehicleHudStalled[vehicleid] = false;
            VehicleHudFuel[vehicleid] = 0.0;
            VehicleHudKm[vehicleid] = 0.0;
            VehicleHudLastDamage[vehicleid] = 0;
            DestroyVehicle(vehicleid);
            deletedTemp++;
            continue;
        }

        if(IsRentVehicle(vehicleid))
        {
            if(RentVehicleOwner[vehicleid])
            {
                new owner = RentVehicleOwner[vehicleid] - 1;
                if(owner >= 0 && owner < MAX_PLAYERS && IsPlayerConnected(owner))
                    StopPlayerRent(owner, false);
                else RentVehicleOwner[vehicleid] = 0;
            }
            SetVehicleToRespawn(vehicleid);
            returnedRent++;
            continue;
        }

        RespawnAtAdminPark(vehicleid);
        returnedParked++;
    }

    RacAdminInProgress = false;
    new message[144];
    format(message, sizeof(message), "[RAC]: Obrisano /veh: %d | Vraceno rent: %d | Vraceno parkirano: %d.", deletedTemp, returnedRent, returnedParked);
    SendClientMessageToAll(0x00FF00FF, message);
    return 1;
}
// --- /CALL 666 ---
CMD:call(playerid, params[])
{
    if(isnull(params) || strval(params) != 666)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Koristite /call 666");
    }

    // Proveravamo da li je taksista uop?te na du?nosti pre poziva
    if(!G_TaxiDuty)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "Trenutno nijedan taksista nije na du?nosti (/duty)!");
    }

    GetPlayerPos(playerid, G_TaxiPos[0], G_TaxiPos[1], G_TaxiPos[2]);
    G_TaxiCaller = playerid;
    G_HasTaxiCall = true;

    new callername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, callername, sizeof(callername));

    // Petlja prolazi kroz sve igrace i proverava da li je neko clan ili lider Taxi organizacije (ID 4)
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new iname[MAX_PLAYER_NAME];
            GetPlayerName(i, iname, sizeof(iname));

            new file[128];
            format(file, sizeof(file), "Korisnici/%s.ini", iname);

            if(DOF2_FileExists(file))
            {
                new orgid = DOF2_GetInt(file, "Member");
                new is_lider = 0;

                // Provera lidera preko Lideri.ini
                new lideri_file[64] = "BalkanRP/Lideri.ini";
                if(DOF2_FileExists(lideri_file))
                {
                    for(new l = 1; l <= 20; l++)
                    {
                        new key[32];
                        format(key, sizeof(key), "Lider_%d", l);
                        if(DOF2_IsSet(lideri_file, key))
                        {
                            new l_name[MAX_PLAYER_NAME];
                            format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                            if(strcmp(l_name, iname, true) == 0)
                            {
                                if(l == 4) // Ako je lider organizacije ID 4 (Taxi)
                                {
                                    is_lider = 1;
                                }
                                break;
                            }
                        }
                    }
                }

                // Ako je clan ili lider Taxi organizacije, ?aljemo belu poruku sa cenom vo?nje
                if(orgid == 4 || is_lider == 1)
                {
                    new string[128];
                    format(string, sizeof(string), "[TAXI POZIV]: Igrac %s tra?i prevoz! Cena voznje: %d RSD. Kucajte /acceptfaren", callername, G_TaxiPrice);
                    SendClientMessage(i, 0xFFFFFFFF, string);
                }
            }
        }
    }

    SendClientMessage(playerid, 0xFFFFFFFF, "Poslali ste svim taksistima poziv.");
    return 1;
}

// --- /ACCEPTFAREN ---
CMD:acceptfaren(playerid, params[])
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Gre?ka pri ucitavanju va?eg fajla!");

    new orgid = DOF2_GetInt(file, "Member");
    new is_lider = 0;

    new lideri_file[64] = "BalkanRP/Lideri.ini";
    if(DOF2_FileExists(lideri_file))
    {
        for(new l = 1; l <= 20; l++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", l);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name, true) == 0)
                {
                    if(l == 4) is_lider = 1;
                    break;
                }
            }
        }
    }

    if(orgid != 4 && is_lider != 1)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Niste clan taxi organizacije!");
    }

    if(!G_HasTaxiCall || G_TaxiCaller == INVALID_PLAYER_ID || !IsPlayerConnected(G_TaxiCaller))
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Trenutno nema aktivnih taxi poziva!");
    }

    // Postavljamo checkpoint taksisti na mapu
    SetPlayerCheckpoint(playerid, G_TaxiPos[0], G_TaxiPos[1], G_TaxiPos[2], 3.0);

    // Pamtimog ko je prihvatio vo?nju
    G_AcceptedTaxiDriver = playerid;

    new string[128], drivername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, drivername, sizeof(drivername));

    SendClientMessage(playerid, 0xFFFFFFFF, "Prihvatili ste voznju, oznaceno vam je na mapi.");

    format(string, sizeof(string), "Trenutno taxista %s je prihvatio vas poziv, cekajte ga na tom mjestu.", drivername);
    SendClientMessage(G_TaxiCaller, 0xFFFFFFFF, string);

    G_HasTaxiCall = false;
    return 1;
}
CMD:duty(playerid, params[])
{
    // 1. Provera lokacije
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, TaxiDutyPos[0], TaxiDutyPos[1], TaxiDutyPos[2]))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Niste na mestu za uzimanje Taxi duznosti!");

    // 2. Provera organizacije preko fajla
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Gre?ka pri ucitavanju va?eg fajla!");

    new orgid = DOF2_GetInt(file, "Member");
    new is_lider = 0;

    new lideri_file[64] = "BalkanRP/Lideri.ini";
    if(DOF2_FileExists(lideri_file))
    {
        for(new l = 1; l <= 20; l++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", l);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name, true) == 0)
                {
                    if(l == 4) is_lider = 1;
                    break;
                }
            }
        }
    }

    if(orgid != 4 && is_lider != 1)
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Niste clan taxi organizacije!");

    // 3. Provera unete cene (npr. /duty 25)
    new price;
    if(sscanf(params, "d", price))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Koristite: /duty [Cena voznje]");

    // 4. Postavljanje du?nosti
    G_TaxiPrice = price;
    G_TaxiDuty = true;

    new string[128];
    format(string, sizeof(string), "Taxi Vozac %s je sada na Duznosti, da ga pozovete kucajte /call 666. Cjena voznje: %d RSD", name, price);
    SendClientMessageToAll(0xFFFF00FF, string); // ?uta boja za obave?tenje svima

    return 1;
}
public OnPlayerEnterCheckpoint(playerid)
{
    if(OffshoreCheckpoint[playerid])
    {
        DisablePlayerCheckpoint(playerid);
        OffshoreCheckpoint[playerid] = false;
        SendClientMessage(playerid, 0x00FF00FF, "[POSAO]: Stigli ste u offshore fishing zonu. Mozete pecati bilo gdje unutar bijele zone.");
        return 1;
    }
    // 1. Provera za taksistu koji je prihvatio vo?nju
    if(playerid == G_AcceptedTaxiDriver)
    {
        DisablePlayerCheckpoint(playerid);
        SendClientMessage(playerid, 0xFFFFFFFF, "Stigli ste na mjesto.");
        G_AcceptedTaxiDriver = INVALID_PLAYER_ID;
        return 1;
    }

    if(IsDoingPosta[playerid])
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(!IsPlayerInAnyVehicle(playerid) || GetVehicleModel(vehicleid) != 482)
        {
            SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Morate biti u po?tarskom kombiju da biste dostavili po?tu!");
            return 1;
        }

        // Ako je korak manji od 15 (to su redovne tacke dostave od 1 do 14)
        if(PostarStep[playerid] < 15)
        {
            PostarStep[playerid]++;
            SetPlayerCheckpoint(playerid, PostarRute[PostarStep[playerid]][0], PostarRute[PostarStep[playerid]][1], PostarRute[PostarStep[playerid]][2], 4.0);
            SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Idite do sljedece lokacije!");
        }
        else if(PostarStep[playerid] == 15)
        {
            // Stigao do aerodroma (tacka 15) - Bri?emo checkpoint, palimo tajmer 10 sekundi i zamrzavamo igraca
            DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, 0xFFFF00FF, "[SERVER]: Stigli ste na aerodrom. Sacekajte 10 sekundi da vam se utovari po?ta u kombi...");
            TogglePlayerControllable(playerid, 0);

            // Pokrecemo tajmer
            SetTimerEx("PostaAerodromZavrsetak", 10000, false, "i", playerid);
        }
        else if(PostarStep[playerid] == 16)
        {
            // Vratio se nazad u magacin nakon utovara - Kraj ture i isplata!
            DisablePlayerCheckpoint(playerid);
            IsDoingPosta[playerid] = false;
            PostarStep[playerid] = 0;

            new file[128], ime[MAX_PLAYER_NAME];
            GetPlayerName(playerid, ime, sizeof(ime));
            format(file, sizeof(file), "Korisnici/%s.ini", ime);

            if(DOF2_FileExists(file))
            {
                new stari_novac_banka = DOF2_IsSet(file, "Banka") ? DOF2_GetInt(file, "Banka") : 0;
                new bruto_plata = CalculateJobPayment(playerid, 2, 1000, file);
                new biznis_dio, biznis_id;
                new plata = SplitJobPayment(2, bruto_plata, biznis_dio, biznis_id);
                new novo_stanje_banka = stari_novac_banka + plata;

                DOF2_SetInt(file, "Banka", novo_stanje_banka);
                DOF2_SaveFile();

				// --- OVDE DODAJ OVO ISPOD ---
                UpdateBankaTD(playerid, novo_stanje_banka);
				// -----------------------------

                new dialog_string[512];
                format(dialog_string, sizeof(dialog_string), "\
                |-----| Bankarski Izvestaj |-----|\n\n\
                Uplata na ziro racun: {00FF00}%s\n\
                {FFFFFF}Uplaceno: {00FF00}%d dinara\n\
                {FFFF00}Penziono: {FF0000}100 dinara\n\
                {FFFFFF}Staro stanje: {FF0000}%d dinara\n\
                {FFFFFF}Novo stanje: {00FF00}%d dinara\n\n\
                |-----| Bankarski Izvestaj |-----|",
                ime, plata, stari_novac_banka, novo_stanje_banka);

                ShowPlayerDialog(playerid, 8501, DIALOG_STYLE_MSGBOX, "{00FF00}Zarada", dialog_string, "Ok", "");
                SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Cestitam, zavr?ili ste po?tarsku turu! Novac je uplacen na bankovni racun.");
            }
        }
        return 1;
    }

    return 1;
}

// Funkcija tajmera za aerodrom (skraceno ime da nema warninga)
forward PostaAerodromZavrsetak(playerid);
public PostaAerodromZavrsetak(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    TogglePlayerControllable(playerid, 1); // Odmrzavamo igraca nakon 10 sekundi

    // Postavljamo checkpoint nazad u magacin (tacka 0)
    SetPlayerCheckpoint(playerid, PostarRute[0][0], PostarRute[0][1], PostarRute[0][2], 4.0);
    PostarStep[playerid] = 16; // Oznaka da se sada vraca u magacin po isplatu

    SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Po?ta je utovarena! Vratite se nazad u magacin da zavr?ite turu.");
    return 1;
}
// --- /F (ORGANIZACIONI CHAT) ---
CMD:f(playerid, params[])
{
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    if(isnull(params))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Koristite: /f [Tekst poruke]");

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Gre?ka pri ucitavanju va?eg fajla!");

    new orgid = DOF2_GetInt(file, "Member");
    new rank = DOF2_GetInt(file, "Rank"); // Ocitavamo rank igraca iz fajla
    new is_lider = 0;

    new lideri_file[64] = "BalkanRP/Lideri.ini";
    if(DOF2_FileExists(lideri_file))
    {
        for(new i = 1; i <= 20; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name, true) == 0)
                {
                    orgid = i;
                    is_lider = 1;
                    break;
                }
            }
        }
    }

    if(orgid == 0)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Niste clan nijedne organizacije!");
    }

    new orgname[32];
    if(orgid == 1) orgname = "Policija";
    else if(orgid == 2) orgname = "Vojska";
    else if(orgid == 3) orgname = "?andarmerija";
    else if(orgid == 4) orgname = "Taxi";
    else if(orgid == 7) orgname = "Parking Servis";
    else orgname = "Organizacija";

    // Formatiramo poruku zavisno od organizacije, ranka i lidera
    new string[144];
    if(orgid == 4)
    {
        if(is_lider)
        {
            format(string, sizeof(string), "[%s] [?ef Taxi Company-e] %s: %s", orgname, name, params);
        }
        else
        {
            new taxi_rank_str[32];
            switch(rank)
            {
                case 1: format(taxi_rank_str, sizeof(taxi_rank_str), "Novi Radnik");
                case 2: format(taxi_rank_str, sizeof(taxi_rank_str), "Iskusni Radnik");
                case 3: format(taxi_rank_str, sizeof(taxi_rank_str), "Stariji Radnik");
                case 4: format(taxi_rank_str, sizeof(taxi_rank_str), "Penzioner");
                default: format(taxi_rank_str, sizeof(taxi_rank_str), "Rank %d", rank);
            }
            format(string, sizeof(string), "[%s] [%s] %s: %s", orgname, taxi_rank_str, name, params);
        }
    }
    else if(orgid == 7)
    {
        if(is_lider)
        {
            format(string, sizeof(string), "[%s] [?ef Parking Servisa] %s: %s", orgname, name, params);
        }
        else
        {
            new parking_rank_str[64];
            switch(rank)
            {
                case 1: format(parking_rank_str, sizeof(parking_rank_str), "Novi Radnik Parking servis-a");
                case 2: format(parking_rank_str, sizeof(parking_rank_str), "Iskusni radnik Parking servis-a");
                case 3: format(parking_rank_str, sizeof(parking_rank_str), "Stariji Radnik Parking servis-a");
                case 4: format(parking_rank_str, sizeof(parking_rank_str), "Z. Sefa Parking Servisa");
                default: format(parking_rank_str, sizeof(parking_rank_str), "Rank %d", rank);
            }
            format(string, sizeof(string), "[%s] [%s] %s: %s", orgname, parking_rank_str, name, params);
        }
    }
    else
    {
        if(is_lider)
        {
            format(string, sizeof(string), "[%s] [Lider] %s: %s", orgname, name, params);
        }
        else
        {
            format(string, sizeof(string), "[%s] [Rank %d] %s: %s", orgname, rank, name, params);
        }
    }

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new iname[MAX_PLAYER_NAME];
            GetPlayerName(i, iname, sizeof(iname));

            new ifile[128];
            format(ifile, sizeof(ifile), "Korisnici/%s.ini", iname);

            if(DOF2_FileExists(ifile))
            {
                new i_orgid = DOF2_GetInt(ifile, "Member");

                if(DOF2_FileExists(lideri_file))
                {
                    for(new l = 1; l <= 20; l++)
                    {
                        new key[32];
                        format(key, sizeof(key), "Lider_%d", l);
                        if(DOF2_IsSet(lideri_file, key))
                        {
                            new l_name[MAX_PLAYER_NAME];
                            format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                            if(strcmp(l_name, iname, true) == 0)
                            {
                                if(l == orgid) i_orgid = orgid;
                                break;
                            }
                        }
                    }
                }

                if(i_orgid == orgid)
                {
                    SendClientMessage(i, 0xF5DEB3FF, string); // Boja bele kafe
                }
            }
        }
    }

    return 1;
}
// --- /D (DEPARTMENT / DR?AVNI CHAT) ---
// --- /D (DEPARTMENT / DR?AVNI CHAT) ---
// --- /D (DEPARTMENT / DR?AVNI CHAT) ---
CMD:d(playerid, params[])
{
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    if(isnull(params))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Koristite: /d [Tekst radio veze]");

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    // 1. Procitamo podatke igraca iz njegovog fajla
    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Gre?ka pri ucitavanju va?eg fajla!");

    new orgid = DOF2_GetInt(file, "Member");
    new rank = DOF2_GetInt(file, "Rank"); // Citamo rank igraca iz fajla
    new is_lider = 0;

    new lideri_file[64] = "BalkanRP/Lideri.ini";
    if(DOF2_FileExists(lideri_file))
    {
        for(new i = 1; i <= 20; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name, true) == 0)
                {
                    orgid = i;
                    is_lider = 1;
                    break;
                }
            }
        }
    }

    if(orgid < 1 || orgid > 7)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Nemate pristup /d radio vezi!");
    }

    new orgname[32];
    switch(orgid)
    {
        case 1: orgname = "Policija";
        case 2: orgname = "Vojska";
        case 3: orgname = "?andarmerija";
        case 4: orgname = "Taxi";
        case 5: orgname = "Hitna Pomoc";
        case 6: orgname = "Parking Servis";
        case 7: orgname = "Novinari";
        default: orgname = "Slu?ba";
    }

    // Formatiramo poruku sa dodatim "Prijem." na kraju
    new string[144];
    if(is_lider)
    {
        if(orgid == 4)
        {
            format(string, sizeof(string), "[D] [%s] [?ef Taxi Company-e] %s: %s.. Prijem.", orgname, name, params);
        }
        else
        {
            format(string, sizeof(string), "[D] [%s] [Lider] %s: %s.. Prijem.", orgname, name, params);
        }
    }
    else
    {
        if(orgid == 4)
        {
            format(string, sizeof(string), "[D] [%s] [Clan Taxi Company-e] %s: %s.. Prijem.", orgname, name, params);
        }
        else
        {
            format(string, sizeof(string), "[D] [%s] [Rank %d] %s: %s.. Prijem.", orgname, rank, name, params);
        }
    }

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new iname[MAX_PLAYER_NAME];
            GetPlayerName(i, iname, sizeof(iname));

            new ifile[128];
            format(ifile, sizeof(ifile), "Korisnici/%s.ini", iname);

            if(DOF2_FileExists(ifile))
            {
                new i_orgid = DOF2_GetInt(ifile, "Member");

                if(DOF2_FileExists(lideri_file))
                {
                    for(new l = 1; l <= 20; l++)
                    {
                        new key[32];
                        format(key, sizeof(key), "Lider_%d", l);
                        if(DOF2_IsSet(lideri_file, key))
                        {
                            new l_name[MAX_PLAYER_NAME];
                            format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                            if(strcmp(l_name, iname, true) == 0)
                            {
                                if(l >= 1 && l <= 7) i_orgid = l;
                                break;
                            }
                        }
                    }
                }

                if(i_orgid >= 1 && i_orgid <= 7)
                {
                    // Ne?no ljubicasta/roze boja sa slike
                    SendClientMessage(i, 0xD8BFD8FF, string);
                }
            }
        }
    }

    return 1;
}
// --- /OOC (GLOBALNI OOC CHAT ZA ADMINE I VLASNIKA) ---
stock SendAdminOOC(playerid, const params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Koristite: /o [Tekst poruke]");

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    // 1. Procitamo fajl igraca da vidimo da li je admin/vlasnik
    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Gre?ka pri ucitavanju va?eg fajla!");

    new admin_level = DOF2_GetInt(file, "Admin"); // Proveravamo admin nivo (mo?e? promeniti kljuc ako se kod tebe drugacije zove, npr. "Vlasnik" ili "GM")

    // Ako igrac nema admin nivo (manji ili jednak 0), odbijamo pristustvo
    if(admin_level <= 0)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Samo administratori i vlasnik mogu koristiti /o chat!");
    }

    // Formatiramo poruku: [OOC] Ime: Tekst
    new string[144];
    format(string, sizeof(string), "[OOC] %s: %s", name, params);

    // Saljemo poruku celom serveru u narandzastoj boji
    SendClientMessageToAll(0xFF8C00FF, string);

    return 1;
}
// --- /GIVERANK (KOMANDA ZA LIDERA TAXIJA) ---
// --- /GIVERANK (KOMANDA ZA LIDERA TAXIJA) ---
CMD:giverank(playerid, params[])
{
    new targetid, newrank;
    if(sscanf(params, "ui", targetid, newrank))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Koristite: /giverank [ID/Ime] [Rank (1-4)]");

    new name_p[MAX_PLAYER_NAME], name_t[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name_p, sizeof(name_p));
    GetPlayerName(targetid, name_t, sizeof(name_t));

    // 1. Proveravamo da li je igrac koji kuca komandu lider (Taxi ID 4 ili Parking Servis ID 7)
    new file_p[128];
    format(file_p, sizeof(file_p), "Korisnici/%s.ini", name_p);

    if(!DOF2_FileExists(file_p))
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Gre?ka pri ucitavanju va?eg fajla!");

    new orgid = DOF2_GetInt(file_p, "Member");
    new is_lider = 0;

    new lideri_file[64] = "BalkanRP/Lideri.ini";
    if(DOF2_FileExists(lideri_file))
    {
        for(new i = 1; i <= 20; i++)
        {
            new key[32];
            format(key, sizeof(key), "Lider_%d", i);
            if(DOF2_IsSet(lideri_file, key))
            {
                new l_name[MAX_PLAYER_NAME];
                format(l_name, sizeof(l_name), "%s", DOF2_GetString(lideri_file, key));
                if(strcmp(l_name, name_p, true) == 0)
                {
                    orgid = i;
                    is_lider = 1;
                    break;
                }
            }
        }
    }

    // Provera da li je lider Taxi-ja (4) ili Parking Servisa (7)
    if(!is_lider || (orgid != 4 && orgid != 7))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Niste ovlasceni da korisite ovu komandu");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Igrac nije povezan na server!");

    // Proveravamo da li je meta clan iste organizacije
    new file_t[128];
    format(file_t, sizeof(file_t), "Korisnici/%s.ini", name_t);

    if(!DOF2_FileExists(file_t))
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Fajl tog igraca ne postoji!");

    if(DOF2_GetInt(file_t, "Member") != orgid)
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Taj igrac nije clan va?e organizacije!");

    if(newrank < 1 || newrank > 4)
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Rank mora biti izmedu 1 i 4!");

    // 2. Postavljamo novi rank u fajl igraca
    DOF2_SetInt(file_t, "Rank", newrank);

    // 3. Odredujemo skin prema ranku i organizaciji na isti nacin kao za Taxi
    new skinid = 259; // Podrazumevano

    if(orgid == 4) // Taxi skinovi
    {
        if(newrank == 1) skinid = 259;
        else if(newrank == 2) skinid = 258;
        else if(newrank == 3) skinid = 262;
        else if(newrank == 4) skinid = 255;
    }
    else if(orgid == 7) // Parking Servis skinovi (svaki rank zasebno)
    {
        if(newrank == 1) skinid = 16;
        else if(newrank == 2) skinid = 16;
        else if(newrank == 3) skinid = 16;
        else if(newrank == 4) skinid = 268;
    }

    // Upisujemo skin u fajl i setujemo ga igracu
    DOF2_SetInt(file_t, "Skin", skinid);
    SetPlayerSkin(targetid, skinid);
    DOF2_SaveFile();

    // Obave?tenja
    new string[128];
    format(string, sizeof(string), "Lider %s vam je promenio rank u %d.", name_p, newrank);
    SendClientMessage(targetid, 0x00BFFFFF, string);

    format(string, sizeof(string), "Uspesno ste postavili igracu %s rank %d i dodelili odgovarajuci skin.", name_t, newrank);
    SendClientMessage(playerid, 0x00BFFFFF, string);

    return 1;
}
forward ZatvoriParkingKapiju();
public ZatvoriParkingKapiju()
{
    MoveObject(kapija_parking, 1022.08948, -927.09814, 43.73440, 3.0); // Vraca je na zatvoreno
    return 1;
}
CMD:preuzmivozilo(playerid, params[])
{
    // Provera lokacije (samo kad je igrac pe?ke ovde)
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1019.4164, -927.8874, 42.1797))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste na mestu za preuzimanje vozila!");
        return 1;
    }

    // Provera novca
    if(GetPlayerMoney(playerid) < 500)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate dovoljno novca (potrebno vam je 500 RSD).");
        return 1;
    }

    // Oduzimanje novca
    GivePlayerMoney(playerid, -500);

    // Cuvanje novca u fajl (DOF2) da se ne vrati nakon restarta
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Novac", GetPlayerMoney(playerid));
        DOF2_SaveFile();
    }

    // Otvaranje kapije
    MoveObject(kapija_parking, 1022.08948, -927.09814, 38.39440, 3.0);
    SetTimer("ZatvoriParkingKapiju", 15000, false);

    SendClientMessage(playerid, 0x00FF00FF, "Otvorili ste kapiju Parking Servisa i naplaceno vam je 500 RSD za preuzimanje vozila.");
    return 1;
}
forward GladSystemTimer();
public GladSystemTimer()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new ime[MAX_PLAYER_NAME], file[128];
            GetPlayerName(i, ime, sizeof(ime));
            format(file, sizeof(file), "Korisnici/%s.ini", ime);

            if(DOF2_FileExists(file))
            {
                // Ako je admin na du?nosti (AdminDuty == 1), preskacemo ga da mu ne skida helt
                if(DOF2_GetInt(file, "AdminDuty") == 1)
                    continue;
            }

            // Uzimamo trenutni health igraca
            new Float:health;
            GetPlayerHealth(i, health);

            // Ako je helt veci od 10, oduzimamo pomalo (npr. 2.0 ili 3.0 da opada realno i lagano)
            if(health > 10.0)
            {
                health -= 3.0;
                SetPlayerHealth(i, health);

                // Kada padne na 10 ili ni?e, ispisujemo poruku da je gladan
                if(health <= 10.0)
                {
                    SendClientMessage(i, 0xFF6347FF, "[Balkan Revolution]: Jako ste gladni! Morate ne?to jesti da ne biste izgubili svest.");
                }
            }
        }
    }
    return 1;
}
forward ServerTipsTimer();
public ServerTipsTimer()
{
    new random_tip = random(29); // Isti savjet u chatu i na HUD-u, svakih 5 minuta.
    UpdateHudTip(random_tip);

    switch(random_tip)
    {
        case 0: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Niste sigurni gde da radite? Posetite op?tinu ili pitajte za pomoc (/askq).");
        case 1: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} ?elite da sacuvate novac? Otvorite racun u banci i koristite karticu.");
        case 2: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Ukoliko vam je potrebna pomoc administracije, postavite pitanje preko /askq komande.");
        case 3: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Redovno kupujte hranu da ne biste izgubili svest zbog sistema gladi!");
        case 4: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Clanovi svih organizacija mogu koristiti specijalni /f chat radi lak?e komunikacije sa kolegama.");
        case 5: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Nikada nikome ne otkrivajte svoju lozinku! Admini je nikada nece tra?iti.");
        case 6: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Posetite zlataru i iskoristite berzu zlata za pametno ulaganje i zaradu!");
        case 7: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Svoje vozilo uvek zakljucavajte komandom /lock kako biste sprecili kradu.");
        case 8: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Imate problem sa vozilom? Pozovite mehanicare ili posetite benzinsku pumpu.");
        case 9: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Kr?ite saobracajna pravila? Parking Servis vam lako mo?e odneti vozilo!");
        case 10: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} ?elite da saznate vi?e o serveru? Kucajte /help i istra?ite sve komande.");
        case 11: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Po?tujte RolePlay pravila i u?ivajte u igri. Srecan rad ?eli vam Balkan Revolution tim!");
        case 12: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Nemate gde da ?ivite? Kupite svoju kucu ili stan komandom /buyhouse.");
        case 13: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} U svojoj kuci mo?ete ostavljati novac u sef i menjati enterijer po ?elji.");
        case 14: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Kupite mobilni telefon i karticu na kiosku za komunikaciju sa igracima (/call).");
        case 15: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Treba vam oglas? Iskoristite /smsad komandu da oglasite prodaju ili potra?nju.");
        case 16: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Bavite se ilegalnim poslovima? Pazite se policije i organa reda.");
        case 17: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Kriminalne organizacije dr?e teritorije pod kontrolom. Saradujte sa kolegama.");
        case 18: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Organizujete ?urku? Pozovite prijatelje i iskoristite animacije za provod.");
        case 19: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} ?elite da promenite stil? Posetite butik odece i kupite novi skin.");
        case 20: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Tek stigli? Zaposlite se kao cistac ulica ili dostavljac da zaradite prvi novac.");
        case 21: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Istra?ite mapu i pronadite poslove koji vam najvi?e odgovaraju za zaradu!");
        case 22: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Posetite auto-?kolu i polo?ite vozacki ispit da vas policija ne bi kaznila.");
        case 23: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Za no?enje oru?ja potrebna vam je dozvola koju mo?ete izvaditi kod nadle?nih.");
        case 24: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Pazite na gorivo ? svratite na pumpu i napunite rezervoar komandom /fill.");
        case 25: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Va?e vozilo je o?teceno? Posetite mehanicarsku radionicu za popravku.");
        case 26: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Novac na banci vam je siguran i na njega dobijate kamatu pri svakoj plati!");
        case 27: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} ?elite da postanete preduzetnik? ?tedite novac i kupite sopstveni biznis.");
        case 28: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} ?elite da komunicirate sa ostalim igracima? Dodite na TeamSpeak da se dru?imo, a za normal se prijavite na na?em TS3 serveru!");
    }
    return 1;
}
stock SendBigEarLog(const string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && BigEar[i])
        {
            SendClientMessage(i, 0xFF9900FF, string); // Narand?asta boja
        }
    }
}
public OnPlayerText(playerid, text[])
{
    if(!CheckPlayerAntiSpam(playerid)) return 0;
    if(JuniorMutedUntil[playerid] > gettime())
    {
        SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
        return 0;
    }

    ReportProfanity(playerid, "ic", text);
    if(BrziPrstiActive && !strcmp(text, BrziPrstiKod, false))
    {
        BrziPrstiActive = false;
        GivePlayerMoney(playerid, BrziPrstiNagrada);
        PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
        new quickName[MAX_PLAYER_NAME], quickFile[128], quickMessage[160], quickAdminMessage[160];
        GetPlayerName(playerid, quickName, sizeof(quickName));
        format(quickFile, sizeof(quickFile), "Korisnici/%s.ini", quickName);
        if(DOF2_FileExists(quickFile))
        {
            DOF2_SetInt(quickFile, "Novac", PlayerInfo[playerid][pNovac]);
            DOF2_SaveFile();
        }
        format(quickMessage, sizeof(quickMessage), "[BRZI PRSTI]: %s je prvi ukucao %s i osvojio %d dinara!", quickName, BrziPrstiKod, BrziPrstiNagrada);
        format(quickAdminMessage, sizeof(quickAdminMessage), "[BRZI PRSTI]: %s[%d] je prvi ukucao %s i osvojio %d dinara!", quickName, playerid, BrziPrstiKod, BrziPrstiNagrada);
        for(new viewer = 0; viewer < MAX_PLAYERS; viewer++)
        {
            if(!IsPlayerConnected(viewer)) continue;
            if(HasAdminCommandAccess(viewer)) SendClientMessage(viewer, 0xFF6B35FF, quickAdminMessage);
            else SendClientMessage(viewer, 0xFF6B35FF, quickMessage);
        }
        return 0;
    }

    // 1. BIGEAR (Spy sistem) - ostaje globalan jer ti treba da cuje? sve
    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    new log_string[144];
    format(log_string, sizeof(log_string), "[BIGEAR CHAT] [ID: %d] %s: %s", playerid, ime, text);
    SendBigEarLog(log_string);

    // 2. LOKALNI RP CHAT (Ovo radi da se cuju samo ljudi u blizini)
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    new chatFile[128], chatAdmin = 0, chatHelper = 0, chatColor = 0xFFFFFFFF;
    format(chatFile, sizeof(chatFile), "Korisnici/%s.ini", ime);
    if(DOF2_FileExists(chatFile))
    {
        chatAdmin = DOF2_GetInt(chatFile, "Admin");
        chatHelper = DOF2_GetInt(chatFile, "Helper");
    }

    new str[144];
    if(JuniorSpectating[playerid] && chatAdmin > 0)
    {
        format(str, sizeof(str), "Administrator kaze: %s", text);
        chatColor = 0x000000FF;
    }
    else if(JuniorSpectating[playerid] && chatHelper > 0)
    {
        format(str, sizeof(str), "Helper kaze: %s", text);
        chatColor = 0x000000FF;
    }
    else format(str, sizeof(str), "%s kaze: %s", ime, text);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            // Provera udaljenosti (20.0 je radijus od 20 metara)
            if(IsPlayerInRangeOfPoint(i, 20.0, pos[0], pos[1], pos[2]))
            {
                SendClientMessage(i, chatColor, str);
            }
        }
    }

    return 0; // VRLO VA?NO: Vracamo 0 da sprecimo SA-MP da duplira poruku (globalno)
}
CMD:bigear(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    // Samo Admin Level 9 ili RCON admin
    if(admin_lvl < 9 && !IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Niste ovla?ceni! Komanda je samo za Vlasnika (Level 9) i RCON admine.");
        return 1;
    }

    BigEar[playerid] = !BigEar[playerid]; // Pali / Gasi

    if(BigEar[playerid])
    {
        SendClientMessage(playerid, 0x00FF00FF, "[Balkan Revolution]: BigEar je UKLJUCEN. Pratite sve akcije igraca.");
    }
    else
    {
        SendClientMessage(playerid, 0x00FF00FF, "[Balkan Revolution]: BigEar je ISKLJUCEN.");
    }
    return 1;
}
CMD:veh(playerid, params[])
{
    new playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));

    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", playername);

    new admin_level = 0;

    // Ako igracev .ini fajl postoji, citamo direktno iz njega koliki mu je admin level
    if(DOF2_FileExists(file))
    {
        admin_level = DOF2_GetInt(file, "Admin");
    }

    // Provera: Ako mu je admin level manji od 3 I nije RCON admin -> odbij komandu
    if(admin_level < 3 && !IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Nemate ovla?cenje da koristite ovu komandu!");
        return 1;
    }

    new modelid;
    if(sscanf(params, "i", modelid))
    {
        SendClientMessage(playerid, 0xB4B4B4FF, "[KORI?CENJE]: /veh [ID Vozila (400 - 611)]");
        return 1;
    }

    if(modelid < 400 || modelid > 611)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: ID vozila mora biti izmedu 400 i 611!");
        return 1;
    }

    new Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);

    x += 3.0 * floatsin(-angle, degrees);
    y += 3.0 * floatcos(-angle, degrees);

    new vehicleid = CreateVehicle(modelid, x, y, z, angle, -1, -1, 60000);
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES)
        return SendClientMessage(playerid, 0xFF0000FF, "[VOZILO]: Stvaranje vozila nije uspjelo.");
    AdminSpawnedVehicle[vehicleid] = true;
    // Novi /veh moze dobiti ID ranije unistenog vozila; ocisti sve staro stanje tog ID-a.
    VehicleHudInitialized[vehicleid] = false;
    VehicleHudOutOfFuel[vehicleid] = false;
    VehicleHudLastPosValid[vehicleid] = false;
    VehicleHudBrokenNotice[vehicleid] = false;
    VehicleHudStalled[vehicleid] = false;
    VehicleHudNextStartTry[vehicleid] = 0;
    VehicleHudNextStallAt[vehicleid] = 0;
    VehicleHudLastDamage[vehicleid] = 0;
    VehicleHudInitData(vehicleid);
    PutPlayerInVehicle(playerid, vehicleid, 0);

    SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Uspe?no ste stvorili vozilo.");
    return 1;
}
// Ako koristi? ZCMD:
stock ResetPlayerJobRuntimeData(playerid)
{
    PlayerJobData[playerid][JobID] = JOB_NONE;
    PlayerJobData[playerid][JobLevel] = 0;
    PlayerJobData[playerid][JobXP] = 0;
    PlayerJobData[playerid][JobDuty] = false;
    PlayerJobData[playerid][JobStage] = JOB_STAGE_NONE;
    PlayerJobData[playerid][JobVehicle] = 0;
    PlayerJobData[playerid][JobCargo] = 0;
    PlayerJobData[playerid][JobCheckpoint] = 0;
    PlayerJobData[playerid][JobObject] = 0;
    PlayerJobData[playerid][JobTaskSerial]++;
    PlayerJobData[playerid][JobPreviousSkin] = 0;
    RibolovacAktivnoMjesto[playerid] = -1;
    RibolovacStartX[playerid] = 0.0;
    RibolovacStartY[playerid] = 0.0;
    RibolovacStartZ[playerid] = 0.0;
    RibolovacUkupnoGrama[playerid] = 0;
    RibolovacVrijednost[playerid] = 0;
    for(new fish = 0; fish < MAX_RIBOLOVAC_RIBA; fish++)
        RibolovacRibaKolicina[playerid][fish] = 0;
    for(new bait = 0; bait < MAX_RIBOLOVAC_MAMACA; bait++)
        RibolovacMamac[playerid][bait] = 0;
    RibolovacAktivniMamac[playerid] = -1;
    RibolovacKoristeniMamac[playerid] = -1;
    RibolovacStap[playerid] = 0;
    RibolovacOffshoreAttempt[playerid] = false;
    return 1;
}

public SaveRibolovacCatch(playerid)
{
    if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn")) return 0;
    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file))) return 0;

    DOF2_SetInt(file, "RibolovacUlov", PlayerJobData[playerid][JobCargo]);
    DOF2_SetInt(file, "RibolovacTezina", RibolovacUkupnoGrama[playerid]);
    DOF2_SetInt(file, "RibolovacVrijednost", RibolovacVrijednost[playerid]);
    DOF2_SetInt(file, "RibolovacSardina", RibolovacRibaKolicina[playerid][0]);
    DOF2_SetInt(file, "RibolovacSkusa", RibolovacRibaKolicina[playerid][1]);
    DOF2_SetInt(file, "RibolovacBrancin", RibolovacRibaKolicina[playerid][2]);
    DOF2_SetInt(file, "RibolovacTuna", RibolovacRibaKolicina[playerid][3]);
    DOF2_SetInt(file, "RibolovacLignjaUlov", RibolovacRibaKolicina[playerid][4]);
    DOF2_SetInt(file, "RibolovacVelikaTuna", RibolovacRibaKolicina[playerid][5]);
    DOF2_SetInt(file, "RibolovacSabljarka", RibolovacRibaKolicina[playerid][6]);
    DOF2_SetInt(file, "RibolovacJastog", RibolovacRibaKolicina[playerid][7]);
    DOF2_SetInt(file, "RibolovacMorskiPas", RibolovacRibaKolicina[playerid][8]);
    DOF2_SaveFile();
    return 1;
}

public SaveRibolovacBait(playerid)
{
    if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn")) return 0;
    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file))) return 0;
    DOF2_SetInt(file, "RibolovacMamacHljeb", RibolovacMamac[playerid][0]);
    DOF2_SetInt(file, "RibolovacMamacCrvi", RibolovacMamac[playerid][1]);
    DOF2_SetInt(file, "RibolovacMamacLignja", RibolovacMamac[playerid][2]);
    DOF2_SetInt(file, "RibolovacAktivniMamac", RibolovacAktivniMamac[playerid]);
    DOF2_SaveFile();
    return 1;
}

stock GetRibolovacCatchChance(baitid)
{
    switch(baitid)
    {
        case 0: return 60;
        case 1: return 72;
        case 2: return 85;
    }
    return 0;
}

stock GetRibolovacFishForBait(playerid, baitid)
{
    new roll = random(100);
    switch(baitid)
    {
        case 0:
        {
            if(roll < 80) return 0;
            return 1;
        }
        case 1:
        {
            if(roll < 35) return 0;
            if(roll < 85 || PlayerJobData[playerid][JobLevel] < 3) return 1;
            return 2;
        }
        case 2:
        {
            if(PlayerJobData[playerid][JobLevel] < 3)
            {
                if(roll < 25) return 0;
                return 1;
            }
            if(PlayerJobData[playerid][JobLevel] < 5)
            {
                if(roll < 15) return 0;
                if(roll < 50) return 1;
                return 2;
            }
            if(roll < 10) return 0;
            if(roll < 35) return 1;
            if(roll < 75) return 2;
            return 3;
        }
    }
    return 0;
}

stock ClearRibolovacCatchData(playerid)
{
    PlayerJobData[playerid][JobCargo] = 0;
    RibolovacUkupnoGrama[playerid] = 0;
    RibolovacVrijednost[playerid] = 0;
    for(new fish = 0; fish < MAX_RIBOLOVAC_RIBA; fish++)
        RibolovacRibaKolicina[playerid][fish] = 0;
    return 1;
}

stock GetRibolovacNextLevelXP(level)
{
    switch(level)
    {
        case 1: return 750;
        case 2: return 1750;
        case 3: return 3500;
        case 4: return 6000;
    }
    return 0;
}

stock GetOldRibolovacTotalXP(level, xp)
{
    new total = xp;
    if(level > 1) total += 500;
    if(level > 2) total += 1000;
    if(level > 3) total += 1500;
    if(level > 4) total += 2250;
    if(level > 5) total += 2750;
    if(level > 6) total += 3500;
    if(level > 7) total += 4000;
    if(level > 8) total += 4500;
    if(level > 9) total += 5000;
    return total;
}

stock MigrateRibolovacLevel(playerid, file[])
{
    if(DOF2_GetInt(file, "RibolovacLevelVersion") >= RIBOLOVAC_LEVEL_VERSION) return 0;
    new total = GetOldRibolovacTotalXP(PlayerJobData[playerid][JobLevel], PlayerJobData[playerid][JobXP]);
    new level = 1;
    while(level < RIBOLOVAC_MAX_LEVEL && total >= GetRibolovacNextLevelXP(level))
    {
        total -= GetRibolovacNextLevelXP(level);
        level++;
    }
    PlayerJobData[playerid][JobLevel] = level;
    PlayerJobData[playerid][JobXP] = (level >= RIBOLOVAC_MAX_LEVEL) ? 0 : total;
    DOF2_SetInt(file, "JobLevel_3", PlayerJobData[playerid][JobLevel]);
    DOF2_SetInt(file, "JobXP_3", PlayerJobData[playerid][JobXP]);
    DOF2_SetInt(file, "RibolovacLevelVersion", RIBOLOVAC_LEVEL_VERSION);
    return 1;
}

stock AddRibolovacXP(playerid, amount, file[])
{
    if(amount <= 0) return 0;
    if(PlayerJobData[playerid][JobXP] < 0) PlayerJobData[playerid][JobXP] = 0;
    if(PlayerJobData[playerid][JobXP] > MAX_MONEY_VALUE - amount) PlayerJobData[playerid][JobXP] = MAX_MONEY_VALUE;
    else PlayerJobData[playerid][JobXP] += amount;
    new oldLevel = PlayerJobData[playerid][JobLevel];
    while(PlayerJobData[playerid][JobLevel] < RIBOLOVAC_MAX_LEVEL &&
          PlayerJobData[playerid][JobXP] >= GetRibolovacNextLevelXP(PlayerJobData[playerid][JobLevel]))
    {
        PlayerJobData[playerid][JobXP] -= GetRibolovacNextLevelXP(PlayerJobData[playerid][JobLevel]);
        PlayerJobData[playerid][JobLevel]++;
    }
    if(PlayerJobData[playerid][JobLevel] >= RIBOLOVAC_MAX_LEVEL) PlayerJobData[playerid][JobXP] = 0;

    DOF2_SetInt(file, "JobXP_3", PlayerJobData[playerid][JobXP]);
    DOF2_SetInt(file, "JobLevel_3", PlayerJobData[playerid][JobLevel]);
    if(PlayerJobData[playerid][JobLevel] > oldLevel)
    {
        new levelMessage[112];
        format(levelMessage, sizeof(levelMessage), "[POSAO]: Napredovali ste na job level %d!", PlayerJobData[playerid][JobLevel]);
        SendClientMessage(playerid, 0xFFD700FF, levelMessage);
    }
    return 1;
}

stock bool:IsPlayerFacingFishingWater(playerid)
{
    new Float:angle;
    GetPlayerFacingAngle(playerid, angle);
    return angle >= 135.0 && angle <= 225.0;
}

stock LoadPlayerJobData(playerid)
{
    new file[128];
    ResetPlayerJobRuntimeData(playerid);
    if(!GetPlayerAccountPath(playerid, file, sizeof(file))) return 0;

    new jobid = DOF2_IsSet(file, "Posao") ? DOF2_GetInt(file, "Posao") : JOB_NONE;
    if(jobid < JOB_NONE || jobid > JOB_RIBOLOVAC) jobid = JOB_NONE;
    PlayerJobData[playerid][JobID] = jobid;

    if(jobid != JOB_NONE)
    {
        new levelKey[24], xpKey[24];
        format(levelKey, sizeof(levelKey), "JobLevel_%d", jobid);
        format(xpKey, sizeof(xpKey), "JobXP_%d", jobid);
        if(!DOF2_IsSet(file, levelKey)) DOF2_SetInt(file, levelKey, 1);
        if(!DOF2_IsSet(file, xpKey)) DOF2_SetInt(file, xpKey, 0);
        PlayerJobData[playerid][JobLevel] = DOF2_GetInt(file, levelKey);
        PlayerJobData[playerid][JobXP] = DOF2_GetInt(file, xpKey);
        if(PlayerJobData[playerid][JobLevel] < 1) PlayerJobData[playerid][JobLevel] = 1;
        if(PlayerJobData[playerid][JobXP] < 0) PlayerJobData[playerid][JobXP] = 0;
        if(jobid == JOB_RIBOLOVAC)
        {
            MigrateRibolovacLevel(playerid, file);
            if(PlayerJobData[playerid][JobLevel] > RIBOLOVAC_MAX_LEVEL) PlayerJobData[playerid][JobLevel] = RIBOLOVAC_MAX_LEVEL;
            while(PlayerJobData[playerid][JobLevel] < RIBOLOVAC_MAX_LEVEL &&
                  PlayerJobData[playerid][JobXP] >= GetRibolovacNextLevelXP(PlayerJobData[playerid][JobLevel]))
            {
                PlayerJobData[playerid][JobXP] -= GetRibolovacNextLevelXP(PlayerJobData[playerid][JobLevel]);
                PlayerJobData[playerid][JobLevel]++;
            }
            if(PlayerJobData[playerid][JobLevel] >= RIBOLOVAC_MAX_LEVEL) PlayerJobData[playerid][JobXP] = 0;
            DOF2_SetInt(file, "JobLevel_3", PlayerJobData[playerid][JobLevel]);
            DOF2_SetInt(file, "JobXP_3", PlayerJobData[playerid][JobXP]);
            PlayerJobData[playerid][JobCargo] = DOF2_GetInt(file, "RibolovacUlov");
            if(PlayerJobData[playerid][JobCargo] < 0) PlayerJobData[playerid][JobCargo] = 0;
            if(PlayerJobData[playerid][JobCargo] > RIBOLOVAC_MAX_ULOV) PlayerJobData[playerid][JobCargo] = RIBOLOVAC_MAX_ULOV;
            RibolovacUkupnoGrama[playerid] = DOF2_GetInt(file, "RibolovacTezina");
            RibolovacVrijednost[playerid] = DOF2_GetInt(file, "RibolovacVrijednost");
            RibolovacRibaKolicina[playerid][0] = DOF2_GetInt(file, "RibolovacSardina");
            RibolovacRibaKolicina[playerid][1] = DOF2_GetInt(file, "RibolovacSkusa");
            RibolovacRibaKolicina[playerid][2] = DOF2_GetInt(file, "RibolovacBrancin");
            RibolovacRibaKolicina[playerid][3] = DOF2_GetInt(file, "RibolovacTuna");
            RibolovacRibaKolicina[playerid][4] = DOF2_GetInt(file, "RibolovacLignjaUlov");
            RibolovacRibaKolicina[playerid][5] = DOF2_GetInt(file, "RibolovacVelikaTuna");
            RibolovacRibaKolicina[playerid][6] = DOF2_GetInt(file, "RibolovacSabljarka");
            RibolovacRibaKolicina[playerid][7] = DOF2_GetInt(file, "RibolovacJastog");
            RibolovacRibaKolicina[playerid][8] = DOF2_GetInt(file, "RibolovacMorskiPas");
            RibolovacStap[playerid] = DOF2_IsSet(file, "RibolovacStap") ? DOF2_GetInt(file, "RibolovacStap") : 0;
            if(RibolovacStap[playerid] < 0 || RibolovacStap[playerid] > 2) RibolovacStap[playerid] = 0;
            RibolovacMamac[playerid][0] = DOF2_GetInt(file, "RibolovacMamacHljeb");
            RibolovacMamac[playerid][1] = DOF2_GetInt(file, "RibolovacMamacCrvi");
            RibolovacMamac[playerid][2] = DOF2_GetInt(file, "RibolovacMamacLignja");
            if(RibolovacUkupnoGrama[playerid] < 0) RibolovacUkupnoGrama[playerid] = 0;
            if(RibolovacUkupnoGrama[playerid] > 500000) RibolovacUkupnoGrama[playerid] = 500000;
            if(RibolovacVrijednost[playerid] < 0) RibolovacVrijednost[playerid] = 0;
            if(RibolovacVrijednost[playerid] > 10000000) RibolovacVrijednost[playerid] = 10000000;
            new loadedFishCount = 0;
            for(new fish = 0; fish < MAX_RIBOLOVAC_RIBA; fish++)
            {
                if(RibolovacRibaKolicina[playerid][fish] < 0) RibolovacRibaKolicina[playerid][fish] = 0;
                if(RibolovacRibaKolicina[playerid][fish] > RIBOLOVAC_MAX_ULOV) RibolovacRibaKolicina[playerid][fish] = RIBOLOVAC_MAX_ULOV;
                loadedFishCount += RibolovacRibaKolicina[playerid][fish];
            }
            if(loadedFishCount > RIBOLOVAC_MAX_ULOV)
            {
                PlayerJobData[playerid][JobCargo] = 0;
                RibolovacUkupnoGrama[playerid] = 0;
                RibolovacVrijednost[playerid] = 0;
                for(new fish = 0; fish < MAX_RIBOLOVAC_RIBA; fish++) RibolovacRibaKolicina[playerid][fish] = 0;
            }
            else PlayerJobData[playerid][JobCargo] = loadedFishCount;
            for(new bait = 0; bait < MAX_RIBOLOVAC_MAMACA; bait++)
                if(RibolovacMamac[playerid][bait] < 0) RibolovacMamac[playerid][bait] = 0;
            RibolovacAktivniMamac[playerid] = DOF2_GetInt(file, "RibolovacAktivniMamac");
            if(RibolovacAktivniMamac[playerid] < -1 || RibolovacAktivniMamac[playerid] >= MAX_RIBOLOVAC_MAMACA)
                RibolovacAktivniMamac[playerid] = -1;
            if(DOF2_GetInt(file, "RibolovacUniformaAktivna"))
                DOF2_SetInt(file, "RibolovacUniformaAktivna", 0);
        }
        DOF2_SaveFile();
    }
    return 1;
}

stock ResetPlayerJobTask(playerid, bool:endDuty = false, bool:clearCargo = true)
{
    new bool:wasFishing = PlayerJobData[playerid][JobStage] == JOB_STAGE_FISHING;
    if(PlayerJobData[playerid][JobCheckpoint])
    {
        if(IsPlayerConnected(playerid)) DisablePlayerCheckpoint(playerid);
        PlayerJobData[playerid][JobCheckpoint] = 0;
    }
    if(PlayerJobData[playerid][JobObject])
    {
        if(IsPlayerConnected(playerid)) RemovePlayerAttachedObject(playerid, RIBOLOVAC_STAP_SLOT);
        PlayerJobData[playerid][JobObject] = 0;
    }
    if(IsPlayerConnected(playerid) && IsPlayerAttachedObjectSlotUsed(playerid, RIBOLOVAC_MAMAC_SLOT))
        RemovePlayerAttachedObject(playerid, RIBOLOVAC_MAMAC_SLOT);
    if(IsPlayerConnected(playerid) && PlayerJobData[playerid][JobStage] != JOB_STAGE_NONE)
        ClearAnimations(playerid);
    if(wasFishing && IsPlayerConnected(playerid) && !JuniorFrozen[playerid] && !IsHealing[playerid])
        TogglePlayerControllable(playerid, 1);

    PlayerJobData[playerid][JobStage] = JOB_STAGE_NONE;
    PlayerJobData[playerid][JobVehicle] = 0;
    if(clearCargo)
    {
        ClearRibolovacCatchData(playerid);
        SaveRibolovacCatch(playerid);
    }
    PlayerJobData[playerid][JobTaskSerial]++;
    RibolovacAktivnoMjesto[playerid] = -1;
    RibolovacKoristeniMamac[playerid] = -1;
    if(endDuty) PlayerJobData[playerid][JobDuty] = false;
    return 1;
}

stock SetPlayerJobData(playerid, jobid)
{
    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file))) return 0;

    ResetPlayerJobTask(playerid, true);
    DOF2_SetInt(file, "Posao", jobid);
    PlayerJobData[playerid][JobID] = jobid;
    PlayerJobData[playerid][JobLevel] = 0;
    PlayerJobData[playerid][JobXP] = 0;

    if(jobid != JOB_NONE)
    {
        new levelKey[24], xpKey[24];
        format(levelKey, sizeof(levelKey), "JobLevel_%d", jobid);
        format(xpKey, sizeof(xpKey), "JobXP_%d", jobid);
        if(!DOF2_IsSet(file, levelKey)) DOF2_SetInt(file, levelKey, 1);
        if(!DOF2_IsSet(file, xpKey)) DOF2_SetInt(file, xpKey, 0);
        PlayerJobData[playerid][JobLevel] = DOF2_GetInt(file, levelKey);
        PlayerJobData[playerid][JobXP] = DOF2_GetInt(file, xpKey);
        if(jobid == JOB_RIBOLOVAC)
        {
            MigrateRibolovacLevel(playerid, file);
            RibolovacStap[playerid] = DOF2_IsSet(file, "RibolovacStap") ? DOF2_GetInt(file, "RibolovacStap") : 0;
            if(RibolovacStap[playerid] < 0 || RibolovacStap[playerid] > 2) RibolovacStap[playerid] = 0;
        }
    }
    DOF2_SaveFile();
    return 1;
}
stock FindJobBusiness(jobid)
{
    for(new marketid = 0; marketid < MAX_MARKETA; marketid++)
    {
        if(MarketInfo[marketid][mEntranceX] != 0.0 && MarketInfo[marketid][mType] == BIZ_TYPE_JOB && MarketInfo[marketid][mJobId] == jobid)
            return marketid;
    }
    return -1;
}

stock SplitJobPayment(jobid, grossPayment, &businessShare, &businessId)
{
    businessShare = 0;
    businessId = FindJobBusiness(jobid);
    if(businessId == -1 || grossPayment <= 0) return grossPayment;
    businessShare = ((grossPayment / 100) * 40) + (((grossPayment % 100) * 40) / 100);
    if(MarketInfo[businessId][mBudzet] < 0) MarketInfo[businessId][mBudzet] = 0;
    if(businessShare <= 0 || MarketInfo[businessId][mBudzet] > MAX_MONEY_VALUE - businessShare)
    {
        businessShare = 0;
        businessId = -1;
        return grossPayment;
    }
    MarketInfo[businessId][mBudzet] += businessShare;
    SaveMarket(businessId);
    UpdateMarketCP(businessId);
    return grossPayment - businessShare;
}

public SellRibolovacCatch(playerid)
{
    if(PlayerJobData[playerid][JobCargo] <= 0) return 0;

    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file))) return 0;

    new soldCount = PlayerJobData[playerid][JobCargo];
    new paymentLevel = PlayerJobData[playerid][JobLevel];
    new levelBonus = (RibolovacVrijednost[playerid] * (paymentLevel - 1) * 5) / 100;
    new payment = RibolovacVrijednost[playerid] + levelBonus;
    new xp = (soldCount * 3) + random(soldCount + 1);

    if(HappyJobId == JOB_RIBOLOVAC)
    {
        payment *= 2;
        SendClientMessage(playerid, 0xFFD700FF, "[HAPPY JOB]: Ribolovac je aktivan. Vrijednost prodatog ulova je udvostrucena.");
    }

    new previousBonusProgress = DOF2_GetInt(file, "RibolovacBonusRibe");
    if(previousBonusProgress < 0 || previousBonusProgress >= 45) previousBonusProgress = 0;
    new bonusProgress = previousBonusProgress + soldCount;
    new bonusCount = bonusProgress / 45;
    bonusProgress %= 45;
    payment += bonusCount * 500;

    new oldBank = DOF2_IsSet(file, "Banka") ? DOF2_GetInt(file, "Banka") : 0;
    if(payment <= 0 || oldBank > MAX_MONEY_VALUE - payment)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Bankovni racun ne moze primiti ovu uplatu. Ulov nije obrisan.");

    DOF2_SetInt(file, "RibolovacBonusRibe", bonusProgress);

    new businessShare, businessId;
    payment = SplitJobPayment(JOB_RIBOLOVAC, payment, businessShare, businessId);

    new newBank = oldBank + payment;
    DOF2_SetInt(file, "Banka", newBank);
    UpdateBankaTD(playerid, newBank);
    AddRibolovacXP(playerid, xp, file);

    new playerName[MAX_PLAYER_NAME], bankReport[512];
    GetPlayerName(playerid, playerName, sizeof(playerName));
    format(bankReport, sizeof(bankReport),
        "{33CCFF}|---| Bankarski izvjestaj |---|\n\n" \
        "{FFFFFF}Uplata na ziro racun: {33CCFF}%s\n" \
        "{FFFFFF}Uplaceno: {00FF00}%d dinara\n" \
        "{FFFFFF}Staro stanje: {FF0000}%d dinara\n" \
        "{FFFFFF}Novo stanje: {00FF00}%d dinara\n\n" \
        "{33CCFF}|---| Bankarski izvjestaj |---|",
        playerName, payment, oldBank, newBank);
    ShowPlayerDialog(playerid, DIALOG_RIBOLOVAC_ZARADA, DIALOG_STYLE_MSGBOX,
        "{33CCFF}Zarada", bankReport, "Ok", "");

    new saleMessage[180];
    if(businessShare > 0)
        format(saleMessage, sizeof(saleMessage), "[POSAO]: Prodali ste %d riba. Vama: %d RSD (60%%), biznisu: %d RSD (40%%), XP: %d.", soldCount, payment, businessShare, xp);
    else
        format(saleMessage, sizeof(saleMessage), "[POSAO]: Prodali ste %d riba za %d RSD, novac je uplacen na banku i dobili ste %d job XP-a.", soldCount, payment, xp);
    SendClientMessage(playerid, 0x00FF00FF, saleMessage);
    if(levelBonus > 0)
    {
        format(saleMessage, sizeof(saleMessage), "[POSAO]: Bonus za job level %d iznosi %d RSD.", paymentLevel, levelBonus);
        SendClientMessage(playerid, 0xFFD700FF, saleMessage);
    }
    if(bonusCount > 0)
    {
        format(saleMessage, sizeof(saleMessage), "[POSAO BONUS]: Prodali ste ukupno 45 riba i dobili bonus od %d RSD.", bonusCount * 500);
        SendClientMessage(playerid, 0x00FF00FF, saleMessage);
    }
    ClearRibolovacCatchData(playerid);
    SaveRibolovacCatch(playerid);
    DOF2_SaveFile();
    return 1;
}

public UpdateRibolovacBaitObject(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(IsPlayerAttachedObjectSlotUsed(playerid, RIBOLOVAC_MAMAC_SLOT))
        RemovePlayerAttachedObject(playerid, RIBOLOVAC_MAMAC_SLOT);

    if(!PlayerJobData[playerid][JobDuty]) return 1;
    new baitid = RibolovacAktivniMamac[playerid];
    if(baitid < 0 || baitid >= MAX_RIBOLOVAC_MAMACA) return 1;
    if(RibolovacMamac[playerid][baitid] <= 0 && RibolovacKoristeniMamac[playerid] != baitid) return 1;

    switch(baitid)
    {
        case 0: SetPlayerAttachedObject(playerid, RIBOLOVAC_MAMAC_SLOT, 19883, 5,
            0.070, 0.025, 0.010, 0.0, 85.0, 15.0, 0.28, 0.28, 0.28);
        case 1: SetPlayerAttachedObject(playerid, RIBOLOVAC_MAMAC_SLOT, 19087, 5,
            0.060, 0.020, 0.000, 0.0, 90.0, 0.0, 0.018, 0.018, 0.035);
        case 2: SetPlayerAttachedObject(playerid, RIBOLOVAC_MAMAC_SLOT, 1602, 5,
            0.080, 0.025, -0.010, 90.0, 0.0, 0.0, 0.08, 0.08, 0.08);
    }
    return 1;
}

stock GiveRibolovacEquipment(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(IsPlayerAttachedObjectSlotUsed(playerid, RIBOLOVAC_STAP_SLOT))
        RemovePlayerAttachedObject(playerid, RIBOLOVAC_STAP_SLOT);

    PlayerJobData[playerid][JobObject] = 0;
    if(RibolovacStap[playerid] <= 0) return 0;
    SetPlayerAttachedObject(playerid, RIBOLOVAC_STAP_SLOT, RIBOLOVAC_STAP_MODEL, 6,
        0.079376, 0.037070, 0.007706,
        181.482910, 0.000000, 0.000000,
        1.000000, 1.000000, 1.000000);
    PlayerJobData[playerid][JobObject] = 1;
    return 1;
}

stock StartRibolovacTask(playerid)
{
    if(!IsPlayerConnected(playerid) || !PlayerJobData[playerid][JobDuty] ||
       PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC) return 0;

    if(RibolovacStap[playerid] > 0 && (!PlayerJobData[playerid][JobObject] ||
       !IsPlayerAttachedObjectSlotUsed(playerid, RIBOLOVAC_STAP_SLOT))) GiveRibolovacEquipment(playerid);
    RibolovacKoristeniMamac[playerid] = -1;
    UpdateRibolovacBaitObject(playerid);

    if(PlayerJobData[playerid][JobCheckpoint])
    {
        DisablePlayerCheckpoint(playerid);
        PlayerJobData[playerid][JobCheckpoint] = 0;
    }
    RibolovacAktivnoMjesto[playerid] = -1;

    if(PlayerJobData[playerid][JobCargo] >= RIBOLOVAC_MAX_ULOV)
    {
        PlayerJobData[playerid][JobStage] = JOB_STAGE_RETURN_TO_MARKET;
        SendClientMessage(playerid, 0xFFFF00FF, "[POSAO]: Mreza je puna. Odnesite ribu do standa u pristanistu i koristite /prodajribu.");
        return 1;
    }

    PlayerJobData[playerid][JobStage] = JOB_STAGE_READY_TO_FISH;
    if(IsPlayerInOffshoreFishingZone(playerid) && IsPlayerInOwnRentedFishingBoat(playerid))
        SendClientMessage(playerid, 0x33CCFFFF, "[POSAO]: Nalazite se u offshore zoni. Pritisnite lijevi klik za premium pecanje iz broda.");
    else
        SendClientMessage(playerid, 0x33CCFFFF, "[POSAO]: Za pecanje idite na kraj doka, okrenite se prema vodi i pritisnite lijevi klik.");
    return 1;
}

forward StartFishingIdle(playerid, serial);
public StartFishingIdle(playerid, serial)
{
    if(!IsPlayerConnected(playerid) || serial != PlayerJobData[playerid][JobTaskSerial]) return 1;
    if(!PlayerJobData[playerid][JobDuty] || PlayerJobData[playerid][JobStage] != JOB_STAGE_FISHING) return 1;
    if(RibolovacOffshoreAttempt[playerid]) return 1;
    ApplyAnimation(playerid, "SAMP", "FishingIdle", 4.1, 1, 0, 0, 1, 0, 1);
    return 1;
}

forward FinishFishingAttempt(playerid, serial);
public FinishFishingAttempt(playerid, serial)
{
    if(!IsPlayerConnected(playerid) || serial != PlayerJobData[playerid][JobTaskSerial]) return 1;
    if(!PlayerJobData[playerid][JobDuty] || PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC ||
       PlayerJobData[playerid][JobStage] != JOB_STAGE_FISHING) return 1;

    if(!JuniorFrozen[playerid] && !IsHealing[playerid]) TogglePlayerControllable(playerid, 1);
    new spot = RibolovacAktivnoMjesto[playerid];
    new bool:offshore = RibolovacOffshoreAttempt[playerid];
    if((offshore && (!IsPlayerInOffshoreFishingZone(playerid) || !IsPlayerInOwnRentedFishingBoat(playerid) ||
        PlayerJobData[playerid][JobLevel] < RIBOLOVAC_MAX_LEVEL || RibolovacStap[playerid] < 2)) ||
       (!offshore && (spot < 0 || spot >= MAX_RIBOLOVAC_MJESTA ||
        GetPlayerDistanceFromPoint(playerid, RibolovacStartX[playerid], RibolovacStartY[playerid], RibolovacStartZ[playerid]) > 2.5 ||
        !IsPlayerInRangeOfPoint(playerid, 2.2, RibolovacMjesta[spot][0], RibolovacMjesta[spot][1], RibolovacMjesta[spot][2]) ||
        !IsPlayerFacingFishingWater(playerid))))
    {
        RibolovacOffshoreAttempt[playerid] = false;
        ClearAnimations(playerid);
        SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Udaljili ste se od ribolovnog mjesta. Pokusaj je prekinut.");
        return StartRibolovacTask(playerid);
    }

    PlayerJobData[playerid][JobStage] = JOB_STAGE_CATCH_READY;
    new usedBait = RibolovacKoristeniMamac[playerid];
    RibolovacKoristeniMamac[playerid] = -1;
    RibolovacOffshoreAttempt[playerid] = false;
    UpdateRibolovacBaitObject(playerid);
    if(random(100) < GetRibolovacCatchChance(usedBait))
    {
        new fishid = offshore ? GetOffshoreFishingCatch() : GetRibolovacFishForBait(playerid, usedBait);
        new grams = RibolovacRibe[fishid][RibaMinGrama] +
            random(RibolovacRibe[fishid][RibaMaxGrama] - RibolovacRibe[fishid][RibaMinGrama] + 1);
        new value = (grams * RibolovacRibe[fishid][RibaCijenaPoKg]) / 1000;
        if(value < 1) value = 1;

        PlayerJobData[playerid][JobCargo]++;
        RibolovacRibaKolicina[playerid][fishid]++;
        RibolovacUkupnoGrama[playerid] += grams;
        RibolovacVrijednost[playerid] += value;
        SaveRibolovacCatch(playerid);

        if(!offshore) ApplyAnimation(playerid, "SAMP", "FishingCatch", 4.1, 0, 0, 0, 0, 1800, 1);
        GameTextForPlayer(playerid, "~g~RIBA UHVACENA", 2500, 3);

        new fishMessage[144];
        format(fishMessage, sizeof(fishMessage), "[POSAO]: Uhvatili ste %s tezine %d.%03d kg. Vrijednost: %d RSD.",
            RibolovacRibe[fishid][RibaNaziv], grams / 1000, grams % 1000, value);
        SendClientMessage(playerid, 0x33CCFFFF, fishMessage);

        if(PlayerJobData[playerid][JobCargo] >= RIBOLOVAC_MAX_ULOV)
        {
            PlayerJobData[playerid][JobCargo] = RIBOLOVAC_MAX_ULOV;
            PlayerJobData[playerid][JobStage] = JOB_STAGE_RETURN_TO_MARKET;
            RibolovacOffshoreAttempt[playerid] = false;
            SendClientMessage(playerid, 0x00FF00FF, "[POSAO]: Mreza je puna (10/10). Prodajte ulov na standu komandom /prodajribu.");
            return 1;
        }

        PlayerJobData[playerid][JobStage] = JOB_STAGE_READY_TO_FISH;
        new catchMessage[112];
        format(catchMessage, sizeof(catchMessage), "[POSAO]: Uspjesno ste uhvatili ribu (%d/%d). Pritisnite lijevi klik za novo pecanje.",
            PlayerJobData[playerid][JobCargo], RIBOLOVAC_MAX_ULOV);
        SendClientMessage(playerid, 0x00FF00FF, catchMessage);
    }
    else
    {
        ClearAnimations(playerid);
        PlayerJobData[playerid][JobStage] = JOB_STAGE_READY_TO_FISH;
        SendClientMessage(playerid, 0xFFFF00FF, "[POSAO]: Riba je pobjegla. Pritisnite lijevi klik i pokusajte ponovo.");
        GameTextForPlayer(playerid, "~y~RIBA JE POBJEGLA", 2500, 3);
    }
    RibolovacOffshoreAttempt[playerid] = false;
    return 1;
}

CMD:posao(playerid, params)
{
    #pragma unused params
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Prvo se prijavite na nalog.");

    new selectedJob = JOB_NONE;
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 330.6513, -1509.8417, 36.0391))
        selectedJob = JOB_POSTAR;
    else if(IsPlayerInRangeOfPoint(playerid, 3.0, RIBOLOVAC_POS_X, RIBOLOVAC_POS_Y, RIBOLOVAC_POS_Z) &&
            GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
        selectedJob = JOB_RIBOLOVAC;

    if(selectedJob == JOB_NONE)
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Niste na mjestu za zaposljavanje.");

    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file)))
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Vas korisnicki nalog nije pronaden.");

    new currentJob = DOF2_IsSet(file, "Posao") ? DOF2_GetInt(file, "Posao") : JOB_NONE;
    if(currentJob == selectedJob)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Vec ste zaposleni na ovom poslu.");
    if(currentJob != JOB_NONE)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Vec imate posao. Dajte otkaz u opstini prije novog zaposlenja.");

    SetPlayerJobData(playerid, selectedJob);
    if(selectedJob == JOB_POSTAR)
        SendClientMessage(playerid, 0x00FF00FF, "[POSAO]: Cestitamo! Uspjesno ste se zaposlili kao Postar.");
    else
        SendClientMessage(playerid, 0x00FF00FF, "[POSAO]: Cestitamo! Uspjesno ste se zaposlili kao Ribolovac. Za pomoc koristite /jobhelp.");
    return 1;
}

CMD:otkaz(playerid, params)
{
    #pragma unused params
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 358.9828, 169.0106, 1008.3828) ||
       GetPlayerInterior(playerid) != 3 || GetPlayerVirtualWorld(playerid) != 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Morate biti u opstini na salteru da biste dali otkaz.");

    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file)))
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Vas korisnicki nalog nije pronaden.");
    if(DOF2_GetInt(file, "Posao") == JOB_NONE)
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Nemate posao da biste dali otkaz.");

    SetPlayerJobData(playerid, JOB_NONE);
    SendClientMessage(playerid, 0x00FF00FF, "[POSAO]: Uspjesno ste dali otkaz. Vas aktivni job zadatak je ociscen.");
    return 1;
}

CMD:smjena(playerid, params)
{
    #pragma unused params
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Prvo se prijavite na nalog.");

    new file[128];
    if(!GetPlayerAccountPath(playerid, file, sizeof(file)))
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Vas korisnicki nalog nije pronaden.");

    new jobid = DOF2_IsSet(file, "Posao") ? DOF2_GetInt(file, "Posao") : JOB_NONE;
    if(PlayerJobData[playerid][JobID] != jobid) LoadPlayerJobData(playerid);
    if(jobid != JOB_RIBOLOVAC)
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: /smjena je trenutno dostupna samo zaposlenim Ribolovcima.");
    if(!IsPlayerInRangeOfPoint(playerid, 4.0, RIBOLOVAC_POS_X, RIBOLOVAC_POS_Y, RIBOLOVAC_POS_Z) ||
       GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Smjenu mozete zapoceti ili zavrsiti samo kod ribarskog pristanista.");

    if(!PlayerJobData[playerid][JobDuty])
    {
        ResetPlayerJobTask(playerid, false, false);
        PlayerJobData[playerid][JobDuty] = true;
        PlayerJobData[playerid][JobPreviousSkin] = GetPlayerSkin(playerid);
        DOF2_SetInt(file, "RibolovacOriginalSkin", PlayerJobData[playerid][JobPreviousSkin]);
        DOF2_SetInt(file, "RibolovacUniformaAktivna", 1);
        DOF2_SaveFile();
        SetPlayerSkin(playerid, RIBOLOVAC_SKIN);
        GiveRibolovacEquipment(playerid);
        StartRibolovacTask(playerid);
        SendClientMessage(playerid, 0x00FF00FF, "[POSAO]: Zapoceli ste smjenu kao Ribolovac.");
    }
    else
    {
        new previousSkin = PlayerJobData[playerid][JobPreviousSkin];
        SaveRibolovacCatch(playerid);
        ResetPlayerJobTask(playerid, true, false);
        if(previousSkin >= 0 && previousSkin <= 311 && previousSkin != 74)
        {
            SetPlayerSkin(playerid, previousSkin);
            DOF2_SetInt(file, "Skin", previousSkin);
        }
        DOF2_SetInt(file, "RibolovacUniformaAktivna", 0);
        DOF2_SaveFile();
        SendClientMessage(playerid, 0xFFFF00FF, "[POSAO]: Zavrsili ste smjenu. Ulov je sacuvan, a prethodni skin vracen.");
    }
    return 1;
}
stock bool:IsPlayerInOffshoreFishingZone(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    return GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0 &&
        x >= OFFSHORE_MIN_X && x <= OFFSHORE_MAX_X && y >= OFFSHORE_MIN_Y && y <= OFFSHORE_MAX_Y;
}

stock bool:IsPlayerInOwnRentedFishingBoat(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER) return false;
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES || vehicleid != RentPlayerVehicle[playerid] || RentVehicleOwner[vehicleid] != playerid + 1) return false;
    if(RentBusinessId[playerid] < 0 || RentBusinessSlot[playerid] < 0 || GetVehicleModel(vehicleid) != FISHING_BOAT_MODEL) return false;
    return true;
}

stock GetOffshoreFishingCatch()
{
    new roll = random(100);
    if(roll < 32) return 4; // Lignja
    if(roll < 60) return 5; // Velika Tuna
    if(roll < 78) return 6; // Sabljarka
    if(roll < 92) return 7; // Jastog
    return 8;               // Morski Pas
}

public StartRibolovacFishing(playerid)
{
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Prvo se prijavite na nalog.");
    if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC)
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Niste zaposleni kao Ribolovac.");
    if(!PlayerJobData[playerid][JobDuty])
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Niste na smjeni. Smjenu zapocinjete kod ribarskog pristanista.");
    if(PlayerJobData[playerid][JobStage] == JOB_STAGE_FISHING)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Vec pecate. Sacekajte zavrsetak pokusaja.");
    if(PlayerJobData[playerid][JobCargo] >= RIBOLOVAC_MAX_ULOV ||
       PlayerJobData[playerid][JobStage] == JOB_STAGE_RETURN_TO_MARKET)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Mreza je puna. Prodajte ribu na standu komandom /prodajribu.");
    if(PlayerJobData[playerid][JobStage] != JOB_STAGE_READY_TO_FISH)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Prvo dodite do oznacenog ribolovnog mjesta.");
    new bool:offshore = IsPlayerInOffshoreFishingZone(playerid);
    if(IsPlayerInAnyVehicle(playerid) && !offshore)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Iz vozila mozete pecati samo iz svog rentanog broda u offshore zoni.");
    if(offshore)
    {
        if(!IsPlayerInOwnRentedFishingBoat(playerid))
            return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: U offshore zoni morate pecati iz svog iznajmljenog Ribarskog broda.");
        if(PlayerJobData[playerid][JobLevel] < RIBOLOVAC_MAX_LEVEL)
            return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Offshore pecanje je dostupno tek na 5. levelu Ribolovca.");
        if(RibolovacStap[playerid] < 2)
            return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Za pecanje u ovoj zoni potreban vam je Profesionalni stap.");
    }
    if(!PlayerJobData[playerid][JobObject] ||
       !IsPlayerAttachedObjectSlotUsed(playerid, RIBOLOVAC_STAP_SLOT))
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Nemate ribarski stap. Kupite ga na standu komandom /kupistap.");

    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Pecati mozete samo na kraju doka.");

    new spot = -1;
    if(!offshore)
    {
        for(new fishingSpot = 0; fishingSpot < MAX_RIBOLOVAC_MJESTA; fishingSpot++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 2.2, RibolovacMjesta[fishingSpot][0], RibolovacMjesta[fishingSpot][1], RibolovacMjesta[fishingSpot][2]))
            {
                spot = fishingSpot;
                break;
            }
        }
        if(spot == -1)
            return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Dodjite do jednog od oznacenih mjesta na samom kraju doka.");
        if(!IsPlayerFacingFishingWater(playerid))
            return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Okrenite se prema vodi prije nego sto zabacite udicu.");
    }
    RibolovacAktivnoMjesto[playerid] = spot;
    RibolovacOffshoreAttempt[playerid] = offshore;

    new baitid = RibolovacAktivniMamac[playerid];
    if(baitid < 0 || baitid >= MAX_RIBOLOVAC_MAMACA || RibolovacMamac[playerid][baitid] <= 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Nemate izabrani mamac. Kupite ga sa /kupimamac i izaberite sa /mamac.");
    RibolovacKoristeniMamac[playerid] = baitid;
    RibolovacMamac[playerid][baitid]--;
    SaveRibolovacBait(playerid);
    UpdateRibolovacBaitObject(playerid);

    GetPlayerPos(playerid, RibolovacStartX[playerid], RibolovacStartY[playerid], RibolovacStartZ[playerid]);
    PlayerJobData[playerid][JobStage] = JOB_STAGE_FISHING;
    PlayerJobData[playerid][JobTaskSerial]++;
    if(!offshore)
    {
        ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 0, 0, 0, 1, 900, 1);
        SetTimerEx("StartFishingIdle", 900, false, "ii", playerid, PlayerJobData[playerid][JobTaskSerial]);
    }
    TogglePlayerControllable(playerid, 0);
    GameTextForPlayer(playerid, "~b~PECANJE...~n~~w~Sacekajte 8 sekundi", 8000, 3);
    SendClientMessage(playerid, 0x33CCFFFF, "[POSAO]: Zabacili ste udicu. Sacekajte rezultat pecanja.");
    SetTimerEx("FinishFishingAttempt", 8000, false, "ii", playerid, PlayerJobData[playerid][JobTaskSerial]);
    return 1;
}

CMD:kupimamac(playerid, params)
{
    #pragma unused params
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Prvo se prijavite na nalog.");
    if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC)
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Niste zaposleni kao Ribolovac.");
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0 ||
       !IsPlayerInRangeOfPoint(playerid, 4.0, RIBOLOVAC_MAMAC_X, RIBOLOVAC_MAMAC_Y, RIBOLOVAC_MAMAC_Z))
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Mamac mozete kupiti samo na standu za prodaju mamaca.");

    new businessid = FindJobBusiness(JOB_RIBOLOVAC), list[320];
    if(businessid == -1)
        format(list, sizeof(list), "Proizvod\tKomad\tCijena\nHljeb\t5\t300 RSD\nCrv\t5\t700 RSD\nLignja\t5\t1500 RSD");
    else
        format(list, sizeof(list), "Proizvod\tKomad\tCijena\nHljeb\t%d\t%d RSD\nCrv\t%d\t%d RSD\nLignja\t%d\t%d RSD",
            BusinessBaitAmount[businessid][0], BusinessBaitPrice[businessid][0], BusinessBaitAmount[businessid][1], BusinessBaitPrice[businessid][1],
            BusinessBaitAmount[businessid][2], BusinessBaitPrice[businessid][2]);
    ShowPlayerDialog(playerid, DIALOG_RIBOLOVAC_KUPI_MAMAC, DIALOG_STYLE_TABLIST_HEADERS,
        "{33CCFF}Ribarski stand - Mamci", list, "Kupi", "Odustani");
    return 1;
}

CMD:kupistap(playerid, params)
{
    #pragma unused params
    if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Niste zaposleni kao Ribolovac.");
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0 ||
       !IsPlayerInRangeOfPoint(playerid, 4.0, RIBOLOVAC_STAP_X, RIBOLOVAC_STAP_Y, RIBOLOVAC_STAP_Z))
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Stap mozete kupiti samo na ribarskom standu.");
    new businessid = FindJobBusiness(JOB_RIBOLOVAC), beginner = 500, professional = 15000, list[200];
    if(businessid != -1) { beginner = BusinessRodPrice[businessid][0]; professional = BusinessRodPrice[businessid][1]; }
    format(list, sizeof(list), "Stap\tLevel\tCijena\nPocetnicki\t1\t%d RSD\nProfesionalni\t5\t%d RSD", beginner, professional);
    ShowPlayerDialog(playerid, DIALOG_RIBOLOVAC_KUPI_STAP, DIALOG_STYLE_TABLIST_HEADERS,
        "{33CCFF}Ribarski stand - Stapovi", list, "Kupi", "Odustani");
    return 1;
}

CMD:mamac(playerid, params)
{
    #pragma unused params
    if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC)
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Niste zaposleni kao Ribolovac.");
    if(PlayerJobData[playerid][JobStage] == JOB_STAGE_FISHING)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Mamac ne mozete mijenjati dok pecate.");

    new baitList[256];
    format(baitList, sizeof(baitList),
        "Hljeb\t%d komada\t60%% uspjeha\nCrv\t%d komada\t72%% uspjeha\nLignja\t%d komada\t85%% uspjeha",
        RibolovacMamac[playerid][0], RibolovacMamac[playerid][1], RibolovacMamac[playerid][2]);
    ShowPlayerDialog(playerid, DIALOG_RIBOLOVAC_IZABERI_MAMAC, DIALOG_STYLE_LIST,
        "{33CCFF}Izaberite mamac", baitList, "Izaberi", "Zatvori");
    return 1;
}

CMD:prodajribu(playerid, params)
{
    #pragma unused params
    if(!GetPVarInt(playerid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Prvo se prijavite na nalog.");
    if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC)
        return SendClientMessage(playerid, 0xFF0000FF, "[POSAO]: Niste zaposleni kao Ribolovac.");
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0 ||
       !IsPlayerInRangeOfPoint(playerid, 4.0, RIBOLOVAC_PRODAJA_X, RIBOLOVAC_PRODAJA_Y, RIBOLOVAC_PRODAJA_Z))
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Ribu mozete prodati samo kod standa u ribarskom pristanistu.");
    if(PlayerJobData[playerid][JobCargo] <= 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Nemate nijednu ribu za prodaju.");
    if(PlayerJobData[playerid][JobStage] == JOB_STAGE_FISHING)
        return SendClientMessage(playerid, 0xFF7777FF, "[POSAO]: Sacekajte da zavrsite trenutni pokusaj pecanja.");

    SellRibolovacCatch(playerid);
    if(PlayerJobData[playerid][JobDuty]) StartRibolovacTask(playerid);
    return 1;
}

stock ShowPlayerJobInfo(playerid)
{
    new jobName[32], status[72], text[1400], xpText[48], rodName[24];
    GetJobName(PlayerJobData[playerid][JobID], jobName, sizeof(jobName));
    if(PlayerJobData[playerid][JobID] == JOB_NONE)
        return ShowPlayerDialog(playerid, DIALOG_JOB_INFO, DIALOG_STYLE_MSGBOX, "{33CCFF}Informacije o poslu", "{FFFFFF}Niste zaposleni.", "Zatvori", "");

    format(status, sizeof(status), PlayerJobData[playerid][JobDuty] ? ("Na smjeni") : ("Niste na smjeni"));
    if(PlayerJobData[playerid][JobID] != JOB_RIBOLOVAC)
    {
        format(text, sizeof(text), "{33CCFF}Posao: {FFFFFF}%s\n{33CCFF}Level: {FFFFFF}%d\n{33CCFF}XP: {FFFFFF}%d\n{33CCFF}Smjena: {FFFFFF}%s",
            jobName, PlayerJobData[playerid][JobLevel], PlayerJobData[playerid][JobXP], status);
        return ShowPlayerDialog(playerid, DIALOG_JOB_INFO, DIALOG_STYLE_MSGBOX, "{33CCFF}Informacije o poslu", text, "Zatvori", "");
    }

    if(PlayerJobData[playerid][JobLevel] >= RIBOLOVAC_MAX_LEVEL) format(xpText, sizeof(xpText), "MAX LEVEL");
    else format(xpText, sizeof(xpText), "%d/%d XP", PlayerJobData[playerid][JobXP], GetRibolovacNextLevelXP(PlayerJobData[playerid][JobLevel]));
    switch(RibolovacStap[playerid])
    {
        case 1: format(rodName, sizeof(rodName), "Pocetnicki");
        case 2: format(rodName, sizeof(rodName), "Profesionalni");
        default: format(rodName, sizeof(rodName), "Nema");
    }
    new line[320];
    format(text, sizeof(text), "{33CCFF}Posao: {FFFFFF}%s\n{33CCFF}Level: {FFFFFF}%d/%d\n{33CCFF}XP: {FFFFFF}%s\n{33CCFF}Smjena: {FFFFFF}%s\n{33CCFF}Stap: {FFFFFF}%s\n\n",
        jobName, PlayerJobData[playerid][JobLevel], RIBOLOVAC_MAX_LEVEL, xpText, status, rodName);
    format(line, sizeof(line), "{FFFF00}Obicni ulov\n{FFFFFF}Sardina: {00FF00}%d\n{FFFFFF}Skusa: {00FF00}%d\n{FFFFFF}Brancin: {00FF00}%d\n{FFFFFF}Tuna: {00FF00}%d\n\n",
        RibolovacRibaKolicina[playerid][0], RibolovacRibaKolicina[playerid][1], RibolovacRibaKolicina[playerid][2], RibolovacRibaKolicina[playerid][3]);
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{FFFF00}Offshore ulov\n{FFFFFF}Lignja: {00FF00}%d\n{FFFFFF}Velika Tuna: {00FF00}%d\n{FFFFFF}Sabljarka: {00FF00}%d\n{FFFFFF}Jastog: {00FF00}%d\n{FFFFFF}Morski Pas: {00FF00}%d\n\n",
        RibolovacRibaKolicina[playerid][4], RibolovacRibaKolicina[playerid][5], RibolovacRibaKolicina[playerid][6], RibolovacRibaKolicina[playerid][7], RibolovacRibaKolicina[playerid][8]);
    strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{FFFFFF}Ukupno: {00FF00}%d/%d riba\n{FFFFFF}Tezina: {00FF00}%d.%03d kg\n{FFFFFF}Vrijednost: {00FF00}%d RSD",
        PlayerJobData[playerid][JobCargo], RIBOLOVAC_MAX_ULOV, RibolovacUkupnoGrama[playerid] / 1000,
        RibolovacUkupnoGrama[playerid] % 1000, RibolovacVrijednost[playerid]);
    strcat(text, line, sizeof(text));
    return ShowPlayerDialog(playerid, DIALOG_JOB_INFO, DIALOG_STYLE_MSGBOX, "{33CCFF}Informacije o poslu", text, "Zatvori", "");
}

CMD:jobinfo(playerid, params)
{
    #pragma unused params
    return ShowPlayerJobInfo(playerid);
}

CMD:jobdebug(playerid, params)
{
    #pragma unused params
    if(!HasAdminCommandAccess(playerid) && !IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[JOB DEBUG]: Nemate ovlascenje.");

    new jobName[32], text[320];
    GetJobName(PlayerJobData[playerid][JobID], jobName, sizeof(jobName));
    format(text, sizeof(text),
        "{33CCFF}Job:{FFFFFF} %s (%d)\n{33CCFF}Level:{FFFFFF} %d\n{33CCFF}XP:{FFFFFF} %d\n{33CCFF}Duty:{FFFFFF} %d\n{33CCFF}Stage:{FFFFFF} %d\n{33CCFF}Vehicle:{FFFFFF} %d\n{33CCFF}Cargo:{FFFFFF} %d\n{33CCFF}Checkpoint:{FFFFFF} %d\n{33CCFF}Object:{FFFFFF} %d",
        jobName,
        PlayerJobData[playerid][JobID],
        PlayerJobData[playerid][JobLevel],
        PlayerJobData[playerid][JobXP],
        PlayerJobData[playerid][JobDuty],
        PlayerJobData[playerid][JobStage],
        PlayerJobData[playerid][JobVehicle],
        PlayerJobData[playerid][JobCargo],
        PlayerJobData[playerid][JobCheckpoint],
        PlayerJobData[playerid][JobObject]);
    ShowPlayerDialog(playerid, DIALOG_ADMIN_CHECK, DIALOG_STYLE_MSGBOX, "Job Debug", text, "Zatvori", "");
    return 1;
}

CMD:jobhelp(playerid, params)
{
    #pragma unused params
    return ShowJobHelp(playerid);
}
CMD:engine(playerid, params)
{
    // Provera da li je igrac u nekom vozilu
    if(!IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Niste ni u kakvom vozilu!");
        return 1;
    }

    // Provera da li je igrac vozac (sjedi?te 0)
    if(GetPlayerVehicleSeat(playerid) != 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Samo vozac mo?e upaliti ili ugasiti motor!");
        return 1;
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    new engine, lights, alarm, doors, bonnet, boot, objective;

    // Uzimamo trenutne parametre vozila
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    // Ako je motor uga?en (0 ili -1), palimo ga
    if(engine == 0 || engine == -1 || VehicleHudStalled[vehicleid])
    {
        VehicleHudInitData(vehicleid);
        if(!VehicleHudNoFuel(GetVehicleModel(vehicleid)) && VehicleHudFuel[vehicleid] <= 0.0)
            return SendClientMessage(playerid, 0xFF7777FF, "[GORIVO]: Nema goriva. Zaustavite vozilo i upisite /fill.");
        new damage = VehicleHudDamageLevel(vehicleid);
        if(damage == 5)
            return SendClientMessage(playerid, 0xFF7777FF, "[VOZILO]: Kvarovi su 5/5. Motor se ne moze upaliti dok se vozilo ne popravi.");
        if(damage == 4)
        {
            if(gettime() < VehicleHudNextStartTry[vehicleid])
                return SendClientMessage(playerid, 0xFF7777FF, "[VOZILO]: Sacekajte nekoliko sekundi prije novog pokusaja paljenja.");
            VehicleHudNextStartTry[vehicleid] = gettime() + 3;
            if(random(100) >= 35)
                return SendClientMessage(playerid, 0xFF7777FF, "[VOZILO]: Motor tesko pali zbog kvarova (4/5). Pokusajte ponovo.");
            VehicleHudNextStallAt[vehicleid] = gettime() + 15 + random(11);
        }
        VehicleHudStalled[vehicleid] = false;
        SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
        SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Uspje?no ste upalili motor vozila.");
    }
    else // Ako je upaljen, gasimo ga
    {
        SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
        SendClientMessage(playerid, 0xFF0000FF, "[SERVER]: Uspje?no ste ugasili motor vozila.");
    }
    return 1;
}
CMD:dovezipostu(playerid, params)
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(!DOF2_FileExists(file)) return 1;

    if(DOF2_GetInt(file, "Posao") != 2)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Niste zaposleni kao Po?tar!");
        return 1;
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0 || GetVehicleModel(vehicleid) != 482)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Morate biti vozac u po?tarskom kombiju (Burrito - model 482)!");
        return 1;
    }

    // Povecan radijus na 80.0 da obuhvati sve kombije u nizu u gara?i sa slike
    if(!IsPlayerInRangeOfPoint(playerid, 80.0, PostarRute[0][0], PostarRute[0][1], PostarRute[0][2]))
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Niste u magacinu da biste zapoceli po?tansku turu!");
        return 1;
    }

    if(IsDoingPosta[playerid])
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Vec ste zapoceli po?tansku turu!");
        return 1;
    }

    IsDoingPosta[playerid] = true;
    PostarStep[playerid] = 1; // Krecemo od prve tacke posle magacina

    SetPlayerCheckpoint(playerid, PostarRute[PostarStep[playerid]][0], PostarRute[PostarStep[playerid]][1], PostarRute[PostarStep[playerid]][2], 4.0);
    SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Zapoceli ste turu! Pratite crvenu oznaku na mapi do aerodroma.");
    return 1;
}
CMD:prekiniposao(playerid, params)
{
    if(!IsDoingPosta[playerid])
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Trenutno nemate aktivnu po?tansku turu!");
        return 1;
    }

    IsDoingPosta[playerid] = false;
    PostarStep[playerid] = 0;
    DisablePlayerCheckpoint(playerid);
    SendClientMessage(playerid, 0xFF0000FF, "[SERVER]: Uspe?no ste prekinuli po?tansku turu.");
    return 1;
}
public OnPlayerUpdate(playerid)
{
    if(GetPVarInt(playerid, "BR_StaffVehicleProtect") && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new staffVehicle = GetPlayerVehicleID(playerid);
        new Float:staffVehicleHealth;
        GetVehicleHealth(staffVehicle, staffVehicleHealth);
        if(staffVehicleHealth < 999.0)
        {
            RepairVehicle(staffVehicle);
            SetVehicleHealth(staffVehicle, 1000.0);
        }
    }
    else if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) DeletePVar(playerid, "BR_StaffVehicleProtect");

    new nativeWanted = GetPlayerWantedLevel(playerid);
    if(nativeWanted > 0 && GetPlayerState(playerid) != PLAYER_STATE_WASTED &&
       GetPlayerState(playerid) != PLAYER_STATE_NONE && !IsHealing[playerid])
    {
        if(GetPVarInt(playerid, "BR_LoggedIn") && !IsHealing[playerid] && !PendingDeathFine[playerid] &&
            nativeWanted > WantedPoints[playerid])
        {
            WantedPoints[playerid] = nativeWanted;
            format(WantedReason[playerid], 64, "Ostali prekrsaj");
            UpdateWantedHint(playerid);
            new name[MAX_PLAYER_NAME], file[128];
            GetPlayerName(playerid, name, sizeof(name));
            format(file, sizeof(file), "Korisnici/%s.ini", name);
            if(DOF2_FileExists(file))
            {
                DOF2_SetInt(file, "DosijeWanted", WantedPoints[playerid]);
                DOF2_SetString(file, "DosijeRazlog", WantedReason[playerid]);
                DOF2_SaveFile();
            }
        }
        SetPlayerWantedLevel(playerid, 0);
    }
    if(JetpackDropGuardUntil[playerid])
    {
        if(gettime() >= JetpackDropGuardUntil[playerid]) JetpackDropGuardUntil[playerid] = 0;
        else if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
        {
            RemoveJetpackClean(playerid);
            JetpackDropGuardUntil[playerid] = 0;
        }
    }
    if(BankHackPlayer == playerid && !BankHackerStillHere(playerid)) BankAbortHack();
    BankCheckLaserForPlayer(playerid);
    return 1;
}
public ApplyPendingDeathPenalty(playerid, bool:notify)
{
    if(PendingDeathFine[playerid] <= 0) return 0;
    new cash = GetPlayerMoney(playerid);
    new fine = PendingDeathFine[playerid];
    new newBalance = cash - fine;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, newBalance);
    PlayerInfo[playerid][pNovac] = newBalance;
    new name[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
        DOF2_SetInt(file, "DosijeWanted", 0);
        DOF2_SetString(file, "DosijeRazlog", "Nema");
        DOF2_SaveFile();
    }
    if(notify)
    {
        new message[128];
        format(message, sizeof(message), "[SMRT]: Naplaceno vam je %d RSD za smrt/lijecenje i %d Wanted Levela. Dosije je obrisan.", fine, PendingDeathWanted[playerid]);
        SendClientMessage(playerid, 0xFF7777FF, message);
    }
    PendingDeathFine[playerid] = 0;
    PendingDeathWanted[playerid] = 0;
    return 1;
}

forward FinishDeathPenalty(playerid, serial);
public FinishDeathPenalty(playerid, serial)
{
    if(!IsPlayerConnected(playerid) || serial != DeathPenaltySerial[playerid]) return 1;
    ApplyPendingDeathPenalty(playerid, true);
    return 1;
}

forward FinishSpawnWantedReset(playerid, serial);
public FinishSpawnWantedReset(playerid, serial)
{
    if(!IsPlayerConnected(playerid) || serial != DeathPenaltySerial[playerid]) return 1;
    new playerState = GetPlayerState(playerid);
    if(playerState == PLAYER_STATE_WASTED || playerState == PLAYER_STATE_NONE) return 1;
    SetPlayerWantedLevel(playerid, 0);
    UpdateWantedHint(playerid);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    #pragma unused reason
    new deathJobSkin = -1;
    if(PlayerJobData[playerid][JobID] == JOB_RIBOLOVAC && PlayerJobData[playerid][JobDuty])
        deathJobSkin = PlayerJobData[playerid][JobPreviousSkin];
    ResetPlayerJobTask(playerid, true);
    if(RentPlayerVehicle[playerid]) StopPlayerRent(playerid, true);
    if(deathJobSkin >= 0 && deathJobSkin <= 311 && deathJobSkin != 74)
        SetPlayerSkin(playerid, deathJobSkin);
    JetpackDropGuardUntil[playerid] = 0;
    new wanted = WantedPoints[playerid];
    if(GetPlayerWantedLevel(playerid) > wanted) wanted = GetPlayerWantedLevel(playerid);
    WantedPoints[playerid] = 0;
    format(WantedReason[playerid], 64, "Nema");
    PendingDeathWanted[playerid] = wanted;
    PendingDeathFine[playerid] = wanted * 1500;

    new name[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "DosijeWanted", 0);
        DOF2_SetString(file, "DosijeRazlog", "Nema");
        if(deathJobSkin >= 0)
        {
            DOF2_SetInt(file, "Skin", deathJobSkin);
            DOF2_SetInt(file, "RibolovacUniformaAktivna", 0);
        }
        DOF2_SetInt(file, "DosijeSmrti", DOF2_GetInt(file, "DosijeSmrti") + 1);
        new insurance = DOF2_GetInt(file, "Osiguranja");
        if(insurance > 0)
        {
            DOF2_SetInt(file, "Osiguranja", insurance - 1);
            SendClientMessage(playerid, 0x66CCFFFF, "[OSIGURANJE]: Iskoristeno je 1 osiguranje za bolnicko lijecenje.");
        }
        else PendingDeathFine[playerid] += MEDICAL_TREATMENT_PRICE;
        DOF2_SaveFile();
    }
    if(killerid != INVALID_PLAYER_ID && killerid != playerid && IsPlayerConnected(killerid))
    {
        AddPlayerSavedStat(killerid, "DosijeUbistva", 1);
        LastKilledPlayer[killerid] = playerid; LastKillWeapon[killerid] = reason; LastKillAt[killerid] = gettime();
    }

    if(BankHackPlayer == playerid) BankAbortHack();
    if(BankRobber == playerid) BankAbortRobbery(true);
    if(BankMoneyBag[playerid]) RemovePlayerAttachedObject(playerid, 9);
    BankMoneyBag[playerid] = false;
    ScriptJetpack[playerid] = false;
    if(JuniorJailedUntil[playerid] > gettime())
    {
        IsHealing[playerid] = false;
        SendClientMessage(playerid, 0xFF7777FF, "[ZATVOR]: Umrli ste dok ste bili u Zatvoru. Vratit cete se u Zatvor da dovrsite vasu KAZNU.");
    }
    else IsHealing[playerid] = true;
    PlayerCurrentSkin[playerid] = GetPlayerSkin(playerid);
    if(PlayerCurrentSkin[playerid] < 0 || PlayerCurrentSkin[playerid] > 311 || PlayerCurrentSkin[playerid] == 74)
        PlayerCurrentSkin[playerid] = 26;
    if(JuniorJailedUntil[playerid] > gettime())
        SetSpawnInfo(playerid, 0, PlayerCurrentSkin[playerid], 264.63, 77.57, 1001.04, 270.0, 0, 0, 0, 0, 0, 0);
    else
        SetSpawnInfo(playerid, 0, PlayerCurrentSkin[playerid], -20.6776, 1481.3562, -3.3132, 179.0601, 0, 0, 0, 0, 0, 0);
    return 1;
}
forward ZavrsiLecenje(playerid);
public ZavrsiLecenje(playerid)
{
    if(IsHealing[playerid])
    {
        IsHealing[playerid] = false;

        // Ako je igrac tokom lijecenja jos uvijek u admin jailu, vraca se u jail.
        if(JuniorJailedUntil[playerid] > gettime())
        {
            SafeTeleportPlayer(playerid, 264.63, 77.57, 1001.04, 6, 0);
            SendClientMessage(playerid, 0xFF7777FF, "[ZATVOR]: Kazna jos traje. Vraceni ste u zatvor.");
            return 1;
        }

        // Vraca ga na njegov regularni spawn na osnovu sacuvane organizacije
        if(PlayerOrg[playerid] == 1)
        {
            SafeTeleportPlayer(playerid, 230.6200, 75.2964, 1005.0391, 6, 0, 270.3857);
        }
        else if(PlayerOrg[playerid] == 4)
        {
            SafeTeleportPlayer(playerid, 1754.1577, -1903.0061, 13.5634, 0, 0, 0.0);
        }
        else if(PlayerOrg[playerid] == 5)
        {
            SafeTeleportPlayer(playerid, -13.7780, 1465.4548, -3.2142, 0, 0, 3.1334);
        }
        else if(PlayerOrg[playerid] == 7)
        {
            SafeTeleportPlayer(playerid, 1072.9264, -878.3057, 43.3932, 0, 0, 0.0);
        }
        else
        {
            SafeTeleportPlayer(playerid, 1685.8652, -2331.2102, 13.5469, 0, 0, 90.2917);
        }

        SendClientMessage(playerid, 0x00FF00FF, "[BOLNICA]: Zavr?ili ste lecenje i vraceni ste na svoju spawn lokaciju.");
    }
    return 1;
}
// Komanda /sethealth (Za admin level 1-9 i RCON admine)
CMD:sethealth(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file))
    {
        admin_lvl = DOF2_GetInt(file, "Admin");
    }

    // Provjera: dozvoljeno ako je admin level 1-9 ILI ako je igrac prijavljen preko RCON-a
    if((admin_lvl < 1 || admin_lvl > 9) && !IsPlayerAdmin(playerid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Niste ovla?teni! Ovu komandu mogu koristiti samo admini od levela 1 do 9 i RCON admini.");
    }

    new targetid, Float:health;
    if(sscanf(params, "uf", targetid, health)) return SendClientMessage(playerid, 0xFFFFFFAA, "KORI?TENJE: /sethealth [ID/Ime] [Health (0-100)]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Igrac nije online!");
    if(health < 0.0 || health > 100.0) return SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Health mora biti izmedu 0 i 100!");

    SetPlayerHealth(targetid, health);

    new string[128], adminname[MAX_PLAYER_NAME], targetname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, adminname, sizeof(adminname));
    GetPlayerName(targetid, targetname, sizeof(targetname));

    format(string, sizeof(string), "[ADMIN]: Admin %s je postavio va? health na %.1f.", adminname, health);
    SendClientMessage(targetid, 0x00FF00FF, string);

    format(string, sizeof(string), "[ADMIN]: Postavili ste health igracu %s na %.1f.", targetname, health);
    SendClientMessage(playerid, 0x00FF00FF, string);
    return 1;
}

// Komanda /setarmour (Za admin level 1-9 i RCON admine)
CMD:setarmour(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file))
    {
        admin_lvl = DOF2_GetInt(file, "Admin");
    }

    // Provjera: dozvoljeno ako je admin level 1-9 ILI ako je igrac prijavljen preko RCON-a
    if((admin_lvl < 1 || admin_lvl > 9) && !IsPlayerAdmin(playerid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Niste ovla?teni! Ovu komandu mogu koristiti samo admini od levela 1 do 9 i RCON admini.");
    }

    new targetid, Float:armour;
    if(sscanf(params, "uf", targetid, armour)) return SendClientMessage(playerid, 0xFFFFFFAA, "KORI?TENJE: /setarmour [ID/Ime] [Armour (0-100)]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Igrac nije online!");
    if(armour < 0.0 || armour > 100.0) return SendClientMessage(playerid, 0xFF0000FF, "[GRE?KA]: Armour mora biti izmedu 0 i 100!");

    SetPlayerArmour(targetid, armour);

    new string[128], adminname[MAX_PLAYER_NAME], targetname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, adminname, sizeof(adminname));
    GetPlayerName(targetid, targetname, sizeof(targetname));

    format(string, sizeof(string), "[ADMIN]: Admin %s je postavio va? armour na %.1f.", adminname, armour);
    SendClientMessage(targetid, 0x00FF00FF, string);

    format(string, sizeof(string), "[ADMIN]: Postavili ste armour igracu %s na %.1f.", targetname, armour);
    SendClientMessage(playerid, 0x00FF00FF, string);
    return 1;
}
CMD:uninviteme(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 359.2273, 178.5944, 1008.3828) || GetPlayerInterior(playerid) != 3 || GetPlayerVirtualWorld(playerid) != 0)
    {
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Niste na lokaciji za napu?tanje organizacije!");
    }

    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new clan_lvl = 0;
    if(DOF2_FileExists(file))
    {
        clan_lvl = DOF2_GetInt(file, "Clan");
        if(clan_lvl == 0) clan_lvl = DOF2_GetInt(file, "Member");
    }

    if(clan_lvl == 0)
    {
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Niste clan nijedne organizacije!");
    }

    if(GetPlayerMoney(playerid) < 15000)
    {
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Nemate dovoljno novca! Potrebno je 15.000 dinara.");
    }

    // Skidamo novac igracu
    GivePlayerMoney(playerid, -15000);

    // A?uriramo novac i u DOF2 fajlu da ostane skinut trajno
    new new_money = GetPlayerMoney(playerid);
    if(DOF2_IsSet(file, "Money")) DOF2_SetInt(file, "Money", new_money);
    if(DOF2_IsSet(file, "Novac")) DOF2_SetInt(file, "Novac", new_money);

    // Postavljamo organizaciju na 0
    DOF2_SetInt(file, "Clan", 0);
    if(DOF2_IsSet(file, "Member"))
    {
        DOF2_SetInt(file, "Member", 0);
    }

    DOF2_SaveFile();

    PlayerOrg[playerid] = 0;

    // Plava boja poruke (0x33CCFFFF)
    SendClientMessage(playerid, 0x33CCFFFF, "[ORGANIZACIJA]: Uspje?no ste napustili organizaciju i skinuto vam je 15.000 dinara.");

    return 1;
}
CMD:stablo(playerid, params[]) {
    new str[1024];

    // Sla?emo tekst dijaloga
    strcat(str, "--------------------\n");
    strcat(str, "BE Vlasnik\n");
    strcat(str, "--------------------\n");
    strcat(str, "BE Suvlasnik\n");
    strcat(str, "BE Direktor\n");
    strcat(str, "BE Head Admin\n");
    strcat(str, "--------------------\n");
    strcat(str, "Admin\n");
    strcat(str, "--------------------\n");
    strcat(str, "Helper\n");
    strcat(str, "--------------------\n");
    strcat(str, "VIP, Promoter\n");
    strcat(str, "--------------------\n");
    strcat(str, "Vojska, Zandarmerija, Policija, Hitna Pomoc\n");
    strcat(str, "Parking Servis, Novinari, Taxi\n");
    strcat(str, "--------------------\n");
    strcat(str, "Mafije\n");
    strcat(str, "Bande\n");
    strcat(str, "--------------------\n");
    strcat(str, "Civil\n");
    strcat(str, "--------------------\n");
    strcat(str, "Banovan\n");

    // Prikazujemo dijalog
    // Napomena: DIALOG_STYLE_MSGBOX je obican prozor sa tekstom
    ShowPlayerDialog(playerid, 888, DIALOG_STYLE_MSGBOX, "Drzavno stablo", str, "Ok", "");

    return 1;
}

// /ah, /name i evidencija privremenih imena
#define TEMP_NAME_REGISTRY "BalkanRP/PrivremenaImena.ini"
#define MAX_TEMP_NAME_RECORDS 500
#define TEMP_NAME_BACKUP_DIR "BackupImena"

stock ShowAllCommands(playerid)
{
    if(!HasAdminCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Samo administracija moze koristiti /ahelp.");
    new text[4096];
    strcat(text, "/mp3 /stats /help /pravila /dajadmina /dajadmin /setcodeadmin\n", sizeof(text));
    strcat(text, "/admini /adminduty /dajhelpera /hduty /helperi /setcodehelper\n", sizeof(text));
    strcat(text, "/napravikucu /izbrisikucu /editujkucu /jetpack /buyhouse /gotohouse /sellhouse\n", sizeof(text));
    strcat(text, "/lockhouse /unlockhouse /napravibizz /editujmarket /obrisimarket /buybizz /sellbizz /bizzhelp\n", sizeof(text));
    strcat(text, "/psellto /bizzinfo /priceproducts /esterbon /uklonisuvlasnika /bizzname /bizzfee /bizzbank /keepingbizz /kupifakture /ob /obcolor\n", sizeof(text));
    strcat(text, "/gotomarket /kick /ban /setlevel /unbanip /gotopos /gotomarker\n", sizeof(text));
    strcat(text, "/kupitelefon /kupibrojtel /kupislusalice /mp3 /ugasimp3 /skinidodatke /editattachedobject /lideri /inventory /buyinventory /kupi /smsad\n", sizeof(text));
    strcat(text, "/napravioglase /editujoglase /obrisioglase /napravizlataru /editujzlataru /obrisizlataru\n", sizeof(text));
    strcat(text, "/kupizlato /prodajzlato /kupisat /time /setleader /slap /goto /kill /setskin\n", sizeof(text));
    strcat(text, "/l /gethere /b /me /do /member /invite /uninvite /orghelp /kazniclana\n", sizeof(text));
    strcat(text, "/napravitrafiku /editujtrafiku /obrisitrafiku /kreirajobjekat /editujobjekt /obrisiobjekat\n", sizeof(text));
    strcat(text, "/trafika /kreirajlabeltrafika /obrisilabeltrafika /kreirajlabel /obrisilabel\n", sizeof(text));
    strcat(text, "/givemoney /givegun /restart /rac /rtc /artc /fix /artcveh /afixveh\n", sizeof(text));
    strcat(text, "/call /acceptfaren /duty /f /d /o /giverank /preuzmivozilo /bigear /veh\n", sizeof(text));
    strcat(text, "/posao /otkaz /smjena /jobinfo /prodajribu /kupimamac /kupistap /mamac /jobhelp /jobdebug /engine /dovezipostu /prekiniposao /sethealth /setarmour\n", sizeof(text));
    strcat(text, "/uninviteme /stablo /sethour /setminute /specname /setadmincode /unrent /rentvehiclehelp /otvoriracun\n", sizeof(text));
    strcat(text, "/iskljucilasere /dajdinamit /resetbanku /postavidinamit /robbank\n", sizeof(text));
    strcat(text, "/happyhour /happyjob /dajpayday /setupozorenja /setrprank /dajosiguranje /dajdpoen\n", sizeof(text));
    strcat(text, "\n{33CCFF}Junior Admin komande:{FFFFFF}\n", sizeof(text));
    strcat(text, "/jailed /checkdm /checkinv /check /checklic /aodg /pm /lockgchat /he /checkevent /gotojetn\n", sizeof(text));
    strcat(text, "/setcarhp /setage /askin /freeze /unfreeze /sethp /setarmor /getcar /auntie /awl /gotomc\n", sizeof(text));
    strcat(text, "/setjob /apark /checkw /flip /cc /ajail /mute /unmute /masked /akick /napravipoklon /rpslap\n", sizeof(text));
    strcat(text, "/spec /specoff /g /h /a /o /or /pr /startevent /stopevent /acontracts\n", sizeof(text));
    strcat(text, "/mutegchat /mutead /muteaskq /mutereport /gotolist /gotoautosk /gotoplanina\n", sizeof(text));
    strcat(text, "/gotoaerodrom /gotojob /gotopijaca /gotoboks /unmuteaskq /unmutereport /unmutead /unmutegchat\n", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_AH, DIALOG_STYLE_MSGBOX, "Sve komande", text, "Zatvori", "");
    return 1;
}

stock ShowAH(playerid)
{
    if(!HasAdminCommandAccess(playerid)) return SendClientMessage(playerid,0xFF0000FF,"GRESKA: Samo administracija moze koristiti /ah.");
    new text[4096];
    strcat(text,"{33CCFF}==================== {FFFFFF}Admin Help {33CCFF}====================\n\n",sizeof(text));
    strcat(text,"{33CCFF}Duznost {FFFFFF}| /adminduty\n",sizeof(text));
    strcat(text,"{33CCFF}Junior Admin {FFFFFF}| /name, /jailed, /checkdm, /checkinv, /check, /checklic, /aodg, /pm, /lockgchat, /he, /checkevent, /gotojetn\n",sizeof(text));
    strcat(text,"{33CCFF}Junior Admin {FFFFFF}| /setcarhp, /setage, /setskin, /askin, /gethere, /freeze, /unfreeze, /sethp, /setarmor, /getcar, /auntie, /awl, /gotomc\n",sizeof(text));
    strcat(text,"{33CCFF}Junior Admin {FFFFFF}| /setjob, /apark, /checkw, /flip, /kill, /cc, /ajail, /mute, /unmute, /masked, /kick, /akick, /slap, /napravipoklon, /rpslap\n",sizeof(text));
    strcat(text,"{33CCFF}Junior Admin {FFFFFF}| /spec, /specoff, /g, /h, /a, /o, /or, /pr, /rtc, /admini, /startevent, /stopevent, /jetpack, /acontracts, /mutegchat, /mutead, /muteaskq, /mutereport\n",sizeof(text));
    strcat(text,"{33CCFF}Junior Admin {FFFFFF}| /goto, /gotolist, /gotoautosk, /gotoplanina, /gotoaerodrom, /gotojob, /gotopijaca, /gotoboks, /unmuteaskq, /unmutereport, /unmutead, /unmutegchat\n\n",sizeof(text));
    strcat(text,"{FFD700}Posebne komande {FFFFFF}| /happyhour /happyjob /setupozorenja /setrprank /dajosiguranje /dajdpoen\n\n",sizeof(text));
    strcat(text,"{33CCFF}Admin {FFFFFF}| Komande ce biti dodane nakon testiranja Junior Admin sistema.\n",sizeof(text));
    strcat(text,"{33CCFF}Senior Admin {FFFFFF}| Komande ce biti dodane kasnije.",sizeof(text));
    ShowPlayerDialog(playerid,DIALOG_ADMIN_HELP,DIALOG_STYLE_MSGBOX,"Balkan Revolution RolePlay Admin Help",text,"OK","");
    return 1;
}
CMD:ah(playerid, params[]) return ShowAH(playerid);
CMD:ahelp(playerid, params[]) return ShowAllCommands(playerid);

public HasSpecialCommandAccess(playerid)
{
    if(IsPlayerAdmin(playerid)) return 1;
    new file[128];
    return GetPlayerAccountPath(playerid, file, sizeof(file)) && DOF2_GetInt(file, "Admin") >= 9;
}

stock SetSpecialPlayerValue(playerid, targetid, key[], value, label[])
{
    if(!HasSpecialCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Ova posebna komanda je trenutno dostupna samo Vlasniku.");
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Igrac nije online.");
    new file[128], message[144], targetName[MAX_PLAYER_NAME];
    if(!GetPlayerAccountPath(targetid, file, sizeof(file)))
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Korisnicki fajl igraca nije pronaden.");
    DOF2_SetInt(file, key, value);
    DOF2_SaveFile();
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(message, sizeof(message), "[POSEBNO]: %s igraca %s postavljeno je na %d.", label, targetName, value);
    SendClientMessage(playerid, 0xFFD700FF, message);
    format(message, sizeof(message), "[POSEBNO]: Vas %s je postavljen na %d.", label, value);
    SendClientMessage(targetid, 0xFFD700FF, message);
    return 1;
}

CMD:happyhour(playerid, params[])
{
    #pragma unused params
    if(!HasSpecialCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: /happyhour je dostupan samo Vlasniku.");

    new message[128];
    if(HappyHourMultiplier == 2)
    {
        HappyHourMultiplier = 1;
        format(message, sizeof(message), "[HAPPY HOUR]: Dupli Respekti su iskljuceni od strane Admin TEAM-a.");
    }
    else
    {
        HappyHourMultiplier = 2;
        format(message, sizeof(message), "[HAPPY HOUR]: Dupli Respekti su ukljuceni od strane Admin TEAM-a.");
    }

    if(!DOF2_FileExists(STATS_SETTINGS_FILE)) DOF2_CreateFile(STATS_SETTINGS_FILE);
    DOF2_SetInt(STATS_SETTINGS_FILE, "HappyHourMultiplier", HappyHourMultiplier);
    DOF2_SaveFile();
    SendClientMessageToAll(0xFFD700FF, message);
    return 1;
}

CMD:happyjob(playerid, params[])
{
    #pragma unused params
    if(!HasSpecialCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: /happyjob je dostupan samo Vlasniku.");
    ShowPlayerDialog(playerid, DIALOG_HAPPYJOB, DIALOG_STYLE_LIST,
        "Odaberite Happy Job", "Ugasi Happy Job\nCistac ulica\nPostar\nRibolovac", "Odaberi", "Odustani");
    return 1;
}
CMD:setupozorenja(playerid, params[])
{
    new targetid, amount;
    if(sscanf(params, "ui", targetid, amount) || amount < 0 || amount > 3)
        return SendClientMessage(playerid, -1, "Koristenje: /setupozorenja [ID/Ime] [0-3]");
    return SetSpecialPlayerValue(playerid, targetid, "Upozorenja", amount, "broj upozorenja");
}

CMD:setrprank(playerid, params[])
{
    new targetid, rank;
    if(sscanf(params, "ui", targetid, rank) || rank < 0 || rank > 100)
        return SendClientMessage(playerid, -1, "Koristenje: /setrprank [ID/Ime] [0-100]");
    return SetSpecialPlayerValue(playerid, targetid, "RolePlayRank", rank, "RolePlay rank");
}

CMD:dajosiguranje(playerid, params[])
{
    new targetid, amount;
    if(sscanf(params, "ui", targetid, amount) || amount < 0 || amount > 1000)
        return SendClientMessage(playerid, -1, "Koristenje: /dajosiguranje [ID/Ime] [Kolicina 0-1000]");
    return SetSpecialPlayerValue(playerid, targetid, "Osiguranja", amount, "broj osiguranja");
}

CMD:dajdpoen(playerid, params[])
{
    if(!HasSpecialCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: /dajdpoen je trenutno dostupan samo Vlasniku.");
    new targetid, amount;
    if(sscanf(params, "ui", targetid, amount) || amount < 1 || amount > 1000000)
        return SendClientMessage(playerid, -1, "Koristenje: /dajdpoen [ID/Ime] [Kolicina]");
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Igrac nije online.");
    new file[128], targetName[MAX_PLAYER_NAME], message[144];
    if(!GetPlayerAccountPath(targetid, file, sizeof(file))) return 0;
    new total = DOF2_GetInt(file, "DonatePoeni") + amount;
    DOF2_SetInt(file, "DonatePoeni", total);
    DOF2_SaveFile();
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(message, sizeof(message), "[DONATE]: Dali ste %d Donate Poena igracu %s. Sada ima %d.", amount, targetName, total);
    SendClientMessage(playerid, 0xFFD700FF, message);
    format(message, sizeof(message), "[DONATE]: Dobili ste %d Donate Poena. Sada imate %d.", amount, total);
    SendClientMessage(targetid, 0xFFD700FF, message);
    return 1;
}

stock JuniorAdminFile(playerid, file[], size)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, size, "Korisnici/%s.ini", name);
    return DOF2_FileExists(file);
}

stock JuniorAdminMessage(const text[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
        if(IsPlayerConnected(i) && HasAdminCommandAccess(i)) SendClientMessage(i, 0x33CCFFFF, text);
    return 1;
}

forward JuniorApplyPenalties(playerid);
public JuniorApplyPenalties(playerid)
{
    if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn")) return 1;
    new file[128];
    if(!JuniorAdminFile(playerid, file, sizeof(file))) return 1;
    LoadExtendedPlayerStats(playerid);
    LoadPlayerJobData(playerid);
    JuniorMutedUntil[playerid] = DOF2_GetInt(file, "AdminMuteUntil");
    JuniorGMutedUntil[playerid] = DOF2_GetInt(file, "MuteGUntil");
    JuniorAdMutedUntil[playerid] = DOF2_GetInt(file, "MuteAdUntil");
    JuniorAskMutedUntil[playerid] = DOF2_GetInt(file, "MuteAskUntil");
    JuniorReportMutedUntil[playerid] = DOF2_GetInt(file, "MuteReportUntil");
    JuniorJailedUntil[playerid] = DOF2_GetInt(file, "AdminJailUntil");
    if(JuniorMutedUntil[playerid] < gettime()) JuniorMutedUntil[playerid] = 0;
    else if(JuniorMuteLabel[playerid] == Text3D:INVALID_3DTEXT_ID) { JuniorMuteLabel[playerid] = Create3DTextLabel("[MUTIRAN]", 0xFF0000FF, 0.0, 0.0, 0.35, 25.0, 0, 1); Attach3DTextLabelToPlayer(JuniorMuteLabel[playerid], playerid, 0.0, 0.0, 0.35); }
    if(JuniorJailedUntil[playerid] > gettime())
    {
        JuniorTeleport(playerid, 264.63, 77.57, 1001.04, 6, 0);
        SendClientMessage(playerid, 0xFF7777FF, "[ZATVOR]: Vraceni ste u zatvor jer kazna jos traje.");
    }
    else JuniorJailedUntil[playerid] = 0;
    return 1;
}

forward JuniorAdminTick();
public JuniorAdminTick()
{
    new now = gettime();
    for(new gift=0;gift<MAX_ADMIN_GIFTS;gift++)
    {
        if(AdminGiftActive[gift] && AdminGiftObject[gift] != STREAMER_TAG_OBJECT:INVALID_STREAMER_ID)
        {
            AdminGiftRotation[gift] += 30.0;
            if(AdminGiftRotation[gift] >= 360.0) AdminGiftRotation[gift] -= 360.0;
            SetDynamicObjectRot(AdminGiftObject[gift], 0.0, 0.0, AdminGiftRotation[gift]);
        }
    }
    for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i))
    {
        if(PoliceTrackTarget[i] != INVALID_PLAYER_ID)
        {
            new targetid = PoliceTrackTarget[i];
            if(!IsPoliceTracker(i) || !IsPlayerConnected(targetid) || !GetPVarInt(targetid, "BR_LoggedIn"))
            {
                RemovePlayerMapIcon(i, POLICE_TRACK_MAP_ICON);
                PoliceTrackTarget[i] = INVALID_PLAYER_ID;
                SendClientMessage(i, 0xFF7777FF, "[POLICIJA]: Praceni igrac vise nije dostupan.");
            }
            else if(WantedPoints[targetid] <= 0)
            {
                RemovePlayerMapIcon(i, POLICE_TRACK_MAP_ICON);
                PoliceTrackTarget[i] = INVALID_PLAYER_ID;
                SendClientMessage(i, 0xFF7777FF, "[POLICIJA]: Taj igrac nema vise Wanted Level.");
            }
            else if(GetPlayerInterior(targetid) != 0 || GetPlayerVirtualWorld(targetid) != 0)
            {
                RemovePlayerMapIcon(i, POLICE_TRACK_MAP_ICON);
                PoliceTrackTarget[i] = INVALID_PLAYER_ID;
                SendClientMessage(i, 0xFF7777FF, "[POLICIJA]: Taj igrac je usao u enterijer. Pracenje je prekinuto.");
            }
            else
            {
                new Float:trackX, Float:trackY, Float:trackZ;
                GetPlayerPos(targetid, trackX, trackY, trackZ);
                SetPlayerMapIcon(i, POLICE_TRACK_MAP_ICON, trackX, trackY, trackZ, 0, 0xFF7777FF, MAPICON_GLOBAL);
            }
        }

        // Wanted upozorenje: pet sekundi vidljivo, jednu sekundu skriveno.
        if(WantedPoints[i] > 0 && GetPVarInt(i, "BR_LoggedIn"))
        {
            UpdateWantedNameColor(i);
            if(WantedHintToggleAt[i] == 0)
            {
                UpdateWantedHint(i);
            }
            else if(now >= WantedHintToggleAt[i] && WantedHintBlinkVisible[i])
            {
                PlayerTextDrawHide(i, TD_WantedHint[i]);
                PlayerTextDrawHide(i, TD_WantedStars[i]);
                WantedHintBlinkVisible[i] = false;
                WantedHintToggleAt[i] = now + 1;
            }
            else if(now >= WantedHintToggleAt[i])
            {
                WantedHintToggleAt[i] = 0;
                UpdateWantedHint(i);
            }
        }
        else if(WantedHintBlinkVisible[i])
        {
            PlayerTextDrawHide(i, TD_WantedHint[i]);
            PlayerTextDrawHide(i, TD_WantedStars[i]);
            WantedHintBlinkVisible[i] = false;
            WantedHintToggleAt[i] = 0;
        }

        if(JuniorJailedUntil[i] > 0 && JuniorJailedUntil[i] <= now)
        {
            JuniorJailedUntil[i] = 0;
            new jailFile[128];
            if(JuniorAdminFile(i, jailFile, sizeof(jailFile)))
            {
                DOF2_SetInt(jailFile, "AdminJailUntil", 0);
                DOF2_SaveFile();
            }
            TogglePlayerControllable(i, 1);
            JuniorTeleport(i, 1544.5, -1675.6, 13.5, 0, 0);
            SendClientMessage(i, 0x33CCFFFF, "[ZATVOR]: Kazna je istekla. Pusteni ste iz zatvora.");
        }
        if(JuniorMutedUntil[i] > 0 && JuniorMutedUntil[i] <= now)
        {
            JuniorMutedUntil[i] = 0;
            if(JuniorMuteLabel[i] != Text3D:INVALID_3DTEXT_ID) { Delete3DTextLabel(JuniorMuteLabel[i]); JuniorMuteLabel[i] = Text3D:INVALID_3DTEXT_ID; }
            new muteFile[128];
            if(JuniorAdminFile(i, muteFile, sizeof(muteFile)))
            {
                DOF2_SetInt(muteFile, "AdminMuteUntil", 0);
                DOF2_SaveFile();
            }
            SendClientMessage(i, 0x33CCFFFF, "[MUTE]: Ponovo mozete pisati.");
        }
    }
    return 1;
}


CMD:pm(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return SendClientMessage(playerid, 0xFF7777FF, "[PM]: Ovu komandu mogu koristiti samo administratori.");
    if(JuniorMutedUntil[playerid] > gettime()) return SendClientMessage(playerid, 0xFF7777FF, "Oduzeto vam je pravo govora.");
    new targetid, msg[100];
    if(sscanf(params, "us[100]", targetid, msg)) return SendClientMessage(playerid, -1, "Koristenje: /pm [ID/Ime] [Poruka]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF7777FF, "Igrac nije online.");
    new a[MAX_PLAYER_NAME], b[MAX_PLAYER_NAME], out[144]; GetPlayerName(playerid,a,sizeof(a)); GetPlayerName(targetid,b,sizeof(b));
    format(out,sizeof(out),"[PM za %s]: %s",b,msg); SendClientMessage(playerid,0xFFB347FF,out);
    format(out,sizeof(out),"[PM od %s]: %s",a,msg); SendClientMessage(targetid,0xFFB347FF,out); return 1;
}
CMD:aodg(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid, msg[100]; if(sscanf(params,"us[100]",targetid,msg)) return SendClientMessage(playerid,-1,"Koristenje: /aodg [ID/Ime] [Odgovor]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid,0xFF7777FF,"Igrac nije online.");
    new name[MAX_PLAYER_NAME], out[144]; GetPlayerName(playerid,name,sizeof(name));
    format(out,sizeof(out),"[ADMIN ODGOVOR] %s: %s",name,msg); SendClientMessage(targetid,0x33CCFFFF,out); SendClientMessage(playerid,0x33CCFFFF,out); return 1;
}

CMD:check(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid;
    if(sscanf(params, "u", targetid) || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Koristenje: /check [ID/Ime]");

    new name[MAX_PLAYER_NAME], ip[24], file[128], text[768], line[144];
    new Float:health, Float:armour;
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerIp(targetid, ip, sizeof(ip));
    GetPlayerHealth(targetid, health);
    GetPlayerArmour(targetid, armour);
    JuniorAdminFile(targetid, file, sizeof(file));
    format(text, sizeof(text), "{33CCFF}IME:{FFFFFF} %s (ID %d)\n", name, targetid);
    format(line, sizeof(line), "{33CCFF}IP/Ping:{FFFFFF} %s / %d\n", ip, GetPlayerPing(targetid)); strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{33CCFF}Level/Novac:{FFFFFF} %d / %d RSD\n", GetPlayerScore(targetid), GetPlayerMoney(targetid)); strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{33CCFF}Health/Armor:{FFFFFF} %.1f / %.1f\n", health, armour); strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{33CCFF}Skin/Admin:{FFFFFF} %d / %d\n", GetPlayerSkin(targetid), DOF2_GetInt(file, "Admin")); strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{33CCFF}Posao:{FFFFFF} %d\n", DOF2_GetInt(file, "Posao")); strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{33CCFF}Organizacija/Lider:{FFFFFF} %d / %d\n", DOF2_GetInt(file, "Organizacija"), DOF2_GetInt(file, "Lider")); strcat(text, line, sizeof(text));
    format(line, sizeof(line), "{33CCFF}Wanted:{FFFFFF} %d", WantedPoints[targetid]); strcat(text, line, sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_ADMIN_CHECK, DIALOG_STYLE_MSGBOX, "Provjera igraca", text, "Zatvori", "");
    return 1;
}

CMD:checkinv(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0; new id; if(sscanf(params,"u",id)||!IsPlayerConnected(id)) return SendClientMessage(playerid,-1,"Koristenje: /checkinv [ID/Ime]");
    new n[MAX_PLAYER_NAME],t[512]; GetPlayerName(id,n,sizeof(n)); format(t,sizeof(t),"{33CCFF}Inventar igraca %s\n\n{FFFFFF}Meso: %d\nMlijeko: %d\nHljeb: %d\nJabuke: %d\nBanane: %d\nSok: %d\nZlato: %d",n,PlayerInfo[id][pMeso],PlayerInfo[id][pMleko],PlayerInfo[id][pHleb],PlayerInfo[id][pJabuke],PlayerInfo[id][pBanana],PlayerInfo[id][pSok],PlayerZlato[id]);
    ShowPlayerDialog(playerid,DIALOG_ADMIN_CHECK,DIALOG_STYLE_MSGBOX,"Provjera inventara",t,"Zatvori",""); return 1;
}

CMD:checklic(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0; new id; if(sscanf(params,"u",id)||!IsPlayerConnected(id)) return SendClientMessage(playerid,-1,"Koristenje: /checklic [ID/Ime]");
    new f[128],n[MAX_PLAYER_NAME],t[320]; GetPlayerName(id,n,sizeof(n)); JuniorAdminFile(id,f,sizeof(f));
    format(t,sizeof(t),"{33CCFF}Dozvole igraca %s\n\n{FFFFFF}Vozacka: %s\nDozvola za oruzje: %s",n,DOF2_GetInt(f,"Vozacka")? ("IMA"):("NEMA"),DOF2_GetInt(f,"DozvolaOruzje")? ("IMA"):("NEMA"));
    ShowPlayerDialog(playerid,DIALOG_ADMIN_CHECK,DIALOG_STYLE_MSGBOX,"Provjera dozvola",t,"Zatvori",""); return 1;
}

CMD:checkdm(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))return 0;new id;if(sscanf(params,"u",id)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /checkdm [ID/Ime]");
    new n[MAX_PLAYER_NAME],a[MAX_PLAYER_NAME],v[MAX_PLAYER_NAME],t[700],line[180];GetPlayerName(id,n,sizeof(n));format(t,sizeof(t),"{33CCFF}DM provjera igraca: {FFFFFF}%s (ID %d)\n\n",n,id);
    if(LastDamageIssuer[id]!=INVALID_PLAYER_ID&&IsPlayerConnected(LastDamageIssuer[id])){GetPlayerName(LastDamageIssuer[id],a,sizeof(a));format(line,sizeof(line),"{33CCFF}Zadnji napad na igraca:{FFFFFF} %s | oruzje %d | prije %d sek.\n",a,LastDamageWeapon[id],gettime()-LastDamageAt[id]);}else format(line,sizeof(line),"{33CCFF}Zadnji napad na igraca:{FFFFFF} Nema zapisa.\n");strcat(t,line,sizeof(t));
    if(LastKilledPlayer[id]!=INVALID_PLAYER_ID){if(IsPlayerConnected(LastKilledPlayer[id]))GetPlayerName(LastKilledPlayer[id],v,sizeof(v));
    else format(v,sizeof(v),"ID %d",LastKilledPlayer[id]);
    format(line,sizeof(line),"{33CCFF}Zadnje ubistvo:{FFFFFF} %s | oruzje %d | prije %d sek.\n",v,LastKillWeapon[id],gettime()-LastKillAt[id]);
        }else format(line,sizeof(line),"{33CCFF}Zadnje ubistvo:{FFFFFF} Nema zapisa.\n");
    strcat(t,line,sizeof(t));
        format(line,sizeof(line),"{33CCFF}Oruzje/metci:{FFFFFF} %d/%d | {33CCFF}Wanted:{FFFFFF} %d\n\n{FF7777}Admin procjenjuje da li je ubistvo bilo DM.",GetPlayerWeapon(id),GetPlayerAmmo(id),WantedPoints[id]);
        strcat(t,line,sizeof(t));
        ShowPlayerDialog(playerid,DIALOG_ADMIN_CHECK,DIALOG_STYLE_MSGBOX,"DM provjera",t,"Zatvori","");
        return 1;
        
}
CMD:checkw(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0; new id; if(sscanf(params,"u",id)||!IsPlayerConnected(id)) return SendClientMessage(playerid,-1,"Koristenje: /checkw [ID/Ime]");
    new text[768],line[64],weapon,ammo,wname[32]; strcat(text,"{33CCFF}ORUZJE IGRACA\n\n",sizeof(text));
    for(new slot=0;slot<13;slot++){GetPlayerWeaponData(id,slot,weapon,ammo);if(weapon>0&&ammo>0){GetWeaponName(weapon,wname,sizeof(wname));format(line,sizeof(line),"{FFFFFF}%s (ID %d): %d metaka\n",wname,weapon,ammo);strcat(text,line,sizeof(text));}}
    ShowPlayerDialog(playerid,DIALOG_ADMIN_CHECK,DIALOG_STYLE_MSGBOX,"Provjera oruzja",text,"Zatvori",""); return 1;
}

CMD:setage(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0; new id,age; if(sscanf(params,"ui",id,age)) return SendClientMessage(playerid,-1,"Koristenje: /setage [ID/Ime] [Godine]"); if(!IsPlayerConnected(id)||age<10||age>100)return SendClientMessage(playerid,0xFF7777FF,"Igrac nije online ili godine nisu 10-100.");
    new f[128]; JuniorAdminFile(id,f,sizeof(f)); PlayerInfo[id][pGodine]=age; DOF2_SetInt(f,"Godine",age); DOF2_SaveFile(); SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Godine su postavljene."); return 1;
}

CMD:setjob(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid, jobid;
    if(sscanf(params, "ui", targetid, jobid))
        return SendClientMessage(playerid, -1, "Koristenje: /setjob [ID/Ime] [ID posla 0-20]");
    if(!IsPlayerConnected(targetid) || jobid < 0 || jobid > 20)
        return SendClientMessage(playerid, 0xFF7777FF, "Pogresan igrac ili ID posla.");
    new file[128]; JuniorAdminFile(targetid, file, sizeof(file));
    DOF2_SetInt(file, "Posao", jobid); DOF2_SaveFile();
    SendClientMessage(playerid, 0x33CCFFFF, "[ADMIN]: Posao je postavljen.");
    return 1;
}

CMD:setcarhp(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))return 0;
    new Float:hp;
        if(sscanf(params,"f",hp))return SendClientMessage(playerid,-1,"Koristenje: /setcarhp [0-1000]");
        if(GetPlayerState(playerid)!=PLAYER_STATE_DRIVER)return SendClientMessage(playerid,0xFF7777FF,"Morate biti vozac vozila.");
        if(hp<0.0||hp>1000.0)return SendClientMessage(playerid,0xFF7777FF,"HP vozila mora biti 0-1000.");
        SetVehicleHealth(GetPlayerVehicleID(playerid),hp);
        return SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: HP vozila je postavljen.");
        
}
CMD:askin(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))return 0;new id,skin;if(sscanf(params,"ui",id,skin)||!IsPlayerConnected(id)||skin<0||skin>311||skin==74)return SendClientMessage(playerid,-1,"Koristenje: /askin [ID/Ime] [0-311, osim 74]");SetPlayerSkin(id,skin);SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Privremeni skin je postavljen do ponovnog ulaska igraca.");return 1;
}
CMD:sethp(playerid, params[]) return cmd_sethealth(playerid, params);
CMD:setarmor(playerid, params[]) return cmd_setarmour(playerid, params);

CMD:freeze(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;new id;if(sscanf(params,"u",id)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /freeze [ID/Ime]");TogglePlayerControllable(id,0);JuniorFrozen[id]=true;SendClientMessage(id,0xFF7777FF,"[ADMIN]: Zamrznuti ste.");return 1;}
CMD:unfreeze(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;new id;if(sscanf(params,"u",id)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /unfreeze [ID/Ime]");TogglePlayerControllable(id,1);JuniorFrozen[id]=false;SendClientMessage(id,0x33CCFFFF,"[ADMIN]: Odmrznuti ste.");return 1;}
CMD:auntie(playerid, params[]) return cmd_unfreeze(playerid, params);

CMD:getcar(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))return 0;
    new v;
        if(sscanf(params,"i",v))return SendClientMessage(playerid,-1,"Koristenje: /getcar [ID vozila iz /dl]");
        if(v<1||v>=MAX_VEHICLES||GetVehicleModel(v)==0)return SendClientMessage(playerid,0xFF7777FF,"Vozilo s tim ID-om ne postoji.");
        new interior=GetPlayerInterior(playerid),world=GetPlayerVirtualWorld(playerid),Float:x,Float:y,Float:z;
        GetPlayerPos(playerid,x,y,z);
        SetVehicleVirtualWorld(v,world);
        LinkVehicleToInterior(v,interior);
        for(new i=0;
        i<MAX_PLAYERS;
        i++)if(IsPlayerConnected(i)&&IsPlayerInVehicle(i,v)){SetPlayerInterior(i,interior);
    SetPlayerVirtualWorld(i,world);
        }SetVehicleVelocity(v,0.0,0.0,0.0);
        SetVehiclePos(v,x+4.0,y,z+0.5);
        VehicleHudLastPosValid[v]=false;
        return SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Vozilo i svi putnici teleportovani su do vas.");
        
}
CMD:awl(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))return 0;new id,n[MAX_PLAYER_NAME],m[128];if(sscanf(params,"u",id)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /awl [ID/Ime]");GetPlayerName(id,n,sizeof(n));format(m,sizeof(m),"[AWL]: Igrac %s (ID %d) ima %d Wanted Levela.",n,id,WantedPoints[id]);return SendClientMessage(playerid,0x33CCFFFF,m);
}
CMD:he(playerid, params[])
{
    if(!HasStaffChatAccess(playerid))return 0;if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /he [Poruka]");if(JuniorMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"Oduzeto vam je pravo govora.");new m[144];format(m,sizeof(m),"[POMOC] %s",params);SendClientMessageToAll(0xFFFFFFFF,m);return 1;
}
CMD:flip(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))return 0;if(GetPlayerState(playerid)!=PLAYER_STATE_DRIVER)return SendClientMessage(playerid,-1,"Morate biti vozac vozila.");new v=GetPlayerVehicleID(playerid),Float:a;GetVehicleZAngle(v,a);SetVehicleZAngle(v,a);return 1;
}
CMD:apark(playerid, params[])
{
    #pragma unused params
    if(!HasAdminCommandAccess(playerid))return 0;
    if(GetPlayerState(playerid)!=PLAYER_STATE_DRIVER)return SendClientMessage(playerid,0xFF7777FF,"Morate biti vozac vozila koje preparkiravate.");
        new v=GetPlayerVehicleID(playerid),f[64]="BalkanRP/AdminParkedVehicles.ini",key[32];
        GetVehiclePos(v,AdminParkX[v],AdminParkY[v],AdminParkZ[v]);
        GetVehicleZAngle(v,AdminParkA[v]);
        AdminParkedVehicle[v]=true;
        if(!DOF2_FileExists(f))DOF2_CreateFile(f);
        format(key,sizeof(key),"V%d_X",v);
        DOF2_SetFloat(f,key,AdminParkX[v]);
        format(key,sizeof(key),"V%d_Y",v);
        DOF2_SetFloat(f,key,AdminParkY[v]);
        format(key,sizeof(key),"V%d_Z",v);
        DOF2_SetFloat(f,key,AdminParkZ[v]);
        format(key,sizeof(key),"V%d_A",v);
        DOF2_SetFloat(f,key,AdminParkA[v]);
        format(key,sizeof(key),"V%d_Set",v);
        DOF2_SetInt(f,key,1);
        DOF2_SaveFile();
        VehicleHudSaveKm(v);
        return SendClientMessage(playerid,0x33CCFFFF,"[APARK]: Nova parking pozicija vozila je sacuvana.");
        
}
CMD:cc(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))return 0;for(new i=0;i<30;i++)SendClientMessageToAll(-1," ");SendClientMessageToAll(0x33CCFFFF,"Chat je obrisan od strane Admin Team-a");return 1;
}
CMD:mute(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid, minutes, reason[64];
    if(sscanf(params, "uis[64]", targetid, minutes, reason))
        return SendClientMessage(playerid, -1, "Koristenje: /mute [ID/Ime] [Minute] [Razlog]");
    if(!IsPlayerConnected(targetid) || minutes < 1 || minutes > 1440)
        return SendClientMessage(playerid, 0xFF7777FF, "Pogresan igrac ili trajanje mutea.");
    JuniorMutedUntil[targetid] = gettime() + minutes * 60;
    if(JuniorMuteLabel[targetid] != Text3D:INVALID_3DTEXT_ID) Delete3DTextLabel(JuniorMuteLabel[targetid]);
    JuniorMuteLabel[targetid] = Create3DTextLabel("[MUTIRAN]", 0xFF0000FF, 0.0, 0.0, 0.35, 25.0, 0, 1);
    Attach3DTextLabelToPlayer(JuniorMuteLabel[targetid], targetid, 0.0, 0.0, 0.35);
    new file[128]; JuniorAdminFile(targetid, file, sizeof(file));
    DOF2_SetInt(file, "AdminMuteUntil", JuniorMutedUntil[targetid]); DOF2_SaveFile();
    new message[128];
    format(message, sizeof(message), "[MUTE]: Mutovani ste %d minuta. Razlog: %s", minutes, reason);
    SendClientMessage(targetid, 0xFF7777FF, message);
    SendClientMessage(playerid, 0x33CCFFFF, "[ADMIN]: Igrac je mutovan.");
    AddPlayerSavedStat(targetid, "AdminKazne", 1);
    return 1;
}

CMD:unmute(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid;
    if(sscanf(params, "u", targetid) || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Koristenje: /unmute [ID/Ime]");
    JuniorMutedUntil[targetid] = 0;
    new file[128]; JuniorAdminFile(targetid, file, sizeof(file));
    DOF2_SetInt(file, "AdminMuteUntil", 0); DOF2_SaveFile();
    SendClientMessage(targetid, 0x33CCFFFF, "[MUTE]: Admin vam je uklonio mute.");
    SendClientMessage(playerid, 0x33CCFFFF, "[ADMIN]: Mute je uklonjen.");
    return 1;
}

CMD:ajail(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid, minutes, reason[64];
    if(sscanf(params, "uis[64]", targetid, minutes, reason))
        return SendClientMessage(playerid, -1, "Koristenje: /ajail [ID/Ime] [Minute] [Razlog]");
    if(!IsPlayerConnected(targetid) || minutes < 1 || minutes > 1440)
        return SendClientMessage(playerid, 0xFF7777FF, "Pogresan igrac ili trajanje zatvora.");
    JuniorJailedUntil[targetid] = gettime() + minutes * 60;
    new file[128]; JuniorAdminFile(targetid, file, sizeof(file));
    DOF2_SetInt(file, "AdminJailUntil", JuniorJailedUntil[targetid]); DOF2_SaveFile();
    JuniorTeleport(targetid, 264.63, 77.57, 1001.04, 6, 0);
    new message[128];
    format(message, sizeof(message), "[ZATVOR]: Zatvoreni ste %d minuta. Razlog: %s", minutes, reason);
    SendClientMessage(targetid, 0xFF7777FF, message);
    AddPlayerSavedStat(targetid, "AdminKazne", 1);
    return 1;
}

CMD:jailed(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid;
    if(sscanf(params, "u", targetid) || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Koristenje: /jailed [ID/Ime]");
    new message[128];
    if(JuniorJailedUntil[targetid] > gettime())
        format(message, sizeof(message), "[ZATVOR]: Igracu je ostalo %d sekundi.", JuniorJailedUntil[targetid] - gettime());
    else
        format(message, sizeof(message), "[ZATVOR]: Igrac nije zatvoren.");
    SendClientMessage(playerid, 0x33CCFFFF, message);
    return 1;
}

CMD:akick(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))return 0;
    new id,reason[96];
        if(sscanf(params,"us[96]",id,reason)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /akick [ID/Ime] [Razlog]");
        if(id==playerid)return SendClientMessage(playerid,0xFF7777FF,"Ne mozete kikovati sami sebe.");
        new m[144];
        format(m,sizeof(m),"Kikovani ste od strane AdminTeama. Razlog: %s",reason);
        SendClientMessage(id,0xFA8072FF,m);
        SendClientMessage(playerid,0x33CCFFFF,"[AKICK]: Igrac je privatno kikovan.");
        AddPlayerSavedStat(id,"AdminKazne",1);
        SetTimerEx("IzvrsiKick",500,false,"i",id);
        return 1;
        
}
CMD:rpslap(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid, reason[96];
    if(sscanf(params, "us[96]", targetid, reason) || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Koristenje: /rpslap [ID/Ime] [Razlog]");
    new Float:x, Float:y, Float:z, targetName[MAX_PLAYER_NAME], message[160];
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(targetid, x, y, z + 5.0);
    GetPlayerName(targetid, targetName, sizeof(targetName));
    format(message, sizeof(message), "RP osamareni ste od strane AdminTeama. Razlog: %s", reason);
    SendClientMessage(targetid, 0xFA8072FF, message);
    format(message, sizeof(message), "Igrac %s je RP osamaren od strane AdminTeama. Razlog: %s", targetName, reason);
    SendClientMessageToAll(0xFA8072FF, message);
    AddPlayerSavedStat(targetid, "AdminKazne", 1);
    return 1;
}
CMD:napravipoklon(playerid, params[])
{
    #pragma unused params
    if(!HasAdminCommandAccess(playerid))return 0;
    new slot=-1;
        for(new i=0;
        i<MAX_ADMIN_GIFTS;
        i++)if(!AdminGiftActive[i]){slot=i;
    break;
        }if(slot==-1)return SendClientMessage(playerid,0xFF7777FF,"[POKLON]: Previse aktivnih poklona.");
        GetPlayerPos(playerid,AdminGiftX[slot],AdminGiftY[slot],AdminGiftZ[slot]);
        AdminGiftInterior[slot]=GetPlayerInterior(playerid);
        AdminGiftWorld[slot]=GetPlayerVirtualWorld(playerid);
        AdminGiftRotation[slot]=0.0;
        // Jedan prolazni pickup: nema collision i ne pravi dupli fizicki objekat.
        AdminGiftObject[slot]=STREAMER_TAG_OBJECT:INVALID_STREAMER_ID;
        AdminGiftPickup[slot]=CreateDynamicPickup(19054,23,AdminGiftX[slot],AdminGiftY[slot],AdminGiftZ[slot],AdminGiftWorld[slot],AdminGiftInterior[slot]);
        AdminGiftActive[slot]=true;
        new admin[MAX_PLAYER_NAME],zone[32],msg[180];
        GetPlayerName(playerid,admin,sizeof(admin));
        new MapZone:z=GetPlayerMapZone(playerid);
        if(z==INVALID_MAP_ZONE_ID||!GetMapZoneName(z,zone,sizeof(zone)))format(zone,sizeof(zone),"San Andreas");
        format(msg,sizeof(msg),"[POKLON]: Admin %s je napravio poklon u blizini lokacije %s. Pronadite ga i koristite /otvoripoklon!",admin,zone);
        SendClientMessageToAll(0xFFD700FF,msg);
        return 1;
        
}
CMD:otvoripoklon(playerid,params[])
{
    #pragma unused params
    new slot=-1;
    for(new i=0;
        i<MAX_ADMIN_GIFTS;
        i++)if(AdminGiftActive[i]&&GetPlayerInterior(playerid)==AdminGiftInterior[i]&&GetPlayerVirtualWorld(playerid)==AdminGiftWorld[i]&&IsPlayerInRangeOfPoint(playerid,3.0,AdminGiftX[i],AdminGiftY[i],AdminGiftZ[i])){slot=i;
    break;
        }if(slot==-1)return SendClientMessage(playerid,0xFF7777FF,"[POKLON]: Niste dovoljno blizu aktivnog poklona.");
        AdminGiftActive[slot]=false;
        DestroyDynamicPickup(AdminGiftPickup[slot]);
        AdminGiftPickup[slot]=STREAMER_TAG_PICKUP:INVALID_STREAMER_ID;
        new f[128],m[160],reward=random(10),amount;
        JuniorAdminFile(playerid,f,sizeof(f));
        
    switch(reward){case 0:{amount=5+random(46);
    DOF2_SetInt(f,"Droga",DOF2_GetInt(f,"Droga")+amount);
        format(m,sizeof(m),"[POKLON]: Dobili ste %d grama droge.",amount);
        }case 1:{amount=100+random(1901);
    DOF2_SetInt(f,"Materijali",DOF2_GetInt(f,"Materijali")+amount);
        format(m,sizeof(m),"[POKLON]: Dobili ste %d materijala.",amount);
        }case 2:{new guns[10]={22,24,25,27,29,30,31,33,34,35};
    new w=guns[random(sizeof(guns))];
        amount=20+random(181);
        GivePlayerWeapon(playerid,w,amount);
        format(m,sizeof(m),"[POKLON]: Dobili ste oruzje ID %d sa %d metaka.",w,amount);
        }case 3:{amount=1000+random(49001);
    GivePlayerMoney(playerid,amount);
        PlayerInfo[playerid][pNovac]=GetPlayerMoney(playerid);
        DOF2_SetInt(f,"Novac",PlayerInfo[playerid][pNovac]);
        format(m,sizeof(m),"[POKLON]: Dobili ste %d RSD.",amount);
        }case 4:{amount=1+random(3);
    DOF2_SetInt(f,"BapPoeni",DOF2_GetInt(f,"BapPoeni")+amount);
        format(m,sizeof(m),"[POKLON]: Dobili ste %d RP poena.",amount);
        }case 5:{amount=1+random(5);
    DOF2_SetInt(f,"DonatorRank",amount);
        format(m,sizeof(m),"[POKLON]: Dobili ste VIP rank %d.",amount);
        }case 6:{amount=1+random(11);
    PlayerZlato[playerid]+=amount;
        DOF2_SetInt(f,"Zlato",PlayerZlato[playerid]);
        UpdateZlatoTD(playerid);
        format(m,sizeof(m),"[POKLON]: Dobili ste %d zlata.",amount);
        }case 7:{amount=10+random(191);
    DOF2_SetInt(f,"Euro",DOF2_GetInt(f,"Euro")+amount);
        format(m,sizeof(m),"[POKLON]: Dobili ste %d eura.",amount);
        }case 8:{SetPlayerScore(playerid,GetPlayerScore(playerid)+1);
    DOF2_SetInt(f,"Level",GetPlayerScore(playerid));
        format(m,sizeof(m),"[POKLON]: Dobili ste 1 level.");
        }case 9:{amount=1+random(5);
    PlayerRespekti[playerid]+=amount;
        DOF2_SetInt(f,"Respekti",PlayerRespekti[playerid]);
        format(m,sizeof(m),"[POKLON]: Dobili ste %d Experience.",amount);
    }}DOF2_SaveFile();
        UpdateRevolutionHudData(playerid);
        SendClientMessage(playerid,0xFFD700FF,m);
        return 1;
        
}
CMD:masked(playerid, params[])
{
    #pragma unused params
    if(!HasAdminCommandAccess(playerid))return 0;
    new text[1200],line[96],count=0,n[MAX_PLAYER_NAME],t[MAX_PLAYER_NAME];
        for(new i=0;
        i<MAX_PLAYERS;
        i++)if(IsPlayerConnected(i)&&JuniorSpectating[i]){GetPlayerName(i,n,sizeof(n));
    if(JuniorSpecTarget[i]!=INVALID_PLAYER_ID&&IsPlayerConnected(JuniorSpecTarget[i]))GetPlayerName(JuniorSpecTarget[i],t,sizeof(t));
        else format(t,sizeof(t),"nepoznat");
        format(line,sizeof(line),"{33CCFF}%s (ID %d){FFFFFF} spectate: %s\n",n,i,t);
        strcat(text,line,sizeof(text));
        count++;
        }if(!count)format(text,sizeof(text),"{FFFFFF}Nijedan Admin/Helper trenutno ne spectatea igraca.");
        ShowPlayerDialog(playerid,DIALOG_ADMIN_CHECK,DIALOG_STYLE_MSGBOX,"Admin/Helper spectate lista",text,"Zatvori","");
        return 1;
        
}
CMD:spec(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid;
    if(sscanf(params, "u", targetid) || !IsPlayerConnected(targetid) || targetid == playerid)
        return SendClientMessage(playerid, -1, "Koristenje: /spec [ID/Ime drugog igraca]");

    GetPlayerPos(playerid, JuniorSpecX[playerid], JuniorSpecY[playerid], JuniorSpecZ[playerid]);
    JuniorSpecInterior[playerid] = GetPlayerInterior(playerid);
    JuniorSpecWorld[playerid] = GetPlayerVirtualWorld(playerid);
    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
    TogglePlayerSpectating(playerid, 1);
    PlayerSpectatePlayer(playerid, targetid);
    JuniorSpectating[playerid] = true;
    JuniorSpecTarget[playerid] = targetid;
    PhoneSpecDisabled[playerid] = true;
    SendClientMessage(playerid, 0x33CCFFFF, "[SPEC]: Posmatrate igraca. Koristite /specoff za izlaz.");
    return 1;
}

CMD:specoff(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    if(!JuniorSpectating[playerid])
        return SendClientMessage(playerid, 0xFF7777FF, "Niste u spec modu.");
    TogglePlayerSpectating(playerid, 0);
    JuniorSpectating[playerid] = false;
    JuniorSpecTarget[playerid] = INVALID_PLAYER_ID;
    PhoneSpecDisabled[playerid] = false;
    SetPlayerInterior(playerid, JuniorSpecInterior[playerid]);
    SetPlayerVirtualWorld(playerid, JuniorSpecWorld[playerid]);
    SetPlayerPos(playerid, JuniorSpecX[playerid], JuniorSpecY[playerid], JuniorSpecZ[playerid]);
    SetCameraBehindPlayer(playerid);
    return 1;
}

stock HasStaffChatAccess(playerid)
{
    if(HasAdminCommandAccess(playerid))return 1;new f[128];if(!JuniorAdminFile(playerid,f,sizeof(f)))return 0;return DOF2_GetInt(f,"Helper")>0;
}
stock JuniorStaffChat(playerid,const channel[],const msg[])
{
    if(!HasStaffChatAccess(playerid))return 0;if(JuniorMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"Oduzeto vam je pravo govora.");new n[MAX_PLAYER_NAME],o[144];GetPlayerName(playerid,n,sizeof(n));format(o,sizeof(o),"[%s] %s[%d]: %s",channel,n,playerid,msg);for(new i=0;i<MAX_PLAYERS;i++)if(IsPlayerConnected(i)&&HasStaffChatAccess(i))SendClientMessage(i,0x33CCFFFF,o);return 1;
}

CMD:a(playerid, params[])
{
    // 1. Provjera admin ranka preko DOF2 fajla
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_rank = 0;
    if(DOF2_FileExists(file)) {
        admin_rank = DOF2_GetInt(file, "Admin");
    }

    if(admin_rank < 1 && !IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, 0xFF3333FF, "(GRESKA!) Niste ovla?teni da koristite ovu komandu!");

    // 2. Provjera unesenog teksta (ako se upi?e samo /a, ispisuje obavje?tenje)
    new poruka[128];
    if(sscanf(params, "s[128]", poruka))
        return SendClientMessage(playerid, 0xE0E0E0FF, "/a [Poruka]");

    // 3. Dodjela naziva ranga ta?no po tvojoj listi
    new rank_naziv[32];
    switch(admin_rank)
    {
        case 1: rank_naziv = "Junior admin";
        case 2: rank_naziv = "Admin";
        case 3: rank_naziv = "Senior Admin";
        case 4: rank_naziv = "Head admin";
        case 5: rank_naziv = "Director";
        case 6: rank_naziv = "Mapper";
        case 7: rank_naziv = "Skripter";
        case 8: rank_naziv = "Suvlasnik";
        case 9: rank_naziv = "Vlasnik";
        default: rank_naziv = "Admin";
    }

    if(IsPlayerAdmin(playerid) && admin_rank == 0)
    {
        rank_naziv = "RCON Admin";
    }

    // 4. Formatiranje poruke u obliku: ** [Rank] [Ime][ID]: [Poruka]
    new string[256];
    format(string, sizeof(string), "** %s %s[%d]: %s", rank_naziv, ime, playerid, poruka);

    // 5. Slanje poruke svim online adminima
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new i_file[128], i_name[MAX_PLAYER_NAME];
            GetPlayerName(i, i_name, sizeof(i_name));
            format(i_file, sizeof(i_file), "Korisnici/%s.ini", i_name);

            if(DOF2_FileExists(i_file))
            {
                if(DOF2_GetInt(i_file, "Admin") > 0 || IsPlayerAdmin(i))
                {
                    SendClientMessage(i, 0xF9A602FF, string); // Narand?asta boja za cijelu liniju u chatu
                }
            }
        }
    }
    return 1;
}
CMD:h(playerid, params[])
{
    // 1. Provjera admin ili helper statusa preko DOF2 fajla
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_rank = 0, helper_rank = 0;
    if(DOF2_FileExists(file)) {
        admin_rank = DOF2_GetInt(file, "Admin");
        helper_rank = DOF2_GetInt(file, "Helper"); // Klju? za helper rank u fajlu
    }

    // Ako igra? nema ni admin ni helper rank i nije RCON admin
    if(admin_rank < 1 && helper_rank < 1 && !IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, 0xFF3333FF, "GRESKA: Niste ovla?teni da koristite ovu komandu!");

    // 2. Provjera unesenog teksta (ako se upi?e samo /h, ispisuje obavje?tenje)
    new poruka[128];
    if(sscanf(params, "s[128]", poruka))
        return SendClientMessage(playerid, 0xE0E0E0FF, "Koristenje: /h [Poruka]");

    // 3. Odre?ivanje naziva (ako je admin, mo?e pisati sa admin rankom, ako je helper, pi?e kao helper)
    new rank_naziv[32];
    if(admin_rank > 0)
    {
        switch(admin_rank)
        {
            case 1: rank_naziv = "Junior admin";
            case 2: rank_naziv = "Admin";
            case 3: rank_naziv = "Senior Admin";
            case 4: rank_naziv = "Head admin";
            case 5: rank_naziv = "Director";
            case 6: rank_naziv = "Mapper";
            case 7: rank_naziv = "Skripter";
            case 8: rank_naziv = "Suvlasnik";
            case 9: rank_naziv = "Vlasnik";
            default: rank_naziv = "Admin";
        }
    }
    else if(helper_rank > 0)
    {
        // Ovdje mo?e? prilagoditi nazive helper rankova ako ih ima vi?e nivoa
        switch(helper_rank)
        {
            case 1: rank_naziv = "Helper 1";
            case 2: rank_naziv = "Helper 2";
            case 3: rank_naziv = "Helper 3";
            case 4: rank_naziv = "Z. Head Helper-a";
            case 5: rank_naziv = "Head Helper";
            default: rank_naziv = "Helper";
        }
    }
    else if(IsPlayerAdmin(playerid))
    {
        rank_naziv = "RCON Admin";
    }

    // 4. Formatiranje poruke u obliku: ** [Rank] Ime[ID]: [Poruka]
    new string[256];
    format(string, sizeof(string), "[Admin/Helper Chat] %s %s[%d]: %s", rank_naziv, ime, playerid, poruka);

    // 5. Slanje poruke svim online helperima i adminima
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            new i_file[128], i_name[MAX_PLAYER_NAME];
            GetPlayerName(i, i_name, sizeof(i_name));
            format(i_file, sizeof(i_file), "Korisnici/%s.ini", i_name);

            if(DOF2_FileExists(i_file))
            {
                // Poruku vide i admini i helperi
                if(DOF2_GetInt(i_file, "Admin") > 0 || DOF2_GetInt(i_file, "Helper") > 0 || IsPlayerAdmin(i))
                {
                    SendClientMessage(i, 0xFFFF00FF, string); // Svijetlo zelena boja za helper chat (mo?e? promijeniti po ?elji)
                }
            }
        }
    }
    return 1;
}
CMD:g(playerid,params[])
{
    if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /g [Poruka]");
    if(JuniorMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"Oduzeto vam je pravo govora.");
        if(JuniorGMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"[G CHAT]: Mutirani ste na donatorskom chatu.");
        if(JuniorGlobalChatLocked&&!HasAdminCommandAccess(playerid))return SendClientMessage(playerid,0xFF7777FF,"[G CHAT]: Donatorski chat je zakljucan.");
        new f[128];
        JuniorAdminFile(playerid,f,sizeof(f));
        if(!HasAdminCommandAccess(playerid)&&DOF2_GetInt(f,"DonatorRank")<1&&DOF2_GetInt(f,"Promoter")<1)return SendClientMessage(playerid,0xFF7777FF,"[G CHAT]: Chat je samo za VIP/Donatore/Promotere.");
        new n[MAX_PLAYER_NAME],m[144],adminMessage[144];
        GetPlayerName(playerid,n,sizeof(n));
        format(m,sizeof(m),"[DONATORSKI CHAT] %s: %s",n,params);
        format(adminMessage,sizeof(adminMessage),"[DONATORSKI CHAT] %s[%d]: %s",n,playerid,params);
        for(new i=0;
        i<MAX_PLAYERS;
        i++)if(IsPlayerConnected(i)){new tf[128];
    JuniorAdminFile(i,tf,sizeof(tf));
        if(HasAdminCommandAccess(i)) SendClientMessage(i,0xFFD700FF,adminMessage);
        else if(DOF2_GetInt(tf,"DonatorRank")>0||DOF2_GetInt(tf,"Promoter")>0)SendClientMessage(i,0xFFD700FF,m);
        }return 1;
        
}
CMD:o(playerid,params[]){if(JuniorMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"Oduzeto vam je pravo govora.");return SendAdminOOC(playerid,params);}
CMD:or(playerid,params[]){return SendClientMessage(playerid,0xFF7777FF,"[OR]: Funkcija ove komande jos nije odredena.");}
CMD:pr(playerid,params[])
{
    if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /pr [Poruka]");
    if(JuniorMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"Oduzeto vam je pravo govora.");
        new f[128];
        JuniorAdminFile(playerid,f,sizeof(f));
        if(!HasAdminCommandAccess(playerid)&&DOF2_GetInt(f,"Promoter")<1)return 0;
        new n[MAX_PLAYER_NAME],m[144],adminMessage[144];
        GetPlayerName(playerid,n,sizeof(n));
        format(m,sizeof(m),"[PROMOTER CHAT] %s: %s",n,params);
        format(adminMessage,sizeof(adminMessage),"[PROMOTER CHAT] %s[%d]: %s",n,playerid,params);
        for(new i=0;
        i<MAX_PLAYERS;
        i++)if(IsPlayerConnected(i)){new tf[128];
    JuniorAdminFile(i,tf,sizeof(tf));
        if(HasAdminCommandAccess(i)) SendClientMessage(i,0xFFB347FF,adminMessage);
        else if(DOF2_GetInt(tf,"Promoter")>0)SendClientMessage(i,0xFFB347FF,m);
        }return 1;
        
}
stock SetJuniorChannelMute(playerid,targetid,minutes,key[],kind)
{
    if(!HasAdminCommandAccess(playerid))return 0;
    if(!IsPlayerConnected(targetid)||minutes<1||minutes>10080)return SendClientMessage(playerid,0xFF7777FF,"Pogresan igrac ili vrijeme (1-10080 minuta).");
    new until=gettime()+minutes*60,f[128],m[128];JuniorAdminFile(targetid,f,sizeof(f));DOF2_SetInt(f,key,until);DOF2_SaveFile();
    switch(kind){case 1:JuniorGMutedUntil[targetid]=until;case 2:JuniorAdMutedUntil[targetid]=until;case 3:JuniorAskMutedUntil[targetid]=until;case 4:JuniorReportMutedUntil[targetid]=until;}
    format(m,sizeof(m),"[MUTE]: Oduzeto vam je pravo koristenja ovog chata na %d minuta.",minutes);SendClientMessage(targetid,0xFF7777FF,m);return SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Posebni mute je postavljen.");
}
CMD:lockgchat(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    JuniorGlobalChatLocked = !JuniorGlobalChatLocked;
    if(JuniorGlobalChatLocked)
        SendClientMessageToAll(0x33CCFFFF, "[G CHAT]: Admin je zakljucao donatorski chat.");
    else
        SendClientMessageToAll(0x33CCFFFF, "[G CHAT]: Admin je otkljucao donatorski chat.");
    return 1;
}

CMD:mutegchat(playerid,params[]){new id,duration,reason[64];if(sscanf(params,"uis[64]",id,duration,reason))return SendClientMessage(playerid,-1,"Koristenje: /mutegchat [ID/Ime] [Minute] [Razlog]");return SetJuniorChannelMute(playerid,id,duration,"MuteGUntil",1);}
CMD:mutead(playerid,params[]){new id,duration,reason[64];if(sscanf(params,"uis[64]",id,duration,reason))return SendClientMessage(playerid,-1,"Koristenje: /mutead [ID/Ime] [Minute] [Razlog]");return SetJuniorChannelMute(playerid,id,duration,"MuteAdUntil",2);}
CMD:muteaskq(playerid,params[]){new id,duration,reason[64];if(sscanf(params,"uis[64]",id,duration,reason))return SendClientMessage(playerid,-1,"Koristenje: /muteaskq [ID/Ime] [Minute] [Razlog]");return SetJuniorChannelMute(playerid,id,duration,"MuteAskUntil",3);}
CMD:mutereport(playerid,params[]){new id,duration,reason[64];if(sscanf(params,"uis[64]",id,duration,reason))return SendClientMessage(playerid,-1,"Koristenje: /mutereport [ID/Ime] [Minute] [Razlog]");return SetJuniorChannelMute(playerid,id,duration,"MuteReportUntil",4);}

CMD:askq(playerid,params[])
{
    if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /askq [Pitanje]");if(JuniorMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"Oduzeto vam je pravo govora.");if(JuniorAskMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"[ASKQ]: Oduzeto vam je pravo slanja pitanja.");
    new n[MAX_PLAYER_NAME],m[144];GetPlayerName(playerid,n,sizeof(n));format(m,sizeof(m),"[ASKQ] %s[%d]: %s",n,playerid,params);for(new i=0;i<MAX_PLAYERS;i++)if(IsPlayerConnected(i)&&HasStaffChatAccess(i))SendClientMessage(i,0x66CCFFFF,m);SendClientMessage(playerid,0x66CCFFFF,"[ASKQ]: Pitanje je poslano administraciji.");return 1;
}
CMD:report(playerid,params[])
{
    new id,reason[100];if(sscanf(params,"us[100]",id,reason)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /report [ID/Ime] [Razlog]");if(JuniorMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"Oduzeto vam je pravo govora.");if(JuniorReportMutedUntil[playerid]>gettime())return SendClientMessage(playerid,0xFF7777FF,"[REPORT]: Oduzeto vam je pravo prijavljivanja.");
    new a[MAX_PLAYER_NAME],b[MAX_PLAYER_NAME],m[180];GetPlayerName(playerid,a,sizeof(a));GetPlayerName(id,b,sizeof(b));format(m,sizeof(m),"[REPORT] %s[%d] prijavljuje %s[%d]: %s",a,playerid,b,id,reason);for(new i=0;i<MAX_PLAYERS;i++)if(IsPlayerConnected(i)&&HasStaffChatAccess(i))SendClientMessage(i,0xFF7777FF,m);SendClientMessage(playerid,0x66CCFFFF,"[REPORT]: Prijava je poslana administraciji.");return 1;
}
CMD:startevent(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;GetPlayerPos(playerid,JuniorEventX,JuniorEventY,JuniorEventZ);JuniorEventInterior=GetPlayerInterior(playerid);JuniorEventWorld=GetPlayerVirtualWorld(playerid);JuniorEventActive=true;SendClientMessageToAll(0x33CCFFFF,"[EVENT]: Admin je pokrenuo event.");return 1;}
CMD:stopevent(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorEventActive=false;SendClientMessageToAll(0x33CCFFFF,"[EVENT]: Admin je zavrsio event.");return 1;}
CMD:checkevent(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;if(!JuniorEventActive)return SendClientMessage(playerid,0xFF7777FF,"[EVENT]: Trenutno nema aktivnog eventa.");new m[128];format(m,sizeof(m),"[EVENT]: Aktivan je na %.1f, %.1f, %.1f (Int %d, VW %d).",JuniorEventX,JuniorEventY,JuniorEventZ,JuniorEventInterior,JuniorEventWorld);return SendClientMessage(playerid,0x33CCFFFF,m);}
CMD:acontracts(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;ShowPlayerDialog(playerid,DIALOG_ADMIN_CHECK,DIALOG_STYLE_MSGBOX,"Admin ugovori","{FFFFFF}Na serveru trenutno nema aktivnog sistema ugovora.","Zatvori","");return 1;}

CMD:gotolist(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new text[640];
    strcat(text, "{33CCFF}/gotoautosk{FFFFFF} - autoskola\n", sizeof(text));
    strcat(text, "{33CCFF}/gotoplanina{FFFFFF} - Mount Chiliad\n", sizeof(text));
    strcat(text, "{33CCFF}/gotoaerodrom{FFFFFF} - aerodrom\n", sizeof(text));
    strcat(text, "{33CCFF}/gotojob{FFFFFF} - centar poslova\n", sizeof(text));
    strcat(text, "{33CCFF}/gotopijaca{FFFFFF} - pijaca\n", sizeof(text));
    strcat(text, "{33CCFF}/gotoboks{FFFFFF} - boks sala\n", sizeof(text));
    strcat(text, "{33CCFF}/gotojetn{FFFFFF} - pista za avione\n", sizeof(text));
    strcat(text, "{33CCFF}/gotomc{FFFFFF} - Mount Chiliad", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_ADMIN_CHECK, DIALOG_STYLE_MSGBOX, "Admin teleport lokacije", text, "Zatvori", "");
    return 1;
}

CMD:gotoautosk(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorTeleport(playerid,2045.8,-1908.2,13.5);return 1;}
CMD:gotoplanina(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorTeleport(playerid,-2329.1,-1624.2,483.7);return 1;}
CMD:gotomc(playerid,params[]){return cmd_gotoplanina(playerid,params);}
CMD:gotoaerodrom(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorTeleport(playerid,1685.9,-2331.2,13.5);return 1;}
CMD:gotojetn(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorTeleport(playerid,1958.4,-2493.6,13.5);return 1;}
CMD:gotojob(playerid,params[])
{
    #pragma unused params
    if(!HasAdminCommandAccess(playerid))return 0;ShowPlayerDialog(playerid,DIALOG_GOTOJOB,DIALOG_STYLE_LIST,"Teleport do posla","Cistac ulica\nPostar\nTaxi vozac\nParking Servis\nRibolovac","Odaberi","Odustani");return 1;
}
CMD:gotopijaca(playerid,params[])
{
    #pragma unused params
    if(!HasAdminCommandAccess(playerid))return 0;ShowPlayerDialog(playerid,DIALOG_GOTOPIJACA,DIALOG_STYLE_LIST,"Pijace vozila","Beogradska Pijaca Vozila\nSarajevska Pijaca Vozila\nZagrebacka Pijaca Vozila\nPijaca Motora","Odaberi","Odustani");return 1;
}
CMD:gotoboks(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorTeleport(playerid,768.0,-19.0,1000.7,5,0);return 1;}

forward CheckTemporaryNames();

stock TempNameKey(key[], size, slot, const field[])
{
    format(key, size, "Name_%d_%s", slot, field);
    return 1;
}

stock TempNameCount()
{
    if(!DOF2_FileExists(TEMP_NAME_REGISTRY)) return 0;
    new count = DOF2_GetInt(TEMP_NAME_REGISTRY, "Count");
    if(count < 0) return 0;
    if(count > MAX_TEMP_NAME_RECORDS) return MAX_TEMP_NAME_RECORDS;
    return count;
}

stock GetTempNameRecord(slot, original[], current[], &expires, &active)
{
    new key[48];
    TempNameKey(key, sizeof(key), slot, "Original");
    if(!DOF2_IsSet(TEMP_NAME_REGISTRY, key)) return 0;
    format(original, MAX_PLAYER_NAME, "%s", DOF2_GetString(TEMP_NAME_REGISTRY, key));
    TempNameKey(key, sizeof(key), slot, "Current");
    format(current, MAX_PLAYER_NAME, "%s", DOF2_GetString(TEMP_NAME_REGISTRY, key));
    TempNameKey(key, sizeof(key), slot, "Expires");
    expires = DOF2_GetInt(TEMP_NAME_REGISTRY, key);
    TempNameKey(key, sizeof(key), slot, "Active");
    active = DOF2_GetInt(TEMP_NAME_REGISTRY, key);
    return 1;
}

stock SaveNameBackup(const original[], const current[], expires, active)
{
    new file[128], oldname[MAX_PLAYER_NAME], tempname[MAX_PLAYER_NAME];
    format(file, sizeof(file), "%s/%s.ini", TEMP_NAME_BACKUP_DIR, original);
    if(!DOF2_FileExists(file) && !DOF2_CreateFile(file)) return 0;
    format(oldname, sizeof(oldname), "%s", original);
    format(tempname, sizeof(tempname), "%s", current);
    DOF2_SetString(file, "OriginalName", oldname);
    DOF2_SetString(file, "TemporaryName", tempname);
    DOF2_SetInt(file, "Expires", expires);
    DOF2_SetInt(file, "Active", active);
    if(!active) DOF2_SetInt(file, "RestoredAt", gettime());
    else DOF2_SetInt(file, "RestoredAt", 0);
    DOF2_SaveFile();
    return 1;
}

stock SetTempNameActive(slot, active)
{
    new key[48];
    TempNameKey(key, sizeof(key), slot, "Active");
    DOF2_SetInt(TEMP_NAME_REGISTRY, key, active);
    DOF2_SaveFile();
    return 1;
}

stock UpdateNameReferences(const oldname[], const newname[])
{
    new file[128], key[40], value[MAX_PLAYER_NAME];

    for(new i = 0; i < MAX_KUCA; i++)
    {
        if(strcmp(HouseInfo[i][kOwner], oldname, true) != 0) continue;
        format(HouseInfo[i][kOwner], MAX_PLAYER_NAME, "%s", newname);
        SaveHouse(i);
        UpdateHouseCP(i);
    }
    for(new i = 0; i < MAX_MARKETA; i++)
    {
        new changedBusinessName = 0;
        if(strcmp(MarketInfo[i][mOwner], oldname, true) == 0)
        {
            format(MarketInfo[i][mOwner], MAX_PLAYER_NAME, "%s", newname);
            changedBusinessName = 1;
        }
        if(strcmp(BusinessCoOwner[i], oldname, true) == 0)
        {
            format(BusinessCoOwner[i], MAX_PLAYER_NAME, "%s", newname);
            changedBusinessName = 1;
        }
        if(changedBusinessName) { SaveMarket(i); UpdateMarketCP(i); }
    }
    for(new i = 0; i < MAX_OGLASA; i++)
    {
        if(strcmp(OglasiInfo[i][oOwner], oldname, true) != 0) continue;
        format(OglasiInfo[i][oOwner], MAX_PLAYER_NAME, "%s", newname);
        SaveOglase(i);
        UpdateOglaseCP(i);
    }
    for(new i = 0; i < MAX_ZLATA; i++)
    {
        if(strcmp(ZlataInfo[i][zOwner], oldname, true) != 0) continue;
        format(ZlataInfo[i][zOwner], MAX_PLAYER_NAME, "%s", newname);
        SaveZlataru(i);
        UpdateZlataruCP(i);
    }
    for(new i = 0; i < MAX_TRAFIKE; i++)
    {
        if(strcmp(TrafikaInfo[i][tOwner], oldname, true) != 0) continue;
        format(TrafikaInfo[i][tOwner], MAX_PLAYER_NAME, "%s", newname);
        SaveTrafiku(i);
        UpdateTrafikuCP(i);
    }

    format(file, sizeof(file), "BalkanRP/Lideri.ini");
    if(DOF2_FileExists(file))
    {
        new changed = 0;
        for(new i = 1; i <= 19; i++)
        {
            format(key, sizeof(key), "Lider_%d", i);
            if(!DOF2_IsSet(file, key)) continue;
            format(value, sizeof(value), "%s", DOF2_GetString(file, key));
            if(strcmp(value, oldname, true) != 0) continue;
            format(value, sizeof(value), "%s", newname);
            DOF2_SetString(file, key, value);
            changed = 1;
        }
        if(changed) DOF2_SaveFile();
    }

    for(new org = 1; org <= 19; org++)
    {
        format(file, sizeof(file), "BalkanRP/Org_%d.ini", org);
        if(!DOF2_FileExists(file)) continue;
        new changed = 0;
        for(new slot = 0; slot < 30; slot++)
        {
            format(key, sizeof(key), "Slot_%d", slot);
            if(!DOF2_IsSet(file, key)) continue;
            format(value, sizeof(value), "%s", DOF2_GetString(file, key));
            if(strcmp(value, oldname, true) != 0) continue;
            format(value, sizeof(value), "%s", newname);
            DOF2_SetString(file, key, value);
            changed = 1;
        }
        if(changed) DOF2_SaveFile();
    }
    return 1;
}

stock RestoreTempNameSlot(slot)
{
    new original[MAX_PLAYER_NAME], current[MAX_PLAYER_NAME], expires, active;
    if(!GetTempNameRecord(slot, original, current, expires, active) || !active) return 0;

    new currentfile[128], originalfile[128];
    format(currentfile, sizeof(currentfile), "Korisnici/%s.ini", current);
    format(originalfile, sizeof(originalfile), "Korisnici/%s.ini", original);

    if(!DOF2_FileExists(currentfile))
    {
        if(!DOF2_FileExists(originalfile)) return 0;
        UpdateNameReferences(current, original);
        SetTempNameActive(slot, 0);
        SaveNameBackup(original, current, expires, 0);
        return 1;
    }
    if(DOF2_FileExists(originalfile)) return 0;

    new online = INVALID_PLAYER_ID, name[MAX_PLAYER_NAME];
    for(new p = 0; p < MAX_PLAYERS; p++)
    {
        if(!IsPlayerConnected(p)) continue;
        GetPlayerName(p, name, sizeof(name));
        if(strcmp(name, current, true) == 0) { online = p; break; }
    }
    if(online != INVALID_PLAYER_ID && SetPlayerName(online, original) != 1) return 0;
    if(online != INVALID_PLAYER_ID && GetPVarInt(online, "BR_LoggedIn"))
    {
        DOF2_SetInt(currentfile, "Novac", GetPlayerMoney(online));
        DOF2_SaveFile();
    }
    if(!DOF2_RenameFile(currentfile, originalfile))
    {
        if(online != INVALID_PLAYER_ID) SetPlayerName(online, current);
        return 0;
    }

    DOF2_SetInt(originalfile, "NameExpires", 0);
    DOF2_SaveFile();
    UpdateNameReferences(current, original);
    SetTempNameActive(slot, 0);
    SaveNameBackup(original, current, expires, 0);
    if(online != INVALID_PLAYER_ID)
        SendClientMessage(online, 0x00BFFFFF, "[IME]: Privremeno ime je isteklo. Vraceno vam je registrovano ime.");
    return 1;
}

public CheckTemporaryNames()
{
    new count = TempNameCount();
    for(new i = 0; i < count; i++)
    {
        new original[MAX_PLAYER_NAME], current[MAX_PLAYER_NAME], expires, active;
        if(!GetTempNameRecord(i, original, current, expires, active)) continue;
        if(active && expires > 0 && gettime() >= expires) RestoreTempNameSlot(i);
    }
    return 1;
}

public HandleTemporaryNameConnect(playerid, playername[])
{
    new count = TempNameCount();
    for(new i = count - 1; i >= 0; i--)
    {
        new original[MAX_PLAYER_NAME], current[MAX_PLAYER_NAME], expires, active;
        if(!GetTempNameRecord(i, original, current, expires, active)) continue;
        new matches_original = strcmp(playername, original, true) == 0;
        new matches_current = strcmp(playername, current, true) == 0;
        if(!matches_original && !matches_current) continue;

        if(active && expires > 0 && gettime() >= expires)
        {
            if(!RestoreTempNameSlot(i) && matches_original)
            {
                SendClientMessage(playerid, 0xFF0000FF, "[IME]: Nalog trenutno ne moze vratiti staro ime. Kontaktirajte administratora.");
                SetTimerEx("KickPlayerDelayed", 500, false, "i", playerid);
                return 0;
            }
            GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
            return 1;
        }
        if(active && matches_original)
        {
            new message[128];
            format(message, sizeof(message), "[IME]: Privremeno ime vam je %s. Prijavite se pod tim imenom.", current);
            SendClientMessage(playerid, 0xFF0000FF, message);
            SetTimerEx("KickPlayerDelayed", 500, false, "i", playerid);
            return 0;
        }
        if(!active && matches_current)
        {
            new accountfile[128];
            format(accountfile, sizeof(accountfile), "Korisnici/%s.ini", original);
            if(!DOF2_FileExists(accountfile) || SetPlayerName(playerid, original) != 1)
            {
                SendClientMessage(playerid, 0xFF0000FF, "[IME]: Prijavite se sa registrovanim imenom.");
                SetTimerEx("KickPlayerDelayed", 500, false, "i", playerid);
                return 0;
            }
            GetPlayerName(playerid, playername, MAX_PLAYER_NAME);
        }
        return 1;
    }
    return 1;
}

CMD:name(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid))return 0;
    new id;
        if(sscanf(params,"u",id)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /name [ID/Ime]");
        if(id==playerid)return SendClientMessage(playerid,0xFF7777FF,"Ne mozete kikovati sami sebe.");
        SendClientMessage(id,0xFF7777FF,"Vase ime nije u skladu sa pravilima servera. Promijenite ime prije ponovnog ulaska.");
        new n[MAX_PLAYER_NAME],m[144];
        GetPlayerName(id,n,sizeof(n));
        format(m,sizeof(m),"[ADMIN]: Igrac %s je kikovan zbog neprikladnog imena.",n);
        SendClientMessageToAll(0xFA8072FF,m);
        SetTimerEx("IzvrsiKick",700,false,"i",id);
        return 1;
        
}
CMD:specname(playerid, params[])
{
    new adminname[MAX_PLAYER_NAME], adminfile[128];
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(adminfile, sizeof(adminfile), "Korisnici/%s.ini", adminname);
    new adminlevel = DOF2_FileExists(adminfile) ? DOF2_GetInt(adminfile, "Admin") : 0;
    if(adminlevel < 2 && !IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Ovu komandu mogu koristiti Admin rank 2 i visi rankovi.");

    new targetid, days, desired[MAX_PLAYER_NAME];
    if(sscanf(params, "us[24]d", targetid, desired, days))
        return SendClientMessage(playerid, 0x00BFFFFF, "Koristenje: /specname [ID/Ime] [NovoIme] [Broj dana]");
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Igrac nije online.");
    if(days < 1 || days > 365)
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Broj dana mora biti od 1 do 365.");

    if(!GetPVarInt(targetid, "BR_LoggedIn"))
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Sacekajte da se igrac prijavi na nalog.");

    new oldcurrent[MAX_PLAYER_NAME], original[MAX_PLAYER_NAME];
    GetPlayerName(targetid, oldcurrent, sizeof(oldcurrent));
    new length = strlen(desired);
    if(length < 3 || length > 20)
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Ime mora imati 3-20 znakova radi ponovnog ulaska na SA-MP server.");
    for(new i = 0; i < length; i++)
    {
        if(!((desired[i] >= 'A' && desired[i] <= 'Z') || (desired[i] >= 'a' && desired[i] <= 'z') ||
            (desired[i] >= '0' && desired[i] <= '9') || desired[i] == '[' || desired[i] == ']' ||
            desired[i] == '(' || desired[i] == ')' || desired[i] == '$' || desired[i] == '@' ||
            desired[i] == '.' || desired[i] == '_' || desired[i] == '='))
            return SendClientMessage(playerid, 0xFF0000FF, "[IME]: SA-MP ne podrzava taj znak. Dozvoljeni su slova, brojevi i []()$@._=.");
    }

    new oldfile[128], newfile[128];
    format(oldfile, sizeof(oldfile), "Korisnici/%s.ini", oldcurrent);
    format(newfile, sizeof(newfile), "Korisnici/%s.ini", desired);
    if(!DOF2_FileExists(oldfile))
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Nalog igraca nije pronaden.");
    new same_name = strcmp(oldcurrent, desired, true) == 0;
    if(!same_name && DOF2_FileExists(newfile))
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Kratko ime vec koristi drugi nalog.");

    new name[MAX_PLAYER_NAME];
    for(new p = 0; p < MAX_PLAYERS; p++)
    {
        if(!IsPlayerConnected(p) || p == targetid) continue;
        GetPlayerName(p, name, sizeof(name));
        if(strcmp(name, desired, true) == 0)
            return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Kratko ime vec koristi drugi igrac.");
    }

    if(!DOF2_FileExists(TEMP_NAME_REGISTRY)) DOF2_CreateFile(TEMP_NAME_REGISTRY);
    if(!DOF2_FileExists(TEMP_NAME_REGISTRY))
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Ne mogu otvoriti evidenciju privremenih imena.");

    new count = TempNameCount(), slot = count, active_slot = -1;
    for(new i = 0; i < count; i++)
    {
        new old[MAX_PLAYER_NAME], shortname[MAX_PLAYER_NAME], expires, active;
        if(!GetTempNameRecord(i, old, shortname, expires, active)) continue;
        if(active && strcmp(shortname, oldcurrent, true) == 0)
        {
            if(active_slot != -1)
                return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Dupla evidencija imena. Kontaktirajte administratora.");
            active_slot = i;
            format(original, sizeof(original), "%s", old);
        }
    }
    if(active_slot != -1) slot = active_slot;
    else
    {
        if(strfind(oldcurrent, "_") < 0)
            return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Igrac nema registrovano RP ime.");
        format(original, sizeof(original), "%s", oldcurrent);
    }
    if(active_slot != -1 && strcmp(desired, original, true) == 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: To je registrovano ime igraca; ono se vraca po isteku.");
    for(new i = 0; i < count; i++)
    {
        new old[MAX_PLAYER_NAME], shortname[MAX_PLAYER_NAME], expires, active;
        if(!GetTempNameRecord(i, old, shortname, expires, active)) continue;
        if(i != active_slot && strcmp(shortname, desired, true) == 0 && strcmp(old, original, true) != 0)
            return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Kratko ime je rezervisano za drugi nalog.");
        if(i != active_slot && active && (strcmp(old, original, true) == 0 || strcmp(shortname, desired, true) == 0))
            return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Evidencija imena je vec aktivna.");
        if(active_slot == -1 && !active && strcmp(old, original, true) == 0) slot = i;
    }
    if(slot >= MAX_TEMP_NAME_RECORDS)
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Evidencija privremenih imena je puna.");

    new originalfile[128];
    format(originalfile, sizeof(originalfile), "Korisnici/%s.ini", original);
    if(active_slot != -1 && DOF2_FileExists(originalfile))
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Stari nalog ima dupli fajl. Kontaktirajte administratora.");

    new backupfile[128];
    format(backupfile, sizeof(backupfile), "%s/%s.ini", TEMP_NAME_BACKUP_DIR, original);
    if(!DOF2_FileExists(backupfile) && !DOF2_CreateFile(backupfile))
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Ne mogu napraviti backup starog imena.");

    DOF2_SetInt(oldfile, "Novac", GetPlayerMoney(targetid));
    DOF2_SaveFile();
    if(!same_name && SetPlayerName(targetid, desired) != 1)
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Promjena imena u igri nije uspjela.");
    if(!same_name && !DOF2_RenameFile(oldfile, newfile))
    {
        SetPlayerName(targetid, oldcurrent);
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Promjena fajla naloga nije uspjela.");
    }

    new expires = gettime() + days * 86400, key[48];
    DOF2_SetString(newfile, "NameOriginal", original);
    DOF2_SetInt(newfile, "NameExpires", expires);
    DOF2_SaveFile();
    if(!same_name) UpdateNameReferences(oldcurrent, desired);

    TempNameKey(key, sizeof(key), slot, "Original"); DOF2_SetString(TEMP_NAME_REGISTRY, key, original);
    TempNameKey(key, sizeof(key), slot, "Current"); DOF2_SetString(TEMP_NAME_REGISTRY, key, desired);
    TempNameKey(key, sizeof(key), slot, "Expires"); DOF2_SetInt(TEMP_NAME_REGISTRY, key, expires);
    TempNameKey(key, sizeof(key), slot, "Active"); DOF2_SetInt(TEMP_NAME_REGISTRY, key, 1);
    if(slot == count) DOF2_SetInt(TEMP_NAME_REGISTRY, "Count", count + 1);
    DOF2_SaveFile();
    SaveNameBackup(original, desired, expires, 1);

    new message[160];
    format(message, sizeof(message), "[IME]: Vase ime je sada %s na %d dana. Pod ovim imenom se prijavite sljedeci put.", desired, days);
    SendClientMessage(targetid, 0x00BFFFFF, message);
    format(message, sizeof(message), "[IME]: Ime %s je promijenjeno u %s na %d dana.", oldcurrent, desired, days);
    SendClientMessage(playerid, 0x00BFFFFF, message);
    return 1;
}

