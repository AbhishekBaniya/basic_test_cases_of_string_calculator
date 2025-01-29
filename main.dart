import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendmoney/core/utils/app_logger.dart';
import 'package:sendmoney/features/presentation/pages/portfolio_screen.dart';

import 'config/res/strings.dart';
import 'core/utils/bool_manager.dart';
import 'core/utils/constants.dart';
import 'features/data/data_source/local_data_source/hive_manager.dart';
import 'features/presentation/app_routes/app_navigation_tracer.dart';
import 'features/presentation/app_routes/app_pages.dart';
import 'features/presentation/app_routes/app_routes.dart';
import 'features/presentation/bindings/app_binding.dart';
import 'features/presentation/pages/authentication/app_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  // Get.put(PortfolioRemoteDataSourceImpl(DioClient(),),);
  // Get.put(PortfolioRepositoryImpl(Get.find(),),);
  // Get.put(GetPortfolio(Get.find(),),);
  AppBindings().dependencies();
  BoolManager().setBool(Consts.debugBanner, false);
  //
  // Initialize Hive and the box
  await HiveManager().initHive();


  final calculator = StringCalculator();
  print(calculator.add("")); // 0
  print(calculator.add("1")); // 1
  print(calculator.add("1,2")); // 3
  print(calculator.add("1\n2,3")); // 6
  print(calculator.add("//;\n1;2")); // 3
  print(calculator.add("//[***]\n1***2***3")); // 6
  print(calculator.add("//[*][%]\n1*2%8")); // 6

  runApp(const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context,) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: BoolManager().getBool(Consts.debugBanner),
      initialBinding: AppBindings(),
      //darkTheme: AppTheme.dark,
      //theme: AppTheme.light,
      themeMode: ThemeMode.light,
      enableLog: true,
      useInheritedMediaQuery: true,
      smartManagement: SmartManagement.onlyBuilder,
      showPerformanceOverlay: false,
      textDirection: TextDirection.ltr,
      //defaultGlobalState: true,
      transitionDuration: Duration.zero,
      //popGesture: true,
      opaqueRoute: false,
      getPages: AppPages.pages,
      navigatorObservers: [NavigationTracer()],
      // Set the observer here
      title: Strings.appName,
      initialRoute: AppRoutes.login,
      home:  AppAuthScreen(),
    );
  }
}

class StringCalculator {
  int add(String numbers) {
    if (numbers.isEmpty) return 0;

    String delimiter = ',';
    if (numbers.startsWith('//')) {
      final delimiterEndIndex = numbers.indexOf('\n');
      final delimiterPart = numbers.substring(2, delimiterEndIndex);
      numbers = numbers.substring(delimiterEndIndex + 1);

      final delimiterRegex = RegExp(r'\[(.*?)\]');
      final matches = delimiterRegex.allMatches(delimiterPart);
      if (matches.isNotEmpty) {
        delimiter = matches.map((m) => RegExp.escape(m.group(1)!)).join('|');
      } else {
        delimiter = RegExp.escape(delimiterPart);
      }
    }

    final pattern = RegExp('($delimiter|\n)');
    final numList = numbers.split(pattern).where((s) => s.isNotEmpty).map(int.parse);

    final negatives = numList.where((n) => n < 0).toList();
    if (negatives.isNotEmpty) {
      throw Exception('Negatives not allowed: ${negatives.join(', ')}');
    }

    return numList.where((n) => n <= 1000).reduce((a, b) => a + b);
  }
}
//In this portfolio project, I showcase my skills and expertise as a mobile developer through a collection of my most impressive and relevant projects. project includes a brief overview, my role and responsibilities, the tools and technologies used and any challenges and solutions I encountered.