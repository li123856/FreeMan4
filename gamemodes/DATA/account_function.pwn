PLC::OnPlayerDataLoad(playerid)
{
	switch(orm_errno(pdate[playerid][_orm]))
	{
		case ERROR_OK:
		{
		    Ban_OnPlayerCome(playerid);
		    SetReg(playerid,1);
		    Info(playerid, "����������...���Ժ�!!!");
		    pdate[playerid][_logindialog]=SetTimerEx("LoginDialog",5000, false, "i", playerid);
		}
		case ERROR_NO_DATA:
		{
		    SetReg(playerid,0);
		    Dialog_Show(playerid,_REG, DIALOG_STYLE_INPUT,"ע���˻�","�㻹û��ע���˻�,������������ע��.","ע��","ȡ��");
		}
	}
	orm_setkey(pdate[playerid][_orm],"ID");
	return 1;
}
PLC::LoginDialog(playerid)return Dialog_Show(playerid,_LOGIN, DIALOG_STYLE_PASSWORD,"��¼","��������������½","��¼","ȡ��");
Dialog:_LOGIN(playerid, response, listitem, inputtext[])
{
	if(GetPlayerBanDate(playerid))
	{
		Dialog_Show(playerid,_BAN_MTO,DIALOG_STYLE_MSGBOX,"�㱻������",BanStr(playerid), "��", "");
        KickEx(playerid);
        return 1;
	}
    if(response)
    {
    	new hpass[128];
    	SHA256_PassHash(inputtext,"",hpass,128);
        if(!strcmp(hpass,pdate[playerid][_pass], false))
		{
		    SetLoginState(playerid,1);
		    if(pdate[playerid][_choose])
		    {
	    		OnPlayerLogin(playerid);
           		ResetPlayerMoney(playerid);
   				GivePlayerMoney(playerid,pdate[playerid][_cash]);
	    		SetSpawnInfoEx(playerid,NO_TEAM,pdate[playerid][_skin],pdate[playerid][_x],pdate[playerid][_y],pdate[playerid][_z], pdate[playerid][_a],0,0,0,0,0,0 );
           		SpawnPlayer(playerid);
           	}
           	else OnPlayerRegister(playerid);
		}
		else
		{
			new string[128];
			format(string, sizeof(string),"��ӭ����%s,�������,������������������½",pdate[playerid][_name]);
			Dialog_Show(playerid,_LOGIN, DIALOG_STYLE_PASSWORD,"��¼",string,"��¼","ȡ��");
		}
    }
    else Dialog_Show(playerid,_LOGIN, DIALOG_STYLE_PASSWORD,"��¼","�����������¼","��¼","ȡ��");
	return 1;
}
Dialog:_REG(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext)<4||strlen(inputtext)>10)return Dialog_Show(playerid,_REG,DIALOG_STYLE_PASSWORD, "�ַ�����", "�㻹û��ע��,����������ע��", "ע��", "�˳�");
		SHA256_PassHash(inputtext,"",pdate[playerid][_pass],128);
		format(pdate[playerid][_motto],256," ");
		pGang(playerid)=NOTHING;
		pdate[playerid][_choose]=0;
		SetReg(playerid,1);
		SetLoginState(playerid,1);
		orm_insert(pdate[playerid][_orm], "OnPlayerRegister", "i", playerid);
	}
    else Dialog_Show(playerid,_REG, DIALOG_STYLE_INPUT,"ע���˻�","�㻹û��ע���˻�,������������ע��.","ע��","ȡ��");
    return 1;
}
PLC::OnPlayerRegister(playerid)
{
	Ban_OnPlayerCome(playerid);
    Info(playerid, "��ѡ��Ҫʹ�õĽ�ɫ");
    Info(playerid, "����SPAWN��������");
	return 1;
}
stock PersonInfo(playerid)
{
	new body[1024],line[128];
	format(line, sizeof(line),"���ݿ�ID:%i\n",pdate[playerid][_uid]);
	strcat(body,line);
	format(line,sizeof(line),"����:%s",pdate[playerid][_name]);
	strcat(body,line);
	format(line,sizeof(line),"����ȼ�:%i",pdate[playerid][_admin]);
	strcat(body,line);
	format(line,sizeof(line),"VIP�ȼ�:%i",VIP(playerid));
	strcat(body,line);
	format(line,sizeof(line),"��Ϸ�ȼ�:%i [%i/%i]",pdate[playerid][_level],pdate[playerid][_exp]);
	strcat(body,line);
	format(line,sizeof(line),"�ֽ�:$%i",pdate[playerid][_cash]);
	strcat(body,line);
	format(line,sizeof(line),"���:$%i",pdate[playerid][_bank]);
	strcat(body,line);
	format(line,sizeof(line),"��ȫǮ��:$%i��",pdate[playerid][_moneybag]);
	strcat(body,line);
	format(line,sizeof(line),"������:$%i",pdate[playerid][_kill]);
	strcat(body,line);
	format(line,sizeof(line),"ɱ����:$%i",pdate[playerid][_death]);
	strcat(body,line);
	if(Iter_Contains(gang,pGang(playerid)))
	{
		format(line,sizeof(line),"��˾:%s [%s]",GetGangName(pGang(playerid)),GetGangRankName(pGang(playerid),pGangLevel(playerid)));
		strcat(body,line);
	}
	return body;
}
