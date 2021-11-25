import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/cubit/app_cubit/states.dart';

import 'package:news_app/shared/network/local/cache_helper.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;
  void changeMode ({bool? fromCache})
  {
    if(fromCache!=null){
      isDark = fromCache;
      emit(NewsChangeModeState());
    }else{
      isDark = !isDark ;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value){
        emit(NewsChangeModeState());
      });
    }

  }

}