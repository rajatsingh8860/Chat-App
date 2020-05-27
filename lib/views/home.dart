import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:message/views/chat.dart';

class HomePage extends StatefulWidget {
  String userId;
  HomePage(this.userId);
  @override
  State<StatefulWidget> createState() {
    return HomePageState(this.userId);
  }
}

class HomePageState extends State<HomePage> {
  HomePageState(this.userId);
  String userId;
  bool isLoading = true;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Null> handleSignOut()async{
    setState(() {
      isLoading=true;
    });
    await FirebaseAuth.instance.signOut;
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Main",
                style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
                    actions: <Widget>[
                     IconButton(icon:Icon(Icons.exit_to_app) , 
                     onPressed: handleSignOut
                     )    
                    ],
                    ),
        body: Stack(
          children: <Widget>[
            Container(
                child: StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            )),
          
          ],
        ));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == userId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(),
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(15.0)),
                        imageUrl: document['photoUrl'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.account_circle,
                    
                        size: 50.0, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                  child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                              child: Text('NickName: ${document['nickname']}',
                                  style: TextStyle(color: Colors.black)),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0)),
                          
                        ],
                      ),
                      margin: EdgeInsets.only(left: 20.0)))
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (cntext) =>
                        Chat(document.documentID, document['photoUrl'])));
          },
          color: Colors.grey,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}
