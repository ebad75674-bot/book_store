// TODO Implement this library.
import 'package:book_store/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> sliderImages = [
      'lib/assets/book1.jpg',
      'lib/assets/book2.png',
      'lib/assets/book3.png',
      'lib/assets/book4.png',
      'lib/assets/book5.png',
    ];

    final List<Map<String, String>> discountBooks = [
      {"title": "The Power of Now", "discount": "20%", "image": "lib/assets/book1.jpg"},
      {"title": "Think Like a Monk", "discount": "30%", "image": "lib/assets/book2.png"},
      {"title": "The Subtle Art of Not Giving a F*ck", "discount": "25%", "image": "lib/assets/book3.png"},
    ];

    final books = [
      {"title": "The Alchemist", "image": "lib/assets/book1.jpg"},
      {"title": "Atomic Habits", "image": "lib/assets/book2.png"},
      {"title": "1984", "image": "lib/assets/book3.png"},
      {"title": "Rich Dad Poor Dad", "image": "lib/assets/book4.png"},
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: sliderImages.map((imgPath) {
                  return Image.asset(imgPath, fit: BoxFit.cover, width: double.infinity);
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 💸 Discounted Books Section (Animated)
          Container(
            width: double.infinity,
            color: MyTheme.backgroundColor.withOpacity(0.1),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🔥 Discounted Books",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.textColor,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: discountBooks.length,
                    itemBuilder: (context, index) {
                      return _AnimatedDiscountCard(
                        title: discountBooks[index]["title"]!,
                        discount: discountBooks[index]["discount"]!,
                        image: discountBooks[index]["image"]!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 📚 Book Collection Grid
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: books.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return Card(
                  color: MyTheme.accentColor.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16)),
                          child: Image.asset(
                            books[index]["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        books[index]["title"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedDiscountCard extends StatefulWidget {
  final String title;
  final String discount;
  final String image;

  const _AnimatedDiscountCard({
    required this.title,
    required this.discount,
    required this.image,
  });

  @override
  State<_AnimatedDiscountCard> createState() => _AnimatedDiscountCardState();
}

class _AnimatedDiscountCardState extends State<_AnimatedDiscountCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 16),
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(_hovered ? 0.95 : 0.85),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? MyTheme.primaryColor.withOpacity(0.3)
                  : Colors.black12,
              blurRadius: _hovered ? 10 : 5,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: AnimatedOpacity(
                      opacity: _hovered ? 0.9 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Image.asset(
                        widget.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: MyTheme.textColor,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Text(
                  "-${widget.discount}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
