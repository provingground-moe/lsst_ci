#!/bin/bash

set -e

PRODUCT_DIR="$VALIDATE_DRP_DIR"
VALIDATION_DATA_DIR="$VALIDATION_DATA_HSC_DIR/raw"
CALIB_DATA="$VALIDATION_DATA_HSC_DIR/CALIB"

CAMERA=Hsc
CONFIG_FILE="${PRODUCT_DIR}/config/hscConfig.py"
MAPPER=lsst.obs.hsc.HscMapper
ASTROMDIR=sdss-dr9-fink-v5b

print_error() {
    >&2 echo "$@"
}

DOPROCESS=true
DOVERIFY=true

usage() {
    print_error
    print_error "Usage: $0 [-PV] [-h] [-- <extra options to validateDrp.py>]"
    print_error
    print_error "Specifc options:"
    print_error "   -P          Skip processing?"
    print_error "   -V          Skip verification?"
    print_error "   -h          show this message"
    exit 1
}

while getopts "VP" option; do
    case "$option" in
        P)  DOPROCESS=false;;
        V)  DOVERIFY=false;;
        h)  usage;;
        *)  usage;;
    esac
done
shift $((OPTIND-1))

if [[ $DOPROCESS == true ]]; then
    "${PRODUCT_DIR}/scripts/processData.sh" \
        -c "$CAMERA" \
        -m "$MAPPER" \
        -v "$VALIDATION_DATA_DIR" \
        -f "$CONFIG_FILE" \
        -e "fits" \
        -a "$ASTROMDIR" \
        -d "$CALIB_DATA" \
        -r
fi

if [[ $DOVERIFY == true ]]; then
    "${PRODUCT_DIR}/scripts/validateRepo.sh" \
        -c "$CAMERA" \
        -- "$@"
fi
