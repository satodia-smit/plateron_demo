import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../utils/database_helper.dart';
import '../../home/models/product_data_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  CartBloc() : super(CartInitial()) {
    on<CartInitialEvent>(cartInitialEvent);
    on<CartBtnClickedEvnt>(cartBtnClickedEvnt);
  }

  FutureOr<void> cartInitialEvent(CartInitialEvent event,
      Emitter<CartState> emit) async {
    try {
      // Load cart items from the database
      final List<ProductDataModel> cartItems = await _databaseHelper
          .getCartItems();

      // Emit CartSuccessState with the loaded items
      emit(CartSuccessState(cartItems: cartItems));
    } catch (error) {
      // Emit CartErrorState in case of an error
      emit(CartErrorState(errorMessage: "Failed to load cart items."));
    }
  }
  FutureOr<void> cartBtnClickedEvnt(
      CartBtnClickedEvnt event, Emitter<CartState> emit) async {

    final product = event.clickedProduct;
    final currentProduct = await _databaseHelper.getCartItem(product.id);
    final currentState = state as CartSuccessState;

    if (currentProduct != null) {
      // Product is in the database
      if (event.cartAction == CartAction.cartAdd) {
        product.count = (currentProduct.count ?? 0) + 1;
      } else if (event.cartAction == CartAction.cartRemove) {
        product.count = (currentProduct.count ?? 0) - 1;
        if (product.count <= 0) {
          await _handleZeroCountProduct(product, currentState, emit);
          return;
        }
      }
      await _databaseHelper.updateProduct(product);
    } else {
      // Product is not in the database
      if (event.cartAction == CartAction.cartAdd) {
        product.count = 1;
        await _databaseHelper.insertProduct(product);
      }
    }

    // Update the count variable of the product in the current state's product list
    final updatedProducts = currentState.cartItems.map((p) {
      if (p.id == product.id) {
        p.count = product.count;
      }
      return p;
    }).toList();
    emit(CartSuccessState(cartItems: updatedProducts));
  }

  Future<void> _handleZeroCountProduct(
      ProductDataModel product, CartSuccessState currentState, Emitter<CartState> emit) async {

    await _databaseHelper.deleteProduct(int.parse(product.id));

    // Update the UI list by excluding the product with count zero
    final updatedProducts = currentState.cartItems
        .where((p) => p.id != product.id)
        .toList();

    emit(CartSuccessState(cartItems: updatedProducts));
  }


}
