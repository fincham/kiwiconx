$fn = 100;

difference() {
translate([40, 0, 0])
    cylinder(r=4, h=2);
    
translate([28, 0, -1])
scale([2, 1, 1])
rotate([0, 0, 45])     
    cube([10, 10, 10], center=true);


}

translate([35, 0, 0.25/2])
    cube([10, 8, 0.25], center=true);

translate([40, 0, 0.25/2])
    cube([4.5, 4, 0.25], center=true);