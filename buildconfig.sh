# Kolla-Ansible does not yet have a 2024.1 branch. This is a space separated
# list.
default_build_targets="2023.1 2023.2 master"

# Which images to build. Kerbside only requires customized nova-compute,
# nova-libvirt, nova-api, and kerbside container images but it can make sense
# to build all the container images at the same time to keep them consistent.
default_build_images="nova-compute nova-libvirt nova-api kerbside"

# Should we only test once at the end?
defer_tests="false"

# Should we skip tests entirely?
skip_tests="false"

# Should we build a compact archive using occystrap?
compact_archive="false"

# Parse command line
export build_targets=${default_build_targets}
export build_images=${default_build_images}
export positional_args=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --compact-archive)
      export skip_tests="true"
      echo "Will create a compact archive."
      shift
      ;;
    --defer-tests)
      export defer_tests="true"
      echo "Will defer testing."
      shift
      ;;
    --build-images)
      export build_images="$2"
      echo "Setting build images to ${build_images}."
      shift; shift
      ;;
    --build-targets)
      export build_targets="$2"
      echo "Setting build targets to ${build_targets}."
      shift; shift
      ;;
    --skip-tests)
      export skip_tests="true"
      echo "Will skip testing."
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      positional_args+=("$1")
      shift
      ;;
  esac
done

# Ensure we fail even when piping output to ts
set -o pipefail

# Color helpers, from https://stackoverflow.com/questions/5947742/
Color_Off='\033[0m'       # Text Reset
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# And an arrow!
Arrow='\u2192'

H1="${Green}"
H2="${Blue}"
H3="${Arrow}${Purple}"

# Make failures more obvious
function on_exit {
    echo
    echo -e "${Red}*** Failed ***${No_Color}"
    echo
    }
trap 'on_exit $?' EXIT