package com.bookstore.model.book;

/**
 * Custom linked list implementation specifically for Book objects
 */
public class BookLinkedList {
    private BookNode head;
    private BookNode tail;
    private int size;

    /**
     * Default constructor
     */
    public BookLinkedList() {
        this.head = null;
        this.tail = null;
        this.size = 0;
    }

    /**
     * Add a book to the end of the list
     * @param book The book to add
     */
    public void add(Book book) {
        BookNode newNode = new BookNode(book);

        if (head == null) {
            // List is empty
            head = newNode;
            tail = newNode;
        } else {
            // Add to the end
            tail.setNext(newNode);
            newNode.setPrev(tail);
            tail = newNode;
        }

        size++;
    }

    /**
     * Insert a book at a specific position
     * @param index The position to insert at
     * @param book The book to insert
     */
    public void insert(int index, Book book) {
        if (index < 0 || index > size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        if (index == 0) {
            // Insert at the beginning
            BookNode newNode = new BookNode(book);
            newNode.setNext(head);

            if (head != null) {
                head.setPrev(newNode);
            } else {
                // List was empty
                tail = newNode;
            }

            head = newNode;
            size++;
        } else if (index == size) {
            // Insert at the end (same as add)
            add(book);
        } else {
            // Insert in the middle
            BookNode current = getNodeAt(index);
            BookNode newNode = new BookNode(book);

            newNode.setNext(current);
            newNode.setPrev(current.getPrev());
            current.getPrev().setNext(newNode);
            current.setPrev(newNode);

            size++;
        }
    }

    /**
     * Get book at specific position
     * @param index The position
     * @return The book at the specified position
     */
    public Book get(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        return getNodeAt(index).getBook();
    }

    /**
     * Helper method to get node at specific position
     * @param index The position
     * @return The BookNode at the specified position
     */
    private BookNode getNodeAt(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        BookNode current;
        if (index < size / 2) {
            // Traverse from head
            current = head;
            for (int i = 0; i < index; i++) {
                current = current.getNext();
            }
        } else {
            // Traverse from tail
            current = tail;
            for (int i = size - 1; i > index; i--) {
                current = current.getPrev();
            }
        }

        return current;
    }

    /**
     * Remove book at specific position
     * @param index The position
     * @return The removed book
     */
    public Book remove(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        BookNode toRemove;

        if (index == 0) {
            // Remove from the beginning
            toRemove = head;
            head = head.getNext();

            if (head != null) {
                head.setPrev(null);
            } else {
                // List is now empty
                tail = null;
            }
        } else if (index == size - 1) {
            // Remove from the end
            toRemove = tail;
            tail = tail.getPrev();
            tail.setNext(null);
        } else {
            // Remove from the middle
            toRemove = getNodeAt(index);
            toRemove.getPrev().setNext(toRemove.getNext());
            toRemove.getNext().setPrev(toRemove.getPrev());
        }

        size--;
        return toRemove.getBook();
    }

    /**
     * Remove a specific book
     * @param book The book to remove
     * @return True if book was found and removed, false otherwise
     */
    public boolean remove(Book book) {
        BookNode current = head;

        while (current != null) {
            if ((current.getBook() == null && book == null) ||
                    (current.getBook() != null && current.getBook().equals(book))) {

                if (current == head) {
                    // Remove from the beginning
                    head = head.getNext();
                    if (head != null) {
                        head.setPrev(null);
                    } else {
                        // List is now empty
                        tail = null;
                    }
                } else if (current == tail) {
                    // Remove from the end
                    tail = tail.getPrev();
                    tail.setNext(null);
                } else {
                    // Remove from the middle
                    current.getPrev().setNext(current.getNext());
                    current.getNext().setPrev(current.getPrev());
                }

                size--;
                return true;
            }

            current = current.getNext();
        }

        return false; // Book not found
    }

    /**
     * Find a book by ID
     * @param id The book ID to search for
     * @return The book with the matching ID, or null if not found
     */
    public Book findById(String id) {
        BookNode current = head;

        while (current != null) {
            Book book = current.getBook();
            if (book != null && book.getId().equals(id)) {
                return book;
            }
            current = current.getNext();
        }

        return null; // Book not found
    }

    /**
     * Find books by title (partial match, case insensitive)
     * @param title The title to search for
     * @return Array of books with matching titles
     */
    public Book[] findByTitle(String title) {
        if (title == null) {
            return new Book[0];
        }

        // First, count matching books
        int count = 0;
        BookNode current = head;

        while (current != null) {
            Book book = current.getBook();
            if (book != null && book.getTitle() != null &&
                    book.getTitle().toLowerCase().contains(title.toLowerCase())) {
                count++;
            }
            current = current.getNext();
        }

        // Create result array
        Book[] result = new Book[count];

        // Fill result array
        if (count > 0) {
            current = head;
            int index = 0;

            while (current != null) {
                Book book = current.getBook();
                if (book != null && book.getTitle() != null &&
                        book.getTitle().toLowerCase().contains(title.toLowerCase())) {
                    result[index++] = book;
                }
                current = current.getNext();
            }
        }

        return result;
    }

    /**
     * Find books by author (partial match, case insensitive)
     * @param author The author to search for
     * @return Array of books by the matching author
     */
    public Book[] findByAuthor(String author) {
        if (author == null) {
            return new Book[0];
        }

        // First, count matching books
        int count = 0;
        BookNode current = head;

        while (current != null) {
            Book book = current.getBook();
            if (book != null && book.getAuthor() != null &&
                    book.getAuthor().toLowerCase().contains(author.toLowerCase())) {
                count++;
            }
            current = current.getNext();
        }

        // Create result array
        Book[] result = new Book[count];

        // Fill result array
        if (count > 0) {
            current = head;
            int index = 0;

            while (current != null) {
                Book book = current.getBook();
                if (book != null && book.getAuthor() != null &&
                        book.getAuthor().toLowerCase().contains(author.toLowerCase())) {
                    result[index++] = book;
                }
                current = current.getNext();
            }
        }

        return result;
    }

    /**
     * Convert the linked list to an array
     * @return Array of books
     */
    public Book[] toArray() {
        Book[] array = new Book[size];
        BookNode current = head;

        for (int i = 0; i < size; i++) {
            array[i] = current.getBook();
            current = current.getNext();
        }

        return array;
    }

    /**
     * Get the size of the list
     * @return The number of books in the list
     */
    public int size() {
        return size;
    }

    /**
     * Check if the list is empty
     * @return True if the list is empty, false otherwise
     */
    public boolean isEmpty() {
        return size == 0;
    }

    /**
     * Clear the list
     */
    public void clear() {
        head = null;
        tail = null;
        size = 0;
    }

    /**
     * Return a string representation of the list
     */
    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder("[");
        BookNode current = head;

        while (current != null) {
            builder.append(current.getBook());
            if (current.getNext() != null) {
                builder.append(", ");
            }
            current = current.getNext();
        }

        builder.append("]");
        return builder.toString();
    }
}