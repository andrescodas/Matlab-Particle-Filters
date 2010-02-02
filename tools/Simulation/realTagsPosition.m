function tags = realTagsPosition(simulation)

tag = struct('tagId','32432frdes','position',[0 0]);
tags = repmat(tag,1,7);

if(simulation)

    tags(1) = struct('tagId','a','position',[ -4.07,	   -1  ]);
    tags(2) = struct('tagId','b','position',[ -4.07,    1.84]);
    tags(3) = struct('tagId','c','position',[	 3,	   1.5 ]);
    tags(4) = struct('tagId','d','position',[  00.50,   3.55]);
    tags(5) = struct('tagId','e','position',[  01.50, +00.50]);
    tags(6) = struct('tagId','f','position',[ +02.50, -03.00]);
    tags(7) = struct('tagId','g','position',[ -0.84, -03.27]);


else

    tags(1) = struct('tagId','e0040000c1b2fd01','position',[ -4.07,	   -1  ]);
    tags(2) = struct('tagId','e00400007cd7fc01','position',[ -4.07,    1.84]);
    tags(3) = struct('tagId','e0040000079efd01','position',[	 3,	   1.5 ]);
    tags(4) = struct('tagId','e004000076defc01','position',[  00.50,   3.55]);
    tags(5) = struct('tagId','e0040000dab1fd01','position',[  01.50, +00.50]);
    tags(6) = struct('tagId','e0040000fa9afd01','position',[ +02.50, -03.00]);
    tags(7) = struct('tagId','e004000080ddfc01','position',[ -0.84, -03.27]);

end
