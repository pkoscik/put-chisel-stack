#!/usr/bin/env bash
set -e

usage() {
  echo "Usage: $0 [-s|--skip]"
  echo "  -s, --skip    Skip the flashing step"
  echo "  -d, --dirty   Do not clean workdirs"
  exit 1
}

skip_synthesis=false
dirty=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--skip)
      skip_synthesis=true
      shift
      ;;
    -d|--dirty)
      dirty=true
      shift
      ;;
    *)
      usage
      ;;
  esac
done

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Chisel
pushd chisel
docker run --rm -v $PWD:/project/ -w="/project" chisel-fpga-toolchain /bin/bash -c "sbt test; sbt 'runMain led.VerilogMain'; sbt clean cleanFiles"
popd

# Copy files to synth
cp chisel/Blinky.sv synthesis/Blinky.sv

# Synthesis
  pushd synthesis
  docker run --privileged --rm -u $UID -v $PWD:/project/ -w="/project" oss-fpga-toolchain /bin/bash -c "make"
if [ "$skip_synthesis" = false ]; then
  read -p "Press enter to continue"
  docker run --privileged --rm -u $UID -v $PWD:/project/ -w="/project" oss-fpga-toolchain /bin/bash -c "openFPGALoader -b ice40_generic Blinky.bin"
fi
if [ "$dirty" = false ]; then
  make clean
fi
  popd
  echo "Skipping synthesis and flashing steps as requested."
