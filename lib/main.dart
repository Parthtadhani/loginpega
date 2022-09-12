import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loginpega/login.dart';
import 'package:loginpega/net.dart';
import 'package:loginpega/sign_up.dart';
import 'package:loginpega/viewpage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: lottielohin(),
    builder: EasyLoading.init(),
  ));
}

class lottielohin extends StatefulWidget {
  const lottielohin({Key? key}) : super(key: key);

  @override
  State<lottielohin> createState() => _lottielohinState();
}

class _lottielohinState extends State<lottielohin> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    demo();
  }

  Future<void> demo() async {
    hiii.prefs = await SharedPreferences.getInstance();
    bool stt = hiii.prefs!.getBool("view") ?? false;
    if(await get())
      {
        if (stt) {
          Future.delayed(Duration(seconds: 2)).then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return view();
              },
            ));
          });
        }
        else
        {
          Future.delayed(Duration(seconds: 2)).then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return login();
              },
            ));
          });
        }
      }
    else
      {
        EasyLoading.dismiss();
        return showDialog(
          builder: (context) {
            return AlertDialog(
              title: Text("Check You Internet"),
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
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              height: 50,
              width: double.infinity,
              // color: Colors.brown,
              child: Center(
                  child: Text("Welcome",
                      style: TextStyle(color: Colors.white, fontSize: 25)))),
          Expanded(
            child: Container(
              height: 900,
              color: Colors.black,
              child: Lottie.asset('Raw/loading.json'),
            ),
          ),
          InkWell(
            onTap: () {
              EasyLoading.show(
                status: 'loading...',
                maskType: EasyLoadingMaskType.clear,
              );
              get1();
            },
            child: Container(
                height: 50,
                color: Colors.white30,
                margin: EdgeInsets.all(20),
                child: Center(
                    child: Text("Login",
                        style: TextStyle(color: Colors.white, fontSize: 25)))),
          ),
          InkWell(
            onTap: () {
              EasyLoading.show(
                status: 'loading...',
                maskType: EasyLoadingMaskType.clear,
              );
              get2();
            },
            child: Container(
                height: 50,
                color: Colors.white30,
                margin: EdgeInsets.all(20),
                child: Center(
                    child: Text("Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 25)))),
          )
        ],
      ),
    ));
  }

  void get1() async {
    if (await get()) {
      EasyLoading.dismiss();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return login();
        },
      ));
    } else {
      EasyLoading.dismiss();
      return showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text("Check You Internet"),
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
    }
  }

  void get2() async {
    if (await get()) {
      EasyLoading.dismiss();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return signup();
        },
      ));
    } else {
      EasyLoading.dismiss();
      return showDialog(
        builder: (context) {
          return AlertDialog(
            title: Text("Check You Internet"),
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
    }
  }
}
