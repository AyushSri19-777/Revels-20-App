class CategoryData {
  final int id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final String type;
  final String cc1Name;
  final String cc1Contact;
  final String cc2Name;
  final String cc2Contact;
  final List<int> eventIds;

  CategoryData(
      {this.id,
      this.name,
      this.shortDescription,
      this.longDescription,
      this.type,
      this.cc1Name,
      this.cc1Contact,
      this.cc2Name,
      this.cc2Contact,
      this.eventIds});
}
