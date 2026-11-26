# Descargas

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | **Español** | [Français](README.fr.md)

![Free](https://img.shields.io/badge/All%20tools-free-2ea44f?style=flat-square) ![Official sources](https://img.shields.io/badge/Sources-official%20only-1A9FFF?style=flat-square)

Todo lo necesario para reproducir este proyecto, con el sitio oficial de cada archivo. Todo es gratuito.

![Lista de descargas](../images/download-links.png)

## Índice

- [1. Este proyecto](#1-este-proyecto)
- [2. Entorno de pruebas](#2-entorno-de-pruebas)
- [3. Versiones probadas](#3-versiones-probadas)
- [4. En una Steam Deck real](#4-en-una-steam-deck-real)
- [5. Antes de descargar](#5-antes-de-descargar)

---

## 1. Este proyecto

| Recurso | Dónde | Notas |
| --- | --- | --- |
| SteamOS-Unattended (última) | `git clone https://github.com/jongwooish/SteamOS-Unattended.git` | O **Code → Download ZIP** en la página del repositorio |
| Archivos de versión | Pestaña **Releases** del repositorio | Desde la etiqueta `v1.0.0` |
| Instalación en una línea (dentro de SteamOS) | `curl -fsSL https://raw.githubusercontent.com/jongwooish/SteamOS-Unattended/main/install.sh \| bash` | Descarga el repositorio y ejecuta el perfil `minimal` |

---

## 2. Entorno de pruebas

| Recurso | Dónde | Uso | Notas |
| --- | --- | --- | --- |
| Imagen de recuperación de SteamOS | https://store.steampowered.com/steamos/download/?ver=steamdeck | SteamOS para instalar en la VM | Guía: https://help.steampowered.com/faqs/view/1B71-EDF2-EB6D-2BB3 |
| 7-Zip | https://www.7-zip.org/ | Descomprimir la imagen `.bz2` | |
| VMware Workstation Pro | https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware+Workstation+Pro | Máquina virtual | Gratis para uso personal, educativo y comercial. Requiere cuenta gratuita de Broadcom |
| qemu-img (QEMU para Windows) | https://qemu.weilnetz.de/w64/ | Convertir `.img` a `.vmdk` de VMware | En Debian/Ubuntu: `sudo apt install qemu-utils` |
| Git for Windows | https://git-scm.com/download/win | Clonar el repositorio | |

---

## 3. Versiones probadas

| Componente | Versión |
| --- | --- |
| SteamOS | 3.8.14 |
| Kernel | `6.16.12-valve24.4-1-neptune-616-gfe145653a794` |
| Paquete de cabeceras del kernel | `linux-neptune-616-headers 6.16.12.valve24.4-1` |
| Código fuente de vmwgfx | kernel.org `linux-6.16.12` |
| distrobox / podman | 1.8.1.2 / 5.5.2 |
| Anfitrión | Windows, VMware Workstation Pro |

---

## 4. En una Steam Deck real

No necesitas ningún archivo del entorno de pruebas. Abre Konsole en el modo escritorio y ejecuta el comando de instalación en una línea.

---

## 5. Antes de descargar

- Descarga la imagen de recuperación **solo desde la página oficial de Valve**. Las imágenes resubidas pueden estar modificadas o incompletas.
- Descarga el instalador de VMware **solo desde el portal de Broadcom**. Evita los sitios que lo ofrecen "sin cuenta".
- Con otra versión de SteamOS cambia el kernel, así que debes [recompilar el controlador vmwgfx para esa versión](../../03-Configuration/03-vmwgfx-Driver/README/README.es.md).
