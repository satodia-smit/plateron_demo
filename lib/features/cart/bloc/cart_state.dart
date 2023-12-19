import '../../home/models/product_data_model.dart';

abstract class CartState {}

abstract class CartActionState extends CartState {}

class CartInitial extends CartState {}

class CartSuccessState extends CartState {
  final List<ProductDataModel> cartItems;
  CartSuccessState({required this.cartItems});
}

class CartErrorState extends CartState {
  final String errorMessage;

  CartErrorState({required this.errorMessage});
}
class CartLoadingState extends CartState {}
