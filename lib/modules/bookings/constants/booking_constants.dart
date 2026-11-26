class BookingConstants {
  static const String baseUrl =
      "https://waygo-uoqs.onrender.com/api";

  // Default seat count for future use only.
  // Do not use this for unassigned demanded trips.
  static const int defaultDemandBusSeats = 50;

  // Seat status colours will be handled in SeatLayout.
  static const int maxPassengersPerBooking = 6;

  static const String paymentPending = "pending";
  static const String paymentPaid = "paid";

  static const String bookingPending = "pending_payment";
  static const String bookingConfirmed = "confirmed";
  static const String bookingCancelled = "cancelled";

  static const String demandWaiting = "waiting";
  static const String demandQualified = "qualified";
  static const String demandBusAssigned = "bus_assigned";
}