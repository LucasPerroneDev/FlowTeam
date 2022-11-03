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
       /*  ProjectLineItem__c PLIRol = [SELECT Id,Rol__c FROM ProjectLineItem__c WHERE Project__c=:projectId]; */

    List<String> roles = new List<String>();

     for(ProjectLineItem__c rolesPli : PLIRol){
     roles.add(rolesPli.Rol__c);
     } 

     System.debug('Estos son los roles requeridos por proyecto ' +PLIRol);
     Project__c project= [SELECT Id,Name,StartDate__c,EndDate__c FROM Project__c WHERE Id=:projectId];


     Date initProject = project.StartDate__c;

     Date endProject = project.EndDate__c;
     

     System.debug('Estas son las fechas de finalizacion de projectos ' +endProject);



     List<User> userList = [SELECT Id, Name, FirstName, LastName, UserRole.Name, Rate_PerHour__c,(SELECT Id, StartDate__c,EndDate__c FROM Project_Resources__r ) FROM User WHERE UserRole.Name IN :roles]; 
     System.debug('Estos son los Usuarios encontrados ' +userList);//WHERE EndDate__c<:endProject

   
     
     List<Project_Resource__c> projectResourceQueryMap = new  List<Project_Resource__c>([SELECT Id, StartDate__c, EndDate__c, User__c  FROM Project_Resource__c WHERE User__c IN: userList]); 
    System.debug('Estos son los Project resource de los usuarios -----'+projectResourceQueryMap);

             
        Set<Id> usersInCorrect = new Set<Id>();
         Set<Id> usersCorrect = new Set<Id>();

       for(Project_Resource__c projectResource : projectResourceQueryMap){
                if(projectResource.StartDate__c < initProject &&
               projectResource.EndDate__c < initProject){
                System.debug('No coincide fechas -----'+projectResource.User__c);

                usersCorrect.add(projectResource.User__c);


            }else if(projectResource.StartDate__c < initProject &&
               projectResource.EndDate__c > initProject && 
            projectResource.EndDate__c < endProject){

                /* 29/10 < 3/11 26/10
                5/11 > 3/11 26/10
                5/11 < 7/11 31/10
               */

               System.debug('Proyect start date = projectResource.EndDate__c ------ ');
               usersCorrect.add(projectResource.User__c);
               /* EndDate__c = projec.EndDate__c */

           }else if(projectResource.StartDate__c 
           > initProject &&
            projectResource.EndDate__c
            > initProject && 
               projectResource.EndDate__c
               < endProject){

           /* 4/11 > 3/11
           5/11 > 3/11
           5/11 < 7/11 */


           /* StartDate__c = projec.StartDate__c, */

           System.debug('Proyect end date = projectResource.EndDate__c----');
           usersCorrect.add(projectResource.User__c);

        }else if(projectResource.StartDate__c > initProject &&
               projectResource.EndDate__c > initProject && 
               projectResource.EndDate__c > endProject){

           
          /*  4/11 > 3/11
           8/11 > 3/11
           8/11 > 7/11 */

           /* StartDate__c = projec.StartDate__c, */
         
           System.debug('inicio ok - fin = el startdate del proyecto viejo----');
           usersCorrect.add(projectResource.User__c);

        }else if(projectResource.StartDate__c
            < initProject &&
            projectResource.EndDate__c 
           == initProject){
           /* 
           2/11 < 3/11
           3/11 == 3/11
           3/11 < 7/11 */

          
           /* projec.StartDate__c = projec.StartDate__c.addDays(1); */
          /*  EndDate__c = projec.EndDate__c */

       
          System.debug('Proyect start date = projectResource.StartDate__c +1----');
          usersCorrect.add(projectResource.User__c);

        }else if(projectResource.StartDate__c > initProject &&
               projectResource.EndDate__c > initProject && 
               projectResource.EndDate__c == endProject){

           System.debug('inicio ok, fin va a ser inicio del proyecto ya asignado +1----');
          usersCorrect.add(projectResource.User__c);

        }else if(projectResource.StartDate__c == initProject &&
               projectResource.EndDate__c > initProject && 
               projectResource.EndDate__c < endProject){
                   System.debug('inicio fin del proyecto del usuario +1, fin ok----');
          usersCorrect.add(projectResource.User__c);

        }else{
        usersInCorrect.add(projectResource.User__c);
        

        System.debug('Usuario no elegible ------'+projectResource.User__c);
        }   
       }
       System.debug('Ids de usuarios ok -----'+usersCorrect);
       System.debug('Ids de usuarios NOT ok -----'+usersInCorrect);

       List<User> userListCorrect = [SELECT Id, Name, FirstName, LastName, UserRole.Name, Rate_PerHour__c FROM User WHERE Id NOT IN :usersInCorrect AND Id IN:usersCorrect]; 


       for(User user : userList){
           if(user.Project_Resources__r.isEmpty()){

               userListCorrect.add(user);
               System.debug('Lo agrego porque no tiene proyectos');            
           }        
       }
       System.debug('Estos son los Usuarios elegibles ' +userListCorrect);
       return userListCorrect;
   }


  

 @AuraEnabled(cacheable=false)
  public static void createAlocate(Id projectId, String jsonUsers){


    System.debug('ESTO ES DEL BACK(LOS DATOS A INSERTAR)----------------'+jsonUsers);
   System.debug('ESTO ES DEL BACK (PROYECTO)----------------'+projectId);

   List<Project_Resource__c> alocations = (List<Project_Resource__c>)JSON.deserializeStrict(jsonUsers, List<Project_Resource__c>.class);
   System.debug('ESTO ES DEL BACK (MAPA DE PROJECT RESOURCES)----------------'+alocations);
   try {
        List<Project_Resource__c> resourcesInsert= new  List<Project_Resource__c> ();
        System.debug('Esta el la lista a insertar(vacia)'+resourcesInsert);


             for(Project_Resource__c proj : alocations){
               
             Project_Resource__c proje = new  Project_Resource__c (
                Resource_Assigned_Hours__c = proj.Resource_Assigned_Hours__c,
                StartDate__c= proj.StartDate__c,
                EndDate__c= proj.EndDate__c,
                User__c= proj.Id,
                Project__c= projectId,
                SquadLead__c=proj.SquadLead__c
                );
                    resourcesInsert.add(proje); 
                    

       }   
       System.debug('Esta el la lista a insertar'+resourcesInsert);   

       insert resourcesInsert; 
       
              
       
   } catch (Exception e) {
     
       MyException exe = new MyException('Holaaaaaa');
       System.debug('ERROR-----------'+e);
       System.debug('ERROR-----------'+exe);

       String errorMsg = e.getMessage();
       throw new AuraHandledException(ErrorMsg);
   }
      
       
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

      public class MyException extends Exception {
        public  void CustomEx(){
            
                }
       
      }    
}





/*

 try{
          insert resourcesInsert;
           return 'Success: Resources alocated successfully'; 
        }
        catch(Exception ex){
        throw ex;
        }
      }

*/

// Traeme los usuarios que tengan rol requerido por el PLI
       /*  @AuraEnabled(cacheable=true)
         public static List<User> getUsersByRole(){

          ProjectLineItem__c projectLineList = [SELECT Id,Rol__c FROM ProjectLineItem__c WHERE Project__c=:projectId];
          
          
          return;
         } */

         /*
          public with sharing class ProjectServiceYes {
    @AuraEnabled(cacheable=true)
    public static Map<string, List<user>> allRoleResource(Id projectId){
        

        List<Project_c> theDates =[SELECT Start_Datec, End_Datec FROM Project_c WHERE Project__c.Id=: projectId ];

        List<user> theResources =[SELECT FirstName, LastName, UserRole.Name, Rate_PerHour__c FROM user WHERE UserRole.Name != null ];

        
        Map<string, List<user>> resourcesBypRol = new Map<string, List<user>>();
        
        for (User u : theResources) {
            if (!resourcesByRol.containsKey(u.userrole.name)) {
                resourcesByRol.put(u.UserRole.Name,new List<user>());
            }
            resourcesByRol.get(u.userrole.name).add(u);
        }
       return resourcesByRole;
    }

    @AuraEnabled(cacheable=true)
    public static List<Project_Line_Item__c> allProjectRoles(Id projectId){
        
      
        List<Project_Line_Item__c> ProjectLineItemRoles=[
            SELECT Rol_c, Quantity_Hs_c 
            FROM Project_Line_Item__c 
            WHERE Project__r.Id =: recordId];

        return ProjectLineItemRoles;


    }
 
    public class ProjectWrapper{
        @AuraEnabled
        public List<ProjectLineItem_c> thisPLI = new List<ProjectLineItem_c>();
        
        @AuraEnabled
        public List<User> thisUsers = new List<User>();  
        
  
        public ProjectWrapper(List<ProjectLineItem__c> thisPLI, List<User> thisUsers){
            this.thisUsers = thisUsers;
            this.thisPLI = thisPLI;
        }
    }
  
    @AuraEnabled(cacheable=true)
    public static ProjectWrapper getProjectWrapper(Id projectId){
  
  
        ProjectWrapper projectWrapper = new ProjectWrapper(allProjectRoles(projectId),allRoleResource(projectId));
        return projectWrapper;
    }
  

}
*/  