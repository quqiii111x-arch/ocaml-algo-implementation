# Lab 6

## Interview Problem

### 1.

Input: an array $a$.

Output: the distance between two indices storing elements with same
value.

Maintain a hash table. Iterate $a$, if $a_i$ is in hash table, record the
answer. Insert $(a_i, i)$.

```cpp
vector<int> Distance(vector<int> a) {
    map<int, int> s;
    vector<pair<int, int> > ans;
    for(int i = 0; i < a.size(); ++i) {
        if (s.contains(a[i]) {
            auto j = s.find(a[i]);
            ans.push_back(make_pair(a[i], i - *j));
        }
        s[a[i]] = i;
    }
    return ans;
}
```

### 2.

Input: an array $t$ of all students estimated total time and your order $i$ in the queue.

Output: The time being spent to answer all $i$ -th student's questions.

Suppose their are $n$ students, define $1$ round to be students from $1$ to $n$ asks questions. Like $1 \rightarrow 2 \rightarrow ... \rightarrow n \rightarrow 1 \rightarrow ... \rightarrow n$. Some students may finished asking their questions, but it doesn't matter.

First we calculate the maximum round for student $i$ which is $r = \lceil \frac{t_i}{5} \rceil$.

Iterate each students:

- If $j \le i$, plus answer by $5 \min \{r, \lceil \frac{t_j}{5}\rceil \}$. 
- If $j > i$. plus answer by $5 \min \{r - 1, \lceil \frac{t_j}{5} \rceil \}$.

```cpp
int QueueTime(vector<int> t, int i) {
    int ans = 0;
    for (auto &c:t) {
        c = ceil(c * 1.0 / 5.0);
    }
    for (int j = 0; j < t.size(); ++j) {
        ans += 5 * min(a[i] - (j > i), a[j]);
    }
    return ans;
}

