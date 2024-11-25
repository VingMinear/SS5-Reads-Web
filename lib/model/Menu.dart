class MenuItem {
  final String title;
  final String subTitle;
  final int id;
  final dynamic icon;
  final bool isSelected;
  const MenuItem({
    this.icon,
    required this.title,
    required this.isSelected,
    this.subTitle = '',
    this.id = -1,
  });
}
