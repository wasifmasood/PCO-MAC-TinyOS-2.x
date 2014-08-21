/**
 * This application provides an interface to emit or detect
 * a continuous unmodulated carrier on platforms using the
 * CC2420 radio chip.
 * Please refer to CC2420 data sheet: 33 Transmitter Test Modes, page 54 
 *
 * @author	wasif.masood@aau.at, micha.rappaport@aau.at
 * @date	25.01.2013
 * @see		CC2420 data sheet
 */

#include "CC2420.h"



configuration CC2420SingleCarrierC
{

	provides interface CC2420SingleCarrier;
  provides interface State as SingleCarrierState;	

}

implementation
{

	components  new StateC() as PCOStateC; 
	SingleCarrierState = PCOStateC;

	components CC2420SingleCarrierP as App;
	CC2420SingleCarrier = App;

	components MainC;
	App.Boot -> MainC;

	components	new Alarm32khz32C() as Al;
	App.Countdown -> Al;

	components new CC2420SpiC() as Spi;
	App.MDMCTRL1 -> Spi.MDMCTRL1;
  App.TXCTRL -> Spi.TXCTRL; 
	App.STXON -> Spi.STXON;
	App.SRXON -> Spi.SRXON;
	App.STXCAL -> Spi.STXCAL;
	App.SRFOFF -> Spi.SRFOFF;
	App.SNOP -> Spi.SNOP;


	components HplCC2420PinsC as Pins;
	App.CSN -> Pins.CSN;
	App.SFD -> Pins.SFD;
	
	components CC2420ControlC;
	App.Rssi -> CC2420ControlC.ReadRssi;
	App.Resource -> CC2420ControlC.Resource;
  
//	components CounterMicro32C;
//	App.DelayCounter -> CounterMicro32C;


	App.SingleCarrierState ->  PCOStateC;
		
/*	components LocalTimeMicroC;
	App.LocalTimeMicro -> LocalTimeMicroC;	*/

	components Counter32khz32C, new CounterToLocalTimeC(T32khz) as LocalTime32khzC;
	LocalTime32khzC.Counter -> Counter32khz32C;
	App.LocalTime     -> LocalTime32khzC;

	components DelayProctorC;	
	App.DelayProctor -> DelayProctorC;


/*
	components CounterMicro32C, new CounterToLocalTimeC(TMicro) as LocalTimeMicroC;
	LocalTimeMicroC.Counter -> CounterMicro32C;
	App.LocalTimeMicro     -> LocalTimeMicroC;

/*
	components Msp430Counter32khzC,new CounterToLocalTimeC(T32khz) as LocalTimeMicroC;
	LocalTimeMicroC.Counter -> Msp430Counter32khzC;
	App.LocalTimeMicro     -> LocalTimeMicroC;*/

}




















