# For running AWS CLI v2

# Set the base image to Ubuntu (version 18.04)
ARG UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION}

# Specifying the ARGs like this allow overrides
# on the `docker build` command line
ARG PKGNAME=aws-cli-v2
ENV PKGNAME ${PKGNAME}
ARG ARCH=x86_64
ENV ARCH ${ARCH}
ARG TMP_DIR=/tmp
ARG ARCHIVE_TMP_DIR=${TMP_DIR}/aws-cli-v2

# Only x86_64 is supported
ENV arch x86_64

# Software packages, any version, added and removed in build
ENV EPHEMERAL_UNVERSIONED_PACKAGES \
# For checking Linux Capabilities
# bpfcc-tools \
 ca-certificates \
 gnupg \
 unzip \
 wget

# Software packages, any version
ENV UNVERSIONED_PACKAGES \
# Needed for `aws2 help` commands
 groff-base \
# Default pager
 less

# Static files
COPY gpg.pub "${ARCHIVE_TMP_DIR}/aws-cli-v2-gpg.pub"

################################################################################
# Install software and cleanup
# Tell apt not to use interactive prompts
RUN export DEBIAN_FRONTEND=noninteractive && \
 apt-get update && \
 apt-get upgrade -y && \
 apt-get install -y --no-install-recommends \
 ${UNVERSIONED_PACKAGES} \
# Install temporary packages
 ${EPHEMERAL_UNVERSIONED_PACKAGES} && \
 mkdir -p "${ARCHIVE_TMP_DIR}" && \
# Install AWS CLI v2
 gpg-agent --daemon && \
 gpg --import "${ARCHIVE_TMP_DIR}/aws-cli-v2-gpg.pub" && \
 wget --progress=dot -O "${ARCHIVE_TMP_DIR}/awscliv2.zip.sig" "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-${ARCH}.zip.sig" && \
 wget --progress=dot -O "${ARCHIVE_TMP_DIR}/awscliv2.zip" "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-${ARCH}.zip" && \
 gpg --verify "${ARCHIVE_TMP_DIR}/awscliv2.zip.sig" "${ARCHIVE_TMP_DIR}/awscliv2.zip" && \
 unzip -q "${ARCHIVE_TMP_DIR}/awscliv2.zip" -d "${ARCHIVE_TMP_DIR}" && \
 "${ARCHIVE_TMP_DIR}/aws/install" -i "/opt/${PKGNAME}" -b "/usr/bin" && \
 rm -fr "${TMP_DIR}/*" && \
# Clean up package cache in this layer
 apt-get --purge remove -y \
# Uninstall temporary packages
 ${EPHEMERAL_UNVERSIONED_PACKAGES} && \
# Remove dependencies which are no longer required
 apt-get --purge autoremove -y && \
# Clean package cache
 apt-get clean -y && \
# Restore interactive prompts
 unset DEBIAN_FRONTEND && \
# Remove cache files
 rm -rf \
 /tmp/* \
 /var/cache/* \
 /var/log/* \
 /var/lib/apt/lists/*
################################################################################
