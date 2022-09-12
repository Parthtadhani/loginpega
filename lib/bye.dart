import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loginpega/net.dart';
import 'package:loginpega/viewpage.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class bey extends StatefulWidget {
  String idd, price, name, msg, shop;
  List<String> pic;
  int index;

  bey(this.idd, this.price, this.name, this.pic, this.msg, this.shop,
      this.index);

  @override
  State<bey> createState() => _beyState();
}

class _beyState extends State<bey> {
  List photo = [];
  String email = "", num = "";
  PageController pg = PageController();
  late Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.pic.length);
    pg = PageController(initialPage: 0);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    get();
  }

  void get() {
    email = hiii.prefs!.getString("email") ?? "";
    num = hiii.prefs!.getString("mobile") ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  int aa = 0;
  Map<String, dynamic>? _selectedPhoto;

  @override
  Widget build(BuildContext context) {
    double hh = MediaQuery.of(context).size.height;
    double ww = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("payment now"),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return sophoto(widget.pic);
                          },
                        ));
                    },
                      child: Container(
                        height: 600,
                        alignment: Alignment.center,
                        child: RotatedBox(
                          quarterTurns: -45,
                          // implement the ListWheelScrollView
                          child: ListWheelScrollView(
                            itemExtent: MediaQuery.of(context).size.width * 0.9,
                            onSelectedItemChanged: (index) {
                              setState(() {
                              aa=index;
                              });
                            },
                            // use the _photos list as children
                            children: widget.pic
                                .map((photo) => RotatedBox(
                                      quarterTurns: 85,
                                      child: Image.network(
                                        "https://poorest-debit.000webhostapp.com/apicalling/${widget.pic[aa]}",
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Card(
                elevation: 1,
                child: Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        widget.name,
                        style: TextStyle(fontSize: 50),
                      ),
                    )),
              ),
              Card(
                elevation: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          child: Text("Shop pirce",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.deepPurple))),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(":",
                            style: TextStyle(
                                fontSize: 25, color: Colors.deepPurple))),
                    Expanded(
                      child: Container(
                          child: Center(
                        child: Text(widget.shop,
                            style: TextStyle(
                              fontSize: 25,
                            )),
                      )),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          child: Text("App price",
                              style: TextStyle(
                                  fontSize: 25, color: Colors.deepPurple))),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(":",
                            style: TextStyle(
                                fontSize: 25, color: Colors.deepPurple))),
                    Expanded(
                      child: Container(
                          child: Center(
                        child: Text("${widget.price}",
                            style: TextStyle(fontSize: 25)),
                      )),
                    )
                  ],
                ),
              ),
              Card(
                elevation: 1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: Text("Details  ",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.deepPurple))),
                    ),
                    Container(
                        child: Text(":",
                            style: TextStyle(
                                fontSize: 20, color: Colors.deepPurple))),
                    Expanded(
                      child: Container(
                          child: Center(
                        child: Text("   ${widget.msg}",
                            style: TextStyle(fontSize: 20)),
                      )),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return view();
                          },
                        ));
                      },
                      child: Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child:
                                Text("cancel", style: TextStyle(fontSize: 25)),
                          )),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        openCheckout(email, num);
                      },
                      child: Container(
                          height: 50,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Center(
                              child: Text("payment now",
                                  style: TextStyle(fontSize: 25)),
                            ),
                          )),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }

  getpiv() {
    List<Widget> nn = [];
    for (int i = 0; i < widget.pic.length; i++) {
      nn.add(Expanded(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return sophoto(widget.pic);
              },
            ));
          },
          child: Container(
            child: Image.network(
                "https://poorest-debit.000webhostapp.com/apicalling/${widget.pic[i]}"),
          ),
        ),
      ));
    }
    return nn;
  }

  void openCheckout(String email, String num) async {
    var options = {
      'key': 'rzp_test_Pc13aAGRzj7nGr',
      'amount': double.parse(widget.price) * 100,
      'name': "${widget.name}",
      'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '$num', 'email': '$email'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    Fluttertoast.showToast(
        msg: "SUCCESS: " ,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    Fluttertoast.showToast(
        msg: "ERROR: " ,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }
}

class sophoto extends StatefulWidget {
  List<String> pic;

  sophoto(this.pic);

  @override
  State<sophoto> createState() => _sophotoState();
}

class _sophotoState extends State<sophoto> {
  PageController pg = PageController();
  int aa = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PinchZoom Page'),
      ),
      body: PageView.builder(
        itemCount: widget.pic.length,
        controller: pg,
        onPageChanged: (value) {
          setState(() {
            aa = value;
          });
        },
        itemBuilder: (context, index) {
          return PinchZoom(
            child: Image.network(
                'https://poorest-debit.000webhostapp.com/apicalling/${widget.pic[aa]}'),
            resetDuration: const Duration(milliseconds: 100),
            maxScale: 2.5,
            onZoomStart: () {
              print('Start zooming');
            },
            onZoomEnd: () {
              print('Stop zooming');
            },
          );
        },
      ),
    );
  }
}
