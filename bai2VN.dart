import 'dart:io';

void main() {
  // a. Nhập chuỗi
  stdout.write('Nhập chuỗi: ');
  String chuoi = stdin.readLineSync()!;

  print('a. Chuỗi vừa nhập: $chuoi');

  // b. Đếm số ký tự nguyên âm
  String nguyenam = 'aeiouAEIOU';
  int demnguyenam = 0;

  for (int i = 0; i < chuoi.length; i++) {
    if (nguyenam.contains(chuoi[i])) {
      demnguyenam++;
    }
  }

  print('b. Số ký tự nguyên âm: $demnguyenam');

  // c. Đếm số từ
  String chuoimoi = chuoi.trim();
  int sotu = 0;

  if (chuoimoi.isNotEmpty) {
    List<String> cactu = chuoimoi.split(RegExp(r'\s+'));
    sotu = cactu.length;
  }

  print('c. Số từ trong chuỗi: $sotu');

  // d. Kiểm tra chuỗi đối xứng
  String chuoidoixung =
      chuoi.replaceAll(RegExp(r'\s+'), '').toLowerCase();

  String chuoidao = chuoidoixung.split('').reversed.join('');

  if (chuoidoixung == chuoidao) {
    print('d. Chuỗi đối xứng');
  } else {
    print('d. Chuỗi không đối xứng');
  }

  // e. Đảo ngược thứ tự các từ
  if (chuoimoi.isNotEmpty) {
    List<String> cactu = chuoimoi.split(RegExp(r'\s+'));

    String daonguoctu = cactu.reversed.join(' ');

    print('e. Chuỗi sau khi đảo ngược từ: $daonguoctu');
  }
}