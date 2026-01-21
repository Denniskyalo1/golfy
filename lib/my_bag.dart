import 'package:flutter/material.dart';
import 'bag_category.dart';
import 'mybag_services.dart';

class MyBag extends StatefulWidget {
  const MyBag({super.key});

  @override
  State<MyBag> createState() => _MyBagState();
}

class _MyBagState extends State<MyBag> {
  late Future<List<BagCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = MyBagServices.getCategories();
  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text(
          'M Y  B A G ',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: height * 0.025,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[100],
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
            child:
            FutureBuilder<List<BagCategory>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                // 1️⃣ Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }

                // 2️⃣ Error state
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                // 3️⃣ Success state
                final categories = snapshot.data!;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(categories[index].category),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/bagClubs',
                          arguments: categories[index].category,
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                );
              },
            ),

          ),
          ),
        ),
      );
  }
}

