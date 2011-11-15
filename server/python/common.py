import urllib
import urllib2

#merchant details
UID = 'MERCHANT ID'
PASSWORD = 'MERCHANT PASSWORD'
SIG = 'MERCHANT SIGNATURE'
VER = '78'

URLBASE = 'https://api-3t.sandbox.paypal.com/nvp'
URLREDIRECT = 'https://www.sandbox.paypal.com/webscr'

def curl(url, postVals):
    data = urllib.urlencode(postVals)
    req = urllib2.Request(url, data)
    response = urllib2.urlopen(req)
    return response.read()