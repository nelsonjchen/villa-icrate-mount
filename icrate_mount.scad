// --- iCrate Mount ---
// Reference: bar_mount.scad

// --- Dimensions ---
mount_height = 40;
mount_width_top = 80;
mount_width_bottom = 50;
mount_depth = 20; // Extrusion depth (thickness of the profile)
wall_thickness = 5;

// --- Cage Dimensions from README ---
wire_diameter = 4;
wire_spacing_edge_to_edge = 105;
wire_center_spacing = wire_spacing_edge_to_edge + wire_diameter; // 109mm

$fn = 60;

module icrate_mount() {
  // Current orientation: Profile in XY, Extruded in Z.
  // This creates a "tunnel" along Z.
  linear_extrude(mount_depth) {
    difference() {
      // 1. Basic Trapezoidal Frame
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
        // Shift up by wall_thickness
        polygon(
          [
            [-(mount_width_bottom / 2 - wall_thickness), wall_thickness],
            [(mount_width_bottom / 2 - wall_thickness), wall_thickness],
            [(mount_width_top / 2 - wall_thickness), mount_height + 0.1],
            [-(mount_width_top / 2 - wall_thickness), mount_height + 0.1],
          ]
        );
      }

      // 2. Open the bottom to make it an Arch/U-shape
      translate([-mount_width_bottom / 2 - 1, -1])
        square([mount_width_bottom + 2, wall_thickness + 1.1]);
    }
  }
}

module cage_mock() {
  // Horizontal bars (along X axis)
  // Spaced vertically (along Z axis) or Y axis depending on orientation.
  // Let's assume standard "Wall" is XZ plane (Up is Z). 
  // Bars run horizontally along X.

  %union() {
    // Top Wire
    color("gray")
      rotate([0, 90, 0]) // Cylinder defaults to Z. Rotate to X.
        cylinder(d=wire_diameter, h=200, center=true);

    // Bottom Wire
    translate([0, 0, -wire_center_spacing])
      color("gray")
        rotate([0, 90, 0])
          cylinder(d=wire_diameter, h=200, center=true);
  }
}

// --- Render ---
// Align mount with the top wire.
// Mount's extrusion axis (Z) needs to align with Wire (X).
// Mount's "Up" (Y in profile) needs to align with World Up (Z).
rotate([90, 0, 90])
  color("lightblue") icrate_mount();

// Show context
cage_mock();
