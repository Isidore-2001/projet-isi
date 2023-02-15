
# Logging avec les représentants 

## Introduction

Le script shell fourni est un script de connexion à un disque chiffré qui peut être déverrouillé à l'aide de deux clés USB. L'objectif est de permettre l'accès au contenu du disque même si le responsable est absent, en utilisant des représentants qui ont accès aux clés USB. Le script vérifie la présence des clés USB, les déchiffre et déverrouille le disque à l'aide d'un fichier maître stocké sur le disque et protégé par un mot de passe.
Variables

Le script commence par définir quelques variables qui seront utilisées plus tard, notamment le répertoire de travail.
Fonctions de connexion

Le script définit ensuite plusieurs fonctions de connexion qui permettent de vérifier les clés USB et de les déchiffrer. En particulier, les fonctions loginJudge et secondLoginJudge sont utilisées pour déchiffrer les clés USB 1 et 2, respectivement. Les fonctions loginJudgeReplace et secondLoginJudgeReplace permettent quant à elles de déchiffrer les clés USB des représentants.

Ces fonctions font toutes appel à la bibliothèque OpenSSL pour le chiffrement et le déchiffrement des fichiers. En particulier, la commande suivante est utilisée pour déchiffrer les fichiers de clé USB chiffrés en AES-256-CBC:


```sh
$ openssl enc -aes-256-cbc -d -in $input_file -out $output_file -pbkdf2
```

Dans cette commande, input_file est le fichier chiffré en entrée, output_file est le fichier déchiffré en sortie et -pbkdf2 est un paramètre de la fonction de déchiffrement qui spécifie l'utilisation de la fonction de dérivation de clé PKCS #5 v2.0, qui est recommandée pour le chiffrement AES.
Les fonctions de connexion vérifient également le résultat du déchiffrement à l'aide du code de sortie de la commande OpenSSL ($?). Si le déchiffrement échoue, la fonction affiche un message d'erreur et quitte le script en appelant la fonction exit.


# Fonctions de remplacement

Le script définit également des fonctions de remplacement qui permettent de déchiffrer les clés USB des représentants en cas d'absence du responsable. Ces fonctions fonctionnent de la même manière que les fonctions de connexion, mais utilisent les clés USB stockées dans le répertoire USBREPRESENTATION plutôt que dans les répertoires USB1 et USB2.

# Questions clés

Le script pose ensuite des questions clés à l'utilisateur pour savoir s'il est le responsable ou un représentant, et pour savoir quelle clé USB il doit utiliser. En fonction des réponses de l'utilisateur, le script choisit la bonne clé USB et appelle la fonction de connexion ou de remplacement appropriée.



