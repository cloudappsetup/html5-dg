import os
import re
import cgi
import sys
import time
import urllib
import urllib2
import string

sys.path.append(os.path.join(os.path.dirname(__file__), './'))

import jsonlib as json
import common
import identity
import inventory

print 'Content-Type: text/plain'
print ''

'''
' Class Name: pptransact
' Description: Main transaction class for payment and verification
'''
class pptransact:
    uid = None
    password = None 
    signature = None
    
    success = None
    userId = None
    state = None
    
    #class initialization - set base data
    def init(self):
        returnObj = {'success': true,
                     'userId': getUserId(),
                     'state': 'init'}
        
        return json.write(returnObj)
    
    #fetch redirect with token 
    def getToken(self, userId, itemId, qty):
        itemObj = inventory.getItem(itemId)
        
        if qty is None:
            itemObj['qty'] = 0
        else:
            itemObj['qty'] = qty
			
        dirRoot = "http://%s%s" % (os.environ['HTTP_HOST'], os.environ['PATH_INFO'])
        p = re.compile( '/[a-z,A-Z]+.py$')
        dirRoot = p.sub( '/', dirRoot)
        
        postDetails = {
            'USER': common.UID,
            'PWD': common.PASSWORD,
            'SIGNATURE': common.SIG,
            'METHOD': 'SetExpressCheckout',
            'VERSION': common.VER,
            'PAYMENTREQUEST_0_CURRENCYCODE': 'USD',
            'PAYMENTREQUEST_0_AMT': float(itemObj.get('qty', 0)) * float(itemObj.get('amt', 0)),
            'PAYMENTREQUEST_0_TAXAMT': '0',
            'PAYMENTREQUEST_0_DESC': 'JS Wars',
            'PAYMENTREQUEST_0_PAYMENTACTION': 'Sale',
            'L_PAYMENTREQUEST_0_ITEMCATEGORY0': itemObj.get('category', None),
            'L_PAYMENTREQUEST_0_NAME0': itemObj.get('name', None),
            'L_PAYMENTREQUEST_0_NUMBER0': itemObj.get('number', 0),
            'L_PAYMENTREQUEST_0_QTY0': itemObj.get('qty', 0),
            'L_PAYMENTREQUEST_0_TAXAMT0': '0',
            'L_PAYMENTREQUEST_0_AMT0': itemObj.get('amt', 0),
            'L_PAYMENTREQUEST_0_DESC0': itemObj.get('desc', None),
            'PAYMENTREQUEST_0_SHIPPINGAMT': '0',
            'PAYMENTREQUEST_0_SHIPDISCAMT': '0',
            'PAYMENTREQUEST_0_TAXAMT': '0',
            'PAYMENTREQUEST_0_INSURANCEAMT': '0',
            'PAYMENTREQUEST_0_PAYMENTACTION': 'sale',
            'L_PAYMENTTYPE0': 'sale',
            'PAYMENTREQUEST_0_CUSTOM': '%s,%s' % (userId, itemObj.get('number', 0)),
            'RETURNURL': '%ssuccess.php?data=%s|%s|%s' % (dirRoot, float(itemObj.get('qty', 0)) * float(itemObj.get('amt', 0)), userId, itemId),
            'CANCELURL': '%scancel.php' % dirRoot
        }
		
        response = common.curl(common.URLBASE, postDetails)
        
        #forward the user to login and accept transaction 
        redirect = "%s?token=%s" % (common.URLREDIRECT, dict(cgi.parse_qsl(response))['TOKEN'])
        
        returnObj = { 'success': 'true',
                      'redirecturl': redirect }
        
        print json.write(returnObj)
    
    #commit user purchase
    def commitPayment(self, userId, payerId, token, amt, itemId):
        returnObj = {}
        
        if identity.verifyUser(userId):
            postDetails = { 'USER': UID,
                             'PWD': PASSWORD,
                             'SIGNATURE': SIG,
                             'METHOD': 'DoExpressCheckoutPayment',
                             'VERSION': VER,
                             'AMT': amt,
                             'TOKEN': token,
                             'PAYERID': payerId,
                             'PAYMENTACTION': 'Sale' };
    
            response = common.curl(common.URLBASE, postDetails)
            
            #HACK: On sandbox the first request will fail - we need to wait for 2 seconds and then try again
            if response == false:
                time.sleep(2)
                response = dict(cgi.parse_qsl(common.curl(common.URLBASE, postDetails)))
            else:
                response = dict(cgi.parse_qsl(response))
            
            returnObj['transactionId'] = response["PAYMENTINFO_0_TRANSACTIONID"]
            returnObj['orderTime'] = response["PAYMENTINFO_0_ORDERTIME"]
            returnObj['paymentStatus'] = response["PAYMENTINFO_0_PAYMENTSTATUS"]
            returnObj['itemId'] = itemId
            returnObj['userId'] = userId
            
            recordPayment(returnObj)
        
        return json.write(returnObj)
    
    #verify user purchase
    def verifyPurchase(self, userId, itemId, transactions):
        returnObj = None
		
        #json correctness hack - remove surrounding quotes on each dict in the array
        transactions = urllib2.unquote(transactions)
        p = re.compile('"{')
        transactions = p.sub( '{', transactions)
        p = re.compile('}"')
        transactions = p.sub( '}', transactions)
        
        if transactions is not None:
		    arrTransactions = json.read(transactions)
        
        transactionId = None
        transactions = json.read(transactions)
        
        if transactions is not None:
            for item in transactions:
                if item['itemId'] == itemId:
                    transactionId = item['transactionId']
        
        if transactionId is not None:
            postDetails = { 'USER': common.UID,
                            'PWD': common.PASSWORD,
                            'SIGNATURE': common.SIG,
                            'METHOD': 'GetTransactionDetails',
                            'VERSION': common.VER,
                            'TRANSACTIONID': transactionId }
            
            response = dict(cgi.parse_qsl(common.curl(common.URLBASE, postDetails)))
            custom = string.split(response["CUSTOM"], ',')

            if (identity.getUserId() == custom[0]) and (itemId == custom[1]):
                returnObj = { 'success': 'true',
                              'error': '',
                              'transactionId': response["TRANSACTIONID"],
                              'orderTime': response["ORDERTIME"],
                              'paymentStatus': response["PAYMENTSTATUS"],
                              'itemId': itemId,
                              'userId': userId }
        else:
            returnObj = {'success': 'false',
                         'error': 'Item not found in transaction history'}
        
        print json.write(returnObj)

transact = pptransact()

#parse query string parameters into dictionary
params = {}
string_split = [s for s in os.environ['QUERY_STRING'].split('&') if s]
for item in string_split:
    key,value = item.split('=')
    if key != 'domain_unverified':
        params[key] = urllib.unquote(value)

#determine method to run for class
if 'method' in params:
    if params['method'] == 'getToken':
        transact.getToken(params.get('userId', None), params.get('itemId', None), params.get('qty', None))
    elif params['method'] == 'commitPayment':
        transact.commitPayment(params.get('userId', None), params.get('payerId', None), params.get('token', None), params.get('amt', None), params.get('itemId', None))
    elif params['method'] == 'verifyPayment':
        transact.verifyPurchase(params.get('userId', None), params.get('itemId', None), params.get('transactions', None))
