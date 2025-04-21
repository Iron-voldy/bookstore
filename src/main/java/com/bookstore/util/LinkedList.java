package com.bookstore.util;

/**
 * Generic LinkedList implementation for the bookstore application
 * @param <T> the type of elements in the list
 */
public class LinkedList<T> {

    // Node class for linked list
    private class Node {
        private T data;
        private Node next;
        private Node prev;

        public Node(T data) {
            this.data = data;
            this.next = null;
            this.prev = null;
        }
    }

    private Node head;
    private Node tail;
    private int size;

    // Constructor
    public LinkedList() {
        this.head = null;
        this.tail = null;
        this.size = 0;
    }

    // Add an element to the end of the list
    public void add(T data) {
        Node newNode = new Node(data);

        if (head == null) {
            // List is empty
            head = newNode;
            tail = newNode;
        } else {
            // Add to the end
            tail.next = newNode;
            newNode.prev = tail;
            tail = newNode;
        }

        size++;
    }

    // Insert an element at a specific position
    public void insert(int index, T data) {
        if (index < 0 || index > size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        if (index == 0) {
            // Insert at the beginning
            Node newNode = new Node(data);
            newNode.next = head;

            if (head != null) {
                head.prev = newNode;
            } else {
                // List was empty
                tail = newNode;
            }

            head = newNode;
            size++;
        } else if (index == size) {
            // Insert at the end (same as add)
            add(data);
        } else {
            // Insert in the middle
            Node current = getNodeAt(index);
            Node newNode = new Node(data);

            newNode.next = current;
            newNode.prev = current.prev;
            current.prev.next = newNode;
            current.prev = newNode;

            size++;
        }
    }

    // Get data at specific position
    public T get(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        return getNodeAt(index).data;
    }

    // Helper method to get node at specific position
    private Node getNodeAt(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        Node current;
        if (index < size / 2) {
            // Traverse from head
            current = head;
            for (int i = 0; i < index; i++) {
                current = current.next;
            }
        } else {
            // Traverse from tail
            current = tail;
            for (int i = size - 1; i > index; i--) {
                current = current.prev;
            }
        }

        return current;
    }

    // Remove element at specific position
    public T remove(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        Node toRemove;

        if (index == 0) {
            // Remove from the beginning
            toRemove = head;
            head = head.next;

            if (head != null) {
                head.prev = null;
            } else {
                // List is now empty
                tail = null;
            }
        } else if (index == size - 1) {
            // Remove from the end
            toRemove = tail;
            tail = tail.prev;
            tail.next = null;
        } else {
            // Remove from the middle
            toRemove = getNodeAt(index);
            toRemove.prev.next = toRemove.next;
            toRemove.next.prev = toRemove.prev;
        }

        size--;
        return toRemove.data;
    }

    // Remove a specific element
    public boolean remove(T data) {
        if (data == null) {
            // Handle null data
            Node current = head;
            while (current != null) {
                if (current.data == null) {
                    if (current == head) {
                        head = head.next;
                        if (head != null) {
                            head.prev = null;
                        } else {
                            tail = null;
                        }
                    } else if (current == tail) {
                        tail = tail.prev;
                        tail.next = null;
                    } else {
                        current.prev.next = current.next;
                        current.next.prev = current.prev;
                    }
                    size--;
                    return true;
                }
                current = current.next;
            }
        } else {
            // Handle non-null data
            Node current = head;
            while (current != null) {
                if (data.equals(current.data)) {
                    if (current == head) {
                        head = head.next;
                        if (head != null) {
                            head.prev = null;
                        } else {
                            tail = null;
                        }
                    } else if (current == tail) {
                        tail = tail.prev;
                        tail.next = null;
                    } else {
                        current.prev.next = current.next;
                        current.next.prev = current.prev;
                    }
                    size--;
                    return true;
                }
                current = current.next;
            }
        }
        return false; // Element not found
    }

    // Check if element exists
    public boolean contains(T data) {
        if (data == null) {
            // Search for null data
            Node current = head;
            while (current != null) {
                if (current.data == null) {
                    return true;
                }
                current = current.next;
            }
        } else {
            // Search for non-null data
            Node current = head;
            while (current != null) {
                if (data.equals(current.data)) {
                    return true;
                }
                current = current.next;
            }
        }
        return false; // Element not found
    }

    // Find index of element
    public int indexOf(T data) {
        int index = 0;
        if (data == null) {
            // Search for null data
            Node current = head;
            while (current != null) {
                if (current.data == null) {
                    return index;
                }
                current = current.next;
                index++;
            }
        } else {
            // Search for non-null data
            Node current = head;
            while (current != null) {
                if (data.equals(current.data)) {
                    return index;
                }
                current = current.next;
                index++;
            }
        }
        return -1; // Element not found
    }

    // Set element at specific position
    public T set(int index, T data) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        Node current = getNodeAt(index);
        T oldData = current.data;
        current.data = data;
        return oldData;
    }

    // Convert the linked list to an array
    public Object[] toArray() {
        Object[] array = new Object[size];
        Node current = head;

        for (int i = 0; i < size; i++) {
            array[i] = current.data;
            current = current.next;
        }

        return array;
    }

    // Get the size of the list
    public int size() {
        return size;
    }

    // Check if the list is empty
    public boolean isEmpty() {
        return size == 0;
    }

    // Clear the list
    public void clear() {
        head = null;
        tail = null;
        size = 0;
    }

    // Find first element matching predicate
    public interface Predicate<T> {
        boolean test(T data);
    }

    public T find(Predicate<T> predicate) {
        Node current = head;
        while (current != null) {
            if (predicate.test(current.data)) {
                return current.data;
            }
            current = current.next;
        }
        return null; // No matching element found
    }

    // Return a string representation of the list
    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder("[");
        Node current = head;

        while (current != null) {
            builder.append(current.data);
            if (current.next != null) {
                builder.append(", ");
            }
            current = current.next;
        }

        builder.append("]");
        return builder.toString();
    }
}