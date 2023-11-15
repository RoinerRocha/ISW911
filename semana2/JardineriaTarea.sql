select * from cliente
select * from detalle_pedido
select * from empleado
select * from gama_producto
select * from oficina
select * from pago
select * from pedido
select * from producto

REM 1.	Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
(1) select CODIGO_OFICINA as codigo, CIUDAD as ciudad from oficina
REM 2.	Actualice el límite de crédito de los clientes en un 25% adicional para los clientes que tengan un límite de crédito superior a  los $12000 y que viven en la ciudad de Miami.
(2)update CLIENTE set LIMITE_CREDITO=LIMITE_CREDITO + (LIMITE_CREDITO*0.25)
    where LIMITE_CREDITO >=12000
    and lower(nvl(CIUDAD,'miami')) like '%miami%'
REM 3.	Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
    Select NOMBRE as Nombre, APELLIDO1 as Apellido, EMAIL as Email From empleado where CODIGO_JEFE = 7  
    
REM nombre de clientes cantidad de ventas y quien es el asesor de ventas
    select c.nombre_cliente,v.monto ,e.nombre representante from cliente c
    inner join 
    (select p.codigo_cliente, sum(dp.cantidad)*sum(dp.precio_unidad) monto   from pedido p
    inner join detalle_pedido dp
    on p.codigo_pedido=dp.codigo_pedido
    group by p.codigo_cliente) v
    on c.codigo_cliente=v.codigo_cliente
    left join empleado e
    on c.codigo_empleado_rep_ventas=e.codigo_empleado
REM nombre de empleado, nombre de jefe, nombre de oficina

select c.nombre_cliente,v.monto ,e.nombre representante from cliente c
inner join 
(select p.codigo_cliente, sum(dp.cantidad)*sum(dp.precio_unidad) monto   from pedido p
inner join detalle_pedido dp
on p.codigo_pedido=dp.codigo_pedido
group by p.codigo_cliente) v
on c.codigo_cliente=v.codigo_cliente
left join empleado e
on c.codigo_empleado_rep_ventas=e.codigo_empleado


creat or replace view v_ventas as
select *  from (
----------------------------------------------------
select pr.nombre producto,p.estado,dp.cantidad,dp.precio_unidad  from pedido p
inner join detalle_pedido dp
on p.codigo_pedido=dp.codigo_pedido
inner join producto pr
on dp.codigo_producto=pr.codigo_producto
----------------------------------------------------
) pivot (sum(cantidad) cantidad, sum(precio_unidad)  precio 
for estado in ('Entregado' entregado,'Rechazado' rechazado,'Pendiente' pendiente ) )