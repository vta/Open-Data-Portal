# VTA CKAN



http://docs.ckan.org/en/latest/maintaining/installing/install-from-source.html

http://docs.ckan.org/en/latest/maintaining/installing/deployment.html


dataproxy extension:
http://extensions.ckan.org/extension/dataproxy/


http://docs.ckan.org/en/latest/maintaining/data-viewer.html

datapusher installation:
http://docs.ckan.org/projects/datapusher/en/latest/deployment.html

theming:
http://docs.ckan.org/en/ckan-2.2.3/theming.html



Postfix is now set up with a default configuration.  If you need to make
changes, edit
/etc/postfix/main.cf (and others) as needed.  To view Postfix configuration
values, see postconf(1).

After modifying main.cf, be sure to run '/etc/init.d/postfix reload'.


the robots file for development should be at:
src/ckan/ckan/public/robots.txt
and should contain:

    User-agent: *
    Disallow: /


timeline?
Michelle (c4sj is now going to be working with us for the city)




hurdles
------------
 - established data storage through azure? no - check with Kevin
 - UX design, implementation
 - is the API side update an append? or is it a replace?
 - ckan community?
 - data preview






example of regional data portal: opendatapilly.org



# architecture
 - disater recovery
 - automation

# tooling
 - APIs
 - IoT
 - private/public tooling/validation
 - data security enforcement
 
# billing


formalizing this:
- creating an MOU


fix for mapquest tiles:
https://groups.google.com/forum/#!msg/ckan-global-user-group/kytuMOvhXLA/Ne9UD43vBAAJ
https://github.com/ckan/ckan/pull/3174#issuecomment-237216080