global class AccountsController {


    @AuraEnabled
    global static Account getAccount(String id) {
        
        Account account = [SELECT Id, Name,ShippingCity, Website
                   FROM Account WHERE Id = :id ];
        System.debug(' HASA account '+account);
        return account;
    }
    
    
    @AuraEnabled
    global static Account saveAccountDetails(Account account) {
        System.debug(' HASA SAVED ACCOUNT '+account);
        Account updatedAccount = [ SELECT Id, Name,ShippingCity, Website
                                  FROM Account
                                  WHERE Id = :account.id ];
        
        
        updatedAccount.Website = account.Website;
        update updatedAccount;
        return updatedAccount;

    }
}