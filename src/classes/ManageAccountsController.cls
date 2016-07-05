/*********************************************************************
 * Description      : The controller Account manager Page
 * @author          : Hasantha Liyanage
 * @since           : May 31, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/

public with sharing class ManageAccountsController {

    public Account acct;
    public ManageAccountsController(){}
    
  /*
   * ManageAccountsController constructor 
   */
    public ManageAccountsController(ApexPages.StandardController controller) {
                this.acct = (Account) controller.getRecord();
                bolshowDetail = false;
                bolDisableName = false;
                searchCriteria = '';
                accounts = null;
                getAccounts();
                noRecordsFoundMsg = 'No Records found!';
                bolNoData = true;
                
    }


    public String clickedRowId { get; set; } 
    public String searchCriteria{ get; set; } 
    public String selectedAcctId{ get; set; }
    public Boolean bolshowDetail{ get; set; }
    public Boolean bolDisableName{ get; set; }    
    public Boolean bolNoData{ get; set; }  
    public String noRecordsFoundMsg{ get; set; }
     
    public List<Account> accounts { get; set; }       
    String searchCri  = '';
    
  /*
   * getAccounts will search for all the accounts according to the given criteria
   */
    public void getAccounts() {
        searchCri = '';
        System.debug('#### searchCriteria: ' + searchCriteria);
        
        if(searchCriteria.equals('') || searchCriteria.equals('*')) {
            searchCri = '%';
        } else if(searchCriteria.contains('*')) {
            searchCriteria = searchCriteria.replace('*','');
            searchCri = searchCriteria+'%';
        } else {
            searchCri = searchCriteria+'%';
        }
         accounts = [SELECT name,  phone, ShippingCity, ShippingCountry 
                     FROM account 
                     WHERE name 
                     LIKE :searchCri  
                     ORDER BY name];
                                           
         if(accounts .size()<=0) {
             bolNoData = false;
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, noRecordsFoundMsg , '');
             ApexPages.addMessage(myMsg);
         } else {
             bolNoData  = true;
         }
        System.debug('#### accounts size : ' + accounts .size());                               
    }
  
    
  /*
   * all the details will be filled to the input fields at the details sections on click on a link
   */
    public void fillDetails(){
         this.bolshowDetail = true;
         this.bolDisableName = true;
         acct = getAccount(); 
    }    
        
   /*
   * getAccount will return only one account against the id given 
   */    
    public Account getAccount() {
        Id accId= ApexPages.currentPage().getParameters().get('accId');
        System.debug('#### accId: ' + accId);
        if(accId!=null)
            acct= [ SELECT name,  phone, ShippingCity, ShippingCountry 
                        FROM Account 
                    WHERE id =:accId limit 1 ];   
        return acct; 
    }
    
   /*
   * saveAccount is responsible of saving/update records
   */
    public void saveAccount(){
     try {
        if(validate()){
            upsert(acct);
            cancelAccount();
        }
      }catch (Exception e){
          System.debug('exception occured');  
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error on Saving record', '');
          ApexPages.addMessage(myMsg);
      }
    }
    
  /*
   * deleteAccount is responsible of deleting record once the delete button is clicked
   */
    public void deleteAccount(){
       try {
        if(acct!=null) {
                delete(acct);
        }
        clearDetails(false);
       }catch (Exception e){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error on deleting record', '');
          ApexPages.addMessage(myMsg);
      }
    }
    
  /*
   * cacelAccount will function once the cacel button is clicked to initialize the screen
   */
    public void cancelAccount(){
       clearDetails(false);
    }
    
  /*
   * clear details will clear/initialize particular statusus and criterias according to the passed status
   */
    public void clearDetails(Boolean status){
        acct = null;
        this.searchCriteria = '';
        this.bolshowDetail = status;
        getAccounts();
    }
    
  /*
   * addNew method will be called once the new button is clicked
   */
    public void addNew(){
        acct = new Account();
        this.searchCriteria = '';
        this.bolshowDetail = true;
        this.bolDisableName = false;
    }
    
  /*
   * validate will handle all the common validations and pass the message to users
   */
     public boolean validate() {
            String detail  = 'details';
            String message = '';
            
             if(acct.name == null || String.valueOf(acct.name).equals('')) {
                message = 'Account name cannot be blank';
             }
             
                 
             if(!message.equals('')) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, message, detail );
                ApexPages.addMessage(myMsg);
                return false;
             }
             
             return true;
     }
}