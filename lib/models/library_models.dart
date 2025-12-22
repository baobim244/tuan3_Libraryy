// 1. TÍNH TRỪU TƯỢNG
abstract class Item {
  String getTitle();
}

// 2. TÍNH KẾ THỨA (Inheritance)
class Book extends Item {
  final String title;
  final String description;
  bool isBorrowed;

  Book({
    required this.title,
    required this.description,
    this.isBorrowed = false,
  });

  @override
  String getTitle() => "Sách: $title";
}

// 3. TÍNH ĐÓNG GÓI (Encapsulation)
class LibraryUser {
  String _name;
  final List<Book> _borrowedBooks = [];

  LibraryUser(this._name);

  String get name => _name;

  set name(String newName) {
    if (newName.trim().isNotEmpty) {
      _name = newName;
    }
  }

  List<Book> get borrowedBooks => _borrowedBooks;

  void borrow(Book book) {
    if (!_borrowedBooks.contains(book)) {
      _borrowedBooks.add(book);
      book.isBorrowed = true;
    }
  }

  void returnBook(Book book) {
    _borrowedBooks.remove(book);
    book.isBorrowed = false;
  }
}
