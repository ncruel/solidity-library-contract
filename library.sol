pragma solidity 0.8.9;

contract Library {

    event BookAdded(Book book);

    struct Book {
        string isbn;
        string name;
        string author;
        uint copies;
    }

    Book[] public books;

    function _addBook(string memory _isbn, string memory _name, string memory _author, uint _copies) internal {
        Book memory book = Book(_isbn, _name, _author, _copies);
        books.push(book);
        emit BookAdded(book);
    }
}