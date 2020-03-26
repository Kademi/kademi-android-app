import 'package:flutter/material.dart';
import 'package:kademi_app/src/model/json_result/json_result.dart';
import 'package:requests/requests.dart';

import '../config/kademi_settings.dart';
import '../model/profile_bean.dart';

class KademiAuth with ChangeNotifier {
  ProfileBean profileData;

  Future<ProfileBean> getProfile() {
    return Future.value(profileData);
  }

  Future<JsonResult<ProfileBean>> login(String username, String password) {
    String loginURL = KademiSettings.BASE_URL + '/.dologin';

    return Requests.post(
      loginURL,
      body: {
        '_loginUserName': username,
        '_loginPassword': password,
      },
      bodyEncoding: RequestBodyEncoding.FormURLEncoded,
    ).then((resp) {
      if (!resp.hasError) {
        JsonResult<ProfileBean> jr = JsonResult<ProfileBean>.fromJson(
          resp.json(),
          (dynamic m) {
            return ProfileBean.fromJson(m);
          },
        );
        profileData = jr.status ? jr.data : null;

        notifyListeners();

        return jr;
      }

      return null;
    });
  }

  void logout() async {
    await Requests.clearStoredCookies(
        Requests.getHostname(KademiSettings.BASE_URL));
    profileData = null;
    notifyListeners();
  }
}
