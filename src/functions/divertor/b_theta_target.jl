"""
    b_theta_target()

Lorem ipsum dolor sit amet.
"""
function b_theta_target()
  cur_angle = target_angle()

  cur_b_theta = 0.040387 * sin(cur_angle)
  cur_b_theta += 0.032490 * cos(cur_angle)

  cur_b_theta = abs(cur_b_theta)

  cur_b_theta
end