import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Các biến trạng thái giả lập cho Cài đặt
  bool _maintenanceMode = false;
  bool _allowRegistration = true;
  bool _autoHideReportedPosts = true;
  
  // Danh sách từ khóa bị cấm (Bộ lọc từ ngữ)
  final List<String> _bannedKeywords = ['chửi bậy', 'mua bán điểm', 'đáp án thi', 'hack', 'cờ bạc'];
  final TextEditingController _keywordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // THÀNH PHẦN 1: HEADER & NÚT LƯU
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cấu hình hệ thống',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Hiển thị thông báo lưu thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã lưu cấu hình hệ thống!'), backgroundColor: Colors.green),
                );
              },
              icon: const Icon(Icons.save_rounded, color: Colors.white),
              label: const Text('Lưu thay đổi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7DFF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),

        // THÀNH PHẦN 2: NỘI DUNG CÀI ĐẶT (Chia làm 2 cột)
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CỘT TRÁI: Cài đặt chung & Kiểm duyệt
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildGeneralSettingsCard(),
                      const SizedBox(height: 24),
                      _buildModerationSettingsCard(),
                    ],
                  ),
                ),
                
                const SizedBox(width: 24),
                
                // CỘT PHẢI: Thông tin Server & Admin
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildAdminRolesCard(),
                      const SizedBox(height: 24),
                      _buildSystemInfoCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // CARD 1: CÀI ĐẶT CHUNG
  // ==========================================
  Widget _buildGeneralSettingsCard() {
    return _buildCardTemplate(
      title: 'Cài đặt chung',
      icon: Icons.tune_rounded,
      child: Column(
        children: [
          _buildSwitchRow(
            title: 'Chế độ bảo trì (Maintenance Mode)',
            subtitle: 'Chặn người dùng truy cập vào ứng dụng Mobile trong thời gian nâng cấp.',
            value: _maintenanceMode,
            onChanged: (val) => setState(() => _maintenanceMode = val),
          ),
          const Divider(height: 32),
          _buildSwitchRow(
            title: 'Cho phép đăng ký tài khoản mới',
            subtitle: 'Mở cửa cho tân sinh viên tạo tài khoản trên ứng dụng.',
            value: _allowRegistration,
            onChanged: (val) => setState(() => _allowRegistration = val),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CARD 2: KIỂM DUYỆT NỘI DUNG
  // ==========================================
  Widget _buildModerationSettingsCard() {
    return _buildCardTemplate(
      title: 'Kiểm duyệt nội dung',
      icon: Icons.shield_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSwitchRow(
            title: 'Tự động ẩn bài viết bị báo cáo',
            subtitle: 'Các bài viết có trên 3 lượt Report sẽ tự động bị ẩn khỏi Bảng tin chờ duyệt.',
            value: _autoHideReportedPosts,
            onChanged: (val) => setState(() => _autoHideReportedPosts = val),
          ),
          const Divider(height: 32),
          const Text('Từ khóa cấm (Blacklist)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          const Text('Hệ thống sẽ chặn các bài viết/bình luận chứa các từ khóa này.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 16),
          
          // Ô nhập từ khóa mới
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _keywordController,
                  decoration: InputDecoration(
                    hintText: 'Nhập từ khóa cần chặn...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (val) => _addKeyword(val),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _addKeyword(_keywordController.text),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A7DFF), padding: const EdgeInsets.all(16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Icon(Icons.add, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 16),
          
          // Danh sách từ khóa (Chips)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bannedKeywords.map((keyword) {
              return Chip(
                label: Text(keyword),
                backgroundColor: Colors.red[50],
                labelStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                deleteIconColor: Colors.red,
                onDeleted: () {
                  setState(() => _bannedKeywords.remove(keyword));
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _addKeyword(String val) {
    if (val.trim().isNotEmpty && !_bannedKeywords.contains(val.trim())) {
      setState(() {
        _bannedKeywords.add(val.trim());
        _keywordController.clear();
      });
    }
  }

  // ==========================================
  // CARD 3: QUẢN TRỊ VIÊN
  // ==========================================
  Widget _buildAdminRolesCard() {
    return _buildCardTemplate(
      title: 'Danh sách Quản trị viên',
      icon: Icons.admin_panel_settings_rounded,
      child: Column(
        children: [
          _buildAdminItem('Super Admin', 'admin@system.com', 'https://i.pravatar.cc/150?u=admin', true),
          const Divider(height: 24),
          _buildAdminItem('Tống Thiên Bảo', 'baott@huce.edu.vn', 'https://i.pravatar.cc/150?u=me_123', false),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_rounded, size: 18),
              label: const Text('Thêm Admin mới'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: Color(0xFF4A7DFF)), foregroundColor: const Color(0xFF4A7DFF)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAdminItem(String name, String email, String avatar, bool isSuperAdmin) {
    return Row(
      children: [
        CircleAvatar(radius: 18, backgroundImage: NetworkImage(avatar)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 8),
                  if (isSuperAdmin) 
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)), child: const Text('Trưởng', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                ],
              ),
              Text(email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // CARD 4: THÔNG TIN SERVER
  // ==========================================
  Widget _buildSystemInfoCard() {
    return _buildCardTemplate(
      title: 'Thông tin Server',
      icon: Icons.dns_rounded,
      child: Column(
        children: [
          _buildInfoRow('Phiên bản hệ thống', 'v2.4.0 (Stable)'),
          const Divider(height: 24),
          _buildInfoRow('Máy chủ cơ sở dữ liệu', 'Firebase Firestore'),
          const Divider(height: 24),
          _buildInfoRow('Dung lượng lưu trữ', '124 GB / 5 TB'),
          const Divider(height: 24),
          _buildInfoRow('Lần cập nhật cuối', '04/05/2026'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  // ==========================================
  // WIDGET DÙNG CHUNG: KHUNG CARD
  // ==========================================
  Widget _buildCardTemplate({required String title, required IconData icon, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF4A7DFF).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: const Color(0xFF4A7DFF), size: 20)),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  // WIDGET DÙNG CHUNG: DÒNG CÓ NÚT BẬT TẮT (SWITCH)
  Widget _buildSwitchRow({required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF4A7DFF),
        ),
      ],
    );
  }
}