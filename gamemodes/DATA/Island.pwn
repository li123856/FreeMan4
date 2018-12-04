#include DATA/island_function.pwn
PLC::island_OnGameModeInit()
{
	Iter_Init(islandobject);
    mysql_tquery(1, "SELECT * FROM `"SQL_ISLAND_DATABASE"`", "OnIslandLoad", "");
	return 1;
}
PLC::island_OnGameModeExit()
{
	foreach(new r : island)orm_destroy(island[r][_orm]);
	return 1;
}
PLC::CMD_ADDLAND(playerid,body[])
{
    new name[80],index;
    if(sscanf(body,"s[80]i",name,index)) return Usage(playerid, "/add land 名称 模型组ID");
    if(strlenEx(name)<4||strlenEx(name)>20)return Info(playerid,"建筑名称最少2个字,最多10个字");
    if(!Iter_Contains(obj,index))return Info(playerid,"没有此建筑模型");
	new Float:cos[3];
	GetPlayerPos(playerid,cos[0],cos[1],cos[2]);
    if(!AddIsLand(playerid,cos[0],cos[1],cos[2],index,name))return SCM(playerid,"创建建筑失败");
	return 1;
}
PLC::CMD_DELLAND(playerid,body[])
{
    new index;
    if(sscanf(body,"i",index)) return Usage(playerid, "/del land ID");
    if(!IsLand_Delete(index))return Info(playerid,"ID无效");
	return 1;
}

