import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/ratingScreen/rate_seller_screen.dart';

import '../splashScreen/my_splash_screen.dart';


class AddressDesign extends StatelessWidget
{
  Address? model;
  String? orderStatus;
  String? orderId;
  String? sellerId ;
  String? orderByUser;

  AddressDesign({

    required this.model,
    required this.orderStatus,
    required this.orderId,
    required this.sellerId,
    required this.orderByUser,
  });

  @override
  Widget build(BuildContext context)
  {
    return Column(
      children: [

        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Shipping Details:',
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold
            ),
          ),
        ),

        const SizedBox(
          height: 6.0,
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [

              //name
              TableRow(
                children:
                [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    model!.name.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const TableRow(
                children:
                [
                   SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),

              //phone
              TableRow(
                children:
                [
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    model!.phoneNumber.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.completeAddress.toString(),
            textAlign: TextAlign.justify,
            style: const TextStyle(
                color: Colors.grey,
            ),
          ),
        ),

        GestureDetector(
          onTap: ()
          async {

            if(orderStatus == "normal")
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MySplashScreen()));
            }
            else if(orderStatus == "shifted")
            {
              //implement Parcel Received feature
              FirebaseFirestore.instance
                  .collection("orders")
                  .doc(orderId)
                  .update({
                "status": "ended",

              }).whenComplete((){
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(orderByUser)
                    .collection("orders")
                    .doc(orderId)
                    .update({
                  "status": "ended",
                });
                
                //send notification to seller
                
                Fluttertoast.showToast(msg: "Confirmed Successfully.");
                Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
                
              });
            }
            else if(orderStatus == "ended")
            {

              final data =  await FirebaseFirestore.instance.collection("orders").doc(orderId).get().then((value) =>
              {
                sellerId = value.get("sellerUID")

                // for( var i in value.get(""))
              }); //get the data
              // FirebaseFirestore.instance.collection("orders").where("orderId", isEqualTo: orderId).get().then(
              //       (querySnapshot) {
              //     print("Successfully completed");
              //     for (var docSnapshot in querySnapshot.docs) {
              //       print('${docSnapshot.id} => ${docSnapshot.data()}');
              //     }
              //   },
              //   onError: (e) => print("Error completing: $e"),
              // );
              //implement Rate this Seller feature
              Navigator.push(context, MaterialPageRoute(builder: (c)=>RateSellerScreen(
                sellerId: sellerId,
              )));
            }
            else
            {
              Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black45,
                      Colors.indigoAccent,
                    ],
                    begin:  FractionalOffset(0.0, 0.0),
                    end:  FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  )
              ),
              width: MediaQuery.of(context).size.width - 40,
              height: orderStatus == "ended" ? 60 : MediaQuery.of(context).size.height * .10,
              child: Center(
                child: Text(
                  orderStatus == "ended"
                      ? "Do you want to Rate this Seller?"
                      : orderStatus == "shifted"
                      ? "Parcel Received, \nClick to Confirm"
                      : orderStatus == "normal"
                      ? "Go Back"
                      : "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
