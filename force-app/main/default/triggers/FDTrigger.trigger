trigger FDTrigger on Fixed_Deposit_Details__c (before insert, before update, after insert, after update) {
    if(Trigger.isBefore){
        FDHandlerclass.populateReloff(Trigger.new,Trigger.oldMap);//Map<id..sObject
        }
    if(Trigger.isAfter){
        FDHandlerClass.shareRecords(Trigger.new, Trigger.old);
    }
    }