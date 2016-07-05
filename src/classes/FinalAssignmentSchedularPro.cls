/*********************************************************************
 * Description      : Final Assignment Schedular
 * @author          : Hasantha Liyanage
 * @since           : June 14, 2013  
 * Copyright 2011 ABSI. All rights reserved. 
 *********************************************************************/
global with sharing class FinalAssignmentSchedularPro implements Schedulable {
  /*
   * excecute method
   */
  global void execute(SchedulableContext ctx) {
	 Database.executeBatch(new FinalAssignmentControllerBatch(),10);
  }

}