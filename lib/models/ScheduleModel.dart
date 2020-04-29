class ScheduleData {
  final int id;
  final int eventId;
  final int round;
  final String name;
  final int categoryId;
  final DateTime startTime;
  final DateTime endTime;
  final String location;

  ScheduleData(
      {this.id,
      this.eventId,
      this.round,
      this.name,
      this.categoryId,
      this.startTime,
      this.endTime,
      this.location});
}