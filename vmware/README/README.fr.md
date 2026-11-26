# vmware/

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | [Español](README.es.md) | **Français**

![Scope](https://img.shields.io/badge/scope-VMware%20test%20only-607078?style=flat-square&logo=vmware&logoColor=white) ![Kernel](https://img.shields.io/badge/kernel-6.16.12--valve24-4a5568?style=flat-square)

Fichiers utilisés pour démarrer le mode bureau de SteamOS dans l'environnement de test VMware.

> [!IMPORTANT]
> **Inutiles sur un vrai Steam Deck.** `install.sh` ne touche jamais à ce dossier.

## Sommaire

- [Fichiers](#fichiers)
- [Comment ils s'articulent](#comment-ils-sarticulent)

---

## Fichiers

| Fichier | Installé dans | Rôle | Guide |
| --- | --- | --- | --- |
| [`compat_dirty.h`](../compat_dirty.h) | Dossier source de vmwgfx | Remplace deux fonctions du noyau absentes du noyau Valve | [Étape 3](../../docs/03-Configuration/03-vmwgfx-Driver/README/README.fr.md#compat-patch) |
| [`vmwgfx-load.service`](../vmwgfx-load.service) | `/etc/systemd/system/` (jeux A et B) | Charge `/home/vmwgfx/vmwgfx.ko` avant le gestionnaire d'affichage | [Étape 5](../../docs/03-Configuration/05-Desktop-Autostart/README/README.fr.md) |
| [`zzz-vmware-desktop.conf`](../zzz-vmware-desktop.conf) | `/etc/sddm.conf.d/` (jeux A et B) | Connexion automatique en mode bureau (`plasma.desktop`) | [Étape 5](../../docs/03-Configuration/05-Desktop-Autostart/README/README.fr.md) |

## Comment ils s'articulent

```mermaid
flowchart LR
    H[compat_dirty.h] -->|make| K[vmwgfx.ko]
    K -->|cp| HOME["/home/vmwgfx/"]
    SVC[vmwgfx-load.service] -->|insmod at boot| HOME
    SVC --> DRI["/dev/dri/card0"]
    DRI --> SDDM[SDDM]
    CONF[zzz-vmware-desktop.conf] --> SDDM
    SDDM --> P[Plasma desktop]
```

> [!NOTE]
> Le `vmwgfx.ko` compilé dépend d'une version précise du noyau ; il n'est donc pas versionné (`.gitignore`). Recompilez-le après chaque mise à jour du noyau SteamOS ([Étape 3](../../docs/03-Configuration/03-vmwgfx-Driver/README/README.fr.md)).
