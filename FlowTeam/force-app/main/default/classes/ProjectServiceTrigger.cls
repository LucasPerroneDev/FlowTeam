public with sharing class ProjectServiceTrigger {

    public static void onBeforeInsert(List<Project_Resource__c> alocations){

        System.debug('TRIGGER ESTO ES lo que dispara ----------------'+alocations);

       // project del trigger alocations
      
        Set<Id> userSet = new  Set<Id>();
        Id projectnow;

        

        Map<Id, List<Project_Resource__c>> projectResourcetoInsert = new Map<Id, List<Project_Resource__c>>();
   
        for(Project_Resource__c proj : alocations){
            if(projectResourcetoInsert.containsKey(proj.User__c)){
                projectResourcetoInsert.get(proj.User__c).add(proj);
                
            }else{
                projectResourcetoInsert.put(proj.User__c, new List<Project_Resource__c>{proj});
            }

            userSet.add(proj.User__c);
            projectnow=proj.Project__c;
             
        }

         Project__c project= [SELECT Id,Name,StartDate__c,EndDate__c FROM Project__c WHERE Id=:projectnow];


          Date initProject = project.StartDate__c;
    
          Date endProject = project.EndDate__c;

          
         /*  for(User usuario : userSet){
            if(user.Project_Resources__r.isEmpty()){
                Project_Resource__c proje = new  Project_Resource__c (
                   User__c= user.Id
                
                );
                    insert proje; 
          } */


        List<Project_Resource__c> projectResources = new  List<Project_Resource__c>([SELECT Id, StartDate__c, EndDate__c, User__c  FROM Project_Resource__c WHERE User__c IN: userSet]); 
         System.debug('TRIGGER Estos son los Project resource de los usuarios -----'+projectResources);

         if(projectResources.isEmpty() || projectResources== null){
            System.debug('ES NULLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL');

            for(Project_Resource__c proj : alocations){

         if((proj.StartDate__c < initProject || proj.EndDate__c > endProject) || (proj.StartDate__c > endProject || proj.EndDate__c < initProject)){
                proj.Project__c.addError('Alocation must be between --'+initProject+' and '+endProject);
         }

        /* if(proj.StartDate__c > initProject && proj.EndDate__c < endProject){
                proj.Project__c.addError('Alocation must be splited. Available dates --'+initProject+' to '+proj.StartDate__c.addDays(-1)+ ' and '+proj.EndDate__c.addDays(1) +'to '+endProject);
         } */


        }
            

         }else{
            System.debug('NO   ES NULLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL');

             for(Project_Resource__c proje : alocations){

         if((proje.StartDate__c < initProject || proje.EndDate__c > endProject) || (proje.StartDate__c > endProject || proje.EndDate__c < initProject)){
                proje.Project__c.addError('Alocation must be between --'+initProject+' and '+endProject);
         }
            
         

         for(Project_Resource__c proj : alocations){

         if((proj.StartDate__c < initProject || proj.EndDate__c > endProject) || (proj.StartDate__c > endProject || proj.EndDate__c < initProject)){
                proj.Project__c.addError('Alocation in must be between --'+initProject+' and '+endProject);
         }
        }

       /*   if(proj.StartDate__c > initProject && proj.EndDate__c < endProject){
                proj.Project__c.addError('Alocation must be splited. Available dates --'+initProject+' to '+proj.StartDate__c.addDays(-1)+ ' and '+proj.EndDate__c.addDays(1) +'to '+endProject);
         }
 */


        }

         

    List<Project_Resource__c> resourcesUpdate = new List<Project_Resource__c>();

        List<User> userListOk = [SELECT Id, Name, FirstName, LastName, UserRole.Name, Rate_PerHour__c,(SELECT Id, StartDate__c,EndDate__c FROM Project_Resources__r ) FROM User WHERE Id IN :userSet]; 
          System.debug('Estos son los Usuarios encontrados ' +userListOk);//WHERE EndDate__c<:endProject

          //mapa de users con sus projectresources de query.

          Map<Id, List<Project_Resource__c>> userByProj = new Map<Id, List<Project_Resource__c>>();

          for(User user : userListOk){
        
            userByProj.put(user.Id, user.Project_Resources__r);
          }

          

          

             Map<Id, List<Date>> mapDatesOk = dateCalculator(project, userByProj);
            System.debug('Este es el mapa que traigo del metodo--- ' +mapDatesOk);

            for(Id iduser : projectResourcetoInsert.keySet()){
                for(Project_Resource__c projecto : projectResourcetoInsert.get(iduser)){
                    System.debug('LLEGAMOS ACA?--------' +projectResourcetoInsert.get(iduser));
                  if(!(mapDatesOk.get(iduser).contains(projecto.StartDate__c))){
                    projecto.StartDate__c.addError('Resource is not available. Choose another Start Date'+mapDatesOk.get(iduser));
                  }else if(!(mapDatesOk.get(iduser).contains(projecto.EndDate__c))){
                     projecto.EndDate__c.addError('Resource is not available. Choose another End Date'+mapDatesOk.get(iduser));



                  }else if(!(mapDatesOk.get(iduser).contains(projecto.EndDate__c))&&!(mapDatesOk.get(iduser).contains(projecto.StartDate__c))){
                    projecto.EndDate__c.addError('Alocation must be splited. Available dates --'+mapDatesOk.get(iduser));

                  }
                   
               }
            }                     
               }       //dateCalculator(project, userByProj);// anular esto luego
 }


     public static Map<Id,List<Date>> dateCalculator(Project__c project, Map<Id, List<Project_resource__c>> userByProj){

    Map<Id, List<Date>> userWithOkDates = new Map<Id, List<Date>>();

    System.debug('Este es el mapa-------- ' +userByProj.values());

    Integer loopSize;

    //LOOPEO LOS PROJECT RESOURCES QUE TIENE EL USER.

    for(Id key: userByProj.keySet()){
        System.debug('Usando keySet--------------- ' +userByProj.keySet());
         
         for(Project_resource__c proj :userByProj.get(key)){
             System.debug('Usando keySet sin usar 3 for--------------- ' +proj.StartDate__c);
             if(proj.StartDate__c < project.StartDate__c && proj.EndDate__c < project.StartDate__c || proj.StartDate__c > project.EndDate__c && proj.EndDate__c > project.EndDate__c){

           
        
        }else if((proj.StartDate__c < project.StartDate__c && proj.EndDate__c < project.EndDate__c) && (proj.StartDate__c < project.EndDate__c &&
        proj.EndDate__c > project.StartDate__c)){ 

            List<Date> userDates = new  List<Date>();
           /*
		    userDates.add(proj.StartDate__c+(proj.StartDate__c.daysBetween(proj.EndDate__c))+proj.EndDate__c); */
                
            loopSize = (proj.EndDate__c).daysBetween(project.EndDate__c);
            for(Integer i = 1; i <= loopSize; i++){
                Date addingDate = proj.EndDate__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                Date myDT = Date.newInstance(year_p, month_p, day_p);
                userDates.add(myDT);
                //System.debug('fecha armadaaa myDT--------------- ' +myDT);
            }
            
            System.debug('fecha armadaaa myDT inicio en fin de user y fin en fin de pryecto--------------- ' +userDates);
            
		    userWithOkDates.put(key, userDates);

        }else if((proj.StartDate__c > project.StartDate__c && proj.EndDate__c > project.EndDate__c) && (proj.StartDate__c < project.EndDate__c &&
        proj.EndDate__c > project.StartDate__c)){

            List<Date> userDates = new  List<Date>();
           /*
		    userDates.add(proj.StartDate__c+(proj.StartDate__c.daysBetween(proj.EndDate__c))+proj.EndDate__c); */
                
            loopSize = (project.StartDate__c).daysBetween(proj.StartDate__c);
            for(Integer i = 1; i < loopSize; i++){
                Date addingDate = project.StartDate__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                Date myDT = Date.newInstance(year_p, month_p, day_p);
                userDates.add(myDT);
                userDates.add(project.StartDate__c);
                //System.debug('fecha armadaaa myDT--------------- ' +myDT);
            }
            
            System.debug('fecha armadaaa myDT inicio proyecto fin inicio del user--------------- ' +userDates);
            
		    userWithOkDates.put(key, userDates);
//------------------------------------------------------------------------------
        }else if((proj.StartDate__c > project.StartDate__c && proj.EndDate__c < project.EndDate__c) && (proj.StartDate__c < project.EndDate__c &&
        proj.EndDate__c < project.EndDate__c)){

              List<Date> userDates = new  List<Date>();
           /*
		    userDates.add(proj.StartDate__c+(proj.StartDate__c.daysBetween(proj.EndDate__c))+proj.EndDate__c); */
                
            loopSize = (project.StartDate__c).daysBetween(proj.StartDate__c);
            for(Integer i = 1; i < loopSize; i++){
                Date addingDate = project.StartDate__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                Date myDT = Date.newInstance(year_p, month_p, day_p);
                userDates.add(myDT);
                userDates.add(project.StartDate__c);
                //System.debug('fecha armadaaa myDT--------------- ' +myDT);
            }

             loopSize = (proj.EndDate__c).daysBetween(project.EndDate__c);
            for(Integer i = 1; i <= loopSize; i++){
                Date addingDate = proj.EndDate__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                Date myDT = Date.newInstance(year_p, month_p, day_p);
                userDates.add(myDT);
                //System.debug('fecha armadaaa myDT--------------- ' +myDT);
            }
            
            System.debug('fecha armadaaa myDT con una parte inicio y otra fin--------------- ' +userDates);
            
		    userWithOkDates.put(key, userDates);
//----------------------------------------------------------------------
        } else if((proj.StartDate__c == project.StartDate__c && proj.EndDate__c < project.EndDate__c) && (proj.StartDate__c < project.EndDate__c &&
        proj.EndDate__c > project.StartDate__c)){

            List<Date> userDates = new  List<Date>();
           /*
		    userDates.add(proj.StartDate__c+(proj.StartDate__c.daysBetween(proj.EndDate__c))+proj.EndDate__c); */
                
            loopSize = (proj.EndDate__c).daysBetween(project.EndDate__c);
            for(Integer i = 1; i <= loopSize; i++){
                Date addingDate = proj.EndDate__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                Date myDT = Date.newInstance(year_p, month_p, day_p);
                userDates.add(myDT);
                
                //System.debug('fecha armadaaa myDT--------------- ' +myDT);
            }
            
            System.debug('fecha armadaaa myDT--------------- ' +userDates);
            
		    userWithOkDates.put(key, userDates);

//---------------------------------------------------------------------------

        }else if((proj.StartDate__c > project.StartDate__c && proj.EndDate__c == project.EndDate__c) && (proj.StartDate__c < project.EndDate__c &&
        proj.EndDate__c > project.StartDate__c)){
            
 List<Date> userDates = new  List<Date>();
           /*
		    userDates.add(proj.StartDate__c+(proj.StartDate__c.daysBetween(proj.EndDate__c))+proj.EndDate__c); */
                
            loopSize = (project.StartDate__c).daysBetween(proj.StartDate__c);
            for(Integer i = 1; i < loopSize; i++){
                Date addingDate = project.StartDate__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                Date myDT = Date.newInstance(year_p, month_p, day_p);
                userDates.add(myDT);
                userDates.add(project.StartDate__c);
                //System.debug('fecha armadaaa myDT--------------- ' +myDT);
            }
            
            System.debug('fecha armadaaa myDT--------------- ' +userDates);
            
		    userWithOkDates.put(key, userDates);
//---------------------------------------------------------------------------
        }else if((proj.StartDate__c < project.StartDate__c && proj.EndDate__c == project.StartDate__c) && (proj.StartDate__c < project.EndDate__c &&
        proj.EndDate__c < project.EndDate__c)){

            List<Date> userDates = new  List<Date>();
           /*
		    userDates.add(proj.StartDate__c+(proj.StartDate__c.daysBetween(proj.EndDate__c))+proj.EndDate__c); */
                
            loopSize = (project.StartDate__c).daysBetween(project.EndDate__c);
            for(Integer i = 1; i < loopSize; i++){
                Date addingDate = project.StartDate__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                Date myDT = Date.newInstance(year_p, month_p, day_p);
                userDates.add(myDT);
                //System.debug('fecha armadaaa myDT--------------- ' +myDT);
            }
            
            System.debug('fecha armadaaa myDT--------------- ' +userDates);
            
		    userWithOkDates.put(key, userDates);
//----------------------------------------------------------------------------
        }else if((proj.StartDate__c == project.EndDate__c && proj.EndDate__c > project.StartDate__c) && (proj.StartDate__c > project.StartDate__c &&
        proj.EndDate__c < project.StartDate__c)){

            List<Date> userDates = new  List<Date>();
           /*
		    userDates.add(proj.StartDate__c+(proj.StartDate__c.daysBetween(proj.EndDate__c))+proj.EndDate__c); */
                
            loopSize = (project.StartDate__c).daysBetween(project.EndDate__c);
            for(Integer i = 1; i < loopSize; i++){
                Date addingDAte = project.StartDate__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                Date myDT = Date.newInstance(year_p, month_p, day_p);
                userDates.add(myDT);
                userDates.add(project.StartDate__c);
                //System.debug('fecha armadaaa myDT--------------- ' +myDT);
            }
            
            System.debug('fecha armadaaa myDT--------------- ' +userDates);
            
		    userWithOkDates.put(key, userDates);

        }else if(proj.StartDate__c == project.StartDate__c && proj.EndDate__c > project.EndDate__c){

            List<Date> userDates = new  List<Date>();
           /*
		    userDates.add(proj.StartDate__c+(proj.StartDate__c.daysBetween(proj.EndDate__c))+proj.EndDate__c); */
                
            loopSize = (project.StartDate__c).daysBetween(proj.StartDate__c);
            for(Integer i = 1; i < loopSize; i++){
                Date addingDAte = project.StartDate__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                Date myDT = Date.newInstance(year_p, month_p, day_p);
                userDates.add(myDT);
                userDates.add(project.StartDate__c);
                //System.debug('fecha armadaaa myDT--------------- ' +myDT);
            }
            
            System.debug('fecha armadaaa myDT--------------- ' +userDates);
            
		    userWithOkDates.put(key, userDates);


        }
        System.debug('Esta es el mapa lleno hasta ahora------------ ' +userWithOkDates);        
             }
         }
         
         return userWithOkDates;
    } 
}




/* trigger getDates on Opportunity (before insert, before update) {
    Integer loopSize = 0;
    String str = '';
    List<Opportunity> oppList = new List<Opportunity>();
    for(Opportunity o : Trigger.new){
        if(o.Start_Date__c < o.CloseDate){
            System.debug('INSIDE THE LOOOP');
            loopSize = (o.Start_Date__c).daysBetween(o.CloseDate);
            for(Integer i = 2; i <= loopSize; i++){
                Date addingDAte = o.Start_Date__c.addDays(i);
                Integer year_p = addingDate.year();
                Integer month_p = addingDate.month();
                Integer day_p = addingDate.day();
                DateTime myDT = DateTime.newInstanceGmt(year_p, month_p, day_p);
                str = str+ myDT.format('MMMM d, yyyy') + '\n';
            }
            o.Available_Dates__c = str;
        }else{
            o.Available_Dates__c = 'Start date is in the future. Make sure close date is after the start date.';
            continue;
        }
    }
} */

/* for(Integer i = 0; i<lista.length; i++){
    lista.EndDate__c[i].daysbetween(lista.StartDate__c[i+1])
    } */


    
    
        

      /*
        }else if(userByProj.get(projmap.StartDate__c) < project.StartDate__c &&
                    userByProj.get(projmap.EndDate__c) > project.StartDate__c && 
                 userByProj.get(projmap.EndDate__c) < project.EndDate__c){
                    List<Date> userDates = new  List<Date>();
		userDates.add(userByProj.get(projmap.StartDate__c));
        userDates.add(userByProj.get(projmap.EndDate__c));
		userWithOkDates.put(projmap.User__c, userDates);
 */
           /*  Set<Id> userDateOk = new  Set<Id>();
        Set<Id> userStarWhenFinishEndOk = new  Set<Id>();
        Set<Id> userStartOkEndWhenBegginAndStartWhernFinishAndEndOK = new  Set<Id>();
        Set<Id> userStartOkEndWhenBeggin = new  Set<Id>();
        Set<Id> userStratWhenFinishPlus1EndOk = new  Set<Id>();
        Set<Id> userStratokEndWhenBegginMinus1 = new  Set<Id>(); */
/* 
                 }else if(projmap.StartDate__c 
                > project.StartDate__c &&
                 projmap.EndDate__c
                 > project.StartDate__c && 
                    projmap.EndDate__c
                    < project.EndDate__c){
                    
                 }else if(projmap.StartDate__c > project.StartDate__c &&
                    projmap.EndDate__c > project.StartDate__c && 
                    projmap.EndDate__c > project.EndDate__c){
                    
                 }else if(projmap.StartDate__c
                 <  project.StartDate__c &&
                 projmap.EndDate__c 
                == project.StartDate__c){
                    
                 }else if(projmap.StartDate__c > project.StartDate__c &&
                    projmap.EndDate__c > project.StartDate__c && 
                    projmap.EndDate__c == project.EndDate__c){
                    
                 } */




   /*  StartDate__c.daysBetween(userStartDate__c)
    StartDate__c.isSameDay(userStartDate__c)
    day()
    Map<Id, List<> 
    11-15
    10-20
    15-20
    1-5
    5-7
    userByProj.StartDate__c 
    userByProj.EndDate__c */
    

//project 10 al 20 // project
//user tiene projectresources 10 al 15 // userByProj
//user tiene disponible del 16 al 20 // result en mapa