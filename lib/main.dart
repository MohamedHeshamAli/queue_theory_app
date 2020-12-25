import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Random-result-page.dart';
import 'Deterministic-Result_page.dart';

const Color activeColour = Color(0xff1D1E33);
const Color inactiveColour = Color(0xff111328);

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Queues',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xff0A0D22),
        scaffoldBackgroundColor: Color(0xff0A0D22),
      ),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  String arrivalLable = "Arrival Time";
  String serviceLable = "Service Time";
  String arrrivalTime;
  String serviceTime;
  String parallelServer;
  String SysCapacity = "";
  bool isDeterministic = true;
  bool isRandom = false;
  bool arrivalError = false;
  bool serviceError = false;
  bool capacityError = false;
  bool parallelSerError = false;

  String ErrorMessage;
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      centerTitle: true,
      title: const Text(
        'Queue',
      ),
    );
    final double width = MediaQuery.of(context).size.width * 0.5;
    double ScreenHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    double height = (ScreenHeight - 380) > 0
        ? ((isRandom) ? ScreenHeight - 380 : ScreenHeight - 310)
        : 10;
    return Scaffold(
      appBar: appBar,
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              SystemTypebtn(
                  width: width,
                  name: "Deterministic",
                  active: isDeterministic,
                  onTap: () {
                    setState(() {
                      isDeterministic = true;
                      isRandom = false;
                      arrivalLable = "Arrival Time";
                      serviceLable = "Service Time";
                    });
                  }),
              SystemTypebtn(
                  width: width,
                  name: "Random",
                  active: isRandom,
                  onTap: () {
                    setState(() {
                      isDeterministic = false;
                      isRandom = true;
                      arrivalLable = "Average of\n Arrival rate";
                      serviceLable = "Average of Service rate";
                    });
                  }),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          inputField(
              lable: arrivalLable,
              error: arrivalError,
              hint: "Enter a positive number",
              inputType: TextInputType.number,
              onchange: (val) {
                arrrivalTime = val;
              }),
          inputField(
              lable: serviceLable,
              error: serviceError,
              hint: "Enter a positive number",
              inputType: TextInputType.number,
              onchange: (val) {
                serviceTime = val;
              }),
          inputField(
            lable: "System capacity",
            hint: "write infinity  or int numbers",
            error: capacityError,
            onchange: (val) {
              SysCapacity = val;
            },
          ),
          if (isRandom)
            inputField(
                lable: "parallel servers",
                hint: "enter aposituve int",
                error: parallelSerError,
                onchange: (val) {
                  parallelServer = val;
                },
                inputType: TextInputType.numberWithOptions(signed: false)),
          SizedBox(
            height: height,
          ),
          SizedBox(
            width: width * 2,
            child: FloatingActionButton.extended(
              onPressed: () {
                ErrorMessage = "";
                double arrival;
                double service;
                var capacity;
                int parallelS;
                try {
                  List<String> a = arrrivalTime.split("/");
                  if (a.length == 1) {
                    arrival = double.parse(arrrivalTime);
                    if (arrival < 0) {
                      setState(() {
                        arrivalError = true;
                      });
                      ErrorMessage +=
                          "service time & rate must be a positive number.\n";
                    } else
                      setState(() {
                        arrivalError = false;
                      });
                  } else if (a.length > 2) {
                    setState(() {
                      arrivalError = true;
                    });
                    ErrorMessage +=
                        "arrival time & rate must be a positive number.\n";
                  } else {
                    arrival = double.parse(a[0]) / double.parse(a[1]);
                    if (arrival < 0) {
                      setState(() {
                        arrivalError = true;
                      });
                      ErrorMessage +=
                          "service time & rate must be a positive number.\n";
                    } else
                      setState(() {
                        arrivalError = false;
                      });
                  }
                } catch (e) {
                  setState(() {
                    arrivalError = true;
                  });
                  ErrorMessage +=
                      "arrival time & rate must be a positive number.\n";
                }
                try {
                  List<String> s = serviceTime.split("/");
                  if (s.length == 1) {
                    service = double.parse(serviceTime);
                    if (service < 0) {
                      setState(() {
                        serviceError = true;
                      });
                      ErrorMessage +=
                          "service time & rate must be a positive number.\n";
                    } else
                      setState(() {
                        serviceError = false;
                      });
                  } else if (s.length > 2) {
                    setState(() {
                      serviceError = true;
                    });
                    ErrorMessage +=
                        "service time & rate must be a positive number.\n";
                  } else {
                    service = double.parse(s[0]) / double.parse(s[1]);
                    if (service < 0) {
                      setState(() {
                        serviceError = true;
                      });
                      ErrorMessage +=
                          "service time & rate must be a positive number.\n";
                    } else
                      setState(() {
                        serviceError = false;
                      });
                  }
                } catch (e) {
                  setState(() {
                    serviceError = true;
                  });
                  ErrorMessage +=
                      "service time & rate must be a positive number.\n";
                }
                if (SysCapacity.isEmpty || SysCapacity == "infinity") {
                  setState(() {
                    capacityError = false;
                  });
                  capacity = "infinity";
                } else {
                  try {
                    capacity = int.parse(SysCapacity);
                    if (capacity < 0) {
                      setState(() {
                        capacityError = true;
                      });
                      ErrorMessage +=
                          "System capacity must be a positive integer number.";
                    } else
                      setState(() {
                        capacityError = false;
                      });
                  } catch (e) {
                    setState(() {
                      capacityError = true;
                    });
                    ErrorMessage +=
                        "System capacity must be a positive integer number.";
                  }
                }
                if (isRandom) {
                  try {
                    parallelS = int.parse(parallelServer);
                    if (parallelS < 0) {
                      setState(() {
                        parallelSerError = true;
                      });
                      ErrorMessage +=
                          "parallel servers must be a positive integer number.";
                    } else
                      setState(() {
                        parallelSerError = false;
                      });
                  } catch (e) {
                    setState(() {
                      parallelSerError = true;
                    });
                    ErrorMessage +=
                        "parallel servers must be a positive integer number.";
                  }
                }

                if (capacityError == true ||
                    serviceError == true ||
                    arrivalError == true ||
                    parallelSerError) {
                  Alert(
                    context: context,
                    type: AlertType.error,
                    style: AlertStyle(
                        titleStyle: TextStyle(
                          color: Colors.red,
                        ),
                        descStyle: TextStyle(
                          color: Colors.white,
                        )),
                    title: "WRONG INPUT",
                    desc: ErrorMessage,
                    buttons: [
                      DialogButton(
                        child: Text(
                          "CANCEL",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => isRandom
                              ? RandomResultPage(
                                  arrivalRate: arrival,
                                  serviceRate: service,
                                  systemCapacity: capacity,
                                  parallelServers: parallelS,
                                )
                              : DeterministicResultPage(
                                  arrivalTime: arrival,
                                  serviceTime: service,
                                  systemCapacity: capacity,
                                )));
                }
              },
              backgroundColor: Colors.red,
              isExtended: true,
              label: Text(
                "Calculate",
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container inputField(
      {String lable,
      bool error,
      String hint,
      Function onchange(String val),
      TextInputType inputType}) {
    return Container(
      height: 60,
      //padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(
            width: 2,
            color: Colors.white, //error ? Colors.red : activeColour
          )),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 5,
          ),
          Container(
            width: 150,
            child: Text(
              lable + " :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.black),
              onChanged: (val) => onchange(val),
              keyboardType: inputType,
              decoration: InputDecoration(
                icon: error
                    ? Icon(
                        Icons.error,
                        color: Colors.yellow,
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector SystemTypebtn(
      {double width, String name, bool active, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: active ? activeColour : inactiveColour,
            border: active ? Border.all(color: Colors.black, width: 2) : null),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        width: width,
      ),
    );
  }
}
