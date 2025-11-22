import 'package:book_store/Controler/cart_controller.dart';
import 'package:book_store/screens/feedback.dart';
import 'package:book_store/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:book_store/theme/theme.dart';
import 'package:book_store/Auth/login.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:book_store/screens/cart_page.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const CategoriesPage(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AK Bookstore"),
        backgroundColor: MyTheme.primaryColor,
        elevation: 4,
        shadowColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: BookSearchDelegate());
            },
          ),

          /// CART BUTTON
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: Container(
          color: MyTheme.backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MyTheme.primaryColor,
                      MyTheme.accentColor.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        color: MyTheme.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  setState(() => _selectedIndex = 0);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categories'),
                onTap: () {
                  setState(() => _selectedIndex = 1);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.feedback),
                title: const Text('Feedback'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Feedbackpage()),
                  );
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: MyTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<String> bannerImages = [
    "https://images.unsplash.com/photo-1512820790803-83ca734da794?w=1000",
    "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=1000",
    "https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=1000",
  ];

  final List<Map<String, dynamic>> featuredBooks = [
    {
      'title': 'The Alchemist',
      'price': '\$10',
      'image':
          'https://images-na.ssl-images-amazon.com/images/I/71aFt4+OTOL._AC_UF1000,1000_QL80_.jpg',
      'rating': 4.5,
    },
    {
      'title': 'Atomic Habits',
      'price': '\$15',
      'image':
          'https://images-na.ssl-images-amazon.com/images/I/91bYsX41DVL.jpg',
      'rating': 4.8,
    },
    {
      'title': '1984',
      'price': '\$12',
      'image':
          'https://images-na.ssl-images-amazon.com/images/I/71kxa1-0mfL.jpg',
      'rating': 4.6,
    },
    {
      'title': 'Rich Dad Poor Dad',
      'price': '\$14',
      'image':
          'https://images-na.ssl-images-amazon.com/images/I/81bsw6fnUiL.jpg',
      'rating': 4.7,
    },
  ];

  final List<Map<String, dynamic>> categories = [
    {"name": "Fiction", "icon": Icons.menu_book},
    {"name": "Non-Fiction", "icon": Icons.article},
    {"name": "Science", "icon": Icons.science},
    {"name": "History", "icon": Icons.history_edu},
    {"name": "Comics", "icon": Icons.image},
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartController>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 CAROUSEL
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
            ),
            items: bannerImages.map((image) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          /// CATEGORY SECTION
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Shop by Category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MyTheme.textColor,
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  width: 90,
                  margin: const EdgeInsets.only(right: 14),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        MyTheme.primaryColor.withOpacity(0.15),
                        MyTheme.accentColor.withOpacity(0.15),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        category['icon'],
                        size: 30,
                        color: MyTheme.primaryColor,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        category['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          /// 🔹 FEATURED BOOKS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Featured Books",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MyTheme.textColor,
              ),
            ),
          ),

          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: featuredBooks.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final book = featuredBooks[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.network(book['image'], fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(
                            book['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            book['price'],
                            style: TextStyle(
                              color: MyTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),

                          /// ADD TO CART BUTTON
                          ElevatedButton.icon(
                            onPressed: () {
                              cart.addToCart(book);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${book['title']} added to cart",
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_shopping_cart, size: 16),
                            label: const Text("Add to Cart"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  final List<String> books = [
    "The Alchemist",
    "Atomic Habits",
    "1984",
    "Rich Dad Poor Dad",
    "Think Like a Monk",
    "The Power of Now",
  ];

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    final results = books
        .where((book) => book.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) =>
          ListTile(title: Text(results[i]), leading: const Icon(Icons.book)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books
        .where((book) => book.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(suggestions[i]),
        onTap: () {
          query = suggestions[i];
          showResults(context);
        },
      ),
    );
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        "name": "Fiction",
        "subcategories": ["Romance", "Thriller", "Fantasy"],
      },
      {
        "name": "Non-Fiction",
        "subcategories": ["Self-Help", "Biography", "Business"],
      },
      {
        "name": "Science",
        "subcategories": ["Physics", "Biology", "Chemistry"],
      },
      {
        "name": "History",
        "subcategories": ["Ancient", "Modern", "World War"],
      },
      {
        "name": "Comics",
        "subcategories": ["Marvel", "DC", "Manga"],
      },
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (_, index) {
            final category = categories[index];

            return ExpansionTile(
              title: Text(
                "name",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),

              children: (category['subcategories'] as List<String>)
                  .map(
                    (sub) => ListTile(
                      title: Text(sub),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Exploring $sub")),
                        );
                      },
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
