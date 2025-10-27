import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 상태 관리(장바구니, 상품)를 위한 Provider 패키지
import 'package:useless_gifts_shopping_mall/providers/cart_provider.dart'; // 장바구니 상태 관리자
import 'package:useless_gifts_shopping_mall/providers/product_provider.dart'; // 상품 목록 상태 관리자
import 'package:useless_gifts_shopping_mall/screens/cart_screen.dart'; // 장바구니 화면
import 'package:useless_gifts_shopping_mall/screens/product_list_screen.dart'; // 상품 목록 (홈) 화면
import 'package:useless_gifts_shopping_mall/screens/product_registration_screen.dart'; // 상품 등록 화면

// 앱의 메인 컨테이너 위젯 (BottomNavigationBar를 사용하므로 StatefulWidget)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

// MainScreen의 상태를 관리하는 State 클래스
class _MainScreenState extends State<MainScreen> {
  // 현재 선택된 BottomNavigationBar 탭의 인덱스 (0: 홈, 1: 장바구니, 2: 등록)
  int _currentIndex = 0;

  // BottomNavigationBar 탭에 따라 표시될 화면 위젯 목록
  final List<Widget> _screens = const [
    ProductListScreen(), // 인덱스 0
    CartScreen(), // 인덱스 1
    ProductRegistrationScreen(), // 인덱스 2
  ];

  @override
  void initState() {
    super.initState();
    // 위젯이 빌드된 후 첫 번째 프레임이 그려진 직후에 비동기 로직을 실행하도록 예약
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 위젯이 마운트된 상태인지 확인 (안정성 확보)
      if (mounted) {
        // ProductProvider를 사용하여 초기 상품 데이터를 로드 (listen: false로 불필요한 리빌드 방지)
        Provider.of<ProductProvider>(context, listen: false).loadProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 현재 선택된 인덱스에 해당하는 화면을 본문(body)에 표시
      body: _screens[_currentIndex],
      // 화면 하단에 표시되는 내비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        // 현재 활성화된 탭 인덱스 설정
        currentIndex: _currentIndex,
        // 탭 아이템을 클릭했을 때 호출되는 콜백 함수
        onTap: (index) {
          // 상태를 변경하여 화면을 갱신
          setState(() {
            _currentIndex = index; // 선택된 새 인덱스로 업데이트
          });
        },
        items: [
          // 1. 홈 탭 아이템
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          // 2. 장바구니 탭 아이템
          BottomNavigationBarItem(
            // 장바구니 아이콘에 실시간 개수를 표시하기 위해 Consumer 사용
            icon: Consumer<CartProvider>(
              // CartProvider의 상태가 변경될 때마다 이 부분을 리빌드
              builder: (context, cart, child) {
                return Badge(
                  // 장바구니 항목 개수를 표시하는 텍스트
                  label: Text('${cart.itemCount}'),
                  // 항목 개수가 0보다 클 때만 배지를 보이도록 설정
                  isLabelVisible: cart.itemCount > 0,
                  // 배지 하단의 기본 아이콘
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
            label: '장바구니',
          ),
          // 3. 상품 등록 탭 아이템
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: '상품 등록',
          ),
        ],
      ),
    );
  }
}
