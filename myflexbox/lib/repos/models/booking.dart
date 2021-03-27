

class Booking {
  final int status;
  final int bookingId;
  final String parcelNumber;
  final String externalId;
  final int lockerId;
  final int compartmentId;
  final double compartmentLength;
  final double compartmentHeight;
  final double compartmentDepth;
  final String deliveryCode;
  final String collectingCode;
  final String state;
  final String startTimeSystem;
  final String startTime;
  final String endTime;
  final String endTimeSystem;
  final String message;

  Booking(
      {this.status,
        this.bookingId,
        this.parcelNumber,
        this.externalId,
        this.lockerId,
        this.compartmentId,
        this.compartmentLength,
        this.compartmentHeight,
        this.compartmentDepth,
        this.deliveryCode,
        this.collectingCode,
        this.state,
        this.startTimeSystem,
        this.startTime,
        this.endTime,
        this.endTimeSystem,
        this.message});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      status: json['status'] as int,
      bookingId: json['bookingId'] as int,
      parcelNumber: json['parcelNumber'] as String,
      externalId: json['externalId'] as String,
      lockerId: json['lockerId'] as int,
      compartmentId: json['compartmentId'] as int,
      compartmentLength: json['compartmentLength'] as double,
      compartmentHeight: json['compartmentHeight'] as double,
      compartmentDepth: json['compartmentDepth'] as double,
      deliveryCode: json['deliveryCode'] as String,
      collectingCode: json['collectingCode'] as String,
      state: json['state'] as String,
      startTimeSystem: json['startTimeSystem'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      endTimeSystem: json['endTimeSystem'] as String,
      message: json['message'] as String,
    );
  }
}