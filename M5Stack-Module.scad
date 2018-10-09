$fn = 100;

outer_size = 54;
thickness = 2;
inner_size = outer_size - thickness*2;
height = 6.7;
hole_size = 3;
edge_height = 1.3;

module roundedCube(x, y, z, radius=0) {
  translate([radius,radius,0]) minkowski() {
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
    roundedCube(outer_size, outer_size, height, radius=3);
    translate([thickness, thickness, -1])
      roundedCube(inner_size, inner_size, height+2, radius=2.5, $fn=4);
  }
}

module screw() {
  top = 5;
  width = 4;
  z = 3.7;
  translate([outer_size / 2, outer_size / 2])
  for (i=[-1:2:1]) for (j=[-1:2:1]) {
    translate([(inner_size/2-top/2)*i, (inner_size/2-9)*j, height-z/2])
    difference() {
      union() {
        translate([i*top/4,0,0]) cube([top/2,width,z], center=true);
        cylinder(h=z, r=width/2, center=true);
      }
      cylinder(h=z+2, r=1, center=true);
    }
  }
}

edge_thickness = 0.8;
ett = thickness-edge_thickness;

difference() {
  union() {
    enclosure();
    difference() {
      translate([ett,ett,height]) roundedCube(
        outer_size-ett*2, outer_size-ett*2, edge_height, radius=2.7);
      translate([2,2,height-1]) roundedCube(inner_size, inner_size, edge_height+2, 2.8);
      translate([outer_size/2,outer_size/2,height+0.7]) {
        cube([outer_size+20, outer_size-2-10*2, edge_height], center=true);
        cube([outer_size-2-6.5*2, outer_size+20, edge_height], center=true);
      }
    }
    screw();
  }
  translate([0,0,-7]) difference() {
    translate([ett,ett,height]) roundedCube(outer_size-ett*2, outer_size-ett*2, edge_height, radius=2.7);
    translate([outer_size/2,outer_size/2,height+0.7]) {
      cube([outer_size+20, outer_size-2-10*2, edge_height], center=true);
      cube([outer_size-2-6.5*2, outer_size+20, edge_height], center=true);
    }
  };
  translate([9,-1,-1]) cube([6,4,2]);
}