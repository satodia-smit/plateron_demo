import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plateron_demo/features/home/ui/product_tile_widget.dart';
import 'package:plateron_demo/utils/commonwidgets/CustomErrorWidget.dart';

import '../../cart/ui/cart.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../models/product_data_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    homeBloc.add(HomeInitialEvnt());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigationToCartPageActionState) {
          _navigateToCartPage();
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return _buildLoadingState();
          case HomeLoadedSuccessState:
            return _buildSuccessState(state as HomeLoadedSuccessState);
          case HomeErrorState:
            return _buildErrorState();
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  void _navigateToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Cart()),
    ).then((result) {
      homeBloc.add(HomeInitialEvnt());
    });
  }

  Widget _buildLoadingState() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSuccessState(HomeLoadedSuccessState successState) {
    final int productCountSum = successState.products
        .map((p) => p.count ?? 0)
        .fold(0, (prev, count) => prev + count);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(successState.products),
      bottomNavigationBar: _buildBottomNavigationBar(productCountSum),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Plateron demo'),
      backgroundColor: Colors.amberAccent,
    );
  }

  Widget _buildBody(List<ProductDataModel> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductTileWidget(
                productDataModel: products[index],
                homeBloc: homeBloc,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(int productCountSum) {
    if (productCountSum > 0) {
      return Container(
        height: 40,
        color: Colors.amberAccent,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black,
                ),
                const SizedBox(width: 8.0),
                Text(
                  '$productCountSum items',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToCartPage();
              },
              child: const Text(
                'Place Order',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    } else {
      // Return an empty container if there are no items in the cart
      return const SizedBox.shrink();
    }
  }

  Widget _buildErrorState() {
    return const CustomErrorWidget(errorMessage: "Error with the loading result");
  }
}
