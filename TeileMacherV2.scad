//TeileMacher V2
$fn=50;
xCOff=5;

module profile(hole=false) {
    import("dxf/profile.dxf");
    if(hole==false)circle(r=2.5);
}
module zMotorRaw() {
    for(i=[0,30])translate([i,0])circle(r=2.5);
    translate([-31,0])rotate(a=[0,0,90])motor(screw_i=true,hole=true);
}
module zMotor() {
    difference() {
        offset(r=10)hull()zMotorRaw();
        zMotorRaw();
    }
}
module xCarriageRaw(nut=false,face=false,motor=true,side=false) {
    offset(r=-0.1)profile();
    translate([-34,0]) {
        circle(r=2.5);
        if(motor==true)rotate(a=[0,0,90]) {
            motor(screw_i=true,hole=true);
            if(face==true)motor(face=true);
        }
    }  
    translate([31.5,0]){
        circle(r=2.5);
        if(nut==true)circle(r=5*0.9,$fn=6);
    }
    if(side==true)tr_xy(x=40,y=15)circle(r=1.5);
    if(side==false)translate([-10,0])tr_xy(x=50,y=20)circle(r=1.5);
}
module xCarriage1() {
    difference() {
        offset(r=xCOff)hull()xCarriageRaw(face=true);
        xCarriageRaw();
    }   
}
module xCarriage2() {
    difference() {
        offset(r=xCOff)hull()xCarriageRaw(face=true);
        xCarriageRaw(face=true,nut=true);
    }   
}
module xCarriage3() {
    difference() {
        offset(r=xCOff)hull()xCarriageRaw(face=true);
        xCarriageRaw(face=true);
    }   
}
module xCarriage4() {
    difference() {
        offset(r=xCOff)hull()xCarriageRaw(motor=false,side=true);
        xCarriageRaw(motor=false,side=true);
    }   
}
module xCarriage5() {
    difference() {
        offset(r=xCOff)hull()xCarriageRaw(motor=false,side=true);
        xCarriageRaw(motor=false,nut=true,side=true);
    }   
}
module angle(profileSize=20,length=60,holeRadius=2.5,number=1) {
i=profileSize/2;
j=length-profileSize/2;
	difference() {
		hull()union() {
			square([profileSize,length]);
			square([length,profileSize]);
		}
		for(k=[i:((j-i)/number):(j+((j-i)/number))])translate([k,i])circle(r=holeRadius);
		for(k=[i:((j-i)/(number+1)):(j+((j-i)/(number+1)))])translate([i,k])circle(r=holeRadius);
	}
}
    
module motor(face,cable,screw_e,screw_i,hole,screw_d,screws,rod,a=1) {	
	if (face==true) square(42.5,center=true);
	if (cable==true) translate([21+5,0])square(10,center=true);
	if (screw_e==true) for(x=[1:4])rotate(a=[0,0,x*90])translate([26,26])circle(r=1.5);
	if (screw_i==true) for(x=[15.5,-15.5])for(y=[-15.5,15.5])translate([x,y])slot_hole(r=1.5,d=a);
	if (hole==true) circle(r=11);
	if (rod==true) circle(r=4);
	if (screws==true) for(x=[1:4])rotate(a=[0,0,x*90])translate([screw_d,screw_d])circle(r=1.5);
}
module slot_hole(r,d) {
	hull() {
		for(i=[-1,1])translate([0,i*d])circle(r=r);
	}
}
module tr_xy(x,y=0) {
	if(y==0) {
		for(i=[-1,1])for(j=[-1,1])translate([x*i,x*j])children();
	} else {
		for(i=[-1,1])for(j=[-1,1])translate([x*i,y*j])children();
	}
}

zMotor(); //2
xCarriage1(); //1
xCarriage2(); //2
xCarriage3(); //1
xCarriage4(); //2
xCarriage5(); //2
!angle();