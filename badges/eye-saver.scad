$fn = 100;

difference() {
translate([40, 0, 0])
    cylinder(r=4, h=2);
    
translate([28, 0, -1])
scale([2, 1, 1])
rotate([0, 0, 45])     
    cube([10, 10, 10], center=true);


}



translate([31.2, 0, 0.1])
scale([2, 1, 1])
rotate([0, 0, 45])     
    cube([8, 8, 0.2], center=true);