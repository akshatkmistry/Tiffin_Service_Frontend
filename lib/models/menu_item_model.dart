class MenuItem {
  final String id;
  final String name;
  final double price;
  final bool isVeg;
  final String description;
  final String image;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.isVeg,
    required this.description,
    required this.image,
  });
}

class TiffinService {
  final String id;
  final String name;
  final double rating;
  final String cuisine;
  final String distance;
  final String image;
  final List<MenuItem> menu;

  TiffinService({
    required this.id,
    required this.name,
    required this.rating,
    required this.cuisine,
    required this.distance,
    required this.image,
    required this.menu,
  });

  static List<TiffinService> getFeaturedServices() {
    return [
      TiffinService(
        id: 'service_1',
        name: 'Gujarati Tiffin Service',
        rating: 4.5,
        cuisine: 'Gujarati',
        distance: '1.2 km',
        image: 'assets/icon/gujarati_thali.svg',
        menu: [
          MenuItem(
            id: 'item_1_1',
            name: 'Basic Gujarati Thali',
            price: 120.0,
            isVeg: true,
            description: 'Rotli, Dal, Rice, 2 Vegetables, Kathol, Salad',
            image: 'assets/icon/basic_thali.svg',
          ),
          MenuItem(
            id: 'item_1_2',
            name: 'Premium Gujarati Thali',
            price: 150.0,
            isVeg: true,
            description: 'Rotli, Dal Fry, Jeera Rice, 3 Vegetables, Kathol, Salad, Sweet',
            image: 'assets/icon/premium_thali.svg',
          ),
        ],
      ),
      TiffinService(
        id: 'service_2',
        name: 'Punjabi Tiffin Service',
        rating: 4.3,
        cuisine: 'Punjabi',
        distance: '2.1 km',
        image: 'assets/icon/punjabi_thali.svg',
        menu: [
          MenuItem(
            id: 'item_2_1',
            name: 'Veg Punjabi Thali',
            price: 130.0,
            isVeg: true,
            description: 'Roti, Dal Makhani, Rice, Paneer Dish, Salad',
            image: 'assets/icon/veg_punjabi.svg',
          ),
          MenuItem(
            id: 'item_2_2',
            name: 'Non-Veg Punjabi Thali',
            price: 160.0,
            isVeg: false,
            description: 'Roti, Dal, Rice, Chicken Curry, Salad',
            image: 'assets/icon/nonveg_punjabi.svg',
          ),
        ],
      ),
      TiffinService(
        id: 'service_3',
        name: 'South Indian Tiffin',
        rating: 4.4,
        cuisine: 'South Indian',
        distance: '1.8 km',
        image: 'assets/icon/south_indian_thali.svg',
        menu: [
          MenuItem(
            id: 'item_3_1',
            name: 'South Indian Veg Meal',
            price: 110.0,
            isVeg: true,
            description: 'Rice, Sambar, Rasam, 2 Vegetables, Curd',
            image: 'assets/icon/south_indian_meal.svg',
          ),
          MenuItem(
            id: 'item_3_2',
            name: 'Special South Indian Thali',
            price: 140.0,
            isVeg: true,
            description: 'Rice, Sambar, Rasam, 3 Vegetables, Curd, Payasam',
            image: 'assets/icon/special_south_indian.svg',
          ),
        ],
      ),
    ];
  }
}