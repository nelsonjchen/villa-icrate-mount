// --- Standalone Square Bar Mount Plate ---
// Simple upright square plate for mounting camera.

// --- Dimensions ---
plate_size = 80; // Width and Height (Square)
plate_thickness = 5; // Thickness

bolt_spacing = 52; // Distance between bolt holes (Square pattern)
bolt_diameter = 4.4; // M4 clearance

$fn = 60;

module bar_mount() {
  difference() {
    // 1. Main Plate (Upright in XZ plane)
    // Centered on X and Z for easy rotation/positioning
    translate([-plate_size / 2, 0, -plate_size / 2])
      cube([plate_size, plate_thickness, plate_size]);

    // 2. Bolt Holes (Through Y-axis)
    // 4 holes in a square pattern
    for (x_pos = [-1, 1]) {
      for (z_pos = [-1, 1]) {
        translate([x_pos * bolt_spacing / 2, plate_thickness + 1, z_pos * bolt_spacing / 2])
          rotate([90, 0, 0])
            cylinder(h=plate_thickness + 2, d=bolt_diameter);
      }
    }
  }
}

// --- Render ---
color("lightgreen") bar_mount();

// --- Visual Reference for Bolts ---
%union() {
  for (x_pos = [-1, 1]) {
    for (z_pos = [-1, 1]) {
      translate([x_pos * bolt_spacing / 2, 0, z_pos * bolt_spacing / 2])
        rotate([90, 0, 0])
          color("red") cylinder(h=plate_thickness * 3, d=2, center=true);
    }
  }
}
