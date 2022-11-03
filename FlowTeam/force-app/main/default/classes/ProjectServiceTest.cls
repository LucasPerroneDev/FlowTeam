@isTest
public with sharing class ProjectServiceTest {

   

    private static Project__c newProject(Id projectId,Id oppId){

        Project__c theProject = new Project__c(
            Name = 'Virgin Airlines',
            Opportunity__c = oppId,
            // Project_Manager__c ='Michael Tester',
            // Quantity_Hours__c = 40,
            // Project_Cost__c = 50000,
            // Squadlead__c = 'Jason Voorhes',
            StartDate__c = Date.Today()+2,
            EndDate__c = Date.Today()+12
            // Total_Amount__c= 75000

        );
        insert theProject;
        return theProject;
    }
    private static List<User> setup() {    
        // Setup 4 Test Users
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        List<User> uu = new List<User>();
    
        while (uu.size() <1) {
          Blob b = Crypto.GenerateAESKey(128);
          String h = EncodingUtil.ConvertTohex(b);
          String uid = h.SubString(0,8);
          User u = new User(Alias = uid, Email= uid + '@myorg.com', 
              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/New_York', UserName= uid + '@myorg.com');      
          uu.add(u);
        }
        insert(uu);
        return uu;
      }
    private static Project_Resource__c newProjectResource (Id prId, Id userId){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        Project_Resource__c PR = new Project_Resource__c(
            Project__c = prId,
            StartDate__c = Date.Today()+2,
            EndDate__c = Date.Today()+12,
            User__c = setup()[0].Id
          );
        return PR;
    }
 
    @isTest

    private static void testProjectResourceTrigger(){
     
        Project__c project = new Project__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+12,Name='Hola');
        insert project;
        User theU = [SELECT Id FROM User LIMIT 1];
        
        
         Project_Resource__c ProjectResourceTestFirst = new Project_Resource__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+6, Project__c=project.Id,User__c=theU.Id);
         
    Test.startTest();
    
    Database.SaveResult result = Database.insert(ProjectResourceTestFirst, true);
    
    Test.stopTest();
    
    System.assert(result.isSuccess());
       
        }

    
     @isTest
    private static void testProjectResourceTriggerTwo(){   
    Project__c project = new Project__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+12,Name='Hola');
    insert project;
    User theU = [SELECT Id FROM User LIMIT 1];    
     Project_Resource__c ProjectResourceTestSecond = new Project_Resource__c(StartDate__c=Date.Today()+10,EndDate__c=Date.Today()+12, Project__c=project.Id,User__c=theU.Id);
     insert ProjectResourceTestSecond;}


    @isTest
     private static void testProjectResourceTriggerThree(){ 
    Project__c project = new Project__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+12,Name='Hola');
    insert project;
    User theU = [SELECT Id FROM User LIMIT 1];
     Project_Resource__c ProjectResourceTestThird = new Project_Resource__c(StartDate__c=Date.Today()+10,EndDate__c=Date.Today()+12, Project__c=project.Id,User__c=theU.Id);
    insert ProjectResourceTestThird;}
     
    // @isTest
    // private static void testProjectResourceTriggerFourth(){
    // Project__c project = new Project__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+12,Name='Hola');
    // insert project;
    // Project_Resource__c ProjectResourceTestFourth = new Project_Resource__c(StartDate__c=Date.Today()+30,EndDate__c=Date.Today()+39, Project__c=project.Id);
    //  insert ProjectResourceTestFourth;}}
     
     //Test Negativo
     @isTest
     private static void testProjectResourceTriggerFourth(){
     Project__c project = new Project__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+12,Name='Hola');
     insert project;
     User theU = [SELECT Id FROM User LIMIT 1];
     Test.startTest();
     Project_Resource__c ProjectResourceTestFourth = new Project_Resource__c(StartDate__c=Date.Today()+30,EndDate__c=Date.Today()+39, Project__c=project.Id,User__c=theU.Id);
     
    Boolean exceptionThrown;
    Boolean expectedExceptionThrown;
    try {

    insert ProjectResourceTestFourth;        

    } catch (Exception e) {
        exceptionThrown = true;

        
         expectedExceptionThrown =  (e.getMessage().contains('Alocation in must be between --')) ? true : false; 
        
    } 
    Test.stopTest();
    System.assertEquals(expectedExceptionThrown, false);
     
    
   }         
    @isTest
    private static void testProjectResourceTriggerFiveth(){
    Project__c project = new Project__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+12,Name='Hola');
    insert project;
    User theU = [SELECT Id FROM User LIMIT 1];
    Project_Resource__c ProjectResourceTestFiveth = new Project_Resource__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+11, Project__c=project.Id,User__c=theU.Id);
    insert ProjectResourceTestFiveth;

     
//     //  try {
//     //     insert ProjectResourceTestFiveth;
//     //     // STUFF to PURPOSEFULLY BREAK...... 
       
//     //     } catch (DmlException e) {
//     //         String message = e.getMessage().contains('Insert failed because in this date the Project-Resource is not available');
//     //         System.assert(e.getMessage().contains('ERROR'), 'message=' + e.getMessage());
//     //     }

        try {
             insert ProjectResourceTestFiveth;
            } catch (Exception e) {
         
             MyException exe = new MyException('Insert failed because in this date the Project-Resource is not available');
             System.debug('ERROR-----------'+e);
             System.debug('ERROR-----------'+exe);
 
             String errorMsg = e.getMessage();
            //  throw new AuraHandledException(ErrorMsg);
         }           
         }

         @isTest
         private static void testProjectResourceTriggerSixth(){
         Project__c project = new Project__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+12,Name='Hola');
         insert project;
         User theU = [SELECT Id FROM User LIMIT 1];
         Test.startTest();
         Project_Resource__c ProjectResourceTestSixth = new Project_Resource__c(StartDate__c=Date.Today()+4,EndDate__c=Date.Today()+5, Project__c=project.Id,User__c=theU.Id);
         
         Boolean exceptionThrown;
         Boolean expectedExceptionThrown;
        try {

        insert ProjectResourceTestSixth;        

        } catch (Exception e) {
        exceptionThrown = true;

        
         expectedExceptionThrown =  (e.getMessage().contains('Resource is not available. Choose another')) ? true : false; 
        
         }
        Test.stopTest();
        System.assertEquals(expectedExceptionThrown, false);
        }

         @isTest
         private static void testProjectResourceTriggerSeventh(){
         Project__c project = new Project__c(StartDate__c=Date.Today()+2,EndDate__c=Date.Today()+12,Name='Hola');
         insert project;
         User theU = [SELECT Id FROM User LIMIT 1];
         Test.startTest();
         Project_Resource__c ProjectResourceTestSeventh = new Project_Resource__c(StartDate__c=Date.Today()+4,EndDate__c=Date.Today()+9, Project__c=project.Id,User__c=theU.Id);
         Boolean exceptionThrown;
         Boolean expectedExceptionThrown;
         try{insert ProjectResourceTestSeventh;}
         catch (Exception e) {
            exceptionThrown = true;
    
            
             expectedExceptionThrown =  (e.getMessage().contains('Alocation must be between --')) ? true : false; 
            
             }
            Test.stopTest();
            System.assertEquals(expectedExceptionThrown, false);}
      
  public class MyException extends Exception {
    public  void CustomEx(){
 }}}
// @isTest
// public with sharing class ProjectServiceTest {



//      private static Project__c newProject(Id projectId,Id oppId){

//          Project__c theProject = new Project__c(
//              Name = 'Virgin Airlines',
//              Opportunity__c = oppId,
//              Project_Manager__c ='Michael Tester',
//              StartDate__c = Date.Today(),
//              EndDate__c = Date.Today()+8,
//              Total_Amount__c= 75000

//          );
//          return theProject;
//      }

//     //  private static User newUser (String Name){

//      private static Project_Resource__c newProjectResource (Id prId, Date fechadeinicio , Date fechadefin ,Id userId){
//          Project_Resource__c PR = new Project_Resource__c(
//              Project__c = prId,
//              StartDate__c = Date.Today()+1,
//             EndDate__c = Date.Today()+6,
//              User__c = '005Dn000000ai5eIAA'
//              // Rol__c = User__r.UserRole.Name
//            );
//         return PR;
//      }

//     @isTest

//     private static void testProjectResourceTrigger(){

        
//         Project__c project = new Project__c(StartDate__c=Date.Today(),EndDate__c=Date.Today()+8,Name='Hola');
//         insert project;

        
        



//         Test.startTest();
//         Project_Resource__c prresource = new Project_Resource__c(StartDate__c=Date.Today()+1,EndDate__c=Date.Today()+6, Project__c=project.Id);
//         insert prresource;

//         Test.stopTest();
//         List<Project_Resource__c> resource = [SELECT Id FROM Project_Resource__c];
//         System.debug('ESTO ES RESOURCE-----'+resource.size());

//         System.assertEquals(4,4);

//     }

// }