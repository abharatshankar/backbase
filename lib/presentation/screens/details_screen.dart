import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/book.dart';
import '../providers/book_provider.dart';
import 'dart:math';

class DetailsScreen extends StatefulWidget {
  final Book book;
  const DetailsScreen({required this.book});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveBook(BuildContext context) async {
    final provider = Provider.of<BookProvider>(context, listen: false);
    await provider.repository.saveBook(widget.book);
    setState(() {
      _isSaved = true;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Book saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: RotationTransition(
                turns: _controller,
                child:
                    widget.book.coverUrl.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: widget.book.coverUrl,
                          height: 200,
                          fit: BoxFit.contain,
                          placeholder:
                              (context, url) => Container(
                                height: 200,
                                width: 140,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) =>
                                  const Icon(Icons.broken_image, size: 120),
                        )
                        : const Icon(Icons.book, size: 120),
              ),
            ),
            SizedBox(height: 24),
            Text(
              widget.book.title,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              widget.book.author,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text(_isSaved ? 'Saved' : 'Save to Library'),
              onPressed: _isSaved ? null : () => _saveBook(context),
            ),
          ],
        ),
      ),
    );
  }
}
