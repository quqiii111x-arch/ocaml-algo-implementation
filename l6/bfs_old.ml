module IOrdered = struct
  type t = int
  let compare = Stdlib.compare
  let hash x = x
  let equal = Stdlib.(=)
end

module DenseInt = Dense.Make(IOrdered)(struct type t = unit end)

module SparseInt = Sparse.Make(IOrdered)(struct type t = unit end)

let density_threshold = 0.2

let read_edges () =
  let m = read_int () in
  let edges = ref [] in
  let max_vertex = ref 0 in
  for _ = 1 to m do
    let line = read_line () in
    let (u, v) = Scanf.sscanf line "%d %d" (fun a b -> (a,b)) in
    edges := !edges @ [(u,v)];
    max_vertex := max !max_vertex (max u v)
  done;
  (!edges, !max_vertex + 1)

type graph_type = 
  | Dense of unit DenseInt.t * int
  | Sparse of unit SparseInt.t * int

let build_graph edges n =
  let m = List.length edges in
  let density = float_of_int m /. float_of_int (n * n) in
  if density > density_threshold then begin
    (* Dense graph *)
    let g = DenseInt.empty () in
    let g = ref g in
    for i = 0 to n-1 do
      g := DenseInt.add_vertex i () !g
    done;
    List.iter (fun (u,v) ->
      g := DenseInt.add_edge u v () !g
    ) edges;
    Dense (!g, n)
  end else begin
    (* Sparse graph *)
    let g = SparseInt.empty () in
    let g = ref g in
    for i = 0 to n-1 do
      g := SparseInt.add_vertex i () !g
    done;
    List.iter (fun (u,v) ->
      g := SparseInt.add_edge u v () !g
    ) edges;
    Sparse (!g, n)
  end

let bfs_dense g start n =
  let visited = Hashtbl.create 32 in
  let q = Queue.create () in
  let order = ref [] in
  let enqueue x =
    if not (Hashtbl.mem visited x) then begin
      Hashtbl.add visited x true;
      Queue.push x q
    end
  in
  enqueue start;
  while not (Queue.is_empty q) do
    let u = Queue.pop q in
    order := !order @ [u];
    let neighbors =
      match DenseInt.get_vertex_value u g with
      | Some _ ->
        let all_v = ref [] in
        for v = 0 to n - 1 do
          if DenseInt.is_adjacent u v g then all_v := v :: !all_v
        done;
        List.rev !all_v
      | None -> []
    in
    List.iter enqueue neighbors
  done;
  !order

let bfs_sparse g start n =
  let visited = Hashtbl.create 32 in
  let q = Queue.create () in
  let order = ref [] in
  let enqueue x =
    if not (Hashtbl.mem visited x) then begin
      Hashtbl.add visited x true;
      Queue.push x q
    end
  in
  enqueue start;
  while not (Queue.is_empty q) do
    let u = Queue.pop q in
    order := !order @ [u];
    let neighbors =
      match SparseInt.get_vertex_value u g with
      | Some _ ->
        let all_v = ref [] in
        for v = 0 to n - 1 do
          if SparseInt.is_adjacent u v g then all_v := v :: !all_v
        done;
        List.rev !all_v
      | None -> []
    in
    List.iter enqueue neighbors
  done;
  !order

let () =
  let edges, n = read_edges () in
  let g = build_graph edges n in
  let order =
    match g with
    | Dense (g, n) -> bfs_dense g 0 n
    | Sparse (g, n) -> bfs_sparse g 0 n
  in
  print_endline (String.concat " " (List.map string_of_int order))
