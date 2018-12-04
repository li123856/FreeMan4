#define MAP_FILES   "房子模板/%i.pwn"
#define GOBAL_FILES   "全局模型/%i.pwn"
#define No_Object 0
#define Dynamic_Object 1
#define General_Object 2
#define Object_Center  3
#define Addex_Vehicle  4
#define Add_Vehicle    5
#define Create_Vehicle 6
#define MAX_OBJECT_INDEX 100
#define MAX_OBJECT_NUMBER 2000
new Iterator:objects[MAX_OBJECT_INDEX]<MAX_OBJECT_NUMBER>;
new Iterator:obj<MAX_OBJECT_INDEX>;
enum o_bj
{
	_center,
	Float:_centerx,
	Float:_centery,
	Float:_centerz
}
new obj[MAX_OBJECT_INDEX][o_bj];
enum o_date
{
	_model,
	Float:_x,
	Float:_y,
	Float:_z,
	Float:_rx,
	Float:_ry,
	Float:_rz,
	_mindex,
	_modelid,
	_txdname[64],
	_texturename[64],
	_materialcolor
}
new objects[MAX_OBJECT_INDEX][MAX_OBJECT_NUMBER][o_date];

PLC::ObJLoader_Array_OnGameModeInit()
{
	Iter_Init(objects);
	return 1;
}
PLC::LoadAllObjectFiles()
{
    forex(i,MAX_OBJECT_INDEX)
	{
		LoadObjectsFrom(i);
		LoadGobalDynamicObjects(i);
	}
    return 1;
}
PLC::LoadObjectsFrom(idx)
{
	new line[60];
    format(line, sizeof(line),MAP_FILES,idx);
    if(!fexist(line))return 1;
	new count = GetTickCount();
    new string[1024],index,var_from_line[64],loaded,type;
    new File:example = fopen(line, io_read);
    if(!example)return printf("打开出错: %s",line);
	Iter_Add(obj,idx);
    while(fread(example, string) > 0)
    {
        type=IsObjectCode(string);
        switch(type)
        {
            case Dynamic_Object,General_Object:
            {
				if(ClearLine(string,type))
				{
					index = 0;
	                index = token_by_delim(string,var_from_line,',',index); objects[idx][loaded][_model] = strval(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_x] = floatstr(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_y] = floatstr(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_z] = floatstr(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_rx] = floatstr(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_ry] = floatstr(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_rz] = floatstr(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_mindex] = strval(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_modelid] = strval(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_txdname] = var_from_line;
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_texturename] = var_from_line;
	                index = token_by_delim(string,var_from_line,',',index+1); objects[idx][loaded][_materialcolor] = strval(var_from_line);
                    Iter_Add(objects[idx],loaded);
					loaded++;
	             }
			}
			case Object_Center:
			{
			    if(ClearLine(string,type))
			    {
			    	obj[idx][_center]=1;
			    	index = 0;
	                index = token_by_delim(string,var_from_line,',',index); obj[idx][_centerx] = floatstr(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); obj[idx][_centery] = floatstr(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); obj[idx][_centerz] = floatstr(var_from_line);
				}
			}
		}
	}
    fclose(example);
    return printf("读取[%s] %d条 模组数据. 使用 %d 毫秒.",line,loaded,(GetTickCount()-count));
}
stock ClearLine(line[],type)
{
	switch(type)
	{
	    case Dynamic_Object:strdel(line, 0, 20);
	    case General_Object:strdel(line, 0, 13);
	    case Object_Center:strdel(line, 0, 7);
	    case Addex_Vehicle:strdel(line, 0, 19);
   	    case Add_Vehicle:strdel(line, 0, 17);
   	    case Create_Vehicle:strdel(line, 0, 14);
	}
    return 1;
}
PLC::IsObjectCode(line[])
{
	if(strfind(line, "CreateDynamicObject", false) != -1)return Dynamic_Object;
    if(strfind(line, "CreateObject", false) != -1)return General_Object;
    if(strfind(line, "Center", false) != -1)return Object_Center;
    if(strfind(line, "AddStaticVehicleEx", false) != -1)return Addex_Vehicle;
    if(strfind(line, "AddStaticVehicle", false) != -1)return Add_Vehicle;
    if(strfind(line, "CreateVehicle", false) != -1)return Create_Vehicle;
    return No_Object;
}

PLC::LoadGobalDynamicObjects(idx)
{
    new line[60];
    format(line, sizeof(line),GOBAL_FILES,idx);
    if(!fexist(line))return 1;
    new count = GetTickCount();
    new string[512],objectid,Float:pos[6],index,var_from_line[64],loaded,ins,mod,txdname[64],texturename[64],materialcolor,lines[32];
    new File:example = fopen(line, io_read);
    if(!example)return printf("打开出错: %s",line);
	while(fread(example, string) > 0)
	{
	    new type=IsObjectCode(string);
	    switch(type)
	    {
	        case Dynamic_Object,General_Object:
	        {
				if(ClearLine(string,type))
				{
     				index = 0;
     				index = token_by_delim(string,var_from_line,',',index); objectid = strval(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[0] = floatstr(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[1] = floatstr(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[2] = floatstr(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[3] = floatstr(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[4] = floatstr(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[5] = floatstr(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); ins = strval(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); mod = strval(var_from_line);
	                index = token_by_delim(string,var_from_line,',',index+1); txdname = var_from_line;
	                index = token_by_delim(string,var_from_line,',',index+1); texturename = var_from_line;
	                index = token_by_delim(string,var_from_line,',',index+1); materialcolor = strval(var_from_line);
	                SetDynamicObjectMaterial(CreateDynamicObject(objectid,pos[0],pos[1],pos[2],pos[3],pos[4],pos[5]),ins, mod,txdname,texturename,materialcolor);
     				loaded++;
 				}
         	}
	        case Addex_Vehicle,Add_Vehicle,Create_Vehicle:
	        {
				if(ClearLine(string,type))
				{
    				index = 0;
     				index = token_by_delim(string,var_from_line,',',index); objectid = strval(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[0] = floatstr(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[1] = floatstr(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[2] = floatstr(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); pos[3] = floatstr(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); mod = strval(var_from_line);
     				index = token_by_delim(string,var_from_line,',',index+1); materialcolor = strval(var_from_line);
     				new carid=AddStaticVehicleEx(objectid,pos[0],pos[1],pos[2],pos[3],mod,materialcolor,99999999);
     				format(lines, sizeof(lines),"ID:%i",carid);
     				CreateDynamic3DTextLabel(lines,-1,0,0,0,20,INVALID_PLAYER_ID,carid);
                    loaded++;
                }
	        }
		}
    }
	fclose(example);
    return printf("读取[%s] %d条 全局模组数据. 使用 %d 毫秒.",line,loaded,(GetTickCount()-count));
}


