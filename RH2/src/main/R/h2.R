RH2 <- H2 <- function() {
	JDBC(Driver$new(), "H2")
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)


dbListTables.JDBCConnection <- function(con) {
	JDBCUtils$getTables(con$conn, c("TABLE", "VIEW", "TABLE LINK"))	
}
