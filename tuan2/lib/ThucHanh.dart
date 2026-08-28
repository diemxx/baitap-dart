import 'MonHoc.dart';

class ThucHanh extends MonHoc {
  double _diemKT1 = 0;
  double _diemKT2 = 0;
  double _diemKT3 = 0;

  ThucHanh() : super() {
    _diemKT1 = 0;
    _diemKT2 = 0;
    _diemKT3 = 0;
  }

  ThucHanh.fullPara(
    String maMH,
    String tenMH,
    int soTinChi,
    double diemKT1,
    double diemKT2,
    double diemKT3,
  ) : super.fullPara(
          maMH,
          tenMH,
          soTinChi,
        ) {
    _diemKT1 = diemKT1;
    _diemKT2 = diemKT2;
    _diemKT3 = diemKT3;
  }

  double get diemKT1 => _diemKT1;

  set diemKT1(double value) {
    if (value >= 0 && value <= 10) {
      _diemKT1 = value;
    }
  }

  double get diemKT2 => _diemKT2;

  set diemKT2(double value) {
    if (value >= 0 && value <= 10) {
      _diemKT2 = value;
    }
  }

  double get diemKT3 => _diemKT3;

  set diemKT3(double value) {
    if (value >= 0 && value <= 10) {
      _diemKT3 = value;
    }
  }

  @override
  double tinhDTB() {
    return (_diemKT1 + _diemKT2 + _diemKT3) / 3;
  }

  @override
  String toString() {
    return 'Thực hành\t' +
        super.toString() +
        '\tKT1: $_diemKT1'
        '\tKT2: $_diemKT2'
        '\tKT3: $_diemKT3';
  }
}