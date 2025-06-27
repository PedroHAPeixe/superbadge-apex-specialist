@IsTest
private class WarehouseCalloutServiceTest {
	// implement your mock callout test here
	@IsTest
	static void mainTest() {
		Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
		Test.startTest();
		Id jobID = System.enqueueJob(new WarehouseCalloutService());
		//System.assertEquals('Queued',aaj.status);
		Test.stopTest();
		AsyncApexJob aaj = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID];
		System.assertEquals('Completed', aaj.Status);
		System.assertEquals(0, aaj.NumberOfErrors);
	}
}