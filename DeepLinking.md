# Deep linking
Deep linking permite a los usuarios acceder a su contenido más rápido desde la UI de Roku via ***Roku's content discovery features*** (por ejemplo, **Roku Search** ó  ***Roku home screen banners***).  Con Deep linking,tu canal inicia en reproducción(playback) o trampolines de contenido(content springboards) directamente desde la UI de Roku.

 Por ejemplo, cuando se selecciona una película de Roku Search, la reproducción comienza inmediatamente sin ninguna navegación de canal.  Esta funcionalidad le permite aprovechar las funciones de descubrimiento de contenido de Roku (Roku's content discovery features) para llevar a los usuarios a su canal y aumentar la participación.

# Vision general 
When content is selected, the contentId and mediaType are passed as query string parameters to the channel. The channel accepts and validates the deep linking parameters and identifies the appropriate launch behavior, which is determined by the mediaType. In this example, contentId "loganLucky123" corresponds to the film "Logan Lucky", and the mediaType is "movie". The "movie" mediaType requires the channel to launch directly into playback (see MediaType behavior for more information on the launch behavior required for different mediaTypes).

Cuando se selecciona el contenido,el contentId y mediaType se pasan como parámetros de cadena de consulta al canal.  El canal acepta y valida los parámetros de deep linking e identifica el comportamiento de lanzamiento apropiado, que está determinado por mediaType.  En este ejemplo, contentId "loganLucky123" corresponde a la película "Logan Lucky", y mediaType es "movie".  El mediaType "movie" requiere que el canal se inicie directamente en reproducción 

> (consulte Comportamiento de MediaType para obtener más información sobre el comportamiento de inicio requerido para diferentes tipos de medios).
>https://developer.roku.com/es-mx/docs/developer-program/discovery/implementing-deep-linking.md#mediatype-behavior

<table >
  <tr>
    <th>mediaType in Deep Link</th>
    <th>Description</th>
    <th>Comportamiento de lanzamiento requerido</th>
  </tr>
  <tr>
    <td>movie</td>
    <td>Película o película de formato largo (más de 15 minutos)</td>
    <td>Reproduce la película identificada por contentId.  Utilice BOOKMARKS para determinar la posición de reproducción.</td>
  </tr>
  <tr>
    <td>episode</td>
    <td>Elemento de contenido único (Ejemplo:episodio de un programa de televisión).</td>
    <td>Reproduce el episodio identificado por contentId.  Utilice BOOKMARKS para determinar la posición de reproducción.</td>
  </tr>
  <tr>
    <td>season</td>
    <td>Forma parte de una serie, conjunto único de episodios de televisión relacionados.</td>
    <td>Lanzar la plataforma de contenido que muestra episodios organizados por temporada;  resalta el episodio asignado al contentid.</td>
  </tr>
  <tr>
    <td>series</td>
    <td>Conjunto de episodios serializados relacionados y posiblemente temporadas.  Incluye programas de televisión y diarios semanales de shows en marcha.</td>
    <td>Lanza un episodio en reproducción directa utilizando BOOKMARKS inteligentes.  Un BOOKMARKS inteligente determina el episodio que se lanzará y la posición de reproducción según el tipo de serie, si el usuario ha visto la serie anteriormente y si completó el último episodio visto.  
    
    Los diferentes tipos de series y su comportamiento de marcador inteligente recomendado son los siguientes:
<ul>
<li>Followed TV (a series that the user has already started watching in the past): Use bookmarks to determine whether the user completed the previously watched episode. If they completed the last episode, launch the next episode in the series. If they did not, launch the episode where the user stopped watching.</li>
<li>Unwatched TV (a cataloged series that the user has not yet watched on your service): launch playback at the beginning of S1E1.
</li>
<li>
Unwatched TV (a cataloged series that the user has not yet watched on your service): launch playback at the beginning of S1E1.
</li>
</ul>
</td>
  </tr>

</table>

