part of 'networks_bloc.dart';

sealed class NetworksEvent extends Equatable {
  const NetworksEvent();

  @override
  List<Object> get props => [];
}

class GetChainId extends NetworksEvent {
  final String rpc;
  const GetChainId({required this.rpc});
}

class AddChain extends NetworksEvent {
  final ChainMetadata chain;
  const AddChain({required this.chain});
}

class RemoveChain extends NetworksEvent {
  final ChainMetadata chain;
  const RemoveChain({required this.chain});
}

class SaveChain extends NetworksEvent {
  final ChainMetadata chain;
  const SaveChain({required this.chain});
}
