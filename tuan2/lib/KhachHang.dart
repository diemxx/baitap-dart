import 'HoaDon.dart';

class KhachHangCaNhan extends HoaDon {
  double _khoangCach = 0;

  KhachHangCaNhan() : super() {
    _khoangCach = 0;
  }

  KhachHangCaNhan.fullPara(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
    double khoangCach,
  ) : super.fullPara(
          maKH,
          tenKH,
          soLuong,
          giaBan,
        ) {
    _khoangCach = khoangCach;
  }

  double get khoangCach => _khoangCach;

  set khoangCach(double value) {
    if (value >= 0) {
      _khoangCach = value;
    }
  }

  @override
  double tinhChietKhau() {
    double chietKhau = 0;

    if (soLuong >= 3) {
      chietKhau += tienHang() * 0.05;
    }

    if (_khoangCach < 10) {
      chietKhau += 50000 * soLuong;
    }

    return chietKhau;
  }

  @override
  double tinhTroGia() {
    double troGia = tienHang() * 0.02;

    if (soLuong > 2) {
      troGia += 100000;
    }

    return troGia;
  }

  @override
  String toString() {
    return 'Cá nhân\t' +
        super.toString() +
        '\tKhoảng cách: $_khoangCach km';
  }
}