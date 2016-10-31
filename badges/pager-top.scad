$fn = 50;

module screw(h) {
    difference() {
        cylinder(r=2.5, h=h);
        translate([0, 0, -0.1])
            cylinder(r=2.85/2, h=h+1);         
    }
}



module switch() {
    difference() {
        cube([10, 10, 3]);
        
        translate([1.91, 1.91, 0.25])
            cube([6.18, 6.18, 10]);
        
        translate([5, 5, -1])
            cylinder(r=2, h=10);
    }
}


module switch_box() {
        cube([10, 10, 3]);

}

module rounded_box(height, width, h, radius) {
    hull() {
        translate([radius, radius, 0])
            cylinder(r=radius, h=h);
        translate([height-radius, width-radius, 0])
            cylinder(r=radius, h=h);    
        translate([radius, width-radius, 0])
            cylinder(r=radius, h=h);       
        translate([height-radius, radius, 0])
            cylinder(r=radius, h=h);     
    }   
}


// the module
/*
translate([4.3, 1.8, 0])
difference() {
    cube([34, 40, 5]);

    translate([1.22, 2, 4.5])
        rounded_box(26.4, 36, 10, 3.5);
}
*/
/*
translate([0, 0, 0])
corner_mounted(42.9, 43.6, 1.2, 1.5);
*/

// lip
difference() {
translate([-3.55, -3.2, 2])
    translate([-1, -1, 0])
    rounded_box(62, 52, 2, 3.5);

translate([-3.55, -3.2, 1.99])
    rounded_box(60, 50, 10, 3.5);

}

translate([30-5, -3.2, -1])
cube([5, 1.5, 6]);

translate([30-5, 45.3, -1])
cube([5, 1.5, 6]);

translate([-3.55, 30, -1])
cube([1.5, 5, 6]);

translate([-3.55, 10, -1])
cube([1.5, 5, 6]);

translate([55, 20, -1])
cube([1.5, 5, 6]);

// top plate 

translate([-3.55, -3.2, 4])
difference() {
    
    translate([-1, -1, 0])
    rounded_box(62, 52, 1, 3.5);
    translate([7.8, 4.8, 0])
        cube([34.4, 40.4, 5]);
    
translate([55+3.55, 3.2, 3])
rotate([0, 180, 0])
    switch_box();

translate([55+3.55, 33.6+3.2, 3])
rotate([0, 180, 0])
    switch_box();   
}

translate([1.5, 1.5, 0.5])
    screw(4);
translate([42.9-3+1.5, 1.5, 0.5])
    screw(4);
translate([42.9-3+1.5, 43.6-3+1.5, 0.5])
    screw(4);
translate([1.5, 43.6-3+1.5, 0.5])
    screw(4);

translate([55, 0, 5])
rotate([0, 180, 0])
    switch();

translate([55, 43.6-10, 5])
rotate([0, 180, 0])
    switch(); 