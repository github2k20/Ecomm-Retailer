import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:my_app/screens/orderstatusscreen/OrdersApi.dart';

class PendingOrders extends StatefulWidget {
  @override
  _PendingOrdersState createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {

  Orders orders=new Orders();
  var pendingOrders;
  bool completed=false;
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    pendingOrders=orders.getPendingOrders(context);
    print(pendingOrders);
    return Scaffold(
        appBar: AppBar(
          title: Text("Pending Orders", style: TextStyle(color: Colors.white)),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // height: MediaQuery.of(context).size.height - 300.0,
              child: FutureBuilder<List<Object>>(
                  future: pendingOrders,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return  _createList(context, snapshot.data);
                    } else {
                      return  Center(child: Text('Loading...'));
                    }
                  })),
        ));
  }

  Widget _createList(BuildContext context, List<Object> products) {
    return products.length > 0
        ? ListView.builder(
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        return buildCard(products[index]);
      },

    ): Center(
      child: Text("No Orders"),
    );
  }
  //---returns store card---------------------------------------------------------------------------------------------------------
  Widget buildCard(var product) {
    //print(product);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(

        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: GestureDetector(
            onTap: (){
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 8.0),
                    child:Image.network(product['product']['img'], height: 80,
                      width: 60,),
                  ),
                  Expanded(
                    child: Container(
                        child:ListTile(
                          title: Text(product['product']['name'],style: TextStyle(
                              fontFamily: 'QuickSand',
                              fontSize: 15.0,
                              color: Colors.red[400],
                              fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ReusableSubtitleText('Qty. - ${product['quantity'].toString()}  ₹${product['product']['price'].toString()}/pc',12.0,Colors.red),
                              ReusableSubtitleText('Name: ${product['customerId']['name']}',12.0,Colors.blue),
                              ReusableSubtitleText('Ph: ${product['customerId']['phone']}',12.0,Colors.purple),
                              ReusableSubtitleText('Location: ${product['customerId']['location']}',12.0,Colors.brown),
                            ],
                          ),)
//
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: IconButton(icon: Icon(Icons.check_circle,color: Colors.orange,size: 40,),
                      onPressed: () {
                        print(product['product']['_id']);
                        orders.UpdateStatus(context,product['product']['_id']);
                        setState(() {

                        });
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );

  }
}

class ReusableSubtitleText extends StatelessWidget {
  ReusableSubtitleText(this.displayText,this.fontSize,this.color);
  final String displayText;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(displayText,style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: fontSize,
        color: color)
    );
  }
}


