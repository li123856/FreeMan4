#include DATA/gang_function.pwn
PLC::gang_OnGameModeInit()
{
    mysql_tquery(1, "SELECT * FROM `"SQL_GROUP_DATABASE"`", "OnGangLoad", "");
	return 1;
}
PLC::gang_OnGameModeExit()
{
	foreach(new r : gang)orm_destroy(gang[r][_orm]);
	return 1;
}
PLC::gang_OnPlayerText(playerid, text[])
{
	if(pGang(playerid)!=NOTHING)
	{
	    if(!Iter_Contains(gang,pGang(playerid)))
	    {
	        pGang(playerid)=NOTHING;
	        pGangLevel(playerid)=0;
	        orm_update(pdate[playerid][_orm]);
	    }
	    else
	    {
			new body[512],line[128];
			format(line,sizeof(line),"[%s%s"#CHAT_WHITE"][%s]%s%s:%s",hue[gang[pGang(playerid)][_color]][_code],gang[pGang(playerid)][_name],RankReturn(pGang(playerid),pGangLevel(playerid)),pdate[playerid][_color],pdate[playerid][_name],pdate[playerid][_saycolor]);
			strcat(body,line);
			strcat(body,text);
			SendClientMessageToAll(COLOR_WHITE,body);
		}
	}
	return 1;
}
PLC::gang_OnPlayerLogin(playerid)
{
	if(pGang(playerid)!=NOTHING)
	{
	    if(!Iter_Contains(gang,pGang(playerid)))
	    {
	        pGang(playerid)=NOTHING;
	        pGangLevel(playerid)=0;
	        orm_update(pdate[playerid][_orm]);
	        SetPlayerColor(playerid,hue[pdate[playerid][_color]][_code]);
	    }
	    else
	    {
	    	SetPlayerColor(playerid,hue[gang[pGang(playerid)][_color]][_code]);
			new line[128];
			format(line,sizeof(line),"* [%s%s"#CHAT_WHITE"][%s]%s%s"#CHAT_WHITE"��½��!",hue[gang[pGang(playerid)][_color]][_code],gang[pGang(playerid)][_name],RankReturn(pGang(playerid),pGangLevel(playerid)),hue[pdate[pGang(playerid)][_color]][_code],pdate[playerid][_name]);
			SendClientMessageToAll(COLOR_WHITE,line);
		}
	}
    return 1;
}
PLC::CMD_JOINGANG(playerid,body[])
{
    if(pGang(playerid)!=NOTHING) return SCM(playerid,"���Ѿ��ڹ�˾��,�޷�����");
	new index;
    if(sscanf(body,"i",index)) return Usage(playerid, "/join gang ID");
    if(!Iter_Contains(gang,index))return SCM(playerid,"�ù�˾������");
    Join_Gang(playerid,index);
	return 1;
}
PLC::CMD_DELGANG(playerid,body[])
{
	new index;
    if(sscanf(body,"i",index)) return Usage(playerid, "/del gang ID");
    if(!Iter_Contains(gang,index))return SCM(playerid,"�ù�˾������");
    Gang_Delete(index);
	return 1;
}
PLC::CMD_ADDGANG(playerid,body[])
{
    if(pGang(playerid)!=NOTHING) return SCM(playerid,"���Ѿ��ڹ�˾��,�޷�����");
    new name[80];
    if(sscanf(body,"s[80]",name)) return Usage(playerid, "/add gang ����");
    if(strlen(name)<2||strlen(name)>20)return Info(playerid,"�ַ����ٻ����");
    if(!addgang(playerid,name))return SCM(playerid,"����ʧ��");
	return 1;
}
