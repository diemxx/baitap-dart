import 'NhanVien.dart';

class CanBo extends NhanVien {
  String _chucVu = '';
  double _hsChucVu = 0;

  // Constructor mặc định
  CanBo() : super() {
    _chucVu = "Unknown";
    _hsChucVu = 0;
  }

  // Constructor đầy đủ tham số
  CanBo.fullPara(
    String manv,
    String tennv,
    double hsl,
    String pb,
    double songaylv,
    String chucvu,
    double hscv,
  )  : super.fullParra(
    manv,
    tennv,
    hsl,
    pb,
    songaylv,
) {
    _chucVu = chucvu;
    _hsChucVu = hscv;
  }

  // Getter và Setter chức vụ
  String get chucVu => _chucVu;

  set chucVu(String value) {
    if (value.isNotEmpty) {
      _chucVu = value;
    }
  }

  // Getter và Setter hệ số chức vụ
  double get hsChucVu => _hsChucVu;

  set hsChucVu(double value) {
    if (value >= 0) {
      _hsChucVu = value;
    }
  }

  // Tính lương cán bộ
  @override
  double tinhLuong() {
    return super.tinhLuong() + _hsChucVu * 1100;
  }

  // Xuất thông tin
  @override
  String toString() {
    return super.toString() +
        "\t$_chucVu\t$_hsChucVu";
  }
}