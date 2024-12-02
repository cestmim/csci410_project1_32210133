/*

Mahdi El Hajj - 32210133
CSCI 410 - Mobile Applications
Project 1 - Kaffara Calculator
Instructor: Dr. Bassel Dhaini

About My Project:
I just had the idea out of nowhere, it's a bit complex and can be modified later to include a lot of different ways in calculating the kaffara and maybe some other things like khomos and stuff.

The Formulas I'm using to calculate the kaffara are (based on leader.ir fatwa):

If you brake your fast in Ramadan on purpose you have two options to choose from:
1. Pay 60$ for each day you missed (To Feed 60 Poor People and each meal costs 1$).
2. Fast for 60 days
And you need to repeat the fast for the days you missed.

If you brake your fast in Ramadan due to illness or travel:
There's no kaffara in this case. But You need to repeat the fast for the days you missed.

If you tried to fast after ramadan for a day that you missed but you broke your fast you have two options to choose from:
1. Pay 10$ for each day you repeated the fast.
2. Fast for 3 days

If there's a day from previous Ramadan that you missed and you didn't fast for it and the next ramadan came:
You have to pay 1$ for each day you missed.

If I made a mistake in the formulas, at the end it's a project and only for learning purposes and wouldn't be used in real life.

*/

import 'package:flutter/material.dart';

void main() {
  runApp(const KaffaraApp());
}

class KaffaraApp extends StatelessWidget {
  const KaffaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaffara Calculator',
      theme: ThemeData(
        primaryColor: const Color(0xFF1D3167),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFFA87C4F),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(132, 255, 225, 196),
        fontFamily: 'Bahnschrift',
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1D3167)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
          ),
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
      home: const KaffaraPage(),
    );
  }
}

class KaffaraPage extends StatefulWidget {
  const KaffaraPage({super.key});

  @override
  KaffaraPageState createState() => KaffaraPageState();
}

class KaffaraPageState extends State<KaffaraPage> {
  final TextEditingController _input1Controller = TextEditingController();
  final TextEditingController _input2Controller = TextEditingController();
  final TextEditingController _input3Controller = TextEditingController();
  final TextEditingController _input4Controller = TextEditingController();
  final TextEditingController _input5Controller = TextEditingController();
  final TextEditingController _totalDaysController =
      TextEditingController(text: '0');

  bool _hasPreviousRamadan = false;
  String? _fastRepeat;
  String? _moneyAmount;
  String? _fastDays;
  String? _extraAmount;
  int _totalDays = 0;

  @override
  void initState() {
    super.initState();
    _input1Controller.addListener(_updateTotalDays);
    _input2Controller.addListener(_updateTotalDays);
  }

  @override
  void dispose() {
    _input1Controller.dispose();
    _input2Controller.dispose();
    _input3Controller.dispose();
    _input4Controller.dispose();
    _input5Controller.dispose();
    _totalDaysController.dispose();
    super.dispose();
  }

  void _updateTotalDays() {
    setState(() {
      int input1 = int.tryParse(_input1Controller.text) ?? 0;
      int input2 = int.tryParse(_input2Controller.text) ?? 0;
      _totalDays = input1 + input2;
      _totalDaysController.text = _totalDays.toString();
    });
  }

  void _calculateKaffara() {
    int input1 = int.tryParse(_input1Controller.text) ?? 0;
    int input2 = int.tryParse(_input2Controller.text) ?? 0;
    int input3 = int.tryParse(_input3Controller.text) ?? 0;
    int input4 = int.tryParse(_input4Controller.text) ?? 0;
    int input5 = int.tryParse(_input5Controller.text) ?? 0;

    if (input4 > _totalDays) {
      _showError('There Is No Logic In Fasting More Than The Total Days.');
      return;
    }

    if (_hasPreviousRamadan && input5 > _totalDays) {
      _showError(
          'You Entered More Days That You Were Unable To Fast Before The Next Ramadan Than The Total Days You Missed.');
      return;
    }

    int fastRepeat = (input1 + input2) - input4;
    int moneyAmount = (input1) * 60 + (input3) * 10;
    int fastDays = (input1) * 60 + (input3) * 3;
    int extraAmount = _hasPreviousRamadan ? (input5 * 1) : 0;

    setState(() {
      _fastRepeat = fastRepeat.toString();
      _moneyAmount = '\$$moneyAmount';
      _fastDays = '$fastDays Day(s)';
      _extraAmount = '\$$extraAmount';
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildInputField({
    required String question,
    required TextEditingController controller,
    bool isReadOnly = false,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3167),
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: controller,
            readOnly: isReadOnly,
            keyboardType: isReadOnly ? null : TextInputType.number,
            decoration: InputDecoration(
              hintText: value,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3167),
            ),
          ),
          const SizedBox(height: 20.0),
          ...children,
        ],
      ),
    );
  }

  Widget _buildYesNoQuestion() {
    return _buildSection(
      title:
          "Is There In The $_totalDays Days Any Missed Fasts From Ramadan 2023 Or Earlier?",
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _hasPreviousRamadan = false;
                    _input5Controller.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    color: !_hasPreviousRamadan
                        ? const Color(0xFF1D3167)
                        : Colors.white,
                    border: Border.all(color: const Color(0xFF1D3167)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'No',
                      style: TextStyle(
                        color: !_hasPreviousRamadan
                            ? Colors.white
                            : const Color(0xFF1D3167),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _hasPreviousRamadan = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    color: _hasPreviousRamadan
                        ? const Color(0xFF1D3167)
                        : Colors.white,
                    border: Border.all(color: const Color(0xFF1D3167)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        color: _hasPreviousRamadan
                            ? Colors.white
                            : const Color(0xFF1D3167),
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        if (_hasPreviousRamadan) _buildPreviousRamadanInputs(),
      ],
    );
  }

  Widget _buildPreviousRamadanInputs() {
    return Column(
      children: [
        _buildInputField(
          question:
              'How Many Days You Were Unable To Make Up For And The Next Ramadan Came?',
          controller: _input5Controller,
        ),
      ],
    );
  }

  Widget _buildResult() {
    if (_fastRepeat == null &&
        _moneyAmount == null &&
        _fastDays == null &&
        _extraAmount == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(text: "You've To Repeat: "),
                  TextSpan(
                    text: "$_fastRepeat Day(s)\n",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF1D3167)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(
                    text: "Kaffara:\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: "You Need To Pay: "),
                  TextSpan(
                    text: _moneyAmount,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF1D3167)),
                  ),
                  const TextSpan(
                    text: "\nOR\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: "You Need To Fast For: "),
                  TextSpan(
                    text: _fastDays,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF1D3167)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(
                          text: "\nAs An Extra Kaffara, You Need To Pay: "),
                      TextSpan(
                        text: _extraAmount,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3167)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3167),
        title: const Text(
          'Kaffara Calculator',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSection(
              title: 'Ramadan Kaffara',
              children: [
                _buildInputField(
                  question: 'How Many Days Did You Break Your Fast?',
                  controller: _input1Controller,
                ),
                _buildInputField(
                  question:
                      'How Many Days Did You Break Your Fast Due To Illness Or Travel?',
                  controller: _input2Controller,
                ),
                _buildInputField(
                  question:
                      'Total Days (Automatically Calculated You Do not Need To Input here)',
                  controller: _totalDaysController,
                  isReadOnly: true,
                  value: _totalDays.toString(),
                ),
                _buildInputField(
                  question:
                      'How Many Days Out Of $_totalDays Were You Able To Successfully Fast After Ramadan?',
                  controller: _input4Controller,
                ),
                _buildInputField(
                  question:
                      'How Many Times Did You Attempt To Make Up A Day After Ramadan But Ended Up Breaking Your Fast Again?',
                  controller: _input3Controller,
                ),
              ],
            ),
            _buildYesNoQuestion(),
            const SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              height: 60.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA87C4F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: _calculateKaffara,
                child: const Text(
                  'Calculate Kaffara',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            _buildResult(),
          ],
        ),
      ),
    );
  }
}
