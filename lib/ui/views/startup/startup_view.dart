import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'startup_viewmodel.dart';

class StartupView extends StackedView<StartupViewModel> {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFF12251D), // Dark Graphite/Green
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              // Logo and branding
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: kcVoltSpareEVGreen.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: kcVoltSpareEVGreen, width: 2),
                    ),
                    child: const Icon(
                      Icons.electric_bolt_rounded,
                      color: kcVoltSpareEVGreen,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'VoltSpare',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'EV & two-wheeler spare parts',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Bottom section
              const Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Right part. First time.',
                      style: TextStyle(
                        color: kcVoltSpareEVGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.8,
                        color: kcVoltSpareEVGreen,
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
  }

  @override
  StartupViewModel viewModelBuilder(BuildContext context) => StartupViewModel();

  @override
  void onViewModelReady(StartupViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
