import 'package:flutter/material.dart';
import 'UiResults.dart';
import 'package:queues/RandomTypesCalculation.dart';

class RandomResultPage extends StatefulWidget {
  var systemCapacity;
  final double arrivalRate;
  final double serviceRate;
  final int parallelServers;
  var SysType;
  RandomResultPage(
      {this.arrivalRate,
      this.serviceRate,
      this.systemCapacity,
      this.parallelServers});

  @override
  _RandomResultPageState createState() => _RandomResultPageState();
}

class _RandomResultPageState extends State<RandomResultPage> {
  double arrivalRate;
  double serveceRate;
  var systemCapacity;
  String systemType;
  int parallelServers;
  Random random;
  double ScreenWidth;
  String CustNum;
  String probability;
  bool error = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    arrivalRate = widget.arrivalRate;
    serveceRate = widget.serviceRate;
    systemCapacity = widget.systemCapacity;
    parallelServers = widget.parallelServers;
    random = Random(
        parallelServers: parallelServers,
        serviceRateAvarage: serveceRate,
        arrivalRateAvarage: arrivalRate,
        Capacity: systemCapacity);
  }

  @override
  Widget build(BuildContext context) {
    ScreenWidth = MediaQuery.of(context).size.width;
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
            width: ScreenWidth - 20,
            informations: " System Type: " + random.SystemType + " ",
          ),
          SysInformationsCard(
            width: ScreenWidth - 20,
            informations: "  Expected number of customers  "
                    "  \n in the system at any time: " +
                random.SystemCustomerNum().toStringAsFixed(3) +
                " ",
          ),
          SysInformationsCard(
            width: ScreenWidth - 20,
            informations: "  Expected number of customers  "
                    "  \n in the queue at any time: " +
                random.QueueCustomerNum().toStringAsFixed(3) +
                " ",
          ),
          SysInformationsCard(
            width: ScreenWidth - 20,
            informations: " Expected waiting time in the  system:\n " +
                " " +
                random.SystemWaitingTime().toStringAsFixed(3) +
                " ",
          ),
          SysInformationsCard(
            width: ScreenWidth - 20,
            informations: " Expected waiting time in the  queue:\n " +
                " " +
                random.QueueWaitingTime().toStringAsFixed(3) +
                " ",
          ),
          SysInformationsCard(
              informations: "probability of customers \nin the System P(n) :",
              widget: textField(
                  error: error,
                  hint: "enter Number of customers",
                  SaveVal: (val) {
                    CustNum = val;
                  }),
              result: probability),
          FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  error = false;
                  probability = "";
                });
                if (CustNum != null && CustNum != "") {
                  int numberOfCust = CheckingInt(CustNum, error);
                  if (numberOfCust < 0)
                    setState(() {
                      error = true;
                    });
                  else
                    setState(() {
                      probability = " " +
                          (random.getCustomerNumProbability(numberOfCust) * 100)
                              .toStringAsFixed(2) +
                          "%";
                    });
                }
                if (error == true)
                  alert("Enter a positive integer number", context).show();
              },
              backgroundColor: Colors.red,
              label: Text(
                "Calculate",
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              )),
        ],
      ),
    );
  }
}
