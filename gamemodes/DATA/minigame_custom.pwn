new Iterator:game<MAX_MINIGAME>;
enum g_ame
{
	_type,
	_name[80],
	_pid,
	_mapid,
	_state,
	_count,
	_vehmodel
};
new game[MAX_MINIGAME][g_ame];
new Iterator:gmap<MAX_MINIGAME_MAP>;
enum g_map
{
	ORM:_orm,
	_id,
	_rate,
	_name[80],
	Float:_x[2],
	Float:_y[2],
	Float:_z[2],
	_interior,
	_skin[2],
	_weapon[12]
};
new gmap[MAX_MINIGAME_MAP][g_map];
new pgame[MAX_PLAYERS];
new pgame_team[MAX_PLAYERS];
new pgame_veh[MAX_PLAYERS];

#define GetPlayerGameIn(%0) pgame[%0]
#define GameMap(%0) game[%0][_mapid]
#define PlayerTeam(%0) pgame_team[%0]
enum tmanes
{
	_name[24],
	_hex
};
new team_name[][tmanes] =
{
	{"{FF0000}ºì¶Ó",0xFF183FFF},
	{"{0092D6}À¶¶Ó",0x0092D6FF}
};

