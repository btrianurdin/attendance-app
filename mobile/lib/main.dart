import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:presensi_pintar_ta/services/locator/navigation_service.dart';
import 'package:presensi_pintar_ta/utils/theme.dart';
import 'package:presensi_pintar_ta/views/pages/add_annual_leaves_page.dart';
import 'package:presensi_pintar_ta/views/pages/add_leaves_page.dart';
import 'package:presensi_pintar_ta/views/pages/annual_leaves_page.dart';
import 'package:presensi_pintar_ta/views/pages/change_password_page.dart';
import 'package:presensi_pintar_ta/views/pages/employee_info_page.dart';
import 'package:presensi_pintar_ta/views/pages/layout_page.dart';
import 'package:presensi_pintar_ta/views/pages/leaves_page.dart';
import 'package:presensi_pintar_ta/views/pages/personal_info_page.dart';
import 'package:presensi_pintar_ta/views/pages/presence_page.dart';
import 'package:presensi_pintar_ta/views/pages/splash_screen.dart';
import 'provider/store_provider.dart';
import 'services/locator/locator.dart';
import 'views/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('id');

  serviceInit();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserStore())],
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: 1.0, alwaysUse24HourFormat: true),
            child: child!,
          );
        },
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: Brightness.dark,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          scaffoldBackgroundColor: backgroundColor,
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          ),
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: primaryColor,
                background: backgroundColor,
              ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Presensi TA',
        initialRoute: '/',
        navigatorKey: locator<NavigationService>().navigatorKey,
        routes: {
          '/layout': (context) => const LayoutPage(),
          '/leaves': (context) => const LeavesPage(),
          '/annualLeaves': (context) => const AnnualLeavesPage(),
          '/addLeaves': (context) => const AddLeavesPage(),
          '/addAnnualLeaves': (context) => const AddAnnualLeavePage(),
          '/login': (context) => const LoginPage(),
          '/presence': (context) => PresencePage(
                arguments: ModalRoute.of(context)?.settings.arguments,
              ),
          '/': (context) => const SplashScreen(),
          '/personal-info': (context) => const PersonalInfoPage(),
          '/employee-info': (context) => const EmployeeInfoPage(),
          '/change-password': (context) => const ChangePasswordPage()
        },
      ),
    );
  }
}
