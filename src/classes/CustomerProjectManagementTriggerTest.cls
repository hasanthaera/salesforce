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
private class CustomerProjectManagementTriggerTest {

    static testMethod void myUnitTest() {
// Data manipulation
		
			//Inserting new custa
		   	Customer__c cust = new Customer__c(name__c = 'Test custa');
			insert cust;
			
			Employee__c emp1 = new Employee__C(Name__c = 'abc');
			insert emp1;
			
			List<Project__c> projects =new List<Project__c>();
			Project__c pro1 = new Project__c(Project_Name__c = 'pro1', Customer__c = cust.id, Employee__c = emp1.id);
			pro1.Q1__c =1000;
        	pro1.Q2__c =1000;
        	pro1.Q3__c =1000;
        	pro1.Q4__c =1000;
			projects.add(pro1);
			
			Project__c pro2 = new Project__c(Project_Name__c = 'pro2' , Customer__c = cust.id,  Employee__c = emp1.id);
			pro2.Q1__c =1000;
        	pro2.Q2__c =1000;
        	pro2.Q3__c =1000;
        	pro2.Q4__c =2000;
			projects.add(pro2);	    
			insert projects;
		
       
		//*********BEGIN THE TEST**************
       	Test.startTest();

		update projects;
        system.assertEquals(2, projects.size());
        
        Project__c updatedProj = [ Select Id, budget__c from Project__c where Project_Name__c='pro1']; 
        system.assertEquals(4000, updatedProj.budget__c);
       	
       	Customer__c updatedCust = [ Select Id, CustomerBudget__c from Customer__c where name__c='Test custa']; 
        system.assertEquals(9000, updatedCust.CustomerBudget__c);
        
        Test.stopTest();
    }
}