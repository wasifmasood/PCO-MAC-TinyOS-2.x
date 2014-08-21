
/**
 *
 * @author Wasif Masood
 * Aug 13,2010
 */

interface DelayProctor<precision_tag> {

	async command error_t setProctor(uint8_t Id);

	async command error_t resetProctor(uint8_t Id);

	async command error_t holdProctor(uint8_t id);

	async command uint32_t getProctor(uint8_t Id);

	async command error_t getStatus(uint8_t id);

	async command uint32_t getLocalTime();

	async command error_t clearProctor(uint8_t id);
}
