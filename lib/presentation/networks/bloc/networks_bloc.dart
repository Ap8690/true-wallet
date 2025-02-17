import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/services/chain/chain_service.dart';
import 'package:flutter_application_1/services/secure_storage_service/secure_storage_service.dart';
import 'package:flutter_application_1/services/wallet/models/chain_metadata.dart';

part 'networks_event.dart';
part 'networks_state.dart';

class NetworksBloc extends Bloc<NetworksEvent, NetworksState> {
  final NetworksService service;
  final SecureStorageService secureStorageService;
  NetworksBloc(this.service, this.secureStorageService)
      : super(ChainInitial()) {
    on<NetworksEvent>((event, emit) {});

    on<GetChainId>((event, emit) async {
      final response = await service.getChainId(event.rpc);
      emit(const GetChainIdLoading());
      response.fold(
        (l) {
          emit(GetChainIdFail(message: l.message));
        },
        (r) {
          emit(GetChainIdSuccess(chainId: r));
        },
      );
    });

    on<AddChain>((event, emit) async {
      try {
        emit(const AddChainLoading());
        String? chainMetaString =
            await secureStorageService.fetchWithPin("chainMeta");
        final chainJson = jsonDecode(chainMetaString!);
        List<ChainMetadata> chainList = ChainMetadata.fromJsonList(chainJson);
        chainList.add(event.chain);
        await secureStorageService.saveWithPin(
            "chainMeta", jsonEncode(ChainMetadata.toJsonList(chainList)));
        emit(AddChainSuccess(chainList: chainList));
      } catch (e) {
        emit(AddChainFail(message: e.toString()));
      }
    });

    on<RemoveChain>((event, emit) async {
      try {
        emit(const RemoveChainLoading());
        String? chainMetaString =
            await secureStorageService.fetchWithPin("chainMeta");
        final chainJson = jsonDecode(chainMetaString!);
        List<ChainMetadata> chainList = ChainMetadata.fromJsonList(chainJson);
        chainList.removeWhere((element) {
          return element.id == event.chain.id;
        });
        await secureStorageService.saveWithPin(
            "chainMeta", jsonEncode(ChainMetadata.toJsonList(chainList)));
        emit(RemoveChainSuccess(chainList: chainList));
      } catch (e) {
        emit(RemoveChainFail(message: e.toString()));
      }
    });

    on<SaveChain>((event, emit) async {
      try {
        print("Saving chain");
        emit(const SaveChainLoading());
        String? chainMetaString =
            await secureStorageService.fetchWithPin("chainMeta");
        final chainJson = jsonDecode(chainMetaString!);
        List<ChainMetadata> chainList = ChainMetadata.fromJsonList(chainJson);
        int index = chainList.indexWhere((element) {
          return element.id == event.chain.id;
        });
        chainList[index] = event.chain;
        await secureStorageService.saveWithPin(
            "chainMeta", jsonEncode(ChainMetadata.toJsonList(chainList)));
        emit(SaveChainSuccess(chainList: chainList));
      } catch (e) {
        emit(SaveChainFail(message: e.toString()));
      }
    });
  }
}
