import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/utils/SharedPrefences.dart';
import 'package:my_app/auth/login/widget/LoginActivity.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:my_app/screens/newproductscreen/NewProductScreen.dart';
import 'package:toast/toast.dart';
import 'package:my_app/screens/homescreen/ProductsApi.dart';
import 'package:photo_view/photo_view.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoading=true;
  Future<List<Object>> allProducts;
  Products products=new Products();

  @override
  void initState () {
    super.initState();


  }
  @override
  Widget build(BuildContext context){

    allProducts = products.getAllProducts(context);
print('hey...');
    return  Scaffold(
      appBar: AppBar(
        title: Text("Main Page", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              await SharedPreferencesManager.clear;
//              pushNewScreen(
//                context,
//                screen:LoginActivity(),
//                platformSpecific: false, // OPTIONAL VALUE. False by default, which means the bottom nav bar will persist
//                withNavBar: false, // OPTIONAL VALUE. True by default.
//              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => LoginActivity()),
                    (Route<dynamic> route) => false,
              );
              },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Container(
        child:FutureBuilder<List<Object>>(
          future: allProducts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return  _createList(context, snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),

      drawer: Drawer(),
    );


  }

  Widget _createList(BuildContext context, List<Object> myProducts) {
    return myProducts.length > 0
        ? ListView.builder(
      itemCount: myProducts.length,
      itemBuilder: (BuildContext context, int index) {
        return buildCard(myProducts[index],myProducts,index);
      },

    ): Center(
      child: Text("No Products Available"),
    );
  }

  Card buildCard(var product,List<Object> myProducts,int index) {
    return Card(
      child: ListTile(
        leading:Container(
          height: 100,
          width: 60,

          child: GestureDetector(

              child: Image.network(
                product['img'],
              ),
            onTap: () {
              pushNewScreen(
                context,
                screen: DetailScreen(product['img']),
                platformSpecific: false, // OPTIONAL VALUE. False by default, which means the bottom nav bar will persist
                withNavBar: false, // OPTIONAL VALUE. True by default.
              );

            },
          )
        )  //, fit: BoxFit.cover,height: 100//        width: 60,
          ,
        title: Text(product['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                product['category']
            ),
            Text(
              '₹${product['price'].toString()}',style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (var choice) {
            selectDropdown(choice,product);
          },
          itemBuilder: (BuildContext context){
            return <String>['Edit','Delete'].map((String choice){
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
        isThreeLine: true,
      ),
    );

  }

  void selectDropdown(String choice,var product){

    if(choice == 'Edit'){
      pushNewScreen(
        context,
        screen: NewProduct(product['_id'],product['category'],product['name'],product['price'].toString(),product['img']),
        platformSpecific: false, // OPTIONAL VALUE. False by default, which means the bottom nav bar will persist
        withNavBar: false, // OPTIONAL VALUE. True by default.
      );
      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NewProduct(product['_id'],product['category'],product['name'],product['price'].toString(),product['img'])));
    }else if(choice == 'Delete'){
        Toast.show("Deleting...", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

        products.deleteProduct(product['_id'],context);
        setState(() {
        });

    }
  }

}


class DetailScreen extends StatelessWidget {
  DetailScreen(this.imageUrl);
  final imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(

            child:  PhotoView(
              imageProvider: NetworkImage(imageUrl),
              initialScale: PhotoViewComputedScale.contained * 0.5,
            )

        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

