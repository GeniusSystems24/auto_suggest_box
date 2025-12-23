/// Sample data models and mock data for the example app

class Country {
  final String code;
  final String name;
  final String flag;
  final String continent;

  const Country({
    required this.code,
    required this.name,
    required this.flag,
    required this.continent,
  });
}

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    this.inStock = true,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String department;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.department,
  });
}

// Sample Countries
const List<Country> sampleCountries = [
  Country(code: 'US', name: 'United States', flag: '🇺🇸', continent: 'North America'),
  Country(code: 'UK', name: 'United Kingdom', flag: '🇬🇧', continent: 'Europe'),
  Country(code: 'FR', name: 'France', flag: '🇫🇷', continent: 'Europe'),
  Country(code: 'DE', name: 'Germany', flag: '🇩🇪', continent: 'Europe'),
  Country(code: 'JP', name: 'Japan', flag: '🇯🇵', continent: 'Asia'),
  Country(code: 'CN', name: 'China', flag: '🇨🇳', continent: 'Asia'),
  Country(code: 'IN', name: 'India', flag: '🇮🇳', continent: 'Asia'),
  Country(code: 'BR', name: 'Brazil', flag: '🇧🇷', continent: 'South America'),
  Country(code: 'AU', name: 'Australia', flag: '🇦🇺', continent: 'Oceania'),
  Country(code: 'CA', name: 'Canada', flag: '🇨🇦', continent: 'North America'),
  Country(code: 'IT', name: 'Italy', flag: '🇮🇹', continent: 'Europe'),
  Country(code: 'ES', name: 'Spain', flag: '🇪🇸', continent: 'Europe'),
  Country(code: 'MX', name: 'Mexico', flag: '🇲🇽', continent: 'North America'),
  Country(code: 'KR', name: 'South Korea', flag: '🇰🇷', continent: 'Asia'),
  Country(code: 'RU', name: 'Russia', flag: '🇷🇺', continent: 'Europe'),
  Country(code: 'SA', name: 'Saudi Arabia', flag: '🇸🇦', continent: 'Asia'),
  Country(code: 'AE', name: 'United Arab Emirates', flag: '🇦🇪', continent: 'Asia'),
  Country(code: 'EG', name: 'Egypt', flag: '🇪🇬', continent: 'Africa'),
  Country(code: 'ZA', name: 'South Africa', flag: '🇿🇦', continent: 'Africa'),
  Country(code: 'NG', name: 'Nigeria', flag: '🇳🇬', continent: 'Africa'),
];

// Sample Products
const List<Product> sampleProducts = [
  Product(id: '1', name: 'MacBook Pro 16"', category: 'Electronics', price: 2499.99, description: 'Apple M3 Pro chip, 18GB RAM'),
  Product(id: '2', name: 'iPhone 15 Pro', category: 'Electronics', price: 999.99, description: 'A17 Pro chip, Titanium design'),
  Product(id: '3', name: 'AirPods Pro 2', category: 'Electronics', price: 249.99, description: 'Active noise cancellation'),
  Product(id: '4', name: 'iPad Air', category: 'Electronics', price: 599.99, description: 'M1 chip, 10.9-inch display'),
  Product(id: '5', name: 'Apple Watch Ultra', category: 'Electronics', price: 799.99, description: 'Titanium case, GPS + Cellular'),
  Product(id: '6', name: 'Nike Air Max', category: 'Footwear', price: 129.99, description: 'Running shoes with Air cushioning'),
  Product(id: '7', name: 'Levi\'s 501 Jeans', category: 'Clothing', price: 79.99, description: 'Original fit denim jeans'),
  Product(id: '8', name: 'Sony WH-1000XM5', category: 'Electronics', price: 349.99, description: 'Wireless noise canceling headphones'),
  Product(id: '9', name: 'Samsung Galaxy S24', category: 'Electronics', price: 899.99, description: 'AI-powered smartphone'),
  Product(id: '10', name: 'Dyson V15', category: 'Home', price: 749.99, description: 'Cordless vacuum cleaner'),
  Product(id: '11', name: 'Nintendo Switch OLED', category: 'Gaming', price: 349.99, description: 'Hybrid gaming console'),
  Product(id: '12', name: 'PlayStation 5', category: 'Gaming', price: 499.99, description: 'Next-gen gaming console'),
  Product(id: '13', name: 'Xbox Series X', category: 'Gaming', price: 499.99, description: 'Microsoft gaming console'),
  Product(id: '14', name: 'Kindle Paperwhite', category: 'Electronics', price: 139.99, description: 'E-reader with 6.8" display'),
  Product(id: '15', name: 'Instant Pot Duo', category: 'Home', price: 89.99, description: '7-in-1 electric pressure cooker'),
];

// Sample Users
const List<User> sampleUsers = [
  User(id: '1', name: 'John Smith', email: 'john.smith@example.com', avatar: 'JS', department: 'Engineering'),
  User(id: '2', name: 'Sarah Johnson', email: 'sarah.j@example.com', avatar: 'SJ', department: 'Design'),
  User(id: '3', name: 'Michael Brown', email: 'm.brown@example.com', avatar: 'MB', department: 'Marketing'),
  User(id: '4', name: 'Emily Davis', email: 'emily.d@example.com', avatar: 'ED', department: 'Sales'),
  User(id: '5', name: 'David Wilson', email: 'd.wilson@example.com', avatar: 'DW', department: 'Engineering'),
  User(id: '6', name: 'Jessica Taylor', email: 'j.taylor@example.com', avatar: 'JT', department: 'HR'),
  User(id: '7', name: 'Chris Anderson', email: 'c.anderson@example.com', avatar: 'CA', department: 'Finance'),
  User(id: '8', name: 'Amanda Thomas', email: 'a.thomas@example.com', avatar: 'AT', department: 'Engineering'),
  User(id: '9', name: 'Robert Martinez', email: 'r.martinez@example.com', avatar: 'RM', department: 'Design'),
  User(id: '10', name: 'Lisa Garcia', email: 'l.garcia@example.com', avatar: 'LG', department: 'Marketing'),
];

// Simple fruit list for basic examples
const List<String> fruits = [
  'Apple',
  'Apricot',
  'Avocado',
  'Banana',
  'Blackberry',
  'Blueberry',
  'Cherry',
  'Coconut',
  'Date',
  'Dragon Fruit',
  'Fig',
  'Grape',
  'Grapefruit',
  'Guava',
  'Kiwi',
  'Lemon',
  'Lime',
  'Mango',
  'Melon',
  'Nectarine',
  'Orange',
  'Papaya',
  'Passion Fruit',
  'Peach',
  'Pear',
  'Pineapple',
  'Plum',
  'Pomegranate',
  'Raspberry',
  'Strawberry',
  'Watermelon',
];

// Mock API search function
Future<List<Product>> searchProducts(String query) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));

  if (query.isEmpty) return [];

  return sampleProducts
      .where((p) =>
          p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.category.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

Future<List<User>> searchUsers(String query) async {
  await Future.delayed(const Duration(milliseconds: 300));

  if (query.isEmpty) return [];

  return sampleUsers
      .where((u) =>
          u.name.toLowerCase().contains(query.toLowerCase()) ||
          u.email.toLowerCase().contains(query.toLowerCase()) ||
          u.department.toLowerCase().contains(query.toLowerCase()))
      .toList();
}

Future<List<Country>> searchCountries(String query) async {
  await Future.delayed(const Duration(milliseconds: 200));

  if (query.isEmpty) return [];

  return sampleCountries
      .where((c) =>
          c.name.toLowerCase().contains(query.toLowerCase()) ||
          c.code.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
