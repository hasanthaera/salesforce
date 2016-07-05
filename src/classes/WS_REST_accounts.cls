@RestResource(urlMapping='/Account/*')
global with sharing class WS_REST_accounts {

  
  
    @HttpGet
    global static AccountDTO doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        WS_accounts wsAcct = new WS_accounts();
        String strId = '';
        Map <String, String> mapParam = req.params;

        strId = mapParam.get('id');
        System.debug('#### accountId: ' +strId);
        AccountDTO ac = getAccountById(strId);
        return ac;
    }
  
  	static AccountDTO getAccountById(String acctId) {
         	AccountDTO accDTO = new AccountDTO();
        	ws_accountController wsCtrl = new ws_accountController();	
        	
        	//setting account id
        	Account acct = new Account();
        	if(wsCtrl.isValidId(acctId)) {
        		Id sid		= acctId;
        		acct.id		= sid;
        		wsCtrl.acct	= acct;
        	
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