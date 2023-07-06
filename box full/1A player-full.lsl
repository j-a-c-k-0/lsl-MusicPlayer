string notecardName = "whitelist";
string music_selection = "none";
string music_song = "none";
key userUUID;
integer arrow_play_sound = FALSE;
integer play_sound = FALSE;
integer only_once = FALSE;
integer ichannel = 46195;
integer menu_time = 10;
integer cur_page = 1;
integer slist_size;
integer chanhandlr;
integer counter;
integer Length;
float default_sound_radius = 0;
float default_volume = 1;
list songlist;

startup()
{
llStopSound(); songlist = list_inv(INVENTORY_NOTECARD); slist_size = llGetListLength(songlist);
}
list list_inv(integer itype)
{
  list InventoryList;
  integer count = llGetInventoryNumber(itype);  
  string  ItemName;
  while (count--)
  {
  ItemName = llGetInventoryName(itype, count);
  if (ItemName != llGetScriptName())
  if(ItemName==notecardName){}else{InventoryList += ItemName;}
}return InventoryList;}
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
get_inventory(){if (llGetInventoryKey(music_selection)==NULL_KEY){llOwnerSay("could not find notecard");}else{llGiveInventory(llGetOwner(),music_selection);}}
string play_sound_0(){if(music_selection == "none"){return"[  ◼  ]";}if(play_sound == FALSE){return"[  ▶  ]";}else{return"[  ⏸  ]";}}
dialog_topmenu()
{ 
list a =llGetLinkPrimitiveParams(2,[PRIM_DESC]);
list items = llParseString2List(llList2String(a,0),["="],[]);
llDialog(llGetOwner(),"main"+"\n"+"\n"+
"Playing = "+music_selection+"\n"+
"Sound Radius = "+(string)llDeleteSubString(check_output(llList2Float(items,1)),4,100)+"\n"+
"Volume = "+(string)llDeleteSubString(check_output(llList2Float(items,0)),4,100)+"\n"
,["[ ⚙ setting ]","[  🔀  ]","[ 🛠️️ option ]","[  ⏪  ]",play_sound_0(),"[  ⏩  ]","[  🞪  ]","[  ♫  ]","[  ⭮  ]"],ichannel);
}
dialog_option()
{ 
  if(userUUID==llGetOwner())
  {
  llDialog(llGetOwner(),"option"+"\n"+"\n"+"Music = "+music_selection+"\n",["[ 📁 get ]","[ ⟳ reset ]","[ main ]"],ichannel);
  }else{
  dialog0();
} }
dialog_songmenu(integer page)
{
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
list snlist = numerizelist(llList2List(songlist, fspnum, (page*9)-1), fspnum, ". ");
llDialog(llGetOwner(),"Music = "+music_selection+"\n\n"+llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<", "[ main ]", ">>>"]),ichannel);
}
dialog0()
{
ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, ""); dialog_topmenu();
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
integer index = llListFindList(songlist,[llList2String(songlist, x)]); 
list sublist = llList2List(songlist, index, index + 1); integer Division= index / 9 ;
dialog_songmenu(Division+1);  
return;
}}dialog_topmenu();}
string check_output(float A){if(.01<=A){return(string)A;}return"OFF";}
option_topmenu()
{
list a=llGetLinkPrimitiveParams(2,[PRIM_DESC]);
list items=llParseString2List(llList2String(a,0),["="],[]);
integer music_list=llGetListLength(songlist);    
integer page=(music_list / 9) + 1 ;
llTextBox(llGetOwner(),
"\n"+"[ Status ]"+"\n\n"+
"Memory = "+(string)llGetFreeMemory()+"\n"+
"Sound Radius = "+(string)llDeleteSubString(check_output(llList2Float(items,1)),4,100)+"\n"+
"Volume = "+(string)llDeleteSubString(check_output(llList2Float(items,0)),4,100)+"\n"+
"Musics = "+(string)music_list+"\n"+
"Page = "+(string)page+"\n\n"+
"[ Command Format ]"+"\n\n"+
"Search > ( s/music )"+"\n"+
"Volume > ( v/0.5 )"+"\n"+
"Radius > ( r/0 )"+"\n"+
"Page > ( p/1 )"+"\n",ichannel);
}
arrow_music()
{
  if(arrow_play_sound == TRUE){counter = counter + 1;}else{counter = counter - 1;}
  if(-1>=counter){counter = llGetListLength(songlist)-1;}if((counter)>llGetListLength(songlist)-1){counter = 0;}else
  {
    if (~llListFindList(songlist,[(string)llList2String(songlist,counter)]))
    {
    music_selection = llList2String(songlist,counter); llMessageLinked(LINK_THIS, 0,"fetch_note_rationed|"+llList2String(songlist,counter), NULL_KEY);
} } }
default
{
    on_rez(integer start_param)
    {
    llResetScript();
    }  
    changed(integer change)
    {
    if (change & CHANGED_INVENTORY){llResetScript();}
    }  
    state_entry()
    {
    startup();
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
    if(only_once == FALSE){if((key)msg){llSetTimerEvent(0);only_once = TRUE;userUUID = msg; dialog0();llSetTimerEvent(menu_time);return;}}
    }
    listen(integer chan, string sname, key skey, string text)
    {  
    list items0 = llParseString2List(text, ["/"], []);
    if(skey == userUUID) 
    {
      if(text == "[  ◼  ]"){dialog_topmenu();}
      if(text == "[ main ]"){dialog_topmenu();}
      if(text == "[ 🛠️️ option ]"){dialog_option();}
      if(text == "[ ⚙ setting ]"){option_topmenu();}
      if(text == "[  ♫  ]"){dialog_songmenu(cur_page);}
      if(text == "[ 📁 get ]"){if(userUUID==llGetOwner()){get_inventory();}}
      if(text == "[  ⭮  ]"){llMessageLinked(LINK_THIS, 0,"start_over",""); dialog_topmenu();}
      if(text == "[  ▶  ]"){play_sound = TRUE; llMessageLinked(LINK_THIS, 0,"[ Play ]",""); dialog_topmenu();}
      if(text == "[  ⏸  ]"){play_sound = FALSE; llMessageLinked(LINK_THIS, 0,"[ Pause ]",""); dialog_topmenu();}
      if(text == "[  ⏩  ]"){play_sound = TRUE;arrow_play_sound = TRUE;arrow_music();dialog_topmenu();}
      if(text == "[  ⏪  ]"){play_sound = TRUE;arrow_play_sound = FALSE;arrow_music();dialog_topmenu();}
      if(only_once == TRUE){only_once = FALSE; llSetTimerEvent(0);llSetTimerEvent(menu_time);}
      if((string)llList2String(items0,0) == "p"){dialog_songmenu((integer)llList2String(items0,1));}
      if((string)llList2String(items0,0) == "s"){search_music(llList2String(items0,1));}
      if((string)llList2String(items0,0) == "v")
      {
      list a =llGetLinkPrimitiveParams(2,[PRIM_DESC]); list items = llParseString2List(llList2String(a,0),["="],[]);
      llSetLinkPrimitiveParamsFast(2,[PRIM_DESC,llDeleteSubString((string)llList2Float(items0,1),4,100)+"="+llList2String(items,1)]);
      llAdjustSoundVolume(llList2Float(items0,1)); dialog_topmenu();
      }
      if((string)llList2String(items0,0) == "r")
      {
      list a =llGetLinkPrimitiveParams(2,[PRIM_DESC]); list items = llParseString2List(llList2String(a,0),["="],[]);
      llSetLinkPrimitiveParamsFast(2,[PRIM_DESC,llList2String(items,0)+"="+llDeleteSubString((string)llList2Float(items0,1),4,100)]); 
      llLinkSetSoundRadius(LINK_THIS,llList2Float(items0,1)); dialog_topmenu();
      }
      if(text == "[  🔀  ]")
      {
      play_sound = TRUE;integer value = llFloor(llFrand(llGetListLength(songlist)));string Random = llList2String(songlist,value); counter = value;
      music_selection = Random; llMessageLinked(LINK_THIS, 0, "fetch_note_rationed|" + Random, NULL_KEY); dialog_topmenu();
      }
      if(text == "[ ⟳ reset ]")
      {
        if(userUUID==llGetOwner())
        {  
        llSetLinkPrimitiveParamsFast(2,[PRIM_DESC,(string)default_volume+"="+(string)default_sound_radius]);
        play_sound = FALSE; music_song = "none"; music_selection = "none"; cur_page = 1; llStopSound(); 
        llSleep(0.2); dialog_topmenu(); llMessageLinked(LINK_THIS, 0,"[ Reset ]","");
      } }
      else if(text == ">>>") dialog_songmenu(cur_page+1);
      else if(text == "<<<") dialog_songmenu(cur_page-1);
      else if(llToLower(llGetSubString(text,0,5)) == "play #")
      {
      play_sound = TRUE; integer pnum = (integer)llGetSubString(text, 6, -1); counter = pnum;
      llMessageLinked(LINK_THIS, 0,"fetch_note_rationed|" + llList2String(songlist, pnum), NULL_KEY);
      music_selection = llList2String(songlist, pnum); dialog_songmenu(cur_page);
  } } }
  timer()
  {
  only_once = FALSE;
  llSetTimerEvent(0);
  llMessageLinked(LINK_THIS,0,"exit_out","");
} }