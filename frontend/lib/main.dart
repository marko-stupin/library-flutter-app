import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BooksPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BooksPage extends StatefulWidget {
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:4000/api/books'));

    if (response.statusCode == 200) {
      setState(() {
        books = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> addBook(String title, String author, int copies) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/api/books'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'author': author,
        'copies': copies,
      }),
    );

    if (response.statusCode == 200) {
      await fetchBooks();
    } else {
      throw Exception('Failed to add book');
    }
  }

  Future<void> deleteBook(String id) async {
    final response =
        await http.delete(Uri.parse('http://10.0.2.2:4000/api/books/$id'));

    if (response.statusCode == 200) {
      await fetchBooks();
    } else {
      throw Exception('Failed to delete book');
    }
  }

  Future<void> updateBook(
      String id, String title, String author, int copies) async {
    final response = await http.patch(
      Uri.parse('http://10.0.2.2:4000/api/books/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'author': author,
        'copies': copies,
      }),
    );

    if (response.statusCode == 200) {
      await fetchBooks();
    } else {
      throw Exception('Failed to update book');
    }
  }

  void _showAddBookDialog() {
    String title = '';
    String author = '';
    String copies = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) {
                  author = value;
                },
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  copies = value;
                },
                decoration: InputDecoration(labelText: 'Copies'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty &&
                    author.isNotEmpty &&
                    copies.isNotEmpty) {
                  addBook(title, author, int.parse(copies));
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateBookDialog(
      String id, String currentTitle, String currentAuthor, int currentCopies) {
    String title = currentTitle;
    String author = currentAuthor;
    String copies = currentCopies.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration:
                    InputDecoration(labelText: 'Title', hintText: currentTitle),
                controller: TextEditingController(text: currentTitle),
              ),
              TextField(
                onChanged: (value) {
                  author = value;
                },
                decoration: InputDecoration(
                    labelText: 'Author', hintText: currentAuthor),
                controller: TextEditingController(text: currentAuthor),
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  copies = value;
                },
                decoration: InputDecoration(
                    labelText: 'Copies', hintText: currentCopies.toString()),
                controller:
                    TextEditingController(text: currentCopies.toString()),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty &&
                    author.isNotEmpty &&
                    copies.isNotEmpty) {
                  updateBook(id, title, author, int.parse(copies));
                  Navigator.of(context).pop();
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Book'),
          content: Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteBook(id);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: books.isEmpty
          ? Center(child: Text('No books found'))
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Title: ${books[index]['title']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Author: ${books[index]['author']}'),
                        Text('Copies: ${books[index]['copies']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showUpdateBookDialog(
                                books[index]['_id'],
                                books[index]['title'],
                                books[index]['author'],
                                books[index]['copies']);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteConfirmationDialog(books[index]['_id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBookDialog,
        child: Icon(Icons.add),
        tooltip: 'Add Book',
      ),
    );
  }
}
