/**
 * This application provides an interface to emit or detect
 * a continuous unmodulated carrier on platforms using the
 * CC2420 radio chip.
 * Please refer to CC2420 datasheet: 33 Transmitter Test Modes, page 54 
 *
 * @author	micha.rappaport@aau.at, wasif.masood@aau.at
 * @date	25.01.2013
 * @see		CC2420 data sheet
 */

interface CC2420SingleCarrier
{
	/**
	 *
	 */
	async command error_t emit(uint16_t jiffies, uint8_t tx_power);
	
	/**
	 *
	 */
	async command void detect(uint32_t ts);

	/**
	 *
	 */
	async  command uint32_t getDelay();

	/**
	 *
	 */	
	async command bool getStatus();

	/**
	 *
	 */
	async event void detectDone(bool detection);
	
	/**
	 *
	 */
	async event void emitDone(uint8_t status, uint32_t tx_delay);

	/**
	 *
	 */
	async event void SFDDetected(uint32_t ts32);
	/**
	 *
	 */
	async command uint32_t getEnergy(uint8_t type);
	/**
	 *
	 */
	async command error_t setSFDTimeStamp(uint32_t ts);
	/**
	 *
	 */
	async command uint32_t getSFDTimeStamp();
	
}







