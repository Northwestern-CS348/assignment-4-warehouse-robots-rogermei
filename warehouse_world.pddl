(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?begin - location ?end - location)
      :precondition (and (at ?r ?begin) (no-robot ?end) (free ?r) (connected ?begin ?end))
      :effect (and (at ?r ?end) (no-robot ?begin) (not (no-robot ?end)) (not (at ?r ?begin)))
   )

   (:action robotMoveWithPallette
	:parameters (?r - robot ?begin - location ?end - location ?p - pallette)
	:precondition (and (at ?r ?begin) (no-robot ?end) (at ?p ?begin) (connected ?begin ?end) (no-pallette ?end))
	:effect (and (at ?r ?end) (no-robot ?begin) (at ?p ?end) (no-pallette ?begin) (has ?r ?p) (not (at ?r ?begin)) (not (no-robot ?end)) (not (at ?p ?begin)) (not (no-pallette ?end)))   
   )

   (:action moveItemFromPallette
	:parameters (?l - location ?p - pallette ?o - order ?si - saleitem ?s - shipment)
	:precondition (and (at ?p ?l) (packing-at ?s ?l) (packing-location ?l) (contains ?p ?si) (ships ?s ?o) (orders ?o ?si) (started ?s))
	:effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )

   (:action completeShipment
	:parameters (?s - shipment ?o - order ?l - location)
	:precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (not (available ?l)) (packing-location ?l))
	:effect (and (not (started ?s)) (complete ?s) (not (packing-at ?s ?l)) (available ?l))
   )

)
