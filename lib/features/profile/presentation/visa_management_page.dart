import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/font_family.dart';
import 'package:register_visa_web_app/core/constants/router/router_names.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/profile/providers/current_tab_provider.dart';
import 'package:register_visa_web_app/shared/widgets/app_bar_widget.dart';

class VisaManagementPage extends StatefulWidget {
  const VisaManagementPage({super.key, required this.child});
  final Widget child;

  @override
  State<VisaManagementPage> createState() => _VisaManagementPageState();
}

class _VisaManagementPageState extends State<VisaManagementPage> {
  int currentId = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  // helper to build each tab child (icon + text)

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = getSize(context);

    final isWeb = (screenSize == ScreenSize.extraLarge) || (screenSize == ScreenSize.large);

    return Scaffold(
      key: _scaffoldKey,
      drawer: !isWeb
          ? Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // 👈 removes all corners
              ),
              child: Column(
                children: [
                  10.ht,
                  _sideItem(context, Icons.document_scanner, 'Visa', index: 0),
                  10.ht,
                  _sideItem(context, Icons.folder, 'My Documents', index: 1),
                  10.ht,
                  _sideItem(context, Icons.credit_card, 'Card', index: 2),
                  10.ht,
                  _sideItem(context, Icons.help_outline, 'Help', index: 3),
                  10.ht,
                  _sideItem(context, Icons.lock, 'Change Password', index: 4),
                ],
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(),
          if (!isWeb)
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(Icons.menu, color: Colors.black),
            ),
          Expanded(
            child: Center(
              child: ConstrainedBox(constraints: const BoxConstraints(), child: !isWeb ? _buildSmall(context) : _buildLarge(context)),
            ),
          ),
          //const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildLarge(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sideItem(context, Icons.document_scanner, 'Visa', index: 0),
              const SizedBox(height: 8),
              _sideItem(context, Icons.folder, 'My Documents', index: 1),
              const SizedBox(height: 8),
              _sideItem(context, Icons.credit_card, 'Card', index: 2),
              const SizedBox(height: 8),
              _sideItem(context, Icons.help_outline, 'Help', index: 3),
              const SizedBox(height: 8),
              _sideItem(context, Icons.help_outline, 'Change Password', index: 4),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [widget.child]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmall(BuildContext context) {
    return widget.child;
  }

  Widget _sideItem(BuildContext context, IconData icon, String title, {int index = 0}) {
    return Consumer(
      builder: (context, ref, child) {
        final currentTab = ref.watch(currentTabProvider);
        return InkWell(
          onTap: () => {
            _scaffoldKey.currentState?.closeDrawer(),
            ref.read(currentTabProvider.notifier).setTab(index),

            if (index == 0)
              {context.go(RouterNames.visaPage)}
            else if (index == 1)
              {context.go(RouterNames.document)}
            else if (index == 2)
              {context.go(RouterNames.card)}
            else if (index == 3)
              {context.go(RouterNames.help)}
            else if (index == 4)
              {context.go(RouterNames.forgotPassword)},
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: currentTab == index ? AppColors.primaryBlue.withValues(alpha: 0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: context.bodyMedium?.copyWith(fontFamily: FontFamily.outfitMedium, color: AppColors.primaryBlue),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
