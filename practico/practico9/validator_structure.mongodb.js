use("mflix");
db.runCommand({
    collMod : "theaters",
    validator : {$jsonSchema : {
        bsonType : "object",
        required : [""],
        properties : {
            theaterld : {
                bsonType : "int"
            },
            location : {
                bsonType : "object",
                required : [""],
                properties : {
                    address : {
                        bsonType : "object",
                        required : ["","","",""],
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
                            type : { enum : ["",null]},
                            coordinates : {
                                bsonType : "array",
                                items : [ {bsonType : ""}, {bsonType : ""}],
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
