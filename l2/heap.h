#ifndef HEAP_H
#define HEAP_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef int (*CompareFunc)(const void *a, const void *b);

typedef void *HeapData;

typedef struct {
    HeapData *nodes;
    int size;
    int capacity;
    size_t dataSize;
    CompareFunc compare;
} Heap;

/**
 * Create a new heap
 * @param capacity Initial capacity
 * @param dataSize Size of each data element in bytes
 * @param compare Comparison function for ordering, return negative if a < b, 0 if a == b, positive if a > b
 * @return Pointer to the created heap
 */
Heap *createHeap(int capacity, size_t dataSize, CompareFunc compare);

/**
 * Free the memory allocated for the heap
 */
void freeHeap(Heap *heap);

/**
 * Insert an element into the heap
 * @param heap Pointer to the heap
 * @param data Pointer to the data to insert
 */
void push(Heap *heap, void *data);

/**
 * Extract the minimum element
 * @param heap Pointer to the heap
 * @param out Pointer to store extracted data
 * @return 1 if succeed, 0 if heap is empty
 */
int pop(Heap *heap, void *out);

/**
 * Check if heap is empty
 */
int isEmpty(Heap *heap);

// Internal functions
void swapData(HeapData *a, HeapData *b);
void heapifyUp(Heap *heap, int index);
void heapifyDown(Heap *heap, int index);

// Implementation
Heap *createHeap(int capacity, size_t dataSize, CompareFunc compare) {
    Heap *heap = (Heap *)malloc(sizeof(Heap));
    heap->nodes = (HeapData *)malloc((size_t)capacity * sizeof(HeapData));
    heap->size = 0;
    heap->capacity = capacity;
    heap->dataSize = dataSize;
    heap->compare = compare;

    for (int i = 0; i < capacity; i++) {
        heap->nodes[i] = NULL;
    }

    return heap;
}

void freeHeap(Heap *heap) {
    if (heap != NULL) {
        for (int i = 0; i < heap->size; i++) {
            if (heap->nodes[i]) {
                free(heap->nodes[i]);
            }
        }
        free((void *)heap->nodes);
        free(heap);
    }
}

void swapData(HeapData *a, HeapData *b) {
    HeapData temp = *a;
    *a = *b;
    *b = temp;
}

void heapifyUp(Heap *heap, int index) {
    while (index > 0) {
        int parent = (index - 1) / 2;

        if (heap->compare(heap->nodes[index], heap->nodes[parent]) >= 0) {
            break;
        }

        swapData(&heap->nodes[index], &heap->nodes[parent]);
        index = parent;
    }
}

void heapifyDown(Heap *heap, int index) {
    int smallest = index;
    int left = 2 * index + 1;
    int right = 2 * index + 2;

    if (left < heap->size &&
        heap->compare(heap->nodes[left], heap->nodes[smallest]) < 0) {
        smallest = left;
    }

    if (right < heap->size &&
        heap->compare(heap->nodes[right], heap->nodes[smallest]) < 0) {
        smallest = right;
    }

    if (smallest != index) {
        swapData(&heap->nodes[index], &heap->nodes[smallest]);
        heapifyDown(heap, smallest);
    }
}

void push(Heap *heap, void *data) {
    if (heap->size >= heap->capacity) {
        int oldCapacity = heap->capacity;
        heap->capacity *= 2;
        HeapData *newNodes = (HeapData *)realloc((void *)heap->nodes,
                                                 (size_t)heap->capacity * sizeof(HeapData));

        if (newNodes == NULL) {
            heap->capacity = oldCapacity;
            return;
        }

        heap->nodes = newNodes;

        for (int i = oldCapacity; i < heap->capacity; i++) {
            heap->nodes[i] = NULL;
        }
    }

    heap->nodes[heap->size] = malloc(heap->dataSize);
    memcpy(heap->nodes[heap->size], data, heap->dataSize);

    heapifyUp(heap, heap->size);
    heap->size++;
}

int pop(Heap *heap, void *out) {
    if (heap->size == 0) {
        return 0;
    }

    memcpy(out, heap->nodes[0], heap->dataSize);

    free(heap->nodes[0]);

    heap->nodes[0] = heap->nodes[heap->size - 1];
    heap->nodes[heap->size - 1] = NULL;
    heap->size--;

    if (heap->size > 0) {
        heapifyDown(heap, 0);
    }

    return 1;
}

int isEmpty(Heap *heap) {
    return heap->size == 0 ? 1 : 0;
}

#endif // HEAP_H