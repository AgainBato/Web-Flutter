import 'package:flutter/material.dart';

class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String major;
  final String joinDate;
  bool isActive; 
  final String avatarUrl;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.major,
    required this.joinDate,
    required this.isActive,
    required this.avatarUrl,
  });
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<AdminUserModel> _mockUsers = [
    AdminUserModel(id: 'U001', name: 'Tống Thiên Bảo', email: 'baott@huce.edu.vn', major: 'CNTT', joinDate: '10/04/2026', isActive: true, avatarUrl: 'https://i.pravatar.cc/150?u=me_123'),
    AdminUserModel(id: 'U002', name: 'Nguyễn Đức Anh', email: 'anhnd@huce.edu.vn', major: 'Kiến trúc', joinDate: '12/04/2026', isActive: true, avatarUrl: 'https://i.pravatar.cc/150?u=user_456'),
    AdminUserModel(id: 'U003', name: 'Trần Lan Hương', email: 'huongtl@huce.edu.vn', major: 'Kinh tế XD', joinDate: '15/04/2026', isActive: false, avatarUrl: 'https://i.pravatar.cc/150?u=user_789'),
    AdminUserModel(id: 'U004', name: 'Lê Minh Tuấn', email: 'tuanlm@huce.edu.vn', major: 'Cầu đường', joinDate: '20/04/2026', isActive: true, avatarUrl: 'https://i.pravatar.cc/150?u=user_111'),
    AdminUserModel(id: 'U005', name: 'Phạm Thị Mai', email: 'maipt@huce.edu.vn', major: 'CNTT', joinDate: '22/04/2026', isActive: true, avatarUrl: 'https://i.pravatar.cc/150?u=user_222'),
  ];

  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';

  void _toggleUserStatus(String userId) {
    setState(() {
      final user = _mockUsers.firstWhere((u) => u.id == userId);
      user.isActive = !user.isActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã cập nhật trạng thái người dùng!'), duration: Duration(seconds: 1), backgroundColor: Colors.blue)
    );
  }

  void _showUserProfile(AdminUserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(user.avatarUrl)),
            const SizedBox(height: 16),
            Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 32),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Chuyên ngành:'), Text(user.major, style: const TextStyle(fontWeight: FontWeight.bold))]),
            const Divider(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Ngày tham gia:'), Text(user.joinDate, style: const TextStyle(fontWeight: FontWeight.bold))]),
            const Divider(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Trạng thái:'), 
              Text(user.isActive ? 'Đang hoạt động' : 'Bị khóa', style: TextStyle(fontWeight: FontWeight.bold, color: user.isActive ? Colors.green : Colors.red))
            ]),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A7DFF), padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Đóng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
  // HÀM: Hiện Modal Thêm người dùng mới
  void _showAddUserModal() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final majorCtrl = TextEditingController();
    final passwordCtrl = TextEditingController(); // Thêm controller cho mật khẩu
    bool obscurePassword = true; // Biến trạng thái để ẩn/hiện mật khẩu

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder( // Dùng StatefulBuilder để setState cho riêng cái Popup này (nút ẩn/hiện pass)
        builder: (context, setModalState) {
          return AlertDialog(
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
                  const Text('Thêm tài khoản mới', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                ],
              ),
            ),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Họ và tên', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(controller: nameCtrl, decoration: InputDecoration(hintText: 'VD: Nguyễn Văn A', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none))),
                    const SizedBox(height: 16),
                    
                    const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(controller: emailCtrl, decoration: InputDecoration(hintText: 'VD: email@huce.edu.vn', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none))),
                    const SizedBox(height: 16),

                    // Đã bổ sung trường Mật khẩu
                    const Text('Mật khẩu', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: passwordCtrl, 
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Nhập mật khẩu khởi tạo', 
                        filled: true, 
                        fillColor: Colors.grey[100], 
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () {
                            setModalState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        )
                      )
                    ),
                    const SizedBox(height: 16),

                    const Text('Chuyên ngành', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(controller: majorCtrl, decoration: InputDecoration(hintText: 'VD: CNTT', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none))),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Ràng buộc phải nhập đủ Tên, Email và Mật khẩu
                          if (nameCtrl.text.isNotEmpty && emailCtrl.text.isNotEmpty && passwordCtrl.text.isNotEmpty) {
                            setState(() {
                              _mockUsers.insert(0, AdminUserModel(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                name: nameCtrl.text,
                                email: emailCtrl.text,
                                major: majorCtrl.text.isEmpty ? 'Chưa cập nhật' : majorCtrl.text,
                                joinDate: '04/05/2026', 
                                isActive: true,
                                avatarUrl: 'https://i.pravatar.cc/150?u=${DateTime.now().millisecondsSinceEpoch}', 
                              ));
                            });
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm tài khoản thành công!'), backgroundColor: Colors.green));
                          } else {
                            // Cảnh báo nếu nhập thiếu
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đủ Tên, Email và Mật khẩu!'), backgroundColor: Colors.orange));
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A7DFF), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: const Text('Tạo tài khoản', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _mockUsers.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(_searchQuery.toLowerCase()) || user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'Tất cả' || (_selectedFilter == 'Hoạt động' && user.isActive) || (_selectedFilter == 'Bị khóa' && !user.isActive);
      return matchesSearch && matchesFilter;
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
                decoration: const InputDecoration(hintText: 'Tìm kiếm theo tên hoặc email...', prefixIcon: Icon(Icons.search, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      items: ['Tất cả', 'Hoạt động', 'Bị khóa'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (value) => setState(() => _selectedFilter = value!),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _showAddUserModal(),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Thêm tài khoản', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A7DFF), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, 
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFF9FAFB)),
                    dataRowMinHeight: 70,
                    dataRowMaxHeight: 70,
                    horizontalMargin: 24,
                    columnSpacing: 40,
                    columns: const [
                      DataColumn(label: Text('Người dùng', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
                      DataColumn(label: Text('Chuyên ngành', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
                      DataColumn(label: Text('Ngày tham gia', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
                      DataColumn(label: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
                      DataColumn(label: Text('Hành động', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))),
                    ],
                    rows: filteredUsers.map((user) => _buildDataRow(user)).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildDataRow(AdminUserModel user) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: NetworkImage(user.avatarUrl), backgroundColor: Colors.grey[200]),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                  Text(user.email, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        DataCell(Text(user.major, style: const TextStyle(color: Colors.black87))),
        DataCell(Text(user.joinDate, style: const TextStyle(color: Colors.black87))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: user.isActive ? const Color(0xFF10B981).withOpacity(0.1) : const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.isActive ? 'Hoạt động' : 'Bị khóa',
              style: TextStyle(
                color: user.isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.blue),
                tooltip: 'Xem hồ sơ',
                onPressed: () => _showUserProfile(user),
              ),
              IconButton(
                icon: Icon(user.isActive ? Icons.lock_open_rounded : Icons.lock_outline_rounded, color: user.isActive ? Colors.green : Colors.red),
                tooltip: user.isActive ? 'Khóa tài khoản' : 'Mở khóa',
                onPressed: () => _toggleUserStatus(user.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}   