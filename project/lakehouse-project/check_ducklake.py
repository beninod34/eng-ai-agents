import duckdb
con = duckdb.connect()
con.execute("INSTALL ducklake; LOAD ducklake;")
print(con.sql("SELECT function_name FROM duckdb_functions() WHERE function_name LIKE 'ducklake%'").df())