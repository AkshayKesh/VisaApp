import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/country_list.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';

class AppDropdown<T> extends StatelessWidget {
  final String title;
  final String hint;
  final T? value;
  final List<String> items;
  final ValueChanged<T?> onChanged;
  final bool isCountyPicker;

  const AppDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.isCountyPicker = false,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        /// Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: isCountyPicker
              ? AppCountryPicker(onChanged: (value) => onChanged)
              : DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    style: context.bodySmall?.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    value: value,
                    hint: Text(
                      hint,
                      style: context.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: true,
                    onChanged: onChanged,
                    items: items
                        .map(
                          (e) => DropdownMenuItem<T>(
                            value: e as T,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
      ],
    );
  }
}

class AppCountryPicker extends StatelessWidget {
  const AppCountryPicker({super.key, required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CountryPickerDropdown(
      isExpanded: true,
      initialValue: 'AR',
      itemBuilder: _buildDropdownItem,
      //itemFilter: (Country c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
      priorityList: [
        CountryPickerUtils.getCountryByIsoCode('GB'),
        CountryPickerUtils.getCountryByIsoCode('CN'),
      ],
      sortComparator: (Country a, Country b) => a.isoCode.compareTo(b.isoCode),
      onValuePicked: (Country country) {
        onChanged(country.name);
      },
    );
  }
}

Widget _buildDropdownItem(Country country) => Row(
  children: <Widget>[
    CountryPickerUtils.getDefaultFlagImage(country),
    SizedBox(width: 8.0),
    Text("+${country.phoneCode}(${country.isoCode})"),
  ],
);

final doubleValueProvider = StateProvider<double>((ref) => 0.0);

class AppCustomDropdown<T> extends ConsumerStatefulWidget {
  const AppCustomDropdown({
    super.key,
    required this.title,
    required this.hint,

    required this.itemLabel,
    required this.onChanged,
    this.value,
    this.maxHeight = 300,
  });

  final String title;
  final String hint;
  final Country? value;

  final String Function(String) itemLabel;
  final ValueChanged<Country> onChanged;
  final double maxHeight;

  @override
  ConsumerState<AppCustomDropdown<T>> createState() =>
      _AppCustomDropdownState<T>();
}

// class _AppCustomDropdownState<T> extends ConsumerState<AppCustomDropdown<T>>
//     with WidgetsBindingObserver {
//   final GlobalKey _buttonKey = GlobalKey();
//   final LayerLink _layerLink = LayerLink();

//   OverlayEntry? _overlayEntry;
//   bool _isOpen = false;
//   double _buttonWidth = 0;

//   @override
//   void initState() {
//     super.initState();
//     //WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);

//     // Close overlay WITHOUT setState
//     _close(fromDispose: true);

//     super.dispose();
//   }

//   @override
//   void didChangeMetrics() {
//     if (_isOpen) {
//       _close();
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) _open();
//       });
//     }
//   }

// void _toggle() {
//     if (!mounted) return;
//     _isOpen ? _close() : _open();
//   }

//   void _open() {
//       if (!mounted) return;

//     _measureWidth();
//     _overlayEntry = _buildOverlay();
//     Overlay.of(context).insert(_overlayEntry!);

//     setState(() => _isOpen = true);
//   }

//  void _close({bool fromDispose = false}) {
//     _overlayEntry?.remove();
//     _overlayEntry = null;

//     if (!fromDispose && mounted) {
//       setState(() => _isOpen = false);
//     } else {
//       _isOpen = false;
//     }
//   }

//   void _measureWidth() {
//     final renderBox =
//         _buttonKey.currentContext!.findRenderObject() as RenderBox;
//     _buttonWidth = renderBox.size.width;
//   }

//   OverlayEntry _buildOverlay() {
//     return OverlayEntry(
//       builder: (_) => Positioned(
//         width: _buttonWidth,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           offset: const Offset(0, 56),
//           showWhenUnlinked: false,
//           child: Material(
//             elevation: 6,
//             borderRadius: BorderRadius.circular(14),
//             child: Container(
//               constraints: BoxConstraints(maxHeight: widget.maxHeight),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 itemCount: allCountryList.length,
//                 itemBuilder: (_, index) {
//                   final item = allCountryList[index];
//                   return InkWell(
//                     onTap: () {
//                       widget.onChanged(item);
//                       _close();
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 14,
//                       ),
//                       child: Row(
//                         children: [
//                           CountryPickerUtils.getDefaultFlagImage(item),
//                           SizedBox(width: 8.0),
//                           Expanded(child: Text(item.name)),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
//         const SizedBox(height: 8),
//         CompositedTransformTarget(
//           link: _layerLink,
//           child: GestureDetector(
//             key: _buttonKey,
//             onTap: _toggle,
//             child: Container(
//               height: 52,
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: Colors.grey.shade300),
//                 color: Colors.white,
//               ),
//               child: widget.value != null
//                   ? Row(
//                       children: [
//                         CountryPickerUtils.getDefaultFlagImage(widget.value!),
//                         SizedBox(width: 8.0),
//                         Expanded(child: Text(widget.value!.name)),
//                       ],
//                     )
//                   : Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             widget.hint,
//                             style: TextStyle(
//                               color: widget.value != null
//                                   ? Colors.black
//                                   : Colors.grey,
//                             ),
//                           ),
//                         ),
//                         Icon(
//                           _isOpen
//                               ? Icons.keyboard_arrow_up
//                               : Icons.keyboard_arrow_down,
//                           color: Colors.grey,
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class _AppCustomDropdownState<T> extends ConsumerState<AppCustomDropdown<T>>
    with WidgetsBindingObserver {
  final GlobalKey _buttonKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  double _buttonWidth = 0;

  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Country>> _filteredList =
      ValueNotifier<List<Country>>(allCountryList);

  @override
  void initState() {
    super.initState();
    _filteredList.value = allCountryList;

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _filteredList.dispose();

    _close(fromDispose: true);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      _filteredList.value = allCountryList;
    } else {
      _filteredList.value = allCountryList.where((country) {
        return country.name.toLowerCase().contains(query) ||
            country.isoCode.toLowerCase().contains(query) ||
            country.phoneCode.toLowerCase().contains(query);
      }).toList();
    }
  }

  void _toggle() {
    if (!mounted) return;
    _isOpen ? _close() : _open();
  }

  void _open() {
    if (!mounted) return;

    _measureWidth();
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);

    setState(() => _isOpen = true);
  }

  void _close({bool fromDispose = false}) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    _filteredList.value = allCountryList;

    if (!fromDispose && mounted) {
      setState(() => _isOpen = false);
    } else {
      _isOpen = false;
    }
  }

  void _measureWidth() {
    final renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    _buttonWidth = renderBox.size.width;
  }

  OverlayEntry _buildOverlay() {
    return OverlayEntry(
      builder: (_) => Positioned(
        width: _buttonWidth,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 56),
          showWhenUnlinked: false,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              constraints: BoxConstraints(maxHeight: widget.maxHeight),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  /// 🔍 Search Field
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: _searchController,
                      style: context.bodyMedium,
                      decoration: InputDecoration(
                        hintText: "Search country...",
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.darkSubText,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),

                  const Divider(height: 1),

                  /// 📋 List
                  Expanded(
                    child: ValueListenableBuilder<List<Country>>(
                      valueListenable: _filteredList,
                      builder: (_, list, _) {
                        if (list.isEmpty) {
                          return const Center(child: Text("No result found"));
                        }

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: list.length,
                          itemBuilder: (_, index) {
                            final item = list[index];

                            return InkWell(
                              onTap: () {
                                widget.onChanged(item);
                                _close();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    CountryPickerUtils.getDefaultFlagImage(
                                      item,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(item.name)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            key: _buttonKey,
            onTap: _toggle,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: widget.value != null
                  ? Row(
                      children: [
                        CountryPickerUtils.getDefaultFlagImage(widget.value!),
                        const SizedBox(width: 8),
                        Expanded(child: Text(widget.value!.name)),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.hint,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        Icon(
                          _isOpen
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
