import 'dart:async';

import 'package:flutter/material.dart';

typedef SearchTermValidator<String> = bool Function(String? value);

class SimpleSearchBar extends StatefulWidget {
  const SimpleSearchBar({
    Key? key,
    this.leading,
    this.topLeading,
    this.padding,
    this.title,
    this.textFieldDecoration,
    this.inputDecoration,
    this.clearAction = const Icon(Icons.clear),
    required this.onChangeSearch,
    this.searchBarElevation = 0.0,
    this.searchBorderRadiusGeometry,
    this.textFieldTextStyle,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.searchBarDecoration,
    this.searchTermValidator,
  }) : super(key: key);

  /// Put the leading on top of the bar
  const SimpleSearchBar.topLeading({
    Key? key,
    this.leading,
    this.topLeading = true,
    this.padding,
    this.title,
    this.textFieldDecoration,
    this.inputDecoration,
    this.clearAction = const Icon(Icons.clear),
    required this.onChangeSearch,
    this.searchBarElevation = 0.0,
    this.searchBorderRadiusGeometry,
    this.textFieldTextStyle,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.searchBarDecoration,
    this.searchTermValidator,
  }) : super(key: key);

  /// Imitation of google search bar
  const SimpleSearchBar.google({
    Key? key,
    this.leading,
    this.topLeading,
    this.padding,
    this.title,
    this.textFieldDecoration,
    this.inputDecoration,
    this.clearAction = const Icon(Icons.clear),
    required this.onChangeSearch,
    this.searchBarElevation = 8.0,
    this.searchBorderRadiusGeometry =
        const BorderRadius.all(Radius.circular(48)),
    this.textFieldTextStyle,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.searchBarDecoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(48)),
    ),
    this.searchTermValidator,
  }) : super(key: key);

  /// A widget to display before the search field.
  /// Typically the leading widget is an Icon or an IconButton.
  final Widget? leading;

  /// Put the leading on the top of bar
  final bool? topLeading;

  /// Title of bar
  final Widget? title;

  // Padding of the bar
  final EdgeInsetsGeometry? padding;

  /// A widget with action that clear search field.
  /// Typically the cleatAction widget is an Icon or an IconButton.
  final Widget? clearAction;

  /// The decoration of search bar.
  final Decoration? searchBarDecoration;

  /// Elevation of search bar.
  final double searchBarElevation;

  /// Border of search bar.
  final BorderRadiusGeometry? searchBorderRadiusGeometry;

  /// Define style for text in search field.
  final TextStyle? textFieldTextStyle;

  /// Decoration of text in search field.
  final Decoration? textFieldDecoration;

  /// [InputDecoration] of search field.
  final InputDecoration? inputDecoration;

  /// Debouce duration help adjust perfomance.
  final Duration? debounceDuration;

  /// Handle change of search terms.
  final void Function(String?) onChangeSearch;

  /// Determines the condition for the search to be done
  final SearchTermValidator<String>? searchTermValidator;

  @override
  _SimpleSearchBarState createState() => _SimpleSearchBarState();
}

class _SimpleSearchBarState extends State<SimpleSearchBar> {
  var _cancelIsVisible = false;
  final _searchTextFieldController = TextEditingController();
  Timer? _debounce;

  String get _value => _searchTextFieldController.value.text;
  bool get isValid => widget.searchTermValidator?.call(_value) ?? true;

  void _cancel() {
    _searchTextFieldController.clear();
  }

  void _onSearchDebounce(String text) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce =
        Timer(widget.debounceDuration ?? Duration(milliseconds: 500), () {
      final _seachTerm = isValid ? text : null;
      widget.onChangeSearch(_seachTerm);
      setState(() {
        _cancelIsVisible = text.isNotEmpty;
      });
    });
  }

  @override
  void initState() {
    _searchTextFieldController.addListener(() {
      _onSearchDebounce(_searchTextFieldController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchTextFieldController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthMax = MediaQuery.of(context).size.width;

    bool? topLeading = widget.topLeading ?? false;

    Widget? leading = widget.leading;
    if (leading != null && topLeading == false) {
      leading = ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 80),
        child: leading,
      );
    }

    EdgeInsetsGeometry? padding = widget.padding ?? EdgeInsets.all(8);

    Widget? title = widget.title;

    return Material(
      borderRadius: widget.searchBorderRadiusGeometry,
      elevation: widget.searchBarElevation,
      child: Container(
        padding: padding,
        decoration: widget.searchBarDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topLeading ? leading ?? SizedBox.shrink() : SizedBox.shrink(),
            title ?? SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                !topLeading ? leading ?? SizedBox.shrink() : SizedBox.shrink(),
                Flexible(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: _cancelIsVisible ? widthMax * .9 : widthMax,
                    decoration: widget.textFieldDecoration,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Theme(
                        child: TextField(
                          controller: _searchTextFieldController,
                          style: widget.textFieldTextStyle,
                          decoration: widget.inputDecoration,
                        ),
                        data: Theme.of(context).copyWith(
                          primaryColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _cancel,
                  child: AnimatedOpacity(
                    opacity: _cancelIsVisible ? 1.0 : 0,
                    curve: Curves.easeIn,
                    duration:
                        Duration(milliseconds: _cancelIsVisible ? 500 : 0),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: _cancelIsVisible
                          ? MediaQuery.of(context).size.width * .1
                          : 0,
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: widget.clearAction,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
