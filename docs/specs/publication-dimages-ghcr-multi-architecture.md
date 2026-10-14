---
title: "Publication d’images GHCR multi-architecture"
id: publication-dimages-ghcr-multi-architecture
type: "technical"
status: draft
created: 2026-10-14
---

# Publication d’images GHCR multi-architecture

## Purpose

Définir le contrat de construction et de publication de l’image Docker du dépôt afin que les consommateurs puissent utiliser la même image sur les hôtes AMD64 et ARM64, avec des tags prévisibles dans GitHub Container Registry.

## Behavior

L’image est construite depuis le `Dockerfile` à la racine du dépôt pour les plateformes Linux `amd64` et `arm64`. Les variantes sont publiées sous un manifeste multi-architecture à l’emplacement `ghcr.io/<owner-du-dépôt-en-minuscules>/basic-debian-image`.

Un push sur `main` publie les tags `latest` et le SHA Git court. La création d’un tag Git SemVer au format `vX.Y.Z` publie les tags `vX.Y.Z`, `vX.Y` et `vX`. Les tags Git qui ne respectent pas ce format ne déclenchent pas de publication.

Les pull requests visant `main` construisent les deux architectures pour valider le Dockerfile mais ne publient aucune image et ne disposent pas de droit d’écriture vers le registre. Une exécution manuelle ne peut publier que lorsqu’elle cible `main` ou un tag `v*`.

## Constraints

- La publication doit utiliser le `GITHUB_TOKEN` fourni par GitHub Actions, sans secret externe.
- Seul le travail de publication peut recevoir la permission `packages: write`.
- Le travail de validation de pull request doit se limiter à `contents: read`.
- Toutes les actions tierces exécutées par le workflow doivent être épinglées à un SHA de commit complet.
- Les builds doivent utiliser Buildx et publier un manifeste contenant `linux/amd64` et `linux/arm64`.
- Les pull requests ne doivent jamais se connecter à GHCR ni pousser une image.

## Examples

Pour un tag Git `v2.4.1`, GHCR contient un manifeste multi-architecture sous les tags `v2.4.1`, `v2.4` et `v2`. Sur un push de `main` au commit `abcdef123`, il est accessible avec `latest` et `abcdef1`.

## Non-goals

Cette spécification ne définit ni la politique de rétention de GHCR, ni les règles de visibilité des packages, ni le déploiement de l’image sur une plateforme d’exécution.