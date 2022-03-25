import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:simple_search/src/simple_search_bar.dart';

class SimpleSearch<A, T> extends StatefulWidget {
  SimpleSearch({
    Key? key,
    required Widget searchBar,
    required this.pagedSliverList,
  })  : effectiveSearchBar = SliverToBoxAdapter(
          child: searchBar,
        ),
        super(key: key);

  SimpleSearch.persistent({
    Key? key,
    required SimpleSearchBar persistentSearchBar,
    double height = 56.0,
    double maxHeigth = 130.0,
    bool pinnedSearchBar = false,
    bool floatingSearchBar = false,
    required this.pagedSliverList,
  })  : effectiveSearchBar = SliverPersistentHeader(
          pinned: pinnedSearchBar,
          floating: floatingSearchBar,
          delegate: PersistentSearchBar(
              widget: persistentSearchBar,
              height: (persistentSearchBar.topLeading ?? false
                  ? height + 48
                  : height)),
        ),
        super(key: key);

  final Widget effectiveSearchBar;
  final PagedSliverList<A, T> pagedSliverList;

  @override
  _SimpleSearchState createState() => _SimpleSearchState();
}

class _SimpleSearchState extends State<SimpleSearch> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        widget.effectiveSearchBar,
        widget.pagedSliverList,
      ],
    );
  }
}

class PersistentSearchBar extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double height;
  final double? maxHeigth;

  PersistentSearchBar(
      {required this.widget, required this.height, this.maxHeigth});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return PreferredSize(
      child: widget,
      preferredSize: Size.fromHeight(height),
    );
  }

  @override
  double get maxExtent => maxHeigth ?? height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
