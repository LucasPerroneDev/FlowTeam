public with sharing class Taskservice {

    @AuraEnabled (cacheable =true)
    public static List<Colpayo__c> getTasks (){

        return [SELECT Name,HsCargadas__c,HsAcargar__c from Colpayo__c];

    }

   // @AuraEnabled (cacheable =true)
    private static List<Id> getProject (){

        List<Project__c> proj = [SELECT Id,Status__c FROM Project__c ];

        //Guardo y retorno los ids de los modulos completados
        Set<Id> projId = new Set<Id>();
        for(Project__c dummyp : proj){
            projId.add(dummyp.Id);
        }

        return new List<Id>(projId);

    }


    @AuraEnabled(cacheable=true)
    public static Wrapper getWrapper(){
        List<Task> taskId = [SELECT Id,whatId FROM Task WHERE OwnerId =: Userinfo.getUserId()];

        //Armo un SET con los ids whatID para que no se repita los IDs, recordar que varias tareas estan relacionadas al mismo proyecto.
        Set<Id> projectsId = new Set<Id>();
        for(Task dumytask : taskId){
            projectsId.add(dumytask.whatId);
        }

        new List<Id>(projectsId);  //transformo el set en List porque el set no funciona bien... la lsita siempre va genial
        System.debug(projectsId); //en el debug me trae bien los dos ID de los proyectos

        //Uso ese set para traer lo que necesito exclusivamente para mi wrapper
        List<Project__c> projectos = [SELECT Name,(SELECT WhatId,Ownerid, subject, Start_Date__c,TaskEstimatedHs__c from Tasks WHERE OwnerId =: Userinfo.getUserId()) From Project__c WHERE Id =: projectsId];
  
        List<Task> task = [SELECT WhatId,Ownerid, subject, Status,TaskEstimatedHs__c,TaskHsLoaded__c,TaskHsToLoad__c from Task WHERE OwnerId =: Userinfo.getUserId() AND WhatId =: projectsId];

        Wrapper projectwrapp= new Wrapper (projectos,task);

        return projectwrapp;
    
    }

// Originalmente tenia
//List<Project__c> projectos = [SELECT Name From Project__c WHERE Id =: projectsId];
//List<Task> task = [SELECT WhatId,Ownerid, subject, Start_Date__c,TaskEstimatedHs__c from Task WHERE OwnerId =: Userinfo.getUserId() AND WhatId =: projectsId];

    public class Wrapper{

        @AuraEnabled
        public List<Project__c> projectos;

        @AuraEnabled
        public List<Task> task;

// originalmente public Wrapper(List<Project__c> projectos,List<Task> task){

        public Wrapper(List<Project__c> projectos,List<Task> task){
            //seteo cada propiedad publica con el valor que entra al constructor y al tenerlas aura enabled las expongo para el wire
            this.projectos = projectos;
            this.task = task;
        }
    }





    }




