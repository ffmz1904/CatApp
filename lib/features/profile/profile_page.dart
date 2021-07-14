import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/features/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/features/authentication/cubit/auth_state.dart';
import 'package:cat_app/features/cache/cache_provider_types.dart';
import 'package:cat_app/features/cats/api/cat_api_types.dart';
import 'package:cat_app/features/profile/cubit/settings_cubit.dart';
import 'package:cat_app/features/profile/cubit/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final user = (authCubit.state as AuthAuthorizedState).userData;

    return Column(
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
        const SizedBox(height: 15),
        Text(user.name!),
        const SizedBox(height: 15),
        Text(user.email!),
        const SizedBox(height: 25),
        ElevatedButton(
          onPressed: () {
            authCubit.logout(user.authProvider);
          },
          child: Text('Logout'),
        ),
        const SizedBox(height: 25),
        BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
          return Column(
            children: [
              _apiSettings(
                state.apiProvider,
                (type) => context.read<SettingsCubit>().changeApiProvider(type),
              ),
              _cacheSettings(
                state.cacheProvider,
                (type) => context.read<SettingsCubit>().changeCacheProvider(type),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _apiSettings(apiType, changeTypeFunc) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Api type:',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20),
          ),
          _switch(
            text: 'Cats Api',
            value: apiType == CAT_API_CATS_API,
            onChangeFunc: () => changeTypeFunc(CAT_API_CATS_API),
          ),
          _switch(
            text: 'Firestore',
            value: apiType == CAT_API_FIRESTORE,
            onChangeFunc: () => changeTypeFunc(CAT_API_FIRESTORE),
          ),
        ],
      ),
    );
  }

  Widget _cacheSettings(cacheType, changeTypeFunc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Cache type:',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20),
          ),
          _switch(
            text: 'Shared Preferences',
            value: cacheType == CACHE_SHARED_PREFERENCES,
            onChangeFunc: () => changeTypeFunc(CACHE_SHARED_PREFERENCES),
          ),
          _switch(
            text: 'SQLite',
            value: cacheType == CACHE_SQLITE,
            onChangeFunc: () => changeTypeFunc(CACHE_SQLITE),
          ),
        ],
      ),
    );
  }

  Widget _switch({text, value, onChangeFunc}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        Switch(
          value: value,
          onChanged: (value) => onChangeFunc(),
          activeTrackColor: Colors.blue[200],
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }
}
