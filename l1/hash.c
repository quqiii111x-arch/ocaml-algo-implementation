// define your only data structure here, you may define hashtable, buckets,
// elements, etc...
#include <stdlib.h>

typedef struct Node {
    int key;
    int value;
    struct Node* next;
} Node;

typedef struct HashTable {
    Node** buckets; 
    int size;       
} HashTable;

void *initializer(int size) {
    HashTable* hashTable = (HashTable*)malloc(sizeof(HashTable));
    hashTable->size = size;
    hashTable->buckets = (Node**)malloc((size_t)size * sizeof(Node*));
    for (int i = 0; i < size; i++) {
        hashTable->buckets[i] = NULL;
    }
    return hashTable;
}

void insert(void *hashtable, int size, int key, int value) {
    HashTable* hashTable = (HashTable*)hashtable;
    int index = key % size;
    Node* cur = hashTable->buckets[index];

    while (cur) {
        if (cur->key == key) {
            cur->value = value;
            return;
        }
        cur = cur->next;
    }

    Node* newNode = (Node*)malloc(sizeof(Node));
    newNode->key = key;
    newNode->value = value;
    newNode->next = hashTable->buckets[index];
    hashTable->buckets[index] = newNode;
}

void delete(void *hashtable, int size, int key) {
    HashTable* hashTable = (HashTable*)hashtable;
    int index = key % size;
    Node* cur = hashTable->buckets[index];
    Node* prev = NULL;

    while (cur) {
        if (cur->key == key) {
            if (!prev) {
                hashTable->buckets[index] = cur->next;
            } else {
                prev->next = cur->next;
            }
            free(cur);
            return;
        }
        prev = cur;
        cur = cur->next;
    }

    return;
}

void *search(void *hashtable, int size, int key) {
    HashTable* hashTable = (HashTable*)hashtable;
    int index = key % size;
    Node* cur = hashTable->buckets[index];

    while (cur) {
        if (cur->key == key) return cur;
        cur = cur->next;
    }

    return NULL;
}

int getValue(void *element) {
    Node* node = (Node*)element;
    return node->value;
}

void freeHashtable(void *hashtable, int size) {
    HashTable* hashTable = (HashTable*)hashtable;

    for (int i = 0; i < size; i++) {
        Node* cur = hashTable->buckets[i];
        while (cur) {
            Node* tempt = cur;
            cur = cur->next;
            free(tempt);
        }
    }

    free(hashTable->buckets);
    free(hashTable);
}
