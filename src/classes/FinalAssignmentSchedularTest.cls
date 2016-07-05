/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class FinalAssignmentSchedularTest {
    
    
    static testMethod void myUnitTest1() {
        User user = new User(
            Username 			= 'hasantha@gmail.com', 
            email				= 'hasanthaera@gmail.com',
            LastName 			= 'Liyanage', 
            Alias				= 'Liyan', 
            TimeZoneSidKey		= 'GMT', 
            LocaleSidKey		= 'en_US', 
            EmailEncodingKey 	= 'ISO-8859-1', 
            ProfileId			= '00e900000018nPi',
            LanguageLocaleKey	= 'en_US' 
        );
        string jobId = '';
       
        System.runAs(user){
            String minuteString = System.now().addMinutes(1).minute().format();
            Schedulable sch = new FinalAssignmentSchedularPro();
            //String cron = '05 '+ minuteString + ' * * * ?';
            
            String hour = String.valueOf(Datetime.now().hour());
            String min = String.valueOf(Datetime.now().minute()); 
            String ss = String.valueOf(Datetime.now().second());
            
            //parse to cron expression
            String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
            
            //MyScheduledJob s = new MyScheduledJob(); System.schedule('Job Started At ' + String.valueOf(Datetime.now()), nextFireTime, ss);
            
            Test.StartTest();
            
            // Schedule the test job 
            
            jobId = System.schedule('FinalAssignmentSchedularPro', nextFireTime, sch);
            
            // Get the information from the CronTrigger API object
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            // Verify the expressions are the same
            //System.assertEquals(cron, ct.CronExpression);
            
            // Verify the job has not run
            System.assertEquals(0, ct.TimesTriggered);
            
            // Verify when the job will run
            System.debug('next fire time = '+ ct.NextFireTime.date() + ', '+ ct.NextFireTime.hour() +', '+ ct.NextFireTime.minute());

           // CronTrigger ct2 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, PreviousFireTime, EndTime, State FROM CronTrigger WHERE id = :jobId];
           
            ///if(ct2.TimesTriggered >0 && ct2.State == 'Completed'){
              //  System.debug('previous fire time = '+ ct2.NextFireTime.date() + ', End Time '+ ct2.EndTime +', State = '+ ct2.State + ' times triggered = ' + ct2.TimesTriggered );
                
            //}//end for loop
            
            Test.StopTest();
            
            // *** How does one know that a batch has completed? ***
            // query for completion
            // Verify the next time the job will run
            
            CronTrigger ct2 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, PreviousFireTime, EndTime, State FROM CronTrigger WHERE id = :jobId];
             System.debug('previous fire time = '+ ct2.NextFireTime.date() + ', End Time '+ ct2.EndTime +', State = '+ ct2.State + ' times triggered = ' + ct2.TimesTriggered );
            
            
            if(ct2.TimesTriggered >0 && ct2.State == 'Completed'){
                System.debug('previous fire time = '+ ct2.NextFireTime.date() + ', End Time '+ ct2.EndTime +', State = '+ ct2.State + ' times triggered = ' + ct2.TimesTriggered );
                
            }//end for loop
            
        }//end runAs
    }//end method
    
	/*
	 * test method
	 */
    static testMethod void myUnitTest() {
      
		DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
		if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        
        Test.startTest();
        
			FinalAssignmentSchedularPro obj = new FinalAssignmentSchedularPro();                
			String jobId = system.schedule('test', sch, obj);        
	        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger where id = :jobId];        
	        System.assertEquals(sch, ct.CronExpression);                                      
	        	
        Test.stopTest();
    }
}