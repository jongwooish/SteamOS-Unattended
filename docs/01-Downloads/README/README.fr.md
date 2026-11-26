# Téléchargements

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | [Español](README.es.md) | **Français**

![Free](https://img.shields.io/badge/All%20tools-free-2ea44f?style=flat-square) ![Official sources](https://img.shields.io/badge/Sources-official%20only-1A9FFF?style=flat-square)

Tout ce qu'il faut pour reproduire ce projet, avec la source officielle de chaque fichier. Tout est gratuit.

![Liste des téléchargements](../images/download-links.png)

## Sommaire

- [1. Ce projet](#1-ce-projet)
- [2. Environnement de test](#2-environnement-de-test)
- [3. Versions testées](#3-versions-testées)
- [4. Sur un vrai Steam Deck](#4-sur-un-vrai-steam-deck)
- [5. Avant de télécharger](#5-avant-de-télécharger)

---

## 1. Ce projet

| Élément | Où | Remarques |
| --- | --- | --- |
| SteamOS-Unattended (dernière version) | `git clone https://github.com/jongwooish/SteamOS-Unattended.git` | Ou **Code → Download ZIP** sur la page du dépôt |
| Fichiers de version | Onglet **Releases** du dépôt | À partir de l'étiquette `v1.0.0` |
| Installation en une ligne (dans SteamOS) | `curl -fsSL https://raw.githubusercontent.com/jongwooish/SteamOS-Unattended/main/install.sh \| bash` | Télécharge le dépôt et lance le profil `minimal` |

---

## 2. Environnement de test

| Élément | Où | Usage | Remarques |
| --- | --- | --- | --- |
| Image de récupération SteamOS | https://store.steampowered.com/steamos/download/?ver=steamdeck | SteamOS à installer dans la VM | Guide : https://help.steampowered.com/faqs/view/1B71-EDF2-EB6D-2BB3 |
| 7-Zip | https://www.7-zip.org/ | Décompresser l'image `.bz2` | |
| VMware Workstation Pro | https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware+Workstation+Pro | Machine virtuelle | Gratuit pour un usage personnel, éducatif et commercial. Compte Broadcom gratuit requis |
| qemu-img (QEMU pour Windows) | https://qemu.weilnetz.de/w64/ | Convertir `.img` en `.vmdk` VMware | Sous Debian/Ubuntu : `sudo apt install qemu-utils` |
| Git for Windows | https://git-scm.com/download/win | Cloner le dépôt | |

---

## 3. Versions testées

| Composant | Version |
| --- | --- |
| SteamOS | 3.8.14 |
| Noyau | `6.16.12-valve24.4-1-neptune-616-gfe145653a794` |
| Paquet d'en-têtes du noyau | `linux-neptune-616-headers 6.16.12.valve24.4-1` |
| Source de vmwgfx | kernel.org `linux-6.16.12` |
| distrobox / podman | 1.8.1.2 / 5.5.2 |
| Hôte | Windows, VMware Workstation Pro |

---

## 4. Sur un vrai Steam Deck

Aucun fichier de l'environnement de test n'est nécessaire. Ouvrez Konsole en mode bureau et lancez la commande d'installation en une ligne.

---

## 5. Avant de télécharger

- Téléchargez l'image de récupération **uniquement depuis la page officielle de Valve**. Une image republiée peut être modifiée ou incomplète.
- Téléchargez l'installeur VMware **uniquement depuis le portail Broadcom**. Évitez les sites qui le proposent « sans compte ».
- Avec une autre version de SteamOS le noyau change : il faut [recompiler le pilote vmwgfx pour cette version](../../03-Configuration/03-vmwgfx-Driver/README/README.fr.md).
