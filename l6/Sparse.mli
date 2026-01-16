(**
  An ORDERED key module used to parameterize the graph.

  Consistency required:
  - If [equal a b] then [compare a b = 0].
  - If [equal a b] then [hash a = hash b].
  - [equal] must be an equivalence relation.
*)
module type ORDERED = sig
  type t

  val compare : t -> t -> int

  val hash : t -> int

  val equal : t -> t -> bool
end

(**
  A persistent, undirected sparse graph interface.

  Semantics and constraints:
  - Undirected: [add_edge u v w] represents an undirected edge u<->v with weight [w].
  - Self-loop is allowed: u = v is valid.
  - No multi-edge: [add_edge] is initialization-only. If the edge already exists, it is a no-op.
  - Vertex existence: [add_edge] requires both endpoints already exist; otherwise it's a no-op.
  - Removal: [remove_edge] and [remove_vertex] are no-ops if the target does not exist.
  - Updates: [set_vertex_value] only updates existing vertices (missing vertex -> no-op);
             [set_edge_weight] only updates existing edges (missing endpoints or edge -> no-op).
*)
module Make : functor
  (K : ORDERED)
  (W : sig
     type t
   end)
  -> sig
  type key = K.t

  type weight = W.t

  type 'a t

  val empty : unit -> 'a t
  (** Generate an empty graph. *)

  val add_vertex : key -> 'a -> 'a t -> 'a t
  (** [add_vertex v data g] inserts vertex [v] with payload [data].
      Initialization-only: if [v] already exists, it is a no-op. *)

  val is_adjacent : key -> key -> 'a t -> bool
  (** [is_adjacent u v g] checks whether edge u<->v exists. *)

  val get_edge_weight : key -> key -> 'a t -> weight option
  (** [get_edge_weight u v g] returns [Some w] if edge u<->v exists, otherwise [None]. *)

  val get_vertex_value : key -> 'a t -> 'a option
  (** [get_vertex_value v g] returns [Some payload] if [v] exists, otherwise [None]. *)

  val set_vertex_value : key -> 'a -> 'a t -> 'a t
  (** [set_vertex_value v data g] updates the payload of existing vertex [v].
      If [v] does not exist, it is a no-op. *)

  val add_edge : key -> key -> weight -> 'a t -> 'a t
  (** [add_edge u v w g] adds an undirected edge u<->v with weight [w].
      Initialization-only: if the edge already exists, it is a no-op.
      If either [u] or [v] does not exist, it is a no-op. *)

  val remove_edge : key -> key -> 'a t -> 'a t
  (** [remove_edge u v g] removes edge u<->v if present, otherwise no-op. *)

  val remove_vertex : key -> 'a t -> 'a t
  (** [remove_vertex v g] removes vertex [v] and all its incident edges.
      If [v] does not exist, it is a no-op. *)

  val set_edge_weight : key -> key -> weight -> 'a t -> 'a t
  (** [set_edge_weight u v w g] updates the weight of an existing undirected edge u<->v.
      If the edge does not exist, it is a no-op.
      If either [u] or [v] does not exist, it is a no-op. *)
end
