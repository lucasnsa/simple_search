import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simple_search/simple_search.dart';

class SearchDemoNormal extends StatefulWidget {
  SearchDemoNormal({Key? key, this.title = 'Demo normal'}) : super(key: key);

  final String title;

  @override
  _SearchDemoNormalState createState() => _SearchDemoNormalState();
}

class _SearchDemoNormalState extends State<SearchDemoNormal> {
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
          title: Text('Search'),
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
                  debugPrint('chamou');
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
      body: SimpleSearch<int, Person>(
        pagedSliverList: PagedSliverList(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            animateTransitions: true,
            itemBuilder: (context, item, index) => ListTile(
              title: Text(item.name),
            ),
          ),
        ),
        searchBar: SimpleSearchBar(
          searchBarElevation: 3.0,
          padding: EdgeInsets.all(24),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
          topLeading: true,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Find a pokemon or people',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          clearAction: Icon(Icons.delete),
          textFieldDecoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          inputDecoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
          onChangeSearch: (text) {
            // Does not search if it is the same text
            if (text != _searchTerm) {
              _searchTerm = text;
              _pagingController.refresh();
            }
          },
          searchTermValidator: (value) {
            if (value != null && value.length < 3) {
              return false;
            }
            return true;
          },
        ),
      ),
    );
  }
}

class Person {
  final String name;

  Person(this.name);
}
