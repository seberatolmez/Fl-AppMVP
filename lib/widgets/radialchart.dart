import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RadialChartWidget extends StatelessWidget {
  final double percent;
  final Color color ;

  const RadialChartWidget({super.key, required this.percent,required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: percent / 100, // Yüzdeyi 0-1 arasına çevirmek için
            strokeWidth: 16,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Text(
          "${percent.toDouble()} Net",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
