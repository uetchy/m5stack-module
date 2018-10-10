$fn = 100;

build_bottom_plate = false;
enclosure_height = 6.8;
// enclosure_height = 15;
enclosure_size = 54;
enclosure_thickness = 2;
enclosure_radius = 5;
inner_radius = 2.5;
clasp_radius = 3;
clasp_thickness = 0.8;
clasp_height = 1.2; // PCB thickness should be 1.2mm
screw_size = 1.8;

inner_size = enclosure_size - enclosure_thickness*2;
etct = enclosure_thickness - clasp_thickness;
center_position = enclosure_size / 2;
spacer = 20;
clasp_long = 10;
clasp_short = 6.5;

module roundedCube(x, y, z, radius=0) {
  translate([radius,radius,0])
  minkowski() {
    cube([
      x-(radius*2),
      y-(radius*2),
      z-0.1
    ]);
    cylinder(r=radius, h=0.1);
  }
}

module enclosure() {
  difference() {
    roundedCube(
      enclosure_size,
      enclosure_size,
      enclosure_height,
      radius=enclosure_radius);
    translate([enclosure_thickness, enclosure_thickness, -1])
    roundedCube(inner_size,
      inner_size,
      enclosure_height+2,
      radius=inner_radius,
      $fn=4);
  }
}

module screw() {
  top = 5;
  width = 4;
  z = 3.8;
  distance_from_edge = 9;
  translate([
    center_position,
    center_position - width/2]) // centerize
  for (i=[-1:2:1]) for (j=[-1:2:1]) {
    translate([ // centerize
      (inner_size/2 - top/2) * i,
      (inner_size/2 - distance_from_edge - 2) * j,
      enclosure_height - z
    ])
    difference() {
      union() {
        translate([i * top/2/2, width/2, z/2])
          cube([top / 2, width, z], center=true);
        translate([0, 2, 0]) cylinder(h=z, r=width / 2);
      }
      translate([0, 2, -1]) cylinder(h=z+2, r=screw_size/2);
    }
  }
}

difference() {
  union() {
    enclosure();
    difference() {
      color("yellow") translate([etct, etct, enclosure_height])
        roundedCube(
          enclosure_size - etct * 2,
          enclosure_size - etct * 2,
          clasp_height,
          radius = clasp_radius);
      translate([2, 2, enclosure_height - 1])
        roundedCube(
          inner_size,
          inner_size,
          clasp_height + 2,
          radius = inner_radius, $fn=4);
      translate([
        center_position,
        center_position,
        enclosure_height + 0.7]) {
        cube([
            enclosure_size + spacer,
            enclosure_size-2-10*2,
            clasp_height
          ],
          center=true);
        cube([
            enclosure_size - 2 - clasp_short * 2,
            enclosure_size + spacer,
            clasp_height
          ],
          center=true);
      }
    }
    screw();
  }
  if (!build_bottom_plate) {
    translate([0, 0, 0]) color("red") difference() { // bottom clasp
      translate([etct, etct, -1])
        roundedCube(
          enclosure_size - etct * 2,
          enclosure_size - etct * 2,
          clasp_height+1,
          radius=clasp_radius);
      translate([ // centerize
        center_position,
        center_position,
        clasp_height/2]) {
        cube([
            enclosure_size + spacer,
            enclosure_size - enclosure_thickness - clasp_long*2,
            clasp_height
          ],
          center=true);
        cube([
            enclosure_size - enclosure_thickness - clasp_short*2,
            enclosure_size + spacer,
            clasp_height
          ],
          center=true);
      }
    }
    translate([9,-1,-1]) cube([6,4,2]); // opener hole
  }
  
}

if (build_bottom_plate) {
  translate([0, 0, 0]) color("blue") difference() { // bottom clasp
    translate([enclosure_thickness, enclosure_thickness, 0])
      cube([
        inner_size,
        inner_size,
        clasp_height
      ]);
  }
}