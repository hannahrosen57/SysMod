NE = [1, 2, 4, 8, 16];

for i = 1:length(NE)
    MESH(i) = OneDimLinearMeshGen(0, 1, NE(i));
    displayMesh(MESH(i));
    saveas(gcf, strcat("OneDimMesh", num2str(NE(i)), "Elem"), "jpeg");
    % pause(1);
end