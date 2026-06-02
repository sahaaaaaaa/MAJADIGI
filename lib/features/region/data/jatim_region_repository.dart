import 'package:majadigi/features/region/data/jatim_region_service.dart';
import 'package:majadigi/features/region/data/model/region_item.dart';

class JatimRegionRepository {
  JatimRegionRepository(this._service);

  final JatimRegionService _service;

  Future<List<RegionItem>> getRegencies() {
    return _service.getRegencies();
  }

  Future<List<RegionItem>> getDistricts(String regencyId) {
    return _service.getDistricts(regencyId);
  }
}
