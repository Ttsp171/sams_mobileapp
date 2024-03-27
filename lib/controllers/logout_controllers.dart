import 'package:sams/controllers/navigation_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/onboarding/login.dart';
import '../services/api.dart';
import '../widgets/toast.dart';

Future<void> logoutCall(context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final res =
      await HttpServices().postWithToken('/api/user-logout', context);
  if (res["status"] == 200) {
    prefs.clear();
    showSuccessToast(res["data"]["message"]);
    navigateWithoutRoute(context, const LoginPage());
  } else {
    showToast(res["data"]["message"]);
  }
}