import 'package:flutter/material.dart';
import 'package:kademi_app/src/api/kademi_api.dart';
import 'package:kademi_app/src/api/kademi_auth.dart';
import 'package:kademi_app/src/config/kademi_settings.dart';
import 'package:kademi_app/src/model/profile/profile_data.dart';
import 'package:kademi_app/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData _profileData;
  bool _isLoadingVisible = true;

  @override
  void initState() {
    super.initState();

    KademiApi.profileData().then((jr) {
      if (jr != null && jr.status) {
        setState(() {
          _profileData = jr.data;
          _isLoadingVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _logo(),
                  SizedBox(height: 48.0),
                  Text('Username: '),
                  Text((_profileData != null ? _profileData.profile.userName : ''),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.0),
                  Text('Email: '),
                  Text((_profileData != null ? _profileData.profile.email : ''),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.0),
                  Text('Firstname: '),
                  Text((_profileData != null ? _profileData.profile.firstName : ''),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.0),
                  Text('Surname: '),
                  Text((_profileData != null ? _profileData.profile.surName : ''),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  // SizedBox(height: 12.0),
                  // settingsIdLabel,
                  // Text(settingsId,
                  //     style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.0),
                  _signOutButton(context),
                ],
              ),
            ),
          ),
        ),
        inAsyncCall: _isLoadingVisible);
  }

  Widget _logo() {
    return Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: ClipOval(
          child: (_profileData != null &&
                  _profileData.profile.photoHash != null &&
                  _profileData.profile.photoHash.length > 1
              ? Image.network(
                  KademiSettings.BASE_URL +
                      '/_hashes/files/' +
                      _profileData.profile.photoHash,
                  fit: BoxFit.cover,
                  width: 120.0,
                  height: 120.0,
                  loadingBuilder: (context, w, oci) {
                    if (oci == null) {
                      return w;
                    }
                    return CircularProgressIndicator();
                  },
                  errorBuilder: (conext, o, st) =>
                      Image.asset('assets/profile.png'),
                )
              : Image.asset('assets/profile.png')),
        ),
      ),
    );
  }

  Widget _signOutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Provider.of<KademiAuth>(context, listen: false).logout();
          Navigator.pushNamed(context, '/');
        },
        padding: EdgeInsets.all(12),
        color: Theme.of(context).primaryColorDark,
        child: Text('SIGN OUT', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
