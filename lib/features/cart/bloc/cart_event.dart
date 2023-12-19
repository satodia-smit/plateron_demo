import '../../home/models/product_data_model.dart';
abstract class CartEvent {}

class CartInitialEvent extends CartEvent {}
class CartBtnClickedEvnt extends CartEvent {
  final ProductDataModel clickedProduct;
  final CartAction cartAction;

  CartBtnClickedEvnt({required this.clickedProduct, required this.cartAction});

}
enum CartAction {
  cartAdd,
  cartRemove,
}
