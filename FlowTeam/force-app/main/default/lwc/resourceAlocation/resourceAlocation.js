import { LightningElement, wire, api } from 'lwc';
import getProjectWrapper from '@salesforce/apex/ProjectService.getProjectWrapper';
import createAlocate from '@salesforce/apex/ProjectService.createAlocate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


import ENDDATE_FIELD from '@salesforce/schema/Project_Resource__c.EndDate__c';
import STARTDATE_FIELD from '@salesforce/schema/Project_Resource__c.StartDate__c';
import USER_FIELD from '@salesforce/schema/Project_Resource__c.User__c';
import ROL_FIELD from '@salesforce/schema/Project_Resource__c.Rol__c';
import PROJECT_FIELD from '@salesforce/schema/Project_Resource__c.Project__c';
import Id from '@salesforce/schema/Account.Id';


export default class ResourceAlocation extends LightningElement {

    @api recordId;
    error = undefined;
    thisUsers;
    thisPLI;
    resourcesToAlocate;
    alocateEvent;
    
    
    @wire(getProjectWrapper, { projectId:'$recordId'})//'$recordId'
    wiredRoles({data, error}) {
        if (data) { 
        this.thisPLI = data.thisPLI;
        this.thisUsers= data.thisUsers; 
        console.log('ESTO SON PLI----------',this.thisPLI);
        console.log('ESTO SON Users----------',this.thisUsers); 
              } else if (error) {
         this.error = error;
      }
    }

    handleAlocations(event){
       /*  const updatedFields =this.template.querySelector('lightning-datatable').getSelectedRows(); */

       this.resourcesToAlocate=  event.detail.datesForResource;
       console.log('ASI LE LLEGO AL PADRE------------------------------'+JSON.stringify(this.resourcesToAlocate));
       /* this.resourcesToAlocate.push({ProjectId:this.recordId});
       console.log('LISTO PARA INSERTAR!! ------------------------------'+JSON.stringify(this.resourcesToAlocate)); */
        

    } 
    
   
    async submitAlocte(){

        console.log('LLEGAMOS HASTA ACA--------------------------');
 try {
        await createAlocate({projectId: this.recordId, jsonUsers: JSON.stringify(this.resourcesToAlocate)})
        
            this.dispatchEvent(
        new ShowToastEvent({
          title:  'Success!',
          message:  'Resource Alocated Successfully!',
          variant:  'success'
        }))
            
        } catch (error) {
            console.log('error del catch!!!!--------'+JSON.stringify(error));

           
            this.dispatchEvent(
            new ShowToastEvent({
          title: 'Error!',
          message: error.body.message,
          variant: 'error',
          mode: 'sticky'}))
            
        } 

               

    }

     


}

/* Map<Id,Map<Id,Project_Resource__c>>

 
[Id,{"StartDate__c":"2022-10-29","EndDate__c":"2022-10-30","Id":"0054w00000C2GACAA3"},

Id,{"StartDate__c":"2022-10-30","EndDate__c":"2022-11-01","Id":"0054w00000C2GcDAAV"}]  */

/* jsonUsers='StartDate__c:2022-10-28,EndDate__c:2022-10-29,Id:0054w00000C2GACAA3';
projectId= a014w00000cwFa3AAE

public static void createAlocate(Id projectId, String jsonUsers){

        Map<Id, Project_Resource__c> alocations = (Map<Id, Project_Resource__c>)JSON.deserializeStrict(jsonUsers, Map<Id, Project_Resource__c>.class);

        List<Project_Resource__c> resourcesInsert= new  List<Project_Resource__c> ();

       

        for(Project_Resource__c pro : alocations.values()){
        
        Project_Resource__c proje = new  Project_Resource__c (
                StartDate__c= pro.StartDate__c,
                EndDate__c= pro.EndDate__c,
                User__c= pro.Id,
                Project__c= projectId
                );
                    resourcesInsert.add(proje); 
            }            
   
        try{
          insert resourcesInsert;
           return 'Success: Resources alocated successfully'; 
        }
        catch(Exception ex){
        throw ex;
        }
      } */