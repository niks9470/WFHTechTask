import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum ItemType { recipes, books }

class HomeController extends GetxController {
  var selectedType = ItemType.recipes.obs;
  var isLoading = true.obs;
  var isLoadingMore = false.obs;

  var books = [].obs;
  var recipes = [].obs;

  int _recipeOffset = 0;
  final int _pageSize = 20;
  List _allMeals = [];

  List get items =>
      selectedType.value == ItemType.books ? books : recipes;

  @override
  void onInit() {
    fetchAllItems();
    super.onInit();
  }

  void switchType(ItemType type) {
    selectedType.value = type;
  }

  void fetchAllItems() async {
    isLoading(true);
    _recipeOffset = 0;
    _allMeals.clear();
    recipes.clear();

    final booksUrl =
        "https://www.googleapis.com/books/v1/volumes?q=subject:fiction&maxResults=10";
    final letters = ['a', 'b', 'c', 'd', 'e','f','g']; // More letters = more recipes

    try {
      // Start fetching books
      final bookFuture = http.get(Uri.parse(booksUrl));

      // Fetch multiple recipe lists
      final recipeFutures = letters.map((letter) {
        final url =
            "https://www.themealdb.com/api/json/v1/1/search.php?f=$letter";
        return http.get(Uri.parse(url));
      }).toList();

      // Wait for all requests together (books + recipes)
      final responses = await Future.wait([bookFuture, ...recipeFutures]);

      final bookData = json.decode(responses[0].body);
      books.value = bookData['items'] ?? [];

      List allMeals = [];
      for (int i = 1; i < responses.length; i++) {
        final data = json.decode(responses[i].body);
        if (data['meals'] != null) {
          allMeals.addAll(data['meals']);
        }
      }
      _allMeals = allMeals;
      _loadMoreRecipes();
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading(false);
    }
  }
  void _loadMoreRecipes() {
    if (_recipeOffset >= _allMeals.length) return;
    final nextOffset = (_recipeOffset + _pageSize).clamp(0, _allMeals.length);
    recipes.addAll(_allMeals.sublist(_recipeOffset, nextOffset));
    _recipeOffset = nextOffset;
  }
  void loadMoreIfNeeded() {
    if (isLoadingMore.value || isLoading.value) return;
    isLoadingMore(true);
    Future.delayed(Duration(milliseconds: 300), () {
      _loadMoreRecipes();
      isLoadingMore(false);
    });
  }
}
