
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

List<String> currencyNames = [];
String selectForm = "";
String selectTo = "";
double amountValue = 0.0;
double totalResult = 0.0;
TextEditingController _controller = TextEditingController();

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 111, 72, 156),
            title: const Text(
              "แปลงสกุลเงิน",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownForm(),
                      ),
                      SizedBox(
                        width: 60,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: DropdownTo(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              key: UniqueKey(),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'))
                              ],
                              onChanged: (value) {
                                if (value != "") {
                                  amountValue = double.parse(value);
                                } else {
                                  amountValue = 0.0;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: '',
                                labelText: "จำนวน",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // กำหนดรูปร่างของเส้นขอบ
                                  borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2), // กำหนดสีและความหนาของเส้น
                                ),
                                // กำหนดสไตล์ของตัวหนังสือ
                                labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 106, 74,
                                      194), // กำหนดสีของตัวหนังสือ
                                  fontSize: 16, // กำหนดขนาดตัวหนังสือ
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            var serviceAPI = FastforexAPIService();

                            serviceAPI
                                .convertCurrencyFunction(
                                    selectForm, selectTo, amountValue)
                                .then((res) => {
                                      print(res.total),
                                      _controller.text = res.total > 0.0
                                          ? res.total.toString()
                                          : "0",
                                      //totalResult = res.total
                                    });
                               // .catchError((e) => {print(e)});
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 111, 72, 156),
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                          ),
                          child: const SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                "Convert",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    10.0), // กำหนดรูปร่างของเส้นขอบ
                                border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 111, 72, 156), // กำหนดสีของเส้น
                                  width: 2, // กำหนดความหนาของเส้น
                                ),
                              ),
                              alignment: Alignment.center,
                              child: TextField(
                                key: UniqueKey(),
                                textAlign: TextAlign.center,

                                controller: _controller,
                                //     enabled: false,
                                decoration: const InputDecoration(
                                  hintText: 'ผลลัพธ์',
                                  labelText: "",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 111, 72, 156),
                                  hintStyle: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                  labelStyle: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            // TextField(
                            //   key: UniqueKey(),
                            //   controller: _controller,
                            //   enabled: false,
                            //   decoration: InputDecoration(
                            //     hintText: 'ผลลัพธ์',
                            //     labelText: "",
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(
                            //           10.0), // กำหนดรูปร่างของเส้นขอบ
                            //       borderSide: const BorderSide(
                            //           color: Colors.blue,
                            //           width: 2), // กำหนดสีและความหนาของเส้น
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class DropdownForm extends StatefulWidget {
  const DropdownForm({super.key});

  @override
  State<DropdownForm> createState() => _DropdownMenuFormState();
}

class _DropdownMenuFormState extends State<DropdownForm> {
  String dropdownValue = list.first;
  Map<String, String> currencyMap = {};
  List<String> currencyList = ['THB'];
  @override
  void initState() {
    super.initState();
    var serviceAPI = FastforexAPIService();
    serviceAPI.FetchCurrencies()
        .then((currenciesRes) => {
              setState(() {
                currencyList = currenciesRes.currencies.values.toList();
              }),
            })
        .catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: currencyList.first,
      width: 140,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          selectForm = value;
        });
      },
      dropdownMenuEntries:
          currencyList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}

class DropdownTo extends StatefulWidget {
  const DropdownTo({super.key});

  @override
  State<DropdownTo> createState() => _DropdownMenuToState();
}

class _DropdownMenuToState extends State<DropdownTo> {
  String dropdownValue = list.first;
  Map<String, String> currencyMap = {};
  List<String> currencyList = ['THB'];
  @override
  void initState() {
    super.initState();
    var serviceAPI = FastforexAPIService();
    serviceAPI.FetchCurrencies()
        .then((currenciesRes) => {
              setState(() {
                currencyList = currenciesRes.currencies.values.toList();
              }),
            })
        .catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: currencyList.first,
      width: 155,
      onSelected: (String? value) {
        print(value);
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          selectTo = value;
        });
      },
      dropdownMenuEntries:
          currencyList.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}


// class ConvertCurreny extends StatefulWidget {
//   @override
//   _ConvertCurreny createState() => _ConvertCurreny();
// }

// class _ConvertCurreny extends State<ConvertCurreny> {
//   @override
//   void initState() {
//     super.initState();

//   }

//   @override
//   Widget build(BuildContext context) {
//     return null;
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
