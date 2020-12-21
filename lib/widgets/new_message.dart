import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var _enterMessage = '';
  final enterMessageController = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData=await Firestore.instance.collection('users').doc(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': _enterMessage,
      'username':userData['username'],
      'userImage':userData['image_url'],
      'time': Timestamp.now(),
      'userId': user.uid,
    });
    enterMessageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _enterMessage = value;
                });
              },
              controller: enterMessageController,
              decoration: InputDecoration(labelText: 'send a message....'),
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.send,
              ),
              onPressed: _enterMessage.trim().isEmpty ? null : _sendMessage)
        ],
      ),
    );
  }
}
