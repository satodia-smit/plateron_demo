import 'package:flutter/material.dart';
import 'package:plateron_demo/features/cart/bloc/cart_event.dart';
import '../../home/models/product_data_model.dart';
import '../bloc/cart_bloc.dart';

class CartTileWidget extends StatelessWidget {
  final ProductDataModel productDataModel;
  final CartBloc cartBloc;

  const CartTileWidget({
    Key? key,
    required this.productDataModel,
    required this.cartBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(productDataModel.imageUrl),
            ),
          ),
        ),
        title: Text(
          productDataModel.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(
              productDataModel.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            Text(
              "\$${productDataModel.price}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                cartBloc.add(CartBtnClickedEvnt(
                  clickedProduct: productDataModel,
                  cartAction: CartAction.cartRemove,
                ));
              },
              icon: const Icon(Icons.remove),
            ),
            Text(
              '${productDataModel.count}',
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              onPressed: () {
                cartBloc.add(CartBtnClickedEvnt(
                  clickedProduct: productDataModel,
                  cartAction: CartAction.cartAdd,
                ));
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
