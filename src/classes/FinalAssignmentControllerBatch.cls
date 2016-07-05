/*********************************************************************
 * Description      : Final Assignment Controller Batch
 * @author          : Hasantha Liyanage
 * @since           : June 14, 2013
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/
global with sharing class FinalAssignmentControllerBatch   implements Database.Batchable<FABarcode__c> {

	String strBarcodes = ''; 
	String strEmployee = ''; 
	
	User user = [ SELECT email, FirstName
						FROM User 
						WHERE id =: Userinfo.getUserId() ];
	
	global Iterable<FABarcode__c> start (Database.Batchablecontext bc) {
		return	[	SELECT FAEmployeeBC__r.id, FAEmployeeBC__c, Barcodes__c, Start_Barcode__c, FAEmployeeBC__r.Employee_Name__c, FAEmployeeBC__r.IPN__c, FAEmployeeBC__r.BIR__c, FAEmployeeBC__r.Country__c, FAEmployeeBC__r.City__c 
					FROM FABarcode__c 
					WHERE Start_Barcode__c = false ];
	}

	global void execute (Database.Batchablecontext bc, list<FABarcode__c> barcodes) {

		for(FABarcode__c bar :barcodes) {	
			bar.Start_Barcode__c = true;
		}

  		try {
  			
			Database.SaveResult[] results = null;
  			
  			//save updated barcodes
  			if (!barcodes.isEmpty()) {
  				results = Database.update(barcodes, false);
  			}
 	    	
 	    	//get employees
 	    	set<id> ids = new set<id>();
 
 	    	for (FABarcode__c bar: barcodes) {
 	    		ids.add(bar.FAEmployeeBC__r.id);
 	    	}
 			
 			boolean mail = false;
	 	    for (Id eid: ids) {
	 	    	mail = false;
	 	    	for (FABarcode__c bar: barcodes) {
	 	    		if(eid == bar.FAEmployeeBC__r.id) {
	 	    			strEmployee = '<br><br><li>Employee Details <br>';
				      	strEmployee += '&nbsp;&nbsp;&nbsp;&nbsp;Employee Name : - '+bar.FAEmployeeBC__r.Employee_Name__c+'<br>';
				        strEmployee += '&nbsp;&nbsp;&nbsp;		  IPN : - '+bar.FAEmployeeBC__r.IPN__c+'<br>';
				        strEmployee += '&nbsp;&nbsp;&nbsp;		  BIR : - '+bar.FAEmployeeBC__r.BIR__c+'<br>';
				        strEmployee += '&nbsp;&nbsp;&nbsp;	  Country : - '+bar.FAEmployeeBC__r.Country__c+'<br>';
				        strEmployee += '&nbsp;&nbsp;&nbsp;		 City : - '+bar.FAEmployeeBC__r.City__c+'<br>';
				        
				        strBarcodes  =  '<h3>Processed Barcode Details for Employee: '+bar.FAEmployeeBC__r.Employee_Name__c+'</h3><br>';
						strBarcodes +=  'Dear '+user.FirstName +',<br><br>';
						strBarcodes +=  'Please find the processed barcodes of employee '+bar.FAEmployeeBC__r.Employee_Name__c +'<br><br>';
						strBarcodes +=  '<li>Barcodes,<br>';
						break;
	 	    		}
	    		} 
	 	    	
	 	    	for (FABarcode__c bar: barcodes) {
					if(eid == bar.FAEmployeeBC__r.id) {    
						mail = true;
	 	    			strBarcodes +=this.getNewLines(bar.Barcodes__c) ;
	 	    		}	 	    		
	 	    	}
	 	    	
	 	    	if(mail) {
 					emailOutput(strBarcodes+strEmployee);
	 	    	}
	 	    }
 		
  		}catch(Exception e) { 
  			System.debug(e); 
  		}
	}


   /* 
   	* generate new lines for each barcode by seperating the barcode text
    */
	private String getNewLines(String barcode) {
		String out = '';
		for(String val:barcode.split(',')) {
				out += '&nbsp;&nbsp;&nbsp;&nbsp;'+val+'<br>';
		}
		return out;
	}

	global void finish(Database.BatchableContext BC) {
		emailOutput('BATCH : Barcode Details for Employees successfully processed ');
	}
	
   /* 
   	* generate email output
    */
	private void emailOutput(String body) {
 
		Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();

		List<String> toAddressesList = new List<String>();
		String toAddresses = user.Email; 
		if(toAddresses != Null) {       
			for(String toAddress : user.Email.split(';')) {
	        	toAddressesList.add(toAddress.trim());
	        }
        }
        mail.setToAddresses(toAddressesList);
        mail.setSubject('Status Update Scheduled Job');
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.Singleemailmessage[]{mail});        
    }

}