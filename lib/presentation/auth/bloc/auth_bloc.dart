import 'dart:convert';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/secure_storage_service/secure_storage_service.dart';
import 'package:flutter_application_1/services/sharedpref/preference_service.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';
import 'package:flutter_application_1/services/wallet/models/wallet_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String fcmToken = "";
  final PreferenceService prefService;
  final SecureStorageService secureStorageService;
  AuthBloc(
    this.secureStorageService,
    this.prefService,
  ) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<addFcmToken>((event, emit) {
      log("FCM :${event.fcmToken}");
      fcmToken = event.fcmToken;
    });
    on<updateFcmToken>((event, emit) {
      //add update call endpoint
    });

    on<VerifyPin>((event, emit) async {
      emit(const VerifyPinLoading());
      try {
        final isValid = await secureStorageService.verifyPassword(event.pin);
        if (!isValid) {
          emit(const VerifyPinFailure("Invalid Password"));
          return;
        }

        String? walletMetString =
            await secureStorageService.fetchWithPin("walletMeta");
        String? chainMetaString =
            await secureStorageService.fetchWithPin("chainMeta");

        if (chainMetaString == null || walletMetString == null) {
          emit(const VerifyPinFailure("Something Went Wrong"));
          return;
        }
        
        emit(VerifyPinSuccess(
            walletMetaString: walletMetString,
            chainMetaString: chainMetaString));
      } catch (e) {
        emit(VerifyPinFailure(e.toString()));
      }
    });

    on<SetPin>((event, emit) async {
      emit(const SetPinLoading());
      try {
        // Validate password length
        if (event.pin.length < 8) {
          emit(const SetPinFailure("Password must be at least 8 characters long"));
          return;
        }

        await secureStorageService.savePassword(event.pin);
        await secureStorageService.saveWithPin(
            "walletMeta", jsonEncode(event.wallet.toJson()));
        await secureStorageService.saveWithPin(
          "chainMeta",
          jsonEncode(
            ChainMetadata.toJsonList(event.chainList),
          ),
        );

        await prefService.saveIsLoggedIn(true);
        await prefService.saveIsMpinSet(true);
        emit(const SetPinSuccess());
      } catch (e) {
        emit(SetPinFailure(e.toString()));
      }
    });
  }
}
