public with sharing class WarehouseCalloutService implements Queueable, Database.AllowsCallouts {
	public List<Product2> equip = new List<Product2>();
	private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';

	public void execute(QueueableContext context) {
		//System.debug('Equipments'+equip );
		Http h = new Http();
		HttpRequest httpReq = new HttpRequest();
		httpReq.setMethod('GET');
		httpReq.setHeader('Content-Type','application/json');
		httpReq.setEndpoint(WAREHOUSE_URL);
		HttpResponse res = h.send(httpReq);
		List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());
		System.debug(results.size());
		for(Object fld : results){
			Map<String,Object> entry = (Map<String,Object>)fld;
			equip.add(new Product2(
				Warehouse_SKU__c = String.valueOf(entry.get('_id')+''),
				Cost__c = Decimal.valueOf(entry.get('cost')+''),
				Lifespan_Months__c = Decimal.valueOf(entry.get('lifespan')+''),
				Maintenance_Cycle__c = Decimal.valueOf(entry.get('maintenanceperiod')+''),
				Name = String.valueOf(entry.get('name')+''),
				QuantityUnitOfMeasure = String.valueOf(entry.get('quantity')+''),
				Replacement_Part__c = Boolean.valueOf(entry.get('replacement') +''),
				StockKeepingUnit = String.valueOf(entry.get('sku')+'')
			));
		}
		if(!equip.isEmpty()) {
			upsert equip Warehouse_SKU__c;
			System.debug('list got updated. Size: '+equip.size());
		}
	}
}