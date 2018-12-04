PLC::OnIslandLoad()
{
    forex(r,cache_num_rows())
	{
		new ORM:ormid = island[r][_orm] = orm_create(SQL_ISLAND_DATABASE);
		orm_addvar_int(ormid, island[r][_id], "ID");
		orm_addvar_int(ormid, island[r][_pid],"PID");
		orm_addvar_string(ormid, island[r][_name],256,"NAME");
		orm_addvar_float(ormid, island[r][_x],"X");
		orm_addvar_float(ormid, island[r][_y],"Y");
		orm_addvar_float(ormid, island[r][_z],"Z");
		orm_addvar_int(ormid, island[r][_mapindex],"MAPINDEX");
		orm_apply_cache(ormid, r);
		orm_setkey(ormid,"ID");
		Iter_Add(island,r);
		CreatIsLandObject(r,island[r][_mapindex]);
	}
	return 1;
}
PLC::AddIsLand(playerid,Float:x,Float:y,Float:z,index,name[])
{
    if(Iter_Free(island) == -1) return 0;
    new r = Iter_Free(island);
    format(island[r][_name],80,name);
    island[r][_x]=x;
    island[r][_y]=y;
    island[r][_z]=z;
    island[r][_mapindex]=index;
    island[r][_pid]=pdate[playerid][_uid];
    
	new ORM:ormid = island[r][_orm] = orm_create(SQL_ISLAND_DATABASE);
	orm_addvar_int(ormid, island[r][_id], "ID");
	orm_addvar_int(ormid, island[r][_pid],"PID");
	orm_addvar_string(ormid, island[r][_name],256,"NAME");
	orm_addvar_float(ormid, island[r][_x],"X");
	orm_addvar_float(ormid, island[r][_y],"Y");
	orm_addvar_float(ormid, island[r][_z],"Z");
	orm_addvar_int(ormid, island[r][_mapindex],"MAPINDEX");
	if(!CreatIsLandObject(r,island[r][_mapindex]))return 0;
	orm_insert(ormid,"IsLand_Create","ii",playerid,r);
	return 1;
}
PLC::IsLand_Delete(landid)
{
	if(!Iter_Contains(island,landid))return 0;
    orm_delete(island[landid][_orm],true);
    DestroyDynamic3DTextLabel(island[landid][_text]);
    DestroyIsLandObject(landid);
    orm_delete(island[landid][_orm],true);
    Iter_Remove(island,landid);
	return 1;
}
PLC::IsLand_Create(playerid,landid)
{
	Iter_Add(island,landid);
	orm_setkey(island[landid][_orm],"ID");
	new line[128];
	format(line,sizeof(line),""CHAT_YELLOW"[建筑] 你成功创建了建筑 %s",island[landid][_name]);
	SCM(playerid,line);
	return 1;
}
PLC::CreatIsLandObject(landid,index)
{
	if(!obj[index][_center])return 0;
	new line[64];
	format(line,sizeof(line),"建筑ID:%i\n%s",landid,island[landid][_name]);
	island[landid][_text]=CreateDynamic3DTextLabel(line,-1,island[landid][_x],island[landid][_y],island[landid][_z],200);
	if(island[landid][_z]==0)island[landid][_z]=1;
	new Float:x,Float:y,Float:z;
	foreach(new i:objects[index])
	{
	    x=floatadd(floatsub(objects[index][i][_x],obj[index][_centerx]),island[landid][_x]);
	    y=floatadd(floatsub(objects[index][i][_y],obj[index][_centery]),island[landid][_y]);
	    z=floatadd(floatsub(objects[index][i][_z],obj[index][_centerz]),island[landid][_z]);
	    islandobject[landid][i][_oid]=CreateDynamicObject(objects[index][i][_model],x,y,z,objects[index][i][_rx],objects[index][i][_ry],objects[index][i][_rz]);
		SetDynamicObjectMaterial(islandobject[landid][i][_oid],objects[index][i][_mindex], objects[index][i][_modelid],objects[index][i][_txdname]\
		,objects[index][i][_texturename],objects[index][i][_materialcolor]);
		Iter_Add(islandobject[landid],i);
	}
	return 1;
}
PLC::DestroyIsLandObject(landid)
{
	foreach(new i:islandobject[landid])DestroyDynamicObject(islandobject[landid][i][_oid]);
	Iter_Clear(islandobject[landid]);
	return 1;
}

