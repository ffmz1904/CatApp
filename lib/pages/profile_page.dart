import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/authentication/cubit/auth_state.dart';
import 'package:cat_app/authentication/model/auth_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = context.read<AuthCubit>();
    AuthUserModel user = (authCubit.state as AuthAuthorizedState).userData;

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
              authCubit.logout(AuthProviders.google_auth);
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
