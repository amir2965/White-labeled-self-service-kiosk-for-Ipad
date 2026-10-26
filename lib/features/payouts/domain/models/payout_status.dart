enum PayoutStatus {
  pending,
  processing,
  paid,
  failed,
  reversed;

  String get displayName {
    switch (this) {
      case PayoutStatus.pending:
        return 'Pending';
      case PayoutStatus.processing:
        return 'Processing';
      case PayoutStatus.paid:
        return 'Paid';
      case PayoutStatus.failed:
        return 'Failed';
      case PayoutStatus.reversed:
        return 'Reversed';
    }
  }

  /// Returns a subtle color for UI display (non-alarming)
  String get colorHex {
    switch (this) {
      case PayoutStatus.pending:
        return '#F5F5F5'; // light gray
      case PayoutStatus.processing:
        return '#E3F2FD'; // very light blue
      case PayoutStatus.paid:
        return '#F1F8F4'; // very light green
      case PayoutStatus.failed:
        return '#FFF4E5'; // very light amber
      case PayoutStatus.reversed:
        return '#F5F5F5'; // light gray
    }
  }

  String get textColorHex {
    switch (this) {
      case PayoutStatus.pending:
        return '#666666';
      case PayoutStatus.processing:
        return '#1976D2';
      case PayoutStatus.paid:
        return '#2E7D32';
      case PayoutStatus.failed:
        return '#F57C00';
      case PayoutStatus.reversed:
        return '#666666';
    }
  }
}
