import 'package:flutter/material.dart';
import 'package:lights_pro/homePage.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:lights_pro/loginPage.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

String urlUpload = "http://theksultra.com/project/php/register.php";

final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emcontroller = TextEditingController();
final TextEditingController _passcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();

String _name, _email, _password, _phone;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();

  const RegisterScreen({Key key}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Text('New User Registration',
          style: TextStyle(
                  color: Colors.amber,
                 )),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 155),
            child: RegisterWidget(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/cover.jpg"),
                fit: BoxFit.fitHeight,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.25), BlendMode.dstATop),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          'assets/images/logo.png',
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
            controller: _namecontroller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Name',
              icon: Icon(Icons.person),
            )),
        TextField(
            controller: _emcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
        TextField(
          controller: _passcontroller,
          decoration:
              InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
          obscureText: true,
        ),
        TextField(
            controller: _phcontroller,
            keyboardType: TextInputType.phone,
            decoration:
                InputDecoration(labelText: 'Phone', icon: Icon(Icons.phone))),
        SizedBox(
          height: 20,
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          minWidth: 300,
          height: 50,
          child: Text(
            'Register',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          color: Colors.amber,
          textColor: Colors.black,
          elevation: 15,
          onPressed: _onRegister,
        ),
        SizedBox(
          height: 13,
        ),
        GestureDetector(
            onTap: _onBackPress,
            child: Text('Already Register',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold, fontSize: 18))),
      ],
    );
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    uploadData();
  }

  void _onBackPress() {
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void uploadData() {
    _name = _namecontroller.text;
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    _phone = _phcontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 5) &&
        (_phone.length > 9)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      http.post(urlUpload, body: {
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
      }).then((res) {
        print(res.statusCode);
        if (res.body == "success") {
          Toast.show(res.body, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          savepref(_email, _password);
          _namecontroller.text = '';
          _emcontroller.text = '';
          _phcontroller.text = '';
          _passcontroller.text = '';

          pr.dismiss();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen()));
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void savepref(String email, String pass) async {
    print('Inside savepref');
    _email = _emcontroller.text;
    _password = _passcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', pass);
    print('Save pref $_email');
    print('Save pref $_password');
  }
}
