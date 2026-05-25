-- Importa sem o --skip. O SQLite vai ler o cabeçalho, mapear e ignorá-lo nas linhas de dados

.import "D:/Portifolio/data/dim_products.csv" dim_products
.import "D:/Portifolio/data/fact_sales.csv" fact_sales