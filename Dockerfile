# Build Stage
FROM rust:1.80-slim-bullseye AS builder
USER 0:0
WORKDIR /home/rust/src

RUN USER=root cargo new --bin autumn
WORKDIR /home/rust/src/autumn
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN apt-get update && apt-get install -y libssl-dev pkg-config && cargo install --locked --path .

# Bundle Stage
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y ca-certificates ffmpeg
COPY --from=builder /usr/local/cargo/bin/autumn ./
EXPOSE 3000
ENV AUTUMN_HOST 0.0.0.0:3000
COPY Autumn.toml ./
CMD ["./autumn"]
