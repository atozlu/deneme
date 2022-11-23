import { api, LightningElement, wire } from 'lwc';
import fetchCustomerType from '@salesforce/apex/FDDETAILS.fetchCustomerType';
export default class FDDETAILS extends LightningElement {
    customeroptions
    @api recordId
    @wire(fetchCustomerType ,{recordId:'$recordId'}) wireDataCus({error,data}){
        if (data) {
            let option=[];
            option.push({label:data.Customer_Type__c, value:data.Customer_Type__c})
            this.customeroptions=option;
            console.log('option is' + JSON.stringify(this.customeroptions));
            
        }else if(error){
            console.error(JSON.stringify(error));
        }
    }
}