import 'package:flutter/material.dart';
import 'package:register_visa_web_app/core/constants/app_color.dart';
import 'package:register_visa_web_app/core/constants/image_url.dart';
import 'package:register_visa_web_app/core/utils/spacing_extension.dart';
import 'package:register_visa_web_app/core/utils/text_theme_extension.dart';
import 'package:register_visa_web_app/shared/widgets/app_bar_widget.dart';
import 'package:register_visa_web_app/shared/widgets/app_button.dart';
import 'package:register_visa_web_app/shared/widgets/app_footer.dart';
import 'package:register_visa_web_app/shared/widgets/app_text_field.dart';
import 'package:register_visa_web_app/shared/widgets/custom_icon_button.dart';

class VisaProcessPage extends StatefulWidget {
  const VisaProcessPage({super.key});

  @override
  State<VisaProcessPage> createState() => _VisaProcessPageState();
}

class _VisaProcessPageState extends State<VisaProcessPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<bool> _isLoggedIn = ValueNotifier<bool>(
    true,
  ); // Assuming logged in for this page

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    ); // For Traveller 1, Traveller 2
  }

  @override
  void dispose() {
    _tabController.dispose();
    _isLoggedIn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(),
            _buildHeader(context),
            20.ht,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTravellerInformationSection(context, isSmallScreen),
                  30.ht,
                  _buildPassportPhotoUpload(context, isSmallScreen),
                  30.ht,
                  _buildTravellerDetailsForm(context, isSmallScreen),
                  30.ht,
                  _buildVisaDetailsAutoFilled(context, isSmallScreen),
                  30.ht,
                  _buildPassportCopyUpload(context, isSmallScreen),
                  40.ht,
                  _buildSubmitButton(context),
                ],
              ),
            ),
            40.ht,
            AppFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              '4 Dec, 12:14 AM',
              style: context.bodyMedium?.copyWith(
                color: AppColors.darkBackground,
              ),
            ),
          ),
          20.ht,
          Row(
            children: [
              Image.asset(ImageUrl.edtiIcon),
              10.wt,
              Text(
                'Valid From',
                style: context.bodySmall?.copyWith(
                  color: AppColors.lightSubText,
                ),
              ),
              10.wt,
              Text(
                'Dec 3 2025',
                style: context.bodyMedium?.copyWith(
                  color: AppColors.darkBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              30.wt,
              const Icon(
                Icons.flight_takeoff,
                color: AppColors.darkBackground,
                size: 20,
              ),
              30.wt,
              Text(
                'Valid Till',
                style: context.bodySmall?.copyWith(
                  color: AppColors.lightSubText,
                ),
              ),
              10.wt,
              Text(
                'Feb 1 2026',
                style: context.bodyMedium?.copyWith(
                  color: AppColors.darkBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          20.ht,
          Row(
            children: [
              Image.asset(ImageUrl.headerBackground, height: 24),
              10.wt,
              Text(
                'United Arab Emirates',
                style: context.titleMedium?.copyWith(
                  color: AppColors.darkBackground,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTravellerInformationSection(
    BuildContext context,
    bool isSmallScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Traveller Information',
              style: context.titleMedium?.copyWith(
                color: AppColors.darkBackground,
              ),
            ),
            CustomIconButton(
              text: 'Add Traveller',
              onPressed: () {},
              icon: const Icon(Icons.add, color: AppColors.lightBackground),
              color: AppColors.primaryBlue,
              textColor: AppColors.lightBackground,
              borderRadius: 8,
              height: 35,
              width: 150,
              textSize: 14,
              iconSize: 16,
            ),
          ],
        ),
        20.ht,
        TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primaryBlue,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: AppColors.lightSubText,
          labelStyle: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: context.bodyLarge,
          tabs: const [
            Tab(text: 'Traveller 1'),
            Tab(text: 'Traveller 2'),
          ],
        ),
        20.ht,
        SizedBox(
          height: 800, // Placeholder height, will adjust dynamically
          child: TabBarView(
            controller: _tabController,
            children: [
              // Traveller 1 Form (will be populated later)
              Container(color: Colors.transparent), // Placeholder
              // Traveller 2 Form (will be populated later)
              Container(color: Colors.transparent), // Placeholder
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPassportPhotoUpload(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passport Photo *',
          style: context.bodyMedium?.copyWith(color: AppColors.darkBackground),
        ),
        10.ht,
        Container(
          height: 150,
          width: isSmallScreen ? double.infinity : 300,
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: BorderRadius.circular(12),
            //border: Border.all(color: AppColors.lightGrey, style: BorderStyle.dashed),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.upload_file,
                size: 40,
                color: AppColors.lightSubText,
              ),
              10.ht,
              Text(
                'Drag & drop or click to upload',
                style: context.bodySmall?.copyWith(
                  color: AppColors.lightSubText,
                ),
              ),
              5.ht,
              Text(
                'JPG, PNG (Max 5MB)',
                style: context.bodySmall?.copyWith(
                  color: AppColors.lightSubText,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTravellerDetailsForm(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextFormField(
          title: 'First Name*',
          hint: 'Enter first name',
          prefixIcon: Icons.person_outline,
          controller: TextEditingController(),
        ),
        20.ht,
        AppTextFormField(
          title: 'Last Name*',
          hint: 'Enter last name',
          prefixIcon: Icons.person_outline,
          controller: TextEditingController(),
        ),
        20.ht,
        AppTextFormField(
          title: 'Passport Number*',
          hint: 'Enter passport number',
          prefixIcon: Icons.credit_card,
          controller: TextEditingController(),
        ),
        20.ht,
        AppTextFormField(
          title: 'Passport Expiry Date*',
          hint: 'dd/mm/yyyy',
          prefixIcon: Icons.calendar_today_outlined,
          controller: TextEditingController(),
        ),
      ],
    );
  }

  Widget _buildVisaDetailsAutoFilled(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Visa Details (Auto-filled)',
          style: context.titleMedium?.copyWith(color: AppColors.darkBackground),
        ),
        20.ht,
        Card(
          elevation: 3,
          color: AppColors.lightBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: isSmallScreen
                ? _buildSmallScreenVisaDetails()
                : _buildLargeScreenVisaDetails(),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScreenVisaDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVisaDetailItem('Entry Type', 'Single Entry'),
        10.ht,
        _buildVisaDetailItem('Visa Type', 'Tourist Visa'),
        10.ht,
        _buildVisaDetailItem('Length of Stay', '30 Days'),
        10.ht,
        _buildVisaDetailItem('Validity', '90 Days'),
      ],
    );
  }

  Widget _buildLargeScreenVisaDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildVisaDetailItem('Entry Type', 'Single Entry'),
        _buildVisaDetailItem('Visa Type', 'Tourist Visa'),
        _buildVisaDetailItem('Length of Stay', '30 Days'),
        _buildVisaDetailItem('Validity', '90 Days'),
      ],
    );
  }

  Widget _buildVisaDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodySmall?.copyWith(color: AppColors.lightSubText),
        ),
        5.ht,
        Text(
          value,
          style: context.bodyMedium?.copyWith(
            color: AppColors.darkBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPassportCopyUpload(BuildContext context, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Passport Copy *',
          style: context.bodyMedium?.copyWith(color: AppColors.darkBackground),
        ),
        10.ht,
        Container(
          height: 150,
          width: isSmallScreen ? double.infinity : 400,
          decoration: BoxDecoration(
            color: AppColors.lightCard,
            borderRadius: BorderRadius.circular(12),
            //border: Border.all(color: AppColors.lightGrey, style: BorderStyle.dashed),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.upload_file,
                size: 40,
                color: AppColors.lightSubText,
              ),
              10.ht,
              Text(
                'Drag & drop your passport scan or click to upload',
                style: context.bodySmall?.copyWith(
                  color: AppColors.lightSubText,
                ),
              ),
              5.ht,
              Text(
                'PDF, JPG, PNG (Max 10MB)',
                style: context.bodySmall?.copyWith(
                  color: AppColors.lightSubText,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return PrimaryButton(
      text: 'Submit Application',
      onPressed: () {
        // Handle submit application logic
      },
      color: AppColors.primaryBlue,
      textColor: Colors.white,
      height: 50,
      borderRadius: 12,
    );
  }
}
