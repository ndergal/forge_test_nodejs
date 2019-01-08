'use strict';

const express = require('express');
const app = express();
const bodyParser = require("body-parser");
app.use(bodyParser.json());
const pgp = require("pg-promise")();
const cn = {
  host: "postgresql-git",
  database: process.env.PGDATABASE,
  user: process.env.PGUSER,
  password: process.env.PGPASSWORD
};
const db = pgp(cn);
const request = require('request');
const parseString = require('xml2js').parseString;


app.post('/hook', function (req, res) {

  var event = req.body;

  if (event.event_name === "project_create") {
    let descriptionxml;
    let descriptionjson;
    let username;
    //REDMINE PROJECT CREATION
    // GET THE DESCRIPTION
    db.one('SELECT description FROM projects WHERE name = $1', [event.name])
      .then(function (data) {
        descriptionxml = data.description;
        descriptionjson = data.description;
        if (descriptionxml.indexOf('&') > -1) {
          descriptionxml = descriptionxml.replace("&", "&amp;");
        }
        if (descriptionxml.indexOf('<') > -1) {
          descriptionxml = descriptionxml.replace("<", "&lt;");
        }
        if (descriptionxml.indexOf('>') > -1) {
          descriptionxml = descriptionxml.replace(">", "&gt;");
        }
        // CREATE THE PROJECT ON REDMINE
        request.post('http://redmine/projects.xml', {
          method: 'POST',
          proxy: false,
          headers: {
            "content-type": "application/xml",  // <--Very important!!!
            "Authorization": "Basic " + new Buffer(process.env.log_in + ":" + process.env.password).toString("base64")
          },
          body: "<project><id>" + event.name + "</id><name>" + event.name + "</name><identifier>" + event.name + "</identifier><description>" + descriptionxml + "</description><is_public>" + (event.project_visibility == "public" ? "true" : "false") + "</is_public></project>",

        }, function (error, response, body) {
          if (error == null) {
            if (response != null && response.statusCode !== 201) {
              console.log('statusCode create project redmine :', response && response.statusCode);
              console.log(body);
            } else {

              // GET THE ID OF THE CREATOR ON REDMINE
              request.get('http://redmine/users.xml', {
                method: 'GET',
                proxy: false,
                headers: {
                  "Authorization": "Basic " + new Buffer(process.env.log_in + ":" + process.env.password).toString("base64")
                }
              }, function (error, response, body) {
                if (error == null) {
                  if (response != null && response.statusCode !== 200) {
                    console.log('statusCode id creator redmine :', response && response.statusCode);
                  } else {
                    parseString(body, (err, result) => {
                      let user = result.users.user.filter(u => u.login[0] === event.path_with_namespace.split("/")[0]);
                      console.log(event.path_with_namespace.split("/")[0])
                      if (user.length > 0) {
                        username = user[0].id[0];
                        // ADDING USER MEMBERSHIP TO THE REDMINE PROJECT
                        request.post('http://redmine/projects/' + event.name + '/memberships.xml', {
                          method: 'POST',
                          proxy: false,
                          headers: {
                            "content-type": "application/xml",  // <--Very important!!!
                            "Authorization": "Basic " + new Buffer(process.env.log_in + ":" + process.env.password).toString("base64")
                          },
                          body: "<membership><user_id>" + username + "</user_id><role_ids type='array'><role_id>3</role_id></role_ids></membership>",
                        }, function (error, response, body) {
                          if (error == null) {
                            if (response != null && response.statusCode !== 201) {
                              console.log('statusCode add membership redmine:', response && response.statusCode);
                              console.log(body);
                            }
                          } else {
                            console.log('error:', error);
                          }
                        });
                      }
                    })
                  }
                } else {
                  console.log('error:', error);
                }
              });
            }
          } else {
            console.log('error:', error);
          }
        })
        // JENKINS PROJECT CREATION
        request.post('http://jenkins:8080/createItem?name=' + event.name, {
          method: 'POST',
          proxy: false,
          headers: {
            "content-type": "application/xml",  // <--Very important!!!
            "Authorization": "Basic " + new Buffer(process.env.log_in + ":" + process.env.password).toString("base64")
          },
          body: "<?xml version='1.0' encoding='UTF-8'?><project><description>" + descriptionxml + "</description></project>",
        }, function (error, response, body) {
          if (error == null) {
            if (response != null && response.statusCode !== 200) {
              console.log('statusCode jenkins project creation :', response && response.statusCode);
              console.log(body);
            }
          } else {
            console.log('error:', error);
          }
        });
        // DOKUWIKI PROJECT CREATION
        request.post('http://dokuwiki:90/', {
          method: 'POST',
          proxy: false,
          headers: {
            "content-type": "application/json",  // <--Very important!!!
          },
          json: {
            "event_name": "project_create",
            "projet": event.name,
            "description": descriptionjson
          },
        }, function (error, response, body) {
          if (error == null) {
            if (response != null && response.statusCode !== 200) {
              console.log('statusCode dokuwiki project creation :', response && response.statusCode);
              console.log(body);
            }
          } else {
            console.log('error:', error);
          }
        });


      })
      .catch(function (error) {
        // error;
        console.log("ERROR:", error);
      });



  }
  res.send(' Finished POST hook ! ');
});

app.get('/', (req, res) => {
  res.send('Hello world\n');
});

app.listen(80, function () {
  console.log('Hook listening on port 80!');
});
