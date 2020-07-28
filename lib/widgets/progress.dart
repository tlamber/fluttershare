import 'package:flutter/material.dart';

circularProgress(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
    ),
  );
}

linearProgress(BuildContext context) {
  return Container(
    alignment: Alignment.topCenter,
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Theme.of(context).accentColor,
      ),
    ),
  );
}
