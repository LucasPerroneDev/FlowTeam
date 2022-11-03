import { LightningElement,api } from 'lwc';


    const columns = [
            
        { label: 'Resource First Name', fieldName: 'FirstName'},
        { label: 'Last Name', fieldName: 'LastName'},
        { label: 'Rate Per Hour', fieldName: 'Rate_PerHour__c', type: 'currency' },
        {
            label: 'Start Date',
            fieldName: 'StartDate__c',
            type: 'date-local',
            editable: true,
            typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            }
         },
         {
            label: 'End Date',
            fieldName: 'EndDate__c',
            type: 'date-local',
            editable: true,
            typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit"
            }
        }
    ];

export default class ResourceView extends LightningElement {

    @api users;
    @api thisPLI;

    userList;
    columns = columns;
    data;
    
   connectedCallback(){
        this.userList = this.users.filter(user => user.UserRole.Name==this.thisPLI.Rol__c);

        console.log('Esta es la listaaaaaaaa-----------'+this.userList); 
        return this.userList;     

    }  
 

   /*   handleSave(event) {

    const updatedFields = event.detail.draftValues;
    console.log('ASI SALE DEL HIJO---------'+JSON.stringify(updatedFields));

         
        const resources = new CustomEvent('resalocated', {
            detail: {
                updatedFields
            }
        });
    this.dispatchEvent(resources); */

   handleSave(event){

        const datesForResource = event.detail.draftValues;
        console.log('ASI esta compuesto el draft values---------'+JSON.stringify(datesForResource));


       /* const updatedFields = this.template.querySelector('lightning-datatable').getSelectedRows();
       console.log('ESTO ES LO QUE SE SELECCIONO---------'+JSON.stringify(updatedFields)); */
       
       /* datesForResource.push(updatedFields); */
       
       console.log('ASI SALE DEL HIJO---------'+JSON.stringify(datesForResource));
       const resources = new CustomEvent('resalocated', {
            detail: {
                datesForResource
            }
        });
    this.dispatchEvent(resources)
   }



}
    
    
    // Prepare the record IDs for getRecordNotifyChange()
    
        // Pass edited fields to the updateContacts Apex controller
        /*  const result = updateContacts({data: updatedFields}); 
        console.log(JSON.stringify("Apex update result: "+ updatedFields));  */

        // Display fresh data in the datatable
        /* refreshApex(this.userList); */
           
           /*  sendAlocations(); */ 


       
    

    /*handleSave(event){
        const datesForResource = event.detail.draftValues;
        console.log('ASI esta compuesto el draft values---------'+JSON.stringify(datesForResource));
        datesForResource.put()

       const updatedFields = this.template.querySelector('lightning-datatable').getSelectedRows();
       updatedFields.put('Dates for project', datesForResource);
       
       console.log('ASI SALE DEL HIJO---------'+JSON.stringify(updatedFields));
       const resources = new CustomEvent('resalocated', {
            detail: {
                updatedFields
            }
        });
    this.dispatchEvent(resources)

    */


   /*  sendAlocations(){

         let resourcesAlocated = this.updatedFields;
         
        const resources = new CustomEvent('resalocated', {
            detail: {
                resourcesAlocated
            }
        });
    this.dispatchEvent(resources);

    }  
 */
    
    



/* 
    connectedCallback(){
        let result = this.users.filter(user => user.UserRole.Name==this.thisPLI.Rol__c);

         result.forEach(element => this.userList.push({label: element["FirstName"] + ' ' + element["LastName"] + " " + element["Rate_PerHour__c"], value: element["Id"]}));
         console.log('Esta es la listaaaaaaaa-----------'+this.userList);
        // console.log('ASI VIENE DE MOVIDA------'+JSON.Stringify(this.objetoS));
        // this.objetoS["Record"]= this.value; 
        return this.userList;    

    }

    /* get options() {
        return this.userList;     
    } */

    
    /*
    handleStart(e){
        
        this.startDate =e.target.value;
       objetoS.startDate=this.startDate;
       console.log('STARTDATE-------------------------'+JSON.Stringify(this.objetoS));
       temporalAssign();
       
        
    }

    handleEnd(evt){
        this.endDate.push(evt.target.value);
       // this.objetoS["endDate"]=this.endDate;
       console.log('ENDDATE-------------------------'+this.endDate);
    }

    checkValue;

    changecheck(evt){
        this.checkValue = evt.target.checked;
       // this.objetoS["True?"]=this.checkValue;
       // console.log('si funca funca------------------------'+JSON.Stringify(this.objetoS));

    }

    temporalAssign(){
       var tempObject={};
        tempObject["StartDate"]= this.startDate;
        console.log('STARTDATE-------------------------'+JSON.Stringify( tempObject));
        console.log('STARTDATE-------------------------'+ tempObject);

    }
 */
    

[[{"Id":"0054w00000C2GACAA3","Name":"Lucas Perrone","FirstName":"Lucas","LastName":"Perrone","UserRoleId":"00E4w000002PEs5EAG","Rate_PerHour__c":50,"UserRole":{"Name":"Consultant","Id":"00E4w000002PEs5EAG"}},
{"Id":"0054w00000C2GcDAAV","Name":"Integration User","FirstName":"Integration","LastName":"User","UserRoleId":"00E4w000002PEs5EAG","Rate_PerHour__c":50,"UserRole":{"Name":"Consultant","Id":"00E4w000002PEs5EAG"}}],
[{"StartDate__c":"2022-10-10T19:21:00.000Z","EndDate__c":"2022-10-11T19:21:00.000Z","id":"row-0"},{"StartDate__c":"2022-10-29T19:22:00.000Z","EndDate__c":"2022-10-30T19:22:00.000Z","id":"row-1"}]]

[{"StartDate__c":"2022-10-29T20:16:00.000Z","EndDate__c":"2022-10-29T20:16:00.000Z","id":"row-0"},{"StartDate__c":"2022-10-20T20:17:00.000Z","EndDate__c":"2022-10-21T20:17:00.000Z","id":"row-1"},[{"Id":"0054w00000C2GACAA3","Name":"Lucas Perrone","FirstName":"Lucas","LastName":"Perrone","UserRoleId":"00E4w000002PEs5EAG","Rate_PerHour__c":50,"UserRole":{"Name":"Consultant","Id":"00E4w000002PEs5EAG"}},{"Id":"0054w00000C2GcDAAV","Name":"Integration User","FirstName":"Integration","LastName":"User","UserRoleId":"00E4w000002PEs5EAG","Rate_PerHour__c":50,"UserRole":{"Name":"Consultant","Id":"00E4w000002PEs5EAG"}}]]