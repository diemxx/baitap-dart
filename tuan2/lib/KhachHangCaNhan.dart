import 'HoaDon.dart';

class KhachHangCaNhan extends HoaDon {
  double _khoangCach = 0;

  // Constructor mặc định
  KhachHangCaNhan() : super() {
    _khoangCach = 0;
  }

  // Constructor đầy đủ tham số
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

  // Getter
  double get khoangCach => _khoangCach;

  // Setter
  set khoangCach(double value) {
    if (value >= 0) {
      _khoangCach = value;
    }
  }

  // Tính chiết khấu
  @override
  double tinhChietKhau() {
    double chietKhau = 0;

    // Nếu số lượng >= 3 thì giảm 5%
    if (soLuong >= 3) {
      chietKhau += tienHang() * 0.05;
    }

    // Nếu khoảng cách < 10km
    if (_khoangCach < 10) {
      chietKhau += 50000 * soLuong;
    }

    return chietKhau;
  }

  // Tính trợ giá
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
    return 'Khách hàng cá nhân\t' +
        super.toString() +
        '\tKhoảng cách: $_khoangCach km';
  }
}