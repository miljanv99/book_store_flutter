import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:flutter/material.dart';
import '../models/serverResponse.model.dart';
import '../providers/authentication.provider.dart';
import '../widgets/snackBar.widget.dart';
import '../utils/screenWidth.dart';

class Login extends StatefulWidget {
  final AuthorizationProvider authNotifier;

  const Login({Key? key, required this.authNotifier}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  UserService userService = UserService();
  CartService cartService = CartService();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    double maxWidth = calculateMaxWidth(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
          child: Container(
        width: maxWidth,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                const SizedBox(height: 20),
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
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          controller: passwordCtrl,
                          obscureText: isPasswordHidden,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordHidden = !isPasswordHidden;
                                    });
                                  },
                                  icon: Icon(isPasswordHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off_outlined))),
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Map<String, dynamic> credentials = {
                        'password': passwordCtrl.text,
                        "username": usernameCtrl.text
                      };
                      String message;
                      Color backgroundColor = Colors.red;
                      message = await login(credentials);
                      if (widget.authNotifier.authenticated == true) {
                        print(
                            'AFTER LOGIN: ${widget.authNotifier.authenticated}');
                        backgroundColor = Colors.green;
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }

                      SnackBarNotification.show(
                          context, message, backgroundColor);
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<String> login(Map<String, dynamic> payload) async {
    print('Credentials: $payload');
    ServerResponse serverResponse = await userService.userLogin(payload);
    if (serverResponse.message == "Login successful!") {
      print('USAO');
      String loginToken = serverResponse.data;
      String username = payload['username'];
      await widget.authNotifier.authenticate(loginToken, username);
      print("DURING LOGIN: ${widget.authNotifier.authenticated}");
      //widget.authNotifier.username = username;
      print("USERNAME: $username");
      return "Login successfully logged in";
    } else {
      print('LOGIN FAILED');
      return "You've entered wrong username or password, please try again.";
    }
  }
}
