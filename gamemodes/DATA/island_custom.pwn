new Iterator:island<MAX_ISLAND>;
enum i_sland
{
	ORM:_orm,
	_id,
 	_pid,
   	_name[80],
    Float:_x,
    Float:_y,
    Float:_z,
    _mapindex,
    Text3D:_text
};
new island[MAX_ISLAND][i_sland];
new Iterator:islandobject[MAX_ISLAND]<MAX_ISLAND_OBJ>;
enum i_s
{
    _oid
}
new islandobject[MAX_ISLAND][MAX_ISLAND_OBJ][i_s];

