/*********************************************************************
 * Description      : Final Assignment Controller 
 * @author          : Hasantha Liyanage
 * @since           : June 14, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/
public with sharing class FinalAssignmentController {
	
	//static variable declaration
	public static String MSG_NO_EMP_FOUND 		= 'No Employee found!';
	public static String MSG_NO_EMP_BIR_BLANK 	= 'BIR Number Cannot be blank';
	public static String MSG_NO_EMP_IPN_BLANK 	= 'IPN Number Cannot be blank';
	public static String COUNTRY_US				= 'US';
	public static String COUNTRY_AUS 			= 'AUS';
	public static String COUNTRY_LK 			= 'LK';
	
	// declare public getters and setters
    public FAEmployee__c employee { get; set; }
    public String searchBIR       { get; set; } 
    public String searchIPN       { get; set; }
    public Boolean bolshowDetail  { get; set; }
    public String country         { get; set; }
    public String city            { get; set; }
    public String barcode         { get; set; }    
    public String message		  { get; set; }
	
	/**
	 * constructor
	 */
    public FinalAssignmentController(ApexPages.StandardController controller) {
         this.employee = (FAEmployee__c) controller.getRecord();
         this.init();
    }
	
   /* 
   	* to initialize the page functionalities
    */
    public void init() {
        this.bolshowDetail  = false;
        this.clearBarcodes();
    }
    
   /* 
   	* Action for the validate button, this method will check the mandatory fields
   	* and fill the dropdowns if all the requirnments are fullfiled otherwise message will be prompted
    */
    public void validate() { 
		// TODO this. tab allignment
		this.message = '';
		this.init();
		//validate BIR
		if(searchBIR == null || searchBIR.trim().equals('')) {
			this.message = MSG_NO_EMP_BIR_BLANK;
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, message, '');
			ApexPages.addMessage(msg); 
			return;
		}
        
		//validate IPN
		if(this.searchIPN==null || searchIPN.trim().equals('')) {
			this.message = MSG_NO_EMP_IPN_BLANK;
			ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, message, '');
			ApexPages.addMessage(msg); 
         	return;
		}
           
		//if no error found and an employee is found, the dependancy picklist will be generated and displayed
		this.employee = this.searchEmployee();
		if(this.employee != null) {
			this.bolshowDetail 	= true;           
			this.country 		= this.employee.Country__c;
			this.city 			= this.employee.City__c; 
			this.getCountries();   
		}
		
		return;
    }
    
   /* 
   	* returns an eployee according to the given search criteria
    */
    public FAEmployee__c searchEmployee() {
		try {
			//query for employees
			System.debug('***search**');
			FAEmployee__c emp = [ SELECT BIR__c, IPN__c, Employee_Name__c, Country__c, City__c 
                              FROM   FAEmployee__c
                              WHERE  BIR__c =: this.searchBIR.trim()
                              AND    IPN__c =: this.searchIPN.trim()
                              limit 1 ];
                              
                              System.debug('***search**' + emp);
			
			return emp;
				                              
		} catch (Exception e) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, MSG_NO_EMP_FOUND, '');
			ApexPages.addMessage(myMsg);
		}                
  
        return null;
    }

   /* 
   	* clear the barcode textarea
    */
    public void clearBarcodes() {
        this.barcode = '';
    }
    
   /* 
   	* prepare and save the barcodes against the loaded employee
    */
    public void saveBarcodes() {
		String saveCodes = '';
         
		for(String val : barcode.split('\n')) {
			if(saveCodes.trim().equals('')) {
				saveCodes = val; 
			} else {
				saveCodes += ',' + val;
			}
        }

		FABarcode__c bc	= new FABarcode__c(
		name 			= 'Barcode '+this.employee.id,
		FAEmployeeBC__c = this.employee.id,
		Barcodes__c		= saveCodes  
		);
		
		boolean bolSaved = true;
         
		try {
			insert bc;  
		} catch (Exception e) {
			bolSaved = false;
		}      
		
		if(bolSaved){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Barcode successfully saved!', '');
         	ApexPages.addMessage(myMsg);
			clearBarcodes(); 
		}
    }

 
   /* 
   	* get countries will generate the picklist values
    */
    public List<SelectOption> getCountries() {

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(COUNTRY_US,'United States'));
        options.add(new SelectOption(COUNTRY_LK,'Sri Lanka'));
        options.add(new SelectOption(COUNTRY_AUS,'Australia'));
        return options;

    } 
    
   /* 
   	* get cities will generate the picklist values for the dependancy picklist
    */
    public List<SelectOption> getCities() {

		List<SelectOption> options = new List<SelectOption>();
        
		if(COUNTRY_US.equals(country)) {
			options.add(new SelectOption('New york','New york'));
			options.add(new SelectOption('Colarado','Colarado'));
			options.add(new SelectOption('San Fransisco','San Fransisco'));
            
		} else if(COUNTRY_AUS.equals(country)) {       
			options.add(new SelectOption('Melborne','Melborne'));
			options.add(new SelectOption('Adelade','Adelade'));
			options.add(new SelectOption('Sydney','Sydney'));

		} else if(COUNTRY_LK.equals(country)) {       
			options.add(new SelectOption('Colombo','Colombo'));
			options.add(new SelectOption('Galle','Galle'));
			options.add(new SelectOption('Matara','Matara'));
		}

		return options;
	} 

}