import 'dart:math';

void main() {
  RegExp regExp = new RegExp(
      "(\[0-9]*(\.?)[0-9]+(\/?)[0-9]+)|(\[0-9]*(\.?)[0-9]+\/[0-9]*(\.?)[0-9]+)"
      "|[0-9]");
  print(regExp.stringMatch("(95/5.5)fff"));
  // Random random = Random(
  //     Capacity: "infinity",
  //     arrivalRateAvarage: 6,
  //     serviceRateAvarage: 3,
  //     parallelServers: 3);
  // print(random.SystemType);
  // print(random.QueueCustomerNum());
  // print(random.SystemWaitingTime());
}

class Random {
  final double arrivalRateAvarage;
  final double serviceRateAvarage;
  final String Capacity;
  String SystemType;
  int SysCapacity;
  double trafficIntensity;
  final int parallelServers;
  Random(
      {this.arrivalRateAvarage,
      this.serviceRateAvarage,
      this.Capacity,
      this.parallelServers}) {
    if (Capacity.isNotEmpty || Capacity != "infinity") {
      try {
        SysCapacity = double.parse(Capacity).round();
      } catch (e) {
        print(e);
      }
    }
    SystemType = getSystemType();
    trafficIntensity =
        (arrivalRateAvarage / serviceRateAvarage) / parallelServers;
  }
  String getSystemType() {
    if (parallelServers == 1 && (Capacity.isEmpty || Capacity == "infinity"))
      return "M/M/1/∞/FCFS";
    else if (parallelServers == 1 &&
        (Capacity.isNotEmpty || Capacity != "infinity"))
      return "M/M/1/K/FCFS";
    else if (parallelServers != 1 &&
        (Capacity.isEmpty || Capacity == "infinity"))
      return "M/M/C/∞/FCFS";
    else
      return "M/M/C/K/FCFS";
  }

  double SystemCustomerNum() {
    if (SystemType == "M/M/1/∞/FCFS")
      return (arrivalRateAvarage / (serviceRateAvarage - arrivalRateAvarage));
    else if (SystemType == "M/M/1/K/FCFS") {
      if (trafficIntensity == 1)
        return (SysCapacity / 2);
      else {
        double L = trafficIntensity *
            (1 -
                (SysCapacity + 1) * pow(trafficIntensity, SysCapacity) +
                SysCapacity * pow(trafficIntensity, SysCapacity + 1)) /
            ((1 - trafficIntensity) *
                (1 - pow(trafficIntensity, SysCapacity + 1)));
        return L;
      }
    } else if (SystemType == "M/M/C/∞/FCFS") {
      return QueueCustomerNum() + (arrivalRateAvarage / serviceRateAvarage);
    } else {
      double r = arrivalRateAvarage / serviceRateAvarage;
      double summation = 0;
      for (int n = 0; n < parallelServers; n++) {
        summation += (parallelServers - n) * pow(r, n) / factorial(n);
      }
      return QueueCustomerNum() +
          parallelServers -
          (summation * EmpityProbability());
    }
  }

  double QueueCustomerNum() {
    if (SystemType == "M/M/1/∞/FCFS")
      return ((arrivalRateAvarage * arrivalRateAvarage) /
          (serviceRateAvarage * (serviceRateAvarage - arrivalRateAvarage)));
    else if (SystemType == "M/M/1/K/FCFS") {
      return (SystemCustomerNum() -
          trafficIntensity * (1 - getCustomerNumProbability(SysCapacity)));
    } else if (SystemType == "M/M/C/∞/FCFS") {
      double r = arrivalRateAvarage / serviceRateAvarage;
      return (((pow(r, (parallelServers + 1)) / parallelServers)) /
              (factorial(parallelServers) * pow((1 - trafficIntensity), 2))) *
          EmpityProbability();
    } else {
      double summasion = 0.0;
      for (int n = parallelServers + 1; n <= SysCapacity; n++) {
        summasion += (n - parallelServers) * getCustomerNumProbability(n);
      }
      return summasion;
    }
  }

  double SystemWaitingTime() {
    if (SystemType == "M/M/1/∞/FCFS")
      return (1 / (serviceRateAvarage - arrivalRateAvarage));
    else if (SystemType == "M/M/1/K/FCFS") {
      return (SystemCustomerNum() /
          (arrivalRateAvarage * (1 - getCustomerNumProbability(SysCapacity))));
    } else if (SystemType == "M/M/C/∞/FCFS") {
      return ((QueueCustomerNum() / arrivalRateAvarage) +
          (1 / serviceRateAvarage));
    }
  }

  double QueueWaitingTime() {
    if (SystemType == "M/M/1/∞/FCFS")
      return (arrivalRateAvarage /
          (serviceRateAvarage * (serviceRateAvarage - arrivalRateAvarage)));
    else if (SystemType == "M/M/1/K/FCFS") {
      return (SystemWaitingTime() - (1 / serviceRateAvarage));
    } else if (SystemType == "M/M/C/∞/FCFS") {
      return (QueueCustomerNum() / arrivalRateAvarage);
    }
  }

  double getCustomerNumProbability(int num) {
    if (SystemType == "M/M/1/∞/FCFS")
      return (1 - trafficIntensity) * (pow(trafficIntensity, num));
    else if (SystemType == "M/M/1/K/FCFS") {
      if (trafficIntensity == 1)
        return 1 / (SysCapacity + 1);
      else
        return (pow(trafficIntensity, num) *
            ((1 - trafficIntensity) /
                (1 - pow(trafficIntensity, (SysCapacity + 1)))));
    } else {
      double R = pow((arrivalRateAvarage / serviceRateAvarage), num);
      if (num == 0)
        return EmpityProbability();
      else if (num < parallelServers)
        return (EmpityProbability() * R / factorial(num));
      else
        return (EmpityProbability() *
            R /
            (factorial(parallelServers) *
                pow(parallelServers, (num - parallelServers))));
    }
  }

  double EmpityProbability() {
    if (SystemType == "M/M/C/∞/FCFS") {
      if (trafficIntensity < 1) {
        double summation = 0;
        for (int n = 0; n < parallelServers; n++) {
          summation +=
              pow((arrivalRateAvarage / serviceRateAvarage), n) / factorial(n);
        }
        return 1 /
            (summation +
                (parallelServers *
                    pow((arrivalRateAvarage / serviceRateAvarage),
                        parallelServers) /
                    (factorial(parallelServers) *
                        (parallelServers -
                            (arrivalRateAvarage / serviceRateAvarage)))));
      } else {
        double summation = 0;
        for (int n = 0; n < parallelServers; n++) {
          summation +=
              pow((arrivalRateAvarage / serviceRateAvarage), n) / factorial(n);
        }
        return 1 /
            (summation +
                (pow((arrivalRateAvarage / serviceRateAvarage),
                            parallelServers) *
                        serviceRateAvarage *
                        parallelServers) /
                    (factorial(parallelServers) *
                        (parallelServers * serviceRateAvarage -
                            arrivalRateAvarage)));
      }
    } else {
      double r = arrivalRateAvarage / serviceRateAvarage;
      double summation = 0;
      for (int n = 0; n < parallelServers; n++) {
        summation +=
            pow((arrivalRateAvarage / serviceRateAvarage), n) / factorial(n);
      }
      if (trafficIntensity == 1) {
        return 1 /
            (summation +
                (pow(r, parallelServers) *
                    (SysCapacity - parallelServers + 1) /
                    factorial(parallelServers)));
      } else {
        return 1 /
            (summation +
                (pow(r, parallelServers) *
                        (1 -
                            pow(trafficIntensity,
                                (SysCapacity - parallelServers + 1)))) /
                    (factorial(parallelServers) * (1 - trafficIntensity)));
      }
    }
  }

  int factorial(int n) {
    if (n == 1 || n == 0)
      return 1;
    else {
      int result = n;
      for (int i = n - 1; i > 0; i--) {
        result = result * i;
      }
      return result;
    }
  }
//
}
