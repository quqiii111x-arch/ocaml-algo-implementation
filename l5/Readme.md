# L5

In lab5, we focus on the graph modules and shortest path problems!

## 1. Graphs

Implement modules for sparse graphs and dense graphs separately, which should be in `Sparse.ml` and `Dense.ml`. You should implement all the methods in the return module signatures of `Make` in `.mli` files. 

The module `ORDERED` is a helper module, use the method in it base on your actual needs.

**Note.** Ex2 and Ex3 is not related to the modules you implemented in Ex1, please design new data structure for them. In Ex2, you should also use **Fibonacci Heap** module from lab 4.

## 2. Dijkstra

Implement **Dijkstra** with **Fibonacci Heap**. You need to check whether **Dijkstra** can be used to solve the problem. (Hint: negative edge/negative loop). The **Fibonacci Heap** should in `FibHeap.mli` and `FibHeap.ml`.

----

Input1:
```
18
s b 4
b s 4
s c 2
c s 2
b d 5
d b 5
c d 8
d c 8
b c 1
c b 1
c e 10
e c 10
d e 2
e d 2
d t 6
t d 6
e t 3
t e 3
s
t
```

Output1:
```
['s', 'c', 'b', 'd', 'e', 't']
```

----

Input2:
```
1
a b -1
a
b
```

Output2:
```
Invalid!
```

----

Input3:
```
5
0 1 1
1 2 -3
2 3 1
3 1 1
1 4 1
0
4
```

Output3:
```
Invalid!
```

## 3. BellmanFord

Implement **BellmanFord**. You need to check whether **BellmanFord** can be used to solve the problem. (Hint: negative loop). 

----

Input1:
```
18
s b 4
b s 4
s c 2
c s 2
b d 5
d b 5
c d 8
d c 8
b c 1
c b 1
c e 10
e c 10
d e 2
e d 2
d t 6
t d 6
e t 3
t e 3
s
t
```

Output1:
```
['s', 'c', 'b', 'd', 'e', 't']
```

----

Input2:
```
1
a b -1
a
b
```

Output2:
```
['a', 'b']
```

----

Input3:
```
5
0 1 1
1 2 -3
2 3 1
3 1 1
1 4 1
0
4
```

Output3:
```
Invalid!
```

## 4. Compare the efficiency of Bellman-Ford and Dijkstra in terms of (i) complexity and (ii) running time

(i) Time Complexity
- Bellman-Ford: Since it relaxes all edges V - 1 times, the worst-case demands O(V $\times$ E). 
- Dijkstra (using binary heap): O(E log V)  
- Dijkstra (using Fibonacci heap): O(E + V log V)  

Dijkstra is asymptotically faster when all edges are non-negative.

(ii) Practical Running Time
- Bellman-Ford:
  - Slower in practice due to repeated full-edge relaxations.  
  - Preferred only when *egative weights exist or when detecting negative cycles.
- Dijkstra:  
  - Faster in real-world graphs, especially sparse ones.  
  - Cannot handle negative-weight edges safely.

## Interview Problems

(1)

**Greedy + Set:**
1. Insert each code into a set.
2. If a code already exists, keep increasing it by 1 until it becomes unique.
3. Add the final unique code to the output.

**Example**
Input:  
`[5, 1, 2, 3, 2]`

Process:  
- 5 - unique  
- 1 - unique  
- 2 - unique  
- 3 - unique  
- 2 - duplicate - becomes 4

Output:  
`[5, 1, 2, 3, 4]`

The sum is minimal because we only increase duplicated values when necessary.

(2)

**Greedy + Sliding window:**
1. Sort the bike positions.
2. Any optimal roof covering `k` bikes will cover `k` *consecutive* positions in the sorted order.
3. For each window of `k` consecutive positions compute the span `positions[i+k-1] - positions[i]`.
4. The answer is the minimum span over all such windows.

Sorting arranges bikes by location. For any chosen set of `k` bikes, moving the roof to align with the leftmost and rightmost of those `k` bikes does not increase span; hence an optimal roof always covers `k` consecutive sorted positions.

**Complexity:**  
- Sorting: `O(n log n)`  
- Sliding-window check: `O(n)`  
Total: `O(n log n)` 

**Example:**  
Input `n = 6`, `positions = [0, 1, 2.5, 10.5, 11, 12]`, `k = 3`  
Sorted windows of size 3: spans =  
- `2.5 - 0 = 2.5`  
- `10.5 - 1 = 9.5`  
- `11 - 2.5 = 8.5`  
- `12 - 10.5 = 1.5` 
minimum answer `1.5`

