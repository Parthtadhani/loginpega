import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final ImagePicker _picker = ImagePicker();
  String imagepath = "";
  String data1 = "";
  String _errorMessage = "";
  String _errorMessage1 = "";
  DateTime dd = DateTime.now();
  bool eye = true;
  List myicon = [Icons.add_a_photo_outlined, Icons.photo_camera_back];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                image: DecorationImage(
                                    image: FileImage(File(imagepath))))),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    // width: 200,
                                    height: 210,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: myicon.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            print(myicon[index]);
                                            print(myicon[1]);
                                            if (myicon[index] ==
                                                Icons.photo_camera_back) {
                                              final XFile? image =
                                                  await _picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);

                                              setState(() {
                                                imagepath = image!.path;
                                              });
                                            } else if (myicon[index] ==
                                                Icons.add_a_photo_outlined) {
                                              final XFile? image =
                                                  await _picker.pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              setState(() {
                                                imagepath = image!.path;
                                              });
                                            }
                                          },
                                          child: Center(
                                            child: Container(
                                                height: 50,
                                                width: 50,
                                                margin: EdgeInsets.all(10),
                                                child: Icon(
                                                  myicon[index],
                                                  size: 50,
                                                )),
                                          ),
                                        );
                                      },
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2),
                                    ),
                                  );
                                },
                                context: context);
                          },
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                // color: Colors.white70,
                              ),
                              margin: EdgeInsets.only(
                                  top: 10, right: 15, left: 10, bottom: 20),
                              child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.brown,
                                  child: Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ))),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10, right: 10),
                            child: Text(
                              "Add Photo",
                              style: TextStyle(color: Colors.red),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 35, right: 35, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    child: TextField(
                        controller: name,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            errorText: name1 ? "Ebter name" : null,
                            hintText: "name",
                            prefixIcon: Icon(Icons.account_circle),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 50)))),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 35, right: 35, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    child: TextField(
                        keyboardType: TextInputType.phone,
                        autofillHints: [AutofillHints.telephoneNumber],
                        controller: num,
                        maxLength: 10,
                        decoration: InputDecoration(
                            errorText: num1 ? _errorMessage1 : null,
                            hintText: "Phone No",
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 50)))),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 35, right: 35, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    child: TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          errorText: email1 ? _errorMessage : null,
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 50))),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 35, right: 35, bottom: 10, top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    child: TextField(
                        controller: pass,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: eye,
                        decoration: InputDecoration(
                            hintText: "Password",
                            errorText: pass1 ? "Enter password" : null,
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: InkWell(
                                onTap: () {
                                  if (eye) {
                                    setState(() {
                                      eye = false;
                                    });
                                  } else {
                                    setState(() {
                                      eye = true;
                                    });
                                  }
                                },
                                child: Icon(Icons.remove_red_eye)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 50)))),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white70),
                      margin: EdgeInsets.only(
                          left: 35, right: 35, bottom: 10, top: 5),
                      child: TextField(
                        controller: dob,
                        decoration: InputDecoration(
                            errorText: dob1 ? "Enter dob" : null,
                            prefixIcon: IconButton(
                              onPressed: () {
                                hello(context);
                              },
                              icon: Icon(Icons.date_range),
                            )),
                      )),
                  InkWell(
                    onTap: () async {
                      name1 = false;
                      num1 = false;
                      email1 = false;
                      pass1 = false;
                      dob1 = false;
                      String name2 = name.text;
                      String num2 = num.text;
                      String email2 = email.text;
                      String pass2 = pass.text;
                      String dob2 = dob.text;

                      if (name2.isEmpty) {
                        setState(() {
                          name1 = true;
                        });
                      } else if (num2.isEmpty) {
                        setState(() {
                          _errorMessage1 = "Enter phone no";
                          num1 = true;
                        });
                      } else if (email2.isEmpty) {
                        setState(() {
                          _errorMessage = "Email can not be empty";
                          email1 = true;
                        });
                      } else if (!EmailValidator.validate(email2, true)) {
                        setState(() {
                          _errorMessage = "Invalid Email Address";
                          email1 = true;
                        });
                      } else if (pass2.isEmpty) {
                        setState(() {
                          pass1 = true;
                        });
                      } else if (dob2.isEmpty) {
                        setState(() {
                          dob1 = true;
                        });
                      } else {
                        Flushbar(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          message: "plese wait",
                          duration: Duration(seconds: 3),
                        )..show(context);
                        name1 = false;
                        num1 = false;
                        email1 = false;
                        pass1 = false;
                        dob1 = false;

                        List<int> ii = File(imagepath).readAsBytesSync();
                        String imagedate = base64Encode(ii);
                        Map map = {
                          "name": name2,
                          "mobile": num2,
                          "email": email2,
                          "password": pass2,
                          "dob": dob2,
                          "imagedata": imagedate
                        };
                        var url = Uri.parse(
                            'https://poorest-debit.000webhostapp.com/apicalling/register.php');
                        var response = await http.post(url, body: map);
                        print('Response status: ${response.statusCode}');
                        print('Response body: ${response.body}');

                        var apii = jsonDecode(response.body);
                        myapicall mmm = myapicall.fromJson(apii);

                        if (mmm.hello == 1) {
                          if (mmm.result == 1) {
                            setState(() {
                              num1 = false;
                              email1 = false;
                            });
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return login();
                              },
                            ));
                          } else if (mmm.result == 2) {
                            print(
                                "111111111111111111111111111111111111111111111111111111111111111111111111111");
                            return showDialog(
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("You are regster"),
                                  actions: [
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Ok"))
                                  ],
                                );
                              },
                              context: context,
                            );

                          } else {
                            Flushbar(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              message: "please change email and phonno No",
                              duration: Duration(seconds: 3),
                            )..show(context);
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 100,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                          left: 35, right: 35, bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blueGrey,
                      ),
                      child: Center(
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController name = TextEditingController();
  TextEditingController num = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController dob = TextEditingController();

  bool name1 = false;
  bool num1 = false;
  bool email1 = false;
  bool pass1 = false;
  bool dob1 = false;

  Future<void> hello(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dd,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != dd) {
      setState(() {
        dd = picked;
        dob.text = ("${dd.year}/${dd.month}/${dd.day}");
      });
    }
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
