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
private class FinalAssignmentTriggerTest {
	
	/*
	 * test method
	 */
    static testMethod void myUnitTest() {
     	
    	// Data manipulation
		FAEmployee__c employee = new FAEmployee__c(
			Employee_Name__c	= 'Hasantha Liyanage_1',
			BIR__c				= '1', 
			IPN__c				= '1',  
			Country__c 			= 'US',  
			City__c 			= 'New york'
			);
 		
 		insert employee;  
	
		//*********BEGIN THE TEST**************
	    Test.startTest();
	    
		    //testing the insert	
		    FABarcode__c bc = new FABarcode__c(
		    	Name 			= 'Barcode '+employee.id,
		    	FAEmployeeBC__c	= employee.id,
		    	Barcodes__c		= '123987'
		    	);
		    insert bc;
		    
		    system.assertEquals(bc.Start_Barcode__c, false);
		    	 
		    FABarcode__c bc1 = new FABarcode__c(
		    	Name 			= 'Barcode '+employee.id,
		    	FAEmployeeBC__c = employee.id
		    	);
		    	 
		    // testing the insert for error message "Barcode cannot be blank"	 
		    Exception e1;
		    
		    try {
			   	insert bc1;
			} catch(Exception ex) {
			 	e1 = ex;
			}
		    	 
		    system.assert(e1.getMessage()!=null);
			
			 // testing the insert for error message "Barcode count cannot be more than 20"	 
			Exception e2;
		    
		    FABarcode__c bar = new FABarcode__c(
		    	Name 			= 'Barcode '+employee.id,
		    	FAEmployeeBC__c = employee.id,
		    	Barcodes__c 	= 'ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab, ab'
		    	);
		    
			try {
				insert bar;
			} catch(Exception ex) {
				e2 = ex;
			}
		    	 
		    system.assert(e2.getMessage()!=null);
		
		Test.stopTest();
	    //*********END THE TEST**************
    }
}