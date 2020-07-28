# SceneGraph threads
SceneGraph introdujo operaciones de multihilos en la programación de aplicaciones Roku.  Los siguientes son los hilos básicos disponibles para un programador de aplicaciones SceneGraph:

- Main BrightScript thread:este es el subproceso que se inicia para todas las aplicaciones de Roku desde el archivo main.brs.  Para las aplicaciones de SceneGraph, el hilo se usa principalmente para crear la escena, que inicia el hilo de renderizado de SceneGraph.  Para otras aplicaciones, este es el único hilo para toda la aplicación.

- SceneGraph render thread: es el subproceso principal de SceneGraph que realiza todo el renderizado de los elementos visuales de la aplicación.  
 Ciertas operaciones y componentes de BrightScript que pueden bloquear o modificar SceneGraph en el hilo de renderizado no se pueden usar en este hilo.  Las operaciones y los componentes que pueden bloquear el subproceso de representación se pueden usar en un archivo task.El uso de subprocesos de estas operaciones y componentes se enumera en: https://developer.roku.com/en-ca/docs/developer-program/core-concepts/scenegraph-brightscript/brightscript-support.md 

- Task node threads:al crear y ejecutar un nodo TASK, puede iniciar subprocesos asincrónicos de BrightScript.  Estos hilos pueden realizar las operaciones más típicas de BrightScript.

# Propiedad del hilo (Thread ownership)
Todos los objetos de SceneGraph estan asociados a un hilo, que por defecto es el render thread.
Solo los componentes que extienden de Node o ContentNode pueden ser propiedad de un Task o  Main BrightScript thread cuando se crean por esos hilos
Cuando un objeto de tipo nodo se almacena en un campo,el propietario cambia al objeto nodo que contiene al campo.Cuando un objeto de tipo nodo se agrega como hijo a otro objeto nodo, el propietario de este nodo lo ocupa su padre.

Las operaciones en objetos de tipo nodo se ejecutan en el hilo del propietario.Si es invocado por otro hilo,
el hilo de invocacion debe encontrarse con el hilo propietario para ejecutar la operación.

# Encuentro de hilos (Thread rendezvous)
para la invocación del hilo se realiza una solicitud al propietario del hilo y luego espera una respuesta.  El propietario del hilo recibe la solicitud, la procesa y luego responde.Asi la primera invocacion continúa con la respuesta como si hubiera hecho la llamada a sí mismo. La respuesta aparece sincrónica al hilo de invocación.  

Solo el render thread puede servir un rendezvous.  Dado que los hilos de task no tienen un event loop implícito (aunque pueden tener un event loop explícito), no pueden servir un rendezvous.
No se puede acceder a ningún objeto nodo que sea propiedad de un Task fuera de ese hilo.  El Task por si mismo es propiedad del render thread, por lo que solo se puede acceder al Task y a sus campos mediante un rendezvous desde otros hilos, incluso del hilo lanzado por el el mismo task.  

La interfaz completa de un objeto de nodo, incluida la creación, configuración y obtención de campos, utiliza este mecanismo de encuentro para garantizar la seguridad de los subprocesos, sin tener que usar bloqueos explícitos en la aplicación y sin la posibilidad de un punto muerto.  El mecanismo de encuentro agrega más sobrecarga que la simple obtención y configuración de campo, por lo que los programadores de la aplicación SceneGraph deben usarlo con cuidado, teniendo en cuenta lo siguiente en relación con los Task threads.