import 'package:flutter/material.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController =
      TextEditingController(); // Added
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _nameErrorText;
  String? _numberErrorText; // Added
  String? _weightErrorText;
  String? _ageErrorText;
  bool _heightHasError = false;

  bool isMaleSelected = true;
  String _selectedUnit = 'Cm';
  double _heightInCm = 100;

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose(); // Added
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void clearAllFields() {
    if (mounted) {
      setState(() {
        _nameController.clear();
        _numberController.clear(); // Added
        _weightController.clear();
        _ageController.clear();
        _heightInCm = 100;
        _selectedUnit = 'Cm';
        isMaleSelected = true;

        _nameErrorText = null;
        _numberErrorText = null; // Added
        _weightErrorText = null;
        _ageErrorText = null;
        _heightHasError = false;
      });
    }
  }

  void _updateCounterValue(
    TextEditingController controller,
    int offset,
    String type,
  ) {
    int currentValue = int.tryParse(controller.text) ?? 0;
    int newValue = currentValue + offset;
    if (newValue >= 0) {
      setState(() {
        controller.text = newValue == 0 ? '' : newValue.toString();
        if (newValue > 0) {
          if (type == 'weight') _weightErrorText = null;
          if (type == 'age') _ageErrorText = null;
        }
      });
    }
  }

  String get _displayedHeightValue {
    if (_heightInCm == 100 && _selectedUnit == 'Cm') {
      return '0';
    }
    if (_selectedUnit == 'Cm') {
      return '${_heightInCm.round()}';
    } else if (_selectedUnit == 'In') {
      double inches = _heightInCm / 2.54;
      return '${inches.round()}';
    } else {
      double feet = _heightInCm / 30.48;
      return feet.toStringAsFixed(1);
    }
  }

  void _validateAndCalculate() {
    int finalWeight = int.tryParse(_weightController.text) ?? 0;
    int finalAge = int.tryParse(_ageController.text) ?? 0;

    setState(() {
      if (_nameController.text.trim().isEmpty) {
        _nameErrorText = 'Please enter your name';
      } else {
        _nameErrorText = null;
      }

      // Number Field Validation
      if (_numberController.text.trim().isEmpty) {
        _numberErrorText = 'Please enter your number';
      } else {
        _numberErrorText = null;
      }

      _heightHasError = (_heightInCm <= 100);

      if (finalWeight <= 0) {
        _weightErrorText = 'Weight required';
      } else {
        _weightErrorText = null;
      }

      if (finalAge <= 0) {
        _ageErrorText = 'Age required';
      } else {
        _ageErrorText = null;
      }
    });

    if (_nameErrorText == null &&
        _numberErrorText == null &&
        !_heightHasError &&
        _weightErrorText == null &&
        _ageErrorText == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            height: _heightInCm,
            weight: finalWeight,
            userName: _nameController.text.trim(),
            onReset: clearAllFields,
            isMale: isMaleSelected,
            age: finalAge,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              // Name Card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF252428),
                  borderRadius: BorderRadius.circular(16),
                  border: _nameErrorText != null
                      ? Border.all(color: Colors.redAccent, width: 1.5)
                      : null,
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onChanged: (value) {
                    if (_nameErrorText != null && value.trim().isNotEmpty) {
                      setState(() => _nameErrorText = null);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: _nameErrorText != null
                          ? Colors.redAccent
                          : Colors.grey,
                      fontSize: 14,
                    ),
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    errorText: _nameErrorText,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Number Card (Added Column)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF252428),
                  borderRadius: BorderRadius.circular(16),
                  border: _numberErrorText != null
                      ? Border.all(color: Colors.redAccent, width: 1.5)
                      : null,
                ),
                child: TextField(
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  onChanged: (value) {
                    if (_numberErrorText != null && value.trim().isNotEmpty) {
                      setState(() => _numberErrorText = null);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Number',
                    labelStyle: TextStyle(
                      color: _numberErrorText != null
                          ? Colors.redAccent
                          : Colors.grey,
                      fontSize: 14,
                    ),
                    hintText: 'Enter your phone number',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                    errorText: _numberErrorText,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gender Selection
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isMaleSelected = true),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: isMaleSelected
                              ? const Color(0xFF2A2E25)
                              : const Color(0xFF252428),
                          borderRadius: BorderRadius.circular(16),
                          border: isMaleSelected
                              ? Border.all(
                                  color: const Color(
                                    0xFFD4FF70,
                                  ).withOpacity(0.3),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.male,
                              size: 36,
                              color: isMaleSelected
                                  ? const Color(0xFFD4FF70)
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'MALE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMaleSelected
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isMaleSelected = false),
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: !isMaleSelected
                              ? const Color(0xFF2A2E25)
                              : const Color(0xFF252428),
                          borderRadius: BorderRadius.circular(16),
                          border: !isMaleSelected
                              ? Border.all(
                                  color: const Color(
                                    0xFFD4FF70,
                                  ).withOpacity(0.3),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.female,
                              size: 36,
                              color: !isMaleSelected
                                  ? const Color(0xFFD4FF70)
                                  : Colors.grey,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'FEMALE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !isMaleSelected
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Height Panel
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF252428),
                  borderRadius: BorderRadius.circular(16),
                  border: _heightHasError
                      ? Border.all(color: Colors.redAccent, width: 1.5)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _heightHasError ? 'Height required *' : 'Height',
                          style: TextStyle(
                            color: _heightHasError
                                ? Colors.redAccent
                                : Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1B1F),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              _buildUnitTab('In'),
                              _buildUnitTab('Ft'),
                              _buildUnitTab('Cm'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        _displayedHeightValue,
                        style: const TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: _heightHasError
                            ? Colors.redAccent
                            : const Color(0xFFD4FF70),
                        inactiveTrackColor: Colors.grey.shade800,
                        thumbColor: _heightHasError
                            ? Colors.redAccent
                            : const Color(0xFFD4FF70),
                        overlayColor: const Color(0xFFD4FF70).withOpacity(0.2),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: _heightInCm,
                        min: 100,
                        max: 220,
                        onChanged: (value) {
                          setState(() {
                            _heightInCm = value;
                            if (value > 100) _heightHasError = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Weight & Age Cards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEditableCounterCard(
                          title: 'Weight',
                          controller: _weightController,
                          unit: 'kg',
                          hasError: _weightErrorText != null,
                          type: 'weight',
                        ),
                        if (_weightErrorText != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 6.0),
                            child: Text(
                              _weightErrorText!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEditableCounterCard(
                          title: 'Age',
                          controller: _ageController,
                          unit: 'Year',
                          hasError: _ageErrorText != null,
                          type: 'age',
                        ),
                        if (_ageErrorText != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 6.0),
                            child: Text(
                              _ageErrorText!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Calculate Button
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
                  onPressed: _validateAndCalculate,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Calculate'),
                      SizedBox(width: 8),
                      Icon(Icons.cached, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitTab(String label) {
    bool isSelected = _selectedUnit == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedUnit = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4FF70) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildEditableCounterCard({
    required String title,
    required TextEditingController controller,
    required String unit,
    required bool hasError,
    required String type,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF252428),
        borderRadius: BorderRadius.circular(16),
        border: hasError
            ? Border.all(color: Colors.redAccent, width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: hasError ? Colors.redAccent : Colors.grey,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          IntrinsicWidth(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              onChanged: (value) {
                int? parsed = int.tryParse(value);
                if (parsed != null && parsed > 0) {
                  setState(() {
                    if (type == 'weight') _weightErrorText = null;
                    if (type == 'age') _ageErrorText = null;
                  });
                }
              },
              decoration: const InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCounterButton(
                Icons.remove,
                () => _updateCounterValue(controller, -1, type),
              ),
              const SizedBox(width: 16),
              _buildCounterButton(
                Icons.add,
                () => _updateCounterValue(controller, 1, type),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFD4FF70),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: Colors.black, size: 18),
      ),
    );
  }
}
