import 'package:flutter/material.dart';
import 'add_category_page.dart';
import './services/category_service.dart';
import 'dart:async';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({Key? key}) : super(key: key);

  @override
  _CategoryManagementPageState createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<dynamic>> _futureCategories;
  List<dynamic> _allCategories = [];
  List<dynamic> _filteredCategories = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    final categories = await CategoryService.getAllCategories();
    setState(() {
      _allCategories = categories;
      _filteredCategories = _allCategories;
      _futureCategories = Future.value(categories);
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      _filterCategories();
    });
  }

  void _filterCategories() {
    final searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _allCategories.where((category) {
        return category['name'].toLowerCase().contains(searchText);
      }).toList();
    });
  }

  void _deleteCategory(String id) {
    print("id id: $id");
    CategoryService.deleteCategory(id);
    _allCategories = _allCategories.map((category) {
        print("Checking category: ${category['id']} with id: $id");
        return category;
      }).where((category) => category['id'] != id).toList();
      setState(() {
        _futureCategories = Future.value(_allCategories);
        _filteredCategories = _allCategories;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Category',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _onSearchChanged();
                },
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _filteredCategories.length,
              itemBuilder: (context, index) {
                final category = _filteredCategories[index];
                return ListTile(
                  title: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(category['name']),
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Image.network(category['imageUrl']),
                                  Text(category['description']),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(category['name']),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteCategory(category['id']),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategoryPage()))
          .then((_) {
            CategoryService.getAllCategories().then((categories) {
              setState(() {
                _allCategories = categories;
                _filteredCategories = categories;
              });
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}