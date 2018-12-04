new Text3D:temp_car_text[MAX_PLAYERS][3];
new temp_car[MAX_PLAYERS][3];
new prev_temp_car_model[MAX_PLAYERS];
new prev_temp_car_color[MAX_PLAYERS][2];
PLC::TempVeh_OnPlayerConnect(playerid)
{
    forex(i,3)temp_car[playerid][i]=NOTHING;
    prev_temp_car_model[playerid]=NOTHING;
    forex(i,2)prev_temp_car_color[playerid][i]=NOTHING;
    return 1;
}
PLC::TempVeh_OnPlayerDisconnect(playerid, reason)
{
    forex(i,3)
	{
	    if(temp_car[playerid][i]!=NOTHING)
	    {
	    	DestroyDynamic3DTextLabel(temp_car_text[playerid][i]);
	        DestroyVehicle(temp_car[playerid][i]);
	        temp_car[playerid][i]=NOTHING;
	    }
	}
    prev_temp_car_model[playerid]=NOTHING;
    forex(i,2)prev_temp_car_color[playerid][i]=NOTHING;
    return 1;
}
PLC::TempVeh_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new Carid = GetPlayerVehicleID(playerid);
	new vehid = GetTempVehId(playerid,Carid);
	if(vehid!=NOTHING)
	{
	    if(PRESSED(KEY_ANALOG_LEFT))//小键盘4
	    {
	        if(GetPlayerState(playerid) == 2)
	        {
				if(prev_temp_car_color[playerid][0] > 0 && prev_temp_car_color[playerid][1] > 0)
			  	{
					prev_temp_car_color[playerid][0] -= 1;
					prev_temp_car_color[playerid][1] -= 1;
					ChangeVehicleColor(Carid, prev_temp_car_color[playerid][0], prev_temp_car_color[playerid][1]);
				}
	        }
	    }
	    else if(PRESSED(KEY_ANALOG_RIGHT))//小键盘6
	    {
	        if(GetPlayerState(playerid) == 2)
	        {
				if(prev_temp_car_color[playerid][0] < 256 && prev_temp_car_color[playerid][1] < 256)
		        {
					prev_temp_car_color[playerid][0] += 1;
					prev_temp_car_color[playerid][1] += 1;
					ChangeVehicleColor(Carid, prev_temp_car_color[playerid][0], prev_temp_car_color[playerid][1]);
				}
	        }
	    }
		else if(PRESSED(KEY_ACTION))//左CTRL
		{
			if(GetPlayerState(playerid) == 2)
			{
				if(GetVehicleComponentInSlot(Carid, GetVehicleComponentType(1010)) == 1010)AddVehicleComponent(Carid, 1010);
			}
		}
	}
	return 1;
}
PLC::GetTempVehId(playerid,vehid)
{
    forex(i,3)
    {
		if(temp_car[playerid][i]==NOTHING)
		{
		    if(temp_car[playerid][i]==vehid)return i;
		}
    }
	return NOTHING;
}
PLC::GetTempVehSlot(playerid)
{
    forex(i,VIP(playerid)+1)
    {
        if(temp_car[playerid][i]==NOTHING)return i;
    }
    return NOTHING;
}
CMD:c(playerid, params[], help)
{
    new Slot=GetTempVehSlot(playerid);
	new mod,co1,co2;
	if(sscanf(params, "iD(0)D(0)",mod,co1,co2))
	{
		if(prev_temp_car_model[playerid]!=NOTHING)
		{
			if(Slot==NOTHING)
			{
			    new line[128];
			    format(line, sizeof(line), "最多刷%i辆[可以提升VIP增加]",VIP(playerid)+1);
			    return Dialog_Show(playerid,_TEMP_CAR,DIALOG_STYLE_MSGBOX,line,"是否清除你之前刷出的车?", "清除", "取消");
			}
			new Float:xx,Float:yy,Float:zz,Float:angled;
			GetPlayerPos(playerid,xx,yy,zz);
			GetPlayerFacingAngle(playerid,angled);
			temp_car[playerid][Slot]=AddStaticVehicleEx(prev_temp_car_model[playerid],xx,yy,zz,angled,prev_temp_car_color[playerid][0],prev_temp_car_color[playerid][1],99999,0);
            new body[128];
			format(body, sizeof(body), "ID:%i\nUser:%s",temp_car[playerid][Slot],pdate[playerid][_name]);
			temp_car_text[playerid][Slot]=CreateDynamic3DTextLabelEx(body, -1, 0.0,0.0,0.0, 20,INVALID_PLAYER_ID,temp_car[playerid][Slot]);
			LinkVehicleToInterior(temp_car[playerid][Slot],GetPlayerInterior(playerid));
			SetVehicleVirtualWorld(temp_car[playerid][Slot],GetPlayerVirtualWorld(playerid));
			PutInVehicle(playerid,temp_car[playerid][Slot],0);
			SetCameraBehindPlayer(playerid);
			return Info(playerid,"刷车成功");
		}
		else
		{
		    Usage(playerid, "/c ID 颜色1 颜色2");
		    Info(playerid,"/c 记忆刷车");
		    return 1;
		}
	}
    if(!IsValidVehicleModel(mod))return Info(playerid,"车型ID无效");
	if(Slot==NOTHING)
	{
		prev_temp_car_model[playerid]=mod;
		prev_temp_car_color[playerid][0]=co1;
		prev_temp_car_color[playerid][1]=co2;
	    new line[128];
	    format(line, sizeof(line), "你最多刷%i辆车,提升VIP可以增加",VIP(playerid)+1);
	    return Dialog_Show(playerid,_TEMP_CAR,DIALOG_STYLE_MSGBOX,line,"是否清除你之前刷出的车?", "清除", "取消");
	}
	new Float:xx,Float:yy,Float:zz,Float:angled;
	GetPlayerPos(playerid,xx,yy,zz);
	GetPlayerFacingAngle(playerid,angled);
	temp_car[playerid][Slot]=AddStaticVehicleEx(mod,xx,yy,zz,angled,co1,co2,99999,0);
    new body[128];
	format(body, sizeof(body), "ID:%i\nUser:%s",temp_car[playerid][Slot],pdate[playerid][_name]);
	temp_car_text[playerid][Slot]=CreateDynamic3DTextLabelEx(body, -1, 0.0,0.0,0.0, 20,INVALID_PLAYER_ID,temp_car[playerid][Slot]);
	LinkVehicleToInterior(temp_car[playerid][Slot],GetPlayerInterior(playerid));
	SetVehicleVirtualWorld(temp_car[playerid][Slot],GetPlayerVirtualWorld(playerid));
	PutInVehicle(playerid,temp_car[playerid][Slot],0);
	SetCameraBehindPlayer(playerid);
	prev_temp_car_model[playerid]=mod;
	prev_temp_car_color[playerid][0]=co1;
	prev_temp_car_color[playerid][1]=co2;
	return Info(playerid,"刷车成功");
}
Dialog:_TEMP_CAR(playerid, response, listitem, inputtext[])
{
    if(response)
    {
	    forex(i,3)
		{
		    if(temp_car[playerid][i]!=NOTHING)
		    {
		        DestroyDynamic3DTextLabel(temp_car_text[playerid][i]);
		        DestroyVehicle(temp_car[playerid][i]);
		        temp_car[playerid][i]=NOTHING;
		    }
		}
		new Slot=GetTempVehSlot(playerid);
		new Float:xx,Float:yy,Float:zz,Float:angled;
		GetPlayerPos(playerid,xx,yy,zz);
		GetPlayerFacingAngle(playerid,angled);
		temp_car[playerid][Slot]=AddStaticVehicleEx(prev_temp_car_model[playerid],xx,yy,zz,angled,prev_temp_car_color[playerid][0],prev_temp_car_color[playerid][1],99999,0);
        new body[128];
		format(body, sizeof(body), "ID:%i\nUser:%s",temp_car[playerid][Slot],pdate[playerid][_name]);
		temp_car_text[playerid][Slot]=CreateDynamic3DTextLabelEx(body, -1, 0.0,0.0,0.0, 20,INVALID_PLAYER_ID,temp_car[playerid][Slot]);
		LinkVehicleToInterior(temp_car[playerid][Slot],GetPlayerInterior(playerid));
		SetVehicleVirtualWorld(temp_car[playerid][Slot],GetPlayerVirtualWorld(playerid));
		PutInVehicle(playerid,temp_car[playerid][Slot],0);
		SetCameraBehindPlayer(playerid);
		Info(playerid,"刷车成功");
    }
    else Info(playerid,"你需要清除之前刷出的车才能继续");
	return 1;
}
