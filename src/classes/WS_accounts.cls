global with sharing class WS_accounts {

 		  webservice static AccountDTO getAccountById(String acctId) {
         	AccountDTO accDTO = new AccountDTO();
        	ws_accountController wsCtrl = new ws_accountController();	
        	
        	
        	//setting account id
        	Account acct = new Account();
        	if(wsCtrl.isValidId(acctId)){
        		Id sid = acctId;
        		acct.id  = sid;
        		wsCtrl.acct = acct;
        	
	        	wsCtrl.getAccountById();
	        	if(wsCtrl.isSuccess) {
	        		
	        		accDTO = wsCtrl.fillDto();
	        	}
	        	
	        	if(accDTO!=null){
	        		accDTO.isSuccess = wsCtrl.isSuccess;
	        		accDTO.errMessage = wsCtrl.errMessage;
	        	 	System.debug('#### wsCtrl.errMessage: ' + wsCtrl.errMessage);
	        	 	System.debug('#### accDTO.name: ' + accDTO.name);
	        	}
        	
        	} else {
        		accDTO.isSuccess = false;
	        	accDTO.errMessage = 'Invalid Account ID';
        	}
        	
        	return accDTO;
       	}       	
}