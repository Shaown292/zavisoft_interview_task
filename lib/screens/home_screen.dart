import 'package:flutter/material.dart';
import 'package:zavisoft_interview_task/screens/profile_screen.dart';

import '../service/api_service.dart';
import '../widgets/product_tile.dart';
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text("FakeStore"),
                  background: FlutterLogo(),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "All"),
                      Tab(text: "Electronics"),
                      Tab(text: "Clothes"),
                    ],
                  ),
                ),
              ),
            ],
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
          child: const Icon(Icons.person),
        ),
      ),
    );
  }

  Widget buildProductList() {
    return RefreshIndicator(
      onRefresh: loadProducts,
      child: CustomScrollView(
        key: PageStorageKey(_tabController.index),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                  ProductTile(product: products[index]),
              childCount: products.length,
            ),
          ),
        ],
      ),
    );
  }
}