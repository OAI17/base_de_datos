//ctrl + alt + s
//ctrl + shift + i prettier
//ejercicio1
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
])

use("mflix")
db.comments.find({ "name" : "cabeza de ladrillo"})

//ejercicio2

