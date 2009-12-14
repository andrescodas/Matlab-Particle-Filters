function k = searchTag(tags,tagId)
%
% function k = searchTag(tags,tagId)
%

for k = 1:length(tags)

    if(strcmp(tags(k).tagId,tagId))
        return
    end
    
end

 k = 0;