import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final ScrollController _scrollController = ScrollController();

  HomeView() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (Get.find<HomeController>().selectedType.value == ItemType.recipes) {
          Get.find<HomeController>().loadMoreIfNeeded();
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Items Browser"),
      centerTitle: true,),

      body: Container(
        decoration: BoxDecoration(
          color:
Colors.red.withOpacity(0.2)
        ),
        child: Column(
          children: [
            Obx(
              () => Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(16),
                  borderColor: Colors.blueGrey,
                  selectedBorderColor: Colors.blue,
                  fillColor: Colors.blue.withOpacity(0.15),
                  selectedColor: Colors.white,
                  color: Colors.black,
                  constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
                  isSelected: [
                    controller.selectedType.value == ItemType.recipes,
                    controller.selectedType.value == ItemType.books,
                  ],
                  onPressed: (index) {
                    controller.switchType(ItemType.values[index]);
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Recipes"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text("Books"),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => Padding(
              padding: EdgeInsets.only( bottom: 1,left: 10.sp),
              child: Align(
               alignment:  Alignment.centerLeft,
                child: Text(
                  controller.selectedType.value == ItemType.recipes
                      ? 'Lists of Recipes'
                      : 'Lists of Books',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder:
                        (_, __) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ListTile(
                            title: Container(height: 20, color: Colors.white),
                          ),
                        ),
                  );
                } else {
                  return Container(
                    // margin: const EdgeInsets.symmetric(
                    //   horizontal: 2,
                    //   vertical: 8,
                    // ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(16.sp), topLeft: Radius.circular(16.sp)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8),
                      itemCount: controller.items.length+
                          (controller.selectedType.value == ItemType.recipes &&
                          controller.isLoadingMore.value
                          ? 1
                          : 0),
                        itemBuilder: (context, index) {
                          if (index >= controller.items.length) {
                            return Center(child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ));
                          }
                          var item = controller.items[index];
                          String title = controller.selectedType.value == ItemType.books
                              ? item['volumeInfo']['title'] ?? ''
                              : item['strMeal'];

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.blue[50],
                            child: ListTile(
                              leading: Text(
                                '${index + 1}.',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 15.sp),
                              ),
                              title: Text(title),
                              onTap: () {
                                Get.toNamed('/details-screen', arguments: item);
                              },
                            ),
                          );
                        }
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
