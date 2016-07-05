/*********************************************************************
 * Description      : Customer-Project Management Trigger
 * @author          : Hasantha Liyanage
 * @since           : June 6, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/
trigger CalculateBudget on Project__c (before insert, before update) {
	
	/*if(trigger.isBefore){
        // Trigger Before Insert
        if(trigger.isInsert){
            CustomerProjectManagementTriggerAction.updateProjects(trigger.new);
        }
        // Trigger Before Update
        if(trigger.isUpdate){
            CustomerProjectManagementTriggerAction.updateProjects(trigger.new);
        }
    }*/
    
}