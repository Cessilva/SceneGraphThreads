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

# Almacenar videos e imagenes en cachefs 

No hay forma de determinar cuanta memoria esta disponible.Se utiliza código para eliminar las imágenes más antiguas cuando descargamos nuevas y mantenemos muy pocas imágenes localmente para evitar problemas con el almacenamiento. 

Los archivos deberían persistir de esta manera al salir / reiniciar la aplicación, en cachefs: y tal vez en tmp: (inseguro sobre esto último), pero no a través del reinicio.  Y hay condiciones de poca memoria cuando el dispositivo necesita memoria, vaciará los archivos de caché para hacer espacio.  Lo cual es típico de los cachés.  La nota al margen es optimizar sus imágenes para el tamaño: mayor compresión o tal vez diseñar para HD en lugar de FHD, para que las imágenes se descarguen más rápido

>https://community.roku.com/t5/Roku-Developer-Program/Image-caching/td-p/

Puede almacenar imágenes en caché utilizando CacheFS.  De la misma manera que un archivo puede leerse desde "pkg: / filepath / filename", puede escribir y leer desde "cachefs: / filepath / filename". 
CacheFS está disponible para todos los canales en nuestra plataforma.  Si inicia el Canal A (que usa CacheFS) y luego inicia el Canal B (que también usa CacheFS) en el mismo dispositivo, es posible que las imágenes del Canal A ya no se almacenen en caché debido a restricciones de memoria de CacheFS.

A partir de Roku OS 8, se implementa [BETA] New file system for data caching:

A new file system, cachefs:, has been introduced to allow applications to cache data to volatile or persistent storage. Users who extend the persistent storage available on their device by adding an external SD card will see the biggest benefit as application data will survive reboots and benefit from additional cache space to improve performance. Users without extended storage will also benefit from the use of a shared in-memory cache that is automatically managed by the system to optimize for the most recently used asset

>https://blog.roku.com/developer/2017/10/02/roku-os-8-developer-release-notes

## In cacheTask.brs

  function init()
  m.files = createObject("roFileSystem")
  m.files.Copyfile( "pkg:/images/roku.png" , "cachefs:/roku.png" ) 
  print m.files.exists("cachefs:/roku.png")
  end function

## Problem cache whith MicroSd attached

>https://community.roku.com/t5/Roku-Developer-Program/Cachefs-Unpredictable-Behaviour/m-p/463940/highlight/false#M36963


# Cleaning cache 
From the remote control, press the following buttons consecutively:
- Press Home 5 times.
- Press Up.
- Press Rewind 2 times.
- Press Fast Forward 2 times.

# Read and write from tmp file

Este un ejemplo de como se realiza:

<p align="center"> 
<img src="/imgs/StorageTMP.png"/> 
</p> 

# STORAGE DATA IN REGISTRY

El Registry es un área de almacenamiento no volátil donde se puede almacenar una pequeña cantidad de configuraciones persistentes.  El Registro proporciona un medio para que una aplicación escriba y lea pequeñas cantidades de datos, como configuraciones, puntajes, etc. Los datos persisten incluso si el usuario sale de la aplicación e incluso si el reproductor se reinicia.  Los datos del registro se eliminan solo cuando la aplicación los elimina explícitamente, el usuario desinstala la aplicación, que elimina el registro de la aplicación, o el usuario realiza un restablecimiento de fábrica, que elimina el registro de todas las aplicaciones.  El acceso al registro está disponible a través del objeto roRegistry.  Este objeto se crea sin parámetros:

    CreateObject("roRegistry")

Puede ser escrito en un nodo Task o no , aunque la documentacion indique lo contrario (por buena programacion si tienes un firmware menor 8.0 debes realizarlo en un nodo Task, ya que hacerlo de esa manera asegura que su IU no se bloqueará mientras escribe datos en el registro ):

> https://developer.roku.com/es-mx/docs/developer-program/core-concepts/scenegraph-brightscript/brightscript-support.md

>Antes del firmware 8.0 se requería un nodo Task, pero ese ya no es el caso.  Ambos componentes se pueden usar de forma segura en el hilo de renderizado.
>ReadAsciiFile () también se puede usar en el render thread desde el firmware 8.0 y tampoco lo han actualizado.

Hay un registro separado para cada ID de desarrollador.  Esto permite que varias aplicaciones usen el registro sin poder leer o modificar el registro desde otras aplicaciones.  Si lo desea, se puede compartir un único registro en varias aplicaciones utilizando la misma ID de desarrollador para empaquetar las aplicaciones.  Esta es la forma convencional en que debería funcionar un "conjunto de aplicaciones" con preferencias compartidas y otra información compartida.  Cada registro se divide en secciones que el desarrollador especifica para la organización y agrupación de atributos.  Se proporcionan métodos en ifRegistry para enumerar las secciones en el registro y para proporcionar acceso a los datos en cada sección.  El tamaño máximo de cada registro de aplicación es de 16K bytes.  Se debe tener cuidado para minimizar la cantidad de datos almacenados y la frecuencia con la que se actualizan.

El Registro también admite el uso de una sección especial de registro transitorio.  Una sección de registro llamada "Transitoria" se puede usar para almacenar atributos que tienen la vida útil de un solo arranque.  Dentro de una sesión de arranque específica, estos valores serán persistentes para la aplicación y se almacenarán como cualquier otro valor de registro.  Cada vez que el usuario reinicia el Roku Streaming Player, todas las secciones de registro "Transitorias" se eliminan y los valores ya no persisten.  Esta técnica es útil para el almacenamiento en caché de datos para minimizar el acceso a la red, y aún así garantiza que estos datos siempre estén actualizados después de un reinicio del sistema.

El registro está encriptado y las actualizaciones requieren un rendimiento relativamente intenso y deben usarse con moderación.  Tenga en cuenta que todas las escrituras en el registro se retrasan y no se comprometen con el almacenamiento no volátil hasta que se llame explícitamente ifRegistry.Flush () o ifRegistrySection.Flush ().  La plataforma puede elegir momentos oportunos para vaciar datos por sí misma, pero ninguna aplicación es técnicamente correcta a menos que llame explícitamente a Flush () en los momentos apropiados.  Vaciar el registro es una operación relativamente lenta, por lo que debe realizarse con la menor frecuencia posible.  Los datos del Registro se almacenan de manera tolerante a fallas al preservar una copia de seguridad para cada escritura que se revierte automáticamente en caso de falla.

## SECCIONES DE REGISTRY

Una sección de registro permite la organización de configuraciones dentro del registro.  Las diferentes secciones del registro pueden tener sus propias claves con el mismo nombre.  En otras palabras, los nombres de las claves están dentro de la sección de registro a la que pertenecen.  Este objeto se debe suministrar con un nombre de "sección" en la creación.  Si no existe tal sección, se creará.  Los nombres de sección distinguen entre mayúsculas y minúsculas, por lo que las secciones denominadas "Configuración" y "configuración" son dos secciones diferentes.

    CreateObject("roRegistrySection", section as String)

Example: Get and set some user authentication in the registry
  Function GetAuthData() As Dynamic
     sec = CreateObject("roRegistrySection", "Authentication")
     if sec.Exists("UserRegistrationToken")
         return sec.Read("UserRegistrationToken")
     endif
     return invalid
  End Function

  Function SetAuthData(userToken As String) As Void
      sec = CreateObject("roRegistrySection", "Authentication")
      sec.Write("UserRegistrationToken", userToken)
      sec.Flush()
  End Function

## Other documentation
> https://community.roku.com/t5/Roku-Developer-Program/Save-Info-To-Registry/td-p/472965
## Supported interfaces
> https://developer.roku.com/es-mx/docs/references/brightscript/interfaces/ifregistrysection.md 


> Interfaces
> https://developer.roku.com/es-mx/docs/references/brightscript/interfaces/ifregistry.md 

