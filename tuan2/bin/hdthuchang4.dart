import 'dart:io';
import 'package:tuan2/PhongThue.dart';
import 'package:tuan2/PhongA.dart';
import 'package:tuan2/PhongB.dart';

Future<List<PhongThue>> readFile(String fileName) async {
  List<PhongThue> ds = [];

  try {
    List<String> lines = await File(fileName).readAsLines();

    for (String line in lines) {
      List<String> parts = line.split('#');

      if (parts[0].startsWith('A') && parts.length == 5) {
        String maPhong = parts[0].trim();
        int soNguoi = int.parse(parts[1].trim());
        double soDien = double.parse(parts[2].trim());
        double soNuoc = double.parse(parts[3].trim());
        int soNguoiThan = int.parse(parts[4].trim());

        ds.add(
          PhongA.fullPara(
            maPhong,
            soNguoi,
            soDien,
            soNuoc,
            soNguoiThan,
          ),
        );
      } else if (parts[0].startsWith('B') && parts.length == 6) {
        String maPhong = parts[0].trim();
        int soNguoi = int.parse(parts[1].trim());
        double soDien = double.parse(parts[2].trim());
        double soNuoc = double.parse(parts[3].trim());
        double giatui = double.parse(parts[4].trim());
        int soMay = int.parse(parts[5].trim());

        ds.add(
          PhongB.fullPara(
            maPhong,
            soNguoi,
            soDien,
            soNuoc,
            giatui,
            soMay,
          ),
        );
      }
    }
  } catch (e) {
    print("Lỗi khi đọc file: $e");
  }

  return ds;
}
void main() async {
  List<PhongThue> ds = await readFile('lib/phongthue.txt');

  // 1. In danh sách phòng
  print("===== DANH SÁCH PHÒNG THUÊ =====");

  for (PhongThue x in ds) {
    print(x);
  }

  // 2. Các phòng có số người > 2
  print("\n===== PHÒNG CÓ SỐ NGƯỜI > 2 =====");

  for (PhongThue x in ds) {
    if (x.soNguoi > 2) {
      print(x);
    }
  }

  // 3. Tổng tiền phòng
  double tongTien = 0;

  for (PhongThue x in ds) {
    tongTien += x.tinhTienPhong();
  }

  print("\n===== TỔNG TIỀN PHÒNG =====");
  print(tongTien);

  // 4. Sắp xếp giảm dần theo số điện
  ds.sort(
    (a, b) => b.soDien.compareTo(a.soDien),
  );

  print("\n===== SẮP XẾP GIẢM DẦN THEO SỐ ĐIỆN =====");

  for (PhongThue x in ds) {
    print(x);
  }

  // 5. Danh sách phòng loại A
  print("\n===== DANH SÁCH PHÒNG LOẠI A =====");

  for (PhongThue x in ds) {
    if (x is PhongA) {
      print(x);
    }
  }
}