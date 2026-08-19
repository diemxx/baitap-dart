import 'dart:io';
void main(){
  stdout.write('Nhập số que kem cần mua:');
  int soque=int.parse(stdin.readLineSync()!);

  stdout.write('Nhập giá tiền 1 que kem:');
  double giatien=double.parse(stdin.readLineSync()!);

  double tongtien=soque*giatien;
  double tienphaitra;

  if(soque>10){
    tienphaitra=tongtien*0.9;
  }
  else if(soque>=5 && soque<=10)
  {
    tienphaitra=tongtien*0.95;
  }
  else{
    tienphaitra=tongtien;
  }
  print('Tổng tiền ban đầu: $tongtien');
  print('Tiền phải trả: $tienphaitra');

}