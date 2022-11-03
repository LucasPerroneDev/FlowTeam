@isTest
public with sharing class ProjectServiceTest {

   

    private static Project__c newProject(Id projectId,Id oppId){

        Project__c theProject = new Project__c(
            Name = 'Virgin Airlines',
            Opportunity__c = oppId,
            Project_Manager__c ='Michael Tester',
            Quantity_Hs__c = 40,
            Project_Cost__c = 50000,
            Squadlead__c = 'Jason Voorhes',
            StartDate__c = '2022-10-5',
            EndDate__c = '2022-10-15',
            Total_Amount__c= 75000

        );
        return theProject;
    }

    private static Project_Resource__c newProjectResource (Id prId, Id userId){
        Project_Resource__c PR = new ProjectResource__c(
            Project__c = prId,
            Name = 'PR-0010',
            StartDate__c = '2022-10-5',
            EndDate__c = '2022-10-15',
            User__c = '005Dn000000ai5eIAA',
            Rol__c = 'Developer'
          );
        return PR;
    }
 
    @isTest

    private static void testProjectResourceTrigger(){
     
     Project__c projectTest =[SELECT Id, Name, Opportunity__c FROM Project__c ];  
     
     ProjectResource__c ProjectResourceTestFirst = newProjectResource(projectTest.Id,'PR-0011', '2022-10-5', '2022-10-8','005Dn000000ai5eIAA','Developer');
     insert ProjectResourceTestFirst;
        
     ProjectResource__c ProjectResourceTestSecond = newProjectResource(projectTest.Id,'PR-0012', '2022-10-9', '2022-10-12','005Dn000000ai5eIAA','Developer');
     insert ProjectResourceTestSecond;

     ProjectResource__c ProjectResourceTestThird = newProjectResource(projectTest.Id,'PR-0013', '2022-10-13', '2022-10-15','005Dn000000ai5eIAA','Developer');
     insert ProjectResourceTestThird;
     
     //Test Negativo
     ProjectResource__c ProjectResourceTestFourth = newProjectResource(projectTest.Id,'PR-0014', '2022-11-5', '2022-11-14','005Dn000000ai5eIAA','Developer');
     insert ProjectResourceTestFourth;
     
    //  try {
    //     insert ProjectResourceTestFourth;
    //     // STUFF to PURPOSEFULLY BREAK...... 
       
    //     } catch (DmlException e) {
    //         String message = e.getMessage().contains('Insert failed because these dates doesnt match with the Project Dates');
    //         System.assert(e.getMessage().contains('ERROR'), 'message=' + e.getMessage());
    //     }

    try {
        insert ProjectResourceTestFourth;
       } catch (Exception e) {
     
        MyException exe = new MyException('Insert failed because these dates doesnt match with the Project Dates');
        System.debug('ERROR-----------'+e);
        System.debug('ERROR-----------'+exe);

        String errorMsg = e.getMessage();
        throw new AuraHandledException(ErrorMsg);
    }         

     ProjectResource__c ProjectResourceTestFiveth = newProjectResource(projectTest.Id,'PR-0015', '2022-10-5', '2022-10-14','005Dn000000ai5eIAA','Developer');
     insert ProjectResourceTestFiveth;

     
    //  try {
    //     insert ProjectResourceTestFiveth;
    //     // STUFF to PURPOSEFULLY BREAK...... 
       
    //     } catch (DmlException e) {
    //         String message = e.getMessage().contains('Insert failed because in this date the Project-Resource is not available');
    //         System.assert(e.getMessage().contains('ERROR'), 'message=' + e.getMessage());
    //     }

        try {
            insert ProjectResourceTestFiveth;
           } catch (Exception e) {
         
            MyException exe = new MyException('Insert failed because in this date the Project-Resource is not available');
            System.debug('ERROR-----------'+e);
            System.debug('ERROR-----------'+exe);
 
            String errorMsg = e.getMessage();
            throw new AuraHandledException(ErrorMsg);
        }           
        }
//  @isTest    
 public class MyException extends Exception {
    public  void CustomEx(){
}}}