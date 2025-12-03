import 'package:bamtol_market_app/src/app.dart';
import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:bamtol_market_app/src/common/controller/bottom_nav_controller.dart';
import 'package:bamtol_market_app/src/common/controller/common_layout_controller.dart';
import 'package:bamtol_market_app/src/common/controller/data_load_controller.dart';
import 'package:bamtol_market_app/src/common/repository/cloud_firebase_storage_repository.dart';
import 'package:bamtol_market_app/src/home/controller/home_controller.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:bamtol_market_app/src/product/write/controller/product_write_controller.dart';
import 'package:bamtol_market_app/src/product/write/page/product_write_page.dart';
import 'package:bamtol_market_app/src/root.dart';
import 'package:bamtol_market_app/src/splash/controller/splash_controller.dart';
import 'package:bamtol_market_app/src/user/login/controller/login_controller.dart';
import 'package:bamtol_market_app/src/user/login/page/login_page.dart';
import 'package:bamtol_market_app/src/user/repository/authentication_repository.dart';
import 'package:bamtol_market_app/src/user/repository/user_repository.dart';
import 'package:bamtol_market_app/src/user/signup/controller/signup_controller.dart';
import 'package:bamtol_market_app/src/user/signup/page/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  // Firebase.initializeApp 제거됨

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance 제거됨

    return GetMaterialApp(
      title: '당근마켓 클론코딩',
      initialRoute: '/',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xff212123),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xff212123),
      ),
      initialBinding: BindingsBuilder(() {
        // Mock Repository 주입 (인자 없음)
        var authenticationRepository = AuthenticationRepository();
        var userRepository = UserRepository();

        Get.put(authenticationRepository);
        Get.put(userRepository);
        Get.put(CommonLayoutController());
        Get.put(ProductRepository());
        Get.put(BottomNavController());
        Get.put(SplashController());
        Get.put(DataLoadController());
        // Auth Controller 주입
        Get.put(AuthenticationController(
          authenticationRepository,
          userRepository,
        ));
        Get.put(CloudFirebaseRepository());
      }),
      getPages: [
        GetPage(name: '/', page: () => const App()),
        GetPage(
            name: '/home',
            page: () => const Root(),
            binding: BindingsBuilder(() {
              Get.put(HomeController(Get.find<ProductRepository>()));
            })),
        GetPage(
            name: '/login',
            page: () => const LoginPage(),
            binding: BindingsBuilder(() {
              Get.lazyPut<LoginController>(
                  () => LoginController(Get.find<AuthenticationRepository>()));
            })),
        GetPage(
          name: '/signup/:uid',
          page: () => const SignupPage(),
          binding: BindingsBuilder(
            () {
              // [중요 수정] Get.create -> Get.put으로 변경!
              // 그래야 입력한 텍스트값과 버튼이 누르는 컨트롤러가 동일해집니다.
              Get.put<SignupController>(
                SignupController(Get.find<UserRepository>(),
                    Get.parameters['uid'] as String),
              );
            },
          ),
        ),
        GetPage(
          name: '/product/write',
          page: () => ProductWritePage(),
          binding: BindingsBuilder(
            () {
              Get.put(ProductWriteController(
                Get.find<AuthenticationController>().userModel.value!,
                Get.find<ProductRepository>(),
                Get.find<CloudFirebaseRepository>(),
              ));
            },
          ),
        ),
      ],
    );
  }
}