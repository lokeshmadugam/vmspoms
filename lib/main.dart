import 'dart:io';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../viewmodel/clockinclockout/AttendanceListingsScreenViewModel.dart';
import '../../viewmodel/clockinclockout/ClockInClockOutScreenViewModel.dart';
import '../../viewmodel/greylist/GreyListFormScreenViewModel.dart';
import '../../viewmodel/greylist/GreyListingsScreenViewModel.dart';
import '../../viewmodel/lostfound/EditLostDetailsFormScreenViewModel.dart';
import '../../viewmodel/lostfound/LostDetailsFormScreenViewModel.dart';
import '../../viewmodel/lostfound/LostItemsScreenViewModel.dart';
import '../../viewmodel/lostfound/UnclaimedItemsScreenViewModel.dart';
import '../../viewmodel/packages/PackageExpectedFormScreenViewModel.dart';
import '../../viewmodel/packages/PackageExpectedScreenViewModel.dart';
import '../../viewmodel/packages/PackageReceivedFormScreenViewModel.dart';
import '../../viewmodel/packages/PackageReceivedScreenViewModel.dart';
import '../../viewmodel/securityrounds/SecurityChecksScreenViewModel.dart';
import '../../viewmodel/securityrounds/SecurityViewDetailsScreenViewModel.dart';
import 'package:provider/provider.dart';
import '../utils/routes/routes.dart';
import '../utils/routes/routes_name.dart';

import '../viewmodel/LoginViewModel.dart';
import '../viewmodel/UserViewModel.dart';



TextStyle getAndroidBodyTextStyle1() {
  return GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}
TextStyle getSmallAndroidBodyTextStyle1() {
  return GoogleFonts.roboto(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}
TextStyle getAndroidBodyTextStyle2() {
  return GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
TextStyle getSmallAndroidBodyTextStyle2() {
  return GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
TextStyle getAndroidBodyTextStyle3() {
  return GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
TextStyle getSmallAndroidBodyTextStyle3() {
  return GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
TextStyle getiOSBodyTextStyle1() {
  return GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black
  );
}
TextStyle getSmalliOSBodyTextStyle1() {
  return GoogleFonts.roboto(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: Colors.black
  );
}

TextStyle getiOSBodyTextStyle2() {
  return GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}
TextStyle getSmalliOSBodyTextStyle2() {
  return GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );
}

TextStyle getiOSBodyTextStyle3() {
  return GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
TextStyle getSmalliOSBodyTextStyle3() {
  return GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
TextStyle getTabsiOSBodyTextStyle3() {
  return GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
class DeviceUtil {
  static String get _getDeviceType {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? 'phone' : 'tablet';
  }

  static bool get isTablet {
    return _getDeviceType == 'tablet';
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(DeviceUtil.isTablet){
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,

      // DeviceOrientation.landscapeRight// Allow portrait orientation when device is upright
      // Allow landscape orientation with device rotated to the right
    ]).then((value) {
      WidgetsFlutterBinding.ensureInitialized();

      runApp( const MyApp());
    });
  }else {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // Allow portrait orientation when device is upright
      // Allow landscape orientation with device rotated to the right
    ]).then((value) {
      WidgetsFlutterBinding.ensureInitialized();

      runApp(const MyApp());
    });
  }
}
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    TextTheme textTheme;
    if (Theme.of(context).platform == TargetPlatform.android) {
      // For Android platform
      if(width < 411 || height < 707) {
        textTheme = GoogleFonts.robotoTextTheme(Theme
            .of(context)
            .textTheme).copyWith(

          bodySmall: getSmallAndroidBodyTextStyle1(),
          headlineMedium: getSmallAndroidBodyTextStyle2(),
          headlineLarge: getSmallAndroidBodyTextStyle3(),
        );
      } else{
        textTheme = GoogleFonts.robotoTextTheme(Theme
            .of(context)
            .textTheme).copyWith(
        bodySmall: getAndroidBodyTextStyle1(),
    headlineMedium: getAndroidBodyTextStyle2(),
    headlineLarge: getAndroidBodyTextStyle3(),
        );
      }
    } else {
      // For iOS and other platforms
      if(width < 411 || height < 707) {
        textTheme = GoogleFonts.robotoTextTheme(Theme
            .of(context)
            .textTheme).copyWith(
          bodySmall: getSmalliOSBodyTextStyle1(),
          headlineMedium: getSmalliOSBodyTextStyle2(),
          headlineLarge: getSmalliOSBodyTextStyle3(),
        );
      }else {
        textTheme = GoogleFonts.robotoTextTheme(Theme
            .of(context)
            .textTheme).copyWith(
          bodySmall: getiOSBodyTextStyle1(),
          headlineMedium: getiOSBodyTextStyle2(),
          headlineLarge: getiOSBodyTextStyle3(),
        );
      }
    }


     textTheme = textTheme;


      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => UserViewModel()),
          ChangeNotifierProvider(
              create: (_) => PackageExpectedFormScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => PackageReceivedFormScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => PackageReceivedScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => PackageExpectedScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => SecurityChecksScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => SecurityViewDetailsScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => EditLostDetailsFormScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => LostDetailsFormScreenViewModel()),
          ChangeNotifierProvider(create: (_) => LostItemsScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => UnclaimedItemsScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => AttendanceListingsScreenViewModel()),
          ChangeNotifierProvider(
              create: (_) => ClockInClockOutScreenViewModel()),
          ChangeNotifierProvider(create: (_) => GreyListFormScreenViewModel()),
          ChangeNotifierProvider(create: (_) => GreyListingsScreenViewModel()),
        ],

        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: MaterialColor(
              0xFF036CB2,
              <int, Color>{
                50: Color(0xFF036CB2),
                100: Color(0xFF036CB2),
                200: Color(0xFF036CB2),
                300: Color(0xFF036CB2),
                400: Color(0xFF036CB2),
                500: Color(0xFF036CB2),
                600: Color(0xFF036CB2),
                700: Color(0xFF036CB2),
                800: Color(0xFF036CB2),
                900: Color(0xFF036CB2),
              },
            ),
            textTheme: textTheme,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,

        ),
      );

  }
}

