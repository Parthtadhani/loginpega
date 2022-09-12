import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loginpega/sign_up.dart';
import 'package:loginpega/viewpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'net.dart';
import 'package:http/http.dart' as http;

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
    String _errorMessage = "";
    bool hello = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page();
  }

  Future<void> page() async {
    hiii.prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: Center(
                    child: Text(
                  "Login page",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
                child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                        hintText: "email",
                        errorText: email1 ? _errorMessage : null,
                        prefixIcon: Icon(Icons.account_circle),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 50)))),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
                child: TextField(
                    controller: pass,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: hello,
                    decoration: InputDecoration(
                        hintText: "Password",
                        errorText: pass1 ? "Enter pasword" : null,
                        suffixIcon: InkWell(
                            onTap: () {
                              if (hello) {
                                setState(() {
                                  hello = false;
                                });
                              } else {
                                setState(() {
                                  hello = true;
                                });
                              }
                            },
                            child: Icon(Icons.remove_red_eye_outlined)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 50)))),
              ),
              InkWell(
                onTap: () async {
                  String email2 = email.text;
                  String pass2 = pass.text;
                  if (email2.isEmpty) {
                    setState(() {
                      _errorMessage = "Email can not be empty";
                      email1 = true;
                    });
                  } else if (pass2.isEmpty) {
                    setState(() {
                      pass1 = true;
                    });
                  } else {
                    EasyLoading.show(
                      status: 'loading...',
                      maskType: EasyLoadingMaskType.clear,
                    );
                    print('EasyLoading show');
                    setState(() {
                      email1 = false;
                      pass1 = false;
                    });
                    Map map = {
                      "email": email2,
                      "password": pass2,
                    };
                    var url = Uri.parse(
                        'https://poorest-debit.000webhostapp.com/apicalling/logindata.php');
                    var response = await http.post(url, body: map);
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');

                    var api = jsonDecode(response.body);
                    myapi mm = myapi.fromJson(api);

                    setState(() {
                      if (mm.connection == 1) {
                        if (mm.result == 1) {
                          EasyLoading.dismiss();
                          String? idd = mm.userdata!.id;
                          String? emaill = mm.userdata!.email;
                          String? mobilee = mm.userdata!.mobile;
                          String? image = mm.userdata!.imagename;
                          String? nameee = mm.userdata!.name;
                          String? dobb = mm.userdata!.dob;

                          hiii.prefs!.setString("idd", idd!);
                          hiii.prefs!.setString("email", emaill!);
                          hiii.prefs!.setString("mobile", mobilee!);
                          hiii.prefs!.setString("image", image!);
                          hiii.prefs!.setString("name", nameee!);
                          hiii.prefs!.setString("dob", dobb!);


                          hiii.prefs!.setBool("view", true);
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return view();
                            },
                          ));
                        } else {
                          EasyLoading.dismiss();
                          hiii.prefs!.setBool("view ", false);
                          Flushbar(
                            icon: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                            message: "Not regster",
                            duration: Duration(seconds: 3),
                          )..show(context);
                        }
                      }
                    });
                  }
                },
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(left: 35, right: 35, bottom: 10, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blueGrey,
                  ),
                  child: Center(
                    child: Text(
                      "Log in",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an New id ?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return signup();
                          },
                        ));
                      },
                      child: Text(
                        " Sign up.",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool email1 = false;
  bool pass1 = false;

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
}

class myapi {
  int? connection;
  int? result;
  Userdata? userdata;

  myapi({this.connection, this.result, this.userdata});

  myapi.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    result = json['result'];
    userdata = json['userdata'] != null
        ? new Userdata.fromJson(json['userdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connection'] = this.connection;
    data['result'] = this.result;
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.toJson();
    }
    return data;
  }
}
class Userdata {
  String? id;
  String? name;
  String? mobile;
  String? email;
  String? password;
  String? dob;
  String? imagename;

  Userdata(
      {this.id,
      this.name,
      this.mobile,
      this.email,
      this.password,
      this.dob,
      this.imagename});

  Userdata.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    mobile = json['Mobile'];
    email = json['Email'];
    password = json['Password'];
    dob = json['Dob'];
    imagename = json['Imagename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Mobile'] = this.mobile;
    data['Email'] = this.email;
    data['Password'] = this.password;
    data['Dob'] = this.dob;
    data['Imagename'] = this.imagename;
    return data;
  }
}
