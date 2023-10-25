import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/models/sellers.dart';
import 'package:users_app/models/items.dart';
import 'package:users_app/sellersScreen/sellers_ui_design_widget.dart';
import 'package:users_app/itemsScreens/items_ui_design_widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String searchText;
  List<Sellers> sellersList = [];
  List<Items> productsList = [];

  @override
  void initState() {
    super.initState();
    searchText = "";
  }

  void searchSellersAndProducts(String textEnteredByUser) async {
    final sellersSnapshot = await FirebaseFirestore.instance
        .collection("sellers")
        .where("name", isEqualTo: textEnteredByUser)
        .get();

    setState(() {
      sellersList = sellersSnapshot.docs
          .map((doc) => Sellers.fromJson(doc.data()))
          .toList();
    });

    final productsSnapshot = await FirebaseFirestore.instance
        .collection("items")
        .where("itemTitle", isEqualTo: textEnteredByUser)
        .get();

    setState(() {
      productsList = productsSnapshot.docs
          .map((doc) => Items.fromJson(doc.data()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black45,
                Colors.indigoAccent,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        automaticallyImplyLeading: true,
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              searchText = textEntered;
            });

            searchSellersAndProducts(searchText);
          },
          decoration: InputDecoration(
            hintText: "Search here...",
            hintStyle: const TextStyle(color: Colors.white54),
            suffixIcon: IconButton(
              onPressed: () {
                searchSellersAndProducts(searchText);
              },
              icon: const Icon(Icons.search),
              color: Colors.white,
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sellersList.length + productsList.length,
              itemBuilder: (context, index) {
                if (index < sellersList.length) {
                  final sellers = sellersList[index];
                  return SellersUIDesignWidget(
                    model: sellers,
                  );
                } else {
                  final productsIndex = index - sellersList.length;
                  final items = productsList[productsIndex];
                  return ItemsUiDesignWidget(
                    model: items,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}