// --- Standalone Square Bar Mount Plate ---
// Simple upright square plate for mounting camera.

// --- Dimensions ---
plate_size = 90; // Width and Height (Square) / Diameter (Round)
plate_thickness = 10; // Thickness

bolt_spacing = 52; // Distance between bolt holes (Square pattern)
bolt_diameter = 4.4; // M4 clearance
cable_hole_diameter = 25; // Hole for camera pigtail

// Cutout Adjustment
svg_offset_x = 40;
svg_offset_y = 0;
svg_scale_x = -1;
svg_scale_y = 1;
svg_rotation = 0;
svg_thickness = plate_thickness; // Default to match plate

$fn = 60;

module bar_mount() {
  difference() {
    union() {
      // 1. Main Plate (Round)
      // Centered on origin
      rotate([-90, 0, 0])
        cylinder(d=plate_size, h=plate_thickness);

      // 4. Triangular Extension (Planar)
      // Extends downwards from the plate
      // Assuming 45-45-90 triangle where one leg is the bottom of the plate ??
      // Or the hypotenuse is the bottom of the plate?
      // Let's assume a Right Triangle extension on one side to act as a flag/brace??
      // Re-reading: "extend the plate".
      // Let's do a centered "V" point? No, that's equilateral usually.
      // Let's do a Right Triangle extension on the Left side (matches "L" bracket shape concept).
      // 4. SVG Extension
      // Extends downwards from the plate
      translate([-plate_size / 2, 0, -plate_size / 2])
        rotate([-90, 0, 0]) // Rotate to be in XZ plane (extruded along Y)
          linear_extrude(svg_thickness) // Extrude to thickness
            translate([svg_offset_x, svg_offset_y])
              rotate([0, 0, svg_rotation])
                scale([svg_scale_x, svg_scale_y])
                  import("drawing.svg");

      // 4a. Reinforcement Cube (Global Coordinates)
      // Calculated: translate([-45, 0, -45])
      // Spans X: -45 to 0. Z: -45 to -35. Matches bottom-left of plate zone.
      translate([-45, 0, -45])
        cube([45, svg_thickness, 10]);

      // 4b. Wedge Triangle (Global Coordinates)
      // Calculated: translate([0, 0, -45])
      // Rotated and Polygon adjusted to match original relative "wedge"
      translate([-45, 0, -45])
        rotate([-90, 0, 0])
          linear_extrude(svg_thickness)
            polygon([[0, 0], [10, 0], [0, 10]]);
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
