// --- iCrate Mount: Flat Planar Hanger ---
// Orientation:
// X = Horizontal (along the wire)
// Z = Vertical (Up/Down)
// Y = Thickness (into/out of plane)

// --- Dimensions ---
wire_diameter = 4;
wire_spacing_edge_to_edge = 105;
wire_center_spacing = wire_spacing_edge_to_edge + wire_diameter;

thickness = 5;
spread = 120; // Distance between hooks
height = 60; // How far it hangs down (along Z)
bottom_width = 40; // Width of the bottom edge

$fn = 60;

// !!! DO NOT TOUCH THE MOCK BELOW. KEEP OBSERVING IT. !!!
// !!! THE MOCK IS STATIC IN THE XZ PLANE. !!!
// !!! DO NOT CHANGE THESE CYLINDERS. !!!
module cage_mock() {
  %union() {
    // Top Wire (Along X, at Z=0)
    color("gray")
      rotate([0, 90, 0]) cylinder(d=wire_diameter, h=250, center=true);

    // Bottom Wire (Along X, at Z=-109)
    translate([0, 0, -wire_center_spacing])
      color("gray")
        rotate([0, 90, 0]) cylinder(d=wire_diameter, h=250, center=true);
  }
}

module icrate_mount() {
  // ONLY THE MOUNT IS ROTATED TO ALIGN WITH THE XZ PLANE
  rotate([0, 0, 0])
    linear_extrude(thickness, center=true) {
      difference() {
        // Main Trapezoid Profile
        polygon(
          [
            [-spread / 2, 0],
            [spread / 2, 0],
            [bottom_width / 2, -height],
            [-bottom_width / 2, -height],
          ]
        );

        // Wire Hook Cutouts
        translate([-spread / 2, 0]) circle(d=wire_diameter);
        translate([spread / 2, 0]) circle(d=wire_diameter);
      }
    }
}

// --- Render ---
// The mock is called directly without global rotation.
cage_mock();

// The mount contains its own internal rotation to match the XZ plane.
color("orange") icrate_mount();
