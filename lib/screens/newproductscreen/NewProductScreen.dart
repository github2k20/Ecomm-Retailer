import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:my_app/screens/newproductscreen/ProductImageScreen.dart';
import 'package:my_app/screens/newproductscreen/ProductsApi.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:my_app/utils/PopupMenuButtonData.dart';

class NewProduct extends StatefulWidget {
  NewProduct(this.productId, this.productCategory, this.productName,
      this.productPrice, this.productImage);
  final String productName;
  final String productPrice;
  final String productCategory;
  final String productId;
  final String productImage;

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
//final searchResults=new SearchResults();

  String url='https://screenshotlayer.com/images/assets/placeholder.png';
  bool cameraOrGallery = false;
  TextEditingController _productController = new TextEditingController();
  TextEditingController _productPriceController = new TextEditingController();
  String _productCategory;
  bool isLoading = false;
  Products products = new Products();


  @override
  void initState() {
    super.initState();
    _productCategory = 'Product Category';
    if (widget.productPrice != '' && widget.productPrice != '')
     {_productCategory = widget.productCategory;
    _productController.text = widget.productName;
    _productPriceController.text = widget.productPrice;
    url = widget.productImage;
  }
  }

  void choiceAction(String choice) {
    setState(() {
      _productCategory = choice;
    });
  }

  Widget getPopupMenu(var listToIterateUpon) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.red[400],
      ),
      onSelected: choiceAction,
      itemBuilder: (BuildContext context) {
        return <String>['Fruits and Vegetables', 'Personal Care', 'Electronics']
            .map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  Widget build(BuildContext context) {

    print('lalllu**********************************');

    return isLoading
        ? Container(child: Center(child: CircularProgressIndicator()))
        : ChangeNotifierProvider<Data>(
            create: (_) => Data(),
            builder: (context, child) {
              return SafeArea(
                child: Scaffold(
                  body: Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      children: <Widget>[
                        Text(
                          (widget.productPrice != '' &&
                                  widget.productPrice != '')
                              ? "Update Product"
                              : "Add Product",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(
                              color: Colors.red[400],
                              width: 2.0,
                            ),
                          ),
                          child: ListTile(
                            title: Text(_productCategory),
                            trailing:
                                getPopupMenu(Categories.productCategories),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: NewProductReusableTextField(_productController,
                              widget.productName, 'Product Name'),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: NewProductReusableTextField(
                              _productPriceController,
                              widget.productPrice,
                              'Set Price'),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            child: Text(
                              "Get Image",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.redAccent,
                            onPressed: () async{
                             final imageUrl=await pushNewScreen(
                                context,
                                screen: getImage(),
                                platformSpecific:
                                    false, // OPTIONAL VALUE. False by default, which means the bottom nav bar will persist
                                withNavBar:
                                    false, // OPTIONAL VALUE. True by default.
                              )??url;
                            setState(() {
                              url=imageUrl;
                            });
                             },

                          ),
                        ),

                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                                  url,
                                  height: 100,
                                  width: 100,
                                ) ??
                                CircularProgressIndicator(),
                          ),
                        ),

//              Text(searchQuery), ,

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            child: Text(
                              (widget.productPrice != '' &&
                                      widget.productPrice != '')
                                  ? "Update"
                                  : "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.redAccent,
                            onPressed: () async {
                              int responseCode;
                              Provider.of<Data>(context, listen: false)
                                  .changedTappedGestureDetector();
                              print(url);
                              if (widget.productPrice != '' &&
                                  widget.productPrice != '') {
                                //Update in DB
                                products.updateProduct(
                                    context,
                                    widget.productId,
                                    _productCategory,
                                    _productController.text,
                                    _productPriceController.text,
                                    url );
                                print('Updated Product');
                              } else {
                                products.addProduct(
                                    context,
                                    _productCategory,
                                    _productController.text,
                                    _productPriceController.text,
                                    url, (int responseCode) {
                                  if (responseCode == 200)
                                    Toast.show("Success!", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  else
                                    Toast.show("Failed!", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                });

                                Timer(Duration(seconds: 5), () {
                                  setState(() {
                                    isLoading = false;
                                    _productCategory = 'Product Category';
                                    _productController.text = '';
                                    _productPriceController.text = '';
                                    url='https://screenshotlayer.com/images/assets/placeholder.png';
                                  });
                                });

                                Timer(Duration(seconds: 4), () {
                                  setState(() {
                                    print('aloo');
                                    isLoading = true;
                                  });
                                });

                                print('new product created');
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}

class NewProductReusableTextField extends StatelessWidget {
  NewProductReusableTextField(this.controller, this.widgetData, this.hintText);

  final TextEditingController controller;
  final String widgetData;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller == '' ? widgetData : controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
    );
  }
}

class Data extends ChangeNotifier {
  String data = 'loading';
  bool isLoading = false;
  String Url = 'https://screenshotlayer.com/images/assets/placeholder.png';
  int value;
  void changedString(String newString) {
    data = newString;
    isLoading = true;
    notifyListeners();
  }

  void changedTappedGestureDetector() {
    value = -1;
    notifyListeners();
  }

}



