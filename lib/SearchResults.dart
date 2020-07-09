import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:my_app/DataHelper.dart';
import 'screens/newproductscreen/NewProductScreen.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchResults extends StatefulWidget {
  final Function getUrl;
  SearchResults(this.getUrl);


  @override
  _SearchResultsState createState()=> _SearchResultsState();
}




class _SearchResultsState extends State<SearchResults> {

//  String searchQuery;
//  _SearchResultsState(this.searchQuery);
  Future<List<String>> links;
  String selectedImage;
  bool isLoading;

  Widget build(BuildContext context) {
    print(Provider.of<Data>(context).data);
    if(Provider.of<Data>(context).data!='loading')
    links = Datahelper.loadImagesFromGoogleTask( Provider.of<Data>(context).data);
    //print(links);
    return Container(
     // color: Colors.black12,
        child:FutureBuilder<List<String>>(
          future: links,
          builder: (context, snapshot) {

            //print(snapshot);
            if (snapshot.hasData) {
              return Expanded(child: _creategrid(context, snapshot.data));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Container();
            // By default, show a loading spinner.
            //return CircularProgressIndicator();
          },
        )
      );
  }

  Widget _creategrid(BuildContext context, List<String> links) {

    return links.length > 0
        ? GridView.builder(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(2.0),

            itemCount: links.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                    onTap: (){
                        widget.getUrl(links[index]);
                        setState(() {  Provider.of<Data>(context,listen: false).value = index; });
                    },
                      child:Container(
                          decoration: BoxDecoration(border:  Provider.of<Data>(context).value == index ? Border.all(color: Colors.red, width: 3.0) : Border.all(color: Colors.transparent,),),
                      child:Stack(
                        children: [
                          Center(child: CircularProgressIndicator()),
                          Center(
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:links[index],
                            ),
                          ),
                        ],
                      )
                      )
                  );

            },

            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 1.0,
            ),
          )
        : Center(
            child: Text("No Available Images"),
          );

  }

}


