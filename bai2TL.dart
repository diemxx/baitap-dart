import 'dart:io';
void main(){
  stdout.write('Nhập số nguyên dương >10 :  \n');
  int n=int.parse(stdin.readLineSync()!);
  
  if(n<=10){
    print('số nhập phải lớn hơn 10');
    return;

  }
  int tam=n, sochuso=0, tongchuso=0, chusomax=0;
  bool sole=false;
  bool chusonguyento=false;

  while(tam>0){
    int chuso=tam%10;
    //a.đếm chữ số
    sochuso++;
    //b.Tính tổng các chữ số
    tongchuso+=chuso;
    //c.Kiểm tra có chữ số lẻ hay không
    if(chuso%2!=0){
      sole=true;
    }
    //d.chữ số lớn nhat
    if(chuso>chusomax){
      chusomax=chuso;
    }
    //e.Kiểm tra số nguyên tố
    if(chuso==2||chuso==3||chuso==5||chuso==7){
      chusonguyento=true;
    }

    tam=tam ~/10;

  }
  print('a.Số chữ số: $sochuso');
  print('b.Tổng chữ số: $tongchuso');
  if(sole){
    print('c.Số $n vừa nhập có chứa chữ số lẻ');
  }
  else{
    print('c.Số $n vừa nhập không chứa chữ số lẻ');
  }
  print('d.Chữ số lớn nhất: $chusomax');

  if(chusonguyento){
    print('e.Số $n có chứa chữ số nguyên tố ');

  }
  else{
    print('e.Số $n không chứa chữ số nguyên tố ');
  }

}