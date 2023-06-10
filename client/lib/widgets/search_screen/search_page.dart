import 'package:client/models/search_item.dart';
import 'package:client/widgets/search_screen/search_list_item.dart';
import 'package:flutter/material.dart';

import '../../services/Nutritionx/nutritionx_api_client.dart';

class SearchPage extends StatelessWidget {
  static const route = '/search';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add Manually'),
        ),
        body: SearchForm(),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;
  List<SearchItem> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void retrieveSearchResults(String query) async {
    try {
      final fetchedItems = await NutritionXApiClient.searchFood(query);
      setState(() {
        _searchResults = fetchedItems;
      });
    } catch (exception) {
      print(exception);
      setState(() {
        _searchResults = [];
      });
    }
  }

  // Initial view when opening this page
  Widget buildDefaultSearchResults() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 70),
        Image.asset(
          'assets/burger.png',
          width: 180,
          height: 180,
        ),
        const SizedBox(height: 40),
        const Text(
          'Type in the name of a food item \n to get started.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            // fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30)
      ],
    );
  }

  Widget buildEmptySearchResults() {
    return Column(
      children: const [
        SizedBox(height: 70),
        Image(
            image: AssetImage('assets/empty_search.png'),
            width: 200,
            height: 200),
        SizedBox(height: 40),
        Text(
          'Sorry, no results found',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "We couldn't find what you searched for.",
          style: TextStyle(fontSize: 16),
        ),
        Text(
          "Please try a different search term.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 30)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  Expanded(
                    child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search for food',
                          contentPadding: EdgeInsets.all(16.0),
                          border: InputBorder.none,
                        ),
                        onChanged: (searchQuery) {
                          retrieveSearchResults(searchQuery);
                        }),
                  ),
                  if (_showClearButton)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _searchResults = [];
                        setState(() {
                          _showClearButton = false;
                        });
                      },
                      child: const Icon(Icons.clear),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
            buildEmptySearchResults()
          else if (_searchResults.isEmpty && _searchController.text.isEmpty)
            buildDefaultSearchResults()
          else
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) =>
                  Divider(thickness: 1.0, color: Colors.grey[400]),
              itemBuilder: (context, index) {
                return SearchListItem(_searchResults[index]);
              },
            )
        ],
      ),
    );
  }
}
