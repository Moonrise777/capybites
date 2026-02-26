import 'dart:ui';
import 'package:flutter/material.dart';
import '../components/glass_container.dart';
import '../components/app_background.dart';

class CartPage extends StatefulWidget {
  final Map<String, int> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.cartItems.keys.toList();
  }

  void _updateQuantity(String product, int index, bool isAdding) {
    setState(() {
      if (isAdding) {
        widget.cartItems[product] = widget.cartItems[product]! + 1;
      } else {
        if (widget.cartItems[product]! > 1) {
          widget.cartItems[product] = widget.cartItems[product]! - 1;
        } else {
          widget.cartItems.remove(product);
          final removedItem = _items.removeAt(index);
          _listKey.currentState?.removeItem(
            index,
            (context, animation) =>
                _buildItem(removedItem, 0, animation, index),
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    });
  }

  void _buyItems() {
    if (widget.cartItems.isEmpty) return;

    for (int i = _items.length - 1; i >= 0; i--) {
      final removedItem = _items.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => _buildItem(removedItem, 0, animation, i),
        duration: const Duration(milliseconds: 400),
      );
    }

    setState(() {
      widget.cartItems.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Thank you for your purchase!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.brown[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildItem(
    String product,
    int quantity,
    Animation<double> animation,
    int index,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: GlassContainer(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              title: Text(
                product,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                'Quantity: ${widget.cartItems[product] ?? quantity}',
                style: const TextStyle(color: Colors.black54),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.black87,
                    ),
                    onPressed: quantity > 0
                        ? () => _updateQuantity(product, index, false)
                        : null,
                  ),
                  Text(
                    '${widget.cartItems[product] ?? quantity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.black87,
                    ),
                    onPressed: quantity > 0
                        ? () => _updateQuantity(product, index, true)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Your Cart',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.2),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: widget.cartItems.isEmpty && _items.isEmpty
                    ? const Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    : AnimatedList(
                        key: _listKey,
                        padding: const EdgeInsets.all(20),
                        initialItemCount: _items.length,
                        itemBuilder: (context, index, animation) {
                          return _buildItem(
                            _items[index],
                            widget.cartItems[_items[index]]!,
                            animation,
                            index,
                          );
                        },
                      ),
              ),
              if (widget.cartItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _buyItems,
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
