/// Types of garments that can be ordered
/// 
/// This enum is extensible - new types can be added without
/// affecting existing business logic.
enum GarmentType {
  /// Traditional men's garment (Arabian Peninsula)
  thobe(
    arabicName: 'ثوب',
    englishName: 'Thobe',
    requiresFullMeasurement: true,
  ),

  /// Men's formal shirt
  shirt(
    arabicName: 'قميص',
    englishName: 'Shirt',
    requiresFullMeasurement: false,
  ),

  /// Men's trousers/pants
  trousers(
    arabicName: 'بنطلون',
    englishName: 'Trousers',
    requiresFullMeasurement: false,
  ),

  /// Full suit (jacket + trousers)
  suit(
    arabicName: 'بدلة',
    englishName: 'Suit',
    requiresFullMeasurement: true,
  ),

  /// Jacket/Blazer only
  jacket(
    arabicName: 'جاكيت',
    englishName: 'Jacket',
    requiresFullMeasurement: false,
  ),

  /// Women's abaya
  abaya(
    arabicName: 'عباية',
    englishName: 'Abaya',
    requiresFullMeasurement: true,
  ),

  /// Traditional dress
  dress(
    arabicName: 'فستان',
    englishName: 'Dress',
    requiresFullMeasurement: true,
  ),

  /// Jalabiya (loose robe)
  jalabiya(
    arabicName: 'جلابية',
    englishName: 'Jalabiya',
    requiresFullMeasurement: true,
  ),

  /// Other/Custom garment
  other(
    arabicName: 'أخرى',
    englishName: 'Other',
    requiresFullMeasurement: true,
  );

  final String arabicName;
  final String englishName;
  final bool requiresFullMeasurement;

  const GarmentType({
    required this.arabicName,
    required this.englishName,
    required this.requiresFullMeasurement,
  });
}

