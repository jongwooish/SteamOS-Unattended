# Precauciones

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | **Español** | [Français](README.fr.md)

![Read first](https://img.shields.io/badge/Read-before%20running-e53e3e?style=flat-square)

Léelo una vez antes de ejecutar nada. Casi todo ocurrió de verdad durante el proyecto.

## Índice

- [1. Script (Steam Deck real)](#1-script-steam-deck-real)
- [2. Sistema SteamOS](#2-sistema-steamos)
- [3. Entorno de pruebas en VMware](#3-entorno-de-pruebas-en-vmware)
- [4. No necesario en una Steam Deck real](#4-no-necesario-en-una-steam-deck-real)

---

## 1. Script (Steam Deck real)

- **Ejecuta primero con `--dry-run`.** Solo muestra lo que se instalaría o cambiaría.
- **Solo el módulo `60-etc-keep` necesita sudo.** Si la contraseña de deck no está definida (`passwd`), ese módulo deja un aviso y se omite. El resto continúa con normalidad.
- **Los archivos de `dotfiles/` sobrescriben los de tu `$HOME`.** Si el contenido difiere, el original se copia antes a `~/.local/state/steamos-unattended/backup/<hora>/`.
- **Solo se añade una línea a `~/.bashrc`** (la que lee `~/.bash_aliases`). Nunca se añade dos veces.
- **La primera ejecución tarda 5–15 minutos** mientras se descargan las imágenes de contenedor y las apps Flatpak. Espera aunque parezca detenida.
- **La entrada en coreano se aplica desde el siguiente inicio de sesión.** Se alterna con Ctrl+Space o la tecla 한/영.
- **Las copias de seguridad van a `~/Backups` por defecto.** Es el mismo disco, así que no protege ante un fallo del dispositivo. Apunta `config/backup.conf` a una tarjeta SD o un NAS.
- **No pongas patrones amplios como `/etc/**` en la lista de conservación.** Impide que futuras actualizaciones de SteamOS cambien `/etc` y provoca fallos. Pon solo los archivos necesarios.

---

## 2. Sistema SteamOS

- **No uses `steamos-readonly disable`.** Este proyecto nunca toca el área del sistema (`/usr`). Lo que se instala ahí desaparece al actualizar.
- **No ejecutes `pacman -Sy`.** La base de datos de pacman está en el área de solo lectura, así que falla, y forzarlo desincroniza los paquetes del sistema.

---

## 3. Entorno de pruebas en VMware

- **El modo juego no funciona en VMware.** La GPU virtual no tiene Vulkan. Pulsar "Return to Gaming Mode" deja la pantalla en negro; `sudo reboot` por SSH devuelve el escritorio.
- **El sistema instalado tarda 1–2 minutos en mostrar el escritorio.** Espera al menos 2 minutos con la pantalla en negro.
- **Si se actualiza el kernel de SteamOS, recompila el controlador vmwgfx.** El servicio del controlador nunca bloquea el arranque, así que puedes arreglarlo por SSH.
- **Comprueba siempre el nombre y el tamaño con `lsblk` antes de formatear un disco.** Elegir por error el disco de recuperación (`sda`) destruye el entorno de trabajo.
- **Indica la ruta `.vmx` exacta.** Una ruta equivocada revierte *esa* VM a su instantánea. Ten cuidado si tienes muchas VM.
- **Comprueba dónde escribes.** `PS C:\…>` es Windows; `(deck@steamdeck ~)$` es dentro de la VM. Los comandos de Windows no funcionan dentro de la VM.
- **En una VM, Windows o VMware pueden capturar la tecla 한/영.** Usa Ctrl+Space.

---

## 4. No necesario en una Steam Deck real

Los pasos 1–5 de [Configuration](../../03-Configuration/README/README.es.md) (crear la VM, el controlador vmwgfx, parchear el instalador, inicio de sesión automático en el escritorio) son **solo para el entorno de pruebas en VMware**. Omítelos en una Steam Deck real.
