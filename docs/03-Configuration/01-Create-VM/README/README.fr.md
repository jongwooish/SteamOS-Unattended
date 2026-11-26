# Étape 1 · Créer la VM

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | [Español](README.es.md) | **Français**

![Step](https://img.shields.io/badge/step-1%20%2F%206-2c7a7b?style=flat-square) ![Time](https://img.shields.io/badge/time-~20%20min-4a5568?style=flat-square) ![Scope](https://img.shields.io/badge/scope-VMware%20only-607078?style=flat-square)

Créer une VM VMware Workstation capable de démarrer l'image de récupération SteamOS.

> [!NOTE]
> Cette étape ne concerne que l'environnement de test VMware. Sur un vrai Steam Deck, passez directement à l'[étape 6](../../06-Run-Unattended/README/README.fr.md).

## Sommaire

- [Vue d'ensemble](#vue-densemble)
- [Prérequis](#prérequis)
- [Étapes](#étapes)
  - [1-1. Décompresser l'image de récupération](#1-1-décompresser-limage-de-récupération)
  - [1-2. La convertir en disque VMware](#1-2-la-convertir-en-disque-vmware)
  - [1-3. Créer la VM](#1-3-créer-la-vm)
  - [1-4. Attacher le disque de récupération et activer la 3D](#1-4-attacher-le-disque-de-récupération-et-activer-la-3d)
- [Vérification](#vérification)
- [Suite](#suite)

---

## Vue d'ensemble

L'image de récupération SteamOS est une image USB brute (raw) conçue pour le Steam Deck. Pour la démarrer dans VMware, trois conditions attendues par l'image doivent être remplies :

| Exigence | Raison |
| --- | --- |
| **Micrologiciel UEFI** | L'image n'a pas de chargeur d'amorçage BIOS. En BIOS, elle [bascule sur le démarrage réseau](../../../04-Troubleshooting/README/README.fr.md#t1). |
| **Disque cible NVMe** | L'installeur écrit sur `/dev/nvme0n1`, le SSD interne du Steam Deck. |
| **Format de disque `.vmdk`** | VMware ne peut pas attacher directement un fichier `.img` brut. |

## Prérequis

- [ ] VMware Workstation Pro installé
- [ ] Image de récupération SteamOS (`steamdeck-repair-….img.bz2`)
- [ ] 7-Zip et `qemu-img`
- [ ] Environ 100 Go d'espace libre

Tous les liens sont dans [Téléchargements](../../../01-Downloads/README/README.fr.md).

---

## Étapes

### 1-1. Décompresser l'image de récupération

Décompressez le fichier `.bz2` avec 7-Zip. Renommer le résultat en `SteamOS.img` raccourcit les commandes suivantes.

### 1-2. La convertir en disque VMware

```powershell
cd C:\VMs
& "C:\Program Files\qemu\qemu-img.exe" convert -p -f raw -O vmdk .\SteamOS.img .\recovery.vmdk
```

![Conversion qemu-img terminée](../images/qemu-img-convert.png)

> [!WARNING]
> Ne déplacez pas `recovery.vmdk` avant la fin de l'installation. La VM conserve son chemin absolu.

### 1-3. Créer la VM

**File → New Virtual Machine → Custom (advanced)**, puis :

| Écran | Valeur |
| --- | --- |
| Installation du système invité | I will install the operating system later |
| Système invité | Linux · **Other Linux 6.x kernel 64-bit** |
| Micrologiciel | **UEFI**, Secure Boot **désactivé** |
| Processeurs | 4 cœurs |
| Mémoire | 8 Go ou plus |
| Réseau | NAT |
| Disque | **NVMe**, 64 Go ou plus, fichier unique |

![Réglage de la mémoire](../images/vm-memory.png)

![Réglage des processeurs](../images/vm-processors.png)

### 1-4. Attacher le disque de récupération et activer la 3D

Dans **Edit virtual machine settings** :

1. **Add → Hard Disk → SATA → Use an existing virtual disk** → `recovery.vmdk` → **Keep Existing Format**
2. Activez **Display → Accelerate 3D graphics** et réglez Graphics memory sur 4 Go ou plus

![Réglage de l'affichage](../images/vm-display.png)

> [!TIP]
> Des options grisées signifient que la VM est allumée. Éteignez-la avant de modifier les réglages ([T3](../../../04-Troubleshooting/README/README.fr.md#t3)).

---

## Vérification

**Edit virtual machine settings** doit afficher :

| Périphérique | Contenu |
| --- | --- |
| Hard Disk (NVMe) | 70 Go, vide — cible d'installation de SteamOS |
| Hard Disk (SATA 0.0) | `recovery.vmdk` — environnement de récupération |
| Memory / Processors | 8 Go / 4 |
| Network / Display | NAT / accélération 3D |

Le disque de travail de 20 Go est ajouté à l'[étape 3](../../03-vmwgfx-Driver/README/README.fr.md).

> [!TIP]
> Prenez maintenant un instantané nommé `before-install` (VM éteinte). En cas d'échec plus tard, vous revenez ici en quelques secondes.

## Suite

[Étape 2 · Démarrage de récupération et SSH →](../../02-Recovery-Boot/README/README.fr.md)
