import 'package:book_store_flutter/services/user.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/authentication.provider.dart';

class Login extends StatefulWidget {

  final AuthorizationProvider authNotifier;

  const Login({Key? key, required this.authNotifier}) : super(key: key);

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
                      await login(credentials);
                      String poruka =
                          "You've entered wrong username or password, please try again.";
                      if (widget.authNotifier.authenticated == true) {
                        print('AFTER LOGIN: ${widget.authNotifier.authenticated}');
                        //print("LOGIN: ${response.message}");
                        //var token = response.data;
                        //var username = usernameCtrl.text;
                        //storeToken(token);
                        //storeUserName(username);;
                        poruka = 'Login successfully logged in';

                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(poruka)));
                      }

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
   Future<void> login(Map<String, dynamic> payload) async {
      print('Credentials: $payload');
      String token = await userService.getToken(payload);
      if (token.isNotEmpty) {
        print('USAO');
        await widget.authNotifier.authenticate(token);
        print("DURING LOGIN: ${widget.authNotifier.authenticated}");
        //await authNotifier.updateProfile();
      } else {
        print('LOGIN FAILED');
      }
    }
}
