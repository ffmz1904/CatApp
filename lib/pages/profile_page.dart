import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final user = FirebaseAuth.instance.currentUser;
    String? photo = user?.photoURL;
    String? name = user?.displayName;
    String? email = user?.email;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(photo!),
          ),
          SizedBox(height: 15),
          Text(name!),
          SizedBox(height: 15),
          Text(email!),
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              userBloc.add(UserLogoutEvent());
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
