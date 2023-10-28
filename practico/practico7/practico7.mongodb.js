//ctrl + alt + s
//ctrl + shift + i prettier
// 1 ->  ascendente
// -1 -> descendente
/*
ejercicio1
Insertar 5 nuevos usuarios en la colección users. Para cada nuevo usuario creado,
insertar al menos un comentario realizado por el usuario en la colección comments.
*/
use("mflix");
db.users.insertMany([
  { name: "cabeza de rosca", email: "rosca@gmail.com", password: "compila1" },
  { name: "cabeza de cello", email: "cello@gmail.com", password: "compila2" },
  {
    name: "cabeza de ladrillo",
    email: "ladrillo@gmail.com",
    password: "compila3",
  },
  { name: "cabeza de album", email: "album@gmail.com", password: "compila4" },
  { name: "cabeza de cpu", email: "cpu@gmail.com", password: "compila5" },
]);

use("mflix");
db.users.find({ name: "cabeza de rosca" });

use("mflix");
db.comments.insertMany([
  {
    name: "cabeza de rosca",
    email: "rosca@gmail.com",
    movie_id: {
      $oid: "573a1390f29313caabcd418c",
    },
    text: "malisima pelicula",
    data: "2023-03-26T23:20:16Z",
  },
  {
    name: "cabeza de cello",
    email: "cello@gmail.com",
    movie_id: {
      $oid: "573a1390f29313caabcd418c",
    },
    text: "maso pelicula",
    data: "2022-03-26T23:20:16Z",
  },
  {
    name: "cabeza de ladrillo",
    email: "ladrillo@gmail.com",
    movie_id: {
      $oid: "573a1390f29313caabcd418c",
    },
    text: "buena pelicula",
    data: new Date(),
  },
]);

use("mflix");
db.comments.find({ name: "cabeza de ladrillo" });

/* 
ejercicio 2
Listar el título, año, actores (cast), directores y rating de las 10 películas con
mayor rating (“imdb.rating”) de la década del 90. ¿Cuál es el valor del rating de 
la película que tiene mayor rating? (Hint: Chequear que el valor de “imdb.rating” sea de 
tipo “double”).
*/
use("mflix");
db.movies
  .find(
    {
      "imdb.rating": {
        $ne: "",
        $not: { $type: "string" },
      },
      year: {
        $gte: 1990,
        $lt: 2000,
      },
    },
    {
      title: true,
      cast: true,
      directors: true,
      "imdb.rating": true,
      year : true
    }
  )
  .sort({ "imdb.rating": -1 })
  .limit(10);

/*
ejercicio 3
Listar el nombre, email, texto y fecha de los comentarios que
la película con id (movie_id) ObjectId("573a1399f29313caabcee886") recibió entre los 
años 2014 y 2016 inclusive. Listar ordenados por fecha. Escribir una nueva consulta 
(modificando la anterior) para responder ¿Cuántos comentarios recibió? 
*/

use("mflix");
db.comments
	.find(
	{
		movie_id : ObjectId("573a1399f29313caabcee886"),
		date: { $gte: ISODate("2014-01-01T00:00:00.000Z"), $lt: ISODate("2017-01-01T00:00:00.000Z") }
	},
	{
		name : true,
		email : true,
		text : true,
		date : true
	}
	).sort({date : -1})

//contar cantidad
use("mflix");
db.comments
	.find(
	{
		movie_id : ObjectId("573a1399f29313caabcee886"),
		date: { $gte: ISODate("2014-01-01T00:00:00.000Z"), $lt: ISODate("2017-01-01T00:00:00.000Z") }
	},
	{
		name : true,
		email : true,
		text : true,
		date : true
	}
	).sort({date : -1}).count()
	
/* 
ejercicio 4
Listar el nombre, id de la película, texto y fecha de los 3 comentarios más 
recientes realizados por el usuario con email patricia_good@fakegmail.com. 
*/
use("mflix")
db.comments
	.find({
		email : "patricia_good@fakegmail.com"
	},
	{
		name : true,
		movie_id : true,
		"date" : true,

	}).sort({"date" : -1})
	.limit(3)

/*
ejercicio 5
Listar el título, idiomas (languages), géneros, fecha de lanzamiento (released) y 
número de votos (“imdb.votes”) de las películas de géneros Drama y Action (la película puede tener otros géneros adicionales), que solo están disponibles en un único idioma y por último tengan un rating (“imdb.rating”) mayor a 9 o bien tengan una duración (runtime) de al menos 180 minutos.
Listar ordenados por fecha de lanzamiento y número de votos.
*/
use("mflix")
db.movies
	.find(
	{
		genres : {$all : ["Drama", "Action"]},
		languages : {$size : 1},
		$or : [
			{runtime : {$gte : 180}},
			{rating : {$gt : 9}}
		]
	},
	{
		title : true,
		languages : true,
		genres : true,
		released : true,
		"imdb.votes" : true
	}).sort({released : -1}, {"imdb.votes" : -1})

/*
ejercicio 6
Listar el id del teatro (theaterId), estado (“location.address.state”), 
ciudad (“location.address.city”), y coordenadas (“location.geo.coordinates”) de los teatros 
que se encuentran en algunos de los estados "CA", "NY", "TX" y el nombre de la ciudades comienza 
con una ‘F’. Listar ordenados por estado y ciudad.
*/
//  /^F/i es la expresión regular que busca nombres de países que comienzan con la letra "F". 
//El ^ indica el comienzo de la cadena y la i al final indica que la búsqueda debe ser insensible a mayúsculas y minúsculas

use("mflix")
db.theaters
	.find(
	{
		"location.address.state" : {$in : ["CA","NY","TX"]},
		"location.address.city" : {$regex : /^F/i}
	},
	{
		theaterId : true,
		"location.address.state" : true,
		"location.address.city" : true,
		"location.geo.coordinates" : true
	}
	).sort({"location.address.state" : -1}, {"location.address.city" : -1})

/*
ejercicio 7
Actualizar los valores de los campos texto (text) y fecha (date) del comentario cuyo id es 
ObjectId("5b72236520a3277c015b3b73") a "mi mejor comentario" y fecha actual respectivamente.
*/
use("mflix")
db.comments
	.updateOne(
	{
		_id : {$eq : ObjectId("5b72236520a3277c015b3b73")}
	},
	{
		$set : {text : "mi mejor comentario", date : new Date()}
	}
	)

use("mflix")
db.comments
.find(
{
	_id : ObjectId("5b72236520a3277c015b3b73")
})
	
/*
ejercicio 8
Actualizar el valor de la contraseña del usuario cuyo email es joel.macdonel@fakegmail.com 
a "some password". La misma consulta debe poder insertar un nuevo usuario en caso que el 
usuario no exista. Ejecute la consulta dos veces. ¿Qué operación se realiza en cada caso?  
(Hint: usar upserts). 
*/

use("mflix")
db.users.find({email : "joel.macdonel@fakegmail.com"})

use("mflix")
db.users
	.updateOne(
	{
		email :  "joel.macdonel@fakegmail.com"
	},
	{
		$set : {password : "some password"}
	},
	{
		upsert : true
	}
	)
/*
ejercicio 9 
Remover todos los comentarios realizados por el usuario cuyo 
email es victor_patel@fakegmail.com durante el año 1980.
*/

use("mflix")
db.comments.aggregation(	{
	email : "victor_patel@fakegmail.com",
	date: { $gte: ISODate("1980-01-01T00:00:00.000Z"), $lt: ISODate("1981-01-01T00:00:00.000Z") }
})

use("mflix")
db.comments
	.deleteMany(
	{
		email : "victor_patel@fakegmail.com",
		date: { $gte: ISODate("1980-01-01T00:00:00.000Z"), $lt: ISODate("1981-01-01T00:00:00.000Z") }
	}
	)	

// PARTE 2

/* 
ejercicio 10
Listar el id del restaurante (restaurant_id) y las calificaciones de los restaurantes 
donde al menos una de sus calificaciones haya sido realizada entre 2014 y 2015 inclusive, 
y que tenga una puntuación (score) mayor a 70 y menor o igual a 90.
*/
use("restaurantdb")
db.restaurants.aggregate([
	{
	  $match: {
		"grades": {
		  $elemMatch: {
			"date": {
			  $gte: ISODate("2014-01-01T00:00:00.000Z"),
			  $lt: ISODate("2016-01-01T00:00:00.000Z")
			},
			"score": {
			  $gt: 70,
			  $lte: 90
			}
		  }
		}
	  }
	}
  ])
  
/* 
ejercicio11
Agregar dos nuevas calificaciones al restaurante cuyo id es "50018608".
A continuación se especifican las calificaciones a agregar en una sola consulta.  
*/
use("restaurantdb")
db.restaurants.find({restaurant_id : "50018608"})

use("restaurantdb")
db.restaurants.updateOne(
	{ restaurant_id: "50018608" },
	{
	  $push: {
		grades: {
		  $each: [
			{
				"date" : ISODate("2019-10-10T00:00:00Z"),
				"grade" : "A",
				"score" : 18
			},
			{
				"date" : ISODate("2020-02-25T00:00:00Z"),
				"grade" : "A",
				"score" : 21
			}
		  ]
		}
	  }
	}
  )
  