import os
import sys
import hashlib

activate_this = os.path.join('/usr/lib/ckan/datapusher/bin/activate_this.py')
execfile(activate_this, dict(__file__=activate_this))
print("yes")
import ckanserviceprovider.web as web
os.environ['JOB_CONFIG'] = '/usr/lib/ckan/datapusher/src/datapusher/deployment/datapusher_settings.py'
web.init()

import datapusher.jobs as jobs

application = web.app
