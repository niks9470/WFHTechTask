

## Experience

This project was built using Flutter with GetX for state management. The development process involved integrating multiple APIs, managing state reactively, and implementing infinite scrolling for recipes. The app was tested on Windows and Android platforms.

## Features Implemented

- Browse and toggle between Recipes and Books.
- Fetch data from TheMealDB and Google Books APIs.
- Infinite scroll for recipes with lazy loading.
- Shimmer loading effect for better UX.
- Detailed view for each item with images and descriptions.
- Responsive UI using `flutter_screenutil`.

## Challenges Faced
- In Api integration
- Managing different data structures from two APIs (recipes vs. books).
- Implementing smooth infinite scroll and loading indicators.
- Ensuring UI responsiveness across devices.

## Assumptions Made

- The app only fetches fiction books and recipes starting with certain letters.
- Book details are shown using the `volumeInfo` field.
- Recipe details are shown using `strMeal` and `strInstructions`.
- Error handling is basic and prints errors to the console
