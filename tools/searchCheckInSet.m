function ta = searchCheckInSet(checkInSet,tagId,antenna);

for ta = 1:length(checkInSet)
   if(antenna == checkInSet(ta).antenna)
        if(strcmp(tagId,checkInSet(ta).tagId))
            break;
        end
   end
    
end