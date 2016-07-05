global class test {
    public list<string> checkboxSelections {get;set;}
    public list<SelectOption> options {get;set;}
    
    public test(){
        getPicklistValues(new Account(), 'Type');
    }
    global void getPicklistValues(SObject Account, String Dummy){
        options = new list<SelectOption>();
        
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType(); 
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get(Dummy).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values) { 
            options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }

    }
    
    
}