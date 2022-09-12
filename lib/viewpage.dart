import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginpega/net.dart';
import 'package:loginpega/update.dart';
import 'bye.dart';
import 'main.dart';

class view extends StatefulWidget {
  const view({Key? key}) : super(key: key);

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  String name = "", img = "", email = "", text = "all view page";
  List<Widget> list = [viewpage(), add(), allview()];
  int cnt = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    demo1();
  }

  void demo1() {
    name = hiii.prefs!.getString("name") ?? "";
    img = hiii.prefs!.getString("image") ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserAccountsDrawerHeader(
                accountName: Text("$name"),
                accountEmail: Text("$email"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://poorest-debit.000webhostapp.com/apicalling/$img"),
                )),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        cnt = 0;
                        text = "view page";
                        Navigator.pop(context);
                      });
                    },
                    title: Text("view page"),
                    trailing: Icon(Icons.shopping_cart),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        cnt = 1;
                        text = "add page";
                        Navigator.pop(context);
                      });
                    },
                    title: Text("Add page"),
                    trailing: Icon(Icons.add_shopping_cart),
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        cnt = 2;
                        text = "all view page";
                        Navigator.pop(context);
                      });
                    },
                    title: Text("all view page"),
                    trailing: Icon(Icons.add_shopping_cart),
                  )
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  showDialog(
                    builder: (context) {
                      return AlertDialog(
                        title: Text("You logoud"),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                hiii.prefs!.setBool("view", false);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return lottielohin();
                                  },
                                ));
                              },
                              child: Text("Ok"))
                        ],
                      );
                    },
                    context: context,
                  );
                });
              },
              title: Text("Logoud"),
              leading: Icon(Icons.logout),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(text),
      ),
      body: list[cnt],
    );
  }
}

class viewpage extends StatefulWidget {
  const viewpage({Key? key}) : super(key: key);

  @override
  State<viewpage> createState() => _viewpageState();
}

class _viewpageState extends State<viewpage> {
  String id = "";
  bool st = false;
  List<Productdatum> productdata = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    call();
  }

  @override
  Widget build(BuildContext context) {
    double hh = MediaQuery.of(context).size.height;
    double ww = MediaQuery.of(context).size.width;
    return st
        ? Scaffold(
            body: Container(
                width: ww,
                height: hh,
                color: Colors.black45,
                child: ListView.builder(
                  itemCount: productdata.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 1,
                            onPressed: (context) {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return update(productdata[index]);
                                },
                              ));
                            },
                            backgroundColor: Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.update,
                            label: 'update',
                          ),
                          SlidableAction(
                            flex: 1,
                            onPressed: (context) {
                              showDialog(
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("detele Productname"),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            setState(() async {
                                              String aa = productdata[index].id;
                                              Map map = {'id': aa};
                                              print(aa);
                                              var url = Uri.parse(
                                                  'https://poorest-debit.000webhostapp.com/apicalling/delete.php');
                                              var response = await http
                                                  .post(url, body: map);
                                              print(
                                                  'Response status: ${response.statusCode}');
                                              print(
                                                  'Response body: ${response.body}');
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                  return view();
                                                },
                                              ));
                                            });
                                          },
                                          child: Text("Ok"))
                                    ],
                                  );
                                },
                                context: context,
                              );
                            },
                            backgroundColor: Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'delete',
                          ),
                        ],
                      ),
                      child: Card(
                          elevation: 1,
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            title: Text(productdata[index].productname),
                            leading: Image.network(
                              "https://poorest-debit.000webhostapp.com/apicalling/${productdata[index].addimg.split(",")[0]}",
                              width: 50,
                              height: 50,
                            ),
                            trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.chevron_left)),
                          )),
                    );
                  },
                )),
          )
        : Center(child: CircularProgressIndicator());
  }

  Future<void> call() async {
    id = hiii.prefs!.getString("idd") ?? "";
    Map map = {"loginid": id};
    var url = Uri.parse(
        'https://poorest-debit.000webhostapp.com/apicalling/view.php');
    var response = await http.post(url, body: map);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var apiview = jsonDecode(response.body);

    Welcome mm = Welcome.fromJson(apiview);

    setState(() {
      productdata = mm.productdata;
    });
    if (mm.hello == 1) {
      if (mm.result == 1) {
        if (mm.productdata != null) {
          setState(() {
            st = true;
          });
        }
      }
    }
  }
}

class Welcome {
  Welcome(
    this.hello,
    this.result,
    this.productdata,
  );

  int hello;
  int result;
  List<Productdatum> productdata;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        json["hello"],
        json["result"],
        List<Productdatum>.from(
            json["productdata"].map((x) => Productdatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hello": hello,
        "result": result,
        "productdata": List<dynamic>.from(productdata.map((x) => x.toJson())),
      };
}

class Productdatum {
  Productdatum(
    this.id,
    this.loginid,
    this.productname,
    this.liveparice,
    this.shopprice,
    this.msg,
    this.addimg,
  );

  String id;
  String loginid;
  String productname;
  String liveparice;
  String shopprice;
  String msg;
  String addimg;

  factory Productdatum.fromJson(Map<String, dynamic> json) => Productdatum(
        json["Id"],
        json["Loginid"],
        json["Productname"],
        json["Liveparice"],
        json["Shopprice"],
        json["Msg"],
        json["Addimg"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Loginid": loginid,
        "Productname": productname,
        "Liveparice": liveparice,
        "Shopprice": shopprice,
        "Msg": msg,
        "Addimg": addimg,
      };
}

class add extends StatefulWidget {
  const add({Key? key}) : super(key: key);

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  final ImagePicker _picker = ImagePicker();
  String imagepath = "",mmm="", id = "";
  TextEditingController liveprice = TextEditingController();
  TextEditingController shopprice = TextEditingController();
  TextEditingController msg = TextEditingController();
  TextEditingController namep = TextEditingController();
  static List addphoto = [];
  bool liveprice1 = false, shopprice1 = false, msg1 = false, namep1 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagepath = "";
    addphoto = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                          controller: liveprice,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              hintText: "liveprice",
                              errorText: liveprice1 ? "add price" : null,
                              prefixIcon: Icon(Icons.currency_rupee_outlined),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 50)))),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: shopprice,
                          decoration: InputDecoration(
                              errorText: shopprice1 ? "add price" : null,
                              hintText: "shopprice",
                              prefixIcon: Icon(Icons.currency_rupee_outlined),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 50)))),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                          controller: namep,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              errorText: namep1 ? "Productname" : null,
                              hintText: "Productname",
                              prefixIcon: Icon(Icons.keyboard_alt_outlined),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 50)))),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                          controller: msg,
                          maxLines: 5,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              errorText: msg1 ? mmm : null,
                              hintText: "details",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 50)))),
                    ),
                  ),
                ],
              ),
              Container(
                height: 320,
                color: Colors.cyan,
                margin: EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: addphoto.length + 1,
                  itemBuilder: (context, index) {
                    return index == addphoto.length
                        ? InkWell(
                            onTap: () async {
                              final XFile? image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                imagepath = image!.path;
                                addphoto.add(imagepath);
                              });
                            },
                            child: Container(
                              height: 100,
                              margin: EdgeInsets.all(10),
                              child: Icon(Icons.add),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                            ))
                        : Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                  height: 100,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                      image: DecorationImage(
                                          image: FileImage(
                                              File(addphoto[index]))))),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    addphoto.removeAt(index);
                                  });
                                },
                                child: Container(
                                  height: 25,
                                  margin: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)),
                                ),
                              )
                            ],
                          );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                ),
              ),
              Container(
                child: ElevatedButton(
                    onPressed: () async {
                      liveprice1 = false;
                      shopprice1 = false;
                      msg1 = false;
                      namep1 = false;
                      String liveprice2 = liveprice.text;
                      String shopprice2 = shopprice.text;
                      String msg2 = msg.text;
                      String namep2 = namep.text;
                      if (liveprice2.isEmpty) {
                        setState(() {
                          liveprice1 = true;
                        });
                      } else if (shopprice2.isEmpty) {
                        setState(() {
                          shopprice1 = true;
                        });
                      } else if (namep2.isEmpty) {
                        setState(() {
                          namep1 = true;
                        });
                      } else if (msg2.isEmpty) {
                        setState(() {
                          msg1 = true;
                          mmm="add to details";
                        });
                      } else if (msg2.length < 150) {
                        setState(() {
                          msg1 = true;
                          mmm="add to log details";
                        });
                      } else if (imagepath.isEmpty) {
                        Flushbar(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          message: "add to photo",
                          duration: Duration(seconds: 3),
                        )..show(context);
                      } else {
                        EasyLoading.show(
                          status: 'loading...',
                          maskType: EasyLoadingMaskType.clear,
                        );
                        setState(() {
                          liveprice1 = false;
                          shopprice1 = false;
                          msg1 = false;
                          namep1 = false;
                        });
                        var addtoimg = [];
                        for (int i = 0; i < addphoto.length; i++) {
                          {
                            List<int> ii = File(addphoto[i]).readAsBytesSync();
                            addtoimg.add(base64Encode(ii));
                          }
                        }
                        id = hiii.prefs!.getString("idd") ?? "";
                        Map map = {
                          'loginid': id,
                          'Productname': namep2,
                          'liveparice': liveprice2,
                          'shopprice': shopprice2,
                          'msg': msg2,
                          'addimg': addtoimg.toString(),
                          'length': addphoto.length.toString()
                        };
                        var url = Uri.parse(
                            'https://poorest-debit.000webhostapp.com/apicalling/add.php');
                        var response = await http.post(url, body: map);
                        print('Response status: ${response.statusCode}');
                        print('Response body: ${response.body}');

                        var api = jsonDecode(response.body);
                        myapicall mm = myapicall.fromJson(api);
                        if (mm.hello == 1) {
                          if (mm.result == 1) {
                            EasyLoading.dismiss();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return view();
                              },
                            ));
                          }
                        }
                      }
                    },
                    child: Text("add item")),
              )
            ],
          ),
        ],
      )),
    );
  }
}

class myapicall {
  int? hello;
  int? result;

  myapicall({this.hello, this.result});

  myapicall.fromJson(Map<String, dynamic> json) {
    hello = json['hello'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hello'] = this.hello;
    data['result'] = this.result;
    return data;
  }
}

class allview extends StatefulWidget {
  const allview({Key? key}) : super(key: key);

  @override
  State<allview> createState() => _allviewState();
}

class _allviewState extends State<allview> {
  bool st = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    call();
  }

  List idd = [], price = [], name = [], pic = [], msg = [], shop = [];
  @override
  Widget build(BuildContext context) {
    // double hh = MediaQuery.of(context).size.height;
    // double ww = MediaQuery.of(context).size.width;
    if (st) {
      return Scaffold(
            body: ListView.builder(
              itemCount: idd.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return bey(idd[index], price[index], name[index],
                            pic[index], msg[index], shop[index], index);
                      },
                    ));
                  },
                  child: Card(
                      elevation: 1,
                      margin: EdgeInsets.all(5),
                      child: ListTile(
                        title: Text(name[index]),
                        leading: Image.network(
                          "https://poorest-debit.000webhostapp.com/apicalling/${pic[index][0]}",
                          width: 50,
                          height: 50,
                        ),
                        subtitle: Row(
                          children: [
                            Text("₹${price[index]}"),
                            Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text("₹${shop[index]}",
                                    style: TextStyle(
                                        decoration:
                                            TextDecoration.lineThrough))),
                            Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  "(${persontage(index)} % off)",
                                  style: TextStyle(color: Colors.green),
                                )),
                          ],
                        ),
                      )),
                );
              },
            ),
          );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Future<void> call() async {
    var url = Uri.parse(
        'https://poorest-debit.000webhostapp.com/apicalling/allview.php');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var apiview = jsonDecode(response.body);
    allviewapi mm = allviewapi.fromJson(apiview);
    for (int i = 0; i < mm.details!.length; i++) {
      setState(() {
        idd.add(mm.details![i].id);
        price.add(mm.details![i].liveparice);
        name.add(mm.details![i].productname);
        msg.add(mm.details![i].msg);
        shop.add(mm.details![i].shopprice);
        pic.add(mm.details![i].addimg!.split(","));
      });
    }
    if (mm.result == 1) {
      if (mm.result == 1) {
        if (mm.details != null) {
          setState(() {
            st = true;
          });
        }
      }
    }
  }

  String persontage(int index) {
    double pr =
        100 - (double.parse(price[index])) * 100 / double.parse(shop[index]);
    return pr.toStringAsFixed(2);
  }
}

class allviewapi {
  int? hello;
  int? result;
  List<Details>? details;

  allviewapi({this.hello, this.result, this.details});

  allviewapi.fromJson(Map<String, dynamic> json) {
    hello = json['hello'];
    result = json['result'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hello'] = this.hello;
    data['result'] = this.result;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? id;
  String? loginid;
  String? productname;
  String? liveparice;
  String? shopprice;
  String? msg;
  String? addimg;

  Details(
      {this.id,
      this.loginid,
      this.productname,
      this.liveparice,
      this.shopprice,
      this.msg,
      this.addimg});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    loginid = json['Loginid'];
    productname = json['Productname'];
    liveparice = json['Liveparice'];
    shopprice = json['Shopprice'];
    msg = json['Msg'];
    addimg = json['Addimg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Loginid'] = this.loginid;
    data['Productname'] = this.productname;
    data['Liveparice'] = this.liveparice;
    data['Shopprice'] = this.shopprice;
    data['Msg'] = this.msg;
    data['Addimg'] = this.addimg;
    return data;
  }
}
