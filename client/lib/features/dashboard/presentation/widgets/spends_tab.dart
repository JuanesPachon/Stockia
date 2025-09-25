import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'stat_card.dart';
import 'top_list_card.dart';
import 'items_list_card.dart';
import 'detail_card.dart';

class GastosTab extends StatelessWidget {
  const GastosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatCard(label: 'Gastos totales:', value: '29', isEven: true),
          StatCard(label: 'Total dinero en gastos:', value: '\$1.245.000', isEven: true),

          const SizedBox(height: 5),

          TopListCard(
            title: 'Categorías con más gastos:',
            items: ['Comida', 'Servicios', 'Arriendo'],
          ),

          ItemListCard(
            title: 'Últimos gastos:',
            items: [
              {'Gasto #290': '\$100.000'},
              {'Gasto #289': '\$100.000'},
              {'Gasto #288': '\$100.000'},
            ],
          ),

          Container(height: 40, color: AppColors.mainBlue),

          DetailCard(
            title: 'Detalle por categoría:',
            dropdowns: [
              {'Rango de tiempo:': 'Hoy'},
              {'Categoría:': 'Selecciona'},
            ],
            stats: [
              {'Cantidad de gastos:': '15'},
              {'Dinero en gastos:': '\$34.000'},
            ],
          ),
        ],
      ),
    );
  }
}