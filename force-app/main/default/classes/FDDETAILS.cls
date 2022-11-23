public with sharing class FDDETAILS {
   @AuraEnabled(cacheable=true)
   
    public static Fixed_Deposit_Details__c fetchCustomerType (String recfdId){
     Fixed_Deposit_Details__c fdRec = [SELECT Id, Customer_Type__c FROM Fixed_Deposit_Details__c WHERE Id=:recfdId with Security_ENFORCED];
    return fdRec;
    }
} 