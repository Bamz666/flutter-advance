// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuModel _$MenuModelFromJson(Map<String, dynamic> json) => MenuModel(
  id: (json['id'] as num).toInt(),
  nama: json['nama'] as String,
  harga: (json['harga'] as num).toDouble(),
  kategori: json['kategori'] as String,
  deskripsi: json['deskripsi'] as String?,
  foto: json['foto'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$MenuModelToJson(MenuModel instance) => <String, dynamic>{
  'id': instance.id,
  'nama': instance.nama,
  'harga': instance.harga,
  'deskripsi': instance.deskripsi,
  'kategori': instance.kategori,
  'foto': instance.foto,
  'status': instance.status,
};
