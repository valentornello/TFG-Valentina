# GWAS de Caracteres Fenológicos y Tasa de Secado en Maíz (*Zea mays* L.)
**Trabajo Final de Grado - Licenciatura en Genética**

Este repositorio contiene los scripts, bases de datos y metodologías utilizadas para el fenotipado y mapeo por asociación a nivel genómico (GWAS) en un panel de 167 líneas endocriadas de maíz. El objetivo central radica en dilucidar la base genética de la fenología y la dinámica de maduración del grano para optimizar los programas de mejoramiento frente a diferentes ambientes de siembra (temprana y tardía) en Argentina.

---

## 1. Estructura de la Base de Datos Final (`BLUP_base`)

La matriz de datos definitiva, denominada `BLUP_base`, fue construida bajo estrictos criterios de control de calidad fenotípico. Para garantizar la robustez de las estimaciones de los valores genotípicos (BLUPs/BLUEs) mediante modelos mixtos lineales, la base fue filtrada para retener **únicamente los genotipos únicos compartidos** a través de las campañas agrícolas 2015-2016, 2016-2017 y 2018-2019[cite: 1]. 

Las variables cuantitativas integradas en esta matriz reflejan el desarrollo ontogénico del cultivo en función del tiempo térmico:

*   **GDU_VT:** Grados día acumulados desde la siembra hasta la floración masculina (liberación de polen en el 50 % de la parcela)[cite: 3].
*   **GDU_R1:** Grados día acumulados desde la siembra hasta la floración femenina (estigmas visibles >2 cm en el 50 % de la parcela)[cite: 3].
*   **GDU_ASI:** Asincronía floral (Anthesis-Silking Interval), calculada como la diferencia de GDU entre VT y R1[cite: 3]. Representa un indicador clave de desfasaje reproductivo y tolerancia a estreses abióticos[cite: 3].
*   **GDU_MF:** Grados día acumulados desde la siembra hasta la madurez fisiológica[cite: 3].
*   **GDU_MC:** Grados día acumulados desde la siembra hasta la madurez comercial[cite: 3].
*   **TSG:** Tasa de secado del grano, expresada como el porcentaje de humedad perdido por día o por grado día desde MF hasta MC[cite: 2].

---

## 2. Metodología de Fenotipado y Cálculo Térmico

Para cuantificar el desarrollo del cultivo de manera precisa y reproducible, se empleó el concepto de grados día de crecimiento (GDU), evaluando el avance fenológico en función de la temperatura acumulada y no del calendario (Ritchie & Nesmith, 1991)[cite: 2, 3]. El cálculo diferencial del umbral térmico (Tb) es una consideración ecofisiológica fundamental aplicada en este proyecto:

*   **Fase Vegetativa (Siembra a R1):** El desarrollo está condicionado por un umbral térmico mínimo de 8 °C, por lo cual se calculó restando esta Tb a la temperatura media diaria[cite: 2].
*   **Fase Reproductiva y de Secado (Post-R1 a MC):** Una vez alcanzada la floración, el umbral térmico basal pierde relevancia, asumiendo una Tb = 0 °C[cite: 2, 3]. Para el período de llenado y secado (GDU_MF y GDU_MC), se acumuló la temperatura media directamente sin realizar la sustracción[cite: 2].

### Determinación de Madurez Fisiológica (MF) y Madurez Comercial (MC)

La transición desde la etapa de llenado hacia la madurez se modeló mediante curvas de humedad y peso seco a partir de muestreos periódicos cada 15 días[cite: 2]:

1.  **Madurez Fisiológica (MF):** Se determinó algorítmicamente en el punto donde el peso seco alcanzó su valor máximo, denotando el cese de acumulación de materia seca (Cárcova et al., 2003)[cite: 2]. Fenotípicamente, este estadio se verifica con la aparición de la capa negra de abscisión y la línea de leche a ¾, encontrándose la humedad del grano en un rango del 32 % al 40 %[cite: 2].
2.  **Madurez Comercial (MC):** El período de secado natural en campo (TSG) entre MF y MC depende de la temperatura y humedad relativa del aire[cite: 2]. La MC fue establecida al extrapolar la curva de secado hasta que los granos alcanzaron el umbral estándar de 14,5 % de humedad[cite: 2].

---

## 3. Análisis de Asociación (GWAS) y Genes Candidatos

Los valores fenotípicos ajustados (BLUPs/BLUEs) obtenidos de `BLUP_base` serán el insumo para el análisis de asociación (GWAS) utilizando el algoritmo GAPIT en el entorno R[cite: 1]. Al evaluar el desequilibrio de ligamiento (LD) y las variantes genómicas asociadas, se buscará dilucidar la arquitectura genética subyacente a los rasgos cuantitativos en condiciones de siembra temprana y tardía[cite: 1].

El flujo de trabajo incluye la anotación funcional de los SNPs significativos y la búsqueda de genes candidatos posicionales empleando bases de datos genómicas como MaizeGDB, Ensembl Plants y NCBI[cite: 1]. Se prestará especial atención a la validación de genes candidatos relevantes para la floración y madurez, tales como *Vgt1*, *ZCN8*, *ZmCCT*, *ZmMADS1* y *ZmCOL3* (Ran et al., 2024)[cite: 1, 3].

---

## 4. Referencias

Borrás, L., Slafer, G. A., & Otegui, M. E. (2004). Seed dry weight response to source–sink manipulations in wheat, maize and soybean: a quantitative reappraisal. *Field Crops Research, 86*, 131–146.[cite: 6]

Cárcova, J., Uribelarrea, M., Borrás, L., Otegui, M. E., & Maddonni, G. A. (2003). Synchronous pollination within and between ears improves kernel set in maize. *Crop Science, 43*(6), 2056-2065.[cite: 2]

Ran, F., Wang, Y., Jiang, F., Yin, X., Bi, Y., Shaw, R. K., & Fan, X. (2024). Studies on candidate genes related to flowering time in a multiparent population of maize derived from tropical and temperate germplasm. *Plants, 13*(7), 1032. https://doi.org/10.3390/plants13071032[cite: 3]

Ritchie, J. T., & Nesmith, D. S. (1991). Temperature and crop development. *Modeling plant and soil system*, 5–29.[cite: 3]

Ritchie, S. W., & Hanway, J. J. (1982). How a corn plant develops (Spec. Rep. No. 48). Iowa State University.[cite: 3]

Sahito, J. H., Zhang, H., Gishkori, Z. G. N., Ma, C., Wang, Z., Ding, D., Zhang, X., & Tang, J. (2024). Advancements and prospects of genome‑wide association studies (GWAS) in maize. *International Journal of Molecular Sciences, 25*(3), 1918. https://doi.org/10.3390/ijms25031918[cite: 3]
