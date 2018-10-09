$fn = 100;

enclosure_size = 54;
enclosure_thickness = 2;
enclosure_height = 6.8;
enclosure_radius = 3;
clasp_thickness = 0.8;
clasp_height = 1.2; // PCB thickness should be 1.2mm
screw_size = 1.8;

inner_size = enclosure_size - enclosure_thickness*2;
ett = enclosure_thickness - clasp_thickness;
center_position = enclosure_size / 2;

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
      radius=2.5,
      $fn=4);
  }
}

module screw() {
  top = 5;
  width = 4;
  z = 3.7;
  translate([center_position, center_position]) // centerize
  for (i=[-1:2:1]) for (j=[-1:2:1]) {
    translate([
      (inner_size/2 - top/2)*i,
      (inner_size/2 - 11)*j,
      enclosure_height - z/2
    ])
    difference() {
      union() {
        translate([i * top / 4, 0, 0])
          cube([top / 2, width, z], center=true);
        cylinder(h=z, r=width / 2, center=true);
      }
      cylinder(h=z+2, r=screw_size/2, center=true);
    }
  }
}

difference() {
  union() {
    enclosure();
    difference() {
      translate([ett, ett, enclosure_height])
      roundedCube(
        enclosure_size - ett * 2,
        enclosure_size - ett * 2,
        clasp_height,
        radius = 2.7);
      translate([2, 2, enclosure_height - 1])
      roundedCube(
        inner_size,
        inner_size,
        clasp_height + 2,
        radius = 2.8);
      translate([
        enclosure_size/2,
        enclosure_size/2,
        enclosure_height + 0.7]) {
        cube([
            enclosure_size+20,
            enclosure_size-2-10*2,
            clasp_height
          ],
          center=true);
        cube([
            enclosure_size-2-6.5*2,
            enclosure_size+20,
            clasp_height
          ],
          center=true);
      }
    }
    screw();
  }
  translate([0,0,-7]) difference() {
    translate([ett,ett,enclosure_height])
      roundedCube(
        enclosure_size-ett*2,
        enclosure_size-ett*2,
        clasp_height,
        radius=2.7);
    translate([
      enclosure_size/2,
      enclosure_size/2,
      enclosure_height+0.7 ]) {
      cube([
          enclosure_size+20,
          enclosure_size-2-10*2,
          clasp_height
        ],
        center=true);
      cube([
          enclosure_size-2-6.5*2,
          enclosure_size+20,
          clasp_height
        ],
        center=true);
    }
  };
  translate([9,-1,-1]) cube([6,4,2]);
}