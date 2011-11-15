import os
import sys
import string
import urllib

sys.path.append(os.path.join(os.path.dirname(__file__), './'))

import pptransact
import jsonlib as json

transact = pptransact

#parse query string parameters into dictionary
params = {}
string_split = [s for s in os.environ['QUERY_STRING'].split('&') if s]
for item in string_split:
    key,value = item.split('=')
    if key != 'domain_unverified':
        params[key] = urllib.unquote(value)

returnObj = ''
if 'data' in params:
    data = params['data']
    data = string.split(data, '|')
    returnObj = transact.commitPayment(data[1], params['PayerID'], params['token'], data[0], data[2])

print '''\
Content-type: text/html; charset=UTF-8
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Thank you</title>

<script>
function closeFlow() {
'''
print 'parent.pptransact.releaseDG(%s);' % json.write(returnObj)    
print '''\
}

</script>
</head>

<body onload="closeFlow()">
<div style="background-color:#FFF;height:700px;width:300px; border-radius:8px;padding:20px;">
    Thank you for the purchase!<br />
    <button id="close" onclick="closeFlow();">close</button>
</div>
</body>
</html>
'''