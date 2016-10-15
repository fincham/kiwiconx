

$fn = 100;

difference() {
    cylinder(r=2.25, h=6);

    translate([0, 0, -1])
        cylinder(r=2.55/2, h=10);
}

translate([10, 0, 0])
difference() {
    cylinder(r=2.25, h=6);
    
    translate([0, 0, -1])
        cylinder(r=2.65/2, h=10);
}

translate([20, 0, 0])
difference() {
    cylinder(r=2.25, h=6);
    
    translate([0, 0, -1])
        cylinder(r=2.75/2, h=10);
}

difference() {
translate([-5, -5, 0])
    cube([30, 15, 2]);
    
    translate([20, 5, -1])
        cylinder(r=2.55/2, h=10);
    
    translate([10, 5, -1])
        cylinder(r=2.65/2, h=10);
    
    translate([0, 5, -1])
        cylinder(r=2.75/2, h=10);

    translate([-5.1, 5.1, -1])
        cube([2, 5, 4]);
}

