import { LightningElement, wire } from 'lwc';
//import getProject from '@salesforce/apex/Taskservice.getProject';
//import getTasks from '@salesforce/apex/Taskservice.getTasks';
import getWrapper from '@salesforce/apex/Taskservice.getWrapper';

const columns = [
    { label: 'Id', fieldName: 'Id',editable: true},
    { label: 'OwnerId', fieldName: 'OwnerId', },
    { label: 'Start date', fieldName: 'Start_Date__c', type: 'date' },
    { label: 'Subject', fieldName: 'Subject', type: 'text' },
    { label: 'Estimated', fieldName: 'TaskEstimatedHs__c', type: 'number' },
    { label: 'WhatId', fieldName: 'WhatId', },
];


export default class Taskhours extends LightningElement {

tarea;
projecto;

dato=[];
columns = columns;


@wire(getWrapper)
project (Result) {
        const { data, error } = Result;
        if (data) {
            
            console.log(data);
            console.log("SOY Project");
            this.projecto = data.projectos;
            this.tarea = data.task;
            
            const dato =data.task;
            this.dato = dato;
            //const dato = data.projectos.Tasks   es indefinido es subquery adentro de Projectos.... no la muestra
            
           
        } else if (error) {
            this.error = error;
            console.log("SOY ERROR");
        }
    }

/*@wire(getTasks)
    task (Result) {
            const { data, error } = Result;
            if (data) {
                
                console.log(data);
                console.log("SOY Task");
                this.dat = data;
                
               
            } else if (error) {
                this.error = error;
                console.log("SOY ERROR");
            }
        }*/


}