import 'package:client/core/constants/app_routes.dart';
import 'package:client/shared/widgets/app_navbar.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/sells_tab.dart';
import '../widgets/spends_tab.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  int _currentBottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      appBar: AppBar(
        backgroundColor: AppColors.mainWhite,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/stockia_logo.png',
          height: 50,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.mainBlue, width: 1),
                bottom: BorderSide(color: AppColors.mainBlue, width: 1),
              )
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.mainBlue,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
              indicator: BoxDecoration(
                color: AppColors.mainBlue.withValues(alpha: 0.2),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: AppColors.mainBlue,
              tabs: const [
                Tab(text: 'Ventas'),
                Tab(text: 'Gastos'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          VentasTab(),
          GastosTab(),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
          
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.management);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.settings);
              break;
          }
        },
      ),
    );
  }
}