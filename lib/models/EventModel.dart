class EventData {
  final int id;
  final int categoryId;
  final String name;
  final int free;
  final String shortDescription;
  final String longDescription;
  final int minTeamSize;
  final int maxTeamSize;
  final int delCardType;
  final int visible;
  final int canRegister;
  final List<String> tags;
  final bool isLiked;

  EventData(
      {this.id,
      this.categoryId,
      this.name,
      this.free,
      this.shortDescription,
      this.longDescription,
      this.minTeamSize,
      this.maxTeamSize,
      this.delCardType,
      this.visible,
      this.canRegister,
      this.tags,
      this.isLiked});
}
