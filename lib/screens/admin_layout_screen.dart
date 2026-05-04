import 'package:flutter/material.dart';
import 'package:fe_admin_web/screens/user_management_screen.dart'; 
import 'package:fe_admin_web/screens/feed_management_screen.dart';
import 'package:fe_admin_web/screens/subject_management_screen.dart';
import 'package:fe_admin_web/screens/settings_screen.dart';
import 'package:fe_admin_web/screens/auth_screen.dart';

class AdminLayoutScreen extends StatefulWidget {
  const AdminLayoutScreen({Key? key}) : super(key: key);

  @override
  State<AdminLayoutScreen> createState() => _AdminLayoutScreenState();
}

class _AdminLayoutScreenState extends State<AdminLayoutScreen> {
  int _selectedIndex = 0;

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Xác nhận đăng xuất', style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text('Bạn có chắc chắn muốn thoát khỏi hệ thống quản trị không?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx), 
          child: const Text('Hủy', style: TextStyle(color: Colors.grey))
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx); // Đóng dialog
            // Quay lại màn hình đăng nhập và xóa sạch lịch sử chuyển trang trước đó
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const AuthScreen())
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Row(
        children: [
          // ==========================================
          // 1. SIDEBAR (Menu bên trái)
          // ==========================================
          Container(
            width: 260,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF4A7DFF), borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text('Student Admin', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                ),
                const Divider(height: 1),
                const SizedBox(height: 16),
                
                _buildNavItem(icon: Icons.dashboard_rounded, title: 'Tổng quan', index: 0),
                _buildNavItem(icon: Icons.people_alt_rounded, title: 'Người dùng', index: 1),
                _buildNavItem(icon: Icons.article_rounded, title: 'Bài viết & Feed', index: 2),
                _buildNavItem(icon: Icons.subject_rounded, title: 'Môn học (Onboarding)', index: 3),
                
                const Spacer(),
                const Divider(height: 1),
                _buildNavItem(icon: Icons.settings_rounded, title: 'Cài đặt hệ thống', index: 4),
                _buildNavItem(icon: Icons.logout_rounded, title: 'Đăng xuất', index: 5, iconColor: Colors.red, textColor: Colors.red),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ==========================================
          // 2. MAIN CONTENT (Nội dung bên phải)
          // ==========================================
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_getPageTitle(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.notifications_none_rounded, color: Colors.black54), onPressed: () {}),
                          const SizedBox(width: 24),
                          const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin'), radius: 18),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Super Admin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text('admin@system.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),

                // Vùng thay đổi nội dung dựa vào Menu
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: _buildMainContent(), // <-- Gọi hàm _buildMainContent() ở đây
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // HÀM QUẢN LÝ CHUYỂN TRANG
  // ==========================================
  Widget _buildMainContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardDemo();
      case 1:
        return const UserManagementScreen(); 
      case 2:
        return const FeedManagementScreen();
      case 3:
        return const SubjectManagementScreen();
      case 4:
        return const SettingsScreen();
      default:
        return Center(
          child: Text(
            'Đang phát triển nội dung cho: ${_getPageTitle()}', 
            style: const TextStyle(fontSize: 18, color: Colors.grey)
          )
        );
    }
  }

  // ==========================================
  // CÁC HÀM HỖ TRỢ SIDEBAR
  // ==========================================
  Widget _buildNavItem({required IconData icon, required String title, required int index, Color? iconColor, Color? textColor}) {
    final isSelected = _selectedIndex == index;
    final activeColor = const Color(0xFF4A7DFF);

    return InkWell(
      onTap: () {
        if (index == 5) {
            _showLogoutDialog(context);
        } else {
            setState(() => _selectedIndex = index);
        }
    },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          border: Border(right: BorderSide(color: isSelected ? activeColor : Colors.transparent, width: 3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? activeColor : (iconColor ?? Colors.black54), size: 22),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(color: isSelected ? activeColor : (textColor ?? Colors.black87), fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0: return 'Tổng quan hệ thống';
      case 1: return 'Quản lý Người dùng';
      case 2: return 'Kiểm duyệt Bài viết';
      case 3: return 'Danh mục Môn học';
      case 4: return 'Cài đặt chung';
      default: return 'Dashboard';
    }
  }

  // ==========================================
  // GIAO DIỆN TỔNG QUAN (DASHBOARD)
  // ==========================================
  Widget _buildDashboardDemo() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatCard('Tổng sinh viên', '1,248', Icons.people_rounded, const Color(0xFF4A7DFF)),
              const SizedBox(width: 24),
              _buildStatCard('Deadline đang chạy', '856', Icons.access_time_rounded, const Color(0xFF10B981)),
              const SizedBox(width: 24),
              _buildStatCard('Bài viết cộng đồng', '320', Icons.article_rounded, const Color(0xFF8B5CF6)),
              const SizedBox(width: 24),
              _buildStatCard('Báo cáo cần xử lý', '5', Icons.warning_rounded, const Color(0xFFEF4444)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 300,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Lượng tương tác cộng đồng (7 ngày)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      Expanded(
                        child: CustomPaint(size: const Size(double.infinity, double.infinity), painter: MockLineChartPainter()),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Container(
                  height: 300,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hoàn thành Deadline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 150, width: 150,
                              child: CircularProgressIndicator(value: 0.75, strokeWidth: 12, backgroundColor: Colors.orange[100], color: const Color(0xFF10B981)),
                            ),
                            const Text('75%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendDot(const Color(0xFF10B981), 'Đúng hạn'),
                          const SizedBox(width: 16),
                          _buildLegendDot(Colors.orange[100]!, 'Trễ hạn'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hoạt động mới nhất', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildActivityRow('Thiên Bảo', 'vừa đăng một bài viết mới trong mục Hỏi đáp.', '2 phút trước'),
                _buildActivityRow('Lan Hương', 'vừa hoàn thành bài tập Đồ án Kiến trúc.', '15 phút trước'),
                _buildActivityRow('Đức Anh', 'đã báo cáo một bình luận vi phạm.', '1 giờ trước'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bọc Expanded ở đây để chữ tự rớt dòng nếu màn hình hẹp
                Expanded(
                  child: Text(
                    title, 
                    style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w600),
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8), 
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), 
                  child: Icon(icon, color: color, size: 20)
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActivityRow(String user, String action, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF4A7DFF), shape: BoxShape.circle)),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(text: TextSpan(style: const TextStyle(color: Colors.black87, fontSize: 14), children: [TextSpan(text: '$user ', style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: action)])),
          ),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class MockLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF4A7DFF)..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.9, size.width * 0.4, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.1, size.width * 0.8, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.5, size.width, size.height * 0.2);
    canvas.drawPath(path, paint);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [const Color(0xFF4A7DFF).withOpacity(0.3), Colors.white.withOpacity(0.0)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fillPath, fillPaint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}