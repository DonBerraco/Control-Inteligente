% Función principal
function Heuristica_Aproximacion
    % Ejemplo de uso
    distancias = [
        45 10 15 20;
        10 3 35 25;
        15 35 5 30;
        20 25 30 10
    ];

    % Llamada a la función del vecino más cercano
    [rutaOptima, distanciaOptima] = tspVecinoMasCercano(distancias);

    % Mostrar resultados
    disp('Ruta Óptima:');
    disp(rutaOptima);
    disp(['Distancia Óptima: ' num2str(distanciaOptima)]);
end

% Función para resolver el TSP usando el vecino más cercano
function [rutaOptima, distanciaOptima] = tspVecinoMasCercano(distancias)
    n = size(distancias, 1); % Número de ciudades

    % Inicializar la ruta con el primer nodo
    ruta = zeros(1, n+1);
    ruta(1) = 1;

    % Inicializar la matriz de ciudades visitadas
    visitadas = false(1, n);
    visitadas(1) = true;

    % Construir la ruta
    for i = 2:n
        ciudadActual = ruta(i-1);
        distanciasDesdeCiudadActual = distancias(ciudadActual, :);
        
        % Encontrar la ciudad más cercana no visitada
        [~, ciudadMasCercana] = min(distanciasDesdeCiudadActual .* ~visitadas);

        % Agregar la ciudad a la ruta y marcarla como visitada
        ruta(i) = ciudadMasCercana;
        visitadas(ciudadMasCercana) = true;
    end

    % Volver al punto de inicio para completar el ciclo
    ruta(end) = ruta(1);

    % Calcular la distancia total de la ruta
    distanciaOptima = calcularDistanciaTotal(ruta, distancias);

    % Resultados
    rutaOptima = ruta;
end

% Función auxiliar para calcular la distancia total de una ruta
function distancia = calcularDistanciaTotal(ruta, distancias)
    distancia = 0;
    for i = 1:length(ruta)-1
        distancia = distancia + distancias(ruta(i), ruta(i+1));
    end
end
