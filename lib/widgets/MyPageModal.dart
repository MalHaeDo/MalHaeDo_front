import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IslandNameDialog extends StatefulWidget {
  final Function(String)? onSave;
  
  const IslandNameDialog({Key? key, this.onSave}) : super(key: key);

  @override
  _IslandNameDialogState createState() => _IslandNameDialogState();
}

class _IslandNameDialogState extends State<IslandNameDialog> {
  final TextEditingController _islandNameController = TextEditingController();
  final TextEditingController _newNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // 저장된 데이터 불러오기
  }

  @override
  void dispose() {
    _islandNameController.dispose();
    _newNameController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _islandNameController.text = prefs.getString('user_name') ?? '';
      _newNameController.text = prefs.getString('island_name') ?? '';
    });
  }

  Future<void> _saveIslandName() async {
    if (_islandNameController.text.isEmpty || _newNameController.text.isEmpty) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _newNameController.text);
    await prefs.setString('island_name', _islandNameController.text);

    widget.onSave?.call(_newNameController.text);
    Navigator.of(context).pop();
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
                      '마이페이지',
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
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: TextField(
                        controller: _islandNameController,
                        textAlign: TextAlign.right, // 오른쪽 정렬
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '섬 이름',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                          suffixText: "도의", // 입력 필드 뒤에 붙는 텍스트
                          suffixStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5), // 최대 5글자
                        ],
                        maxLength: 5,
                        buildCounter: (_, {required currentLength, required maxLength, required isFocused}) => null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: TextField(
                        controller: _newNameController,
                        textAlign: TextAlign.right, // 오른쪽 정렬
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '변경할 이름',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                          suffixText: "주민", // 입력 필드 뒤에 붙는 텍스트
                          suffixStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5), // 최대 5글자
                        ],
                        maxLength: 5,
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
                alignment: Alignment.center,
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
