import 'HoaDon.dart';

class QuanLyHoaDon {
  List<HoaDon> dsHoaDon = [];

  // Thêm hóa đơn
  void them(HoaDon hd) {
    dsHoaDon.add(hd);
  }

  // Xuất danh sách
  void xuatDanhSach() {
    for (HoaDon hd in dsHoaDon) {
      print(hd);
    }
  }

  // Tổng thành tiền
  double tongThanhTien() {
    double tong = 0;

    for (HoaDon hd in dsHoaDon) {
      tong += hd.thanhTien();
    }

    return tong;
  }

  // Tổng tiền trợ giá
  double tongTroGia() {
    double tong = 0;

    for (HoaDon hd in dsHoaDon) {
      tong += hd.tinhTroGia();
    }

    return tong;
  }

  // Khách hàng mua nhiều nhất
  HoaDon? khachHangMuaNhieuNhat() {
    if (dsHoaDon.isEmpty) {
      return null;
    }

    HoaDon max = dsHoaDon[0];

    for (HoaDon hd in dsHoaDon) {
      if (hd.soLuong > max.soLuong) {
        max = hd;
      }
    }

    return max;
  }

  // Tổng chiết khấu của khách hàng công ty
  double tongChietKhauCongTy() {
    double tong = 0;

    for (HoaDon hd in dsHoaDon) {
      if (hd.runtimeType.toString() == 'KhachHangCongTy') {
        tong += hd.tinhChietKhau();
      }
    }

    return tong;
  }

  // Sắp xếp tăng dần số lượng
  // Nếu bằng nhau thì giảm dần thành tiền
  void sapXep() {
    dsHoaDon.sort((a, b) {
      int kq = a.soLuong.compareTo(b.soLuong);

      if (kq == 0) {
        return b.thanhTien().compareTo(a.thanhTien());
      }

      return kq;
    });
  }

  // Tìm theo mã khách hàng
  void timTheoMa(String ma) {
    bool timThay = false;

    for (HoaDon hd in dsHoaDon) {
      if (hd.maKH == ma) {
        print(hd);
        timThay = true;
      }
    }

    if (!timThay) {
      print('Khách hàng lạ');
    }
  }
}