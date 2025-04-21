package com.bookstore.model.user;

/**
 * Custom LinkedList implementation for User objects
 */
public class UserLinkedList {

    // Node class for linked list
    private class UserNode {
        private User user;
        private UserNode next;
        private UserNode prev;

        public UserNode(User user) {
            this.user = user;
            this.next = null;
            this.prev = null;
        }
    }

    private UserNode head;
    private UserNode tail;
    private int size;

    // Constructor
    public UserLinkedList() {
        this.head = null;
        this.tail = null;
        this.size = 0;
    }

    // Add a user to the end of the list
    public void add(User user) {
        UserNode newNode = new UserNode(user);

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

    // Insert a user at a specific position
    public void insert(int index, User user) {
        if (index < 0 || index > size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        if (index == 0) {
            // Insert at the beginning
            UserNode newNode = new UserNode(user);
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
            add(user);
        } else {
            // Insert in the middle
            UserNode current = getNodeAt(index);
            UserNode newNode = new UserNode(user);

            newNode.next = current;
            newNode.prev = current.prev;
            current.prev.next = newNode;
            current.prev = newNode;

            size++;
        }
    }

    // Get user at specific position
    public User get(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        return getNodeAt(index).user;
    }

    // Helper method to get node at specific position
    private UserNode getNodeAt(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        UserNode current;
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

    // Remove user at specific position
    public User remove(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        UserNode toRemove;

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
        return toRemove.user;
    }

    // Remove a specific user
    public boolean remove(User user) {
        UserNode current = head;

        while (current != null) {
            if (current.user.getUserId().equals(user.getUserId())) {
                if (current == head) {
                    // Remove from the beginning
                    head = head.next;
                    if (head != null) {
                        head.prev = null;
                    } else {
                        // List is now empty
                        tail = null;
                    }
                } else if (current == tail) {
                    // Remove from the end
                    tail = tail.prev;
                    tail.next = null;
                } else {
                    // Remove from the middle
                    current.prev.next = current.next;
                    current.next.prev = current.prev;
                }

                size--;
                return true;
            }

            current = current.next;
        }

        return false; // User not found
    }

    // Update a user
    public boolean update(User updatedUser) {
        UserNode current = head;

        while (current != null) {
            if (current.user.getUserId().equals(updatedUser.getUserId())) {
                current.user = updatedUser;
                return true;
            }

            current = current.next;
        }

        return false; // User not found
    }

    // Find a user by ID
    public User findById(String userId) {
        UserNode current = head;

        while (current != null) {
            if (current.user.getUserId().equals(userId)) {
                return current.user;
            }
            current = current.next;
        }

        return null; // User not found
    }

    // Find a user by username
    public User findByUsername(String username) {
        UserNode current = head;

        while (current != null) {
            if (current.user.getUsername().equals(username)) {
                return current.user;
            }
            current = current.next;
        }

        return null; // User not found
    }

    // Check if a username already exists
    public boolean usernameExists(String username) {
        return findByUsername(username) != null;
    }

    // Convert the linked list to an array
    public User[] toArray() {
        User[] array = new User[size];
        UserNode current = head;

        for (int i = 0; i < size; i++) {
            array[i] = current.user;
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
}