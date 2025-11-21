// uts nih bos

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyShop Mini',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF4ECEA),
        cardColor: const Color(0xFFEFE5E2),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// -------------------- HOME PAGE FINAL (UI + ANIMATION + BANNER) --------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = 430;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),

              // ------------------ HEADER ------------------
              FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: const Text(
                    "MyShop Mini",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ------------------ BANNER FIX ------------------
              FadeTransition(
                opacity: _fadeAnim,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.asset(
                    'assets/kopibanner.png',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ------------------ CATEGORY BUTTONS ------------------
              FadeTransition(
                opacity: _fadeAnim,
                child: CategoryTile(
                  title: "Snack",
                  icon: Icons.fastfood,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductListPage(
                          title: "Snack",
                          products: snackItems,
                        ),
                      ),
                    );
                  },
                ),
              ),

              FadeTransition(
                opacity: _fadeAnim,
                child: CategoryTile(
                  title: "Minuman",
                  icon: Icons.local_cafe,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductListPage(
                          title: "Minuman",
                          products: drinkItems,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- CATEGORY TILE --------------------

class CategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.brown),
              const SizedBox(width: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- PRODUCT LIST --------------------

class ProductListPage extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;

  const ProductListPage({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth = 430;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: p),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            p["image"],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                      ),
                      Text(
                        p["name"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p["price"],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// -------------------- PRODUCT DETAIL --------------------

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasOptions = p["options"] != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(p["name"]),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(p["image"], height: 250, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              p["name"],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              p["price"],
              style: const TextStyle(fontSize: 20, color: Colors.brown),
            ),
          ),
          const SizedBox(height: 25),

          // OPTIONS
          if (hasOptions)
            const Text(
              "Pilih Varian:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

          if (hasOptions)
            ...p["options"].map<Widget>((opt) {
              return RadioListTile(
                title: Text(opt),
                value: opt,
                groupValue: selectedOption,
                onChanged: (v) => setState(() => selectedOption = v),
              );
            }).toList(),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (hasOptions && selectedOption == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pilih opsi dulu bro!")),
                );
                return;
              }

              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Order Berhasil!"),
                  content: Text(
                    hasOptions
                        ? "${p["name"]} - $selectedOption dipesan!"
                        : "${p["name"]} dipesan!",
                  ),
                ),
              );
            },
            child: const Text(
              "ORDER",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------- DATA --------------------

List<Map<String, dynamic>> snackItems = [
  {
    "name": "Cireng",
    "price": "10k",
    "image": "assets/cireng.jpeg",
    "options": null,
  },
  {
    "name": "Kentang Goreng",
    "price": "12k",
    "image": "assets/kentang goreng.jpg",
    "options": null,
  },
  {
    "name": "Tahu Crispy",
    "price": "12k",
    "image": "assets/tahu crispy.jpg",
    "options": null,
  },
  {
    "name": "Jamur Crispy",
    "price": "14k",
    "image": "assets/jamur crispy.jpeg",
    "options": null,
  },
];

List<Map<String, dynamic>> drinkItems = [
  {
    "name": "Kopi Hitam Racik",
    "price": "5k",
    "image": "assets/kopihitam.jpeg",
    "options": [
      "Manis",
      "Gula Standart",
      "Gula Sedang",
      "Gula Sedikit",
      "Tanpa Gula",
    ],
  },
  {
    "name": "Kopi Susu Racik",
    "price": "6k",
    "image": "assets/kopi susu.jpg",
    "options": ["Gula Standart", "Tanpa Gula"],
  },
  {
    "name": "Pop Ice / Nutrisari",
    "price": "4k - 6k",
    "image": "assets/pop ice.jpeg",
    "options": ["Es Gelas Kecil - 4k", "Es Gelas Besar - 6k", "Hangat - 4k"],
  },
  {
    "name": "Kopi Sachet",
    "price": "5k",
    "image": "assets/kopi sachet.jpg",
    "options": null,
  },
  {
    "name": "Susu Sachet",
    "price": "4k - 8k",
    "image": "assets/es susu.jpg",
    "options": ["Es Gelas Kecil - 5k", "Es Gelas Besar - 8k", "Hangat - 4k"],
  },
  {
    "name": "Joshua",
    "price": "7k - 9k",
    "image": "assets/joshua.jpg",
    "options": ["Es Gelas Kecil - 7k", "Es Gelas Besar - 9k"],
  },
];
