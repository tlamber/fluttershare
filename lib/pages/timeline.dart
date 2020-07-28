import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/header.dart';
import '../widgets/progress.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  CollectionReference userRef = Firestore.instance.collection('users');

  @override
  void initState() {
    createUser();
    super.initState();
  }

  createUser() {
    userRef.document().setData({
      'isAdmin': true,
      'username': "Tim",
      'postsCount': 0,
    });
  }

  updateUser() async {
    final DocumentSnapshot userDoc =
        await userRef.document('-MCu3mDlVd0S7J4XieJD').get();

    if (userDoc.exists) {
      userDoc.reference.updateData({
        'isAdmin': false,
        'username': "Timotayo",
        'postsCount': 0,
      });
    }
  }

  deleteUser() async {
    final DocumentSnapshot userDoc =
        await userRef.document('-MCu3mDlVd0S7J4XieJD').get();
    if (userDoc.exists) {
      userRef.document('-MCu3mDlVd0S7J4XieJD').delete();
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, appTitle: 'Timeline'),
      body: StreamBuilder<QuerySnapshot>(
        stream: userRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(context);
          }

          final List<Text> listOfUsers = snapshot.data.documents
              .map((documentSnapshot) => Text(documentSnapshot['username']))
              .toList();

          return Container(
            child: ListView(
              //   children: listOfUsers,
              children: listOfUsers,
            ),
          );
        },
      ),
    );
  }
}
