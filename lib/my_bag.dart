import 'package:flutter/material.dart';
import 'bag_category.dart';
import 'mybag_services.dart';

class MyBag extends StatelessWidget {
  const MyBag({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final List<BagCategory> categories =
    MyBagServices.getCategories();

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text(
          'M Y  B A G',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: height * 0.025,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[100],
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.separated(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    categories[index].category,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/bagClubs',
                      arguments: categories[index].category,
                    );
                  },
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 1),
            ),
          ),
        ),
      ),
    );
  }
}
