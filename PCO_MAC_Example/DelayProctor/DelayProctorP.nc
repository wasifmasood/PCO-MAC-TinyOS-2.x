

/**
 * @author Wasif Masood 
 * @Created: Sept 10, 2012
 */

#include "DelayProctor.h"


module DelayProctorP{
	
	provides interface DelayProctor<T32khz> as DelayProctorT32khz;
	provides interface DelayProctor<TMicro> as DelayProctorTMicro;
	provides interface DelayProctor<TMilli> as DelayProctorTMilli;

	uses interface LocalTime<T32khz> as LocalTime32khz;
  uses interface LocalTime<TMilli> as LocalTimeMilli;
  uses interface LocalTime<TMicro> as LocalTimeTMicro;
}

implementation {


	proctor_entry_t proctor_entry_table[PROCTOR_TABLE_SIZE];

/*----------------- DelayProctorTMicro -----------------*/

	async command uint32_t DelayProctorTMicro.getLocalTime()
    {
        return call LocalTimeTMicro.get();
    }

	async command error_t DelayProctorTMicro.setProctor(uint8_t id){

		if(id>PROCTOR_TABLE_SIZE-1){
			proctor_entry_table[id].status=PROCTOR_FREE;
			return PROCTOR_ERROR;
		}
		
		if(proctor_entry_table[id].status!=PROCTOR_FREE)
			return PROCTOR_ERROR;

		proctor_entry_table[id].start_time = call LocalTimeTMicro.get();

		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_STARTED;

		return SUCCESS;
	}

	async command error_t DelayProctorTMicro.resetProctor(uint8_t id){

		proctor_entry_table[id].start_time = call LocalTimeTMicro.get();

		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_STARTED;

		return PROCTOR_SUCCESS;
	}

	async command error_t DelayProctorTMicro.getStatus(uint8_t id){

		if(id>PROCTOR_TABLE_SIZE-1)
			return -1;
	
		return proctor_entry_table[id].status;
	}	

	async command uint32_t DelayProctorTMicro.getProctor(uint8_t id){

		uint32_t temp;	

		if(proctor_entry_table[id].status!=PROCTOR_HOLDING)
			return PROCTOR_ERROR;
	
		temp = proctor_entry_table[id].end_time - proctor_entry_table[id].start_time;

		proctor_entry_table[id].start_time = 0;
		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_FREE;

		return temp;
	}

	async command error_t DelayProctorTMicro.holdProctor(uint8_t id){
		
		if(id>PROCTOR_TABLE_SIZE-1)	
			return PROCTOR_ERROR;
	
		if(proctor_entry_table[id].status!=PROCTOR_STARTED)
			return PROCTOR_ERROR;

		proctor_entry_table[id].status=PROCTOR_HOLDING;

		proctor_entry_table[id].end_time = call LocalTimeTMicro.get();

		return PROCTOR_SUCCESS;
	}

	async command error_t DelayProctorTMicro.clearProctor(uint8_t id){
		
		if(id>PROCTOR_TABLE_SIZE-1)	
			return PROCTOR_ERROR;			

		proctor_entry_table[id].start_time = 0;

		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_FREE;

		return PROCTOR_SUCCESS;
	}

/*----------------- DelayProctorT32KHz -----------------*/

	async command uint32_t DelayProctorT32khz.getLocalTime(){
        return call LocalTime32khz.get();
    }

	async command error_t DelayProctorT32khz.setProctor(uint8_t id){

		if(id>PROCTOR_TABLE_SIZE-1){
			proctor_entry_table[id].status=PROCTOR_FREE;
			return PROCTOR_ERROR;
		}
		
		if(proctor_entry_table[id].status!=PROCTOR_FREE)
			return PROCTOR_ERROR;

		proctor_entry_table[id].start_time = call LocalTime32khz.get();

		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_STARTED;

		return PROCTOR_SUCCESS;
	}

	async command error_t DelayProctorT32khz.getStatus(uint8_t id){

		if(id>PROCTOR_TABLE_SIZE-1)
			return PROCTOR_ERROR;
	
		return proctor_entry_table[id].status;
	}	

	async command error_t DelayProctorT32khz.resetProctor(uint8_t id){

		proctor_entry_table[id].start_time = call LocalTime32khz.get();

		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_STARTED;

		return PROCTOR_SUCCESS;
	}

	async command uint32_t DelayProctorT32khz.getProctor(uint8_t id){

		uint32_t temp;			

		if(id>PROCTOR_TABLE_SIZE-1)
			return PROCTOR_ERROR;

/*	
		if(proctor_entry_table[id].status!=PROCTOR_HOLDING)
			return PROCTOR_ERROR;		*/

		call DelayProctorT32khz.holdProctor(id);

		temp = proctor_entry_table[id].end_time - proctor_entry_table[id].start_time;

		proctor_entry_table[id].start_time = 0;

		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status = PROCTOR_FREE;

		return temp;
	}

	async command error_t DelayProctorT32khz.holdProctor(uint8_t id){
		
		if(id > PROCTOR_TABLE_SIZE-1)	
			return PROCTOR_ERROR;
	
		if(proctor_entry_table[id].status != PROCTOR_STARTED)
			return PROCTOR_ERROR;

		if(proctor_entry_table[id].status == PROCTOR_HOLDING)
			return PROCTOR_SUCCESS;

		proctor_entry_table[id].end_time = call LocalTime32khz.get();

		proctor_entry_table[id].status=PROCTOR_HOLDING;

		return PROCTOR_SUCCESS;
	}

	async command error_t DelayProctorT32khz.clearProctor(uint8_t id){

		if(id>PROCTOR_TABLE_SIZE-1)	
			return PROCTOR_ERROR;			

		proctor_entry_table[id].start_time = 0;

		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_FREE;

		return PROCTOR_SUCCESS;
	}	

/*----------------- DelayProctorTMilli -----------------*/

	async command uint32_t DelayProctorTMilli.getLocalTime()
    {
        return call LocalTimeMilli.get();
    }

	async command error_t DelayProctorTMilli.setProctor(uint8_t id){

		if(id>PROCTOR_TABLE_SIZE-1){
			proctor_entry_table[id].status=PROCTOR_FREE;
			return PROCTOR_ERROR;
		}
		
		if(proctor_entry_table[id].status!=PROCTOR_FREE)
			return PROCTOR_ERROR;

		proctor_entry_table[id].start_time = call LocalTimeMilli.get();

		proctor_entry_table[id].end_time = 0;
	
		proctor_entry_table[id].status=PROCTOR_STARTED;

		return PROCTOR_SUCCESS;
	}

	async command error_t DelayProctorTMilli.resetProctor(uint8_t id){

		proctor_entry_table[id].start_time = call LocalTime32khz.get();

		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_STARTED;

		return PROCTOR_SUCCESS;
	}


	async command error_t DelayProctorTMilli.getStatus(uint8_t id){

		if(id>PROCTOR_TABLE_SIZE-1)
			return -1;
	
		return proctor_entry_table[id].status;
	}	

	async command uint32_t DelayProctorTMilli.getProctor(uint8_t id){

		uint32_t temp;	
	
		if(proctor_entry_table[id].status!=PROCTOR_HOLDING)
			return PROCTOR_ERROR;

		temp = proctor_entry_table[id].end_time - proctor_entry_table[id].start_time;

		proctor_entry_table[id].start_time = 0;
		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_FREE;
		return temp;
	}

	async command error_t DelayProctorTMilli.holdProctor(uint8_t id){
		
		if(id>PROCTOR_TABLE_SIZE-1)	
			return PROCTOR_ERROR;
	
		if(proctor_entry_table[id].status!=PROCTOR_STARTED)
			return PROCTOR_ERROR;

		proctor_entry_table[id].end_time = call LocalTimeMilli.get();
		proctor_entry_table[id].status=PROCTOR_HOLDING;

		return PROCTOR_SUCCESS;
	}

	async command error_t DelayProctorTMilli.clearProctor(uint8_t id){

		
		if(id>PROCTOR_TABLE_SIZE-1)	
			return PROCTOR_ERROR;			

		proctor_entry_table[id].start_time = 0;

		proctor_entry_table[id].end_time = 0;

		proctor_entry_table[id].status=PROCTOR_FREE;

		return PROCTOR_SUCCESS;
	}	


/*******************************************************/
}





















































