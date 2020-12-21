import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String userName,
    String pass,
    File imageFile,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  bool isLoading;

  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _userName = '';
  var _password = '';
  File _imageFile;
  bool isLogin = true;
void _pickImage(File image){
  _imageFile=image;
}
  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if(_imageFile==null && !isLogin){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('pick image'),backgroundColor: Colors.redAccent,));
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
      print(_email);
      print(_password);
      widget.submitFn(
        _email.trim(),
        _userName.trim(),
        _password.trim(),
        _imageFile,
        isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(!isLogin)
                  UserImagePicker(_pickImage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'please enter valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'user name'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'please enter at least 4 charecter';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return 'password must be at least 6 charecter';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if(!widget.isLoading)
                  RaisedButton(
                    child: Text(isLogin ? 'Login' : 'SignUp'),
                    onPressed: _trySubmit,
                  ),
                  if(!widget.isLoading)
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      textColor: Theme.of(context).primaryColor,
                      child: Text(isLogin
                          ? 'create new account'
                          : 'I have already acount'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
