import 'package:flutter/material.dart';

class AdminSubjectModel {
  final String id;
  String name; 
  String code; 
  final Color themeColor; 
  final int enrolledStudents; 

  AdminSubjectModel({
    required this.id,
    required this.name,
    required this.code,
    required this.themeColor,
    required this.enrolledStudents,
  });
}

class SubjectManagementScreen extends StatefulWidget {
  const SubjectManagementScreen({Key? key}) : super(key: key);

  @override
  State<SubjectManagementScreen> createState() => _SubjectManagementScreenState();
}

class _SubjectManagementScreenState extends State<SubjectManagementScreen> {
  final List<AdminSubjectModel> _mockSubjects = [
    AdminSubjectModel(id: 'S01', name: 'Khai phá dữ liệu', code: 'IT4040', themeColor: const Color(0xFF4A7DFF), enrolledStudents: 156),
    AdminSubjectModel(id: 'S02', name: 'Đồ án Kiến trúc', code: 'AR3020', themeColor: const Color(0xFF10B981), enrolledStudents: 240),
    AdminSubjectModel(id: 'S03', name: 'Cơ kết cấu', code: 'CE2010', themeColor: const Color(0xFFF59E0B), enrolledStudents: 312),
    AdminSubjectModel(id: 'S04', name: 'Toán cao cấp', code: 'MA1010', themeColor: const Color(0xFF8B5CF6), enrolledStudents: 450),
    AdminSubjectModel(id: 'S05', name: 'Vật lý đại cương', code: 'PH1020', themeColor: const Color(0xFFEC4899), enrolledStudents: 420),
    AdminSubjectModel(id: 'S06', name: 'Trí tuệ nhân tạo', code: 'IT5010', themeColor: const Color(0xFF14B8A6), enrolledStudents: 89),
  ];

  String _searchQuery = '';

  void _saveSubject(String? id, String name, String code) {
    setState(() {
      if (id == null) {
        _mockSubjects.add(AdminSubjectModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name, code: code, themeColor: Colors.purple, enrolledStudents: 0
        ));
      } else {
        final index = _mockSubjects.indexWhere((s) => s.id == id);
        if (index != -1) {
          _mockSubjects[index].name = name;
          _mockSubjects[index].code = code;
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu môn học thành công!'), backgroundColor: Colors.green));
  }

  void _deleteSubject(String id) {
    setState(() => _mockSubjects.removeWhere((s) => s.id == id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa môn học!'), backgroundColor: Colors.red));
  }

  void _showAddEditSubjectModal([AdminSubjectModel? subject]) {
    final isEditing = subject != null;
    final nameCtrl = TextEditingController(text: subject?.name);
    final codeCtrl = TextEditingController(text: subject?.code);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isEditing ? 'Chỉnh sửa môn học' : 'Thêm môn học mới', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ],
          ),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tên môn học', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(hintText: 'VD: Khai phá dữ liệu', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 16),
              const Text('Mã học phần', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: codeCtrl,
                decoration: InputDecoration(hintText: 'VD: IT4040', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty && codeCtrl.text.isNotEmpty) {
                      _saveSubject(subject?.id, nameCtrl.text, codeCtrl.text); 
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A7DFF), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text(isEditing ? 'Lưu thay đổi' : 'Thêm môn học', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = _mockSubjects.where((sub) {
      return sub.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             sub.code.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 350,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: const InputDecoration(hintText: 'Tìm kiếm theo tên môn hoặc mã...', prefixIcon: Icon(Icons.search, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddEditSubjectModal(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Thêm môn học', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A7DFF), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: filteredSubjects.isEmpty 
          ? const Center(child: Text('Không tìm thấy môn học nào.', style: TextStyle(color: Colors.grey, fontSize: 16)))
          : GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 320, 
                childAspectRatio: 1.4, 
                crossAxisSpacing: 24, 
                mainAxisSpacing: 24, 
              ),
              itemCount: filteredSubjects.length,
              itemBuilder: (context, index) {
                return _buildSubjectCard(filteredSubjects[index]);
              },
            ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(AdminSubjectModel subject) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: subject.themeColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.book_rounded, color: subject.themeColor, size: 24),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
                onSelected: (value) {
                  if (value == 'edit') _showAddEditSubjectModal(subject);
                  if (value == 'delete') _deleteSubject(subject.id); 
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                  const PopupMenuItem(value: 'delete', child: Text('Xóa môn học', style: TextStyle(color: Colors.red))),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(subject.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text('Mã HP: ${subject.code}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.people_alt_rounded, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text('${subject.enrolledStudents} sinh viên đang theo dõi', style: const TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
            ],
          )
        ],
      ),
    );
  }
}