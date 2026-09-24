import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';
import 'package:spare_shop/ui/common/app_colors.dart';
import 'package:spare_shop/ui/common/responsive.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/widgets/common/voltspare_widgets.dart';
import 'package:stacked/stacked.dart';

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
                          hint: 'Peelamedu',
                          icon: Icons.location_city_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: viewModel.districtController,
                          label: 'District / City',
                          hint: 'Coimbatore',
                          icon: Icons.map_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: viewModel.stateController,
                          label: 'State',
                          hint: 'Tamil Nadu',
                          icon: Icons.explore_outlined,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: viewModel.postalCodeController,
                          label: 'Postal / PIN Code',
                          hint: '641001',
                          icon: Icons.pin_drop_outlined,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  if (viewModel.locationName != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: kcVoltSpareEVGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: kcVoltSpareEVGreen.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: kcVoltSpareEVGreen.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.hub_outlined,
                                color: kcVoltSpareEVGreen, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Hub: ${viewModel.locationName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: kcVoltSpareTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  viewModel.distanceFromLocationKm != null
                                      ? 'Distance: ${viewModel.distanceFromLocationKm!.toStringAsFixed(2)} km (Eligible for fast delivery)'
                                      : 'Assigned to nearest service center',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: kcVoltSpareTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                            color: kcVoltSpareEVGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: kcVoltSpareEVGreen.withValues(alpha: 0.3)),
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
                    height: isDesktop ? 500 : 360,
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
                      onAreaSelected: (taluk, district, state, [postalCode]) {
                        viewModel.onAreaSelected(taluk, district, state, postalCode);
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
  final String postalCode;

  const SearchLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.taluk,
    required this.district,
    required this.state,
    this.postalCode = '',
  });
}

class InteractiveMapPicker extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final Function(double lat, double lng) onLocationChanged;
  final Function(String taluk, String district, String state, [String? postalCode])? onAreaSelected;

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
  late final MapController _mapController;
  late double _currentLat;
  late double _currentLng;
  bool _isDragging = false;
  bool _isSearching = false;
  bool _isReverseGeocoding = false;

  final _searchController = TextEditingController();
  List<SearchLocation> _searchResults = [];

  Timer? _searchDebounceTimer;
  Timer? _panDebounceTimer;
  CancelToken? _searchCancelToken;
  CancelToken? _reverseGeoCancelToken;
  final Dio _dio = Dio();

  late AnimationController _pinAnimationController;
  late Animation<double> _pinTranslationY;
  late Animation<double> _shadowScale;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentLat = widget.initialLat;
    _currentLng = widget.initialLng;

    _pinAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _pinTranslationY = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _pinAnimationController, curve: Curves.easeOut),
    );

    _shadowScale = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _pinAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _panDebounceTimer?.cancel();
    _searchCancelToken?.cancel();
    _reverseGeoCancelToken?.cancel();
    _pinAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture) {
      if (!_isDragging) {
        _isDragging = true;
        _pinAnimationController.forward();
      }

      setState(() {
        _currentLat = camera.center.latitude;
        _currentLng = camera.center.longitude;
      });

      _panDebounceTimer?.cancel();
      _panDebounceTimer = Timer(const Duration(milliseconds: 500), () {
        _finalizePinMove(camera.center.latitude, camera.center.longitude);
      });
    }
  }

  void _onMapEvent(MapEvent event) {
    if (event is MapEventMoveEnd) {
      _panDebounceTimer?.cancel();
      _panDebounceTimer = Timer(const Duration(milliseconds: 150), () {
        final center = _mapController.camera.center;
        _finalizePinMove(center.latitude, center.longitude);
      });
    }
  }

  void _finalizePinMove(double lat, double lng) {
    if (!mounted) return;
    if (_isDragging) {
      setState(() {
        _isDragging = false;
        _currentLat = lat;
        _currentLng = lng;
      });
      _pinAnimationController.reverse();
    }

    widget.onLocationChanged(_currentLat, _currentLng);
    _performReverseGeocode(_currentLat, _currentLng);
  }

  Future<void> _performReverseGeocode(double lat, double lng) async {
    _reverseGeoCancelToken?.cancel();
    _reverseGeoCancelToken = CancelToken();

    setState(() {
      _isReverseGeocoding = true;
    });

    try {
      final response = await _dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'format': 'json',
          'addressdetails': '1',
        },
        options: Options(
          headers: {'User-Agent': 'VoltSpare_App/1.0'},
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
        cancelToken: _reverseGeoCancelToken,
      );

      if (response.statusCode == 200 && response.data is Map && mounted) {
        final data = response.data as Map;
        final addr = (data['address'] as Map?) ?? {};

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
        final String postalCode = (addr['postcode'] ?? '').toString();

        if (widget.onAreaSelected != null) {
          widget.onAreaSelected!(
            taluk.isNotEmpty ? taluk : 'Area',
            district.isNotEmpty ? district : 'City',
            state.isNotEmpty ? state : 'State',
            postalCode,
          );
        }
      }
    } catch (_) {
      // Graceful error handling - maintain current user values
    } finally {
      if (mounted) {
        setState(() {
          _isReverseGeocoding = false;
        });
      }
    }
  }

  void _onSearchChanged(String query) {
    _searchDebounceTimer?.cancel();

    if (query.trim().length < 3) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    _searchDebounceTimer = Timer(const Duration(milliseconds: 550), () async {
      _searchCancelToken?.cancel();
      _searchCancelToken = CancelToken();

      if (mounted) {
        setState(() {
          _isSearching = true;
        });
      }

      try {
        final response = await _dio.get(
          'https://nominatim.openstreetmap.org/search',
          queryParameters: {
            'q': query.trim(),
            'format': 'json',
            'addressdetails': '1',
            'limit': '6',
            'countrycodes': 'in',
          },
          options: Options(
            headers: {'User-Agent': 'VoltSpare_App/1.0'},
            receiveTimeout: const Duration(seconds: 6),
            sendTimeout: const Duration(seconds: 6),
          ),
          cancelToken: _searchCancelToken,
        );

        if (response.statusCode == 200 && response.data is List && mounted) {
          final list = response.data as List;
          setState(() {
            _searchResults = list.map((item) {
              final addr = (item['address'] as Map?) ?? {};

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
              final String postalCode = (addr['postcode'] ?? '').toString();

              return SearchLocation(
                name: item['display_name'] ?? '',
                latitude: double.tryParse(item['lat']?.toString() ?? '') ??
                    widget.initialLat,
                longitude: double.tryParse(item['lon']?.toString() ?? '') ??
                    widget.initialLng,
                taluk: taluk.isNotEmpty ? taluk : 'Area',
                district: district.isNotEmpty ? district : 'City',
                state: state.isNotEmpty ? state : 'State',
                postalCode: postalCode,
              );
            }).toList();
          });
        }
      } catch (_) {
        // Silently handle search network issues
      } finally {
        if (mounted) {
          setState(() {
            _isSearching = false;
          });
        }
      }
    });
  }

  void _selectSearchResult(SearchLocation loc) {
    setState(() {
      _currentLat = loc.latitude;
      _currentLng = loc.longitude;
      _searchResults = [];
      _searchController.text = loc.name;
      FocusScope.of(context).unfocus();
    });

    _mapController.move(LatLng(loc.latitude, loc.longitude), 16.0);
    widget.onLocationChanged(loc.latitude, loc.longitude);
    if (widget.onAreaSelected != null) {
      widget.onAreaSelected!(loc.taluk, loc.district, loc.state, loc.postalCode);
    }
  }

  void _recenterMap() {
    setState(() {
      _currentLat = widget.initialLat;
      _currentLng = widget.initialLng;
      _searchController.clear();
      _searchResults = [];
    });
    _mapController.move(LatLng(widget.initialLat, widget.initialLng), 15.0);
    widget.onLocationChanged(_currentLat, _currentLng);
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    if (currentZoom < 18.5) {
      _mapController.move(_mapController.camera.center, currentZoom + 1.0);
    }
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    if (currentZoom > 4.5) {
      _mapController.move(_mapController.camera.center, currentZoom - 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Real OpenStreetMap Layer using FlutterMap
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(widget.initialLat, widget.initialLng),
            initialZoom: 15.0,
            minZoom: 4.0,
            maxZoom: 19.0,
            onPositionChanged: _onPositionChanged,
            onMapEvent: _onMapEvent,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.voltspare.spare_shop',
              maxZoom: 19,
            ),
          ],
        ),

        // Center Pin with micro-animation and shadow
        Align(
          alignment: Alignment.center,
          child: AnimatedBuilder(
            animation: _pinAnimationController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Ground Pin Shadow
                  Transform.translate(
                    offset: const Offset(0, 16),
                    child: Transform.scale(
                      scale: _shadowScale.value,
                      child: Container(
                        width: 14,
                        height: 5,
                        decoration: BoxDecoration(
                          color: kcVoltSpareDark.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: kcVoltSpareDark.withValues(alpha: 0.3),
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Animated Center Pin Teardrop
                  Transform.translate(
                    offset: Offset(0, -18 + _pinTranslationY.value),
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
                            width: 12,
                            height: 12,
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

        // Map HUD Overlay in Top Corner (Search + Coordinates Banner)
        Positioned(
          top: 14,
          left: 14,
          right: 14,
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
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: kcVoltSpareBorder),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: const TextStyle(
                      fontSize: 13,
                      color: kcVoltSpareTextPrimary,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Search location (e.g. Madukkarai, Coimbatore...)',
                    hintStyle: const TextStyle(
                        color: kcLightGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                    prefixIcon: _isSearching
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kcVoltSpareEVGreen,
                              ),
                            ),
                          )
                        : const Icon(Icons.search_rounded,
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

              // Coordinates & Status Banner
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kcVoltSpareDark.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      _isReverseGeocoding
                          ? Icons.sync_rounded
                          : Icons.gps_fixed_rounded,
                      color: kcVoltSpareEVGreen,
                      size: 14,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Lat: ${_currentLat.toStringAsFixed(5)}, Lng: ${_currentLng.toStringAsFixed(5)}',
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 11,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Recenter Map',
                      child: InkWell(
                        onTap: _recenterMap,
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.my_location_rounded,
                              color: Colors.white, size: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Search Results Dropdown List Overlay
        if (_searchResults.isNotEmpty)
          Positioned(
            top: 62,
            left: 14,
            right: 14,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.18),
              clipBehavior: Clip.antiAlias,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kcVoltSpareBorder),
                ),
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
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    leading: const Icon(Icons.location_on_rounded,
                        color: kcVoltSpareEVGreen, size: 20),
                    title: Text(
                      loc.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: kcVoltSpareTextPrimary),
                    ),
                    subtitle: Text(
                      '${loc.taluk}, ${loc.district}, ${loc.state}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10.5, color: kcVoltSpareTextSecondary),
                    ),
                    onTap: () => _selectSearchResult(loc),
                  );
                },
              ),
            ),
          ),
        ),

        // Zoom Controls overlay in Bottom Left
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
              border: Border.all(color: kcVoltSpareBorder),
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
                      width: 38,
                      height: 38,
                      child: Icon(Icons.add_rounded,
                          color: kcVoltSpareTextPrimary, size: 22),
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 1.0,
                  color: kcVoltSpareBorder,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _zoomOut,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12)),
                    child: const SizedBox(
                      width: 38,
                      height: 38,
                      child: Icon(Icons.remove_rounded,
                          color: kcVoltSpareTextPrimary, size: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // OpenStreetMap Attribution badge bottom-right
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: kcVoltSpareBorder.withValues(alpha: 0.6)),
            ),
            child: const Text(
              '© OpenStreetMap contributors',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: kcVoltSpareTextSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
