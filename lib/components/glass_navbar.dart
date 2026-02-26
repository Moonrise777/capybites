import 'dart:ui';
import 'package:flutter/material.dart';

class GlassNavbar extends StatelessWidget {
  final bool isDesktop;
  final int cartCount;
  final VoidCallback onMenuPressed;
  final VoidCallback onCartPressed;
  final VoidCallback onAboutPressed;

  const GlassNavbar({
    super.key,
    required this.isDesktop,
    required this.cartCount,
    required this.onMenuPressed,
    required this.onCartPressed,
    required this.onAboutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isDesktop)
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black87),
                    onPressed: onMenuPressed,
                  ),

                Tooltip(
                  message: 'CapyBites',
                  child: InkWell(
                    onTap: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 120,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                if (isDesktop)
                  Row(
                    children: [
                      _navItem(
                        'Menu',
                        () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                      ),
                      _navItem('About Us', onAboutPressed),
                    ],
                  ),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.black87,
                      ),
                      onPressed: onCartPressed,
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(String title, VoidCallback press) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: press,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
