#!/bin/bash
set -euo pipefail

# create an app.zip file with what you want to push to the yarn job
# Note: put here extra files needed.
(rm build/app.zip &> /dev/null) || true
zip -r build/app.zip \
    my_module

# submit app in cluster mode with conda environment and dependencies
spark-submit \
--conf spark.yarn.appMasterEnv.PYSPARK_PYTHON=./environment/bin/python \
--conf spark.yarn.appMasterEnv.PYTHONPATH=./app \
--master yarn \
--deploy-mode cluster \
--archives \
    build/environment.tar.gz#environment,build/app.zip#app \
run.py
