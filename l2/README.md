# Lab 2.1: Kruskal and Prim's algorithm


## Description
Implement Kruskal and Prim's algorithm for solving the minimum spanning tree. First determine the characteristics of the input graph, and then decide which corresponding algorithm to use.

We provide a sample heap implementation for you in `heap.h`. You can use it in your code.

### Input
number of edges    $eSize$ on the first line

number of vertexes $vSize$ on the second line

an edge in the form "$v1$ $v2$ $w$" on the following $eSize$ line

$v1$ and $v2$ are the indexes (start at 0) of the two vertexes of the edge

$w$ is the weight of the edge

### Output
All the edges in the resulting minimum spanning tree

Print all the edges in the format

"$v1$--$v2$"

$v1$ and $v2$ are the indexes of the two vertexes of the edge, $v1$ < $v2$

Print all edges in the increasing order of $v1$, for two edges "$v1$ $v2$" and

"$v1$ $v3$" with $v2$ < $v3$, print "$v1$ $v2$" first.
## Sample 1

### Input
```
5
4
0 1 1
1 2 2
2 3 3
3 0 2
0 2 5
```

### Output
```
0--1
0--3
1--2
```


# Lab 2.2: Quick-sort in Ocaml


## Description
Implement Quick-sort in OCaml.

We will use the following command to compile your source file.
```
ocamlopt -o quicksort quicksort.ml
```


### Input
Nonnegative integers in one line, splitted by ','.

### Output
Sorted numbers.

### Sample IO
#### Input
```
104, 280, 444, 102, 18
```
#### Output
```
18 102 104 280 444
```



# Lab 2.1 C programming
## Questions & Answers
### Q: Consider the complexity of Kruskal and Prim algorithms, then compare how they perform in practice.
- Kruskal runs in $O(E \log V)$, good for sparse graphs, and is simple to implement with Union-Find.
- Prim runs in $O(V^2)$ with adjacency matrix, $O(E \log V)$ with binary heap, and $O(E + V \log V)$ with Fibonacci heap, making it better for dense graphs.
- Kruskal is preferred for sparse graphs, while Prim is usually faster for dense graphs.



# Lab 2.2.1 Getting acquainted with OCaml
## Questions & Answers

### Q1: How to define an anonymous function in OCaml? When to define and use anonymous functions?
- Anonymous functions are usually used when the function is short-lived and only needed locally
    ```ocaml
    let square = fun x -> x * x
    ```

### Q2: How should variables and functions be named?  
- start with a lowercase letter.
- Use underscores to separate words.

### Q3: What is a module? How does it differ from an class in OOP?
- A module in OCaml is a collection of related definitions.
- In OOP, a class defines objects with data and behavior. In OCaml, modules do not carry runtime state.

### Q4: Life without arrays is not simple. How can `Lists` help?
- Lists are the fundamental sequence type in OCaml.
- They are immutable and allow easy recursion, pattern matching, and higher-order operations

### Q5: What are maps and iterators? How to best use them?
- `map` applies a function to every element of a list and returns a new list
- `iter` applies a function to every element and returns `unit`.
    ```ocaml
    List.map (fun x -> x * 2) [1;2;3]   (* returns [2;4;6] *)
    List.iter print_int [1;2;3]        (* prints 123, returns () *)
    ```

### Q6: Foldings are very powerful features. Explain why and provide a simple example different from the ones in the documentation.
- `fold_left` and `fold_right` generalize iteration and accumulation.
- They are used to replace loops with recursion safely.
    ```ocaml
    List.fold_left (fun acc s -> acc ^ s) "" ["a"; "b"; "c"] (* result: "abc" *)
    ```

### Q7.1: What is tail recursion? Why is it an important point in functional programming?
- Tail recursion is a recursive function whose recursive call is the last operation in the function.
- It avoids growing the call stack and improves efficiency.

### Q7.2: What is Continuation Passing Style (CPS)? Explain how it relates to tail recursion and why it is very important in functional programming.    
- CPS is a style where functions receive an extra argument, the continuation, representing "what to do next". It transforms recursion into tail recursion and makes control flow explicit.

### Q8: What does `ref` mean, and when to use this keyword?
- ref creates a mutable reference cell.
- Used when mutation is necessary in an otherwise immutable language.

### Q9: What are functors, how do they relate and differ from templates in C++?
- A functor is a module parameterized by another module.
- It allows generic code reuse at the module level and is similar to C++ templates. But functors are applied explicitly, while templates are expanded by the compiler.

### Q10: How to define new types?
- Use `type` keyword.
    ```ocaml
    type color = Red | Green | Blue
    ```

### Q11: What are sum and product types? How do they help improving coding quality?
- Sum types are types that can take one of several options.
- Product types combine multiple values together. 
- They help ensure correctness by making illegal states unrepresentable.



# Lab 2.3 Interview problems
## Problems & Answers
### Prob1
How to determine the square root of a number $n$, accurate to five decimal places? Do not use any packages like numpy or headers like `math.h`.
### Answer
- Newton-Raphson method: 
$$
x_{i+1} = \frac{1}{2} \left( x_i + \frac{C}{x_i} \right)
$$
- Start with an initial guess $x_0 = C$.
- Updating until the accuracy is reached.

### Prob2
Find the longest substring without duplication. Each character should appear only once in this substring.
### Answer
- Sliding Window: Use two pointers to represent the start and the end of the substring respectively. Move the end pointer until a duplicate character is found before moving the start pointer one by one. Keep updating the maximum length throughout the process.

```cpp
    int lengthOfLongestSubstring(string s) {
        int length = s.size();
        unordered_set<char> hashTable;

        int right = 0;
        int maxLength = 0;

        for (int i=0; i<length; i++) {
            if (i > 0) {
                hashTable.erase(s[i-1]);
            }
            
            while (right < length && hashTable.find(s[right]) == hashTable.end()) {
                hashTable.insert(s[right]);
                ++right;
            }

            maxLength = max(right-i, maxLength);
        }

        return maxLength;
    }
```