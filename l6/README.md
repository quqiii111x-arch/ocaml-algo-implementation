# Lab 6

## Interview Problem

### 1.

1. Traverse the array.
2. Record the first index at which each value appears.
3. When the same value appears again, compute the distance between its two occurrences.
4. Store the result for each repeated value.

```cpp
unordered_map<int, int> distance(const vector<int>& arr) {
    unordered_map<int, int> firstIndex;
    unordered_map<int, int> result;

    for (int i = 0; i < arr.size(); ++i) {
        int v = arr[i];
        if (!firstIndex.count(v)) {
            firstIndex[v] = i;
        } else {
            result[v] = i - firstIndex[v];
        }
    }

    return result;
}
```

### 2.

1. The student needs ceil(required_time / 5) rounds.
2. In each round, every active student consumes 5 minutes.
3. Track when student i finishes and return the total accumulated time.

```cpp
int time(vector<int>& times, int target) {
    queue<pair<int,int>> q; 
    
    for (int i = 0; i < (int)times.size(); i++) {
        q.push({times[i], i});
    }

    int total = 0;

    while (!q.empty()) {
        auto [rem, idx] = q.front();
        q.pop();

        int used = min(5, rem);
        total += used;
        rem -= used;

        if (idx == target) {
            if (rem <= 0) return total; 
        }

        if (rem > 0) {
            q.push({rem, idx});
        }
    }

    return total;
}

