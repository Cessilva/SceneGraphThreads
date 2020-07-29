# Almacenamiento de aplicaciones 
Hay varios medios disponibles para que una aplicación almacene datos:
<table >
  <tr>
    <th>Storage</th>
    <th>Ventajas</th>
    <th>Desventajas</th>
  </tr>
  <tr>
    <td>file in tmp:</td>
    <td>Los archivos son de lectura / escritura</td>
    <td>El contenido no se retiene cuando la aplicación sale</td>
  </tr>
  <tr>
    <td>file in cachefs:</td>
    <td>Los archivos son de lectura / escritura;  se puede escribir una cantidad arbitraria de datos</td>
    <td>Los datos se expulsan cuando se necesita más espacio para otro canal</td>
  </tr>
  <tr>
    <td>file in pkg:</td>
    <td>Accede a cualquier archivo incluido en el paquete de la aplicación</td>
    <td>Los archivos son de solo lectura</td>
  </tr>
  <tr>
    <td>file on USB device</td>
    <td>Accede a archivos en medios USB extraíbles</td>
    <td>Files are read-only; not all Roku models support USB</td>
  </tr>
  <tr>
    <td>Registry</td>
    <td>Los datos son de lectura / escritura;  los datos se retienen cuando la aplicación sale y cuando el sistema se reinicia.</td>
    <td>Data size is limited. Each channel has access to only 16kb of registry space.</td>
  </tr>
</table>

# Cachefs
Los desarrolladores pueden usar el sistema de archivos cachefs: para permitir que las aplicaciones almacenen datos en caché para almacenamiento volátil o persistente en lugar de tmp :.  Los usuarios finales pueden agregar una tarjeta SD externa a su dispositivo que preservará los datos incluso después de reiniciar el sistema y mejorará el rendimiento.  

Los usuarios sin almacenamiento extendido también se benefician del uso de una memoria caché en memoria compartida que el sistema administra automáticamente para optimizar los activos utilizados más recientemente.  Tenga en cuenta que el sistema operativo puede desalojar los datos en cualquier momento, como cuando otro canal decide escribir tantos datos que se necesita espacio.  

Por lo tanto, un canal siempre debe verificar la existencia del archivo en el que escribió antes de confiar en la memoria caché de datos.  Dependiendo de los requisitos de su aplicación, puede elegir una de estas opciones.  Las interfaces con el ***Registry*** están documentadas en roRegistry.  Las interfaces a los archivos se describen a continuación.

>https://developer.roku.com/es-mx/docs/references/brightscript/components/roregistry.md 

El Registry es un área de almacenamiento no volátil donde se puede almacenar una pequeña cantidad de configuraciones persistentes.  El Registro proporciona un medio para que una aplicación escriba y lea pequeñas cantidades de datos, como configuraciones, puntajes, etc. Los datos persisten incluso si el usuario sale de la aplicación e incluso si el reproductor se reinicia.  Los datos del registro se eliminan solo cuando la aplicación los elimina explícitamente, el usuario desinstala la aplicación, que elimina el registro de la aplicación, o el usuario realiza un restablecimiento de fábrica, que elimina el registro de todas las aplicaciones.  El acceso al registro está disponible a través del objeto roRegistry.  Este objeto se crea sin parámetros:

    CreateObject("roRegistry")

Hay un registro separado para cada ID de desarrollador.  Esto permite que varias aplicaciones usen el registro sin poder leer o modificar el registro desde otras aplicaciones.  Si lo desea, se puede compartir un único registro en varias aplicaciones utilizando la misma ID de desarrollador para empaquetar las aplicaciones.  Esta es la forma convencional en que debería funcionar un "conjunto de aplicaciones" con preferencias compartidas y otra información compartida.  Cada registro se divide en secciones que el desarrollador especifica para la organización y agrupación de atributos.  Se proporcionan métodos en ifRegistry para enumerar las secciones en el registro y para proporcionar acceso a los datos en cada sección.  El tamaño máximo de cada registro de aplicación es de 16K bytes.  Se debe tener cuidado para minimizar la cantidad de datos almacenados y la frecuencia con la que se actualizan.

El Registro también admite el uso de una sección especial de registro transitorio.  Una sección de registro llamada "Transitoria" se puede usar para almacenar atributos que tienen la vida útil de un solo arranque.  Dentro de una sesión de arranque específica, estos valores serán persistentes para la aplicación y se almacenarán como cualquier otro valor de registro.  Cada vez que el usuario reinicia el Roku Streaming Player, todas las secciones de registro "Transitorias" se eliminan y los valores ya no persisten.  Esta técnica es útil para el almacenamiento en caché de datos para minimizar el acceso a la red, y aún así garantiza que estos datos siempre estén actualizados después de un reinicio del sistema.

El registro está encriptado y las actualizaciones requieren un rendimiento relativamente intenso y deben usarse con moderación.  Tenga en cuenta que todas las escrituras en el registro se retrasan y no se comprometen con el almacenamiento no volátil hasta que se llame explícitamente ifRegistry.Flush () o ifRegistrySection.Flush ().  La plataforma puede elegir momentos oportunos para vaciar datos por sí misma, pero ninguna aplicación es técnicamente correcta a menos que llame explícitamente a Flush () en los momentos apropiados.  Vaciar el registro es una operación relativamente lenta, por lo que debe realizarse con la menor frecuencia posible.  Los datos del Registro se almacenan de manera tolerante a fallas al preservar una copia de seguridad para cada escritura que se revierte automáticamente en caso de falla.

> Interfaces
> https://developer.roku.com/es-mx/docs/references/brightscript/interfaces/ifregistry.md 

# Read and write from temp file

# Cleaning cache 
From the remote control, press the following buttons consecutively:
Press Home 5 times.
Press Up.
Press Rewind 2 times.
Press Fast Forward 2 times.