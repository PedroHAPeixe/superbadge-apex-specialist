@isTest
public class WarehouseSyncScheduleTest {
	@isTest
	static void testScheduler() {
		// Criar dados necessários para o callout (se for o caso)
		Product2 p = new Product2(Name = 'Test Product', Warehouse_SKU__c = 'dummy_sku');
		insert p;

		// Configurar mock do callout
		Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

		Test.startTest();
		// Agenda o job
		String cronExp = '0 0 1 * * ?'; // todo dia 1h da manhã
		String jobId = System.schedule('WarehouseSyncScheduleJobTest', cronExp, new WarehouseSyncSchedule());
		Test.stopTest();

		// Verificar que o job foi agendado (opcional)
		CronTrigger ct = [SELECT Id, State FROM CronTrigger WHERE Id = :jobId];
		System.assertEquals('WAITING', ct.State, 'Job deve estar aguardando');

		// Opcional: checar se Equipment foi atualizado na fila (com asserts na outra classe de teste)
	}
}