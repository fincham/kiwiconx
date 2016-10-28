$fn = 100;

// dish top         
difference() {
        cylinder(r=22, h=4, $fn=12); // dish itself
        translate([0, 0, -0.001])
        ring_holder();
        cylinder(r=7.18+1.15+0.18, h=20); 
    
}

translate([0, 0, 4])
difference() {
        cylinder(r=22, h=1, $fn=12); // dish itself
        translate([0, 0, -0.001])
            cylinder(r=20, h=2, $fn=12); // dish itself
    
}
/*
difference() {
    cylinder(r=7.18+1.15+1+0.18, h=3.6); 
    translate([0, 0, -0.001])    {
        cylinder(r=7.18+1.15+0.18, h=20); 
        translate([-5, -25, 0])
            cube([10, 50, 10]);    }
}
*/
module ring_holder() {
        cylinder(r=18.68+1.15, h=3.5);


}

difference() {
translate([0, 0, 3.5])
intersection() {
import("nlgm-ring-diffuser2.stl");
        cylinder(r=22, h=4.5, $fn=12); // dish itself
}

        cylinder(r=7.18+1.15+0.18, h=20); 

translate([0, 0, 5])
cylinder(r=50, h=20);
}

translate([0, 0, 3.5])
difference() {
    cylinder(r=7.18+1.15+1+0.18+1, h=1.5); 
    translate([0, 0, -0.001])  
        cylinder(r=7.18+1.15+0.18, h=20); 
    }
    