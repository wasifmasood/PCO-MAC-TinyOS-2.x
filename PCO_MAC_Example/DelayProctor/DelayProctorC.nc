
/**
 *
 @ author Wasif Masood
 @ Created: Sept 10, 2012
 */


configuration DelayProctorC {

	provides interface DelayProctor<T32khz> as DelayProctorT32khz;
	provides interface DelayProctor<TMicro> as DelayProctorTMicro;

}

implementation {
	
	components DelayProctorP as Imp;
	DelayProctorT32khz = Imp;
	DelayProctorTMicro = Imp;


	components  LocalTimeMicroC;
	Imp.LocalTimeTMicro -> LocalTimeMicroC;
		
	components LocalTimeMilliC;
	Imp.LocalTimeMilli -> LocalTimeMilliC;


	components  LocalTime32khzC;
	Imp.LocalTime32khz -> LocalTime32khzC;

	
}









