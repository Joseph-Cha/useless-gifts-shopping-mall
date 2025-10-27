// 상품의 데이터 구조를 정의하는 클래스
class Product {
  // final: 한번 초기화되면 변경할 수 없는 불변(Immutable) 속성
  final String id; // 상품 고유 ID (필수)
  final String name; // 상품 이름 (필수)
  final String description; // 상품 상세 설명
  final double price; // 상품 가격 (실수형)
  final String imageUrl; // 상품 이미지 URL 또는 로컬 경로
  final String category; // 상품 카테고리

  // 생성자
  Product({
    required this.id,
    required this.name,
    // 설명이 없을 경우 기본값 설정
    this.description = '상품 설명이 없습니다.',
    required this.price,
    required this.imageUrl,
    // 카테고리가 없을 경우 기본값 설정
    this.category = '쓸데없는 물건',
  });

  // 가격을 콤마(,)를 포함한 포맷된 문자열로 반환하는 Getter
  String get formattedPrice {
    final priceInt = price.toInt(); // double을 정수로 변환 (소수점 이하 버림)
    final priceStr = priceInt.toString(); // 정수를 문자열로 변환
    final buffer = StringBuffer(); // 문자열을 효율적으로 조합하기 위한 버퍼

    for (int i = 0; i < priceStr.length; i++) {
      // 첫 글자가 아니며, 남은 글자 수(priceStr.length - i)가 3의 배수일 때 콤마 추가
      // 예: 10000 -> 1(남은 4) 콤마 추가 -> 10(남은 3) 콤마 추가 -> 100(남은 2)
      if (i > 0 && (priceStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(priceStr[i]); // 현재 문자를 버퍼에 추가
    }

    return '${buffer.toString()}원'; // 최종 문자열에 '원'을 붙여 반환
  }

  // 이미지 URL이 'http://' 또는 'https://'로 시작하지 않으면 로컬 파일 경로로 간주하는 Getter
  bool get isLocalImage {
    return !imageUrl.startsWith('http://') && !imageUrl.startsWith('https://');
  }

  // 이미지 URL이 'assets/'로 시작하면 에셋(Asset) 이미지 경로로 간주하는 Getter
  bool get isAssetImage {
    return imageUrl.startsWith('assets/');
  }

  // 객체를 JSON 형식(Map<String, dynamic>)으로 변환하는 메서드 (데이터 저장 등에 사용)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  // JSON Map에서 Product 객체를 생성하는 팩토리 생성자 (데이터 로드 등에 사용)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // id가 없으면 현재 시간을 ID로 사용
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'],
      // 설명이 없으면 기본 문자열 사용
      description: json['description'] ?? '쓸데없지만 갖고 싶은 그런 물건입니다.',
      // 가격 데이터 타입이 int이거나 null일 경우 double로 변환 (JSON 파싱 시 발생 가능)
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'].toDouble(),
      // 이미지 경로를 'img_path' 또는 'imageUrl' 키에서 가져오며, 없으면 빈 문자열 사용
      imageUrl: json['img_path'] ?? json['imageUrl'] ?? '',
      // 카테고리가 없으면 기본 문자열 사용
      category: json['category'] ?? '쓸데없는 물건',
    );
  }
}
