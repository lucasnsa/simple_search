import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simple_search/simple_search.dart';

class SearchDemoPersist extends StatefulWidget {
  SearchDemoPersist({Key? key, this.title = 'Demo Persist'}) : super(key: key);

  final String title;

  @override
  _SearchDemoPersistState createState() => _SearchDemoPersistState();
}

class _SearchDemoPersistState extends State<SearchDemoPersist> {
  String? _searchTerm;

  final listPersons = [
    Person('Charizard'),
    Person('Pikachu'),
    Person('Afondo'),
    Person('Aristo'),
    Person('Jackin'),
    Person('Jack'),
    Person('Jacquin'),
    Person('Oliver'),
    Person('Olivia'),
    Person('Daniel'),
    Person('Dan'),
    Person('Marie'),
    Person('Maria'),
    Person('Marine'),
    Person('Marine1'),
    Person('Marine2'),
    Person('Marine3'),
    Person('Marine4'),
    Person('Marine5'),
    Person('Marine6'),
    Person('Marine7'),
    Person('Marine8'),
    Person('Marine9'),
    Person('Marine10'),
    Person('Marine11'),
    Person('Marine12'),
    Person('Marine13'),
    Person('Marine14'),
  ];

  final PagingController<int, Person> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final result = await Future.value(listPersons
          .where((element) => element.name
              .toLowerCase()
              .contains(_searchTerm?.toLowerCase() ?? ''))
          .toList());

      if (_searchTerm?.isEmpty ?? true) {
        _pagingController.appendLastPage([]);
      } else {
        _pagingController.appendLastPage(result);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _incrementCounter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pesquisar'),
          content: Container(
            width: double.maxFinite,
            child: SimpleSearch<int, Person>(
              pagedSliverList: PagedSliverList(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  animateTransitions: true,
                  itemBuilder: (context, item, index) => ListTile(
                    title: Text(item.name),
                  ),
                ),
              ),
              searchBar: SimpleSearchBar.google(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                clearAction: Icon(Icons.clear),
                textFieldDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                onChangeSearch: (text) {
                  _searchTerm = text;
                  _pagingController.refresh();
                },
                searchTermValidator: (value) {
                  if (value != null && value.length < 3) {
                    return false;
                  }
                  return true;
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter();
        },
      ),
      body: SafeArea(
        child: SimpleSearch<int, Person>.persistent(
          pinnedSearchBar: true,
          persistentSearchBar: SimpleSearchBar(
            searchBarElevation: 8.0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            clearAction: Icon(Icons.clear),
            textFieldDecoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            onChangeSearch: (text) {
              _searchTerm = text;
              _pagingController.refresh();
            },
            searchTermValidator: (value) {
              if (value != null && value.length < 3) {
                return false;
              }
              return true;
            },
          ),
          pagedSliverList: PagedSliverList(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              animateTransitions: true,
              itemBuilder: (context, item, index) => ListTile(
                title: Text(item.name),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Person {
  final String name;

  Person(this.name);
}
