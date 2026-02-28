import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../model/product_model.dart';
import '../service/api_service.dart';
import '../widgets/best_selling_card.dart';
import '../widgets/product_tile.dart';
import '../widgets/stricky_tab_deligate.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  List<ProductModel> products = [];
  bool isLoading = true;
  String? error;

  final List<String> imgList = [
    'https://picsum.photos/800/400?image=1',
    'https://picsum.photos/800/400?image=2',
    'https://picsum.photos/800/400?image=3',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final data = await _api.fetchProducts();

      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ProductModel> filterByCategory(String category) {
    if (category == "All") return products;
    return products
        .where((product) => product.category.toLowerCase().contains(
      category.toLowerCase(),
    ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
        child: const Icon(Icons.person),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            /// SLIDER
            SliverAppBar(
              expandedHeight: 260,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayInterval:
                      const Duration(seconds: 3),
                      viewportFraction: 0.85,
                    ),
                    items: imgList
                        .map(
                          (item) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(16),
                          child: Image.network(
                            item,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ),

            /// GRID SECTION
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: products.length > 6
                      ? 6
                      : products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return BestSellingCard(imageUrl: product.image, title: product.title, price: product.price, rating: product.rating,);
                  },
                ),
              ),
            ),

            /// STICKY TAB BAR
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(text: "All"),
                    Tab(text: "Electronics"),
                    Tab(text: "Clothes"),
                  ],
                ),
              ),
            ),
          ],

          /// TAB CONTENT
          body: TabBarView(
            controller: _tabController,
            children: [
              buildProductList("All"),
              buildProductList("electronics"),
              buildProductList("clothing"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductList(String category) {
    final filtered = filterByCategory(category);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Text(error!),
      );
    }

    return RefreshIndicator(
      onRefresh: loadProducts,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          return ProductTile(product: filtered[index]);
        },
      ),
    );
  }
}