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
private class FinalAssignmentControllerTest {
 
	/*
	 * test method
	 */
    static testMethod void myUnitTest() {
    	//create user 
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

 		FAEmployee__c employee = new FAEmployee__c(
 			Employee_Name__c 	= 'Hasantha Liyanage_11',
 			BIR__c 				= '1', 
 			IPN__c				= '1',  
 			Country__c 			= 'US',  
 			City__c 			= 'New york'
 		);
 		
 		insert employee;
 		
 		// Data manipulation
        List<FABarcode__c> barcodes = new List<FABarcode__c>();
		//Inserting new FABarcode__c(s)
		FABarcode__c bc = null;
	    
	    for(Integer i = 0; i < 11; i++){
	        bc = new FABarcode__c(
	        	Name 			= 'Barcode '+employee.id,
	        	FAEmployeeBC__c = employee.id,
	        	Barcodes__c 	= '123987'+i
	        );
	        barcodes.add(bc);
	    }
	     
 		insert barcodes;
	    
	     
		//Create a new instance of standard controller
		ApexPages.StandardController sc = new ApexPages.standardController(employee);
        FinalAssignmentController ctrl = new FinalAssignmentController(sc);
   
        	
        PageReference pageReference = Page.FinalAssignmentPage;            
        pageReference.getParameters().put('id', employee.id);
		Test.setCurrentPage(pageReference);
                
                 
		System.runAs(user) {
            
		        //*********BEGIN THE TEST**************
			Test.startTest();	
	        
			    	//init methos test
			    	ctrl.init();
			        system.assertEquals(ctrl.bolshowDetail, false);
			        system.assertEquals(ctrl.barcode, '');
			    	 
			    	//search field test with empty fields
			    	ctrl.searchBIR = '';
			    	ctrl.searchIPN = ''; 
			    	ctrl.validate();
			
			    	system.assertEquals(ctrl.bolshowDetail, false);
			    	system.assertEquals(ctrl.country, null);
			    	system.assertEquals(ctrl.city, null); 
			    	  

			    	//search field test 
			    	ctrl.searchBIR 	= '1';
			    	ctrl.searchIPN 	= '1'; 
			    	ctrl.validate();
			    	
			    	system.assert(ctrl.employee !=null);
			    	system.assertEquals(ctrl.message, '');
			    	system.assertEquals(ctrl.bolshowDetail, true);
			    	system.assert(ctrl.country != null);
			    	system.assert(ctrl.city != null);
			
					//validate get employees 
					ctrl.searchBIR = null;
			    	ctrl.searchIPN = null; 
					ctrl.searchEmployee();
			    	system.assert(ctrl.employee !=null);
			    	
			    	
			    	ctrl.clearBarcodes();
			    	system.assertEquals(ctrl.barcode, '');
			    	ctrl.employee = employee;
			    	ctrl.barcode = 'abc \n 123 \n 8s8';
			    	ctrl.saveBarcodes(); 
			
			    	//test for the country dropdown population since it is hard coded 
			    	List <SelectOption>lstci = ctrl.getCountries();
			    	system.assertNotEquals(lstci,null);
			    	 
			    	ctrl.country = FinalAssignmentController.COUNTRY_AUS;
			    	List <SelectOption>lstcoAUS = ctrl.getCities();
			    	system.assertNotEquals(lstcoAUS,null);
			    	 
			    	ctrl.country = FinalAssignmentController.COUNTRY_LK;
			    	List <SelectOption>lstcoLK = ctrl.getCities();
			    	system.assertNotEquals(lstcoLK, null);
			    	 
			    	ctrl.country = FinalAssignmentController.COUNTRY_US;
			    	List <SelectOption>lstcoUS = ctrl.getCities();
			    	system.assertNotEquals(lstcoUS,null);
			    	 
			    	ctrl.country = '';
			    	List <SelectOption>lstcoEmpty = ctrl.getCities();
			    	system.assertNotEquals(lstcoEmpty,null);
	    	 
			Test.stopTest();
         }
    	//*********END THE TEST**************
    }
}