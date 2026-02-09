import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/error_widget.dart';
import 'package:register_visa_web_app/features/auth/domain/hive_user_model.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_passing_model.dart';

import 'app.dart';

void main() async {
  //* Initialize Flutter bindings and Hive database on app startup. Register the adapter for UserModel, and open required Hive boxes.
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(error: details.exception, error1: "");
  };
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('user');

  await Hive.openBox('settings');
  Hive.registerAdapter(VisaApplicationModelAdapter());

  await Hive.openBox<VisaApplicationModel>('visaApplications');

  //* Retrieve the stored user (if any) upon startup and set the global authentication token accordingly.
  final Box<UserModel> userBox = Hive.box<UserModel>('user');
  final UserModel? existingUser = userBox.isNotEmpty ? userBox.getAt(0) : null;

  if (existingUser != null) {
    AppConstants.authToken =
        existingUser.token; //* Set the global auth token if a user exists.
  } else {
    AppConstants.authToken = ""; //* No user found: global auth token is empty.
  }

  //* Start the app.
  runApp(const MyApp());
}
