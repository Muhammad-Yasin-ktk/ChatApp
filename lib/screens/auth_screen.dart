import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading=false;

  void _submitAuthForm(
    String email,
    String userName,
    String pass,
    File imageFile,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    try {
      setState(() {
        isLoading=true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        final ref=FirebaseStorage.instance.ref().child('user_image').child(userCredential.user.uid+'.jpg');
        UploadTask uploadTask =  ref.putFile(imageFile);
        var imageUrl = await (await uploadTask).ref.getDownloadURL();
//        uploadTask.whenComplete(() async{
//
//          try{
//           final imageUrl = await ref.getDownloadURL();
//          }catch(onError){
//            print("Error");
//          }
//
//          print(imageUrl);
//
//        });


        await Firestore.instance.collection('users').doc(userCredential.user.uid).set(
          {
            'username':userName,
            'email':email,
            'image_url':imageUrl
          }

        );


      }
    } on PlatformException catch (err) {
      var message = 'check user credential';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueAccent,
      ));
     setState(() {
       isLoading=false;
     });
    } catch (err) {
      print(err);
      setState(() {
        isLoading=false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: AuthForm(_submitAuthForm,isLoading),
    );
  }
}
