String formatTanggal(String dateStr) {
  // Parsing string tanggal ke DateTime
  DateTime dateTime = DateTime.parse(dateStr);

  // Mendefinisikan hari dalam bahasa Indonesia
  final List<String> hari = [
    'Minggu',
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu'
  ];

  // Mendefinisikan bulan dalam bahasa Indonesia
  final List<String> bulan = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];

  // Mendapatkan nama hari dan bulan
  String namaHari = hari[dateTime.weekday % 7];
  String namaBulan = bulan[dateTime.month - 1];

  // Membentuk string dengan format yang diinginkan
  String formattedDate =
      '$namaHari ${dateTime.day} $namaBulan ${dateTime.year}';

  return formattedDate;
}
