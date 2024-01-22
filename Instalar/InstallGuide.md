# Instalación de las traducciones:
Para simplificar el proceso de instalación (y actualización) de las traducciones, he creado un script para hacer el proceso más liviano.

NOTA: el proceso variará ligeramente dependiendo del sistema operativo que usemos.

## Windows:
### Pasos para actualizar las traducciones:
1. Descargar el [script de actualización para Windows](https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Instalar/_update.ps1) (Seguir pasos abajo).
2. Mover el script al directorio raíz del juego. Este normalmente es: `C:\Program Files (x86)\Steam\steamapps\common\RimWorld`
3. Ejecutar el script (CLic derecho => Ejecutar con Powershell).
4. ¡Listo!

### Pasos para descargar el Script en Windows:
Opción 1:
1. Ve al siguiente [enlace](https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Instalar/_update.ps1).
2. Haz clic derecho en cualquier parte de la página / el texto (sale como texto sin formato).
3. En el menú emergente "Guardar como", y lo guardaremos con la extensión ".ps1" (_update.ps1)
4. Ya se nos ha descargado el script en la carpeta de Descargas.

Opción 2:
1. Abrir una terminal (Símbolo del sistema) desde el menú de Windows, o mediante la combinación de teclas "Win+R" (dentro de "ejecutar": cmd)
3. Una vez dentro de la terminal, ejecutar el siguiente comando (copiar y pegar): `cd C:\Users\%Username%\Downloads\ && curl -LJO https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Instalar/_update.ps1`
4. Ya se nos ha descargado el script en la carpeta de Descargas. Podemos cerrar la terminal.

## Linux:
### Pasos para actualizar las traducciones:

1. Abrir el explorador de archivos, dirigirse a tu directorio de descargas por defecto (`~/Descargas`) y descargar el [script de actualización para Linux](https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Instalar/_update.sh) (seguir  los pasos descritos más abajo).
2. Abrir un terminal en el directorio donde bajaste el script (`cd ~/Decargas`).
3. Ejecutar el script con `./_update.sh`
4. ¡Listo!

#### Pasos para descargar el Script en Linux:

Opción 1:
1. Ve al siguiente [enlace](https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Instalar/_update.sh).
2. Haz clic derecho en cualquier parte de la página / el texto (sale como texto sin formato).
3. En el menú emergente "Guardar como", y lo guardaremos con la extensión ".sh" (` _update.sh`)
4. Ya se nos ha descargado el script en la carpeta de Descargas.

Opción 2:
1. Abrir un terminal 
2. Ejecutar el siguiente comando: `cd  ~/Descargas && curl -LJO https://raw.githubusercontent.com/Ludeon/RimWorld-Spanish/master/Instalar/_update.sh`
3. Ya se nos ha descargado el script en la carpeta de Descargas. Podemos cerrar el terminal.