import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<QuerySnapshot> matchingUsersResults;
  TextEditingController queryTextController = TextEditingController();
  //TODO -- GOAL: instead of displaying a string with displayName, use the custom UserResult() stateless widget
  //TODO -- to display name, image, and email

  Future<QuerySnapshot> checkQueryMatch(String query) {
    setState(() {
      matchingUsersResults = usersRef
          .where('displayName', isGreaterThanOrEqualTo: query)
          .getDocuments();
    });
  }

  _searchAppBar() {
    return AppBar(
      title: TextFormField(
        controller: queryTextController,
        onFieldSubmitted: checkQueryMatch,
        decoration: InputDecoration(
          filled: true,
          hintText: 'search for a user...',
          fillColor: Colors.white,
          prefixIcon: Icon(
            Icons.account_box,
            color: Colors.green,
            size: 28,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              queryTextController.clear();
              print('clear search result');
            },
          ),
        ),
      ),
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: matchingUsersResults,
      builder: (context, AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return circularProgress(context);
        }
        List<UserResult> listQueryMatches = [];
        List<DocumentSnapshot> listDocSnap = asyncSnapshot.data.documents;
        listDocSnap.forEach((DocumentSnapshot doc) {
          User user = User.fromDocument(doc);

          listQueryMatches.add(
            UserResult(user),
          );
        });

        return ListView(
          children: listQueryMatches,
        );
      },
    );
  }

// Go from Future<QuerySnapshot> -> QuerySnapshot -> list of document snapshot aka [ DocumentSnapshot, DocumentSnapshot]
// iterate through this list.  During the iteration, set each document snapshot into Custom user model (Dart object)
  // transfer this data into a list of text widgets and return it in a listview.

  Container buildNoContent() {
    Orientation orientation = MediaQuery.of(context).orientation;
    print(orientation);

    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.landscape ? 100 : 300,
            ),
            Text(
              'find users',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: _searchAppBar(),
      body: matchingUsersResults != null
          ? buildSearchResults()
          : buildNoContent(),
    );
  }
}

class UserResult extends StatelessWidget {
  User user;
  UserResult(this.user);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(.7),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            ),
            title: Text(
              user.displayName,
              style:
                  GoogleFonts.reenieBeanie(color: Colors.white, fontSize: 24),
            ),
            subtitle: Text(
              user.email,
              style: GoogleFonts.rockSalt(color: Colors.black, fontSize: 12),
            ),
            trailing: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.userPlus,
                color: Colors.black87,
              ),
              tooltip: 'tooltip test',
            ),
          ),
          Divider(
            height: 2,
            color: Colors.white24,
          ),
        ],
      ),
    );
  }
}
