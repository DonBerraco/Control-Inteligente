clc;
clear all;
close all;

% Definir parámetros del algoritmo genético
num_poblacion = 50;         % Tamaño de la población
num_generaciones = 1000;    % Número de generaciones
prob_mutacion = 0.02;       % Probabilidad de mutación

% Definir una matriz de distancias entre nodos
distancias = [
    0 10 15 20 15 12 10 14 0 41;
    10 0 35 25 12 21 12 21 12 4;
    15 35 0 30 10 21 41 1 41 4;
    20 25 30 0 21 0 14 1 2 41;
    32 12 10 0 41 7 8 12 32 12;
    21 12 14 41 7 21 10 0 12 1;
    7 12 11 10 30 0 10 12 4 1;
    7 12 4 10 12 10 32 10 12 2;
    8 12 41 32 10 14 11 21 10 4;
    11 12 0 1 12 33 2 11 14 20;
]

% Inicializar la población con permutaciones aleatorias de nodos
poblacion = inicializar_poblacion(num_poblacion, size(distancias, 1));

% Bucle principal del algoritmo genético
for generacion = 1:num_generaciones
    % Evaluar la aptitud de cada individuo en la población
    aptitudes = evaluar_aptitud(poblacion, distancias);
    
    % Seleccionar padres basándose en la aptitud (ruleta)
    padres = seleccionar_padres(poblacion, aptitudes);
    
    % Cruzar padres para generar descendencia
    descendencia = cruzamiento(padres);
    
    % Aplicar mutación a la descendencia
    descendencia_mutada = mutacion(descendencia, prob_mutacion);
    
    % Reemplazar la población anterior con la nueva generación
    poblacion = reemplazar_poblacion(poblacion, descendencia_mutada, distancias);
end

% Obtener la mejor ruta y su costo de la última generación
[mejor_ruta, mejor_costo] = obtener_mejor_ruta(poblacion, distancias);

% Mostrar resultados en la consola
disp('Mejor Ruta encontrada:');
disp(mejor_ruta);

disp('Costo de la Mejor Ruta:');
disp(mejor_costo);

% Graficar puntos y la mejor ruta encontrada
figure;

% Graficar puntos
scatter(distancias(:,1), distancias(:,2), 'filled');
hold on;

% Graficar la ruta óptima calculada por el algoritmo genético
coordenadas_ruta_optima = distancias(mejor_ruta, :);
plot(coordenadas_ruta_optima(:, 1), coordenadas_ruta_optima(:, 2), 'r.-', 'LineWidth', 2);

% Graficar la ruta más rápida directa entre los puntos
for i = 1:length(distancias)
    for j = i+1:length(distancias)
        plot([distancias(i,1), distancias(j,1)], [distancias(i,2), distancias(j,2)], 'k--');
    end
end

% Graficar la ruta más corta con color verde
plot([distancias(mejor_ruta,1), distancias(mejor_ruta([2:end,1]),1)], [distancias(mejor_ruta,2), distancias(mejor_ruta([2:end,1]),2)], 'g+', 'LineWidth', 5);

title('Mejor Ruta Encontrada y Rutas Directas');
xlabel('Coordenada X');
ylabel('Coordenada Y');
legend('Puntos', 'Mejor Ruta', 'Rutas Directas', 'Ruta más Corta');

% Funciones auxiliares

function poblacion = inicializar_poblacion(num_poblacion, num_nodos)
    poblacion = zeros(num_poblacion, num_nodos);

    for i = 1:num_poblacion
        poblacion(i, :) = randperm(num_nodos);
    end
end

function aptitudes = evaluar_aptitud(poblacion, distancias)
    num_poblacion = size(poblacion, 1);
    aptitudes = zeros(num_poblacion, 1);

    for i = 1:num_poblacion
        aptitudes(i) = calcular_costo(distancias, poblacion(i, :));
    end
end

function padres = seleccionar_padres(poblacion, aptitudes)
    [~, indices_ordenados] = sort(aptitudes);
    padres = poblacion(indices_ordenados(1:2), :);
end

function descendencia = cruzamiento(padres)
    punto_cruzamiento = randi(length(padres(1, :)));
    descendencia = [padres(1, 1:punto_cruzamiento), padres(2, punto_cruzamiento+1:end)];
end

function descendencia_mutada = mutacion(descendencia, prob_mutacion)
    descendencia_mutada = descendencia;
    for i = 1:length(descendencia_mutada)
        if rand < prob_mutacion
            indices = randperm(length(descendencia_mutada));
            descendencia_mutada(i) = descendencia_mutada(indices(1));
        end
    end
end

function poblacion = reemplazar_poblacion(poblacion, descendencia_mutada, distancias)
    [~, peores_indices] = max(evaluar_aptitud(poblacion, distancias));
    poblacion(peores_indices, :) = descendencia_mutada;
end

function [mejor_ruta, mejor_costo] = obtener_mejor_ruta(poblacion, distancias)
    aptitudes = evaluar_aptitud(poblacion, distancias);
    [~, indice_mejor_ruta] = min(aptitudes);
    mejor_ruta = poblacion(indice_mejor_ruta, :);
    mejor_costo = aptitudes(indice_mejor_ruta);
end

function costo = calcular_costo(distancias, ruta)
    costo = 0;
    n = length(ruta);

    for i = 1:n - 1
        costo = costo + distancias(ruta(i), ruta(i + 1));
    end

    costo = costo + distancias(ruta(end), ruta(1));
end
