################################################################################
# BEGIN: IDENTITY
################################################################################
#version and url details
VER = '78'
URLBASE = 'https://api-3t.sandbox.paypal.com/nvp'
URLREDIRECT = 'https://www.sandbox.paypal.com/incontext'

'''
' Function: Verify Current User
'''
def verifyUser(userId):
    yourSessionUserId = '888888'
    returnVal = False
    
    if userId == yourSessionUserId:
        returnVal = True
        
    return returnVal       

'''
' Function: Fetch Current User ID
'''
def getUserId():
    result = '888888'
    return result

'''
' Function: Record User Payment
'''
def recordPayment(paymentObj):
    userId = paymentObj['userId']
    itemId = paymentObj['itemId']
    transactionId = paymentObj['transactionId']
    paymentStatus = paymentObj['paymentStatus']
    orderTime = paymentObj['orderTime']
    
    #INSERT YOUR CODE TO SAVE THE PAYMENT DATA

'''
' Function: Verify User Payment
'''
def verifyPayment(userId, itemId):
    result = False

    #INSERT YOUR CODE TO QUERY PAYMENT DATA and RETURN TRUE if MATCH FOUND
    
    return result

'''
' Function: Get Payment Information
'''
def getPayment(userId, itemId):
    returnObj = { 'success': true,
                  'error': '',
                  'transactionId': '12345678',
                  'orderTime': '2011-09-29T04:47:51Z',
                  'paymentStatus': 'Pending',
                  'itemId': '123',
                  'userId': '888888' }
    
    return returnObj