import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
import 'package:homework3/modules/PageNotFound.dart';
import 'package:homework3/modules/about_us/about_us.dart';
import 'package:homework3/modules/admin/dashboard/screen/dashboard_screen.dart';
import 'package:homework3/modules/admin/dashboard/screen/editing_category_screen.dart';
import 'package:homework3/modules/admin/dashboard/screen/main_layout_admin.dart';
import 'package:homework3/modules/admin/order/screens/admin_order_screen.dart';
import 'package:homework3/modules/admin/product/controller/adproduct_con.dart';
import 'package:homework3/modules/admin/product/screen/adproduct_detail.dart';
import 'package:homework3/modules/admin/product/screen/adproduct_screen.dart';
import 'package:homework3/modules/admin/slides/screens/slide_screen.dart';
import 'package:homework3/modules/admin/user/screen/admin_user.dart';
import 'package:homework3/modules/auth/screens/splash_screen.dart';
import 'package:homework3/modules/bottom_navigation_bar/main_layout.dart';
import 'package:homework3/modules/cart/screens/cart_screen.dart';
import 'package:homework3/modules/cart/screens/check_out_screen.dart';
import 'package:homework3/modules/favorite/screens/favorite_screen.dart';
import 'package:homework3/modules/home_screen/components/searching.dart';
import 'package:homework3/modules/home_screen/screens/home_screen.dart';
import 'package:homework3/modules/home_screen/screens/list_product.dart';
import 'package:homework3/modules/home_screen/screens/product_detail.dart';
import 'package:homework3/modules/profile/screens/contact_us.dart';
import 'package:homework3/modules/profile/screens/order_screen.dart';
import 'package:homework3/utils/SingleTon.dart';

GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellNavigatorKey');
GlobalKey<NavigatorState> _shellNavigatorKeyAdmin =
    GlobalKey<NavigatorState>(debugLabel: 'shellNavigatorKeyAdmin');

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
    ShellRoute(
      navigatorKey: _shellNavigatorKeyAdmin,
      routes: [
        GoRoute(
          path: '/admin',
          pageBuilder: (context, state) =>
              FadeTransitionPage(child: const DashboardScreen()),
          redirect: (context, state) {
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
          routes: [
            GoRoute(
              path: '/order',
              pageBuilder: (context, state) =>
                  FadeTransitionPage(child: const AdminOrderScreen()),
            ),
            GoRoute(
              path: '/product',
              pageBuilder: (context, state) =>
                  FadeTransitionPage(child: const AdminProductScreen()),
            ),
            GoRoute(
              path: '/product-detail',
              pageBuilder: (context, state) {
                var isEdit =
                    (state.uri.queryParameters['isEdit'] ?? '') == 'true'
                        ? true
                        : false;
                return FadeTransitionPage(
                  child: AdminProductDetail(
                    isEdit: isEdit,
                    pId: tryParseInt(state.uri.queryParameters['pId']) ?? 0,
                  ),
                );
              },
            ),
            GoRoute(
              path: '/user',
              pageBuilder: (context, state) =>
                  FadeTransitionPage(child: const AdminUser()),
            ),
            GoRoute(
              path: '/category',
              pageBuilder: (context, state) =>
                  FadeTransitionPage(child: const EditingCategoryScreen()),
            ),
            GoRoute(
              path: '/slideshow',
              pageBuilder: (context, state) =>
                  FadeTransitionPage(child: const SlideScreen()),
            ),
          ],
        ),
      ],
      pageBuilder: (context, state, child) {
        return FadeTransitionPage(child: MainLayoutAdmin(screen: child));
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return FadeTransitionPage(child: MainLayout(screen: child));
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
          path: '/about-us',
          pageBuilder: (context, state) => FadeTransitionPage(
            child: const AboutUs(),
          ),
        ),
        GoRoute(
          path: '/contact-us',
          pageBuilder: (context, state) => FadeTransitionPage(
            child: const ContactUsScreen(),
          ),
        ),
        GoRoute(
          path: '/my-order',
          pageBuilder: (context, state) => FadeTransitionPage(
            child: const OrderScreen(),
          ),
        ),
        GoRoute(
          path: '/my-favorite',
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
