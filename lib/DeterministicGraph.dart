import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:queues/DeterministicCalculations.dart';

class Graph extends StatelessWidget {
  final double arrivalTime;
  final double serviceTime;
  final int SysCapacity;
  DeterministicQueue deterministicQueue;
  Graph({this.arrivalTime, this.serviceTime, this.SysCapacity}) {
    deterministicQueue = DeterministicQueue(
        arrivalTime: arrivalTime,
        serviceTime: serviceTime,
        SysCapacity: SysCapacity);
  }
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(title: AxisTitle(text: 'Time')),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Number of customers')),
      series: <ChartSeries>[
        StepLineSeries<XYgraph, double>(
          dataSource: deterministicQueue.getGraphData(),
          xValueMapper: (XYgraph g, _) => g.time,
          yValueMapper: (XYgraph g, _) => g.NumOfCustomer,
        )
      ],
    );
  }
}
