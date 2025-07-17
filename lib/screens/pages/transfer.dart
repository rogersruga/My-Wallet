import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); // Start the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Transfer App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set the app's theme color
      ),
      home: const TransferPage(), // Set the home page to TransferPage
    );
  }
}

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  _TransferPageState createState() => _TransferPageState(); // Create the state for this widget
}

class _TransferPageState extends State<TransferPage> {
  int _currentPage = 0; // Tracks the current page (0 = Search, 1 = Confirmation, 2 = Success)
  final TextEditingController _recipientNameController = TextEditingController(); // For recipient name input
  final TextEditingController _amountController = TextEditingController(); // For amount input
  final TextEditingController _pinController = TextEditingController(); // For PIN input
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

  String recipientName = ''; // Stores the recipient's name
  String amount = ''; // Stores the amount to transfer
  String selectedPaymentMethod = 'Bank Transfer'; // Selected payment method
  bool isFavorite = false; // Whether to mark as favorite
  bool isProcessing = false; // Tracks if the transfer is being processed

  // Payment method options
  final List<String> paymentMethods = [
    'Bank Transfer',
    'Mobile Money',
    'Credit Card',
    'Debit Card',
    'PayPal',
  ];

  // Form validation errors
  String? recipientNameError;
  String? amountError;

  @override
  void dispose() {
    // Clean up controllers when the widget is removed
    _recipientNameController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  // Navigate to the next page
  void _navigateToNextPage() {
    setState(() {
      if (_currentPage < 2) {
        _currentPage++; // Move to the next page
      }
    });
  }

  // Navigate to the previous page
  void _navigateToPreviousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--; // Move to the previous page
      }
    });
  }

  // Validate form and continue to next page
  void _validateAndContinue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        recipientName = _recipientNameController.text.trim();
        amount = '\$${_amountController.text.trim()}';
      });
      _navigateToNextPage();
    }
  }

  // Get icon for payment method
  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'Bank Transfer':
        return Icons.account_balance;
      case 'Mobile Money':
        return Icons.phone_android;
      case 'Credit Card':
        return Icons.credit_card;
      case 'Debit Card':
        return Icons.payment;
      case 'PayPal':
        return Icons.account_balance_wallet;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900, // Set background color
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900, // Match background color
        elevation: 0, // Remove shadow
        title: const Text(
          'Transfer Money',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true, // Center the title
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _navigateToPreviousPage, // Add back button for pages > 0
              )
            : null, // No back button on the first page
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500), // Animation duration
        child: _buildPage(_currentPage), // Build the current page based on _currentPage
      ),
    );
  }

  // Build the appropriate page based on the index
  Widget _buildPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return _buildSearchScreen(); // First screen: Search for recipient
      case 1:
        return _buildConfirmationScreen(); // Second screen: Confirm transfer
      case 2:
        return _buildSuccessScreen(); // Third screen: Success message
      default:
        return const Center(child: Text('Invalid page')); // Fallback for invalid page
    }
  }

  // First Screen: Search for recipient and enter amount
  Widget _buildSearchScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0), // Add padding around the content
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
            children: [
              const Text(
                'Transfer money to',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12), // Add spacing
              const Text(
                'Enter recipient details and transfer information',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 24),

              // Recipient Name Input Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recipient Name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _recipientNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Enter recipient\'s full name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Recipient name is required';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Amount Input Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Enter amount (e.g., 100.00)'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      final double? amount = double.tryParse(value.trim());
                      if (amount == null) {
                        return 'Please enter a valid number';
                      }
                      if (amount <= 0) {
                        return 'Amount must be greater than 0';
                      }
                      if (amount > 10000) {
                        return 'Amount cannot exceed \$10,000';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Payment Method Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade800,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade600),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPaymentMethod,
                        dropdownColor: Colors.blue.shade800,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: paymentMethods.map((String method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Row(
                              children: [
                                Icon(
                                  _getPaymentMethodIcon(method),
                                  color: Colors.orangeAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(method),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPaymentMethod = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Favorite Switch
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade600),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_outline,
                      color: Colors.orangeAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Save as Favorite',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          Text(
                            'Quick access for future transfers',
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isFavorite,
                      onChanged: (bool value) {
                        setState(() {
                          isFavorite = value;
                        });
                      },
                      activeColor: Colors.orangeAccent,
                      activeTrackColor: Colors.orangeAccent.withValues(alpha: 0.3),
                      inactiveThumbColor: Colors.white70,
                      inactiveTrackColor: Colors.blue.shade600,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _validateAndContinue,
                  style: _buttonStyle(),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Second Screen: Confirm transfer and enter PIN
  Widget _buildConfirmationScreen() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm Transfer',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 24),

            // Transfer Details Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade800.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade600),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipient Details
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        radius: 25,
                        child: Text(
                          recipientName.isNotEmpty ? recipientName[0].toUpperCase() : 'R',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipientName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _getPaymentMethodIcon(selectedPaymentMethod),
                                  color: Colors.orangeAccent,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  selectedPaymentMethod,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isFavorite)
                        const Icon(
                          Icons.favorite,
                          color: Colors.orangeAccent,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Amount Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Transfer Amount',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          amount,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // PIN Input Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter PIN to Confirm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 4),
                  decoration: _inputDecoration('Enter your 4-6 digit PIN'),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Confirm Transfer Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_pinController.text.length < 4) {
                    _showErrorSnackbar('PIN must be at least 4 digits');
                  } else {
                    setState(() {
                      isProcessing = true;
                    });
                    // Simulate processing delay
                    Future.delayed(const Duration(seconds: 2), () {
                      setState(() {
                        isProcessing = false;
                      });
                      _showSuccessSnackbar('Transfer completed successfully!');
                      _navigateToNextPage();
                    });
                  }
                },
                style: _buttonStyle(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: isProcessing
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Processing...',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : const Text(
                          'Confirm Transfer',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Third Screen: Success Message
  Widget _buildSuccessScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        children: [
          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 80), // Success icon
          const SizedBox(height: 20),
          Text(
            'Success! $amount sent to $recipientName', // Success message
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 30),

          // Done Button
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentPage = 0; // Reset to the first page
                _recipientNameController.clear(); // Clear recipient input
                _amountController.clear(); // Clear amount input
                _pinController.clear(); // Clear PIN input
                selectedPaymentMethod = 'Bank Transfer'; // Reset payment method
                isFavorite = false; // Reset favorite toggle
              });
            },
            style: _buttonStyle(), // Custom button style
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // Custom Input Decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.blue.shade800,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade600, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Custom Button Style
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.orangeAccent,
      foregroundColor: Colors.white,
      elevation: 3,
      shadowColor: Colors.orangeAccent.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Show Error Snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Show Success Snackbar
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}