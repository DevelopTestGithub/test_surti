Surtido, mobil.

# Estandares

Nombres de archivos
Todos los archivos tienen nomenclatura en minuscula con "_" subguiones entre palabras, esto incluye carpetas, e imagenes.

## Orden
- -  Constantes
- -  Finales
- - Privadas
- - Constructores()
- - Factories
- - Funciones publicas
- - Dependencias de esa funcion
- - Funciones privadas
- Usar la menor cantitad de stateful widgets.
- - Stateless widgets son modificados facilmente por stateful widget
- - Stateful widgets modifican todas sus dependencias.
- Cargas de Apis deben ser escondidas como se puedan
- - Revisar que los Apis no carguen si ya estan cargando
- - desabilitando interaccion.
- - Toda carga tiene manejo de errores

## Clases
- Solo debe entrar a una clase por una razon, cada clase/archivo tiene solo una responsabilidad. Clases tienen un tamaño de 200 - 400 lineas
- Dividir una clase, si es posible si es necesario, poner en una carpeta del mismo nombre.

## Nombres de variables
- Classes y Enumeradores tienen camel case con Mayuscula inicial "CamelCase"
- variables publicas o finales tienen camel case con minuscula inicial "lowCamelCase" 
- variables privadas con subguion inicial y lowerCamel case "_subguionYLowerCamelCase"
- constantes y internas de enumeradores con Mayusculas y suguion entre si.

## Clases cosas propias.
- WillPopScope debe ser manejado en cada pagina.

## Git
- Toda historia es un feature que debe ser enviado en la forma de un Pull Request.
- Se debe enviar en su propia rama, con el codigo de jira de la historia, y el tipo de actividad, sea (mob) = mobile, (back) = backend
- - rama es = pullRequests/[Nombre]/[codigo de Jira]

