# Measuring channel performance(Medicion del rendimiento del canal)

A partir de Roku OS 9.1, el sistema operativo Roku registra métricas clave de rendimiento del canal, como el tiempo de inicio del canal, el tiempo de cambio del canal, el tiempo de salida del canal y el tiempo de inicio del video a través de balizas de señal. Las señales de faro,modelo o baliza son marcadores para los puntos de inicio y finalización de acciones iniciadas por el usuario. 

Para medir el tiempo de inicio del canal, por ejemplo, las balizas se disparan cuando un usuario presiona OK para seleccionar un canal del inicio de Roku (marcando el punto de inicio) y cuando el canal seleccionado esta completamente renderizado (el punto de parada).  El tiempo transcurrido entre los puntos de inicio y fin se registra y se puede ver con la consola de BrightScript. 

Luego puede usar los comentarios de la consola para actualizar su aplicación, si es necesario, para cumplir con los requisitos de certificación.

> Channel launch and video start times must meet the specified
> https://developer.roku.com/es-mx/docs/developer-program/certification/certification.md#3performance

# Measuring EPG launch times (Medición de tiempos de lanzamiento de EPG)

Si su canal contiene una EPG, la aplicación también debe disparar balizas cuando el usuario inicia una pulsación de tecla para mostrar la EPG (EPGLaunchInitiate) y cuando la EPG está completamente renderizada y navegable (EPGLaunchComplete).  

El siguiente ejemplo muestra cómo hacer esto:

    myEPGComponent.signalBeacon(“EPGLaunchInitiate”)
    m.top.signalBeacon(“EPGLaunchComplete”)

Only the first sequence of EPG launch beacons is recorded. If a user launches the EPG more than once while the channel is running, a warning message is output to the debug console. This warning message, which acknowledges the receipt of the beacon while notifying that subsequent ones will not be recorded, may be ignored.

Only EPG launch sequences that start within 5 seconds of the AppLaunchComplete event being fired qualify as a valid measurements for certification. EPG launch sequences fired after the 5-second window are still recorded so that channel performance can be compared against requirements.

Solo se registra la primera secuencia de balizas de lanzamiento de EPG.  Si un usuario inicia la EPG más de una vez mientras el canal se está ejecutando, se envía un mensaje de advertencia a la consola de depuración.  Este mensaje de advertencia, que confirma el recibo de la baliza mientras notifica que no se grabarán las posteriores, puede ignorarse.  

***Solo las secuencias de lanzamiento de EPG que comienzan dentro de los 5 segundos posteriores al lanzamiento del evento AppLaunchComplete califican como medidas válidas para la certificación.***  Las secuencias de lanzamiento de EPG disparadas después de la ventana de 5 segundos todavía se graban para que el rendimiento del canal se pueda comparar con los requisitos.

# Viewing channel performance metrics(Ver métricas de rendimiento del canal)

You can use the BrightScript console (port 8085) to view a log with your channel's performance metrics. When a beacon is fired, the console immediately outputs statistics related to the initiate or complete beacon. When you exit your channel, the console displays a report summarizing the statistics for the just-concluded session, which are described as follows:

> https://developer.roku.com/es-mx/docs/developer-program/performance-guide/measuring-channel-performance.md


<table >
  <tr>
    <th>Estadística</th>
    <th>Tipo de beacon</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>TimeBase</td>
    <td>Initiate</td>
    <td>Una marca de tiempo para el beacon basada en los milisegundos transcurridos desde que se grabó el beacon initiate para el lanzamiento del canal.</td>
  </tr>
  <tr>
    <td>Duration</td>
    <td>Complete</td>
    <td>Milliseconds entre el initiate y el complete beacons.</td>
  </tr>
  <tr>
    <td>Memory Points (MiP, KiP, or p)</td>
    <td>Complete</td>
    <td>Los puntos de memoria proporcionan una medida relativa para el rendimiento de la memoria de su canal que se puede utilizar para el análisis de tendencias.  Puede monitorear la cantidad de puntos de memoria informados para cualquier beacon complete para ver si sube o baja en las compilaciones de su aplicación.  Los puntos de memoria se miden en mebipoints (MiP), kibipoints (KiP) o puntos (p).  Esto es similar a cómo las unidades de información se expresan como mebibytes (MiB), kibibytes (Kib) y bytes.</td>
  </tr>
  <tr>
    <td>SteadyMaxMemPoints</td>
    <td>N/A</td>
    <td> La cantidad máxima de puntos de memoria que su aplicación usó durante un intervalo de 5 segundos (el uso de este intervalo evita que los picos temporales se registren como el máximo).  
    TimeBase y duration indican el período en que se produjo el uso máximo.</td>
  </tr>
</table>

## PROBANDO EL RENDIMIENTO DE ALGUNO DE NUESTROS CANALES 
### TIMEGRID 
> https://github.com/Cessilva/TimeGridView

### COMPILING
<p align="center"> 
<img src="/imgs/TimeGridViewCompile.png"/> 
</p> 

### RUNNING
<p align="center"> 
<img src="/imgs/TimeGridView.png"/> 
</p> 

# Channel performance metrics reference(Referencia de métricas de rendimiento del canal)

El sistema operativo Roku puede medir y registrar métricas de rendimiento de ocho canales: channel launch, app compile, dialog launch, Electronic Program Guide (EPG) launch, video start, live start, channel change, and channel exit.  Para cada métrica de rendimiento del canal, la siguiente tabla enumera cómo se miden y cuándo se disparan sus balizas de inicio y finalización.

> https://developer.roku.com/es-mx/docs/developer-program/performance-guide/measuring-channel-performance.md
