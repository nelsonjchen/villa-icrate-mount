// --- iCrate Mount ---
// Reference: bar_mount.scad

// --- Dimensions ---
mount_height = 40;
mount_width_top = 80;
mount_width_bottom = 50;
mount_depth = 20; // Extrusion depth (thickness of the profile)
wall_thickness = 5;

$fn = 60;

module icrate_mount() {
  linear_extrude(mount_depth) {
    difference() {
      // Outer Shape (Trapezoid)
      polygon(
        [
          [-mount_width_bottom / 2, 0],
          [mount_width_bottom / 2, 0],
          [mount_width_top / 2, mount_height],
          [-mount_width_top / 2, mount_height],
        ]
      );

      // Inner Shape (Cutout)
      // We want constant wall thickness, but for simple trapezoid diff:
      // Shift up by wall_thickness
      // Calculate inner widths based on similar triangles or simple offset
      // For now, simple offset method
      polygon(
        [
          [-(mount_width_bottom / 2 - wall_thickness), wall_thickness],
          [(mount_width_bottom / 2 - wall_thickness), wall_thickness],
          [(mount_width_top / 2 - wall_thickness), mount_height + 0.1],
          [-(mount_width_top / 2 - wall_thickness), mount_height + 0.1],
        ]
      );
    }
  }
}

// --- Render ---
color("lightblue") icrate_mount();
