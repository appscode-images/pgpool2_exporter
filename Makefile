# Copyright 2018 The Prometheus Authors
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Needs to be defined before including Makefile.common to auto-generate targets
DOCKER_ARCHS      ?= amd64 arm64
DOCKER_REPO       ?= ghcr.io/appscode-images
DOCKER_IMAGE_NAME ?= pgpool2_exporter
DOCKER_IMAGE_TAG  ?= $(shell git describe --exact-match --abbrev=0 2>/dev/null || git rev-parse --abbrev-ref HEAD)

include Makefile.common

.PHONY: tarball
tarball: common-tarball

.PHONY: docker
docker: common-docker

.PHONY: docker-publish
docker-publish: common-docker-publish

.PHONY: docker-manifest
docker-manifest: common-docker-manifest

.PHONY: build
build: common-build

.PHONY: crossbuild
crossbuild: promu
	@echo ">> building cross-platform binaries"
	@$(PROMU) crossbuild

.PHONY: tarballs
tarballs: crossbuild
	@echo ">> building release tarballs"
	@$(PROMU) tarballs

.PHONY: release
release: crossbuild docker docker-publish docker-manifest
