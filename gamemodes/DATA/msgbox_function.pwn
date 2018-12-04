PLC::OnMboxLoad()
{
    forex(r,cache_num_rows())
	{
		new ORM:ormid = mbox[r][_orm] = orm_create(SQL_MSGBOX_DATABASE);
		orm_addvar_int(ormid, mbox[r][_id], "ID");
		orm_addvar_int(ormid, mbox[r][_pid],"PID");
		orm_addvar_int(ormid, mbox[r][_cash],"CASH");
		orm_addvar_int(ormid, mbox[r][_qb],"QB");
		orm_addvar_int(ormid, mbox[r][_read],"READ");
		orm_addvar_string(ormid, mbox[r][_msg],256,"MSG");
		orm_addvar_string(ormid, mbox[r][_sender],80,"SENDER");
		orm_addvar_string(ormid, mbox[r][_sendtime],40,"SENDTIME");
		orm_apply_cache(ormid, r);
		orm_setkey(ormid,"ID");
		Iter_Add(mbox,r);
	}
	return 1;
}
stock addbox_msg(to_id,send_name[],msg[],money=0,qb=0)
{
	if(GetPlayerMsgCount(to_id)>MAX_MSG_OWNER(GetPidVip(to_id))) return 0;
    if(Iter_Free(mbox) == -1) return 0;
    new r = Iter_Free(mbox);
    mbox[r][_pid]=to_id;
    format(mbox[r][_sender],80,send_name);
    format(mbox[r][_msg],80,msg);
    mbox[r][_cash]=money;
    mbox[r][_qb]=qb;
	new date[3];
	new time[3];
	getdate(date[0], date[1], date[2]);
	gettime(time[0], time[1], time[2]);
   	format(mbox[r][_sendtime],40, "%d/%d/%d %02d:%02d:%02d",date[0],date[1],date[2],time[0],time[1],time[2]);
    new ORM:ormid=mbox[r][_orm]=orm_create(SQL_MSGBOX_DATABASE);
    orm_addvar_int(ormid,mbox[r][_pid],"PID");
    orm_addvar_int(ormid,mbox[r][_cash],"CASH");
    orm_addvar_int(ormid,mbox[r][_qb],"QB");
    orm_addvar_int(ormid,mbox[r][_read],"READ");
   	orm_addvar_string(ormid,mbox[r][_sender],80,"SENDER");
   	orm_addvar_string(ormid,mbox[r][_msg],256,"MSG");
   	orm_addvar_string(ormid,mbox[r][_sendtime],40,"SENDTIME");
    orm_insert(ormid,"Msg_Create","i",r);
	return 1;
}
PLC::Msg_Create(msgid)
{
	Iter_Add(mbox,msgid);
	orm_setkey(mbox[msgid][_orm],"ID");
	new pid=GetPid_ID(mbox[msgid][_pid]);
	if(pid!=NOTHING)
	{
		new pesan[256];
		format(pesan, sizeof(pesan), ""CHAT_YELLOW"[����] "CHAT_WHITE"����һ������"CHAT_RED"%s"CHAT_WHITE"�����ʼ�,/mail �鿴", mbox[msgid][_sender]);
        SCM(pid,pesan);
        if(GetPlayerMsgCount(pdate[pid][_uid])+10>=MAX_MSG_OWNER(pid))
        {
 			format(pesan, sizeof(pesan), ""CHAT_YELLOW"[����] ������������,�뼰ʱ����,�����޷������ʼ�,��ǰ %i/%i (����VIP��������)",GetPlayerMsgCount(pid),MAX_MSG_OWNER(pid));
        	SCM(pid,pesan);
        }
	}
	return 1;
}
PLC::Msg_Delete(msgid)
{
	if(!Iter_Contains(mbox,msgid))return 0;
    orm_delete(mbox[msgid][_orm],true);
    Iter_Remove(mbox,msgid);
	return 1;
}
PLC::GetPlayerMsgCount(pid)
{
	new count=0;
	foreach(new i:mbox)
    {
        if(mbox[i][_pid]==pid)count++;
    }
    return count;
}
PLC::Msg_SendUnRead(playerid)
{
	new count=0;
	foreach(new i:mbox)
    {
        if(mbox[i][_pid]==pdate[playerid][_uid])
        {
            if(!mbox[i][_read])count++;
        }
    }
    if(count>0)
    {
		new line[128];
		format(line, sizeof(line), "�㻹�� %i ���ʼ�δ��,/mail �鿴",count);
	    SCM(playerid,line);
    }
	return 1;
}
PLC::GetPid_ID(pid)
{
	foreach(new i:Player)
    {
    	if(IsPlayerConnected(i))
    	{
    	    if(IsLogin(i))
    	    {
    	        if(pdate[i][_uid]>0)
    	        {
    	        	if(pdate[i][_uid]==pid)return i;
    	        }
    	    }
    	}
    }
    return NOTHING;
}
stock ShowMsgBoxList(playerid,pager)
{
    listarray[playerid]=1;
    for(new i=Iter_End(mbox);(i=Iter_Prev(mbox, i))!=Iter_Begin(mbox);)
	{
		if(mbox[i][_pid]==pdate[playerid][_uid])
		{
			totals[playerid][listarray[playerid]]=i;
        	listarray[playerid]++;
 		}
	}
    new body[1024];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager == 0)pager = 1;
	else pager++;
	new over=0;
	format(body,sizeof(body), "������\tʱ��\t����\n");
	strcat(body, "\t\t"CHAT_SERVER"��һҳ\n");
	Loop(i,pager,pager+MAX_DILOG_LIST)
	{
		new line[100],index=totals[playerid][i];
		if(i<listarray[playerid])
        {
            if(mbox[index][_read])strcat(line,""CHAT_WHITE"");
            else strcat(line,""CHAT_YELLOW"");
            new str[80];
            format(str,sizeof(str),"%s\t%s\t",mbox[index][_sender],mbox[index][_sendtime]);
            strcat(line,str);
            if(mbox[index][_cash]>0||mbox[index][_qb]>0)strcat(line,"��\n");
            else strcat(line,"��\n");
		}
		if(i>=listarray[playerid])
		{
			over=1;
			break;
		}
		else strcat(body,line);
	}
	if(over==0)strcat(body, "\t\t"CHAT_SERVER"��һҳ\n");
    return body;
}
Dialog:_MSG_LIST(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pager=(page[playerid]-1)*MAX_DILOG_LIST;
		if(pager == 0)pager = 1;
		else pager++;
		switch(listitem)
		{
		    case 0:
		  	{
		    	page[playerid]--;
		    	if(page[playerid]<1)
		    	{
		    	    page[playerid]=1;
		    	    SCM(playerid,""CHAT_YELLOW"[����] û����һҳ��");
		    	}
				Dialog_Show(playerid,_MSG_LIST,DIALOG_STYLE_TABLIST_HEADERS,"�ҵ����� /mail",ShowMsgBoxList(playerid,page[playerid]), "�Ķ�", "ȡ��");
		    }
		    case MAX_DILOG_LIST+1:
		    {
	    		page[playerid]++;
				Dialog_Show(playerid,_MSG_LIST,DIALOG_STYLE_TABLIST_HEADERS,"�ҵ����� /mail",ShowMsgBoxList(playerid,page[playerid]), "�Ķ�", "ȡ��");
		    }
			default:
			{
				new index=totals[playerid][pager+listitem-1];
	            ReadMsg(playerid,index);
			}
		}
	}
	return 1;
}
Dialog:_MSG_READ(playerid, response, listitem, inputtext[])
{
	if(response)Dialog_Show(playerid,_MSG_READ_DO, DIALOG_STYLE_LIST,"�ż�����","��ȡ����\nɾ���ż�\n�������", "ѡ��", "����");
	else Dialog_Show(playerid,_MSG_LIST,DIALOG_STYLE_TABLIST_HEADERS,"�ҵ����� /mail",ShowMsgBoxList(playerid,page[playerid]), "�Ķ�", "ȡ��");
	return 1;
}
Dialog:_MSG_READ_DO(playerid, response, listitem, inputtext[])
{
    new index=GetPVarInt(playerid,"MsgBox_Index");
    if(response)
    {
		switch(listitem)
		{
		    case 0:
		    {
		        if(mbox[index][_cash]>0||mbox[index][_qb]>0)
		        {
		            if(mbox[index][_cash]>0)
					{
					    new line[128];
					    format(line,sizeof(line),""CHAT_YELLOW"[����] ����ȡ�˸�����Ϸ�� $%i",mbox[index][_cash]);
					    SCM(playerid,line);
						GiveCash(playerid,mbox[index][_cash]);
					}
		            if(mbox[index][_qb]>0)
					{
					    new line[128];
					    format(line,sizeof(line),""CHAT_YELLOW"[����] ����ȡ�˸���Q�� %i��",mbox[index][_qb]);
					    SCM(playerid,line);
						GiveQb(playerid,mbox[index][_qb]);
					}
					mbox[index][_qb]=0;
					mbox[index][_cash]=0;
					orm_update(mbox[index][_orm]);
		        }
		        else
				{
					SCM(playerid,""CHAT_YELLOW"[����] ���ż�û�и������ѱ���ȡ");
					Dialog_Show(playerid,_MSG_READ_DO, DIALOG_STYLE_LIST,"�ż�����","��ȡ����\nɾ���ż�\n�������", "ѡ��", "����");
				}
		    }
		    case 1:
		    {
		        orm_delete(mbox[index][_orm],true);
                Iter_Remove(mbox,index);
                Dialog_Show(playerid,_MSG_LIST,DIALOG_STYLE_TABLIST_HEADERS,"�ҵ����� /mail",ShowMsgBoxList(playerid,page[playerid]), "�Ķ�", "ȡ��");
                SCM(playerid,""CHAT_YELLOW"[����] ���ż��ѱ�ɾ��");
		    }
		    case 2:
		    {
				foreach(new i : mbox)
			   	{
			   	    new	cur = i;
					if(mbox[cur][_pid]==pdate[playerid][_uid])
					{
					    orm_delete(mbox[i][_orm],true);
					    Iter_SafeRemove(mbox,cur,i);
		     		}
				}
                SCM(playerid,""CHAT_YELLOW"[����] ��������ѱ����");
		    }
		}
    }
    else ReadMsg(playerid,index);
	return 1;
}
PLC::ReadMsg(playerid,msgid)
{
	new caption[100];
	format(caption,sizeof(caption),"������:%s",mbox[msgid][_sender]);
	new body[1024],line[256];
	format(line, sizeof(line),"����ʱ��:%s\n",mbox[msgid][_sendtime]);
	strcat(body,line);
	strcat(body,"����\n");
	format(line,sizeof(line),"%s\n",mbox[msgid][_msg]);
	strcat(body,line);
	strcat(body,"����\n");
	new over=0;
	if(mbox[msgid][_cash]>0)
	{
	    format(line,sizeof(line),"��Ϸ��: $%i\n",mbox[msgid][_cash]);
		strcat(body,line);
		over++;
	}
	if(mbox[msgid][_qb]>0)
	{
	    format(line,sizeof(line),"Q��: %i��\n",mbox[msgid][_qb]);
		strcat(body,line);
		over++;
	}
	if(!over)strcat(body,"��");
	Dialog_Show(playerid,_MSG_READ,DIALOG_STYLE_MSGBOX,caption,body, "����", "����");
	SetPVarInt(playerid,"MsgBox_Index",msgid);
	mbox[msgid][_read]=1;
	orm_update(mbox[msgid][_orm]);
	return 1;
}
