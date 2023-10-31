import 'package:book_store_flutter/main.dart';
import 'package:book_store_flutter/screens/home.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Future<SharedPreferences> sharedPreferences =
      SharedPreferences.getInstance();
  final formKey = GlobalKey<FormState>();

  UserService userService = UserService();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://content.wepik.com/statics/76970161/preview-page0.jpg',
                  height: 200,
                ),
              ),
              SizedBox(height: 20),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        controller: usernameCtrl,
                        decoration: InputDecoration(labelText: 'Username'),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        controller: passwordCtrl,
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {

                    Map<String, dynamic> credentials = {
                      'password': passwordCtrl.text,
                      "username": usernameCtrl.text
                    };

                    var response = await userService.login(credentials);
                    String poruka = "You've entered wrong username or password, please try again.";
                    if (response.message == 'Login successful!') {
                      print("LOGIN: ${response.message}");
                      var token = response.data;
                      var username = usernameCtrl.text;
                      storeToken(token);
                      storeUserName(username);
                      poruka = 'Login successfully logged in';

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ));

                          ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(poruka)));
                      
                    }

                    ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(poruka)));
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void storeToken(String token) {
    sharedPreferences.then((SharedPreferences sp) =>
        sp.setString('token', token).then((bool isOK) {
          if (isOK) {
            print('Token is successfuly stored');
          } else {
            print('Token is not successfuly stored');
          }
        }));
  }
  void storeUserName(String username) {
    sharedPreferences.then((SharedPreferences sp) =>
        sp.setString('username', username).then((bool isOK) {
          if (isOK) {
            print('Username is successfuly stored');
            print(username);
          } else {
            print('Username is not successfuly stored');
          }
        }));
  }
}
