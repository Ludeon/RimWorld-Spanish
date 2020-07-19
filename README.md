Spanish-translation-of-Rimworld
===============================

Esta es la **traducción al español** Castellano (de España) de Rimworld.


Consulte esta página para obtener información sobre la licencia e información adicional sobre como ayudar

[Enlace a la guia en los foros oficiales](http://ludeon.com/forums/index.php?topic=2933.0)



[Enlace al grupo Discord](https://discord.gg/KF5cqm)

Tareas pendientes:
--------------------

El archivo [ToDoList.md](ToDoList.md) es el archivo en el que se anotarán aquellos archivos que contengan nuevos **textos pendientes de traducción**, **nuevos archivos** necesarios para las traducciones y **que aún no están traducidos**, etc.

Arreglar **Backstories.xml**:
--------------------
Antes que nada, esto se puede ignorar y simplemente usar la herramienta de limpieza de archivos de traducción que provee el propio juego.
Para darle formato al archivo **Backstories.xml** generado con la herramienta proporcionada por el juego, se han usado secuencialmente los siguientes 2 Regex de sustitución:
* Primero:
	* Find:		\n\n
	* Replace:	\\n\\n
* Después:
	* Find:		([0-9])>\n\t<
	* Replace:	$1>\n\n\t<

Toda esta magia es necesaria para separar cada uno de los trasfondos del resto, ser más eficaces a la hora de traducir dichos trasfondos, y que cada trasfondo y sus etiquetas identificadoras se mantengan intactas.


Lista  traductores:
--------------------

* Traductores Activos:
	* Xeros08

	* Lord Mellington



* Tradcutores:
	* Capiqua 

	* Gaesatae 

	* Ghrull

	* Vhiden

	* Yllelder
    
    * Guntrek


* Colaboradores:

	* Emsaic

	* Alvirolo

	* Mototron

	* Amatiasq

	* Azarashi
