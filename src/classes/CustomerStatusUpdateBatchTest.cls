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
private class CustomerStatusUpdateBatchTest {

    static testMethod void myUnitTest() {
        
        list<Customer__c> custList 						=	new list<Customer__c>();
        
        Customer__c		 	cus1 						=	new Customer__c(
        					name__c			 			= 	'Hasantha1',
        					CustomerBudget__c 			= 	0);
        Customer__c		 	cus2 						=	new Customer__c(
        					name__c			 			= 	'Hasantha2',
        					CustomerBudget__c 			= 	5000);
        					
        Customer__c		 	cus3 						=	new Customer__c(
        					name__c			 			= 	'Hasantha3',
        					CustomerBudget__c 			= 	12000);
       	Customer__c		 	cus4 						=	new Customer__c(
       						name__c			 			= 	'Hasantha4',
        					CustomerBudget__c 			= 	50000);
        Customer__c		 	cus5 						=	new Customer__c(
        					name__c			 			= 	'Hasantha5',
        					CustomerBudget__c 			= 	90000);
        					
        Customer__c		 	cus6 						=	new Customer__c(
        					name__c			 			= 	'Hasantha6',
        					CustomerBudget__c 			= 	150000);
       
        
		custList.add(cus1);
		custList.add(cus2);
		custList.add(cus3);
		custList.add(cus4);
		custList.add(cus5);
		custList.add(cus6);

		
		insert custList;
		
		Test.startTest();
		
		Database.executeBatch(new CustomerStatusUpdateBatch(),200);
		Test.stopTest();
			
		list<Customer__c> UpdatedCustList	=	[ SELECT Id 
												  	  FROM Customer__c 
												  	  WHERE Status__c = :'Low' ];
												  
		System.assertEquals(2, UpdatedCustList.size(), 'Status update batch process ERROR!!!');									  
			
		
    }
}