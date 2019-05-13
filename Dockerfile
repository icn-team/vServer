FROM icnteam/vswitch

# Build hicn suite (from source for disabling punting)
WORKDIR /hicn

# Use bash shell
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get update && apt-get install -y curl
RUN curl -s https://packagecloud.io/install/repositories/fdio/release/script.deb.sh | bash
RUN apt-get update

# Install main packages
RUN apt-get install -y git cmake build-essential libpcre3-dev swig \
    libprotobuf-c-dev libev-dev libavl-dev protobuf-c-compiler libssl-dev \
    libssh-dev libcurl4-openssl-dev libasio-dev --no-install-recommends openssh-server dumb-init

  # Install hicn dependencies                                                                   \
RUN rm -rf /var/lib/apt/lists/*                                                                 \
  ############################################################                                  \
  # Build hicn-apps                                                                             \
  ############################################################                                  \
  && git clone https://github.com/FDio/hicn.git                                                 \
  && mkdir build && pushd build                                                                 \
  && cmake ../ -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_HICNPLUGIN=on -DBUILD_APPS=On                \
  && cd apps/                                                                                   \
  && make -j4 install && popd                                                                   \
  ####################################################
  # Cleanup
  ####################################################
  && apt-get remove -y git cmake build-essential libasio-dev \
                      libcurl4-openssl-dev libev-dev libpcre3-dev libprotobuf-c-dev \
                      libssh-dev libssl-dev protobuf-c-compiler swig \
  && apt-get install libprotobuf-c1 libev4 libssh-4\
  && rm -rf /var/lib/apt/lists/* \
  && apt-get autoremove -y \
  && apt-get clean && rm -r /hicn\
