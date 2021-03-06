FROM swift:5.2 as builder
WORKDIR /swiftdoc
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so* /build/lib
RUN make install prefix=/build

FROM ubuntu:18.04
RUN apt-get -qq update && apt-get install -y libatomic1 && rm -r /var/lib/apt/lists/*
COPY --from=builder /build/bin/swift-doc /usr/bin
COPY --from=builder /build/lib/* /usr/lib/
ENTRYPOINT ["swift-doc"]
CMD ["--help"]
