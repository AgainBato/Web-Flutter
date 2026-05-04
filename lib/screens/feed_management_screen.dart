import 'package:flutter/material.dart';

class AdminPostModel {
  final String id;
  final String authorName;
  final String avatarUrl;
  final String contentSnippet;
  final String fullContent;
  final int likes;
  final int commentsCount;
  final String postDate;
  final bool isReported;

  AdminPostModel({
    required this.id,
    required this.authorName,
    required this.avatarUrl,
    required this.contentSnippet,
    required this.fullContent,
    required this.likes,
    required this.commentsCount,
    required this.postDate,
    this.isReported = false,
  });
}

class FeedManagementScreen extends StatefulWidget {
  const FeedManagementScreen({Key? key}) : super(key: key);

  @override
  State<FeedManagementScreen> createState() => _FeedManagementScreenState();
}

class _FeedManagementScreenState extends State<FeedManagementScreen> {
  final List<AdminPostModel> _mockPosts = [
    AdminPostModel(id: 'P001', authorName: 'Đức Anh', avatarUrl: 'https://i.pravatar.cc/150?u=user_456', contentSnippet: 'Mọi người cho mình hỏi bài này giải sao với...', fullContent: 'Mọi người cho mình hỏi bài này giải sao với? Mình dùng định lý Pitago mà tính mãi không ra kết quả đúng như đáp án.', likes: 36, commentsCount: 12, postDate: '14:30 - 04/05/2026', isReported: false),
    AdminPostModel(id: 'P002', authorName: 'Lan Hương', avatarUrl: 'https://i.pravatar.cc/150?u=user_789', contentSnippet: 'Có ai đi học nhóm thư viện chiều nay không?', fullContent: 'Có ai đi học nhóm thư viện chiều nay không? Mình đang cần ôn lại phần Cơ kết cấu.', likes: 10, commentsCount: 5, postDate: '09:15 - 04/05/2026', isReported: false),
    AdminPostModel(id: 'P003', authorName: 'Minh Tuấn', avatarUrl: 'https://i.pravatar.cc/150?u=user_111', contentSnippet: 'Đề thi năm nay khó quá, giảng viên cho đề ảo ma...', fullContent: 'Đề thi năm nay khó quá, giảng viên cho đề ảo ma thật sự, học một đằng thi một nẻo, chán không buồn nói!!!', likes: 85, commentsCount: 42, postDate: '20:00 - 03/05/2026', isReported: true),
    AdminPostModel(id: 'P004', authorName: 'Tống Thiên Bảo', avatarUrl: 'https://i.pravatar.cc/150?u=me_123', contentSnippet: 'Chia sẻ tài liệu RAG và LLM cho NCKH...', fullContent: 'Chia sẻ tài liệu RAG và LLM cho NCKH. Các bạn tải về tham khảo nhé, file mình để ở link drive bên dưới.', likes: 120, commentsCount: 18, postDate: '10:00 - 02/05/2026', isReported: false),
  ];

  String _searchQuery = '';
  String _selectedFilter = 'Tất cả';

  void _confirmDeletePost(String postId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa bài viết?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn có chắc chắn muốn xóa bài viết này không? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              setState(() => _mockPosts.removeWhere((p) => p.id == postId));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa bài viết khỏi hệ thống!'), backgroundColor: Colors.red));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa ngay', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPostDetailModal(AdminPostModel post) {
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
              const Text('Chi tiết bài viết', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ],
          ),
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: NetworkImage(post.avatarUrl)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(post.postDate, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(post.fullContent, style: const TextStyle(fontSize: 15, height: 1.5)),
              const SizedBox(height: 24),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${post.likes} Lượt thích  •  ${post.commentsCount} Bình luận', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx); 
                      _confirmDeletePost(post.id); 
                    },
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Xóa bài này'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = _mockPosts.where((post) {
      final matchesSearch = post.authorName.toLowerCase().contains(_searchQuery.toLowerCase()) || post.contentSnippet.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'Tất cả' || (_selectedFilter == 'Bị báo cáo' && post.isReported) || (_selectedFilter == 'An toàn' && !post.isReported);
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
                decoration: const InputDecoration(hintText: 'Tìm theo người đăng hoặc nội dung...', prefixIcon: Icon(Icons.search, color: Colors.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  items: ['Tất cả', 'An toàn', 'Bị báo cáo'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: e == 'Bị báo cáo' ? Colors.red : Colors.black87, fontWeight: e == 'Bị báo cáo' ? FontWeight.bold : FontWeight.normal)))).toList(),
                  onChanged: (value) => setState(() => _selectedFilter = value!),
                ),
              ),
            ),
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
                    columnSpacing: 32,
                    columns: const [
                      DataColumn(label: Text('Người đăng', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Nội dung tóm tắt', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Tương tác', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Thời gian', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Hành động', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: filteredPosts.map((post) => _buildDataRow(post)).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildDataRow(AdminPostModel post) {
    return DataRow(
      color: MaterialStateProperty.resolveWith((states) => post.isReported ? Colors.red[50] : Colors.white),
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundImage: NetworkImage(post.avatarUrl)),
              const SizedBox(width: 8),
              Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        DataCell(
          SizedBox(
            width: 250,
            child: Text(post.contentSnippet, overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
        ),
        DataCell(
          Row(
            children: [
              const Icon(Icons.favorite_rounded, size: 16, color: Colors.redAccent),
              const SizedBox(width: 4),
              Text('${post.likes}'),
              const SizedBox(width: 16),
              const Icon(Icons.chat_bubble_rounded, size: 16, color: Colors.blueAccent),
              const SizedBox(width: 4),
              Text('${post.commentsCount}'),
            ],
          ),
        ),
        DataCell(Text(post.postDate, style: const TextStyle(color: Colors.black54))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: post.isReported ? Colors.red : const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              post.isReported ? 'Bị báo cáo' : 'An toàn',
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_red_eye_rounded, color: Color(0xFF4A7DFF)),
                tooltip: 'Xem chi tiết',
                onPressed: () => _showPostDetailModal(post), 
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: Colors.red),
                tooltip: 'Xóa bài viết',
                onPressed: () => _confirmDeletePost(post.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}