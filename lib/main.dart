import 'package:flutter/material.dart';
import '../ui/cart/cart_screen.dart';
import 'ui/products/product_detail_screen.dart';
import 'ui/products/products_manager.dart';
import 'ui/products/products_overview_screen.dart';
import '../ui/products/user_products_screen.dart';
import '../ui/orders/orders_screen.dart';
import 'ui/screens.dart';
import 'package:provider/provider.dart';
import '../ui/products/edit_product_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home.dart';
// void main() {
//   runApp(const MyApp());
// }
Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.lightBlueAccent,
      secondary: Colors.redAccent,
      background: Colors.lightGreen[100],
      surfaceTint: Colors.grey[200],
    );
    final themeData = ThemeData(
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 20,
        ),
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, previousProducts) {
            previousProducts!.authToken = authManager.authToken;
            return previousProducts;
          },
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartManager(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersManager(),
        ),
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authManager, child){
          return MaterialApp(
              title: 'Grop',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme: colorScheme,
                appBarTheme: AppBarTheme(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 4,
                  shadowColor: colorScheme.shadow,
                ),
              ),
              // home: Scaffold(
              //   appBar: AppBar(
              //     title: const Text('MyShop'),
              //   ),
              //   body: const Center(
              //     child: Text('Welcome to MyShop'),
              //   ),
              //),
              //
              // home: const SafeArea(
              //   child: ProductsOverviewScreen(),
              // ),
              //home: const SafeArea(
              //child: UserProductsScreen(),
              //home: const SafeArea(
              //child: CartScreen(),
              // home: const SafeArea(
              // child: OrdersScreen(),
              routes: {
                CartScreen.routeName: (ctx) => const SafeArea(
                  child: CartScreen(),
                ),
                OrdersScreen.routeName: (ctx) => const SafeArea(
                  child: OrdersScreen(),
                ),
                UserProductsScreen.routeName: (ctx) =>  const SafeArea(
                  child: UserProductsScreen(),
                ),
              },
              home: authManager.isAuth



                  ? const SafeArea(child: Home()) // Hiển thị Home nếu người dùng đã đăng nhập
                  : FutureBuilder(
                future: authManager.tryAutoLogin(),
                builder: (ctx, snapshot){
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const SafeArea(child: SplashScreen())
                      : const SafeArea(child: AuthScreen());
                },
              ),
              onGenerateRoute: (settings) {
                if (settings.name == ProductDetailScreen.routeName) {
                  final productId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return SafeArea(
                        child: ProductDetailScreen(
                          ctx.read<ProductsManager>().findById(productId)!,
                        ),
                      );
                    },
                  );
                }
                if (settings.name == EditProductScreen.routeName) {
                  final productId = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return SafeArea(
                        child: EditProductScreen(
                          productId != null
                              ? ctx.read<ProductsManager>().findById(productId)
                              : null,
                        ),
                      );
                    },
                  );
                };
                return null;
              }
          );
        },
      ),
    );
  }
}
