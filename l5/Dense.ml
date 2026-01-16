module type ORDERED = sig
  type t

  val compare : t -> t -> int

  val hash : t -> int

  val equal : t -> t -> bool
end

module Make (K : ORDERED) (W : sig type t end) = struct
  module KeyMap = Map.Make(struct
    type t = K.t
    let compare = K.compare
  end)

  type key = K.t
  type weight = W.t

  type 'a t = {
    vertices : 'a KeyMap.t;
    edges : (weight KeyMap.t) KeyMap.t;
  }

  let empty () = { vertices = KeyMap.empty; edges = KeyMap.empty }

  let add_vertex v data g =
    if KeyMap.mem v g.vertices then g
    else { 
      vertices = KeyMap.add v data g.vertices;
      edges = KeyMap.add v KeyMap.empty g.edges
    }

  let get_vertex_value v g = KeyMap.find_opt v g.vertices

  let set_vertex_value v data g =
    if KeyMap.mem v g.vertices then
      { g with vertices = KeyMap.add v data g.vertices }
    else g

  let is_adjacent u v g =
    match KeyMap.find_opt u g.edges with
    | Some adj -> KeyMap.mem v adj
    | None -> false

  let get_edge_weight u v g =
    match KeyMap.find_opt u g.edges with
    | Some adj -> KeyMap.find_opt v adj
    | None -> None

  let add_edge u v w g =
    if KeyMap.mem u g.vertices && KeyMap.mem v g.vertices then
      let add_one u v g =
        match KeyMap.find_opt u g.edges with
        | Some adj ->
            if KeyMap.mem v adj then g
            else { g with edges = KeyMap.add u (KeyMap.add v w adj) g.edges }
        | None -> g
      in
      g |> add_one u v |> add_one v u
    else g

  let remove_edge u v g =
    let remove_one u v g =
      match KeyMap.find_opt u g.edges with
      | Some adj -> { g with edges = KeyMap.add u (KeyMap.remove v adj) g.edges }
      | None -> g
    in
    g |> remove_one u v |> remove_one v u

  let remove_vertex v g =
    if not (KeyMap.mem v g.vertices) then g
    else
      let vertices = KeyMap.remove v g.vertices in
      let edges = KeyMap.remove v g.edges in
 
      let edges =
        KeyMap.map (fun adj -> KeyMap.remove v adj) edges
      in
      { vertices; edges }

  let set_edge_weight u v w g =
    if KeyMap.mem u g.vertices && KeyMap.mem v g.vertices then
      let set_one u v g =
        match KeyMap.find_opt u g.edges with
        | Some adj ->
            if KeyMap.mem v adj then
              { g with edges = KeyMap.add u (KeyMap.add v w adj) g.edges }
            else g
        | None -> g
      in
      g |> set_one u v |> set_one v u
    else g
end
