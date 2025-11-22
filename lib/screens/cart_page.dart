import 'package:book_store/Controler/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_store/theme/theme.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Your Cart",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 8, color: Colors.black)],
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: cart.cartItems.isEmpty
            ? const Center(
                child: Text(
                  "Your Cart is Empty",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            : Column(
                children: [
                  const SizedBox(height: 80),

                  /// CART LIST
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 12),
                      itemCount: cart.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cart.cartItems[index];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item['image'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),

                            title: Text(
                              item['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            subtitle: Text(
                              item['price'],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),

                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 28,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                cart.removeItem(index);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// Total Price Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${cart.totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: MyTheme.primaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        /// CHECKOUT BUTTON + ANIMATION
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyTheme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 10,
                              shadowColor: MyTheme.primaryColor,
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Proceed to Checkout",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
