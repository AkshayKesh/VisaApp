import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/country_list.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_provider.dart';
import 'package:register_visa_web_app/shared/widgets/app_drop_down.dart';

class StepTripDetails extends ConsumerStatefulWidget {
  const StepTripDetails({super.key, this.destinationCountry = 'India'});

  final String destinationCountry;

  @override
  ConsumerState<StepTripDetails> createState() => _StepTripDetailsState();
}

class _StepTripDetailsState extends ConsumerState<StepTripDetails> {
  final _arrivalDateController = TextEditingController();
  final _arrivalDateKey = GlobalKey();
  String? _arrivalPointId;
  final List<String?> _countriesBeforeIndia = [null];
  DateTime? _arrivalDate;
  OverlayEntry? _calendarOverlay;

  void _syncToState() {
    final dateStr = _arrivalDate != null
        ? '${_arrivalDate!.year}/${_arrivalDate!.month.toString().padLeft(2, '0')}/${_arrivalDate!.day.toString().padLeft(2, '0')}'
        : null;
    ref
        .read(evisaApplicationProvider.notifier)
        .setTripDetails(arrivalDate: dateStr, arrivalPoint: _arrivalPointId, countryBefore: _countriesBeforeIndia.whereType<String>().toList());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = ref.read(evisaApplicationProvider);
      if (s.arrivalDate != null && s.arrivalDate!.isNotEmpty) {
        final parts = s.arrivalDate!.replaceAll('-', '/').split(RegExp(r'[/-]'));
        if (parts.length >= 3) {
          final y = int.tryParse(parts[0]);
          final m = int.tryParse(parts[1]);
          final d = int.tryParse(parts[2]);
          if (y != null && m != null && d != null) {
            setState(() {
              _arrivalDate = DateTime(y, m, d);
              _arrivalDateController.text = '${m.toString().padLeft(2, '0')}/${d.toString().padLeft(2, '0')}/$y';
            });
          }
        }
      }
      if (s.arrivalPoint != null && s.arrivalPoint!.isNotEmpty) setState(() => _arrivalPointId = s.arrivalPoint);
      if (s.countryBefore != null && s.countryBefore!.isNotEmpty) {
        setState(() {
          _countriesBeforeIndia
            ..clear()
            ..addAll(s.countryBefore!.map((e) => e as String?));
        });
      }
    });
  }

  void _pickArrivalDate() {
    if (_calendarOverlay != null) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initialDate = _arrivalDate ?? today;
    final firstDate = today;
    final lastDate = today.add(const Duration(days: 365 * 2));
    final theme = Theme.of(context);

    final overlay = OverlayEntry(
      builder: (overlayContext) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _calendarOverlay?.remove();
                _calendarOverlay = null;
                setState(() {});
              },
            ),
          ),
          Positioned(
            left: _getDropdownLeft(),
            top: _getDropdownTop(),
            child: Theme(
              data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(onSurface: AppColors.darkTextColor, onPrimary: AppColors.lightBackground),
              ),
              child: SizedBox(
                width: 450,
                height: 380,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.textFieldBorderColor),
                    ),
                    child: CalendarDatePicker(
                      initialDate: initialDate,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      onDateChanged: (picked) {
                        setState(() {
                          _arrivalDate = picked;
                          _arrivalDateController.text =
                              '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
                          _syncToState();
                        });
                        _calendarOverlay?.remove();
                        _calendarOverlay = null;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    _calendarOverlay = overlay;
    Overlay.of(context).insert(overlay);
    setState(() {});
  }

  double _getDropdownLeft() {
    final box = _arrivalDateKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return 24;
    return box.localToGlobal(Offset.zero).dx;
  }

  double _getDropdownTop() {
    final box = _arrivalDateKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return 100;
    final pos = box.localToGlobal(Offset.zero);
    return pos.dy + box.size.height + 4;
  }

  @override
  void dispose() {
    _arrivalDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Arrival date',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        8.ht,
        Container(
          key: _arrivalDateKey,
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.textFieldBorderColor),
          ),
          child: TextFormField(
            controller: _arrivalDateController,
            readOnly: true,
            onTap: _pickArrivalDate,
            decoration: InputDecoration(
              hintText: 'MM/DD/YYYY',
              hintStyle: context.bodyMedium?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              suffixIcon: Padding(padding: const EdgeInsets.only(right: 12), child: Image.asset(ImageUrl.calenderIcon, height: 20, width: 20)),
            ),
            style: context.bodyMedium?.copyWith(fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
          ),
        ),
        24.ht,
        Text(
          'Arrival point in ${widget.destinationCountry}',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
        ),
        8.ht,
        ref
            .watch(airportListProvider)
            .when(
              data: (items) => _buildAirportDropdown(
                value: _arrivalPointId,
                hint: 'Select arrival point',
                items: items,
                onChanged: (id) {
                  setState(() => _arrivalPointId = id);
                  _syncToState();
                },
              ),
              loading: () => _buildAirportDropdown(
                value: _arrivalPointId,
                hint: 'Select arrival point',
                items: const [],
                onChanged: (id) {
                  setState(() => _arrivalPointId = id);
                  _syncToState();
                },
              ),
              error: (_, __) => _buildAirportDropdown(
                value: _arrivalPointId,
                hint: 'Select arrival point',
                items: const [],
                onChanged: (id) {
                  setState(() => _arrivalPointId = id);
                  _syncToState();
                },
              ),
            ),
        const SizedBox(height: 6),
        Text(
          "If your arrival point isn't listed, we can't process your request.",
          style: context.bodySmall?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular, fontSize: 12),
        ),
        24.ht,
        Text(
          'List the countries you have visited in the last 10 years',
          style: context.titleSmall?.copyWith(fontSize: 14, fontFamily: FontFamily.outfitSemiBold, color: AppColors.darkTextColor),
        ),
        12.ht,

        ...List.generate(_countriesBeforeIndia.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppCustomDropdown<String>(
                    title: 'Country before ${widget.destinationCountry}',
                    hint: 'Country before ${widget.destinationCountry}',
                    maxHeight: 180,
                    value: countryFromName(_countriesBeforeIndia[i]),
                    itemLabel: (v) => v,
                    onChanged: (c) {
                      setState(() {
                        _countriesBeforeIndia[i] = c.name;
                        _syncToState();
                      });
                    },
                  ),
                ),
                if (_countriesBeforeIndia.length > 1) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _countriesBeforeIndia.removeAt(i);
                        _syncToState();
                      });
                    },
                    icon: Icon(Icons.delete_outline, color: AppColors.redColor, size: 22),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ],
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              _countriesBeforeIndia.add(null);
              _syncToState();
            });
          },
          icon: Icon(Icons.add, color: AppColors.primaryBlue, size: 18),
          label: Text(
            'Add another',
            style: context.bodyMedium?.copyWith(color: AppColors.primaryBlue, fontFamily: FontFamily.outfitSemiBold),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.2),
            foregroundColor: AppColors.primaryBlue,
            side: const BorderSide(color: AppColors.primaryBlue),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget _buildAirportDropdown({
    required String? value,
    required String hint,
    required List<AirportItem> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textFieldBorderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.any((e) => e.id == value) ? value : null,
          isExpanded: true,
          hint: Text(
            hint,
            style: context.bodyMedium?.copyWith(color: AppColors.lightSubText, fontFamily: FontFamily.outfitRegular, fontSize: 14),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.lightSubText),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e.id,
                  child: Text(
                    e.name,
                    style: TextStyle(fontSize: 12, fontFamily: FontFamily.outfitRegular, color: AppColors.darkTextColor),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
