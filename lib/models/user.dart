import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String photoUrl;
  final String displayName;
  final String bio;

  User(
      {this.bio,
      this.displayName,
      this.email,
      this.id,
      this.photoUrl,
      this.username});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
      displayName: doc['displayName'],
      bio: doc['bio'],
    );
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bio = json['bio'],
        displayName = json['displayName'],
        photoUrl = json['photoUrl'],
        email = json['email'],
        username = json['username'];
}
