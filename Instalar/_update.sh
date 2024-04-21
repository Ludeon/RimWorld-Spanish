#!/usr/bin/env bash
# -*- ENCODING: UTF-8 -*-

# Author: Iter
# Date Created: 22/12/2023
# Last Modified: 12/04/2024

# Description
# Baja la traducción al castellano del repositorio oficial de Rimworld y la instala en el directorio del juego ya existente.
# NOTA: El repositorio oficial contiene tan solo la traducción que se despliega con las actualizaciones release.
# NOTA2: EL SCRIPT SÓLO SIRVE PARA VERSIÓN STEAM DEL JUEGO

# Usage
# ./actualizar.sh

# TODO
# función `getSteamPath`: obtener paths de más distros o famílias

function exit_code() {
    if [[ $1 -eq 0 ]]; then
        echo -e "[ ${verde}OK${rc} ]"
    else
        echo -e "[ ${rojo}Ha fallado${rc} ]"
    fi
    sleep 1
}

# colores
if (hash "tput" 2>/dev/null) ; then
    if [[ $(tput colors) != "-1" && -z $CI ]]; then
        rc=$(tput sgr0) # resetea tanto fg como bg
        rojo=$(tput setaf 1)
        verde=$(tput setaf 2)
        azul=$(tput setaf 4)
    fi
else
    rc="\e[0m"
    rojo="\e[0;31m"
    verde="\e[0;32m"
    azul="\e[0;34m"
fi

function getSteamPath() {
    # Obtiene la ruta hacia el directorio del juego en Steam según al distribución Linux que uses (aún por testear muchas otras distros)
    local os_release=$(grep "ID_LIKE" /etc/os-release | cut -d '=' -f2 | tr -d '"') # `tr` para quitar comillas dobles al inicio y final
    case "$os_release" in
        ubuntu*|debian*)
            steam_path="$HOME/.steam/debian-installation/steamapps/common/RimWorld";;
        arch*)
            steam_path="$HOME/.local/share/Steam/steamapps/common/RimWorld";;
        *)
            steam_path=$(find $HOME -wholename "*common/RimWorld" -print -quit);;
    esac
}

function updateTranslation() {
    getSteamPath
    local game_content="$1"   # contenido a actualizar: juego base (Core) o DLC's (biotech, royalty, ideology, anomaly). Lo pasamos por parámetro al llamar a la función.
    local translation_path="${steam_path}/Data/$game_content/Languages"
    local translation_label="Spanish (Español(Castellano))"
    if ! [ -d "${translation_path}" ]; then
        echo -e "[ ${rojo}Error${rc} ]: el directorio donde se alojan las traducciones no existe.\nQuizás hay un problema con la instalación del juego o no está (correctamente) instalado."
        exit 1
    fi
    # Borramos el directorio "Spanish (Español(Castellano))" si ya existía
    if [ -d "${translation_path}/${translation_label}" ]; then
        rm -r "${translation_path}/${translation_label}"
    fi
    # Lo mismo con la traducción empaquetada antigua "Spanish (Español(Castellano)).tar"
    if [ -f "${translation_path}/${translation_label}.tar" ]; then
        rm "${translation_path}/${translation_label}.tar"
    fi
    # Movemos las traducciones del juego base/DLCs hacia su directorio pertinente dentro del directorio de la traducción al castellano
    mv "$2/$1" "${translation_path}/${translation_label}"
    echo "Traducción ${azul}$1${rc} aplicada"
}

# Establecemos variables para acceder al repositorio Github de la traducción al castellano
github_user="Ludeon"
repo_name="RimWorld-Spanish"
repo_url="https://api.github.com/repos/${github_user}/${repo_name}/zipball/master"
zip_filename="/tmp/traduccion-rimworld.zip"
# Bajamos la traducción desde el repositorio Github
echo -ne "Bajando repositorio..."
wget $repo_url --output-document="${zip_filename}" &> /dev/null
exit_code $?
# Descomprimimos
echo -ne "Descomprimiendo..."
unzip -o ${zip_filename} -d /tmp &> /dev/null
exit_code $?
# Como Github nos añade un hash al final del `.zip`, y al extraer el `.zip` nos crea un directorio con el mismo nombre junto con el hash que no queremos para nada (p.ej. `ludeon-rimworld-spanish-1ebc836`), lo renombramos a un nombre de directorio que podamos manejar fácilmente (p.ej. `ludeon-rimworld-spanish`).
mv /tmp/${github_user}-${repo_name}-* /tmp/${github_user}-${repo_name}
# Borramos el archivo `.zip` original de github
rm "${zip_filename}"
# Actualizamos tanto el juego base como los DLCs si el usuario se los hubiera comprado
game_content=('Core' 'Royalty' 'Ideology' 'Biotech' 'Anomaly')
for content in $game_content; do
    updateTranslation "${content}" "/tmp/${github_user}-${repo_name}"
done
rm -rf /tmp/${github_user}-${repo_name}

exit 0