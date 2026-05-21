Este panel interactivo es el Producto Académico del curso Herramientas Informáticas I, dictado por el profesor Joel Jovani Turco Quinto en la Maestría en Economía con mención en Data Analytics de la Universidad Continental. Para la elaboración de este dashboard se usó el lenguaje R, transformamos las estadísticas históricas de Gapminder en un visor dinámico. Para asegurar su disponibilidad y transparencia, el código se subió a GitHub y la aplicación se desplegó en shinyapps 
<img width="1023" height="526" alt="image" src="https://github.com/user-attachments/assets/4f6e6001-d4d8-46b5-9e4f-9dbf3de03f79" />

1. Introducción
El presente proyecto consiste en el desarrollo de un dashboard interactivo utilizando el lenguaje de programación R y el framework Shiny, aplicado a la base de datos Gapminder
El propósito de esta aplicación web interactiva es facilitar la exploración libre y dinámica de los datos. La herramienta permite a cualquier usuario analizar, de manera visual y sencilla, la evolución simultánea de la economía y la esperanza de vida global que va desde 1952 hasta 2007.
Para construir este tablero usamos el lenguaje R y un grupo de herramientas listas para usar (paquetes):
•	Para armar la página web: shiny y shinydashboard (diseñan los botones, menús y pestañas).
•	Para organizar los datos: dplyr (funciona como un filtro inteligente de datos).
•	Para los gráficos y mapas: ggplot2 y plotly (hacen que los gráficos se muevan y muestren información al pasar el mouse por encima).

3. Preparación de los Datos
Antes de mostrar la información, se configuró lo siguiente para una mayor comprensión:
•	Traducción: Cambia los nombres de los continentes al español 

•	Cálculo del PBI Total: Multiplica el dinero por persona (PBI per cápita) por la cantidad de habitantes para saber el tamaño económico real de cada país.

•	Unión con el mapa: Conecta los nombres de los países con un mapa del mundo para poder pintarlo más adelante.
 
4. Las Variables Analizadas
El tablero se enfoca en cuatro indicadores principales:
1.	PBI per cápita: El promedio de ingresos de una persona en ese país (indica riqueza).
2.	Esperanza de Vida: Cuántos años se espera que viva una persona (indica salud pública).
3.	Población: Cuántos habitantes tiene el país.
4.	Índice de Desarrollo (Creado por nosotros): Un puntaje del $0$ al $1$ que combina la salud y la riqueza para medir el bienestar general (donde $1$ es el nivel más alto).

5. Diseño de la Pantalla (Interfaz de Usuario)
La aplicación es muy fácil de usar y se divide en dos partes:
•	El menú de la izquierda: Contiene botones para elegir el continente, el país, el año que quieres ver y cuántos países quieres en el ranking.

•	El centro de la pantalla: Cambia según la pestaña que elijas. Tiene 7 opciones:
 

o	Resumen: Cuadros con números grandes y un gráfico general.

o	Relaciones: Gráficos para ver si los países con más dinero tienen mejor salud.





o	Rankings: Listas de los países "top" en economía y salud.

o	Evolución: Líneas de tiempo para ver si un país mejoró o empeoró con los años.

 
o	Comparación y Animación: Gráficos con un botón de "Play" para ver la historia en movimiento.

o	Mapa: Un mapa mundial que cambia de color según la esperanza de vida.
 
o	Tabla: Una lista con todos los números listos para revisar.

6. Ejecución y Uso
•	La aplicación se enciende con una sola línea de código al final del script: shinyApp(ui, server).
•	Se puede usar directamente en la computadora o subirse a internet. En este caso cualquier usuario usarla desde su celular o computadora sin necesidad de saber programar dado que el dashboard está publicado en internet.
7. Ventajas del Tablero
•	Toda la información del mundo recolectada durante décadas se encuentra en un solo lugar donde el usuario puede usar botones y filtros para encontrar exactamente lo que necesita.
•	Al ser visual, cualquier persona entiende los datos de inmediato gracias a los colores y tamaños de los gráficos 
8. Limitaciones
•	La base de datos original llega solo hasta el año 2007, por lo que no incluye eventos recientes.
•	No se incluyeron datos como la educación, la inflación o la desigualdad social.
9. Conclusiones
•	Se logró crear una herramienta interactiva, moderna y útil para el análisis económico de la maestría.
•	Al usar el tablero se demuestra visualmente que, aunque la salud del mundo ha mejorado en todos lados, la brecha económica entre los países ricos y pobres sigue siendo muy grande.
•	La programación y la economía se unen aquí para hacer que los datos complejos sean fáciles de entender para todos.
