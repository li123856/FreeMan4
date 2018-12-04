PLC::OnJiajuLoad()
{
    forex(r,cache_num_rows())
	{
		new ORM:ormid = jj[r][_orm] = orm_create(SQL_JJ_DATABASE);
		orm_addvar_int(ormid, jj[r][_id], "ID");
		orm_addvar_string(ormid, jj[r][_name],80,"NAME");
		orm_addvar_string(ormid, jj[r][_createtime],40,"CREATETIME");
		orm_addvar_float(ormid, jj[r][_x],"X");
		orm_addvar_float(ormid, jj[r][_y],"Y");
		orm_addvar_float(ormid, jj[r][_z],"Z");
		orm_addvar_float(ormid, jj[r][_rx],"RX");
		orm_addvar_float(ormid, jj[r][_ry],"RY");
		orm_addvar_float(ormid, jj[r][_rz],"RZ");
		orm_addvar_int(ormid, jj[r][_interior],"INTERIOR");
		orm_addvar_int(ormid, jj[r][_world],"WORLD");
		orm_addvar_int(ormid, jj[r][_index],"INDEX");
		orm_addvar_int(ormid, jj[r][_modelid],"MODELID");
		orm_addvar_int(ormid, jj[r][_txdid],"TXDID");
		orm_addvar_int(ormid, jj[r][_colorid],"COLORID");
		orm_addvar_int(ormid, jj[r][_sizeid],"SIZEID");
		orm_addvar_int(ormid, jj[r][_fontid],"FONTID");
		orm_addvar_int(ormid, jj[r][_fontsize],"FONTSIZE");
		orm_addvar_int(ormid, jj[r][_bold],"BOLD");
		orm_addvar_int(ormid, jj[r][_fontcolorid],"FONTCOLORID");
		orm_addvar_int(ormid, jj[r][_backcolorid],"BACKCOLORID");
		orm_addvar_int(ormid, jj[r][_textalignment],"TEXTALIGNMENT");
		orm_addvar_string(ormid, jj[r][_text],2048,"TEXT");
		orm_addvar_int(ormid, jj[r][_join],"JOIN");
		orm_addvar_int(ormid, jj[r][_limit],"LIMIT");
		orm_apply_cache(ormid, r);
		orm_setkey(ormid,"ID");
		Iter_Add(jj,r);
		Jiaju_Create(r);
	}
	return 1;
}
PLC::AddJiaju(modelid,name[],Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz,interior,world)
{
    if(Iter_Free(jj) == -1) return 0;
    new r = Iter_Free(jj);
    format(jj[r][_name],80,name);
	new date[3];
	new time[3];
	getdate(date[0], date[1], date[2]);
	gettime(time[0], time[1], time[2]);
   	format(jj[r][_createtime],40, "%d/%d/%d %02d:%02d:%02d",date[0],date[1],date[2],time[0],time[1],time[2]);
    jj[r][_modelid]=modelid;
	jj[r][_x]=x;
	jj[r][_y]=y;
	jj[r][_z]=z;
	jj[r][_rx]=rx;
	jj[r][_ry]=ry;
	jj[r][_rz]=rz;
	jj[r][_interior]=interior;
	jj[r][_world]=world;
	jj[r][_index]=NOTHING;
	jj[r][_txdid]=0;
	jj[r][_colorid]=0;
	jj[r][_sizeid]=NOTHING;
    jj[r][_fontid]=0;
    jj[r][_fontsize]=0;
    jj[r][_bold]=0;
    jj[r][_fontcolorid]=0;
    jj[r][_backcolorid]=0;
    jj[r][_textalignment]=0;
	jj[r][_join]=ServerRunTime;
	jj[r][_limit]=7200;
	format(jj[r][_name],80,name);

	new ORM:ormid = jj[r][_orm] = orm_create(SQL_JJ_DATABASE);
	orm_addvar_int(ormid, jj[r][_id], "ID");
	orm_addvar_string(ormid, jj[r][_name],80,"NAME");
	orm_addvar_string(ormid, jj[r][_createtime],40,"CREATETIME");
	orm_addvar_float(ormid, jj[r][_x],"X");
	orm_addvar_float(ormid, jj[r][_y],"Y");
	orm_addvar_float(ormid, jj[r][_z],"Z");
	orm_addvar_float(ormid, jj[r][_rx],"RX");
	orm_addvar_float(ormid, jj[r][_ry],"RY");
	orm_addvar_float(ormid, jj[r][_rz],"RZ");
	orm_addvar_int(ormid, jj[r][_interior],"INTERIOR");
	orm_addvar_int(ormid, jj[r][_world],"WORLD");
	orm_addvar_int(ormid, jj[r][_index],"INDEX");
	orm_addvar_int(ormid, jj[r][_modelid],"MODELID");
	orm_addvar_int(ormid, jj[r][_txdid],"TXDID");
	orm_addvar_int(ormid, jj[r][_colorid],"COLORID");
	orm_addvar_int(ormid, jj[r][_sizeid],"SIZEID");
	orm_addvar_int(ormid, jj[r][_fontid],"FONTID");
	orm_addvar_int(ormid, jj[r][_fontsize],"FONTSIZE");
	orm_addvar_int(ormid, jj[r][_bold],"BOLD");
	orm_addvar_int(ormid, jj[r][_fontcolorid],"FONTCOLORID");
	orm_addvar_int(ormid, jj[r][_backcolorid],"BACKCOLORID");
	orm_addvar_int(ormid, jj[r][_textalignment],"TEXTALIGNMENT");
	orm_addvar_string(ormid, jj[r][_text],2048,"TEXT");
	orm_addvar_int(ormid, jj[r][_join],"JOIN");
	orm_addvar_int(ormid, jj[r][_limit],"LIMIT");
	orm_insert(ormid,"Jiaju_Date_Create","i",r);
	return 1;
}
PLC::Jiaju_Date_Create(jjid)
{
	Iter_Add(jj,jjid);
	orm_setkey(jj[jjid][_orm],"ID");
    Jiaju_Create(jjid);
	return 1;
}
PLC::Jiaju_Create(jjid)
{
	jj[jjid][_jid]=CreateDynamicObject(jj[jjid][_modelid],jj[jjid][_x],jj[jjid][_y],jj[jjid][_z],jj[jjid][_rx],jj[jjid][_ry],jj[jjid][_rz],jj[jjid][_world],jj[jjid][_interior]);
	jj[jjid][_jtext]=CreateDynamic3DTextLabel("Y",-1,jj[jjid][_x],jj[jjid][_y],jj[jjid][_z],5,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,jj[jjid][_world],jj[jjid][_interior]);
    jj[jjid][_area]=CreateDynamicSphere(jj[jjid][_x],jj[jjid][_y],jj[jjid][_z],3.0,jj[jjid][_world],jj[jjid][_interior]);
	AttachDynamicAreaToObject(jj[jjid][_area],jj[jjid][_jid]);
	if(jj[jjid][_index]!=NOTHING)
	{
	    if(jj[jjid][_sizeid]!=NOTHING)SetDynamicObjectMaterialText(jj[jjid][_jid],jj[jjid][_index],jj[jjid][_text],TextSizes[jj[jjid][_sizeid]][fsize],g_Fonts[jj[jjid][_fontid]],jj[jjid][_fontsize],jj[jjid][_bold],ARGB(hue[jj[jjid][_fontcolorid]][_hex]),ARGB(hue[jj[jjid][_backcolorid]][_hex]),jj[jjid][_textalignment]);
		else SetDynamicObjectMaterial(jj[jjid][_jid],jj[jjid][_index],GetTModel(jj[jjid][_txdid]),GetTXDName(jj[jjid][_txdid]),GetTextureName(jj[jjid][_txdid]),jj[jjid][_colorid]);
	}
	jj[jjid][_state]=JJ_NONE;
	return 1;
}
PLC::Jiaju_Delete(jjid)
{
	if(!Iter_Contains(jj,jjid))return 0;
    orm_delete(jj[jjid][_orm],true);
    DestroyDynamicObject(jj[jjid][_jid]);
    DestroyDynamic3DTextLabel(jj[jjid][_jtext]);
    DestroyDynamicArea(jj[jjid][_area]);
    Iter_Remove(jj,jjid);
	return 1;
}
PLC::Jiaju_Destroy(jjid)
{
    DestroyDynamicObject(jj[jjid][_jid]);
    DestroyDynamic3DTextLabel(jj[jjid][_jtext]);
    DestroyDynamicArea(jj[jjid][_area]);
	return 1;
}
PLC::JiajuUpdate()
{
	foreach(new i:jj)
    {
        if(jj[i][_join]!=NOTHING)
        {
            jj[i][_limit]++;
        	if(jj[i][_limit]-(ServerRunTime-jj[i][_join])==0)
        	{
        	    Jiaju_Delete(i);
        	}
        	orm_update(jj[i][_orm]);
        	printf("i");
        }
    }
	return 1;
}
PLC::GetNearJiajuID(playerid)
{
	if(!IsPlayerInAnyDynamicArea(playerid))return NOTHING;
	foreach(new i:jj)
    {
		if(IsPlayerInDynamicArea(playerid,jj[i][_area]))return i;
    }
	return NOTHING;
}
PLC::IsJiajuUse(playerid,jid)
{
	foreach(new i:Player)
	{
	    if(i!=playerid)
	    {
		    if(Puj[i]!=NOTHING)
		    {
		        if(Puj[i]==jid)return 1;
	        }
        }
	}
	return 0;
}
PLC::Jiaju_OnPlayerConnect(playerid)
{
    Puj[playerid]=NOTHING;
    Carry[playerid]=false;
	return 1;
}
PLC::Jiaju_OnPlayerDisconnect(playerid, reason)
{
	new jid=Puj[playerid];
	if(jid!=NOTHING&&Carry[playerid])
	{
		GetPlayerPos(playerid,jj[jid][_x],jj[jid][_y],jj[jid][_z]);
		jj[jid][_interior]=GetPlayerInterior(playerid);
		jj[jid][_world]=GetPlayerVirtualWorld(playerid);
		RemovePlayerAttachedObject(playerid,9);
		Jiaju_Create(jid);
		jj[jid][_state]=JJ_NONE;
	}
	Carry[playerid]=false;
	Puj[playerid]=NOTHING;
	return 1;
}
PLC::Jiaju_OnPlayerDeath(playerid, killerid, reason)
{
	new jid=Puj[playerid];
	if(jid!=NOTHING&&Carry[playerid])
	{
		GetPlayerPos(playerid,jj[jid][_x],jj[jid][_y],jj[jid][_z]);
		jj[jid][_interior]=GetPlayerInterior(playerid);
		jj[jid][_world]=GetPlayerVirtualWorld(playerid);
		RemovePlayerAttachedObject(playerid,9);
		Jiaju_Create(jid);
		jj[jid][_state]=JJ_NONE;
	}
	Carry[playerid]=false;
	Puj[playerid]=NOTHING;
	return 1;
}
stock Show_Jiaju_Info(jid)
{
	new body[256],line[100];
	format(line, sizeof(line),"名称:%s [ID:%i]\n",jj[jid][_name],jid);
	strcat(body,line);
	format(line, sizeof(line),"剩余时间:%s\n",GetTimeStr(jj[jid][_limit]-(ServerRunTime-jj[jid][_join])));
	strcat(body,line);
	return body;
}
PLC::Jiaju_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_YES))
	{
	    if(Carry[playerid])return SCM(playerid,"你正在搬运其他家具");
	    if(Puj[playerid]!=NOTHING)return SCM(playerid,"你正在使用其他家具");
	    new jid=GetNearJiajuID(playerid);
	    if(jid==NOTHING)return 1;
	    if(IsJiajuUse(playerid,jid))return SCM(playerid,"别人正在使用此家具");
	    new line[80];
	    format(line,80,jj[jid][_name]);
	    Dialog_Show(playerid,_JJ_USE,DIALOG_STYLE_LIST,line,UseJiaJu_String, "选择", "关闭",ARRAY_MODE_JJ,jid);
	    Puj[playerid]=jid;
	}
	if(PRESSED(KEY_HANDBRAKE))
	{
	    if(Puj[playerid]!=NOTHING&&Carry[playerid])Dialog_Show(playerid,_JJ_PUTDOWN,DIALOG_STYLE_MSGBOX,"放下家具","是否放下家具", "放下", "不了",ARRAY_MODE_JJ,Puj[playerid]);
	}
	return 1;
}
Dialog:_JJ_PUTDOWN(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    ApplyAnimation(playerid,"Freeweights","gym_free_putdown",4.0,0,0,1,1,1,1);
	    SetTimerEx("PutDownJiaJu",1500, false, "i",playerid);
	    RemovePlayerAttachedObject(playerid, 9);
	}
	return 1;
}
PLC::PutDownJiaJu(playerid)
{
	new jid=Puj[playerid];
    new Float:x,Float:y,Float:z;
    GetPlayerPos(playerid,x,y,z);
    GetXYInFrontOfPlayer(playerid,x,y,2);
    jj[jid][_x]=x;
    jj[jid][_y]=y;
    jj[jid][_z]=z;
	jj[jid][_interior]=GetPlayerInterior(playerid);
	jj[jid][_world]=GetPlayerVirtualWorld(playerid);
    jj[jid][_state]=JJ_NONE;
    orm_update(jj[jid][_orm]);
	Carry[playerid]=false;
	Puj[playerid]=NOTHING;
	Jiaju_Create(jid);
	SCM(playerid,"你放下了家具!");
	return 1;
}
PLC::CarryJiaJu(playerid)
{
	new jid=Puj[playerid];
	if(!Iter_Contains(jj,jid))return SCM(playerid,"家具可能被删除");
	Carry[playerid]=true;
	jj[jid][_state]=JJ_CARRY;
	Jiaju_Destroy(jid);
	SetPlayerAttachedObject(playerid,9,jj[jid][_modelid],1,0,0.6,0,0,90,0,1.000000,1.000000,1.000000);
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 1, 1, 1);
	SCM(playerid,"你举起了家具!");
	SCM(playerid,"按鼠标右键可以放下家具!");
	return 1;
}
Dialog:_JJ_USE(playerid, response, listitem, inputtext[])
{
    new jid=Puj[playerid];
	if(response)
	{
	    switch(listitem)
	    {
	        case 0:Dialog_Show(playerid,_JJ_INFO,DIALOG_STYLE_MSGBOX,"家具信息",Show_Jiaju_Info(jid), "返回", "",ARRAY_MODE_JJ,jid);
	        case 1:
	        {
	            if(Carry[playerid])return SCM(playerid,"你正在搬运其他家具");
	            if(jj[jid][_state])return SCM(playerid,"家具正在被搬移");
	            ApplyAnimation(playerid, "CARRY", "liftup", 4, 0, 0, 0, 0, 0);
	            Carry[playerid]=true;
	            SetTimerEx("CarryJiaJu", 1500, false, "i", playerid);
	        }
	        case 2:
	        {
	        }
	        case 3:
	        {
	        }
	        case 4:
	        {
	        }
	    }
	}
	else Puj[playerid]=NOTHING;
	return 1;
}

Dialog:_JJ_INFO(playerid, response, listitem, inputtext[])
{
    new jid=Puj[playerid];
	new line[80];
    format(line,80,jj[jid][_name]);
    Dialog_Show(playerid,_JJ_USE,DIALOG_STYLE_LIST,line,UseJiaJu_String, "选择", "关闭",ARRAY_MODE_JJ,jid);
	return 1;
}
