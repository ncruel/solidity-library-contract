pragma solidity 0.8.10;

import "./Ownable.sol";

contract Library is Ownable {

    event NewBookAdded(Book book);
    event NewCopyOfBookAdded(Book book);
    event BookBorrowed(Book book);
    event BookReturned(Book book);

    struct Book {
        string isbn;
        string name;
        string author;
        uint copies;
    }

    Book[] public books;

    function _addBook(string memory _isbn, string memory _name, string memory _author, uint _copies) private onlyOwner {
        uint numberOfBooks = books.length;

        bool isNewBook = false;

        if (numberOfBooks == 0) {
           isNewBook = true;
        }
        
        for (uint i = 0; i < numberOfBooks; i++) {
           Book storage book = books[i];
           if (keccak256(abi.encodePacked(book.isbn)) == keccak256(abi.encodePacked(_isbn))) {
               // book alreadey exists => inc number of copies
               book.copies++;
               emit NewCopyOfBookAdded(book);
           }
        }

        if (isNewBook) {
            _addNewBook(Book(_isbn, _name, _author, _copies));
        }
    }

    function _addNewBook(Book memory book) private {
        books.push(book);
        emit NewBookAdded(book);
    }

    function _borrowBook(string _isbn) private {
        uint numberOfBooks = books.length;
        
        for (uint i = 0; i < numberOfBooks; i++) {
           Book storage book = books[i];
           if (keccak256(abi.encodePacked(book.isbn)) == keccak256(abi.encodePacked(_isbn)) 
                && book.copies > 1)  {
               book.copies--;
               emit BookBorrowed(book);
           }
        }
    }

    function _returnBook(string _isbn) private {
        uint numberOfBooks = books.length;
        
        for (uint i = 0; i < numberOfBooks; i++) {
           Book storage book = books[i];
           if (keccak256(abi.encodePacked(book.isbn)) == keccak256(abi.encodePacked(_isbn)))  {
               book.copies++;
               emit BookReturned(book);
           }
        }
    }
}