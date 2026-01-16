type 'a heap
type 'a node


exception Empty
exception Invalid_key


val makeHeap : unit -> 'a heap


val insert : 'a heap -> key:int -> value:'a -> 'a node


val minimum : 'a heap -> (int * 'a) option


val extractMin : 'a heap -> (int * 'a) option


val union : 'a heap -> 'a heap -> 'a heap


val decreaseKey : 'a heap -> 'a node -> int -> unit


val delete : 'a heap -> 'a node -> unit


val isEmpty : 'a heap -> bool


val size : 'a heap -> int