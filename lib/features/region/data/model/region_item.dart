class RegionItem {
  const RegionItem({required this.id, required this.name});

  final String id;
  final String name;

  factory RegionItem.fromJson(Map<String, dynamic> json) {
    return RegionItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
