type 'a node = {
  mutable key : int;
  value : 'a;
  mutable degree : int;
  mutable mark : bool;
  mutable parent : 'a node option;
  mutable child : 'a node option;
  mutable left : 'a node;
  mutable right : 'a node
}

type 'a heap = {
  mutable min : 'a node option;
  mutable n : int
}

exception Empty
exception Invalid_key

let makeHeap () = { min = None; n = 0 }

let create_node ~key ~value =
  let rec node = {
    key;
    value;
    degree = 0;
    mark = false;
    parent = None;
    child = None;
    left = node; 
    right = node
  } in
  node

let insert_into_root_list h node =
  match h.min with
  | None ->
    node.left <- node; node.right <- node; h.min <- Some node
  | Some m ->
    let r = m.right in
    m.right <- node; node.left <- m;
    node.right <- r; r.left <- node;
    if node.key < m.key then h.min <- Some node

let insert h ~key ~value =
  let node = create_node ~key ~value in
  insert_into_root_list h node;
  h.n <- h.n + 1;
  node

let isEmpty h = (h.n = 0)

let size h = h.n

let minimum h =
  match h.min with
  | None -> None
  | Some m -> Some (m.key, m.value)

let remove_from_list node =
  if node.left == node && node.right == node then
    ()
  else begin
    node.left.right <- node.right;
    node.right.left <- node.left
  end;
  node.left <- node; node.right <- node

let link x y =
  remove_from_list y;
  y.parent <- Some x;
  begin match x.child with
  | None -> x.child <- Some y; y.left <- y; y.right <- y
  | Some c ->
    let r = c.right in
    c.right <- y; y.left <- c; y.right <- r; r.left <- y
  end;
  x.degree <- x.degree + 1;
  y.mark <- false


let consolidate h =
  let max_degree = (int_of_float (ceil (log (float_of_int (max 1 h.n)) /. log 2.0))) + 1 in
  let a = Array.make (max_degree + 5) None in
  let root_nodes = ref [] in
  begin match h.min with
  | None -> ()
  | Some m ->
    let start = m in
    let cur = ref start in
    let cont = ref true in
    while !cont do
      root_nodes := !cur :: !root_nodes;
      cur := (!cur).right;
      if !cur == start then cont := false
    done
  end;
  List.iter (fun w ->
    let w = w in
    let d = w.degree in
    let rec aux node d =
      match a.(d) with
      | None -> a.(d) <- Some node
      | Some other ->
        let (small,big) = if node.key <= other.key then (node, other) else (other, node) in
        link small big;
        a.(d) <- None;
        aux small (d+1)
    in aux w d
  ) !root_nodes;
  h.min <- None;
  for i = 0 to Array.length a - 1 do
    match a.(i) with
    | None -> ()
    | Some node ->
      node.left <- node; node.right <- node; node.parent <- None;
      insert_into_root_list h node
  done

let extractMin h =
  match h.min with
  | None -> None
  | Some z ->
    begin match z.child with
    | None -> ()
    | Some c ->
      let children = ref [] in
      let start = c in
      let cur = ref start in
      let cont = ref true in
      while !cont do
        children := !cur :: !children;
        cur := (!cur).right;
        if !cur == start then cont := false
      done;
      List.iter (fun x ->
        x.parent <- None;
        x.left <- x; x.right <- x;
        insert_into_root_list h x
      ) !children
    end;
    remove_from_list z;
    if z == (match h.min with Some m -> m | None -> z) && z.right == z then
      h.min <- None
    else
      h.min <- (if z.right == z then None else Some z.right);
    h.n <- h.n - 1;
    if h.min <> None then consolidate h;
    Some (z.key, z.value)

let union h1 h2 =
  let h = makeHeap () in
  begin match h1.min, h2.min with
  | None, _ ->
    h.min <- h2.min; h.n <- h2.n
  | _, None ->
    h.min <- h1.min; h.n <- h1.n
  | Some m1, Some m2 ->
    let r1 = m1.right in
    let l2 = m2.left in
    m1.right <- m2; m2.left <- m1;
    r1.left <- l2; l2.right <- r1;
    h.min <- (if m1.key <= m2.key then Some m1 else Some m2);
    h.n <- h1.n + h2.n
  end;
  h

let cut h x y =
  if y.child = Some x then
    if x.right == x then y.child <- None
    else y.child <- Some x.right;
  remove_from_list x;
  y.degree <- y.degree - 1;
  x.parent <- None;
  x.mark <- false;
  x.left <- x; x.right <- x;
  insert_into_root_list h x

let rec cascading_cut h y =
  match y.parent with
  | None -> ()
  | Some z ->
    if not y.mark then y.mark <- true
    else begin
      cut h y z;
      cascading_cut h z
    end

let decreaseKey h x new_key =
  if new_key > x.key then raise Invalid_key;
  x.key <- new_key;
  match x.parent with
  | None -> 
    begin match h.min with
    | None -> h.min <- Some x
    | Some m -> if x.key < m.key then h.min <- Some x
    end
  | Some y ->
    if x.key < y.key then begin
      cut h x y;
      cascading_cut h y;
      match h.min with
      | None -> h.min <- Some x
      | Some m -> if x.key < m.key then h.min <- Some x
    end

let delete h x =
  decreaseKey h x min_int;
  ignore (extractMin h)


