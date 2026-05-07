import 'package:flutter/material.dart';
import 'excel_product_page.dart';
import 'admin_orders_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _adminPages = [
    const ExcelProductsPage(),
    const AdminOrdersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: Row(
        children: [
          // القائمة الجانبية - تعطي مظهر بريميوم للويب
          NavigationRail(
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.white,
            elevation: 1,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            extended:
                MediaQuery.of(context).size.width >
                900, // يتمدد تلقائياً إذا كانت الشاشة واسعة
            leading: Column(
              children: [
                const SizedBox(height: 20),
                // Logo بسيط
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
            unselectedIconTheme: const IconThemeData(color: Color(0xff94A3B8)),
            selectedIconTheme: const IconThemeData(color: Colors.indigo),
            selectedLabelTextStyle: const TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            unselectedLabelTextStyle: const TextStyle(
              color: Color(0xff64748B),
              fontSize: 14,
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag),
                label: Text('Orders'),
              ),
            ],
          ),

          // فاصل رأسي رفيع جداً
          const VerticalDivider(
            thickness: 1,
            width: 1,
            color: Color(0xffE2E8F0),
          ),

          // المحتوى الرئيسي
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _adminPages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
