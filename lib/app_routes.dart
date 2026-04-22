import 'package:flutter/material.dart';

import 'admin/admin_all_users.dart';
import 'admin/admin_archived_products.dart';
import 'admin/admin_archived_users.dart';
import 'admin/admin_dashboard.dart';
import 'admin/admin_commission.dart';
import 'admin/admin_offenses.dart';
import 'admin/admin_order_management.dart';
import 'admin/admin_product_management.dart';
import 'admin/admin_reports.dart';
import 'admin/admin_rider_request.dart';
import 'admin/admin_seller_request.dart';
import 'buyer/buyer_homepage.dart';
import 'buyer/buyer_cart.dart';
import 'buyer/buyer_checkout.dart';
import 'buyer/buyer_orders.dart';
import 'buyer/buyer_customer_service.dart';
import 'buyer/buyer_profile.dart';
import 'buyer/signup_buyer.dart';
import 'rider/rider_dashboard.dart';
import 'rider/rider_customer_service.dart';
import 'rider/rider_deliveries.dart';
import 'rider/rider_earnings.dart';
import 'rider/rider_history.dart';
import 'rider/rider_profile.dart';
import 'rider/signup_rider.dart';
import 'seller/seller_dashboard.dart';
import 'seller/seller_archived_products.dart';
import 'seller/seller_customer_service.dart';
import 'seller/seller_orders.dart';
import 'seller/seller_earnings.dart';
import 'seller/seller_promotion.dart';
import 'seller/seller_reports.dart';
import 'seller/seller_shop_public_view.dart';
import 'seller/seller_profile.dart';
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
  static const buyerProfile = '/dash/buyer/profile';
  static const sellerDashboard = '/dash/seller';
  static const sellerProducts = '/dash/seller/products';
  static const sellerArchivedProducts = '/dash/seller/products/archived';
  static const sellerCustomerService = '/dash/seller/support';
  static const sellerOrders = '/dash/seller/orders';
  static const sellerEarnings = '/dash/seller/earnings';
  static const sellerPromotions = '/dash/seller/promotions';
  static const sellerReports = '/dash/seller/reports';
  static const sellerShopPublicView = '/dash/seller/shop-public';
  static const sellerProfile = '/dash/seller/profile';
  static const riderDashboard = '/dash/rider';
  static const riderDeliveries = '/dash/rider/deliveries';
  static const riderEarnings = '/dash/rider/earnings';
  static const riderHistory = '/dash/rider/history';
  static const riderProfile = '/dash/rider/profile';
  static const riderCustomerService = '/dash/rider/support';
  static const adminDashboard = '/dash/admin';
  static const adminAllUsers = '/dash/admin/users';
  static const adminArchivedUsers = '/dash/admin/users/archived';
  static const adminSellerRequests = '/dash/admin/seller-requests';
  static const adminRiderRequests = '/dash/admin/rider-requests';
  static const adminProductManagement = '/dash/admin/products';
  static const adminArchivedProducts = '/dash/admin/products/archived';
  static const adminOrderManagement = '/dash/admin/orders';
  static const adminCommission = '/dash/admin/commission';
  static const adminOffenses = '/dash/admin/offenses';
  static const adminReports = '/dash/admin/reports';

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
      case buyerProfile:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const BuyerProfilePage(),
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
      case sellerShopPublicView:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerShopPublicViewPage(),
        );
      case sellerProfile:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const SellerProfilePage(),
        );
      case riderDashboard:
        {
          final args =
              (settings.arguments as Map?)?.cast<String, dynamic>() ?? const {};
          final tab = (args['tab'] as int?) ?? 0;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => RiderDashboardPage(initialIndex: tab),
          );
        }
      case riderDeliveries:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RiderDeliveriesPage(),
        );
      case riderEarnings:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RiderEarningsPage(),
        );
      case riderHistory:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RiderHistoryPage(),
        );
      case riderProfile:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const RiderProfilePage(),
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
      case adminProductManagement:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminProductManagementPage(),
        );
      case adminArchivedProducts:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminArchivedProductsPage(),
        );
      case adminOrderManagement:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminOrderManagementPage(),
        );
      case adminCommission:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminCommissionPage(),
        );
      case adminOffenses:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminOffensesPage(),
        );
      case adminReports:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AdminReportsPage(),
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
