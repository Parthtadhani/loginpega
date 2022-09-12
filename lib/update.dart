import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginpega/viewpage.dart';

class update extends StatefulWidget {
  Productdatum productdata;

  update(this.productdata);

  @override
  State<update> createState() => _updateState();
}

class _updateState extends State<update> {
  final ImagePicker _picker = ImagePicker();
  String imagepath = "", id = "";
  TextEditingController liveprice = TextEditingController();
  TextEditingController shopprice = TextEditingController();
  TextEditingController msg = TextEditingController();
  TextEditingController namep = TextEditingController();
  List<String> prophoto = [];
  List<String> photo = [];
  List<String> addphoto = [];
  bool liveprice1 = false, shopprice1 = false, msg1 = false, namep1 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      liveprice.text = widget.productdata.liveparice;
      shopprice.text = widget.productdata.shopprice;
      namep.text = widget.productdata.productname;
      msg.text = widget.productdata.msg;
      prophoto = widget.productdata.addimg.split(",").toList();
      photo = prophoto;
      print(
          "111111111111111111111111111111111111111111111111111111111111111111${photo}");
    });
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
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              errorText: msg1 ? "add msg" : null,
                              hintText: "msg",
                              prefixIcon: Icon(Icons.keyboard_alt_outlined),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 50)))),
                    ),
                  ),
                ],
              ),
              Container(
                height: 370,
                color: Colors.cyan,
                margin: EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: photo.length + 1,
                  itemBuilder: (context, index) {
                    return index < photo.length
                        ? Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              img(index),
                              IconButton(
                                  alignment: AlignmentDirectional.topEnd,
                                  onPressed: () {
                                    setState(() {
                                      if (index < prophoto.length) {
                                        prophoto.removeAt(index);
                                        photo = prophoto + addphoto;
                                        // photo.removeAt(index);
                                      } else if (index >= prophoto.length) {
                                        addphoto
                                            .removeAt(index - prophoto.length);
                                        photo = prophoto + addphoto;
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.close))
                            ],
                          )
                        : InkWell(
                            onTap: () async {
                              final XFile? image = await _picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                imagepath = image!.path;
                                addphoto.add(imagepath);
                                photo=prophoto+addphoto;
                              });
                            },
                            child: Container(
                              height: 100,
                              margin: EdgeInsets.all(10),
                              child: Icon(Icons.add),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                            ));
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
                        });
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
                        Map map = {
                          'id': widget.productdata.id,
                          'Productname': namep2,
                          'liveparice': liveprice2,
                          'shopprice': shopprice2,
                          'msg': msg2,
                          'newphotos': addphoto.isEmpty ? "" : addtoimg.toString(),
                          'oldphotos': prophoto.isEmpty ? "" : prophoto.toString(),
                        };
                        var url = Uri.parse(
                            'https://poorest-debit.000webhostapp.com/apicalling/update.php');
                        var response = await http.post(url, body: map);
                        print('Response status: ${response.statusCode}');
                        print('Response body: ${response.body}');
                        var ll=jsonDecode(response.body);
                        updataclass up=updataclass.fromJson(ll);
                        if(up.hello==1)
                          {
                            if(up.result==1)
                              {
                                EasyLoading.dismiss();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                  return view();
                                },));
                              }
                          }
                      }
                    },
                    child: Text("Update")),
              )
            ],
          ),
        ],
      )),
    );
  }

  img(int index) {
    if (index < prophoto.length) {
      return Image.network(
        "https://poorest-debit.000webhostapp.com/apicalling/${prophoto[index]}",
        height: 100,
        width: 100,
      );
    } else {
      print(
          "-=======================================================================");
      return Image.file(
        File(photo[index]),
        height: 100,
        width: 100,
      );
    }
  }
}
class updataclass {
  int? hello;
  int? result;

  updataclass(this.hello, this.result);

  updataclass.fromJson(Map<String, dynamic> json) {
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

