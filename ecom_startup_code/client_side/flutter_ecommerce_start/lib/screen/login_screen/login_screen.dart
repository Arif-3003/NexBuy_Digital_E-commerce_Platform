import 'package:e_commerce_flutter/utility/extensions.dart';
import '../../theme/app_color.dart';
import '../../theme/login_background.dart';
import '../../utility/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND (soft dots)
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg_soft_dot.png",
              fit: BoxFit.cover,
            ),
          ),

          /// LOGIN CARD
          LoginBackgroundWrapper(
            child: FlutterLogin(
              loginAfterSignUp: false,
              logo: const AssetImage('assets/images/logo.png'),

              onLogin: (loginData) {
                context.userProvider.login(loginData);
              },

              onSignup: (SignupData data) {
                context.userProvider.register(data);
              },

              onSubmitAnimationCompleted: () {
                if (context.userProvider.getLoginUsr()?.sId != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                }
              },

              onRecoverPassword: (_) => null,
              hideForgotPasswordButton: true,

              theme: LoginTheme(
                primaryColor: AppColors.primaryOrange,
                accentColor: AppColors.primaryOrange,

                buttonTheme: LoginButtonTheme(
                  backgroundColor: AppColors.primaryOrange,
                  highlightColor: AppColors.primaryOrange.withOpacity(0.8),
                  splashColor: AppColors.primaryOrange.withOpacity(0.3),
                ),

                cardTheme: CardTheme(
                  color: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),

                titleStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),

                pageColorLight: Colors.transparent,
                pageColorDark: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
