import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:majadigi/features/region/data/jatim_region_repository.dart';
import 'package:majadigi/features/region/data/jatim_region_service.dart';
import 'package:majadigi/features/region/data/model/region_item.dart';

class RegionSelectionState {
  const RegionSelectionState({
    required this.regencies,
    required this.districts,
    required this.selectedRegency,
    required this.selectedDistricts,
    required this.isLoadingRegencies,
    required this.isLoadingDistricts,
    required this.errorMessage,
  });

  final List<RegionItem> regencies;
  final List<RegionItem> districts;
  final RegionItem? selectedRegency;
  final RegionItem? selectedDistricts;
  final bool isLoadingRegencies;
  final bool isLoadingDistricts;
  final String? errorMessage;

  factory RegionSelectionState.initial() {
    return const RegionSelectionState(
      regencies: [],
      districts: [],
      selectedRegency: null,
      selectedDistricts: null,
      isLoadingRegencies: true,
      isLoadingDistricts: false,
      errorMessage: null,
    );
  }

  RegionSelectionState copyWith({
    List<RegionItem>? regencies,
    List<RegionItem>? districts,
    RegionItem? selectedRegency,
    bool clearSelectedRegency = false,
    RegionItem? selectedDistrict,
    bool clearSelectedDistrict = false,
    bool? isLoadingRegencies,
    bool? isLoadingDistricts,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RegionSelectionState(
      regencies: regencies ?? this.regencies,
      districts: districts ?? this.districts,
      selectedRegency: clearSelectedRegency
          ? null
          : (selectedRegency ?? this.selectedRegency),
      selectedDistricts: clearSelectedDistrict
          ? null
          : (selectedDistrict ?? this.selectedDistricts),
      isLoadingRegencies: isLoadingRegencies ?? this.isLoadingRegencies,
      isLoadingDistricts: isLoadingDistricts ?? this.isLoadingDistricts,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

final regionServiceProvider = Provider<JatimRegionService>((ref) {
  final service = JatimRegionService();
  ref.onDispose(service.dispose);
  return service;
});

final regionRepositoryProvider = Provider<JatimRegionRepository>((ref) {
  return JatimRegionRepository(ref.read(regionServiceProvider));
});

final regionControllerProvider =
    StateNotifierProvider<RegionController, RegionSelectionState>((ref) {
      return RegionController(ref.read(regionRepositoryProvider));
    });

class RegionController extends StateNotifier<RegionSelectionState> {
  RegionController(this._repository) : super(RegionSelectionState.initial()) {
    loadRegencies();
  }

  final JatimRegionRepository _repository;

  Future<void> loadRegencies() async {
    state = state.copyWith(isLoadingRegencies: true, clearErrorMessage: true);

    try {
      final regencies = await _repository.getRegencies();
      state = state.copyWith(
        regencies: regencies,
        isLoadingRegencies: false,
        clearErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(
        regencies: const [],
        isLoadingRegencies: false,
        errorMessage: 'Gagal memuat data kabupaten/kota Jawa Timur.',
      );
    }
  }

  Future<void> selectRegency(RegionItem regency) async {
    state = state.copyWith(
      selectedRegency: regency,
      clearSelectedDistrict: true,
      districts: const [],
      isLoadingDistricts: true,
      clearErrorMessage: true,
    );

    try {
      final districts = await _repository.getDistricts(regency.id);
      state = state.copyWith(
        districts: districts,
        isLoadingDistricts: false,
        clearErrorMessage: true,
      );
    } catch (_) {
      state = state.copyWith(
        districts: const [],
        isLoadingDistricts: false,
        errorMessage: 'Gagal memuat data kecamatan.',
      );
    }
  }

  void selectDistrict(RegionItem district) {
    state = state.copyWith(selectedDistrict: district, clearErrorMessage: true);
  }

  void resetSelection() {
    state = RegionSelectionState.initial();
    loadRegencies();
  }
}
