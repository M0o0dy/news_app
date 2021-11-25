


import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/modules/web_view_screen/web_view_screen.dart';
import 'package:news_app/shared/components/constance.dart';
import 'package:news_app/shared/cubit/news_cubit/cubit.dart';


void showToast({required String msg, required state})=>Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);
enum ToastStates{SUCCESS,WARNING,ERROR}
Color chooseColor (ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS : color = Colors.green;break;
    case ToastStates.WARNING : color = Colors.amber;break;
    case ToastStates.ERROR : color = Colors.red;break;
  }return color;
}



Widget defaultButton ({required String label, required Function onPressed,Color? color})=>Container(
width: double.infinity,
decoration: BoxDecoration(
  color: color?? Colors.blue,
  borderRadius: BorderRadius.circular(20),
),
child: MaterialButton(
onPressed:(){
  onPressed();
},
child: Text(
  label,
style: TextStyle(
fontSize: 20,
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
),
);




Widget defaultFormField ({
  required TextEditingController controller,
 required String label,
 required IconData prefixIcon,
  String? hintText,
  Color? outLineColor,
  Color? fillColor,
  Color? focusColor,
  Color? hoverColor,
  IconData? suffixIcon,
  VoidCallback? suffixPressed,
  FormFieldValidator<String>? validate,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  GestureTapCallback? onTab,
  required TextInputType keyboard,
  bool isPassword = false,
  bool noInput = false,
}) => TextFormField(

  cursorColor: outLineColor,
  onChanged:onChanged,
  onFieldSubmitted: onSubmitted,
  readOnly:noInput ,
  validator: validate,
  controller: controller,
  decoration: InputDecoration(

    enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: isDark! ? Colors.white : Colors.grey
      )
    ) ,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),),
    labelText: label,
    labelStyle: TextStyle(
      color: isDark!? Colors.white:Colors.grey
    ),
    prefixIcon: Icon(prefixIcon,color: isDark!? Colors.white:Colors.grey,),
    suffixIcon: IconButton(icon: Icon(suffixIcon),onPressed:suffixPressed,),
    hintText: hintText,
  ),
  keyboardType: keyboard,
  obscureText: isPassword ,
  onTap: onTab,
);


Widget buildArticleItem(article,context)=>InkWell(
  child:   Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image:NetworkImage(
                  '${article['urlToImage']}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(width: 20,),
        Expanded(
          flex: 2,
          child: Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${article['title']}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,

                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Text(
                  '${article['publishedAt']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ),
  onTap: (){
    navigateTo(context, WebViewScreen(article['url']));
  },
);

Widget articleBuilder(list,context, {isSearch = false,})=>Conditional.single(
  context: context,
  conditionBuilder:(context) => list.length > 0,
  widgetBuilder: (context) {

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) => buildArticleItem(list[index],context),
      separatorBuilder: (context, index) => myDivider(),
      itemCount: list.length,
    );
  },
  fallbackBuilder: (context) => isSearch? Container() :
  Center(child: CircularProgressIndicator())

);

Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(start: 20,),
  child: Container(
    height: 1, width: double.infinity, color: Colors.grey[300],),
);

void navigateTo(context, widget) => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> widget ));
void navigateAndFinishTo(context, widget) => Navigator.pushReplacement(context , MaterialPageRoute(builder: (BuildContext context)=> widget ),result:(route)=>false);

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}