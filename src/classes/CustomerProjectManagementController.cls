/*********************************************************************
 * Description      : Customer Project Management Controller
 * @author          : Hasantha Liyanage
 * @since           : June 6, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/
public with sharing class CustomerProjectManagementController {

  
    public CustomerProjectManagementController(ApexPages.StandardController controller) {
                this.customer = (Customer__c) controller.getRecord();
                init();
               
    }
    
    
     public Customer__c customer{ get; set; }
     public List<Customer__c > customers{ get; set; }
     public List<Project__c > projects{ get; set; } 
     
     /*
      * get all projects for the particular customer 
      */
     public void getProjects() {
       
         projects = [SELECT name, Q1__c,Q2__c,Q3__c,Q4__c, budget__c 
                                      FROM project__c
                                      WHERE Customer__c =:customer.id];    
                                                                                     
     }
     
    /*
     * Save projects luist
     */
     public void saveProjects(){
         System.debug('#### customer size : ' + projects.size());  
         //Database.executeBatch(new CustomerStatusUpdateBatch(),10);
         update(projects);
         init();
     }
     
    /*
     * Initialize the page
     */
     public void init() {
        this.getProjects();
     
     }

}