# Étape 4 · Installer SteamOS sur le NVMe

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | [Español](README.es.md) | **Français**

![Step](https://img.shields.io/badge/step-4%20%2F%206-2c7a7b?style=flat-square) ![Time](https://img.shields.io/badge/time-~20%20min-4a5568?style=flat-square) ![Scope](https://img.shields.io/badge/scope-VMware%20only-607078?style=flat-square)

Lancer l'installeur de Valve depuis l'environnement de récupération et écrire SteamOS sur le disque NVMe de la VM.

## Sommaire

- [Vue d'ensemble](#vue-densemble)
- [Prérequis](#prérequis)
- [Étapes](#étapes)
  - [4-1. Créer une copie de l'installeur adaptée à VMware](#4-1-créer-une-copie-de-linstalleur-adaptée-à-vmware)
  - [4-2. Le lancer depuis le terminal de la VM](#4-2-le-lancer-depuis-le-terminal-de-la-vm)
  - [4-3. Le dernier *Proceed* redémarre](#4-3-le-dernier-proceed-redémarre)
- [Vérification](#vérification)
- [Suite](#suite)

---

## Vue d'ensemble

Le raccourci **Wipe Device & Install SteamOS** se ferme juste après *Proceed* et n'installe rien. En lançant le script à la main, trois blocages distincts apparaissent :

| # | Symptôme | Cause | Correctif |
| --- | --- | --- | --- |
| 1 | `!! Please run as root.` | Nécessite root | Lancer avec `sudo` ([T6](../../../04-Troubleshooting/README/README.fr.md#t6)) |
| 2 | `zenity … cannot open display` | Affiche une boîte de confirmation | Lancer depuis le **terminal de la VM**, pas en SSH |
| 3 | `nvme format` → `Invalid Command Opcode` | Le NVMe virtuel de VMware n'implémente pas la commande de formatage | Sauter cette seule étape dans une copie du script ([T7](../../../04-Troubleshooting/README/README.fr.md#t7)) |

## Prérequis

- [ ] [Étape 3](../../03-vmwgfx-Driver/README/README.fr.md) terminée — bureau de récupération visible, disque de travail monté sur `/mnt/build`

---

## Étapes

### 4-1. Créer une copie de l'installeur adaptée à VMware

En SSH :

```bash
cp ~/tools/repair_device.sh ~/tools/repair_device_vm.sh
sed -i 's/nvme format/true nvme format/' ~/tools/repair_device_vm.sh
chmod +x ~/tools/repair_device_vm.sh
diff ~/tools/repair_device.sh ~/tools/repair_device_vm.sh
```

`true` réussit quels que soient les arguments qui suivent : seul le formatage matériel est sauté. Cette étape vise le SSD physique du Steam Deck ; un disque virtuel vide n'en a pas besoin. La copie reste dans `tools/` car le script charge des fichiers voisins.

### 4-2. Le lancer depuis le terminal de la VM

Double-cliquez sur **Terminal with repair tools** sur le bureau de récupération.

![Terminal with repair tools](../images/terminal-icon.png)

```bash
sudo ~/tools/repair_device_vm.sh all 2>&1 | tee /mnt/build/install.log
```

> [!TIP]
> `tee` conserve le journal sur le disque de travail. Si la fenêtre se ferme, lisez-le en SSH avec `tail -30 /mnt/build/install.log`.

![Installation en cours](../images/install-progress.png)

| Ligne du journal | Signification |
| --- | --- |
| `mkfs.ext4 … nvme0n1p8` | Partitions créées et formatées |
| `Skipping update due to unsupported hardware revision` | Mise à jour du BIOS ignorée — normal dans une VM |
| `Device does not look like a Steam Deck…` | Micrologiciel des contrôleurs ignoré — normal |
| `fsfreeze -f /` | Source gelée pendant la copie ; la VM peut sembler figée un instant |
| `Imaging OS partition A`, `dd … sda3 → nvme0n1p4` | Copie de l'image système SteamOS |

Le système installé est une copie du système de l'image de récupération : le **noyau est identique** et le module de l'étape 3 fonctionne tel quel.

### 4-3. Le dernier *Proceed* redémarre

La dernière boîte de dialogue signifie « installation terminée, redémarrer ». La VM démarre la nouvelle entrée **SteamOS**, qui affiche un écran noir car le pilote n'y est pas encore. C'est attendu.

![Boot Manager après l'installation](../images/boot-manager-steamos.png)

| Entrée | Description |
| --- | --- |
| **SteamOS** | Créée par l'installeur (NVMe) |
| SATA Hard Drive (0.0) | Disque de récupération |
| SATA Hard Drive (2.0) | Disque de travail (non amorçable) |

---

## Vérification

- [ ] `install.log` se termine par `Creating Boot… SteamOS`
- [ ] Boot Manager affiche une entrée **SteamOS**

Éteignez et redémarrez sur **SATA Hard Drive (0.0)** pour continuer.

## Suite

[Étape 5 · Démarrage automatique du bureau →](../../05-Desktop-Autostart/README/README.fr.md)
