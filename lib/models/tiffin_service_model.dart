import 'package:tiffin_app/models/menu_item_model.dart';

class TiffinService {
  final String id;
  final String name;
  final String image;
  final double rating;
  final String cuisine;
  final String distance;
  final List<MenuItem> menu;

  TiffinService({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.cuisine,
    required this.distance,
    required this.menu,
  });

  static List<TiffinService> getFeaturedServices() {
    return [
      TiffinService(
        id: 'service_1',
        name: 'Gujarati Tiffin Service',
        image: 'assets/images/gujarati_thali.jpg',
        rating: 4.5,
        cuisine: 'Gujarati',
        distance: '2.5 km',
        menu: [
          MenuItem(
            id: 'item_1',
            name: 'Gujarati Thali',
            description: 'Complete Gujarati meal with rotis, dal, rice, and sabzi',
            price: 150.0,
            isVeg: true,
            image: 'assets/images/gujarati_thali.jpg',
          ),
          MenuItem(
            id: 'item_2',
            name: 'Mini Thali',
            description: 'Light Gujarati meal with 2 rotis, dal, and sabzi',
            price: 120.0,
            isVeg: true,
            image: 'assets/images/gujarati_thali.jpg',
          ),
        ],
      ),
      TiffinService(
        id: 'service_2',
        name: 'Punjabi Tiffin Service',
        image: 'assets/images/punjabi_thali.jpg',
        rating: 4.3,
        cuisine: 'Punjabi',
        distance: '3.0 km',
        menu: [
          MenuItem(
            id: 'item_3',
            name: 'Punjabi Thali',
            description: 'Complete Punjabi meal with naan, dal makhani, and paneer',
            price: 180.0,
            isVeg: true,
            image: 'assets/images/punjabi_thali.jpg',
          ),
          MenuItem(
            id: 'item_4',
            name: 'Non-Veg Special',
            description: 'Special thali with butter chicken and naan',
            price: 220.0,
            isVeg: false,
            image: 'assets/images/punjabi_thali.jpg',
          ),
        ],
      ),
    ];
  }
}