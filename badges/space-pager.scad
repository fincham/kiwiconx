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
    
translate([-11, 3, -13])
cube([9, 38, 14]);    


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
            cylinder(r=2.75/2, h=12);        
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

  

difference() {
difference() {
translate([-11, 2, -11])
cube([10, 40, 13]);
    translate([0, 0, -0.001])
    box();
    
}

translate([-9.5, 3, -12])
cube([8, 38, 13]); 


// switch hole
translate([-12, 3, -7])
cube([10, 16.8, 7.1]);


// power hole
translate([-12, 26, -6])
cube([10, 10, 4.4]);
}




translate([-11, 3, -11])
cube([2, 38, 4]);


translate([-11, 3, -11])
cube([2, 38, 4]);



// shelf
intersection() {
translate([-9, -9, -7.8])
cube([10, 61, 0.5+0.3]);
box();
}

/*
translate([20, -8.5, -7.8])
cube([20, 60.5, 0.5+0.3]);
*/

// snap away shelf supports
translate([1, 20.5, -11])
cylinder(r=1,h=3.5-0.3);
translate([1, 20.5, -11])
cylinder(r=3,h=0.5-0.3);
/*
translate([20, 20.5, -11])
cylinder(r=1,h=3.5-0.3);
translate([20, 20.5, -11])
cylinder(r=3,h=0.5);

translate([40, 20.5, -11])
cylinder(r=1,h=3.5-0.3);
translate([40, 20.5, -11])
cylinder(r=3,h=0.5);
*/

// heat stakes for the charger
module charger() {
    translate([0, 0.5, 0])
        cylinder(r=0.9, h=3.5);

    translate([0, 15, 0])
        cylinder(r=0.9, h=3.5);

}

translate([-7, 23.5, -7.8])

charger();
