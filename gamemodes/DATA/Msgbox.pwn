#include DATA/msgbox_function.pwn
PLC::msgbox_OnGameModeInit()
{
    mysql_tquery(1, "SELECT * FROM `"SQL_MSGBOX_DATABASE"`", "OnMboxLoad", "");
	return 1;
}
PLC::msgbox_OnGameModeExit()
{
	foreach(new r : mbox)orm_destroy(mbox[r][_orm]);
	return 1;
}
CMD:sendmail(playerid, params[], help)
{
    if(!addbox_msg(pdate[playerid][_uid],pdate[playerid][_name],params))return SCM(playerid,""CHAT_YELLOW"[����] ��������,�޷�ʹ����");
	return 1;
}
CMD:mail(playerid, params[], help)
{
    if(!Iter_Count(mbox))return SCM(playerid,""CHAT_YELLOW"[����] �������û���ż�");
	page[playerid]=1;
	new caption[100];
	format(caption,sizeof(caption),"�ҵ����� /mail-����[%i/%i] *��ɫ δ�� *��ɫ �Ѷ� ",Iter_Count(mbox),MAX_MSG_OWNER(playerid));
	Dialog_Show(playerid,_MSG_LIST, DIALOG_STYLE_TABLIST_HEADERS,caption,ShowMsgBoxList(playerid,page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
PLC::CMD_DELMSG(playerid,body[])
{
    Iter_Free(mbox);
    new query[128];
	format(query, sizeof(query),"TRUNCATE TABLE `"SQL_MSGBOX_DATABASE"`");
	mysql_query(1,query,false);
	return 1;
}
