abstract class NewsStates {}

class NewsInitialState extends NewsStates{}

class NewsOnConnectionState extends NewsStates{}

class NewsOffConnectionState extends NewsStates{}

class NewsChangeNavBarState extends NewsStates{}

class NewsGetBusinessSuccessState extends NewsStates{}

class NewsGetBusinessErrorState extends NewsStates{
  final error;

  NewsGetBusinessErrorState(this.error);
}

class NewsBusinessLoadingState extends NewsStates{}

class NewsGetSportsSuccessState extends NewsStates{}

class NewsGetSportsErrorState extends NewsStates{
  final error;

  NewsGetSportsErrorState(this.error);
}

class NewsSportsLoadingState extends NewsStates{}

class NewsGetScienceSuccessState extends NewsStates{}

class NewsGetScienceErrorState extends NewsStates{
  final error;

  NewsGetScienceErrorState(this.error);
}

class NewsScienceLoadingState extends NewsStates{}

class NewsGetSearchSuccessState extends NewsStates{}

class NewsGetSearchErrorState extends NewsStates{
  final error;

  NewsGetSearchErrorState(this.error);
}

class NewsSearchLoadingState extends NewsStates{}

