docker build -t test -f test.dockerfile .
export BUILD_TYPE=DEV
docker run --env BUILD_TYPE test
