# Configuración

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | **Español** | [Français](README.fr.md)

![Steps](https://img.shields.io/badge/steps-6-2c7a7b?style=flat-square) ![Total time](https://img.shields.io/badge/total-~3%20h-4a5568?style=flat-square) ![Host](https://img.shields.io/badge/host-VMware%20Workstation-607078?style=flat-square&logo=vmware&logoColor=white)

Crea una máquina de prueba con SteamOS en VMware Workstation a partir de la imagen de recuperación oficial y ejecuta SteamOS-Unattended en ella. Cada paso se hizo de verdad e incluye capturas.

> [!TIP]
> **¿Tienes una Steam Deck real?** Los pasos 1–5 solo sirven para que SteamOS funcione en VMware. Ve directamente al [Paso 6](../06-Run-Unattended/README/README.es.md).

## Índice

- [Flujo](#flujo)
- [Pasos](#pasos)
- [Convenciones](#convenciones)

---

## Flujo

```mermaid
flowchart TD
    S1["1 · Create VM<br/>UEFI · NVMe · recovery vmdk"] --> S2["2 · Recovery boot<br/>TTY · SSH"]
    S2 --> S3["3 · Build vmwgfx<br/>headers · podman · compat patch"]
    S3 --> S4["4 · Install SteamOS<br/>patched repair_device.sh"]
    S4 --> S5["5 · Desktop autostart<br/>vmwgfx-load · Plasma autologin"]
    S5 --> S6["6 · Run SteamOS-Unattended<br/>1st run · 2nd run = 0 changes"]
```

## Pasos

| # | Paso | Qué obtienes | Tiempo |
| --- | --- | --- | --- |
| 1 | [Crear la VM](../01-Create-VM/README/README.es.md) | Una VM UEFI con la imagen de recuperación en SATA y un disco NVMe vacío | ~15 min |
| 2 | [Arranque de recuperación y SSH](../02-Recovery-Boot/README/README.es.md) | La causa de la pantalla negra y acceso SSH al sistema de recuperación | ~15 min |
| 3 | [Compilar el controlador vmwgfx](../03-vmwgfx-Driver/README/README.es.md) | Un `vmwgfx.ko` para el kernel exacto de SteamOS; aparece el escritorio de recuperación | ~60 min |
| 4 | [Instalar SteamOS en NVMe](../04-Install-SteamOS/README/README.es.md) | SteamOS instalado con una copia del instalador adaptada a VMware | ~30 min |
| 5 | [Inicio automático del escritorio](../05-Desktop-Autostart/README/README.es.md) | El sistema instalado arranca solo en el modo escritorio | ~20 min |
| 6 | [Ejecutar SteamOS-Unattended](../06-Run-Unattended/README/README.es.md) | 18 cambios en la primera ejecución, 0 en la segunda, todo verificado | ~30 min |

## Convenciones

| Notación | Significado |
| --- | --- |
| `PS C:\…>` | Se ejecuta en Windows PowerShell en el anfitrión |
| `(deck@steamdeck ~)$` | Se ejecuta dentro de la VM (por SSH o en Konsole) |
| `192.168.126.133` | La IP de la VM usada en toda la guía — sustitúyela por la tuya |
| `/mnt/build` | El disco de trabajo adicional del Paso 3 |

> [!NOTE]
> Antes de empezar, lee las [Precauciones](../../02-Cautions/README/README.es.md) y reúne los archivos de [Descargas](../../01-Downloads/README/README.es.md). Si algo falla, todos los errores encontrados por el camino están en [Solución de problemas](../../04-Troubleshooting/README/README.es.md).
