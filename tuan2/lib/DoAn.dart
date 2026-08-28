import 'MonHoc.dart';

class DoAn extends MonHoc {
  double _diemGVHD = 0;
  double _diemGVPB = 0;

  DoAn() : super() {
    _diemGVHD = 0;
    _diemGVPB = 0;
  }

  DoAn.fullPara(
    String maMH,
    String tenMH,
    int soTinChi,
    double diemGVHD,
    double diemGVPB,
  ) : super.fullPara(
          maMH,
          tenMH,
          soTinChi,
        ) {
    _diemGVHD = diemGVHD;
    _diemGVPB = diemGVPB;
  }

  double get diemGVHD => _diemGVHD;

  set diemGVHD(double value) {
    if (value >= 0 && value <= 10) {
      _diemGVHD = value;
    }
  }

  double get diemGVPB => _diemGVPB;

  set diemGVPB(double value) {
    if (value >= 0 && value <= 10) {
      _diemGVPB = value;
    }
  }

  @override
  double tinhDTB() {
    return (_diemGVHD + _diemGVPB) / 2;
  }

  @override
  String toString() {
    return 'Đồ án\t' +
        super.toString() +
        '\tGVHD: $_diemGVHD'
        '\tGVPB: $_diemGVPB';
  }
}