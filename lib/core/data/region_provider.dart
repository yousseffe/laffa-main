import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/region.dart';

class RegionProvider extends ChangeNotifier {
  final GetStorage _storage = GetStorage();

  String? _regionId;
  String? _regionName;
  double _deliveryFee = 0;

  String? get regionId => _regionId;
  String? get regionName => _regionName;
  double get deliveryFee => _deliveryFee;
  bool get hasRegion => _regionId != null;

  RegionProvider() {
    _regionId = _storage.read('regionId');
    _regionName = _storage.read('regionName');
    _deliveryFee = (_storage.read('regionDeliveryFee') ?? 0).toDouble();
  }

  void setRegion(Region region) {
    _regionId = region.sId;
    _regionName = region.name;
    _deliveryFee = region.deliveryFee ?? 0;
    _storage.write('regionId', region.sId);
    _storage.write('regionName', region.name);
    _storage.write('regionDeliveryFee', region.deliveryFee ?? 0);
    notifyListeners();
  }
}
