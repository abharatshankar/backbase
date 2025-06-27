import 'package:backbase/presentation/screens/book_title.dart';
import 'package:backbase/presentation/screens/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String currentQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context);
    return Scaffold(
      // appBar: AppBar(title: Text("Book Finder",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),backgroundColor: Colors.grey.shade700,),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2C5364),
              Color(0xFF203A43),
              Color(0xFF0F2027),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade800,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search for books...',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    ),
                    keyboardType: TextInputType.text,
                    onSubmitted: (value) {
                    currentQuery = value;
                    if (currentQuery.isEmpty) return;
                    provider.refresh(currentQuery);
                    },
                  ),
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  if (currentQuery.isEmpty) return;
                  provider.refresh(currentQuery);
                },
                child: _buildContent(provider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BookProvider provider) {
    if (provider.isLoading && provider.books.isEmpty) {
      return ShimmerList();
    }
    
    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              if (provider.errorMessage.contains('internet'))
                ElevatedButton(
                  onPressed: () => provider.refresh(currentQuery),
                  child: Text('Retry'),
                ),
            ],
          ),
        ),
      );
    }
    
    if (provider.books.isEmpty) {
      return Center(
        child: Text(
          'Search for books to get started',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    
    
    return ListView.builder(padding: EdgeInsets.zero,
      
  itemCount: provider.books.length + (provider.hasMore ? 1 : 0),
  itemBuilder: (context, index) {
    if (index == provider.books.length && provider.hasMore) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!provider.isLoading) {
          provider.searchBooks(currentQuery);
        }
      });
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // Wrap each item with TweenAnimationBuilder for fade + slide
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)), // slide up effect
            child: child,
          ),
        );
      },
      child: GlassyBookItem(book: provider.books[index]),
    );
  },
);

  }
}