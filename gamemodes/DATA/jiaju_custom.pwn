new Iterator:jj<MAX_JJ>;
enum jj_info
{
	ORM:_orm,
	Text3D:_jtext,
	_area,
	_jid,
	_id,
	_objectid,
	_name[80],
   	_createtime[40],
    Float:_x,
    Float:_y,
    Float:_z,
    Float:_rx,
    Float:_ry,
    Float:_rz,
    _interior,
    _world,
	_index,
	_modelid,
	_txdid,
	_colorid,
	_sizeid,
	_fontid,
	_fontsize,
	_bold,
	_fontcolorid,
	_backcolorid,
	_textalignment,
	_text[2048],
	_join,
	_limit,
	_state
};
new jj[MAX_JJ][jj_info];
new Puj[MAX_PLAYERS];
new Carry[MAX_PLAYERS];
enum sizeEnum
{
    fsize,
    fsizes[64]
}
new TextSizes[][sizeEnum] = {
{OBJECT_MATERIAL_SIZE_32x32,"32x32"},
{OBJECT_MATERIAL_SIZE_64x32,"64x32"},
{OBJECT_MATERIAL_SIZE_64x64,"64x64"},
{OBJECT_MATERIAL_SIZE_128x32,"128x32"},
{OBJECT_MATERIAL_SIZE_128x64,"128x64"},
{OBJECT_MATERIAL_SIZE_128x128,"128x128"},
{OBJECT_MATERIAL_SIZE_256x32,"256x32"},
{OBJECT_MATERIAL_SIZE_256x64,"256x64"},
{OBJECT_MATERIAL_SIZE_256x128,"256x128"},
{OBJECT_MATERIAL_SIZE_256x256,"256x256"},
{OBJECT_MATERIAL_SIZE_512x64,"512x64"},
{OBJECT_MATERIAL_SIZE_512x128,"512x128"},
{OBJECT_MATERIAL_SIZE_512x256,"512x256"},
{OBJECT_MATERIAL_SIZE_512x512,"512x512"}
};
new const g_Fonts[][] =
{
	"Arial","ºÚÌå","ËÎÌå","Arial Black", "Calibri", "Cambria", "Cambria Math", "Candara",
	"Comic Sans MS", "Consolas", "Constantia", "Corbel", "Courier",
	"Courier New", "Fixedsys", "Franklin Gothic Medium", "Gabriola", "Georgia",
	"GTAWEAPON3", "Impact", "Lucida Console", "Lucida Sans Unicode",
	"Microsoft Sans Serif", "Modern", "MS Sans Serif", "MS Serif",
	"Palatino Linotype", "Roman", "SampAux3", "Script", "Segoe Print",
	"Segoe Script", "Segoe UI", "Segoe UI Light", "Segoe UI Semibold",
	"Segoe UI Symbol", "Small Fonts", "Symbol", "System", "Tahoma", "Terminal",
	"Times New Roman", "Trebuchet MS", "Webdings", "Verdana", "Wingdings"
};
