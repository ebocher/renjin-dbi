library(hamcrest)
library(RH2GIS)

test.driver <- function() {
        dbPath = paste ("jdbc:h2:file:",tempdir(), "/db", sep = "", collapse = NULL)
	con <- dbConnect(RH2GIS(), url=dbPath, username="sa", password="")
	print(loadSpatialFunctions(con));
        sq <- dbSendQuery(con,"DROP TABLE IF EXISTS VANNES; CREATE TABLE VANNES (the_geom geometry, id int)")
        stopifnot(identical(dbExistsTable(con,"VANNES"),TRUE))
        sq <- dbSendQuery(con,"INSERT INTO VANNES VALUES('POLYGON ((100 300, 210 300, 210 200, 100 200, 100 300))'::GEOMETRY, 1)"); 
        stopifnot(identical(as.numeric(dbGetQuery(con,"SELECT ST_AREA(the_geom) as area FROM VANNES")[[1]]),11000))
}

test.externalFile <- function() {
        dbPath = paste ("jdbc:h2:file:",tempdir(), "/db_external", sep = "", collapse = NULL)
	con <- dbConnect(RH2GIS(), url=dbPath, username="sa", password="")
	print(loadSpatialFunctions(con));
        sq <- dbSendQuery(con,"DROP TABLE IF EXISTS VANNES; CREATE TABLE VANNES (the_geom geometry, id int)")
        sq <- dbSendQuery(con,"INSERT INTO VANNES VALUES('POLYGON ((100 300, 210 300, 210 200, 100 200, 100 300))'::GEOMETRY, 1)"); 
        shapeWrite = paste ("CALL SHPWrite('",tempdir(), "/vannes.shp', 'VANNES')", sep = "", collapse = NULL)      
        dbSendQuery(con,shapeWrite);
        shapeTable = paste ("CALL FILE_TABLE('",tempdir(), "/vannes.shp', 'LINKED_SHAPE')", sep = "", collapse = NULL)
        dbSendQuery(con,shapeTable);
        stopifnot(identical(dbExistsTable(con,"LINKED_SHAPE"),TRUE))
}
