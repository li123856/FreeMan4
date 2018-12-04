#include DATA/tele_function.pwn
PLC::tele_OnGameModeInit()
{
    mysql_tquery(1, "SELECT * FROM `"SQL_TELE_DATABASE"`", "OnTeleLoad", "");
	return 1;
}
PLC::tele_OnGameModeExit()
{
	foreach(new r : tele)orm_destroy(tele[r][_orm]);
	return 1;
}
public OnPlayerCommandReceived(playerid,cmdtext[])
{
	if(cmdtext[0] == '/'&& cmdtext[1])
	{
		new line0[40],line1[40];
		format(line0,sizeof(line0),cmdtext[1]);
		strlower(line0);
		foreach(new i:tele)
		{
	        format(line1,sizeof(line1),tele[i][_cmd]);
	        strlower(line1);
			if(!strcmp(line0,line1, false))
			{
			    TeleHandle(playerid,i);
			    return 0;
			}
		}
 	}
	return 1;
}
public OnPlayerCommandPerformed(playerid,cmdtext[], success)
{
	if(!success)
	{
	    new line[128];
	    format(line,sizeof(line),"%s ָ�����!",cmdtext);
	    Info(playerid, line);
	}
	return 1;
}
PLC::CMD_ADDCS(playerid,body[])
{
    new name[80],cmd[60];
    if(sscanf(body,"s[80]s[40]",name,cmd)) return Usage(playerid, "/add cs ���� ָ��[����/]");
    if(ExistChinese(cmd))return Info(playerid,"ָ��ܰ�������");
    if(strlenEx(name)<4||strlenEx(name)>20)return Info(playerid,"������������2����,���10����");
    if(strlen(cmd)<2||strlen(cmd)>10)return Info(playerid,"����ָ������2����,���10����");
    if(!addtele(playerid,cmd,name))return Info(playerid,"���������Ѵ�����,�޷�������");
	return 1;
}
PLC::CMD_DELCS(playerid,body[])
{
    new index;
    if(sscanf(body,"%i",index)) return Usage(playerid, "/del ID");
    if(!Tele_Delete(index))return Info(playerid,"ID��Ч");
	return 1;
}
CMD:llcs(playerid, params[], help)
{
    if(!Iter_Count(tele))return SCM(playerid,""CHAT_YELLOW"[����] ��ǰ����û�п����Զ��崫��,��������/add cs");
	page[playerid]=1;
	new caption[100];
	format(caption,sizeof(caption),"��Ҵ���/llcs -����[%i��] ��������/cs add",Iter_Count(tele));
	Dialog_Show(playerid,_TELE_LIST, DIALOG_STYLE_TABLIST_HEADERS,caption,ShowTeleList(playerid,page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
CMD:wdcs(playerid, params[], help)
{
    if(!Iter_Count(tele))return SCM(playerid,""CHAT_YELLOW"[����] û�п����Զ��崫��,��������/add cs");
	page[playerid]=1;
	new caption[100];
	format(caption,sizeof(caption),"�ҵĴ���/wdcs ��������/csadd");
	Dialog_Show(playerid,_TELE_MY_LIST, DIALOG_STYLE_TABLIST_HEADERS,caption,ShowMyTeleList(playerid,page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
