@RestResource(urlMapping='/v2/setLead/*')
global with sharing class REST_Lead_Controller {

    @HttpPost
    global static String createLead(String email, String phone, String fname, String lname){

        List<Lead> anct = [SELECT Id from Lead  WHERE Email = :email]; 

        /* If PersonAccount's record does not exist */               
        if(anct.size() == 0){ 

            Lead lead = new Lead();
            List<String> temp = email.split('@');
            lead.FirstName = fname;
            lead.LastName = lname;
            lead.Email = email;      
            lead.Company = 'mcnabb';    
            lead.Status = 'Open'; 
            insert lead;
            return 'Added';


        }else if(phone != 'NA'){

        /* If PersonAccount's record already exist */                
            Lead lead= [SELECT Id, Phone, FirstName, LastName, Email, Company from Lead  WHERE Email   = :email];
            lead.Phone = phone; 
            lead.FirstName = fname;
            lead.LastName = lname;
            update lead;
            return 'Updated';
        }else{

             return 'Exist';
        }
    }
}