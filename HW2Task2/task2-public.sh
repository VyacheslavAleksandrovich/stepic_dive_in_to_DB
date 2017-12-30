#!/bin/bash
docker run -d --name postgres -v $(pwd):/workspace postgres:9.6
sleep 15
docker run --rm  --name psql --link postgres:postgres -v $(pwd):/workspace postgres:9.6 psql -h postgres -U postgres -f /workspace/task2-public.sql
