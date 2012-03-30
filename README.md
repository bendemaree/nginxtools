nginxtools
==========
Fancy tool for automagically managing NGINX virtual host configuration files.  The purpose of this package is to allow you to work with your site directories as environments that you can enable and disable, add and remove.

##Features##
The tool does not encompass NGINX's entire configuration featureset.  However, the tool is also very easy to use.  It also generates completely legible configuration files, so if you'd like to modify them with more complex settings, that should be business as usual.  Here are a few things it can do for you, however:

* Create a new site content folder and initialize it as a git repository
* Auto-generate virtual host configuration files
* Set up logging to custom log directories
* Treat sites as whole objects that you can activate and deactivate
* Cleanly remove a site and all its files, with the option of retaining log files

##Usage##

nginxtools **[verb]** *sitename.com* **[option]...**

##Verbs##
* **create** Ask nginxtools to automatically create a new site configuration. Use in conjunction with the nogit option
* **remove** Remove an existing site configuration. Use in conjunction with the skiplogs option.
* **list** Display lists of available and enabled sites.
* **enable** Enable a disabled site.
* **disable** Disable a site, rendering it invisible.

##Options##
* **nogit** For use with the *create* verb; will NOT set up a git repository if included.
* **skiplogs** For use with the *remove* verb; will skip removal of log files if included.

##Example Usage##
Create a shiny new site using a standard configuration.

    nginxtools create catsaregreat.com

Hate git?  Of course not.  Don't want a repository created for you?  No problem.

    nginxtools create seriouslycatsrule.com nogit

Need to modify site visibility?
    
    nginxtools disable lookatmycat.com
    nginxtools enable cativersity.edu

Done with your site, but would like to review server logs?

    nginxtools remove catsinhats.com skiplogs

##Thanks##
Well, gee, thanks for using my script!  Also thanks to <a href="https://github.com/trevorriles">trevorriles</a> for brainstorming this thing with me.
