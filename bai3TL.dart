import 'dart:io';

bool songuyento(int n)
{
  if(n<2){
    return false;
  }
  for (int i=2;i<n;i++){
    if (n%i==0){
      return false;
    }
  }
  return true;
}
void main(){
  List<int>ds=[];
  stdout.write('Nhập số lượng phần tử:');
  int n=int.parse(stdin.readLineSync()!);

  //nhập danh sách
  for(int i=0;i<n;i++){
    stdout.write('Nhập phần tử thứ ${i+1}:');
    int x=int.parse(stdin.readLineSync()!);
    ds.add(x);
  }

  //a.xuất danh sách
  print('\n a. Danh sách vừa nhập: $ds');
  //b.Tính tổng các phần tử trong ds
  int tong=0;
  for(int x in ds){
    tong=tong+x;

  }
  print('b. Tổng các phần tử= $tong');
  
  //c.Xuất các số nguyên tố
  print('c.Các số nguyên tố trong danh sách:');
  bool cosonguyento=false;
  for(int x in ds){
    if(songuyento(x)){
      stdout.write('$x ');
      cosonguyento=true;
    }
  }
  if(cosonguyento==false){
    print('Không có số nguyên tố');
}
else{
  print('');
}

//d.Nhập giá trị cần tìm
stdout.write('\n d.Nhập giá trị cần tìm:');
int giatri=int.parse(stdin.readLineSync()!);
if(ds.contains(giatri)){
  print('Giá trị $giatri có trong danh sách');
  print ('Giá trị $giatri ở vị trí:');
  for(int i=0;i<ds.length;i++)
  {
    if(ds[i]==giatri)
    {
      print(i+1);
    }
    
    }
    
  }
  else
  {
      print('Giá trị $giatri không có trong danh sách');
      ds.insert(0,giatri);
      print('Đã thêm $giatri vào đầu danh sách');
      print('Danh sách mới: $ds');
  
  }
}