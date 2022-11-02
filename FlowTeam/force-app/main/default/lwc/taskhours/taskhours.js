import { LightningElement , wire, api} from 'lwc';
//import getTasks from '@salesforce/apex/Taskservice.getTasks';
//import getProTas from '@salesforce/apex/Taskservice.getTasks';
import  showProjectData from '@salesforce/apex/Taskservice.showProjectData'; 
import  getProjectWrapper from '@salesforce/apex/Taskservice.getProjectWrapper'; 
       


const columns = [
    { label: 'Id', fieldName: 'Id',editable: true},
    { label: 'OwnerId', fieldName: 'OwnerId', },
    { label: 'Start date', fieldName: 'Start_Date__c', type: 'date' },
    { label: 'Subject', fieldName: 'Subject', type: 'text' },
    { label: 'Estimated', fieldName: 'TaskEstimatedHs__c', type: 'number' },
    { label: 'WhatId', fieldName: 'WhatId', },
];



export default class Taskhours extends LightningElement {


    
}


   /*
    wrapper;
    thisproject;
    thistasks;
  
    
    @wire(showProjectData)
    project({ data, error }) {
        if(data) {
            this.wrapper = data;
            this.thisproject = data.Name;
            this.thistasks = data.taskList;
            console.log('record ==>>> '+JSON.stringify())
            console.log('SOY DATAAAA=>' + data)
            console.log('SOY WRAPPER => ' + this.wrapper )
            console.log('SOY WRAPPER => ' + this.thisproject )
            console.log('SOY WRAPPER => ' + this.thistasks )
        }else if(error) {
            this.error = error;
        }
    }*/
    /*
    @wire(getProjectWrapper)
    project({ data, error }) {
        if(data) {
            this.wrapper = data;
            this.thisproject = data.Name;
            this.thistasks = data.taskList;
            console.log('record ==>>> '+JSON.stringify())
            console.log('SOY DATAAAA=>' + data)
            console.log('SOY WRAPPER => ' + this.thisproject )
            console.log('SOY WRAPPER => ' + this.thistasks )

        }else if(error) {
            this.error = error;
        }
    }*/

    /*
    name;
    thistask
    thisprojecto;
    dato = [];
    columns = columns;
    
    @wire(showProjectData)
    project (Result) {
        const { data, error } = Result;
        if (data) {
            
            console.log('SOY DATAA => ' + data);
            console.log("SOY Project");
            this.thisprojecto = data.Name;
            this.thistask = data.taskList
            this.name =data.projectos;
            console.log(data.taskList + " Soy Task")
            const dato = data;
            this.dato = dato;
            
           
        } else if (error) {
            this.error = error;
            console.log("SOY ERROR");
        }
    }
   */