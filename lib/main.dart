import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useless_gifts_shopping_mall/providers/cart_provider.dart';
import 'package:useless_gifts_shopping_mall/providers/product_provider.dart';
import 'package:useless_gifts_shopping_mall/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: '이걸 왜 팔아?',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
