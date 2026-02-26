import 'dart:ui';
import 'package:flutter/material.dart';
import 'pages/cart_page.dart';
import 'pages/about_page.dart';
import 'components/glass_container.dart';
import 'components/app_background.dart';
import 'components/glass_navbar.dart';

void main() {
  runApp(const DessertShopApp());
}

class DessertShopApp extends StatelessWidget {
  const DessertShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CapyBites',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, int> _cart = {};

  int get _totalItems => _cart.values.fold(0, (sum, count) => sum + count);

  void _updateCart(String product, bool isAdding) {
    setState(() {
      if (isAdding) {
        _cart[product] = (_cart[product] ?? 0) + 1;
      } else {
        if (_cart.containsKey(product) && _cart[product]! > 0) {
          _cart[product] = _cart[product]! - 1;
          if (_cart[product] == 0) _cart.remove(product);
        }
      }
    });
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartPage(cartItems: _cart)),
    ).then((_) => setState(() {}));
  }

  void _goToAbout() => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AboutPage()),
  );

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 800;

    return AppBackground(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        drawer: SizedBox(
          width: 200,
          child: Drawer(
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    border: Border(
                      right: BorderSide(color: Colors.white.withOpacity(0.3)),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 50,
                          bottom: 10,
                          left: 20,
                          right: 10,
                        ),
                        child: Text(
                          'Menu',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Home'),
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          right: 10,
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                      ListTile(
                        title: const Text('About Us'),
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          right: 10,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _goToAbout();
                        },
                      ),
                      ListTile(
                        title: const Text('Cart'),
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          right: 10,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _goToCart();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: GlassNavbar(
            isDesktop: isDesktop,
            cartCount: _totalItems,
            onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
            onCartPressed: _goToCart,
            onAboutPressed: _goToAbout,
          ),
        ),

        body: GridView.count(
          padding: const EdgeInsets.only(
            top: 100,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          crossAxisCount: isDesktop ? 3 : (screenWidth > 500 ? 2 : 1),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.8,
          children: [
            _buildProductCard(
              'Tiramisu',
              'Coffee & Mascarpone',
              'assets/item1.jpg',
              0,
            ),
            _buildProductCard(
              'Mocha Frappe',
              'With whipped cream',
              'assets/item2.jpg',
              1,
            ),
            _buildProductCard(
              'Cheesecake',
              'Red berries',
              'assets/item3.jpg',
              2,
            ),
            _buildProductCard(
              'Macarons',
              'French assortment',
              'assets/item4.jpg',
              3,
            ),
            _buildProductCard('Matcha Tea', 'Organic', 'assets/item5.jpg', 4),
            _buildProductCard(
              'Ice Cream',
              'Natural vanilla',
              'assets/item6.jpg',
              5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    String title,
    String subtitle,
    String imagePath,
    int index,
  ) {
    int currentQuantity = _cart[title] ?? 0;

    // Animación escalonada según el índice
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.white30,
                    child: const Center(child: Text('Image')),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _circleBtn(Icons.remove, () => _updateCart(title, false)),
                      Text(
                        '$currentQuantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _circleBtn(Icons.add, () => _updateCart(title, true)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback press) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.4),
        elevation: 0,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
      ),
      onPressed: press,
      child: Icon(icon, color: Colors.black87),
    );
  }
}
