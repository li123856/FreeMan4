new Iterator:tele<MAX_TELE>;
enum t_ele
{
	ORM:_orm,
	_id,
	_cmd[40],
 	_name[80],
   	_createtime[40],
  	_pid,
    Float:_x,
    Float:_y,
    Float:_z,
    Float:_a,
    _interior,
    _world,
    _cost,
    _moneybox,
    _rate,
    Float:_range1,
    Float:_range2
};
new tele[MAX_TELE][t_ele];
