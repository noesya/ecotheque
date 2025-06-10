# Ecothèque

Porté par *Villette Makerz*

## Setup

### Pré-requis

- ElasticSearch (voir la [doc](https://docs.ecotheque.fr/docs/recherche/))

### Récupération du projet

```
git clone git@github.com:noesya/ecotheque.git
cd ecotheque
bin/setup
```

Ensuite, remplir le fichier .env avec les infos secrètes.

En cas d'erreur `Asset application.css was not declared to be precompiled`, vider le cache local avec `rails tmp:cache:clear`
