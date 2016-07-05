global with sharing class CustomerStatusUpdateSchedular implements Schedulable {
	 global void execute(SchedulableContext ctx) {
	 	Database.executeBatch(new CustomerStatusUpdateBatch(),10);
	 }
}