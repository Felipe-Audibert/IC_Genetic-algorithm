function[] = save_figures(EDFA,Storage_Pop,Storage_Diff)

Vec_Pin = [0.43 0.68 1 4.01 14]*1e-3;

for Pin = Vec_Pin
[line col] = find(Storage_Diff(:,:,find(Vec_Pin==Pin))==min(min(Storage_Diff(:,:,find(Vec_Pin==Pin)))));
cascateado_dudu(EDFA, Pin, Storage_Pop(line,1,col,find(Vec_Pin==Pin)), Storage_Pop(line,2,col,find(Vec_Pin==Pin)),0,1);
end