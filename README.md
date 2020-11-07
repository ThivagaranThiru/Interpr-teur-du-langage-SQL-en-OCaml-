# Interpreteur-du-langage-SQL

Le projet consiste à réaliser en OCaml un interprète du langage SQL. La réalisation minimale consiste à évaluer une requête SQL simple (i.e., SELECT … FROM … WHERE …).

L'objectif est de réaliser l'analyseur lexical (fichier lexer.mll) et l'analyseur syntaxique (fichier parser.mly) correspondant à la BNF (https://fr.wikipedia.org/wiki/Forme_de_Backus-Naur).

Quelques remarques concernant les propriétés des opérateurs :

    Par défaut, tous les opérateurs sont considérés associatifs à gauche
    Les opérateurs arithmétiques possèdent les propriétés de priorité et d'associativité usuelles
    L'opérateur de concaténation est moins prioritaire que les opérateurs arithmétiques
    Les opérateurs logiques respectent les priorités suivantes : OR < AND < NOT < IS
    Dans une clause FROM, la virgule est moins prioritaire que les opérateurs de jointure, ceux-ci étant tous de même priorité


On attend à la sortie de l'analyse syntaxique un arbre de syntaxe abstraite.Le module Ast offrira les éléments pour la manipulation d'un arbre:

    un type query permettant de représenter l'arbre de syntaxe d'une requête 
    une fonction string_of_query: query → string permettant de convertir un arbre de syntaxe en chaîne de caractères respectant la syntaxe concrète
    une fonction eval_query: (R.relation * R.attribute env) env → query → R.relation 

La fonction eval_query du module Ast demande la manipulation de données de type R.relation. Ce type provient d'un module Relation codant les éléments principaux de l'algèbre relationnelle.

Dans les faits, le module Relation propose une implémentation de l'algèbre relationnelle indépendamment du type des données élémentaires stockées dans les relations. Le module Relation fournit trois éléments :

    la signature S : il s'agit de la signature que doit respecter un module de manipulation de relation
    la signature DATA : il s'agit de la signature que doit respecter un module de manipulation de données élémentaires
    le foncteur Make : il s'agit d'un outils permettant de créer un module vérifiant la signature S à partir d'un module de données élémentaires (donc vérifiant la signature DATA) ; en gros, il s'agit d'une fonction de module de type DATA → S

Le module R définit précédemment respecte la signature S du module Relation. En particulier, R contient un ensemble de types et d'opérations implémentant l'algèbre relationnelle dans sa version multi-ensembliste (i.e., où chaque tuple peut apparaître plusieurs fois ; aucune clé - primaire ou étrangère - n'est considérée). Les attributs, identifiant les colonnes d'une relation, sont de simples entiers indiquant le numéro de la colonne (aucun nom d'attribut n'est géré ; ce sera à vous de rajouter le lien entre nom et numéro). 

Un environnement est une liste triée de couples (nom, valeur), peu importe le type des valeurs.

Faites un make pour compiler.





