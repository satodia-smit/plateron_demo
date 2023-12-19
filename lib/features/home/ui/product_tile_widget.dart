import 'package:flutter/material.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../models/product_data_model.dart';

class ProductTileWidget extends StatelessWidget {
  final ProductDataModel productDataModel;
  final HomeBloc homeBloc;

  const ProductTileWidget({
    Key? key,
    required this.productDataModel,
    required this.homeBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isInCart = productDataModel.count != 0;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(productDataModel.imageUrl),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              productDataModel.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(productDataModel.description),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${productDataModel.price}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                isInCart
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              homeBloc.add(HomeBtnClickedEvnt(
                                clickedProduct: productDataModel,
                                cartAction: CartAction.cartRemove,
                              ));
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${productDataModel.count}'),
                          IconButton(
                            onPressed: () {
                              homeBloc.add(HomeBtnClickedEvnt(
                                clickedProduct: productDataModel,
                                cartAction: CartAction.cartAdd,
                              ));
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      )
                    : ElevatedButton(
                  onPressed: () {
                    homeBloc.add(HomeBtnClickedEvnt(
                      clickedProduct: productDataModel,
                      cartAction: CartAction.cartAdd,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent, // Set the button background color
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.black87, // Set the text color
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
