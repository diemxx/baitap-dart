class PhongThue {
  String _maPhong = '';
  int _soNguoi = 0;
  double _soDien = 0;
  double _soNuoc = 0;

  // Constructor mặc định
  PhongThue() {
    _maPhong = "P000";
    _soNguoi = 0;
    _soDien = 0;
    _soNuoc = 0;
  }

  // Constructor đầy đủ tham số
  PhongThue.fullPara(
    String maPhong,
    int soNguoi,
    double soDien,
    double soNuoc,
  ) {
    _maPhong = maPhong;
    _soNguoi = soNguoi;
    _soDien = soDien;
    _soNuoc = soNuoc;
  }

  // Getter
  String get maPhong => _maPhong;

  int get soNguoi => _soNguoi;

  double get soDien => _soDien;

  double get soNuoc => _soNuoc;

  // Setter
  set maPhong(String value) {
    if (value.isNotEmpty) {
      _maPhong = value;
    }
  }

  set soNguoi(int value) {
    if (value >= 0) {
      _soNguoi = value;
    }
  }

  set soDien(double value) {
    if (value >= 0) {
      _soDien = value;
    }
  }

  set soNuoc(double value) {
    if (value >= 0) {
      _soNuoc = value;
    }
  }

  // Phương thức tính tiền phòng
  double tinhTienPhong() {
    return 0;
  }

  @override
  String toString() {
    return "$_maPhong\t"
        "$_soNguoi\t"
        "$_soDien\t"
        "$_soNuoc\t"
        "${tinhTienPhong()}";
  }
}