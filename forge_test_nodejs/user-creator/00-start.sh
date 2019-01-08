#!/bin/sh

export PGUSER=$DBGITLOGIN
export PGPASSWORD=$DBGITPASSWORD

################### Reset the password change for the first connexion GITLAB #################
while [ true ]
	do
	PG=$(psql -h postgresql-git -p 5432 -d $DBGITNAME -c "UPDATE users SET sign_in_count=sign_in_count+1 , password_automatically_set=false, encrypted_password='\$2a\$10\$BJZl5iZK6Txcpkg4L7q/e.jC4NCP2yLz0yrn4y2eDDJSX6H8W.1ri', reset_password_token=null, reset_password_sent_at=null WHERE id=1")

	if [ "$PG" == "UPDATE 1" ]; then
		break
	fi
	sleep 1
done

####################### Get the root token GITLAB ################
while [ true ]
	do
	TOKEN=$(curl --noproxy '*' -s -X POST "http://gitlab/api/v3/session?login=root&password="5iveL\!fe"" | tr "," "\n" | grep token | cut -d":" -f2 | cut -d"\"" -f2)

	if [ ! -z "$TOKEN" ]; then
		break
	fi
	sleep 1
done

################## Add Gitlab System Hook ##############
if [ "$HOOKED" == "1" ]; then
    HOOKS=$(curl --noproxy '*' -X GET -s --header "PRIVATE-TOKEN: $TOKEN" http://gitlab/api/v3/hooks | grep hook)

    if [ -z "$HOOKS" ]; then
    	curl --noproxy '*' -s -X POST --header "PRIVATE-TOKEN:  $TOKEN" \
    	http://gitlab/api/v3/hooks?url=http://$HOOK_PORT_80_TCP_ADDR/hook/
    fi
fi

################## Creation USER Gitlab #############
curl  --noproxy '*' -s --header "PRIVATE-TOKEN: $TOKEN" -X POST  "http://gitlab/api/v3/users?email=$address&password=$password&username=$log_in&name=$name&admin=true"



############ Creation USER Redmine ####################

curl --noproxy '*' -v -H "Content-Type: application/xml" -d "<?xml version="1.0" encoding="ISO-8859-1" ?>
<user>
  <login>$log_in</login>
  <firstname>$name</firstname>
  <lastname>$lastname</lastname>
  <password>$password</password>
  <mail>$address</mail>
</user>
" -u admin:admin http://redmine/users.xml

export PGUSER=$DBREDLOGIN
export PGPASSWORD=$DBREDPASSWORD
psql -h postgresql-red -p 5432-d $DBREDNAME -c "UPDATE users SET admin=true WHERE login='$log_in'"
psql -h postgresql-red -p 5432-d $DBREDNAME -c "INSERT INTO roles (id,name,position,assignable,builtin,permissions,issues_visibility,users_visibility,time_entries_visibility,all_roles_managed)
VALUES (3,'proprietaire',3,TRUE,0,'---
- :add_project
- :edit_project
- :close_project
- :select_project_modules
- :manage_members
- :manage_versions
- :add_subprojects
- :manage_boards
- :add_messages
- :edit_messages
- :edit_own_messages
- :delete_messages
- :delete_own_messages
- :view_calendar
- :add_documents
- :edit_documents
- :delete_documents
- :view_documents
- :manage_files
- :view_files
- :view_gantt
- :manage_categories
- :view_issues
- :add_issues
- :edit_issues
- :copy_issues
- :manage_issue_relations
- :manage_subtasks
- :set_issues_private
- :set_own_issues_private
- :add_issue_notes
- :edit_issue_notes
- :edit_own_issue_notes
- :view_private_notes
- :set_notes_private
- :delete_issues
- :manage_public_queries
- :save_queries
- :view_issue_watchers
- :add_issue_watchers
- :delete_issue_watchers
- :import_issues
- :manage_news
- :comment_news
- :manage_repository
- :browse_repository
- :view_changesets
- :commit_access
- :manage_related_issues
- :log_time
- :view_time_entries
- :edit_time_entries
- :edit_own_time_entries
- :manage_project_activities
- :manage_wiki
- :rename_wiki_pages
- :delete_wiki_pages
- :view_wiki_pages
- :export_wiki_pages
- :view_wiki_edits
- :edit_wiki_pages
- :delete_wiki_pages_attachments
- :protect_wiki_pages', 'default','all','all',true)"
