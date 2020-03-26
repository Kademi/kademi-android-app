import 'package:flutter/material.dart';
import 'package:kademi_app/src/api/kademi_api.dart';
import 'package:kademi_app/src/model/json_result/json_result.dart';
import 'package:kademi_app/src/model/profile/profile_data.dart';
import 'package:kademi_app/src/pages/login_page.dart';
import 'package:kademi_app/src/widgets/loading.dart';

import 'main_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _isSuccess = false;
  bool _initDone = false;
  bool _loadingVisible = true;

  @override
  void initState() {
    super.initState();

    KademiApi.profileData().then((JsonResult<ProfileData> jr) {
      setState(() {
        if (jr != null && jr.status) {
          _isSuccess = true;
        } else {
          _isSuccess = false;
        }
        _initDone = true;
        _loadingVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      child: (_initDone && _isSuccess ? MainPage() : LoginPage()),
      inAsyncCall: _loadingVisible,
    );
  }
}
