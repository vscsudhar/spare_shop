import 'dart:math';
import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:dio/dio.dart';

import 'add_address_viewmodel.dart';

class AddAddressView extends StackedView<AddAddressViewModel> {
  final AddressModel? address;

  const AddAddressView({Key? key, this.address}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddAddressViewModel viewModel,
    Widget? child,
  ) {
    final titleText =
        address == null ? 'Add Shipping Address' : 'Edit Shipping Address';

    return Scaffold(
      backgroundColor: kcVoltSpareOffWhite,
      appBar: VoltSpareAppBar(
        title: titleText,
        showBackButton: true,
        onBackPressed: viewModel.goBack,
      ),
      body: SafeArea(
        child: MaxContentWidth(
          maxWidth: 1000,
          child: ResponsiveBuilder(
            builder: (context, sizingInformation) {
              final isDesktop = sizingInformation.isDesktop;

              final formColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact & Label Details',
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: viewModel.labelController,
                    label: 'Address Label (e.g. Home, Office, Parent\'s House)',
                    hint: 'Home',
                    icon: Icons.bookmark_border_rounded,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: viewModel.phoneController,
                    label: 'Contact Phone Number',
                    hint: '+91 XXXXX XXXXX',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Address Information',
                    style: TextStyle(
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: viewModel.doorNoController,
                    label: 'Door No, Flat / Building Name, Street Name',
                    hint: 'Flat 402, Green Meadows, Sector 5',
                    icon: Icons.home_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: viewModel.talukController,
                          label: 'Taluk / Area',
                          hint: 'HSR Layout',
                          icon: Icons.location_city_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: viewModel.districtController,
                          label: 'District / City',
                          hint: 'Bengaluru',
                          icon: Icons.map_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: viewModel.stateController,
                    label: 'State',
                    hint: 'Karnataka',
                    icon: Icons.explore_outlined,
                  ),
                  const SizedBox(height: 32),
                  PrimaryActionButton(
                    label: address == null ? 'Save Address' : 'Update Address',
                    isLoading: viewModel.isBusy,
                    onPressed: () {
                      if (viewModel.labelController.text.trim().isEmpty ||
                          viewModel.phoneController.text.trim().isEmpty ||
                          viewModel.doorNoController.text.trim().isEmpty ||
                          viewModel.talukController.text.trim().isEmpty ||
                          viewModel.districtController.text.trim().isEmpty ||
                          viewModel.stateController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all required fields'),
                            backgroundColor: kcErrorColor,
                          ),
                        );
                        return;
                      }
                      viewModel.saveAddress();
                    },
                  ),
                ],
              );

              final mapColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Location on Map',
                        style: TextStyle(
                          color: kcVoltSpareTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (viewModel.isMapMoved)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: kcVoltSpareEVGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.gps_fixed_rounded,
                                  color: kcVoltSpareEVGreen, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'Location Selected',
                                style: TextStyle(
                                    color: kcVoltSpareTextPrimary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: isDesktop ? 500 : 320,
                    decoration: BoxDecoration(
                      color: kcVoltSpareWhite,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kcVoltSpareBorder, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: kcVoltSpareDark.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InteractiveMapPicker(
                      initialLat: viewModel.latitude,
                      initialLng: viewModel.longitude,
                      onLocationChanged: (lat, lng) {
                        viewModel.updateLocation(lat, lng);
                      },
                      onAreaSelected: (taluk, district, state) {
                        viewModel.onAreaSelected(taluk, district, state);
                      },
                    ),
                  ),
                ],
              );

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: formColumn,
                          ),
                          const SizedBox(width: 32),
                          Expanded(
                            flex: 5,
                            child: mapColumn,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          mapColumn,
                          const SizedBox(height: 28),
                          formColumn,
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kcVoltSpareTextSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: kcVoltSpareWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kcVoltSpareBorder),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14, color: kcVoltSpareTextPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: kcLightGrey, fontSize: 13),
              prefixIcon: Icon(icon, color: kcVoltSpareTextSecondary, size: 20),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  @override
  AddAddressViewModel viewModelBuilder(BuildContext context) =>
      AddAddressViewModel(addressToEdit: address);
}

class SearchLocation {
  final String name;
  final double latitude;
  final double longitude;
  final String taluk;
  final String district;
  final String state;

  const SearchLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.taluk,
    required this.district,
    required this.state,
  });
}

const List<SearchLocation> searchableLocations = [
  SearchLocation(
    name: "Avinashi Road, Coimbatore",
    latitude: 11.0250,
    longitude: 77.0050,
    taluk: "Peelamedu",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "Gandhipuram Bus Stand, Coimbatore",
    latitude: 11.0183,
    longitude: 76.9687,
    taluk: "Coimbatore North",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "PSG Tech, Peelamedu, Coimbatore",
    latitude: 11.0243,
    longitude: 77.0032,
    taluk: "Peelamedu",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "VOC Park Zoo, Coimbatore South",
    latitude: 11.0068,
    longitude: 76.9732,
    taluk: "Coimbatore South",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "Prozone Mall, Saravanampatti, Coimbatore",
    latitude: 11.0543,
    longitude: 76.9932,
    taluk: "Saravanampatti",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "Coimbatore Junction Railway Station",
    latitude: 11.0003,
    longitude: 76.9637,
    taluk: "Coimbatore South",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "HSR Layout Sector 5, Bengaluru",
    latitude: 12.9116,
    longitude: 77.6388,
    taluk: "HSR Layout",
    district: "Bengaluru",
    state: "Karnataka",
  ),
  SearchLocation(
    name: "Bellandur EcoSpace, Bengaluru",
    latitude: 12.9304,
    longitude: 77.6784,
    taluk: "Varthur Hobli",
    district: "Bengaluru",
    state: "Karnataka",
  ),
  SearchLocation(
    name: "Marudhamalai Road, Coimbatore",
    latitude: 11.0195,
    longitude: 76.9015,
    taluk: "Vadavalli",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "Cross Cut Road, Coimbatore North",
    latitude: 11.0210,
    longitude: 76.9695,
    taluk: "Coimbatore North",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "Madukkarai, Coimbatore South",
    latitude: 10.9068,
    longitude: 76.9632,
    taluk: "Madukkarai",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "Singanallur, Coimbatore East",
    latitude: 11.0028,
    longitude: 77.0252,
    taluk: "Singanallur",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
  SearchLocation(
    name: "Ramanathapuram, Coimbatore South",
    latitude: 10.9982,
    longitude: 76.9856,
    taluk: "Ramanathapuram",
    district: "Coimbatore",
    state: "Tamil Nadu",
  ),
];

class InteractiveMapPicker extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final Function(double lat, double lng) onLocationChanged;
  final Function(String taluk, String district, String state)? onAreaSelected;

  const InteractiveMapPicker({
    Key? key,
    required this.initialLat,
    required this.initialLng,
    required this.onLocationChanged,
    this.onAreaSelected,
  }) : super(key: key);

  @override
  State<InteractiveMapPicker> createState() => _InteractiveMapPickerState();
}

class _InteractiveMapPickerState extends State<InteractiveMapPicker>
    with SingleTickerProviderStateMixin {
  late Offset _mapOffset;
  bool _isDragging = false;
  late double _currentLat;
  late double _currentLng;
  double _zoomLevel = 1.0; // Default zoom scale

  final _searchController = TextEditingController();
  List<SearchLocation> _searchResults = [];

  // Animation for pin jump
  late AnimationController _animationController;
  late Animation<double> _pinTranslationY;
  late Animation<double> _shadowScale;

  @override
  void initState() {
    super.initState();
    _currentLat = widget.initialLat;
    _currentLng = widget.initialLng;
    _mapOffset = Offset.zero;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _pinTranslationY = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _shadowScale = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
    _animationController.forward();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _mapOffset += details.delta;
      // 1px panning ~ 0.00004 degrees coordinate offset at 1.0 zoom
      _currentLat = widget.initialLat - (_mapOffset.dy * 0.00004 / _zoomLevel);
      _currentLng = widget.initialLng + (_mapOffset.dx * 0.00004 / _zoomLevel);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
    _animationController.reverse();
    widget.onLocationChanged(_currentLat, _currentLng);
  }

  void _recenterMap() {
    setState(() {
      _mapOffset = Offset.zero;
      _currentLat = widget.initialLat;
      _currentLng = widget.initialLng;
      _zoomLevel = 1.0;
      _searchController.clear();
      _searchResults = [];
    });
    widget.onLocationChanged(_currentLat, _currentLng);
  }

  void _zoomIn() {
    setState(() {
      if (_zoomLevel < 2.5) {
        _zoomLevel += 0.25;
        // Keep coordinates synced with new zoom and offset
        _currentLat =
            widget.initialLat - (_mapOffset.dy * 0.00004 / _zoomLevel);
        _currentLng =
            widget.initialLng + (_mapOffset.dx * 0.00004 / _zoomLevel);
      }
    });
    widget.onLocationChanged(_currentLat, _currentLng);
  }

  void _zoomOut() {
    setState(() {
      if (_zoomLevel > 0.5) {
        _zoomLevel -= 0.25;
        // Keep coordinates synced with new zoom and offset
        _currentLat =
            widget.initialLat - (_mapOffset.dy * 0.00004 / _zoomLevel);
        _currentLng =
            widget.initialLng + (_mapOffset.dx * 0.00004 / _zoomLevel);
      }
    });
    widget.onLocationChanged(_currentLat, _currentLng);
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.trim().length < 3) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    try {
      final dio = Dio();
      // Set User-Agent as required by Nominatim usage policy
      dio.options.headers['User-Agent'] = 'VoltSpare_App/1.0';
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'addressdetails': '1',
          'limit': '5',
          'countrycodes': 'in', // Limit to India for relevance
        },
      );

      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        setState(() {
          _searchResults = list.map((item) {
            final addr = item['address'] ?? {};

            final String taluk = (addr['suburb'] ??
                    addr['neighbourhood'] ??
                    addr['village'] ??
                    addr['town'] ??
                    addr['city_district'] ??
                    addr['county'] ??
                    '')
                .toString();

            final String district = (addr['city'] ??
                    addr['town'] ??
                    addr['district'] ??
                    addr['county'] ??
                    '')
                .toString();

            final String state = (addr['state'] ?? '').toString();

            return SearchLocation(
              name: item['display_name'] ?? '',
              latitude: double.tryParse(item['lat']?.toString() ?? '') ??
                  widget.initialLat,
              longitude: double.tryParse(item['lon']?.toString() ?? '') ??
                  widget.initialLng,
              taluk: taluk.isNotEmpty ? taluk : 'Area',
              district: district.isNotEmpty ? district : 'City',
              state: state.isNotEmpty ? state : 'State',
            );
          }).toList();
        });
      }
    } catch (e) {
      print('Error search address Nominatim: $e');
    }
  }

  void _selectSearchResult(SearchLocation loc) {
    setState(() {
      _currentLat = loc.latitude;
      _currentLng = loc.longitude;
      // Calculate offset from initialLat/Lng
      _mapOffset = Offset(
        (loc.longitude - widget.initialLng) * _zoomLevel / 0.00004,
        (widget.initialLat - loc.latitude) * _zoomLevel / 0.00004,
      );
      _searchResults = [];
      _searchController.text = loc.name;
      FocusScope.of(context).unfocus();
    });

    widget.onLocationChanged(_currentLat, _currentLng);
    if (widget.onAreaSelected != null) {
      widget.onAreaSelected!(loc.taluk, loc.district, loc.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Pan gesture detector on custom painter map
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: CustomPaint(
            painter: StylizedMapPainter(
                mapOffset: _mapOffset, zoomScale: _zoomLevel),
            child: Container(),
          ),
        ),

        // Map HUD Overlay in top corner (Search & Coordinates)
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search Input Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(
                      fontSize: 13,
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Search area (e.g. PSG Tech, HSR Layout...)',
                    hintStyle: const TextStyle(
                        color: kcLightGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: kcVoltSpareEVGreen, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded,
                                color: kcLightGrey, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Coordinates details banner below search input
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kcVoltSpareDark.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.gps_fixed_rounded,
                        color: kcVoltSpareEVGreen, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lat: ${_currentLat.toStringAsFixed(5)}, Lng: ${_currentLng.toStringAsFixed(5)}',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 10,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _recenterMap,
                      child: const Icon(Icons.my_location_rounded,
                          color: Colors.white, size: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Search Results Dropdown List overlay
        if (_searchResults.isNotEmpty)
          Positioned(
            top: 60, // directly below search box (before coordinate banner)
            left: 16,
            right: 16,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 180),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: kcVoltSpareBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: _searchResults.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: kcVoltSpareBorder),
                itemBuilder: (context, index) {
                  final loc = _searchResults[index];
                  return ListTile(
                    dense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const Icon(Icons.location_on_rounded,
                        color: kcVoltSpareEVGreen, size: 18),
                    title: Text(
                      loc.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: kcVoltSpareTextPrimary),
                    ),
                    subtitle: Text(
                      '${loc.taluk}, ${loc.district}, ${loc.state}',
                      style: const TextStyle(
                          fontSize: 10, color: kcVoltSpareTextSecondary),
                    ),
                    onTap: () => _selectSearchResult(loc),
                  );
                },
              ),
            ),
          ),

        // Centered Animated Map Pin Marker
        Align(
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Animated shadow underneath
                  Transform.translate(
                    offset: const Offset(0, 16),
                    child: Transform.scale(
                      scale: _shadowScale.value,
                      child: Container(
                        width: 12,
                        height: 4,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: kcVoltSpareDark.withValues(alpha: 0.35),
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Animated Pin
                  Transform.translate(
                    offset: Offset(0, _pinTranslationY.value),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 42,
                          color: kcVoltSpareEVGreen,
                        ),
                        Transform.translate(
                          offset: const Offset(0, -3),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Zoom Controls overlay in bottom left
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _zoomIn,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.add_rounded,
                          color: kcVoltSpareTextPrimary, size: 22),
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 1.5,
                  color: kcVoltSpareBorder,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _zoomOut,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12)),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.remove_rounded,
                          color: kcVoltSpareTextPrimary, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Compass / Map scale simulation in bottom right
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: -pi / 6, // slight offset rotation
                    child: const Icon(Icons.explore_outlined,
                        color: kcVoltSpareTextPrimary, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${(100 / _zoomLevel).round()} m',
                  style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: kcVoltSpareTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StylizedMapPainter extends CustomPainter {
  final Offset mapOffset;
  final double zoomScale;

  StylizedMapPainter({required this.mapOffset, this.zoomScale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    final relativeOffset = mapOffset;

    // Save current canvas settings
    canvas.save();

    // Scale canvas centered at the middle of the viewport
    canvas.translate(center.dx, center.dy);
    canvas.scale(zoomScale);
    canvas.translate(-center.dx, -center.dy);

    // Draw Background Land (large size to cover edges when zoomed out)
    paint.color = const Color(0xFFF4F3F0); // map background color (cream/beige)
    canvas.drawRect(
      Rect.fromLTRB(
          -size.width * 2, -size.height * 2, size.width * 3, size.height * 3),
      paint,
    );

    // Grid Coordinates helper (to draw lines scrolling with offset)
    const gridSize = 160.0;
    final startX = (relativeOffset.dx % gridSize) - gridSize - size.width;
    final startY = (relativeOffset.dy % gridSize) - gridSize - size.height;
    final endX = size.width * 2;
    final endY = size.height * 2;

    // Draw Parks (green zones)
    paint.color = const Color(0xFFD4ECD5); // lush green
    paint.style = PaintingStyle.fill;
    final parks = [
      const Offset(100, -80),
      const Offset(-300, 200),
      const Offset(400, 300),
      const Offset(-200, -400),
    ];
    for (var park in parks) {
      final rect = Rect.fromLTWH(
        center.dx + park.dx + relativeOffset.dx,
        center.dy + park.dy + relativeOffset.dy,
        180,
        120,
      );
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(16)), paint);
    }

    // Draw Water Bodies (rivers / lakes)
    paint.color = const Color(0xFFC0DAE8); // clear blue water
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 36;
    paint.strokeCap = StrokeCap.round;

    final riverPath = Path();
    riverPath.moveTo(center.dx - 600 + relativeOffset.dx,
        center.dy - 300 + relativeOffset.dy);
    riverPath.quadraticBezierTo(
      center.dx - 200 + relativeOffset.dx,
      center.dy - 100 + relativeOffset.dy,
      center.dx + relativeOffset.dx,
      center.dy + 150 + relativeOffset.dy,
    );
    riverPath.quadraticBezierTo(
      center.dx + 250 + relativeOffset.dx,
      center.dy + 350 + relativeOffset.dy,
      center.dx + 600 + relativeOffset.dx,
      center.dy + 400 + relativeOffset.dy,
    );
    canvas.drawPath(riverPath, paint);

    // Draw Buildings (grey blocks)
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFE5E2DB); // building fill grey
    final buildings = [
      const Offset(120, 100),
      const Offset(150, 110),
      const Offset(130, 150),
      const Offset(-120, -50),
      const Offset(-180, -90),
      const Offset(-140, -130),
      const Offset(50, -220),
      const Offset(-50, 240),
      const Offset(-90, 260),
    ];
    for (var b in buildings) {
      final rect = Rect.fromLTWH(
        center.dx + b.dx + relativeOffset.dx,
        center.dy + b.dy + relativeOffset.dy,
        35,
        45,
      );
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(6)), paint);
    }

    // --- Draw Bordered Roads (casings drawn first, then fills) ---
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;

    // 1. Secondary Roads - Outlines (Grey borders)
    paint.color = const Color(0xFFD2CFC7);
    paint.strokeWidth = 10;
    for (double x = startX; x < endX; x += gridSize) {
      canvas.drawLine(
          Offset(x, -size.height), Offset(x, size.height * 2), paint);
    }
    for (double y = startY; y < endY; y += gridSize) {
      canvas.drawLine(Offset(-size.width, y), Offset(size.width * 2, y), paint);
    }

    // 2. Secondary Roads - Fills (Clean White)
    paint.color = Colors.white;
    paint.strokeWidth = 6.5;
    for (double x = startX; x < endX; x += gridSize) {
      canvas.drawLine(
          Offset(x, -size.height), Offset(x, size.height * 2), paint);
    }
    for (double y = startY; y < endY; y += gridSize) {
      canvas.drawLine(Offset(-size.width, y), Offset(size.width * 2, y), paint);
    }

    // 3. Highways - Outlines (Orange/Brown borders)
    paint.color = const Color(0xFFE2AE6E);
    paint.strokeWidth = 18;
    // Diagonal Highway
    canvas.drawLine(
      Offset(center.dx - 600 + relativeOffset.dx,
          center.dy - 600 + relativeOffset.dy),
      Offset(center.dx + 600 + relativeOffset.dx,
          center.dy + 600 + relativeOffset.dy),
      paint,
    );
    // Vertical Highway
    canvas.drawLine(
      Offset(center.dx + 250 + relativeOffset.dx, -size.height),
      Offset(center.dx + 250 + relativeOffset.dx, size.height * 2),
      paint,
    );

    // 4. Highways - Fills (Google Maps Light Orange/Yellow)
    paint.color = const Color(0xFFFFE0B2);
    paint.strokeWidth = 13;
    // Diagonal Highway
    canvas.drawLine(
      Offset(center.dx - 600 + relativeOffset.dx,
          center.dy - 600 + relativeOffset.dy),
      Offset(center.dx + 600 + relativeOffset.dx,
          center.dy + 600 + relativeOffset.dy),
      paint,
    );
    // Vertical Highway
    canvas.drawLine(
      Offset(center.dx + 250 + relativeOffset.dx, -size.height),
      Offset(center.dx + 250 + relativeOffset.dx, size.height * 2),
      paint,
    );

    // --- Draw Street Names and Landmark Labels ---
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Dynamic Road Badges (white cards on top of roads)
    _drawRoadLabelBadge(
      canvas,
      textPainter,
      "Avinashi Highway (NH 544)",
      Offset(center.dx - 180 + relativeOffset.dx,
          center.dy - 180 + relativeOffset.dy),
    );
    _drawRoadLabelBadge(
      canvas,
      textPainter,
      "NSR Road",
      Offset(center.dx + 250 + relativeOffset.dx,
          center.dy - 120 + relativeOffset.dy),
    );
    _drawRoadLabelBadge(
      canvas,
      textPainter,
      "Cross Cut Road",
      Offset(startX + gridSize * 2 + 80, center.dy + 80 + relativeOffset.dy),
    );
    _drawRoadLabelBadge(
      canvas,
      textPainter,
      "DB Road",
      Offset(center.dx - 120 + relativeOffset.dx, startY + gridSize * 3 + 80),
    );

    // Draw Interactive Landmarks (markers & labels)
    _drawLandmark(
      canvas,
      textPainter,
      "VoltSpare Depot",
      Offset(center.dx - 60 + relativeOffset.dx,
          center.dy - 80 + relativeOffset.dy),
      Colors.redAccent,
    );
    _drawLandmark(
      canvas,
      textPainter,
      "Coimbatore Junction",
      Offset(center.dx - 140 + relativeOffset.dx,
          center.dy + 260 + relativeOffset.dy),
      Colors.blueAccent,
    );
    _drawLandmark(
      canvas,
      textPainter,
      "VOC Park & Zoo",
      Offset(center.dx - 220 + relativeOffset.dx,
          center.dy + 120 + relativeOffset.dy),
      Colors.green,
    );
    _drawLandmark(
      canvas,
      textPainter,
      "PSG Tech campus",
      Offset(center.dx + 180 + relativeOffset.dx,
          center.dy + 350 + relativeOffset.dy),
      Colors.orange,
    );

    // Restore canvas state
    canvas.restore();
  }

  void _drawRoadLabelBadge(
      Canvas canvas, TextPainter textPainter, String text, Offset position) {
    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        color: Color(0xFF4B5563), // Medium gray
        fontSize: 7.5,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
    textPainter.layout();

    final width = textPainter.width;
    final height = textPainter.height;

    // Badge boundary rect
    final rect = Rect.fromLTWH(position.dx - width / 2 - 8,
        position.dy - height / 2 - 4, width + 16, height + 8);

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            rect.translate(0, 1.5), const Radius.circular(8)),
        shadowPaint);

    // Draw white background
    final badgePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)), badgePaint);

    // Draw light gray border
    final borderPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)), borderPaint);

    // Draw text centered
    textPainter.paint(
        canvas, Offset(position.dx - width / 2, position.dy - height / 2));
  }

  void _drawLandmark(Canvas canvas, TextPainter textPainter, String name,
      Offset position, Color color) {
    // Draw circular pin dot
    final markerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final whiteBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw outer shadow circle
    canvas.drawCircle(position, 7, markerPaint);
    canvas.drawCircle(position, 7, whiteBorderPaint);

    // Draw text label in bubble next to marker
    textPainter.text = TextSpan(
      text: name,
      style: const TextStyle(
        color: Color(0xFF111827), // Dark text
        fontSize: 8.5,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();

    final width = textPainter.width;
    final height = textPainter.height;

    final bubbleRect = Rect.fromLTWH(
        position.dx + 12, position.dy - height / 2 - 3, width + 10, height + 6);

    // Draw bubble background
    final bubblePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..style = PaintingStyle.fill;
    final bubbleBorderPaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Draw bubble drop shadow
    final bubbleShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            bubbleRect.translate(0, 1), const Radius.circular(5)),
        bubbleShadowPaint);

    canvas.drawRRect(
        RRect.fromRectAndRadius(bubbleRect, const Radius.circular(5)),
        bubblePaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(bubbleRect, const Radius.circular(5)),
        bubbleBorderPaint);

    // Paint text inside bubble
    textPainter.paint(
        canvas, Offset(position.dx + 17, position.dy - height / 2));
  }

  @override
  bool shouldRepaint(covariant StylizedMapPainter oldDelegate) {
    return oldDelegate.mapOffset != mapOffset ||
        oldDelegate.zoomScale != zoomScale;
  }
}
