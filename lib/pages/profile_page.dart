import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_events.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/models/auth_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
      AuthUserModel user = (userState as UserAuthState).userData;

      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              fit: BoxFit.fill,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              imageUrl: user.photo!,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 50,
                backgroundImage: imageProvider,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 15),
            Text(user.name!),
            SizedBox(height: 15),
            Text(user.email!),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                userBloc.add(UserLogoutEvent(authProvider: user.authProvider));

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Text('Logout'),
            ),
          ],
        ),
      );
    });
  }
}
