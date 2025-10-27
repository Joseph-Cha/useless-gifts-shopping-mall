import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:useless_gifts_shopping_mall/models/product.dart';
import 'package:useless_gifts_shopping_mall/providers/product_provider.dart';

class ProductRegistrationScreen extends StatefulWidget {
  const ProductRegistrationScreen({super.key});

  @override
  State<ProductRegistrationScreen> createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedCategory = '티셔츠';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = ['티셔츠', '잡화', '쿠션', '노트'];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다: $e')));
      }
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 이미지 URL이 비어있고 선택된 이미지도 없으면 에러
    if (_imageUrlController.text.isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 URL을 입력하거나 갤러리에서 이미지를 선택해주세요')),
      );
      return;
    }

    // 실제 앱에서는 이미지를 서버에 업로드하고 URL을 받아와야 하지만,
    // 데모에서는 로컬 파일 경로나 입력된 URL을 그대로 사용
    String imageUrl = _imageUrlController.text;
    if (_selectedImage != null && imageUrl.isEmpty) {
      imageUrl = _selectedImage!.path;
    }

    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      imageUrl: imageUrl,
      category: _selectedCategory,
    );

    Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);

    // 등록 완료 다이얼로그
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('등록 완료'),
        content: const Text('상품이 등록되었습니다!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // 폼 초기화
              _formKey.currentState!.reset();
              _nameController.clear();
              _priceController.clear();
              _descriptionController.clear();
              _imageUrlController.clear();
              setState(() {
                _selectedImage = null;
                _selectedCategory = '티셔츠';
              });
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 등록'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 이미지 선택
              const Text(
                '상품 이미지',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 50),
                            SizedBox(height: 8),
                            Text('갤러리에서 이미지 선택'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              // 이미지 URL (옵션)
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: '또는 이미지 URL 입력',
                  hintText: 'https://example.com/image.jpg',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              // 상품명
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '상품명 *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '상품명을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 카테고리
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: '카테고리 *',
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // 가격
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: '가격 *',
                  suffixText: '원',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '가격을 입력해주세요';
                  }
                  if (double.tryParse(value) == null) {
                    return '올바른 숫자를 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // 상품 설명
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '상품 설명 *',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '상품 설명을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              // 등록 버튼
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '상품 등록하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
