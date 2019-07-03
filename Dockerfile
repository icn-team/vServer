FROM icnteam/vswitch

# Build hicn suite (from source for disabling punting)
WORKDIR /hicn

# Use bash shell
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get update && apt-get install -y curl
RUN curl -s https://packagecloud.io/install/repositories/fdio/release/script.deb.sh | bash
RUN apt-get update

# Install main packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git cmake build-essential libasio-dev --no-install-recommends \
    libparc-dev                                                                                 \
  ############################################################                                  \
  # Build hicn-apps                                                                             \
  ############################################################                                  \
  && git clone https://github.com/FDio/hicn.git                                                 \
  && mkdir build && pushd build                                                                 \
  && cmake ../hicn -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_HICNPLUGIN=ON -DBUILD_APPS=ON            \
  && cd apps                                                                                    \
  && make -j4 install && popd                                                                   \
  ####################################################                                          \
  # Cleanup                                                                                     \
  ####################################################                                          \
  && apt-get remove -y git cmake build-essential libasio-dev libparc-dev                        \
  && rm -rf /var/lib/apt/lists/*                                                                \
  && apt-get autoremove -y                                                                      \
  && apt-get clean && rm -r /hicn                                                               \
  && rm -rf vpp

WORKDIR /
CMD ["/tmp/init.sh"]