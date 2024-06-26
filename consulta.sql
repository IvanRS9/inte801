# consulta para saber cual es la galleta mas vendida
SELECT g.nombre, SUM(dv.cantidad) as cantidad_vendida FROM detalleventa dv
JOIN galletas g ON g.id = dv.galleta_id
GROUP BY g.nombre
ORDER BY cantidad_vendida DESC;

# consulta para saber la galleta que mas merma produce
SELECT g.nombre, SUM(m.cantidad) as cantidad_merma FROM merma_galletas m
JOIN inventariogalletas ig ON ig.idLoteGalletas = m.idInventarioGalletas
JOIN galletas g ON g.id = ig.idGalleta
GROUP BY g.nombre
ORDER BY cantidad_merma DESC;

#insertar mermas
select * from inventariogalletas;
INSERT INTO merma_galletas(idInventarioGalletas, cantidad, created_at, updated_at,justificaion)
VALUES(1,5, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo');
(2, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo'),
(23, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo'),
(24, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo'),
(25, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo'),
(26, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo'),
(27, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo'),
(28, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo'),
(29, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo'),
(30, 1, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(),'Se cayo al suelo');


#en base al id del lote, el id del proveedor saber que materia prima se utilizo para producir una galleta

SELECT mp.material, mpp.precio, mpp.cantidad, mpp.tipo
FROM inventariogalletas ig
JOIN materia_prima_proveedor mpp ON mpp.materiaprima_id = ig.idGalleta
JOIN materiaprima mp ON mp.id = mpp.materiaprima_id
WHERE ig.idLoteGalletas = 1 AND mpp.proveedor_id = 1;



# AUN NO ESTA BIEN
# consulta para saber que galleta deberia producir para obtener la mayor utilidad usando row_number
SELECT g.nombre, 
SUM(dv.cantidad * g.`pesoGalleta`) as total_vendido,
SUM(m.cantidad * g.`pesoGalleta`) as total_merma, 
SUM(dv.cantidad * g.`pesoGalleta`) - SUM(m.cantidad * g.`pesoGalleta`) as utilidad FROM detalleventa dv
JOIN galletas g ON g.id = dv.galleta_id
JOIN merma_galletas m ON m.idInventarioGalletas = dv.galleta_id
GROUP BY g.nombre
ORDER BY utilidad DESC;


# AUN NO ESTA BIEN CREo
# consulta para saber acorde a las materias primas que tengo, si se escoge una receta, cuanto me costara la produccion de cada tipo de galleta
select sum(costo_produccion) from(
SELECT 
    nombre_material,
    sum(costo_material) as costo_produccion,
    cantidad_utilizada
FROM
    (SELECT
        mp.material AS nombre_material,
        i.cantidad AS cantidad_utilizada,
        ROUND((i.cantidad * g.precio), 2) / 100 AS costo_material
    FROM
        ingredientes i
    JOIN
        materiaprima mp ON i.material_id = mp.id
    JOIN
        galletas g ON i.galleta_id = g.id
    WHERE
        g.id = 4) AS materiales
GROUP BY
    nombre_material) as p;
    

#saber cuanto cuesta cada gramo de materia prima
SELECT 
    mp.material,
    mpp.precio,
    c.cantidadConvertida,
    c.tipoConvertido,
    c.`tipoConvertido` as tipo,
    ROUND((mpp.precio / c.cantidadConvertida), 2) as precio_por_gramo
FROM
    materia_prima_proveedor mpp
LEFT JOIN
    conversiones c ON c.tipoSinConvertir = mpp.tipo
   left JOIN
    materiaprima mp ON mpp.materiaprima_id = mp.id;
    
#unir con la consulta anterior con la tabla de ingredientes y galletas para saber cuanto cuesta producir una galleta
SELECT 
    g.nombre,
    mp.material,
    i.cantidad,
    mpp.precio,
    c.cantidadConvertida,
    c.tipoConvertido,
    ROUND((mpp.precio / c.cantidadConvertida), 2) as precio_por_gramo,
    ROUND((i.cantidad * (mpp.precio / c.cantidadConvertida)), 2) as costo_produccion
FROM
    ingredientes i
left JOIN
    galletas g ON i.galleta_id = g.id
left JOIN
    materiaprima mp ON i.material_id = mp.id
left JOIN
    materia_prima_proveedor mpp ON mpp.materiaprima_id = mp.id
left JOIN
    conversiones c ON c.tipoSinConvertir = mp.tipo;


#consulta para convertir la cantidad de materia prima que se necesita para una receta a gramos
SELECT 
    mp.material,
    i.cantidad,
    c.cantidadConvertida,
    c.tipoConvertido
FROM
    ingredientes i
left JOIN
    materiaprima mp ON i.material_id = mp.id
left JOIN
    conversiones c ON c.tipoSinConvertir = mp.tipo;
    
SELECT galletas.id, galletas.nombre, galletas.precio, galletas.estatus, galletas.created_at, galletas.updated_at, galletas.deleted_at, materiaprima.material, materiaprima.tipo
FROM galletas
JOIN (
    SELECT galletas.id, galletas.nombre, galletas.precio, galletas.estatus, galletas.created_at, galletas.updated_at, galletas.deleted_at, materia_prima_galleta.materiaprima_id
    FROM galletas
    JOIN materia_prima_galleta ON materia_prima_galleta.galleta_id = galletas.id
    WHERE galletas.id = 1
) AS galletas_materia_prima ON galletas_materia_prima.id = galletas.id;

select * from inventariogalletas;
select * from produccion;
select * from solicitudproduccion;
# consulta para saber un determinado lote de galletas, saber que empreado la produjo
SELECT inventariogalletas.idLoteGalletas, inventariogalletas.idGalleta, inventariogalletas.cantidad, inventariogalletas.fechaCaducidad, inventariogalletas.estatus, inventariogalletas.created_at, inventariogalletas.updated_at, inventariogalletas.deleted_at, usuario.nombre, usuario.apellido
FROM inventariogalletas
JOIN produccion ON produccion.idProduccion = inventariogalletas.idLoteGalletas
JOIN usuario ON usuario.id = produccion.idUsuario
WHERE inventariogalletas.idLoteGalletas = 22;

update inventariogalletas set idLotegalletas = 3 where idLoteGalletas = 23;

# consulta para saber un determinado lote de galletas, saber que proveedor proporciono la materia prima
SELECT inventariogalletas.idLoteGalletas, inventariogalletas.idGalleta, inventariogalletas.cantidad, inventariogalletas.fechaCaducidad, inventariogalletas.estatus, inventariogalletas.created_at, inventariogalletas.updated_at, inventariogalletas.deleted_at, proveedor.nombre_empresa
FROM inventariogalletas
JOIN materia_prima_proveedor ON materia_prima_proveedor.materiaprima_id = inventariogalletas.idGalleta
JOIN proveedor ON proveedor.id = materia_prima_proveedor.proveedor_id
WHERE inventariogalletas.idLoteGalletas = 1;


select concat(u.nombre, ' ', u.apellido) as nombre_empleado, ig.idLoteGalletas
JOIN produccion p ON p.idSolicitud = ig.idSolicitud
JOIN usuario u ON u.id = p.idUsuario;


# consulta para saber el nombre y la cantidad de galletas que hay en inventario
SELECT g.nombre, ig.cantidad
FROM inventariogalletas ig
JOIN galletas g ON g.id = ig.idGalleta;

#consulta para saber el nombre y la cantidad de materias primas que hay en inventario
SELECT mp.material, ig.cantidad
FROM inventariomateriaprima ig
JOIN materiaprima mp ON mp.id = ig.idMateriaPrima;

 SELECT COALESCE(SUM(costo_produccion) / min(totalGalletas), 0) as costoUnitario, min(totalGalletas) ,
        min(totalGalletas) * COALESCE(SUM(costo_produccion) / min(totalGalletas), 0) as costoTotal, min(nombre) as nombre,min(precioTotal) as precioTotal
        FROM (
    SELECT
        nombre_material,
        SUM(cantidad_utilizada * precio_material) AS costo_produccion,
        totalGalletas AS totalGalletas,
        precioTotal as precioTotal,
        nombre
    FROM (
        SELECT
            mp.material AS nombre_material,
            SUM(i.cantidad) AS cantidad_utilizada,
            ROUND((SUM(mpp.cantidad)  * AVG(mpp.precio)), 2)/ 10000 AS precio_material,
            g.totalGalletas,
            g.nombre nombre,
            g.precio as precioTotal
        FROM
            ingredientes i
        JOIN
            materiaprima mp ON i.material_id = mp.id
        JOIN
            galletas g ON i.galleta_id = g.id
		JOIN 
			materia_prima_proveedor mpp on mpp.materiaprima_id = mp.id
        WHERE
            g.id = :id and g.enable = 1
        GROUP BY
            mp.material, g.totalGalletas, g.precio, mpp.materiaprima_id, g.nombre
    ) AS materiales
    GROUP BY
        nombre_material, nombre, totalGalletas, precioTotal
    ) AS materiales;


mysql> describe detalleventa;
+-----------------+---------------+------+-----+---------+----------------+
| Field           | Type          | Null | Key | Default | Extra          |
+-----------------+---------------+------+-----+---------+----------------+
| id              | int           | NO   | PRI | NULL    | auto_increment |
| venta_id        | int           | YES  | MUL | NULL    |                |
| galleta_id      | int           | YES  | MUL | NULL    |                |
| cantidad        | decimal(10,2) | NO   |     | NULL    |                |
| precio_unitario | decimal(10,2) | NO   |     | NULL    |                |
| created_at      | datetime      | NO   |     | NULL    |                |
| tipoVenta       | varchar(255)  | NO   |     | NULL    |                |
+-----------------+---------------+------+-----+---------+----------------+

SELECT 
    dv.galleta_id,
    dv.precio_unitario,
    dv.cantidad,
    c.costoUnitario,
    (dv.precio_unitario - c.costoUnitario) AS gananciaPorGalleta,
    (dv.precio_unitario - c.costoUnitario) * dv.cantidad AS gananciaTotal
FROM 
    detalleventa dv
JOIN
    (SELECT 
         g.id AS galleta_id,
         COALESCE(SUM(costo_produccion) / NULLIF(min(totalGalletas), 0), 0) AS costoUnitario
     FROM
         (SELECT COALESCE(SUM(costo_produccion) / min(totalGalletas), 0) as costoUnitario, min(totalGalletas) ,
        min(totalGalletas) * COALESCE(SUM(costo_produccion) / min(totalGalletas), 0) as costoTotal, min(nombre) as nombre,min(precioTotal) as precioTotal
        FROM (
    SELECT
        nombre_material,
        SUM(cantidad_utilizada * precio_material) AS costo_produccion,
        totalGalletas AS totalGalletas,
        precioTotal as precioTotal,
        nombre
    FROM (
        SELECT
            mp.material AS nombre_material,
            SUM(i.cantidad) AS cantidad_utilizada,
            ROUND((SUM(mpp.cantidad)  * AVG(mpp.precio)), 2)/ 10000 AS precio_material,
            g.totalGalletas,
            g.nombre nombre,
            g.precio as precioTotal
        FROM
            ingredientes i
        JOIN
            materiaprima mp ON i.material_id = mp.id
        JOIN
            galletas g ON i.galleta_id = g.id
		JOIN 
			materia_prima_proveedor mpp on mpp.materiaprima_id = mp.id
        WHERE
            g.id = :id and g.enable = 1
        GROUP BY
            mp.material, g.totalGalletas, g.precio, mpp.materiaprima_id, g.nombre
    ) AS materiales
    GROUP BY
        nombre_material, nombre, totalGalletas, precioTotal
    ) AS materiales) AS costos
     JOIN
         galletas g ON costos.galleta_id = g.id
     GROUP BY
         g.id) AS c ON dv.galleta_id = c.galleta_id;  -- Cambia esto según necesites filtrar por tipo de venta
