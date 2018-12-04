new Iterator:mbox<MAX_MSG_BOX>;
enum m_box
{
	ORM:_orm,
	_id,
 	_pid,
   	_sender[80],
  	_msg[256],
    _cash,
    _qb,
    _read,
    _sendtime[40]
};
new mbox[MAX_MSG_BOX][m_box];

