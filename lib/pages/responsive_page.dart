import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  ResponsivePage({super.key});
  final List<Map<String, dynamic>> jsonData = List.generate(11, (index) {
    return {
      "id": index + 1,
      "title": "Card Title ${index + 1}",
      "description":
          "This is a sample description for card ${index + 1}. It is meant to be approximately 250 characters long so that it can demonstrate wrapping and text truncation in the card layout. Each card will show an image, title, description, and date.",
      "date": "2025-09-${(10 + index).toString().padLeft(2, '0')}",
      "image":
          "https://picsum.photos/200/300?random=${index + 1}" // random placeholder images
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Responsive Cards")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // number of cards per row depends on screen width
            int crossAxisCount = (constraints.maxWidth ~/ 160).clamp(1, 6);

            return GridView.builder(
              itemCount: jsonData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65, // height relative to width
              ),
              itemBuilder: (context, index) {
                final item = jsonData[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          item['image'],
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              item['description'],
                              style: TextStyle(fontSize: 12),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              item['date'],
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
