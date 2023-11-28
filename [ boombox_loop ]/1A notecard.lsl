string notecardName = "uuids";
integer ichannel = 07899;
integer cur_page = 1;
integer notecardLine;
integer chanhandlr;
key notecardQueryId;
key notecardKey;
key userUUID;
list songlist;

ReadNotecard()
{
    if (llGetInventoryKey(notecardName) == NULL_KEY)
    {
    llOwnerSay( "Notecard '" + notecardName + "' missing or unwritten.");
    return;
    }
    else if (llGetInventoryKey(notecardName) == notecardKey) return;
    notecardKey = llGetInventoryKey(notecardName);
    notecardQueryId = llGetNotecardLine(notecardName, notecardLine);
}
list order_buttons(list buttons)
{
return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) +
llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}
list numerizelist(list tlist, integer start, string apnd)
{
list newlist; integer lsize = llGetListLength(tlist); integer i;
for(; i < lsize; i++)
{
newlist += [(string)(start + i) + apnd + llList2String(tlist, i)];
}return newlist;}
dialog_songmenu(integer page)
{
integer slist_size = llGetListLength(songlist);
integer pag_amt = llCeil((float)slist_size / 9.0);
if(page > pag_amt) page = 1;
else if(page < 1) page = pag_amt;
cur_page = page; integer songsonpage;
if(page == pag_amt)
songsonpage = slist_size % 9;
if(songsonpage == 0)
songsonpage = 9; integer fspnum = (page*9)-9; list dbuf; integer i;
for(; i < songsonpage; ++i)
{
dbuf += ["Play #" + (string)(fspnum+i)];
}
list snlist = numerizelist(make_list(fspnum,i), fspnum, ". ");
llDialog(userUUID,
"Notecard Memory = "+(string)llGetFreeMemory()+"\n\n"+
llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<", "[  ♫  ]", ">>>"]),ichannel);
}
list make_list(integer a,integer b) 
{
list inventory;
integer i;
for (i = 0; i < b; ++i)
{
list items = llParseString2List(llList2String(songlist,a+i),["|"],[]);
inventory += llList2String(items,0);
}
return inventory;
}
search_music(string search)
{
        ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, "");
        integer Lengthx = llGetListLength(songlist); integer x;
        for ( ; x < Lengthx; x += 1)
        {
        string A = llToLower(search); string B = llToLower(llList2String(songlist, x));
        integer search_found = ~llSubStringIndex(B,A);
        if (search_found)
        { 
        list item = llParseString2List(llList2String(songlist, x), ["|"], []);
        integer Division= x / 9 ; llOwnerSay("[ "+llList2String(item,0)+" ] [ page = "+(string)(Division+1)+" list = "+(string)x+" ]");
        dialog_songmenu(Division+1);  
        return;
        }
    }llOwnerSay("Could not find anything");
}
dialog0()
{
ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, ""); dialog_songmenu(cur_page);
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
    }
    listen(integer chan, string sname, key skey, string text)
    {  
    if(skey == userUUID) 
    {
        if(text == "[  ♫  ]"){llMessageLinked(LINK_THIS, 0,"main", "");}
        else if(text == ">>>") dialog_songmenu(cur_page+1);
        else if(text == "<<<") dialog_songmenu(cur_page-1);
        else if(llToLower(llGetSubString(text,0,5)) == "play #")
        {
        integer pnum = (integer)llGetSubString(text, 6, -1);
        llMessageLinked(LINK_THIS, 0,"notecard="+llList2String(songlist,pnum),"");
        dialog0();
    } } }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    list items = llParseString2List(msg,["="],[]);
    if(msg == "exit_out"){userUUID = ""; ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, "");}
    if(llList2String(items,0) == "search"){search_music(llList2String(items,1));}  
    if(msg == "notecard_uuid"){dialog0();} 
    if((key)msg){userUUID = msg;}
    }
    dataserver(key query_id, string data)
    {
        if (query_id == notecardQueryId)
        {
            if (data == EOF){ }else
            {
            songlist += data; ++notecardLine;
            notecardQueryId = llGetNotecardLine(notecardName, notecardLine);
            }
        }
    }
}
