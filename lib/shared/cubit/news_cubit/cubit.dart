import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/business_screen/business_screen.dart';
import 'package:news_app/modules/science_screen/science_screen.dart';
import 'package:news_app/modules/sports_screen/sports_screen.dart';
import 'package:news_app/shared/cubit/news_cubit/states.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';
import 'package:overlay_support/overlay_support.dart';

class NewsCubit extends Cubit<NewsStates>{

  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context)=> BlocProvider.of(context);



  Future<void>  internetChecker() async {
    ConnectivityResult result;
     result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){emit(NewsOffConnectionState());}else emit(NewsOnConnectionState());
  }


  int currentIndex = 0;

  List<BottomNavigationBarItem>bottomNavBarItem=[
    BottomNavigationBarItem(icon: Icon(Icons.business_center_outlined),label: 'Business',),
    BottomNavigationBarItem(icon: Icon(Icons.sports_outlined),label: 'Sports'),
    BottomNavigationBarItem(icon: Icon(Icons.science_outlined),label: 'Science'),

  ];
  List<Widget>screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),

  ];
  void changeNavBar(index){
    currentIndex = index;
    emit(NewsChangeNavBarState());
  }
  List <dynamic> business=[];
  List <dynamic> sports=[];
  List <dynamic> science=[];

  Future<void> getNews()async{
    await getBusinessData();
    await getSportsData();
    await getScienceData();
  }
  Future<void> checkAndGetNews()async{
    await internetChecker();
    await getBusinessData();
    await getSportsData();
    await getScienceData();
  }


  Future<void> getBusinessData() async {

    emit(NewsBusinessLoadingState());
    Future.delayed(const Duration(milliseconds: 500), () =>DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'business',
      'apiKey': '657ad78789e64a89a631adb5d3708937',
    }).then((value) {
      business = value.data['articles'];
      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    }));
  }

  Future<void> getSportsData() async{

    emit(NewsSportsLoadingState());
    Future.delayed(const Duration(milliseconds: 500), () =>DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'sports',
      'apiKey': '657ad78789e64a89a631adb5d3708937',
    }).then((value) {
      sports = value.data['articles'];
      emit(NewsGetSportsSuccessState());
    }).catchError((error){
      print('Error is ${error.toString()}');
      emit(NewsGetSportsErrorState(error.toString()));
    }));
  }

  Future<void> getScienceData() async{

    emit(NewsScienceLoadingState());
    Future.delayed(const Duration(milliseconds: 500), () =>DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'science',
      'apiKey': '657ad78789e64a89a631adb5d3708937',
    }).then((value) {

      science = value.data['articles'];
      emit(NewsGetScienceSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetScienceErrorState(error.toString()));

    }));
  }
  List <dynamic> search=[];

  void getSearch(String value) {
    internetChecker();
    String searchWord = value;

    search=[];
    emit(NewsSearchLoadingState());
    Future.delayed(const Duration(milliseconds: 500), () =>DioHelper.getData(url: 'v2/everything', query: {
      'q': '$searchWord',
      'apiKey': '657ad78789e64a89a631adb5d3708937',
    }).then((value) {
      searchWord.isEmpty ? search = [] : search = value.data['articles'];
      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    }));}
}