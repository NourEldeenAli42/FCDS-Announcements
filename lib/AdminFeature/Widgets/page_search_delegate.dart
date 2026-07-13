import 'package:fcds_announcements/AdminFeature/repositories/admin_repository.dart';
import 'package:fcds_announcements/FollowPageFeature/Data%20Models/page_data_model.dart';
import 'package:fcds_announcements/utils/Widgets/text_style.dart';
import 'package:flutter/material.dart';

class PageSearchDelegate extends SearchDelegate<List<PageDataModel>> {
  final String userId;
  List<PageDataModel> pages = [];
  List<PageDataModel> selectedPages = [];
  late final Future<void> _pagesFuture;
  Future<void> _populatePages() async {
    final fetchedPages = await AdminRepository.getPagesWithoutPermissions(
      userId,
    );
    pages.clear();
    pages.addAll(fetchedPages);
  }

  PageSearchDelegate({required this.userId}) {
    _pagesFuture = _populatePages();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              close(context, selectedPages);
            },
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              query = '';
            },
          ),
        ],
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _pagesFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (asyncSnapshot.hasError) {
          return Center(child: Text('Error: ${asyncSnapshot.error}'));
        }

        final results = pages
            .where(
              (page) => page.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        return StatefulBuilder(
          builder: (context, setState) {
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final page = results[index];
                return ListTile(
                  selected: selectedPages.contains(page),
                  selectedColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  title: Text(
                    page.title,
                    style: MyTextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 6, top: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.blueGrey.shade800,
                            ),
                            SizedBox(width: 4),
                            Text(
                              page.hall,
                              style: MyTextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 6, top: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.blueGrey.shade800,
                            ),
                            SizedBox(width: 4),
                            Text(
                              page.startTime.format(context),
                              style: MyTextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 6, top: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.blueGrey.shade800,
                            ),
                            SizedBox(width: 4),
                            Text(
                              page.instructor,
                              style: MyTextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (selectedPages.contains(page)) {
                      setState(() {
                        selectedPages.remove(page);
                      });
                    } else {
                      setState(() {
                        selectedPages.add(page);
                      });
                    }
                    // Refresh the UI
                    showResults(context);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: _pagesFuture,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (asyncSnapshot.hasError) {
          return Center(child: Text('Error: ${asyncSnapshot.error}'));
        }

        final suggestions = pages
            .where(
              (page) => page.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        return StatefulBuilder(
          builder: (context, setState) {
            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final page = suggestions[index];
                return ListTile(
                  selected: selectedPages.contains(page),
                  selectedColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  title: Text(
                    page.title,
                    style: MyTextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 6, top: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.blueGrey.shade800,
                            ),
                            SizedBox(width: 4),
                            Text(
                              page.hall,
                              style: MyTextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 6, top: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.blueGrey.shade800,
                            ),
                            SizedBox(width: 4),
                            Text(
                              page.startTime.format(context),
                              style: MyTextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 6, top: 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.blueGrey.shade800,
                            ),
                            SizedBox(width: 4),
                            Text(
                              page.instructor,
                              style: MyTextStyle(
                                fontSize: 12,
                                color: Colors.blueGrey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (selectedPages.contains(page)) {
                      setState(() {
                        selectedPages.remove(page);
                      });
                    } else {
                      setState(() {
                        selectedPages.add(page);
                      });
                    }
                    // Refresh the UI
                    showSuggestions(context);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
