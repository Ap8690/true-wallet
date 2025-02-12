// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chain_metadata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChainMetadataAdapter extends TypeAdapter<ChainMetadata> {
  @override
  final int typeId = 7;

  @override
  ChainMetadata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChainMetadata(
      id: fields[0] as String,
      balance: fields[8] as double,
      logo: fields[3] as String?,
      isDefault: fields[6] as bool,
      symbol: fields[7] as String,
      chainId: fields[1] as String,
      name: fields[2] as String,
      tokens: (fields[9] as List).cast<TokenMetaData>(),
      isTestnet: fields[4] as bool,
      rpc: fields[5] as String,
      explorerUrl: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChainMetadata obj) {
    writer
      ..writeByte(10)
      ..write(obj.explorerUrl)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.chainId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.logo)
      ..writeByte(4)
      ..write(obj.isTestnet)
      ..writeByte(5)
      ..write(obj.rpc)
      ..writeByte(6)
      ..write(obj.isDefault)
      ..writeByte(7)
      ..write(obj.symbol)
      ..writeByte(8)
      ..write(obj.balance)
      ..writeByte(9)
      ..write(obj.tokens);
      
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChainMetadataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TokenMetaDataAdapter extends TypeAdapter<TokenMetaData> {
  @override
  final int typeId = 8;

  @override
  TokenMetaData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokenMetaData(
        balance: fields[1] as double,
        isNative: fields[2] as bool,
        logo: fields[6] as String?,
        contract: fields[5] as String,
        name: fields[0] as String,
        symbol: fields[3] as String,
        decimal: fields[4] as int,
        usdBalance: fields[7] as double);
  }

  @override
  void write(BinaryWriter writer, TokenMetaData obj) {
    writer
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.balance)
      ..writeByte(2)
      ..write(obj.isNative)
      ..writeByte(3)
      ..write(obj.symbol)
      ..writeByte(4)
      ..write(obj.decimal)
      ..writeByte(5)
      ..write(obj.contract)
      ..writeByte(6)
      ..write(obj.logo)
      ..writeByte(7)
      ..write(obj.usdBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenMetaDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
