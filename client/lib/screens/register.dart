import 'package:book_store_flutter/services/cart.service.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/utils/globalMethods.dart';
import 'package:flutter/material.dart';
import '../models/serverResponse.model.dart';
import '../providers/authentication.provider.dart';
import '../widgets/snackBar.widget.dart';
import '../utils/screenWidth.dart';

class Register extends StatefulWidget {
  final AuthorizationProvider authNotifier;

  const Register({Key? key, required this.authNotifier}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();

  UserService userService = UserService();
  CartService cartService = CartService();
  GlobalMethods globalMethods = GlobalMethods();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController passwordConfirmCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController avatarCtrl = TextEditingController();
  bool isPasswordHidden = true;
  bool isPasswordConfirmHidden = true;

  @override
  Widget build(BuildContext context) {
    double maxWidth = calculateMaxWidth(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                              return 'Username is required';
                            }
                            return null;
                          },
                          controller: usernameCtrl,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                          controller: emailCtrl,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: isPasswordHidden,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                          controller: passwordCtrl,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordHidden = !isPasswordHidden;
                                });
                              },
                              icon: Icon(
                                isPasswordHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          obscureText: isPasswordConfirmHidden,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password is required';
                            }
                            return null;
                          },
                          controller: passwordConfirmCtrl,
                          decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isPasswordConfirmHidden =
                                          !isPasswordConfirmHidden;
                                    });
                                  },
                                  icon: Icon(isPasswordConfirmHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off_outlined))),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Avatar is required';
                            }
                            return null;
                          },
                          controller: avatarCtrl,
                          decoration:
                              const InputDecoration(labelText: 'Avatar: URL'),
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Map<String, dynamic> formInputs = {
                        'email': emailCtrl.text,
                        'password': passwordCtrl.text,
                        'confirmPassword': passwordConfirmCtrl.text,
                        "username": usernameCtrl.text,
                        'avatar': avatarCtrl.text
                      };
                      String message;
                      Color backgroundColor = Colors.red;
                      message = await register(formInputs);
                      if (widget.authNotifier.authenticated == true) {
                        print(
                            'AFTER Register: ${widget.authNotifier.authenticated}');
                        backgroundColor = Colors.green;
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }

                      SnackBarNotification.show(
                          context, message, backgroundColor);
                    }
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<String> register(Map<String, dynamic> payload) async {
    print('Credentials: $payload');
    ServerResponse serverResponse = await userService.registerUser(payload);

    if (serverResponse.message == "Registration successful!") {
      print('Registration successful');
      String token = serverResponse.data;
      String username = payload['username'];
      await widget.authNotifier.authenticate(token, username);
      print("DURING Register: ${widget.authNotifier.authenticated}");
      print("USERNAME: $username");
      return "Successfully registered";
    } else {
      // Registration failed
      Map<String, dynamic>? errors = serverResponse.errors;
      return globalMethods.handleRegistrationErrors(errors);
    }
  }
}
