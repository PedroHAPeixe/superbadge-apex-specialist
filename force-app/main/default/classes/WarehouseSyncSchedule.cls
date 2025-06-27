public class WarehouseSyncSchedule implements Schedulable {
	public void execute(SchedulableContext sc) {
		// Enfileira o job que faz o callout
		System.enqueueJob(new WarehouseCalloutService());
	}
}