import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    // final user = FirebaseAuth.instance.currentUser;
    // String? photo = user?.photoURL;
    // String? name = user?.displayName;
    // String? email = user?.email;

    return Container(
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     CircleAvatar(
        //       radius: 50,
        //       backgroundImage: NetworkImage(photo!),
        //     ),
        //     SizedBox(height: 15),
        //     Text(name!),
        //     SizedBox(height: 15),
        //     Text(email!),
        //     SizedBox(height: 25),
        //     BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        //       UserAuthTypes? type;
        //       if (state is UserAuthState) type = state.type;

        //       return ElevatedButton(
        //         onPressed: () {
        //           print(user);
        //           // userBloc.add(UserLogoutEvent(type: UserAuthTypes.Google));
        //           userBloc.add(UserLogoutEvent(type: UserAuthTypes.Facebook));
        //           // userBloc.add(UserLogoutEvent(type: type!));
        //           Navigator.push(
        //               context, MaterialPageRoute(builder: (context) => MyApp()));
        //         },
        //         child: Text('Logout'),
        //       );
        //     }),
        //   ],
        // ),
        );
  }
}
