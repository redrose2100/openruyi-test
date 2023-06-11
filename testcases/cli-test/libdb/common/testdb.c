#include <stdio.h>
#include <stdlib.h>
#include <db.h>
#include <string.h>

#define DATABASE "test.db"

typedef struct _data_struct {
    int data_id;
    char data[20];
} data_struct;

int main()
{
    DBT key, data;
    DB *dbp;
    int ret;
    data_struct my_data;

    ret = db_create(&dbp, NULL, 0);  // create the DB handle
    if (ret != 0)
    {
        perror("create");
        return 1;
    }

    ret = dbp->open(dbp, NULL, DATABASE, NULL, DB_BTREE, DB_CREATE, 0);  // open the database
    if (ret != 0)
    {
        perror("open");
        return 1;
    }


    my_data.data_id = 1;
    strcpy(my_data.data, "some data");

    memset(&key, 0, sizeof(DBT));
    memset(&data, 0, sizeof(DBT));

    key.data = &(my_data.data_id);
    key.size = sizeof(my_data.data_id);
    data.data = &my_data;
    data.size = sizeof(my_data);

    ret = dbp->put(dbp, NULL, &key, &data, DB_NOOVERWRITE);  // add the new data into the database
    if (ret != 0)
    {
        printf("Data ID exists\n");
    }

    dbp->close(dbp, 0);   // close the database

    return 0;
}

