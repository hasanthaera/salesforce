/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class EmailDemoReceiveHandlerTests {
    static testMethod void testInboundEmail() {
 	  // Create a new email and envelope object
        Messaging.InboundEmail email  = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
       
        // Set up your data if you need to
        
        // Create the email body
        email.plainTextBody = 'This is the body text which becomes the note';
        email.fromAddress ='hasanthaera@gmail.com';
        String contactEmail = 'hasan@salesforce.com';
        email.ccAddresses = new String[] {'Hasantha Liyanage <' + contactEmail + '>'};
        email.subject = 'Sample Account 0001';
        
        // set the body of the binary attachment
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
	   	binaryAttachment.body = blob.valueOf('test binary attachment');
	   	binaryAttachment.fileName = ' binary attachment attachment name';
	   	binaryAttachment.mimeTypeSubType = 'plain/txt';
	   	email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] {binaryAttachment};
	   	
	   	// set the body of the text attachment
	   	Messaging.InboundEmail.TextAttachment textAttachment = new Messaging.InboundEmail.TextAttachment();
	   	textAttachment.body = 'test text attachment';
	   	textAttachment.fileName = 'text attachment attachment name';
	   	textAttachment.mimeTypeSubType = 'texttwo/plain';
        email.textAttachments = new Messaging.InboundEmail.TextAttachment[] {textAttachment};
        
        EmailDemoReceive edr = new EmailDemoReceive();
        
        Test.startTest();
        Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
        Test.stopTest();
        
        System.assert (result.success, 'InboundEmailResult returned a failure message');
        
        Account [] accDb = [select ID from Account where name=:email.subject];
        System.assertEquals (1, accDb.size(),'Account insertion failed!');
        Contact [] cDb = [select firstname,lastname from Contact where email=:contactEmail];
        System.assertEquals (1, cDb.size(),'Contact insertion failed!');
        Contact c = CDb[0];
        System.assertEquals ('Hasantha', c.firstName);
        System.assertEquals ('Liyanage', c.LastName);
        Note [] nDb = [select body from Note where ParentID=:accDb[0].id];
        System.assertEquals (1,nDb.size(), 'The new note should have been attached');
        System.assertEquals (email.plainTextBody, nDb[0].body);
        
    }
}