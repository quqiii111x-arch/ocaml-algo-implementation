# Lab 4.1 Programming

## Prob#1

In OCaml:

- **Modules** are the primary way to encapsulate data and functions.
  - They allow static type checking and efficient compilation.
  - Functional programming fits naturally with modules.
- **Classes** exist since OCaml has object-oriented features:
  - They are less efficient and may lead to performance loss due to runtime dispatch.
  - Functional code is usually preferred to take advantage of the feature of OCaml.

**Good setup for classes**:
- Define a class type to describe the interface.
- Implement concrete classes and maintain encapsulation.
- Use mutable state only when necessary.
- Combine classes and modules.

## Prob#3

| Operation      | Time Complexity             |
|----------------|-----------------------------|
| `MakeHeap`     | O(1)                        |
| `Insert`       | O(1)                        |
| `Minimum`      | O(1)                        |
| `ExtractMin`   | O(log n)                     |
| `Union`        | O(1)                        |
| `DecreaseKey`  | O(1)                        |
| `Delete`       | O(log n)                     |


## Prob#4

Fibonacci heap:

**Advantages:**
- Amortized O(1) insert and decrease-key.
- Useful for graph algorithms (like Dijkstra) with convenient decrease-key operations.
- Efficient union operation.

**Disadvantages:**
- More complex to implement.
- Larger constant factors and memory usage.
- Slower in practice for small heaps.

Min-heap:

- Min-heap has O(log n) insert/decrease-key.
- Simple and fast for small heaps or few decrease-key operations.

## Prob#5

- Fibonacci heap shouold be used when a large amount of `decrease-key` or `union` operations are needed.
- Example: Dijkstra's algorithm on sparse graphs with many vertices.
- It's not recommended for small heaps or heaps with few decrease-key operations.


# Lab 4.2 Interview Problems

## Prob#1
Given an array `A` of size `n`, split it into as few subarrays as possible such that in each subarray, the GCD of its first and last elements is greater than 1.

### Solution 
1. Initialize `start = 0`.
2. From `start`, try to extend the subarray to `end` as much as possible such that `gcd(A[start], A[end]) > 1`.
3. Once `gcd(A[start], A[end+1]) == 1` or the end of the array is reached, record this subarray.
4. Move `start = end + 1` and repeat until the entire array is processed.

Time Complexity: $O(N^2)$ in the worst case.

## Prob#2
Write a short program allowing to expand a binary tree into a linked list with all elements in
increasing order.

### Solution
1. Perform an in-order traversal of the BST to obtain the nodes in increasing order.
2. Create linked list nodes during traversal and connect them in order.

```cpp

#include <iostream>

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

struct ListNode {
    int val;
    ListNode* next;
    ListNode(int x) : val(x), next(nullptr) {}
};


void inorder(TreeNode* root, ListNode*& current) {
    if (!root) return;
    inorder(root->left, current);
    current->next = new ListNode(root->val);
    current = current->next;
    inorder(root->right, current);
}

ListNode* bstToLinkedList(TreeNode* root) {
    ListNode dummy(0);
    ListNode* current = &dummy;
    inorder(root, current);
    return dummy.next;
}


```