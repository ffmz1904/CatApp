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
              _SettingsSection(
                'Api type:',
                [
                  _SwitchData(title: 'CatsApi', type: CAT_API_CATS_API, value: state.apiProvider == CAT_API_CATS_API),
                  _SwitchData(title: 'Firestore', type: CAT_API_FIRESTORE, value: state.apiProvider == CAT_API_FIRESTORE),
                ],
                (type) => context.read<SettingsCubit>().changeApiProvider(type),
              ),
              _SettingsSection(
                'Cache type:',
                [
                  _SwitchData(title: 'Shared Preferences', type: CACHE_SHARED_PREFERENCES, value: state.cacheProvider == CACHE_SHARED_PREFERENCES),
                  _SwitchData(title: 'SQLite', type: CACHE_SQLITE, value: state.cacheProvider == CACHE_SQLITE),
                ],
                (type) => context.read<SettingsCubit>().changeCacheProvider(type),
              ),
            ],
          );
        }),
      ],
    );
  }
}


class _SettingsSection extends StatelessWidget {
  final List<_SwitchData> _switchData;
  final String title;
  final Function _handleSwitch;

  _SettingsSection(this.title, this._switchData, this._handleSwitch);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20),
          ),
          ..._switchData.map((e) => _Switch(e, _handleSwitch)).toList(),
        ],
      ),
    );
  }
}

class _SwitchData {
  final String title;
  final String type;
  final bool value;

  _SwitchData({ required this.title, required this.type, required this.value});
}

class _Switch extends StatelessWidget {
  final _SwitchData _data;
  final Function _onChange;

  _Switch(this._data, this._onChange);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_data.title),
        Switch(
          value: _data.value,
          onChanged: (_) => _onChange(_data.type),
          activeTrackColor: Colors.blue[200],
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }
}
