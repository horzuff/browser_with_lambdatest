import json
import urllib.parse

try:
    from robot.libraries.BuiltIn import BuiltIn
    from robot.libraries.BuiltIn import _Misc
    import robot.api.logger as logger
    from robot.api.deco import keyword
    ROBOT = False
except Exception:
    ROBOT = False



@keyword("Capability")
def caps():
  a = {
      'browserName': 'pw-webkit',
      'browserVersion': 'latest',
      #lambdatest specific options
      'LT:Options': {
        'platform': 'macOS Monterey',
        'build': 'browser-library tests',
        'name': 'browser-library',
        #provide Your username and access key
        'user': 'username',
        'accessKey': 'accesskey',
      }
    }

  # Convert JSON to String
  y = json.dumps(a)
  print("Encoded" + urllib.parse.quote(y))  
  return urllib.parse.quote(y)
