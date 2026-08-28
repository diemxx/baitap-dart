import 'HoaDon.dart';

class DaiLyCap1 extends HoaDon {
  int _soNamHopTac = 0;

  // Constructor mặc định
  DaiLyCap1() : super() {
    _soNamHopTac = 0;
  }

  // Constructor đầy đủ tham số
  DaiLyCap1.fullPara(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
    int soNamHopTac,
  ) : super.fullPara(
          maKH,
          tenKH,
          soLuong,
          giaBan,
        ) {
    _soNamHopTac = soNamHopTac;
  }

  // Getter
  int get soNamHopTac => _soNamHopTac;

  // Setter
  set soNamHopTac(int value) {
    if (value >= 0) {
      _soNamHopTac = value;
    }
  }

  // Tính chiết khấu
  @override
  double tinhChietKhau() {
    double phanTram = 0.30;

    // Nếu hợp tác > 5 năm
    if (_soNamHopTac > 5) {
      phanTram += (_soNamHopTac - 5) * 0.01;
    }

    // Tối đa 35%
    if (phanTram > 0.35) {
      phanTram = 0.35;
    }

    return tienHang() * phanTram;
  }

  // Đại lý không có trợ giá
  @override
  double tinhTroGia() {
    return 0;
  }

  @override
  String toString() {
    return 'Đại lý cấp 1\t' +
        super.toString() +
        '\tSố năm hợp tác: $_soNamHopTac';
  }
}