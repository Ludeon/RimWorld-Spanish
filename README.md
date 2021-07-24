# Spanish Translation of Rimworld
Esta es la **traducción al español** Castellano (de España) de Rimworld.

Consulta esta página para obtener información sobre la licencia e información adicional sobre cómo ayudar

[Licencia y aportar a las traducciones](http://ludeon.com/forums/index.php?topic=2933.0)


---
### Para empezar a colaborar entra al nuevo  Discord de traducción: [Team Facción Latina](https://discord.gg/EjK52KM) (Actualizado el 24/07/2021) 

---
### Instalación de las últimas traducciones
Las traducciones que vienen con el juego no se actualizan automáticamente.

Cada vez que el juego se actualiza, Ludeon coge los archivos de los repositorios oficiales y los "empaqueta" para incluirlos en el juego.

Si queréis actualizar las traducciones a las más recientes; seguid [esta guía](Instalation/InstallGuide.md).

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
* En Activo:
	* [Raúl Naharro Fernández (Zakees)](https://github.com/Zakees)
	* [Miguel Angel Farias (Zerstrick)](https://github.com/Zerstrick)
	* [Aser Granado Amores (Xeros08)](https://github.com/Xeros08)
	* [Creepynstoid](https://github.com/Creepynstoid)

* Colaboradores:
	* [Juan Melenchón Ramírez (Lord Mellington)](https://github.com/LordMellington)
	* [Capiqua](https://github.com/capiqua)
	* [Gaesatae](https://github.com/Gaesatae) 
	* [Ismael García Cruzado (Ghrull)](https://github.com/Ghrull)
	* [Vhiden](https://github.com/Vhiden)
	* [Guntrek](https://github.com/Guntrek)
	* [Yllelder](https://github.com/Yllelder)
	* [Emsaic](https://github.com/Emsaic)
	* [Alvirolo](https://github.com/Alvirolo)
	* [Mototron](https://github.com/Mototron)
	* [Amatiasq](https://github.com/amatiasq)
	* [Azarashi](https://github.com/AzarashiEsp)