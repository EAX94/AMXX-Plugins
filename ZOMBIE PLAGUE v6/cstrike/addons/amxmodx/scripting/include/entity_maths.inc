stock entity_set_follow(entity, target, Float:speed) {

  if (!is_valid_ent(entity) || !is_valid_ent(target)) return 0

  new Float:entity_origin[3], Float:target_origin[3]
  entity_get_vector(entity, EV_VEC_origin, entity_origin)
  entity_get_vector(target, EV_VEC_origin, target_origin)

  new Float:diff[3]
  diff[0] = target_origin[0] - entity_origin[0]
  diff[1] = target_origin[1] - entity_origin[1]
  diff[2] = target_origin[2] - entity_origin[2]

  new Float:length = floatsqroot(floatpower(diff[0], 2.0) + floatpower(diff[1], 2.0) + floatpower(diff[2], 2.0))

  new Float:Velocity[3]
  Velocity[0] = diff[0] * (speed / length)
  Velocity[1] = diff[1] * (speed / length)
  Velocity[2] = diff[2] * (speed / length)

  entity_set_vector(entity, EV_VEC_velocity, Velocity)

  return 1
}