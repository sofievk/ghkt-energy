% TEST_LOADPARAMS Compare LoadParams against the original parameter code.
clear
ref_params                          % runs the original code
save('ref_params_values.mat')       % saves all its variables to a file
clear

ref = load('ref_params_values.mat'); % loads them back as ONE struct
p = LoadParams();

names = fieldnames(p);
for k = 1:numel(names)
    nm = names{k};
    if ~isfield(ref, nm)
        fprintf('%-10s only in LoadParams\n', nm);
    elseif isequal(ref.(nm), p.(nm))
        fprintf('%-10s identical\n', nm);
    elseif isequal(size(ref.(nm)), size(p.(nm)))
        fprintf('%-10s DIFFERS, max abs diff %g\n', nm, ...
            max(abs(ref.(nm)(:) - p.(nm)(:))));
    else
        fprintf('%-10s DIFFERENT SIZE\n', nm);
    end
end

disp('In the original but not in LoadParams:')
disp(setdiff(fieldnames(ref), names))