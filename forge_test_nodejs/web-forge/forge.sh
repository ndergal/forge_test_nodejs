export HOSTNAME=`cat /etc/hostname`
cat > $WEBROOT/index.html <<EOF
<!DOCTYPE html>
<html>

<head>
  <title>Forge ${HOSTNAME}</title>
  <meta charset="UTF-8">
  <meta name="keywords" content="test, html, nouveau">
  <meta name="author" content="Nacer Dergal">
  <link rel="stylesheet" type="text/css" href="style.css">
</head>

<body>
  <h1 id="titre">Portail d'acces a la forge: Forge ${HOSTNAME}</h1>
  <h2 id="sous-titre">Voici la liste des outils de la forge</h2>
  <div id="illustration">
    <pre>
                                 ##         .                  
                          ## ## ##        ==                   
                       ## ## ## ## ##    ===                   
                    /""""""""""""""""\___/ ===                 
               ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~          
                    \______ o          _,/                     
                     \      \       _,'                        
                      ''--.._\..--''                           
      </pre>
  </div>
  <div class="button">

    <button id="gitlab" onclick="window.location.href='http://${HOSTNAME}:10089'">Gitlab</button>

    <button id="redmine" onclick="window.location.href='http://${HOSTNAME}:10090'">Redmine</button>

    <button id="jenkins " onclick="window.location.href='http://${HOSTNAME}:10091'">Jenkins</button>

    <button id="dokuwiki " onclick="window.location.href='http://${HOSTNAME}:10092'">Dokuwiki</button>

  </div>
</body>

</html>
EOF

