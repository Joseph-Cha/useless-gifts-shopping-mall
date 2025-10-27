import 'package:flutter/material.dart';
import 'package:useless_gifts_shopping_mall/models/product.dart';
import 'package:useless_gifts_shopping_mall/screens/product_detail_screen.dart';
import 'package:useless_gifts_shopping_mall/widgets/product_image.dart';

// 상품 그리드의 개별 아이템을 표시하는 위젯 (StatelessWidget)
class ProductGridItem extends StatelessWidget {
  // 표시할 상품 데이터
  final Product product;

  // 생성자: key와 필수 상품 데이터를 받음
  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // 상품 카드를 Card 위젯으로 감싸서 그림자 효과와 둥근 모서리 제공
    return Card(
      elevation: 2, // 카드에 그림자 깊이 설정
      // 카드의 모서리를 12의 반지름으로 둥글게 처리
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // 카드 전체를 InkWell로 감싸서 터치 반응 및 Material 잔물결 효과(splash) 추가
      child: InkWell(
        // 탭했을 때 실행될 동작
        onTap: () {
          // Navigator를 사용하여 상품 상세 화면으로 이동
          Navigator.of(context).push(
            MaterialPageRoute(
              // 상세 화면 빌더: ProductDetailScreen에 현재 상품 데이터를 전달
              builder: (ctx) => ProductDetailScreen(product: product),
            ),
          );
        },
        // 잔물결 효과의 모서리를 카드의 모서리와 동일하게 둥글게 설정
        borderRadius: BorderRadius.circular(12),
        // InkWell 내부의 내용을 세로로 배치하기 위한 Column
        child: Column(
          // 자식 위젯들을 가로축(cross axis)의 시작(왼쪽)에 정렬
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상품 이미지 영역
            Expanded(
              flex: 3, // Column 공간의 3/5를 할당
              child: ProductImage(
                product: product,
                width: double.infinity, // 가로 폭을 최대로 확장
                // 이미지의 상단 모서리만 둥글게 처리 (카드의 상단 모서리와 일치)
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            // 상품 정보 영역
            Expanded(
              flex: 2, // Column 공간의 2/5를 할당
              child: Padding(
                padding: const EdgeInsets.all(8.0), // 안쪽 여백 8.0 설정
                child: Column(
                  // 정보 텍스트들을 왼쪽 정렬
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // 상품 이름과 가격을 위아래 양 끝에 배치 (사이에 공간 채우기)
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 카테고리 뱃지
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // 상품 이름 표시
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2, // 최대 2줄까지만 표시
                          overflow: TextOverflow.ellipsis, // 2줄 초과 시 "..." 처리
                        ),
                      ],
                    ),
                    // 상품 가격 표시 (이미 형식화된 문자열)
                    Text(
                      product.formattedPrice,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue, // 가격을 파란색으로 강조
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
