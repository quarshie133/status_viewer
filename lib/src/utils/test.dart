void main() {
  int divisor = 5;

  List first_arr = [
    'ds',
    'tr',
    'tee',
    'o',
    'ui',
    'oi',
    'wed',
    'rr',
    'as',
    'amai',
    'isca',
    'naru'
  ];

  int size = first_arr.length;
  print('size: $size');

  int sizeAd = size + size ~/ divisor;
  print('size with Ads: $sizeAd');
  int x = 1;
  for (int i = 1; i <= sizeAd; i++) {
    if (i % divisor == 0) {

      int y = i;
      if ( x % 2 == 0 && i != sizeAd) {
        y = i + 1;
      }
      first_arr.insert(y, 3);
      x++;
    }
  }

  print(first_arr);
}
