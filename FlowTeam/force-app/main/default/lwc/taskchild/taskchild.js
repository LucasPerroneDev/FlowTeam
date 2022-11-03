import { api, LightningElement,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';

const columns = [
    { label: 'WhatId', fieldName: 'WhatId', type:'Id'},
    { label: 'OwnerId', fieldName: 'OwnerId', },
    { label: 'Subject', fieldName: 'Subject', type: 'text' },
    { label: 'Estimated', fieldName: 'TaskEstimatedHs__c', type: 'number' },
    { label: 'HsLoaded', fieldName: 'TaskHsLoaded__c', type: 'number' },
    { label: 'HsToLoad', fieldName: 'TaskHsToLoad__c', type: 'number',editable: true },
    { label: 'Status', fieldName: 'Status', type: 'picklist',editable: true },
    { label: 'Start Task', type: "button", typeAttributes: {  
        label: 'Start',  
        name: 'Edit',  
        title: 'Edit',  
        disabled: false,  
        value: 'edit',  
        iconPosition: 'left'  
    } },
    { label: 'Mark as complete', type: "button", typeAttributes: {  
        label: 'Finish',  
        name: 'Edit',  
        title: 'Edit',  
        disabled: false,  
        value: 'edit',  
        iconPosition: 'left'  
    } }
    
];


export default class Taskchild extends LightningElement {

@api 
task; //llega bien la data cuando la veo por stringify


@api 
projectid;


dato=[];
columns = columns;
draftValues = [];

//rendercalball hizo loop infinito, conectedcallback no da tiempo a que pase la info... get no lo puedo hacer andar !!
connectedCallback(){

    console.log(JSON.stringify(this.task) + "Soy tarea handle2");
    console.log(JSON.stringify(this.projectid) + "Soy tarea handle3");
    const dato = this.task.filter(task => task.WhatId == this.projectid);
    this.dato = dato;
    }

    async handleSave(event) {
        // Convert datatable draft values into record objects
        
        const records = event.detail.draftValues.slice().map((draftValue) => {
        const fields = Object.assign({}, draftValue);
        return { fields };
        });
        console.log(JSON.stringify(event.detail.draftValues) + "Soy draftValues")
        
        // Clear all datatable draft values
        this.draftValues = [];

        try {
            // Update all records in parallel thanks to the UI API
            console.log("soy entre al try");
            const recordUpdatePromises = records.map((record) =>{
            console.log(JSON.stringify(record) + "soy record promise"); // antes no ejecutaba cuando pusimos el console.log rompio algo que empezo a llevar "info" buena o mala al siguiente paso... no anda aun updaterecord
                updateRecord(record)
                
                //updateRecord de forma imperativa?
                //updateRecord({recordInput: record})
                //.then((Rest) => {console.log(Rest)})
                //.catch((error) => {console.log(error)});
            });
            
            
            await Promise.all(recordUpdatePromises);
            console.log(JSON.stringify(recordUpdatePromises) + "soy update promise");
            // Report success with a toast
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contacts updated',
                    variant: 'success'
                })
            );

            // Display fresh data in the datatable
            console.log("soy antes de refresh");
            await refreshApex(this.contacts);
            console.log("soy dsp de refresh");
        } catch (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or reloading contacts',
                    message: 'Hay un error',
                    variant: 'error'
                })
            );
        }
    }
}
/*

handleSave(event) {
    console.log("Hola soy Save Inicial");
    const updatedRecords = event.detail.draftValues

    const updatedData = this.data.map(row => {
    const newRow = Object.assign({}, row);
    const changes = updatedRecords.find(changedElement => changedElement.id === row.id);});
        //return changes ? Object.assign(newRow, changes) : newRow;
    
    console.log("Hola soy Save Final");
    console.log(JSON.stringify(updatedRecords) +"soy draft");
    console.log(JSON.stringify(updatedData) +"soy update");
    console.log(JSON.stringify(newRow) +"soy newrow");
    console.log(JSON.stringify(changes) +"soy changes");
}





handleclick(){
    
    console.log("SOY Render");
    console.log(tareas + "Soy Tareas")
     const dato = tareas;
     this.dato = dato;
     console.log(tareas + "Soy Tareas final");
    

}

}*/