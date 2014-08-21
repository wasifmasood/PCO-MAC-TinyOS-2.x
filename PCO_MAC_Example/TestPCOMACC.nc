

/**
 *
 @ author Wasif Masood
 @ Created: Sept 10, 2012
 */
 

#define NEW_PRINTF_SEMANTICS
#include "printf.h"

configuration TestPCOMACC { 

	

}
implementation {

	components TestPCOMACP; 
	

	components MainC;
	TestPCOMACP.Boot -> MainC;

	components CC2420SingleCarrierC;
	TestPCOMACP.PCOMAC ->CC2420SingleCarrierC;

	components new Alarm32khz32C() as Alarm32C;
	TestPCOMACP.GPIOAlarm -> Alarm32C;
	

	components ActiveMessageC;
	TestPCOMACP.RadioControl -> ActiveMessageC;
	TestPCOMACP.AMPacket -> ActiveMessageC;

	components PrintfC;
	components SerialStartC;

	components RandomC, LedsC;
	TestPCOMACP.Random -> RandomC;
	TestPCOMACP.Leds -> LedsC;


}































