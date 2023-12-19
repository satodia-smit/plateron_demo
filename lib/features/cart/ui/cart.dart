import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/commonwidgets/CustomErrorWidget.dart';
import '../../../utils/commonwidgets/NoDataWidget.dart';
import '../../home/models/product_data_model.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import 'cart_tile_widget.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartBloc cartBloc = CartBloc();

  @override
  void initState() {
    cartBloc.add(CartInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        bloc: cartBloc,
        listenWhen: (previous, current) => current is CartActionState,
        buildWhen: (previous, current) => current is! CartActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case CartLoadingState:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case CartSuccessState:
              final successState = state as CartSuccessState;

              return Column(
                children: [
                  Expanded(
                    child: successState.cartItems.isEmpty
                        ? const NoDataWidget()
                        : ListView.builder(
                            itemCount: successState.cartItems.length,
                            itemBuilder: (context, index) {
                              return CartTileWidget(
                                productDataModel: successState.cartItems[index],
                                cartBloc: cartBloc,
                              );
                            },
                          ),
                  ),
                  _buildTotalPriceWidget(successState.cartItems),
                ],
              );
            case CartErrorState:
              return const CustomErrorWidget(errorMessage: 'An error occurred');
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildTotalPriceWidget(List<ProductDataModel> cartItems) {
    if (cartItems.isEmpty) {
      return const SizedBox.shrink(); // or return an empty widget or a message
    }

    final totalPrice = cartItems
        .where((item) => item.price != null && item.count != null)
        .map((item) => item.price! * item.count!)
        .reduce((prev, price) => prev + price);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.amberAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Price:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$$totalPrice',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
