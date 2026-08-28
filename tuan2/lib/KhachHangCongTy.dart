import 'HoaDon.dart';

class KhachHangCongTy extends HoaDon {
  int _soNhanVien = 0;

  // Constructor mặc định
  KhachHangCongTy() : super() {
    _soNhanVien = 0;
  }

  // Constructor đầy đủ tham số
  KhachHangCongTy.fullPara(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
    int soNhanVien,
  ) : super.fullPara(
          maKH,
          tenKH,
          soLuong,
          giaBan,
        ) {
    _soNhanVien = soNhanVien;
  }

  // Getter
  int get soNhanVien => _soNhanVien;

  // Setter
  set soNhanVien(int value) {
    if (value >= 0) {
      _soNhanVien = value;
    }
  }

  // Tính chiết khấu
  @override
  double tinhChietKhau() {
    if (_soNhanVien > 5000) {
      return tienHang() * 0.07;
    } else if (_soNhanVien > 1000) {
      return tienHang() * 0.05;
    } else {
      return 0;
    }
  }

  // Tính trợ giá
  @override
  double tinhTroGia() {
    return 120000.0* soLuong;
  }

  @override
  String toString() {
    return 'Khách hàng công ty\t' +
        super.toString() +
        '\tSố nhân viên: $_soNhanVien';
  }
}