// --- Standalone Square Bar Mount Plate ---
// Simple upright square plate for mounting camera.

// --- Dimensions ---
plate_size = 80; // Width and Height (Square)
plate_thickness = 5; // Thickness

bolt_spacing = 52; // Distance between bolt holes (Square pattern)
bolt_diameter = 4.4; // M4 clearance
cable_hole_diameter = 25; // Hole for camera pigtail

$fn = 60;

module bar_mount() {
  difference() {
    union() {
      // 1. Main Plate (Upright in XZ plane)
      // Centered on X and Z for easy rotation/positioning
      translate([-plate_size / 2, 0, -plate_size / 2])
        cube([plate_size, plate_thickness, plate_size]);

      // 4. Triangular Extension (Planar)
      // Extends downwards from the plate
      // Assuming 45-45-90 triangle where one leg is the bottom of the plate ??
      // Or the hypotenuse is the bottom of the plate?
      // Let's assume a Right Triangle extension on one side to act as a flag/brace??
      // Re-reading: "extend the plate".
      // Let's do a centered "V" point? No, that's equilateral usually.
      // Let's do a Right Triangle extension on the Left side (matches "L" bracket shape concept).
      translate([-plate_size / 2, 0, -plate_size / 2])
        rotate([-90, 0, 0]) // Rotate to be in XZ plane (extruded along Y)
          linear_extrude(plate_thickness) // Extrude to thickness
            polygon(
              [
                [0, 0], // Top Left
                [plate_size, 0], // Top Right
                [0, plate_size], // Bottom Left (Vertical drop)
              ]
            );
    }

    // 2. Bolt Holes (Through Y-axis)
    // 4 holes in a square pattern
    for (x_pos = [-1, 1]) {
      for (z_pos = [-1, 1]) {
        translate([x_pos * bolt_spacing / 2, plate_thickness + 1, z_pos * bolt_spacing / 2])
          rotate([90, 0, 0])
            cylinder(h=plate_thickness + 2, d=bolt_diameter);
      }
    }

    // 3. Central Cable Pass-through Hole
    translate([0, plate_thickness + 1, 0])
      rotate([90, 0, 0])
        cylinder(h=plate_thickness + 2, d=cable_hole_diameter);
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

  // Cable Hole Visual
  rotate([90, 0, 0])
    color("blue", 0.5) cylinder(h=plate_thickness * 3, d=cable_hole_diameter, center=true);
}
