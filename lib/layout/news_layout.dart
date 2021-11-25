
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:news_app/main.dart';
import 'package:news_app/modules/search_screen/search_screen.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/components/constance.dart';
import 'package:news_app/shared/cubit/news_cubit/cubit.dart';
import 'package:news_app/shared/cubit/news_cubit/states.dart';
import 'package:news_app/shared/cubit/app_cubit/cubit.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:overlay_support/overlay_support.dart';
class NewsApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

      return BlocConsumer<NewsCubit,NewsStates>(
          listener: (context,state){
            if(state is NewsOffConnectionState) {

              Future.delayed(Duration(seconds: 5),(){
                NewsCubit.get(context).internetChecker();
              });
            if(state is NewsOffConnectionState) {
              showSimpleNotification(
                Text('You have no internet'),
                autoDismiss: true,
                duration: Duration(seconds: 5),
                background: Colors.red,
              );
            }
          }
            else if(state is NewsOnConnectionState) {
             NewsCubit.get(context).getNews();
          }
        },
          builder:(context,state) {
            NewsCubit cubit = NewsCubit.get(context);
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'News App',
                  ),
                  actions: [
                    IconButton(icon: Icon(Icons.search), onPressed: () {
                      isDark = CacheHelper.getData(key: 'isDark');
                      navigateTo( context, SearchScreen());
                    },),
                    IconButton(icon: Icon(Icons.brightness_6_outlined), onPressed: () {
                      AppCubit.get(context).changeMode();
                    },)
                  ],
                ),

                body:

                RefreshIndicator(child: cubit.screens[cubit.currentIndex],onRefresh: (){
                  return NewsCubit.get(context).checkAndGetNews();
                  },)
                  ,
                bottomNavigationBar: BottomNavigationBar(
                  items: cubit.bottomNavBarItem,
                  currentIndex: cubit.currentIndex,
                  onTap: (index){

                    cubit.changeNavBar(index);
                  },

                ),



            );
          }
      );
    }


  }

