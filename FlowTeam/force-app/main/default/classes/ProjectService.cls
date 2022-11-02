public with sharing class ProjectService {

  //Traeme los roles de projectLineItem que se encuentren en el proyecto pasado por parametro 

     @AuraEnabled(cacheable=true)
      public static List<ProjectLineItem__c> getRolesByProjectLI(Id projectId){
       List<ProjectLineItem__c> projectLineList = [SELECT Id,Rol__c,Quantity_Hs__c,Project__c,Hours_Pending__c,Assign_Hours__c FROM ProjectLineItem__c WHERE Project__c=:projectId];

       return projectLineList;
      }

    //Ahora traeme los projectResource que se encuentre en el proyecto pasado por parametro
    @AuraEnabled(cacheable=true)
    public static List<User> getUsersByPLI (Id projectId){

      List<ProjectLineItem__c> PLIRol = [SELECT Id,Rol__c FROM ProjectLineItem__c WHERE Project__c=:projectId];

      List<String> roles = new List<String>();

      for(ProjectLineItem__c rolesPli : PLIRol){
      roles.add(rolesPli.Rol__c);
      }

      System.debug('Estos son los roles requeridos por proyecto ' +PLIRol);
      Project__c project= [SELECT Id,Name,StartDate__c,EndDate__c FROM Project__c WHERE Id=:projectId];
      Date initProject = project.StartDate__c;
      Date endProject = project.EndDate__c;
      System.debug('Estas son las fechas de finalizacion de projectos ' +endProject);

      List<User> userList = [SELECT Id, FirstName, LastName, UserRole.Name, Rate_PerHour__c,(SELECT Id, StartDate__c,EndDate__c FROM Project_Resources__r WHERE EndDate__c<:endProject) FROM User WHERE UserRole.Name IN :roles];
      System.debug('Estos son los Usuarios encontrados ' +userList);

      List<User> usersElegibles = new List<User>();


        for(User user : userList){
            if(user.Project_Resources__r.isEmpty()){
                System.debug('Es Null');
                usersElegibles.add(user);      
            }else{
                System.debug('NO Es Null');   
          }         
        }

          System.debug('Estos son los Usuarios elegibles ' +usersElegibles);
      return usersElegibles;
    }

    public class ProjectWrapper{
      @AuraEnabled
      public List<ProjectLineItem__c> thisPLI = new List<ProjectLineItem__c>();
      
      @AuraEnabled
      public List<User> thisUsers = new List<User>();  
      

      public ProjectWrapper(List<ProjectLineItem__c> thisPLI, List<User> thisUsers){
          this.thisUsers = thisUsers;
          this.thisPLI = thisPLI;
      }
  }

  @AuraEnabled(cacheable=true)
  public static ProjectWrapper getProjectWrapper(Id projectId){


      ProjectWrapper projectWrapper = new ProjectWrapper(getRolesByProjectLI(projectId),getUsersByPLI(projectId));
      return projectWrapper;
  }

  @AuraEnabled(cacheable=false)
       public static void createAlocate(Id projectId, String jsonUsers){

        Map<Id, Project_Resource__c> alocations = (Map<Id, Project_Resource__c>)JSON.deserializeStrict(jsonUsers, Map<Id, Project_Resource__c>.class);

        List<Project_Resource__c> resourcesInsert= new  List<Project_Resource__c> ();

        System.debug('ESTO ES DEL BACK----------------'+jsonUsers);
        System.debug('ESTO ES DEL BACK----------------'+alocations);
        for(Project_Resource__c pro : alocations.values()){
        
          Project_Resource__c proje = new  Project_Resource__c (
                  StartDate__c= pro.StartDate__c,
                  EndDate__c= pro.EndDate__c,
                  User__c= pro.Id,
                  Project__c= projectId
                  );
                      resourcesInsert.add(proje); 
              }          
              
              insert resourcesInsert;  
     
  
      }}

  
  // @AuraEnabled(cacheable=false)
  // public static void createAlocate(List<Project_Resource__c> projectResourceList){
  //     try{
  //       insert projectResourceList;
       
  //     }
  //   catch(Exception ex){
  //     throw ex;
  //   }
  // }





    


    

    
 


