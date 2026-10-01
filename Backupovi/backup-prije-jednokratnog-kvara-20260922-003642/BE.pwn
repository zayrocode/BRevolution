#include <Vozila>
#include <map-zones>
#include <Mape>
#include <BankaMapa>
#include <zcmd>
#define FILTERSCRIPT
#include <a_samp>
#include <dof2>
#include <streamer> // DODAJ OVO OVDJE

#pragma unused DOF2_Exit
#pragma tabsize 4
#pragma dynamic 65536


// --- DEFINICIJE ---
#define PLAVA_BOJA     0x9EC7E0FF
#define PLAVA_LINIJA   0x0042FFFF
#define ZUTA_BOJA      0xF9A602FF
#define BELA_BOJA      0xFFFFFFFF
#define SSCANF_NO_NICE_FEATURES
#include <sscanf2>

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
#define DIALOG_INVENTORY 555
#define DIALOG_MARKET_SIM 150      // Možeš staviti bilo koji broj koji se ne koristi
#define DIALOG_MARKET_HRANA 151
#define MAX_ZLATARE 10 // Umjesto 10 stavi onoliko zlatara koliko maksimalno imaš na serveru
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
#define MAX_TRAFIKA 50 // Možeš staviti koliki god maksimalan broj trafika želiš
#define DIALOG_TRAFIKA         100 // Možeš staviti bilo koji slobodan broj koji se ne poklapa sa drugim
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
// Dodaj ovo na vrh skripte (gdje definišeš ostale globalne varijable)
new LastOglasTick;
new PlayerSat[MAX_PLAYERS];
new IgracKrediti[MAX_PLAYERS];
new HappyHourMultiplier = 1;
#define MEDICAL_TREATMENT_PRICE 500
#define STATS_SETTINGS_FILE "BalkanRP/StatsSettings.ini"
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
new BankLaserLastCheck[MAX_PLAYERS];
new BankLaserLastAlert[MAX_PLAYERS];
new bool:BankLaserPrevValid[MAX_PLAYERS];
new Float:BankLaserPrevX[MAX_PLAYERS], Float:BankLaserPrevY[MAX_PLAYERS], Float:BankLaserPrevZ[MAX_PLAYERS];

new PlayerOrg[MAX_PLAYERS];
new bool:IsHealing[MAX_PLAYERS];
new PlayerCurrentSkin[MAX_PLAYERS];



// HUD: zajednicki dijelovi se prave jednom, podaci posebno za svakog igraca.
// Elementi HUD-a direktno iz korisnikovog DTD.pwn exporta.
new Text:TD_DTD[63];
new PlayerText:TD_Vozilo[MAX_PLAYERS][12];
new bool:VoziloHudShown[MAX_PLAYERS];
new bool:VehicleHudTruckLayout[MAX_PLAYERS];
new bool:VehicleHudInitialized[MAX_VEHICLES], bool:VehicleHudOutOfFuel[MAX_VEHICLES];
new Float:VehicleHudFuel[MAX_VEHICLES], Float:VehicleHudKm[MAX_VEHICLES];
new Float:VehicleHudLastX[MAX_VEHICLES], Float:VehicleHudLastY[MAX_VEHICLES], Float:VehicleHudLastZ[MAX_VEHICLES];
new bool:VehicleHudLastPosValid[MAX_VEHICLES];
new VehicleHudLastSpeed[MAX_PLAYERS];
new VehicleHudNextStartTry[MAX_VEHICLES], VehicleHudNextStallAt[MAX_VEHICLES];
new bool:VehicleHudBrokenNotice[MAX_VEHICLES], bool:VehicleHudStalled[MAX_VEHICLES];
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
new bool:JuniorFrozen[MAX_PLAYERS], bool:JuniorSpectating[MAX_PLAYERS];
new Float:JuniorSpecX[MAX_PLAYERS], Float:JuniorSpecY[MAX_PLAYERS], Float:JuniorSpecZ[MAX_PLAYERS];
new JuniorSpecInterior[MAX_PLAYERS], JuniorSpecWorld[MAX_PLAYERS];
new bool:JuniorGlobalChatLocked, bool:JuniorAdsMuted, bool:JuniorAskMuted, bool:JuniorReportsMuted;
new bool:JuniorEventActive;
new Float:JuniorEventX, Float:JuniorEventY, Float:JuniorEventZ;
new JuniorEventInterior, JuniorEventWorld;
new Text3D:HelperLabel[MAX_PLAYERS] = {Text3D:INVALID_3DTEXT_ID, ...};
// Pamcenje da li igrac radi turu i na kom je koraku
new IsDoingPosta[MAX_PLAYERS];
new PostarStep[MAX_PLAYERS];


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
#define MAX_SLOBODNIH_OBJEKATA 100 // Maksimum koliko ih možeš imati

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
#define MAX_TRAFIKE 50 // Možeš promijeniti po želji

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

#define MAX_MARKETA 50 // Možeš promijeniti na koliko god marketâ želiš

enum MarketEnum
{
    mOwned,
    mOwner[MAX_PLAYER_NAME],
    mNaziv[32],
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
    pKuca, // <--- Dodajte ovo ovdje!
    pBizz, // <--- DODAJ OVO OVDJE
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
    new PlayerText:td = CreatePlayerTextDraw(playerid, 320.0, 420.0, "RENT: 00:00 | /unrent");
    PlayerTextDrawAlignment(playerid, td, 2);
    PlayerTextDrawFont(playerid, td, 1);
    PlayerTextDrawLetterSize(playerid, td, 0.35, 1.3);
    PlayerTextDrawColor(playerid, td, 0xFFFFFFFF);
    PlayerTextDrawSetOutline(playerid, td, 1);
    PlayerTextDrawBackgroundColor(playerid, td, 0x000000AA);
    return td;
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

public OnGameModeInit()
{
    // Pokrece tajmer na svakih 180000 milisekundi (što je tacno 3 minuta)
	// Možeš promeniti broj ukoliko želiš da gladovanje ide brže ili sporije
	SetTimer("GladSystemTimer", 180000, true);
    SetTimer("TajmerZaMinute", 60000, true); // 60000 ms = 1 minuta
    SetTimer("ServerTipsTimer", 300000, true);
    SetTimer("CheckTemporaryNames", 60000, true);
    SetTimer("RentTick", 1000, true);
    SetTimer("UpdateLocationDisplays", 2000, true);
    SetTimer("UpdateVehicleHud", 500, true);
    SetTimer("UpdateVehicleSpeed", 150, true);
    SetTimer("JuniorAdminTick", 1000, true);
    if(DOF2_FileExists(STATS_SETTINGS_FILE))
    {
        HappyHourMultiplier = DOF2_GetInt(STATS_SETTINGS_FILE, "HappyHourMultiplier");
        if(HappyHourMultiplier != 2 && HappyHourMultiplier != 4 && HappyHourMultiplier != 8)
            HappyHourMultiplier = 1;
    }
    AddPlayerClass(0, 1685.8652, -2331.2102, 13.5469, 90.2917, 0, 0, 0, 0, 0, 0);
    InitRevolutionHud();
    UpdateHudTip(random(29));
    SetGameModeText("Balkan Revolution RP");
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF); // Bez kvadratica igraca na radaru/mapi.
    EnableStuntBonusForAll(0); // Bez stunt bonusa i njihovih poruka.
    UcitajServerMape();     // Ucitava objekte/mape iz Mape.inc
    UcitajBankuMapu();      // Banka iz BANKA-FINITO-HAHAH-1.txt
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
    CreateDynamic3DTextLabel("{33CCFF}BANKA{FFFFFF}\nDa udjete u Banku pritisnite F", 0xFFFFFFFF, 1462.90759277, -1022.80725097, 24.53310317, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    CreateDynamic3DTextLabel("{33CCFF}Izlaz iz Banke{FFFFFF}\nPritisnite F", 0xFFFFFFFF, 153.79109191, 1702.71630859, -0.15856175, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
    UcitajVozilaServera();  // Ucitava vozila i motore iz Vozila.inc
    UcitajOglase();
    UcitajZlataru(); // <--- OVDJE DODAJ Ovu liniju!
    UcitajTrafike();
    UcitajSlobodneObjekte();
    UcitajLabele();
    LoadHouses(); // <--- DODAJ OVU LINIJU OVDE!
    InitParkingServisVozila();
    CheckTemporaryNames();
    
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
            MarketInfo[m][mOwned] = DOF2_GetInt(file, "Owned");
            format(MarketInfo[m][mOwner], MAX_PLAYER_NAME, "%s", DOF2_GetString(file, "Owner"));
            format(MarketInfo[m][mNaziv], 32, "%s", DOF2_GetString(file, "Naziv"));

            MarketInfo[m][mEntranceX] = DOF2_GetFloat(file, "EntranceX");
            MarketInfo[m][mEntranceY] = DOF2_GetFloat(file, "EntranceY");
            MarketInfo[m][mEntranceZ] = DOF2_GetFloat(file, "EntranceZ");

            MarketInfo[m][mExitX] = DOF2_GetFloat(file, "ExitX");
            MarketInfo[m][mExitY] = DOF2_GetFloat(file, "ExitY");
            MarketInfo[m][mExitZ] = DOF2_GetFloat(file, "ExitZ");

            MarketInfo[m][mInterior] = DOF2_GetInt(file, "Interior");
            MarketInfo[m][mCena] = DOF2_GetInt(file, "Cena");
            MarketInfo[m][mLevel] = DOF2_GetInt(file, "Level");
            MarketInfo[m][mUlaznaCena] = DOF2_GetInt(file, "UlaznaCena");
            MarketInfo[m][mBudzet] = DOF2_GetInt(file, "Budzet");
            MarketInfo[m][mProizvodi] = DOF2_GetInt(file, "Proizvodi");
            MarketInfo[m][mCenaProizvoda] = DOF2_GetInt(file, "CenaProizvoda");

            // Automatsko kreiranje 3D teksta za svaki ucitani market iz fajla
            new labelstring[128];
            format(labelstring, sizeof(labelstring), "{00FF00}24/7 Market\n{FFFFFF}Budžet: {FFCC00}$%d\n{FFFFFF}Kucaj: /kupi", MarketInfo[m][mBudzet]);
            MarketInfo[m][mLabel] = CreateDynamic3DTextLabel(labelstring, 0xFFFFFFFF, MarketInfo[m][mEntranceX], MarketInfo[m][mEntranceY], MarketInfo[m][mEntranceZ] + 0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, MarketInfo[m][mInterior]);

            UpdateMarketCP(m);
        }
    }
    // ---------------------------------------------------

    // --- DODANE LOKACIJE ZA TELEFON I GIGATRON ---

    // 1. Mjesto za kupovinu telefona
    Create3DTextLabel("Kupi telefon\nKucaj: /kupitelefon", 0x00BFFFFF, -537.5564, 2589.3081, 10.9875, 20.0, 0, 0);
    CreatePickup(1239, 23, -537.5564, 2589.3081, 10.9875, 0);

    // 2. Unutrašnjost / Izlaz iz Gigatrona
    Create3DTextLabel("Pritisni 'F' za izlazak iz Gigatrona", 0xFFFF00FF, -540.8716, 2596.0989, 10.9875, 20.0, 0, 0);
    CreatePickup(1318, 23, -540.8716, 2596.0989, 10.9875, 0);

    // 3. Glavni ulaz u Gigatron
    Create3DTextLabel("Pritisni 'F' za ulazak u Gigatron", 0xFFFF00FF, 1412.1534, -1700.0010, 13.5395, 20.0, 0, 0);
    CreatePickup(1318, 23, 1412.1534, -1700.0010, 13.5395, 0);

    // Kreiranje 3D Text Labele na tvojim koordinatama (-526.6230, 2595.7686, 10.9875)
    Create3DTextLabel("{00BFFF}Gigatron / Prodaja Telefona\n{FFFFFF}Kucaj {FF0000}/kupibrojtel {FFFFFF}da kupite broj telefona!", 0x00BFFFFFFF, -526.6230, 2595.7686, 10.9875, 20.0, 0, 0);

    AddStaticPickup(1239, 2, -526.6230, 2595.7686, 10.9875, 0);
    Create3DTextLabel("{00BFFF}Gigatron / Kupovina Slušalica\n{FFFFFF}Kucaj {FF0000}/kupislusalice {FFFFFF}da kupite slušalice!", 0x00BFFFFFFF, -530.8458, 2603.3523, 10.9875, 20.0, 0, 0);

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
	
	// Ulaz u Opštinu (Ispred zgrade)
    CreatePickup(1239, 1, 1481.0885, -1771.9858, 18.7958, 0);
    Create3DTextLabel("Gradska Opština\n{FFFFFF}Da udete u gradsku opštinu pritisnite {FFFF00}'F'", 0x00BFFFFF, 1481.0885, -1771.9858, 18.7958 + 0.5, 15.0, 0, 0);

    // Izlaz iz Opštine (Unutar enterijera ID: 3)
    CreatePickup(1239, 1, 386.52, 173.63, 1008.38, 0);
    Create3DTextLabel("Izlaz\n{FFFFFF}Pritisnite {FFFF00}'F' {FFFFFF}da izadete", 0x00BFFFFF, 386.52, 173.63, 1008.38 + 0.5, 15.0, 0, 0);

	// Ubaci ovo unutar public OnGameModeInit()
	Create3DTextLabel("{FFFF00}Parking Servis\n{FFFFFF}Da preuzmete vozilo kucajte {00FF00}/preuzmivozilo", 0xFFFFFFFF, 1019.4164, -927.8874, 42.1797, 20.0, 0, 0);
	
	// 3D Text spolja na ulazu u policiju
	Create3DTextLabel("Beogradska Policija\nPritisnite 'F' da udjete", 0x33CCFFFF, 1555.1368, -1675.6598, 16.1953, 20.0, 0, 0);

	// 3D Text unutra na izlazu iz policije
	Create3DTextLabel("Izlaz iz policije\nPritisnite 'F' da izadjete", 0x33CCFFFF, 246.66, 65.80, 1003.64, 20.0, 6, 0);
	
	
	// Kreiramo pickup za poštara (samo vizuelno, komanda radi preko koordinata)
    CreatePickup(1239, 23, 330.6513, -1509.8417, 36.0391, -1);
    Create3DTextLabel("Da se zaposlite kao postar\nKucajte /posao", 0xFFFFFFAA, 330.6513, -1509.8417, 36.0391, 15.0, 0, 1);
	
	// Ulaz spolja
	CreateDynamic3DTextLabel("Pritisni 'F' za ulazak u bolnicu", 0x00FF00FF, 1172.4083, -1323.3091, 15.4029, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	// Izlaz iz unutrašnjosti
	CreateDynamic3DTextLabel("Pritisni 'F' za izlazak iz bolnice", 0xFF0000FF, -23.7858, 1500.6514, -3.3132, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

    //UsePlayerPedAnims();
    DisableInteriorEnterExits();
    return 1;
}
public OnPlayerConnect(playerid)
{
    BankMoneyBag[playerid] = false;
    JetpackDropGuardUntil[playerid] = 0;
    SetPVarInt(playerid, "BR_LoggedIn", 0);
    // Ucitaj animacije pljacke prije nego sto igrac dodje do banke.
    ApplyAnimation(playerid, "BOMBER", "null", 4.1, 0, 0, 0, 0, 0);

    WantedPoints[playerid] = 0;
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
    JuniorJailedUntil[playerid] = 0;
    JuniorFrozen[playerid] = false;
    JuniorSpectating[playerid] = false;
    RentPlayerVehicle[playerid] = 0;
    RentPendingVehicle[playerid] = 0;
    RentExpiresAt[playerid] = 0;
    RentTextDraw[playerid] = CreateRentTextDraw(playerid);
    // --- PROVJERA IMENA (Ime_Prezime) ---
    new playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
    if(!HandleTemporaryNameConnect(playerid, playername)) return 0;
    SetPlayerColor(playerid, 0xFFFFFFFF);
    UkloniMapeObjekte(playerid); // Briše objekte za igraca

    if(!IsValidRPName(playername))
    {
        new file_check[128];
        format(file_check, sizeof(file_check), "Korisnici/%s.ini", playername);

        // Ako nema donje crte I NEMA njegovog fajla u folderu -> KIKUJ GA!
        if(!DOF2_FileExists(file_check))
        {
            SendClientMessage(playerid, 0xFF0000FF, "[SERVER]: Morate imati RP format imena (Ime_Prezime) da biste igrali!");
            SetTimerEx("KickPlayerDelayed", 500, false, "i", playerid); // Odloženi kik sprecava "Server closed the connection" pucanje
            return 0;
        }
        // Ako fajl POSTOJI (ti si mu ga kreirao/stavio), preskace kik i pušta ga unutra!
    }
    // ------------------------------------

    // Muzika pocinje cim igrac klikne na "Connect" i ude na server
    PlayAudioStreamForPlayer(playerid, "https://a7.asurahosting.com/listen/balkan_radio_hit/radio.mp3");
    IntroKorak[playerid] = 0;
    PlayerZlato[playerid] = 0;
    PlayerRespekti[playerid] = 0;
    PlayerMinute[playerid] = 0;

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
    return 1;
}

// Dodaj ovo negde na dno skripte da podrži odloženi kik bez pucanja konekcije:
forward KickPlayerDelayed(playerid);
public KickPlayerDelayed(playerid)
{
    Kick(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
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
    PlayerTextDrawDestroy(playerid, RentTextDraw[playerid]);
    ScriptJetpack[playerid] = false;
    // --- AUTOMATSKO SKIDANJE SA ADMIN DUŽNOSTI I SNIMANJE PODATAKA ---
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
        DOF2_SetInt(file, "Skin", GetPlayerSkin(playerid));
        DOF2_SaveFile();
    }
    // --------------------------------------------------------

    // Tvoji postojeci textdrawovi koji se brišu pri diskonekciji
    DestroyRevolutionPlayerHud(playerid);

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
    // Ako je igrac umro i nalazi se na lecenju u bolnici 5 sekundi (skin se ne mijenja)
    if(IsHealing[playerid])
    {
        // Bolnicka pozicija i skin su postavljeni prije respawna u OnPlayerDeath.
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);

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
        SetPlayerPos(playerid, 230.6200, 75.2964, 1005.0391);
        SetPlayerFacingAngle(playerid, 270.3857);
        SetPlayerInterior(playerid, 6);
        SetPlayerVirtualWorld(playerid, 0);
    }
    else if(orgid == 4)
    {
        SetPlayerPos(playerid, 1754.1577, -1903.0061, 13.5634);
        SetPlayerFacingAngle(playerid, 0.0);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
    }
    else if(orgid == 5)
    {
        SetPlayerPos(playerid, -13.7780, 1465.4548, -3.2142);
        SetPlayerFacingAngle(playerid, 3.1334);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
    }
    else if(orgid == 7)
    {
        SetPlayerPos(playerid, 1072.9264, -878.3057, 43.3932);
        SetPlayerFacingAngle(playerid, 0.0);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
    }
    else
    {
        SetPlayerPos(playerid, 1685.8652, -2331.2102, 13.5469);
        SetPlayerFacingAngle(playerid, 90.2917);
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
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
    switch(dialogid)
    {
        case DIALOG_AH:
        {
            return 1;
        }

        case DIALOG_RENT:
        {
            new vehicleid = RentPendingVehicle[playerid];
            RentPendingVehicle[playerid] = 0;
            if(!response) return 1;
            if(listitem < 0 || listitem > 2 || !IsRentVehicle(vehicleid) || GetVehicleModel(vehicleid) == 0)
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Vozilo vise nije dostupno.");
            if(RentPlayerVehicle[playerid])
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Vec imas iznajmljeno vozilo. Koristi /unrent.");
            if(RentVehicleOwner[vehicleid])
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Ovo vozilo je vec iznajmljeno.");
            if(!GetPVarInt(playerid, "BR_LoggedIn"))
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Prvo se prijavi na nalog.");

            new Float:x, Float:y, Float:z;
            GetVehiclePos(vehicleid, x, y, z);
            if(!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Previse si se udaljio od vozila.");

            new minutes, price;
            switch(listitem)
            {
                case 0: { minutes = 10; price = 200; }
                case 1: { minutes = 15; price = 300; }
                case 2: { minutes = 30; price = 600; }
            }
            if(GetPlayerMoney(playerid) < price)
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Nemas dovoljno RSD za iznajmljivanje.");

            RentVehicleOwner[vehicleid] = playerid + 1;
            RentPlayerVehicle[playerid] = vehicleid;
            RentExpiresAt[playerid] = gettime() + minutes * 60;
            if(!PutPlayerInVehicle(playerid, vehicleid, 0))
            {
                StopPlayerRent(playerid, false);
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Ulazak u vozilo nije uspio. Nista nije naplaceno.");
            }

            GivePlayerMoney(playerid, -price);
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
            // Pomoc se samo zatvara; nema pomjeranja niti novog spawna.
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
            ShowPlayerDialog(playerid, DIALOG_POL, DIALOG_STYLE_LIST, "Da li ste Muško ili Žensko?", "Muško\nŽensko", "U redu", "Odustani");
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
                        ShowPlayerDialog(playerid, DIALOG_ADMINKOD, DIALOG_STYLE_PASSWORD, "Admin Login Kod", "{FFFFFF}Unesite vaš tajni admin kod da biste potvrdili identitet:\n{FF0000}Napomena: Pogrešan kod vas automatski kickuje sa servera!", "Potvrdi", "Izlaz");
                        return 1;
                    }

                    new helper_lvl = DOF2_GetInt(file, "Helper");
                    if(helper_lvl > 0 && DOF2_IsSet(file, "HelperCode"))
                    {
                        ShowPlayerDialog(playerid, DIALOG_HELPERKOD, DIALOG_STYLE_PASSWORD, "Helper Login Kod", "{FFFFFF}Unesite vaš tajni helper kod da biste potvrdili identitet:\n{FF0000}Napomena: Pogrešan kod vas automatski kickuje sa servera!", "Potvrdi", "Izlaz");
                        return 1;
                    }

                    SendClientMessage(playerid, PLAVA_BOJA, "[Balkan Revolution]: Uspješno ste se ulogovali!");
                    SetPlayerScore(playerid, DOF2_GetInt(file, "Level"));
                    ResetPlayerMoney(playerid);
                    GivePlayerMoney(playerid, DOF2_GetInt(file, "Novac"));
                    PlayerZlato[playerid] = DOF2_GetInt(file, "Zlato");
                    IgracKrediti[playerid] = DOF2_GetInt(file, "Krediti");
                    UpdateZlatoTD(playerid);
                    UpdateBankaTD(playerid, DOF2_GetInt(file, "Banka"));
                    PlayerTextDrawShow(playerid, TD_Zlato[playerid]);
                    PlayerTextDrawShow(playerid, TD_Grad[playerid]);
                    PlayerTextDrawShow(playerid, TD_Lokacija[playerid]);
                    SetSpawnInfo(playerid, 0, 247, 1759.1915, -1898.1232, 13.5568, 0.0, 0, 0, 0, 0, 0, 0);
                    SpawnPlayer(playerid);
                    PrikaziPorukuDobrodoslice(playerid);
                    SetPVarInt(playerid, "BR_LoggedIn", 1);
                    SetTimerEx("JuniorApplyPenalties", 750, false, "i", playerid);
                    LoadWantedState(playerid);
                }
                else
                {
                    SendClientMessage(playerid, ZUTA_BOJA, "[Balkan Revolution]: Pogrešna lozinka!");
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
            SetPVarInt(playerid, "BR_LoggedIn", 1);
            SetTimerEx("JuniorApplyPenalties", 750, false, "i", playerid);
            LoadWantedState(playerid);
            PlayerZlato[playerid] = 0;
            PlayerRespekti[playerid] = 0;
            PlayerMinute[playerid] = 0;
            IgracKrediti[playerid] = 0;
            UpdateZlatoTD(playerid);
            UpdateBankaTD(playerid, 0);
            PlayerTextDrawShow(playerid, TD_Zlato[playerid]);
            PlayerTextDrawShow(playerid, TD_Grad[playerid]);
            PlayerTextDrawShow(playerid, TD_Lokacija[playerid]);
            SendClientMessage(playerid, PLAVA_BOJA, "[Balkan Revolution]: Uspješno ste se registrovali i dobili 5000 dinara!");
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
                SetPlayerAttachedObject(playerid, 0, 19036, 2, 0.12, 0.0, 0.0, 0.0, 80.0, 80.0);
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
                return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Nalog nije pronadjen.");
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
                    SendClientMessage(playerid, 0x00FF00FF, "[Balkan Revolution]: Uspješno ste unijeli admin kod. Dobrodošli nazad!");
                    SetPlayerScore(playerid, DOF2_GetInt(file, "Level"));
                    ResetPlayerMoney(playerid);
                    GivePlayerMoney(playerid, DOF2_GetInt(file, "Novac"));
                    PlayerZlato[playerid] = DOF2_GetInt(file, "Zlato");
                    IgracKrediti[playerid] = DOF2_GetInt(file, "Krediti");
                    UpdateZlatoTD(playerid);
                    UpdateBankaTD(playerid, DOF2_GetInt(file, "Banka"));
                    PlayerTextDrawShow(playerid, TD_Zlato[playerid]);
                    PlayerTextDrawShow(playerid, TD_Grad[playerid]);
                    PlayerTextDrawShow(playerid, TD_Lokacija[playerid]);
                    SetSpawnInfo(playerid, 0, 247, 1759.1915, -1898.1232, 13.5568, 0.0, 0, 0, 0, 0, 0, 0);
                    SpawnPlayer(playerid);
                    PrikaziPorukuDobrodoslice(playerid);
                    SetPVarInt(playerid, "BR_LoggedIn", 1);
                    SetTimerEx("JuniorApplyPenalties", 750, false, "i", playerid);
                    LoadWantedState(playerid);
                }
                else
                {
                    SendClientMessage(playerid, 0xFF0000FF, "[ANTICHETE/ADMIN]: Unijeli ste pogrešan admin kod! Izbaceni ste sa servera.");
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
                    SendClientMessage(playerid, 0x00FF00FF, "[Balkan Revolution]: Uspješno ste unijeli helper kod. Dobrodošli nazad!");
                    SetPlayerScore(playerid, DOF2_GetInt(file, "Level"));
                    ResetPlayerMoney(playerid);
                    GivePlayerMoney(playerid, DOF2_GetInt(file, "Novac"));
                    PlayerZlato[playerid] = DOF2_GetInt(file, "Zlato");
                    IgracKrediti[playerid] = DOF2_GetInt(file, "Krediti");
                    UpdateZlatoTD(playerid);
                    UpdateBankaTD(playerid, DOF2_GetInt(file, "Banka"));
                    PlayerTextDrawShow(playerid, TD_Zlato[playerid]);
                    PlayerTextDrawShow(playerid, TD_Grad[playerid]);
                    PlayerTextDrawShow(playerid, TD_Lokacija[playerid]);
                    SetSpawnInfo(playerid, 0, 247, 1759.1915, -1898.1232, 13.5568, 0.0, 0, 0, 0, 0, 0, 0);
                    SpawnPlayer(playerid);
                    PrikaziPorukuDobrodoslice(playerid);
                    SetPVarInt(playerid, "BR_LoggedIn", 1);
                    SetTimerEx("JuniorApplyPenalties", 750, false, "i", playerid);
                    LoadWantedState(playerid);
                }
                else
                {
                    SendClientMessage(playerid, 0xFF0000FF, "[ANTICHETE/HELPER]: Unijeli ste pogrešan helper kod! Izbaceni ste sa servera.");
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

            SendClientMessage(playerid, 0x00FF00FF, "Trafika: Uspješno ste kupili sok i osvježili se!");
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

            SendClientMessage(playerid, 0x00FF00FF, "Trafika: Uspješno ste pojeli proizvod!");
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

            SendClientMessage(playerid, 0x00FF00FF, "Trafika: Uspješno ste kupili kredite!");
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
            format(string, sizeof(string), "Uspješno ste kupili rucni sat: {FFFF00}%s {00BFFF}za {00AA00}$%d.", naziv_sata, cijena);
            SendClientMessage(playerid, 0x00BFFFFF, string);
            SendClientMessage(playerid, 0xFFFFFFFF, "Sada u svakom trenutku možete ukucati komandu {FFFF00}/time {FFFFFF}da vidite tacno vrijeme na ekranu.");
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
            format(poruka, sizeof(poruka), "[Balkan Revolution]: Uspješno ste kupili telefon %s za $%d!", TelLista[listitem][tNaziv], cijena);
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
                format(string, sizeof(string), "[Greška] {FFFFFF}Nemate dovoljno novca! Artikal košta $%d.", cijene_sim[listitem]);
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
                    format(tel_msg, sizeof(tel_msg), "{00FF00}[Telefon] {FFFFFF}Uspješno ste kupili SIM karticu. Vaš novi broj: %d", random_broj);
                    SendClientMessage(playerid, -1, tel_msg);
                }
                case 5: SendClientMessage(playerid, 0x00FF00FF, "[Market] {FFFFFF}Uspješno ste kupili i stavili sat na ruku!");
            }

            if(listitem != 1)
            {
                new string[128];
                format(string, sizeof(string), "[Market] {FFFFFF}Uspješno ste kupili {00FF00}%s {FFFFFF}za ${FFCC00}%d.", nazivi_sim[listitem], cijene_sim[listitem]);
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
                format(string, sizeof(string), "[Greška] {FFFFFF}Nemate dovoljno novca! Artikal košta $%d.", cijene_hrana[listitem]);
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
            format(string, sizeof(string), "[Market] {FFFFFF}Uspješno ste kupili {00FF00}10x %s {FFFFFF}za ${FFCC00}%d.", nazivi_hrana[listitem], cijene_hrana[listitem]);
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
    new vip = 0; // Ako budeš pravio VIP sistem kasnije

    // Pretvaramo broj admin ranka u tekst za poruku dobrodošlice
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

    // Ovdje sada pokazuje pravi admin rank umjesto levela
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
            SendClientMessage(playerid, PLAVA_BOJA, " Ovo je takodje centar zbivanja u Beogradu");
            SendClientMessage(playerid, PLAVA_BOJA, " Savet:Idite do opstine sto je pre moguce, uzmite posao i krenite sa zaradjivanjem novca,");
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
            SendClientMessage(playerid, PLAVA_BOJA, " Nemojte vredjati Policiju jer su oni tu da vas zastite od kriminalaca.");
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
            SendClientMessage(playerid, PLAVA_BOJA, " Kad-Tad ce vam se desiti da slucajno naidjete na nekog clana Mafije ili Bande.");
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
            SendClientMessage(playerid, PLAVA_BOJA, " Dodjite u auto skolu i polozite za neku od dozvola.");
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
            SendClientMessage(playerid, PLAVA_BOJA, " Ovo je mesto gde mozete ostaviti vas tesko zaradjeni novac.");
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
            SendClientMessage(playerid, PLAVA_BOJA, " Ovo je mesto za vas, ovde objavite sve sto zelite, oglas takodje mozete dati i na /smsad.");
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------------------------------------");
        }
        case 11: // BURGER SHOT
        {
            SetPlayerCameraPos(playerid, 1199.11, -920.55, 45.00);
            SetPlayerCameraLookAt(playerid, 1199.11, -920.55, 20.00);
            SendClientMessage(playerid, PLAVA_BOJA, "--------------------[ Burger shot ]--------------------");
            SendClientMessage(playerid, PLAVA_BOJA, " Ogladneli ste, zelite malo zabave/drustva ?.");
            SendClientMessage(playerid, PLAVA_BOJA, " Ovo je pravo mesto za vas, ovde mozete pojesti ukusne specijalitete spremljene od strane profesionalnih kuvara.");
            SendClientMessage(playerid, PLAVA_BOJA, " Dodjite sa drustvom i provedite se odlicno, jer to moze samo u Burgu.");
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
CMD:mp3(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    // Provjera da li fajl postoji i da li ima kljuc "Slusalice"
    if(!DOF2_FileExists(file) || !DOF2_IsSet(file, "Slusalice") || DOF2_GetInt(file, "Slusalice") == 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Nemaš slušalice! Moraš ih kupiti komandom {FFFFFF}/kupislusalice{FF0000}.");
        return 1;
    }

    // Stavljanje slušalica na glavu (Slot 0, Model ID 19424, Kost 2 = Glava)
    SetPlayerAttachedObject(playerid, 0, 19424, 2, 0.08, 0.0, 0.0, 0.0, 90.0, -90.0, 1.0, 1.0, 1.0);

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
        return SendClientMessage(playerid, 0xFF7777FF, "[STATS]: Vas korisnicki fajl nije pronadjen.");

    new level = DOF2_GetInt(file, "Level");
    if(level < 1) level = 1;
    new respects = DOF2_GetInt(file, "Respekti");
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
        default: format(jobName, sizeof(jobName), "Nezaposlen");
    }

    new sickUntil = DOF2_GetInt(file, "BolestanDo");
    new healthStatus[40], spawnHealth;
    if(sickUntil > gettime())
    {
        spawnHealth = 50;
        format(healthStatus, sizeof(healthStatus), "Bolestan jos %d min", (sickUntil - gettime() + 59) / 60);
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
    format(line, sizeof(line), "{00BFFF}Level: {FFFFFF}[%d]\n{00BFFF}Respekti: {FFFFFF}[%d/%d]\n", level, respects, needed);
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
    format(line, sizeof(line), "{00BFFF}Neobradjena Droga: {FFFFFF}[%d]  {00BFFF}Droga: {FFFFFF}[%d]\n{00BFFF}Vrecice Semena: {FFFFFF}[%d]  {00BFFF}Materijali: {FFFFFF}[%d]\n", DOF2_GetInt(file, "NeobradjenaDroga"), DOF2_GetInt(file, "Droga"), DOF2_GetInt(file, "VreciceSemena"), DOF2_GetInt(file, "Materijali"));
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
            // Donja crta ne smije biti na pocetku, kraju, niti ih smije biti više od jedne
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

stock UpdateWantedHint(playerid)
{
    if(WantedPoints[playerid] <= 0)
    {
        PlayerTextDrawHide(playerid, TD_WantedHint[playerid]);
        return 1;
    }
    new label[80];
    format(label, sizeof(label), "IMATE %d WANTED LEVELA  /DOSIJE", WantedPoints[playerid]);
    PlayerTextDrawSetString(playerid, TD_WantedHint[playerid], label);
    PlayerTextDrawShow(playerid, TD_WantedHint[playerid]);
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
    // Cetiri vidljiva snopa idu izmedju parova objekata kroz cijeli hodnik.
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
            SendClientMessage(robber, 0x66FF66FF, "[BANKA]: Uspjesno ste uzeli novac. Ruksak je na ledjima; banka je zakljucana narednih 30 minuta.");
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
        return SendClientMessage(playerid, 0xFF7777FF, "[BANKA]: Dodjite do mjesta za hakovanje u banci.");
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
    strcat(text, "mnoga RolePlay pravila, ali kod nas vaze samo ona koja su ovdje napisana. To znaci da mozete biti\n", sizeof(text));
    strcat(text, "kaznjeni samo za pravila koja stoje u ovoj listi. Takodje postoje jos neka pravila koja se kaznjavaju, ali ne\n", sizeof(text));
    strcat(text, "stoje na ovoj listi jer server sam obavlja taj posao. Za odredjena pravila na ovoj listi navedeno je za sta se\n", sizeof(text));
    strcat(text, "tacno kaznjava. Sva RolePlay pravila mozete pogledati na nasem forumu. Pravila su obavezna za testiranje\n", sizeof(text));
    strcat(text, "u Administraciju, a koriste ih i drzavne organizacije.\n\n", sizeof(text));

    strcat(text, "{FF3333}DeathMatching (DM) - Ubijanje ljudi bez ikakvog RP razloga. {75B9E6}Kaznjava se: Ubistvo civila, ubistvo clana\n", sizeof(text));
    strcat(text, "drzavne organizacije osim Policije/Zandarmerije i ubistvo radnika dok radi legalan posao. Igrac koga\n", sizeof(text));
    strcat(text, "prijavite ce biti kaznjen samo ukoliko ga vi ne napadnete! {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}BugAbuse (BA) - Iskoristavanje poznatih i nepoznatih BUGova na skripti. {66CC66}Kazna: Prison 1h\n", sizeof(text));
    strcat(text, "{FF3333}Powergaming (PG) - Radnja koju je nemoguce izvesti u stvarnom zivotu. {75B9E6}Kaznjava se: Ako udjete\n", sizeof(text));
    strcat(text, "na G preko zida, ukoliko vas Policajac /cuff ili /pu preko zida ili u vazduhu bez koriscenja /me i /do\n", sizeof(text));
    strcat(text, "komandi. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}SpawnKill (SK) - Ubijanje igraca na mjestu spawn-a. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Non RolePlay (NonRP) - Ometanje RP radnji koje izvrsavaju drugi igraci. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Logging To Avoid (LTA) - Napustanje igrice da biste nesto izbjegli. {66CC66}Kazna: Prison 1 - 5h\n", sizeof(text));
    strcat(text, "{FF3333}Player vs Player (PvP) - Odnos izmedju igraca na serveru. {75B9E6}Kaznjava se: Izivljavanje nad drugim\n", sizeof(text));
    strcat(text, "igracima, tjeranje sa servera, ponizavanje i slicno. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Player vs Environment (PvE) - Odnos igraca sa svojom okolinom. {75B9E6}Kaznjava se: Konstantno udaranje\n", sizeof(text));
    strcat(text, "vozilom (Dune, Autobus, Sleper, Kamion). {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Drive By (DB) - Odnosi se na stetu nanesenu drugom igracu iz vozila. {75B9E6}Kaznjava se: Zabranjeno je\n", sizeof(text));
    strcat(text, "parkirati se na druge igrace i cekati njihovu smrt, te ubijanje elisom helikoptera. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Fake Account (FA) - Pravljenje novih naloga radi ostvarivanja prednosti, a vec posjedujete nalog\n", sizeof(text));
    strcat(text, "{75B9E6}(ukoliko vam je potreban novi nalog, obavezno se obratite na FB stranicu). {66CC66}Kazna: Cenzura\n", sizeof(text));
    strcat(text, "{FF3333}VIP Abusing (VA) - Zloupotreba komandi VIP-a. {75B9E6}Kaznjava se: Spasavanje igraca sa Wanted Levelom\n", sizeof(text));
    strcat(text, "tako sto ga negdje portate. {66CC66}Kazna: 30 min\n", sizeof(text));
    strcat(text, "{FF3333}Forum/Zalba. {66CC66}Kazna: Po pravilniku\n", sizeof(text));
    strcat(text, "{FF3333}Stablo - Omalovazavanje administracije i nepostovanje stabla > /stablo. {66CC66}Kazna: Prison 1 - 5h\n", sizeof(text));
    strcat(text, "{FF3333}Nacionalizam. {66CC66}Kazna: Ludnica 5 - 50h\n", sizeof(text));
    strcat(text, "{FF3333}Vrijedjanje. {66CC66}Kazna: Ludnica 1 - 24h + mute 1 - 24h\n", sizeof(text));
    strcat(text, "{FF3333}Spam - Ponavljanje istih recenica ili rijeci vise puta zaredom, na bilo kom chatu. Vazi i za OOC\n", sizeof(text));
    strcat(text, "chatove. {66CC66}Kazna: Slap, Kick ili Lavirint\n", sizeof(text));
    strcat(text, "{FF3333}Invalid AD - Pisanje gluposti na oglasima i stvari koje krse pravilo > /mg.\n", sizeof(text));
    strcat(text, "{66CC66}Kazna: 30 - 60 min + mute 1 - 3h\n", sizeof(text));
    strcat(text, "{FF3333}Cit - Koriscenje bilo kakvih citova/modova koji daju prednost u odnosu na ostale igrace.\n", sizeof(text));
    strcat(text, "{66CC66}Kazna: Robija, a ukoliko igrac i dalje koristi cit slijedi cenzura\n", sizeof(text));
    strcat(text, "{FF3333}Reklamiranje bilo kakvih zajednica, sajtova... {66CC66}Kazna: Robija\n", sizeof(text));
    strcat(text, "{FF3333}Zabranjeno zapocinjanje price o nekom drugom serveru. {66CC66}Kazna: Rengban\n", sizeof(text));
    strcat(text, "{FF3333}Zabranjene su imovinske prevare, provale na tudje naloge i slicno. {75B9E6}Kod kupovine/prodaje\n", sizeof(text));
    strcat(text, "obavezno zovite helpera; ako nema helpera, a dodje do prevare, obavezno slikajte FB.\n", sizeof(text));
    strcat(text, "{66CC66}Kazna: Resava vrhovna komanda\n", sizeof(text));
    strcat(text, "{FF3333}Invalid /askq - Glupiranje na /askq i postavljanje glupih pitanja. {66CC66}Kazna: Lavirint\n", sizeof(text));
    strcat(text, "{FF3333}Voznja bicikla sa WL-om i ulaz u kucu sa healthom i armorom tokom akcije. {66CC66}Kazna: 30 min", sizeof(text));

    ShowPlayerDialog(playerid, DIALOG_PRAVILA, DIALOG_STYLE_MSGBOX, "Pravila", text, "Ok", "");
    return 1;
}
CMD:help(playerid, params[])
{
    new string[1500];

    // Sastavljanje teksta sa bojama (Plava za komande, bijela za opis)
    strcat(string, "{00C0FF}/pravila{FFFFFF} - pomoc u vezi pravila servera\n");
    strcat(string, "{00C0FF}/jobhelp{FFFFFF} - pomoc u vezi komandi za Vas posao\n");
    strcat(string, "{00C0FF}/orghelp{FFFFFF} - pomoc u vezi komandi za Vasu organizaciju\n");
    strcat(string, "{00C0FF}/househelp{FFFFFF} - pomoc u vezi komandi za Vasu kucu\n");
    strcat(string, "{00C0FF}/bizhelp{FFFFFF} - pomoc u vezi komandi za Vas biznis\n");
    strcat(string, "{00C0FF}/vehhelp{FFFFFF} - pomoc u vezi komandi za Vas automobil\n");
    strcat(string, "{00C0FF}/renthousehelp{FFFFFF} - pomoc u vezi komandi za rentanje kuce\n");
    strcat(string, "{00C0FF}/rentvehiclehelp{FFFFFF} - pomoc u vezi komandi za rentanje vozila\n");
    strcat(string, "{00C0FF}/fill{FFFFFF} - natoci gorivo dok vozilo miruje i motor je ugasen\n");
    strcat(string, "{00C0FF}/leaderhelp{FFFFFF} - pomoc u vezi komandi za lidere\n");
    strcat(string, "{00C0FF}/phonehelp{FFFFFF} - pomoc u vezi komandi za mobilni telefon\n");
    strcat(string, "{00C0FF}/bankhelp{FFFFFF} - pomoc u vezi banke i bankomata\n");
    strcat(string, "{00C0FF}/dosije{FFFFFF} - pregled Wanted Levela i posljednjeg razloga\n");
    strcat(string, "{00C0FF}/platiputarinu{FFFFFF} - otvori rampu na granici iz vozila\n");
    strcat(string, "{00C0FF}/gpshelp{FFFFFF} - pomoc u vezi lokacija na serveru");

    // Prikazivanje dijaloga igracu (ID dijaloga možeš promijeniti u svoj slobodni broj, npr. 999)
    ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_MSGBOX, "Pomoc", string, "Zatvori", "");
    return 1;
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
    new sickUntil = DOF2_GetInt(file, "BolestanDo");
    if(sickUntil > gettime()) SetPlayerHealth(playerid, 50.0);
    else
    {
        if(sickUntil != 0)
        {
            DOF2_SetInt(file, "BolestanDo", 0);
            DOF2_SaveFile();
        }
        SetPlayerHealth(playerid, 100.0);
    }
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

    PlayerRespekti[playerid] = DOF2_GetInt(file, "Respekti") + HappyHourMultiplier;
    sati++;
    sati--;
    DOF2_SetInt(file, "Sati", sati);

    new salary = 0;
    if(admin_lvl > 0 || helper_lvl > 0) salary = 1500;
    else if(sati % 2 == 0) salary = 2500;
    if(salary > 0)
    {
        GivePlayerMoney(playerid, salary);
        PlayerInfo[playerid][pNovac] = GetPlayerMoney(playerid);
        DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
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
    if(sickUntil <= gettime() && random(100) < 10)
    {
        DOF2_SetInt(file, "BolestanDo", gettime() + 7200);
        SendClientMessage(playerid, 0xFFAA66FF, "[ZDRAVLJE]: Razboljeli ste se. Spawn health ce biti 50% naredna 2 sata.");
    }
    DOF2_SaveFile();

    new message[160];
    format(message, sizeof(message), "[PAYDAY]: Odigrali ste puni sat, dobili %dx respekt i %d RSD. Respekti: %d/%d.", HappyHourMultiplier, salary, PlayerRespekti[playerid], level * 4);
    SendClientMessage(playerid, 0x00FF00FF, message);
    if(level > oldLevel)
    {
        format(message, sizeof(message), "[SERVER]: Cestitamo! Presli ste sa levela %d na level %d.", oldLevel, level);
        SendClientMessage(playerid, 0xFFFF00FF, message);
    }
    return 1;
}
CMD:dajadmin(playerid, params[])
{
    // Provjera prava
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_rank = 0;
    if(DOF2_FileExists(file)) {
        admin_rank = DOF2_GetInt(file, "Admin");
    }

    if(admin_rank < 1 && !IsPlayerAdmin(playerid)) return 0;
    if(!IsPlayerAdmin(playerid) && admin_rank < 9)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste Vlasnik servera i ne mozete koristiti ovu komandu!");
        return 1;
    }

    new targetid, rank;
    if(sscanf(params, "ui", targetid, rank))
    {
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/dajadmin [ID / Ime] [Rank (0-9)]");
        return 1;
    }

    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Igrac nije na serveru!");
        return 1;
    }

    if(rank < 0 || rank > 9)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Admin rank mora biti izmedju 0 i 9!");
        return 1;
    }

    new target_file[128], target_name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, target_name, sizeof(target_name));
    format(target_file, sizeof(target_file), "Korisnici/%s.ini", target_name);

    if(!DOF2_FileExists(target_file))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Fajl ovog igraca ne postoji!");
        return 1;
    }

    // --- AKO JE RANK 0 -> SKIDA MU ADMINA ---
    if(rank == 0)
    {
        DOF2_SetInt(target_file, "Admin", 0);
        DOF2_SetInt(target_file, "AdminSlot", -1);
        DOF2_SetInt(target_file, "AdminKod", 0);

        // Vracamo mu default skin sa pocetka (npr. skin 26 ili cemo procitati iz fajla ako cuvas)
        DOF2_SetInt(target_file, "Skin", 26);
        DOF2_SaveFile();

        SetPlayerSkin(targetid, 26); // Postavljamo mu skin 26 vizuelno na serveru
        SetPlayerColor(targetid, 0xFFFFFFFF);
        UpdateAdminLabel(targetid); // Briše labelu iznad glave

        new string[128];
        format(string, sizeof(string), "Admin %s vam je skinuo admin poziciju.", ime);
        SendClientMessage(targetid, 0xFF0000FF, string);

        format(string, sizeof(string), "Uspjesno ste skinuli admin poziciju igracu %s i vratili mu pocetni skin.", target_name);
        SendClientMessage(playerid, 0x00BFFFFF, string);
        return 1;
    }

    // --- AUTOMATSKO DODJELJIVANJE SLOTA KROZ SVE IGRACE ---
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
                    if(DOF2_GetInt(i_file, "Admin") > 0 && DOF2_GetInt(i_file, "AdminSlot") == s)
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
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nema vise slobodnih slotova (sva 20 su zauzeta)!");
        return 1;
    }
    // --------------------------------------

    DOF2_SetInt(target_file, "Admin", rank);
    DOF2_SetInt(target_file, "AdminSlot", slobodan_slot);
    DOF2_SetInt(target_file, "Skin", 294);
    DOF2_SaveFile();

    SetPlayerSkin(targetid, 294);
    if(rank == 8 || rank == 9) SetPlayerColor(targetid, 0x000000FF);
    else SetPlayerColor(targetid, 0xFFFFFFFF);

    // Osvježavanje 3D teksta iznad glave da se odmah prikaže
    UpdateAdminLabel(targetid);

    new string[128];
    format(string, sizeof(string), "Admin %s vam je dodijelio admin rank: %d (Slot: %d)", ime, rank, slobodan_slot);
    SendClientMessage(targetid, 0x00BFFFFF, string);

    format(string, sizeof(string), "Uspjesno ste dodijelili admin rank %d igracu %s na slotu %d.", rank, target_name, slobodan_slot);
    SendClientMessage(playerid, 0x00BFFFFF, string);

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
        return SendClientMessage(playerid, 0xFF0000FF, "[ADMIN KOD]: Nalog nije pronadjen.");
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

    // Ako nije admin, ne radi ništa (za obicne igrace)
    if(admin_rank < 1 && !IsPlayerAdmin(playerid)) return 0;

    // Ako je admin ali nije Vlasnik, daje mu grešku
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
    format(string, sizeof(string), "Uspješno ste generisali admin kod (%d) za igraca %s.", random_code, target_name);
    SendClientMessage(playerid, 0x00BFFFFF, string);

    return 1;
}
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
    format(dialog_string, sizeof(dialog_string), "%s\n{FFFFFF}[SPISAK SVIH ADMIN SLOTOVA]\n========================================\n", dialog_string);

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
                    new i_admin = DOF2_GetInt(i_file, "Admin");
                    new i_slot = DOF2_GetInt(i_file, "AdminSlot");

                    if(i_admin > 0 && i_slot == slot)
                    {
                        format(slot_ime, sizeof(slot_ime), "%s", i_name);
                        format(slot_prikaz, sizeof(slot_prikaz), "%d", i_admin); // Vracen level pored imena
                        zauzet_slot = 1;
                        break;
                    }
                }
            }
        }

        // Ako slot nema online igraca, tražimo u fajlovima ko je zadužen za taj slot
        if(zauzet_slot == 0)
        {
            format(slot_prikaz, sizeof(slot_prikaz), "239");
        }

        format(dialog_string, sizeof(dialog_string), "%s{FFFFFF}[ADMIN] [SLOT %d]: %s | %s\n", dialog_string, slot, slot_ime, slot_prikaz);
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

    // Ako igrac nije admin, ne radi ništa (obicni igraci vide Unknown command)
    if(admin_rank < 1 && !IsPlayerAdmin(playerid)) return 0;

    // Trenutno stanje dužnosti iz fajla
    new current_duty = DOF2_GetInt(file, "AdminDuty");
    new string[128];

    if(current_duty == 0)
    {
        // Prelazi na dužnost
        DOF2_SetInt(file, "AdminDuty", 1);
        DOF2_SaveFile();

        // Postavljamo Health i Armor na 100
        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 100.0);

        // Format poruke sa zvjezdicama, imenom, ID-om i statusom
        format(string, sizeof(string), "** ADMIN: %s[%d] je sada na Admin dužnosti **", ime, playerid);
    }
    else
    {
        // Skida se sa dužnosti
        DOF2_SetInt(file, "AdminDuty", 0);
        DOF2_SaveFile();

        // Kada skine duty, brišemo mu armor (stavljamo na 0) i vracamo normalno trošenje
        SetPlayerArmour(playerid, 0.0);

        // Format poruke kad nije više na dužnosti
        format(string, sizeof(string), "** ADMIN: %s[%d] više nije na Admin dužnosti **", ime, playerid);
    }

    // Slanje poruke ISKLJUCIVO online adminima u zlatno-žutoj boji (0xF9A602FF)
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
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Rank helpera mora biti izmedju 0 i 5!");
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

        // Brišemo staru labelu ako je ima
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

    // --- AUTOMATSKO DODJELJIVANJE HELPER SLOTA (0-20) KROZ SVE IGRACE ---
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
    new string[128];

    if(duty == 0) {
        DOF2_SetInt(file, "HDuty", 1);
        SetPlayerColor(playerid, 0xFFFF00FF); // Skroz cista zuta boja u TAB-u

        // Postavljamo Health i Armor na 100 kad ude na dužnost
        SetPlayerHealth(playerid, 100.0);
        SetPlayerArmour(playerid, 100.0);

        format(string, sizeof(string), "** HELPER: %s[%d] je sada na Helper duznosti **", name, playerid);
        SendClientMessageToAll(0xFFFF00FF, string);
    } else {
        DOF2_SetInt(file, "HDuty", 0);
        SetPlayerColor(playerid, 0xFFFFFFFF); // Vraca na bijelo

        // Kada skine helper dužnost, brišemo mu armor (stavljamo na 0) i vracamo normalno trošenje
        SetPlayerArmour(playerid, 0.0);

        format(string, sizeof(string), "** HELPER: %s[%d] vise nije na Helper duznosti **", name, playerid);
        SendClientMessageToAll(0xFFFF00FF, string);
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
    // Generiše nasumicni broj izmedu 100000 i 999999 i pretvara ga u string kod
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
        if(IsPlayerConnected(i))
        {
            // Ovdje server poziva tvoju stock funkciju za svakog igraca!
            DajPayDayRespekt(i);
        }
    }
    return 1;
}
// Na vrhu skripte provjeri da li imaš: new Text3D:AdminText[MAX_PLAYERS];

forward UpdateAdminLabel(playerid);
public UpdateAdminLabel(playerid)
{
    // Ako vec ima labelu, brišemo je da se ne duplira
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
        if(PlayerMinute[i] >= 60)
        {
            PlayerMinute[i] = 0;
            DOF2_SetInt(file, "MinuteIgranja", 0);
            DOF2_SaveFile();
            DajPayDayRespekt(i);
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
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(DOF2_FileExists(file))
    {
        // Šteta se blokira SAMO ako je na admin ili helper dužnosti
        if(DOF2_GetInt(file, "AdminDuty") == 1 || DOF2_GetInt(file, "HDuty") == 1)
        {
            SetPlayerHealth(playerid, 100.0);
            SetPlayerArmour(playerid, 100.0);
            return 0; // Poništava štetu
        }
    }
    return 1; // Cim skine dužnost, vraca se na normalno gubljenje HP-a i armora!
}
stock UpdateHouseCP(houseid)
{
    // Uništavanje starog 3D Labela samo ako je važeci
    if(HouseInfo[houseid][kLabel] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(HouseInfo[houseid][kLabel]);
        HouseInfo[houseid][kLabel] = Text3D:INVALID_3DTEXT_ID;
    }

    // Uništavanje starog pikapa samo ako zapravo postoji (ne briše Pikap 0)
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
stock LoadHouses()
{
    for(new h = 0; h < MAX_KUCA; h++)
    {
        // KLJUCNA IZMENA: Stavljamo na -1 pre ucitavanja da ne briše pikap/label 0
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

    DestroyPickup(HouseInfo[id][kPickup]); // Samo uništavamo pikap bez provjere

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

    new hfile[128];
    format(hfile, sizeof(hfile), "BalkanRP/Kuce/kuca_%d.ini", id);
    if(!DOF2_FileExists(hfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ta kuca ne postoji!");

    // Postavljamo i cijenu i level odjednom
    HouseInfo[id][kCena] = nova_cijena;
    HouseInfo[id][kLevel] = novi_level;

    // Snimamo promjene i osvježavamo kucu
    SaveHouse(id);
    UpdateHouseCP(id);

    new string[128];
    format(string, sizeof(string), "Uspješno si izmijenio kucu ID: %d | Nova cijena: $%d | Novi level: %d", id, nova_cijena, novi_level);
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
        SendClientMessage(playerid, 0x00BFFFFF, "[JETPACK]: Jetpack je uklonjen.");
        return 1;
    }

    if(!SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK))
        return SendClientMessage(playerid, 0xFF0000FF, "[JETPACK]: Nije moguce ukljuciti jetpack.");
    ScriptJetpack[playerid] = true;
    JetpackDropGuardUntil[playerid] = 0;
    SendClientMessage(playerid, 0x00BFFFFF, "[JETPACK]: Jetpack je ukljucen. Ponovi /jetpack za skidanje.");
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
    // --- OSVJEŽAVANJE LEVELA I NOVCA IZ FAJLA DA NE BUDE BAGS ---
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    if(!DOF2_FileExists(file)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Vas nalog nije pronadjen!");
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
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste blizu nijedne kuce koju možete kupiti!");
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

    // Spremamo kucu u fajl i ažuriramo 3D text/pikap
    SaveHouse(houseid);
    UpdateHouseCP(houseid);

    // Poruka uspjeha
    new succstring[128];
    format(succstring, sizeof(succstring), "Cestitamo! Uspješno ste kupili kucu ID: %d za $%d.", houseid, HouseInfo[houseid][kCena]);
    SendClientMessage(playerid, 0x00BFFFFF, succstring);

    return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
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
    // TASTER "C" (PEŠKE) ILI "H" (U VOZILU) -> KEY_CROUCH
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

        // 2. PROVERA ZA PEŠKE ("C" van vozila)
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

            // Otvaranje kapije za clana peške (bez skidanja para)
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
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerPos(playerid, 153.79109191, 1702.71630859, -0.85856175);
                SetCameraBehindPlayer(playerid);
                SendClientMessage(playerid, 0x33CCFFFF, "[BANKA]: Usli ste u banku.");
                return 1;
            }
            if(IsPlayerInRangeOfPoint(playerid, 2.5, 153.79109191, 1702.71630859, -0.85856175))
            {
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerPos(playerid, 1462.90759277, -1022.80725097, 23.83310317);
                SetCameraBehindPlayer(playerid);
                SendClientMessage(playerid, 0x33CCFFFF, "[BANKA]: Izasli ste iz banke.");
                return 1;
            }
        }

        // 1. KUCE - IZLAZ
        for(new h = 0; h < MAX_KUCA; h++)
        {
            if(pVW == h && IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[h][kExitX], HouseInfo[h][kExitY], HouseInfo[h][kExitZ]))
            {
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerPos(playerid, HouseInfo[h][kEntranceX], HouseInfo[h][kEntranceY], HouseInfo[h][kEntranceZ]);
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

                SetPlayerInterior(playerid, HouseInfo[h][kInterior]);
                SetPlayerVirtualWorld(playerid, h);
                SetPlayerPos(playerid, HouseInfo[h][kExitX], HouseInfo[h][kExitY], HouseInfo[h][kExitZ]);
                return 1;
            }
        }

        // 3. MARKETA - IZLAZ
        for(new m = 0; m < MAX_MARKETA; m++)
        {
            if(pVW == (m + 5000) && IsPlayerInRangeOfPoint(playerid, 3.0, MarketInfo[m][mExitX], MarketInfo[m][mExitY], MarketInfo[m][mExitZ]))
            {
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerPos(playerid, MarketInfo[m][mEntranceX], MarketInfo[m][mEntranceY], MarketInfo[m][mEntranceZ]);
                return 1;
            }
        }

        // 4. MARKETA - ULAZ
        for(new m = 0; m < MAX_MARKETA; m++)
        {
            if(pVW == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, MarketInfo[m][mEntranceX], MarketInfo[m][mEntranceY], MarketInfo[m][mEntranceZ]))
            {
                SetPlayerInterior(playerid, MarketInfo[m][mInterior]);
                SetPlayerVirtualWorld(playerid, m + 5000);
                SetPlayerPos(playerid, MarketInfo[m][mExitX], MarketInfo[m][mExitY], MarketInfo[m][mExitZ]);
                return 1;
            }
        }

        // 5. ZLATARE - IZLAZ
        for(new z = 0; z < MAX_ZLATA; z++)
        {
            if(pVW == (z + 6000) && IsPlayerInRangeOfPoint(playerid, 3.0, ZlataInfo[z][zExitX], ZlataInfo[z][zExitY], ZlataInfo[z][zExitZ]))
            {
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetPlayerPos(playerid, ZlataInfo[z][zEntranceX], ZlataInfo[z][zEntranceY], ZlataInfo[z][zEntranceZ]);
                return 1;
            }
        }

        // 6. ZLATARE - ULAZ
        for(new z = 0; z < MAX_ZLATA; z++)
        {
            if(pVW == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, ZlataInfo[z][zEntranceX], ZlataInfo[z][zEntranceY], ZlataInfo[z][zEntranceZ]))
            {
                SetPlayerInterior(playerid, ZlataInfo[z][zInterior]);
                SetPlayerVirtualWorld(playerid, z + 6000);
                SetPlayerPos(playerid, ZlataInfo[z][zExitX], ZlataInfo[z][zExitY], ZlataInfo[z][zExitZ]);
                return 1;
            }
        }

        // 7. GIGATRON - ULAZ I IZLAZ
        if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, 1412.1534, -1700.0010, 13.5395))
        {
            SetPlayerPos(playerid, -540.8716, 2596.0989, 10.9875);
            SetPlayerInterior(playerid, 10);
            SendClientMessage(playerid, 0x00BFFFFF, "[Balkan Revolution]: Ušli ste u Gigatron!");
            return 1;
        }
        else if(pInt == 10 && IsPlayerInRangeOfPoint(playerid, 3.0, -540.8716, 2596.0989, 10.9875))
        {
            SetPlayerPos(playerid, 1412.1534, -1700.0010, 13.5395);
            SetPlayerInterior(playerid, 0);
            SendClientMessage(playerid, 0x00BFFFFF, "[Balkan Revolution]: Izišli ste iz Gigatrona!");
            return 1;
        }

        // 8. OPŠTINA - ULAZ I IZLAZ
        if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, 1481.0885, -1771.9858, 18.7958))
        {
            SetPlayerPos(playerid, 386.52, 173.63, 1008.38);
            SetPlayerInterior(playerid, 3);
            SetPlayerFacingAngle(playerid, 90.0);
            SetCameraBehindPlayer(playerid);
            SendClientMessage(playerid, 0x00FF00FF, "[OPŠTINA]: Ušli ste u Gradsku Opštinu.");
            return 1;
        }
        else if(pInt == 3 && IsPlayerInRangeOfPoint(playerid, 3.0, 386.52, 173.63, 1008.38))
        {
            SetPlayerPos(playerid, 1481.0885, -1771.9858, 18.7958);
            SetPlayerInterior(playerid, 0);
            SetPlayerFacingAngle(playerid, 177.9518);
            SetCameraBehindPlayer(playerid);
            SendClientMessage(playerid, 0x00FF00FF, "[OPŠTINA]: Izašli ste iz Gradske Opštine.");
            return 1;
        }

        // 9. POLICIJSKA STANICA (Beogradska Policija) - ULAZ I IZLAZ
        if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, 1555.1368, -1675.6598, 16.1953))
        {
            SetPlayerPos(playerid, 246.66, 65.80, 1003.64);
            SetPlayerInterior(playerid, 6);
            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerFacingAngle(playerid, 0.0);
            SetCameraBehindPlayer(playerid);
            SendClientMessage(playerid, 0x33CCFFFF, "[Balkan Revolution]: Ušli ste u stanicu policije.");
            return 1;
        }
        else if(pInt == 6 && IsPlayerInRangeOfPoint(playerid, 3.0, 246.66, 65.80, 1003.64))
        {
            SetPlayerPos(playerid, 1555.1368, -1675.6598, 16.1953);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerFacingAngle(playerid, 272.5560);
            SetCameraBehindPlayer(playerid);
            SendClientMessage(playerid, 0x33CCFFFF, "[Balkan Revolution]: Izašli ste iz stanice policije.");
            return 1;
        }

        // 10. BOLNICA - ULAZ I IZLAZ
        if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, 1172.4083, -1323.3091, 15.4029))
        {
            SetPlayerPos(playerid, -23.7858, 1500.6514, -3.3132);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SendClientMessage(playerid, 0x00FF00FF, "[BOLNICA]: Ušli ste u bolnicu.");
            return 1;
        }
        else if(pInt == 0 && IsPlayerInRangeOfPoint(playerid, 3.0, -23.7858, 1500.6514, -3.3132))
        {
            SetPlayerPos(playerid, 1172.4083, -1323.3091, 15.4029);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SendClientMessage(playerid, 0xFF0000FF, "[BOLNICA]: Izašli ste iz bolnice.");
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
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlastenje! Ovu komandu može koristiti samo vlasnik kuce ili viši admin.");
        return 1;
    }

    // Postavljanje svijeta, interiora i pozicije na ulaz kuce
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, HouseInfo[houseid][kEntranceX], HouseInfo[houseid][kEntranceY], HouseInfo[houseid][kEntranceZ]);

    new string[128];
    format(string, sizeof(string), "Uspješno ste se teleportovali do kuce ID: %d.", houseid);
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
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ova kuca nije u vašem vlasništvu!");
        return 1;
    }

    // Racunamo pola cijene za povrat novca
    new povrat_novca = HouseInfo[houseid][kCena] / 2;

    // Vracamo novac igracu (prilagodi funkciju za novac ako koristiš drugu, npr. GivePlayerMoney)
    GivePlayerMoney(playerid, povrat_novca);

    // Resetujemo podatke kuce na "Drzava"
    HouseInfo[houseid][kOwned] = 0;
    HouseInfo[houseid][kLocked] = 1;
    format(HouseInfo[houseid][kOwner], MAX_PLAYER_NAME, "Drzava");

    // Snimamo promjene u fajl i ažuriramo checkpoint
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
    format(string, sizeof(string), "Uspješno ste prodali kucu državi i dobili nazad $%d (pola cijene).", povrat_novca);
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

    SendClientMessage(playerid, 0x00BFFFFF, "Uspješno ste zakljucali kucu.");
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

    SendClientMessage(playerid, 0x00BFFFFF, "Uspješno ste otkljucali kucu.");
    return 1;
}
forward SaveMarket(marketid);
public SaveMarket(marketid)
{
    new file[128];
    format(file, sizeof(file), "BalkanRP/Marketi/market_%d.ini", marketid);
    if(!DOF2_FileExists(file)) DOF2_CreateFile(file);

    DOF2_SetInt(file, "Owned", MarketInfo[marketid][mOwned]);
    DOF2_SetString(file, "Owner", MarketInfo[marketid][mOwner]);
    DOF2_SetString(file, "Naziv", MarketInfo[marketid][mNaziv]);

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

    DOF2_SaveFile();
    return 1;
}

forward UpdateMarketCP(marketid);
public UpdateMarketCP(marketid)
{
    if(IsValidDynamic3DTextLabel(MarketInfo[marketid][mLabel])) DestroyDynamic3DTextLabel(MarketInfo[marketid][mLabel]);
    if(IsValidDynamicPickup(MarketInfo[marketid][mPickup])) DestroyDynamicPickup(MarketInfo[marketid][mPickup]);

    new string[512], vlasnik[MAX_PLAYER_NAME], opis[32];

    if(MarketInfo[marketid][mOwned] == 1)
    {
        format(vlasnik, sizeof(vlasnik), "%s", MarketInfo[marketid][mOwner]);
        format(opis, sizeof(opis), "Otvoreno");
    }
    else
    {
        format(vlasnik, sizeof(vlasnik), "Nitko");
        format(opis, sizeof(opis), "Na Prodaju");
    }

    format(string, sizeof(string), "{00C0FF}Naziv Firme: {FFFFFF}%s\n{00C0FF}Opis: {FFFFFF}%s\n{00C0FF}Vlasnik Firme: {FFFFFF}%s\n{00C0FF}ID: {FFFFFF}%d | {00C0FF}Cijena: {FFFFFF}$%d | {00C0FF}Level: {FFFFFF}%d\n{00C0FF}Cijena Ulaza: {FFFFFF}$%d\n{00C0FF}Budžet: {FFFFFF}$%d\n{00C0FF}Potrebni Produkti: {FFFFFF}%d | {00C0FF}Cijena Produkta: {FFFFFF}$%d",
        MarketInfo[marketid][mNaziv],
        opis,
        vlasnik,
        marketid,
        MarketInfo[marketid][mCena],
        MarketInfo[marketid][mLevel],
        MarketInfo[marketid][mUlaznaCena],
        MarketInfo[marketid][mBudzet],
        MarketInfo[marketid][mProizvodi],
        MarketInfo[marketid][mCenaProizvoda]
    );

    MarketInfo[marketid][mLabel] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, MarketInfo[marketid][mEntranceX], MarketInfo[marketid][mEntranceY], MarketInfo[marketid][mEntranceZ]+0.5, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, -1, -1);

    // Dinamicki pikup preko streamera (1239 je znak dolara $)
    MarketInfo[marketid][mPickup] = CreateDynamicPickup(1239, 23, MarketInfo[marketid][mEntranceX], MarketInfo[marketid][mEntranceY], MarketInfo[marketid][mEntranceZ], 0, 0);
    return 1;
}
// --- 1. KREIRANJE MARKETA (ADMIN) ---
CMD:napravimarket(playerid, params[])
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
        SendClientMessage(playerid, 0x00BFFFFF, "KORISCENJE: {FFFFFF}/napravimarket [Cijena] [Level]");
        return 1;
    }

    // Trazenje slobodnog slota u memoriji (RAM)
    new marketid = -1;
    for(new m = 0; m < MAX_MARKETA; m++)
    {
        if(MarketInfo[m][mEntranceX] == 0.0)
        {
            marketid = m;
            break;
        }
    }

    if(marketid == -1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Dostignut je maksimalan broj marketa!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    // Automatsko postavljanje naziva "24/7"
    MarketInfo[marketid][mOwned] = 0;
    format(MarketInfo[marketid][mOwner], MAX_PLAYER_NAME, "Nitko");
    format(MarketInfo[marketid][mNaziv], 32, "24/7");

    MarketInfo[marketid][mEntranceX] = x;
    MarketInfo[marketid][mEntranceY] = y;
    MarketInfo[marketid][mEntranceZ] = z;

    // Koordinate unutrašnjosti (24/7 enterijer)
    MarketInfo[marketid][mExitX] = 6.08;
    MarketInfo[marketid][mExitY] = -28.89;
    MarketInfo[marketid][mExitZ] = 1003.54;
    MarketInfo[marketid][mInterior] = 10;

    MarketInfo[marketid][mCena] = cena;
    MarketInfo[marketid][mLevel] = level;
    MarketInfo[marketid][mUlaznaCena] = 50;
    MarketInfo[marketid][mBudzet] = 0;
    MarketInfo[marketid][mProizvodi] = 100;
    MarketInfo[marketid][mCenaProizvoda] = 100;

    SaveMarket(marketid);
    UpdateMarketCP(marketid);

    new string[128];
    format(string, sizeof(string), "Uspješno si kreirao 24/7 market ID: %d", marketid);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

// --- 2. UREÐIVANJE MARKETA (ADMIN) ---
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
    format(string, sizeof(string), "Uspješno si izmijenio market ID: %d | Nova cijena: $%d | Novi level: %d", id, nova_cijena, novi_level);
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

    new mfile[128];
    format(mfile, sizeof(mfile), "BalkanRP/Marketi/market_%d.ini", id);
    if(!DOF2_FileExists(mfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj market ne postoji!");

    DOF2_RemoveFile(mfile);

    if(IsValidDynamic3DTextLabel(MarketInfo[id][mLabel])) DestroyDynamic3DTextLabel(MarketInfo[id][mLabel]);

    // Umjesto DestroyPickup, koristimo ispravnu streamer funkciju za dinamicke pikupove:
    if(IsValidDynamicPickup(MarketInfo[id][mPickup])) DestroyDynamicPickup(MarketInfo[id][mPickup]);

    // Resetovanje u memoriji
    MarketInfo[id][mOwned] = 0;
    format(MarketInfo[id][mOwner], MAX_PLAYER_NAME, "Nitko");
    MarketInfo[id][mCena] = 0;
    MarketInfo[id][mLevel] = 0;

    new string[128];
    format(string, sizeof(string), "Uspješno si obrisao market ID: %d", id);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

// --- 4. KUPOVINA MARKETA (IGRAC) ---
CMD:buybizz(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);
    if(fexist(file))
    {
        PlayerInfo[playerid][pLevel] = DOF2_GetInt(file, "Level");
        PlayerInfo[playerid][pNovac] = DOF2_GetInt(file, "Novac");
        PlayerInfo[playerid][pBizz] = DOF2_GetInt(file, "Bizz");
    }

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
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste blizu nijednog marketa koji možete kupiti!");
        return 1;
    }

    if(MarketInfo[marketid][mOwned] == 1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Ovaj market vec ima svog vlasnika!");
        return 1;
    }

    if(PlayerInfo[playerid][pBizz] >= 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Vec posjedujete biznis! Ne možete imati više biznisa.");
        return 1;
    }

    if(PlayerInfo[playerid][pLevel] < MarketInfo[marketid][mLevel])
    {
        new string[128];
        format(string, sizeof(string), "GRESKA: Nemate dovoljan level! (Tvoj level: %d | Potreban: %d)", PlayerInfo[playerid][pLevel], MarketInfo[marketid][mLevel]);
        SendClientMessage(playerid, 0xFF0000FF, string);
        return 1;
    }

    if(PlayerInfo[playerid][pNovac] < MarketInfo[marketid][mCena])
    {
        new string[128];
        format(string, sizeof(string), "GRESKA: Nemate dovoljno novca! (Imate: $%d | Cijena: $%d)", PlayerInfo[playerid][pNovac], MarketInfo[marketid][mCena]);
        SendClientMessage(playerid, 0xFF0000FF, string);
        return 1;
    }

    PlayerInfo[playerid][pNovac] -= MarketInfo[marketid][mCena];
    GivePlayerMoney(playerid, -MarketInfo[marketid][mCena]);

    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
        DOF2_SetInt(file, "Bizz", marketid);
        DOF2_SaveFile();
    }

    MarketInfo[marketid][mOwned] = 1;
    GetPlayerName(playerid, MarketInfo[marketid][mOwner], MAX_PLAYER_NAME);
    PlayerInfo[playerid][pBizz] = marketid;

    SaveMarket(marketid);
    UpdateMarketCP(marketid);

    new succstring[128];
    format(succstring, sizeof(succstring), "Cestitamo! Uspješno ste kupili market ID: %d za $%d.", marketid, MarketInfo[marketid][mCena]);
    SendClientMessage(playerid, 0x00BFFFFF, succstring);

    return 1;
}

// --- 5. PRODAJA MARKETA DRŽAVI (IGRAC) ---
CMD:sellbizz(playerid, params[])
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(fexist(file))
    {
        PlayerInfo[playerid][pBizz] = DOF2_GetInt(file, "Bizz");
        PlayerInfo[playerid][pNovac] = DOF2_GetInt(file, "Novac");
    }

    if(PlayerInfo[playerid][pBizz] == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Vi ne posjedujete nijedan biznis!");
        return 1;
    }

    new marketid = PlayerInfo[playerid][pBizz];

    if(!IsPlayerInRangeOfPoint(playerid, 3.0, MarketInfo[marketid][mEntranceX], MarketInfo[marketid][mEntranceY], MarketInfo[marketid][mEntranceZ]))
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Morate biti kod ulaza Vašeg biznisa da biste ga prodali!");
        return 1;
    }

    new povrat_novca = MarketInfo[marketid][mCena] / 2;

    PlayerInfo[playerid][pNovac] += povrat_novca;
    GivePlayerMoney(playerid, povrat_novca);
    PlayerInfo[playerid][pBizz] = -1;

    MarketInfo[marketid][mOwned] = 0;
    format(MarketInfo[marketid][mOwner], MAX_PLAYER_NAME, "Nitko");

    if(DOF2_FileExists(file))
    {
        DOF2_SetInt(file, "Novac", PlayerInfo[playerid][pNovac]);
        DOF2_SetInt(file, "Bizz", -1);
        DOF2_SaveFile();
    }

    SaveMarket(marketid);
    UpdateMarketCP(marketid);

    new string[128];
    format(string, sizeof(string), "Uspješno ste prodali svoj biznis državi za $%d.", povrat_novca);
    SendClientMessage(playerid, 0x00BFFFFF, string);
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
    format(string, sizeof(string), "Uspješno si se teleportovao do marketa ID: %d", id);
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

    // Ovdje ide funkcija/komanda za banovanje (npr. Ban(targetid) ili snimanje u fajl)
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
    if(nivo < 1 || nivo > 5000) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Level mora biti izmedju 1 i 5000!");

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

    format(msg, sizeof(msg), "Uspješno ste postavili igracu %s level na: %d.", targetName, nivo);
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
    format(string, sizeof(string), "unbanip %s", ip); // <--- OVDJE JE DODANO sizeof(string)
    SendRconCommand(string);

    format(string, sizeof(string), "Administrator %s je skinuo IP ban sa adrese: %s", ime, ip);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
public OnPlayerCommandReceived(playerid, cmdtext[])
{
    new ime_be[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime_be, sizeof(ime_be));

    new log_string_be[144];
    format(log_string_be, sizeof(log_string_be), "[BIGEAR CMD] [ID: %d] %s kuca: %s", playerid, ime_be, cmdtext);
    SendBigEarLog(log_string_be);

    // Ovdje provjerava da li komanda uopšte postoji u modu
    return 1; // Dozvoljava izvršavanje
}

// Ova funkcija se poziva automatski kada kuca nepostojecu komandu u ZCMD-u:
public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(!success)
    {
        SendClientMessage(playerid, 0xFF0000FF, "(Greska!) {FFFFFF}Uneli ste nepostojecu komandu, spisak svih komandi mozete vidjeti na /help");
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

    // Postavljanje igraca na željene koordinate
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

    // Složit cemo dijalog sa spiskom telefona i cijenama
    new string[512];
    format(string, sizeof(string), "Model telefona\tCijena\n");

    for(new i = 0; i < 5; i++)
    {
        new redak[64];
        format(redak, sizeof(redak), "%s\t$%d\n", TelLista[i][tNaziv], TelLista[i][tCijena]);
        strcat(string, redak, sizeof(string));
    }

    // Prikaz dijaloga igracu (ID dijaloga možeš prilagoditi svom modu, npr. DIALOG_TELEFONI)
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
    format(poruka, sizeof(poruka), "[Balkan Revolution]: Uspješno ste kupili broj telefona! Vaš novi broj je: {00BFFF}[%d]", random_broj);
    SendClientMessage(playerid, 0x00BFFFFF, poruka);

    return 1;
}
CMD:kupislusalice(playerid, params[])
{
    // Provjera da li je igrac na tvojoj lokaciji (-530.8458, 2603.3523, 10.9875) u krugu od 3 metra
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, -530.8458, 2603.3523, 10.9875))
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Niste na mjestu za kupovinu slušalica!");
        return 1;
    }

    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(!DOF2_FileExists(file)) return 1;

    // Provjera da li igrac vec ima slušalice
    if(DOF2_IsSet(file, "Slusalice") && DOF2_GetInt(file, "Slusalice") == 1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Vec posjedujete slušalice!");
        return 1;
    }

    // Upisivanje u bazu da posjeduje slušalice
    DOF2_SetInt(file, "Slusalice", 1);
    DOF2_SaveFile();

    SendClientMessage(playerid, 0x00BFFFFF, "[Balkan Revolution]: Uspješno ste kupili slušalice! Sada možete koristiti komandu {FFFFFF}/mp3.");
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
        • Meso: %d kom\n\
        • Mleko: %d kom\n\
        • Hleb: %d kom\n\
        • Jabuke: %d kom\n\
        • Banana: %d kom\n\
        • Sok: %d kom",
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
        return SendClientMessage(playerid, 0xFF0000FF, "[Greška] {FFFFFF}Niste na kasi za inventar/namirnice!");

    new dialogstring[300];
    format(dialogstring, sizeof(dialogstring), "Proizvod\tCijena\nMeso\t350 RSD\nMleko\t120 RSD\nHleb\t80 RSD\nJabuke\t50 RSD\nBanana\t60 RSD\nSok\t90 RSD");
    ShowPlayerDialog(playerid, DIALOG_MARKET_HRANA, DIALOG_STYLE_TABLIST_HEADERS, "24/7 - Namirnice", dialogstring, "Kupi", "Izadji");
    return 1;
}

CMD:kupi(playerid, params[])
{
    #pragma unused params

    // Da vidimo šta ti tacno server ocita u igri:
    new string[128];
    format(string, sizeof(string), "DEBUG -> Tvoj Interior: %d | Udaljenost: %f", GetPlayerInterior(playerid), GetPlayerDistanceFromPoint(playerid, 2.4111, -28.4906, 1003.5494));
    SendClientMessage(playerid, -1, string);

    // Privremeno micemo provjeru enterijera da vidimo hoce li otvoriti dialog ako si blizu 10 metara
    if(!IsPlayerInRangeOfPoint(playerid, 10.0, 2.4111, -28.4906, 1003.5494))
        return SendClientMessage(playerid, 0xFF0000FF, "[Greška] {FFFFFF}Predaleko ste od mjesta za kupovinu!");

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

    ShowPlayerDialog(playerid, DIALOG_MARKET_SIM, DIALOG_STYLE_TABLIST_HEADERS, "24/7 prodavnica", dialogstring, "Kupi", "Izadji");
    return 1;
}
// --- FUNKCIJA ZA AŽURIRANJE LABELA ---
forward AktualizirajMarketLabel(marketid);
public AktualizirajMarketLabel(marketid)
{
    // Provjera koristi tvoj MAX_MARKETA
    if(marketid < 0 || marketid >= MAX_MARKETA) return 0;

    new string[128];
    format(string, sizeof(string), "{00FF00}24/7 Market\n{FFFFFF}Budžet: {FFCC00}$%d\n{FFFFFF}Koristite {00FFFF}/kupi {FFFFFF}ili {00FFFF}/buyinventory", MarketInfo[marketid][mBudzet]);

    // Koristi tvoj mLabel iz enuma
    if(IsValidDynamic3DTextLabel(MarketInfo[marketid][mLabel]))
    {
        UpdateDynamic3DTextLabelText(MarketInfo[marketid][mLabel], -1, string);
    }
    return 1;
}

// --- FUNKCIJA ZA INICIJALIZACIJU ---
stock UcitajMarkete()
{
    // Ovdje postavljaš podatke za prvi market (index 0)
    MarketInfo[0][mBudzet] = 0;

    // Kreiranje labela koristeci tvoj mLabel
    MarketInfo[0][mLabel] = CreateDynamic3DTextLabel("{00FF00}24/7 Market\n{FFFFFF}Budžet: {FFCC00}$0\n{FFFFFF}Koristite {00FFFF}/kupi {FFFFFF}ili {00FFFF}/buyinventory", -1, 7.0822, -22.7557, 1003.5494, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 17);

    return 1;
}
stock PostaviMarketLabele()
{
    // Label za /kupi
    CreateDynamic3DTextLabel("{00FF00}PRODAVNICA\n{FFFFFF}Kucaj: /kupi", 0xFFFFFFFF, 2.4111, -28.4906, 1003.5494, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 17);

    // Label za /buyinventory
    CreateDynamic3DTextLabel("{00FF00}NAMIRNICE\n{FFFFFF}Kucaj: /buyinventory", 0xFFFFFFFF, 7.0822, -22.7557, 1003.5494, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 17);

    print("Market labeli su postavljeni."); // Ovo ceš vidjeti u server_log.txt ako se ucitalo
}
CMD:sms(playerid, params[])
{
    new targetid, messageText[100];
    if(sscanf(params, "us[100]", targetid, messageText))
        return SendClientMessage(playerid, -1, "Koristenje: /sms [ID/Ime] [Poruka]");
    if(!IsPlayerConnected(targetid) || targetid == playerid)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Izaberite drugog online igraca.");
    new senderFile[128], targetFile[128];
    if(!GetPlayerAccountPath(playerid, senderFile, sizeof(senderFile)) || !GetPlayerAccountPath(targetid, targetFile, sizeof(targetFile)))
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Korisnicki nalog nije pronadjen.");
    if(!DOF2_IsSet(senderFile, "Telefon") || DOF2_GetInt(senderFile, "BrojTelefona") <= 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Morate kupiti telefon i broj telefona.");
    if(!DOF2_IsSet(targetFile, "Telefon") || DOF2_GetInt(targetFile, "BrojTelefona") <= 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMS]: Taj igrac nema telefon ili broj.");
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
    new smsadFile[128];
    if(!GetPlayerAccountPath(playerid, smsadFile, sizeof(smsadFile)) ||
       !DOF2_IsSet(smsadFile, "Telefon") || DOF2_GetInt(smsadFile, "BrojTelefona") <= 0)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMSAD]: Morate kupiti telefon i broj telefona.");
    if(JuniorAdsMuted)
        return SendClientMessage(playerid, 0xFF7777FF, "[OGLASI]: Administracija je privremeno ugasila oglase.");
    // 1. Globalni cooldown - provjera da li je prošla 1 minuta od posljednjeg oglasa
    if(gettime() - LastOglasTick < 60)
    {
        new preostalo = 60 - (gettime() - LastOglasTick);
        new string_cd[128];
        format(string_cd, sizeof(string_cd), "{FF0000}[Greška] {FFFFFF}Oglas možete dati ponovo za %d sekundi.", preostalo);
        return SendClientMessage(playerid, -1, string_cd);
    }

    // 2. Provjera levela (preko Score-a)
    if(GetPlayerScore(playerid) < 3)
        return SendClientMessage(playerid, -1, "{FF0000}[Greška] {FFFFFF}Morate biti level 3 ili više da biste dali oglas!");

    // 3. Provjera unosa (sscanf)
    new tekst[128];
    if(sscanf(params, "s[128]", tekst))
        return SendClientMessage(playerid, -1, "{BFC0C2}Koristite: {FFFFFF}/smsad [Tekst oglasa]");

    // Provjera da oglas nije prekratak
    if(strlen(tekst) < 3)
        return SendClientMessage(playerid, -1, "{FF0000}[Greška] {FFFFFF}Tekst oglasa je prekratak.");

    // 4. Racunamo koliko oglas ima karaktera
    if(IgracKrediti[playerid] < 1)
        return SendClientMessage(playerid, 0xFF7777FF, "[SMSAD]: Nemate telefonskog kredita. Kupite ga na trafici.");

    new brojKaraktera = strlen(tekst);

    // 5. Provjera novca
    if(GetPlayerMoney(playerid) < brojKaraktera)
    {
        new string_err[128];
        format(string_err, sizeof(string_err), "{FF0000}[Greška] {FFFFFF}Nemate dovoljno novca! Oglas košta $%d.", brojKaraktera);
        return SendClientMessage(playerid, -1, string_err);
    }

    // 6. Bilježimo vrijeme
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

    // --- DODAVANJE 70% U BUDŽET BIZNISA MALI OGLASI (ID 0) ---
    new zarada_biznisa = (brojKaraktera * 70) / 100; // Racunamo 70% od cijene oglasa
    OglasiInfo[0][oBudzet] += zarada_biznisa;       // Dodajemo u budžet biznisa ID 0
    SaveOglase(0);                                  // Snimamo promjene u fajl biznisa
    UpdateOglaseCP(0);                              // Ažuriramo 3D label na vratima biznisa
    // --------------------------------------------------------

    // Provjera broja telefona: Ako nema upisan broj, dajemo mu defaultni da ne prekida komandu
    new brTelefona = PlayerInfo[playerid][pBrojTelefona];
    if(brTelefona <= 0) brTelefona = 555111;

    // 8. Slanje oglasa svima
    new string[256];
    format(string, sizeof(string), "{00AA00}[OGLAS] {0085FF}%s{FFFFFF}. {00AA00}Telefon: {0085FF}/call %d {0085FF}(/smsad)", tekst, brTelefona);
    SendClientMessageToAll(-1, string);

    // 9. Obavještenje igracu
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
    format(string, sizeof(string), "Uspješno si kreirao biznis Mali Oglasi ID: %d", oglasid);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

// --- 2. UREÐIVANJE MALI OGLASI (ADMIN) ---
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
    format(string, sizeof(string), "Uspješno si izmijenio biznis oglasa ID: %d | Nova cijena: $%d | Novi level: %d", id, nova_cijena, novi_level);
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
    format(string, sizeof(string), "Uspješno si obrisao biznis oglasa ID: %d", id);
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

    format(string, sizeof(string), "{00C0FF}Naziv Firme: {FFFFFF}%s\n{00C0FF}Opis: {FFFFFF}%s\n{00C0FF}Vlasnik Firme: {FFFFFF}%s\n{00C0FF}ID: {FFFFFF}%d | {00C0FF}Cijena: {FFFFFF}$%d | {00C0FF}Level: {FFFFFF}%d\n{00C0FF}Cijena Ulaza: {FFFFFF}$%d\n{00C0FF}Budžet: {FFFFFF}$%d\n{00C0FF}Potrebni Produkti: {FFFFFF}%d | {00C0FF}Cijena Produkta: {FFFFFF}$%d",
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
stock UcitajOglase()
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

    // Koordinate unutrašnjosti koje si dao za zlataru
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
    format(string, sizeof(string), "Uspješno si kreirao zlataru ID: %d", zlataid);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}

// --- 2. UREÐIVANJE ZLATARE (ADMIN) ---
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
    format(string, sizeof(string), "Uspješno si izmijenio zlataru ID: %d | Nova cijena: $%d | Novi level: %d", id, nova_cijena, novi_level);
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
    format(string, sizeof(string), "Uspješno si obrisao zlataru ID: %d", id);
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

    format(string, sizeof(string), "{00C0FF}Naziv Firme: {FFFFFF}%s\n{00C0FF}Opis: {FFFFFF}%s\n{00C0FF}Vlasnik Firme: {FFFFFF}%s\n{00C0FF}ID: {FFFFFF}%d | {00C0FF}Cijena: {FFFFFF}$%d | {00C0FF}Level: {FFFFFF}%d\n{00C0FF}Cijena Ulaza: {FFFFFF}$%d\n{00C0FF}Budžet: {FFFFFF}$%d\n{00C0FF}Potrebni Produkti: {FFFFFF}%d | {00C0FF}Cijena Produkta: {FFFFFF}$%d",
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
stock UcitajZlataru()
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
    // Provjeravamo preko PVara da li je igrac uopšte unutar neke zlatare
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

    // Direktno uvecavamo budžet zlatare u kojoj se igrac nalazi
    ZlataInfo[zlatara_id][zBudzet] += ukupna_cijena;
    UpdateZlataruCP(zlatara_id); // Osvježava 3D text label sa novim budžetom
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

    // Odmah osvježi TextDraw zlata na ekranu
    UpdateZlatoTD(playerid);

    new string[128];
    format(string, sizeof(string), "Uspješno si kupio {0085FF}%d grama {FFFFFF}zlata za {00AA00}$%d.", kolicina, ukupna_cijena);
    SendClientMessage(playerid, 0xFFFFFFFF, string);
    return 1;
}

// --- 2. PRODAJA ZLATA ---
CMD:prodajzlato(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 601.5987, -1506.8588, 2.7801))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste na šalteru za prodaju zlata!");

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

    // Provjera da li zlatara ima dovoljno novca u budžetu da otkupi zlato od igraca
    if(zlatara_id != -1 && ZlataInfo[zlatara_id][zBudzet] < ukupna_zarada)
    {
        SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Zlatara trenutno nema dovoljno novca u budžetu da otkupi ovu kolicinu zlata!");
        return 1;
    }

    PlayerZlato[playerid] -= kolicina;
    UpdateZlatoTD(playerid);
    GivePlayerMoney(playerid, ukupna_zarada);

    // Oduzimamo novac iz budžeta zlatare jer isplacuje igraca
    if(zlatara_id != -1)
    {
        ZlataInfo[zlatara_id][zBudzet] -= ukupna_zarada;
        UpdateZlataruCP(zlatara_id);
        // SaveZlataru(zlatara_id);
    }

    new string[128];
    format(string, sizeof(string), "Uspješno si prodao {0085FF}%d grama {FFFFFF}zlata za {00AA00}$%d.", kolicina, ukupna_zarada);
    SendClientMessage(playerid, 0xFFFFFFFF, string);
    return 1;
}
CMD:kupisat(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 602.4924, -1519.7023, 2.7801))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste na pultu za prodaju satova!");

    // Postavljamo ID zlatare (ako imaš samo jednu zlataru, ostaje 0;
    // ako imaš više zlatara na serveru, ovdje upiši ID te konkretne zlatare)
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
stock InitRevolutionHud()
{
    // Geometrija, fontovi i boje su iz DTD.pwn. Dinamicke vrijednosti su PlayerTextDrawovi.
    TD_DTD[0] = TextDrawCreate(500.000000, 2.000000, "B");
    TextDrawFont(TD_DTD[0], 2);
    TextDrawLetterSize(TD_DTD[0], 0.395832, 2.749998);
    TextDrawTextSize(TD_DTD[0], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[0], 1);
    TextDrawSetShadow(TD_DTD[0], 3);
    TextDrawAlignment(TD_DTD[0], 1);
    TextDrawColor(TD_DTD[0], 1097458175);
    TextDrawBackgroundColor(TD_DTD[0], 255);
    TextDrawBoxColor(TD_DTD[0], 50);
    TextDrawUseBox(TD_DTD[0], 0);
    TextDrawSetProportional(TD_DTD[0], 1);
    TextDrawSetSelectable(TD_DTD[0], 0);
    TD_DTD[1] = TextDrawCreate(510.000000, 13.000000, "alkan");
    TextDrawFont(TD_DTD[1], 2);
    TextDrawLetterSize(TD_DTD[1], 0.291664, 1.200000);
    TextDrawTextSize(TD_DTD[1], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[1], 1);
    TextDrawSetShadow(TD_DTD[1], 3);
    TextDrawAlignment(TD_DTD[1], 1);
    TextDrawColor(TD_DTD[1], -1);
    TextDrawBackgroundColor(TD_DTD[1], 255);
    TextDrawBoxColor(TD_DTD[1], 50);
    TextDrawUseBox(TD_DTD[1], 0);
    TextDrawSetProportional(TD_DTD[1], 1);
    TextDrawSetSelectable(TD_DTD[1], 0);
    TD_DTD[2] = TextDrawCreate(552.000000, 2.000000, "R");
    TextDrawFont(TD_DTD[2], 2);
    TextDrawLetterSize(TD_DTD[2], 0.395000, 2.740000);
    TextDrawTextSize(TD_DTD[2], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[2], 1);
    TextDrawSetShadow(TD_DTD[2], 3);
    TextDrawAlignment(TD_DTD[2], 1);
    TextDrawColor(TD_DTD[2], 1097458175);
    TextDrawBackgroundColor(TD_DTD[2], 255);
    TextDrawBoxColor(TD_DTD[2], 50);
    TextDrawUseBox(TD_DTD[2], 0);
    TextDrawSetProportional(TD_DTD[2], 1);
    TextDrawSetSelectable(TD_DTD[2], 0);
    TD_DTD[3] = TextDrawCreate(562.000000, 13.000000, "evolution");
    TextDrawFont(TD_DTD[3], 2);
    TextDrawLetterSize(TD_DTD[3], 0.289999, 1.200000);
    TextDrawTextSize(TD_DTD[3], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[3], 1);
    TextDrawSetShadow(TD_DTD[3], 3);
    TextDrawAlignment(TD_DTD[3], 1);
    TextDrawColor(TD_DTD[3], -1);
    TextDrawBackgroundColor(TD_DTD[3], 255);
    TextDrawBoxColor(TD_DTD[3], 50);
    TextDrawUseBox(TD_DTD[3], 0);
    TextDrawSetProportional(TD_DTD[3], 1);
    TextDrawSetSelectable(TD_DTD[3], 0);
    TD_DTD[4] = TextDrawCreate(317.000000, 431.000000, "_");
    TextDrawFont(TD_DTD[4], 1);
    TextDrawLetterSize(TD_DTD[4], 0.649999, 1.749994);
    TextDrawTextSize(TD_DTD[4], 357.500000, 647.500000);
    TextDrawSetOutline(TD_DTD[4], 1);
    TextDrawSetShadow(TD_DTD[4], 0);
    TextDrawAlignment(TD_DTD[4], 2);
    TextDrawColor(TD_DTD[4], -1);
    TextDrawBackgroundColor(TD_DTD[4], 255);
    TextDrawBoxColor(TD_DTD[4], 421339391);
    TextDrawUseBox(TD_DTD[4], 1);
    TextDrawSetProportional(TD_DTD[4], 1);
    TextDrawSetSelectable(TD_DTD[4], 0);
    TD_DTD[5] = TextDrawCreate(317.000000, 430.000000, "_");
    TextDrawFont(TD_DTD[5], 1);
    TextDrawLetterSize(TD_DTD[5], 0.649999, -0.150003);
    TextDrawTextSize(TD_DTD[5], 357.500000, 647.500000);
    TextDrawSetOutline(TD_DTD[5], 1);
    TextDrawSetShadow(TD_DTD[5], 0);
    TextDrawAlignment(TD_DTD[5], 2);
    TextDrawColor(TD_DTD[5], 1097458175);
    TextDrawBackgroundColor(TD_DTD[5], 255);
    TextDrawBoxColor(TD_DTD[5], 1097458175);
    TextDrawUseBox(TD_DTD[5], 1);
    TextDrawSetProportional(TD_DTD[5], 1);
    TextDrawSetSelectable(TD_DTD[5], 0);
    TD_DTD[6] = TextDrawCreate(317.000000, 448.000000, "_");
    TextDrawFont(TD_DTD[6], 1);
    TextDrawLetterSize(TD_DTD[6], 0.649999, -0.100004);
    TextDrawTextSize(TD_DTD[6], 357.500000, 647.500000);
    TextDrawSetOutline(TD_DTD[6], 1);
    TextDrawSetShadow(TD_DTD[6], 0);
    TextDrawAlignment(TD_DTD[6], 2);
    TextDrawColor(TD_DTD[6], 1097458175);
    TextDrawBackgroundColor(TD_DTD[6], 255);
    TextDrawBoxColor(TD_DTD[6], 1097458175);
    TextDrawUseBox(TD_DTD[6], 1);
    TextDrawSetProportional(TD_DTD[6], 1);
    TextDrawSetSelectable(TD_DTD[6], 0);
    TD_DTD[7] = TextDrawCreate(17.000000, 426.000000, "BR");
    TextDrawFont(TD_DTD[7], 2);
    TextDrawLetterSize(TD_DTD[7], 0.600000, 2.349997);
    TextDrawTextSize(TD_DTD[7], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[7], 0);
    TextDrawSetShadow(TD_DTD[7], 0);
    TextDrawAlignment(TD_DTD[7], 1);
    TextDrawColor(TD_DTD[7], -1);
    TextDrawBackgroundColor(TD_DTD[7], 255);
    TextDrawBoxColor(TD_DTD[7], 50);
    TextDrawUseBox(TD_DTD[7], 0);
    TextDrawSetProportional(TD_DTD[7], 1);
    TextDrawSetSelectable(TD_DTD[7], 0);
    TD_DTD[8] = TextDrawCreate(48.000000, 430.000000, "BALKAN");
    TextDrawFont(TD_DTD[8], 2);
    TextDrawLetterSize(TD_DTD[8], 0.162496, 1.000000);
    TextDrawTextSize(TD_DTD[8], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[8], 0);
    TextDrawSetShadow(TD_DTD[8], 0);
    TextDrawAlignment(TD_DTD[8], 1);
    TextDrawColor(TD_DTD[8], 1097458175);
    TextDrawBackgroundColor(TD_DTD[8], 255);
    TextDrawBoxColor(TD_DTD[8], 50);
    TextDrawUseBox(TD_DTD[8], 0);
    TextDrawSetProportional(TD_DTD[8], 1);
    TextDrawSetSelectable(TD_DTD[8], 0);
    TD_DTD[9] = TextDrawCreate(48.000000, 436.000000, "REVOLUTION");
    TextDrawFont(TD_DTD[9], 2);
    TextDrawLetterSize(TD_DTD[9], 0.162496, 1.000000);
    TextDrawTextSize(TD_DTD[9], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[9], 0);
    TextDrawSetShadow(TD_DTD[9], 0);
    TextDrawAlignment(TD_DTD[9], 1);
    TextDrawColor(TD_DTD[9], 1097458175);
    TextDrawBackgroundColor(TD_DTD[9], 255);
    TextDrawBoxColor(TD_DTD[9], 50);
    TextDrawUseBox(TD_DTD[9], 0);
    TextDrawSetProportional(TD_DTD[9], 1);
    TextDrawSetSelectable(TD_DTD[9], 0);
    TD_DTD[10] = TextDrawCreate(112.000000, 433.000000, "ld_chat:badchat");
    TextDrawFont(TD_DTD[10], 4);
    TextDrawLetterSize(TD_DTD[10], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[10], 12.500000, 10.500000);
    TextDrawSetOutline(TD_DTD[10], 1);
    TextDrawSetShadow(TD_DTD[10], 2);
    TextDrawAlignment(TD_DTD[10], 1);
    TextDrawColor(TD_DTD[10], -1);
    TextDrawBackgroundColor(TD_DTD[10], 255);
    TextDrawBoxColor(TD_DTD[10], 50);
    TextDrawUseBox(TD_DTD[10], 1);
    TextDrawSetProportional(TD_DTD[10], 1);
    TextDrawSetSelectable(TD_DTD[10], 0);
    TD_DTD[11] = TextDrawCreate(0.000000, 430.000000, "LogoDiagonal:dia1");
    TextDrawFont(TD_DTD[11], 4);
    TextDrawLetterSize(TD_DTD[11], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[11], 17.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[11], 1);
    TextDrawSetShadow(TD_DTD[11], 0);
    TextDrawAlignment(TD_DTD[11], 1);
    TextDrawColor(TD_DTD[11], -1);
    TextDrawBackgroundColor(TD_DTD[11], 255);
    TextDrawBoxColor(TD_DTD[11], 50);
    TextDrawUseBox(TD_DTD[11], 1);
    TextDrawSetProportional(TD_DTD[11], 1);
    TextDrawSetSelectable(TD_DTD[11], 0);
    TD_DTD[12] = TextDrawCreate(90.000000, 430.000000, "LogoDiagonal:dia2");
    TextDrawFont(TD_DTD[12], 4);
    TextDrawLetterSize(TD_DTD[12], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[12], 17.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[12], 1);
    TextDrawSetShadow(TD_DTD[12], 0);
    TextDrawAlignment(TD_DTD[12], 1);
    TextDrawColor(TD_DTD[12], -1);
    TextDrawBackgroundColor(TD_DTD[12], 255);
    TextDrawBoxColor(TD_DTD[12], 50);
    TextDrawUseBox(TD_DTD[12], 1);
    TextDrawSetProportional(TD_DTD[12], 1);
    TextDrawSetSelectable(TD_DTD[12], 0);
    TD_DTD[13] = TextDrawCreate(127.000000, 434.500000, "PORUKE");
    TextDrawFont(TD_DTD[13], 2);
    TextDrawLetterSize(TD_DTD[13], 0.237498, 0.849999);
    TextDrawTextSize(TD_DTD[13], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[13], 0);
    TextDrawSetShadow(TD_DTD[13], 0);
    TextDrawAlignment(TD_DTD[13], 1);
    TextDrawColor(TD_DTD[13], -1);
    TextDrawBackgroundColor(TD_DTD[13], 255);
    TextDrawBoxColor(TD_DTD[13], 50);
    TextDrawUseBox(TD_DTD[13], 0);
    TextDrawSetProportional(TD_DTD[13], 1);
    TextDrawSetSelectable(TD_DTD[13], 0);
    TD_DTD[14] = TextDrawCreate(93.000000, 430.000000, "LogoDiagonal:dia2");
    TextDrawFont(TD_DTD[14], 4);
    TextDrawLetterSize(TD_DTD[14], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[14], 17.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[14], 1);
    TextDrawSetShadow(TD_DTD[14], 0);
    TextDrawAlignment(TD_DTD[14], 1);
    TextDrawColor(TD_DTD[14], -1);
    TextDrawBackgroundColor(TD_DTD[14], 255);
    TextDrawBoxColor(TD_DTD[14], 50);
    TextDrawUseBox(TD_DTD[14], 1);
    TextDrawSetProportional(TD_DTD[14], 1);
    TextDrawSetSelectable(TD_DTD[14], 0);
    TD_DTD[15] = TextDrawCreate(353.000000, 437.000000, "LogoDiagonal:dia3");
    TextDrawFont(TD_DTD[15], 4);
    TextDrawLetterSize(TD_DTD[15], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[15], 3.000000, 3.000000);
    TextDrawSetOutline(TD_DTD[15], 1);
    TextDrawSetShadow(TD_DTD[15], 0);
    TextDrawAlignment(TD_DTD[15], 1);
    TextDrawColor(TD_DTD[15], -1);
    TextDrawBackgroundColor(TD_DTD[15], 255);
    TextDrawBoxColor(TD_DTD[15], 50);
    TextDrawUseBox(TD_DTD[15], 1);
    TextDrawSetProportional(TD_DTD[15], 1);
    TextDrawSetSelectable(TD_DTD[15], 0);
    TD_DTD[16] = TextDrawCreate(358.000000, 437.000000, "LogoDiagonal:dia3");
    TextDrawFont(TD_DTD[16], 4);
    TextDrawLetterSize(TD_DTD[16], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[16], 3.000000, 3.000000);
    TextDrawSetOutline(TD_DTD[16], 1);
    TextDrawSetShadow(TD_DTD[16], 0);
    TextDrawAlignment(TD_DTD[16], 1);
    TextDrawColor(TD_DTD[16], -1);
    TextDrawBackgroundColor(TD_DTD[16], 255);
    TextDrawBoxColor(TD_DTD[16], 50);
    TextDrawUseBox(TD_DTD[16], 1);
    TextDrawSetProportional(TD_DTD[16], 1);
    TextDrawSetSelectable(TD_DTD[16], 0);
    TD_DTD[17] = TextDrawCreate(363.000000, 437.000000, "LogoDiagonal:dia3");
    TextDrawFont(TD_DTD[17], 4);
    TextDrawLetterSize(TD_DTD[17], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[17], 3.000000, 3.000000);
    TextDrawSetOutline(TD_DTD[17], 1);
    TextDrawSetShadow(TD_DTD[17], 0);
    TextDrawAlignment(TD_DTD[17], 1);
    TextDrawColor(TD_DTD[17], -1);
    TextDrawBackgroundColor(TD_DTD[17], 255);
    TextDrawBoxColor(TD_DTD[17], 50);
    TextDrawUseBox(TD_DTD[17], 1);
    TextDrawSetProportional(TD_DTD[17], 1);
    TextDrawSetSelectable(TD_DTD[17], 0);
    TD_DTD[18] = TextDrawCreate(301.000000, 211.000000, "Turbo:tur1");
    TextDrawFont(TD_DTD[18], 4);
    TextDrawLetterSize(TD_DTD[18], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[18], 17.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[18], 1);
    TextDrawSetShadow(TD_DTD[18], 0);
    TextDrawAlignment(TD_DTD[18], 1);
    TextDrawColor(TD_DTD[18], -1);
    TextDrawBackgroundColor(TD_DTD[18], 255);
    TextDrawBoxColor(TD_DTD[18], 50);
    TextDrawUseBox(TD_DTD[18], 1);
    TextDrawSetProportional(TD_DTD[18], 1);
    TextDrawSetSelectable(TD_DTD[18], 0);
    TD_DTD[19] = TextDrawCreate(369.000000, 431.500000, "Krug:krug1");
    TextDrawFont(TD_DTD[19], 4);
    TextDrawLetterSize(TD_DTD[19], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[19], 13.500000, 13.500000);
    TextDrawSetOutline(TD_DTD[19], 1);
    TextDrawSetShadow(TD_DTD[19], 0);
    TextDrawAlignment(TD_DTD[19], 1);
    TextDrawColor(TD_DTD[19], -1);
    TextDrawBackgroundColor(TD_DTD[19], 255);
    TextDrawBoxColor(TD_DTD[19], 50);
    TextDrawUseBox(TD_DTD[19], 1);
    TextDrawSetProportional(TD_DTD[19], 1);
    TextDrawSetSelectable(TD_DTD[19], 0);
    TD_DTD[20] = TextDrawCreate(366.000000, 431.500000, "Preview_Model");
    TextDrawFont(TD_DTD[20], 5);
    TextDrawLetterSize(TD_DTD[20], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[20], 19.000000, 13.500000);
    TextDrawSetOutline(TD_DTD[20], 0);
    TextDrawSetShadow(TD_DTD[20], 0);
    TextDrawAlignment(TD_DTD[20], 1);
    TextDrawColor(TD_DTD[20], -1);
    TextDrawBackgroundColor(TD_DTD[20], -256);
    TextDrawBoxColor(TD_DTD[20], 0);
    TextDrawUseBox(TD_DTD[20], 0);
    TextDrawSetProportional(TD_DTD[20], 1);
    TextDrawSetSelectable(TD_DTD[20], 0);
    TextDrawSetPreviewModel(TD_DTD[20], 1239);
    TextDrawSetPreviewRot(TD_DTD[20], -10.000000, 0.000000, 0.000000, 1.000000);
    TextDrawSetPreviewVehCol(TD_DTD[20], 1, 1);
    TD_DTD[21] = TextDrawCreate(418.000000, 432.000000, "HAPPY JOB:");
    TextDrawFont(TD_DTD[21], 2);
    TextDrawLetterSize(TD_DTD[21], 0.133331, 0.699998);
    TextDrawTextSize(TD_DTD[21], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[21], 0);
    TextDrawSetShadow(TD_DTD[21], 0);
    TextDrawAlignment(TD_DTD[21], 3);
    TextDrawColor(TD_DTD[21], -1);
    TextDrawBackgroundColor(TD_DTD[21], 255);
    TextDrawBoxColor(TD_DTD[21], 50);
    TextDrawUseBox(TD_DTD[21], 0);
    TextDrawSetProportional(TD_DTD[21], 1);
    TextDrawSetSelectable(TD_DTD[21], 0);
    TD_DTD[22] = TextDrawCreate(472.000000, 438.000000, "USKORO");
    TextDrawFont(TD_DTD[22], 2);
    TextDrawLetterSize(TD_DTD[22], 0.158333, 0.600000);
    TextDrawTextSize(TD_DTD[22], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[22], 0);
    TextDrawSetShadow(TD_DTD[22], 0);
    TextDrawAlignment(TD_DTD[22], 3);
    TextDrawColor(TD_DTD[22], -1);
    TextDrawBackgroundColor(TD_DTD[22], 255);
    TextDrawBoxColor(TD_DTD[22], 50);
    TextDrawUseBox(TD_DTD[22], 0);
    TextDrawSetProportional(TD_DTD[22], 1);
    TextDrawSetSelectable(TD_DTD[22], 0);
    TD_DTD[23] = TextDrawCreate(475.000000, 431.500000, "Krug:krug1");
    TextDrawFont(TD_DTD[23], 4);
    TextDrawLetterSize(TD_DTD[23], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[23], 13.500000, 13.500000);
    TextDrawSetOutline(TD_DTD[23], 1);
    TextDrawSetShadow(TD_DTD[23], 0);
    TextDrawAlignment(TD_DTD[23], 1);
    TextDrawColor(TD_DTD[23], -1);
    TextDrawBackgroundColor(TD_DTD[23], 255);
    TextDrawBoxColor(TD_DTD[23], 50);
    TextDrawUseBox(TD_DTD[23], 1);
    TextDrawSetProportional(TD_DTD[23], 1);
    TextDrawSetSelectable(TD_DTD[23], 0);
    TD_DTD[24] = TextDrawCreate(476.000000, 433.000000, "ld_grav:timer");
    TextDrawFont(TD_DTD[24], 4);
    TextDrawLetterSize(TD_DTD[24], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[24], 11.500000, 10.500000);
    TextDrawSetOutline(TD_DTD[24], 1);
    TextDrawSetShadow(TD_DTD[24], 0);
    TextDrawAlignment(TD_DTD[24], 1);
    TextDrawColor(TD_DTD[24], -1);
    TextDrawBackgroundColor(TD_DTD[24], 255);
    TextDrawBoxColor(TD_DTD[24], 50);
    TextDrawUseBox(TD_DTD[24], 1);
    TextDrawSetProportional(TD_DTD[24], 1);
    TextDrawSetSelectable(TD_DTD[24], 0);
    TD_DTD[27] = TextDrawCreate(560.000000, 430.000000, "LogoDiagonal:dia2");
    TextDrawFont(TD_DTD[27], 4);
    TextDrawLetterSize(TD_DTD[27], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[27], 17.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[27], 1);
    TextDrawSetShadow(TD_DTD[27], 0);
    TextDrawAlignment(TD_DTD[27], 1);
    TextDrawColor(TD_DTD[27], -1);
    TextDrawBackgroundColor(TD_DTD[27], 255);
    TextDrawBoxColor(TD_DTD[27], 50);
    TextDrawUseBox(TD_DTD[27], 1);
    TextDrawSetProportional(TD_DTD[27], 1);
    TextDrawSetSelectable(TD_DTD[27], 0);
    TD_DTD[28] = TextDrawCreate(563.000000, 430.000000, "LogoDiagonal:dia2");
    TextDrawFont(TD_DTD[28], 4);
    TextDrawLetterSize(TD_DTD[28], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[28], 17.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[28], 1);
    TextDrawSetShadow(TD_DTD[28], 0);
    TextDrawAlignment(TD_DTD[28], 1);
    TextDrawColor(TD_DTD[28], -1);
    TextDrawBackgroundColor(TD_DTD[28], 255);
    TextDrawBoxColor(TD_DTD[28], 50);
    TextDrawUseBox(TD_DTD[28], 1);
    TextDrawSetProportional(TD_DTD[28], 1);
    TextDrawSetSelectable(TD_DTD[28], 0);
    TD_DTD[29] = TextDrawCreate(575.000000, 428.000000, "V");
    TextDrawFont(TD_DTD[29], 2);
    TextDrawLetterSize(TD_DTD[29], 0.412499, 2.000000);
    TextDrawTextSize(TD_DTD[29], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[29], 0);
    TextDrawSetShadow(TD_DTD[29], 0);
    TextDrawAlignment(TD_DTD[29], 1);
    TextDrawColor(TD_DTD[29], -1);
    TextDrawBackgroundColor(TD_DTD[29], 255);
    TextDrawBoxColor(TD_DTD[29], 50);
    TextDrawUseBox(TD_DTD[29], 0);
    TextDrawSetProportional(TD_DTD[29], 1);
    TextDrawSetSelectable(TD_DTD[29], 0);
    TD_DTD[30] = TextDrawCreate(584.000000, 436.000000, "ERSION:");
    TextDrawFont(TD_DTD[30], 2);
    TextDrawLetterSize(TD_DTD[30], 0.187500, 0.949998);
    TextDrawTextSize(TD_DTD[30], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[30], 0);
    TextDrawSetShadow(TD_DTD[30], 0);
    TextDrawAlignment(TD_DTD[30], 1);
    TextDrawColor(TD_DTD[30], 1097458175);
    TextDrawBackgroundColor(TD_DTD[30], 255);
    TextDrawBoxColor(TD_DTD[30], 50);
    TextDrawUseBox(TD_DTD[30], 0);
    TextDrawSetProportional(TD_DTD[30], 1);
    TextDrawSetSelectable(TD_DTD[30], 0);
    TD_DTD[31] = TextDrawCreate(611.000000, 432.000000, "V1.0");
    TextDrawFont(TD_DTD[31], 2);
    TextDrawLetterSize(TD_DTD[31], 0.125000, 0.800000);
    TextDrawTextSize(TD_DTD[31], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[31], 0);
    TextDrawSetShadow(TD_DTD[31], 0);
    TextDrawAlignment(TD_DTD[31], 1);
    TextDrawColor(TD_DTD[31], -1);
    TextDrawBackgroundColor(TD_DTD[31], 255);
    TextDrawBoxColor(TD_DTD[31], 50);
    TextDrawUseBox(TD_DTD[31], 0);
    TextDrawSetProportional(TD_DTD[31], 1);
    TextDrawSetSelectable(TD_DTD[31], 0);
    TD_DTD[32] = TextDrawCreate(640.000000, 430.000000, "LogoDiagonal:dia1");
    TextDrawFont(TD_DTD[32], 4);
    TextDrawLetterSize(TD_DTD[32], 0.600000, 2.000000);
    TextDrawTextSize(TD_DTD[32], -17.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[32], 1);
    TextDrawSetShadow(TD_DTD[32], 0);
    TextDrawAlignment(TD_DTD[32], 1);
    TextDrawColor(TD_DTD[32], -1);
    TextDrawBackgroundColor(TD_DTD[32], 255);
    TextDrawBoxColor(TD_DTD[32], 50);
    TextDrawUseBox(TD_DTD[32], 1);
    TextDrawSetProportional(TD_DTD[32], 1);
    TextDrawSetSelectable(TD_DTD[32], 0);
    TD_DTD[33] = TextDrawCreate(497.000000, 105.000000, "BANK:");
    TextDrawFont(TD_DTD[33], 2);
    TextDrawLetterSize(TD_DTD[33], 0.237499, 1.000000);
    TextDrawTextSize(TD_DTD[33], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[33], 1);
    TextDrawSetShadow(TD_DTD[33], 0);
    TextDrawAlignment(TD_DTD[33], 1);
    TextDrawColor(TD_DTD[33], 1097458175);
    TextDrawBackgroundColor(TD_DTD[33], 255);
    TextDrawBoxColor(TD_DTD[33], 50);
    TextDrawUseBox(TD_DTD[33], 0);
    TextDrawSetProportional(TD_DTD[33], 1);
    TextDrawSetSelectable(TD_DTD[33], 0);
    TD_DTD[35] = TextDrawCreate(497.000000, 117.000000, "EURO:");
    TextDrawFont(TD_DTD[35], 2);
    TextDrawLetterSize(TD_DTD[35], 0.237499, 1.000000);
    TextDrawTextSize(TD_DTD[35], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[35], 1);
    TextDrawSetShadow(TD_DTD[35], 0);
    TextDrawAlignment(TD_DTD[35], 1);
    TextDrawColor(TD_DTD[35], -905198081);
    TextDrawBackgroundColor(TD_DTD[35], 255);
    TextDrawBoxColor(TD_DTD[35], 50);
    TextDrawUseBox(TD_DTD[35], 0);
    TextDrawSetProportional(TD_DTD[35], 1);
    TextDrawSetSelectable(TD_DTD[35], 0);
    TD_DTD[37] = TextDrawCreate(497.000000, 129.000000, "ZLATO:");
    TextDrawFont(TD_DTD[37], 2);
    TextDrawLetterSize(TD_DTD[37], 0.237499, 1.000000);
    TextDrawTextSize(TD_DTD[37], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[37], 1);
    TextDrawSetShadow(TD_DTD[37], 0);
    TextDrawAlignment(TD_DTD[37], 1);
    TextDrawColor(TD_DTD[37], -65281);
    TextDrawBackgroundColor(TD_DTD[37], 255);
    TextDrawBoxColor(TD_DTD[37], 50);
    TextDrawUseBox(TD_DTD[37], 0);
    TextDrawSetProportional(TD_DTD[37], 1);
    TextDrawSetSelectable(TD_DTD[37], 0);
    TD_DTD[41] = TextDrawCreate(560.000000, 343.899993, "_");
    TextDrawFont(TD_DTD[41], 1);
    TextDrawLetterSize(TD_DTD[41], 0.600000, 8.399991);
    TextDrawTextSize(TD_DTD[41], 317.500000, 130.000000);
    TextDrawSetOutline(TD_DTD[41], 1);
    TextDrawSetShadow(TD_DTD[41], 0);
    TextDrawAlignment(TD_DTD[41], 2);
    TextDrawColor(TD_DTD[41], -1);
    TextDrawBackgroundColor(TD_DTD[41], 255);
    TextDrawBoxColor(TD_DTD[41], 421339391);
    TextDrawUseBox(TD_DTD[41], 1);
    TextDrawSetProportional(TD_DTD[41], 1);
    TextDrawSetSelectable(TD_DTD[41], 0);
    TD_DTD[42] = TextDrawCreate(493.000000, 344.000000, "_");
    TextDrawFont(TD_DTD[42], 1);
    TextDrawLetterSize(TD_DTD[42], 0.600000, 8.399991);
    TextDrawTextSize(TD_DTD[42], 306.500000, -4.000000);
    TextDrawSetOutline(TD_DTD[42], 1);
    TextDrawSetShadow(TD_DTD[42], 0);
    TextDrawAlignment(TD_DTD[42], 2);
    TextDrawColor(TD_DTD[42], -1);
    TextDrawBackgroundColor(TD_DTD[42], 255);
    TextDrawBoxColor(TD_DTD[42], 1097458175);
    TextDrawUseBox(TD_DTD[42], 1);
    TextDrawSetProportional(TD_DTD[42], 1);
    TextDrawSetSelectable(TD_DTD[42], 0);
    TD_DTD[43] = TextDrawCreate(558.900024, 423.000000, "_");
    TextDrawFont(TD_DTD[43], 1);
    TextDrawLetterSize(TD_DTD[43], 0.600000, -0.150000);
    TextDrawTextSize(TD_DTD[43], 479.000000, 130.500000);
    TextDrawSetOutline(TD_DTD[43], 1);
    TextDrawSetShadow(TD_DTD[43], 0);
    TextDrawAlignment(TD_DTD[43], 2);
    TextDrawColor(TD_DTD[43], -1);
    TextDrawBackgroundColor(TD_DTD[43], 255);
    TextDrawBoxColor(TD_DTD[43], 1097458175);
    TextDrawUseBox(TD_DTD[43], 1);
    TextDrawSetProportional(TD_DTD[43], 1);
    TextDrawSetSelectable(TD_DTD[43], 0);
    TD_DTD[44] = TextDrawCreate(560.000000, 363.000000, "_");
    TextDrawFont(TD_DTD[44], 1);
    TextDrawLetterSize(TD_DTD[44], 0.600000, -0.150000);
    TextDrawTextSize(TD_DTD[44], 479.000000, 130.500000);
    TextDrawSetOutline(TD_DTD[44], 1);
    TextDrawSetShadow(TD_DTD[44], 0);
    TextDrawAlignment(TD_DTD[44], 2);
    TextDrawColor(TD_DTD[44], -1);
    TextDrawBackgroundColor(TD_DTD[44], 255);
    TextDrawBoxColor(TD_DTD[44], 1097458175);
    TextDrawUseBox(TD_DTD[44], 1);
    TextDrawSetProportional(TD_DTD[44], 1);
    TextDrawSetSelectable(TD_DTD[44], 0);
    TD_DTD[45] = TextDrawCreate(558.900024, 342.000000, "_");
    TextDrawFont(TD_DTD[45], 1);
    TextDrawLetterSize(TD_DTD[45], 0.600000, -0.150000);
    TextDrawTextSize(TD_DTD[45], 479.000000, 130.500000);
    TextDrawSetOutline(TD_DTD[45], 1);
    TextDrawSetShadow(TD_DTD[45], 0);
    TextDrawAlignment(TD_DTD[45], 2);
    TextDrawColor(TD_DTD[45], -1);
    TextDrawBackgroundColor(TD_DTD[45], 255);
    TextDrawBoxColor(TD_DTD[45], 1097458175);
    TextDrawUseBox(TD_DTD[45], 1);
    TextDrawSetProportional(TD_DTD[45], 1);
    TextDrawSetSelectable(TD_DTD[45], 0);
    TD_DTD[47] = TextDrawCreate(526.000000, 364.000000, "BRZINA:");
    TextDrawFont(TD_DTD[47], 2);
    TextDrawLetterSize(TD_DTD[47], 0.174999, 1.299998);
    TextDrawTextSize(TD_DTD[47], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[47], 0);
    TextDrawSetShadow(TD_DTD[47], 1);
    TextDrawAlignment(TD_DTD[47], 3);
    TextDrawColor(TD_DTD[47], -1);
    TextDrawBackgroundColor(TD_DTD[47], 255);
    TextDrawBoxColor(TD_DTD[47], 50);
    TextDrawUseBox(TD_DTD[47], 0);
    TextDrawSetProportional(TD_DTD[47], 1);
    TextDrawSetSelectable(TD_DTD[47], 0);
    TD_DTD[49] = TextDrawCreate(558.000000, 364.000000, "KM/H");
    TextDrawFont(TD_DTD[49], 2);
    TextDrawLetterSize(TD_DTD[49], 0.174999, 1.299998);
    TextDrawTextSize(TD_DTD[49], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[49], 0);
    TextDrawSetShadow(TD_DTD[49], 1);
    TextDrawAlignment(TD_DTD[49], 3);
    TextDrawColor(TD_DTD[49], -1);
    TextDrawBackgroundColor(TD_DTD[49], 255);
    TextDrawBoxColor(TD_DTD[49], 50);
    TextDrawUseBox(TD_DTD[49], 0);
    TextDrawSetProportional(TD_DTD[49], 1);
    TextDrawSetSelectable(TD_DTD[49], 0);
    TD_DTD[50] = TextDrawCreate(527.000000, 374.000000, "GORIVO:");
    TextDrawFont(TD_DTD[50], 2);
    TextDrawLetterSize(TD_DTD[50], 0.174999, 1.299998);
    TextDrawTextSize(TD_DTD[50], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[50], 0);
    TextDrawSetShadow(TD_DTD[50], 1);
    TextDrawAlignment(TD_DTD[50], 3);
    TextDrawColor(TD_DTD[50], -1);
    TextDrawBackgroundColor(TD_DTD[50], 255);
    TextDrawBoxColor(TD_DTD[50], 50);
    TextDrawUseBox(TD_DTD[50], 0);
    TextDrawSetProportional(TD_DTD[50], 1);
    TextDrawSetSelectable(TD_DTD[50], 0);
    TD_DTD[51] = TextDrawCreate(524.000000, 384.000000, "VRSTA:");
    TextDrawFont(TD_DTD[51], 2);
    TextDrawLetterSize(TD_DTD[51], 0.174999, 1.299998);
    TextDrawTextSize(TD_DTD[51], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[51], 0);
    TextDrawSetShadow(TD_DTD[51], 1);
    TextDrawAlignment(TD_DTD[51], 3);
    TextDrawColor(TD_DTD[51], -1);
    TextDrawBackgroundColor(TD_DTD[51], 255);
    TextDrawBoxColor(TD_DTD[51], 50);
    TextDrawUseBox(TD_DTD[51], 0);
    TextDrawSetProportional(TD_DTD[51], 1);
    TextDrawSetSelectable(TD_DTD[51], 0);
    TD_DTD[52] = TextDrawCreate(537.000000, 394.000000, "KILOMETRI:");
    TextDrawFont(TD_DTD[52], 2);
    TextDrawLetterSize(TD_DTD[52], 0.174999, 1.299998);
    TextDrawTextSize(TD_DTD[52], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[52], 0);
    TextDrawSetShadow(TD_DTD[52], 1);
    TextDrawAlignment(TD_DTD[52], 3);
    TextDrawColor(TD_DTD[52], -1);
    TextDrawBackgroundColor(TD_DTD[52], 255);
    TextDrawBoxColor(TD_DTD[52], 50);
    TextDrawUseBox(TD_DTD[52], 0);
    TextDrawSetProportional(TD_DTD[52], 1);
    TextDrawSetSelectable(TD_DTD[52], 0);
    TD_DTD[53] = TextDrawCreate(498.000000, 405.000000, "KVAROVI:");
    TextDrawFont(TD_DTD[53], 2);
    TextDrawLetterSize(TD_DTD[53], 0.174999, 1.299998);
    TextDrawTextSize(TD_DTD[53], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[53], 0);
    TextDrawSetShadow(TD_DTD[53], 1);
    TextDrawAlignment(TD_DTD[53], 1);
    TextDrawColor(TD_DTD[53], -1);
    TextDrawBackgroundColor(TD_DTD[53], 255);
    TextDrawBoxColor(TD_DTD[53], 50);
    TextDrawUseBox(TD_DTD[53], 0);
    TextDrawSetProportional(TD_DTD[53], 1);
    TextDrawSetSelectable(TD_DTD[53], 0);
    TD_DTD[56] = TextDrawCreate(626.000000, 342.000000, "_");
    TextDrawFont(TD_DTD[56], 1);
    TextDrawLetterSize(TD_DTD[56], 0.600000, 8.849993);
    TextDrawTextSize(TD_DTD[56], 306.500000, -4.000000);
    TextDrawSetOutline(TD_DTD[56], 1);
    TextDrawSetShadow(TD_DTD[56], 0);
    TextDrawAlignment(TD_DTD[56], 2);
    TextDrawColor(TD_DTD[56], -1);
    TextDrawBackgroundColor(TD_DTD[56], 255);
    TextDrawBoxColor(TD_DTD[56], 1097458175);
    TextDrawUseBox(TD_DTD[56], 1);
    TextDrawSetProportional(TD_DTD[56], 1);
    TextDrawSetSelectable(TD_DTD[56], 0);
    TD_DTD[61] = TextDrawCreate(538.000000, 405.000000, "/");
    TextDrawFont(TD_DTD[61], 2);
    TextDrawLetterSize(TD_DTD[61], 0.174999, 1.299998);
    TextDrawTextSize(TD_DTD[61], 400.000000, 17.000000);
    TextDrawSetOutline(TD_DTD[61], 0);
    TextDrawSetShadow(TD_DTD[61], 1);
    TextDrawAlignment(TD_DTD[61], 1);
    TextDrawColor(TD_DTD[61], -1);
    TextDrawBackgroundColor(TD_DTD[61], 255);
    TextDrawBoxColor(TD_DTD[61], 50);
    TextDrawUseBox(TD_DTD[61], 0);
    TextDrawSetProportional(TD_DTD[61], 1);
    TextDrawSetSelectable(TD_DTD[61], 0);
    TD_HudPoruka = TD_DTD[13];
    return 1;
}

stock UpdateHudTip(tip)
{
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
        case 17: TextDrawSetString(TD_HudPoruka, "SARADJUJ SA SVOJOM ORG");
        case 18: TextDrawSetString(TD_HudPoruka, "KORISTI ANIMACIJE ZA PROVOD");
        case 19: TextDrawSetString(TD_HudPoruka, "POSJETI BUTIK ODJECE");
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
    TD_HudDatum[playerid] = CreatePlayerTextDraw(playerid, 509.000000, 434.000000, "00.00.0000");
    PlayerTextDrawFont(playerid, TD_HudDatum[playerid], 2);
    PlayerTextDrawLetterSize(playerid, TD_HudDatum[playerid], 0.158332, 0.899999);
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
    TD_WantedHint[playerid] = CreatePlayerTextDraw(playerid, 505.000000, 416.000000, "IMATE 1 WANTED LEVELA  /DOSIJE");
    PlayerTextDrawFont(playerid, TD_WantedHint[playerid], 2);
    PlayerTextDrawLetterSize(playerid, TD_WantedHint[playerid], 0.195000, 0.950000);
    PlayerTextDrawAlignment(playerid, TD_WantedHint[playerid], 2);
    PlayerTextDrawColor(playerid, TD_WantedHint[playerid], 0xFF7777FF);
    PlayerTextDrawSetOutline(playerid, TD_WantedHint[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, TD_WantedHint[playerid], 0x000000FF);
    PlayerTextDrawSetProportional(playerid, TD_WantedHint[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TD_WantedHint[playerid], 0);
    TD_HudVrijeme[playerid] = CreatePlayerTextDraw(playerid, 543.000000, 434.000000, "00:00");
    PlayerTextDrawFont(playerid, TD_HudVrijeme[playerid], 2);
    PlayerTextDrawLetterSize(playerid, TD_HudVrijeme[playerid], 0.158000, 0.899999);
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
    TD_NovacPlavi[playerid] = CreatePlayerTextDraw(playerid, 532.000000, 105.000000, "0$");
    PlayerTextDrawFont(playerid, TD_NovacPlavi[playerid], 2);
    PlayerTextDrawLetterSize(playerid, TD_NovacPlavi[playerid], 0.237499, 1.000000);
    PlayerTextDrawTextSize(playerid, TD_NovacPlavi[playerid], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_NovacPlavi[playerid], 1);
    PlayerTextDrawSetShadow(playerid, TD_NovacPlavi[playerid], 0);
    PlayerTextDrawAlignment(playerid, TD_NovacPlavi[playerid], 1);
    PlayerTextDrawColor(playerid, TD_NovacPlavi[playerid], 1097458175);
    PlayerTextDrawBackgroundColor(playerid, TD_NovacPlavi[playerid], 255);
    PlayerTextDrawBoxColor(playerid, TD_NovacPlavi[playerid], 50);
    PlayerTextDrawUseBox(playerid, TD_NovacPlavi[playerid], 0);
    PlayerTextDrawSetProportional(playerid, TD_NovacPlavi[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TD_NovacPlavi[playerid], 0);
    TD_Euro[playerid] = CreatePlayerTextDraw(playerid, 532.000000, 117.000000, "000000000");
    PlayerTextDrawFont(playerid, TD_Euro[playerid], 2);
    PlayerTextDrawLetterSize(playerid, TD_Euro[playerid], 0.237499, 1.000000);
    PlayerTextDrawTextSize(playerid, TD_Euro[playerid], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Euro[playerid], 1);
    PlayerTextDrawSetShadow(playerid, TD_Euro[playerid], 0);
    PlayerTextDrawAlignment(playerid, TD_Euro[playerid], 1);
    PlayerTextDrawColor(playerid, TD_Euro[playerid], -905198081);
    PlayerTextDrawBackgroundColor(playerid, TD_Euro[playerid], 255);
    PlayerTextDrawBoxColor(playerid, TD_Euro[playerid], 50);
    PlayerTextDrawUseBox(playerid, TD_Euro[playerid], 0);
    PlayerTextDrawSetProportional(playerid, TD_Euro[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Euro[playerid], 0);
    TD_Zlato[playerid] = CreatePlayerTextDraw(playerid, 539.000000, 129.000000, "000000000");
    PlayerTextDrawFont(playerid, TD_Zlato[playerid], 2);
    PlayerTextDrawLetterSize(playerid, TD_Zlato[playerid], 0.237499, 1.000000);
    PlayerTextDrawTextSize(playerid, TD_Zlato[playerid], 400.000000, 17.000000);
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
    PlayerTextDrawLetterSize(playerid, TD_Grad[playerid], 0.237499, 1.000000);
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
    PlayerTextDrawLetterSize(playerid, TD_Lokacija[playerid], 0.190000, 0.900000);
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
    TD_Vozilo[playerid][1] = CreatePlayerTextDraw(playerid, 527.000000, 364.000000, "100");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][1], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][1], 0.174999, 1.299998);
    PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][1], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][1], 1);
    PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][1], 1);
    PlayerTextDrawColor(playerid, TD_Vozilo[playerid][1], 1433087999);
    PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][1], 255);
    PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][1], 0);
    TD_Vozilo[playerid][2] = CreatePlayerTextDraw(playerid, 544.000000, 374.000000, "70.0");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][2], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][2], 0.174999, 1.299998);
    PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][2], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][2], 1);
    PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][2], 3);
    PlayerTextDrawColor(playerid, TD_Vozilo[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][2], 255);
    PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][2], 50);
    PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][2], 0);
    PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][2], 0);
    TD_Vozilo[playerid][3] = CreatePlayerTextDraw(playerid, 525.000000, 384.000000, "BENZIN");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][3], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][3], 0.174999, 1.299998);
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
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][4], 0.174999, 1.299998);
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
    TD_Vozilo[playerid][5] = CreatePlayerTextDraw(playerid, 533.000000, 405.000000, "5");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][5], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][5], 0.174999, 1.299998);
    PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][5], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][5], 1);
    PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][5], 1);
    PlayerTextDrawColor(playerid, TD_Vozilo[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][5], 255);
    PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][5], 50);
    PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][5], 0);
    PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][5], 0);
    TD_Vozilo[playerid][6] = CreatePlayerTextDraw(playerid, 564.000000, 374.000000, "70.0");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][6], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][6], 0.174999, 1.299998);
    PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][6], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][6], 1);
    PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][6], 3);
    PlayerTextDrawColor(playerid, TD_Vozilo[playerid][6], -16776961);
    PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][6], 255);
    PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][6], 50);
    PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][6], 0);
    PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][6], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][6], 0);
    TD_Vozilo[playerid][7] = CreatePlayerTextDraw(playerid, 542.000000, 405.000000, "5");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][7], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][7], 0.174999, 1.299998);
    PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][7], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][7], 0);
    PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][7], 1);
    PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][7], 1);
    PlayerTextDrawColor(playerid, TD_Vozilo[playerid][7], -16776961);
    PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][7], 255);
    PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][7], 50);
    PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][7], 0);
    PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][7], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][7], 0);
    TD_Vozilo[playerid][8] = CreatePlayerTextDraw(playerid, 548.000000, 374.000000, "/");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][8], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][8], 0.174999, 1.299998);
    PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][8], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][8], 0);
    PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][8], 1);
    PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][8], 3);
    PlayerTextDrawColor(playerid, TD_Vozilo[playerid][8], -1);
    PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][8], 255);
    PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][8], 50);
    PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][8], 0);
    PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][8], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][8], 0);
    TD_Vozilo[playerid][9] = CreatePlayerTextDraw(playerid, 548.000000, 374.000000, "250.0");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][9], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][9], 0.174999, 1.299998);
    PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][9], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][9], 1);
    PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][9], 3);
    PlayerTextDrawColor(playerid, TD_Vozilo[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][9], 255);
    PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][9], 50);
    PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][9], 0);
    PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][9], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][9], 0);
    TD_Vozilo[playerid][10] = CreatePlayerTextDraw(playerid, 552.000000, 374.000000, "/");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][10], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][10], 0.174999, 1.299998);
    PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][10], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][10], 0);
    PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][10], 1);
    PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][10], 3);
    PlayerTextDrawColor(playerid, TD_Vozilo[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][10], 255);
    PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][10], 50);
    PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][10], 0);
    PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][10], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][10], 0);
    TD_Vozilo[playerid][11] = CreatePlayerTextDraw(playerid, 573.000000, 374.000000, "250.0");
    PlayerTextDrawFont(playerid, TD_Vozilo[playerid][11], 2);
    PlayerTextDrawLetterSize(playerid, TD_Vozilo[playerid][11], 0.174999, 1.299998);
    PlayerTextDrawTextSize(playerid, TD_Vozilo[playerid][11], 400.000000, 17.000000);
    PlayerTextDrawSetOutline(playerid, TD_Vozilo[playerid][11], 0);
    PlayerTextDrawSetShadow(playerid, TD_Vozilo[playerid][11], 1);
    PlayerTextDrawAlignment(playerid, TD_Vozilo[playerid][11], 3);
    PlayerTextDrawColor(playerid, TD_Vozilo[playerid][11], -16776961);
    PlayerTextDrawBackgroundColor(playerid, TD_Vozilo[playerid][11], 255);
    PlayerTextDrawBoxColor(playerid, TD_Vozilo[playerid][11], 50);
    PlayerTextDrawUseBox(playerid, TD_Vozilo[playerid][11], 0);
    PlayerTextDrawSetProportional(playerid, TD_Vozilo[playerid][11], 1);
    PlayerTextDrawSetSelectable(playerid, TD_Vozilo[playerid][11], 0);
    return 1;
}

stock DestroyRevolutionPlayerHud(playerid)
{
    PlayerTextDrawDestroy(playerid, TD_HudDatum[playerid]);
    PlayerTextDrawDestroy(playerid, TD_HudVrijeme[playerid]);
    PlayerTextDrawDestroy(playerid, TD_WantedHint[playerid]);
    PlayerTextDrawDestroy(playerid, TD_NovacPlavi[playerid]);
    PlayerTextDrawDestroy(playerid, TD_Euro[playerid]);
    PlayerTextDrawDestroy(playerid, TD_Zlato[playerid]);
    PlayerTextDrawDestroy(playerid, TD_Grad[playerid]);
    PlayerTextDrawDestroy(playerid, TD_Lokacija[playerid]);
    for(new i = 0; i < 12; i++) PlayerTextDrawDestroy(playerid, TD_Vozilo[playerid][i]);
    VoziloHudShown[playerid] = false;
    return 1;
}

stock ShowRevolutionHud(playerid)
{
    for(new i = 0; i < 41; i++)
    {
        if(i == 25 || i == 26 || i == 34 || i == 36 || i == 38 || i == 39 || i == 40) continue;
        TextDrawShowForPlayer(playerid, TD_DTD[i]);
    }
    PlayerTextDrawShow(playerid, TD_HudDatum[playerid]);
    PlayerTextDrawShow(playerid, TD_HudVrijeme[playerid]);
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

stock Float:VehicleHudFuelCapacity(model)
{
    if(VehicleHudNoFuel(model)) return 0.0;
    if(VehicleHudIsTruck(model)) return 250.0;
    return 70.0;
}

stock VehicleHudFuelType(model, output[], size)
{
    if(VehicleHudNoFuel(model)) format(output, size, "NEMA");
    else if(model == 403 || model == 406 || model == 407 || model == 408 ||
            model == 414 || model == 416 || model == 428 || model == 431 ||
            model == 437 || model == 443 || model == 455 || model == 456 ||
            model == 498 || model == 499 || model == 514 || model == 515 ||
            model == 524 || model == 525 || model == 531 || model == 544 ||
            model == 552 || model == 578 || model == 582 || model == 588 || model == 609)
        format(output, size, "NAFTA");
    else if(model == 417 || model == 425 || model == 447 || model == 469 ||
            model == 476 || model == 487 || model == 488 || model == 497 ||
            model == 511 || model == 512 || model == 513 || model == 519 ||
            model == 520 || model == 548 || model == 553 || model == 563 ||
            model == 577 || model == 592 || model == 593)
        format(output, size, "KEROZIN");
    else format(output, size, "BENZIN");
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
    return 1;
}

stock VehicleHudUpdateSpeed(playerid, vehicleid)
{
    new Float:vx, Float:vy, Float:vz, label[12];
    GetVehicleVelocity(vehicleid, vx, vy, vz);
    new speed = floatround(floatsqroot(vx * vx + vy * vy + vz * vz) * 180.0);
    if(speed < 0) speed = 0;
    if(speed == VehicleHudLastSpeed[playerid]) return 1;
    format(label, sizeof(label), "%d", speed);
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
        if(playerState == PLAYER_STATE_DRIVER)
        {
            new damage = VehicleHudDamageLevel(vehicleid);
            if(damage == 5)
            {
                new engine, lights, alarm, doors, bonnet, boot, objective;
                GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                if(engine != 0)
                    SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
                SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
                if(!VehicleHudBrokenNotice[vehicleid])
                {
                    SendClientMessage(p, 0xFF7777FF, "[VOZILO]: Kvarovi su 5/5. Motor je stao; vozilo treba popraviti.");
                    VehicleHudBrokenNotice[vehicleid] = true;
                }
            }
            else
            {
                VehicleHudBrokenNotice[vehicleid] = false;
                if(damage > 0)
                {
                    new Float:vx, Float:vy, Float:vz;
                    GetVehicleVelocity(vehicleid, vx, vy, vz);
                    new Float:speed = floatsqroot(vx * vx + vy * vy + vz * vz) * 180.0;
                    new Float:limit = 0.0;
                    switch(damage)
                    {
                        case 1: limit = 170.0;
                        case 2: limit = 140.0;
                        case 3: limit = 110.0;
                        case 4: limit = 70.0;
                    }
                    // Ne usporava vozilo pri normalnoj voznji. Velocity se mijenja samo iznad limita.
                    if(limit > 0.0 && speed > limit)
                    {
                        new Float:factor = limit / speed;
                        SetVehicleVelocity(vehicleid, vx * factor, vy * factor, vz * factor);
                    }
                }
                if(damage == 4)
                {
                    new engine, lights, alarm, doors, bonnet, boot, objective;
                    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                    if(VehicleHudStalled[vehicleid])
                    {
                        if(engine != 0)
                            SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
                        SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
                    }
                    else
                    {
                        // Neki motori se mogu kretati i kada je native engine parametar 0.
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
                    VehicleHudNextStallAt[vehicleid] = 0;
                    VehicleHudStalled[vehicleid] = false;
                }
            }
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
    VehicleHudOutOfFuel[vehicleid] = true;
    for(new p = 0; p < MAX_PLAYERS; p++)
        if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid))
            SendClientMessage(p, 0xFF7777FF, "[GORIVO]: Rezervoar je prazan. Zaustavite se i upisite /fill.");
    return 1;
}

stock VehicleHudHide(playerid)
{
    if(!VoziloHudShown[playerid]) return 0;
    for(new i = 41; i <= 62; i++)
    {
        if(i == 46 || i == 48 || i == 54 || i == 55 || i == 57 || i == 58 || i == 59 || i == 60 || i == 62) continue;
        TextDrawHideForPlayer(playerid, TD_DTD[i]);
    }
    for(new i = 0; i < 12; i++) PlayerTextDrawHide(playerid, TD_Vozilo[playerid][i]);
    VoziloHudShown[playerid] = false;
    VehicleHudLastSpeed[playerid] = -1;
    return 1;
}

stock VehicleHudShow(playerid)
{
    if(VoziloHudShown[playerid]) return 0;
    for(new i = 41; i <= 62; i++)
    {
        if(i == 46 || i == 48 || i == 54 || i == 55 || i == 57 || i == 58 || i == 59 || i == 60 || i == 62) continue;
        TextDrawShowForPlayer(playerid, TD_DTD[i]);
    }
    new model = GetVehicleModel(GetPlayerVehicleID(playerid));
    for(new i = 0; i < 12; i++)
    {
        if(VehicleHudIsTruck(model))
        {
            if(i == 2 || i == 6 || i == 8) continue;
        }
        else if(i == 9 || i == 10 || i == 11) continue;
        PlayerTextDrawShow(playerid, TD_Vozilo[playerid][i]);
    }
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
    format(name, sizeof(name), "- %s -", VehicleHudModelNames[model - 400]);
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][0], name);
    VehicleHudUpdateSpeed(playerid, vehicleid);
    format(label, sizeof(label), "%.1f", VehicleHudFuel[vehicleid]);
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][2], label);
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][9], label);
    VehicleHudFuelType(model, fuelType, sizeof(fuelType));
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][3], fuelType);
    format(label, sizeof(label), "%d", floatround(VehicleHudKm[vehicleid], floatround_floor));
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][4], label);
    format(label, sizeof(label), "%d", VehicleHudDamageLevel(vehicleid));
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][5], label);
    format(label, sizeof(label), "%.1f", fuelCapacity);
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][6], label);
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][11], label);
    PlayerTextDrawSetString(playerid, TD_Vozilo[playerid][7], "5");
    new bool:truckLayout = VehicleHudIsTruck(model) != 0;
    if(VoziloHudShown[playerid] && VehicleHudTruckLayout[playerid] != truckLayout)
        VehicleHudHide(playerid);
    VehicleHudTruckLayout[playerid] = truckLayout;
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
            if(VehicleHudOutOfFuel[vehicleid]) SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
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
        format(label, sizeof(label), "%d", euro);
        PlayerTextDrawSetString(playerid, TD_Euro[playerid], label);
        PlayerTextDrawShow(playerid, TD_Euro[playerid]);
    }
    return 1;
}

stock UpdateZlatoTD(playerid)
{
    new label[32];
    format(label, sizeof(label), "%d", PlayerZlato[playerid]);
    PlayerTextDrawSetString(playerid, TD_Zlato[playerid], label);
    PlayerTextDrawShow(playerid, TD_Zlato[playerid]);
    return 1;
}

stock UpdateBankaTD(playerid, amount)
{
    new label[32];
    format(label, sizeof(label), "%d$", amount);
    PlayerTextDrawSetString(playerid, TD_NovacPlavi[playerid], label);
    PlayerTextDrawShow(playerid, TD_NovacPlavi[playerid]);
    return 1;
}
CMD:time(playerid, params[])
{
    // Provjera da li igrac posjeduje sat
    if(PlayerSat[playerid] == 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Nemate rucni sat! Morate ga kupiti u zlatari da biste vidjeli vrijeme.");
        return 1;
    }

    // Uzimamo trenutno server vrijeme
    new sat, minut, sekund;
    gettime(sat, minut, sekund);

    // Formatiranje i slanje poruke igracu u chat
    new string[128];
    format(string, sizeof(string), "[Balkan Revolution]: Tacno vrijeme na vašem satu je: {FFFF00}%02d:%02d:%02d", sat, minut, sekund);
    SendClientMessage(playerid, 0x00BFFFFF, string);

    // Ako želiš da mu se pojavi i krupno na sred ekrana (GameText), otkomentariši liniju ispod:
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
            case 3:  { novi_skin = 286; format(org_ime_set, sizeof(org_ime_set), "Žandarmerija"); }
            case 4:  { novi_skin = 61;  format(org_ime_set, sizeof(org_ime_set), "Taxi služba"); }
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
        format(string, sizeof(string), "[Balkan Revolution]: Uspješno ste skinuli lidera igracu %s.", targetName);
        SendClientMessage(playerid, 0x00BFFFFF, string);
    }
    else
    {
        format(string, sizeof(string), "[Balkan Revolution]: Cestitamo! Postali ste Lider organizacije %s.", org_ime_set);
        SendClientMessage(targetid, 0x00BFFFFF, string);

        format(string, sizeof(string), "[Balkan Revolution]: Uspješno ste postavili lidera igracu %s organizacije %s.", targetName, org_ime_set);
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
stock HasAdminCommandAccess(playerid)
{
    if(IsPlayerAdmin(playerid)) return 1;
    if(!GetPVarInt(playerid, "BR_LoggedIn")) return 0;
    new name[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    return (DOF2_FileExists(file) && DOF2_GetInt(file, "Admin") >= 1);
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
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nalog igraca nije pronadjen.");
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

    // Ovdje je promijenjeno sa 9 na 1, što znaci da svaki admin (level 1+) može koristiti komandu
    if(!IsPlayerAdmin(playerid) && admin_lvl < 1) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlascenje!");

    new targetid, razlog[128];
    if(sscanf(params, "us[128]", targetid, razlog)) return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /slap [ID/DeoImena] [Razlog]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF0000FF, "Taj igrac trenutno nije na serveru.");
    if(targetid == playerid) return SendClientMessage(playerid, 0xFF0000FF, "Ne mozete koristiti /slap na sebi.");

    new targetName[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetName, sizeof(targetName));
    GetPlayerName(playerid, adminName, sizeof(adminName));

    if(strcmp(targetName, "Rile", true) == 0 && !IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Ne mozete ošamariti Vlasnika servera!");
        return 1;
    }

    // Podižemo igraca u zrak (slap efekat)
    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(targetid, x, y, z + 5.0); // diže ga 5 metara u vis

    // Poruka direktno ošamarenom igracu u traženom formatu i sa istom bojom
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
CMD:l(playerid, params[])
{
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
                    org_id = i; // Pronašli smo tacan ID organizacije iz master fajla!
                    break;
                }
            }
        }
    }

    // Provjera ko može pisati: Vlasnik (Rile), Lideri (is_lider == 1) ili Admini (admin_lvl >= 1)
    if(strcmp(name, "Rile", true) != 0 && is_lider == 0 && admin_lvl < 1)
    {
        return SendClientMessage(playerid, 0xFF0000FF, "Niste lider niti ovlašteno osoblje!");
    }

    new tekst[128];
    if(sscanf(params, "s[128]", tekst))
        return SendClientMessage(playerid, -1, "Koristi: /l [tekst]");

    new string[256], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    // Formatiranje poruke u zavisnosti od toga ko piše
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
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nemate ovlaštenje!");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /gethere [ID/DeoImena]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xFF0000FF, "Taj igrac trenutno nije na serveru.");
    if(targetid == playerid)
        return SendClientMessage(playerid, 0xFF0000FF, "Ne možete portati sami sebe!");

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
    new tekst[128];
    if(sscanf(params, "s[128]", tekst))
        return SendClientMessage(playerid, 0xAFAFAFFF, "KORISTI: /b [OOC tekst]");

    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));

    // Formatiranje poruke u OOC stilu
    new string[256];
    format(string, sizeof(string), "(( [%d] %s: %s ))", playerid, ime, tekst);

    // Uzimamo poziciju, virtuelni svijet i enterijer igraca koji piše
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new playerVW = GetPlayerVirtualWorld(playerid);
    new playerInterior = GetPlayerInterior(playerid);

    // Petlja koja prolazi kroz sve igrace i šalje poruku samo onima u blizini
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
                    // Boja 0xC2C2C2FF je standardna siva/srebrna boja za OOC chat
                    SendClientMessage(i, 0xC2C2C2FF, string);
                }
            }
        }
    }
    return 1;
}
CMD:me(playerid, params[])
{
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

    // Šaljemo poruku samo igracima u blizini (20 metara)
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

    // Šaljemo poruku samo igracima u blizini (20 metara)
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
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Greška pri ucitavanju vašeg fajla!");

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

    // TEK SADA KADA SMO SIGURNI DA JE CLAN/LIDER, ŠALJEMO PORUKU U CHAT
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
        case 4: format(org_name, sizeof(org_name), "Taxi službe");
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
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Taj igrac mora biti minimalno level 3 da bi ušao u organizaciju!");

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
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Greška: Fajl organizacije ne postoji!");

    new slot_key[32];
    format(slot_key, sizeof(slot_key), "Slot_%d", slotid);

    if(!DOF2_IsSet(org_file, slot_key))
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Taj slot je vec prazan!");

    new targetname[MAX_PLAYER_NAME];
    format(targetname, sizeof(targetname), "%s", DOF2_GetString(org_file, slot_key));

    if(strcmp(targetname, "Nema", true) == 0)
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Na tom slotu nema nikoga!");

    // Brišemo igraca sa tog slota u organizaciji (postavljamo na "Nema")
    DOF2_SetString(org_file, slot_key, "Nema");
    DOF2_SaveFile();

    // Brišemo mu organizaciju u njegovom licnom fajlu (Member na 0, Rank na 0)
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
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Greška pri ucitavanju vašeg fajla!");

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
            strcat(dialog_string, "{00BFFF}/d {FFFFFF}- Department chat (komunikacija sa državnim službama)\n\n");
        }
    }

    // Ako je clan državnih organa (Policija, Vojska, Žandarmerija - ID 1, 2, 3) ili njihov lider
    if(orgid == 1 || orgid == 2 || orgid == 3)
    {
        strcat(dialog_string, "{00BFFF}=== DRŽAVNE / POLICIJSKE KOMANDE ===\n");
        strcat(dialog_string, "{00BFFF}/cuff {FFFFFF}- Da stavite lisice igracu\n");
        strcat(dialog_string, "{00BFFF}/drag {FFFFFF}- Da izbacite igraca iz vozila\n");
        strcat(dialog_string, "{00BFFF}/pu {FFFFFF}- Da ubacite igraca u svoje vozilo\n");
        strcat(dialog_string, "{00BFFF}/su {FFFFFF}- Da posaljete igraca u zatvor\n");
        strcat(dialog_string, "{00BFFF}/bk {FFFFFF}- Da postavite barikade\n");
        strcat(dialog_string, "{00BFFF}/pretresi {FFFFFF}- Da pretreses igraca\n");
        strcat(dialog_string, "{00BFFF}/oduzmi {FFFFFF}- Da oduzmes igracu ilegalne supstance\n");
        strcat(dialog_string, "{00BFFF}/wl {FFFFFF}- Da vidite spisak igraca koji imaju Wanted Level\n");
        strcat(dialog_string, "{00BFFF}/dajwl {FFFFFF}- Da date Wanted Level igracu\n");
        strcat(dialog_string, "{00BFFF}/f {FFFFFF}- Org chat\n");
        strcat(dialog_string, "{00BFFF}/d {FFFFFF}- Department chat\n\n");

        // Opis/Upozorenje za policijske komande
        strcat(dialog_string, "{FF0000}Opis:\nSvako iskoristavanje ovih komandi nepotrebno možete biti kažnjeni!\n\n");
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
        else if(orgid >= 1 && orgid <= 7) // Za ostale državne/javne službe koje nemaju posebne komande iznad, a koriste /f i /d
        {
            strcat(dialog_string, "{00BFFF}=== SLUŽBENE KOMANDE ===\n");
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
        strcat(dialog_string, "{FFFFFF}Ugovor Lidera organizacije traje 3 dana, ukoliko skinete Lidera ranije bicete kažnjeni i možete završiti na Black Listi Lidera.");
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
        return SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Greška: Fajl organizacije ne postoji!");

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

    format(string, sizeof(string), "{00C0FF}Naziv Trafike: {FFFFFF}%s\n{00C0FF}Opis: {FFFFFF}%s\n{00C0FF}Vlasnik: {FFFFFF}%s\n{00C0FF}ID: {FFFFFF}%d | {00C0FF}Cijena: {FFFFFF}$%d | {00C0FF}Level: {FFFFFF}%d\n{00C0FF}Budžet: {FFFFFF}$%d\n{00C0FF}Potrebni Produkti: {FFFFFF}%d | {00C0FF}Cijena Produkta: {FFFFFF}$%d\n{FFFFFF}Kucajte {00C0FF}/trafika {FFFFFF}za kupovinu!",
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

stock UcitajTrafike()
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
    format(string, sizeof(string), "Uspješno si kreirao trafiku ID: %d", trafikaid);
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
    format(string, sizeof(string), "Uspješno si izmijenio trafiku ID: %d | Nova cijena: $%d | Novi level: %d", id, nova_cijena, novi_level);
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
    format(string, sizeof(string), "Uspješno si obrisao trafiku ID: %d", id);
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

    SendClientMessage(playerid, 0x00BFFFFF, "Uspješno si kreirao objekt. Fajl je napravljen, namjesti ga mišem i pritisni Save!");
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

            // 1. Ovdje pronalazimo slobodan slot u nizu i upisujemo podatke tog objekta
            for(new i = 0; i < MAX_SLOBODNIH_OBJEKATA; i++)
            {
                // Ako je slot prazan ili ako vec editujemo taj isti objekt
                if(SlobodanObjekt[i][sModel] == 0 || SlobodanObjekt[i][sObjID] == objectid)
                {
                    // Uzimamo model objekta (ako imaš sacuvan model, ili ga upisujemo)
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

    // Provjeravamo da li taj dinamicki objekt uopšte postoji u svijetu
    if(!IsValidDynamicObject(objid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Objekt u tom slotu ne postoji u svijetu!");
    }

    // Pokrecemo editovanje tog objekta mišem
    EditDynamicObject(playerid, objid);

    // Snimamo slot u PVar umjesto obicnog ID-ja objekta
    SetPVarInt(playerid, "EditujemSlobodanSlot", slot);

    new string[128];
    format(string, sizeof(string), "Uspješno si preuzeo objekt iz slota %d. Pomjeri ga mišem i pritisni Save!", slot);
    SendClientMessage(playerid, 0x00BFFFFF, string);
    return 1;
}
stock SnimiSlobodneObjekte()
{
    new file[64] = "BalkanRP/Objekti.ini";

    // Ako fajl ne postoji, moramo ga prvo kreirati da DOF2 može upisivati u njega!
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

    // Brišemo objekt iz igre ako validan ID postoji
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

    SendClientMessage(playerid, 0x00FF00FF, "Uspješno si obrisao objekt i uklonjen je iz fajla!");
    return 1;
}
stock UpdateTrafikuLabel(id)
{
    if(IsValidDynamic3DTextLabel(TrafikaInfo[id][tLabel]))
        DestroyDynamic3DTextLabel(TrafikaInfo[id][tLabel]);

    new string[128];
    // Prikazuje tacno onaj tekst koji želiš, bez suvišnih informacija
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
        return SendClientMessage(playerid, 0xFF0000FF, "[Greška]: {FFFFFF}Niste blizu nijedne trafike!");
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

    SendClientMessage(playerid, 0x00FF00FF, "Uspješno kreiran i sacuvan label i pickup!");
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
            SendClientMessage(playerid, 0x00FF00FF, "Uspješno si obrisao label, pickup i fajl!");
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
    format(poruka, sizeof(poruka), "[LABEL]: Uspješno ste kreirali label ID: %d sa tekstom: '%s'", slot, params);
    SendClientMessage(playerid, 0x00FF00FF, poruka);
    return 1;
}
stock UcitajLabele()
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
    printf("[LABEL SYSTEM]: Uspješno ucitano %d labela iz baze.", ucitano);
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
    format(poruka, sizeof(poruka), "[LABEL]: Uspješno ste obrisali label (ID: %d).", id);
    SendClientMessage(playerid, 0x00FF00FF, poruka);
    return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
        ScriptJetpack[playerid] = false;
    // Proveravamo kada igrac postane vozac nekog vozila
    if(newstate == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(IsRentVehicle(vehicleid))
        {
            if(RentVehicleOwner[vehicleid] == playerid + 1 && RentPlayerVehicle[playerid] == vehicleid)
                return 1;
            RemovePlayerFromVehicle(playerid);
            if(RentVehicleOwner[vehicleid])
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Ovo vozilo je vec iznajmljeno.");
            if(RentPlayerVehicle[playerid])
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Vec imas rent vozilo. Koristi /unrent.");
            if(!GetPVarInt(playerid, "BR_LoggedIn"))
                return SendClientMessage(playerid, 0xFF0000FF, "[RENT]: Prvo se prijavi na nalog.");
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
        // 4. Provera za Poštara (Posao ID 2)
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
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste ovlašceni da koristite ovu komandu!");
    }

    new targetid, money;
    // Ako je params definisan kao niz, ovo ce raditi bez greške:
    if(sscanf(params, "dd", targetid, money))
    {
        return SendClientMessage(playerid, 0xCECECEFF, "Koristite: /givemoney [ID Igraca] [Kolicina]");
    }

    if(!IsPlayerConnected(targetid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Taj igrac nije na serveru!");
    }
    if(money <= 0) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Kolicina novca mora biti veca od nule!");
    if(money > 2147483647 - GetPlayerMoney(targetid)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Prevelika kolicina novca!");

    new string[128], targetname[MAX_PLAYER_NAME], targetfile[128];
    GetPlayerName(targetid, targetname, sizeof(targetname));
    format(targetfile, sizeof(targetfile), "Korisnici/%s.ini", targetname);
    if(!DOF2_FileExists(targetfile)) return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Nalog igraca nije pronadjen!");

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
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste ovlašceni da koristite ovu komandu!");
    }

    // Poruka na sred ekrana svima
    GameTextForAll("~r~Uskoro ce restart!\n~w~Zavrsavajte svoje poslove.", 6000, 3);
    SendClientMessageToAll(0xFF0000FF, "[SERVER]: Administrator je pokrenuo restart servera za 1 minut!");

    // Pokrece tajmer na 60 sekundi (1 minut)
    SetTimer("RestartServerTimer", 60000, false);
    return 1;
}

// --- /RAC (RESPAWN NEISKORIŠCENIH VOZILA) ---
CMD:rac(playerid, params)
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    new admin_lvl = 0;
    if(DOF2_FileExists(file)) admin_lvl = DOF2_GetInt(file, "Admin");

    if(admin_lvl < 9 && !IsPlayerAdmin(playerid))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Niste ovlašceni da koristite ovu komandu!");
    }

    SendClientMessageToAll(0x00BFFFFF, "Administrator je pokrenuo Respawn vozila, sva vozila neiskoristena bice Respawnovana za 30 sekundi!");

    // Pokrece tajmer na 30 sekundi (pola minuta)
    SetTimer("RespawnUnusedVehiclesTimer", 30000, false);
    return 1;
}
new bool:AdminSpawnedVehicle[MAX_VEHICLES];

stock VehicleCommandAdmin(playerid)
{
    if(IsPlayerAdmin(playerid)) return 1;
    if(!GetPVarInt(playerid, "BR_LoggedIn")) return 0;

    new name[MAX_PLAYER_NAME], file[128];
    GetPlayerName(playerid, name, sizeof(name));
    format(file, sizeof(file), "Korisnici/%s.ini", name);
    return DOF2_FileExists(file) && DOF2_GetInt(file, "Admin") >= 1;
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
    return SetVehicleToRespawn(vehicleid);
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
    }
    else
    {
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
    format(label, sizeof(label), "RENT: %02d:%02d | /unrent", remaining / 60, remaining % 60);
    PlayerTextDrawSetString(playerid, RentTextDraw[playerid], label);
    return 1;
}

stock StopPlayerRent(playerid, bool:respawn)
{
    new vehicleid = RentPlayerVehicle[playerid];
    RentPendingVehicle[playerid] = 0;
    if(!vehicleid) return 0;
    RentPlayerVehicle[playerid] = 0;
    RentExpiresAt[playerid] = 0;
    if(RentVehicleOwner[vehicleid] == playerid + 1) RentVehicleOwner[vehicleid] = 0;
    PlayerTextDrawHide(playerid, RentTextDraw[playerid]);
    if(respawn && GetVehicleModel(vehicleid) != 0)
    {
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(IsPlayerConnected(p) && IsPlayerInVehicle(p, vehicleid))
                RemovePlayerFromVehicle(p);
        }
        SetVehicleToRespawn(vehicleid);
    }
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    if(!IsRentVehicle(vehicleid)) return 1;
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
    SetVehicleToRespawn(vehicleid);
    return 1;
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
            SendClientMessage(playerid, 0x00BFFFFF, "[RENT]: Vrijeme je isteklo. Vozilo je vraceno.");
        }
        else UpdateRentTextDraw(playerid);
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
    SendRconCommand("gmx"); // Ako želiš potpuno gašenje servera umesto gmx (gamemode restart), zameni sa "exit"
    return 1;
}

// Tajmer za respawn praznih vozila nakon pola minuta (30s)
forward RespawnUnusedVehiclesTimer();
public RespawnUnusedVehiclesTimer()
{
    for(new i = 0; i < MAX_VEHICLES; i++)
    {
        if(!IsVehicleOccupied(i) && !RentVehicleOwner[i])
        {
            SetVehicleToRespawn(i);
        }
    }
    SendClientMessageToAll(0x00FF00FF, "[SERVER]: Sva neiskorišcena vozila su uspešno respawnovana!");
    return 1;
}
// --- /CALL 666 ---
CMD:call(playerid, params[])
{
    if(isnull(params) || strval(params) != 666)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Koristite /call 666");
    }

    // Proveravamo da li je taksista uopšte na dužnosti pre poziva
    if(!G_TaxiDuty)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "Trenutno nijedan taksista nije na dužnosti (/duty)!");
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

                // Ako je clan ili lider Taxi organizacije, šaljemo belu poruku sa cenom vožnje
                if(orgid == 4 || is_lider == 1)
                {
                    new string[128];
                    format(string, sizeof(string), "[TAXI POZIV]: Igrac %s traži prevoz! Cena voznje: %d RSD. Kucajte /acceptfaren", callername, G_TaxiPrice);
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
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Greška pri ucitavanju vašeg fajla!");

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

    // Pamtimog ko je prihvatio vožnju
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
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Greška pri ucitavanju vašeg fajla!");

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

    // 4. Postavljanje dužnosti
    G_TaxiPrice = price;
    G_TaxiDuty = true;

    new string[128];
    format(string, sizeof(string), "Taxi Vozac %s je sada na Duznosti, da ga pozovete kucajte /call 666. Cjena voznje: %d RSD", name, price);
    SendClientMessageToAll(0xFFFF00FF, string); // Žuta boja za obaveštenje svima

    return 1;
}
public OnPlayerEnterCheckpoint(playerid)
{
    // 1. Provera za taksistu koji je prihvatio vožnju
    if(playerid == G_AcceptedTaxiDriver)
    {
        DisablePlayerCheckpoint(playerid);
        SendClientMessage(playerid, 0xFFFFFFFF, "Stigli ste na mjesto.");
        G_AcceptedTaxiDriver = INVALID_PLAYER_ID;
        return 1;
    }

    // 2. Provera za poštara (Dostava pošte)
    if(IsDoingPosta[playerid])
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(!IsPlayerInAnyVehicle(playerid) || GetVehicleModel(vehicleid) != 482)
        {
            SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Morate biti u poštarskom kombiju da biste dostavili poštu!");
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
            // Stigao do aerodroma (tacka 15) - Brišemo checkpoint, palimo tajmer 10 sekundi i zamrzavamo igraca
            DisablePlayerCheckpoint(playerid);
            SendClientMessage(playerid, 0xFFFF00FF, "[SERVER]: Stigli ste na aerodrom. Sacekajte 10 sekundi da vam se utovari pošta u kombi...");
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
                new plata = 1000;
                new novo_stanje_banka = stari_novac_banka + plata;

                DOF2_SetInt(file, "Banka", novo_stanje_banka);
                DOF2_SaveFile();

				// --- OVDJE DODAJ OVO ISPOD ---
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
                SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Cestitam, završili ste poštarsku turu! Novac je uplacen na bankovni racun.");
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

    SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Pošta je utovarena! Vratite se nazad u magacin da završite turu.");
    return 1;
}
// --- /F (ORGANIZACIONI CHAT) ---
CMD:f(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Koristite: /f [Tekst poruke]");

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Greška pri ucitavanju vašeg fajla!");

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
    else if(orgid == 3) orgname = "Žandarmerija";
    else if(orgid == 4) orgname = "Taxi";
    else if(orgid == 7) orgname = "Parking Servis";
    else orgname = "Organizacija";

    // Formatiramo poruku zavisno od organizacije, ranka i lidera
    new string[144];
    if(orgid == 4)
    {
        if(is_lider)
        {
            format(string, sizeof(string), "[%s] [Šef Taxi Company-e] %s: %s", orgname, name, params);
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
            format(string, sizeof(string), "[%s] [Šef Parking Servisa] %s: %s", orgname, name, params);
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
// --- /D (DEPARTMENT / DRŽAVNI CHAT) ---
// --- /D (DEPARTMENT / DRŽAVNI CHAT) ---
// --- /D (DEPARTMENT / DRŽAVNI CHAT) ---
CMD:d(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Koristite: /d [Tekst radio veze]");

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    // 1. Procitamo podatke igraca iz njegovog fajla
    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Greška pri ucitavanju vašeg fajla!");

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
        case 3: orgname = "Žandarmerija";
        case 4: orgname = "Taxi";
        case 5: orgname = "Hitna Pomoc";
        case 6: orgname = "Parking Servis";
        case 7: orgname = "Novinari";
        default: orgname = "Služba";
    }

    // Formatiramo poruku sa dodatim "Prijem." na kraju
    new string[144];
    if(is_lider)
    {
        if(orgid == 4)
        {
            format(string, sizeof(string), "[D] [%s] [Šef Taxi Company-e] %s: %s.. Prijem.", orgname, name, params);
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
                    // Nežno ljubicasta/roze boja sa slike
                    SendClientMessage(i, 0xD8BFD8FF, string);
                }
            }
        }
    }

    return 1;
}
// --- /OOC (GLOBALNI OOC CHAT ZA ADMINE I VLASNIKA) ---
CMD:ooc(playerid, params[])
{
    if(isnull(params))
        return SendClientMessage(playerid, 0xFFFFFFFF, "Koristite: /ooc [Tekst poruke]");

    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));

    // 1. Procitamo fajl igraca da vidimo da li je admin/vlasnik
    new file[128];
    format(file, sizeof(file), "Korisnici/%s.ini", name);

    if(!DOF2_FileExists(file))
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Greška pri ucitavanju vašeg fajla!");

    new admin_level = DOF2_GetInt(file, "Admin"); // Proveravamo admin nivo (možeš promeniti kljuc ako se kod tebe drugacije zove, npr. "Vlasnik" ili "GM")

    // Ako igrac nema admin nivo (manji ili jednak 0), odbijamo pristustvo
    if(admin_level <= 0)
    {
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Samo administratori i vlasnik mogu koristiti /ooc chat!");
    }

    // Formatiramo poruku: [OOC] Ime: Tekst
    new string[144];
    format(string, sizeof(string), "[OOC] %s: %s", name, params);

    // Šaljemo poruku celom serveru u narandžastoj boji sa tvoje slike
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
        return SendClientMessage(playerid, 0xFFFFFFFF, "[Balkan Revolution]: Greška pri ucitavanju vašeg fajla!");

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
        return SendClientMessage(playerid, 0xFFFFFFFF, "GRESKA: Taj igrac nije clan vaše organizacije!");

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

    // Obaveštenja
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
    // Provera lokacije (samo kad je igrac peške ovde)
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
                // Ako je admin na dužnosti (AdminDuty == 1), preskacemo ga da mu ne skida helt
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

                // Kada padne na 10 ili niže, ispisujemo poruku da je gladan
                if(health <= 10.0)
                {
                    SendClientMessage(i, 0xFF6347FF, "[Balkan Revolution]: Jako ste gladni! Morate nešto jesti da ne biste izgubili svest.");
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
        case 0: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Niste sigurni gde da radite? Posetite opštinu ili pitajte za pomoc (/askq).");
        case 1: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Želite da sacuvate novac? Otvorite racun u banci i koristite karticu.");
        case 2: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Ukoliko vam je potrebna pomoc administracije, postavite pitanje preko /askq komande.");
        case 3: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Redovno kupujte hranu da ne biste izgubili svest zbog sistema gladi!");
        case 4: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Clanovi svih organizacija mogu koristiti specijalni /f chat radi lakše komunikacije sa kolegama.");
        case 5: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Nikada nikome ne otkrivajte svoju lozinku! Admini je nikada nece tražiti.");
        case 6: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Posetite zlataru i iskoristite berzu zlata za pametno ulaganje i zaradu!");
        case 7: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Svoje vozilo uvek zakljucavajte komandom /lock kako biste sprecili kradu.");
        case 8: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Imate problem sa vozilom? Pozovite mehanicare ili posetite benzinsku pumpu.");
        case 9: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Kršite saobracajna pravila? Parking Servis vam lako može odneti vozilo!");
        case 10: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Želite da saznate više o serveru? Kucajte /help i istražite sve komande.");
        case 11: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Poštujte RolePlay pravila i uživajte u igri. Srecan rad želi vam Balkan Revolution tim!");
        case 12: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Nemate gde da živite? Kupite svoju kucu ili stan komandom /buyhouse.");
        case 13: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} U svojoj kuci možete ostavljati novac u sef i menjati enterijer po želji.");
        case 14: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Kupite mobilni telefon i karticu na kiosku za komunikaciju sa igracima (/call).");
        case 15: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Treba vam oglas? Iskoristite /smsad komandu da oglasite prodaju ili potražnju.");
        case 16: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Bavite se ilegalnim poslovima? Pazite se policije i organa reda.");
        case 17: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Kriminalne organizacije drže teritorije pod kontrolom. Saradujte sa kolegama.");
        case 18: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Organizujete žurku? Pozovite prijatelje i iskoristite animacije za provod.");
        case 19: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Želite da promenite stil? Posetite butik odece i kupite novi skin.");
        case 20: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Tek stigli? Zaposlite se kao cistac ulica ili dostavljac da zaradite prvi novac.");
        case 21: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Istražite mapu i pronadite poslove koji vam najviše odgovaraju za zaradu!");
        case 22: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Posetite auto-školu i položite vozacki ispit da vas policija ne bi kaznila.");
        case 23: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Za nošenje oružja potrebna vam je dozvola koju možete izvaditi kod nadležnih.");
        case 24: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Pazite na gorivo – svratite na pumpu i napunite rezervoar komandom /fill.");
        case 25: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Vaše vozilo je ošteceno? Posetite mehanicarsku radionicu za popravku.");
        case 26: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Novac na banci vam je siguran i na njega dobijate kamatu pri svakoj plati!");
        case 27: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Želite da postanete preduzetnik? Štedite novac i kupite sopstveni biznis.");
        case 28: SendClientMessageToAll(0xFFFFFFFF, "{33CCFF}[Balkan Revolution Tip]:{FFFFFF} Želite da komunicirate sa ostalim igracima? Dodite na TeamSpeak da se družimo, a za normal se prijavite na našem TS3 serveru!");
    }
    return 1;
}
stock SendBigEarLog(const string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && BigEar[i])
        {
            SendClientMessage(i, 0xFF9900FF, string); // Narandžasta boja
        }
    }
}
public OnPlayerText(playerid, text[])
{
    if(JuniorMutedUntil[playerid] > gettime())
    {
        new muteMsg[96];
        format(muteMsg, sizeof(muteMsg), "[MUTE]: Ne mozete pisati jos %d sekundi.", JuniorMutedUntil[playerid] - gettime());
        SendClientMessage(playerid, 0xFF7777FF, muteMsg);
        return 0;
    }
    if(JuniorGlobalChatLocked && !HasAdminCommandAccess(playerid))
    {
        SendClientMessage(playerid, 0xFF7777FF, "[CHAT]: Globalni chat je trenutno zakljucan.");
        return 0;
    }
    // 1. BIGEAR (Spy sistem) - ostaje globalan jer ti treba da cuješ sve
    new ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    new log_string[144];
    format(log_string, sizeof(log_string), "[BIGEAR CHAT] [ID: %d] %s: %s", playerid, ime, text);
    SendBigEarLog(log_string);

    // 2. LOKALNI RP CHAT (Ovo radi da se cuju samo ljudi u blizini)
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    new str[144];
    format(str, sizeof(str), "%s kaže: %s", ime, text); // Ovde možeš dodati boju ako želiš

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            // Provera udaljenosti (20.0 je radijus od 20 metara)
            if(IsPlayerInRangeOfPoint(i, 20.0, pos[0], pos[1], pos[2]))
            {
                SendClientMessage(i, 0xFFFFFFFF, str); // Bela boja za RP chat
            }
        }
    }

    return 0; // VRLO VAŽNO: Vracamo 0 da sprecimo SA-MP da duplira poruku (globalno)
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
        SendClientMessage(playerid, 0xFF0000FF, "[Balkan Revolution]: Niste ovlašceni! Komanda je samo za Vlasnika (Level 9) i RCON admine.");
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
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Nemate ovlašcenje da koristite ovu komandu!");
        return 1;
    }

    new modelid;
    if(sscanf(params, "i", modelid))
    {
        SendClientMessage(playerid, 0xB4B4B4FF, "[KORIŠCENJE]: /veh [ID Vozila (400 - 611)]");
        return 1;
    }

    if(modelid < 400 || modelid > 611)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: ID vozila mora biti izmedu 400 i 611!");
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
    PutPlayerInVehicle(playerid, vehicleid, 0);

    SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Uspešno ste stvorili vozilo.");
    return 1;
}
// Ako koristiš ZCMD:
CMD:posao(playerid, params)
{
    // Proveravamo da li je igrac u krugu od 3 metra od tih koordinata
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 330.6513, -1509.8417, 36.0391))
    {
        new file[128], ime[MAX_PLAYER_NAME];
        GetPlayerName(playerid, ime, sizeof(ime));
        format(file, sizeof(file), "Korisnici/%s.ini", ime);

        if(DOF2_FileExists(file))
        {
            // Postavljamo vrednost Posao na 2 (Poštar)
            DOF2_SetInt(file, "Posao", 2);
            DOF2_SaveFile();

            SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Cestitamo! Uspešno ste se zaposlili kao Poštar. Sada možete voziti poštarska vozila.");
        }
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Niste na mestu gde se možete zaposliti kao poštar!");
    }
    return 1;
}
CMD:otkaz(playerid, params)
{
    // Proveravamo da li je igrac na tacnim koordinatama, u enterijeru 3 i virtuelnom svetu 0
    if(IsPlayerInRangeOfPoint(playerid, 3.0, 358.9828, 169.0106, 1008.3828) && GetPlayerInterior(playerid) == 3 && GetPlayerVirtualWorld(playerid) == 0)
    {
        new file[128], ime[MAX_PLAYER_NAME];
        GetPlayerName(playerid, ime, sizeof(ime));
        format(file, sizeof(file), "Korisnici/%s.ini", ime);

        if(DOF2_FileExists(file))
        {
            new current_job = DOF2_GetInt(file, "Posao");
            if(current_job == 0)
            {
                SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Nemate nikakav posao da biste dali otkaz!");
                return 1;
            }

            // Vracamo posao na 0 (Nema posla)
            DOF2_SetInt(file, "Posao", 0);
            DOF2_SaveFile();

            SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Uspešno ste dali otkaz u opštini. Vaš posao je sada resetovan.");
        }
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Morate biti u opštini na šalteru da biste dali otkaz! Kucajte /otkaz na predvidenom mestu.");
    }
    return 1;
}
CMD:jobhelp(playerid, params)
{
    new file[128], ime[MAX_PLAYER_NAME];
    GetPlayerName(playerid, ime, sizeof(ime));
    format(file, sizeof(file), "Korisnici/%s.ini", ime);

    if(DOF2_FileExists(file))
    {
        new player_job = DOF2_GetInt(file, "Posao");

        // Proveravamo da li je igrac uopste zaposlen
        if(player_job == 0)
        {
            SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Trenutno niste zaposleni ni na jednom poslu!");
            return 1;
        }

        // POSAO ID 2: Poštar
        else if(player_job == 2)
        {
            new string[512]; // Veliki string jer ima dosta teksta

            // Formatiramo tekst za dialog, stavljamo boje (bela za komande, zelena/žuta za opise) i \n za novi red
            format(string, sizeof(string), "\
            {FFFFFF}/prekiniposao {00FF00}- Da prekinete posao\n\
            {FFFFFF}/raznesipostu {00FF00}- Da raznosite postu po kucama (morate biti na motoru)\n\
            {FFFFFF}/dovezipostu {00FF00}- Da iz lagera dovezete postu u Magacin poste (morate biti u kombiju)\n\n\
            {FFFF00}Opis:\n\
            {FFFFFF}Posao je lak i jednostavan, ucinite mogucnost da pisma i paketi dodju na vreme na adresu i do magacina.\n\
            Da bi dali otkaz morate otici u Opstinu i to uciniti na salteru.");

            // Prikazujemo MSGBOX dialog (ID dialoga stavljen 8500, možeš promeniti ako je zauzet)
            ShowPlayerDialog(playerid, 8500, DIALOG_STYLE_MSGBOX, "{00FF00}Pomoc za posao: {FFFFFF}Postar", string, "U redu", "");
        }

        // Ovde možeš kasnije dodati i ostale poslove
        // else if(player_job == 1) { ... Cistac ulica ... }

        else
        {
            SendClientMessage(playerid, 0xFF0000FF, "[SERVER]: Za Vaš posao još uvek nije upisan vodic (/jobhelp).");
        }
    }
    return 1;
}
CMD:engine(playerid, params)
{
    // Provera da li je igrac u nekom vozilu
    if(!IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Niste ni u kakvom vozilu!");
        return 1;
    }

    // Provera da li je igrac vozac (sjedište 0)
    if(GetPlayerVehicleSeat(playerid) != 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Samo vozac može upaliti ili ugasiti motor!");
        return 1;
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    new engine, lights, alarm, doors, bonnet, boot, objective;

    // Uzimamo trenutne parametre vozila
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    // Ako je motor ugašen (0 ili -1), palimo ga
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
        SendClientMessage(playerid, 0x00FF00FF, "[SERVER]: Uspješno ste upalili motor vozila.");
    }
    else // Ako je upaljen, gasimo ga
    {
        SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
        SendClientMessage(playerid, 0xFF0000FF, "[SERVER]: Uspješno ste ugasili motor vozila.");
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
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Niste zaposleni kao Poštar!");
        return 1;
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleSeat(playerid) != 0 || GetVehicleModel(vehicleid) != 482)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Morate biti vozac u poštarskom kombiju (Burrito - model 482)!");
        return 1;
    }

    // Povecan radijus na 80.0 da obuhvati sve kombije u nizu u garaži sa slike
    if(!IsPlayerInRangeOfPoint(playerid, 80.0, PostarRute[0][0], PostarRute[0][1], PostarRute[0][2]))
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Niste u magacinu da biste zapoceli poštansku turu!");
        return 1;
    }

    if(IsDoingPosta[playerid])
    {
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Vec ste zapoceli poštansku turu!");
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
        SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Trenutno nemate aktivnu poštansku turu!");
        return 1;
    }

    IsDoingPosta[playerid] = false;
    PostarStep[playerid] = 0;
    DisablePlayerCheckpoint(playerid);
    SendClientMessage(playerid, 0xFF0000FF, "[SERVER]: Uspešno ste prekinuli poštansku turu.");
    return 1;
}
public OnPlayerUpdate(playerid)
{
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
stock ApplyPendingDeathPenalty(playerid, bool:notify)
{
    if(PendingDeathFine[playerid] <= 0) return 0;
    new cash = GetPlayerMoney(playerid);
    if(cash < 0) cash = 0;
    new fine = PendingDeathFine[playerid];
    if(fine > cash) fine = cash;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, cash - fine);
    PlayerInfo[playerid][pNovac] = cash - fine;
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
        AddPlayerSavedStat(killerid, "DosijeUbistva", 1);

    if(BankHackPlayer == playerid) BankAbortHack();
    if(BankRobber == playerid) BankAbortRobbery(true);
    if(BankMoneyBag[playerid]) RemovePlayerAttachedObject(playerid, 9);
    BankMoneyBag[playerid] = false;
    ScriptJetpack[playerid] = false;
    IsHealing[playerid] = true;
    PlayerCurrentSkin[playerid] = GetPlayerSkin(playerid);
    if(PlayerCurrentSkin[playerid] < 0 || PlayerCurrentSkin[playerid] > 311 || PlayerCurrentSkin[playerid] == 74)
        PlayerCurrentSkin[playerid] = 26;
    SetSpawnInfo(playerid, 0, PlayerCurrentSkin[playerid], -20.6776, 1481.3562, -3.3132, 179.0601, 0, 0, 0, 0, 0, 0);
    return 1;
}
forward ZavrsiLecenje(playerid);
public ZavrsiLecenje(playerid)
{
    if(IsHealing[playerid])
    {
        IsHealing[playerid] = false;

        // Vraca ga na njegov regularni spawn na osnovu sacuvane organizacije
        if(PlayerOrg[playerid] == 1)
        {
            SetPlayerPos(playerid, 230.6200, 75.2964, 1005.0391);
            SetPlayerFacingAngle(playerid, 270.3857);
            SetPlayerInterior(playerid, 6);
            SetPlayerVirtualWorld(playerid, 0);
        }
        else if(PlayerOrg[playerid] == 4)
        {
            SetPlayerPos(playerid, 1754.1577, -1903.0061, 13.5634);
            SetPlayerFacingAngle(playerid, 0.0);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
        else if(PlayerOrg[playerid] == 5)
        {
            SetPlayerPos(playerid, -13.7780, 1465.4548, -3.2142);
            SetPlayerFacingAngle(playerid, 3.1334);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
        else if(PlayerOrg[playerid] == 7)
        {
            SetPlayerPos(playerid, 1072.9264, -878.3057, 43.3932);
            SetPlayerFacingAngle(playerid, 0.0);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }
        else
        {
            SetPlayerPos(playerid, 1685.8652, -2331.2102, 13.5469);
            SetPlayerFacingAngle(playerid, 90.2917);
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
        }

        SendClientMessage(playerid, 0x00FF00FF, "[BOLNICA]: Završili ste lecenje i vraceni ste na svoju spawn lokaciju.");
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
        return SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Niste ovlašteni! Ovu komandu mogu koristiti samo admini od levela 1 do 9 i RCON admini.");
    }

    new targetid, Float:health;
    if(sscanf(params, "uf", targetid, health)) return SendClientMessage(playerid, 0xFFFFFFAA, "KORIŠTENJE: /sethealth [ID/Ime] [Health (0-100)]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Igrac nije online!");
    if(health < 0.0 || health > 100.0) return SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Health mora biti izmedu 0 i 100!");

    SetPlayerHealth(targetid, health);

    new string[128], adminname[MAX_PLAYER_NAME], targetname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, adminname, sizeof(adminname));
    GetPlayerName(targetid, targetname, sizeof(targetname));

    format(string, sizeof(string), "[ADMIN]: Admin %s je postavio vaš health na %.1f.", adminname, health);
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
        return SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Niste ovlašteni! Ovu komandu mogu koristiti samo admini od levela 1 do 9 i RCON admini.");
    }

    new targetid, Float:armour;
    if(sscanf(params, "uf", targetid, armour)) return SendClientMessage(playerid, 0xFFFFFFAA, "KORIŠTENJE: /setarmour [ID/Ime] [Armour (0-100)]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Igrac nije online!");
    if(armour < 0.0 || armour > 100.0) return SendClientMessage(playerid, 0xFF0000FF, "[GREŠKA]: Armour mora biti izmedu 0 i 100!");

    SetPlayerArmour(targetid, armour);

    new string[128], adminname[MAX_PLAYER_NAME], targetname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, adminname, sizeof(adminname));
    GetPlayerName(targetid, targetname, sizeof(targetname));

    format(string, sizeof(string), "[ADMIN]: Admin %s je postavio vaš armour na %.1f.", adminname, armour);
    SendClientMessage(targetid, 0x00FF00FF, string);

    format(string, sizeof(string), "[ADMIN]: Postavili ste armour igracu %s na %.1f.", targetname, armour);
    SendClientMessage(playerid, 0x00FF00FF, string);
    return 1;
}
CMD:uninviteme(playerid, params[])
{
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 359.2273, 178.5944, 1008.3828) || GetPlayerInterior(playerid) != 3 || GetPlayerVirtualWorld(playerid) != 0)
    {
        return SendClientMessage(playerid, -1, "{FF0000}[GRESKA]: {FFFFFF}Niste na lokaciji za napuštanje organizacije!");
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

    // Ažuriramo novac i u DOF2 fajlu da ostane skinut trajno
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
    SendClientMessage(playerid, 0x33CCFFFF, "[ORGANIZACIJA]: Uspješno ste napustili organizaciju i skinuto vam je 15.000 dinara.");

    return 1;
}
CMD:stablo(playerid, params[]) {
    new str[1024];

    // Slažemo tekst dijaloga
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
    strcat(text, "/mp3 /stats /help /pravila /dajadmin /setcodeadmin\n", sizeof(text));
    strcat(text, "/admini /adminduty /dajhelpera /hduty /helperi /setcodehelper\n", sizeof(text));
    strcat(text, "/napravikucu /izbrisikucu /editujkucu /jetpack /buyhouse /gotohouse /sellhouse\n", sizeof(text));
    strcat(text, "/lockhouse /unlockhouse /napravimarket /editujmarket /obrisimarket /buybizz /sellbizz\n", sizeof(text));
    strcat(text, "/gotomarket /kick /ban /setlevel /unbanip /gotopos /gotomarker\n", sizeof(text));
    strcat(text, "/kupitelefon /kupibrojtel /kupislusalice /lideri /inventory /buyinventory /kupi /smsad\n", sizeof(text));
    strcat(text, "/napravioglase /editujoglase /obrisioglase /napravizlataru /editujzlataru /obrisizlataru\n", sizeof(text));
    strcat(text, "/kupizlato /prodajzlato /kupisat /time /setleader /slap /goto /kill /setskin\n", sizeof(text));
    strcat(text, "/l /gethere /b /me /do /member /invite /uninvite /orghelp /kazniclana\n", sizeof(text));
    strcat(text, "/napravitrafiku /editujtrafiku /obrisitrafiku /kreirajobjekat /editujobjekt /obrisiobjekat\n", sizeof(text));
    strcat(text, "/trafika /kreirajlabeltrafika /obrisilabeltrafika /kreirajlabel /obrisilabel\n", sizeof(text));
    strcat(text, "/givemoney /givegun /restart /rac /rtc /artc /fix /artcveh /afixveh\n", sizeof(text));
    strcat(text, "/call /acceptfaren /duty /f /d /ooc /giverank /preuzmivozilo /bigear /veh\n", sizeof(text));
    strcat(text, "/posao /otkaz /jobhelp /engine /dovezipostu /prekiniposao /sethealth /setarmour\n", sizeof(text));
    strcat(text, "/uninviteme /stablo /sethour /setminute /name /setadmincode /unrent /rentvehiclehelp\n", sizeof(text));
    strcat(text, "/iskljucilasere /dajdinamit /resetbanku /postavidinamit /robbank\n", sizeof(text));
    strcat(text, "/happyhour /setupozorenja /setrprank /dajosiguranje /dajdpoen\n", sizeof(text));
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
    if(!HasAdminCommandAccess(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "GRESKA: Samo administracija moze koristiti /ah.");
    new text[4096];
    strcat(text, "{33CCFF}==================== {FFFFFF}Admin Help {33CCFF}====================\n\n", sizeof(text));
    strcat(text, "{33CCFF}Duznost {FFFFFF}| /adminduty\n", sizeof(text));
    strcat(text, "{33CCFF}Junior Admin {FFFFFF}| /name, /jailed, /checkdm, /checkinv, /check, /checklic, /aodg, /pm, /lockgchat, /he, /checkevent, /gotojetn\n", sizeof(text));
    strcat(text, "{33CCFF}Junior Admin {FFFFFF}| /setcarhp, /setage, /setskin, /askin, /gethere, /freeze, /unfreeze, /sethp, /setarmor, /getcar, /auntie, /awl, /gotomc\n", sizeof(text));
    strcat(text, "{33CCFF}Junior Admin {FFFFFF}| /setjob, /apark, /checkw, /flip, /kill, /cc, /ajail, /mute, /unmute, /masked, /kick, /akick, /slap, /napravipoklon, /rpslap\n", sizeof(text));
    strcat(text, "{33CCFF}Junior Admin {FFFFFF}| /spec, /specoff, /g, /h, /a, /o, /or, /pr, /rtc, /admini, /startevent, /stopevent, /jetpack, /acontracts\n", sizeof(text));
    strcat(text, "{33CCFF}Junior Admin {FFFFFF}| /mutegchat, /mutead, /muteaskq, /mutereport, /goto, /gotolist, /gotoautosk, /gotoplanina, /gotoaerodrom, /gotojob, /gotopijaca, /gotoboks\n", sizeof(text));
    strcat(text, "{33CCFF}Junior Admin {FFFFFF}| /unmuteaskq, /unmutereport, /unmutead, /unmutegchat\n\n", sizeof(text));
    strcat(text, "{FFD700}Posebne komande {FFFFFF}| /happyhour, /setupozorenja, /setrprank, /dajosiguranje, /dajdpoen\n\n", sizeof(text));
    strcat(text, "{33CCFF}Admin {FFFFFF}| Komande ce biti dodane nakon testiranja Junior Admin sistema.\n", sizeof(text));
    strcat(text, "{33CCFF}Senior Admin {FFFFFF}| Komande ce biti dodane kasnije.\n", sizeof(text));
    ShowPlayerDialog(playerid, DIALOG_ADMIN_HELP, DIALOG_STYLE_MSGBOX, "Balkan Revolution RolePlay Admin Help", text, "OK", "");
    return 1;
}

CMD:ah(playerid, params[]) return ShowAH(playerid);
CMD:ahelp(playerid, params[]) return ShowAllCommands(playerid);

stock HasSpecialCommandAccess(playerid)
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
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: Korisnicki fajl igraca nije pronadjen.");
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
        return SendClientMessage(playerid, 0xFF7777FF, "GRESKA: /happyhour je trenutno dostupan samo Vlasniku.");

    new message[128];
    if(HappyHourMultiplier == 2)
    {
        HappyHourMultiplier = 1;
        format(message, sizeof(message), "[HAPPY HOUR]: Happy Hour je zavrsen. Respekt se ponovo dobija 1x.");
    }
    else
    {
        HappyHourMultiplier = 2;
        format(message, sizeof(message), "[HAPPY HOUR]: Happy Hour je ukljucen. Respekt se sada dobija 2x.");
    }

    if(!DOF2_FileExists(STATS_SETTINGS_FILE)) DOF2_CreateFile(STATS_SETTINGS_FILE);
    DOF2_SetInt(STATS_SETTINGS_FILE, "HappyHourMultiplier", HappyHourMultiplier);
    DOF2_SaveFile();
    SendClientMessageToAll(0xFFD700FF, message);
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

forward JuniorApplyPenalties(playerid);
public JuniorApplyPenalties(playerid)
{
    if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "BR_LoggedIn")) return 1;
    new file[128];
    if(!JuniorAdminFile(playerid, file, sizeof(file))) return 1;
    LoadExtendedPlayerStats(playerid);
    JuniorMutedUntil[playerid] = DOF2_GetInt(file, "AdminMuteUntil");
    JuniorJailedUntil[playerid] = DOF2_GetInt(file, "AdminJailUntil");
    if(JuniorMutedUntil[playerid] < gettime()) JuniorMutedUntil[playerid] = 0;
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
    for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i))
    {
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
    new targetid, msg[100];
    if(sscanf(params, "us[100]", targetid, msg)) return SendClientMessage(playerid, -1, "Koristenje: /pm [ID/Ime] [Poruka]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF7777FF, "Igrac nije online.");
    new a[MAX_PLAYER_NAME], b[MAX_PLAYER_NAME], out[144]; GetPlayerName(playerid,a,sizeof(a)); GetPlayerName(targetid,b,sizeof(b));
    format(out,sizeof(out),"(( PM za %s: %s ))",b,msg); SendClientMessage(playerid,0xDDA0DDFF,out);
    format(out,sizeof(out),"(( PM od %s: %s ))",a,msg); SendClientMessage(targetid,0xDDA0DDFF,out); return 1;
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
    if(!HasAdminCommandAccess(playerid)) return 0; new id; if(sscanf(params,"u",id)||!IsPlayerConnected(id)) return SendClientMessage(playerid,-1,"Koristenje: /checkdm [ID/Ime]");
    new n[MAX_PLAYER_NAME],t[256],Float:h,Float:a; GetPlayerName(id,n,sizeof(n)); GetPlayerHealth(id,h); GetPlayerArmour(id,a);
    format(t,sizeof(t),"{33CCFF}DM provjera: %s\n\n{FFFFFF}Oruzje: %d\nMetci: %d\nHealth: %.1f\nArmor: %.1f\nWanted: %d",n,GetPlayerWeapon(id),GetPlayerAmmo(id),h,a,WantedPoints[id]); ShowPlayerDialog(playerid,DIALOG_ADMIN_CHECK,DIALOG_STYLE_MSGBOX,"DM provjera",t,"Zatvori",""); return 1;
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
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid, Float:health;
    if(sscanf(params, "uf", targetid, health))
        return SendClientMessage(playerid, -1, "Koristenje: /setcarhp [ID/Ime] [250-1000]");
    if(!IsPlayerConnected(targetid) || !IsPlayerInAnyVehicle(targetid))
        return SendClientMessage(playerid, 0xFF7777FF, "Igrac mora biti u vozilu.");
    if(health < 250.0 || health > 1000.0)
        return SendClientMessage(playerid, 0xFF7777FF, "HP vozila mora biti 250-1000.");
    SetVehicleHealth(GetPlayerVehicleID(targetid), health);
    SendClientMessage(playerid, 0x33CCFFFF, "[ADMIN]: HP vozila je postavljen.");
    return 1;
}

CMD:askin(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;new skin;if(sscanf(params,"i",skin)||skin<0||skin>311||skin==74)return SendClientMessage(playerid,-1,"Koristenje: /askin [0-311, osim 74]");SetPlayerSkin(playerid,skin);return 1;}
CMD:sethp(playerid, params[]) return cmd_sethealth(playerid, params);
CMD:setarmor(playerid, params[]) return cmd_setarmour(playerid, params);

CMD:freeze(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;new id;if(sscanf(params,"u",id)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /freeze [ID/Ime]");TogglePlayerControllable(id,0);JuniorFrozen[id]=true;SendClientMessage(id,0xFF7777FF,"[ADMIN]: Zamrznuti ste.");return 1;}
CMD:unfreeze(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;new id;if(sscanf(params,"u",id)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /unfreeze [ID/Ime]");TogglePlayerControllable(id,1);JuniorFrozen[id]=false;SendClientMessage(id,0x33CCFFFF,"[ADMIN]: Odmrznuti ste.");return 1;}
CMD:auntie(playerid, params[]) return cmd_unfreeze(playerid, params);

CMD:getcar(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, -1, "Koristenje: /getcar [ID/Ime igraca u vozilu]");
    if(!IsPlayerConnected(targetid) || !IsPlayerInAnyVehicle(targetid))
        return SendClientMessage(playerid, 0xFF7777FF, "Taj igrac nije online ili nije u vozilu.");

    new vehicleid = GetPlayerVehicleID(targetid);
    new interior = GetPlayerInterior(playerid);
    new world = GetPlayerVirtualWorld(playerid);
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetVehicleVirtualWorld(vehicleid, world);
    LinkVehicleToInterior(vehicleid, interior);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerInVehicle(i, vehicleid)) continue;
        SetPlayerInterior(i, interior);
        SetPlayerVirtualWorld(i, world);
    }
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    SetVehiclePos(vehicleid, x + 4.0, y, z + 0.5);
    VehicleHudLastPosValid[vehicleid] = false;
    SendClientMessage(playerid, 0x33CCFFFF, "[ADMIN]: Vozilo je teleportovano do vas.");
    return 1;
}

CMD:awl(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;new id,lvl,reason[64];if(sscanf(params,"uis[64]",id,lvl,reason)||!IsPlayerConnected(id)||lvl<1||lvl>20)return SendClientMessage(playerid,-1,"Koristenje: /awl [ID/Ime] [1-20] [Razlog]");AddWantedPoints(id,lvl,reason);return 1;}
CMD:he(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;SetPlayerHealth(playerid,100.0);SetPlayerArmour(playerid,100.0);SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Health i armor su obnovljeni.");return 1;}

CMD:flip(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;new id;if(sscanf(params,"u",id))id=playerid;if(!IsPlayerConnected(id)||!IsPlayerInAnyVehicle(id))return SendClientMessage(playerid,-1,"Koristenje: /flip [ID/Ime igraca u vozilu]");new v=GetPlayerVehicleID(id);new Float:a;GetVehicleZAngle(v,a);SetVehicleZAngle(v,a);return 1;}
CMD:apark(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;if(!IsPlayerInAnyVehicle(playerid))return SendClientMessage(playerid,0xFF7777FF,"Morate biti u vozilu.");new v=GetPlayerVehicleID(playerid);SetVehicleVelocity(v,0.0,0.0,0.0);VehicleHudSaveKm(v);SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Vozilo je parkirano; kilometraza je sacuvana.");return 1;}

CMD:cc(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;for(new i=0;i<30;i++)SendClientMessageToAll(-1," ");SendClientMessageToAll(0x33CCFFFF,"[ADMIN]: Chat je ociscen.");return 1;}
CMD:mute(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid, minutes, reason[64];
    if(sscanf(params, "uis[64]", targetid, minutes, reason))
        return SendClientMessage(playerid, -1, "Koristenje: /mute [ID/Ime] [Minute] [Razlog]");
    if(!IsPlayerConnected(targetid) || minutes < 1 || minutes > 1440)
        return SendClientMessage(playerid, 0xFF7777FF, "Pogresan igrac ili trajanje mutea.");
    JuniorMutedUntil[targetid] = gettime() + minutes * 60;
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

CMD:akick(playerid, params[]) return cmd_kick(playerid, params);
CMD:rpslap(playerid, params[]){if(!HasAdminCommandAccess(playerid))return 0;new id,reason[64];if(sscanf(params,"us[64]",id,reason)||!IsPlayerConnected(id))return SendClientMessage(playerid,-1,"Koristenje: /rpslap [ID/Ime] [Razlog]");new Float:h;GetPlayerHealth(id,h);SetPlayerHealth(id,h>10.0?h-10.0:1.0);new m[128];format(m,sizeof(m),"[RP SLAP]: Izgubili ste 10 HP. Razlog: %s",reason);SendClientMessage(id,0xFF7777FF,m);return 1;}
CMD:napravipoklon(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid;
    if(sscanf(params, "u", targetid) || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Koristenje: /napravipoklon [ID/Ime]");
    new amount = 500 + random(1501);
    GivePlayerMoney(targetid, amount);
    PlayerInfo[targetid][pNovac] = GetPlayerMoney(targetid);
    new file[128], message[128];
    JuniorAdminFile(targetid, file, sizeof(file));
    DOF2_SetInt(file, "Novac", PlayerInfo[targetid][pNovac]);
    DOF2_SaveFile();
    format(message, sizeof(message), "[POKLON]: Dobili ste administrativni poklon od %d RSD.", amount);
    SendClientMessage(targetid, 0x33CCFFFF, message);
    SendClientMessage(playerid, 0x33CCFFFF, "[ADMIN]: Poklon je urucen igracu.");
    return 1;
}

CMD:masked(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    new targetid;
    if(sscanf(params, "u", targetid) || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, -1, "Koristenje: /masked [ID/Ime]");
    if(GetPVarInt(targetid, "BR_Masked"))
        SendClientMessage(playerid, 0x33CCFFFF, "[MASKA]: Igrac nosi masku.");
    else
        SendClientMessage(playerid, 0x33CCFFFF, "[MASKA]: Igrac ne nosi masku.");
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
    SetPlayerInterior(playerid, JuniorSpecInterior[playerid]);
    SetPlayerVirtualWorld(playerid, JuniorSpecWorld[playerid]);
    SetPlayerPos(playerid, JuniorSpecX[playerid], JuniorSpecY[playerid], JuniorSpecZ[playerid]);
    SetCameraBehindPlayer(playerid);
    return 1;
}

stock JuniorStaffChat(playerid, const channel[], const msg[])
{
    if(!HasAdminCommandAccess(playerid))return 0;new n[MAX_PLAYER_NAME],o[144];GetPlayerName(playerid,n,sizeof(n));format(o,sizeof(o),"[%s] %s[%d]: %s",channel,n,playerid,msg);JuniorAdminMessage(o);return 1;
}
CMD:a(playerid,params[]){if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /a [Poruka]");return JuniorStaffChat(playerid,"ADMIN CHAT",params);}
CMD:g(playerid,params[]){if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /g [Poruka]");return JuniorStaffChat(playerid,"STAFF CHAT",params);}
CMD:h(playerid,params[]){if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /h [Poruka]");return JuniorStaffChat(playerid,"HELPER CHAT",params);}
CMD:o(playerid,params[]){if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /o [Poruka]");return JuniorStaffChat(playerid,"ORG NADZOR",params);}
CMD:or(playerid,params[]){if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /or [Poruka]");return JuniorStaffChat(playerid,"ORG RADIO",params);}
CMD:pr(playerid,params[]){if(!strlen(params))return SendClientMessage(playerid,-1,"Koristenje: /pr [Poruka]");return JuniorStaffChat(playerid,"REPORT CHAT",params);}

CMD:lockgchat(playerid, params[])
{
    if(!HasAdminCommandAccess(playerid)) return 0;
    JuniorGlobalChatLocked = !JuniorGlobalChatLocked;
    if(JuniorGlobalChatLocked)
        SendClientMessageToAll(0x33CCFFFF, "[CHAT]: Admin je zakljucao globalni chat.");
    else
        SendClientMessageToAll(0x33CCFFFF, "[CHAT]: Admin je otkljucao globalni chat.");
    return 1;
}

CMD:mutegchat(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorGlobalChatLocked=true;SendClientMessageToAll(0x33CCFFFF,"[CHAT]: Globalni chat je ugasen.");return 1;}
CMD:unmutegchat(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorGlobalChatLocked=false;SendClientMessageToAll(0x33CCFFFF,"[CHAT]: Globalni chat je ukljucen.");return 1;}
CMD:mutead(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;if(JuniorAdsMuted) return SendClientMessage(playerid,0xFF7777FF,"[ADMIN]: Oglasi su vec ugaseni.");JuniorAdsMuted=true;return SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Oglasi su ugaseni.");}
CMD:unmutead(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorAdsMuted=false;return SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Oglasi su ukljuceni.");}
CMD:muteaskq(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;if(JuniorAskMuted) return SendClientMessage(playerid,0xFF7777FF,"[ADMIN]: Pitanja su vec ugasena.");JuniorAskMuted=true;return SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Pitanja su ugasena.");}
CMD:unmuteaskq(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorAskMuted=false;return SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Pitanja su ukljucena.");}
CMD:mutereport(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;if(JuniorReportsMuted) return SendClientMessage(playerid,0xFF7777FF,"[ADMIN]: Reporti su vec ugaseni.");JuniorReportsMuted=true;return SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Reporti su ugaseni.");}
CMD:unmutereport(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorReportsMuted=false;return SendClientMessage(playerid,0x33CCFFFF,"[ADMIN]: Reporti su ukljuceni.");}

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
CMD:gotojob(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorTeleport(playerid,330.7,-1509.8,36.0);return 1;}
CMD:gotopijaca(playerid,params[]){if(!HasAdminCommandAccess(playerid))return 0;JuniorTeleport(playerid,1127.0,-1439.2,15.8);return 1;}
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
        if(strcmp(MarketInfo[i][mOwner], oldname, true) != 0) continue;
        format(MarketInfo[i][mOwner], MAX_PLAYER_NAME, "%s", newname);
        SaveMarket(i);
        UpdateMarketCP(i);
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

stock HandleTemporaryNameConnect(playerid, playername[])
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
    new adminname[MAX_PLAYER_NAME], adminfile[128];
    GetPlayerName(playerid, adminname, sizeof(adminname));
    format(adminfile, sizeof(adminfile), "Korisnici/%s.ini", adminname);
    new adminlevel = DOF2_FileExists(adminfile) ? DOF2_GetInt(adminfile, "Admin") : 0;
    if(adminlevel < 1 && !IsPlayerAdmin(playerid))
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Ovu komandu mogu koristiti Junior Admini i visi rankovi.");

    new targetid, days, desired[MAX_PLAYER_NAME];
    if(sscanf(params, "us[24]d", targetid, desired, days))
        return SendClientMessage(playerid, 0x00BFFFFF, "Koristenje: /name [ID/Ime] [NovoIme] [Broj dana]");
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
        return SendClientMessage(playerid, 0xFF0000FF, "[IME]: Nalog igraca nije pronadjen.");
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
