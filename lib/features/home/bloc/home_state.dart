import '../models/product_data_model.dart';

abstract class HomeState {}

class HomeActionState extends HomeState {}
class HomeInitial extends HomeState {}
class HomeLoadingState extends HomeState {}
class HomeLoadedSuccessState extends HomeState {
  final List<ProductDataModel> products;
  HomeLoadedSuccessState({required this.products});
}
class HomeErrorState extends HomeState {}


class HomeNavigationToCartPageActionState extends HomeActionState {}
