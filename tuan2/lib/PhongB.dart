import 'PhongThue.dart';

class PhongB extends PhongThue {
  double _giatui = 0;
  int _soMay = 0;

  // Constructor mặc định
  PhongB() : super() {
    _giatui = 0;
    _soMay = 0;
  }

  // Constructor đầy đủ tham số
  PhongB.fullPara(
    String maPhong,
    int soNguoi,
    double soDien,
    double soNuoc,
    double giatui,
    int soMay,
  ) : super.fullPara(
          maPhong,
          soNguoi,
          soDien,
          soNuoc,
        ) {
    _giatui = giatui;
    _soMay = soMay;
  }

  // Getter
  double get giatui => _giatui;

  int get soMay => _soMay;

  // Setter
  set giatui(double value) {
    if (value >= 0) {
      _giatui = value;
    }
  }

  set soMay(int value) {
    if (value >= 0) {
      _soMay = value;
    }
  }

  // Tính tiền phòng loại B
  @override
  double tinhTienPhong() {
    return 2000 +
        2 * soDien +
        8 * soNuoc +
        _giatui * 5 +
        _soMay * 100;
  }

  @override
  String toString() {
    return "Loại B\t" +
        super.toString() +
        "\tGiặt ủi: $_giatui\tSố máy: $_soMay";
  }
}