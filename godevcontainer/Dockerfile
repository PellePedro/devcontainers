ARG BASE_IMAGE=pellepedro/basedevcontainer:alpine
ARG BASE
ARG BASEDEV_VERSION=v0.17.0
ARG ALPINE_VERSION=3.16
ARG GO_VERSION=1.19
ARG GOMODIFYTAGS_VERSION=v1.16.0
ARG GOPLAY_VERSION=v1.0.0
ARG GOTESTS_VERSION=v1.6.0
ARG DLV_VERSION=v1.9.1
ARG MOCKERY_VERSION=v2.14.0
ARG GOMOCK_VERSION=v1.6.0
ARG MOCKGEN_VERSION=v1.6.0
ARG GOPLS_VERSION=v0.9.4
ARG GOLANGCILINT_VERSION=v1.49.0
ARG IMPL_VERSION=v1.1.0
ARG GOPKGS_VERSION=v2.1.2
ARG KUBECTL_VERSION=v1.25.0
ARG STERN_VERSION=v1.21.0
ARG KUBECTX_VERSION=v0.9.4
ARG KUBENS_VERSION=v0.9.4
ARG HELM_VERSION=v3.9.3

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS go
FROM qmcgaw/binpot:gomodifytags-${GOMODIFYTAGS_VERSION} AS gomodifytags
FROM qmcgaw/binpot:goplay-${GOPLAY_VERSION} AS goplay
FROM qmcgaw/binpot:gotests-${GOTESTS_VERSION} AS gotests
FROM qmcgaw/binpot:dlv-${DLV_VERSION} AS dlv
FROM qmcgaw/binpot:mockery-${MOCKERY_VERSION} AS mockery
FROM qmcgaw/binpot:gomock-${GOMOCK_VERSION} AS gomock
FROM qmcgaw/binpot:mockgen-${MOCKGEN_VERSION} AS mockgen
#FROM qmcgaw/binpot:gopls-${GOPLS_VERSION} AS gopls
FROM qmcgaw/binpot:golangci-lint-${GOLANGCILINT_VERSION} AS golangci-lint
FROM qmcgaw/binpot:impl-${IMPL_VERSION} AS impl
FROM qmcgaw/binpot:gopkgs-${GOPKGS_VERSION} AS gopkgs
FROM qmcgaw/binpot:gopls-${GOPLS_VERSION} AS gopls
FROM qmcgaw/binpot:kubectl-${KUBECTL_VERSION} AS kubectl
FROM qmcgaw/binpot:stern-${STERN_VERSION} AS stern
FROM qmcgaw/binpot:kubectx-${KUBECTX_VERSION} AS kubectx
FROM qmcgaw/binpot:kubens-${KUBENS_VERSION} AS kubens
FROM qmcgaw/binpot:helm-${HELM_VERSION} AS helm

ENV GO_VERSION 1.19
ENV GO111MODULE on
ENV GOPATH /go
ENV GOBIN ${GOPATH}/bin
ENV GOFLAGS "-ldflags=-w -ldflags=-s"
ENV LANG en_US.UTF-8

FROM go AS go-base
RUN  apk add upx

FROM go-base AS gofumpt
RUN GO111MODULE=on go install  \
  --ldflags "-s -w" --trimpath \
  mvdan.cc/gofumpt@latest \
  && upx -9 /go/bin/gofumpt

FROM go-base AS goimports
RUN GO111MODULE=on go install  \
  --ldflags "-s -w" --trimpath \
  golang.org/x/tools/cmd/goimports@latest \
  && upx -9 /go/bin/goimports

# FROM go-base AS misspell
# RUN GO111MODULE=on go install  \
#   --ldflags "-s -w" --trimpath \
#   github.com/client9/misspell/cmd/misspell@latest \
#   && upx -9 /go/bin/misspell

# FROM go-base AS gopls
# RUN GO111MODULE=on go install \
#   --ldflags "-s -w" --trimpath \
#   golang.org/x/tools/gopls@latest \
#   && upx -9 /go/bin/gopls
# FROM pellepedro/basedevcontainer:alpine

FROM $BASE_IMAGE
ARG CREATED
ARG COMMIT
ARG VERSION=local

COPY --from=go /usr/local/go /usr/local/go
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH \
  CGO_ENABLED=0 \
  GO111MODULE=on
#WORKDIR $GOPATH
# Install Alpine packages (g++ for race testing)
#RUN apk add -q --update --progress --no-cache g++
# Shell setup

COPY --from=gomodifytags /bin /go/bin/gomodifytags
COPY --from=goplay  /bin /go/bin/goplay
COPY --from=gotests /bin /go/bin/gotests
COPY --from=dlv /bin /go/bin/dlv
COPY --from=mockery /bin /go/bin/mockery
COPY --from=gomock /bin /go/bin/gomock
COPY --from=mockgen /bin /go/bin/mockgen
COPY --from=golangci-lint /bin /go/bin/golangci-lint
COPY --from=impl /bin /go/bin/impl
COPY --from=gopkgs /bin /go/bin/gopkgs

# Extra binary tools
COPY --from=kubectl /bin /usr/local/bin/kubectl
COPY --from=stern /bin /usr/local/bin/stern
COPY --from=kubectx /bin /usr/local/bin/kubectx
COPY --from=kubens /bin /usr/local/bin/kubens
COPY --from=helm /bin /usr/local/bin/helm
COPY --from=gofumpt /go/bin/gofumpt /go/bin/gofumpt
COPY --from=gopls /bin /go/bin/gopls
COPY --from=goimports /go/bin/goimports /go/bin/goimports
# COPY --from=misspell /go/bin/misspell /go/bin/misspell

RUN go install github.com/jesseduffield/lazygit@latest
