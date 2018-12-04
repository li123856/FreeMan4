#define HACK_WEAPON 1
#define HACK_WEAPON_AMMO 2
#define HACK_HEALTH 3
#define HACK_ARMOUR 4
#define HACK_CAR_SPEED 5
#define HACK_TELEPORT 6
new bool:psapwn[MAX_PLAYERS];
static Anti_pTick[MAX_PLAYERS];
static Anti_car_pTick[MAX_PLAYERS];
new pWeapon[MAX_PLAYERS][13];
new pAmmo[MAX_PLAYERS][13];
new oAmmo[MAX_PLAYERS];
new nAmmo[MAX_PLAYERS];
new oWeapon[MAX_PLAYERS];
new nWeapon[MAX_PLAYERS];
new CheckAmmo_Time[MAX_PLAYERS];

new Float:pHealth[MAX_PLAYERS];
new Float:pArmour[MAX_PLAYERS];

new bool:OpenIng[MAX_PLAYERS];

static stock
    Float:AC_Position[3],
    pLastPosTick[MAX_PLAYERS],
    BitArray:AC_SafeTP<MAX_PLAYERS>
;

PLC::Anti_OnPlayerConnect(playerid)
{
    pHealth[playerid]=100.0;
    pArmour[playerid]=0.0;
    ResetWeapon(playerid);
    psapwn[playerid]=false;
    OpenIng[playerid]=false;
    return 1;
}
PLC::Anti_OnPlayerDisconnect(playerid, reason)
{
    pHealth[playerid]=100.0;
    pArmour[playerid]=0.0;
    ResetWeapon(playerid);
    psapwn[playerid]=false;
    OpenIng[playerid]=false;
    return 1;
}
PLC::Anti_OnPlayerDeath(playerid, killerid, reason)
{
    pHealth[playerid]=0.0;
    pArmour[playerid]=0.0;
    psapwn[playerid]=false;
    return 1;
}
PLC::SetHealth(playerid, Float:health)
{
	pHealth[playerid] = health;
	return SetPlayerHealth(playerid, pHealth[playerid]);
}
PLC::SetArmour(playerid, Float:armour)
{
	pArmour[playerid] = armour;
	return SetPlayerArmour(playerid, pArmour[playerid]);
}
Float:GetArmour(playerid)return pArmour[playerid];
Float:GetHealth(playerid)return pHealth[playerid];
PLC::Anti_OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid)
{
    new Float:armour,Float:hp;
    GetPlayerHealth(playerid,hp);
    GetPlayerArmour(playerid,armour);
	if(hp>GetHealth(playerid)&&issuerid!=INVALID_PLAYER_ID)return CRF("OnPlayerHack","ii",playerid,HACK_HEALTH);
	if(armour>GetArmour(playerid)&&issuerid!=INVALID_PLAYER_ID)return CRF("OnPlayerHack","ii",playerid,HACK_ARMOUR);
    armour=GetArmour(playerid);
	if(armour > 0)
	{
	    pArmour[playerid] = pArmour[playerid] - amount;
	    SetArmour(playerid, pArmour[playerid]);
	}
	else
	{
	    hp=GetHealth(playerid);
	    pHealth[playerid] = pHealth[playerid] - amount;
	    SetHealth(playerid, pHealth[playerid]);
	}
    return 1;
}
PLC::Anti_OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
    return 1;
}
PLC::GiveWeapon(playerid,weaponid,ammo)
{
    if(pWeapon[playerid][WeaponSlot(weaponid)]==weaponid)pAmmo[playerid][WeaponSlot(weaponid)]+=ammo;
	else
	{
        pWeapon[playerid][WeaponSlot(weaponid)] = weaponid;
        pAmmo[playerid][WeaponSlot(weaponid)] = ammo;
    }
    GivePlayerWeapon(playerid,weaponid,ammo);
    return 1;
}
PLC::SetWeapon(playerid,weaponid,ammo)
{
    ResetWeapon(playerid);
    pWeapon[playerid][WeaponSlot(weaponid)] = weaponid;
    pAmmo[playerid][WeaponSlot(weaponid)] = ammo;
    GivePlayerWeapon(playerid,weaponid,ammo);
    return 1;
}
PLC::ResetWeapon(playerid)
{
    forex(i,13)
    {
        pWeapon[playerid][i] = 0;
        pAmmo[playerid][i] = 0;
    }
    ResetPlayerWeapons(playerid);
    return 1;
}
PLC::RecoverWeapon(playerid)
{
    ResetPlayerWeapons(playerid);
    forex(i,13)
    {
        if(pWeapon[playerid][i]!=0)GivePlayerWeapon(playerid,pWeapon[playerid][i],pAmmo[playerid][i]);
    }
    return 1;
}
PLC::Anti_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(IsShotWeaponModel(weaponid))
	{
	    new index=IsWeaponHave(playerid,weaponid);
	    if(index==NOTHING)return CRF("OnPlayerHack","ii",playerid,HACK_WEAPON);
        oAmmo[playerid] = GetPlayerAmmo(playerid);
	    if(oAmmo[playerid]<0)return CRF("OnPlayerHack","ii",playerid,HACK_WEAPON_AMMO);
		oWeapon[playerid]=GetPlayerWeapon(playerid);
		pAmmo[playerid][index]=oAmmo[playerid];
		KillTimer(CheckAmmo_Time[playerid]);
        CheckAmmo_Time[playerid]=SetTimerEx("CheckAmmo",200,false,"i",playerid);
	}
    return 1;
}
PLC::Anti_OnPlayerSpawn(playerid)
{
    psapwn[playerid]=true;
    return 1;
}
PLC::IsSpawn(playerid)return psapwn[playerid];
PLC::TeleportChecker(playerid)
{
	if(!IsSpawn(playerid))return 1;
	OpenDoor(playerid);
	new Float:fX, Float:fY, Float:fZ;
	GetPlayerPos(playerid,fX, fY, fZ);
    if(gettime( ) - pLastPosTick[ playerid ] > 1)
    {
         if( !IsPlayerInRangeOfPoint(playerid, 50.0, AC_Position[0], AC_Position[1], AC_Position[2]) && !Bit_Get(AC_SafeTP, playerid) && !IsPlayerNPC(playerid)
        && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT&&!OpenIng[playerid])CRF("OnPlayerHack","ii",playerid,HACK_TELEPORT);
        else if( !IsPlayerInRangeOfPoint(playerid, 300.0, AC_Position[0], AC_Position[1], AC_Position[2]) && !Bit_Get(AC_SafeTP, playerid) && !IsPlayerNPC(playerid)
        && GetVehicleSpeed( GetPlayerVehicleID(playerid)) <= 50 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)CRF("OnPlayerHack","ii",playerid,HACK_TELEPORT);
        GetPlayerPos(playerid, AC_Position[ 0 ], AC_Position[ 1 ], AC_Position[ 2 ]);
        Bit_Set(AC_SafeTP, playerid, false);
        pLastPosTick[ playerid ] = gettime( ) + 2;
    }
    return 1;
}

OpenDoor(playerid)
{
	new animlib[32];
	new animname[32];
	GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
	if(!strcmp(animname,"WALK_DOORPARTIAL", false))OpenIng[playerid]=true;
	if(!strcmp(animname,"IDLE_STANCE",false)&&OpenIng[playerid])
	{
    	GetPlayerPos(playerid, AC_Position[0], AC_Position[1], AC_Position[2]);
    	Bit_Set(AC_SafeTP, playerid, true);
    	OpenIng[playerid]=false;
	}
    return 1;
}
stock SetSpawnInfoEx(playerid, team, skin, Float:x, Float:y, Float:z, Float:Angle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
{
	AC_Position[0]=x;
	AC_Position[1]=y;
	AC_Position[2]=z;
    SetSpawnInfo(playerid, team, skin,x,y,z,Angle, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);
    return 1;
}
stock SetPos(playerid, Float:PosX, Float:PosY, Float:PosZ)
{
    GetPlayerPos(playerid, AC_Position[0], AC_Position[1], AC_Position[2]);
    Bit_Set(AC_SafeTP, playerid, true);
    return SetPlayerPos(playerid, PosX, PosY, PosZ);
}
stock SetPosFindZ(playerid, Float:PosX, Float:PosY, Float:PosZ)
{
    GetPlayerPos(playerid, AC_Position[0], AC_Position[1], AC_Position[2]);
    Bit_Set(AC_SafeTP, playerid, true);
    return SetPlayerPosFindZ(playerid, PosX, PosY, PosZ);
}
stock PutInVehicle(playerid, vehicleid, seatid)
{
    GetPlayerPos(playerid, AC_Position[0], AC_Position[1], AC_Position[2]);
    Bit_Set(AC_SafeTP, playerid, true);
    return PutPlayerInVehicle(playerid, vehicleid, seatid);
}
stock SetInterior(playerid, interiorid)
{
    GetPlayerPos(playerid, AC_Position[0], AC_Position[1], AC_Position[2]);
    Bit_Set(AC_SafeTP, playerid, true);
    return SetPlayerInterior(playerid, interiorid);
}
static stock GetVehicleSpeed( vehicleid ) 
{
    new Float:VehiclePos[3],VehicleVelocity;
    GetVehicleVelocity( vehicleid, VehiclePos[0], VehiclePos[1], VehiclePos[2] );
    VehicleVelocity = floatround( floatsqroot( VehiclePos[0]*VehiclePos[0] + VehiclePos[1]*VehiclePos[1] + VehiclePos[2]*VehiclePos[2] ) * 180 );
    return VehicleVelocity;
}

PLC::CheckAmmo(playerid)
{
    nAmmo[playerid] = GetPlayerAmmo(playerid);
    nWeapon[playerid] = GetPlayerWeapon(playerid);
    new index=IsWeaponHave(playerid,nWeapon[playerid]);
	if(index==NOTHING)return CRF("OnPlayerHack","ii",playerid,HACK_WEAPON);
    if(oWeapon[playerid]==nWeapon[playerid])
    {
        if(nAmmo[playerid]>=oAmmo[playerid])return CRF("OnPlayerHack","ii",playerid,HACK_WEAPON_AMMO);
        if(nAmmo[playerid]<0)return CRF("OnPlayerHack","ii",playerid,HACK_WEAPON_AMMO);
    }
    pAmmo[playerid][index]=nAmmo[playerid];
    return 1;
}
PLC::IsWeaponHave(playerid,weaponid)
{
    forex(i,13)if(pWeapon[playerid][i]==weaponid)return i;
    return NOTHING;
}
PLC::WeaponCheck(playerid)
{
    forex(i,13)
    {
        new ammo,weaponid;
        GetPlayerWeaponData(playerid,i,weaponid,ammo);
		if(weaponid != 0&&weaponid!=pWeapon[playerid][WeaponSlot(weaponid)])return CRF("OnPlayerHack","ii",playerid,HACK_WEAPON);
    }
    return 1;
}
PLC::IsShotWeaponModel(weaponid)
{
    if(weaponid < 16 || weaponid == 19 || weaponid == 20 || weaponid == 21 || weaponid > 38) return 0;
	return 1;
}

PLC::AntiCheater(playerid)
{
	if(GetTickCount() - Anti_pTick[playerid] > 500)
	{
    	WeaponCheck(playerid);
    	Anti_pTick[playerid] = GetTickCount();
    }
	if(GetTickCount() - Anti_car_pTick[playerid] > 200)
	{
	    SpeedHackChacker(playerid);
	    Anti_car_pTick[playerid] = GetTickCount();
	}
	TeleportChecker(playerid);
	/*if(GetPlayerAnimationIndex(playerid))
    {
        new animlib[32];
        new animname[32];
        new msg[128];
        GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
        format(msg, 128, "Running anim: %s %s", animlib, animname);
        printf("%s",msg);
    }*/
	return 1;
}

stock WeaponSlot(weaponid)
{
    if(weaponid == 0){return 0;}
    else if(weaponid == 1){return 0;}
    else if(weaponid == 2){return 1;}
    else if(weaponid == 3){return 1;}
    else if(weaponid == 4){return 1;}
    else if(weaponid == 5){return 1;}
    else if(weaponid == 6){return 1;}
    else if(weaponid == 7){return 1;}
    else if(weaponid == 8){return 1;}
    else if(weaponid == 9){return 1;}
    else if(weaponid == 10){return 10;}
    else if(weaponid == 11){return 10;}
    else if(weaponid == 12){return 10;}
    else if(weaponid == 13){return 10;}
    else if(weaponid == 14){return 10;}
    else if(weaponid == 15){return 10;}
    else if(weaponid == 16){return 8;}
    else if(weaponid == 17){return 8;}
    else if(weaponid == 18){return 8;}
    else if(weaponid == 22){return 2;}
    else if(weaponid == 23){return 2;}
    else if(weaponid == 24){return 2;}
    else if(weaponid == 25){return 3;}
    else if(weaponid == 26){return 3;}
    else if(weaponid == 27){return 3;}
    else if(weaponid == 28){return 4;}
    else if(weaponid == 29){return 4;}
    else if(weaponid == 30){return 5;}
    else if(weaponid == 31){return 5;}
    else if(weaponid == 32){return 4;}
    else if(weaponid == 33){return 6;}
    else if(weaponid == 34){return 6;}
    else if(weaponid == 35){return 7;}
    else if(weaponid == 36){return 7;}
    else if(weaponid == 37){return 7;}
    else if(weaponid == 38){return 7;}
    else if(weaponid == 39){return 8;}
    else if(weaponid == 40){return 12;}
    else if(weaponid == 41){return 9;}
    else if(weaponid == 42){return 9;}
    else if(weaponid == 43){return 9;}
    else if(weaponid == 44){return 11;}
    else if(weaponid == 45){return 11;}
    else if(weaponid == 46){return 11;}
    else {return false;}
}
PLC::SpeedHackChacker(playerid)
{
	new keys, updown, leftright;
	GetPlayerKeys(playerid, keys, updown, leftright);
    new Float:Pos[4];
	Pos[3] = GetPlayerDistanceFromPoint(playerid, Pos[0], Pos[1], Pos[2]);
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	if((keys & KEY_ACTION || keys & KEY_FIRE) && (floatround(floatmul(Pos[3], 10.0)) > 200) && (IsPlayerInAnyVehicle(playerid)))return CRF("OnPlayerHack","ii",playerid,HACK_CAR_SPEED);
 	return 1;
}
stock GetPlayerSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
	GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
	else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
    return floatround(ST[3]);
}
