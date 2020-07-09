import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:my_app/SearchResults.dart';
import 'package:my_app/screens/newproductscreen/NewProductImageApi.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:toast/toast.dart';
import 'package:my_app/screens/newproductscreen/NewProductScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class getImage extends StatefulWidget {
  @override
  _getImageState createState() => _getImageState();
}

class _getImageState extends State<getImage> {
  TextEditingController _searchController = new TextEditingController();
  var imageUrl;
  File cameraImage;
  String img64;

  Future<void> takePicture() async{
    final picker=ImagePicker();
  final imageFile=await picker.getImage(source: ImageSource.camera,maxWidth: 600);
  setState(() {
    cameraImage=File(imageFile.path);
    final bytes = cameraImage.readAsBytesSync();
    img64 = base64Encode(bytes);
   // print(img64);
  });
  }

  Future<void> getGalleryPicture() async{
    final picker=ImagePicker();
    final imageFile=await picker.getImage(source: ImageSource.gallery,maxWidth: 600);
    setState(() {
      cameraImage=File(imageFile.path);
      final bytes = cameraImage.readAsBytesSync();
      img64 = base64Encode(bytes);
      // print(img64);
    });
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
        create: (_) => Data(),
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
                body: Center(
                  child: Container(
                   height: MediaQuery.of(context).size.height * 0.65,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[
                              NewProductReusableTextField(
                                  _searchController, '', 'Search Image on Google'),
                              IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Provider.of<Data>(context, listen: false)
                                      .changedString(_searchController.text);
                                  // do something
                                },
                              ),
                            ],
                          ),
                        ),
                        SearchResults((Url) {
                          imageUrl=Url;
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlatButton(
                                child: Text(
                                  "Camera",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.redAccent,
                                onPressed: takePicture,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlatButton(
                                child: Text(
                                  "Gallery",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.redAccent,
                                onPressed:getGalleryPicture,
                              ),
                            ),
                          ],
                        ),
                        Container(

                          child: cameraImage!=null?Container(
                            height: 150,
                              width: 150,
                              child:Stack(
                                children: [
                                  Center(child: CircularProgressIndicator()),
                                  Center(
                                    child: Image.file(
                                      cameraImage,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ],
                              )
                          ):null,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            child: Text(
                              "Continue",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.redAccent,
                            onPressed: () async{
                              Toast.show("Please wait...", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                              if(cameraImage!=null)
                                {
                                  String url=await saveImage(img64);
                                  if(url!=null)
                                  setState(() {
                                    imageUrl=url;
                                  });
                                  Toast.show("Success", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              Navigator.pop(context,imageUrl);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}