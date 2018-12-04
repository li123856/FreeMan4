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
	    format(line,sizeof(line),"%s 指令不存在!",cmdtext);
	    Info(playerid, line);
	}
	return 1;
}
PLC::CMD_ADDCS(playerid,body[])
{
    new name[80],cmd[60];
    if(sscanf(body,"s[80]s[40]",name,cmd)) return Usage(playerid, "/add cs 名称 指令[不带/]");
    if(ExistChinese(cmd))return Info(playerid,"指令不能包含中文");
    if(strlenEx(name)<4||strlenEx(name)>20)return Info(playerid,"传送名称最少2个字,最多10个字");
    if(strlen(cmd)<2||strlen(cmd)>10)return Info(playerid,"传送指令最少2个字,最多10个字");
    if(!addtele(playerid,cmd,name))return Info(playerid,"传送数量已达上限,无法创建了");
	return 1;
}
PLC::CMD_DELCS(playerid,body[])
{
    new index;
    if(sscanf(body,"%i",index)) return Usage(playerid, "/del ID");
    if(!Tele_Delete(index))return Info(playerid,"ID无效");
	return 1;
}
CMD:llcs(playerid, params[], help)
{
    if(!Iter_Count(tele))return SCM(playerid,""CHAT_YELLOW"[传送] 当前世界没有可用自定义传送,创建传送/add cs");
	page[playerid]=1;
	new caption[100];
	format(caption,sizeof(caption),"玩家传送/llcs -共计[%i个] 创建传送/cs add",Iter_Count(tele));
	Dialog_Show(playerid,_TELE_LIST, DIALOG_STYLE_TABLIST_HEADERS,caption,ShowTeleList(playerid,page[playerid]), "确定", "取消");
	return 1;
}
CMD:wdcs(playerid, params[], help)
{
    if(!Iter_Count(tele))return SCM(playerid,""CHAT_YELLOW"[传送] 没有可用自定义传送,创建传送/add cs");
	page[playerid]=1;
	new caption[100];
	format(caption,sizeof(caption),"我的传送/wdcs 创建传送/csadd");
	Dialog_Show(playerid,_TELE_MY_LIST, DIALOG_STYLE_TABLIST_HEADERS,caption,ShowMyTeleList(playerid,page[playerid]), "确定", "取消");
	return 1;
}
