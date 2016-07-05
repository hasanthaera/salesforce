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
private class ManageAccountsTest {

    public static testMethod void myUnitTest() {

 		// Data manipulation
        List<Account> accounts = new List<Account>{};
		Account accountaaa = (Account)SmartFactory.createSObject('Account');
		accountaaa.BillingState = 'puke';
 		 System.debug('#### accountaaa.Name: ' + accountaaa.Name);
 		 System.debug('#### accountaaa.BillingState: ' + accountaaa.BillingState);
		//Inserting new Accounts
	    for(Integer i = 0; i < 11; i++){
	        Account a = new Account(Name = 'Hasantha Li' + i);
	        accounts.add(a);
	    }
	    
        insert accounts;        
   
    
    
     // Query the database for the newly inserted records.
    	List<Account> newlyAddedRecords = [SELECT Id, Name
                                      		FROM Account
                                      		WHERE Id IN :accounts];

        //Adding FixedSearchResults fro SOSL Query
        Id [] newlyAddedRecordsList = new List<Id>();
        for(Account acc: newlyAddedRecords) {
        	
			newlyAddedRecordsList.add(acc.Id);
   		}
   		
        Test.setFixedSearchResults(newlyAddedRecordsList);
        
        // creating a new ManageAccountController instance
        ManageAccountsController ctrler = new ManageAccountsController();
        
        
        //*********BEGIN THE TEST**************
        Test.startTest();
        //test search functionality
        ctrler.searchCriteria = '';
        ctrler.getAccounts();
        system.assert(ctrler.accounts.size()>0);
        system.assertEquals(accounts.size(), ctrler.accounts.size());
        system.assertEquals(ctrler.bolNoData, true);
        
        ctrler.searchCriteria = '*';
        ctrler.getAccounts();
        system.assert(ctrler.accounts.size()>10);
        system.assertEquals(ctrler.bolNoData, true);
        
        
        ctrler.searchCriteria = 'Hasantha';
        ctrler.getAccounts();
        system.assert(ctrler.accounts.size()>10);
        system.assertEquals(ctrler.accounts.size(), 11);
        
        ctrler.searchCriteria = 'ha';
        ctrler.getAccounts();
        system.assert(ctrler.accounts.size()>10);
        system.assertEquals(ctrler.bolshowDetail, null);
        
        //test fill details to list
        ctrler.fillDetails();
        system.assertEquals(ctrler.bolshowDetail, true);
        system.assertEquals(ctrler.bolDisableName, true);


		//testing save/update functionality     
        Account acct = new Account(Name = 'Hasantha Liyanage', phone = '123321123');
        ctrler.acct = acct;
        ctrler.saveAccount();
        system.assertEquals(ctrler.acct.Name, null); 
        
        //test delete functionality  
        List<Account> acctDel = new List<Account>();
        ctrler.deleteAccount();
        acctDel = [ SELECT Id FROM Account WHERE Name = 'Hasantha Liyanage' ];
        system.assertEquals(ctrler.acct, null);
        system.assertEquals(ctrler.bolshowDetail, false);

		//add new button functionality
       	ctrler.addNew();
       	Account newAcct = new Account();
       	system.assertEquals(ctrler.acct,newAcct);
        system.assertEquals(ctrler.searchCriteria, '');
        system.assertEquals(ctrler.bolshowDetail, true);
        system.assertEquals(ctrler.bolDisableName, false);

		//test validate method
		ctrler.validate();
		system.assert(ctrler.acct.name==null);
		
		//test clear content and hide details status
		ctrler.clearDetails(false);
		system.assertEquals(ctrler.acct, null);
        system.assertEquals(ctrler.bolshowDetail, false);
		Test.stopTest();
        
      }
}