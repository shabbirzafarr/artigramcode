import 'package:artplace/Core/Widget/Searchuserbar.dart';

import 'package:flutter/material.dart';


import '../../../Core/Utils/ErrorText.dart';
class SearchUserDelegate extends SearchDelegate {

   @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }
  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }
   @override
  Widget buildSuggestions(BuildContext context) {
      return UserListTitle(query);
  }
  void navigateToCommunity(BuildContext context, String communityName) {
    
  }
}