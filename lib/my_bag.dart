import 'package:flutter/material.dart';
import 'package:golfy/constants.dart';
import 'bag_category.dart';
import 'mybag_services.dart';

class MyBag extends StatelessWidget {
  const MyBag({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<BagCategory> categories =
    MyBagServices.getCategories();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: TopBar(
        showBackButton: true,
        backgroundColor: isDark? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary ,
        route: '/homePage',
        title: 'M Y  B A G',
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    categories[index].category,
                    style:  TextStyle(
                        fontWeight: FontWeight.w400,
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.onSurface
                    ),
                  ),
                  trailing:  Icon(Icons.arrow_forward_ios, size: 20, color: Theme.of(context).colorScheme.onSurface,),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/bagClubs',
                      arguments: categories[index].category,
                    );
                  },
                );
              },

            ),
          ),
        ),
      ),
    );
  }
}
