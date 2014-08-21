


#ifndef DELAYPROCTOR_H
#define DELAYPROCTOR_H


#ifndef PROCTOR_TABLE_SIZE
#define PROCTOR_TABLE_SIZE 10
#endif

typedef struct proctor_entry{
	uint8_t status;
	uint32_t start_time;
	uint32_t end_time;
}proctor_entry_t;


enum {
	PROCTOR_FREE=0,	
	PROCTOR_HOLDING=1,
	PROCTOR_STARTED=2,
	PROCTOR_END=3,
	PROCTOR_SUCCESS=4,
	PROCTOR_ERROR=-1	
};

#endif





