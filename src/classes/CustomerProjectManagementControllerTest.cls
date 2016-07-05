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
private class CustomerProjectManagementControllerTest {
		
	    
    	static testMethod void myUnitTest() {
    		// Data manipulation
		
			//Inserting new custa
		   	Customer__c cust = new Customer__c(name__c = 'Test custa');
			insert cust;
			
			Employee__c emp1 = new Employee__C(Name__c = 'abc');
			insert emp1;
			
			List<Project__c> projects =new List<Project__c>();
			Project__c pro1 = new Project__c(Customer__c = cust.id, Employee__c = emp1.id);
			projects.add(pro1);
			
			Project__c pro2 = new Project__c(Customer__c = cust.id,  Employee__c = emp1.id);
			projects.add(pro2);	    
			//Insert the object virtually
			insert projects; 
			

			//Create a new instance of standard controller
			ApexPages.StandardController sc = new ApexPages.standardController(cust);
        	CustomerProjectManagementController cusProMgtCtrl = new CustomerProjectManagementController(sc);
        	
        	PageReference pageReference = Page.CustomerProjectManagementPage;            
         	pageReference.getParameters().put('id', cust.id);
			Test.setCurrentPage(pageReference);
                
        	//*********BEGIN THE TEST**************
        	Test.startTest();
        
        
        	cusProMgtCtrl.getProjects();
        	system.assertEquals(2, projects.size());
        	
        	for(Project__c proj : projects) {
        		proj.Q1__c	=	100;
        	}
        	
        	update projects;
        	
        	cusProMgtCtrl.saveProjects();
        	for(Project__c updatedProj : [ Select Id, Q1__c from Project__c ]) {
        		system.assertEquals(100, updatedProj.Q1__c);
        	}
        	
        	
        	Test.stopTest();
    	}
}