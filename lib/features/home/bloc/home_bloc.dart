import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/grocery_data.dart';
import '../../../utils/database_helper.dart';
import '../models/product_data_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();


  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvnt>(homeInitialEvnt);
    on<HomeBtnClickedEvnt>(cartBtnClickedEvnt);
    on<CartNavEvnt>(cartNavEvnt);
  }

  FutureOr<void> homeInitialEvnt(
      HomeInitialEvnt event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await Future.delayed(const Duration(seconds: 0));

    final List<ProductDataModel> products = [];

    for (var e in GroceryData.groceryProducts) {
      final ProductDataModel product = ProductDataModel(
        id: e['id'],
        name: e['name'],
        description: e['description'],
        price: e['price'],
        imageUrl: e['imageUrl'],
      );

      // Fetch the current count of the product from the database
      final ProductDataModel? currentProduct =
          await _databaseHelper.getCartItem(product.id);

      if (currentProduct != null) {
        // Product is in the database, set the count variable
        product.count = currentProduct.count ?? 0;
      } else {
        // Product is not in the database, set count to 0
        product.count = 0;
      }

      products.add(product);
    }

    emit(HomeLoadedSuccessState(products: products));
  }

  FutureOr<void> cartBtnClickedEvnt(
      HomeBtnClickedEvnt event, Emitter<HomeState> emit) async {
    final product = event.clickedProduct;

    // Fetch the current count of the product from the database
    final ProductDataModel? currentProduct =
        await _databaseHelper.getCartItem(product.id);

    if (currentProduct != null) {
      // Product is in the database
      if (event.cartAction == CartAction.cartAdd) {
        // Increase the count variable of the product in the database
        product.count = (currentProduct.count ?? 0) + 1;
      } else if (event.cartAction == CartAction.cartRemove) {
        // Reduce the count variable of the product in the database
        product.count = (currentProduct.count ?? 0) - 1;

        // If count becomes zero or negative, remove the product from the database
        if (product.count <= 0) {
          await _databaseHelper.deleteProduct(int.parse(product.id));
        }
      }
      // Update the product in the database
      await _databaseHelper.updateProduct(product);
    } else {
      // Product is not in the database
      if (event.cartAction == CartAction.cartAdd) {
        // Add the product to the database with count 1
        product.count = 1;
        await _databaseHelper.insertProduct(product);
      } else {
        // Do nothing if the product is not in the database and the event is for remove
      }
    }

    // Fetch the current state's product list
    if (state is HomeLoadedSuccessState) {
      final currentState = state as HomeLoadedSuccessState;

      // Update the count variable of the product in the current state's product list
      final updatedProducts = currentState.products.map((p) {
        if (p.id == product.id) {
          p.count = product.count;
        }
        return p;
      }).toList();
      emit(HomeLoadedSuccessState(products: updatedProducts));
    } else {
      if (kDebugMode) {
        print("state is ${state.runtimeType}");
      }
    }
  }

  FutureOr<void> cartNavEvnt(CartNavEvnt event, Emitter<HomeState> emit) {
    emit(HomeNavigationToCartPageActionState());
  }
}
