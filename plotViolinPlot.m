function plotViolinPlot(data1, data2)
    % Crear un violin plot para los dos conjuntos de datos
    figure;
    hold on;
    
    % Dibujar violines para el primer conjunto de datos
    h1 = violinplot(data1, 'ViolinColor', [0.5 0.5 1], 'ShowData', false);
    
    % Dibujar violines para el segundo conjunto de datos
    h2 = violinplot(data2, 'ViolinColor', [1 0.5 0.5], 'ShowData', false);
    
    % Personalizar la apariencia del violin plot
    xlabel('Grupos');
    ylabel('Valores');
    title('Violin Plot de Dos Conjuntos de Datos');
    set(gca, 'XTick', [1 2], 'XTickLabel', {'Data1', 'Data2'});
    legend([h1{1}, h2{1}], {'Data1', 'Data2'});
    
    hold off;
end

