import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/keranjang.dart';
import 'package:flutter_application_1/pages/search.dart'; // Import your search page
import 'package:flutter_application_1/pages/profile_screen.dart'; // Import ProfileScreen
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'name': 'VINA VENTISQUERO RESERVA MERLOT 88AG 2021',
      'price': 447000
    },
    {
      'id': 2,
      'name': 'VINA VENTISQUERO CLASSICO CABERNET SAUVIGNON 2018',
      'price': 516000
    },
    {'id': 3, 'name': 'MONTES ALPHA MERLOT', 'price': 516000},
    {'id': 4, 'name': 'CATENA ALAMOS MALBEC', 'price': 447000},
  ];

  String _selectedSort = 'Popularity'; // Added state for sorting

  Future<void> _addToCart(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cart = [];

    // Load existing cart from SharedPreferences
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      cart = List<Map<String, dynamic>>.from(json.decode(cartData));
    }

    // Check if item is already in the cart
    int index = cart.indexWhere((cartItem) => cartItem['id'] == item['id']);
    if (index >= 0) {
      cart[index]['quantity'] += 1;
    } else {
      cart.add({
        'id': item['id'],
        'name': item['name'],
        'price': item['price'],
        'quantity': 1
      });
    }

    // Save updated cart back to SharedPreferences
    prefs.setString('cart', json.encode(cart));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} added to cart')),
    );
  }

  // Function to handle sorting
  void _sortItems(String criterion) {
    setState(() {
      _selectedSort = criterion;
      if (criterion == 'Price: Low to High') {
        items.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (criterion == 'Price: High to Low') {
        items.sort((a, b) => b['price'].compareTo(a['price']));
      } else {
        // Assuming 'Popularity' is the default order
        // If you have a 'popularity' field, sort accordingly
        // For now, we'll keep the original order
        items = [
          {
            'id': 1,
            'name': 'VINA VENTISQUERO RESERVA MERLOT 88AG 2021',
            'price': 447000
          },
          {
            'id': 2,
            'name': 'VINA VENTISQUERO CLASSICO CABERNET SAUVIGNON 2018',
            'price': 516000
          },
          {'id': 3, 'name': 'MONTES ALPHA MERLOT', 'price': 516000},
          {'id': 4, 'name': 'CATENA ALAMOS MALBEC', 'price': 447000},
        ];
      }
    });
  }

  int _selectedIndex = 0; // Added state for BottomNavigationBar

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Current HomePage, do nothing
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WineSearchPage()),
        );
        break;
      case 2:
        // Navigate to Favorite Page (Assuming you have a FavoritePage)
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const FavoritePage()),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Favorite feature not implemented yet")),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Go Wine"),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            tooltip: 'Cart',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Section
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/banner.jpg'), // Ensure this asset exists
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Sort Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sort by:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedSort,
                    items: const [
                      DropdownMenuItem(
                          value: 'Popularity', child: Text('Popularity')),
                      DropdownMenuItem(
                          value: 'Price: Low to High',
                          child: Text('Price: Low to High')),
                      DropdownMenuItem(
                          value: 'Price: High to Low',
                          child: Text('Price: High to Low')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _sortItems(value);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Product Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/product${item['id']}.jpg'), // Ensure these assets exist
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Rp ${item['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ElevatedButton(
                                onPressed: () => _addToCart(item),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: const Text('Add to Cart'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20), // Added spacing at the bottom
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex, // Highlight the selected item
        type: BottomNavigationBarType.fixed, // To show all labels
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: _onBottomNavTapped,
      ),
    );
  }
}