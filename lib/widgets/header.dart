import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar header(BuildContext context,
    {bool isAppTitle = true,
    String appTitle,
    bool removeHeaderBackButton = false}) {
  return AppBar(
    automaticallyImplyLeading: removeHeaderBackButton ? false : true,
    title: Text(
      isAppTitle ? 'Tribe Social' : appTitle,
      style: GoogleFonts.openSans(
        textStyle: TextStyle(
          fontSize: isAppTitle ? 27 : 20,
          color: Colors.white,
        ),
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
