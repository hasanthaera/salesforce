/*********************************************************************
 * Description      : Customer-Project Management Trigger Action
 * @author          : Hasantha Liyanage
 * @since           : June 6, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/
public with sharing class CustomerProjectManagementTriggerAction {

   /*
    * Update projects budget and the total for the customer
    */
	public static void updateProjects(list<Project__c> projectsList) {

		try {
			Set <id>customerIds = new Set<id>();
			// calculate total budget per project
			for(Project__c project : projectsList) {
				Decimal num = project.Q1__c+project.Q2__c+project.Q3__c+project.Q4__c;                      	
				project.budget__c = num;
				customerIds.add(project.Customer__c);
			}	
			list<Customer__c> newCustList = new list<Customer__c>();
			//calculate total budget per customer
			 for(Customer__c customer: [Select c.CustomerBudget__c From Customer__c c WHERE c.id IN:customerIds]) {
			 		Decimal dec = 0;
					for(Project__c project : projectsList) {
						if(project.Customer__c==customer.id){
							dec+=project.budget__c;
						}
					}
					customer.CustomerBudget__c=dec;
					newCustList.add(customer);
			 }

			update(newCustList);
			
		} catch(Exception e) { system.debug(e); }
	}

}