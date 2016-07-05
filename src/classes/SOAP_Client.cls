public with sharing class SOAP_Client {

	public void excecutetest(){
		
		String username = 'hasanthaera@gmail.com';
		String password = 'He@08082012@u3VQBGfVZrQs32R4RKJz7h75h';
		partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();

		partnerSoapSforceCom.LoginResult loginResult = sp.login(username, password);
		
		system.debug('   loginResult ' + loginResult);
		
		soapSforceComSchemasClassWsAccount.WS_accounts apexWebSvc = new soapSforceComSchemasClassWsAccount.WS_accounts();
		soapSforceComSchemasClassWsAccount.SessionHeader_element sessionHeader = new soapSforceComSchemasClassWsAccount.SessionHeader_element();
		sessionHeader.sessionId = loginResult.sessionId; 
		
		// The Web services have a maximum timeout of 2 minutes. The timeout value
		// is in milliseconds.
		apexWebSvc.timeout_x = 120000;
		apexWebSvc.SessionHeader = sessionHeader;
		
		soapSforceComSchemasClassAccountdto.AccountDTO	accountDto = apexWebSvc.getAccountById('0019000000OtgTX');

		if(accountDto.isSuccess=true) {
			system.debug('   name ' + accountDto.name);		
			system.debug('   stDate ' + accountDto.stDate);	
			system.debug('   Categoty ' + accountDto.Categoty);	
			system.debug('   verified ' + accountDto.verified);	
			system.debug('   isSuccess ' + accountDto.isSuccess);	
			system.debug('   errMessage ' + accountDto.errMessage);	
		}else{
			system.debug('   Message ' + accountDto.errMessage);	
		}		
		
     }
}