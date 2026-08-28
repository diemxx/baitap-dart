import 'MonHoc.dart';

class LyThuyet extends MonHoc {
  double _diemTieuLuan = 0;
  double _diemCuoiKy = 0;

  LyThuyet() : super() {
    _diemTieuLuan = 0;
    _diemCuoiKy = 0;
  }

  LyThuyet.fullPara(
    String maMH,
    String tenMH,
    int soTinChi,
    double diemTieuLuan,
    double diemCuoiKy,
  ) : super.fullPara(
          maMH,
          tenMH,
          soTinChi,
        ) {
    _diemTieuLuan = diemTieuLuan;
    _diemCuoiKy = diemCuoiKy;
  }

  double get diemTieuLuan => _diemTieuLuan;

  set diemTieuLuan(double value) {
    if (value >= 0 && value <= 10) {
      _diemTieuLuan = value;
    }
  }

  double get diemCuoiKy => _diemCuoiKy;

  set diemCuoiKy(double value) {
    if (value >= 0 && value <= 10) {
      _diemCuoiKy = value;
    }
  }

  @override
  double tinhDTB() {
    return _diemTieuLuan * 0.3 +
        _diemCuoiKy * 0.7;
  }

  @override
  String toString() {
    return 'Lý thuyết\t' + super.toString() +
        '\tTiểu luận: $_diemTieuLuan'
        '\tCuối kỳ: $_diemCuoiKy';
  }
}