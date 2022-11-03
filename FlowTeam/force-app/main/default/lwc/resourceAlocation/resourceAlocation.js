import { LightningElement, wire, api } from 'lwc';
import getProjectWrapper from '@salesforce/apex/ProjectService.getProjectWrapper';
import ENDDATE_FIELD from '@salesforce/schema/Project_Resource__c.EndDate__c';
import STARTDATE_FIELD from '@salesforce/schema/Project_Resource__c.StartDate__c';
import USER_FIELD from '@salesforce/schema/Project_Resource__c.User__c';
import ROL_FIELD from '@salesforce/schema/Project_Resource__c.Rol__c';
import PROJECT_FIELD from '@salesforce/schema/Project_Resource__c.Project__c';


export default class ResourceAlocation extends LightningElement {

    @api recordId;
    error = undefined;
    thisUsers;
    thisPLI;
    newFields;
    
    
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

    handleProjectResource(event){
      this.newFields=event.detail.resources;
      console.log('EL EVENTO---->'+ JSON.stringify(resources))
      submitAlocte();
    }

    submitAlocte(){

      console.log('LLEGAMOS HASTA ACA--------------------------');

      createAlocate(this.recordId, {data: this.resourcesToAlocate})
      .then(
          this.dispatchEvent(
      new ShowToastEvent({
        title:  'Success!',
        message:  'Resource Alocated Successfully!',
        variant:  'success'
      }))
          .catch(
      new ShowToastEvent({
        title: 'Error!',
        message: 'Resource cannot be alocated',
variant: 'error'})));
      

  }










  //   handleSaveYes(){
  //   saveResource({createAlocate: this.thisUsers})
  //   .then(result=> {
  //       this.thisUsers = {};
  //       console.log('ESTO ES RESULTADO ----'+result);
  //       this.dispatchEvent(new ShowToastEvent({
  //         title: 'Success!',
  //         message: 'Resource Alocated Successfully!',
  //         variant: 'success'

  //       }),);
  //   })
  //   .catch(error=>{
  //       this.error = error.message;
  //   });
  //  }

   
  
 

}