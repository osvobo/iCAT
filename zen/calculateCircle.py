import math


def calculate_circle_properties(y1, z1, y2, z2, diff):
    # Normalize the angle to the range [0, 360) degrees

    if math.floor(diff/180) % 2 == 0:
        chord = 0
    else:
        chord = 1

    diff = diff % 360

    # Convert angle from degrees to radians
    diff_rad = math.radians(diff)

    # Midpoint of AB
    my = (y1 + y2) / 2
    mz = (z1 + z2) / 2

    # Length of AB (chord length)
    ab_length = math.sqrt((y2 - y1)**2 + (z2 - z1)**2)

    # Handle special case where alpha is 0 (no valid circle)
    if diff == 0:
        raise ValueError("Diff angle cannot be 0 degrees.")

    # Handle special case where alpha is 180 (center is midpoint, radius is half the distance)
    if diff == 180:
        r = ab_length / 2
        return my, mz, 2 * r

    # Radius of the circle
    r = (ab_length / 2) / math.sin(diff_rad / 2)

     # Perpendicular bisector direction
    dy = y2 - y1
    dz = z2 - z1

    # Perpendicular direction
    perp_dy = -dz
    perp_dz = dy


    # Normalize the perpendicular direction
    #d_length = math.sqrt(perp_dy**2 + perp_dz**2)
    perp_dy /= ab_length
    perp_dz /= ab_length


    # Distance from midpoint to the center
    h = math.sqrt(r**2 - (ab_length / 2)**2)


    # Center of the circle (two possible solutions, above or below the chord)
    if chord == 1:
        cy = my + perp_dy * h
        cz = mz + perp_dz * h
    else:
        cy = my - perp_dy * h
        cz = mz - perp_dz * h

    # Diameter of the circle
    diameter = 2 * r

    #return (cz1, cz1), (cz2, cz2), diameter
    return cy, cz, diameter

def calculate_point_on_circle(cy, cz, r, delta):
    angle_rad = math.atan2(y1 - cy, z1 - cz)  # atan2 gives the angle in radians
    angle_deg = math.degrees(angle_rad) 


    # Convert angle delta from degrees to radians
    delta_rad = math.radians(delta - angle_deg)

    # Calculate the coordinates of the new point
    y = cy + r * math.cos(delta_rad)
    z = cz + r * math.sin(delta_rad)

    return y, z, angle_deg

# Example usage
y1, z1 = -3382 , -1478  # Coordinates of point A
y2, z2 = -2307, -1147  # Coordinates of point B
alpha = 4      # Angle between vertical and line C-point1
beta = 95      # Angle between vertical and line C-point2
delta = 95    # Angle between vertical and line C-new point
delta_diff = delta - alpha
diff = beta - alpha  # Angle between points A and B

# Calculate the circle properties
Ycenter, Zcenter, diameter = calculate_circle_properties(y1, z1, y2, z2, diff)
radius = diameter / 2

# Calculate a point on the circle
y_point, z_point, ORIangle = calculate_point_on_circle(Ycenter, Zcenter, radius, 90-delta_diff)

print("Center of the circle: (%s, %s)" % (Ycenter, Zcenter))
print("Radius of the circle: %s" % radius)
print("y1z1 angle: %s" % ORIangle)
print("Point on the circle at delta=%s degrees: (%s, %s)" % (delta, y_point, z_point))