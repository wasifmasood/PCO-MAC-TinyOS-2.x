


#ifndef SERIALLOGGER_H
#define SERIALLOGGER_H


enum {
	
/*	Radio Messages*/
  AM_RADIO_SIGNAL_MSG = 0x94,
  AM_RADIO_SYNC_SIGNAL_MSG = 0x96,

/*	Serial Messages*/
	AM_PCO_STACK_SYNC_LOG_MSG = 0x91,
//	AM_PCKT_LOG_MSG = 0x92,
	AM_DEBUG_LOG_MSG = 0x93,
	AM_LOG_PCO_SYNC_PREC_MSG = 0x95,

	PROCTOR_TX_DELAY=0,
	PROCTOR_RX_DELAY=1,
};



/*Radio Messages*/
typedef nx_struct radio_signal_msg {
  nx_uint32_t timeleft;
  nx_uint8_t tx_power;
} radio_signal_msg_t;

typedef nx_struct radio_sync_signal_msg{
	nx_uint32_t sync_signals_sent;
}radio_sync_signal_msg_t;

#endif





