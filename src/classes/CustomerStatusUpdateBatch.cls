/*********************************************************************
 * Description      : Customer status update batch
 * @author          : Hasantha Liyanage
 * @since           : June 6, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/
global with sharing class CustomerStatusUpdateBatch implements Database.Batchable<Customer__c>, Database.Stateful {
	String outputCsv = '';
	AsyncApexJob a;
	global Iterable<Customer__c> start (Database.Batchablecontext bc) {
	  a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      TotalJobItems, CreatedBy.Email
      FROM AsyncApexJob WHERE Id =
      :BC.getJobId()];
		return	[Select CustomerBudget__c, Status__c From Customer__c ];
	}

	global void execute (Database.Batchablecontext bc, list<Customer__c> custList) {
 		addHeader();
		for(Customer__c c : custList) {

			if(c.CustomerBudget__c<10000 ) {
				c.Status__c	= 'Low';
			} else if(c.CustomerBudget__c>10000 && c.CustomerBudget__c<100000) {
				c.Status__c	= 'Medium';
			} else if(c.CustomerBudget__c>100000) {
				c.Status__c	= 'High';
			}
       	}
 
  		try {
  			
 			Database.SaveResult[] results = Database.update(custList, false);
 		
 			for (Integer i = 0; i < results.size(); i++) {
	            if (results[i].isSuccess()) {
	            	addOutputCsv(custList[i].id);
	            	addOutputCsv(custList[i].Status__c);
	            	addOutputCsv(String.valueOf(custList[i].CustomerBudget__c));
	            	addNewLine(); 	
	            } else {
	            	addOutputCsv('Fail');
	            	addOutputCsv(results[i].getErrors()[0].getMessage());
	            	addNewLine();
	            }
	        }
 		
  			}catch(Exception e) { System.debug(e); }
	}

	global void finish(Database.BatchableContext BC){
		emailOutput('The batch Apex job for Budget Status Update finished processing.');
	}
	
	private void addHeader() {    	
    	outputCsv = EncodingUtil.base64decode('77u/').toString();
		addOutputCsv('Name');
    	addOutputCsv('Status');
    	addOutputCsv('Budget');   
    	addNewLine(); 	
    }
    private void addOutputCsv(String s) {
        if ( s != null ) outputCsv += '\"' + s + '\",'; 
        else outputCsv += '\"\",';
    }
    
    public void addNewLine() {
         outputCsv = outputCsv.substring(0, outputCsv.length() - 1) + '\r\n';
    }
    
    private boolean limitReached(){
    	return (outputCsv.length() > 5242880);
    }

	private void emailOutput(String body) {
                            
        Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
        Messaging.Emailfileattachment attach = new Messaging.Emailfileattachment();
        
        List<String> toAddressesList = new List<String>();
        String toAddresses = a.CreatedBy.Email; 
        if(toAddresses != Null) {       
	        for(String toAddress : a.CreatedBy.Email.split(';')) {
	        	toAddressesList.add(toAddress.trim());
	        }
        }
        mail.setToAddresses(toAddressesList);
        mail.setSubject('Status Update Scheduled Job');
        mail.setPlainTextBody(body);
        if(outputCsv != null && outputCsv != '') {
        	attach.setBody(Blob.valueOf(outputCsv));
	        attach.setContentType('text/csv');
	        attach.setFileName('Status Update '+ Datetime.now().format('dd-MM-yyyy_hh_mm')+'.csv');
	        mail.setFileAttachments(new Messaging.Emailfileattachment[]{attach});
        }        
        Messaging.sendEmail(new Messaging.Singleemailmessage[]{mail});        
    }

}