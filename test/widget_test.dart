import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Import file main từ project của bạn
import 'package:book/main.dart';

void main() {
  testWidgets('Library system smoke test', (WidgetTester tester) async {
    // 1. Khởi chạy ứng dụng (Sử dụng LibrarySystem thay vì MyApp)
    await tester.pumpWidget(const MaterialApp(home: LibrarySystem()));

    // 2. Kiểm tra tiêu đề AppBar (Phải khớp chính xác từng chữ)
    expect(find.text('Hệ thống Thư viện UTH'), findsOneWidget);

    // 3. Kiểm tra sự tồn tại của tên nhân viên khởi tạo
    expect(
      find.text('Nguyen Van A'),
      findsNothing,
    ); // Vì nó nằm trong TextField hoặc biến hiển thị có tiền tố
    // Cách kiểm tra an toàn hơn cho tên nhân viên:
    expect(find.textContaining('Nguyen Van A'), findsOneWidget);

    // 4. Kiểm tra các Icon ở thanh điều hướng dưới cùng (BottomNavigationBar)
    expect(find.byIcon(Icons.settings), findsOneWidget); // Icon Quản lý
    expect(find.byIcon(Icons.book), findsOneWidget); // Icon DS Sách
    expect(find.byIcon(Icons.person), findsOneWidget); // Icon Nhân viên
  });
}
