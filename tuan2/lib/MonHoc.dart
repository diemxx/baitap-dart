class MonHoc {
  String _maMH = '';
  String _tenMH = '';
  int _soTinChi = 0;

  MonHoc() {
    _maMH = 'MH000';
    _tenMH = 'Unknown';
    _soTinChi = 0;
  }

  MonHoc.fullPara(
    String maMH,
    String tenMH,
    int soTinChi,
  ) {
    _maMH = maMH;
    _tenMH = tenMH;
    _soTinChi = soTinChi;
  }

  String get maMH => _maMH;

  set maMH(String value) {
    if (value.isNotEmpty) {
      _maMH = value;
    }
  }

  String get tenMH => _tenMH;

  set tenMH(String value) {
    if (value.isNotEmpty) {
      _tenMH = value;
    }
  }

  int get soTinChi => _soTinChi;

  set soTinChi(int value) {
    if (value > 0) {
      _soTinChi = value;
    }
  }

 
  double tinhDTB() {
    return 0;
  }

  double diemHe4() {
    double dtb = tinhDTB();

    if (dtb >= 8.5) {
      return 4.0;
    } else if (dtb >= 8.0) {
      return 3.5;
    } else if (dtb >= 7.0) {
      return 3.0;
    } else if (dtb >= 6.5) {
      return 2.5;
    } else if (dtb >= 5.5) {
      return 2.0;
    } else if (dtb >= 5.0) {
      return 1.5;
    } else if (dtb >= 4.0) {
      return 1.0;
    } else {
      return 0.0;
    }
  }


  String diemChu() {
    double dtb = tinhDTB();

    if (dtb >= 8.5) {
      return 'A';
    } else if (dtb >= 8.0) {
      return 'B+';
    } else if (dtb >= 7.0) {
      return 'B';
    } else if (dtb >= 6.5) {
      return 'C+';
    } else if (dtb >= 5.5) {
      return 'C';
    } else if (dtb >= 5.0) {
      return 'D+';
    } else if (dtb >= 4.0) {
      return 'D';
    } else {
      return 'F';
    }
  }

  @override
  String toString() {
    return '$_maMH\t$_tenMH\t$_soTinChi\t'
        'DTB: ${tinhDTB().toStringAsFixed(2)}\t'
        'Điểm chữ: ${diemChu()}\t'
        'Hệ 4: ${diemHe4()}';
  }
}