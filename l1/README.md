# Lab 1.1.1 Dictionary with sorted double link lists

The starter files are in `./dict/`

## Description
Implement the seven basic operations of dictionary using sorted double link lists. The seven basic operations are `search insert delete maximum minimum successor predecessor`. Besides, we will require you to implement some easy extra functions in order to test your code.

### Header file
In order to test your code, we have specified the interface of your implemetation in `dictionary.h`.

## Submission
### Requirement
You should implement the function according to the complexity stated in `Dictionary using linked structures` (Page 22 of c1.pdf).

## Testing
### Test Program
We will test your dictionary with a testing program. You don't need to consider too much about it, only for a reference. The testing program is in `dict_test.c` 

### IO format
#### Input
the number of operations $n$ on the first line.
an operation on the next $n$ lines

#### Output
the ordered dictionary at that time.
try the test program yourselves to get the output

### Sample IO

#### Input
```
1
insert 0 0
```

#### Output
```
0
***Print Dictionary***
Original: {0:0, }.
Reversed: {0:0, }.
****Print Finished****

```
# Lab 1.1.2 Hash table
## Description
Implement basic operations for hash table, which are `search insert delete`. Besides, we will require you to implement some easy extra functions to create and free your hash table. 

### Header file
In order to test your code, we have specified the interface of your implemetation in `hash.h`

## Submission
### Requirement
You are required to implement the hash table with **separate chaining**. 

### Files
You should submit a tar or zip file containing a c source file named as `hash.c`.

## Testing
### Test Program
We will test your hash table with a testing program. You don't need to consider too much about it, only for a reference. The testing program is in `hash-test.c`

### IO format
#### Input
the number of bucket $size$ on the first line
the number of operations $n$ on the first line.
an operation on the next $n$ lines

#### Output
the searching results
detailed output can be found by testing it yourself

### Sample IO

#### Input
```
7
5
insert 15 11
delete 23
search 22
search 15
insert 21 24
```

#### Output
```
0
***End***
1
***End***
2
***End***
3
The value is 11.
***End***
4
***End***

```

# Lab 1.2 Functional programming
## Questions & Answers
### Q1: What are imperative and object-oriented languages? Give examples.
- Imperative languages use a series of instructions to control the computer.  
  Examples: C, Fortran.  
- Object-oriented languages organize code around objects that combine data and behavior.  
  Examples: Java, C#, Python.

### Q2: Functional programming:
- A programming paradigm that uses mathematical evaluation for programming.


### Q4: What does it mean for a function to be a first-class citizen?
- A function is a first-class citizen if it can be treated like other variables:  
  assigned to variables, passed as arguments, stored in data structures and returned as results.

### Q5: What is a higher-order function?
- A **higher-order function** is a function that either:  
  1. Takes one or more functions as arguments, or  
  2. Returns a function as its result.  

### Q6: Using basic mathematics show that integration defines a linear map. How does it relate to higher order functions?
- For functions \( f(x) \) and \( g(x) \), and constants \( a, b \):  
  \[
  \int (a f(x) + b g(x)) dx = a \int f(x) dx + b \int g(x) dx
  \]
- The integration preserves linear combinations, so it defines a linear map.

- In programming terms, integration is similar to a higher-order function, since it takes a function (the integrand) as input and returns a value or another function (the integral).

### Q7: What does it mean for a variable to be immutable?
- An immutable variable is a variable whose state cannot be changed after it has been assigned.

### Q8: What are the pros and cons of dealing with immutable variables?
- Pros:
  - Makes programs easier to reason about, and simplifies debugging and testing.
  - Safer for concurrency and parallel programming.
- Cons:
  - May require creating many new objects instead of updating existing ones, so its harder to build cyclic data structures.
  - Can lead to higher memory usage and poor performance.

### Q9: What is a pure function or a function with no side-effects?
- A pure function is a function that:
  1. Produces the same output for the same input. 
  2. Doesn't cause side-effects.
- A function with no side-effects means the function does not:
  1. Modify global or external variables.
  2. Perform I/O operations.


# Lab 1.3 Getting started with OCaml
## Questions & Answers

### Q1: What is the meaning of REPL?
- Read-Eval-Print Loop.  
- It is an interactive programming environment where the user can type expressions before the system evaluates and prints the result.

### Q2: Is OCaml an interpreted or a compiled language?
- OCaml has two compilers and supports both.

### Q3: Which is "faster", C or OCaml?
- In general, C is faster because it is closer to the hardware and more optimized for low-level control.

### Q4: What is the `let` keyword used for?
- The `let` keyword is used to bind values to names (variables or functions).  

### Q5: What are the basic types in OCaml?
- Integers, Floats, Booleans, Characters, Strings.

### Q6: What is type inference?
- Type inference means the compiler can automatically deduce the type of an expression without explicit annotations. 

### Q7: What is the meaning of `f : int -> int -> float`?
- A function `f` that takes two `int` arguments and returns a `float`.  
- Equals to `f : int -> (int -> float)`

### Q8: What is the "NULL reference problem"? How does the keyword `option` help in OCaml?
- In many languages, using variables referred to `NULL` may lead to runtime errors.  
- OCaml uses the `option type` to represent values that may or may not exist.
  - `Some value` means a value is present.  
  - `None` means no value.  
- When programming, none case won't be accidentally ignored.

### Q9: What is the difference between statically and dynamically typed languages? Which category does OCaml belong to?
- Statically typed: Types are checked at compile time.  
- Dynamically typed: Types are checked at runtime.  
- OCaml is statically typed.

### Q10: What is pattern matching. Provide a simple OCaml example different from the one in the tutorial.
- Pattern matching allows checking the structure of data and deconstructing it.  
- Example:  
  ```ocaml
  let describe_number n =
    match number with
    | 0 -> "zero"
    | 1 -> "one"
    | _ -> "many"
    
  ```  

### Q11: How does pattern matching increase type safety?
- Pattern matching hints considering all possible cases. So it prevents runtime errors caused by unhandled situations.


# Lab 1.4 Interview problems
## Problems & Answers
### Prob1
Given a set of integers, design an algorithm which finds all the subsets composed of three elements
summing up to 0. Analyze its time and space complexity.
### Answer
- Sorting + Double Pointer: Sort the given integers, then iterate over all the integers as the first element of the subarrays. In the loop, iterate over the sum of the second and third elements.
- Time complexity: $O(N^2)$
  - The first loop iterates over all elements. And in the second loop, due to the fixed sum of element 2 and 3, both pointers move simultaneously, thus traversing a total of n elements.
  - Time complexity of sorting is $O(N \log N)$ is covered.
- Space Complexity: $O(N)$ or $O(\log N)$ Affected by the sorting method.  

### Prob2
Given a sorted linked list, describe a strategy to delete all nodes featuring duplicate numbers. The result
should be a linked list only composed of nodes featuring distinct numbers.
### Answer
- Set two pointers to store the current node and the previous node respectively. If the nodes are equivalent, delete the current node and move the current pointer to the next node.