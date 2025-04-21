package com.bookstore.util;

import java.util.Comparator;

/**
 * Implementation of QuickSort algorithm for various data types
 */
public class QuickSort {

    /**
     * Sort an array of comparable objects
     * @param <T> the type of elements in the array (must implement Comparable)
     * @param arr the array to be sorted
     */
    public static <T extends Comparable<T>> void sort(T[] arr) {
        if (arr == null || arr.length == 0) {
            return;
        }
        quickSort(arr, 0, arr.length - 1, Comparator.naturalOrder());
    }

    /**
     * Sort an array of objects using the provided comparator
     * @param <T> the type of elements in the array
     * @param arr the array to be sorted
     * @param comparator the comparator to determine the order
     */
    public static <T> void sort(T[] arr, Comparator<? super T> comparator) {
        if (arr == null || arr.length == 0) {
            return;
        }
        quickSort(arr, 0, arr.length - 1, comparator);
    }

    /**
     * Private quickSort implementation
     * @param <T> the type of elements in the array
     * @param arr the array to be sorted
     * @param low the starting index
     * @param high the ending index
     * @param comparator the comparator to determine the order
     */
    private static <T> void quickSort(T[] arr, int low, int high, Comparator<? super T> comparator) {
        if (low < high) {
            // Get the pivot element from the middle of the array
            int middle = low + (high - low) / 2;
            T pivot = arr[middle];

            // Make left < pivot and right > pivot
            int i = low, j = high;
            while (i <= j) {
                // Find element on left that should be on right
                while (comparator.compare(arr[i], pivot) < 0) {
                    i++;
                }

                // Find element on right that should be on left
                while (comparator.compare(arr[j], pivot) > 0) {
                    j--;
                }

                // Swap elements and move left and right indices
                if (i <= j) {
                    swap(arr, i, j);
                    i++;
                    j--;
                }
            }

            // Recursively sort two sub parts
            if (low < j) {
                quickSort(arr, low, j, comparator);
            }

            if (high > i) {
                quickSort(arr, i, high, comparator);
            }
        }
    }

    /**
     * Swap two elements in an array
     * @param <T> the type of elements in the array
     * @param arr the array containing the elements
     * @param i the index of the first element
     * @param j the index of the second element
     */
    private static <T> void swap(T[] arr, int i, int j) {
        T temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    /**
     * Sort an array of integers
     * @param arr the array to be sorted
     */
    public static void sort(int[] arr) {
        if (arr == null || arr.length == 0) {
            return;
        }
        quickSortInt(arr, 0, arr.length - 1);
    }

    /**
     * Private quickSort implementation for integer arrays
     * @param arr the array to be sorted
     * @param low the starting index
     * @param high the ending index
     */
    private static void quickSortInt(int[] arr, int low, int high) {
        if (low < high) {
            // Get the pivot element from the middle of the array
            int middle = low + (high - low) / 2;
            int pivot = arr[middle];

            // Make left < pivot and right > pivot
            int i = low, j = high;
            while (i <= j) {
                // Find element on left that should be on right
                while (arr[i] < pivot) {
                    i++;
                }

                // Find element on right that should be on left
                while (arr[j] > pivot) {
                    j--;
                }

                // Swap elements and move left and right indices
                if (i <= j) {
                    int temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                    i++;
                    j--;
                }
            }

            // Recursively sort two sub parts
            if (low < j) {
                quickSortInt(arr, low, j);
            }

            if (high > i) {
                quickSortInt(arr, i, high);
            }
        }
    }

    /**
     * Sort an array of doubles
     * @param arr the array to be sorted
     */
    public static void sort(double[] arr) {
        if (arr == null || arr.length == 0) {
            return;
        }
        quickSortDouble(arr, 0, arr.length - 1);
    }

    /**
     * Private quickSort implementation for double arrays
     * @param arr the array to be sorted
     * @param low the starting index
     * @param high the ending index
     */
    private static void quickSortDouble(double[] arr, int low, int high) {
        if (low < high) {
            // Get the pivot element from the middle of the array
            int middle = low + (high - low) / 2;
            double pivot = arr[middle];

            // Make left < pivot and right > pivot
            int i = low, j = high;
            while (i <= j) {
                // Find element on left that should be on right
                while (arr[i] < pivot) {
                    i++;
                }

                // Find element on right that should be on left
                while (arr[j] > pivot) {
                    j--;
                }

                // Swap elements and move left and right indices
                if (i <= j) {
                    double temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                    i++;
                    j--;
                }
            }

            // Recursively sort two sub parts
            if (low < j) {
                quickSortDouble(arr, low, j);
            }

            if (high > i) {
                quickSortDouble(arr, i, high);
            }
        }
    }
}