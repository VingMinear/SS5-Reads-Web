import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:homework3/modules/PageNotFound.dart';
import 'package:homework3/modules/admin/dashboard/screen/dashboard_screen.dart';
import 'package:homework3/modules/auth/screens/splash_screen.dart';
import 'package:homework3/modules/bottom_navigation_bar/main_layout.dart';
import 'package:homework3/modules/cart/screens/cart_screen.dart';
import 'package:homework3/modules/cart/screens/check_out_screen.dart';
import 'package:homework3/modules/favorite/screens/favorite_screen.dart';
import 'package:homework3/modules/home_screen/components/searching.dart';
import 'package:homework3/modules/home_screen/screens/home_screen.dart';
import 'package:homework3/modules/home_screen/screens/list_product.dart';
import 'package:homework3/modules/home_screen/screens/product_detail.dart';
import 'package:homework3/utils/SingleTon.dart';

GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellNavigatorKey');

class PageName {}

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorPageBuilder: (context, state) {
    return FadeTransitionPage(child: const NotFoundPage());
  },
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          FadeTransitionPage(child: const SplashScreen()),
    ),
    GoRoute(
      path: '/admin',
      pageBuilder: (context, state) =>
          FadeTransitionPage(child: const DashboardScreen()),
      redirect: (context, state) {
        print("redirect to : > ${state.fullPath}");
        if (state.fullPath == '/') {
          // Allow splash screen to show
          return null;
        }
        if (state.fullPath == '/admin' && !GlobalClass().isUserLogin) {
          return '/home';
        }
        if (!GlobalClass().user.value.isAdmin) {
          return '/home';
        }
        return null;
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(screen: child);
      },
      //
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) =>
              FadeTransitionPage(child: const HomePage()),
        ),
        GoRoute(
          path: '/favorite',
          pageBuilder: (context, state) => FadeTransitionPage(
            child: const FavoriteScreen(),
          ),
        ),
        GoRoute(
          path: '/list-products',
          pageBuilder: (context, state) => FadeTransitionPage(
            child: ListProducts(
              categoryId: state.uri.queryParameters['categoryId'] != null
                  ? int.parse(state.uri.queryParameters['categoryId']!)
                  : null,
              searchText: state.uri.queryParameters['search'],
            ),
          ),
        ),
        GoRoute(
          path: '/check-out',
          name: 'check-out',
          pageBuilder: (context, state) {
            var mapItem = state.extra as Map;
            return FadeTransitionPage(
              child: CheckOutScreen(
                listPro: mapItem['pro'],
                subTotal: mapItem['subTotal'],
                total: mapItem['total'],
              ),
            );
          },
        ),
        GoRoute(
          path: '/product-detail',
          pageBuilder: (context, state) {
            var params = state.uri.queryParameters;
            print('detail $params');

            return FadeTransitionPage(
              child: ProductDetailsView(
                cateogryId: int.parse(params['cateId']!),
                productId: int.parse(params['pId']!),
              ),
            );
          },
        ),
        GoRoute(
          path: '/cart',
          pageBuilder: (context, state) => FadeTransitionPage(
            child: const CartScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/search-product',
      name: 'search-product',
      pageBuilder: (context, state) {
        return FadeTransitionPage(child: const Searching());
      },
    ),
  ],
  redirect: (context, state) async {
    return null;
  },
);

int? tryParseInt(String? value) {
  if (value == null) return null;
  return int.tryParse(value);
}

// Reusable FadeTransitionPage class
class FadeTransitionPage extends CustomTransitionPage {
  FadeTransitionPage({required super.child})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
