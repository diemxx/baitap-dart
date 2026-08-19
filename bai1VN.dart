import 'dart:io';
import 'dart:math';

void main(){
  Random random=Random();
  stdout.write('Nhập só lượng phần tử: ');
  int n=int.parse(stdin.readLineSync()!);
  List<int>ds=[];
  for(int i=0;i<n;i++){
    ds.add(random.nextInt(96)+5);
  }
  //a.xuất danh sách
  print('\n a. Danh sách vừa tạo:');
  print(ds);
  //b.Tính tổng các phần tử
  int tong=0;
  for(int x in ds){
    tong += x;
  }
  print('b: Tổng các phần tử= $tong');
  //c.Tính trung bình cộng các số lẻ
  int tongle=0;
  int demle=0;
  for(int x in ds){
    if(x%2!=0){
      tongle+=x;
      demle++;

    }
  }
  if(demle==0){
    print('c.Danh sách khong có so le');

  }else{
    double trungbinhle=tongle/demle;
    print('c.Trung bình cộng các số lẻ=${trungbinhle.toStringAsFixed(2)}');

  }
  //d.Kiểm tra danh sách đối xứng
  bool doixung=true;
  for(int i=0;i<ds.length ~/2;i++){
    if (ds[i]!=ds[ds.length-1-i]){
      doixung=false;
      break;
    }

  }
  if(doixung){
    print('d. Danh sách là danh sách đối xứng');

  }else{
    print('d. Danh sách không đối xứng');
  }

  //e.Kiểm tra danh sách tăng dần
  bool tangdan=true;
  for (int i=0;i<ds.length-1;i++)
  {
    if (ds[i]>ds[i+1]){
      tangdan=false;
      break;
    }
  }
  if(tangdan){
    print('e. Danh sách được sắp xếp tăng dần');
  }else{
    print('e. Danh sách không được sắp xếp tăng dần');

  }
  //f.Tìm phần tử lớn nhất 
  int max=ds[0];
  for(int x in ds)
  {
    if(x>max)
    {
      max=x;    
    }
  }
  print('f. Phần tử lớn nhất= $max ');

  //g.Tìm số chẵn lớn nhất
  int ?maxchan; //? cho phép biến maxchan có thể chưa có giá trị
  for(int x in ds)
  {
    if(x%2==0)
    {
      if(maxchan==null|| x>maxchan)
      {
        maxchan=x;
      }
    }
  }
  if (maxchan==null){
    print('g. Danh sách không có số chẵn');

  }else{
    print('g. Số chẵn lớn nhất=$maxchan');
  }
  //h.Tìm và xóa giá trị 
  stdout.write('\n h.Nhập giá trị cần tìm: ');
  int giatri=int.parse(stdin.readLineSync()!);
  if(!ds.contains(giatri))
  {
    print('Không tìm thấy');
  }
  else{
    ds.removeWhere((x) => x==giatri);
    print('Đã tìm thấy $giatri');
    print('Đã xóa tất cả các phần tử có giá trị $giatri');
    print('Danh sách sau khi xóa:');
    print(ds);
  }
}
