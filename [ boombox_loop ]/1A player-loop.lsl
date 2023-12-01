list type_mode = ["[  ◩  ]","[  ◪  ]"];
string music_selection = "none";
string music_song = "none";
key userUUID;
integer arrow_play_sound = FALSE;
integer play_sound = FALSE;
integer only_once = FALSE;
integer menu = TRUE;
integer notecard_music = 0;
integer ichannel = 07899;
integer sound_type = 0;
integer menu_time = 10;
integer cur_page = 1;
integer chanhandlr;
integer counter;
integer Length;
integer c = 80;
float default_sound_radius = 0;
float default_volume = 1;

startup()
{
llStopSound();
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
get_inventory(){if (llGetInventoryKey(music_selection)==NULL_KEY){llOwnerSay(music_selection+"|"+music_song);}else{llGiveInventory(llGetOwner(),music_selection);}}
string play_sound_0(){if(music_selection == "none"){return"[  ◼  ]";}if(play_sound == FALSE){return"[  ▶  ]";}else{return"[  ⏸  ]";}}
string sound_type_1(integer a){if(a == 0){return"[  ◩  ]";}if(a == 1){return"[  ◪  ]";}return"null";}
string sound_type_0(integer a){if(a == 0){return"sound";}if(a == 1){return"uuid";}return"null";}
type_option(){llDialog(userUUID,"type",["[ sound ]","[ main ]","[ uuid ]","[  🞪  ]"],ichannel);}
dialog_topmenu()
{ 
menu = TRUE;
list a =llGetLinkPrimitiveParams(2,[PRIM_DESC]);
list items = llParseString2List(llGetObjectDesc(),["="],[]);
llDialog(userUUID,"main"+"\n"+"\n"+
"Playing = "+music_selection+"\n"+
"Sound Type = "+sound_type_0(sound_type)+"\n"+
"Sound Radius = "+(string)llDeleteSubString(check_output(llList2Float(items,1)),4,100)+"\n"+
"Volume = "+(string)llDeleteSubString(check_output(llList2Float(items,0)),4,100)+"\n"
,["[ ⚙ setting ]","[  🔀  ]","[ 🛠️️ option ]","[  ⏪  ]",play_sound_0(),"[  ⏩  ]","[  🞪  ]","[  ♫  ]",sound_type_1(sound_type)],ichannel);
}
dialog_option()
{
if(userUUID==llGetOwner())
{  
  if(sound_type == 0)
  {
  llDialog(llGetOwner(),"option"+"\n"+"\n"+"Uuid = "+(string)llGetInventoryKey(music_song)+"\n"+"Music = "+music_selection+"\n",["[ 📁 get ]","[ ⟳ reset ]","[ main ]"],ichannel);
  }else{  
  llDialog(llGetOwner(),"option"+"\n"+"\n"+"Uuid = "+music_song+"\n"+"Music = "+music_selection+"\n",["[ 📁 get ]","[ ⟳ reset ]","[ main ]"],ichannel);
}}}
dialog_songmenu(integer page)
{
integer slist_size = llGetInventoryNumber(INVENTORY_SOUND);
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
llDialog(userUUID,"music selection\n\n"+llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<","[  ♫  ]", ">>>"]),ichannel);
}
list make_list(integer a,integer b) 
{
list inventory;
integer i;
for (i = 0; i < b; ++i){string name = llGetInventoryName(INVENTORY_SOUND,a+i);inventory += llDeleteSubString(name,30,1000);}
return inventory;
}
dialog0()
{
ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, ""); dialog_topmenu();
}
search_music(string search)
{
integer Lengthx = llGetInventoryNumber(INVENTORY_SOUND); integer x;
for ( ; x < Lengthx; x += 1)
{
string A = llToLower(search); string B = llToLower(llGetInventoryName(INVENTORY_SOUND, x));
integer search_found = ~llSubStringIndex(B,A);
if (search_found)
{
integer Division= x / 9 ; llRegionSayTo(userUUID,0,"[ "+llGetInventoryName(INVENTORY_SOUND,x)+" ] [ page = "+(string)(Division+1)+" list = "+(string)x+" ]");
dialog_songmenu(Division+1);  
return;
}}llMessageLinked(LINK_THIS, 0,"search="+search+"="+(string)userUUID,NULL_KEY);}
string check_output(float A){if(.01<=A){return(string)A;}return"OFF";}
option_topmenu()
{
list a=llGetLinkPrimitiveParams(2,[PRIM_DESC]);
list items=llParseString2List(llGetObjectDesc(),["="],[]);
integer music_list = llGetInventoryNumber(INVENTORY_SOUND)+notecard_music;   
integer page=(music_list / 9) + 1 ;
llTextBox(userUUID,
"\n"+"[ Status ]"+"\n\n"+
"Sound Radius = "+(string)llDeleteSubString(check_output(llList2Float(items,1)),4,100)+"\n"+
"Volume = "+(string)llDeleteSubString(check_output(llList2Float(items,0)),4,100)+"\n"+
"Musics = "+(string)music_list+"\n\n"+
"[ Command Format ]"+"\n\n"+
"Search > ( s/music )"+"\n"+
"Volume > ( v/0.5 )"+"\n"+
"Radius > ( r/0 )"+"\n",ichannel);
}
arrow_music()
{
  if(arrow_play_sound == TRUE){counter = counter + 1;}else{counter = counter - 1;}
  if(-1>=counter){counter = llGetInventoryNumber(INVENTORY_SOUND)-1;}if((counter)>llGetInventoryNumber(INVENTORY_SOUND)-1){counter = 0;}else
  {
  music_selection = llGetInventoryName(INVENTORY_SOUND,counter);
  music_song = llGetInventoryName(INVENTORY_SOUND,counter);
  playmusic(); return;
  }
  music_selection = llGetInventoryName(INVENTORY_SOUND,0);
  music_song = llGetInventoryName(INVENTORY_SOUND,0);
  playmusic();
}
playmusic()
{
if(play_sound == TRUE)
{
    list items = llParseString2List(llGetObjectDesc(),["="],[]);
    llLinkSetSoundRadius(LINK_THIS,llList2Float(items,1));
    if(sound_type == 0)
    {
    llLoopSound(music_song,llList2Float(items,0));
    }else{
    if((key)music_song){llLoopSound(music_song,llList2Float(items,0));}else{llOwnerSay("error invalid [ " +music_song+" ]");}
    }
  }llRegionSayTo(userUUID,0," Playing [ " +music_selection+" ]");
}
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
      list items0 = llParseString2List(msg, ["="], []);   
      if(only_once == FALSE){if((key)msg){llSetTimerEvent(0);only_once = TRUE; userUUID = msg; dialog0();llSetTimerEvent(menu_time);return;}}
      if(msg == "owner_ride"){only_once = TRUE; llSetTimerEvent(0);userUUID = llGetOwner(); dialog0();llSetTimerEvent(menu_time);return;}
      if(llList2String(items0,0) == "music_number"){notecard_music = (integer)llList2String(items0,1);}
      if(msg == "menu_in_use"){llSetTimerEvent(0); llSetTimerEvent(menu_time);}
      if(msg == "main"){type_option();}
      if((string)llList2String(items0,0) == "notecard")
      {
      sound_type = 1; play_sound = TRUE;    
      list items1 = llParseString2List(llList2String(items0,1), ["|"], []);  
      music_selection = llList2String(items1,0); music_song = llList2String(items1,1); 
      playmusic(); if(menu == TRUE){dialog_topmenu();}
    } }
    listen(integer chan, string sname, key skey, string text)
    {  
    list items0 = llParseString2List(text, ["/"], []);
    if(skey == userUUID) 
    { 
      llSetTimerEvent(0);
      llSetTimerEvent(menu_time);
      if(chan == c){if (text == "menu"){dialog0();}}
      if(text == "[  ◼  ]"){dialog_topmenu();}
      if(text == "[ main ]"){dialog_topmenu();}
      if(text == "[ 📁 get ]"){get_inventory();}
      if(text == "[ ⚙ setting ]"){option_topmenu();}
      if(text == "[  ♫  ]"){menu = FALSE;type_option();}
      if(text == "[ sound ]"){menu = FALSE;dialog_songmenu(cur_page);}  
      if(text == "[  ▶  ]"){play_sound = TRUE; playmusic();dialog_topmenu();}
      if(text == "[  ⏸  ]"){play_sound = FALSE; llStopSound();dialog_topmenu();}
      if(text == "[ 🛠️️ option ]"){if(userUUID==llGetOwner()){dialog_option();return;}dialog_topmenu();}
      if(text == "[  🞪  ]"){only_once = FALSE;llSetTimerEvent(0);llMessageLinked(LINK_THIS,0,"exit_out","");}   
      if(text == "[ uuid ]"){menu = FALSE;llMessageLinked(LINK_THIS, 0,"notecard_uuid="+(string)userUUID,"");}
      if((string)llList2String(items0,0) == "s"){search_music(llList2String(items0,1));}
      if((string)llList2String(items0,0) == "v")
      {
      list items = llParseString2List(llGetObjectDesc(),["="],[]);
      llSetObjectDesc(llDeleteSubString((string)llList2Float(items0,1),4,100)+"="+llList2String(items,1));
      llAdjustSoundVolume(llList2Float(items0,1)); dialog_topmenu();
      }
      if((string)llList2String(items0,0) == "r")
      {
      list items = llParseString2List(llGetObjectDesc(),["="],[]);
      llSetObjectDesc(llList2String(items,0)+"="+llDeleteSubString((string)llList2Float(items0,1),4,100));
      llLinkSetSoundRadius(LINK_THIS,llList2Float(items0,1)); dialog_topmenu();
      }
      if (~llListFindList(type_mode,[text])) 
      {
      if(sound_type == 0){sound_type = 1;dialog_topmenu();return;}
      if(sound_type == 1){sound_type = 0;dialog_topmenu();return;}
      }
      if(text == "[  ⏩  ]")
      {
        if(sound_type == 0)
        {
        sound_type = 0; play_sound = TRUE;arrow_play_sound = TRUE;arrow_music();dialog_topmenu();
        }else{
        sound_type = 1; llMessageLinked(LINK_THIS, 0,"⏩","");
      } }
      if(text == "[  ⏪  ]")
      {
        if(sound_type == 0)
        {   
        sound_type = 0; play_sound = TRUE;arrow_play_sound = FALSE;arrow_music();dialog_topmenu();
        }else{
        sound_type = 1; llMessageLinked(LINK_THIS, 0,"⏪","");
      } }
      if(text == "[  🔀  ]")
      {
        if(sound_type == 0)
        {
        sound_type = 0; play_sound = TRUE;
        integer x = llFloor(llFrand(llGetInventoryNumber(INVENTORY_SOUND)));
        music_selection = llGetInventoryName(INVENTORY_SOUND,x);
        music_song = llGetInventoryName(INVENTORY_SOUND,x);
        counter = x; playmusic(); dialog_topmenu();
        }else{
        sound_type = 1; llMessageLinked(LINK_THIS, 0,"🔀","");
      } }
      if(text == "[ ⟳ reset ]")
      {
        if(userUUID==llGetOwner())
        {
        menu = FALSE;sound_type = 0;llSetObjectDesc((string)default_volume+"="+(string)default_sound_radius);
        play_sound = FALSE; music_song = "none"; music_selection = "none"; cur_page = 1; llStopSound(); llSleep(0.2); dialog_topmenu();
      } }
      else if(text == ">>>") dialog_songmenu(cur_page+1);
      else if(text == "<<<") dialog_songmenu(cur_page-1);
      else if(llToLower(llGetSubString(text,0,5)) == "play #")
      {
      sound_type = 0; play_sound = TRUE; integer pnum = (integer)llGetSubString(text, 6, -1); counter = pnum;
      music_selection = llGetInventoryName(INVENTORY_SOUND,pnum);
      music_song = llGetInventoryName(INVENTORY_SOUND,pnum);
      dialog_songmenu(cur_page);
      playmusic();
  } } }
  timer()
  {
  only_once = FALSE;
  llSetTimerEvent(0);
  llRegionSayTo(userUUID,0,"time_out");
  llMessageLinked(LINK_THIS,0,"exit_out",""); userUUID = "";
} }