package com.bookstore.model.book;

/**
 * Node class for book linked list implementation
 */
public class BookNode {
    private Book book;
    private BookNode next;
    private BookNode prev;

    /**
     * Constructor with Book object
     * @param book The book object
     */
    public BookNode(Book book) {
        this.book = book;
        this.next = null;
        this.prev = null;
    }

    /**
     * Get the book stored in this node
     * @return The book object
     */
    public Book getBook() {
        return book;
    }

    /**
     * Set the book stored in this node
     * @param book The book object to set
     */
    public void setBook(Book book) {
        this.book = book;
    }

    /**
     * Get the next node
     * @return The next BookNode
     */
    public BookNode getNext() {
        return next;
    }

    /**
     * Set the next node
     * @param next The BookNode to set as next
     */
    public void setNext(BookNode next) {
        this.next = next;
    }

    /**
     * Get the previous node
     * @return The previous BookNode
     */
    public BookNode getPrev() {
        return prev;
    }

    /**
     * Set the previous node
     * @param prev The BookNode to set as previous
     */
    public void setPrev(BookNode prev) {
        this.prev = prev;
    }

    /**
     * Return a string representation of this node
     * @return String representation
     */
    @Override
    public String toString() {
        return "BookNode{" +
                "book=" + book +
                '}';
    }
}