#include <stdio.h>
#include <stdlib.h>
#include "heap.h"

// Union-Find
typedef struct {
    int *parent;
    int *rank;
    int size;
} UnionFind;

UnionFind *createUF(int n) {
    UnionFind *uf = (UnionFind *)malloc(sizeof(UnionFind));
    uf->parent = (int *)malloc((size_t)n * sizeof(int));
    uf->rank = (int *)calloc((size_t)n, sizeof(int));
    uf->size = n;
    for (int i = 0; i < n; i++) {
        uf->parent[i] = i;
    }
    return uf;
}

int findUF(UnionFind *uf, int x) {
    if (uf->parent[x] != x) {
        uf->parent[x] = findUF(uf, uf->parent[x]);
    }
    return uf->parent[x];
}

void unionUF(UnionFind *uf, int x, int y) {
    int rootX = findUF(uf, x);
    int rootY = findUF(uf, y);
    if (rootX == rootY) return;
    if (uf->rank[rootX] < uf->rank[rootY]) {
        uf->parent[rootX] = rootY;
    } else if (uf->rank[rootX] > uf->rank[rootY]) {
        uf->parent[rootY] = rootX;
    } else {
        uf->parent[rootY] = rootX;
        ++uf->rank[rootX];
    }
}

void freeUF(UnionFind *uf) {
    free(uf->parent);
    free(uf->rank);
    free(uf);
}

// Graph 
typedef struct {
    int v1, v2, weight;
} Edge;

int compareEdge(const void *a, const void *b) {
    Edge *ea = (Edge *)a;
    Edge *eb = (Edge *)b;
    return ea->weight - eb->weight;
}

typedef struct {
    int v1, v2;
} MSTEdge;

int compareMSTEdge(const void *a, const void *b) {
    MSTEdge *ea = (MSTEdge *)a;
    MSTEdge *eb = (MSTEdge *)b;
    if (ea->v1 != eb->v1) return ea->v1 - eb->v1;
    return ea->v2 - eb->v2;
}

//Kruskal 
int kruskal(int vSize, int eSize, Edge *edges, MSTEdge *mstEdges) {
    qsort(edges, (size_t)eSize, sizeof(Edge), compareEdge);

    UnionFind *uf = createUF(vSize);
    int count = 0;

    for (int i = 0; i < eSize && count < vSize - 1; ++i) { 
        if (findUF(uf, edges[i].v1) != findUF(uf, edges[i].v2)) {
            unionUF(uf, edges[i].v1, edges[i].v2);
            mstEdges[count].v1 = edges[i].v1 < edges[i].v2 ? edges[i].v1 : edges[i].v2;
            mstEdges[count].v2 = edges[i].v1 < edges[i].v2 ? edges[i].v2 : edges[i].v1;
            ++count;
        }
    }

    freeUF(uf);
    return count;
}

//Prim
int prim(int vSize, int eSize, Edge *edges, MSTEdge *mst) {
    int **adj = (int **)malloc((size_t)vSize * sizeof(int *));
    int *deg = (int *)calloc((size_t)vSize, sizeof(int));
    for (int i = 0; i < vSize; i++) adj[i] = NULL;

    for (int i = 0; i < eSize; i++) {
        deg[edges[i].v1]++;
        deg[edges[i].v2]++;
    }

    for (int i = 0; i < vSize; i++) adj[i] = (int *)malloc((size_t)(2 * deg[i]) * sizeof(int));
    for (int i = 0; i < vSize; i++) deg[i] = 0;

    for (int i = 0; i < eSize; i++) {
        adj[edges[i].v1][2 * deg[edges[i].v1]] = edges[i].v2;
        adj[edges[i].v1][2 * deg[edges[i].v1] + 1] = edges[i].weight;
        deg[edges[i].v1]++;
        adj[edges[i].v2][2 * deg[edges[i].v2]] = edges[i].v1;
        adj[edges[i].v2][2 * deg[edges[i].v2] + 1] = edges[i].weight;
        deg[edges[i].v2]++;
    }

    int *visited = (int *)calloc((size_t)vSize, sizeof(int));
    int *minDist = (int *)malloc((size_t)vSize * sizeof(int));
    int *parent = (int *)malloc((size_t)vSize * sizeof(int));
    for (int i = 0; i < vSize; i++) { minDist[i] = 1e9; parent[i] = -1; }

    Heap *heap = createHeap(vSize, sizeof(Edge), compareEdge);
    minDist[0] = 0;
    Edge start = {0, 0, 0};
    push(heap, &start);

    int count = 0;
    while (!isEmpty(heap) && count < vSize - 1) {
        Edge e;
        pop(heap, &e);
        int u = e.v2;
        if (visited[u]) continue;
        visited[u] = 1;

        if (parent[u] != -1) {
            mst[count].v1 = u < parent[u] ? u : parent[u];
            mst[count].v2 = u < parent[u] ? parent[u] : u;
            count++;
        }

        for (int i = 0; i < deg[u]; i++) {
            int v = adj[u][2 * i];
            int w = adj[u][2 * i + 1];
            if (!visited[v] && w < minDist[v]) {
                minDist[v] = w;
                parent[v] = u;
                Edge newE = {u, v, w};
                push(heap, &newE);  
            }
        }
    }

    freeHeap(heap);
    free(visited); free(minDist); free(parent);
    for (int i = 0; i < vSize; i++) free(adj[i]);
    free(adj); free(deg);

    return count;
}



int main() {
    int eSize, vSize;
    if (scanf("%d", &eSize) != 1) return 1;
    if (scanf("%d", &vSize) != 1) return 1;

    Edge *edges = (Edge *)malloc((size_t)eSize * sizeof(Edge));
    
    for (int i = 0; i < eSize; i++) {
        if (scanf("%d %d %d", &edges[i].v1, &edges[i].v2, &edges[i].weight) != 3) {
            return 1;
        }
    }

    MSTEdge *mst = (MSTEdge *)malloc((size_t)(vSize - 1) * sizeof(MSTEdge));

    int mstSize;
    if (eSize <= 20 * vSize) {
        mstSize = kruskal(vSize, eSize, edges, mst);
    } else {
        mstSize = prim(vSize, eSize, edges, mst);
    }

    qsort(mst, (size_t)mstSize, sizeof(MSTEdge), compareMSTEdge);
    for (int i = 0; i < mstSize; i++) {
        printf("%d--%d\n", mst[i].v1, mst[i].v2);
    }

    free(edges);
    free(mst);
    return 0;
}
