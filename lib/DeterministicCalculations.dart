import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DeterministicQueue {
  bool Isinfinity;
  final double arrivalTime;
  final double serviceTime;
  final int SysCapacity;
  double Xrange = 30;
  int inisialValue = 0;
  double blockTime; //bock time
  int Nt; //number in the system at time (t) including the customer in service.
  double
      Wqn; //the time that the nth customer must wait in the queue to get service
  DeterministicQueue(
      {this.arrivalTime, this.serviceTime, this.SysCapacity, this.Isinfinity}) {
    setbolckTime();
  }
  void setbolckTime() {
    if (Isinfinity || arrivalTime >= serviceTime) return;
    double arrivalRate = 1 / arrivalTime;
    double serviceRate = 1 / serviceTime;
    blockTime = double.parse(
        (((SysCapacity + 1) - (serviceRate / arrivalRate)) /
                (arrivalRate - serviceRate))
            .toStringAsFixed(2));
    double ti = blockTime;
    ti = ti - arrivalTime;

    while ((SysCapacity + 1) <=
        ((ti / arrivalTime).toInt() -
            (ti / serviceTime - (arrivalTime / serviceTime)).toInt())) {
      blockTime = ti;
      ti = ti - arrivalTime;
    }
  }

  List<XYgraph> getGraphData() {
    List<XYgraph> graphList = <XYgraph>[];
    graphList.clear();
    if (inisialValue != 0) {
      int n = inisialValue;
      graphList.add(XYgraph(time: 0, NumOfCustomer: n));
      double ti = arrivalTime;
      double to = serviceTime;
      while (n > 0) {
        if (ti < to) {
          n = inisialValue +
              (ti / arrivalTime).floor() -
              (ti / serviceTime).floor();
          graphList.add(XYgraph(NumOfCustomer: n, time: ti));
          ti += arrivalTime;
        } else if (ti == to) {
          graphList.add(XYgraph(NumOfCustomer: n, time: ti));
          ti += arrivalTime;
          to += serviceTime;
        } else {
          n = inisialValue +
              (to / arrivalTime).floor() -
              (to / serviceTime).floor();
          graphList.add(XYgraph(NumOfCustomer: n, time: to));
          to += serviceTime;
        }
      }
      graphList.add(XYgraph(NumOfCustomer: 1, time: ti));
      return graphList;
    }
    if (arrivalTime > serviceTime) {
      graphList.add(XYgraph(time: 0, NumOfCustomer: 0));
      double ti = arrivalTime;
      double to = ti + serviceTime;
      while (ti <= Xrange) {
        graphList.add(XYgraph(time: ti, NumOfCustomer: 1));
        ti += arrivalTime;
        graphList.add(XYgraph(time: to, NumOfCustomer: 0));
        to = ti + serviceTime;
      }
      return graphList;
    }

    if (Isinfinity == true || arrivalTime >= serviceTime)
      blockTime = Xrange + 1;
    else {
      setbolckTime();
    }
    graphList.add(XYgraph(time: 0, NumOfCustomer: 0));
    graphList.add(XYgraph(time: arrivalTime, NumOfCustomer: 1));
    if (arrivalTime == serviceTime) {
      graphList.add(XYgraph(time: blockTime - 1, NumOfCustomer: 1));
      return graphList;
    }

    int CustNum = 1;
    double CustOutTime = arrivalTime + serviceTime; //وقت خروج العميل بعد خدمته
    double CustInTime = arrivalTime * 2; //وقت دخول عميل جديد
    while (CustInTime <= blockTime) {
      if (CustInTime < CustOutTime) {
        CustNum++;
        graphList.add(XYgraph(time: CustInTime, NumOfCustomer: CustNum));
        CustInTime += arrivalTime;
      } else if (CustOutTime == CustInTime) {
        graphList.add(XYgraph(time: CustInTime, NumOfCustomer: CustNum));
        CustInTime += arrivalTime;
        CustOutTime += serviceTime;
      } else {
        CustNum--;
        graphList.add(XYgraph(time: CustOutTime, NumOfCustomer: CustNum));
        CustOutTime += serviceTime;
      }
    }
    if (!Isinfinity && arrivalTime < serviceTime) {
      graphList.removeLast();
      graphList.add(XYgraph(time: blockTime, NumOfCustomer: SysCapacity));
    }
    return graphList;
  }

  int getNumOfCustomers(double time) {
    if (inisialValue != 0) {
      int n = (inisialValue +
          (time / arrivalTime).floor() -
          (time / serviceTime).floor());
      if (n >= 0)
        return n;
      else
        return time > (time / arrivalTime).floor() * arrivalTime + serviceTime
            ? 0
            : 1;
    }
    if (time < arrivalTime) return 0;
    if (time == arrivalTime) return 1;
    if (arrivalTime == serviceTime) return 1;
    if (Isinfinity) {
      return (time / arrivalTime).toInt() -
          (time / serviceTime - (arrivalTime / serviceTime)).toInt();
    }
    if (arrivalTime > serviceTime) {
      return time > ((time / arrivalTime).floor() * arrivalTime + serviceTime)
          ? 0
          : 1;
    }
    setbolckTime();
    if (time < blockTime)
      return (time / arrivalTime).toInt() -
          (time / serviceTime - (arrivalTime / serviceTime)).toInt();
    else {
      if (((arrivalTime / serviceTime).floor() - (arrivalTime / serviceTime)) ==
          0) return SysCapacity;
      int CustNum = 1;
      double CustOutTime =
          arrivalTime + serviceTime; //وقت خروج العميل بعد خدمته
      double CustInTime = arrivalTime * 2; //وقت دخول عميل جديد
      while (CustInTime < time) {
        if (CustInTime < CustOutTime) {
          if (CustNum != SysCapacity) CustNum++;
          CustInTime += arrivalTime;
        } else if (CustOutTime == CustInTime) {
          CustInTime += arrivalTime;
          CustOutTime += serviceTime;
        } else {
          CustNum--;
          CustOutTime += serviceTime;
        }
      }
      return CustNum;
    }
  }

  double getWaitingTime(int n) {
    if (inisialValue != 0) {
      if (n == 0)
        return (inisialValue - 1) * (serviceTime) / (2);
      else {
        double wq = (inisialValue + n - 1) * serviceTime - n * arrivalTime;
        return wq > 0 ? wq : 0;
      }
    }
    if (n <= 1 || arrivalTime >= serviceTime) {
      return 0.0;
    }
    if (n < ((1 / arrivalTime) * blockTime) || Isinfinity == true) {
      return (serviceTime - arrivalTime) * (n - 1);
    } else {
      if (((arrivalTime / serviceTime).floor() - (arrivalTime / serviceTime)) ==
          0)
        return (serviceTime - arrivalTime) * (arrivalTime * blockTime - 2);
      else {
        if (getNumOfCustomers((n) * arrivalTime) == SysCapacity)
          return (serviceTime - arrivalTime) *
              (1 / arrivalTime * blockTime - 2);
        else
          return (serviceTime - arrivalTime) * (arrivalTime * blockTime - -3);
      }
    }
  }

  Widget graph() {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(title: AxisTitle(text: 'Time')),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Number of customers')),
      series: <ChartSeries>[
        StepLineSeries<XYgraph, double>(
          dataSource: getGraphData(),
          xValueMapper: (XYgraph g, _) => g.time,
          yValueMapper: (XYgraph g, _) => g.NumOfCustomer,
        )
      ],
    );
  }
}

class XYgraph {
  final double time;
  final int NumOfCustomer;
  XYgraph({this.time, this.NumOfCustomer});
}
