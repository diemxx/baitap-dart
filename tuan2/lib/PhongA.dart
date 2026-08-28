import 'PhongThue.dart';

class PhongA extends PhongThue {
  int _soNguoiThan = 0;

  // Constructor mặc định
  PhongA() : super() {
    _soNguoiThan = 0;
  }

  // Constructor đầy đủ tham số
  PhongA.fullPara(
    String maPhong,
    int soNguoi,
    double soDien,
    double soNuoc,
    int soNguoiThan,
  ) : super.fullPara(
          maPhong,
          soNguoi,
          soDien,
          soNuoc,
        ) {
    _soNguoiThan = soNguoiThan;
  }

  // Getter
  int get soNguoiThan => _soNguoiThan;

  // Setter
  set soNguoiThan(int value) {
    if (value >= 0) {
      _soNguoiThan = value;
    }
  }

  // Tính tiền phòng loại A
  @override
  double tinhTienPhong() {
    return 1400 +
        2 * soDien +
        8 * soNuoc +
        50 * _soNguoiThan;
  }

  @override
  String toString() {
    return "Loại A\t" +
        super.toString() +
        "\tSố người thân: $_soNguoiThan";
  }
}