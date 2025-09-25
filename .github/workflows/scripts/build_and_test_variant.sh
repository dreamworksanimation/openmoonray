#!/bin/bash -e
# Expects to be run from the github.workspace directory with one parameter which is the
# variant to build and run unit tests on.
# build_and_test_variant.sh <variant1> <variant2> ... <variantn>

if [ $# -lt 1 ]
then
    printf "Usage:\n\t$0 variant#+\n"
    exit 1
fi

# Set the variants to build and test.
variants=$*
echo "Building and tests variant(s) " ${variants}

# define environment variables that are setup by the studio.
export REL_BOOT_DIR=/rel/boot
export OS_RELEASE=$(/bin/cat /etc/redhat-release | sed -r 's/.*release ([0-9]+).*/ws\1/')
export RATS_CANONICAL_DIR=$(pwd)/rats_canonicals

# Setup access to rez.
source /rel/boot/rez/rezx.sh
export REZ_LOCAL_PACKAGES_PATH=$(pwd)/installs
export REZ_PACKAGES_PATH=${REZ_PRE_PACKAGES_PATH}:${REZ_LOCAL_PACKAGES_PATH}:${REZ_RELEASE_PACKAGES_PATH}:/rel/rez/third_party:/rel/rez/pypi:/rel/lang/python/packages:${REZ_POST_PACKAGES_PATH}

# Build the variants.
rez-env buildtools -c "rez-build -i --variants ${variants}"

# Run unit tests on each variant.
for variant in ${variants}
do
    rez-env buildtools -c "rez-test openmoonray variant${variant} || rez-test openmoonray retry_variant${variant}"
    if [ ${variant} -eq 0 ]
    then
        rez-env buildtools -c "rez-test openmoonray rats || rez-test openmoonray retry_rats"
    # elif [ ${variant} -eq 1 ]
    # then
    #     rez-env buildtools -c "rez-test openmoonray rats-debug || rez-test openmoonray retry_rats-debug"
    fi
done
