import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'choose_vehicle_type_viewmodel.dart';

import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';

class ChooseVehicleTypeView extends StackedView<ChooseVehicleTypeViewModel> {
  const ChooseVehicleTypeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChooseVehicleTypeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: const VoltSpareAppBar(
        title: 'Choose Vehicle Type',
        showBackButton: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What do you ride?',
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose a vehicle type to see matching spare parts.',
                    style: TextStyle(
                      color: kcVoltSpareTextSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // EV Option Card
                  _buildOptionCard(
                    context,
                    title: 'Electric Vehicle',
                    brands: 'Ola · Ather · TVS iQube · Chetak · Vida',
                    icon: Icons.electric_bolt_rounded,
                    buttonLabel: 'Select EV',
                    onTap: viewModel.selectEv,
                    isEv: true,
                  ),
                  const SizedBox(height: 20),

                  // Petrol Option Card
                  _buildOptionCard(
                    context,
                    title: 'Petrol Two-Wheeler',
                    brands: 'Hero · Honda · TVS · Bajaj · Yamaha · Suzuki',
                    icon: Icons.two_wheeler_rounded,
                    buttonLabel: 'Select Petrol Vehicle',
                    onTap: viewModel.selectPetrol,
                    isEv: false,
                  ),
                  const SizedBox(height: 36),

                  // Bottom Help Text
                  const Center(
                    child: Text(
                      'You can change this anytime from My Vehicles.',
                      style: TextStyle(
                        color: kcVoltSpareTextSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String brands,
    required IconData icon,
    required String buttonLabel,
    required VoidCallback onTap,
    required bool isEv,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kcVoltSpareWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kcVoltSpareBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isEv
                        ? kcVoltSpareEVGreen.withValues(alpha: 0.12)
                        : kcVoltSpareOffWhite,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isEv ? kcVoltSpareEVGreen : kcVoltSpareDark,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: kcVoltSpareTextPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        brands,
                        style: const TextStyle(
                          color: kcVoltSpareTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            PrimaryActionButton(
              label: '$buttonLabel   →',
              onPressed: onTap,
              height: 46,
            ),
          ],
        ),
      ),
    );
  }

  @override
  ChooseVehicleTypeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChooseVehicleTypeViewModel();
}
