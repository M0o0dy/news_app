
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_layout.dart';
import 'package:news_app/shared/bloc_observer.dart';
import 'package:news_app/shared/components/constance.dart';
import 'package:news_app/shared/cubit/news_cubit/cubit.dart';
import 'package:news_app/shared/cubit/app_cubit/cubit.dart';
import 'package:news_app/shared/cubit/app_cubit/states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';
import 'package:news_app/shared/styles/themes.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await DioHelper.init();
  await CacheHelper.init();
  isDark = CacheHelper.getData(key: 'isDark');
  runApp(MyApp(
    isDark: isDark,
  ));
}
class MyApp extends StatelessWidget
{


  bool? isDark;
  MyApp({this.isDark,});


  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context)=> NewsCubit()..internetChecker()..getBusinessData()..getSportsData()..getScienceData()),
        BlocProvider(
          create: (BuildContext context)=> AppCubit()..changeMode( fromCache: isDark),),

      ],

      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context,state){},
          builder: (context,state) {

            return OverlaySupport(
              child: MaterialApp(
                theme:lightTheme,
                darkTheme:  darkTheme,
                themeMode:
                AppCubit
                    .get(context)
                    .isDark ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: NewsApp(),
              ),
            );
          }
      ),

    );
  }

}
