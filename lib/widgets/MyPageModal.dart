import 'package:flutter/material.dart';
import 'package:malhaeboredo/core/api_service.dart';
import 'package:flutter/services.dart';

class IslandNameDialog extends StatefulWidget {
  final Function(String)? onSave;
  
  const IslandNameDialog({Key? key, this.onSave}) : super(key: key);

  @override
  _IslandNameDialogState createState() => _IslandNameDialogState();
}

class _IslandNameDialogState extends State<IslandNameDialog> {
  final TextEditingController _islandNameController = TextEditingController();
  final TextEditingController _newNameController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _islandNameController.dispose();
    _newNameController.dispose();
    super.dispose();
  }

  Future<void> _saveIslandName() async {
    if (_islandNameController.text.isEmpty || _newNameController.text.isEmpty) {
      return; // Do nothing if either field is empty
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // API 호출
      final response = await _apiService.userProfile(_islandNameController.text, _newNameController.text);
      
      if (response['isSuccess'] == true) {
        // 성공 시 콜백 호출
        if (widget.onSave != null) {
          widget.onSave!(_newNameController.text);
        }
        Navigator.of(context).pop();
      } else {
        // 에러 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? '저장에 실패했습니다')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8EFE9), // 베이지색 배경
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 내용물 크기에 맞게 조절
          children: [
            // 헤더 영역 (타이틀과 닫기 버튼)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Center(
                    child: Text(
                      '도의',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, color: Color(0xFF333333)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // 첫 번째 입력 필드 (섬 이름)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: TextField(
                        controller: _islandNameController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '섬 이름',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5), // 최대 5글자
                        ],
                        maxLength: 5,
                        // 입력 길이 제한 표시(counterText)를 숨김
                        buildCounter: (_, {required currentLength, required maxLength, required isFocused}) => null,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            
            // 두 번째 입력 필드 (변경할 이름)
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: TextField(
                        controller: _newNameController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '주민',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5), // 최대 5글자
                        ],
                        maxLength: 5,
                        // 입력 길이 제한 표시(counterText)를 숨김
                        buildCounter: (_, {required currentLength, required maxLength, required isFocused}) => null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // 최대 글자수 안내
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '*최대 5글자라네',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[400],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 저장 버튼
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveIslandName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_islandNameController.text.isEmpty || _newNameController.text.isEmpty || _isLoading) 
                      ? Colors.grey[300] // 비활성화 색상
                      : const Color(0xFFB78A6D), // 활성화 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        '저장하기',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
