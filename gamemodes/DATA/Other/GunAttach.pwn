#define ATTACH_NEAR 	6
#define ATTACH_MIDDEL 	7
#define ATTACH_FAR 		8
#define ATTACH_NONE 	0
static armedbody_pTick[MAX_PLAYERS];
PLC::GunAtt_OnPlayerConnect(playerid)
{
    Loop(i,6,9)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid,i))RemovePlayerAttachedObject(playerid,i);
	}
	return 1;
}
PLC::GunAtt_OnPlayerDisconnect(playerid, reason)
{
    Loop(i,6,9)
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid,i))RemovePlayerAttachedObject(playerid,i);
	}
	return 1;
}
PLC::Attach_Gun(playerid)
{
	if(GetTickCount() - armedbody_pTick[playerid] > 200)
	{
		new weapons,ammos,near,middle,far,type;
		new pArmedWeapon = GetPlayerWeapon(playerid);
		near=middle=far=0;
		forex(i,12)
		{
			GetPlayerWeaponData(playerid,i,weapons,ammos);
			if(weapons!=pArmedWeapon&&ammos>0)
			{
				type=GetWeaponType(weapons);
				switch(type)
				{
				    case ATTACH_NEAR:near=weapons;
				    case ATTACH_MIDDEL:middle=weapons;
				    case ATTACH_FAR:far=weapons;
				}
			}
		}
		switch(near)
		{
		    case 0:if(IsPlayerAttachedObjectSlotUsed(playerid,ATTACH_NEAR))RemovePlayerAttachedObject(playerid,ATTACH_NEAR);
			default:SetWeaponModelAttach(playerid,near,ATTACH_NEAR);
		}
		switch(middle)
		{
		    case 0:if(IsPlayerAttachedObjectSlotUsed(playerid,ATTACH_MIDDEL))RemovePlayerAttachedObject(playerid,ATTACH_MIDDEL);
			default:SetWeaponModelAttach(playerid,middle,ATTACH_MIDDEL);
		}
		switch(far)
		{
		    case 0:if(IsPlayerAttachedObjectSlotUsed(playerid,ATTACH_FAR))RemovePlayerAttachedObject(playerid,ATTACH_FAR);
			default:SetWeaponModelAttach(playerid,far,ATTACH_FAR);
		}
		armedbody_pTick[playerid] = GetTickCount();
	}
	return 1;
}
PLC::GetWeaponType(weaponid)
{
	switch(weaponid)
	{
	    case 2..15:return ATTACH_NEAR;
        case 22..24:return ATTACH_MIDDEL;
		case 25..38:return ATTACH_FAR;
	}
	return ATTACH_NONE;
}
PLC::SetWeaponModelAttach(playerid,weaponid,slot)
{
	switch(weaponid)
	{
	    case 2..9:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),1, 0.199999, -0.139999, 0.030000, 0.500007, -115.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 22..24:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),8, -0.079999, -0.039999, 0.109999, -90.100006, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 25..27:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 28,29,32:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 30,31:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),1, 0.200000, -0.119999, -0.059999, 0.000000, 206.000000, 0.000000, 1.000000, 1.000000, 1.000000);
	    case 33,34:SetPlayerAttachedObject(playerid, slot, GetWeaponModel(weaponid), 1, -0.164999, -0.164000, 0.128999, 1.000000, 49.099983, 3.300002, 1.000000, 1.000000, 1.000000);
	    case 35..38:SetPlayerAttachedObject(playerid,slot,GetWeaponModel(weaponid),1,-0.100000, 0.000000, -0.100000, 84.399932, 112.000000, 10.000000, 1.099999, 1.000000, 1.000000);
	    case 10..15:SetPlayerAttachedObject(playerid, slot, GetWeaponModel(weaponid), 7, 0.008000, 0.074999, -0.161999, -87.099845, 157.899917, -169.400009, 1.000000, 1.000000, 1.000000);
	}
	return 1;
}
PLC::GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
	    case 1:
	        return 331;

		case 2..8:
		    return weaponid+331;

        case 9:
		    return 341;

		case 10..15:
			return weaponid+311;

		case 16..18:
		    return weaponid+326;

		case 22..29:
		    return weaponid+324;

		case 30,31:
		    return weaponid+325;

		case 32:
		    return 372;

		case 33..45:
		    return weaponid+324;

		case 46:
		    return 371;
	}
	return 0;
}

