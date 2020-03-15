import 'package:flutter/material.dart';
import 'package:fa_cosmetic/registerscreen.dart';
import 'package:fa_cosmetic/mainscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   
    TextEditingController _emailEditingController = new TextEditingController();
    TextEditingController _passEditingController = new TextEditingController();
    String urlLogin = "https://seriouslaa.com/fa_cosmetic/user_login.php";


@override
Widget build(BuildContext context) {
  return new Scaffold(
       backgroundColor: Color(0xFFE0F2F1),
       body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Image.asset(
                  'assets/images/logo2.png',
                   width: 200,
                   height: 230,
             ),
             SizedBox(
                   height: 50,
            ),
            
             TextField(
                   controller: null,
                   keyboardType: TextInputType.emailAddress,
                   decoration: InputDecoration(
                   contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                   labelText: 'Email',
                   icon: Icon(Icons.email),
                   border:OutlineInputBorder(
                   borderRadius: BorderRadius.circular(32.0))
                   )),
             SizedBox(
                    height: 10,
                  ),     
             TextField(
                   controller: null,
                   decoration: InputDecoration(
                   contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                   labelText: 'Password',
                   icon: Icon(Icons.lock),
                   border:OutlineInputBorder(
                   borderRadius: BorderRadius.circular(32.0))
                    ),
                   obscureText: true,
                  ),
             SizedBox(
                   height: 20,
                  ),
            
             Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    Padding(
                       padding: EdgeInsets.all(5),
                       child:RaisedButton(
                       child: Text("SIGN UP"),
                       onPressed: _registerUser,
                       color: Colors.red,
                       textColor: Colors.yellow,
                       splashColor: Colors.grey,
                       elevation: 10,
                        ),
                    ),
                    
                   Padding(
                       padding: EdgeInsets.all(5),
                       child:RaisedButton(
                       child: Text("LOGIN"),
                       onPressed: _userLogin,
                       color: Colors.red,
                       textColor: Colors.yellow,
                       splashColor: Colors.grey,
                       elevation: 10,
                        ),
                     ),
                    ],
                  ),
                  
                  CheckboxListTile(
                      title: Text("Remember Me"),
                      value: rememberMe,
                      onChanged: _onRememberMeChanged,
                      controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                    ),         
          
         
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                        onTap: _forgotPassword,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
            ],
          
          ),
          ],
        ),
       ), 
      
    
    
  );
  }

  void _userLogin() {
   String email = _emailEditingController.text;
    String password = _passEditingController.text;

    http.post(urlLogin, body: {
      "email": email,
      "password": password,
    }).then((res) {
      if (res.body == "success") {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
        Toast.show("Login success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Login failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });



  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Forgot Password?"),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your recovery email",
                ),
                TextField(
                    decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ))
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
        } else {}
      });

  void loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email'))??'';
    String password = (prefs.getString('pass'))??'';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}