global with sharing class ws_accountController {

    public ws_accountController(ApexPages.StandardController controller) {
       this.acct = (Account) controller.getRecord();
    }
    
    public ws_accountController() {
    }
    
    public Account acct         {set; get;}
    public boolean isSuccess    {set; get;}
    public String errMessage    {set; get;}
    public AccountDTO dto		{set; get;}
    
    public void getAccountById() {
    	Account account;
    	 try {
          	 account = [SELECT name, ws_date__c, WS_category__c, ws_Verified__c
                                      FROM Account
                                      WHERE Account.id=:acct.id 
                                      LIMIT 1];
             }catch (Exception e) {
         	 
         	 	errMessage = 'Un succesful';
            	isSuccess = false; 
    	     
    	     }
        if(account!=null) {                          
            this.acct = account;
            fillDto(); 
            errMessage = 'Succesful';
            isSuccess = true;
        } else {
            errMessage = 'Un succesful';
            isSuccess = false;
        }
        
    } 
     
    public AccountDTO fillDto() {
        	dto = new AccountDTO(); 
        if(acct!=null){
	        dto.categoty = acct.WS_category__c;
	        dto.name = acct.name;
	        dto.stDate = acct.WS_date__c;
	    	dto.verified = acct.WS_Verified__c;
       }
       return dto;
    }  
    
    public Boolean isValidId(String s) {
		Id validId;
			try {
				validId = s;
				return true;
			} catch (Exception ex) {
				return false;
			}
		}
        
 } // 0019000000OtgTX