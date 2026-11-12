import 'package:blog_rivaan/core/route/route_name.dart';
import 'package:blog_rivaan/features/auth/presentation/pages/log_in_page.dart';
import 'package:blog_rivaan/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.login_page:
        return MaterialPageRoute(builder: (context) => LogInPage());
      case RouteName.signup_page:
        return MaterialPageRoute(builder: (context) => SignUpPage());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Container(child: Text("No Specific route is Defined")),
            ),
          ),
        );
    }
  }
}
