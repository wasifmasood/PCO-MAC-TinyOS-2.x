/**
 * This application provides an interface to emit or detect
 * a continuous unmodulated carrier on platforms using the
 * CC2420 radio chip.
 * Please refer to CC2420 datasheet: 33 Transmitter Test Modes, page 54 
 *
 * @author	wasif.masood@aau.at, micha.rappaport@aau.at
 * @date	25.01.2013
 * @see		CC2420 data sheet
 */

#include "Timer.h"

module CC2420SingleCarrierP
{
	
	provides interface CC2420SingleCarrier;

	uses {
	
		interface Alarm<T32khz,uint32_t> as Countdown;
//		interface Counter<TMicro,uint32_t> as DelayCounter;	    

		interface LocalTime<T32khz> as LocalTime;

    interface Read<uint16_t> as Rssi;
    interface Resource;
    interface State as SingleCarrierState;

    interface CC2420Register as MDMCTRL1;
    interface CC2420Register as TXCTRL;

    interface CC2420Strobe as STXON;
    interface CC2420Strobe as SRXON;
    interface CC2420Strobe as STXCAL;
    interface CC2420Strobe as SRFOFF;
		interface CC2420Strobe as SNOP;

  	interface GeneralIO as CSN;
		interface GeneralIO as SFD;	

		interface Boot;

		interface DelayProctor<T32khz>;
	}
}

implementation
{
	uint32_t last_fired_ts, tx_delay, rec_time_stamp;	


	/*************** Global vars ***************/
	
	uint8_t STXON_status=0, m_tx_power;	

	enum {
		S_IDLE,
		S_PCO_RX,
		S_PCO_ACTIVE,
		S_PCO_TX,
	};

	
	/********************* Commands ******************************/
	

	async command error_t  CC2420SingleCarrier.setSFDTimeStamp(uint32_t ts){

		atomic {rec_time_stamp = call  LocalTime.get();}

	}


	async command uint32_t  CC2420SingleCarrier.getSFDTimeStamp(){
		return rec_time_stamp;
	}

	async command error_t CC2420SingleCarrier.emit(uint16_t usTime,uint8_t tx_power)	{

		if(!call Countdown.isRunning()){
								
			m_tx_power = tx_power;

			last_fired_ts = call LocalTime.get();

			// Request the tranceiver resource

			call SingleCarrierState.forceState(S_PCO_ACTIVE);

			return call Resource.request();

		}else

		return EBUSY;
	}


	async command void CC2420SingleCarrier.detect(uint32_t ts)	{

		call DelayProctor.holdProctor(PROCTOR_RX_DELAY);		

		signal CC2420SingleCarrier.SFDDetected(ts);
	}
	
	async command uint32_t CC2420SingleCarrier.getDelay(){
		return tx_delay;
	}


	async command bool CC2420SingleCarrier.getStatus(){
		return call SingleCarrierState.getState();
	}

	async command uint32_t CC2420SingleCarrier.getEnergy(uint8_t type){

		float time_elasped;
		float tx_power=0,rx_power=19.7;	//mA
		float time_ms=0, Energy_A;
		

		/* power spent in receive mode */
		if(type==PROCTOR_RX_DELAY){

			time_ms = (float)call DelayProctor.getProctor(PROCTOR_RX_DELAY)*32;					

			time_ms = time_ms/1000;	// time in millisecond
			
		}else{		/* power spent in transmit mode */
				
			if(0 <= CC2420_DEF_CHANNEL && CC2420_DEF_CHANNEL <= 7)	/*P=-25dBm=0.0032mW, I=8.5mA*/
				tx_power = 0.0032;
			else if(7 < CC2420_DEF_CHANNEL && CC2420_DEF_CHANNEL <= 14)	/*P=-15dBm=0.032mW , I=9.9*/
				tx_power = 0.032;
			else if(14 < CC2420_DEF_CHANNEL && CC2420_DEF_CHANNEL<= 21)	/*P=-10dBm=0.1mW, I=11 mA*/
				tx_power = 0.1;	
			else if(21 <= CC2420_DEF_CHANNEL && CC2420_DEF_CHANNEL<= 28)	/*P=-5dBm=0.32mW, I=14mA*/
				tx_power= 0.32;	
			else																		/*P=0dBm=1.0mW, I=17.4 mA*/
				tx_power = 1;	
						
			time_ms = (float)call DelayProctor.getProctor(PROCTOR_TX_DELAY)*32;					

			time_ms = time_ms/1000;		// time in millisecond
		}

		/* Energy (Amp) = Power (Watt) / time (s) */
		Energy_A = tx_power/time_ms;		// Energy is in Ampers

		return Energy_A;
	}

	/*************** Events ***************/
	
	async event void Countdown.fired(){
		uint16_t temp;
		atomic {
				if(	call SingleCarrierState.isState(S_PCO_TX) ){

					call SingleCarrierState.forceState(S_PCO_RX);

					//Power off transmitter
					//call SRFOFF.strobe();

					call STXCAL.strobe();

					// Reset registers

					call MDMCTRL1.write(0x500);

					call SRXON.strobe();

					call Resource.release();

					tx_delay = call LocalTime.get() - last_fired_ts;

					call DelayProctor.holdProctor(PROCTOR_TX_DELAY);

					//printf("SC:Done %lu\n", temp);printfflush();

	//				call DelayCounter.clearOverflow();

					signal CC2420SingleCarrier.emitDone(STXON_status, tx_delay);
				}
			}
	}
		

	event void Resource.granted(){

		atomic {
				if( call SingleCarrierState.isState(S_PCO_ACTIVE) ){
				// Set register values according to CC2420 datasheet (s. page 54)
//				call MDMCTRL1.write(0x50C);	// Modem control register 1: tx mode = 2: 0x0508, tx mode = 3: 0x050C (page 65)
//			    call DACTST.write(0x1800);	// DAC test register (page 79)
		
					

					if ( !m_tx_power ) {
						m_tx_power = CC2420_DEF_RFPOWER;
					}
				
					call CSN.clr();
				
					//if ( m_tx_power != tx_power ) {
						call TXCTRL.write( ( 2 << CC2420_TXCTRL_TXMIXBUF_CUR ) |
						                   ( 3 << CC2420_TXCTRL_PA_CURRENT ) |
						                   ( 1 << CC2420_TXCTRL_RESERVED ) |
						                   ( (m_tx_power & 0x1F) << CC2420_TXCTRL_PA_LEVEL ) );
					//}

					call MDMCTRL1.write(0x50C);	
			    
			    // Strobe to set transmission on
					call SingleCarrierState.forceState(S_PCO_TX);

//				printf("SC:sent, status:%d, SFD State:%d\n",status,call SFD.get());printfflush();

					call DelayProctor.setProctor(PROCTOR_TX_DELAY);		

			    STXON_status = call STXON.strobe();

    			if ( !( STXON_status & CC2420_STATUS_TX_ACTIVE ) ) {
			        STXON_status = call SNOP.strobe();        
			    }

					//printf("granted\n");printfflush();

					// Start alarm to turn of in txDuration jiffies
					call Countdown.start(15);
			}
		}
	}



//	async event void DelayCounter.overflow(){}
	
	event void Rssi.readDone(error_t result, uint16_t val)
	{
		signal CC2420SingleCarrier.detectDone(val >= 100);
	}


	event void Boot.booted(){		

		call SingleCarrierState.forceState(S_PCO_RX);
	}

/********************************************************************************/	

	default async event void CC2420SingleCarrier.emitDone(uint8_t status, uint32_t delay){
	}

	default async event void CC2420SingleCarrier.SFDDetected(uint32_t ts32){		
	}	

	default async event void CC2420SingleCarrier.detectDone(bool detection){
	}
}













