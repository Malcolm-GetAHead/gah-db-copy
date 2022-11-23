#!/bin/sh

#env vars:
# $DATABASES: List of databases separated by commas, eg: gah,kong
# SRC_[HOST|PORT|USER|PASS]: Source database credentials and connection info, defaults port is 5432
# DEST_[HOST|PORT|USER|PASS]: Destination database credentials and connection info, defaults port is 5432
# POST_QUERY: Query to run on the destination database(s) when the import has finished

for db in ${DATABASES//,/ }
do
    PGPASSWORD="$SRC_PASS" pg_dump \
        --clean \
        -h "$SRC_HOST" \
        -p "${SRC_PORT:-5432}" \
        -U "$SRC_USER" \
        "$db" | \
    PGPASSWORD="$DEST_PASS" psql \
        -h "$DEST_HOST" \
        -p "${DEST_PORT:-5432}" \
        -U "$DEST_USER" \
        $db

    if [ -n "$POST_QUERY" ];
    then
        echo "${POST_QUERY}" | \
            PGPASSWORD="$DEST_PASS" psql \
            -h "$DEST_HOST" \
            -p "${DEST_PORT:-5432}" \
            -U "$DEST_USER" \
            $db
    fi
done
