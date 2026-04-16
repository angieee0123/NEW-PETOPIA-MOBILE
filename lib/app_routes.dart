import 'package:flutter/material.dart';

import 'admin/admin_all_users.dart';
import 'admin/admin_archived_users.dart';
import 'admin/admin_dashboard.dart';
import 'admin/admin_rider_request.dart';
import 'admin/admin_seller_request.dart';
import 'buyer/buyer_homepage.dart';
import 'buyer/signup_buyer.dart';
import 'rider/rider_dashboard.dart';
import 'rider/signup_rider.dart';
import 'seller/seller_dashboard.dart';
import 'seller/seller_products.dart';
import 'seller/signup_seller.dart';
import 'users/account.dart';
import 'users/home.dart';
import 'users/login_forgot_password.dart';
import 'users/login_otp_verification.dart';
import 'users/login_reset_code.dart';
import 'users/login_reset_password.dart';
import 'users/signup_role_selection.dart';

class AppRoutes {
  static const shell = '/';
  static const account = '/account';
  static const signupRole = '/signup/role';
  static const signupBuyer = '/signup/buyer';
  static const signupSeller = '/signup/seller';
  static const signupRider = '/signup/rider';

  static const otp = '/auth/otp';
  static const forgotPassword = '/auth/forgot';
  static const resetCode = '/auth/reset-code';
  static const resetPassword = '/auth/reset-password';

  static const buyerDashboard = '/dash/buyer';
  static const sellerDashboard = '/dash/seller';
  static const sellerProducts = '/dash/seller/products';
  static const riderDashboard = '/dash/rider';
  static const adminDashboard = '/dash/admin';
  static const adminAllUsers = '/dash/admin/users';
  static const adminArchivedUsers = '/dash/admin/users/archived';
  static const adminSellerRequests = '/dash/admin/seller-requests';
  static const adminRiderRequests = '/dash/admin/rider-requests';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case shell:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const PetopiaShellPage(),
        );
      case account:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AccountPage(),
        );
      case signupRole:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SignupRoleSelectionPage(),
        );
      case signupBuyer:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SignupBuyerPage(),
        );
      case signupSeller:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SignupSellerPage(),
        );
      case signupRider:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SignupRiderPage(),
        );
      case forgotPassword:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const LoginForgotPasswordPage(),
        );
      case otp:
        {
          final args =
              (settings.arguments as Map?)?.cast<String, dynamic>() ?? const {};
          final destinationLabel = (args['destinationLabel'] as String?) ?? '';
          final next = args['next'] as String?;
          return MaterialPageRoute<bool>(
            settings: settings,
            builder: (_) => LoginOtpVerificationPage(
              destinationLabel: destinationLabel,
              nextRouteNameOnSuccess: next,
            ),
          );
        }
      case resetCode:
        {
          final args =
              (settings.arguments as Map?)?.cast<String, dynamic>() ?? const {};
          final destinationLabel = (args['destinationLabel'] as String?) ?? '';
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) =>
                LoginResetCodePage(destinationLabel: destinationLabel),
          );
        }
      case resetPassword:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const LoginResetPasswordPage(),
        );
      case buyerDashboard:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const BuyerDashboardPage(),
        );
      case sellerDashboard:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerDashboardPage(),
        );
      case sellerProducts:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerProductsPage(),
        );
      case riderDashboard:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RiderDashboardPage(),
        );
      case adminDashboard:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminDashboardPage(),
        );
      case adminAllUsers:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminAllUsersPage(),
        );
      case adminArchivedUsers:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminArchivedUsersPage(),
        );
      case adminSellerRequests:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminSellerRequestPage(),
        );
      case adminRiderRequests:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminRiderRequestPage(),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
