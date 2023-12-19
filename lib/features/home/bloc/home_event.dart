
import '../models/product_data_model.dart';

abstract class HomeEvent {}
class HomeInitialEvnt extends HomeEvent {}

class HomeBtnClickedEvnt extends HomeEvent {
  final ProductDataModel clickedProduct;
  final CartAction cartAction;

  HomeBtnClickedEvnt({required this.clickedProduct, required this.cartAction});
}

enum CartAction {
  cartAdd,
  cartRemove,
}
class CartNavEvnt extends HomeEvent {}
