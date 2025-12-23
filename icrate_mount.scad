include <BOSL2/std.scad>
// 

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
    cage_wire();
  }
}

module camera_sim(total_h = 103, dia = 117) {

  // Calculate cylinder length
  cyl_h = total_h - (dia / 2);

  // Rotate so it hangs down like a ceiling mount (Dome at bottom)
  rotate([180, 0, 0])
    intersection() {
      union() {
        // 1. The Cylinder Body
        cylinder(d=dia, h=cyl_h);

        // 2. The Dome (Centered at 0, sticking down)
        sphere(d=dia);
      }

      // 3. The "Chopper" 
      // A big box that allows the bottom dome to exist 
      // but cuts off anything sticking out the back (top).
      // It goes from -Radius (bottom of dome) to Cylinder Height.
      translate([0, 0, -dia])
        cylinder(d=dia, h=dia + cyl_h);
    }
}

// !!! DO NOT TOUCH THE WIRE BELOW. KEEP OBSERVING IT. !!!
// !!! THE WIRE IS STATIC IN THE XZ PLANE. !!!
// !!! DO NOT CHANGE THESE CYLINDERS. !!!
module cage_wire() {
  // Top Wire (Along X, at Z=0)
  translate([0, wire_diameter / 2, 0])
    color("gray")
      rotate([0, 90, 0])
        cylinder(d=wire_diameter, h=250, center=true);

  // Bottom Wire (Along X, at Z=-109)
  translate([0, wire_diameter / 2, -wire_center_spacing])
    rotate([0, 90, 0])
      color("gray")
        cylinder(d=wire_diameter, h=250, center=true);
}

module icrate_mount() {
  // ONLY THE MOUNT IS ROTATED TO ALIGN WITH THE XZ PLANE
  difference() {
    rotate([0, 0, 0])
      linear_extrude(thickness, center=true)
        trapezoid(h=height, w1=spread, w2=bottom_width, anchor=FRONT);

    // Cut out an wire extruded down 8mm
    translate([0, 0, 0])
      linear_extrude(8, center=true) {
        cage_wire();
      }
  }
}

// --- Render ---
// The mock is called directly without global rotation.
cage_mock();

// The mount contains its own internal rotation to match the XZ plane.
color("orange") icrate_mount();
