import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
    required Widget persistentSearchBar,
    double height = 56.0,
    bool pinnedSearchBar = false,
    bool floatingSearchBar = false,
    required this.pagedSliverList,
  })  : effectiveSearchBar = SliverPersistentHeader(
          pinned: pinnedSearchBar,
          floating: floatingSearchBar,
          delegate:
              PersistentSearchBar(widget: persistentSearchBar, heigth: height),
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
  final double heigth;

  PersistentSearchBar({required this.widget, required this.heigth});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: heigth,
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.white,
        elevation: 5.0,
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
