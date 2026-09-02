import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'select_petrol_bike_viewmodel.dart';

import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';

class SelectPetrolBikeView extends StackedView<SelectPetrolBikeViewModel> {
  const SelectPetrolBikeView({Key? key}) : super(key: key);

  @override
  void onViewModelReady(SelectPetrolBikeViewModel viewModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) => viewModel.init());
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
    BuildContext context,
    SelectPetrolBikeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: const VoltSpareAppBar(
        title: 'Select Petrol Bike',
        showBackButton: true,
      ),
      body: SafeArea(
        child: viewModel.isBusy
            ? const Center(
                child: CircularProgressIndicator(color: kcVoltSpareEVGreen),
              )
            : Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Brand',
                          style: TextStyle(
                            color: kcVoltSpareTextPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Grid of Petrol Brands
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.2,
                          ),
                          itemCount: viewModel.brands.length,
                          itemBuilder: (context, index) {
                            final brand = viewModel.brands[index];
                            final isSelected =
                                viewModel.selectedBrandId == brand.id;
                            return VehicleBrandCard(
                              name: brand.name,
                              isSelected: isSelected,
                              onTap: () => viewModel.selectBrand(brand.id),
                            );
                          },
                        ),

                        const SizedBox(height: 32),

                        if (viewModel.selectedBrandId == 'other') ...[
                          const Text(
                            'Custom Brand Name',
                            style: TextStyle(
                              color: kcVoltSpareTextPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: kcVoltSpareWhite,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: kcVoltSpareBorder),
                            ),
                            child: TextField(
                              controller: viewModel.customBrandController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                hintText: 'Enter Brand Name',
                                border: InputBorder.none,
                              ),
                              onChanged: (val) => viewModel.notifyListeners(),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        if (viewModel.selectedBrandId != null) ...[
                          const Text(
                            'Select Model',
                            style: TextStyle(
                              color: kcVoltSpareTextPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Model Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: kcVoltSpareWhite,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: kcVoltSpareBorder),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('Choose Model'),
                                value: viewModel.selectedModel,
                                items: viewModel.modelsForSelectedBrand
                                    .map((String model) {
                                  return DropdownMenuItem<String>(
                                    value: model,
                                    child: Text(model),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) viewModel.selectModel(val);
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          if (viewModel.selectedModel == 'Other') ...[
                            const Text(
                              'Custom Model Name',
                              style: TextStyle(
                                color: kcVoltSpareTextPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: kcVoltSpareWhite,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: kcVoltSpareBorder),
                              ),
                              child: TextField(
                                controller: viewModel.customModelController,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Model Name',
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) => viewModel.notifyListeners(),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ],

                        if (viewModel.selectedModel != null &&
                            (viewModel.selectedModel != 'Other' ||
                                viewModel.customModelController.text
                                    .trim()
                                    .isNotEmpty)) ...[
                          const Text(
                            'Select Year',
                            style: TextStyle(
                              color: kcVoltSpareTextPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Year Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: kcVoltSpareWhite,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: kcVoltSpareBorder),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: const Text('Choose Year'),
                                value: viewModel.selectedYear,
                                items: viewModel.years.map((String year) {
                                  return DropdownMenuItem<String>(
                                    value: year,
                                    child: Text(year),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) viewModel.selectYear(val);
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],

                        PrimaryActionButton(
                          label: 'Save and Continue',
                          onPressed:
                              viewModel.canSave ? viewModel.saveVehicle : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  @override
  SelectPetrolBikeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SelectPetrolBikeViewModel();
}
