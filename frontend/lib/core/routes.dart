import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/profile_view.dart';

getRoutes() {
  return {
    LoginView.route: (context) => LoginView(),
    ProfileView.route: (context) => ProfileView(),
  };
}
