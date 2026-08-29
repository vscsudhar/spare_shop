import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'vehicle_selector_viewmodel.dart';

class VehicleSelectorView extends StackedView<VehicleSelectorViewModel> {
  const VehicleSelectorView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    VehicleSelectorViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: VoltSpareAppBar(
        title: 'My Vehicles',
        showBackButton: true,
        onBackPressed: viewModel.goBackHome,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Primary Vehicle',
                  style: TextStyle(
                    color: kcVoltSpareTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Search results and catalog items will be filtered to fit this vehicle.',
                  style: TextStyle(
                    color: kcVoltSpareTextSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),

                // List of user vehicles
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = viewModel.vehicles[index];
                      final isSelected =
                          viewModel.selectedVehicle?.id == vehicle.id;
                      final isEv = vehicle.type == VehicleType.ev;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: InkWell(
                          onTap: () => viewModel.selectPrimaryVehicle(vehicle),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? kcVoltSpareEVGreen.withValues(alpha: 0.05)
                                  : kcVoltSpareWhite,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? kcVoltSpareEVGreen
                                    : kcVoltSpareBorder,
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: isSelected
                                      ? kcVoltSpareEVGreen
                                      : kcLightGrey,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isEv
                                        ? kcVoltSpareEVGreen.withValues(
                                            alpha: 0.1)
                                        : kcVoltSpareOffWhite,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isEv
                                        ? Icons.electric_bolt_rounded
                                        : Icons.two_wheeler_rounded,
                                    color: isEv
                                        ? kcVoltSpareEVGreen
                                        : kcVoltSpareDark,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${vehicle.brand} ${vehicle.name}',
                                        style: const TextStyle(
                                          color: kcVoltSpareTextPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${vehicle.year} · ${isEv ? 'Electric' : 'Petrol'}',
                                        style: const TextStyle(
                                          color: kcVoltSpareTextSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Add vehicle button
                SecondaryActionButton(
                  label: '+ Add New Vehicle',
                  onPressed: viewModel.addVehicle,
                ),
                const SizedBox(height: 14),
                PrimaryActionButton(
                  label: 'Apply & Continue',
                  onPressed: viewModel.selectedVehicle != null
                      ? viewModel.goBackHome
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  VehicleSelectorViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VehicleSelectorViewModel();
}
