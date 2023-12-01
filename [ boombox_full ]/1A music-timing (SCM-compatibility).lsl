integer check_song_finish = FALSE;
integer music_num; 
float timing_subtraction =1.0;
float music_timing;
float rate = 0.1;
list music_song;

length_mode_sound(float a,string b)
{
list items = llParseString2List(llGetObjectDesc(),["="],[]); llLinkSetSoundRadius(LINK_THIS,llList2Float(items,1));
if (a > 56) { llLoopSound(b,llList2Float(items,0)); }else{ llPlaySound(b,llList2Float(items,0)); }
}
playmusic()
{
  list items = llParseString2List(llGetObjectDesc(),["="],[]);
  if(check_song_finish == TRUE){if(llList2String(items,2) == "1")
  {
    llStopSound(); music_song = []; music_timing = 5;
    llMessageLinked(LINK_THIS, 0,"[autoplay]",""); return;
  } } 
  integer Length = llGetListLength(music_song);
  if (music_num < Length)
  {
  music_timing = music_timing;
  length_mode_sound(music_timing,llList2String(music_song, music_num)); music_num += 1;
  if((key)llList2String(music_song, music_num)){ llPreloadSound(llList2String(music_song, music_num));  
  }else{ 
  music_num = 0;
  if(llList2String(items,2) == "1"){check_song_finish = TRUE;}
}}}
sound_upload(string uuid)
{ 
  if((key)uuid)
  {
  music_song += (list)[uuid];
  }else{  
  if((float)uuid)
  {
  music_timing =(float)((float)uuid-timing_subtraction);
}}}
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
    llStopSound();
    }
    timer()
    {
    llSetTimerEvent(0); playmusic(); llSetTimerEvent(music_timing);
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {
      list items1 = llParseString2List(msg, ["|"], []); list items0 = llParseString2List(msg, ["/"], []); 
      if(llList2String(items0,0) == "v"){llAdjustSoundVolume(llList2Float(items0,1));}
      if(msg == "erase"){check_song_finish = FALSE; music_num = 0; llStopSound(); music_song = []; llSetTimerEvent(0);}
      if(llList2String(items1,0) == "upload_note"){llSetTimerEvent(0); sound_upload(llList2String(items1,1));}    
      if(llList2String(items0,0) == "r"){llLinkSetSoundRadius(LINK_THIS,llList2Float(items0,1));} 
      if(msg == "[ Reset ]"){music_num = 0; llStopSound(); music_song = []; llSetTimerEvent(0);}
      if(msg == "start"){music_num = 0; llStopSound(); llSetTimerEvent(rate);}
      if(msg == "start_over"){music_num = 0; llStopSound(); llSetTimerEvent(0.1);}
      if(msg == "[ Pause ]"){llStopSound(); llSetTimerEvent(0);}
      if(msg == "[ Play ]"){llSetTimerEvent(0.1);}
    } }