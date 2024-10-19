list inventory; // inventory to be handed out to the end-user
string product; // name of the product
list exclude = []; // list of inventory to exclude from list
string prefix = "!- Dedric Mauriac -!"; // prefix of folder given to owner with inventory
string packageSuffix = " (boxed)"; // suffix of package (usually to indicate it is boxed
string infoSuffix; // only notecards with this suffix will be handed out as package information
list noCopy = []; // items that should be given to the owner, but are no-copy
list guestInventory;

init()
{
    product = productName();
    makeInventoryList();
    
    if (llGetListLength(inventory) == 0)
        llSetText("", <0,0,0>, 0);
    else
        llSetText("Touch me to unpack\nyour new " + product + ".",<1,1,1>,1.0);

    checkInventoryPermissions();
}
makeInventoryList()
{
    inventory = [];
    guestInventory = [];
    noCopy = [];
    integer i;
    integer n = llGetInventoryNumber(INVENTORY_ALL);
    // Find every item in inventory that can be copied and build a list
    for(i = 0; i < n; i++)
    {
        string name = llGetInventoryName(INVENTORY_ALL, i);
        if(llGetInventoryPermMask(name, MASK_OWNER) & PERM_COPY)
            if(include(name))
            {
                if(canGiveGuest(name))
                    guestInventory += name;
                inventory += [name];
            }
        else if(include(name))
            noCopy += name;
    }
}
integer canGiveGuest(string name)
{
    if(llGetInventoryPermMask(name, MASK_OWNER) & PERM_TRANSFER)
    {
        if(llGetInventoryType(name) == INVENTORY_NOTECARD) return TRUE;
        if(llGetInventoryType(name) == INVENTORY_LANDMARK) return TRUE;
    }
    return FALSE;
}
string productName()
{
    // Parse product name from object name (remove suffix)
    string name = llGetObjectName();
    if(endsWith(name, packageSuffix))
        name = llGetSubString(name, 0, - (llStringLength(packageSuffix) + 1));
    return name;
}
checkInventoryPermissions()
{
    // if the creator is not the current owner, don't check permissions
    if(llGetOwner() != llGetCreator()) return;
    
    // State permission of object as a whole
    llOwnerSay(permissionString(llGetObjectPermMask(MASK_NEXT)));
    
    // Go through each object in the inventory and state its permissions
    integer count = llGetInventoryNumber(INVENTORY_ALL);
    integer i;
    for(i = 0; i < count; i++)
        checkPermissions(llGetInventoryName(INVENTORY_ALL, i));
}
integer include(string name)
{
    // determine if item should be included in inventory folder to hand out
    
    // don't include this script
    if(name == llGetScriptName()) return FALSE;
    
    if(llGetInventoryType(name) == INVENTORY_SCRIPT) return FALSE;
    
    // go through list of items to exclude
    integer i;
    integer n = llGetListLength(exclude);
    for(i = 0; i < n; i++)
        if(name == llList2String(exclude, i))
            return FALSE;
    
    // item passed the test
    return TRUE;
}
integer isLandmark(string name)
{
    // determine if the inventory is a landmark
    if(llGetInventoryType(name) != INVENTORY_LANDMARK) return FALSE;
    if(llGetInventoryPermMask(name, MASK_OWNER) & PERM_TRANSFER == FALSE) return FALSE;
    return TRUE;
}
integer isInfo(string name)
{
    // determine if the inventory is information about the product
    if(llGetInventoryType(name) != INVENTORY_NOTECARD) return FALSE;
    if(llGetInventoryPermMask(name, MASK_OWNER) & PERM_TRANSFER == FALSE) return FALSE;
    return endsWith(name, infoSuffix);
}
integer endsWith(string text, string value)
{
    // determine if name of the inventory ends with the spedified text
    return llSubStringIndex(text, value) == llStringLength(text) - llStringLength(value);
}
checkPermissions(string name)
{
    // Tell the owner what permissions are on the inventory object
    integer mask = llGetInventoryPermMask(name, MASK_NEXT);
    llOwnerSay(name + ": " + permissionString(mask));
}
string permissionString(integer mask)
{
    // Determine what permissions are available and compile a list.
    string perms = "";
    if(mask & PERM_COPY) perms += "copy, ";
    if(mask & PERM_MODIFY) perms += "modify, ";
    if(mask & PERM_TRANSFER) perms += "transfer";
    if(llGetSubString(perms, -2, -1) == ", ") perms = llGetSubString(perms, 0, -3);
    if(perms == "") perms = "limited";
    return perms;
}
default
{
    state_entry()
    {
        init();
    }
    on_rez(integer start_param)
    {
        init();
    }
    touch_start(integer total_number)
    {
        integer i = 0;
        for(i = 0; i < total_number; i++)
        {
            if(llDetectedKey(i) == llGetOwner())
            {
                if(llGetListLength(inventory))
                {
                    llGiveInventoryList(llGetOwner(), prefix + " " + product, inventory);
                    llOwnerSay("Your items are now in your inventory in a folder called " + prefix + " " + product + ". You may delete this box now. Right mouse-click the box and choose \"Move >\" and then click \"Delete\".");
                }
                // Give no-copy items if any exist
                integer n = llGetListLength(noCopy);
                if(n != 0)
                {
                    integer n2;
                    for(n2 = 0; n2 < n; n2++)
                        llGiveInventory(llDetectedKey(i), llList2String(noCopy, n2));
                    llOwnerSay("Some items are no-copy and have been placed directly in your object folder.");
                }
                if(llGetOwner() != llGetCreator()) 
                {
                    llSetText("Your new " + product + "\nhas been unpacked.",<1,1,1>,1.0);
                }
            }
            else
            {
                llInstantMessage(llDetectedKey(i), "Only the owner may unpack me.");
                integer n = llGetListLength(guestInventory);
                integer j;
                for(j = 0; i < n; j++)
                    llGiveInventory(llDetectedKey(i), llList2String(guestInventory, j));
            }
        }
    }
    changed(integer change)
    {
        if(change & CHANGED_INVENTORY) init();
    }
}