clc;
clear all;
close all;

% Defino una matriz distancias para representar distancia entre todos los nodos
distancias = [ 
    4 10 15 20 45 4 9 74 7 85;
    10 45 35 25 45 7 10 12 54 7;
    15 35 0 30 31 4 32 10 47 4;
    20 25 30 0 74 7 10 14 12 41;
    10 51 41 7 78 87 12 10 10 36;
    35 45 40 40 74 74 47 41 12 10;
    45 10 5 7 4 2 1 74 12 1;
    87 74 4 57 7 41 41 41 12 10;
    12 78 74 74 85 21 32 54 45 7;
    21 45 78 41 2 5 45 4 78 4;
]

[ruta_optima, costo_optimo] = tsp_fuerza_bruta(distancias); % función fuerza bruta

% Mostrar en ventana de comando la ruta optima y el costo mas pequeño en distancia
disp('Ruta óptima:');
disp(ruta_optima);

disp('Costo óptimo:');
disp(costo_optimo);

% % Dibujar la ruta óptima
% figure;
% hold on;
% for i = 1:length(ruta_optima)-1
%     % Dibujar línea entre nodos consecutivos en la ruta óptima
%     plot([ruta_optima(i), ruta_optima(i+1)], [ruta_optima(i), ruta_optima(i+1)], 'bo-');
% end
% plot([ruta_optima(end), ruta_optima(1)], [ruta_optima(end), ruta_optima(1)], 'bo-'); % Conectar el último con el primero
% title('Ruta Óptima');
% xlabel('Coordenada X');
% ylabel('Coordenada Y');
% hold off;

function [ruta_optima, costo_optimo] = tsp_fuerza_bruta(distancias)
    n = size(distancias, 1); % Obtener el numero de nodos
    nodos = 1:n; % Creando el vector de nodos
    
    % Generar todas las permutaciones posibles
    todas_rutas = perms(nodos);
    
    % Calcular el costo de cada ruta y encontrar la óptima
    costo_optimo = inf;
    ruta_optima = [];
    
    % Recorrer cada ruta posible, calcular el costo y actualizar la ruta y el
    % costo si es que es necesario
    for i = 1:size(todas_rutas, 1) 
        ruta_actual = todas_rutas(i, :);
        costo_actual = calcular_costo(distancias, ruta_actual);
        
        if costo_actual < costo_optimo
            costo_optimo = costo_actual;
            ruta_optima = ruta_actual;
        end
    end
end
 
% Función que toma la matriz de distancias y una ruta, y devuelve el costo
% total de la ruta
function costo = calcular_costo(distancias, ruta)
    costo = 0;
    n = length(ruta);
    
    for i = 1:n-1 % Suma las distancias entre nodos consecutivos en la ruta
        costo = costo + distancias(ruta(i), ruta(i+1));
    end
    % Añadir la distancia para regresar al nodo inicial y completar el cálculo
    % del costo total.
    costo = costo + distancias(ruta(end), ruta(1)); % Regresar al nodo inicial
end
