import { LightningElement,api } from 'lwc';


    const columns = [
    { label: 'Resource Name', fieldName: 'FirstName'},
    { label: 'Rate Per Hour', fieldName: 'Rate_PerHour__c', type: 'currency'},
    {label: 'Start Date',fieldName: 'dateApiName',type: 'date',editable: true},
    {label: 'End Date',fieldName: 'dateApiName1',type: 'date',editable: true}
];

export default class ResourceView extends LightningElement {

    @api users;
    @api thisPLI;
    
    /* @api recordId;  */

    userList;
    columns = columns;
    data;
    theArray = []
 

     connectedCallback(){
        this.userList = this.users.filter(user => user.UserRole.Name==this.thisPLI.Rol__c);

        return this.userList;     

    } 

    
    get data() {
        return this.resourcesByRole;     
    }  
    
    
    
    records;

     handleSave(event) {
        // console.log('ESTE ES EL EVENT DETAIL'+JSON.stringify(event.detail));
        // console.log('ESTE ES EL EVENT DETAIL DRAFT VALUE'+JSON.stringify(event.detail.draftValues));
        const updateFields = this.template.querySelector('lightning-datatable').getSelectedRows(); 
        updateFields.push(event.detail.draftValues);
        
        // const resources = event.detail.draftValues;
        console.log('RESOURCESFIRST---->'+JSON.stringify(updateFields));

        const resourcesProject = new CustomEvent("resourcesproject", {
        
            detail: {
                resources
                
            }
        });
    this.dispatchEvent(resourcesProject);
    console.log("RESOURCES---->"+JSON.stringify(resources));
    } 

    
}

//RESOURCESFIRST---->[{"Id":"005Dn000000ai5eIAA","FirstName":"Ulises","LastName":"Ferreyra","UserRoleId":"00EDn000000t7lYMAQ","Rate_PerHour__c":50,"UserRole":{"Name":"Consultant","Id":"00EDn000000t7lYMAQ"}},[{"dateApiName":"2022-10-28T20:11:00.000Z","id":"row-0"}]]