import 'dart:io';

import 'package:tuan2/MonHoc.dart';
import 'package:tuan2/LyThuyet.dart';
import 'package:tuan2/ThucHanh.dart';
import 'package:tuan2/DoAn.dart';

Future<List<MonHoc>> readFile(String fileName) async {
  List<MonHoc> ds = [];

  try {
    List<String> lines = await File(fileName).readAsLines();

    for (String line in lines) {
      List<String> parts = line.split('#');

      if (parts[0].startsWith('LT') && parts.length == 5) {
        ds.add(
          LyThuyet.fullPara(
            parts[0],
            parts[1],
            int.parse(parts[2]),
            double.parse(parts[3]),
            double.parse(parts[4]),
          ),
        );
      } else if (parts[0].startsWith('TH') && parts.length == 6) {
        ds.add(
          ThucHanh.fullPara(
            parts[0],
            parts[1],
            int.parse(parts[2]),
            double.parse(parts[3]),
            double.parse(parts[4]),
            double.parse(parts[5]),
          ),
        );
      } else if (parts[0].startsWith('DA') && parts.length == 5) {
        ds.add(
          DoAn.fullPara(
            parts[0],
            parts[1],
            int.parse(parts[2]),
            double.parse(parts[3]),
            double.parse(parts[4]),
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
  List<MonHoc> ds = [];


  // 1. NHẬP DANH SÁCH TỪ BÀN PHÍM


  stdout.write("Nhập số lượng môn học: ");
  int n = int.parse(stdin.readLineSync()!);

  for (int i = 0; i < n; i++) {
    print("\nNhập môn học thứ ${i + 1}");

    stdout.write("Mã môn học: ");
    String ma = stdin.readLineSync()!;

    stdout.write("Tên môn học: ");
    String ten = stdin.readLineSync()!;

    stdout.write("Số tín chỉ: ");
    int tinchi = int.parse(stdin.readLineSync()!);

    stdout.write(
        "Loại môn (1-Lý thuyết, 2-Thực hành, 3-Đồ án): ");
    int loai = int.parse(stdin.readLineSync()!);

    if (loai == 1) {
      stdout.write("Điểm tiểu luận: ");
      double tl = double.parse(stdin.readLineSync()!);

      stdout.write("Điểm cuối kỳ: ");
      double ck = double.parse(stdin.readLineSync()!);

      ds.add(
        LyThuyet.fullPara(
          ma,
          ten,
          tinchi,
          tl,
          ck,
        ),
      );
    } else if (loai == 2) {
      stdout.write("Điểm kiểm tra 1: ");
      double kt1 = double.parse(stdin.readLineSync()!);

      stdout.write("Điểm kiểm tra 2: ");
      double kt2 = double.parse(stdin.readLineSync()!);

      stdout.write("Điểm kiểm tra 3: ");
      double kt3 = double.parse(stdin.readLineSync()!);

      ds.add(
        ThucHanh.fullPara(
          ma,
          ten,
          tinchi,
          kt1,
          kt2,
          kt3,
        ),
      );
    } else if (loai == 3) {
      stdout.write("Điểm GVHD: ");
      double gvhd = double.parse(stdin.readLineSync()!);

      stdout.write("Điểm GVPB: ");
      double gvpb = double.parse(stdin.readLineSync()!);

      ds.add(
        DoAn.fullPara(
          ma,
          ten,
          tinchi,
          gvhd,
          gvpb,
        ),
      );
    }
  }


  // 2. XUẤT DANH SÁCH


  print("\n===== DANH SÁCH MÔN HỌC =====");

  for (MonHoc x in ds) {
    print(x);
  }


  // 3. KIỂM TRA SẮP XẾP THEO TÊN


  bool tangDan = true;

  for (int i = 0; i < ds.length - 1; i++) {
    if (ds[i]
            .tenMH
            .toLowerCase()
            .compareTo(ds[i + 1].tenMH.toLowerCase()) >
        0) {
      tangDan = false;
      break;
    }
  }

  if (tangDan) {
    print(
        "\nDanh sách ĐÃ được sắp xếp tăng dần theo tên.");
  } else {
    print(
        "\nDanh sách CHƯA được sắp xếp tăng dần theo tên.");
  }


  // 4. SẮP XẾP TĂNG DẦN THEO SỐ TÍN CHỈ


  ds.sort(
    (a, b) => a.soTinChi.compareTo(b.soTinChi),
  );

  print("\n===== SẮP XẾP TĂNG DẦN THEO TÍN CHỈ =====");

  for (MonHoc x in ds) {
    print(x);
  }

 
  // 5. MÔN CÓ SỐ TÍN CHỈ CAO NHẤT


  if (ds.isNotEmpty) {
    int maxTinChi = ds[0].soTinChi;

    for (MonHoc x in ds) {
      if (x.soTinChi > maxTinChi) {
        maxTinChi = x.soTinChi;
      }
    }

    print("\n===== MÔN CÓ SỐ TÍN CHỈ CAO NHẤT =====");

    for (MonHoc x in ds) {
      if (x.soTinChi == maxTinChi) {
        print(x);
      }
    }
  }

  // 6. TÌM MÔN HỌC THEO TÊN


  stdout.write("\nNhập tên môn học cần tìm: ");
  String tenTim = stdin.readLineSync()!;

  bool timThay = false;

  for (MonHoc x in ds) {
    if (x.tenMH.toLowerCase() == tenTim.toLowerCase()) {
      print("\nĐã tìm thấy môn học:");
      print(x);
      timThay = true;
      break;
    }
  }

  // Nếu không tìm thấy
  if (!timThay) {
    print("\nKhông tìm thấy môn học.");
    print("Hãy nhập thông tin môn học để thêm vào danh sách.");

    stdout.write("Mã môn học: ");
    String ma = stdin.readLineSync()!;

    stdout.write("Số tín chỉ: ");
    int tinchi = int.parse(stdin.readLineSync()!);

    stdout.write(
        "Loại môn (1-Lý thuyết, 2-Thực hành, 3-Đồ án): ");
    int loai = int.parse(stdin.readLineSync()!);

    if (loai == 1) {
      stdout.write("Điểm tiểu luận: ");
      double tl = double.parse(stdin.readLineSync()!);

      stdout.write("Điểm cuối kỳ: ");
      double ck = double.parse(stdin.readLineSync()!);

      ds.add(
        LyThuyet.fullPara(
          ma,
          tenTim,
          tinchi,
          tl,
          ck,
        ),
      );
    } else if (loai == 2) {
      stdout.write("Điểm kiểm tra 1: ");
      double kt1 = double.parse(stdin.readLineSync()!);

      stdout.write("Điểm kiểm tra 2: ");
      double kt2 = double.parse(stdin.readLineSync()!);

      stdout.write("Điểm kiểm tra 3: ");
      double kt3 = double.parse(stdin.readLineSync()!);

      ds.add(
        ThucHanh.fullPara(
          ma,
          tenTim,
          tinchi,
          kt1,
          kt2,
          kt3,
        ),
      );
    } else if (loai == 3) {
      stdout.write("Điểm GVHD: ");
      double gvhd = double.parse(stdin.readLineSync()!);

      stdout.write("Điểm GVPB: ");
      double gvpb = double.parse(stdin.readLineSync()!);

      ds.add(
        DoAn.fullPara(
          ma,
          tenTim,
          tinchi,
          gvhd,
          gvpb,
        ),
      );
    }

    print("\nĐã thêm môn học vào cuối danh sách.");
  }


  // 7. ĐỌC FILE monhoc.txt


  List<MonHoc> dsFile =
      await readFile('lib/monhoc.txt');

  print("\n===== ĐỌC DANH SÁCH TỪ FILE =====");

  for (MonHoc x in dsFile) {
    print(x);
  }


  // 8. TÍNH SỐ TÍN CHỈ TRUNG BÌNH


  if (dsFile.isNotEmpty) {
    double tongTinChi = 0;

    for (MonHoc x in dsFile) {
      tongTinChi += x.soTinChi;
    }

    double trungBinh =
        tongTinChi / dsFile.length;

    print(
      "\nSố tín chỉ trung bình: "
      "${trungBinh.toStringAsFixed(2)}",
    );
  }
}