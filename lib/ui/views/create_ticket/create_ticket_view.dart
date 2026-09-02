import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

import 'create_ticket_viewmodel.dart';

class CreateTicketView extends StackedView<CreateTicketViewModel> {
  const CreateTicketView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CreateTicketViewModel viewModel,
    Widget? child,
  ) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: kcVoltSpareOffWhite,
          appBar: VoltSpareAppBar(
            title: 'New Support Ticket',
            showBackButton: true,
            onBackPressed: viewModel.goBack,
          ),
          body: SafeArea(
            child: MaxContentWidth(
              maxWidth: 700,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Intro Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: kcVoltSpareEVGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: kcVoltSpareEVGreen.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: kcVoltSpareEVGreen,
                            size: 22,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Describe your issue or query below. You can attach photos to help us assist you faster.',
                              style: TextStyle(
                                color: kcVoltSpareDark,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Category Selector
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kcVoltSpareTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: kcVoltSpareWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: kcVoltSpareBorder),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: viewModel.selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: viewModel.categories.map((cat) {
                            return DropdownMenuItem<String>(
                              value: cat,
                              child: Text(
                                cat,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: kcVoltSpareTextPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: viewModel.selectCategory,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Subject Input
                    const Text(
                      'Subject',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kcVoltSpareTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: viewModel.subjectController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Issue with Battery Charger delivery',
                        hintStyle: const TextStyle(
                          color: kcLightGrey,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: kcVoltSpareWhite,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: kcVoltSpareBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: kcVoltSpareBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: kcVoltSpareDark, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Description Input
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kcVoltSpareTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: viewModel.descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText:
                            'Provide detailed information about your inquiry or problem...',
                        hintStyle: const TextStyle(
                          color: kcLightGrey,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: kcVoltSpareWhite,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: kcVoltSpareBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: kcVoltSpareBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: kcVoltSpareDark, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Photo Attachments (Optional)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Attach Photos',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: kcVoltSpareTextPrimary,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '(Optional, Max 5)',
                              style: TextStyle(
                                color: kcVoltSpareTextSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${viewModel.selectedPhotos.length}/5',
                          style: const TextStyle(
                            color: kcVoltSpareTextSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Photos Row & Buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (viewModel.selectedPhotos.length < 5) ...[
                            // Gallery button
                            InkWell(
                              onTap: viewModel.pickPhotos,
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: kcVoltSpareWhite,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: kcVoltSpareBorder,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.photo_library_outlined,
                                      color: kcVoltSpareDark,
                                      size: 24,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Gallery',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: kcVoltSpareTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Camera button
                            InkWell(
                              onTap: viewModel.capturePhoto,
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: kcVoltSpareWhite,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: kcVoltSpareBorder,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: kcVoltSpareDark,
                                      size: 24,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Camera',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: kcVoltSpareTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],

                          // Selected photo thumbnails
                          ...viewModel.selectedPhotos
                              .asMap()
                              .entries
                              .map((entry) {
                            final idx = entry.key;
                            final photo = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: kcVoltSpareBorder),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(13),
                                    child: kIsWeb
                                        ? Image.network(
                                            photo.path,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(photo.path),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => viewModel.removePhoto(idx),
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: viewModel.isBusy
                            ? null
                            : () => viewModel.submitTicket(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kcVoltSpareDark,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: viewModel.isBusy
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Submit Support Ticket',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  CreateTicketViewModel viewModelBuilder(BuildContext context) =>
      CreateTicketViewModel();
}
