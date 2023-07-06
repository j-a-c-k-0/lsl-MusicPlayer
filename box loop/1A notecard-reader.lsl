string notecardName = "uuids";
integer notecardLine;
integer c = 80;
key notecardQueryId;
key notecardKey;
key keyUUID;
list songlist;
ReadNotecard()
{
    if (llGetInventoryKey(notecardName) == NULL_KEY)
    {
    llSay(0, "Notecard '" + notecardName + "' missing or unwritten.");
    return;
    }
    else if (llGetInventoryKey(notecardName) == notecardKey) return;
    notecardKey = llGetInventoryKey(notecardName);
    notecardQueryId = llGetNotecardLine(notecardName, notecardLine);
}
search_music(string search)
{
        integer Lengthx = llGetListLength(songlist); integer x;
        for ( ; x < Lengthx; x += 1)
        {
        string A = llToLower(search); string B = llToLower(llList2String(songlist, x));
        integer search_found = ~llSubStringIndex(B,A);
        if (search_found)
        { 
        list item = llParseString2List(llList2String(songlist, x), ["|"], []);
        llMessageLinked(LINK_THIS, 0,"playmusic_notecard"+"|"+llList2String(item, 1), NULL_KEY);
        return;
        }
    }
}
read_data(string soundname)
{
    if (llGetInventoryType(soundname) == INVENTORY_NONE)
    {
    search_music(soundname);
    return;
    }
    else
    {
    keyUUID = llGetInventoryKey(soundname);
    llMessageLinked(LINK_THIS, 0, "loop_music|" +(string)keyUUID, NULL_KEY);
    return;
    }
}
default 
{
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    changed(integer change)
    {
        if (change & CHANGED_INVENTORY)         
        {
        llResetScript();
        }
    }
    state_entry() 
    {
    ReadNotecard();
    llSetLinkTextureAnim(LINK_THIS, ANIM_ON | LOOP, ALL_SIDES,4,2, 0, 64, 8 );
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
        list params = llParseString2List(msg, ["|"], []);
        string cmd = llList2String(params, 0);
        string param1 = llList2String(params, 1);
        if(cmd == "fetch_note_rationed")
        {
        string nname = llDumpList2String(llList2ListStrided(params, 1, -1, 1), " ");
        read_data(nname);
        }
    }
    dataserver(key query_id, string data)
    {
        if (query_id == notecardQueryId)
        {
            if (data == EOF)
            {
            integer free_memory = llGetFreeMemory();
            llMessageLinked(LINK_THIS, 0, "memory_result"+"|"+(string)free_memory, NULL_KEY);
            }
            else
            {
            llMessageLinked(LINK_THIS, 0, "add_music"+"|"+data, NULL_KEY);
            songlist += data; ++notecardLine;
            notecardQueryId = llGetNotecardLine(notecardName, notecardLine);
            }
        }
    }
}