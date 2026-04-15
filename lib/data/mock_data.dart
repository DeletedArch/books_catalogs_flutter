import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/feature.dart';

class MockData {
  static List<Book> get bestSellers => const [
    Book(title: 'To Kill a Mockingbird', author: 'Harper Lee'),
    Book(title: '1984', author: 'George Orwell'),
    Book(title: 'Pride and Prejudice', author: 'Jane Austen'),
    Book(title: 'The Great Gatsby', author: 'F. Scott Fitzgerald'),
    Book(title: 'Moby Dick', author: 'Herman Melville'),
    Book(title: 'The Catcher in the Rye', author: 'J.D. Salinger'),
  ];

  static List<Book> get recentlyAdded => const [
    Book(title: 'To Kill a Mockingbird', author: 'Harper Lee'),
    Book(title: '1984', author: 'George Orwell'),
    Book(title: 'Pride and Prejudice', author: 'Jane Austen'),
    Book(title: 'The Great Gatsby', author: 'F. Scott Fitzgerald'),
    Book(title: 'Moby Dick', author: 'Herman Melville'),
    Book(title: 'The Catcher in the Rye', author: 'J.D. Salinger'),
  ];

  static List<Book> get recommended => const [
    Book(title: 'Brave New World', author: 'Aldous Huxley'),
    Book(title: 'The Hobbit', author: 'J.R.R. Tolkien'),
    Book(title: 'Fahrenheit 451', author: 'Ray Bradbury'),
    Book(title: 'Jane Eyre', author: 'Charlotte Brontë'),
    Book(title: 'Wuthering Heights', author: 'Emily Brontë'),
    Book(title: 'The Odyssey', author: 'Homer'),
  ];

  static List<Book> get popularThisWeek => const [
    Book(title: 'Crime and Punishment', author: 'Fyodor Dostoevsky'),
    Book(title: 'The Brothers Karamazov', author: 'Fyodor Dostoevsky'),
    Book(title: 'War and Peace', author: 'Leo Tolstoy'),
    Book(title: 'Anna Karenina', author: 'Leo Tolstoy'),
    Book(title: 'The Iliad', author: 'Homer'),
    Book(title: 'Don Quixote', author: 'Miguel de Cervantes'),
  ];

  static List<Book> get newReleases => const [
    Book(title: 'Ulysses', author: 'James Joyce'),
    Book(title: 'The Divine Comedy', author: 'Dante Alighieri'),
    Book(title: 'Hamlet', author: 'William Shakespeare'),
    Book(title: 'Macbeth', author: 'William Shakespeare'),
    Book(title: 'Romeo and Juliet', author: 'William Shakespeare'),
    Book(title: 'The Canterbury Tales', author: 'Geoffrey Chaucer'),
  ];

  static List<AppFeature> get features => const [
    AppFeature(
      number: 1,
      title: 'Browsing Books',
      description: 'Browse a library of books and view their details.',
      icon: Icons.search,
    ),
    AppFeature(
      number: 2,
      title: 'Viewing and Downloading Books',
      description:
          'View and Download Books either from us or different providers.',
      icon: Icons.remove_red_eye_outlined,
    ),
    AppFeature(
      number: 3,
      title: 'Rating and Reviewing Books',
      description: 'Rate and Review Books to communicate with other users.',
      icon: Icons.edit,
    ),
    AppFeature(
      number: 4,
      title: 'Adding Books to Lists',
      description:
          'Add books to lists to save it or suggest it to other users.',
      icon: Icons.add,
      iconColor: Color(0xFF4CAF50),
    ),
    AppFeature(
      number: 5,
      title: 'Books Recommendations',
      description:
          'Get book recommendations through lists or through chatting with AI Assistant.',
      icon: Icons.favorite,
      iconColor: Color(0xFFE91E8C),
    ),
    AppFeature(
      number: 6,
      title: 'Books Charts',
      description: "View Books charts based on users' ratings.",
      icon: Icons.bar_chart,
    ),
  ];
}
