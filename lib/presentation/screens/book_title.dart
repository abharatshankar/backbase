import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import '../../domain/entities/book.dart';
import '../screens/details_screen.dart';

class BookTile extends StatelessWidget {
  final Book book;
  const BookTile({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.coverUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: book.coverUrl,
                width: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 70,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image),
              ),
            )
          : const Icon(Icons.book),
      title: Text(
        book.title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        book.author,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(book: book),
          ),
        );
      },
    );
  }
}
