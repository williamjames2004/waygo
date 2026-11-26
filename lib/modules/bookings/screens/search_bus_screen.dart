
import 'package:flutter/material.dart';
import 'package:waygo/modules/bookings/screens/bus_list_screen.dart';

import '../models/district_model.dart';
import '../models/busstand_model.dart';
import '../models/busstop_model.dart';
import '../services/location_service.dart';

typedef BusSearchCallback = void Function({
required String startingDistrictId,
required String endingDistrictId,
required String startingBusstandId,
required String endingBusstandId,
required String startingBusstopId,
required String endingBusstopId,
required String journeyDate,
});

class SearchBusScreen extends StatefulWidget {
  final BusSearchCallback? onSearch;

  const SearchBusScreen({
    super.key,
    this.onSearch,
  });

  @override
  State<SearchBusScreen> createState() => _SearchBusScreenState();
}

class _SearchBusScreenState extends State<SearchBusScreen> {
  final LocationService _locationService = LocationService();

  List<DistrictModel> _districts = [];
  List<BusStandModel> _startingBusStands = [];
  List<BusStandModel> _endingBusStands = [];
  List<BusStopModel> _startingBusStops = [];
  List<BusStopModel> _endingBusStops = [];

  String? _startingDistrictId;
  String? _endingDistrictId;

  String? _startingBusstandId;
  String? _endingBusstandId;

  String? _startingBusstopId;
  String? _endingBusstopId;

  DateTime? _journeyDate = DateTime.now();

  bool _loadingDistricts = true;
  bool _loadingStartingStands = false;
  bool _loadingEndingStands = false;
  bool _loadingStartingStops = false;
  bool _loadingEndingStops = false;

  @override
  void initState() {
    super.initState();
    _loadDistricts();
  }

  Future<void> _loadDistricts() async {
    try {
      final districts = await _locationService.getDistricts();

      if (!mounted) return;

      setState(() {
        _districts = districts;
        _loadingDistricts = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingDistricts = false;
      });

      _showError('Unable to load districts: $e');
    }
  }

  Future<void> _selectStartingDistrict(String? districtId) async {
    if (districtId == null) return;

    setState(() {
      _startingDistrictId = districtId;

      _startingBusstandId = null;
      _startingBusstopId = null;

      _startingBusStands = [];
      _startingBusStops = [];

      _loadingStartingStands = true;
    });

    try {
      final stands = await _locationService.getBusStands(districtId);

      if (!mounted) return;

      setState(() {
        _startingBusStands = stands;
        _loadingStartingStands = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingStartingStands = false;
      });

      _showError('Unable to load starting bus stands: $e');
    }
  }

  Future<void> _selectEndingDistrict(String? districtId) async {
    if (districtId == null) return;

    setState(() {
      _endingDistrictId = districtId;

      _endingBusstandId = null;
      _endingBusstopId = null;

      _endingBusStands = [];
      _endingBusStops = [];

      _loadingEndingStands = true;
    });

    try {
      final stands = await _locationService.getBusStands(districtId);

      if (!mounted) return;

      setState(() {
        _endingBusStands = stands;
        _loadingEndingStands = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingEndingStands = false;
      });

      _showError('Unable to load ending bus stands: $e');
    }
  }

  Future<void> _selectStartingBusStand(String? busstandId) async {
    if (busstandId == null) return;

    setState(() {
      _startingBusstandId = busstandId;

      _startingBusstopId = null;
      _startingBusStops = [];

      _loadingStartingStops = true;
    });

    try {
      final stops = await _locationService.getBusStops(busstandId);

      if (!mounted) return;

      setState(() {
        _startingBusStops = stops;
        _loadingStartingStops = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingStartingStops = false;
      });

      _showError('Unable to load starting bus stops: $e');
    }
  }

  Future<void> _selectEndingBusStand(String? busstandId) async {
    if (busstandId == null) return;

    setState(() {
      _endingBusstandId = busstandId;

      _endingBusstopId = null;
      _endingBusStops = [];

      _loadingEndingStops = true;
    });

    try {
      final stops = await _locationService.getBusStops(busstandId);

      if (!mounted) return;

      setState(() {
        _endingBusStops = stops;
        _loadingEndingStops = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingEndingStops = false;
      });

      _showError('Unable to load ending bus stops: $e');
    }
  }

  Future<void> _selectJourneyDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _journeyDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    setState(() {
      _journeyDate = selectedDate;
    });
  }

  void _searchBuses() {
    if (_startingDistrictId == null ||
        _endingDistrictId == null ||
        _startingBusstandId == null ||
        _endingBusstandId == null ||
        _journeyDate == null) {
      _showError('Please complete all journey details.');
      return;
    }

    if (_startingBusstandId == _endingBusstandId) {
      _showError('Starting and ending bus stands cannot be the same.');
      return;
    }

    final date = _journeyDate!;

    final journeyDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusListScreen(
          startingDistrictId: _startingDistrictId!,
          endingDistrictId: _endingDistrictId!,
          startingBusstandId: _startingBusstandId!,
          endingBusstandId: _endingBusstandId!,
          startingBusstopId: _startingBusstopId!,
          endingBusstopId: _endingBusstopId!,
          journeyDate: journeyDate,
        ),
      ),
    );
  }

  void _swapLocations() {
    if (_startingDistrictId == null || _endingDistrictId == null) {
      return;
    }

    final startingDistrict = _startingDistrictId;
    final endingDistrict = _endingDistrictId;

    final startingStand = _startingBusstandId;
    final endingStand = _endingBusstandId;

    final startingStop = _startingBusstopId;
    final endingStop = _endingBusstopId;

    // Swap the district selections.
    setState(() {
      _startingDistrictId = endingDistrict;
      _endingDistrictId = startingDistrict;

      _startingBusstandId = null;
      _endingBusstandId = null;

      _startingBusstopId = null;
      _endingBusstopId = null;

      _startingBusStands = [];
      _endingBusStands = [];

      _startingBusStops = [];
      _endingBusStops = [];
    });

    // Reload dependent dropdowns.
    _selectStartingDistrict(endingDistrict);
    _selectEndingDistrict(startingDistrict);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required String hint,
    required List<T> items,
    required String? selectedValue,
    required String Function(T) getId,
    required String Function(T) getName,
    required ValueChanged<String?>? onChanged,
    bool loading = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: loading ? 'Loading...' : hint,
            prefixIcon: const Icon(Icons.location_on_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: getId(item),
              child: Text(
                getName(item),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: enabled && !loading ? onChanged : null,
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    final date = _journeyDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Journey Date',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectJourneyDate,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.calendar_month_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              date == null
                  ? 'Select journey date'
                  : '${date.day.toString().padLeft(2, '0')}/'
                  '${date.month.toString().padLeft(2, '0')}/'
                  '${date.year}',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 650;

        final fieldWidth = isWide
            ? (constraints.maxWidth - 20) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            SizedBox(
              width: fieldWidth,
              child: _buildDropdown<DistrictModel>(
                label: 'Starting District',
                hint: 'Select starting district',
                items: _districts,
                selectedValue: _startingDistrictId,
                getId: (item) => item.districtId,
                getName: (item) => item.districtName,
                onChanged: _selectStartingDistrict,
                loading: _loadingDistricts,
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _buildDropdown<DistrictModel>(
                label: 'Ending District',
                hint: 'Select ending district',
                items: _districts,
                selectedValue: _endingDistrictId,
                getId: (item) => item.districtId,
                getName: (item) => item.districtName,
                onChanged: _selectEndingDistrict,
                loading: _loadingDistricts,
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _buildDropdown<BusStandModel>(
                label: 'Starting Bus Stand',
                hint: 'Select starting bus stand',
                items: _startingBusStands,
                selectedValue: _startingBusstandId,
                getId: (item) => item.busstandId,
                getName: (item) => item.busstandName,
                onChanged: _selectStartingBusStand,
                loading: _loadingStartingStands,
                enabled: _startingDistrictId != null,
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _buildDropdown<BusStandModel>(
                label: 'Ending Bus Stand',
                hint: 'Select ending bus stand',
                items: _endingBusStands,
                selectedValue: _endingBusstandId,
                getId: (item) => item.busstandId,
                getName: (item) => item.busstandName,
                onChanged: _selectEndingBusStand,
                loading: _loadingEndingStands,
                enabled: _endingDistrictId != null,
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _buildDropdown<BusStopModel>(
                label: 'Starting Bus Stop',
                hint: 'Select starting bus stop',
                items: _startingBusStops,
                selectedValue: _startingBusstopId,
                getId: (item) => item.busstopId,
                getName: (item) => item.busstopName,
                onChanged: (value) {
                  setState(() {
                    _startingBusstopId = value;
                  });
                },
                enabled: _startingBusstandId != null,
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _buildDropdown<BusStopModel>(
                label: 'Ending Bus Stop',
                hint: 'Select ending bus stop',
                items: _endingBusStops,
                selectedValue: _endingBusstopId,
                getId: (item) => item.busstopId,
                getName: (item) => item.busstopName,
                onChanged: (value) {
                  setState(() {
                    _endingBusstopId = value;
                  });
                },
                enabled: _endingBusstandId != null,
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: _buildDatePicker(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Buses'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Plan Your Journey',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Choose your starting point and destination.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLocationFields(),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _swapLocations,
                            icon: const Icon(Icons.swap_vert),
                            label: const Text('Swap Locations'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _loadingDistricts
                                ? null
                                : _searchBuses,
                            icon: const Icon(Icons.search),
                            label: const Text('Search Buses'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}