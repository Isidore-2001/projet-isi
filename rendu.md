# Rendu "Les droits d’accès dans les systèmes UNIX"

## Binome

- Nom, Prénom, email: ___

- Nom, Prénom, email: ___

## Question 1

L'utilisateur toto a le droit de lecture mais comme il appartient au groupe ubuntu il hérite donc des 
permissions du groupe de ubuntu. 
Or le groupe ubuntu dispose de l'ensemble des droits pour lire et écrire dans le fichier. 
De ce fait le processus lancé par l'utilisateur toto pourra a cet effet bien écrire dans le fichier.

## Question 2

le caractère x pour un répertoire permet à un utilisateur de pouvoir naviguer dans le répertoire et dans les sous-repertoires. 

Lorsqu'on enleve le droit d'exécution pour le groupe ubuntu et on se connecte on essaie de naviguer dans le répertoire **mydir** on obtiens 

```sh 
$ bash: cd: mydir/: Permission denied
```
car l'utilisateur toto hérite de l'ensemble des permissions du groupe ubuntu et comme ce dernier ne dipose plus de droit d'exécution `x` sur 
le dossier l'utilisateur toto aussi n'en dispose donc pas. 

On crée le fichier data.txt 
===========================

On obtient avec : 

```sh 
ls: cannot open directory 'mydir/': Permission denied
```

On obtient le fait que la commande ls ne dispose pas d'assez de droit pour lister le contenu du dossier.
S'il avait cependant le droit suivant : drwxr--r-- 
on obtient donc : 

```sh 
ls: cannot access 'mydir/..': Permission denied
ls: cannot access 'mydir/data.txt': Permission denied
ls: cannot access 'mydir/.': Permission denied
total 0
d????????? ? ? ? ?            ? .
d????????? ? ? ? ?            ? ..
-????????? ? ? ? ?            ? data.txt
```

Explication
===========

Tout ceci provient du fait que l'utilisateur toto hérite de ubuntu et donc il hérite de l'ensemble de ces droits. 

## Question 3

Voici les valeurs des différents ids lorsque le programme est exécuté avec l'utilisateur toto : 

```sh 
EUID: 1001
EGID: 1001
RUID: 1001
RGID: 1001
Error opening file
```

Mais cependant il n'arrive pas à ouvrir le contenu du fichier. 

En activant le flag set-user-id du fichier exécutable on obtient les ids suivants: 

```sh 
EUID: 1000
EGID: 1001
RUID: 1001
RGID: 1001
```
Et il a réussi à ouvrir le fichier comme il faut.


## Question 4
Avec le script python on obtient les ids suivants : 

```sh 
RUID:  1001
EUID:  1001
RGID:  1001
EGID:  1001
```


## Question 5
Voici le contenu du fichier /etc/passwd 

```sh 
root:x:0:0:root:/root:/bin/bash
...
```

La commande chfn permet de modifier les informations concernant un utilisateur donnée. 

Permission sur /usr/bin/chfn
============================

On obtient les permissions suivantes : 

```sh 
-rwsr-xr-x 1 root root 72712 Mar 14  2022 /usr/bin/chfn
```
On constate que son set-user-id est activé. Ce qui montre que cette commande pourra être exécuté par un utilisateur qui ne dispose 
pas forcément de certains privilèges.

Après modification on constate avec la commande **chfn** que les données ont bien été enregistrés. 

```sh 
toto:x:1001:1001:,1,0786901328,0786901328:/home/toto:/bin/bash
```


## Question 6
Les mots de passe des utilisateurs sont stockés dans le fichier **etc/shadow**. Ces mots de passe ne sont pas stockés dans 
/etc/passwd car ce fichier est accessible par tous les utilisateurs. 

Il est donc stockés dans /etc/shadow dont les droits en lecture et écrire ne sont disponibles que pour

## Question 7

Mettre les scripts bash dans le repertoire *question7*.

## Question 8

Le programme et les scripts dans le repertoire *question8*.

## Question 9

Le programme et les scripts dans le repertoire *question9*.

## Question 10

Les programmes *groupe_server* et *groupe_client* dans le repertoire
*question10* ainsi que les tests. 








