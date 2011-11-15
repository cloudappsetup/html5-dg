################################################################################
# BEGIN: INVENTORY
################################################################################
def getItem(itemId):
    items = [{'name': 'Mega Shields',
            'number': '123',
            'qty': '1',
            'taxamt': '0',
            'amt': '1.00',
            'desc': 'Unlock the power!',
            'category': 'Digital'},
           {'name': 'Laser Cannon',
            'number': '456',
            'qty': '1',
            'taxamt': '0',
            'amt': '1.25',
            'desc': 'Lock and load!',
            'category': 'Digital'}]
    
    returnObj = {}
    
    for item in items:
        if item['number'] == itemId:
            returnObj = item
    
    return returnObj