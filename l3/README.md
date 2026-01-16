# Lab 2.1.3.c: the Knapsack Problem

## Report

### Results:

$$
\begin{array}{|c|c|c|c|c|}
\hline
n & \text{Smallest-first (s)} & \text{Largest-first (s)} & \text{DP solution (s)} & \text{Theoretical } O(n)/O(n^2) \\
\hline
10 & 0.000005 & 0.000002 & 0.000003 & O(n)\approx 0.01\mu s, \; O(n^2)\approx 0.1\mu s \\
20 & 0.000004 & 0.000004 & 0.000006 & O(n)\approx 0.02\mu s, \; O(n^2)\approx 0.4\mu s \\
30 & 0.000006 & 0.000005 & 0.000011 & O(n)\approx 0.03\mu s, \; O(n^2)\approx 0.9\mu s \\
40 & 0.000006 & 0.000006 & 0.000017 & O(n)\approx 0.04\mu s, \; O(n^2)\approx 1.6\mu s \\
50 & 0.000007 & 0.000008 & 0.000026 & O(n)\approx 0.05\mu s, \; O(n^2)\approx 2.5\mu s \\
100 & 0.000017 & 0.000016 & 0.000093 & O(n)\approx 0.1\mu s, \; O(n^2)\approx 10\mu s \\
1000 & 0.000238 & 0.000228 & 0.009118 & O(n)\approx 1\mu s, \; O(n^2)\approx 1\text{ms} \\
10000 & 0.005402 & 0.003421 & 0.922989 & O(n)\approx 10\mu s, \; O(n^2)\approx 100\text{ms} \\
\hline
\end{array}
$$



- Greedy algorithms (Smallest-first and Largest-first):
  - Very fast. Time complexity roughly O(n log n) due to sorting.
  - May fail to find a correct solution in some cases (e.g., counterexample: n=4, S=7, list=[1;3;4;5]).

- Dynamic Programming :
  - Correct solution guaranteed.
  - Time complexity O(n*S).
  - Slower than greedy, especially for large n or S.

- Runtime Compare:
  - For small n (10~50): all algorithms complete in microseconds.
  - For medium n (100~1000): DP takes milliseconds, greedy remains microseconds.
  - For large n (10000): DP approaches 1 second, greedy still a few milliseconds.

---

### Conclusion

1. Greedy algorithms are suitable for fast approximate solutions.
2. DP is necessary for exact correctness but has higher runtime cost.
3. Benchmark results align qualitatively with theoretical expectations from table (2.11|2.75).


# Lab 2.1.4: Topological Sort

## Definition
A topological sort of a directed acyclic graph (DAG) is a linear ordering of its vertices such that for every directed edge \( u \to v \), vertex \( u \) appears before vertex \( v \) in the ordering.


## Algorithm: Kahn's Algorithm 
1. Compute the indegree (number of incoming edges) for each vertex.
2. Start with vertices of indegree 0.
3. Remove each such vertex and reduce the indegree of its neighbors.
4. Continue until all vertices are processed.


# Lab 2.2: Interview problems
## Prob1
1. Compute the total sum of the array: `total_sum = sum(A)`.
2. Check `total_sum % 3`:
   - If `total_sum % 3 == 0`, the sum is already divisible by 3.
   - If `total_sum % 3 == 1`:
     - Remove the smallest element `x` where `x % 3 == 1`, or
     - Remove the two smallest elements `x, y` where `x % 3 == 2`.
   - If `total_sum % 3 == 2`:
     - Remove the smallest element `x` where `x % 3 == 2`, or
     - Remove the two smallest elements `x, y` where `x % 3 == 1`.

The maximum sum divisible by 3 is the largest sum obtained after removal.

## Prob2

If there is 1 red-eyed person:
  - This person sees 0 red-eyed people.  
  - Then they realize it must be themselves and will commit suicide on the 1st evening.

If there are 2 red-eyed people  
  - Each sees 1 red-eyed person.  
  - If nobody dies on the 1st evening, each concludes "I must also be red-eyed". Then, they will both commit suicide on the 2nd evening.


If the number of red-eyed people is `X`.  
- Each red-eyed person sees `X-1` red-eyed people.  
- Each will reason:
  1. "If I am not red-eyed, the `X-1` people I see will die on the `(X-1)`-th evening."  
  2. If nobody dies by the `(X-1)`-th evening, then I must also be red-eyed.  
- Conclusion: all `X` red-eyed people commit suicide on the `X`-th evening.


Number of red-eyed people: `X = 5`  
Therefore, all 5 red-eyed people will commit suicide on the 5th evening after the explorer's announcement.

