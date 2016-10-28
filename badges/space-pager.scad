include <circuit.scad>;

$fn = 100;


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

module corner_mounted(height, width, h, radius) {
    difference() {
        cube([height, width, h]);
        
        translate([0, 0, -0.1]) {
            translate([radius, radius, 0])
                cylinder(r=radius, h=h+0.2);
            translate([height-radius, width-radius, 0])
                cylinder(r=radius, h=h+0.2);    
            translate([radius, width-radius, 0])
                cylinder(r=radius, h=h+0.2);       
            translate([height-radius, radius, 0])
                cylinder(r=radius, h=h+0.2);
        }
    }   
}

module screw(h) {
    difference() {
        cylinder(r=2.5, h=h);
        translate([0, 0, -0.1])
            cylinder(r=2.85/2, h=h+1);         
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

// top plate 
/*
translate([-3.55, -3.2, 4])
difference() {
    rounded_box(60, 50, 1, 3.5);
    translate([7.8, 4.8, 0])
        cube([34.4, 40.4, 5]);
    
translate([55+3.55, 3.2, 3])
rotate([0, 180, 0])
    switch_box();

translate([55+3.55, 33.6+3.2, 3])
rotate([0, 180, 0])
    switch_box();   
}

translate([1.5, 1.5, 1])
    screw(3);
translate([42.9-3+1.5, 1.5, 1])
    screw(4);
translate([42.9-3+1.5, 43.6-3+1.5, 1])
    screw(4);
translate([1.5, 43.6-3+1.5, 1])
    screw(4);

translate([55, 0, 5])
rotate([0, 180, 0])
    switch();

translate([55, 43.6-10, 5])
rotate([0, 180, 0])
    switch(); */

module box() {
    // the box
    hull() {
    translate([-3.55, -3.2, 5])
        rounded_box(60, 50, 0.1, 3.5);
        
    translate([-3.55-7.5, -3.2-7.5, -11])
        rounded_box(60+15, 50+15, 0.1, 3.5);
    }
}

module cutout() {
scale([2, 1, 1])
rotate([65, 0, 0])
rotate([0 ,0, 90])
circuit(5);        
}

difference() {
    difference() {
        box();
        translate([-100, -100, 3])
        cube([200,200,10]);
        
   
    }
    translate([0, 0, -4])
    box();

translate([-3.55, -3.2, 0])

    rounded_box(60, 50, 50, 3.5);

    
translate([25, -5.3, 0])
    cutout();

translate([58.4, 20, 0])
rotate([0, 0, 90])
    cutout();
    
translate([25, 49, 0])
rotate([0, 0, 180])
    cutout();

}




/*
difference() {
intersection() {
translate([-100, -100, 1.5])

    rounded_box(200, 200, 4, 3.5);
    
    box();
}    

translate([-3.55, -3.2, -1])
    rounded_box(60, 50, 50, 3.5);

}*/

// screw posts
module screw_post () {
    difference() {
        cylinder(r=4, h=12);

        translate([0, 0, -0.1])
            cylinder(r=2.85/2, h=12);        
    }
}

intersection() {
        box();
    
    union(){
translate([-3.55-2,-3.2-2, -11])
screw_post();

    
translate([-3.55-2+60+4,-3.2-2, -11])
screw_post();
        
        translate([-3.55-2+60+4,-3.2-2+50+4, -11])
screw_post();
        
                translate([-3.55-2,-3.2-2+50+4, -11])
screw_post();
        
        }
    
}