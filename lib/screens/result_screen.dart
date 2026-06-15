import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ResultScreen extends StatelessWidget {
  final double height;
  final int weight;
  final String userName;
  final VoidCallback onReset;
  final bool isMale;
  final int age;

  const ResultScreen({
    super.key,
    required this.height,
    required this.weight,
    required this.userName,
    required this.onReset,
    required this.isMale,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInvalidInput = weight <= 0 || height <= 100 || age <= 0;

    double bmiScore = 0.0;
    double bodyFatScore = 0.0;
    String bmiString = "0.0";
    String bodyFatString = "0.0%";

    String bmiCondition = "No Data";
    Color conditionColor = Colors.grey;
    List<String> adviceList = [
      "Please provide valid physical parameters to view analysis metrics.",
    ];
    String fatCondition = "No Data";
    Color fatColor = Colors.grey;

    if (!isInvalidInput) {
      bmiScore = weight / ((height / 100) * (height / 100));
      bmiString = bmiScore.toStringAsFixed(1);

      final int genderValue = isMale ? 1 : 0;
      bodyFatScore =
          (1.20 * bmiScore) + (0.23 * age) - (10.8 * genderValue) - 5.4;
      bodyFatString = bodyFatScore < 0
          ? "0.0%"
          : "${bodyFatScore.toStringAsFixed(1)}%";

      if (bmiScore < 18.5) {
        bmiCondition = "Underweight";
        conditionColor = const Color(0xFFD4FF70);
        adviceList = [
          "Consume more high-calorie foods like nuts, avocados, and healthy oils.",
          "Increase portion sizes during meals.",
          "Focus on foods rich in protein (lean meats, fish, eggs, legumes).",
        ];
      } else if (bmiScore >= 18.5 && bmiScore < 25) {
        bmiCondition = "Normal Weight";
        conditionColor = const Color(0xFF4CAF50);
        adviceList = [
          "Maintain your current balanced diet.",
          "Keep engaging in consistent physical exercises.",
          "Ensure you prioritize consistent high-quality sleep.",
        ];
      } else {
        bmiCondition = "Overweight";
        conditionColor = Colors.redAccent;
        adviceList = [
          "Focus on controlling calorie portions.",
          "Incorporate regular cardio routines into your schedule.",
          "Reduce high-sugar and highly processed food items.",
        ];
      }

      if (isMale) {
        if (bodyFatScore < 6) {
          fatCondition = "Too Low";
          fatColor = const Color(0xFFD4FF70);
        } else if (bodyFatScore >= 6 && bodyFatScore < 25) {
          fatCondition = "Healthy Fitness";
          fatColor = const Color(0xFF4CAF50);
        } else {
          fatCondition = "High Body Fat";
          fatColor = Colors.redAccent;
        }
      } else {
        if (bodyFatScore < 14) {
          fatCondition = "Too Low";
          fatColor = const Color(0xFFD4FF70);
        } else if (bodyFatScore >= 14 && bodyFatScore < 32) {
          fatCondition = "Healthy Fitness";
          fatColor = const Color(0xFF4CAF50);
        } else {
          fatCondition = "High Body Fat";
          fatColor = Colors.redAccent;
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFD4FF70),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.hourglass_empty,
              color: Colors.black,
              size: 16,
            ),
          ),
        ),
        titleSpacing: 0,
        title: const Text(
          'BMI Calculator',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Result for $userName (${isMale ? 'Male' : 'Female'})",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // BMI CARD WITH RADIAL SPEEDOMETER GAUGE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF252428),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your BMI is',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        bmiCondition,
                        style: TextStyle(
                          color: conditionColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Radial Speedometer
                  SizedBox(
                    height: 165,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 10,
                          maximum: 40,
                          startAngle: 180,
                          endAngle: 0,
                          showTicks: false,
                          showLabels: false,
                          axisLineStyle: const AxisLineStyle(
                            thickness: 0.15,
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 10,
                              endValue: 18.5,
                              color: const Color(0xFFD4FF70),
                              startWidth: 14,
                              endWidth: 14,
                            ),
                            GaugeRange(
                              startValue: 18.5,
                              endValue: 25.0,
                              color: const Color(0xFF4CAF50),
                              startWidth: 14,
                              endWidth: 14,
                            ),
                            GaugeRange(
                              startValue: 25.0,
                              endValue: 40,
                              color: Colors.redAccent,
                              startWidth: 14,
                              endWidth: 14,
                            ),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: bmiScore > 40
                                  ? 40
                                  : (bmiScore < 10 ? 10 : bmiScore),
                              needleColor: Colors.white,
                              knobStyle: const KnobStyle(
                                color: Colors.white,
                                knobRadius: 0.08,
                              ),
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              angle: 90,
                              positionFactor: 0.6,
                              widget: Text(
                                isInvalidInput ? "0.0" : bmiString,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // BODY FAT CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF252428),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: fatColor.withOpacity(0.2), width: 1),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Est. Body Fat Percentage',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        fatCondition,
                        style: TextStyle(
                          color: fatColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.accessibility_new_rounded,
                        color: fatColor,
                        size: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isInvalidInput ? "0.0%" : bodyFatString,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(
              isInvalidInput ? "Notice" : "$bmiCondition Recommendations",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...adviceList.map(
                      (advice) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6.0, right: 8.0),
                              child: Icon(
                                Icons.circle,
                                size: 6,
                                color: Colors.grey,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                advice,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Re-Calculate Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4FF70),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onReset();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Re-Calculate'),
                    SizedBox(width: 8),
                    Icon(Icons.keyboard_return, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
