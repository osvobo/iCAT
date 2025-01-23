import matplotlib.pyplot as plt
import numpy as np
import math

def plot_circle_and_points(center, diameter, point_a, point_b, point_x1, point_x2, point_x3):
    # Unpack the center and points
    cx, cy = center
    ax, ay = point_a
    bx, by = point_b
    x1, y1 = point_x1
    x2, y2 = point_x2
    x3, y3 = point_x3

    # Calculate radius
    radius = diameter / 2

    # Create the circle
    theta = np.linspace(0, 2 * np.pi, 500)
    circle_x = cx + radius * np.cos(theta)
    circle_y = cy + radius * np.sin(theta)

    # Calculate vectors CA, CB, and CX
    vector_ca = (ax - cx, ay - cy)
    vector_cb = (bx - cx, by - cy)
    vector_cx = (x1 - cx, y1 - cy)

    # Calculate the dot product and magnitude of vectors for angles
    dot_ca_cb = vector_ca[0] * vector_cb[0] + vector_ca[1] * vector_cb[1]
    mag_ca = math.sqrt(vector_ca[0]**2 + vector_ca[1]**2)
    mag_cb = math.sqrt(vector_cb[0]**2 + vector_cb[1]**2)
    angle_ca_cb_rad = math.acos(dot_ca_cb / (mag_ca * mag_cb))
    angle_ca_cb_deg = math.degrees(angle_ca_cb_rad)

    dot_ca_cx = vector_ca[0] * vector_cx[0] + vector_ca[1] * vector_cx[1]
    mag_cx = math.sqrt(vector_cx[0]**2 + vector_cx[1]**2)
    angle_ca_cx_rad = math.acos(dot_ca_cx / (mag_ca * mag_cx))
    angle_ca_cx_deg = math.degrees(angle_ca_cx_rad)

    # Set figure size
    plt.figure(figsize=(12, 8))

    # Plot the circle
    plt.plot(circle_x, circle_y, label="Circle")

    # Plot points A, B, and X
    plt.scatter([ax], [ay], color="red", label="Point A")
    plt.scatter([bx], [by], color="blue", label="Point B")
    plt.scatter([x1], [y1], color="purple", label="Point X1")
    plt.scatter([x2], [y2], color="purple", label="Point X2")
    plt.scatter([x3], [y3], color="purple", label="Point X3")

    # Plot lines CA, CB, and CX
    plt.plot([cx, ax], [cy, ay], color="orange", linestyle="--", label="Line CA")
    plt.plot([cx, bx], [cy, by], color="green", linestyle="--", label="Line CB")
    plt.plot([cx, x1], [cy, y1], color="purple", linestyle="--", label="Line CX")

    # Annotate the points
    plt.text(ax, ay, "A", fontsize=12, color="red", ha="right")
    plt.text(bx, by, "B", fontsize=12, color="blue", ha="left")
    plt.text(x1, y1, "X1", fontsize=12, color="purple", ha="left")
    plt.text(x2, y2, "X2", fontsize=12, color="purple", ha="left")
    plt.text(x3, y3, "X3", fontsize=12, color="purple", ha="left")
    plt.text(cx, cy, "C", fontsize=12, color="black", ha="center")

    # Display the angles
    plt.title(f"Angles: CA-CB = {angle_ca_cb_deg:.2f}°, CA-CX1 = {angle_ca_cx_deg:.2f}°")

    # Set equal aspect ratio
    plt.axis("equal")
    plt.legend(loc="upper left", bbox_to_anchor=(1.2, 1))
    plt.xlabel("X-axis")
    plt.ylabel("Y-axis")

    # Show the plot
    plt.grid(True)
    plt.tight_layout(rect=[0, 0, 1, 1])
    plt.show()

# Define the center, diameter, and points A, B, and X
#center = (-3007.136397045647, -784.3002210753166)
center = (-2681.863602954353, -1840.6997789246834)
diameter = 788*2
point_a = (-3382 , -1478 )
point_b = (-2307, -1147)
point_x1 = (-2993.6269999984502, -246.05599999872095)
point_x2 = (-3026.2686268764805, -188.00672714716274)
point_x3 = (-3329.204,
-303.554)



# Call the function
plot_circle_and_points(center, diameter, point_a, point_b, point_x1, point_x2, point_x3)
