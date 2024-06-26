/obj/effect/ebeam/curse_arm
	name = "curse arm"
	layer = LARGE_MOB_LAYER

/obj/item/projectile/curse_hand
	name = "curse hand"
	icon_state = "cursehand0"
	hitsound = 'sound/effects/curse4.ogg'
	layer = LARGE_MOB_LAYER
	damage_type = BURN
	damage = 10
	knockdown = 20
	pixels_per_second = TILES_TO_PIXELS(5)
	range = 16
	var/datum/beam/arm
	var/handedness = 0

/obj/item/projectile/curse_hand/Initialize(mapload)
	. = ..()
	handedness = prob(50)
	icon_state = "cursehand[handedness]"

/obj/item/projectile/curse_hand/Destroy()
	QDEL_NULL(arm)
	. = ..()

/obj/item/projectile/curse_hand/update_icon_state()
	icon_state = "[initial(icon_state)][handedness]"

/obj/item/projectile/curse_hand/fire(setAngle)
	if(starting)
		arm = starting.Beam(src, icon_state = "curse[handedness]", time = INFINITY, maxdistance = INFINITY, beam_type=/obj/effect/ebeam/curse_arm)
	..()

/obj/item/projectile/curse_hand/prehit_pierce(atom/target)
	return (target == original)? PROJECTILE_PIERCE_NONE : PROJECTILE_PIERCE_PHASE

/obj/item/projectile/curse_hand/Destroy()
	if(arm)
		arm.End()
		arm = null
	if((movement_type & PHASING))
		playsound(src, 'sound/effects/curse3.ogg', 25, 1, -1)
	var/turf/T = get_step(src, dir)
	var/obj/effect/temp_visual/dir_setting/curse/hand/leftover = new(T, dir)
	leftover.icon_state = icon_state
	for(var/obj/effect/temp_visual/dir_setting/curse/grasp_portal/G in starting)
		qdel(G)
	new /obj/effect/temp_visual/dir_setting/curse/grasp_portal/fading(starting, dir)
	var/datum/beam/D = starting?.Beam(T, icon_state = "curse[handedness]", time = 32, maxdistance = INFINITY, beam_type=/obj/effect/ebeam/curse_arm, beam_sleep_time = 1)
	if(D)
		for(var/b in D.elements)
			var/obj/effect/ebeam/B = b
			animate(B, alpha = 0, time = 32)
	return ..()

