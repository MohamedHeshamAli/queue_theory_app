import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DeterministicCalculations.dart';
import 'UiResults.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DeterministicResultPage extends StatefulWidget {
  var systemCapacity;
  final double arrivalTime;
  final double serviceTime;
  bool isInfinty = false;
  String systemType;
  DeterministicResultPage(
      {this.systemCapacity, this.serviceTime, this.arrivalTime}) {
    if (systemCapacity == "infinity") {
      systemType = "D/D/1/∞/FCFS";
      isInfinty = true;
    } else {
      systemType = "D/D/1/K-1/FCFS";
    }
  }
  @override
  _DeterministicResultPageState createState() =>
      _DeterministicResultPageState();
}

class _DeterministicResultPageState extends State<DeterministicResultPage> {
  String sysType;
  double arrivalT;
  double serviceT;
  bool IsInfinity;
  int sysCapacity;
  DeterministicQueue deterministicQueue;
  double width;
  String Time;
  String NthCust;
  String waitingTime;
  String custmerNum;
  bool errorTime = false;
  bool errorCNum = false;
  bool errorRange = false;
  String inputRange;
  String inatialCustoers = "";
  bool errorInatialC = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sysType = widget.systemType;
    arrivalT = widget.arrivalTime;
    serviceT = widget.serviceTime;
    IsInfinity = widget.isInfinty;
    if (!IsInfinity) sysCapacity = widget.systemCapacity;
    deterministicQueue = DeterministicQueue(
        arrivalTime: arrivalT,
        serviceTime: serviceT,
        SysCapacity: sysCapacity,
        Isinfinity: IsInfinity);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Queue',
        ),
      ),
      body: ListView(
        children: <Widget>[
          SysInformationsCard(
            width: width - 20,
            informations: " System Type:" + sysType + " ",
          ),
          SysInformationsCard(
            width: width - 20,
            informations: " Block Time=" +
                "${IsInfinity || deterministicQueue.arrivalTime > deterministicQueue.serviceTime ? "∞" : deterministicQueue.blockTime} ",
          ),
          SysInformationsCard(
              width: width - 20,
              result: custmerNum,
              informations: " Customers Number\n at time:",
              widget: textField(
                  error: errorCNum,
                  hint: "Enter a time",
                  SaveVal: (val) {
                    setState(() {
                      Time = val;
                    });
                  })),
          SysInformationsCard(
            width: width - 20,
            result: waitingTime,
            informations: "  Waiting time for  \n customer number"
                " : ",
            widget: textField(
                hint: "Enter customer number",
                error: errorCNum,
                SaveVal: (val) {
                  setState(() {
                    NthCust = val;
                  });
                }),
          ),
          if (arrivalT > serviceT)
            SysInformationsCard(
                width: width - 20,
                informations: " initial customer :",
                widget: textField(
                    error: errorInatialC,
                    hint: "enter appositive integer number",
                    SaveVal: (val) {
                      setState(() {
                        inatialCustoers = val;
                      });
                    })),
          if ((IsInfinity || (arrivalT > serviceT)) &&
              (deterministicQueue.inisialValue == 0))
            SysInformationsCard(
                width: width - 20,
                informations: " X Axis Range :  ",
                widget: textField(
                    error: errorRange,
                    hint: "Enter a time range",
                    SaveVal: (val) {
                      setState(() {
                        inputRange = val;
                      });
                    })),
          deterministicQueue.graph(),
          FloatingActionButton.extended(
            onPressed: () {
              String ErrorMessage = "";
              setState(() {
                custmerNum = "";
                waitingTime = "";
              });
              errorInatialC = false;
              errorRange = false;
              errorTime = false;
              errorCNum = false;
              if (Time != null && Time != "") {
                double time = CheckingDouble(Time, errorTime);
                if (time < 0) {
                  setState(() {
                    errorTime = true;
                  });
                  ErrorMessage += "enter a positive time or keep it empty.\n";
                } else
                  custmerNum = " = " +
                      deterministicQueue.getNumOfCustomers(time).toString() +
                      "     ";
              }
              if (NthCust != null && NthCust != "") {
                int custN = CheckingInt(NthCust, errorCNum);
                if (custN < 0) {
                  setState(() {
                    errorCNum = true;
                  });
                  ErrorMessage += "Enter a positive number or keep it empty.\n";
                } else
                  waitingTime = " = " +
                      deterministicQueue
                          .getWaitingTime(custN)
                          .toStringAsFixed(2) +
                      "   ";
              }
              if (inputRange != null && inputRange != "") {
                double range = CheckingDouble(inputRange, errorRange);
                if (range < 0)
                  setState(() {
                    errorRange = true;
                  });
                else
                  deterministicQueue.Xrange = range;
              }
              if (inatialCustoers != null && inatialCustoers != "") {
                int M = CheckingInt(
                  inatialCustoers,
                  errorInatialC,
                );

                if (M < 0)
                  setState(() {
                    errorInatialC = true;
                  });
                else {
                  setState(() {
                    deterministicQueue.inisialValue = M;
                  });
                }
                if (errorInatialC)
                  ErrorMessage +=
                      "enter a positive number of initial customer.";
              }
              if (errorCNum || errorTime || errorRange || errorInatialC)
                alert(ErrorMessage, context).show();
            },
            backgroundColor: Colors.red,
            label: Text(
              "Calculate",
              style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
