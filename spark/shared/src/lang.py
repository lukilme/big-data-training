from pyspark import SparkContext

sc = SparkContext("local", "Word Count")

numeros = sc.parallelize([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13])
filtro = numeros.filter(lambda x: x > 5)
print(filtro.collect())
mapa = numeros.map(lambda mapa: mapa * 2)
print(mapa.collect())


numeros2 = sc.parallelize([6,7,8,9,10,11])
uniao = numeros.union(numeros2)
print(uniao.collect())

interseccao = numeros.intersection(numeros2)
print(interseccao.collect())

cartesiano = numeros2.cartesian(numeros)
print(cartesiano.collect())

conteo_rdd = sc.parallelize(list(cartesiano.countByValue().items())) 

filtro_conteo = conteo_rdd.filter(lambda x: x[1] > 1) 
print()
print(filtro_conteo.collect())

compras = sc.parallelize([(1,300),(2,540),(3,400),(4,320),(5,700),(6,640)])
chaves = compras.keys()
print(chaves.collect())

valores = compras.values()
print(valores.collect())

debitos = sc.parallelize([(1,20),(3,400)])

resultado = compras.join(debitos)
print(resultado.collect())

print(compras.subtractByKey(debitos).collect())