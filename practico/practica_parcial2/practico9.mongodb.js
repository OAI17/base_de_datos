use("restaurant");
db.restaurants.find({})

//ejercicio 1
use("restaurant");
db.restaurants.find({
    cuisine : "Italian",
    grades : {
        $elemMatch : {
            "grade" : "A",
            "score" : { $gte : 10}
        }
    }
},
{
    name : true,
    borough : true,   
}
).sort({borough : 1, name : 1})

//ejercicio2 
use("restaurant");
db.restaurant.update(
    { $or: [{cuisine : "Bakery"},{cuisine : "Coffee"}] },  
    { $set: { "discounts": { 
        $cond: { 
            if: { $eq: ["$borough", "Manhattan"] },
            then: { "day": "Monday", "amount": "%10" }, 
            else: { "day": "Tuesday", "amount": "%5" } } } } },
    { multi: true }
  )
  
//ejercicio3
use("restaurant");
db.restaurant.updateMany(
  {
    "address.zipcode": {
      $exists: true,
      $type: "string"
    }
  },
  {
    $set: {
      "address.zipcode": {
        $convert: {
          input: "$address.zipcode",
          to: "int",
          onError: 0
        }
      }
    }
  }
);
  
use("restaurant");
db.restaurant.find({
    "address.zipcode": {
        $gte: "10000",
        $lte: "11000"
    }
}).count()

  