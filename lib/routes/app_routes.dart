import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/checkout_screen/checkout_screen.dart';
import '../presentation/order_history_screen/order_history_screen.dart';
import '../presentation/product_detail/product_detail.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/product_dashboard/product_dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/shopping_cart/shopping_cart.dart';
import '../presentation/product_search/product_search.dart';
import '../presentation/personal_information/personal_information.dart';
import '../presentation/personal_information/manage_addresses_page.dart';
import '../presentation/personal_information/add_edit_address_page.dart';
import '../presentation/wishlist_page/wishlist_page.dart';

class AppRoutes {
  static const String initial = '/splash-screen';
  static const String splashScreen = '/splash-screen';
  static const String checkoutScreen = '/checkout-screen';
  static const String orderHistory = '/order-history';
  static const String personalInformation = '/personal-information';
  static const String manageAddresses = '/manage-addresses';
  static const String addEditAddress = '/add-edit-address';
  static const String productDetail = '/product-detail';
  static const String userProfile = '/user-profile';
  static const String productDashboard = '/product-dashboard';
  static const String login = '/login-screen';
  static const String shoppingCart = '/shopping-cart';
  static const String productSearch = '/product-search';
  static const String wishlist = '/wishlist';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    checkoutScreen: (context) => const CheckoutScreen(),
    orderHistory: (context) => const OrderHistoryScreen(),
    personalInformation: (context) => const PersonalInformation(),
    manageAddresses: (context) => const ManageAddressesPage(),
    addEditAddress: (context) => AddEditAddressPage(address: null),
    productDetail: (context) => const ProductDetail(),
    userProfile: (context) => const UserProfile(),
    productDashboard: (context) => const ProductDashboard(),
    login: (context) => const LoginScreen(),
    shoppingCart: (context) => const ShoppingCart(),
    productSearch: (context) => const ProductSearch(),
    wishlist: (context) => const WishlistPage(),
  };
}
