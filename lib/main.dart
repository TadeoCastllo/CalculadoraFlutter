import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String display = '';

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '';
      } else if (value == '=') {
        calcularResultado();
      } else {
        if (display.isEmpty && RegExp(r'[+*/)]').hasMatch(value)) return;
        display += value;
      }
    });
  }

  void calcularResultado() {
    if (display.isEmpty) return;
    try {
      Parser p = Parser();
      Expression exp = p.parse(display);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval.isInfinite || eval.isNaN) {
        display = "Error: Div/0";
      } else {
        display = eval % 1 == 0
            ? eval.toInt().toString()
            : eval.toStringAsFixed(2);
      }
    } catch (e) {
      display = "Error";
    }
  }

  Widget boton(
    String text, {
    Color? color,
    int flex = 1,
    bool isLandscape = false,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: isLandscape ? 10 : 24),
            elevation: 2,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: isLandscape ? 20 : 26,
              fontWeight: FontWeight.bold,
              color: color == null && !RegExp(r'[0-9]').hasMatch(text)
                  ? Colors.deepPurpleAccent
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MediaQuery.of(context).orientation == Orientation.landscape
          ? null
          : AppBar(
              title: const Text("Calculadora Académica"),
              centerTitle: true,
            ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool isLandscape = orientation == Orientation.landscape;

            return Column(
              children: [
                // Display
                Expanded(
                  child: Container(
                    padding: isLandscape
                        ? const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 0,
                          )
                        : const EdgeInsets.all(24),
                    alignment: isLandscape
                        ? Alignment.centerRight
                        : Alignment.bottomRight,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                      child: Text(
                        display.isEmpty ? '0' : display,
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Teclado
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: isLandscape ? 4 : 16,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          boton(
                            "(",
                            color: Colors.grey[850],
                            isLandscape: isLandscape,
                          ),
                          boton(
                            ")",
                            color: Colors.grey[850],
                            isLandscape: isLandscape,
                          ),
                          boton(
                            "C",
                            color: Colors.redAccent.withOpacity(0.8),
                            isLandscape: isLandscape,
                          ),
                          boton(
                            "/",
                            color: Colors.orangeAccent,
                            isLandscape: isLandscape,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          boton("7", isLandscape: isLandscape),
                          boton("8", isLandscape: isLandscape),
                          boton("9", isLandscape: isLandscape),
                          boton(
                            "*",
                            color: Colors.orangeAccent,
                            isLandscape: isLandscape,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          boton("4", isLandscape: isLandscape),
                          boton("5", isLandscape: isLandscape),
                          boton("6", isLandscape: isLandscape),
                          boton(
                            "-",
                            color: Colors.orangeAccent,
                            isLandscape: isLandscape,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          boton("1", isLandscape: isLandscape),
                          boton("2", isLandscape: isLandscape),
                          boton("3", isLandscape: isLandscape),
                          boton(
                            "+",
                            color: Colors.orangeAccent,
                            isLandscape: isLandscape,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          boton("0", isLandscape: isLandscape),
                          boton(
                            "=",
                            color: Colors.deepPurpleAccent,
                            flex: 3,
                            isLandscape: isLandscape,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
