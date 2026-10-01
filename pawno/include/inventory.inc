#if defined _brp_inventory_included
    #endinput
#endif
#define _brp_inventory_included

/*
    Balkan Revolution RP - Inventory
    SA-MP / Pawn
    Base inventory UI inspired by the supplied reference image.

    Integration:
      OnPlayerConnect(playerid)        -> Inventory_Create(playerid);
      OnPlayerDisconnect(playerid, r)  -> Inventory_Destroy(playerid);
      OnPlayerClickPlayerTextDraw(...) -> if(Inventory_HandleClick(playerid, playertextid)) return 1;

    Open / close:
      Inventory_Toggle(playerid);

    Example:
      Inventory_AddItem(playerid, 348, 1, "DEAGLE", INV_TYPE_WEAPON, 24, 35);
*/

#define INV_MAX_SLOTS          (6)
#define INV_INVALID_SLOT       (-1)

#define INV_COLOR_WHITE        0xFFFFFFFF
#define INV_COLOR_GREY         0xB0B0B0FF
#define INV_COLOR_DARK         0x111111DD
#define INV_COLOR_DARK2        0x1A1A1ADD
#define INV_COLOR_GREEN        0x3A8F3AFF
#define INV_COLOR_YELLOW       0xA7842EFF
#define INV_COLOR_RED          0x8E2E2EFF

enum E_INV_TYPE
{
    INV_TYPE_NONE = 0,
    INV_TYPE_WEAPON,
    INV_TYPE_AMMO,
    INV_TYPE_FOOD,
    INV_TYPE_DRINK,
    INV_TYPE_MEDKIT,
    INV_TYPE_MISC
};

enum E_INV_ITEM
{
    invModel,
    invAmount,
    invType,
    invData1,
    invData2,
    invName[32]
};

new PlayerInventory[MAX_PLAYERS][INV_MAX_SLOTS][E_INV_ITEM];

new bool:InventoryCreated[MAX_PLAYERS];
new bool:InventoryOpen[MAX_PLAYERS];
new SelectedInvSlot[MAX_PLAYERS];

new PlayerText:InvBG[MAX_PLAYERS];
new PlayerText:InvTitleChar[MAX_PLAYERS];
new PlayerText:InvTitleInventory[MAX_PLAYERS];
new PlayerText:InvClose[MAX_PLAYERS];
new PlayerText:InvCharacter[MAX_PLAYERS];

new PlayerText:InvBodyLabel[MAX_PLAYERS];
new PlayerText:InvHeadLabel[MAX_PLAYERS];
new PlayerText:InvBackpackLabel[MAX_PLAYERS];
new PlayerText:InvWeapon1Label[MAX_PLAYERS];
new PlayerText:InvWeapon2Label[MAX_PLAYERS];
new PlayerText:InvWeapon3Label[MAX_PLAYERS];

new PlayerText:InvBodyBox[MAX_PLAYERS];
new PlayerText:InvHeadBox[MAX_PLAYERS];
new PlayerText:InvBackpackBox[MAX_PLAYERS];
new PlayerText:InvWeapon1Box[MAX_PLAYERS];
new PlayerText:InvWeapon2Box[MAX_PLAYERS];
new PlayerText:InvWeapon3Box[MAX_PLAYERS];

new PlayerText:InvSlot[MAX_PLAYERS][INV_MAX_SLOTS];
new PlayerText:InvSlotPreview[MAX_PLAYERS][INV_MAX_SLOTS];
new PlayerText:InvSlotAmount[MAX_PLAYERS][INV_MAX_SLOTS];

new PlayerText:InvInfoBG[MAX_PLAYERS];
new PlayerText:InvItemPreview[MAX_PLAYERS];
new PlayerText:InvItemName[MAX_PLAYERS];
new PlayerText:InvItemDesc[MAX_PLAYERS];

new PlayerText:InvUse[MAX_PLAYERS];
new PlayerText:InvSplit[MAX_PLAYERS];
new PlayerText:InvDrop[MAX_PLAYERS];


/* =========================================================
   INTERNAL HELPERS
   ========================================================= */

stock Inventory_ResetSlot(playerid, slot)
{
    if(slot < 0 || slot >= INV_MAX_SLOTS)
        return 0;

    PlayerInventory[playerid][slot][invModel] = 0;
    PlayerInventory[playerid][slot][invAmount] = 0;
    PlayerInventory[playerid][slot][invType] = _:INV_TYPE_NONE;
    PlayerInventory[playerid][slot][invData1] = 0;
    PlayerInventory[playerid][slot][invData2] = 0;
    PlayerInventory[playerid][slot][invName][0] = EOS;
    return 1;
}

stock Inventory_Clear(playerid)
{
    for(new i = 0; i < INV_MAX_SLOTS; i++)
        Inventory_ResetSlot(playerid, i);

    SelectedInvSlot[playerid] = INV_INVALID_SLOT;
    return 1;
}

stock Inventory_FindFreeSlot(playerid)
{
    for(new i = 0; i < INV_MAX_SLOTS; i++)
    {
        if(PlayerInventory[playerid][i][invModel] == 0)
            return i;
    }
    return INV_INVALID_SLOT;
}

stock Inventory_FindSameStack(playerid, model, E_INV_TYPE:type, data1, data2, const name[])
{
    for(new i = 0; i < INV_MAX_SLOTS; i++)
    {
        if(PlayerInventory[playerid][i][invModel] != model)
            continue;

        if(PlayerInventory[playerid][i][invType] != _:type)
            continue;

        if(PlayerInventory[playerid][i][invData1] != data1)
            continue;

        if(PlayerInventory[playerid][i][invData2] != data2)
            continue;

        if(strcmp(PlayerInventory[playerid][i][invName], name, true) != 0)
            continue;

        return i;
    }
    return INV_INVALID_SLOT;
}

stock Inventory_UpdateSlot(playerid, slot)
{
    if(!InventoryCreated[playerid])
        return 0;

    if(slot < 0 || slot >= INV_MAX_SLOTS)
        return 0;

    if(PlayerInventory[playerid][slot][invModel] == 0)
    {
        PlayerTextDrawHide(playerid, InvSlotPreview[playerid][slot]);
        PlayerTextDrawSetString(playerid, InvSlotAmount[playerid][slot], "");
        PlayerTextDrawHide(playerid, InvSlotAmount[playerid][slot]);
        return 1;
    }

    PlayerTextDrawSetPreviewModel(
        playerid,
        InvSlotPreview[playerid][slot],
        PlayerInventory[playerid][slot][invModel]
    );

    PlayerTextDrawShow(playerid, InvSlotPreview[playerid][slot]);

    new amountText[16];
    if(PlayerInventory[playerid][slot][invAmount] > 1)
        format(amountText, sizeof(amountText), "x%d", PlayerInventory[playerid][slot][invAmount]);
    else
        amountText[0] = EOS;

    PlayerTextDrawSetString(playerid, InvSlotAmount[playerid][slot], amountText);

    if(PlayerInventory[playerid][slot][invAmount] > 1)
        PlayerTextDrawShow(playerid, InvSlotAmount[playerid][slot]);
    else
        PlayerTextDrawHide(playerid, InvSlotAmount[playerid][slot]);

    return 1;
}

stock Inventory_UpdateAllSlots(playerid)
{
    for(new i = 0; i < INV_MAX_SLOTS; i++)
        Inventory_UpdateSlot(playerid, i);

    return 1;
}

stock Inventory_ClearSelection(playerid)
{
    SelectedInvSlot[playerid] = INV_INVALID_SLOT;

    PlayerTextDrawSetString(playerid, InvItemName[playerid], "NO ITEM");
    PlayerTextDrawSetString(playerid, InvItemDesc[playerid], "SELECT AN ITEM");
    PlayerTextDrawHide(playerid, InvItemPreview[playerid]);
    return 1;
}

stock Inventory_Select(playerid, slot)
{
    if(slot < 0 || slot >= INV_MAX_SLOTS)
        return 0;

    if(PlayerInventory[playerid][slot][invModel] == 0)
    {
        Inventory_ClearSelection(playerid);
        return 1;
    }

    SelectedInvSlot[playerid] = slot;

    PlayerTextDrawSetPreviewModel(
        playerid,
        InvItemPreview[playerid],
        PlayerInventory[playerid][slot][invModel]
    );

    PlayerTextDrawSetString(
        playerid,
        InvItemName[playerid],
        PlayerInventory[playerid][slot][invName]
    );

    new desc[96];
    format(desc, sizeof(desc), "KOLICINA: %d", PlayerInventory[playerid][slot][invAmount]);
    PlayerTextDrawSetString(playerid, InvItemDesc[playerid], desc);
    PlayerTextDrawShow(playerid, InvItemPreview[playerid]);

    return 1;
}


/* =========================================================
   ITEM API
   ========================================================= */

stock Inventory_AddItem(playerid, model, amount, const name[], E_INV_TYPE:type = INV_TYPE_MISC, data1 = 0, data2 = 0)
{
    if(amount <= 0 || model <= 0)
        return INV_INVALID_SLOT;

    new slot = Inventory_FindSameStack(playerid, model, type, data1, data2, name);

    if(slot == INV_INVALID_SLOT)
        slot = Inventory_FindFreeSlot(playerid);

    if(slot == INV_INVALID_SLOT)
        return INV_INVALID_SLOT;

    if(PlayerInventory[playerid][slot][invModel] == 0)
    {
        PlayerInventory[playerid][slot][invModel] = model;
        PlayerInventory[playerid][slot][invAmount] = amount;
        PlayerInventory[playerid][slot][invType] = _:type;
        PlayerInventory[playerid][slot][invData1] = data1;
        PlayerInventory[playerid][slot][invData2] = data2;
        format(PlayerInventory[playerid][slot][invName], 32, "%s", name);
    }
    else
    {
        PlayerInventory[playerid][slot][invAmount] += amount;
    }

    if(InventoryOpen[playerid])
        Inventory_UpdateSlot(playerid, slot);

    return slot;
}

stock Inventory_RemoveAmount(playerid, slot, amount)
{
    if(slot < 0 || slot >= INV_MAX_SLOTS)
        return 0;

    if(PlayerInventory[playerid][slot][invModel] == 0)
        return 0;

    if(amount <= 0)
        return 0;

    PlayerInventory[playerid][slot][invAmount] -= amount;

    if(PlayerInventory[playerid][slot][invAmount] <= 0)
    {
        Inventory_ResetSlot(playerid, slot);

        if(SelectedInvSlot[playerid] == slot)
            Inventory_ClearSelection(playerid);
    }
    else if(SelectedInvSlot[playerid] == slot)
    {
        Inventory_Select(playerid, slot);
    }

    if(InventoryOpen[playerid])
        Inventory_UpdateSlot(playerid, slot);

    return 1;
}


/* =========================================================
   ACTIONS
   ========================================================= */

stock Inventory_UseSelected(playerid)
{
    new slot = SelectedInvSlot[playerid];

    if(slot == INV_INVALID_SLOT)
        return SendClientMessage(playerid, 0xFF4444FF, "[INVENTORY] Odaberi item.");

    if(PlayerInventory[playerid][slot][invModel] == 0)
        return Inventory_ClearSelection(playerid);

    switch(PlayerInventory[playerid][slot][invType])
    {
        case INV_TYPE_WEAPON:
        {
            // data1 = weapon ID, data2 = ammo
            new weaponid = PlayerInventory[playerid][slot][invData1];
            new ammo = PlayerInventory[playerid][slot][invData2];

            if(weaponid <= 0)
                return SendClientMessage(playerid, 0xFF4444FF, "[INVENTORY] Ovaj weapon item nije pravilno konfigurisan.");

            if(ammo <= 0)
                ammo = 1;

            GivePlayerWeapon(playerid, weaponid, ammo);
            Inventory_RemoveAmount(playerid, slot, 1);

            SendClientMessage(playerid, 0x55CC55FF, "[INVENTORY] Oruzje je izvadjeno iz inventoryja.");
        }

        case INV_TYPE_FOOD:
        {
            new Float:hp;
            GetPlayerHealth(playerid, hp);

            hp += 15.0;
            if(hp > 100.0) hp = 100.0;

            SetPlayerHealth(playerid, hp);
            Inventory_RemoveAmount(playerid, slot, 1);

            SendClientMessage(playerid, 0x55CC55FF, "[INVENTORY] Pojeo si item.");
        }

        case INV_TYPE_DRINK:
        {
            new Float:hp;
            GetPlayerHealth(playerid, hp);

            hp += 5.0;
            if(hp > 100.0) hp = 100.0;

            SetPlayerHealth(playerid, hp);
            Inventory_RemoveAmount(playerid, slot, 1);

            SendClientMessage(playerid, 0x55CC55FF, "[INVENTORY] Popio si item.");
        }

        case INV_TYPE_MEDKIT:
        {
            new Float:hp;
            GetPlayerHealth(playerid, hp);

            hp += 35.0;
            if(hp > 100.0) hp = 100.0;

            SetPlayerHealth(playerid, hp);
            Inventory_RemoveAmount(playerid, slot, 1);

            SendClientMessage(playerid, 0x55CC55FF, "[INVENTORY] Iskoristio si medkit.");
        }

        default:
        {
            SendClientMessage(playerid, 0xFFCC55FF, "[INVENTORY] Ovaj item trenutno nema USE akciju.");
        }
    }

    return 1;
}

stock Inventory_SplitSelected(playerid)
{
    new slot = SelectedInvSlot[playerid];

    if(slot == INV_INVALID_SLOT)
        return SendClientMessage(playerid, 0xFF4444FF, "[INVENTORY] Odaberi item.");

    new amount = PlayerInventory[playerid][slot][invAmount];

    if(amount < 2)
        return SendClientMessage(playerid, 0xFFCC55FF, "[INVENTORY] Item nema dovoljno komada za SPLIT.");

    new freeSlot = Inventory_FindFreeSlot(playerid);

    if(freeSlot == INV_INVALID_SLOT)
        return SendClientMessage(playerid, 0xFF4444FF, "[INVENTORY] Nemate slobodan slot.");

    new moved = amount / 2;

    PlayerInventory[playerid][slot][invAmount] -= moved;

    PlayerInventory[playerid][freeSlot][invModel] = PlayerInventory[playerid][slot][invModel];
    PlayerInventory[playerid][freeSlot][invAmount] = moved;
    PlayerInventory[playerid][freeSlot][invType] = PlayerInventory[playerid][slot][invType];
    PlayerInventory[playerid][freeSlot][invData1] = PlayerInventory[playerid][slot][invData1];
    PlayerInventory[playerid][freeSlot][invData2] = PlayerInventory[playerid][slot][invData2];
    format(
        PlayerInventory[playerid][freeSlot][invName],
        32,
        "%s",
        PlayerInventory[playerid][slot][invName]
    );

    Inventory_UpdateSlot(playerid, slot);
    Inventory_UpdateSlot(playerid, freeSlot);
    Inventory_Select(playerid, slot);

    SendClientMessage(playerid, 0x55CC55FF, "[INVENTORY] Stack je podijeljen.");
    return 1;
}

stock Inventory_DropSelected(playerid)
{
    new slot = SelectedInvSlot[playerid];

    if(slot == INV_INVALID_SLOT)
        return SendClientMessage(playerid, 0xFF4444FF, "[INVENTORY] Odaberi item.");

    if(PlayerInventory[playerid][slot][invModel] == 0)
        return Inventory_ClearSelection(playerid);

    /*
        Base version:
        item is removed from inventory.

        If you later want world pickups, connect this function to your
        pickup / dropped-item system and save:
          model, amount, type, data1, data2, name, X, Y, Z.
    */

    new droppedName[32];
    format(droppedName, sizeof(droppedName), "%s", PlayerInventory[playerid][slot][invName]);

    Inventory_RemoveAmount(playerid, slot, 1);

    new msg[96];
    format(msg, sizeof(msg), "[INVENTORY] Bacio si 1x %s.", droppedName);
    SendClientMessage(playerid, 0xFFCC55FF, msg);

    return 1;
}


/* =========================================================
   TEXTDRAW CREATION
   ========================================================= */

stock Inventory_Create(playerid)
{
    if(InventoryCreated[playerid])
        return 1;

    InventoryCreated[playerid] = true;
    InventoryOpen[playerid] = false;
    SelectedInvSlot[playerid] = INV_INVALID_SLOT;

    // MAIN BACKGROUND
    InvBG[playerid] = CreatePlayerTextDraw(playerid, 66.0, 100.0, "_");
    PlayerTextDrawTextSize(playerid, InvBG[playerid], 619.0, 0.0);
    PlayerTextDrawLetterSize(playerid, InvBG[playerid], 0.0, 18.5);
    PlayerTextDrawUseBox(playerid, InvBG[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvBG[playerid], INV_COLOR_DARK);
    PlayerTextDrawFont(playerid, InvBG[playerid], 1);

    InvTitleChar[playerid] = CreatePlayerTextDraw(playerid, 72.0, 103.0, "CHARACTER");
    PlayerTextDrawLetterSize(playerid, InvTitleChar[playerid], 0.22, 1.0);
    PlayerTextDrawFont(playerid, InvTitleChar[playerid], 2);
    PlayerTextDrawColor(playerid, InvTitleChar[playerid], INV_COLOR_WHITE);

    InvTitleInventory[playerid] = CreatePlayerTextDraw(playerid, 337.0, 103.0, "YOUR INVENTORY");
    PlayerTextDrawLetterSize(playerid, InvTitleInventory[playerid], 0.22, 1.0);
    PlayerTextDrawFont(playerid, InvTitleInventory[playerid], 2);
    PlayerTextDrawColor(playerid, InvTitleInventory[playerid], INV_COLOR_WHITE);

    InvClose[playerid] = CreatePlayerTextDraw(playerid, 604.0, 102.0, "X");
    PlayerTextDrawTextSize(playerid, InvClose[playerid], 617.0, 115.0);
    PlayerTextDrawLetterSize(playerid, InvClose[playerid], 0.24, 1.0);
    PlayerTextDrawFont(playerid, InvClose[playerid], 2);
    PlayerTextDrawColor(playerid, InvClose[playerid], INV_COLOR_WHITE);
    PlayerTextDrawSetSelectable(playerid, InvClose[playerid], 1);

    // CHARACTER PREVIEW
    InvCharacter[playerid] = CreatePlayerTextDraw(playerid, 151.0, 126.0, "");
    PlayerTextDrawTextSize(playerid, InvCharacter[playerid], 239.0, 291.0);
    PlayerTextDrawFont(playerid, InvCharacter[playerid], 5);
    PlayerTextDrawSetPreviewModel(playerid, InvCharacter[playerid], 0);
    PlayerTextDrawSetPreviewRot(playerid, InvCharacter[playerid], -10.0, 0.0, -20.0, 1.0);

    // LABELS
    InvBodyLabel[playerid] = CreatePlayerTextDraw(playerid, 118.0, 153.0, "BODY");
    InvHeadLabel[playerid] = CreatePlayerTextDraw(playerid, 244.0, 122.0, "HEAD");
    InvBackpackLabel[playerid] = CreatePlayerTextDraw(playerid, 244.0, 153.0, "BACKPACK");
    InvWeapon1Label[playerid] = CreatePlayerTextDraw(playerid, 118.0, 206.0, "WEAPON");
    InvWeapon2Label[playerid] = CreatePlayerTextDraw(playerid, 244.0, 206.0, "WEAPON");
    InvWeapon3Label[playerid] = CreatePlayerTextDraw(playerid, 118.0, 259.0, "WEAPON");

    new PlayerText:labels[6];
    labels[0] = InvBodyLabel[playerid];
    labels[1] = InvHeadLabel[playerid];
    labels[2] = InvBackpackLabel[playerid];
    labels[3] = InvWeapon1Label[playerid];
    labels[4] = InvWeapon2Label[playerid];
    labels[5] = InvWeapon3Label[playerid];

    for(new i = 0; i < 6; i++)
    {
        PlayerTextDrawLetterSize(playerid, labels[i], 0.14, 0.7);
        PlayerTextDrawFont(playerid, labels[i], 2);
        PlayerTextDrawColor(playerid, labels[i], INV_COLOR_WHITE);
    }

    // EQUIPMENT BOXES
    InvBodyBox[playerid] = CreatePlayerTextDraw(playerid, 116.0, 164.0, "_");
    PlayerTextDrawTextSize(playerid, InvBodyBox[playerid], 151.0, 0.0);
    PlayerTextDrawLetterSize(playerid, InvBodyBox[playerid], 0.0, 2.9);
    PlayerTextDrawUseBox(playerid, InvBodyBox[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvBodyBox[playerid], INV_COLOR_DARK2);

    InvHeadBox[playerid] = CreatePlayerTextDraw(playerid, 243.0, 133.0, "_");
    PlayerTextDrawTextSize(playerid, InvHeadBox[playerid], 278.0, 0.0);
    PlayerTextDrawLetterSize(playerid, InvHeadBox[playerid], 0.0, 2.9);
    PlayerTextDrawUseBox(playerid, InvHeadBox[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvHeadBox[playerid], INV_COLOR_DARK2);

    InvBackpackBox[playerid] = CreatePlayerTextDraw(playerid, 243.0, 164.0, "_");
    PlayerTextDrawTextSize(playerid, InvBackpackBox[playerid], 278.0, 0.0);
    PlayerTextDrawLetterSize(playerid, InvBackpackBox[playerid], 0.0, 2.9);
    PlayerTextDrawUseBox(playerid, InvBackpackBox[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvBackpackBox[playerid], INV_COLOR_DARK2);

    InvWeapon1Box[playerid] = CreatePlayerTextDraw(playerid, 116.0, 217.0, "_");
    PlayerTextDrawTextSize(playerid, InvWeapon1Box[playerid], 151.0, 0.0);
    PlayerTextDrawLetterSize(playerid, InvWeapon1Box[playerid], 0.0, 2.9);
    PlayerTextDrawUseBox(playerid, InvWeapon1Box[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvWeapon1Box[playerid], INV_COLOR_DARK2);

    InvWeapon2Box[playerid] = CreatePlayerTextDraw(playerid, 243.0, 217.0, "_");
    PlayerTextDrawTextSize(playerid, InvWeapon2Box[playerid], 278.0, 0.0);
    PlayerTextDrawLetterSize(playerid, InvWeapon2Box[playerid], 0.0, 2.9);
    PlayerTextDrawUseBox(playerid, InvWeapon2Box[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvWeapon2Box[playerid], INV_COLOR_DARK2);

    InvWeapon3Box[playerid] = CreatePlayerTextDraw(playerid, 116.0, 270.0, "_");
    PlayerTextDrawTextSize(playerid, InvWeapon3Box[playerid], 151.0, 0.0);
    PlayerTextDrawLetterSize(playerid, InvWeapon3Box[playerid], 0.0, 2.9);
    PlayerTextDrawUseBox(playerid, InvWeapon3Box[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvWeapon3Box[playerid], INV_COLOR_DARK2);

    // INVENTORY SLOTS
    for(new i = 0; i < INV_MAX_SLOTS; i++)
    {
        new Float:x = 337.0 + (i * 46.0);

        InvSlot[playerid][i] = CreatePlayerTextDraw(playerid, x, 128.0, "_");
        PlayerTextDrawTextSize(playerid, InvSlot[playerid][i], x + 42.0, 0.0);
        PlayerTextDrawLetterSize(playerid, InvSlot[playerid][i], 0.0, 3.5);
        PlayerTextDrawUseBox(playerid, InvSlot[playerid][i], 1);
        PlayerTextDrawBoxColor(playerid, InvSlot[playerid][i], INV_COLOR_DARK2);
        PlayerTextDrawSetSelectable(playerid, InvSlot[playerid][i], 1);

        InvSlotPreview[playerid][i] = CreatePlayerTextDraw(playerid, x + 3.0, 131.0, "");
        PlayerTextDrawTextSize(playerid, InvSlotPreview[playerid][i], x + 38.0, 164.0);
        PlayerTextDrawFont(playerid, InvSlotPreview[playerid][i], 5);
        PlayerTextDrawSetPreviewModel(playerid, InvSlotPreview[playerid][i], 18631);
        PlayerTextDrawSetPreviewRot(playerid, InvSlotPreview[playerid][i], -10.0, 0.0, -20.0, 1.0);

        InvSlotAmount[playerid][i] = CreatePlayerTextDraw(playerid, x + 38.0, 153.0, "");
        PlayerTextDrawLetterSize(playerid, InvSlotAmount[playerid][i], 0.16, 0.7);
        PlayerTextDrawAlignment(playerid, InvSlotAmount[playerid][i], 3);
        PlayerTextDrawFont(playerid, InvSlotAmount[playerid][i], 2);
        PlayerTextDrawColor(playerid, InvSlotAmount[playerid][i], INV_COLOR_WHITE);
    }

    // LOWER ITEM PANEL
    InvInfoBG[playerid] = CreatePlayerTextDraw(playerid, 337.0, 270.0, "_");
    PlayerTextDrawTextSize(playerid, InvInfoBG[playerid], 619.0, 0.0);
    PlayerTextDrawLetterSize(playerid, InvInfoBG[playerid], 0.0, 4.8);
    PlayerTextDrawUseBox(playerid, InvInfoBG[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvInfoBG[playerid], INV_COLOR_DARK2);

    InvItemPreview[playerid] = CreatePlayerTextDraw(playerid, 342.0, 276.0, "");
    PlayerTextDrawTextSize(playerid, InvItemPreview[playerid], 405.0, 322.0);
    PlayerTextDrawFont(playerid, InvItemPreview[playerid], 5);
    PlayerTextDrawSetPreviewModel(playerid, InvItemPreview[playerid], 18631);
    PlayerTextDrawSetPreviewRot(playerid, InvItemPreview[playerid], -10.0, 0.0, -20.0, 1.0);

    InvItemName[playerid] = CreatePlayerTextDraw(playerid, 412.0, 273.0, "NO ITEM");
    PlayerTextDrawLetterSize(playerid, InvItemName[playerid], 0.24, 1.0);
    PlayerTextDrawFont(playerid, InvItemName[playerid], 2);
    PlayerTextDrawColor(playerid, InvItemName[playerid], INV_COLOR_WHITE);

    InvItemDesc[playerid] = CreatePlayerTextDraw(playerid, 412.0, 293.0, "SELECT AN ITEM");
    PlayerTextDrawLetterSize(playerid, InvItemDesc[playerid], 0.14, 0.7);
    PlayerTextDrawFont(playerid, InvItemDesc[playerid], 1);
    PlayerTextDrawColor(playerid, InvItemDesc[playerid], INV_COLOR_GREY);

    // BUTTONS
    InvUse[playerid] = CreatePlayerTextDraw(playerid, 540.0, 270.0, "USE");
    PlayerTextDrawTextSize(playerid, InvUse[playerid], 616.0, 286.0);
    PlayerTextDrawLetterSize(playerid, InvUse[playerid], 0.25, 1.0);
    PlayerTextDrawAlignment(playerid, InvUse[playerid], 2);
    PlayerTextDrawUseBox(playerid, InvUse[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvUse[playerid], INV_COLOR_GREEN);
    PlayerTextDrawColor(playerid, InvUse[playerid], INV_COLOR_WHITE);
    PlayerTextDrawFont(playerid, InvUse[playerid], 2);
    PlayerTextDrawSetSelectable(playerid, InvUse[playerid], 1);

    InvSplit[playerid] = CreatePlayerTextDraw(playerid, 540.0, 288.0, "SPLIT");
    PlayerTextDrawTextSize(playerid, InvSplit[playerid], 616.0, 304.0);
    PlayerTextDrawLetterSize(playerid, InvSplit[playerid], 0.25, 1.0);
    PlayerTextDrawAlignment(playerid, InvSplit[playerid], 2);
    PlayerTextDrawUseBox(playerid, InvSplit[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvSplit[playerid], INV_COLOR_YELLOW);
    PlayerTextDrawColor(playerid, InvSplit[playerid], INV_COLOR_WHITE);
    PlayerTextDrawFont(playerid, InvSplit[playerid], 2);
    PlayerTextDrawSetSelectable(playerid, InvSplit[playerid], 1);

    InvDrop[playerid] = CreatePlayerTextDraw(playerid, 540.0, 306.0, "DROP");
    PlayerTextDrawTextSize(playerid, InvDrop[playerid], 616.0, 322.0);
    PlayerTextDrawLetterSize(playerid, InvDrop[playerid], 0.25, 1.0);
    PlayerTextDrawAlignment(playerid, InvDrop[playerid], 2);
    PlayerTextDrawUseBox(playerid, InvDrop[playerid], 1);
    PlayerTextDrawBoxColor(playerid, InvDrop[playerid], INV_COLOR_RED);
    PlayerTextDrawColor(playerid, InvDrop[playerid], INV_COLOR_WHITE);
    PlayerTextDrawFont(playerid, InvDrop[playerid], 2);
    PlayerTextDrawSetSelectable(playerid, InvDrop[playerid], 1);

    return 1;
}


/* =========================================================
   SHOW / HIDE
   ========================================================= */

stock Inventory_Show(playerid)
{
    if(!InventoryCreated[playerid])
        Inventory_Create(playerid);

    if(InventoryOpen[playerid])
        return 1;

    InventoryOpen[playerid] = true;
    SelectedInvSlot[playerid] = INV_INVALID_SLOT;

    PlayerTextDrawSetPreviewModel(playerid, InvCharacter[playerid], GetPlayerSkin(playerid));

    PlayerTextDrawShow(playerid, InvBG[playerid]);
    PlayerTextDrawShow(playerid, InvTitleChar[playerid]);
    PlayerTextDrawShow(playerid, InvTitleInventory[playerid]);
    PlayerTextDrawShow(playerid, InvClose[playerid]);
    PlayerTextDrawShow(playerid, InvCharacter[playerid]);

    PlayerTextDrawShow(playerid, InvBodyLabel[playerid]);
    PlayerTextDrawShow(playerid, InvHeadLabel[playerid]);
    PlayerTextDrawShow(playerid, InvBackpackLabel[playerid]);
    PlayerTextDrawShow(playerid, InvWeapon1Label[playerid]);
    PlayerTextDrawShow(playerid, InvWeapon2Label[playerid]);
    PlayerTextDrawShow(playerid, InvWeapon3Label[playerid]);

    PlayerTextDrawShow(playerid, InvBodyBox[playerid]);
    PlayerTextDrawShow(playerid, InvHeadBox[playerid]);
    PlayerTextDrawShow(playerid, InvBackpackBox[playerid]);
    PlayerTextDrawShow(playerid, InvWeapon1Box[playerid]);
    PlayerTextDrawShow(playerid, InvWeapon2Box[playerid]);
    PlayerTextDrawShow(playerid, InvWeapon3Box[playerid]);

    for(new i = 0; i < INV_MAX_SLOTS; i++)
        PlayerTextDrawShow(playerid, InvSlot[playerid][i]);

    PlayerTextDrawShow(playerid, InvInfoBG[playerid]);
    PlayerTextDrawShow(playerid, InvItemName[playerid]);
    PlayerTextDrawShow(playerid, InvItemDesc[playerid]);

    PlayerTextDrawShow(playerid, InvUse[playerid]);
    PlayerTextDrawShow(playerid, InvSplit[playerid]);
    PlayerTextDrawShow(playerid, InvDrop[playerid]);

    Inventory_UpdateAllSlots(playerid);
    Inventory_ClearSelection(playerid);

    SelectTextDraw(playerid, INV_COLOR_WHITE);
    return 1;
}

stock Inventory_Hide(playerid)
{
    if(!InventoryCreated[playerid])
        return 1;

    InventoryOpen[playerid] = false;
    SelectedInvSlot[playerid] = INV_INVALID_SLOT;

    PlayerTextDrawHide(playerid, InvBG[playerid]);
    PlayerTextDrawHide(playerid, InvTitleChar[playerid]);
    PlayerTextDrawHide(playerid, InvTitleInventory[playerid]);
    PlayerTextDrawHide(playerid, InvClose[playerid]);
    PlayerTextDrawHide(playerid, InvCharacter[playerid]);

    PlayerTextDrawHide(playerid, InvBodyLabel[playerid]);
    PlayerTextDrawHide(playerid, InvHeadLabel[playerid]);
    PlayerTextDrawHide(playerid, InvBackpackLabel[playerid]);
    PlayerTextDrawHide(playerid, InvWeapon1Label[playerid]);
    PlayerTextDrawHide(playerid, InvWeapon2Label[playerid]);
    PlayerTextDrawHide(playerid, InvWeapon3Label[playerid]);

    PlayerTextDrawHide(playerid, InvBodyBox[playerid]);
    PlayerTextDrawHide(playerid, InvHeadBox[playerid]);
    PlayerTextDrawHide(playerid, InvBackpackBox[playerid]);
    PlayerTextDrawHide(playerid, InvWeapon1Box[playerid]);
    PlayerTextDrawHide(playerid, InvWeapon2Box[playerid]);
    PlayerTextDrawHide(playerid, InvWeapon3Box[playerid]);

    for(new i = 0; i < INV_MAX_SLOTS; i++)
    {
        PlayerTextDrawHide(playerid, InvSlot[playerid][i]);
        PlayerTextDrawHide(playerid, InvSlotPreview[playerid][i]);
        PlayerTextDrawHide(playerid, InvSlotAmount[playerid][i]);
    }

    PlayerTextDrawHide(playerid, InvInfoBG[playerid]);
    PlayerTextDrawHide(playerid, InvItemPreview[playerid]);
    PlayerTextDrawHide(playerid, InvItemName[playerid]);
    PlayerTextDrawHide(playerid, InvItemDesc[playerid]);

    PlayerTextDrawHide(playerid, InvUse[playerid]);
    PlayerTextDrawHide(playerid, InvSplit[playerid]);
    PlayerTextDrawHide(playerid, InvDrop[playerid]);

    CancelSelectTextDraw(playerid);
    return 1;
}

stock Inventory_Toggle(playerid)
{
    if(InventoryOpen[playerid])
        return Inventory_Hide(playerid);

    return Inventory_Show(playerid);
}

stock Inventory_Destroy(playerid)
{
    if(!InventoryCreated[playerid])
        return 1;

    Inventory_Hide(playerid);

    PlayerTextDrawDestroy(playerid, InvBG[playerid]);
    PlayerTextDrawDestroy(playerid, InvTitleChar[playerid]);
    PlayerTextDrawDestroy(playerid, InvTitleInventory[playerid]);
    PlayerTextDrawDestroy(playerid, InvClose[playerid]);
    PlayerTextDrawDestroy(playerid, InvCharacter[playerid]);

    PlayerTextDrawDestroy(playerid, InvBodyLabel[playerid]);
    PlayerTextDrawDestroy(playerid, InvHeadLabel[playerid]);
    PlayerTextDrawDestroy(playerid, InvBackpackLabel[playerid]);
    PlayerTextDrawDestroy(playerid, InvWeapon1Label[playerid]);
    PlayerTextDrawDestroy(playerid, InvWeapon2Label[playerid]);
    PlayerTextDrawDestroy(playerid, InvWeapon3Label[playerid]);

    PlayerTextDrawDestroy(playerid, InvBodyBox[playerid]);
    PlayerTextDrawDestroy(playerid, InvHeadBox[playerid]);
    PlayerTextDrawDestroy(playerid, InvBackpackBox[playerid]);
    PlayerTextDrawDestroy(playerid, InvWeapon1Box[playerid]);
    PlayerTextDrawDestroy(playerid, InvWeapon2Box[playerid]);
    PlayerTextDrawDestroy(playerid, InvWeapon3Box[playerid]);

    for(new i = 0; i < INV_MAX_SLOTS; i++)
    {
        PlayerTextDrawDestroy(playerid, InvSlot[playerid][i]);
        PlayerTextDrawDestroy(playerid, InvSlotPreview[playerid][i]);
        PlayerTextDrawDestroy(playerid, InvSlotAmount[playerid][i]);
    }

    PlayerTextDrawDestroy(playerid, InvInfoBG[playerid]);
    PlayerTextDrawDestroy(playerid, InvItemPreview[playerid]);
    PlayerTextDrawDestroy(playerid, InvItemName[playerid]);
    PlayerTextDrawDestroy(playerid, InvItemDesc[playerid]);

    PlayerTextDrawDestroy(playerid, InvUse[playerid]);
    PlayerTextDrawDestroy(playerid, InvSplit[playerid]);
    PlayerTextDrawDestroy(playerid, InvDrop[playerid]);

    InventoryCreated[playerid] = false;
    InventoryOpen[playerid] = false;
    SelectedInvSlot[playerid] = INV_INVALID_SLOT;
    return 1;
}


/* =========================================================
   CLICK HANDLER
   ========================================================= */

stock Inventory_HandleClick(playerid, PlayerText:playertextid)
{
    if(!InventoryOpen[playerid])
        return 0;

    if(playertextid == InvClose[playerid])
    {
        Inventory_Hide(playerid);
        return 1;
    }

    for(new i = 0; i < INV_MAX_SLOTS; i++)
    {
        if(playertextid == InvSlot[playerid][i])
        {
            Inventory_Select(playerid, i);
            return 1;
        }
    }

    if(playertextid == InvUse[playerid])
    {
        Inventory_UseSelected(playerid);
        return 1;
    }

    if(playertextid == InvSplit[playerid])
    {
        Inventory_SplitSelected(playerid);
        return 1;
    }

    if(playertextid == InvDrop[playerid])
    {
        Inventory_DropSelected(playerid);
        return 1;
    }

    return 0;
}
