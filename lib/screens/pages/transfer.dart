import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

void main() {
  runApp(const MyApp()); // Start the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Transfer App',
      theme: AppTheme.lightTheme, // Use the custom app theme
      home: const TransferPage(), // Set the home page to TransferPage
    );
  }
}

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState(); // Create the state for this widget
}

class _TransferPageState extends State<TransferPage> {
  int _currentPage = 0; // Tracks the current page (0 = Search, 1 = Confirmation, 2 = Success)
  final TextEditingController _recipientNameController = TextEditingController(); // For recipient name input
  final TextEditingController _amountController = TextEditingController(); // For amount input
  final TextEditingController _pinController = TextEditingController(); // For PIN input
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation

  String recipientName = ''; // Stores the recipient's name
  String amount = ''; // Stores the amount to transfer
  String selectedPaymentMethod = PaymentMethodItems.items.first.value; // Selected payment method
  bool isFavorite = false; // Whether to mark as favorite
  bool isProcessing = false; // Tracks if the transfer is being processed

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
    } else {
      // Show error message for invalid form
      CustomSnackBar.showError(
        context,
        'Please fix the errors above before continuing',
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary, // Set background color
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundPrimary, // Match background color
        elevation: 0, // Remove shadow
        title: const Text(
          'Transfer Money',
          style: AppTheme.headingMedium,
        ),
        centerTitle: true, // Center the title
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                onPressed: _navigateToPreviousPage, // Add back button for pages > 0
              )
            : null, // No back button on the first page
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: AnimationUtils.normalDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Determine transition direction based on page navigation
            final isForward = child.key == ValueKey(_currentPage);

            if (isForward) {
              // Forward navigation: slide from right
              return AnimationUtils.slideFromRight(animation, child);
            } else {
              // Backward navigation: slide from left
              return AnimationUtils.slideFromLeft(animation, child);
            }
          },
          child: Container(
            key: ValueKey(_currentPage),
            child: _buildPage(_currentPage),
          ),
        ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text(
                'Transfer money to',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              const Text(
                'Enter recipient details and transfer information',
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingS),

              // Recipient Name Input Field with Animation
              AnimatedFormField(
                controller: _recipientNameController,
                label: 'Recipient Name',
                hint: 'Enter recipient\'s full name',
                isRequired: true,
                validator: (value) => FieldValidators.minLength(value, 2, fieldName: 'Recipient name'),
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: AppTheme.spacingS),

              // Amount Input Field with Animation
              AnimatedFormField(
                controller: _amountController,
                label: 'Amount',
                hint: 'Enter amount (e.g., 100.00)',
                isRequired: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) => FieldValidators.amount(value, maxAmount: 10000),
                prefixIcon: Icons.attach_money,
              ),
              const SizedBox(height: AppTheme.spacingS),

              // Payment Method Dropdown
              CustomDropdown<String>(
                label: 'Payment Method',
                value: selectedPaymentMethod,
                items: PaymentMethodItems.items,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPaymentMethod = newValue!;
                  });
                },
                isRequired: true,
                validator: (value) => DropdownValidators.required(value, fieldName: 'Payment method'),
              ),
              const SizedBox(height: AppTheme.spacingS),

              // Favorite Switch
              FavoriteSwitch(
                isFavorite: isFavorite,
                onChanged: (bool value) {
                  setState(() {
                    isFavorite = value;
                  });
                },
              ),
              const SizedBox(height: AppTheme.spacingM),

              // Continue Button
              MoneyTransferButton(
                text: 'Continue',
                onPressed: _validateAndContinue,
                icon: Icons.arrow_forward,
                fullWidth: true,
                size: MoneyTransferButtonSize.large,
              ),
              // Add bottom padding to prevent overflow
              const SizedBox(height: AppTheme.spacingM),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Second Screen: Confirm transfer and enter PIN
  Widget _buildConfirmationScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text(
              'Confirm Transfer',
              style: AppTheme.headingMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Transfer Details Card
            TransferInfoCard(
              recipientName: recipientName,
              amount: amount,
              paymentMethod: PaymentMethodItems.getLabelByValue(selectedPaymentMethod),
              isFavorite: isFavorite,
              paymentMethodIcon: PaymentMethodItems.getIconByValue(selectedPaymentMethod),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // PIN Input Field with Animation
            AnimatedFormField(
              controller: _pinController,
              label: 'Enter PIN to Confirm',
              hint: 'Enter your 4-6 digit PIN',
              isRequired: true,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) => FieldValidators.pin(value, length: 4),
              prefixIcon: Icons.lock_outline,
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Confirm Transfer Button with animated processing
            AnimatedContainer(
              duration: AnimationUtils.normalDuration,
              curve: AnimationUtils.defaultCurve,
              child: MoneyTransferButton(
                text: isProcessing ? 'Processing Transfer...' : 'Confirm Transfer',
                onPressed: isProcessing ? null : () {
                  if (_pinController.text.length < 4) {
                    CustomSnackBar.showError(context, 'PIN must be at least 4 digits');
                  } else {
                    setState(() {
                      isProcessing = true;
                    });
                    // Simulate processing delay with progress animation
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        setState(() {
                          isProcessing = false;
                        });
                        CustomSnackBar.showSuccess(context, 'Transfer completed successfully!');
                        _navigateToNextPage();
                      }
                    });
                  }
                },
                isLoading: isProcessing,
                loadingText: 'Processing...',
                icon: isProcessing ? null : Icons.send,
                fullWidth: true,
                size: MoneyTransferButtonSize.large,
              ),
            ),

            // Animated progress indicator during processing
            if (isProcessing) ...[
              const SizedBox(height: AppTheme.spacingM),
              AnimatedFadeInWidget(
                duration: AnimationUtils.fastDuration,
                child: Column(
                  children: [
                    PulsingWidget(
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        'Securing your transaction...',
                        style: AppTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    AnimatedProgressIndicator(
                      progress: 1.0,
                      duration: const Duration(seconds: 2),
                      color: AppTheme.accentOrange,
                      backgroundColor: AppTheme.borderSecondary,
                    ),
                  ],
                ),
              ),
            ],
            // Add bottom padding to prevent overflow
            const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  // Third Screen: Success Message
  Widget _buildSuccessScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated success icon with bounce effect
            AnimatedSuccessIcon(
              size: 80,
              color: AppTheme.successGreen,
              delay: const Duration(milliseconds: 200),
              onAnimationComplete: () {
                // Icon animation completed
              },
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Animated success message with slide-up effect
            AnimatedSlideText(
              text: 'Success! $amount sent to $recipientName',
              style: AppTheme.headingMedium,
              delay: const Duration(milliseconds: 500), // 300ms after icon starts
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Animated done button with fade-in effect
            AnimatedFadeInWidget(
              delay: const Duration(milliseconds: 1000),
              duration: AnimationUtils.normalDuration,
              child: MoneyTransferButton(
                text: 'Done',
                onPressed: () {
                  setState(() {
                    _currentPage = 0; // Reset to the first page
                    _recipientNameController.clear(); // Clear recipient input
                    _amountController.clear(); // Clear amount input
                    _pinController.clear(); // Clear PIN input
                    selectedPaymentMethod = PaymentMethodItems.items.first.value; // Reset payment method
                    isFavorite = false; // Reset favorite toggle
                  });
                },
                icon: Icons.check,
                fullWidth: true,
                size: MoneyTransferButtonSize.large,
                style: MoneyTransferButtonStyle.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }


}