# Spanish-translation-of-Rimworld
---
Esta es la **traducción al español** Castellano (de España) de Rimworld.
Consulte esta página para obtener información sobre la licencia e información adicional sobre como ayudar

[Enlace a la guia en los foros oficiales](http://ludeon.com/forums/index.php?topic=2933.0)

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
## Sobre lo de añadirse en los créditos:
Se hará como en la traducción alemana del juego;
Si quieres ser añadido a la lista de traductores, solo hay una regla; Tienes que ayudar con las traducciones de, por lo menos, dos actualizaciones mayores.
Si después de cumplir los requisitos quieres aparecer en los créditos, podrás modificar el archivo ```LanguageInfo.xml``` y añadirte.

Se entiende por actualización mayor, las que aumentan cualquiera de las dos primeras cifras que forman el número de la versión.
Ejemplo: Pasar de la ```1.2``` a la ```1.2.1``` no es una actualización mayor, pero de la ```1.2``` a la ```1.3``` o la ```2.0```, si lo es.

---
## Lista  traductores:

* Traductores Activos:
	* Xeros08 
	* Zakees


* Traductores:
	* Lord Mellington
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
