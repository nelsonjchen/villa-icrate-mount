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

// --- Wire Constants ---
horiz_wire_y = wire_diameter / 2 + 2;
vert_wire_y = wire_diameter * 2;

$fn = 60;

// !!! DO NOT TOUCH THE MOCK BELOW. KEEP OBSERVING IT. !!!
// !!! THE MOCK IS STATIC IN THE XZ PLANE. !!!
// !!! DO NOT CHANGE THESE CYLINDERS. !!!
module cage_mock() {
  %union() {
    cage_wires();
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
module horiz_wire() {
  color("gray")
    rotate([0, 90, 0])
      cylinder(d=wire_diameter, h=250, center=true);
}

module vert_wire() {
  color("gray")
    cylinder(d=wire_diameter, h=250, center=true);
}

module cage_wires() {
  // Top Wire (Along X, at Z=0)
  back(horiz_wire_y)
    horiz_wire();

  // Wire in front, also 4mm, just crossing
  back(vert_wire_y)
    vert_wire();
}

module icrate_mount() {
  // ONLY THE MOUNT IS ROTATED TO ALIGN WITH THE XZ PLANE

  difference() {
    down(4)
      cuboid([10, 113, 8], anchor=BOTTOM+FRONT, rounding=2) show_anchors();

    hull() {
      back(horiz_wire_y)
        horiz_wire();
      back(horiz_wire_y)
        down(10)
          horiz_wire();
    }

    hull() {
      back(vert_wire_y)
        vert_wire();
      fwd(vert_wire_y)
        vert_wire();
    }
  }
}

// --- Render ---
// The mock is called directly without global rotation.
cage_mock();

// The mount contains its own internal rotation to match the XZ plane.
icrate_mount();
