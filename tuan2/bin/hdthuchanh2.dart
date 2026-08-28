import 'package:tuan2/NhanVien.dart';
import 'package:tuan2/CanBo.dart';

void main() {
  NhanVien nv = NhanVien.fullParra(
    "NV001",
    "Nguyễn Trần Tuấn",
    2.34,
    "Tổ chức",
    23,
  );

  CanBo cb = CanBo.fullPara(
    "NV002",
    "Trần Văn Bình",
    2.34,
    "Tổ chức",
    26,
    "Trưởng phòng",
    2.0,
  );

  NhanVien nv3 = NhanVien.fullParra(
    "NV003",
    "Nguyễn Nam",
    2.34,
    "Nhân sự",
    27,
  );

  List<NhanVien> lstNhanVien = [];

  lstNhanVien.add(nv);
  lstNhanVien.add(cb);
  lstNhanVien.add(nv3);

  print("Danh sách nhân viên và cán bộ:");

  for (NhanVien x in lstNhanVien) {
    print(x);
  }

  print("\nDanh sách nhân viên và cán bộ xếp loại A:");

  for (NhanVien x in lstNhanVien) {
    if (x.xeploai() == "A") {
      print(x);
    }
  }

  double tongLuong = 0;

  for (NhanVien x in lstNhanVien) {
    tongLuong = tongLuong + x.tinhLuong();
  }

  print("\nTổng thu nhập của nhân viên và cán bộ:");
  print(tongLuong);

  lstNhanVien.sort(
    (x, y) => x.tinhLuong().compareTo(y.tinhLuong()),
  );

  print("\nDanh sách sau khi sắp xếp tăng dần theo lương:");

  for (NhanVien x in lstNhanVien) {
    print(x);
  }
}