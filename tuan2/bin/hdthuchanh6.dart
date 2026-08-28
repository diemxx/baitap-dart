import 'package:tuan2/HoaDon.dart';
import 'package:tuan2/KhachHangCaNhan.dart';
import 'package:tuan2/DaiLyCap1.dart';
import 'package:tuan2/KhachHangCongTy.dart';
import 'package:tuan2/QuanLyHoaDon.dart';

void main() {
  QuanLyHoaDon ql = QuanLyHoaDon();


//Tạo hóa đơn cá nhân

  KhachHangCaNhan caNhan = KhachHangCaNhan.fullPara(
    'KH0001',
    'Nguyễn Văn A',
    4,
    500000,
    5,
  );
 
  // Tạo hóa đơn đại lý

  DaiLyCap1 daiLy = DaiLyCap1.fullPara(
    'KH0002',
    'Đại lý Minh Anh',
    10,
    700000,
    7,
  );

  // Tạo hóa đơn công ty

  KhachHangCongTy congTy = KhachHangCongTy.fullPara(
    'KH0003',
    'Công ty ABC',
    20,
    600000,
    6000,
  );

  // Thêm vào danh sách
  ql.them(caNhan);
  ql.them(daiLy);
  ql.them(congTy);

  // 1.Xuất danh sách

  print('===== DANH SÁCH HÓA ĐƠN =====');

  ql.xuatDanhSach();

  //2.Tổng thành tiền

  print('\n===== TỔNG THÀNH TIỀN =====');

  print(
    ql.tongThanhTien().toStringAsFixed(2),
  );

  // 3.Tổng tiền trợ giá

  print('\n===== TỔNG TIỀN TRỢ GIÁ =====');

  print(
    ql.tongTroGia().toStringAsFixed(2),
  );


  // 4. Khách hàng mua nhiều nhất
 

  print('\n===== KHÁCH HÀNG MUA NHIỀU NHẤT =====');

  HoaDon? max = ql.khachHangMuaNhieuNhat();

  if (max != null) {
    print(max);
  }

  // 5.Tổng chiết khấu công ty

  print('\n===== TỔNG CHIẾT KHẤU KHÁCH HÀNG CÔNG TY =====');

  print(
    ql.tongChietKhauCongTy().toStringAsFixed(2),
  );

 
  // 6.sắp xếp

  ql.sapXep();

  print('\n===== SAU KHI SẮP XẾP =====');

  ql.xuatDanhSach();


//7. Tìm khách hàng

  print('\n===== TÌM KHÁCH HÀNG KH0002 =====');

  ql.timTheoMa('KH0002');

  print('\n===== TÌM KHÁCH HÀNG KH9999 =====');

  ql.timTheoMa('KH9999');
}