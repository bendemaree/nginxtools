Fancy tool for autmagically managing NGINX virtual host configuration files.  Usage is as follows:

nginxtools [VERB] [OPTION]...

**VERBS**
* *create* Ask nginxtools to automatically create a new site configuration.
* *remove* Removing an existing site configuration.
* list (not yet implemented)

**OPTIONS**
* *nogit* For use with the *create* verb; will NOT set up a git repository if included.
* *skiplogs* For use with the *remove* verb; will skip removal of log files if included.

**EXAMPLE USAGE**
Create a shiny new site using a standard configuration.

    nginxtools create catsaregreat.com

Hate git?  Of course not.  Don't want a repository created for you?  No problem.

    nginxtools create seriouslycatsrule.com nogit

Done with your site, but would like to review server logs?

    nginxtools remove catsinhats.com skiplogs

**THANKS**
Well, gee, thanks for using my script!  Also thanks to trevorriles for brainstorming this thing with me.
