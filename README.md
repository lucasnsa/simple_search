# Simple Search

Provides widgets to easily list and search.

This project uses the [Infinite Scroll Pagination](https://pub.dev/packages/infinite_scroll_pagination) library to list and paginate the data.

## Usage

Add it in your `pubspec.yaml`:

```yaml
dependencies:
  infinite_scroll_pagination: any
  simple_search: any
```

Import it.

```dart
import 'package:simple_search/simple_search.dart';
```

### SimpleSearch

All SimpleSearch tools depend on the [PagedSliverList](https://pub.dev/documentation/infinite_scroll_pagination/latest/infinite_scroll_pagination/PagedSliverList-class.html) from the [Infinite Scroll Pagination](https://pub.dev/packages/infinite_scroll_pagination) library.

```dart
    SimpleSearch<int, Person>(
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
        ),
```

It is also possible to fix the search bar and other things

```dart
    SimpleSearch<int, Person>.persistent(
          pinnedSearchBar: true,
          floatingSearchBar: false,
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
```

The search bar can have round edges for example:

```dart
        SimpleSearchBar.google(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ...
```