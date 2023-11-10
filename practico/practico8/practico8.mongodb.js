/*
ejercicio1
Cantidad de cines (theaters) por estado.
*/

use("mflix");
db.theaters.aggregate([
    { 
        $group : {
        _id : "$location.address.state",
        cantidad : { $count : {}}
        }
    }
])

/* 
ejercicio2
Cantidad de estados con al menos dos cines (theaters) registrados.
*/
use("mflix");
db.theaters.aggregate([
    { 
        $group : {
        _id : "$location.address.state",
        cantidad : { $count : {}}
        }
    },
    {
        $match : {
            cantidad : {$gt : 2}
        }
    }
])

/*
ejercicio3 
Cantidad de películas dirigidas por "Louis Lumière". 
Se puede responder sin pipeline de agregación, realizar ambas queries.
*/
use("mflix");
db.movies.find(
    { directors : 
        {$elemMatch : 
            {$eq : "Louis Lumière"}} 
    }).count()

use("mflix");
db.movies.aggregate([
    {$match : {directors : "Louis Lumière"}},
    {$count : "Cantidad de películas dirigidas por Louis Lumière"}
])

/*
ejercicio4
Cantidad de películas estrenadas en los años 50 (desde 1950 hasta 1959). 
Se puede responder sin pipeline de agregación, realizar ambas queries.
*/
use("mflix");
db.movies.find({})

use("mflix");
db.movies.aggregate([
    {$match : {
        year : {$gte : 1950, $lte : 1959}
    }
    }
])

use("mflix");
db.movies.find({
    year : {$gte : 1950, $lte : 1959}
})

/* 
ejercicio5
Listar los 10 géneros con mayor cantidad de películas (tener en cuenta 
que las películas pueden tener más de un género). Devolver el género y
la cantidad de películas. Hint: unwind puede ser de utilidad
*/

use("mflix");
db.movies.aggregate([
    { $unwind : {path : "$genres"}},
    { $group : {_id : "$genres", cantidad : {$count : {}}}},
    { $sort : {cantidad : -1}},
    { $limit : 10}
])

/* 
ejercicio 6
Top 10 de usuarios con mayor cantidad de comentarios, mostrando Nombre,
Email y Cantidad de Comentarios.
*/
use("mflix");
db.comments.aggregate([
    { $group : { _id : "$email", name : {$first : "$name"}, email : {$first : "$email"},  cantidad : {$count : {}}}},
    { $sort : {cantidad : -1}},
    { $limit : 10} 
])

/* 
ejercicio 7
Ratings de IMDB promedio, mínimo y máximo por año de las películas 
estrenadas en los años 80 (desde 1980 hasta 1989), ordenados de mayor 
a menor por promedio del año.
*/
use("mflix");
db.movies.aggregate([
    { $match : { year : {$gte : 1980, $lte : 1989}}},
    { $match : { "imdb.rating" : {$ne : ""}}},
    { $group : { _id : "$year", "IMDB promedio" : {$avg :"$imdb.rating"}, 
                "IMDB max" : {$max : "$imdb.rating"},"IMDB min" : {$min : "$imdb.rating"}}},
    { $sort : {"IMDB promedio" : -1}}
])

/*
ejercicio 8
Título, año y cantidad de comentarios de las 10 películas con más comentarios.
*/
use("mflix");
db.comments.find({})
use("mflix");
db.comments.aggregate([
  {
    $lookup: {
      from: "movies",
      localField: "movie_id",
      foreignField: "_id",
      as: "movie_details",
    },
  },
  { $group : {_id : "$movie_id", 
            titulo : {$first :"$movie_details.title"}, 
            año : {$first :"$movie_details.year"}, 
            cantidad : {$count : {}}}},
  { $sort : {cantidad : -1}},
    { $limit : 10}
])

/* 
ejercicio 9
Crear una vista con los 5 géneros con mayor cantidad de comentarios,
junto con la cantidad de comentarios.
*/
db.createView(
    "Generos con mas comentarios",
    "comments",
    [ { $group: { year: 1 } } ]
)

use("mflix");
db.movies.find({})

use("mflix");
db.movies.aggregate([
    {
    $lookup: {
        from: "comments",
        localField: "_id",
        foreignField: "movie_id",
        as: "movie_details"
        }
    },
    { $unwind : "$genres"},
    { $group : {_id : "$genres",
              cantidad : {$count : {}}}},
    { $sort : {cantidad : -1}},
    { $limit : 5}
  ])