# Spanish-translation-of-Rimworld
Esta es la **traducción al español** Castellano (de España) de Rimworld.
Consulta esta página para obtener información sobre la licencia e información adicional sobre cómo ayudar

[Enlace a la guia en los foros oficiales](http://ludeon.com/forums/index.php?topic=2933.0)

---
### Instalación de las últimas traducciones
Las traducciones que vienen con el juego no se actualizan automáticamente.
Cada vez que el juego se actualiza, Ludeon coge los archivos de los repositorios oficiales y los "empaqueta" para incluirlos en el juego.

Si queréis actualizar las traducciones a las más recientes; seguid [esta guía](Instalation/InstallGuide.md), o [esta otra](Instalation/ManualInstallGuide.md) para hacerlo manualmente.

Para empezar a colaborar entra al: Nuevo Grupo Discord de traducción: [Team Facción Latina](https://discord.gg/EjK52KM) actualizado el 24/07/2021. 
---
### Tareas pendientes:
El archivo [ToDoList.md](ToDoList.md) es el archivo en el que se anotarán aquellos archivos que contengan nuevos **textos pendientes de revisión**, **anotaciones**, etc.

---
### Arreglar **Backstories.xml**:
Antes que nada, esto se puede ignorar y simplemente usar la herramienta de limpieza de archivos de traducción que provee el propio juego.
Para darle formato al archivo **Backstories.xml** generado con la herramienta proporcionada por el juego, se han usado secuencialmente los siguientes 2 Regex de sustitución:
* Primero:
	* Find:		```\n\n```
	* Replace:	```\\n\\n```
* Después:
	* Find:		```([0-9])>\n\t<```
	* Replace:	```$1>\n\n\t<```

Toda esta magia es necesaria para separar cada uno de los trasfondos del resto, ser más eficaces a la hora de traducir dichos trasfondos, y que cada trasfondo y sus etiquetas identificadoras se mantengan intactas.

---
## Lista  traductores:

* Traductores Activos:
	* Zakees
	* Zerstrick
	* Xeros08
	* Creepynstoid

* Traductores:
	* Lord Mellington
	* Capiqua 
	* Gaesatae 
	* Ghrull
	* Vhiden
	* Guntrek

* Colaboradores:
	* Emsaic
	* Alvirolo
	* Mototron
	* Amatiasq
	* Azarashi
