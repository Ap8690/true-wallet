part of 'networks_bloc.dart';

sealed class NetworksState extends Equatable {
  const NetworksState();

  @override
  List<Object> get props => [];
}

final class ChainInitial extends NetworksState {}

final class GetChainIdSuccess extends NetworksState {
  final String chainId;
  const GetChainIdSuccess({required this.chainId});
}

final class GetChainIdLoading extends NetworksState {
  const GetChainIdLoading();
}

final class GetChainIdFail extends NetworksState {
  final String message;
  const GetChainIdFail({required this.message});
}

final class AddChainSuccess extends NetworksState {
  final List<ChainMetadata> chainList;
  const AddChainSuccess({required this.chainList});
}

final class AddChainLoading extends NetworksState {
  const AddChainLoading();
}

final class AddChainFail extends NetworksState {
  final String message;
  const AddChainFail({required this.message});
}

final class RemoveChainSuccess extends NetworksState {
  final List<ChainMetadata> chainList;
  const RemoveChainSuccess({required this.chainList});
}

final class RemoveChainLoading extends NetworksState {
  const RemoveChainLoading();
}

final class RemoveChainFail extends NetworksState {
  final String message;
  const RemoveChainFail({required this.message});
}

final class SaveChainSuccess extends NetworksState {
  final List<ChainMetadata> chainList;
  const SaveChainSuccess({required this.chainList});
}

final class SaveChainLoading extends NetworksState {
  const SaveChainLoading();
}

final class SaveChainFail extends NetworksState {
  final String message;
  const SaveChainFail({required this.message});
}
