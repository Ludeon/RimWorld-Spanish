# Instalación de las traducciones:
Para simplificar el proceso de instalación (y actualización) de las traducciones, [Xeros08](https://github.com/Xeros08) ha creado un script para hacer el proceso más liviano. A continuación tendrás los pasos a seguir para conseguirlo.

_NOTA: El proceso variará ligeramente dependiendo del sistema operativo que usemos. Actualmente, está soportado Windows y Linux._

## Windows:
### 1) Descargar el Script de Windows:
#### Opción 1:
1. Ve al siguiente enlace para descargar el [script de actualización para Windows](https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Scripts/_update.ps1).
2. Haz clic derecho en cualquier parte de la página / el texto (sale como texto sin formato).
3. En el menú emergente "Guardar como", y lo guardaremos con la extensión ".ps1" (`_update.ps1`)
4. Ya se nos ha descargado el script en la carpeta de Descargas.

#### Opción 2:
1. Abrir una terminal (Símbolo del sistema) desde el menú de Windows, o mediante la combinación de teclas "Win+R" (dentro de "ejecutar", y escribimos: cmd)
2. Una vez dentro de la terminal, ejecutar el siguiente comando (copiar y pegar): `cd C:\Users\%Username%\Downloads\ && curl -LJO https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Scripts/_update.ps1`
3. Ya se nos ha descargado el script en la carpeta de Descargas. Podemos cerrar el terminal.

### 2) Actualizar e instalar las traducciones:
1. Abre el explorador de archivos, y dirígete a tu directorio de descargas por defecto (`~/Descargas`) donde has guardado el **script para Windows** (ver pasos arriba).
2. Mueve el script al directorio raíz del juego. Este normalmente es: `C:\Program Files (x86)\Steam\steamapps\common\RimWorld`
3. Comprueba, en la línea 20, que tienes la rama adecuada seleccionada. Por defecto se encuentra `master`, pero deberás modificarla a la versión que te interese entre las actualmente disponibles (`v1.4`, `v1.5`, `master`, `test-translations`).
4. Ejecuta el script (Clic derecho => Ejecutar con Powershell).
5. ¡Listo! Reinicia el juego o recarga el idioma del español castellano desde el menú principal para asegurarte de que tienes la última versión disponible.

NOTA: Si Windows no te permite ejecutar scripts de Powershell, ejecuta con permisos de administrador en Powershell el comando `set-executionpolicy remotesigned`.

## Linux:
### 1) Descargar el Script de Linux:
#### Opción 1:
1. Ve al siguiente enlace para descargar el [script de actualización para Linux](https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Scripts/_update.sh).
2. Haz clic derecho en cualquier parte de la página / el texto (sale como texto sin formato).
3. En el menú emergente "Guardar como", y lo guardaremos con la extensión ".sh" (`_update.sh`)
4. Ya se nos ha descargado el script en la carpeta de Descargas.

#### Opción 2:
1. Abrir un terminal 
2. Ejecutar el siguiente comando: `cd  ~/Descargas && curl -LJO https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Scripts/_update.sh`
3. Ya se nos ha descargado el script en la carpeta de Descargas. Podemos cerrar el terminal.

### 2) Actualizar e instalar las traducciones:
1. Abre el explorador de archivos, y dirígete a tu directorio de descargas por defecto (`~/Descargas`) donde has guardado el **script para Linux** (ver pasos arriba).
2. Abre un terminal en el directorio donde bajaste el script (`cd ~/Decargas`).
3. Ejecutar el script con `./_update.sh`
4. ¡Listo! Reinicia el juego o recarga el idioma del español castellano desde el menú principal para asegurarte de que tienes la última versión disponible.
