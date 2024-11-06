import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:wisata_app/src/data/model/wisata.dart';

@immutable
class WisataState extends Equatable {
  final List<Wisata> wisataList;

  const WisataState({required this.wisataList});

  const WisataState.initial(List<Wisata> wisataList) : this(wisataList: wisataList);

  @override
  List<Object?> get props => [wisataList];

  WisataState copyWith({List<Wisata>? wisataList}) {
    return WisataState(wisataList: wisataList ?? this.wisataList);
  }

  @override
  String toString() => 'wisataState{wisataList: $wisataList}';
}
