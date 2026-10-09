import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/legal_content.dart';
import 'package:spare_shop/ui/widgets/common/legal_card.dart';
import 'package:stacked/stacked.dart';

import 'terms_conditions_viewmodel.dart';

class TermsConditionsView extends StackedView<TermsConditionsViewModel> {
  const TermsConditionsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TermsConditionsViewModel viewModel,
    Widget? child,
  ) {
    final isTerms = viewModel.activeTab == LegalTab.terms;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          viewModel.goToLogin();
        }
      },
      child: Scaffold(
        backgroundColor: kcBackgroundColor,
        appBar: AppBar(
          title: Text(
            isTerms ? 'Terms & Conditions' : 'Privacy Policy',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kcVoltSpareDark,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: kcVoltSpareDark),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                viewModel.goToLogin();
              }
            },
          ),
          actions: [
            TextButton.icon(
              onPressed: () =>
                  viewModel.setTab(isTerms ? LegalTab.privacy : LegalTab.terms),
              icon: Icon(
                isTerms ? Icons.privacy_tip_outlined : Icons.gavel_rounded,
                size: 16,
              ),
              label: Text(
                isTerms ? 'Privacy' : 'Terms',
                style: const TextStyle(fontSize: 12),
              ),
              style: TextButton.styleFrom(
                foregroundColor: kcVoltSpareDark,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Segmented Tab Switcher (In-page switching without adding to navigation stack)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: kcBorderColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => viewModel.setTab(LegalTab.terms),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isTerms
                                      ? kcVoltSpareDark
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.gavel_rounded,
                                      size: 16,
                                      color: isTerms
                                          ? kcVoltSpareEVGreen
                                          : kcVoltSpareTextSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isTerms
                                            ? Colors.white
                                            : kcVoltSpareTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => viewModel.setTab(LegalTab.privacy),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !isTerms
                                      ? kcVoltSpareDark
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.privacy_tip_outlined,
                                      size: 16,
                                      color: !isTerms
                                          ? kcVoltSpareEVGreen
                                          : kcVoltSpareTextSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: !isTerms
                                            ? Colors.white
                                            : kcVoltSpareTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Header Hero Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isTerms
                              ? const [Color(0xFF111827), Color(0xFF1E293B)]
                              : const [Color(0xFF064E3B), Color(0xFF0F766E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 16,
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
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isTerms
                                      ? kcVoltSpareEVGreen.withValues(
                                          alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isTerms
                                      ? Icons.gavel_rounded
                                      : Icons.privacy_tip_outlined,
                                  color: isTerms
                                      ? kcVoltSpareEVGreen
                                      : Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isTerms
                                          ? 'VoltSpare Terms & Conditions'
                                          : 'VoltSpare Privacy Policy',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isTerms
                                          ? 'Online EV & Petrol Two-Wheeler Spare Parts'
                                          : 'Customer Data Protection & Privacy Practices',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            isTerms
                                ? VoltSpareTermsAndConditions.preamble
                                : VoltSparePrivacyPolicy.preamble,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.white70,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              _HeaderTag(
                                icon: Icons.calendar_today_rounded,
                                label:
                                    'Effective: ${LegalConfig.effectiveDate}',
                              ),
                              _HeaderTag(
                                icon: Icons.update_rounded,
                                label:
                                    'Updated: ${LegalConfig.lastUpdatedDate}',
                              ),
                              _HeaderTag(
                                icon: Icons.flag_rounded,
                                label: 'Republic of India',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kcBorderColor),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        onChanged: viewModel.updateSearch,
                        decoration: InputDecoration(
                          hintText: isTerms
                              ? 'Search terms (e.g. returns, warranty, delivery, hub radius)...'
                              : 'Search privacy practices (e.g. cookies, payments, rights, grievance)...',
                          hintStyle:
                              const TextStyle(fontSize: 13, color: kcLightGrey),
                          border: InputBorder.none,
                          icon: const Icon(Icons.search_rounded,
                              color: kcMediumGrey),
                          suffixIcon: viewModel.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon:
                                      const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: viewModel.clearSearch,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sections inside Card-in-Card
                    LegalCardInsideCard(
                      title: isTerms
                          ? 'VoltSpare User Agreement & Terms'
                          : 'VoltSpare Customer Privacy Charter',
                      subtitle: isTerms
                          ? 'All ${viewModel.sections.length} operative provisions for customers and buyers'
                          : 'All ${viewModel.sections.length} data governance and protection principles',
                      icon: isTerms
                          ? Icons.description_outlined
                          : Icons.shield_outlined,
                      accentColor:
                          isTerms ? kcPrimaryColor : kcVoltSpareEVGreen,
                      sections: viewModel.sections,
                      isFullPage: true,
                    ),

                    const SizedBox(height: 24),

                    // Quick Footer Contact / Grievance Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kcBorderColor),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.headset_mic_rounded,
                                  size: 20, color: kcVoltSpareDark),
                              SizedBox(width: 10),
                              Text(
                                'Questions or Grievances?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kcVoltSpareDark,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Our support team and statutory grievance redressal cell are available to assist you.',
                            style: TextStyle(
                              fontSize: 12,
                              color: kcVoltSpareTextSecondary,
                            ),
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              _ContactChip(
                                icon: Icons.email_outlined,
                                label: LegalConfig.supportEmail,
                              ),
                              _ContactChip(
                                icon: Icons.security_rounded,
                                label: LegalConfig.grievanceEmail,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  TermsConditionsViewModel viewModelBuilder(BuildContext context) =>
      TermsConditionsViewModel();
}

class _HeaderTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeaderTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: kcVoltSpareEVGreen),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ContactChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kcSurfaceVariantColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: kcVoltSpareDark),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kcVoltSpareDark,
            ),
          ),
        ],
      ),
    );
  }
}
