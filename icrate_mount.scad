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
bolt_spacing = 52; // Distance between bolt holes
bolt_diameter = 4.4; // M4 clearance
bolt_height = 70; // Vertical distance from top wire to center of bolts

// --- Parameterized Dimensions ---
arm_length = 125;
mount_width = 10;
strip_margin = 10;
mount_height = (bolt_height + bolt_spacing / 2 + strip_margin) + 4; // Top of arm is at Z=4

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

module camera_sim(total_h = 104, dia = 120) {

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

  // Part with mount
  difference() {
    down(mount_height - 4)
      back(arm_length - 2 - thickness / 2)
        cuboid([mount_width, thickness, mount_height], anchor=BOTTOM + FRONT, rounding=2);

    // Cut out two holes for bolts
    for (z_dir = [-1, 1]) {
      translate([0, arm_length - 2, -bolt_height + z_dir * bolt_spacing / 2])

        rotate([90, 0, 0])
          cylinder(h=thickness + 2, d=bolt_diameter, center=true);
    }
  }

  difference() {
    down(4)
      cuboid([mount_width, arm_length, 8], anchor=BOTTOM + FRONT, rounding=2) down(4) right(-2.5) rotate([180, 0, 90]) text3d("PLA", h=1, anchor=LEFT, size=5);

    
    hull() {
      back(horiz_wire_y)
        horiz_wire();
      back(horiz_wire_y)
        down(mount_height) // Ensure cut is deep enough
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

// Camera Simulator for clearance check
camera_cyl_h = 104 - 120 / 2; // 44
%translate([0, arm_length - 2 - camera_cyl_h, -bolt_height])

  rotate([90, 0, 0])
    camera_sim();
