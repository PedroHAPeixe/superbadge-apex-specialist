@isTest
public with sharing class MaintenanceRequestHelperTest {

	@testSetup
	static void setupData() {
		Product2 product = new Product2(
			Name = 'Test Product',
			Maintenance_Cycle__c = 10,
			Replacement_Part__c = true
		);
		insert product;

		List<Case> caseList = new List<Case>();
		for (Integer i = 0; i < 5; i++) {
			caseList.add(new Case(
				Type = 'Routine Maintenance',
				Status = 'New',
				Subject = 'Test Case ' + i,
				Date_Reported__c = Date.today(),
				ProductId = product.Id
			));
		}
		insert caseList;

		List<Equipment_Maintenance_Item__c> maintenanceItems = new List<Equipment_Maintenance_Item__c>();
		for (Integer i = 0; i < 5; i++) {
			maintenanceItems.add(new Equipment_Maintenance_Item__c(
				Equipment__c = product.Id,
				Maintenance_Request__c = caseList[i].Id,
				Quantity__c = 10
			));
		}
		insert maintenanceItems;
	}

	@isTest
	public static void testPositiveScenario() {
		List<Case> cases = [SELECT Id, Status, Type FROM Case WHERE Type = 'Routine Maintenance' LIMIT 1];
		Case c = cases[0];
		c.Status = 'Closed';
		Test.startTest();
		update c;
		Test.stopTest();
		Integer createdCases = [SELECT count() FROM Case WHERE ParentId = :c.Id];
		System.assertEquals(1, createdCases, 'Uma nova requisição deveria ter sido criada.');
	}

	@isTest
	public static void testNegativeScenario() {
		List<Case> cases = [SELECT Id, Status, Type FROM Case WHERE Type = 'Routine Maintenance' LIMIT 1];
		Case c = cases[0];
		c.Status = 'Working';
		Test.startTest();
		update c;
		Test.stopTest();
		Integer createdCases = [SELECT count() FROM Case WHERE ParentId = :c.Id];
		System.assertEquals(0, createdCases, 'Nenhuma requisição deveria ter sido criada.');
	}

	@isTest
	public static void testBulkScenario() {
		List<Case> cases = [SELECT Id, Status, Type FROM Case WHERE Type = 'Routine Maintenance'];
		for (Case c : cases) {
			c.Status = 'Closed';
		}
		Test.startTest();
		update cases;
		Test.stopTest();
		// Espera-se que uma nova requisição tenha sido criada para cada caso fechado
		Integer createdCases = [SELECT count() FROM Case WHERE ParentId != NULL];
		System.assertEquals(cases.size(), createdCases, 'Deveria ter criado uma nova requisição para cada caso fechado.');
	}

}