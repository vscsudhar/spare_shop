import 'package:spare_shop/core/mixins/navigation_mixin.dart';
import 'package:spare_shop/ui/common/legal_content.dart';
import 'package:spare_shop/ui/views/terms_conditions/terms_conditions_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PrivacyPolicyViewModel extends BaseViewModel with NavigationMixin {
  LegalTab _activeTab = LegalTab.privacy;
  LegalTab get activeTab => _activeTab;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setTab(LegalTab tab) {
    if (_activeTab == tab) return;
    _activeTab = tab;
    _searchQuery = '';
    notifyListeners();
  }

  List<LegalSection> get sections {
    final allSections = _activeTab == LegalTab.privacy
        ? VoltSparePrivacyPolicy.sections
        : VoltSpareTermsAndConditions.sections;

    if (_searchQuery.trim().isEmpty) {
      return allSections;
    }
    final query = _searchQuery.toLowerCase().trim();
    return allSections.where((s) {
      return s.title.toLowerCase().contains(query) ||
          s.summary.toLowerCase().contains(query) ||
          s.bulletPoints.any((b) => b.toLowerCase().contains(query)) ||
          (s.detailedText?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void openTermsConditions() {
    setTab(LegalTab.terms);
  }

  void openPrivacyPolicy() {
    setTab(LegalTab.privacy);
  }
}
