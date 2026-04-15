import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/book.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/app_footer.dart';
import 'sections/hero_section.dart';
import 'sections/features_section.dart';
import 'sections/bestsellers_section.dart';

class HomeScreen extends StatefulWidget {
  // ADD THESE
  final VoidCallback? onLogin;
  final VoidCallback? onSignUp;

  const HomeScreen({
    super.key,
    this.onLogin, // ADD THIS
    this.onSignUp, // ADD THIS
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    // TODO: Navigate to browse screen
  }

  void _onBookTap(Book book) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tapped: ${book.title}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppNavbar(
            searchController: _searchController,
            onLogin: widget.onLogin, // WIRE UP
            onSignUp: widget.onSignUp, // WIRE UP
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeroSection(onGetStarted: _onGetStarted),
                  FeaturesSection(features: MockData.features),
                  BestSellersSection(
                    books: MockData.bestSellers,
                    onBookTap: _onBookTap,
                  ),
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
