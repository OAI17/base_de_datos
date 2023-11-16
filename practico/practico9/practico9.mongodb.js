// runCommand funciona para esquemas que ya estan en la base de datos
// createCollection para hacer validaciones al crear un nuevo esquema
use("mflix");
db.users.find({})

use("shop");
db.orders.drop()

/* ejercicio 1
Especificar en la colección users las siguientes reglas de validación:
El campo name (requerido) debe ser un string con un máximo de 30 caracteres, 
email (requerido) debe ser un string que matchee con la expresión regular: 
"^(.*)@(.*)\\.(.{2,4})$" , password (requerido) debe ser un string con al menos 50 caracteres.
*/
use("mflix");
db.runCommand({
    collMod : "users",
    validator : {$jsonSchema : {
        bsonType : "object",
        required : ["name","email", "password"],
        properties : {
            name : {
                bsonType : "string",
                description : "debe ser un string",
                maxLength : 30
            },
            email : {
                bsonType : "string",
                description : "debe matchear con la exprecion regular",
                pattern : "^(.*)@(.*)\\.(.{2,4})$"
            }, 
            password : {
                bsonType : "string",
                description : "debe contener al menos 50 caracteres",
                minLength : 50
            }
        }
    }},
    validationLevel : "moderate"
})

/* ejercicio 2
Obtener metadata de la colección users que garantice que las reglas de 
validación fueron correctamente aplicadas.
*/
use("mflix");
db.getCollectionInfos({"name" : "users"})

/* ejercicio 3 
Especificar en la colección theaters las siguientes reglas de validación: El campo theaterId (requerido) debe ser un int y location (requerido) debe ser un object con:
un campo address (requerido) que sea un object con campos street1, city, state y zipcode todos de tipo string y requeridos
un campo geo (no requerido) que sea un object con un campo type, con valores posibles “Point” o null y coordinates que debe ser una lista de 2 doubles
Por último, estas reglas de validación no deben prohibir la inserción o actualización de documentos que no las cumplan sino que solamente deben advertir.
*/
use("mflix");
db.theaters.find({})

use("mflix");
db.runCommand({
    collMod : "theaters",
    validator : {$jsonSchema : {
        bsonType : "object",
        required : ["theaterld","location"],
        properties : {
            theaterld : {
                bsonType : "int"
            },
            location : {
                bsonType : "object",
                required : ["address"],
                properties : {
                    address : {
                        bsonType : "object",
                        required : ["street1","city","state","zipcode"],
                        properties : {
                            street1 : { bsonType : "string"},
                            city : { bsonType : "string"},
                            state : { bsonType : "string"},
                            zipcode : { bsonType : "string"}
                        }
                    },
                    geo : {
                        bsonType : "object",
                        properties : {
                            type : { enum : ["Point",null]},
                            coordinates : {
                                bsonType : "array",
                                items : [ {bsonType : "double"}, {bsonType : "double"}],
                                maxItems : 2,
                                minItems : 2    
                            }
                        }
                    }
                }
            }
        }
    }},
    //Permite hacer todo, solamente advierte de la violacion
    validationLevel: "moderate",
    validationAction: "warn"
})

//verificacion
use("mflix");
db.getCollectionInfos({"name" : "theaters"})

/* ejercicio 4
Especificar en la colección movies las siguientes reglas de validación: El campo title (requerido) es de tipo string, year (requerido) int con mínimo en 1900 y máximo en 3000, y que tanto cast, directors, countries, como genres sean arrays de strings sin duplicados.
Hint: Usar el constructor NumberInt() para especificar valores enteros a la hora de insertar documentos. Recordar que mongo shell es un intérprete javascript y en javascript los literales numéricos son de tipo Number (double).
*/
use("mflix");
db.movies.find({})

use("mflix");
db.runCommand({
    collMod : "movies",
    validator : { $jsonSchema : {
        bsonType : "object",
        required : ["title","year"],
        properties : {
            title : { bsonType : "string"},
            year : {
                bsonType : "int",
                minimum : 1900,
                maximum : 3000
            },
            cast : { 
                bsonType : "array",
                uniqueItems : true
            },
            directors : { 
                bsonType : "array",
                uniqueItems : true
            },
            countries : { 
                bsonType : "array",
                uniqueItems : true
            },
            genres : { 
                bsonType : "array",
                uniqueItems : true
            }                        
        }
    }},
    //Permite hacer todo, solamente advierte de la violacion
    validationLevel: "moderate",
    validationAction: "warn"
})
//verificacion
use("mflix");
db.getCollectionInfos({"name" : "movies"})

/*ejercicio 5
Crear una colección userProfiles con las siguientes reglas de validación: Tenga un campo user_id (requerido) de tipo “objectId”, 
un campo language (requerido) con alguno de los siguientes valores [ “English”, “Spanish”, “Portuguese” ] y un campo favorite_genres 
(no requerido) que sea un array de strings sin duplicados.
*/
use("mflix");
db.createCollection("userProfiles", {
    validator : {
        $jsonSchema : {
            bsonType : "object",
            required : ["user_id","language"],
            properties : {
                user_id : { bsonType : "objectId"},
                language : { enum : ["English", "Spanish", "Portuguese"]},
                favorite_genres : {
                    bsonType : "array",
                    items : [ {bsonType : "string"}],
                    uniqueItems : true
                }
            }
        }
    }
})
//verificacion
use("mflix");
db.userProfiles.find({})

use("mflix");
db.getCollectionInfos({"name" : "userProfiles"})

/* ejercicio 6
Identificar los distintos tipos de relaciones (One-To-One, One-To-Many) en las colecciones movies y comments. 
Determinar si se usó documentos anidados o referencias en cada relación y justificar la razón.
*/
use("mflix");
db.comments.find({})
db.movies.find({})
/*
La relacion es de uno (movies) a muchos (comments)
Debido a que comments tiene el id que identifica a movie es una referencia a la relacion
(Para ser mas preciso seria la relacion one-to-squillon)
*/

/* ejercicio 7*/
use shop //crear una base de datos

use("shop");
db.categories.find({})

use("shop");
db.createCollection("orders", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["order_id", "delivery_name", "delivery_address", "cc_name","cc_number","cc_expiry"],
            properties: {
                order_id: { bsonType: "long"},
                delivery_name : {bsonType : "string", maxLength : 70},
                delivery_address : {bsonType : "string", maxLength : 70},
                cc_name : {bsonType : "string", maxLength : 70},
                cc_number : {bsonType : "string", maxLength : 32},
                cc_expiry : {bsonType : "string", maxLength : 20}
            }
        }
    }
});

use("shop");
db.createCollection("books", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["book_id", "title", "author","price","category_id"],
            properties: {
                book_id : {bsonType : "int"},
                title : {bsonType : "string", maxLength : 70},
                author : {bsonType : "string", maxLength : 70},
                price : {bsonType : "double"},
                order_id: { bsonType: "long"},
                category_id: { bsonType: "int"}
            }
        }
    }
});

use("shop");
db.createCollection("categories", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["category_id","category_name"],
            properties: {
                category_id: { bsonType: "int"},
                category_name: {bsonType : "string", maxLength : 70}
            }
        }
    }
});

use("shop");
db.categories.insert([
    {
        category_id: 1,
        category_name: 'Web Development'
    },
    {
        category_id: 2,
        category_name: 'Science Fiction'
    },
    {
        category_id: 3,
        category_name: 'Historical Mysteries'
    },
]);
  
use("shop");
db.books.insert([
    {
        book_id : 1,
        title : 'Learning mysql',
        author : 'Jesper Wisborg Krogh',
        price : 34.31,
        category_id: 1
    },
    {
        book_id : 2,
        title : 'JavaScript Next',
        author : 'Raju Gandhi',
        price : 36.70,
        category_id: 1
    },
    {
        book_id : 3,
        title : 'The Complete Robot',
        author : 'Isaac Asimov',
        price : 12.13,
        category_id: 2
    },
    {
        book_id : 4,
        title : 'Foundation and Earth',
        author : 'Isaac Asimov',
        price : 11.07,
        category_id: 2
    },
    {
        book_id : 5,
        title : 'The Da Vinci Code',
        author : 'Dan Brown',
        price : 7.99,
        category_id: 3
    },
    {
        book_id : 6,
        title : 'A Column of Fire',
        author : 'Ken Follett',
        price : 6.99,
        category_id: 3
    },
]);