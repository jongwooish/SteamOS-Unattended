# Précautions

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | [Español](README.es.md) | **Français**

![Read first](https://img.shields.io/badge/Read-before%20running-e53e3e?style=flat-square)

À lire une fois avant de lancer quoi que ce soit. Presque tout est arrivé pour de vrai pendant le projet.

## Sommaire

- [1. Script (vrai Steam Deck)](#1-script-vrai-steam-deck)
- [2. Système SteamOS](#2-système-steamos)
- [3. Environnement de test VMware](#3-environnement-de-test-vmware)
- [4. Inutile sur un vrai Steam Deck](#4-inutile-sur-un-vrai-steam-deck)

---

## 1. Script (vrai Steam Deck)

- **Lancez d'abord avec `--dry-run`.** Cela affiche seulement ce qui serait installé ou modifié.
- **Seul le module `60-etc-keep` a besoin de sudo.** Si le mot de passe de deck n'est pas défini (`passwd`), ce module laisse un avertissement et est ignoré. Les autres modules continuent normalement.
- **Les fichiers de `dotfiles/` écrasent ceux de votre `$HOME`.** Si le contenu diffère, l'original est d'abord sauvegardé dans `~/.local/state/steamos-unattended/backup/<heure>/`.
- **Une seule ligne est ajoutée à `~/.bashrc`** (celle qui lit `~/.bash_aliases`). Elle n'est jamais ajoutée deux fois.
- **Le premier lancement prend 5 à 15 minutes** pendant le téléchargement des images de conteneur et des applications Flatpak. Patientez même si cela semble bloqué.
- **La saisie coréenne s'applique à partir de la prochaine connexion.** Basculez avec Ctrl+Space ou la touche 한/영.
- **Les sauvegardes vont par défaut dans `~/Backups`.** C'est le même disque : cela ne protège pas d'une panne de l'appareil. Indiquez une carte SD ou un NAS dans `config/backup.conf`.
- **Ne mettez pas de motifs larges comme `/etc/**` dans la liste de conservation.** Cela empêche les futures mises à jour de SteamOS de modifier `/etc` et provoque des pannes. N'indiquez que les fichiers nécessaires.

---

## 2. Système SteamOS

- **N'utilisez pas `steamos-readonly disable`.** Ce projet ne touche jamais la zone système (`/usr`). Ce qui y est installé disparaît à la mise à jour.
- **Ne lancez pas `pacman -Sy`.** La base de données de pacman est dans la zone en lecture seule : la commande échoue, et la forcer désynchronise les paquets système.

---

## 3. Environnement de test VMware

- **Le mode jeu ne fonctionne pas dans VMware.** Le GPU virtuel n'a pas Vulkan. Cliquer sur « Return to Gaming Mode » donne un écran noir ; `sudo reboot` via SSH ramène le bureau.
- **Le système installé met 1 à 2 minutes à afficher le bureau.** Attendez au moins 2 minutes devant un écran noir.
- **Si le noyau de SteamOS est mis à jour, recompilez le pilote vmwgfx.** Le service du pilote ne bloque jamais le démarrage : vous pouvez corriger via SSH.
- **Vérifiez toujours le nom et la taille avec `lsblk` avant de formater un disque.** Choisir par erreur le disque de récupération (`sda`) détruit l'environnement de travail.
- **Indiquez le chemin `.vmx` exact.** Un mauvais chemin ramène *cette* VM à son instantané. Prudence si vous avez beaucoup de VM.
- **Vérifiez où vous tapez.** `PS C:\…>` correspond à Windows, `(deck@steamdeck ~)$` à l'intérieur de la VM. Les commandes Windows ne fonctionnent pas dans la VM.
- **Dans une VM, la touche 한/영 peut être interceptée par Windows ou VMware.** Utilisez Ctrl+Space.

---

## 4. Inutile sur un vrai Steam Deck

Les étapes 1 à 5 de [Configuration](../../03-Configuration/README/README.fr.md) (création de la VM, pilote vmwgfx, modification de l'installeur, connexion automatique au bureau) sont **réservées à l'environnement de test VMware**. Ignorez-les sur un vrai Steam Deck.
