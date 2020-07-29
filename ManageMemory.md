# Texture memory
Un error comun es usar mucha memoria de textura.El uso de una imagen  grande no necesariamente garantiza un resultado final de mayor calidad. Por el contrario, el uso de imágenes innecesariamente grandes a menudo generará problemas de rendimiento.  Todos los dispositivos Roku tienen una cantidad dedicada de memoria de textura, que varía en gran medida de un dispositivo a otro.  Cada imagen única que le gustaría mostrar en su canal ocupará una cierta cantidad de memoria de textura limitada (sin embargo, la reutilización de la misma imagen en múltiples nodos no ocupará más memoria).  Más específicamente, el tamaño en bytes del archivo de imagen no importa (por lo que comprimir sus imágenes es intrascendente), más bien, la dimensión en píxeles de la imagen es estrictamente importante.  Las imágenes se cargan en la memoria de textura en forma de mapas de bits, ocupando 4 bytes por píxel (RGBA).  Un cálculo rápido (ancho x alto x 4B) puede ayudarlo a aproximar cuánta memoria de textura ocuparán sus imágenes.

Here is small list of the amount of texture memory available to your channel to use on various devices:

- Tyler: 20 MB
- Giga: 44-45 MB
- Mustang/Austin: 60 MB

Si su canal termina superando cualquiera de estos límites al intentar mostrar más de lo que la memoria de texturas puede permitir, entonces su canal tendrá un comportamiento inesperado en esos dispositivos.  Un síntoma común son las imágenes parpadeantes o la carga lenta del contenido, ya que los mapas de bits se descargarán y volverán a cargar constantemente en la memoria en un esfuerzo por gestionar el exceso de imágenes.  Incluso si sus imágenes no usan toda la memoria de textura en un dispositivo, su canal se cargará más lentamente en general si contiene imágenes más grandes.

# How to see texture memory
1. telnet to your roku at port 8080
2. If your channel is SceneGraph run this command: "loaded_textures"
Tenga en cuenta que hay un caché de texturas, por lo que las imágenes que no son visibles se pueden borrar automáticamente.

Si su canal es anterior a SceneGraph, API 2D o plantilla, ejecute este comando: "r2d2_bitmaps".
   

# Cómo evitar sobrepasar los límites de memoria
## Haga las imágenes más pequeñas 
¡La solución más simple!  Si planea mostrar una imagen en un nodo Poster de 200x200, no cargue y renderice una imagen de 1920x1080.  Funcionará, pero será un desperdicio de recursos del sistema sin beneficio real.  Un cálculo rápido pone una imagen de 1920x1080 usando una enorme (1920 • 1080 • 4 = ~ 8.3MB) de memoria, mientras que la imagen de 200x200 del tamaño apropiado solo ocupará ~ 0.16MB.  El uso de los campos loadWidth y loadHeight de un nodo Poster sería una solución equivalente para cambiar el tamaño de las imágenes.

## Use representadores de elementos minimalistas 
Cuantos menos elementos, mejor.  Utilice nodos Rectángulo (no requieren un mapa de bits cargado en la memoria), sobre nodos Poster siempre que sea posible.  Tenga en cuenta que incluso los mapas de bits para elementos como anillos de enfoque y fondos de teclado ocupan memoria de textura, así que tenga cuidado de no usar imágenes innecesariamente grandes para estos.

# Depuración del rendimiento de la memoria de textura
Usando el comando "r2d2_bitmaps" para verificar la cantidad de memoria de textura disponible:

<p align="center"> 
<img src="/imgs/MemoryTexture.png"/> 
</p> 

Este comando generará una lista de direcciones de memoria que representan los activos cargados en la memoria de textura, su ancho y alto, así como su tamaño en bytes.  En la parte inferior, también muestra la memoria disponible que le queda en su dispositivo, la cantidad utilizada y la cantidad que el dispositivo tiene en total.  Si su canal usa múltiples imágenes de alta resolución (por ejemplo, más de dos imágenes de 1920 x 1080), notará que la memoria disponible alcanzará un pico en algún lugar inferior a la cantidad máxima y seguirá fluctuando entre los valores a medida que el administrador de memoria de texturas intente descargar activos y  volviéndolos a cargar para administrar la memoria.  ¡Asegúrate de usar las técnicas de rendimiento enumeradas en esta guía para que tu canal no se encuentre con estos problemas!

# Memoria del sistema (DRAM)
- Los dispositivos Roku tienen desde 256 MB de DRAM en los dispositivos finales más bajos, hasta 1,5 GB de DRAM en la plataforma Dallas. 

- Si bien muchas aplicaciones como el procesamiento de imágenes o el software de modelado 3D se benefician enormemente de una gran cantidad de RAM, este no suele ser el caso de los canales que se ejecutan en el sistema operativo Roku.

- Para casi todos los canales, la RAM no será un cuello de botella para el rendimiento a menos que tenga una pérdida grave de memoria en alguna parte.  

- Es mucho más probable que un canal golpee la memoria de textura o este al tope el CPU a que se quede sin RAM, y su canal está protegido de manera que el dispositivo Roku siempre asignará y guardará suficiente RAM para el almacenamiento en búfer de video.  Además, si su canal usa una gran cantidad de RAM (más de ~ 80 MB), simplemente se eliminará antes de que los golpes de rendimiento sean notables.

# Visualización de la memoria del sistema
## For SceneGraph apps
Para las aplicaciones SceneGraph, al igual que arriba, ejecute el canal y el puerto 8080. Luego ejecute: ***sgnodes all***

<p align="center"> 
<img src="/imgs/Sgnodes.png"/> 
</p> 

## For pre-SceneGraph apps
For pre-SceneGraph apps, telnet to the console; hit ^C to break into the debugger; run ***bcs*** or ***bscs***
