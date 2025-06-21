
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Get.arguments;

    // Get image URL for recipes or books
    String? imageUrl;
    if (item != null) {
      if (item['strMealThumb'] != null) {
        imageUrl = item['strMealThumb'];
      } else if (item['cover_id'] != null) {
        imageUrl = 'https://covers.openlibrary.org/b/id/${item['cover_id']}-L.jpg';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        centerTitle: true,
        backgroundColor: Colors.blue[50],
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        color: Colors.red.withOpacity(0.2),
        child: item == null
            ? Text("No data.")
            : Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.sp),
              topLeft: Radius.circular(16.sp),
            ),
          ),
          color: Colors.blue[50],
          elevation: 4,
          margin: EdgeInsets.only(top: 32.h),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.sp),
                      child: Image.network(
                        imageUrl,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 180.h,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 2)
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180.h,
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, size: 48.sp),
                        ),
                      ),
                    ),
                  SizedBox(height: 16.h),
                  Text(
                    item['title'] ?? item['strMeal'] ?? '',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    item['volumeInfo']?['description'] ?? item['strInstructions'] ?? 'No description available.',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}