import 'package:flutter/material.dart';

import 'package:book/models/library_models.dart';

void main() => runApp(
  const MaterialApp(home: LibrarySystem(), debugShowCheckedModeBanner: false),
);

class LibrarySystem extends StatefulWidget {
  const LibrarySystem({super.key});

  @override
  State<LibrarySystem> createState() => _LibrarySystemState();
}

class _LibrarySystemState extends State<LibrarySystem> {
  final TextEditingController _nameController = TextEditingController();

  // Danh sách sách (Tính Đa hình)
  final List<Book> allBooks = [
    Book(title: "Sách 01", description: "Hướng dẫn xây dựng ứng dụng Flutter."),
    Book(title: "Sách 02", description: "Tìm hiểu 4 nguyên tắc OOP căn bản."),
    Book(
      title: "Sách 03",
      description: "Tối ưu hóa mã nguồn và cấu trúc dữ liệu.",
    ),
  ];

  late LibraryUser currentUser;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    currentUser = LibraryUser("Nguyen Van A");

    _nameController.text = currentUser.name;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildManagementPage(),
      _buildBookListPage(),
      _buildProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hệ thống Thư viện UTH"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Quản lý'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'DS Sách'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Nhân viên'),
        ],
      ),
    );
  }

  Widget _buildManagementPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nhân viên",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Cập nhật tên nhân viên mới (Tính Đóng gói)
                    currentUser.name = _nameController.text;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã cập nhật tên nhân viên!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text("Đổi", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Danh sách sách",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: allBooks.length,
                itemBuilder: (context, index) {
                  final book = allBooks[index];
                  return CheckboxListTile(
                    title: Text(book.getTitle()),
                    subtitle: Text(book.description),
                    value: currentUser.borrowedBooks.contains(book),
                    activeColor: Colors.redAccent,
                    onChanged: (val) {
                      setState(() {
                        val!
                            ? currentUser.borrow(book)
                            : currentUser.returnBook(book);
                      });
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () => _showConfirmDialog(),
              child: const Text(
                "Thêm",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookListPage() {
    return ListView.builder(
      itemCount: allBooks.length,
      itemBuilder: (context, index) {
        final book = allBooks[index];
        return ListTile(
          leading: const Icon(Icons.library_books, color: Colors.blueAccent),
          title: Text(book.title),
          trailing: Text(
            book.isBorrowed ? "Đã mượn" : "Sẵn có",
            style: TextStyle(
              color: book.isBorrowed ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 20),
          Text(
            "Tên: ${currentUser.name}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "Số sách đang mượn: ${currentUser.borrowedBooks.length}",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận mượn"),
        content: Text(
          "Nhân viên: ${currentUser.name}\nSố lượng sách: ${currentUser.borrowedBooks.length}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Xong"),
          ),
        ],
      ),
    );
  }
}
