/*********************************************************************
 * Description      : The controller for Approve / Return page
 * @author          : Hasantha Liyanage
 * @since           : May 31, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/

public with sharing class ApexEmployeeController {
        
        public Decimal totalSalary {get; set;} 
        public Decimal netSalary {get; set;} 
        public Decimal bonus {get; set;} 
        
        private ApexEmployee__c apEmp;
        
        
        public ApexEmployeeController(ApexPages.StandardController stdController) {
                 this.apEmp = (ApexEmployee__c) stdController.getRecord();
        }
        
        public void calculateBonus() {
            if(validateBonus()){
                bonus 		= 	(netSalary/100)*apEmp.Bonus__c;
                totalSalary =  	bonus+netSalary;
            }
        }
       

        public void netSalary () {
            if(validateSalary()) {
                Decimal decNetSal = apEmp.Salary_per_Day__c ;
                Decimal decNoOfDays = apEmp.Number_of_Days__c;
                netSalary = decNetSal * decNoOfDays;
            }
        } 

        public boolean validateSalary(){
            String detail  = 'details';
            String message = '';
             if(apEmp.Salary_per_Day__c == null || String.valueOf(apEmp.Salary_per_Day__c).equals('')){
                message = 'Salary Per Day cannot be blank';
             }
             
             if(apEmp.Number_of_Days__c == null || String.valueOf(apEmp.Number_of_Days__c).equals('')){
                message = 'Number of days cannot be blank';
             }
             
             if(apEmp.Bonus__c == null || String.valueOf(apEmp.Bonus__c).equals('')){
                message = 'Bonus cannot be blank';
             }
             
                 
             if(!message.equals('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, message, detail );
                ApexPages.addMessage(myMsg);
                return false;
             }
             
             return true;
        }
        
        public boolean validateBonus(){
            
            String detail  = 'details';
            String message = '';
             if(netSalary == null || String.valueOf(netSalary).equals('')){
                message = 'Net Salary should be calculated';
             }
             
             if(apEmp.Bonus__c == null || String.valueOf(apEmp.Bonus__c).equals('')){
                message = 'Bonus cannot be blank';
             }
             
                 
             if(!message.equals('')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, message, detail );
                ApexPages.addMessage(myMsg);
                return false;
             }
             
             return true;
        }




}