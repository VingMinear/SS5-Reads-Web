class MenuItem {
  final String title;
  final String subTitle;
  final int id;
  final dynamic icon;

  const MenuItem({
    this.icon,
    required this.title,
    this.subTitle = '',
    this.id = -1,
  });
}
