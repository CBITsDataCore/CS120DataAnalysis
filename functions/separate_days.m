% This function breaks data into separate days.
% Data must be in table format.
% The first column is Unix timestamps in ascending order, and the rest are
% attribute values.

function [out, jour, stats] = separate_days(data, extract_stats)

if ~istable(data),
    error('Data must be in table format.');
end

time = data.Var1;

if isempty(time),
    error('Table contains no data');
end

sd = 86400; % seconds in a day

date_start = floor(data.Var1(1)/sd);
date_end = floor(data.Var1(end)/sd);
jour = date_start:date_end;

out = cell(length(jour),1);
stats = cell(length(jour),1);

cnt = 0;
for d = jour,
    
    cnt = cnt+1;
    %out.date{cnt} = datestr(d + datenum(1970,1,1), 6);
    ind_rng = find(time>=d*sd,1,'first'):find(time<=(d+1)*sd,1,'last');
    
    if ~isempty(ind_rng)
        
        out{cnt} = data(ind_rng, :);
        
        if extract_stats,
            stats{cnt}.samplingduration = sd/length(ind_rng);
            stats{cnt}.maxgap(cnt) = max(diff([d*sd;time(ind_rng);(d+1)*sd]));
        end
        
    else
        
        out{cnt} = [];
        stats{cnt} = [];
        
    end
end

end