import { LightningElement } from 'lwc';

const columns = [  
    { label: 'Id', fieldName: 'Id' },  
    { label: 'OwnerId', fieldName: 'OwnerId' },  
    { label: 'Start Date', fieldName: 'Start_Date__C', type:'date' },   
    { label: 'Subject', fieldName: 'Subject', type : 'text' },  
    { label: 'Estimated', fieldName: 'TaskEstimatedHs__C' },  
    { label: 'WhatId', fieldName: 'WhatId' }
];  


export default class ChildTask extends LightningElement {

    
    
}