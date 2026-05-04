import 'package:flutter/material.dart';

// ==========================================
// 1. MODEL GIẢ LẬP DỮ LIỆU NGƯỜI DÙNG
// ==========================================
class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String major;
  final String joinDate;
  final bool isActive;
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

// ==========================================
// 2. GIAO DIỆN CHÍNH
// ==========================================
class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  // Danh sách user giả lập
  final List<AdminUserModel> _mockUsers = [
    AdminUserModel(id: 'U001', name: 'Tống Thiên Bảo', email: 'baott@huce.edu.vn', major: 'CNTT', joinDate: '10/04/2026', isActive: true, avatarUrl: 'https://i.pravatar.cc/150?u=me_123'),
    AdminUserModel(id: 'U002', name: 'Nguyễn Đức Anh', email: 'anhnd@huce.edu.vn', major: 'Kiến trúc', joinDate: '12/04/2026', isActive: true, avatarUrl: 'https://i.pravatar.cc/150?u=user_456'),
    AdminUserModel(id: 'U003', name: 'Trần Lan Hương', email: 'huongtl@huce.edu.vn', major: 'Kinh tế XD', joinDate: '15/04/2026', isActive: false, avatarUrl: 'https://i.pravatar.cc/150?u=user_789'),
    AdminUserModel(id: 'U004', name: 'Lê Minh Tuấn', email: 'tuanlm@huce.edu.vn', major: 'Cầu đường', joinDate: '20/04/2026', isActive: true, avatarUrl: 'https://i.pravatar.cc/150?u=user_111'),
    AdminUserModel(id: 'U005', name: 'Phạm Thị Mai', email: 'maipt@huce.edu.vn', major: 'CNTT', joinDate: '22/04/2026', isActive: true, avatarUrl: 'https://i.pravatar.cc/150?u=user_222'),
  ];

  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách dựa trên tìm kiếm và filter
    final filteredUsers = _mockUsers.where((user) {
      final matchesSearch = user.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'Tất cả' ||
                            (_selectedFilter == 'Hoạt động' && user.isActive) ||
                            (_selectedFilter == 'Bị khóa' && !user.isActive);
      return matchesSearch && matchesFilter;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // THÀNH PHẦN 1: THANH CÔNG CỤ (TÌM KIẾM & LỌC)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Ô tìm kiếm
            Container(
              width: 350,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm theo tên hoặc email...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            
            // Bộ lọc & Nút Thêm mới
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      items: ['Tất cả', 'Hoạt động', 'Bị khóa']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedFilter = value!),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {}, // Nút này sau này có thể dùng để Admin thêm tay user
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Thêm tài khoản', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A7DFF),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ],
            )
          ],
        ),
        
        const SizedBox(height: 24),

        // THÀNH PHẦN 2: BẢNG DỮ LIỆU (DATA TABLE)
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Hỗ trợ cuộn ngang nếu màn hình hẹp
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFF9FAFB)), // Màu xám nhạt cho tiêu đề
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

  // WIDGET HỖ TRỢ: Tạo một hàng dữ liệu trong bảng
  DataRow _buildDataRow(AdminUserModel user) {
    return DataRow(
      cells: [
        // Cột 1: Avatar + Tên + Email
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
        
        // Cột 2: Chuyên ngành
        DataCell(Text(user.major, style: const TextStyle(color: Colors.black87))),
        
        // Cột 3: Ngày tham gia
        DataCell(Text(user.joinDate, style: const TextStyle(color: Colors.black87))),
        
        // Cột 4: Trạng thái (Chip màu)
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
        
        // Cột 5: Hành động (Nút bấm)
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined, color: Colors.blue),
                tooltip: 'Xem hồ sơ',
                onPressed: () {}, // Todo: Mở popup xem chi tiết
              ),
              IconButton(
                icon: Icon(user.isActive ? Icons.lock_outline_rounded : Icons.lock_open_rounded, color: user.isActive ? Colors.red : Colors.green),
                tooltip: user.isActive ? 'Khóa tài khoản' : 'Mở khóa',
                onPressed: () {
                  // Todo: Xác nhận khóa/mở khóa
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}