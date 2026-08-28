class NhanVien{
  String _manv='';
  String _tennv='';
  double _hesoluong=0.0;
  String _phongban='';
  double _songaylv=0.0;

  static double LCB=2340;
  
  NhanVien(){
    _manv="Nv000";
    _tennv="Nguyễn Văn A";
    _hesoluong=2.34;
    _phongban="Tổ chức";
    _songaylv=22;
    
  }
  NhanVien.fullParra(
    String manv,
    String tennv,
    double hsl,
    String pb,
    double songaylv,

  )
{
  _manv=manv;
  _tennv=tennv;
  _hesoluong=hsl;
  _songaylv=songaylv;
  _phongban=pb;

}
String get manv=>_manv;
set manv(String value){
  if(value.isNotEmpty){
    _manv=value;
  }
}
String get tennv=>_tennv;
set tennv(String value){
  if(value.isNotEmpty){
    tennv=value;
  }
}
double get hesoluong=>_hesoluong;

set hesoluong(String value){
  if(value.isNotEmpty){
        hesoluong=value;  
        }

}
String get phongban=>_phongban;
set phongban(String value){
  if(value.isNotEmpty){
    _phongban=value;
  }
}
double get songaylv=>_songaylv;
set songaylv(double value){
  if(value>=0){
    _songaylv=value;
  }
}
String xeploai(){
  if(_songaylv>25){
    return 'A';
  
  }else if(_songaylv>22){
    return'B';

  }else{
    return 'C';
  }
}
  // Tính lương
  double tinhLuong() {
    String xLoai = xeploai();

    double hsThiDua = 0.5;

    if (xLoai == 'A') {
      hsThiDua = 1.0;
    } else if (xLoai == 'B') {
      hsThiDua = 0.75;
    }

    return LCB * _hesoluong * hsThiDua;
  }

  // Xuất thông tin
  @override
  String toString() {
    return "$_manv\t"
        "$_tennv\t"
        "$_hesoluong\t"
        "$_songaylv\t"
        "${xeploai()}\t"
        "${tinhLuong()}";
  }
}