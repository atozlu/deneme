public class FDHandlerclass {
    public static void populateReloff(List<Fixed_Deposit_Details__c> listFD , Map<Id, Fixed_Deposit_Details__c> mapFD ){
        //STEP 1:WE WILL CAPTURE THE BRANCHES OF THE NEWLY CREATED fd dETAILS RECORDS.
        Set<String> brSet = new Set<String>(); // this will hold the branches
        for(Fixed_Deposit_Details__c fdRec:listFD){
            if(String.isNotBlank(fdRec.Branch__c)){
                brSet.add(fdRec.Branch__c);
            }
               }
        // STEP 2:WE WILL DO AN SOQL IN THE BRANCH RELATIONSHIP OFFICER OBJECT BY USING THE SET AS A FILTER
        List<Branch_Relationship_Officer__c> listRel = new List<Branch_Relationship_Officer__c>();
        if(brSet.size()>0){
            listRel= [SELECT Id, Branch_name__c, Relationship_Officer__c FROM Branch_Relationship_Officer__c
                     WHERE Branch_name__c IN:brSet];
        }
        //STEP 3: we will create a map collection so that we can match the branch name and its relationship officer
        Map<String,String> mapRel = new Map<String,String>();
        for(Branch_Relationship_Officer__c  brRec:listRel){
            mapRel.put(brRec.Branch_name__c, brRec.Relationship_Officer__c);
        }
         //STEP 4: WE WILL POPULATE THE REL OFF VALUES TO THE NEWLY CREATED FD RECORDS FROM THE MAP COLLECTION
        for(Fixed_Deposit_Details__c fdRec:listFD){
            if(mapFD==null){
                fdRec.Relationship_Officer__c=mapRel.get(fdRec.Branch__c);
            } else if (mapFD .get(fdRec.Id).Branch__c!=fdRec.Branch__c)
            {
                  fdRec.Relationship_Officer__c=mapRel.get(fdRec.Branch__c);
            }
        }
}
    public static void shareRecords(List<Fixed_Deposit_Details__c> listFD , List<Fixed_Deposit_Details__c> oldlist ){
        List<Fixed_Deposit_Details__share> shareList = new  List<Fixed_Deposit_Details__share>();// this list will be loaded as a bulkification practice
        for(Fixed_Deposit_Details__c fdRec:listFD){
            if(String.isNotBlank(fdRec.Relationship_Officer__c)){ //if relationship officer field is not blank
                Fixed_Deposit_Details__share  fdshare = new Fixed_Deposit_Details__share();//this instance will have the record value coming from the method below
                fdshare = createShareIns(fdRec.Id, fdRec.Relationship_Officer__c);  //we are calling our method and assigning the value to the variable
               fdshare.AccessLevel='Edit'; //overwrite the access level
                shareList.add(fdshare);// we will add instance in the list
            }
          if(String.isNotBlank(fdRec.Sales_Representative__c)){
                Fixed_Deposit_Details__share  fdshare = new Fixed_Deposit_Details__share();
                fdshare = createShareIns(fdRec.Id, fdRec.Sales_Representative__c);
                shareList.add(fdshare);
            }
        }
        insert shareList;
        if(oldList!=null){   //if old list is not equal to null then update the record sharing
            Set<String> oldOffIds = new Set<String>(); //want to store the user ID
            for(Fixed_Deposit_Details__c fdRec:oldList){// To put the Elements in the set
                     oldOffIds.add(fdRec.Relationship_Officer__c);//IT WILL ADD PREVIOUS VERSION OF RECORDS
                     oldOffIds.add(fdRec.Sales_Representative__c);
                     oldOffIds.add(fdRec.Id);
            }
        //WILL PASS SOQL FILTER
        List<Fixed_Deposit_Details__share> oldShareRecs = [SELECT Id,ParentId, UserOrGroupId from Fixed_Deposit_Details__share
                                                         WHERE UserOrGroupId IN:oldOffIds AND ParentId IN:oldOffIds];
            delete oldShareRecs;
    }
    }
    //A method can manage the function and return it
    //We are giving an instructions to method , create the instance for Fixed deposit share obj and assign the access level and row case
    //and for parent id and usergrup id field value  please use the parameter
    public static Fixed_Deposit_Details__share createShareIns(Id recId, Id offId){ //if condition will call this method and for this we need record
         Fixed_Deposit_Details__share fdshare = new Fixed_Deposit_Details__share();
        fdshare.ParentId=recId;
        fdshare.UserOrGroupId=offId;
        fdshare.AccessLevel='Read';
        fdshare.RowCause='Manual';
        return  fdshare;
    }
}