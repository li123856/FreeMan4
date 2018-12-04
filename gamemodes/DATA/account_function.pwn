PLC::OnPlayerDataLoad(playerid)
{
	switch(orm_errno(pdate[playerid][_orm]))
	{
		case ERROR_OK:
		{
		    Ban_OnPlayerCome(playerid);
		    SetReg(playerid,1);
		    Info(playerid, "载入资料中...请稍后!!!");
		    pdate[playerid][_logindialog]=SetTimerEx("LoginDialog",5000, false, "i", playerid);
		}
		case ERROR_NO_DATA:
		{
		    SetReg(playerid,0);
		    Dialog_Show(playerid,_REG, DIALOG_STYLE_INPUT,"注册账户","你还没有注册账户,请输入密码来注册.","注册","取消");
		}
	}
	orm_setkey(pdate[playerid][_orm],"ID");
	return 1;
}
PLC::LoginDialog(playerid)return Dialog_Show(playerid,_LOGIN, DIALOG_STYLE_PASSWORD,"登录","请输入密码来登陆","登录","取消");
Dialog:_LOGIN(playerid, response, listitem, inputtext[])
{
	if(GetPlayerBanDate(playerid))
	{
		Dialog_Show(playerid,_BAN_MTO,DIALOG_STYLE_MSGBOX,"你被封锁了",BanStr(playerid), "呃", "");
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
			format(string, sizeof(string),"欢迎回来%s,密码错误,请重新输入密码来登陆",pdate[playerid][_name]);
			Dialog_Show(playerid,_LOGIN, DIALOG_STYLE_PASSWORD,"登录",string,"登录","取消");
		}
    }
    else Dialog_Show(playerid,_LOGIN, DIALOG_STYLE_PASSWORD,"登录","请输入密码登录","登录","取消");
	return 1;
}
Dialog:_REG(playerid, response, listitem, inputtext[])
{
    if(response)
    {
        if(strlen(inputtext)<4||strlen(inputtext)>10)return Dialog_Show(playerid,_REG,DIALOG_STYLE_PASSWORD, "字符错误", "你还没有注册,请输入密码注册", "注册", "退出");
		SHA256_PassHash(inputtext,"",pdate[playerid][_pass],128);
		format(pdate[playerid][_motto],256," ");
		pGang(playerid)=NOTHING;
		pdate[playerid][_choose]=0;
		SetReg(playerid,1);
		SetLoginState(playerid,1);
		orm_insert(pdate[playerid][_orm], "OnPlayerRegister", "i", playerid);
	}
    else Dialog_Show(playerid,_REG, DIALOG_STYLE_INPUT,"注册账户","你还没有注册账户,请输入密码来注册.","注册","取消");
    return 1;
}
PLC::OnPlayerRegister(playerid)
{
	Ban_OnPlayerCome(playerid);
    Info(playerid, "请选择要使用的角色");
    Info(playerid, "按下SPAWN出生！！");
	return 1;
}
stock PersonInfo(playerid)
{
	new body[1024],line[128];
	format(line, sizeof(line),"数据库ID:%i\n",pdate[playerid][_uid]);
	strcat(body,line);
	format(line,sizeof(line),"姓名:%s",pdate[playerid][_name]);
	strcat(body,line);
	format(line,sizeof(line),"管理等级:%i",pdate[playerid][_admin]);
	strcat(body,line);
	format(line,sizeof(line),"VIP等级:%i",VIP(playerid));
	strcat(body,line);
	format(line,sizeof(line),"游戏等级:%i [%i/%i]",pdate[playerid][_level],pdate[playerid][_exp]);
	strcat(body,line);
	format(line,sizeof(line),"现金:$%i",pdate[playerid][_cash]);
	strcat(body,line);
	format(line,sizeof(line),"存款:$%i",pdate[playerid][_bank]);
	strcat(body,line);
	format(line,sizeof(line),"安全钱包:$%i亿",pdate[playerid][_moneybag]);
	strcat(body,line);
	format(line,sizeof(line),"死亡数:$%i",pdate[playerid][_kill]);
	strcat(body,line);
	format(line,sizeof(line),"杀人数:$%i",pdate[playerid][_death]);
	strcat(body,line);
	if(Iter_Contains(gang,pGang(playerid)))
	{
		format(line,sizeof(line),"公司:%s [%s]",GetGangName(pGang(playerid)),GetGangRankName(pGang(playerid),pGangLevel(playerid)));
		strcat(body,line);
	}
	return body;
}
