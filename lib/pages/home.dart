import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'activity_feed.dart';
import 'create_account.dart';
import 'profile.dart';
import 'search.dart';
import 'timeline.dart';
import 'upload.dart';

final CollectionReference usersRef = Firestore.instance.collection('users');

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  GoogleSignIn googleSignIn;
  PageController pageController;
  int pageIndex = 0;
  User currentUser;

  @override
  void initState() {
    googleSignIn = GoogleSignIn();
    pageController = PageController();

    void signInHandler(GoogleSignInAccount account) {
      if (account != null) {
        createUserInFirestore();
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
    }

    googleSignIn.onCurrentUserChanged.listen(signInHandler, onError: (error) {
      print('error signing in with Google: $error');
    });

    googleSignIn
        .signInSilently(suppressErrors: false)
        .then(signInHandler)
        .catchError((error) {
      print('error signing in with Google: $error');
    });

    super.initState();
  }

  createUserInFirestore() async {
    GoogleSignInAccount googleUser = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(googleUser.id).get();

    if (!doc.exists) {
      String username = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccount(),
        ),
      );

      usersRef.document(googleUser.id).setData({
        "id": googleUser.id,
        "username": username,
        "photoUrl": googleUser.photoUrl,
        "email": googleUser.email,
        "displayName": googleUser.displayName,
        "bio": "",
        "timestamp": DateTime.now(),
      });

      doc = await usersRef.document(googleUser.id).get();
    }

    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser.username);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? successfullyAuthenticated() : notAuthenticated();
  }

  Widget successfullyAuthenticated() {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: [
          // Timeline(),
          RaisedButton(child: Text('logout'), onPressed: signOutWithGoogle),
          ActivityFeed(),
          Upload(currentUser),
          Search(),
          Profile(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onBottomTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            size: 30,
          )),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }

  Scaffold notAuthenticated() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to Tribe.World',
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.imFellEnglish(fontSize: 50, color: Colors.white),
            ),
            GestureDetector(
              child: Container(
                height: 60,
                width: 260,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                  ),
                ),
              ),
              onTap: signInWithGoogle,
            )
          ],
        ),
      ),
    );
  }

  void signInWithGoogle() {
    googleSignIn.signIn();
  }

  void signOutWithGoogle() {
    googleSignIn.signOut();
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onBottomTap(int pageBottomIndex) {
    pageController.animateToPage(pageBottomIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
