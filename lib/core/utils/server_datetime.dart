/// Parses a timestamp coming from the API.
///
/// The backend stores every time in UTC, but SQL Server round-trips its
/// `datetime2` columns with no timezone kind, so those values reach the client
/// without a trailing `Z` (e.g. `2026-07-24T18:29:34.56`). Dart's
/// [DateTime.parse] treats a zone-less string as *local time*, which for any
/// UTC+ device reads the instant hours in the past. That is harmless for a label
/// but breaks anything compared against [DateTime.now]: a dispatch offer whose
/// deadline was really 60 seconds away looked 2-3 hours expired, so the
/// countdown dropped it the instant it arrived - the provider never saw the job
/// live and watched it vanish right after a manual refresh.
///
/// A value that already carries a zone (`Z` or a numeric offset) is trusted as
/// is; only a zone-less value is reinterpreted as UTC.
DateTime? parseServerDateTime(Object? value) {
  if (value is! String || value.isEmpty) {
    return null;
  }
  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    return null;
  }
  if (parsed.isUtc || _hasExplicitZone(value)) {
    return parsed;
  }
  // Zone-less: the wall-clock is UTC, so rebuild it as a UTC instant rather than
  // letting it be read as local.
  return DateTime.utc(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
    parsed.millisecond,
    parsed.microsecond,
  );
}

final RegExp _zoneSuffix = RegExp(r'([Zz]|[+-]\d{2}:?\d{2})$');

bool _hasExplicitZone(String value) => _zoneSuffix.hasMatch(value);
