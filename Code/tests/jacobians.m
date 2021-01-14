syms x_r y_r theta_r delta_x_r delta_y_r delta_theta_r x_l y_l delta_x_l delta_y_l z real

Xr = [x_r; y_r]
DXr = [delta_x_r; delta_y_r]

Xl = [x_l; y_l]
DXl = [delta_x_l; delta_y_l]

Z = z

e = norm(Xr + DXr - Xl- DXl) - z

subs(diff(e, [delta_x_r delta_y_r delta_theta_r]), [delta_x_r delta_y_r delta_theta_r delta_x_l delta_y_l], [0 0 0 0 0])


subs(diff(e, [delta_x_l delta_y_l]), [delta_x_r delta_y_r delta_theta_r delta_x_l delta_y_l], [0 0 0 0 0])