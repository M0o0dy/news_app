
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/components/constance.dart';
import 'package:news_app/shared/cubit/news_cubit/cubit.dart';
import 'package:news_app/shared/cubit/news_cubit/states.dart';
import 'package:news_app/shared/styles/colors.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  var searchController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context,state){},
      builder:(context,state){
        var list = NewsCubit.get(context).search;
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key : formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultFormField(
                      label: 'Search',
                      controller: searchController,
                      keyboard: TextInputType.text,
                      prefixIcon: Icons.search,
                      validate: (String? value){
                        setState(() {

                        });
                        if(value!.isEmpty) {
                          NewsCubit.get(context).getSearch(value);
                          return 'Type to search';
                        }return null;
                      },
                      onChanged: (String value){
                        setState(() {

                        if(formKey.currentState!.validate()){
                          NewsCubit.get(context).getSearch(value);
                        }return null;
                        });
                      },

                    outLineColor: Colors.grey,

                  ),
                ),
                SizedBox(height: 10,),
                if(state is NewsSearchLoadingState)
                  LinearProgressIndicator(
                    color: isDark! ? darkColor: defaultColor,
                    backgroundColor: Colors.blue[100],
                  ),
                if(state is NewsGetSearchSuccessState)
                Expanded(child: articleBuilder(list,context,isSearch: true, ))
              ],
            ),
          ),
        );

      },
    );
  }
}
