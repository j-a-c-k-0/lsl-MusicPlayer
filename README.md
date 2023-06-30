# lsl-MusicPlayer

2 prims





list a =llGetLinkPrimitiveParams(2,[PRIM_DESC]);               //get object description


list items = llParseString2List(llList2String(a,0),["="],[]);               //1=0


llLinkSetSoundRadius(LINK_THIS,llList2Float(items,1));


llLoopSound(music_song,llList2Float(items,0));
