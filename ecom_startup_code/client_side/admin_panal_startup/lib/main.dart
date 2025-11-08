import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'core/data/data_provider.dart';
import 'core/routes/app_pages.dart';
import 'screens/brands/provider/brand_provider.dart';
import 'screens/category/provider/category_provider.dart';
import 'screens/coupon_code/provider/coupon_code_provider.dart';
import 'screens/dashboard/provider/dash_board_provider.dart';
import 'screens/main/main_screen.dart';
import 'screens/main/provider/main_screen_provider.dart';
import 'screens/notification/provider/notification_provider.dart';
import 'screens/order/provider/order_provider.dart';
import 'screens/posters/provider/poster_provider.dart';
import 'screens/sub_category/provider/sub_category_provider.dart';
import 'screens/variants/provider/variant_provider.dart';
import 'screens/variants_type/provider/variant_type_provider.dart';
import 'utility/constants.dart';
import 'utility/extensions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => DataProvider()),
    ChangeNotifierProvider(create: (context) => MainScreenProvider()),
    ChangeNotifierProvider(create: (context) => CategoryProvider(context.dataProvider)),
    ChangeNotifierProvider(create: (context) => SubCategoryProvider(context.dataProvider)),
    ChangeNotifierProvider(create: (context) => BrandProvider(context.dataProvider)),
    ChangeNotifierProvider(create: (context) => VariantsTypeProvider(context.dataProvider)),
    ChangeNotifierProvider(create: (context) => VariantsProvider(context.dataProvider)),
    ChangeNotifierProvider(create: (context) => DashBoardProvider(context.dataProvider)),
    ChangeNotifierProvider(create: (context) => CouponCodeProvider(context.dataProvider)),
    ChangeNotifierProvider(create: (context) => PosterProvider(context.dataProvider)),
    ChangeNotifierProvider(create: (context) => OrderProvider(context.dataProvider)),
    ChangeNotifierProvider(create: (context) => NotificationProvider(context.dataProvider)),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NexBuy',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: bgColor,
        primaryColor: primaryColor,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
        iconTheme: const IconThemeData(color: textColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: textColor),
          titleTextStyle: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            elevation: 2,
          ),
        ),
        colorScheme: const ColorScheme.light().copyWith(
          primary: primaryColor,
          surface: Colors.white,
          onSurface: textColor,
        ),
      ),


      initialRoute: AppPages.HOME,
      unknownRoute: GetPage(name: '/notFount', page: () => MainScreen()),
      defaultTransition: Transition.cupertino,
      getPages: AppPages.routes,
    );
  }
}
