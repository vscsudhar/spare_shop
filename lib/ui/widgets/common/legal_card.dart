import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/legal_content.dart';

/// Interactive "Card Inside Card" widget for displaying Terms & Conditions or Privacy Policy
class LegalCardInsideCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<LegalSection> sections;
  final VoidCallback? onFullViewPressed;
  final bool isFullPage;

  const LegalCardInsideCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.accentColor = kcVoltSpareEVGreen,
    required this.sections,
    this.onFullViewPressed,
    this.isFullPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kcBorderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Outer Card Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kcVoltSpareDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: kcVoltSpareTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onFullViewPressed != null && !isFullPage)
                TextButton.icon(
                  onPressed: onFullViewPressed,
                  icon: const Icon(Icons.open_in_new_rounded, size: 14),
                  label: const Text(
                    'Read Full',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: kcVoltSpareDark,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    backgroundColor: kcSurfaceVariantColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Preamble / Last Updated pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kcSurfaceVariantColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_outlined,
                    size: 14, color: kcVoltSpareDark),
                SizedBox(width: 6),
                Text(
                  'Compliant with Indian E-Commerce & DPDP Rules',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: kcVoltSpareDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Inner Cards (Card inside Card)
          ListView.separated(
            shrinkWrap: true,
            physics: isFullPage
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            itemCount: isFullPage
                ? sections.length
                : (sections.length > 3 ? 3 : sections.length),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final section = sections[index];
              return _InnerLegalCard(
                section: section,
                accentColor: accentColor,
              );
            },
          ),

          if (!isFullPage &&
              sections.length > 3 &&
              onFullViewPressed != null) ...[
            const SizedBox(height: 14),
            InkWell(
              onTap: onFullViewPressed,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View all ${sections.length} sections',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: kcVoltSpareDark,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 16, color: kcVoltSpareDark),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Single inner card representing a legal section
class _InnerLegalCard extends StatefulWidget {
  final LegalSection section;
  final Color accentColor;

  const _InnerLegalCard({
    Key? key,
    required this.section,
    required this.accentColor,
  }) : super(key: key);

  @override
  State<_InnerLegalCard> createState() => _InnerLegalCardState();
}

class _InnerLegalCardState extends State<_InnerLegalCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded
              ? widget.accentColor.withValues(alpha: 0.4)
              : const Color(0xFFE5E7EB),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: widget.accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.section.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kcVoltSpareDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.section.summary,
                            style: const TextStyle(
                              fontSize: 12,
                              color: kcVoltSpareTextSecondary,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: kcLightGrey,
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  const Divider(height: 20, color: Color(0xFFE5E7EB)),
                  ...widget.section.bulletPoints.map(
                    (point) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 5.0, right: 8.0),
                            child: Icon(
                              Icons.check_circle_outline_rounded,
                              size: 13,
                              color: kcPrimaryColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF374151),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.section.detailedText != null) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Text(
                        widget.section.detailedText!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: kcVoltSpareTextSecondary,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact Dual Legal Card (Card Inside Card) for Auth and Profile screens
class CompactLegalConsentCard extends StatelessWidget {
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;
  final bool showCheckbox;
  final bool isChecked;
  final ValueChanged<bool?>? onCheckboxChanged;

  const CompactLegalConsentCard({
    Key? key,
    required this.onTermsTap,
    required this.onPrivacyTap,
    this.showCheckbox = false,
    this.isChecked = false,
    this.onCheckboxChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showCheckbox)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: isChecked,
                      onChanged: onCheckboxChanged,
                      activeColor: kcPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: kcVoltSpareEVGreen.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    size: 16,
                    color: kcVoltSpareDark,
                  ),
                ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VoltSpare Legal & Trust Policies',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kcVoltSpareDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'By proceeding, you agree to our policies governing two-wheeler part purchases, hub deliveries, and data privacy.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: kcVoltSpareTextSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Cards inside card for Terms and Privacy
          Row(
            children: [
              Expanded(
                child: _PolicyShortcutCard(
                  title: 'Terms & Conditions',
                  badgeText: '20 Sections',
                  icon: Icons.gavel_rounded,
                  onTap: onTermsTap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PolicyShortcutCard(
                  title: 'Privacy Policy',
                  badgeText: 'DPDP 2023',
                  icon: Icons.privacy_tip_outlined,
                  onTap: onPrivacyTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PolicyShortcutCard extends StatelessWidget {
  final String title;
  final String badgeText;
  final IconData icon;
  final VoidCallback onTap;

  const _PolicyShortcutCard({
    required this.title,
    required this.badgeText,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: kcVoltSpareDark),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: kcVoltSpareDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        badgeText,
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: kcPrimaryColorDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: kcLightGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
