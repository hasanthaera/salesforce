/*********************************************************************
 * Description      : Final Assignment Controller Trigger Action
 * @author          : Hasantha Liyanage
 * @since           : June 14, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/
public with sharing class FinalAssignmentControllerTriggerAction {

   /*
    * Update barcodes action method
    */
	public static void updateBarcodes(list<FABarcode__c > barcodeList) {
		// get the barcode list
		for(FABarcode__c barcode : barcodeList) {
			// validate for empty barcode entry
			if(barcode.Barcodes__c==null || barcode.Barcodes__c.equals('')){
				barcode.addError('Barcode cannot be blank');
			} else {
				// validate for barcode limitation
				List<String> lstCodes = barcode.Barcodes__c.split(',');
				if(!lstCodes.isEmpty() && lstCodes.size()>20){
					barcode.addError('Barcode count cannot be more than 20');
				}
			}
		}
	}
}