import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:jobshub/firebase/my_firebase_messaging_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobshub/employer/views/auth/employer_otp.dart';
import 'package:jobshub/employer/views/auth/kyc_checker.dart';
import 'package:jobshub/employer/views/info_collector/employer_complete_profile.dart';
import 'package:jobshub/employer/views/info_collector/employer_tell_us_more.dart';
import 'package:jobshub/hr/views/auth/hr_otp_screen.dart';
import 'package:jobshub/hr/views/auth/kyc_checker.dart';
import 'package:jobshub/hr/views/info_collector/hr_complete_profile.dart';
import 'package:jobshub/hr/views/info_collector/hr_tell_us_more.dart';
import 'package:jobshub/users/views/auth/kyc_checker.dart';
import 'package:jobshub/users/views/auth/otp_screen.dart';
import 'package:jobshub/users/views/info_collector/user_complete_profile.dart';
import 'package:jobshub/users/views/info_collector/user_tell_us_more.dart';
import 'package:jobshub/common/utils/app_routes.dart';
import 'package:jobshub/common/views/splash_screen.dart';
import 'package:jobshub/common/views/onboarding/web_onboarding_screen.dart';
import 'package:jobshub/common/views/onboarding/mobile_onboarding_screen.dart';
import 'package:jobshub/common/views/static/privacy_policy_page.dart';
import 'package:jobshub/common/views/static/terms_page.dart';
import 'package:jobshub/common/views/static/contact_us_page.dart';
import 'package:jobshub/common/views/static/refund_policy_page.dart';
import 'package:jobshub/common/views/static/blogs_page.dart';
import 'package:jobshub/users/views/auth/login_screen.dart';
import 'package:jobshub/employer/views/auth/employer_login.dart';
import 'package:jobshub/hr/views/auth/hr_login_screen.dart';
import 'package:jobshub/admin/views/auth/admin_login.dart';
import 'package:jobshub/users/views/bottomnav_sidebar/bottom_nav.dart';
import 'package:jobshub/employer/views/sidebar_dashboard/employer_dashboard.dart';
import 'package:jobshub/hr/views/sidebar_dashboard/hr_dashboard.dart';
import 'package:jobshub/admin/views/sidebar_dashboard/admin_dashboard.dart';

/// ✅ Top-Level Background Message Handler (required for FCM)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background notification here if needed
  // print("🌙 Background Notification: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialize Firebase for Android, iOS, Web
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔔 Register background notification handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🔔 Initialize your FCM logic (foreground, token, listeners)
  await MyFirebaseMessagingService.init();

  // Shared Preferences
  await SharedPreferences.getInstance();

  // For Web URL strategy
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BADHYATA',
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          // 🔹 Splash
          case AppRoutes.splash:
            return MaterialPageRoute(
              builder: (_) => const SplashScreen(),
              settings: settings,
            );

          case '/':
          case AppRoutes.home:
            return MaterialPageRoute(
              builder: (_) {
                if (kIsWeb) {
                  return const WebOnboardingPage();
                }
                return const MobileOnboardingPage();
              },
              settings: settings,
            );

          // 🔹 Static pages
          case AppRoutes.privacy:
            return MaterialPageRoute(
              builder: (_) => const PrivacyPolicyPage(),
              settings: settings,
            );
          case AppRoutes.terms:
            return MaterialPageRoute(
              builder: (_) => const TermsPage(),
              settings: settings,
            );
          case AppRoutes.contact:
            return MaterialPageRoute(
              builder: (_) => const ContactUsPage(),
              settings: settings,
            );
          case AppRoutes.refund:
            return MaterialPageRoute(
              builder: (_) => const RefundPolicyPage(),
              settings: settings,
            );
          case AppRoutes.blogs:
            return MaterialPageRoute(
              builder: (_) => const BlogsPage(),
              settings: settings,
            );

          // 🔹 Auth pages
          case AppRoutes.userLogin:
            return MaterialPageRoute(
              builder: (_) => const LoginScreen(),
              settings: settings,
            );

          case AppRoutes.userOtp:
            final args = settings.arguments as Map<String, dynamic>?;
            if (args == null || args['mobile'] == null) {
              return MaterialPageRoute(
                builder: (_) => const LoginScreen(),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => UserOtpScreen(
                mobile: args['mobile'] as String,
                otp: (args['otp'] as String?) ?? '',
              ),
              settings: settings,
            );

          case AppRoutes.employerLogin:
            return MaterialPageRoute(
              builder: (_) => const EmployerLogin(),
              settings: settings,
            );

          case AppRoutes.hrLogin:
            return MaterialPageRoute(
              builder: (_) => HrLoginPage(),
              settings: settings,
            );

          case AppRoutes.hrOtp:
            final args = settings.arguments as Map<String, dynamic>?;
            if (args == null || args['mobile'] == null || args['otp'] == null) {
              return MaterialPageRoute(
                builder: (_) => const HrLoginPage(),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => HROtpScreen(
                mobile: args['mobile'] as String,
                otp: args['otp'] as String,
              ),
              settings: settings,
            );

          case AppRoutes.hrCompleteProfile:
            final args = settings.arguments as Map<String, dynamic>?;
            final mobile = args?['mobile'] as String?;
            if (mobile == null || mobile.isEmpty) {
              return MaterialPageRoute(
                builder: (_) => const HrLoginPage(),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => HrCompleteProfile(mobile: mobile),
              settings: settings,
            );

          case AppRoutes.hrTellUsMore:
            return MaterialPageRoute(
              builder: (_) => const HrTellUsMore(),
              settings: settings,
            );

          case AppRoutes.hrKycChecker:
            return MaterialPageRoute(
              builder: (_) => const HrKyccheckerPage(),
              settings: settings,
            );

          case AppRoutes.adminLogin:
            return MaterialPageRoute(
              builder: (_) => AdminLoginPage(),
              settings: settings,
            );

          // 🔹 Dashboards
          case AppRoutes.userDashboard:
            return MaterialPageRoute(
              builder: (_) => const MainBottomNav(),
              settings: settings,
            );
          case AppRoutes.employerDashboard:
            return MaterialPageRoute(
              builder: (_) => EmployerDashboardPage(),
              settings: settings,
            );
          case AppRoutes.hrDashboard:
            return MaterialPageRoute(
              builder: (_) => HrDashboard(),
              settings: settings,
            );
          case AppRoutes.adminDashboard:
            return MaterialPageRoute(
              builder: (_) => AdminDashboard(),
              settings: settings,
            );

          case AppRoutes.userTellUsMore:
            return MaterialPageRoute(
              builder: (_) => const JobProfileDetailsPage(),
              settings: settings,
            );

          case AppRoutes.userCompleteProfile:
            final args = settings.arguments as Map<String, dynamic>?;
            final mobile = args?['mobile'] as String?;
            if (mobile == null || mobile.isEmpty) {
              return MaterialPageRoute(
                builder: (_) => const LoginScreen(),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => SignUpPage(mobile: mobile),
              settings: settings,
            );

          case AppRoutes.employerOtp:
            final args = settings.arguments as Map<String, dynamic>?;
            if (args == null || args['mobile'] == null || args['otp'] == null) {
              return MaterialPageRoute(
                builder: (_) => const EmployerLogin(),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => EmployerOtpScreen(
                mobile: args['mobile'] as String,
                otp: args['otp'] as String,
              ),
              settings: settings,
            );

          case AppRoutes.employerCompleteProfile:
            final args = settings.arguments as Map<String, dynamic>?;
            final mobile = args?['mobile'] as String?;
            if (mobile == null || mobile.isEmpty) {
              return MaterialPageRoute(
                builder: (_) => const EmployerLogin(),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => EmployerCompleteProfile(mobile: mobile),
              settings: settings,
            );

          case AppRoutes.employerTellUsMore:
            return MaterialPageRoute(
              builder: (_) => const EmployerTellUsMore(),
              settings: settings,
            );

          case AppRoutes.employerKycChecker:
            return MaterialPageRoute(
              builder: (_) => const EmployerKyccheckerPage(),
              settings: settings,
            );

          case AppRoutes.userKycChecker:
            return MaterialPageRoute(
              builder: (_) => const KycCheckerPage(),
              settings: settings,
            );

          // 🔹 Fallback
          default:
            return MaterialPageRoute(
              builder: (_) {
                if (kIsWeb) {
                  return const WebOnboardingPage();
                }
                return const MobileOnboardingPage();
              },
              settings: settings,
            );
        }
      },
    );
  }
}
