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

thickness = 10;
spread = 120; // Distance between hooks
height = 60; // How far it hangs down (along Z)
bottom_width = 40; // Width of the bottom edge
bolt_spacing = 52; // Distance between bolt holes
bolt_diameter = 4.4; // M4 clearance
bolt_height = 80; // Vertical distance from top wire to center of bolts

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

// --- Derived Dimensions ---
hook_thickness = 4;
wire_offset_y = horiz_wire_y;

module wire_cutouts() {
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

module vertical_mount_plate() {
  // Calculated Center from original relative transforms:
  // Z top was 6. Z center = 6 - mount_height/2.
  // Y front was (arm_length - 2 - thickness/2). Y center = Y_front + thickness/2 = arm_length - 2.

  translate([0, arm_length - 2, 6 - mount_height / 2])
    cuboid([mount_width, thickness, mount_height], anchor=CENTER, rounding=2);
}

module horizontal_arm_bar() {
  // Calculated Center from original relative transforms:
  // Z bottom was -4. Height 10. Z center = -4 + 10/2 = 1.
  // Y front was -4. Length arm_length+4. Y center = -4 + (arm_length+4)/2 = arm_length/2 - 2.

  translate([0, arm_length / 2 - 2, 1])
    cuboid([mount_width, arm_length + 4, 10], anchor=CENTER, rounding=2);
}

module gusset() {
  // Preserving the user's "hax" adjustment exactly:
  // Original Base: [0, arm_length - 2 - thickness/2, -4]
  // Adjustment: up(2) back(2) -> [+0, +2, +2]
  // Final Pos:
  // X = 0
  // Y = (arm_length - 2 - thickness/2) + 2 = arm_length - thickness/2
  // Z = -4 + 2 = -2

  translate([0, arm_length - thickness / 2, -2])
    rotate([180, 0, 0])
      wedge([mount_width, 15, 15], anchor=FRONT + BOTTOM);
}

module hook_feature() {
  translate([0, 8, -10])
    cuboid([8, 8, 20], anchor=CENTER, rounding=2);
}

module mount_body() {
  vertical_mount_plate();
  horizontal_arm_bar();
  gusset();
  hook_feature();

  // Text "PETG"
  // Original: translate([mount_width / 2, arm_length - 2, -bolt_height])
  translate([mount_width / 2, arm_length - 2, -bolt_height])
    rotate([90, 90, 90])
      fwd(4)
        text3d("PETG", h=1, size=6, anchor=CENTER);
}

module icrate_mount() {
  difference() {
    mount_body();

    // Wire Cutouts
    wire_cutouts();

    // Bolt Holes
    for (z_dir = [-1, 1]) {
      translate([0, arm_length - 2, -bolt_height + z_dir * bolt_spacing / 2])
        rotate([90, 0, 0])
          cylinder(h=thickness + 10, d=bolt_diameter, center=true);
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
