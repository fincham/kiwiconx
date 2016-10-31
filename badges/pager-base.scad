$fn = 100;

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

module screw_post () {
    difference() {
        cylinder(r=4, h=2.5);

        translate([0, 0, -0.1])
            cylinder(r=3/2, h=4);        
    }
}

module posted_screw_hole(where) {
        difference() {
            translate([where, 0, 0])
                cylinder(r=3/2+1, h=3.5); 
            translate([where, 0, -1])
                cylinder(r=2.75/2, h=5);       
        }
}

difference() {
    translate([-0.5, -0.5, 0])
    rounded_box(60+15, 50+15, 3.5, 3.5);
    translate([1.5,1.5,1])
        rounded_box(60+14.5-4, 50+15-4, 3, 3.5); 
    
translate([2.5, 32-9, -2])
        cylinder(r=1.5,h=10);
        
translate([2.5, 32+9, -2])
        cylinder(r=1.5,h=10);


    
translate([2.5+69, 32-9, -2])
        cylinder(r=1.5,h=10);
        
translate([2.5+69, 32+9, -2])
        cylinder(r=1.5,h=10);


translate([-3.55-2+10,-3.2-2+10, -1])
        cylinder(r=1.5,h=10);

    
translate([-3.55-2+60+4+10,-3.2-2+10, -1])
        cylinder(r=1.5,h=10);
        
        translate([-3.55-2+60+4+10,-3.2-2+50+4+10,-1])
        cylinder(r=1.5,h=10);
        
                translate([-3.55-2+10,-3.2-2+50+4+10, -1])
        cylinder(r=1.5,h=10);
        
translate([-3.55-2+10,-3.2-2+10, -1])
        cylinder(r=2.5,h=10);

    
translate([-3.55-2+60+4+10,-3.2-2+10, -1])
        cylinder(r=2.5,h=10);
        
        translate([-3.55-2+60+4+10,-3.2-2+50+4+10,-1])
        cylinder(r=2.5,h=10);
        
                translate([-3.55-2+10,-3.2-2+50+4+10, -1])
        cylinder(r=2.5,h=10);
                
         
}

translate([10, 10 ,1])
    union(){
translate([-3.55-2,-3.2-2, 0])
screw_post();

    
translate([-3.55-2+60+4,-3.2-2, 0])
screw_post();
        
        translate([-3.55-2+60+4,-3.2-2+50+4,0])
screw_post();
        
                translate([-3.55-2,-3.2-2+50+4, 0])
screw_post();
        
        
        
        }


        
translate([2.5, 32-8.5, 0])
        posted_screw_hole();
        
translate([2.5, 32+9, 0])
        posted_screw_hole();        
        
translate([2.5+69, 32-8.5, 0])
        posted_screw_hole();
        
translate([2.5+69, 32+9, 0])
        posted_screw_hole();                