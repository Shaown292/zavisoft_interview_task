import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:zavisoft_interview_task/screens/profile_screen.dart';

import '../service/api_service.dart';
import '../widgets/product_tile.dart';
import '../widgets/best_selling_card.dart';
import '../widgets/stricky_tab_deligate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _api = ApiService();

  List products = [];

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
    products = await _api.fetchProducts();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

            /// ------------------ SLIDER APP BAR ------------------
            SliverAppBar(
              expandedHeight: 260,
              floating: false,
              pinned: false,
              elevation: 0,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      viewportFraction: 0.85,
                    ),
                    items: imgList
                        .map(
                          (item) => Container(
                        margin:
                        const EdgeInsets.symmetric(horizontal: 6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
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

            /// ------------------ GRID SECTION ------------------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      imageUrl:
                      "https://picsum.photos/200?random=$index",
                      title:
                      "Premium Headphone Wireless Bluetooth",
                      price: 59.99,
                      rating: 4.5,
                    );
                  },
                ),
              ),
            ),

            /// ------------------ STICKY TAB BAR ------------------
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

          /// ------------------ TAB CONTENT ------------------
          body: TabBarView(
            controller: _tabController,
            children: [
              buildProductList(),
              buildProductList(),
              buildProductList(),
            ],
          ),
        ),
      ),
    );
  }

  /// ------------------ PRODUCT LIST ------------------
  Widget buildProductList() {
    return RefreshIndicator(
      onRefresh: loadProducts,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (products.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return ProductTile(product: products[index]);
              },
              childCount:
              products.isEmpty ? 1 : products.length,
            ),
          ),
        ],
      ),
    );
  }
}