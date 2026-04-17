import 'package:flutter/material.dart';

import 'admin/admin_all_users.dart';
import 'admin/admin_archived_users.dart';
import 'admin/admin_dashboard.dart';
import 'admin/admin_rider_request.dart';
import 'admin/admin_seller_request.dart';
import 'buyer/buyer_homepage.dart';
import 'buyer/buyer_cart.dart';
import 'buyer/buyer_checkout.dart';
import 'buyer/buyer_orders.dart';
import 'buyer/buyer_customer_service.dart';
import 'buyer/signup_buyer.dart';
import 'rider/rider_dashboard.dart';
import 'rider/rider_customer_service.dart';
import 'rider/signup_rider.dart';
import 'seller/seller_dashboard.dart';
import 'seller/seller_archived_products.dart';
import 'seller/seller_customer_service.dart';
import 'seller/seller_orders.dart';
import 'seller/seller_earnings.dart';
import 'seller/seller_promotion.dart';
import 'seller/seller_reports.dart';
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
  static const buyerOrders = '/dash/buyer/orders';
  static const buyerCart = '/dash/buyer/cart';
  static const buyerCheckout = '/dash/buyer/checkout';
  static const buyerCustomerService = '/dash/buyer/support';
  static const sellerDashboard = '/dash/seller';
  static const sellerProducts = '/dash/seller/products';
  static const sellerArchivedProducts = '/dash/seller/products/archived';
  static const sellerCustomerService = '/dash/seller/support';
  static const sellerOrders = '/dash/seller/orders';
  static const sellerEarnings = '/dash/seller/earnings';
  static const sellerPromotions = '/dash/seller/promotions';
  static const sellerReports = '/dash/seller/reports';
  static const riderDashboard = '/dash/rider';
  static const riderCustomerService = '/dash/rider/support';
  static const adminDashboard = '/dash/admin';
  static const adminAllUsers = '/dash/admin/users';
  static const adminArchivedUsers = '/dash/admin/users/archived';
  static const adminSellerRequests = '/dash/admin/seller-requests';
  static const adminRiderRequests = '/dash/admin/rider-requests';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case shell:
        {
          final args =
              (settings.arguments as Map?)?.cast<String, dynamic>() ?? const {};
          final tab = (args['tab'] as int?) ?? 0;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => PetopiaShellPage(initialIndex: tab),
          );
        }
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
        {
          final args =
              (settings.arguments as Map?)?.cast<String, dynamic>() ?? const {};
          final tab = (args['tab'] as int?) ?? 0;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => BuyerDashboardPage(initialIndex: tab),
          );
        }
      case buyerCart:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const BuyerCartPage(),
        );
      case buyerOrders:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const BuyerOrdersPage(),
        );
      case buyerCheckout:
        {
          final args =
              (settings.arguments as Map?)?.cast<String, dynamic>() ?? const {};
          final itemsRaw = (args['items'] as List?) ?? const [];
          final items = itemsRaw
              .map((e) => (e as Map).cast<String, dynamic>())
              .toList();
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => BuyerCheckoutPage(items: items),
          );
        }
      case buyerCustomerService:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const BuyerCustomerServicePage(),
        );
      case sellerDashboard:
        {
          final args =
              (settings.arguments as Map?)?.cast<String, dynamic>() ?? const {};
          final tab = (args['tab'] as int?) ?? 0;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => SellerDashboardPage(initialIndex: tab),
          );
        }
      case sellerProducts:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerProductsPage(),
        );
      case sellerArchivedProducts:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerArchivedProductsPage(),
        );
      case sellerCustomerService:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerCustomerServicePage(),
        );
      case sellerOrders:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerOrdersPage(),
        );
      case sellerEarnings:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerEarningsPage(),
        );
      case sellerPromotions:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerPromotionPage(),
        );
      case sellerReports:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerReportsPage(),
        );
      case riderDashboard:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RiderDashboardPage(),
        );
      case riderCustomerService:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RiderCustomerServicePage(),
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
