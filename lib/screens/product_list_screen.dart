import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider 상태 관리를 위한 패키지
import 'package:useless_gifts_shopping_mall/models/product.dart'; // 상품 데이터 모델
import 'package:useless_gifts_shopping_mall/providers/product_provider.dart'; // 상품 상태 관리자
import 'package:useless_gifts_shopping_mall/widgets/product_grid_item.dart'; // 상품 그리드 아이템 위젯

// 상품 목록 화면 (검색 및 필터 상태 관리를 위해 StatefulWidget 사용)
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

// ProductListScreen의 상태 관리 클래스
class _ProductListScreenState extends State<ProductListScreen> {
  // 검색어 입력 필드를 제어하는 컨트롤러
  final TextEditingController _searchController = TextEditingController();
  // 현재 적용된 검색어 문자열
  String _searchQuery = '';
  // 현재 선택된 카테고리 필터. 기본값은 '전체'
  String _selectedCategory = '전체';

  // 사용 가능한 카테고리 목록
  final List<String> _categories = ['전체', '티셔츠', '잡화', '쿠션', '노트'];

  @override
  void dispose() {
    // 위젯이 제거될 때 컨트롤러를 정리하여 메모리 누수를 방지
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider를 통해 상품 상태 관리자 인스턴스를 가져옴 (listen: true로 상태 변화 감지)
    final productProvider = Provider.of<ProductProvider>(context);

    // 필터링된 상품 목록을 담을 변수 선언
    List<Product> products;

    // --- 검색 및 카테고리 필터 적용 로직 시작 ---
    if (_searchQuery.isEmpty && _selectedCategory == '전체') {
      // 1. 검색어 없음, 카테고리 '전체': 모든 상품 표시
      products = productProvider.products;
    } else if (_searchQuery.isEmpty && _selectedCategory != '전체') {
      // 2. 검색어 없음, 특정 카테고리 선택: 해당 카테고리 상품만 필터링
      products = productProvider.getProductsByCategory(_selectedCategory);
    } else if (_searchQuery.isNotEmpty && _selectedCategory == '전체') {
      // 3. 검색어 있음, 카테고리 '전체': 검색어에 해당하는 상품만 필터링
      products = productProvider.searchProducts(_searchQuery);
    } else {
      // 4. 검색어 있음, 특정 카테고리 선택: 검색 후 카테고리로 2차 필터링
      products = productProvider
          .searchProducts(_searchQuery)
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
    // --- 검색 및 카테고리 필터 적용 로직 끝 ---

    return Scaffold(
      appBar: AppBar(
        title: const Text('이걸 왜 팔아?'),
        elevation: 0, // 앱바 하단 그림자 제거
      ),
      body: Column(
        children: [
          // 1. 검색 바 영역
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '상품 검색...',
                prefixIcon: const Icon(Icons.search),
                // 검색어가 있을 때만 '지우기' 버튼 표시
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          // 버튼 클릭 시 검색어 초기화 및 상태 업데이트
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                // 검색 바의 모양 설정 (둥근 모서리)
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                // 입력 값이 변경될 때마다 상태를 업데이트하고 검색 쿼리 적용
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // 2. 카테고리 필터 영역
          Container(
            height: 50, // 높이 고정
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // 수평 스크롤 허용
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    // 현재 칩의 선택 상태
                    selected: isSelected,
                    // 칩을 탭했을 때 실행 (선택 상태를 토글하는 콜백)
                    onSelected: (selected) {
                      setState(() {
                        // 선택된 카테고리로 상태 업데이트
                        _selectedCategory = category;
                      });
                    },
                    // 선택되었을 때의 배경색
                    selectedColor: Colors.blue,
                    // 라벨 텍스트 스타일
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          // 3. 상품 목록 영역
          Expanded(
            // 남은 공간을 모두 차지하도록 확장
            child: products.isEmpty
                ? Center(
                    // 검색 결과 또는 상품이 없을 경우 메시지 표시
                    child: Text(
                      _searchQuery.isEmpty ? '상품이 없습니다.' : '검색 결과가 없습니다.',
                    ),
                  )
                // 상품이 있을 경우 GridView로 표시
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: products.length,
                    // 그리드 레이아웃 설정
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 한 행에 2개 아이템
                          childAspectRatio: 3 / 4, // 아이템의 가로/세로 비율 (3:4)
                          crossAxisSpacing: 10, // 가로 간격
                          mainAxisSpacing: 10, // 세로 간격
                        ),
                    // 각 그리드 아이템 빌드
                    itemBuilder: (ctx, i) =>
                        ProductGridItem(product: products[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
