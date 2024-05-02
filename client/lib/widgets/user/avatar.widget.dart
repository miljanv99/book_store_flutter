import 'package:book_store_flutter/providers/authentication.provider.dart';
import 'package:book_store_flutter/services/user.service.dart';
import 'package:book_store_flutter/widgets/snackBar.widget.dart';
import 'package:flutter/material.dart';
import '../../models/serverResponse.model.dart';
import '../../models/user.model.dart';

class AvatarWidget extends StatefulWidget {
  final AuthorizationProvider? authNotifier;
  final TextEditingController? avatarCtrl;
  final User? userProfileData;
  const AvatarWidget(
      {Key? key,
      this.userProfileData,
      this.avatarCtrl,
      this.authNotifier})
      : super(key: key);

  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  String defaultAvatar = 'https://i.imgur.com/4s5qLzU.png';

  UserService userService = UserService();
  final urlFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.blueAccent,
            width: 4.0,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 50,
          backgroundImage: NetworkImage(widget.userProfileData != null
              ? '${widget.userProfileData!.avatar}'
              : defaultAvatar),
        ),
      ),
      onTapInside: (event) {
        showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return SingleChildScrollView(
                child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.ease,
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text("Insert Avatar's URL"),
                      Form(
                        key: urlFormKey,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Avatar is required';
                              }
                              return null;
                            },
                            controller: widget.avatarCtrl,
                            decoration:
                                const InputDecoration(labelText: 'Avatar: URL'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: const Text('Apply Avatar Image'),
                        onPressed: () async {
                          if (widget.userProfileData != null &&
                              urlFormKey.currentState!.validate()) {
                            Map<String, dynamic> formInputs = {
                              'id': widget.authNotifier!.userId,
                              'avatar': widget.avatarCtrl!.text
                            };

                            Future<ServerResponse> serverResponse =
                                userService.changeAvatar(
                                    widget.authNotifier!.token, formInputs);

                            serverResponse.then((response) {
                              if (response.errors == null) {
                                setState(() {
                                  widget.userProfileData!.avatar =
                                      widget.avatarCtrl!.text;
                                });
                                Navigator.pop(context);
                                SnackBarNotification.show(
                                    context, response.message, Colors.green);
                              } else {
                                Navigator.pop(context);
                                SnackBarNotification.show(context,
                                    response.errors!['avatar'], Colors.red);
                              }
                            });
                          } else if (urlFormKey.currentState!.validate()) {
                            setState(() {
                              defaultAvatar = widget.avatarCtrl!.text;
                            });
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ));
          },
        );
      },
    );
  }
}
