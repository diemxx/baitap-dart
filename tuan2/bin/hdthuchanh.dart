import 'package:tuan2/SanPham.dart';

void main(){
  SanPham sp=SanPham();

  print("Thông tin sản phẩm mặc định:");
  sp.showInfo();
  SanPham sp1=SanPham.fullPara('SP001','Bánh gạo Nhật', 25000,0);

  print("\n Thông tin sản phẩm");
  sp1.showInfo();
  List<SanPham>lstSanPham=[];
  SanPham sp2=SanPham.fullPara('SP002', 'Trà ô lông', 75000,0);
  SanPham sp3=SanPham.fullPara('SP003', 'Mứt xoài sấy', 45000,0);
  lstSanPham.add(sp1);
  lstSanPham.add(sp2);
  lstSanPham.add(sp3);
  print("\nDanh sách sản phẩm là:");
  for(SanPham a in lstSanPham){
    a.showInfo();
  }

}