import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'rare_product_request_viewmodel.dart';

class RareProductRequestView extends StackedView<RareProductRequestViewModel> {
  const RareProductRequestView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RareProductRequestViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: VoltSpareAppBar(
        title: 'Request Rare Spare Part',
        showBackButton: true,
        onBackPressed: viewModel.goBack,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 550),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rare Spare Sourcing Form',
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Submit specifications. VoltSpare catalog support will search our national logistics networks and quote you back.',
                    style: TextStyle(
                        color: kcVoltSpareTextSecondary,
                        fontSize: 13,
                        height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // Contact Details Section
                  _sectionHeader('CONTACT INFORMATION'),
                  _textField('Your Name', viewModel.customerNameController,
                      hint: 'e.g. Suresh Kumar'),
                  _textField('Phone Number', viewModel.phoneController,
                      hint: 'e.g. +91 98765 43210',
                      keyboard: TextInputType.phone),

                  // Vehicle Details Section
                  _sectionHeader('VEHICLE COMPATIBILITY'),
                  const Text('Vehicle Power Unit',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _powerChip(viewModel, 'Electric EV', VehicleType.ev),
                      const SizedBox(width: 12),
                      _powerChip(
                          viewModel, 'Petrol Engine', VehicleType.petrol),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _textField(
                              'Vehicle Brand', viewModel.brandController,
                              hint: 'e.g. Ather')),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _textField(
                              'Model Name', viewModel.modelController,
                              hint: 'e.g. 450X')),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _textField(
                              'Mfg. Year', viewModel.yearController,
                              hint: 'e.g. 2023',
                              keyboard: TextInputType.number)),
                    ],
                  ),

                  // Part Info Section
                  _sectionHeader('SPARE PART SPECIFICATIONS'),
                  _textField(
                      'Part Name (If known)', viewModel.partNameController,
                      hint: 'e.g. Ather Belt Tensioner Pulley'),

                  // Description
                  const Text('Describe Problem / Part Details *',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: viewModel.descriptionController,
                    maxLines: 4,
                    onChanged: (_) => viewModel.notifyListeners(),
                    decoration: InputDecoration(
                      hintText:
                          'Describe physical parameters, dimensions, markings, or part numbers...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kcVoltSpareBorder),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity and Budget
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Quantity Required',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: kcVoltSpareBorder),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    onPressed: viewModel.decrementQuantity,
                                  ),
                                  Text('${viewModel.quantity}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    onPressed: viewModel.incrementQuantity,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _textField('Target Budget (Optional)',
                            viewModel.budgetController,
                            hint: 'e.g. 1500', keyboard: TextInputType.number),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Urgency Priority Segment
                  const Text('Delivery Urgency',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _urgencyChip(viewModel, 'Normal Priority', 'Normal'),
                      const SizedBox(width: 12),
                      _urgencyChip(viewModel, 'Urgent Rush', 'Urgent'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Image Upload Gallery / Camera
                  const Text('Spare Part Reference Photos',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: viewModel.addSimulatedPhoto,
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Add Gallery Photo'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kcVoltSpareBorder),
                            foregroundColor: kcVoltSpareDark,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: viewModel.addSimulatedPhoto,
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Capture Camera'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kcVoltSpareBorder),
                            foregroundColor: kcVoltSpareDark,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Multiple-image preview list
                  if (viewModel.uploadedImages.isNotEmpty) ...[
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.uploadedImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: kcVoltSpareBorder),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[200],
                                  ),
                                  child: const Icon(Icons.image,
                                      color: Colors.grey),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => viewModel.removePhoto(index),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 10),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Notes
                  _textField(
                      'Additional Logistics Notes', viewModel.notesController,
                      hint:
                          'e.g. Sourcing from custom aftermarket suppliers is fine.'),
                  const SizedBox(height: 24),

                  // Validation Warnings
                  if (!viewModel.canSubmit)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.08),
                        border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.orange, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Please either fill in a detail description or upload a visual photo of the spare part.',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),

                  // Submit Button
                  ElevatedButton(
                    onPressed:
                        viewModel.canSubmit ? viewModel.submitRequest : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kcVoltSpareDark,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: viewModel.isBusy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Submit Sourcing Request'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1)),
          const Divider(),
        ],
      ),
    );
  }

  Widget _textField(String label, TextEditingController ctrl,
      {String? hint, TextInputType? keyboard}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kcVoltSpareBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: kcVoltSpareBorder),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _powerChip(
      RareProductRequestViewModel vm, String label, VehicleType type) {
    final isSelected = vm.vehicleType == type;
    return ChoiceChip(
      label: Text(label,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black, fontSize: 11)),
      selected: isSelected,
      onSelected: (_) => vm.setVehicleType(type),
      selectedColor: kcVoltSpareDark,
      backgroundColor: Colors.white,
    );
  }

  Widget _urgencyChip(
      RareProductRequestViewModel vm, String label, String priority) {
    final isSelected = vm.urgency == priority;
    return ChoiceChip(
      label: Text(label,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black, fontSize: 11)),
      selected: isSelected,
      onSelected: (_) => vm.setUrgency(priority),
      selectedColor: kcVoltSpareDark,
      backgroundColor: Colors.white,
    );
  }

  @override
  RareProductRequestViewModel viewModelBuilder(BuildContext context) =>
      RareProductRequestViewModel();
}
