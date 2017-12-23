add_definitions(
    -DSQLITE_THREADSAFE=0
    -DSQLITE_OMIT_LOAD_EXTENSION
    )

add_library(sqlite3 sqlite3.c sqlite3.h)
