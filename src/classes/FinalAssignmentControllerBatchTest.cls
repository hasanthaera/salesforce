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
private class FinalAssignmentControllerBatchTest {
	
	/*
	 * test method
	 */
    static testMethod void myUnitTest() {
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
		
        // Data manipulation
        List<FABarcode__c> barcodes = new List<FABarcode__c>{};

 		FAEmployee__c employee = new FAEmployee__c(Employee_Name__c = 'Hasantha Liyanage_1',BIR__c = '1', IPN__c='1',  Country__c ='US',  City__c = 'New york');
 		insert employee;  
 		
		//Inserting new FABarcode__c(s)
	    for(Integer i = 0; i < 11; i++){
	        FABarcode__c bc = new FABarcode__c(Name = 'Barcode '+employee.id ,FAEmployeeBC__c = employee.id, Barcodes__c = '123987'+i, Start_Barcode__c = false);
	        barcodes.add(bc);
	    }
	    
 		insert barcodes;
 		System.runAs(user){
	 		Test.startTest();
			
				Database.executeBatch(new FinalAssignmentControllerBatch(),200);
													  	  
			Test.stopTest();
	 											  	  
			list<FABarcode__c> UpdatedCodes	=	[ SELECT Start_Barcode__c 
													  	  FROM FABarcode__c ];
													  	  
			for(FABarcode__c bar:UpdatedCodes) {
				 system.assertEquals(bar.Start_Barcode__c, true);
			}
		}	
    }
}