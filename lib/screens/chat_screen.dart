
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mychat/constants.dart';


final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print("logged in user is: ${loggedInUser!.email}");
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                      style: TextStyle(color: Colors.black),
                      controller: messagTextController,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messagTextController.clear();
                      _firestore.collection('messages').add(
                        {
                          'text': messageText,
                          'sender': loggedInUser!.email,
                          'time': FieldValue.serverTimestamp()
                        },
                      );
                      setState(() {});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore
            .collection("messages")
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!.docs.reversed;
            List<MessageBuble> messageBubbles = [];
            for (var message in messages) {
              print(message.data());
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final currentUser = loggedInUser!.email;
              final messageBuble = MessageBuble(
                messageText,
                messageSender,
                currentUser == messageSender,
              );
              messageBubbles.add(messageBuble);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                children: messageBubbles,
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class MessageBuble extends StatelessWidget {
  MessageBuble(this.text, this.sender, this.isMe);
  String? text;
  String? sender;
  bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender ?? 'null',
            style: TextStyle(color: Colors.black38),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
            color: isMe ? Colors.lightBlue : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text ?? 'null',
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



































