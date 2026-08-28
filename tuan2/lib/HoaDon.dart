class HoaDon {
  String _maKH = '';
  String _tenKH = '';
  int _soLuong = 0;
  double _giaBan = 0;

  // Constructor mặc định
  HoaDon() {
    _maKH = 'KH0000';
    _tenKH = 'Unknown';
    _soLuong = 1;
    _giaBan = 1000;
  }

  // Constructor đầy đủ tham số
  HoaDon.fullPara(
    String maKH,
    String tenKH,
    int soLuong,
    double giaBan,
  ) {
    this.maKH = maKH;
    this.tenKH = tenKH;
    this.soLuong = soLuong;
    this.giaBan = giaBan;
  }

  // Getter
  String get maKH => _maKH;

  String get tenKH => _tenKH;

  int get soLuong => _soLuong;

  double get giaBan => _giaBan;

  // Setter mã khách hàng
  set maKH(String value) {
    if (RegExp(r'^KH\d{4}$').hasMatch(value)) {
      _maKH = value;
    } else {
      print('Mã khách hàng không đúng định dạng!');
    }
  }

  // Setter tên khách hàng
  set tenKH(String value) {
    if (value.trim().isNotEmpty) {
      _tenKH = value;
    } else {
      print('Tên khách hàng không được để trống!');
    }
  }

  // Setter số lượng
  set soLuong(int value) {
    if (value > 0) {
      _soLuong = value;
    } else {
      print('Số lượng phải lớn hơn 0!');
    }
  }

  // Setter giá bán
  set giaBan(double value) {
    if (value > 0) {
      _giaBan = value;
    } else {
      print('Giá bán phải lớn hơn 0!');
    }
  }

  // Tiền hàng
  double tienHang() {
    return _soLuong * _giaBan;
  }

  // Chiết khấu
  double tinhChietKhau() {
    return 0;
  }

  // Trợ giá
  double tinhTroGia() {
    return 0;
  }

  // Thuế VAT
  double tinhVAT() {
    return tienHang() * 0.10;
  }

  // Thành tiền
  double thanhTien() {
    return tienHang() -
        tinhChietKhau() -
        tinhTroGia() +
        tinhVAT();
  }

  @override
  String toString() {
    return 'Mã KH: $_maKH\t'
        'Tên KH: $_tenKH\t'
        'Số lượng: $_soLuong\t'
        'Giá bán: $_giaBan\t'
        'Chiết khấu: ${tinhChietKhau()}\t'
        'Trợ giá: ${tinhTroGia()}\t'
        'VAT: ${tinhVAT()}\t'
        'Thành tiền: ${thanhTien()}';
  }
}