result = zeros(1,6);
% error = [0.0,0.0,0.0];
for i = 1:30
    testComputeUij;
    error = (max(abs(s1))-max(abs(s2)))
    for n=1:6
        if abs(error(:,n))>abs(result(:,n));
            result(:,n) = abs(error(:,n));
        end
    end
end
result

% result = [0.0,0.0,0.0];
% temp = [0.0,0.0,0.0];
% for i = 1:3
%     testComputeT;
%     temp = max(err);
%     for n=1:3
%         if (temp(n)^2)>(result(n)^2);
%             result(n) = temp(n);
%         end
%     end
% end
% result