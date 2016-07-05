public with sharing class REST_Client {

    public REST_Client() {
        searchAccountsRest();
    }

     public void searchAccountsRest() {
        String accId= '0019000000O';
        Http h = new Http();
        String url = 'https://ap1.salesforce.com/services/apexrest/Account?id=' + EncodingUtil.urlEncode(accId, 'UTF-8');
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        HttpResponse res = h.send(req);
        system.debug('############### PRINTING THE JSON OBJECT : ' + res.getBody());
        
        AccountDTO deserializedJson = (AccountDTO) JSON.deserialize(res.getBody(), AccountDTO.class);
        system.debug('############### PRINTING THE DESERIALIZED JSON OBJECT : ' + deserializedJson);
        
        //return deserializedJson;
     }
}