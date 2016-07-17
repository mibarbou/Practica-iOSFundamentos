# Practica-iOSFundamentos
Práctica para el módulo de iOS Fundamentos del Master KeepCoding.


- Con *as?* podemos hacer un casteo optional que devolverá el tipo que le indiquemos en el caso que lo sea, o nil si no lo es.

- Los datos a cachear los guardaría en el *documents directory* si nunca van a cambiar, si es posible que cambien usaría el Temporary directory.

- Los favoritos los guardo en el NSUserDefaults dentro de un NSArray, dicho array contiene los strings del nombre de los archivos de los pdf de los libros, para asegurarme que son únicos. También se podrían guardar en un plist.

- Cuando la propiedad isFavorite cambia, el didSet de la propiedad lanza una notificación a la que está suscrita el modelo Library, que al recibirla hace los cambios necesarios, y manda un notificación diciendo que el modelo de la libería ha cambiado, los controladores interesados se suscriben a esta notificación y actuan en consecuencia sincronizando la vista con el modelo actualizado, en nuestro caso al ser una tabla invocaremos el recargado de la tabla, y lo mismo haría el controlador del detalle del libro que se suscribiría a dicha notificación para que actualice su modelo con la vista y cambie el aspecto delboton de favoritos. También se podría hacer lo mismo con delegado, con KVO o con ReactiveSwift. Para mí la mejor opción sería hacerlo con KVO o con ReactiveSwift, ya que me parece muy engorroso usar notificaciones o delegados para esto.

- El recargado de una tabla no es un problema siempre y cuando no se invoque con demasiada frecuencia.

- Para actualizar la vista del pdf utilizo las notificaciones al momento de pulsar un libro en la vista de la tabla, dicha notificación enviará a través del userinfo el objeto del modelo del libro que seraá recibido via notificación por el controlador del pdf para que sincronice la vista con dicho modelo recibido.

- Como funcionalidades extras le añadiría un buscador a la tabla de los libros, y cuando estan ordenadas alfabéticamente haría que se puediera salta por la letra inicial del nombre de los libros, al igual que se hace en las tablas de agendas telefónicas. También sería interesante que se pudieran añadir libros.



