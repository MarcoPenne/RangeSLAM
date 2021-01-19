%syms x_r y_r theta_r delta_x_r delta_y_r delta_theta_r x_l y_l delta_x_l delta_y_l z real

% Xr = [x_r; y_r]
% DXr = [delta_x_r; delta_y_r]

% Xl = [x_l; y_l]
% DXl = [delta_x_l; delta_y_l]

% Z = z

% e = norm(Xr + DXr - Xl- DXl) - z

% subs(diff(e, [delta_x_r delta_y_r delta_theta_r]), [delta_x_r delta_y_r delta_theta_r delta_x_l delta_y_l], [0 0 0 0 0])


% subs(diff(e, [delta_x_l delta_y_l]), [delta_x_r delta_y_r delta_theta_r delta_x_l delta_y_l], [0 0 0 0 0])


clear all
syms x_ri y_ri theta_ri x_rj y_rj theta_rj tr1 tr2 tr3 dx_ri dy_ri dtheta_ri dx_rj dy_rj dtheta_rj real

Xr_i = [x_ri; y_ri; theta_ri]
Xr_j = [x_rj; y_rj; theta_rj]
DXr_i = [dx_ri; dy_ri; dtheta_ri]
DXr_j = [dx_rj; dy_rj; dtheta_rj]

function t = v2t(X)
    t = sym(zeros(3,3));
    t(1:2, 3) = X(1:2);
    t(3, 3) = 1;
    theta = X(3);
    t(1:2, 1:2) = [cos(theta) -sin(theta);sin(theta) cos(theta)];
end

function v = t2v(t)
    v = sym(zeros(3,1));
    v(1:2) = t(1:2, 3);
    v(3) = atan2(t(2,1), t(1,1));
end

function i = t_inverse(t)
    i = sym(zeros(3,3));
    i(3, 3) = 1;
    i(1:2, 3) = -t(1:2, 1:2)' * t(1:2, 3);
    i(1:2, 1:2) = t(1:2, 1:2)';
end
t = v2t(Xr_i)
t_inv = t_inverse(t)

simplify(t_inverse(v2t(Xr_i)) * v2t(Xr_j))

t2v(v2t(Xr_i))

Z = v2t([tr1; tr2; tr3])
Z_1 = t_inverse(Z)

h = t_inverse(v2t(Xr_i))*v2t(Xr_j)
e = t2v(Z_1 * t_inverse(v2t(DXr_i)*v2t(Xr_i)) * (v2t(DXr_j)*v2t(Xr_j)))

ei = [diff(e(1), [dx_ri dy_ri dtheta_ri]); diff(e(2), [dx_ri dy_ri dtheta_ri]); diff(e(3), [dx_ri dy_ri dtheta_ri])];
simplify(subs(ei, [dx_ri dy_ri dtheta_ri dx_rj dy_rj dtheta_rj], [0 0 0 0 0 0]))

ej = [diff(e(1), [dx_rj dy_rj dtheta_rj]); diff(e(2), [dx_rj dy_rj dtheta_rj]); diff(e(3), [dx_rj dy_rj dtheta_rj])];
simplify(subs(ej, [dx_ri dy_ri dtheta_ri dx_rj dy_rj dtheta_rj], [0 0 0 0 0 0]))