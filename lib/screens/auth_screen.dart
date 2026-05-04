import 'package:flutter/material.dart';
import 'package:fe_admin_web/screens/admin_layout_screen.dart'; // Đổi tên fe_admin_web theo project của bạn

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true; // Biến để chuyển đổi giữa Đăng nhập và Đăng ký
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: Container(
          width: 900, // Chiều rộng tối đa của thẻ
          height: 550, // Chiều cao tối đa của thẻ
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Row(
            children: [
              // ==========================================
              // CỘT TRÁI: BANNER THƯƠNG HIỆU
              // ==========================================
              Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A7DFF),
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
                    // Thêm một chút gradient cho màu xanh thêm sâu
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A7DFF), Color(0xFF2E5BFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          _isLogin ? 'Chào mừng\ntrở lại!' : 'Tham gia\nHệ thống',
                          style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold, height: 1.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isLogin 
                              ? 'Đăng nhập để truy cập vào bảng điều khiển và quản lý cộng đồng sinh viên của bạn.'
                              : 'Tạo tài khoản quản trị viên mới để cùng xây dựng cộng đồng học tập.',
                          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ==========================================
              // CỘT PHẢI: FORM ĐĂNG NHẬP / ĐĂNG KÝ
              // ==========================================
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin ? 'Đăng nhập Admin' : 'Đăng ký Admin',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLogin ? 'Vui lòng nhập thông tin của bạn' : 'Điền thông tin để tạo tài khoản',
                          style: const TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        const SizedBox(height: 32),

                        // Form Đăng ký sẽ có thêm trường Họ tên
                        if (!_isLogin) ...[
                          const Text('Họ và tên', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 8),
                          _buildTextField(hint: 'VD: Tống Thiên Bảo', icon: Icons.person_outline_rounded),
                          const SizedBox(height: 20),
                        ],

                        // Trường Email
                        const Text('Địa chỉ Email', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 8),
                        _buildTextField(hint: 'admin@huce.edu.vn', icon: Icons.email_outlined),
                        const SizedBox(height: 20),

                        // Trường Mật khẩu
                        const Text('Mật khẩu', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 8),
                        _buildTextField(
                          hint: '••••••••', 
                          icon: Icons.lock_outline_rounded, 
                          isPassword: true,
                        ),
                        const SizedBox(height: 8),

                        // Quên mật khẩu (Chỉ hiện ở màn Đăng nhập)
                        if (_isLogin)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Quên mật khẩu?', style: TextStyle(color: Color(0xFF4A7DFF), fontWeight: FontWeight.w600)),
                            ),
                          ),
                        
                        SizedBox(height: _isLogin ? 16 : 32),

                        // Nút Đăng nhập / Đăng ký
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Chuyển hướng sang màn hình Admin Layout và không cho quay lại bằng phím Back
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const AdminLayoutScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A7DFF),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Text(
                              _isLogin ? 'Đăng nhập' : 'Tạo tài khoản',
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Nút Chuyển đổi giữa Đăng nhập / Đăng ký
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_isLogin ? 'Chưa có tài khoản? ' : 'Đã có tài khoản? ', style: const TextStyle(color: Colors.grey)),
                            GestureDetector(
                              onTap: () => setState(() => _isLogin = !_isLogin), // Đảo ngược trạng thái
                              child: Text(
                                _isLogin ? 'Đăng ký ngay' : 'Đăng nhập', 
                                style: const TextStyle(color: Color(0xFF4A7DFF), fontWeight: FontWeight.bold)
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET HỖ TRỢ: Text Field chuẩn form
  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A7DFF), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}