@isTest
public class REST_Lead_Controller_Test {
    
    static testMethod void testcreateLead(){ 
       Test.startTest();
       String email= 'xx@gmail.com';
       String phone= '9878987659';
       String fname='gdf';
       String lname='dfg';

        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/v2/setLead/';

        List<Lead> anct = [SELECT Id from Lead WHERE Email = :email];

        String act = REST_Lead_Controller.createLead(email, phone, fname, lname);
           /* If PersonAccount's record does not exist */               
           Lead ant = new Lead();
           List<String> temp = email.split('@');
           ant.FirstName = fname;
           ant.LastName = lname;
           ant.Email = email;  
           ant.Company = 'mcnabb';
           ant.Status = 'Open';
           insert ant;
           System.assertEquals('Added', act);
           Test.stopTest();
    }

    static testMethod void testcreateLeadone(){

        Test.startTest();
        String email='abc@gmail.com';
        String fname='abc';
        String lname='qwe';
        String phone='9878987658';
		
        // you need to have a test data record inserted in order to retrive a one and update, otherwise you will ge the Error:
        // System.QueryException: List has no rows for assignment to SObject
        insert(new Lead (Email = 'abc@gmail.com',Company = 'ACB(Pty) Ltd', FirstName = 'test fn', LastName = 'test ln'));
        
        Lead actt = [SELECT Id, Phone, FirstName, LastName, Email, Company from Lead  WHERE Email   = :email LIMIT 1];
        String act = REST_Lead_Controller.createLead(email, phone, fname, lname);
           actt.FirstName = fname;
           actt.LastName = lname;
           actt.Phone = phone;
        update actt;
        System.assertEquals('Updated', act);
        Test.stopTest();
    }

     static testMethod void testcreateLeadtwo(){ 
        // you need to have an exsisting record in order to ge this test case passed 
        insert(new Lead (Email = 'abc@gmail.com',Company = 'ACB(Pty) Ltd', FirstName = 'test fn', LastName = 'test ln'));
        Test.startTest();
        String email='abc@gmail.com';
        String fname='';
        String lname='';
        String phone='NA';
        String act = REST_Lead_Controller.createLead(email, phone, fname, lname);
        System.assertEquals('Exist', act);
        Test.stopTest();
    }
}