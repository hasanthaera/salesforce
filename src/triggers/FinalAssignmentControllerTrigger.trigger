/*********************************************************************
 * Description      : Final Assignment Controller Trigger
 * @author          : Hasantha Liyanage
 * @since           : June 14, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/

trigger FinalAssignmentControllerTrigger on FABarcode__c (before insert) {

	if(trigger.isBefore){
        // Trigger Before Insert
        if(trigger.isInsert){
        	// calling the action class
            FinalAssignmentControllerTriggerAction.updateBarcodes(trigger.new);
        }
    }
}