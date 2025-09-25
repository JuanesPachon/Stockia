import 'package:client/features/dashboard/presentation/widgets/top_list_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'stat_card.dart';
import 'items_list_card.dart';
import 'detail_card.dart';

class VentasTab extends StatelessWidget {
  const VentasTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatCard(label: 'Ventas totales:', value: '29', isEven: true),
          StatCard(label: 'Total dinero en ventas:', value: '\$1.245.000', isEven: true),

          const SizedBox(height: 5),

          TopListCard(
            title: 'Productos mas vendidos:',
            items: ['Empanada', 'Pan de yuca', 'Torta'],
          ),

          ItemListCard(
            title: 'Últimas ventas:',
            items: [
              {'Venta #1': '\$45.000'},
              {'Venta #2': '\$120.000'},
              {'Venta #3': '\$15.000'},
            ],
          ),

          Container(height: 40, color: AppColors.mainBlue),

          DetailCard(
            title: 'Detalle por producto(s):',
            dropdowns: [
              {'Rango de tiempo:': 'Hoy'},
              {'Producto:': 'Todos'},
            ],
            stats: [
              {'Unidades vendidas:': '6'},
              {'Total dinero en ventas:': '\$12.000'},
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
              {'Unidades vendidas:': '15'},
              {'Dinero en ventas:': '\$34.000'},
            ],
          ),
        ],
      ),
    );
  }
}
