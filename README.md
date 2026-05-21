Este panel interactivo es el Producto Académico del curso Herramientas Informáticas I, dictado por el profesor Joel Jovani Turco Quinto en la Maestría en Economía con mención en Data Analytics de la Universidad Continental. Para la elaboración de este dashboard se usó el lenguaje R, transformamos las estadísticas históricas de Gapminder en un visor dinámico. Para asegurar su disponibilidad y transparencia, el código se subió a GitHub y la aplicación se desplegó en shinyapps 
<img width="1023" height="526" alt="image" src="https://github.com/user-attachments/assets/4f6e6001-d4d8-46b5-9e4f-9dbf3de03f79" />

1. Introducción
El presente proyecto consiste en el desarrollo de un dashboard interactivo utilizando el lenguaje de programación R y el framework Shiny, aplicado a la base de datos Gapminder
El propósito de esta aplicación web interactiva es facilitar la exploración libre y dinámica de los datos. La herramienta permite a cualquier usuario analizar, de manera visual y sencilla, la evolución simultánea de la economía y la esperanza de vida global que va desde 1952 hasta 2007.
Para construir este tablero usamos el lenguaje R y un grupo de herramientas listas para usar (paquetes):
•	Para armar la página web: shiny y shinydashboard (diseñan los botones, menús y pestañas).
•	Para organizar los datos: dplyr (funciona como un filtro inteligente de datos).
•	Para los gráficos y mapas: ggplot2 y plotly (hacen que los gráficos se muevan y muestren información al pasar el mouse por encima).
<img width="321" height="272" alt="image" src="https://github.com/user-attachments/assets/cecc389e-9100-4cde-b570-a4db6237cfcd" />

3. Preparación de los Datos
Antes de mostrar la información, se configuró lo siguiente para una mayor comprensión:
•	Traducción: Cambia los nombres de los continentes al español 
<img width="381" height="260" alt="image" src="https://github.com/user-attachments/assets/476e1cbf-23e2-4d38-97d4-0d3d7c81c516" />


•	Cálculo del PBI Total: Multiplica el dinero por persona (PBI per cápita) por la cantidad de habitantes para saber el tamaño económico real de cada país.
<img width="481" height="48" alt="image" src="https://github.com/user-attachments/assets/9f7b0d67-9902-48be-9d9f-8ce82abc1433" />

•	Unión con el mapa: Conecta los nombres de los países con un mapa del mundo para poder pintarlo más adelante.
 <img width="594" height="137" alt="image" src="https://github.com/user-attachments/assets/13b47070-c3d3-40c1-b5d2-0280645c8218" />

4. Las Variables Analizadas
El tablero se enfoca en cuatro indicadores principales:
1.	PBI per cápita: El promedio de ingresos de una persona en ese país (indica riqueza).
2.	Esperanza de Vida: Cuántos años se espera que viva una persona (indica salud pública).
3.	Población: Cuántos habitantes tiene el país.
4.	Índice de Desarrollo (Creado por nosotros): Un puntaje del $0$ al $1$ que combina la salud y la riqueza para medir el bienestar general (donde $1$ es el nivel más alto).
<img width="565" height="127" alt="image" src="https://github.com/user-attachments/assets/22ce16e0-560e-40b5-81d1-5f6a42d026ef" />


5. Diseño de la Pantalla (Interfaz de Usuario)
La aplicación es muy fácil de usar y se divide en dos partes:
•	El menú de la izquierda: Contiene botones para elegir el continente, el país, el año que quieres ver y cuántos países quieres en el ranking.
<img width="919" height="481" alt="image" src="https://github.com/user-attachments/assets/06e43784-f74d-49f8-963c-579db04c885b" />


•	El centro de la pantalla: Cambia según la pestaña que elijas. Tiene 7 opciones:
 

o	Resumen: Cuadros con números grandes y un gráfico general.
<img width="1090" height="555" alt="image" src="https://github.com/user-attachments/assets/76d23edd-734b-448e-ae5a-7fec4c7a8d3c" />

o	Relaciones: Gráficos para ver si los países con más dinero tienen mejor salud.
<img width="1090" height="613" alt="image" src="https://github.com/user-attachments/assets/f9d142e7-0268-4dd9-a248-6bcf16285b51" />





o	Rankings: Listas de los países "top" en economía y salud.
<img width="1090" height="601" alt="image" src="https://github.com/user-attachments/assets/86e9b8d5-01b6-47e5-83aa-baf8f801a3c0" />

o	Evolución: Líneas de tiempo para ver si un país mejoró o empeoró con los años.
<img width="1090" height="598" alt="image" src="https://github.com/user-attachments/assets/2882c0d0-fa3c-45fb-934b-43e7ffb9db82" />

 
o	Comparación y Animación: Gráficos con un botón de "Play" para ver la historia en movimiento.
<img width="1090" height="635" alt="image" src="https://github.com/user-attachments/assets/b5b96af1-2bdc-42ba-abc3-0ec522e309c6" />

o	Mapa: Un mapa mundial que cambia de color según la esperanza de vida.
 <img width="1090" height="411" alt="image" src="https://github.com/user-attachments/assets/de5ae34b-3552-4d11-b3f9-d53987608e65" />

o	Tabla: Una lista con todos los números listos para revisar.
<img width="1090" height="486" alt="image" src="https://github.com/user-attachments/assets/25a3fff4-6eae-4521-9b9a-ccf7d6590c0f" />

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
