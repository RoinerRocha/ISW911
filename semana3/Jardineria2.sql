select * from producto
SELECT * FROM PEDIDO


select PRODUCTO, 
ANIO,
VENTAS,
lag(VENTAS) over (partition by producto order by anio asc) ventas_anteriores,
VENTAS-lag(VENTAS) over (partition by producto order by anio asc) crecimiento,
lead(VENTAS) over (partition by producto order by anio asc) ventas_posterior
from(
select PR.nombre producto, DP.cantidad*DP.precio_unidad VENTAS, extract( year from p.fecha_entrega) ANIO
from PEDIDO p
inner join detalle_pedido dp
on p.codigo_pedido= dp.codigo_pedido
inner join producto pr
on dp.codigo_producto=pr.codigo_producto
where upper(p.estado)= 'ENTREGADO'
)

REM solucionado
SELECT CLIENTE,VENTAS,NIVEL,  
CASE WHEN NIVEL= 1 THEN 'CATEGORIA A'
 WHEN NIVEL= 2 THEN 'CATEGORIA B'
  WHEN NIVEL= 3 THEN 'CATEGORIA C'
   WHEN NIVEL=4 THEN 'CATEGORIA D'
   END CATEGORIA
FROM (
SELECT CLIENTE,VENTAS,
NTILE(4) OVER (ORDER BY VENTAS DESC) AS NIVEL
FROM (
SELECT CL.NOMBRE_CLIENTE CLIENTE,SUM(DP.CANTIDAD*DP.PRECIO_UNIDAD) VENTAS
FROM PEDIDO P 
INNER JOIN DETALLE_PEDIDO DP
ON P.CODIGO_PEDIDO=DP.CODIGO_PEDIDO
INNER JOIN PRODUCTO PR
ON DP.CODIGO_PRODUCTO=PR.CODIGO_PRODUCTO
INNER JOIN CLIENTE CL
ON P.CODIGO_CLIENTE=CL.CODIGO_CLIENTE
WHERE UPPER(P.ESTADO)='ENTREGADO'
GROUP BY CL.NOMBRE_CLIENTE
)
)


REM Continuar
select producto, anio, sum(ventas) ventas from (
select PR.nombre producto, DP.cantidad*DP.precio_unidad VENTAS, extract( year from p.fecha_entrega) ANIO, 
p.estado
from PEDIDO p
inner join detalle_pedido dp
on p.codigo_pedido= dp.codigo_pedido
inner join producto pr
on dp.codigo_producto=pr.codigo_producto)
group by cube ( producto, anio, estado)
order by 2,1


REM nuevo

select distinct cl.nombre_cliente, cliente 
listagg(pr.nombre, ',')within group (order by cl.nombre_cliente)
    over (partition by cl.nombre_cliente) productos
from pedido p
inner join detalle_pedido dp
on  p.codigo_pedido=dp.codigo_pedido
inner join producto pr
on dp.codigo_producto=pr.codigo_producto
inner join cliente cl
on p.codigo_cliente=cl.codigo_cliente
where upper(p.estado)='ENTREGADO'

