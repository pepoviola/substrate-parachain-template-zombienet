# This file is sourced from https://github.com/paritytech/polkadot/blob/master/scripts/ci/dockerfiles/polkadot/polkadot_builder.Dockerfile
FROM docker.io/paritytech/ci-linux:production as builder

WORKDIR /parachain-template
COPY . /parachain-template

RUN cargo build --locked --release

FROM --platform=linux/amd64 docker.io/library/ubuntu:20.04

# show backtraces
ENV RUST_BACKTRACE 1

# install tools and dependencies
RUN apt-get update && \
		DEBIAN_FRONTEND=noninteractive apt-get install -y \
				libssl1.1 \
				ca-certificates && \
# apt cleanup
		apt-get autoremove -y && \
		apt-get clean && \
		find /var/lib/apt/lists/ -type f -not -name lock -delete; \
# add user and link ~/.local/share/polkadot to /data
		useradd -m -u 1000 -U -s /bin/sh -d /polkadot polkadot && \
		mkdir -p /data /polkadot/.local/share && \
		chown -R polkadot:polkadot /data && \
		ln -s /data /polkadot/.local/share/polkadot


# add binary to docker image
COPY --from=builder \
    /parachain-template/target/release/parachain-template-node /usr/local/bin

USER polkadot

# check if executable works in this container
RUN /usr/local/bin/parachain-template-node --version

EXPOSE 30333 9933 9944 9615
VOLUME ["/polkadot"]

ENTRYPOINT ["/usr/local/bin/parachain-template-node"]
