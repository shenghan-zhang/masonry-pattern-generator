itlc = [];
for i = 1:length(int_lock_file)
    temp = int_lock_file{i};
    temp2 = cell2mat(temp);
    temp3 = mean(temp2);
    itlc = [itlc;
            temp3];
end
[B1,I1] = sort(itlc(:,1));
[B2,I2] = sort(itlc(:,2));