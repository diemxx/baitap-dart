class SanPham{

  String _masp='';
  String _tensp='';
  double _dongia=0;
  double _giamgia=0;
  SanPham(){
    _masp="SP000";
    _tensp="Unknown";
    _dongia=0;
    _giamgia=0;

  }
  SanPham.fullPara(String masp, String tensp, double gia, double giam){
    _masp=masp;
    _tensp=tensp;
    _dongia=gia;
    _giamgia=giam;
  }
  String get masp=>_masp;
  set masp(String value){
    if(value.isNotEmpty){
      _masp=value;
    }
  }
  String get tensp=>_tensp;
  set tensp(String value){
    if(value.isEmpty){
      _tensp=value;
    }
  }
  double get dongia=>_dongia;
  set dongia(double value){
    if(value>0){
      _dongia=value;
    }
  }
  double get giamgia=>_giamgia;
  set giamgia(double value){
    if(value >=0){
      _giamgia=value;
    }
  }
  double tinhthuenhapkhau(){
    return 0.10*_dongia;
  }
  void showInfo(){
    print(
      "Mã sản phẩm: $_masp,"
      "Tên : $_tensp,"
      "Giá bán: $_dongia,"
      "Giảm giá: $_giamgia,"
      "Thuế nhập khẩu: ${tinhthuenhapkhau()}");
    }
  }
