// define your only data structure here, you may define dictionary, elements,
// etc...

// #define NULL ((void*)0)
// void *malloc(unsigned long size);
// void free(void *ptr);

#include <stdlib.h>

typedef struct Node {
    int key;
    int value;
    struct Node* prev;
    struct Node* next;
} Node;

typedef struct Dictionary {
    Node* head;  
    Node* tail;  
} Dictionary;

void *initializer() {
    Dictionary* dict = (Dictionary*)malloc(sizeof(Dictionary));
    dict->head = dict->tail = NULL;
    return dict;
}

void *search(void *dictionary, int key) {
    Dictionary* dict = (Dictionary*)dictionary;
    Node* cur = dict->head;
    while (cur && cur->key < key) {
        cur = cur->next;
    }
    if (cur && cur->key == key) return cur;
    return NULL;
}

void insert(void *dictionary, int key, int value) {
    Dictionary* dict = (Dictionary*)dictionary;
    Node* newNode = (Node*)malloc(sizeof(Node));

    newNode->key = key;
    newNode->value = value;
    newNode->prev = newNode->next = NULL;

    if (!dict->head) {  
        dict->head = dict->tail = newNode;
        return;
    }

    Node* cur = dict->head;
    while (cur && cur->key < key) {
        cur = cur->next;
    }

    if (!cur) {  
        dict->tail->next = newNode;
        newNode->prev = dict->tail;
        dict->tail = newNode;
    } else if (cur->key == key) {  
        cur->value = value;
        free(newNode);
    } else {  
        newNode->next = cur;
        newNode->prev = cur->prev;

        if (cur->prev) {
            cur->prev->next = newNode;
        } else { 
            dict->head = newNode;
        }

        cur->prev = newNode;
    }
}

void delete(void *dictionary, int key) {
    Dictionary* dict = (Dictionary*)dictionary;
    Node* target = (Node*)search(dict, key);
    if (!target) return;

    if (target->prev) {
        target->prev->next = target->next;
    } else {
        dict->head = target->next;
    }

    if (target->next) { 
        target->next->prev = target->prev;
    } else {
        dict->tail = target->prev;
    }

    free(target);
}

void *minimum(void *dictionary) {
    Dictionary* dict = (Dictionary*)dictionary;
    return dict->head;
}

void *maximum(void *dictionary) {
    Dictionary* dict = (Dictionary*)dictionary;
    return dict->tail;
}

void *predecessor(void *dictionary, int key) {
    Node* node = (Node*)search(dictionary, key);
    if (node) return node->prev;
    return NULL;
}

void *successor(void *dictionary, int key) {
    Node* node = (Node*)search(dictionary, key);
    if (node) return node->next;
    return NULL;
}

int getkey(void *element) { 
    Node* node = (Node*)element;
    return node->key;
}

int getvalue(void *element) {
    Node* node = (Node*)element;
    return node->value;
}

void free_dict(void *dictionary) {
    Dictionary* dict = (Dictionary*)dictionary;
    Node* cur = dict->head;

    while (cur) {
        Node* tmp = cur;
        cur = cur->next;
        free(tmp);
    }

    free(dict);
}
