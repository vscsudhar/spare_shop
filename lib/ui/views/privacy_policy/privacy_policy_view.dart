import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/legal_content.dart';
import 'package:spare_shop/ui/widgets/common/legal_card.dart';
import 'package:stacked/stacked.dart';
import 'package:spare_shop/ui/views/terms_conditions/terms_conditions_viewmodel.dart';

import 'privacy_policy_viewmodel.dart';

class PrivacyPolicyView extends StackedView<PrivacyPolicyViewModel> {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PrivacyPolicyViewModel viewModel,
    Widget? child,
  ) {
    final isPrivacy = viewModel.activeTab == LegalTab.privacy;

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
            isPrivacy ? 'Privacy Policy' : 'Terms & Conditions',
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
              onPressed: () => viewModel.setTab(isPrivacy ? LegalTab.terms : LegalTab.privacy),
              icon: Icon(
                isPrivacy ? Icons.gavel_rounded : Icons.privacy_tip_outlined,
                size: 16,
              ),
              label: Text(
                isPrivacy ? 'Terms' : 'Privacy',
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: !isPrivacy
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
                                      color: !isPrivacy
                                          ? kcVoltSpareEVGreen
                                          : kcVoltSpareTextSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Terms & Conditions',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: !isPrivacy
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
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isPrivacy
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
                                      color: isPrivacy
                                          ? kcVoltSpareEVGreen
                                          : kcVoltSpareTextSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isPrivacy
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
                          colors: isPrivacy
                              ? const [Color(0xFF064E3B), Color(0xFF0F766E)]
                              : const [Color(0xFF111827), Color(0xFF1E293B)],
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
                                  color: isPrivacy
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : kcVoltSpareEVGreen.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isPrivacy ? Icons.privacy_tip_outlined : Icons.gavel_rounded,
                                  color: isPrivacy ? Colors.white : kcVoltSpareEVGreen,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isPrivacy
                                          ? 'VoltSpare Privacy Policy'
                                          : 'VoltSpare Terms & Conditions',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isPrivacy
                                          ? 'Customer Data Protection & Privacy Practices'
                                          : 'Online EV & Petrol Two-Wheeler Spare Parts',
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
                            isPrivacy
                                ? VoltSparePrivacyPolicy.preamble
                                : VoltSpareTermsAndConditions.preamble,
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
                                label: 'Effective: ${LegalConfig.effectiveDate}',
                              ),
                              _HeaderTag(
                                icon: Icons.update_rounded,
                                label: 'Updated: ${LegalConfig.lastUpdatedDate}',
                              ),
                              _HeaderTag(
                                icon: Icons.verified_user_rounded,
                                label: 'DPDP Act, 2023 Compliant',
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
                          hintText: isPrivacy
                              ? 'Search privacy topics (e.g. location, payments, DPDP rights)...'
                              : 'Search terms (e.g. returns, warranty, delivery, hub radius)...',
                          hintStyle: const TextStyle(fontSize: 13, color: kcLightGrey),
                          border: InputBorder.none,
                          icon: const Icon(Icons.search_rounded, color: kcMediumGrey),
                          suffixIcon: viewModel.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: viewModel.clearSearch,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sections inside Card-in-Card
                    LegalCardInsideCard(
                      title: isPrivacy
                          ? 'VoltSpare Data & Privacy Commitments'
                          : 'VoltSpare User Agreement & Terms',
                      subtitle: isPrivacy
                          ? 'All ${viewModel.sections.length} privacy safeguards and data handling standards'
                          : 'All ${viewModel.sections.length} operative provisions for customers and buyers',
                      icon: isPrivacy ? Icons.shield_outlined : Icons.description_outlined,
                      accentColor: isPrivacy ? const Color(0xFF0F766E) : kcPrimaryColor,
                      sections: viewModel.sections,
                      isFullPage: true,
                    ),

                  const SizedBox(height: 24),

                  // Grievance Officer Details Card
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
                            Icon(Icons.admin_panel_settings_outlined,
                                size: 20, color: kcVoltSpareDark),
                            SizedBox(width: 10),
                            Text(
                              'Data Protection & Privacy Officer',
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
                          'In accordance with Indian data protection laws, inquiries or consent withdrawal requests may be sent to our designated officer:',
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
                              icon: Icons.person_outline_rounded,
                              label: LegalConfig.grievanceOfficerName,
                            ),
                            _ContactChip(
                              icon: Icons.email_outlined,
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
  PrivacyPolicyViewModel viewModelBuilder(BuildContext context) =>
      PrivacyPolicyViewModel();
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
