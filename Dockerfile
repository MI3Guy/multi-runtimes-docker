FROM debian:stretch-20190122-slim

RUN apt-get update && apt-get install -y wget xz-utils

RUN mkdir runtimes

# Install OpenJDK
RUN cd runtimes && \
	wget -q https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz && \
	tar xf openjdk-11.0.2_linux-x64_bin.tar.gz && \
	rm openjdk-11.0.2_linux-x64_bin.tar.gz

ENV PATH "/runtimes/jdk-11.0.2/bin:${PATH}"

# Install SBT
RUN cd runtimes && \
	wget -q https://piccolo.link/sbt-1.2.8.tgz && \
	tar xf sbt-1.2.8.tgz && \
	rm sbt-1.2.8.tgz

ENV PATH "/runtimes/sbt/bin:${PATH}"

# Install .NET SDK
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1
RUN cd runtimes && \
	wget -q https://dot.net/v1/dotnet-install.sh && \
	mkdir dotnet-sdk && \
	bash dotnet-install.sh --install-dir dotnet-sdk --version 2.2.103 && \
	rm dotnet-install.sh
	
ENV PATH "/runtimes/dotnet-sdk:${PATH}"

# Install Node
RUN cd runtimes && \
	wget https://nodejs.org/dist/v11.8.0/node-v11.8.0-linux-x64.tar.xz && \
	tar xf node-v11.8.0-linux-x64.tar.xz && \
	rm node-v11.8.0-linux-x64.tar.xz

ENV PATH "/runtimes/node-v11.8.0-linux-x64/bin:${PATH}"
