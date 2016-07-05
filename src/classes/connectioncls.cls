public with sharing class connectioncls{ 
public boolean CampaignConnection(){
        try{
             
                String mailchimpstatus;  
                List<String> dcList = 'test-test'.split('-');
                String dc = String.valueOf(dcList[1]);
/***********************************************************/               
String statusReqURL = 'https://'+ dc +'.api.mailchimp.com/2.0/helper/verified-domains?apikey='+ 'test';
                HttpRequest statusreq = new HttpRequest();     
                statusreq.setEndpoint(statusReqURL);
                statusreq.setMethod('GET');         
                Http statushttp = new Http();
                HTTPResponse statusres = statushttp.send(statusreq);      
                String statusresult = statusres.getBody();           
                if(statusresult<>null && statusresult<>''){                 
                    List<Object> data = (List<Object>)JSON.deserializeUntyped(statusresult);
                    for (Object o : data) {
                        Map<String, Object> d = (Map<String, Object>) o;                    
                        mailchimpstatus = String.valueOf(d.get('status')); 
                    }
                    if(mailchimpstatus == 'verified'){
                        //smMessage = true;                   
                    }else{
                        //smMessage = false;  
                    }
                }else{
                    //smMessage = false;  
                }

/**************************************************************/                   
        }catch(Exception e){
            //smMessage = false; 
        }
        return null;
    }
}